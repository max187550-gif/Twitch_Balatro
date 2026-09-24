-- ============================================
-- CHANNEL.LUA — Панель канала стримера (rebuild v22)
-- ============================================

G.jokerstream_channel = G.jokerstream_channel or {
    subs = 0, total_received = 0, stream_time_total = 0,
    clips = {}, milestones = {},

    panel = { open = false, anim = 0 },
    active_tab = "account",
    tab_rects = {},

    karal_letter_open = false,
    karal_letter_anim = 0,
    karal_letter_text_progress = 0,
    karal_letter_particles = {},
    karal_button_rect = nil,

    settings_anim = 1,
    account_anim  = 1,
    tab_anim = 1,
    pending_tab = nil,
    tab_from = nil,

    avatar = nil, avatar_checked = false,

    palette_button_rect = nil, palette_swatch_rects = {},
    palette_menu_open = false, palette_menu_anim = 0,

    palette_picker_open = false,
    palette_picker_rects = {},

    clips_scroll = 0, clip_card_rects = {}, scrollbar_rect = nil,
    dragging_scrollbar = false, open_clip = nil,

    float_texts = {}, counter_flash = { subs = 0, received = 0, clips = 0 },
    _prev_subs = 0, _prev_received = 0, _prev_clips = 0,
    display_subs = nil, display_received = nil, display_clips = nil, display_time = nil,

    music_muted = false, saved_music_vol = nil,

    setting_rects = {},
    setting_ctrl_rects = {},
    setting_reset_rect = nil,
    setting_reset_all_rect = nil,

    chat_settings = {
        donations_enabled = true,
        drag_chat        = false,
        drag_chat_pos    = nil,
        chat_palette     = 1,
        chat_alpha       = 1.0,
        chat_font_size   = 18,
        chat_box_width   = 320,
        chat_font        = 1,
        chat_anim        = 2,
    },

    clip_loading = { active=false, clip_id=nil, timer=0, duration=0, angle=0 },
    clip_view = {
        active=false, clip=nil,
        comments_shown=0, comments_total=0, comment_timer=0,
        comments_scroll=0, playback_t=0, playback_duration=0,
        score_shown=0, finished=false,
    },
    _save_timer = 0,
}

local MOD_PATH         = "C:/Users/МАКСИМУШКА/AppData/Roaming/Balatro/Mods/Twitch Balatro"
local PALETTE_FILE     = MOD_PATH .. "/palette.txt"
local CHANNEL_FILE_NFS = MOD_PATH .. "/channel_save.txt"
local CHANNEL_FILE_LFS = "jokerstream_channel_save.txt"

local PANEL_W = 1350
local PANEL_H = 1050

-- ============================================
-- СВОЯ МУЗЫКА ПАНЕЛИ КАНАЛА
-- ============================================
G.jokerstream_panel_music = G.jokerstream_panel_music or nil
do
    if not G.jokerstream_panel_music then
        local paths = {
            "sounds/panel.ogg",
            "assets/sounds/panel.ogg",
            "resources/sounds/panel.ogg",
        }
        for _, p in ipairs(paths) do
            if love.filesystem.getInfo and love.filesystem.getInfo(p) then
                local ok, src = pcall(love.audio.newSource, p, "static")
                if ok and src then
                    src:setLooping(true)
                    src:setVolume(0.7)
                    G.jokerstream_panel_music = src
                    break
                end
            end
        end
    end
end

-- ============================================
-- ПАЛИТРЫ
-- ============================================
local function hsv_to_rgb(h, s, v)
    local i = math.floor(h * 6); local f = h * 6 - i
    local p = v * (1 - s); local q = v * (1 - f * s); local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then return { v, t, p } elseif i == 1 then return { q, v, p }
    elseif i == 2 then return { p, v, t } elseif i == 3 then return { p, q, v }
    elseif i == 4 then return { t, p, v } else return { v, p, q } end
end

local BASE_COLORS = {}
for hue_step = 0, 23 do
    local h = hue_step / 24
    table.insert(BASE_COLORS, hsv_to_rgb(h, 1.00, 1.00))
    table.insert(BASE_COLORS, hsv_to_rgb(h, 0.35, 0.95))
    table.insert(BASE_COLORS, hsv_to_rgb(h, 1.00, 0.55))
    table.insert(BASE_COLORS, hsv_to_rgb(h, 0.85, 0.32))
end

local function make_bg(c, mul) mul = mul or 0.12; return { c[1]*mul, c[2]*mul, c[3]*mul } end
local function make_title(c) return { math.min(c[1]+0.2,1), math.min(c[2]+0.2,1), math.min(c[3]+0.2,1) } end
local function make_dim(c) return { c[1]*0.7, c[2]*0.7, c[3]*0.7 } end

local function make_palette(c1)
    return { bg=make_bg(c1,0.12), accent=c1, title=make_title(c1), dim=make_dim(c1), type="single" }
end
local function make_palette_dual(c1, c2)
    return { bg={(c1[1]+c2[1])*0.08,(c1[2]+c2[2])*0.08,(c1[3]+c2[3])*0.08},
             accent=c1, accent2=c2, title=make_title(c1), dim=make_dim(c1), type="dual" }
end
local function make_palette_triple(c1, c2, c3)
    return { bg={(c1[1]+c2[1]+c3[1])*0.06,(c1[2]+c2[2]+c3[2])*0.06,(c1[3]+c2[3]+c3[3])*0.06},
             accent=c1, accent2=c2, accent3=c3, title=make_title(c1), dim=make_dim(c1), type="triple" }
end

G.jokerstream_channel_palettes = {}

table.insert(G.jokerstream_channel_palettes, {
    bg     = {0.02, 0.02, 0.02},
    accent = {0.20, 0.20, 0.20},
    title  = {0.95, 0.95, 0.95},
    dim    = {0.35, 0.35, 0.35},
    type   = "single",
    is_standard = true,
})

local color_cursor = 1
local function take_color()
    local c = BASE_COLORS[color_cursor]
    color_cursor = color_cursor + 1
    if color_cursor > #BASE_COLORS then color_cursor = 1 end
    return c
end

for _ = 1, 5 do
    table.insert(G.jokerstream_channel_palettes, make_palette(take_color()))
end

for _ = 1, 20 do
    table.insert(G.jokerstream_channel_palettes, make_palette(take_color()))
    table.insert(G.jokerstream_channel_palettes, make_palette(take_color()))
    local d1, d2 = take_color(), take_color()
    table.insert(G.jokerstream_channel_palettes, make_palette_dual(d1, d2))
    local t1a, t1b, t1c = take_color(), take_color(), take_color()
    table.insert(G.jokerstream_channel_palettes, make_palette_triple(t1a, t1b, t1c))
    local t2a, t2b, t2c = take_color(), take_color(), take_color()
    table.insert(G.jokerstream_channel_palettes, make_palette_triple(t2a, t2b, t2c))
end

for i, pal in ipairs(G.jokerstream_channel_palettes) do
    if pal.is_standard then
        pal.level_required = 0
    else
        pal.level_required = math.floor((i - 2) / 5)
    end
end

-- ============================================
-- СОХРАНЕНИЕ / ЗАГРУЗКА ПАЛИТРЫ
-- ============================================
local function jokerstream_save_palette_file(idx)
    if not G.jokerstream_config then G.jokerstream_config = {} end
    G.jokerstream_config.channel_palette = idx
    if NFS then pcall(function() NFS.write(PALETTE_FILE, tostring(idx)) end) end
    if love.filesystem then pcall(function() love.filesystem.write("palette.txt", tostring(idx)) end) end
end

local function jokerstream_load_palette_file()
    local idx = nil
    if NFS then
        local ok, data = pcall(function() return NFS.read(PALETTE_FILE) end)
        if ok and data and data ~= "" then idx = tonumber(data) end
    end
    if not idx then
        local ok, data = pcall(function() return love.filesystem.read("palette.txt") end)
        if ok and data and data ~= "" then idx = tonumber(data) end
    end
    if not idx and G.jokerstream_config then idx = G.jokerstream_config.channel_palette end
    if not idx or idx < 1 or idx > #G.jokerstream_channel_palettes then idx = 1 end
    if not G.jokerstream_config then G.jokerstream_config = {} end
    G.jokerstream_config.channel_palette = idx
    return idx
end

local function jokerstream_get_palette()
    local idx = (G.jokerstream_config and G.jokerstream_config.channel_palette) or 1
    local pal = G.jokerstream_channel_palettes[idx] or G.jokerstream_channel_palettes[1]
    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    if pal.level_required and level < pal.level_required then
        return G.jokerstream_channel_palettes[1]
    end
    return pal
end

function G.jokerstream_get_chat_palette()
    local cs = G.jokerstream_channel.chat_settings
    local idx = cs.chat_palette or 1
    if idx < 1 or idx > #G.jokerstream_channel_palettes then idx = 1 end
    return G.jokerstream_channel_palettes[idx] or G.jokerstream_channel_palettes[1]
end

-- ============================================
-- МАЙЛСТОУНЫ
-- ============================================
G.jokerstream_milestones = {
    { subs=100,    id="m001", name="First Badge",       desc="+$1 per donation" },
    { subs=250,    id="m002", name="Small Channel",     desc="Chat palette" },
    { subs=500,    id="m003", name="Growing Channel",   desc="+$1 per donation" },
    { subs=750,    id="m004", name="Active Streamer",   desc="Drag chat" },
    { subs=1000,   id="m005", name="Thousand Club",     desc="Challenges unlocked" },
    { subs=1500,   id="m006", name="Stable Growth",     desc="Chat palette" },
    { subs=2000,   id="m007", name="Two Thousands",     desc="Chat transparency" },
    { subs=2500,   id="m008", name="VIP Status",        desc="Chat size" },
    { subs=3000,   id="m009", name="Advertiser",        desc="10% donation cashback" },
    { subs=4000,   id="m010", name="Big Channel",       desc="15% donation cashback" },
    { subs=5000,   id="m011", name="Five Thousands",    desc="Chat font" },
    { subs=7500,   id="m012", name="Popular",           desc="Chat animations" },
    { subs=10000,  id="m013", name="Twitch Partner",    desc="20% donation cashback" },
    { subs=15000,  id="m014", name="Big Raid chance",   desc="5% - MrBeast donates $25" },
    { subs=20000,  id="m015", name="Top Streamer",      desc="Top donator bonus every 2 min" },
    { subs=30000,  id="m016", name="Collab Events",     desc="1 in 5 - donation x2" },
    { subs=50000,  id="m017", name="Hustler",           desc="1 in 10 on discard - +$1" },
    { subs=75000,  id="m018", name="Legend",            desc="1 in 20 - $50 legendary donation" },
    { subs=100000, id="m019", name="Hundred Thousands", desc="Viewer growth x1.7" },
    { subs=250000, id="m020", name="Partner Forever",   desc="+$1 per 2000 viewers each ante" },
}

local descriptions = {
    "Small channel, big dreams. Balatro 24/7.",
    "Jokers are my life. Deck is my home.",
    "Never give up, even if the boss killed your whole deck.",
    "Streaming to pay rent. It's not working.",
    "Cards and suffering. That's the content.",
    "My channel is my fortress. Chat is my family.",
    "Every run is a story. Every loss is experience.",
    "Professional RNG beta tester.",
    "Streaming for fun, not for schedule.",
    "Want to be like Northernlion, but playing Balatro.",
    "Joker diff, hand diff, RNG diff — all here.",
    "Spinning jokers, breaking the meta.",
    "My viewers are the best. Even haters are cool.",
    "No bad runs here, only funny ones.",
    "A stream for those who understand.",
    "Every Friday — run to ante 8. Or not to 8.",
    "I built naneinf once. Once.",
    "My chat is smarter than me. Fact.",
    "Writing a mod, playing a mod, living a mod.",
    "Welcome. It's fun here. Usually.",
}

local function jokerstream_channel_get_description()
    if not G.jokerstream_config then G.jokerstream_config = {} end
    local cfg = G.jokerstream_config
    if cfg.channel_description and cfg.channel_description ~= "" then return cfg.channel_description end
    local d = descriptions[math.random(1, #descriptions)]
    cfg.channel_description = d
    if SMODS and SMODS.save_mod_config and SMODS.current_mod then
        SMODS.save_mod_config(SMODS.current_mod)
    end
    return d
end

-- ============================================
-- API КАНАЛА
-- ============================================
function G.jokerstream_channel.add_subs(n)
    n = n or 1
    G.jokerstream_channel.subs = G.jokerstream_channel.subs + n
    G.jokerstream_channel_check_milestones()
    G.jokerstream_channel.save()
end

function G.jokerstream_channel.add_received(amount)
    G.jokerstream_channel.total_received = G.jokerstream_channel.total_received + amount
    G.jokerstream_channel.save()
end

function G.jokerstream_channel.add_clip(clip)
    table.insert(G.jokerstream_channel.clips, 1, clip)
    while #G.jokerstream_channel.clips > 50 do table.remove(G.jokerstream_channel.clips) end
    G.jokerstream_channel.save()
end

function G.jokerstream_channel_check_milestones()
    for _, m in ipairs(G.jokerstream_milestones) do
        if G.jokerstream_channel.subs >= m.subs
           and not G.jokerstream_channel.milestones[m.id] then
            G.jokerstream_channel.milestones[m.id] = true
        end
    end
    G.jokerstream_channel.save()
end

function G.jokerstream_channel.save()
    local ch = G.jokerstream_channel
    local lines = {
        "subs="             .. tostring(ch.subs or 0),
        "received="         .. tostring(ch.total_received or 0),
        "time="             .. tostring(ch.stream_time_total or 0),
        "display_subs="     .. tostring(ch.display_subs     or ch.subs or 0),
        "display_received=" .. tostring(ch.display_received or ch.total_received or 0),
        "display_clips="    .. tostring(ch.display_clips    or #(ch.clips or {})),
        "display_time="     .. tostring(ch.display_time     or ch.stream_time_total or 0),
    }
    for i = 1, math.min(20, #(ch.clips or {})) do
        local c = ch.clips[i]
        lines[#lines + 1] = "clip=" .. (c.title or "") .. "|" .. (c.kind or "") .. "|" .. (c.time or 0)
    end
    for id, v in pairs(ch.milestones or {}) do
        if v then lines[#lines + 1] = "milestone=" .. id end
    end
    local cs = ch.chat_settings
    lines[#lines + 1] = "cs_donations_enabled=" .. tostring(cs.donations_enabled ~= false and 1 or 0)
    lines[#lines + 1] = "cs_drag_chat="      .. tostring(cs.drag_chat and 1 or 0)
    lines[#lines + 1] = "cs_chat_palette="   .. tostring(cs.chat_palette or 1)
    lines[#lines + 1] = "cs_chat_alpha="     .. tostring(cs.chat_alpha or 1.0)
    lines[#lines + 1] = "cs_chat_font_size=" .. tostring(cs.chat_font_size or 18)
    lines[#lines + 1] = "cs_chat_box_width=" .. tostring(cs.chat_box_width or 320)
    lines[#lines + 1] = "cs_chat_font="      .. tostring(cs.chat_font or 1)
    lines[#lines + 1] = "cs_chat_anim="      .. tostring(cs.chat_anim or 2)
    if cs.drag_chat_pos then
        lines[#lines + 1] = "cs_drag_pos_x=" .. tostring(math.floor(cs.drag_chat_pos.x))
        lines[#lines + 1] = "cs_drag_pos_y=" .. tostring(math.floor(cs.drag_chat_pos.y))
    end

    local content = table.concat(lines, "\n")
    if NFS then pcall(NFS.write, CHANNEL_FILE_NFS, content) end
    pcall(love.filesystem.write, CHANNEL_FILE_LFS, content)
end

function G.jokerstream_channel.load()
    local content
    if NFS then
        local ok, data = pcall(NFS.read, CHANNEL_FILE_NFS)
        if ok and data and data ~= "" then content = data end
    end
    if not content then
        local ok, data = pcall(love.filesystem.read, CHANNEL_FILE_LFS)
        if ok and data and data ~= "" then content = data end
    end
    local ch = G.jokerstream_channel
    if not content then
        ch.display_subs     = ch.subs
        ch.display_received = ch.total_received
        ch.display_clips    = #ch.clips
        ch.display_time     = ch.stream_time_total
        return
    end
    ch.clips = {}
    ch.milestones = {}
    local ls, lr, lc, lt
    local cs = ch.chat_settings
    local px, py
    for line in content:gmatch("[^\r\n]+") do
        local key, value = line:match("^([^=]+)=(.*)$")
        if key == "subs" then ch.subs = tonumber(value) or 0
        elseif key == "received" then ch.total_received = tonumber(value) or 0
        elseif key == "time" then ch.stream_time_total = tonumber(value) or 0
        elseif key == "display_subs" then ls = tonumber(value)
        elseif key == "display_received" then lr = tonumber(value)
        elseif key == "display_clips" then lc = tonumber(value)
        elseif key == "display_time" then lt = tonumber(value)
        elseif key == "clip" then
            local t, k, tm = value:match("^(.-)|(.-)|(.*)$")
            if t then table.insert(ch.clips, { title=t, kind=k, time=tonumber(tm) or 0 }) end
        elseif key == "milestone" then ch.milestones[value] = true
        elseif key == "cs_donations_enabled" then cs.donations_enabled = (value == "1")
        elseif key == "cs_drag_chat" then cs.drag_chat = (value == "1")
        elseif key == "cs_chat_palette" then cs.chat_palette = tonumber(value) or 1
        elseif key == "cs_chat_alpha" then cs.chat_alpha = tonumber(value) or 1.0
        elseif key == "cs_chat_font_size" then cs.chat_font_size = tonumber(value) or 18
        elseif key == "cs_chat_box_width" then cs.chat_box_width = tonumber(value) or 320
        elseif key == "cs_chat_font" then cs.chat_font = tonumber(value) or 1
        elseif key == "cs_chat_anim" then cs.chat_anim = tonumber(value) or 2
        elseif key == "cs_drag_pos_x" then px = tonumber(value)
        elseif key == "cs_drag_pos_y" then py = tonumber(value)
        end
    end
    if px and py then cs.drag_chat_pos = { x=px, y=py } end
    ch.display_subs     = ls or ch.subs
    ch.display_received = lr or ch.total_received
    ch.display_clips    = lc or #ch.clips
    ch.display_time     = lt or ch.stream_time_total
    ch._prev_subs       = ch.subs
    ch._prev_received   = ch.total_received
    ch._prev_clips      = #ch.clips
end

G.jokerstream_channel.load()
jokerstream_load_palette_file()

-- ============================================
-- ФОНТЫ ПАНЕЛИ
-- ============================================
local function jokerstream_channel_font(size)
    size = size or 20
    G.jokerstream_font_cache = G.jokerstream_font_cache or {}
    if G.jokerstream_font_cache[size] then return G.jokerstream_font_cache[size] end
    local candidates = {
        "resources/fonts/m6x11plus.ttf", "resources/fonts/m6x11.ttf",
        "resources/fonts/pixel.ttf", "assets/fonts/m6x11plus.ttf",
        "assets/fonts/font.ttf",
    }
    for _, path in ipairs(candidates) do
        local ok, font = pcall(love.graphics.newFont, path, size)
        if ok and font and font.getHeight then
            G.jokerstream_font_cache[size] = font; return font
        end
    end
    if G.FONTS then
        for _, f in pairs(G.FONTS) do
            if type(f) == "userdata" and f.getHeight then
                G.jokerstream_font_cache[size] = f; return f
            end
        end
    end
    local ok, font = pcall(love.graphics.newFont, size)
    if ok and font then G.jokerstream_font_cache[size] = font; return font end
    return nil
end

-- ============================================
-- СПИСОК ШРИФТОВ ЧАТА
-- ============================================
local CHAT_ANIM_NAMES = {
    "fade", "slide", "left", "pop", "zoom",
    "bounce", "drop", "glitch", "wave", "none",
}

local FONT_SIZE_OPTIONS = { 14, 16, 18, 20, 22 }
local BOX_WIDTH_OPTIONS = { 240, 280, 320, 360 }

local function build_chat_fonts_list()
    local list = {}
    local seen = {}

    local function try_add(name, rel_path, abs_path)
        if seen[name] then return end

        local ok, f = pcall(love.graphics.newFont, rel_path, 20)
        if ok and f and f.getHeight then
            table.insert(list, { name = name, path = rel_path })
            seen[name] = true
            print("[JOKER STREAM] font OK: " .. name .. " -> " .. rel_path)
            return
        end

        if NFS and abs_path then
            local ok2, bytes = pcall(NFS.read, abs_path)
            if ok2 and bytes and #bytes > 0 then
                local fd = love.filesystem.newFileData(bytes, name .. ".ttf")
                local ok3, f2 = pcall(love.graphics.newFont, fd, 20)
                if ok3 and f2 and f2.getHeight then
                    table.insert(list, { name = name, path = nil,
                                          abs_path = abs_path, from_nfs = true })
                    seen[name] = true
                    print("[JOKER STREAM] font OK (NFS): " .. name)
                    return
                end
            end
        end

        print("[JOKER STREAM] font NOT FOUND: " .. name .. " (" .. rel_path .. ")")
    end

    try_add("m6x11+", "resources/fonts/m6x11plus.ttf", nil)
    try_add("m6x11+", "assets/fonts/m6x11plus.ttf", nil)

    try_add("ARCADE",     "fonts/arcade.ttf",                 MOD_PATH .. "/fonts/arcade.ttf")
    try_add("deltarune",  "fonts/deltarune.ttf",              MOD_PATH .. "/fonts/deltarune.ttf")
    try_add("minecraft",  "fonts/minecraft.ttf",              MOD_PATH .. "/fonts/minecraft.ttf")
    try_add("cmd",        "fonts/windows_command_prompt.ttf", MOD_PATH .. "/fonts/windows_command_prompt.ttf")

    local base = {
        { "m6x11",          "resources/fonts/m6x11.ttf" },
        { "Noto",           "resources/fonts/NotoSans-Regular.ttf" },
        { "Noto Bold",      "resources/fonts/NotoSans-Bold.ttf" },
        { "Noto Italic",    "resources/fonts/NotoSans-Italic.ttf" },
        { "Noto BoldIt",    "resources/fonts/NotoSans-BoldItalic.ttf" },
        { "Mono",           "resources/fonts/NotoMono-Regular.ttf" },
        { "Mono Bold",      "resources/fonts/NotoMono-Bold.ttf" },
        { "Mono Italic",    "resources/fonts/NotoMono-Italic.ttf" },
        { "Mono BoldIt",    "resources/fonts/NotoMono-BoldItalic.ttf" },
        { "GoNoto",         "resources/fonts/GoNotoKurrent-Regular.ttf" },
        { "GoNoto Bold",    "resources/fonts/GoNotoKurrent-Bold.ttf" },
        { "GoNoto Italic",  "resources/fonts/GoNotoKurrent-Italic.ttf" },
        { "GoNoto BoldIt",  "resources/fonts/GoNotoKurrent-BoldItalic.ttf" },
    }
    for _, c in ipairs(base) do
        try_add(c[1], c[2], nil)
        try_add(c[1], (c[2]:gsub("^resources/", "assets/")), nil)
    end

    if NFS and NFS.getDirectoryItems then
        local ok, files = pcall(NFS.getDirectoryItems, MOD_PATH .. "/fonts")
        if ok and files then
            for _, fname in ipairs(files) do
                if fname:lower():match("%.ttf$") then
                    local display = fname:gsub("%.ttf$", "")
                    if not seen[display] then
                        try_add(display, "fonts/" .. fname, MOD_PATH .. "/fonts/" .. fname)
                    end
                end
            end
        end
    end

    table.insert(list, { name = "system", path = nil })

    print("[JOKER STREAM] total chat fonts loaded: " .. #list)
    return list
end

G._jokerstream_chat_fonts_list = G._jokerstream_chat_fonts_list or build_chat_fonts_list()

function G.jokerstream_chat_fonts_list()
    return G._jokerstream_chat_fonts_list
end

function G.jokerstream_get_chat_font(size, idx)
    local list = G.jokerstream_chat_fonts_list()
    idx = math.max(1, math.min(idx or 1, #list))
    local entry = list[idx]
    if not entry then
        local ok, f = pcall(love.graphics.newFont, size)
        return ok and f or nil
    end

    G.jokerstream_chat_font_cache = G.jokerstream_chat_font_cache or {}
    local key = tostring(size) .. "_" .. tostring(idx)
    if G.jokerstream_chat_font_cache[key] then
        return G.jokerstream_chat_font_cache[key]
    end

    local f
    if entry.from_nfs and entry.abs_path then
        local ok, bytes = pcall(NFS.read, entry.abs_path)
        if ok and bytes and #bytes > 0 then
            local fd = love.filesystem.newFileData(bytes, entry.name .. ".ttf")
            local ok2, font = pcall(love.graphics.newFont, fd, size)
            if ok2 and font then f = font end
        end
    elseif entry.path then
        local ok, font = pcall(love.graphics.newFont, entry.path, size)
        if ok and font then f = font end
    end

    if not f then
        local ok, font = pcall(love.graphics.newFont, size)
        if ok and font then f = font end
    end

    if f then G.jokerstream_chat_font_cache[key] = f end
    return f
end

-- ============================================
-- АВАТАР
-- ============================================
local function jokerstream_load_avatar()
    if G.jokerstream_channel.avatar ~= nil then return G.jokerstream_channel.avatar end
    if G.jokerstream_channel.avatar_checked then return nil end
    G.jokerstream_channel.avatar_checked = true
    local rel_paths = { "assets/icons/avatar.png", "assets/avatar.png", "avatar.png" }
    for _, p in ipairs(rel_paths) do
        if love.filesystem.getInfo and love.filesystem.getInfo(p) then
            local ok, img = pcall(love.graphics.newImage, p)
            if ok and img then G.jokerstream_channel.avatar = img; return img end
        end
    end
    if NFS then
        local abs = { MOD_PATH .. "/assets/icons/avatar.png", MOD_PATH .. "/assets/avatar.png" }
        for _, p in ipairs(abs) do
            local ok, bytes = pcall(NFS.read, p)
            if ok and bytes then
                local fd = love.filesystem.newFileData(bytes, "avatar.png")
                local ok2, img = pcall(love.graphics.newImage, fd)
                if ok2 and img then G.jokerstream_channel.avatar = img; return img end
            end
        end
    end
    return nil
end

-- ============================================
-- UTF-8 HELPERS
-- ============================================
local function utf8_char_count(s)
    local count = 0
    local i = 1
    local n = #s
    while i <= n do
        local b = s:byte(i)
        if b < 0x80 then i = i + 1
        elseif b < 0xC0 then i = i + 1
        elseif b < 0xE0 then i = i + 2
        elseif b < 0xF0 then i = i + 3
        else i = i + 4 end
        count = count + 1
    end
    return count
end

local function utf8_byte_index(s, n)
    if n <= 0 then return 0 end
    local count = 0
    local i = 1
    local len = #s
    while i <= len and count < n do
        local b = s:byte(i)
        if b < 0x80 then i = i + 1
        elseif b < 0xC0 then i = i + 1
        elseif b < 0xE0 then i = i + 2
        elseif b < 0xF0 then i = i + 3
        else i = i + 4 end
        count = count + 1
    end
    return math.min(i - 1, len)
end

-- ============================================
-- ФОРМАТ
-- ============================================
local function fmt_number(n)
    n = math.floor(n or 0)
    if n >= 1000000 then return string.format("%.1fM", n / 1000000) end
    if n >= 1000    then return string.format("%.1fK", n / 1000) end
    return tostring(n)
end
local function fmt_time(sec)
    sec = math.floor(sec or 0)
    local h = math.floor(sec / 3600); local m = math.floor((sec % 3600) / 60)
    if h > 0 then return h .. "h " .. m .. "m" end
    return m .. "m"
end

local function jokerstream_get_milestone_progress()
    local cur = G.jokerstream_channel.subs
    local prev = { subs=0, name="Start", desc="" }
    local nxt
    for _, m in ipairs(G.jokerstream_milestones) do
        if cur >= m.subs then prev = m else nxt = m; break end
    end
    local p = 1
    if nxt then
        local rng  = nxt.subs - prev.subs
        local done = cur - prev.subs
        p = math.max(0, math.min(1, done / rng))
    end
    return prev, nxt, p
end

-- ============================================
-- МУЗЫКА
-- ============================================
local function jokerstream_mute_music()
    if not G.SOUND_MANAGER or G.jokerstream_channel.music_muted then return end
    G.jokerstream_channel.saved_music_vol = G.SOUND_MANAGER.music_vol
    if G.SOUND_MANAGER.music_vol then G.SOUND_MANAGER.music_vol = 0 end
    if G.SOUND_MANAGER.cur_music and G.SOUND_MANAGER.cur_music.source then
        pcall(function() G.SOUND_MANAGER.cur_music.source:setVolume(0) end)
    end
    if G.jokerstream_panel_music then
        pcall(function()
            G.jokerstream_panel_music:setVolume(0.7)
            G.jokerstream_panel_music:play()
        end)
    end
    G.jokerstream_channel.music_muted = true
end

local function jokerstream_unmute_music()
    if not G.SOUND_MANAGER or not G.jokerstream_channel.music_muted then return end
    if G.jokerstream_panel_music then
        pcall(function() G.jokerstream_panel_music:stop() end)
    end
    if G.jokerstream_channel.saved_music_vol then
        G.SOUND_MANAGER.music_vol = G.jokerstream_channel.saved_music_vol
    end
    if G.SOUND_MANAGER.cur_music and G.SOUND_MANAGER.cur_music.source then
        local v = G.jokerstream_channel.saved_music_vol or 1
        pcall(function() G.SOUND_MANAGER.cur_music.source:setVolume(v) end)
    end
    G.jokerstream_channel.music_muted = false
end

-- ============================================
-- ФЛОАТЫ
-- ============================================
local function spawn_float(text, counter, color)
    table.insert(G.jokerstream_channel.float_texts, {
        text=text, counter=counter, color=color, timer=0, duration=1.5,
    })
end

local function check_counter_changes()
    local ch = G.jokerstream_channel
    local cur_clips = #ch.clips
    if ch._prev_subs and ch.subs > ch._prev_subs then
        spawn_float("+" .. (ch.subs - ch._prev_subs), "subs", { 0.4, 1.0, 0.5 })
        ch.counter_flash.subs = 0.5
    end
    if ch._prev_received and ch.total_received > ch._prev_received then
        spawn_float("+$" .. math.floor(ch.total_received - ch._prev_received), "received", { 1.0, 0.85, 0.3 })
        ch.counter_flash.received = 0.5
    end
    if ch._prev_clips and cur_clips > ch._prev_clips then
        spawn_float("+" .. (cur_clips - ch._prev_clips), "clips", { 0.6, 0.9, 1.0 })
        ch.counter_flash.clips = 0.5
    end
    ch._prev_subs     = ch.subs
    ch._prev_received = ch.total_received
    ch._prev_clips    = cur_clips
end

-- ============================================
-- КНОПКА В МЕНЮ
-- ============================================
local btn_cache = nil

function G.jokerstream_channel_draw_button()
    if not G.STATE or G.STATE ~= G.STATES.MENU then btn_cache = nil; return end
    local w = love.graphics.getWidth()
    local btn_w, btn_h = 220, 42
    local btn_x = w - btn_w - 15
    local btn_y = 15
    local mx, my = love.mouse.getPosition()
    local hover = mx >= btn_x and mx <= btn_x + btn_w and my >= btn_y and my <= btn_y + btn_h
    local pal = jokerstream_get_palette()
    if hover then love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 0.95)
    else love.graphics.setColor(pal.bg[1]+0.15, pal.bg[2]+0.10, pal.bg[3]+0.20, 0.95) end
    love.graphics.rectangle("fill", btn_x, btn_y, btn_w, btn_h, 8)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", btn_x, btn_y, btn_w, btn_h, 8)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
    local ff = jokerstream_channel_font(16); if ff then love.graphics.setFont(ff) end
    love.graphics.printf("YOUR ACCOUNT", btn_x, btn_y + 13, btn_w, "center")
    btn_cache = { x=btn_x, y=btn_y, w=btn_w, h=btn_h }
end

-- ============================================
-- ПАЛИТРА — КРУЖОК
-- ============================================
local function draw_palette_circle(pal, cx, cy, r)
    if pal.type == "triple" and pal.accent3 then
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.arc("fill", "pie", cx, cy, r, -math.pi/2, math.pi/6)
        love.graphics.setColor(pal.accent2[1], pal.accent2[2], pal.accent2[3], 1)
        love.graphics.arc("fill", "pie", cx, cy, r, math.pi/6, math.pi*5/6)
        love.graphics.setColor(pal.accent3[1], pal.accent3[2], pal.accent3[3], 1)
        love.graphics.arc("fill", "pie", cx, cy, r, math.pi*5/6, math.pi*3/2)
    elseif pal.type == "dual" and pal.accent2 then
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.arc("fill", "pie", cx, cy, r, math.pi/2, math.pi*3/2)
        love.graphics.setColor(pal.accent2[1], pal.accent2[2], pal.accent2[3], 1)
        love.graphics.arc("fill", "pie", cx, cy, r, -math.pi/2, math.pi/2)
    else
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.circle("fill", cx, cy, r)
    end
end

-- ============================================
-- НАСТРОЙКИ ЧАТА
-- ============================================
local CHAT_SETTINGS = {
    { id="donations_enabled", level=0,  name="DONATIONS",      desc="Enable or disable donations (disable to prevent money farming)", kind="toggle" },
    { id="drag_chat",         level=4,  name="DRAG CHAT",      desc="Move chat with mouse",     kind="toggle" },
    { id="chat_palette",      level=6,  name="CHAT PALETTE",   desc="Separate palette for chat",kind="picker" },
    { id="chat_alpha",        level=7,  name="CHAT OPACITY",   desc="Adjust chat transparency", kind="range", min=0.2, max=1.0, step=0.1 },
    { id="chat_size",         level=8,  name="CHAT SIZE",      desc="Font size + box width",    kind="size" },
    { id="chat_font",         level=11, name="CHAT FONT",      desc="Choose chat font",         kind="font" },
    { id="chat_anim",         level=12, name="CHAT ANIMATIONS",desc="Enable message animations",kind="anim" },
}

-- ============================================
-- КЛИПЫ
-- ============================================
local function jokerstream_start_clip_loading(clip_id)
    if not clip_id then return end
    local clips_list = (G.jokerstream_clips and G.jokerstream_clips.list) or {}
    local clip
    for _, c in ipairs(clips_list) do if c and c.id == clip_id then clip = c; break end end
    if not clip then return end
    local load = G.jokerstream_channel.clip_loading
    load.active=true; load.clip_id=clip_id; load.timer=0; load.angle=0
    local views = clip.views or 0
    local comments = (type(clip.comments)=="table") and #clip.comments or 0
    load.duration = 1.5 + views / 200 + comments / 15
    if load.duration < 2 then load.duration = 2 end
    if load.duration > 8 then load.duration = 8 end
end

local function jokerstream_finish_clip_loading()
    local load = G.jokerstream_channel.clip_loading
    if not load.active or not load.clip_id then load.active=false; return end
    local clips_list = (G.jokerstream_clips and G.jokerstream_clips.list) or {}
    local clip
    for _, c in ipairs(clips_list) do if c and c.id == load.clip_id then clip = c; break end end
    if not clip then load.active=false; load.clip_id=nil; return end
    local view = G.jokerstream_channel.clip_view
    view.active=true; view.clip=clip
    view.comments_shown=0
    view.comments_total=(type(clip.comments)=="table") and #clip.comments or 0
    view.comment_timer=0; view.comments_scroll=0
    view.playback_t=0; view.score_shown=0; view.finished=false
    local score = clip.score or 10000
    view.playback_duration = 3 + math.log10(score + 10) * 1.5
    if view.playback_duration < 4 then view.playback_duration = 4 end
    if view.playback_duration > 15 then view.playback_duration = 15 end
    G.jokerstream_channel.open_clip = load.clip_id
    load.active=false; load.clip_id=nil
end

local function jokerstream_close_clip_view()
    local view = G.jokerstream_channel.clip_view
    view.active=false; view.clip=nil
    view.comments_shown=0; view.comments_total=0
    view.comment_timer=0; view.comments_scroll=0
    view.playback_t=0; view.score_shown=0; view.finished=false
    G.jokerstream_channel.open_clip = nil
end

local function jokerstream_draw_card(x, y, w, h, rank, suit)
    love.graphics.setColor(0.95, 0.95, 0.95, 1)
    love.graphics.rectangle("fill", x, y, w, h, 4)
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.setLineWidth(2); love.graphics.rectangle("line", x, y, w, h, 4); love.graphics.setLineWidth(1)
    local rf = jokerstream_channel_font(math.floor(h * 0.25)); if rf then love.graphics.setFont(rf) end
    local sc = {0,0,0}; local sch = "?"
    if suit=="H" or suit=="h" or suit=="hearts" then sch="H"; sc={0.9,0.2,0.2}
    elseif suit=="D" or suit=="d" or suit=="diamonds" then sch="D"; sc={0.9,0.2,0.2}
    elseif suit=="C" or suit=="c" or suit=="clubs" then sch="C"; sc={0.1,0.1,0.1}
    elseif suit=="S" or suit=="s" or suit=="spades" then sch="S"; sc={0.1,0.1,0.1} end
    local rs = tostring(rank or "?")
    if rank == 11 then rs="J" elseif rank == 12 then rs="Q"
    elseif rank == 13 then rs="K" elseif rank == 14 or rank == 1 then rs="A" end
    love.graphics.setColor(sc[1], sc[2], sc[3], 1)
    local tw = rf and rf:getWidth(rs) or 10
    local sw = rf and rf:getWidth(sch) or 10
    love.graphics.print(rs, x + w/2 - tw/2, y + h/2 - h*0.2)
    love.graphics.print(sch, x + w/2 - sw/2, y + h/2 + h*0.05)
end

local function jokerstream_draw_loading(pal, screen_w, screen_h)
    local load = G.jokerstream_channel.clip_loading
    if not load or not load.active then return end
    love.graphics.setColor(0, 0, 0, 0.92)
    love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)
    local cx, cy = screen_w/2, screen_h/2
    local radius = 75; local ring_r = radius + 40
    love.graphics.setColor(pal.bg[1], pal.bg[2], pal.bg[3], 0.95)
    love.graphics.circle("fill", cx, cy, radius)
    local prog = 0
    if load.duration and load.duration > 0 then prog = math.min(load.timer / load.duration, 1.0) end
    load.angle = (load.angle or 0) + 0.03
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(8)
    love.graphics.arc("line", "open", cx, cy, radius - 4, load.angle, load.angle + math.pi*1.2)
    love.graphics.setLineWidth(1)
    local pf = jokerstream_channel_font(34); if pf then love.graphics.setFont(pf) end
    love.graphics.setColor(1,1,1,1)
    local pct = tostring(math.floor(prog*100)) .. "%"
    local tw = pf and pf:getWidth(pct) or 60
    love.graphics.print(pct, cx - tw/2, cy - 20)
    local text = "LOADING " .. math.floor(prog*100) .. "%"
    local tf = jokerstream_channel_font(18); if tf then love.graphics.setFont(tf) end
    local n = #text
    if n > 0 then
        local step = (math.pi*2)/n
        for i = 1, n do
            local ch = text:sub(i,i)
            local angle = -math.pi/2 + (i-1)*step + load.angle*0.3
            local wave = math.sin(load.timer*3 + i*0.5)*4
            local tx = cx + math.cos(angle)*(ring_r + wave)
            local ty = cy + math.sin(angle)*(ring_r + wave)
            love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
            local cw = tf:getWidth(ch)
            love.graphics.print(ch, tx - cw/2, ty - 10)
        end
    end
    local sf = jokerstream_channel_font(20); if sf then love.graphics.setFont(sf) end
    love.graphics.setColor(0.8,0.8,0.8,1)
    local sub = "CONNECTING TO SERVER..."
    local sw = sf and sf:getWidth(sub) or 300
    love.graphics.print(sub, cx - sw/2, cy + ring_r + 60)
end

local function jokerstream_draw_clip_view(pal, screen_w, screen_h, panel_x, panel_y, panel_w, panel_h)
    local view = G.jokerstream_channel.clip_view
    if not view.active or not view.clip then return end
    local clip = view.clip
    love.graphics.setColor(0,0,0,0.92)
    love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)
    local ow = panel_w - 100; local oh = panel_h - 150
    local ox = panel_x + 50; local oy = panel_y + 75
    love.graphics.setColor(pal.bg[1], pal.bg[2], pal.bg[3], 0.98)
    love.graphics.rectangle("fill", ox, oy, ow, oh, 20)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(3); love.graphics.rectangle("line", ox, oy, ow, oh, 20); love.graphics.setLineWidth(1)
    local tf = jokerstream_channel_font(28); if tf then love.graphics.setFont(tf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print(clip.title or "CLIP", ox + 25, oy + 20)
    local cx_x, cx_y = ox + ow - 50, oy + 15
    love.graphics.setColor(0.9,0.2,0.2,1); love.graphics.rectangle("fill", cx_x, cx_y, 36, 36, 8)
    love.graphics.setColor(1,1,1,1)
    local cxf = jokerstream_channel_font(24); if cxf then love.graphics.setFont(cxf) end
    love.graphics.print("X", cx_x + 10, cx_y + 3)
    local inf = jokerstream_channel_font(15); if inf then love.graphics.setFont(inf) end
    love.graphics.setColor(0.8,0.8,0.9,1)
    love.graphics.print("ANTE: " .. (clip.ante or 0) ..
        "  |  SCORE: " .. (clip.score or 0) ..
        "  |  HAND: " .. (clip.hand_name or "?") ..
        "  |  VIEWS: " .. (clip.views or 0) ..
        "  |  LIKES: " .. (clip.likes or 0) ..
        "  |  SUBS: +" .. (clip.subs_earned or 0), ox + 25, oy + 55)
    love.graphics.setColor(pal.dim[1], pal.dim[2], pal.dim[3], 0.6)
    love.graphics.rectangle("fill", ox + 20, oy + 80, ow - 40, 1)
    local vx, vy = ox + 30, oy + 95
    local vw = ow - 30 - 30 - 350
    local vh = oh - 130
    love.graphics.setColor(0.05,0.03,0.08,1); love.graphics.rectangle("fill", vx, vy, vw, vh, 12)
    love.graphics.setScissor(vx, vy, vw, vh)
    local prog = 0
    if view.playback_duration > 0 then prog = math.min(view.playback_t/view.playback_duration, 1.0) end
    view.score_shown = math.floor((clip.score or 0) * prog)
    local cards = clip.cards or {}
    local cw, chh = 70, 100; local gap = 15
    local total_w = #cards * (cw + gap)
    local sx = vw - prog*(vw + total_w) + 50
    for i, cs in ipairs(cards) do
        local rank, suit = cs:match("^([^|]+)|([^|]+)")
        local px = vx + sx + (i-1)*(cw+gap)
        local py = vy + vh/2 - chh/2
        if px + cw > vx and px < vx + vw then
            jokerstream_draw_card(px, py, cw, chh, tonumber(rank), suit)
        end
    end
    love.graphics.setScissor()
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(2); love.graphics.rectangle("line", vx, vy, vw, vh, 12); love.graphics.setLineWidth(1)
    local scf = jokerstream_channel_font(48); if scf then love.graphics.setFont(scf) end
    love.graphics.setColor(1, 0.9, 0.5, 1)
    local st = tostring(view.score_shown)
    local stw = scf and scf:getWidth(st) or 100
    love.graphics.print(st, vx + vw/2 - stw/2, vy + vh - 70)
    local pby = vy + vh + 8; local pbh = 8
    love.graphics.setColor(0.1,0.06,0.14,1); love.graphics.rectangle("fill", vx, pby, vw, pbh, pbh/2)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.rectangle("fill", vx, pby, vw*prog, pbh, pbh/2)
    local cmx = vx + vw + 30; local cmy = vy
    local cmw, cmh = 320, vh
    love.graphics.setColor(0.08,0.05,0.12,1); love.graphics.rectangle("fill", cmx, cmy, cmw, cmh, 12)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(2); love.graphics.rectangle("line", cmx, cmy, cmw, cmh, 12); love.graphics.setLineWidth(1)
    local hf = jokerstream_channel_font(20); if hf then love.graphics.setFont(hf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print("COMMENTS", cmx + 15, cmy + 10)
    love.graphics.setScissor(cmx, cmy + 40, cmw, cmh - 50)
    local all = clip.comments or {}
    local shown = math.min(view.comments_shown, #all)
    local lh = 28
    local off = view.comments_scroll
    local cf = jokerstream_channel_font(15)
    local nf = jokerstream_channel_font(15)
    for i = 1, shown do
        local c = all[i]
        if c then
            local cy = cmy + 50 + (i-1)*lh - off
            if cy > cmy and cy < cmy + cmh then
                if nf then love.graphics.setFont(nf) end
                local col = c.color or {1,1,1}
                love.graphics.setColor(col[1], col[2], col[3], 1)
                love.graphics.print(c.nick or "?", cmx + 15, cy)
                local nw = nf and nf:getWidth((c.nick or "?")..": ") or 50
                if cf then love.graphics.setFont(cf) end
                love.graphics.setColor(1,1,1,0.95)
                love.graphics.print(c.text or "...", cmx + 15 + nw, cy)
            end
        end
    end
    love.graphics.setScissor()
end

-- ============================================
-- МЕНЮ ПАЛИТРЫ КАНАЛА
-- ============================================
local function jokerstream_draw_palette_menu(pal, close_x, close_y)
    local current_idx = (G.jokerstream_config and G.jokerstream_config.channel_palette) or 1
    local current_pal = G.jokerstream_channel_palettes[current_idx] or G.jokerstream_channel_palettes[1]
    local pr = 16
    local pcx, pcy = close_x - 25 - pr, close_y + 18
    G.jokerstream_channel.palette_button_rect = {
        x = pcx - pr, y = pcy - pr, w = pr*2, h = pr*2,
    }
    local pulse = math.sin(love.timer.getTime()*2)*0.5 + 0.5
    local r = pr + pulse * 2
    draw_palette_circle(current_pal, pcx, pcy, r)
    love.graphics.setColor(1, 1, 1, 0.6 + pulse*0.4)
    love.graphics.setLineWidth(2); love.graphics.circle("line", pcx, pcy, r); love.graphics.setLineWidth(1)

    local target = G.jokerstream_channel.palette_menu_open and 1 or 0
    local cur = G.jokerstream_channel.palette_menu_anim or 0
    cur = cur + (target - cur) * 0.2
    if math.abs(cur - target) < 0.01 then cur = target end
    G.jokerstream_channel.palette_menu_anim = cur
    G.jokerstream_channel.palette_swatch_rects = {}

    if cur > 0.01 then
        local total = #G.jokerstream_channel_palettes
        local cols, ss, gap, pad = 12, 28, 6, 12
        local rows = math.ceil(total / cols)
        local mw = cols*ss + (cols-1)*gap + pad*2
        local mh = rows*ss + (rows-1)*gap + pad*2
        local mx = close_x - 25 - mw
        local my = close_y + 40
        local offy = (1 - cur) * -30
        local wave = math.sin(love.timer.getTime() * 1.5) * 6

        love.graphics.setColor(0.06,0.04,0.10,0.98*cur)
        love.graphics.rectangle("fill", mx, my + offy, mw, mh, 12)
        love.graphics.setColor(current_pal.accent[1], current_pal.accent[2], current_pal.accent[3], cur)
        love.graphics.setLineWidth(2); love.graphics.rectangle("line", mx, my + offy, mw, mh, 12); love.graphics.setLineWidth(1)
        local level = 0
        if G.jokerstream_get_level then level = G.jokerstream_get_level() end
        for i, pi in ipairs(G.jokerstream_channel_palettes) do
            local ci = (i-1) % cols
            local ri = math.floor((i-1)/cols)
            local sx = mx + pad + ci*(ss+gap)
            local sy = my + pad + ri*(ss+gap) + offy + wave
            G.jokerstream_channel.palette_swatch_rects[i] = { x=sx, y=sy, w=ss, h=ss }
            local locked = pi.level_required and level < pi.level_required
            if locked then
                love.graphics.setColor(0.15,0.15,0.15,cur)
                love.graphics.circle("fill", sx + ss/2, sy + ss/2, ss/2 - 2)
                love.graphics.setColor(0.4,0.4,0.4,cur)
                love.graphics.setLineWidth(1); love.graphics.circle("line", sx + ss/2, sy + ss/2, ss/2 - 2)
                local lf = jokerstream_channel_font(11); if lf then love.graphics.setFont(lf) end
                love.graphics.print("X", sx + ss/2 - 4, sy + ss/2 - 7)
            else
                love.graphics.setColor(1,1,1,cur)
                draw_palette_circle(pi, sx + ss/2, sy + ss/2, ss/2 - 2)
                if i == current_idx then
                    love.graphics.setColor(1,1,1,cur)
                    love.graphics.setLineWidth(2); love.graphics.circle("line", sx + ss/2, sy + ss/2, ss/2 - 1); love.graphics.setLineWidth(1)
                end
            end
        end
    end
end

-- ============================================
-- ТРЕУГОЛЬНИКИ
-- ============================================
local function draw_arrow_triangle(cx, cy, dir, size, color)
    love.graphics.setColor(color)
    if dir == "right" then
        love.graphics.polygon("fill", cx - size, cy - size, cx + size, cy, cx - size, cy + size)
    elseif dir == "left" then
        love.graphics.polygon("fill", cx + size, cy - size, cx - size, cy, cx + size, cy + size)
    elseif dir == "down" then
        love.graphics.polygon("fill", cx - size, cy - size/2, cx + size, cy - size/2, cx, cy + size/2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

-- ============================================
-- КОНТРОЛЫ
-- ============================================
local function draw_toggle(rect, value, accent)
    local on = value and true or false
    if on then love.graphics.setColor(0.20, 0.75, 0.35, 0.9)
    else love.graphics.setColor(0.18, 0.10, 0.22, 0.9) end
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, rect.h/2)
    love.graphics.setColor(accent[1], accent[2], accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h, rect.h/2)
    love.graphics.setLineWidth(1)
    local knob = rect.h - 8
    local kx = on and (rect.x + rect.w - knob - 4) or (rect.x + 4)
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill", kx + knob/2, rect.y + rect.h/2, knob/2)
    local lf = jokerstream_channel_font(18); if lf then love.graphics.setFont(lf) end
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(on and "ON" or "OFF", rect.x, rect.y + rect.h/2 - 10, rect.w, "center")
end

local function draw_stepper(rect, value_str, accent)
    local bw = rect.h
    love.graphics.setColor(0.15, 0.10, 0.20, 0.95)
    love.graphics.rectangle("fill", rect.x, rect.y, bw, rect.h, 8)
    love.graphics.rectangle("fill", rect.x + rect.w - bw, rect.y, bw, rect.h, 8)
    love.graphics.setColor(0.08, 0.05, 0.12, 0.95)
    love.graphics.rectangle("fill", rect.x + bw, rect.y, rect.w - 2*bw, rect.h)
    love.graphics.setColor(accent[1], accent[2], accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", rect.x, rect.y, bw, rect.h, 8)
    love.graphics.rectangle("line", rect.x + rect.w - bw, rect.y, bw, rect.h, 8)
    love.graphics.rectangle("line", rect.x + bw, rect.y, rect.w - 2*bw, rect.h)
    love.graphics.setLineWidth(1)

    local mid = rect.y + rect.h / 2
    draw_arrow_triangle(rect.x + bw/2, mid, "left",  7, { 1, 1, 1, 1 })
    draw_arrow_triangle(rect.x + rect.w - bw/2, mid, "right", 7, { 1, 1, 1, 1 })

    local vf = jokerstream_channel_font(20); if vf then love.graphics.setFont(vf) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(value_str, rect.x + bw, rect.y + rect.h/2 - 10, rect.w - 2*bw, "center")
end

local function draw_dropdown(rect, value_str, accent)
    love.graphics.setColor(0.15, 0.10, 0.20, 0.95)
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, 8)
    love.graphics.setColor(accent[1], accent[2], accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h, 8)
    love.graphics.setLineWidth(1)
    local f = jokerstream_channel_font(18); if f then love.graphics.setFont(f) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(value_str, rect.x + 12, rect.y + rect.h/2 - 11)
    draw_arrow_triangle(rect.x + rect.w - 18, rect.y + rect.h/2, "down", 7, { 1, 1, 1, 1 })
end

-- ============================================
-- ПРЕВЬЮ АНИМАЦИЙ
-- ============================================
local function draw_anim_preview(rect, anim_idx, accent, alpha)
    love.graphics.setScissor(rect.x, rect.y, rect.w, rect.h)
    love.graphics.setColor(0.05, 0.03, 0.08, 1)
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, 8)

    local t = love.timer.getTime()
    local cycle = (t * 0.7) % 1.6
    local anim = math.min(cycle / 0.5, 1.0)

    local eased = 1 - math.pow(1 - anim, 3)
    local alpha_mul = eased
    local off_x, off_y = 0, 0
    local scale_x, scale_y = 1.0, 1.0

    if anim_idx == 10 then
        anim = 1; alpha_mul = 1
    elseif anim_idx == 1 then
        alpha_mul = anim
    elseif anim_idx == 2 then
        off_x = (1 - eased) * 60
    elseif anim_idx == 3 then
        off_x = -(1 - eased) * 60
    elseif anim_idx == 4 then
        local s = 0.3 + eased * 0.7
        scale_x, scale_y = s, s
        alpha_mul = eased
    elseif anim_idx == 5 then
        local s = 1.4 - eased * 0.4
        scale_x, scale_y = s, s
        alpha_mul = eased
    elseif anim_idx == 6 then
        local c1 = 1.70158
        local c3 = c1 + 1
        local tt = anim - 1
        local e = 1 + c3 * math.pow(tt, 3) + c1 * math.pow(tt, 2)
        off_x = (1 - e) * 80
        alpha_mul = math.min(1, anim * 2)
    elseif anim_idx == 7 then
        off_y = -(1 - eased) * 40
        alpha_mul = eased
    elseif anim_idx == 8 then
        local g = math.sin(anim * 30) * (1 - anim) * 6
        off_x = g
        alpha_mul = anim > 0.5 and 1 or 0.7
    elseif anim_idx == 9 then
        off_y = math.sin(anim * math.pi * 3) * (1 - anim) * 12
        alpha_mul = eased
    end

    local cx_center = rect.x + rect.w / 2
    local cy_center = rect.y + rect.h / 2

    love.graphics.push()
    love.graphics.translate(cx_center + off_x, cy_center + off_y)
    love.graphics.scale(scale_x, scale_y)

    local f = jokerstream_channel_font(16)
    if f then love.graphics.setFont(f) end
    local txt1 = "pogmaster:"
    local txt1_w = f and f:getWidth(txt1) or 80
    love.graphics.setColor(0.9, 0.9, 0.9, 0.9 * alpha_mul * alpha)
    love.graphics.print(txt1, -txt1_w - 5, -8)
    love.graphics.setColor(1, 1, 1, 0.95 * alpha_mul * alpha)
    love.graphics.print("CLIP IT", 0, -8)
    love.graphics.pop()

    love.graphics.setScissor()
    love.graphics.setColor(accent[1], accent[2], accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h, 8)
    love.graphics.setLineWidth(1)
end

local function draw_font_preview(rect, font_idx, accent)
    love.graphics.setColor(0.05, 0.03, 0.08, 1)
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, 8)
    local f = G.jokerstream_get_chat_font and G.jokerstream_get_chat_font(20, font_idx) or nil
    if f then love.graphics.setFont(f) end
    love.graphics.setColor(1, 1, 1, 0.95)
    love.graphics.printf("Aa Bb Cc 123", rect.x, rect.y + rect.h/2 - 12, rect.w, "center")
    love.graphics.setColor(accent[1], accent[2], accent[3], 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h, 8)
    love.graphics.setLineWidth(1)
end

-- ============================================
-- ХЕЛПЕР АЛЬФЫ
-- ============================================
local function with_alpha(coeff, fn)
    if coeff >= 0.999 then
        fn()
        return
    end
    local real_setcolor = love.graphics.setColor
    love.graphics.setColor = function(...)
        local n = select("#", ...)
        if n == 0 then
            real_setcolor()
        elseif n == 1 then
            local t = ...
            real_setcolor(t[1], t[2], t[3], (t[4] or 1) * coeff)
        elseif n == 3 then
            local r, g, b = ...
            real_setcolor(r, g, b, coeff)
        else
            local r, g, b, a = ...
            real_setcolor(r, g, b, (a or 1) * coeff)
        end
    end
    fn()
    love.graphics.setColor = real_setcolor
end

-- ============================================
-- KARAL LETTER — частицы
-- ============================================
local function spawn_karal_particles()
    local ch = G.jokerstream_channel
    ch.karal_letter_particles = {}
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local count = 55

    for i = 1, count do
        local t = math.random()
        local col
        if t < 0.4 then
            col = {0.75, 0.40, 1.00}
        elseif t < 0.75 then
            col = {1.00, 0.55, 0.85}
        else
            col = {0.55, 0.75, 1.00}
        end

        table.insert(ch.karal_letter_particles, {
            x = math.random(0, w),
            y = math.random(0, h),
            vx = (math.random() - 0.5) * 12,
            vy = -8 - math.random() * 18,
            size = 1.5 + math.random() * 2.5,
            alpha = 0.3 + math.random() * 0.5,
            phase = math.random() * math.pi * 2,
            speed_phase = 1.5 + math.random() * 2,
            color = col,
        })
    end
end

local function update_karal_particles(dt)
    local ch = G.jokerstream_channel
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    for _, p in ipairs(ch.karal_letter_particles) do
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt

        if p.y < -10 then
            p.y = h + 10
            p.x = math.random(0, w)
        end
        if p.x < -10 then p.x = w + 10 end
        if p.x > w + 10 then p.x = -10 end

        p.phase = p.phase + p.speed_phase * dt
    end
end

-- ============================================
-- KARAL LETTER — модальное окно
-- ============================================
local function draw_karal_letter(pal, screen_w, screen_h)
    local ch = G.jokerstream_channel

    local dt = love.timer.getDelta()
    if dt > 0.1 then dt = 0.1 end
    local speed = 8.0

    local target = ch.karal_letter_open and 1 or 0
    local cur = ch.karal_letter_anim or 0
    local diff = target - cur
    if math.abs(diff) < 0.001 then
        cur = target
    else
        cur = cur + diff * math.min(dt * speed, 1)
    end
    ch.karal_letter_anim = cur

    if cur < 0.005 then return end

    local eased = 1 - math.pow(1 - cur, 3)

    local scale
    if cur < 0.99 then
        local t = cur
        local c1 = 1.70158
        local c3 = c1 + 1
        local tt = t - 1
        local spring = 1 + c3 * math.pow(tt, 3) + c1 * math.pow(tt, 2)
        scale = 0.85 + (spring * 0.15)
    else
        scale = 1.0
    end

    local y_off = (1 - eased) * 50

    love.graphics.setColor(0, 0, 0, 0.75 * cur)
    love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)

    for i = 3, 1, -1 do
        local r = 500 * i / 3
        local a = 0.03 * cur * (4 - i)
        love.graphics.setColor(0.55, 0.30, 0.90, a)
        love.graphics.circle("fill", screen_w/2, screen_h/2, r)
    end

    local t = love.timer.getTime()
    for _, p in ipairs(ch.karal_letter_particles) do
        local twinkle = 0.5 + 0.5 * math.sin(t * p.speed_phase + p.phase)
        local alpha = p.alpha * twinkle * cur
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], alpha)
        love.graphics.circle("fill", p.x, p.y, p.size)

        love.graphics.setColor(p.color[1], p.color[2], p.color[3], alpha * 0.25)
        love.graphics.circle("fill", p.x, p.y, p.size * 3)
    end

    local bw, bh = 820, 620
    local bx = screen_w/2 - bw/2
    local by = screen_h/2 - bh/2

    love.graphics.push()
    love.graphics.translate(screen_w/2, screen_h/2 + y_off)
    love.graphics.scale(scale, scale)
    love.graphics.translate(-screen_w/2, -screen_h/2)

    love.graphics.setColor(0.10, 0.05, 0.16, 0.98 * eased)
    love.graphics.rectangle("fill", bx, by, bw, bh, 16)

    local pulse = 0.85 + 0.15 * math.sin(t * 2)
    love.graphics.setColor(0.75 * pulse, 0.40 * pulse, 1.00 * pulse, eased)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", bx, by, bw, bh, 16)
    love.graphics.setLineWidth(1)

    love.graphics.setColor(0.75, 0.40, 1.00, 0.06 * eased)
    love.graphics.rectangle("fill", bx + 3, by + 3, bw - 6, bh - 6, 14)

    local nf = jokerstream_channel_font(30)
    if nf then love.graphics.setFont(nf) end
    love.graphics.setColor(0.75, 0.40, 1.00, eased)
    love.graphics.print("karal:", bx + 35, by + 25)

    love.graphics.setColor(0.75, 0.40, 1.00, 0.3 * eased)
    love.graphics.rectangle("fill", bx + 30, by + 68, bw - 60, 1)

    local cx_x = bx + bw - 50
    local cx_y = by + 25
    love.graphics.setColor(0.9, 0.2, 0.2, eased)
    love.graphics.rectangle("fill", cx_x, cx_y, 36, 36, 8)
    love.graphics.setColor(1, 1, 1, eased)
    local cxf = jokerstream_channel_font(24)
    if cxf then love.graphics.setFont(cxf) end
    love.graphics.print("X", cx_x + 10, cx_y + 3)

    local tf = jokerstream_channel_font(18)
    if tf then love.graphics.setFont(tf) end

    local full_text = "Hi, player.\n\n" ..
        "It's me — karal. The one who wrote this mod at night while everyone else was asleep.\n\n" ..
        "This is my first mod. And honestly — it means a lot to me. I put into it everything I know, and even things I don't. Every joker, every chat line, every clip — it's my attempt to make Balatro a little more alive.\n\n" ..
        "I'm not asking for likes. Not asking for money. Not asking for subscriptions. I'm asking for one thing: if you liked it — tell someone about this mod. A friend. A girlfriend. A dog. A cat. Or just drop a link in a Discord chat.\n\n" ..
        "I want to understand: should I keep going? This mod is the core. The foundation. The first brick. If it lands — I'll build a whole world on top of it. If not — at least I'll know I tried.\n\n" ..
        "Thanks for reading.\n" ..
        "Play. And have fun.\n\n" ..
        "— karal"

    local chars_per_sec = 180
    local total_chars = utf8_char_count(full_text)

    ch.karal_letter_text_progress = math.min(
        (ch.karal_letter_text_progress or 0) + chars_per_sec * dt,
        total_chars
    )

    local shown_chars = math.floor(ch.karal_letter_text_progress)
    local byte_end = utf8_byte_index(full_text, shown_chars)
    local shown_text = full_text:sub(1, byte_end)

    love.graphics.setColor(0.95, 0.90, 1.0, eased)
    love.graphics.printf(shown_text, bx + 40, by + 90, bw - 80, "left")

    if shown_chars < total_chars then
        local line_y = by + 90
        local last_newline = shown_text:match(".*()\n") or 0
        local current_line = shown_text:sub(last_newline + 1)
        local line_count = select(2, shown_text:gsub("\n", ""))
        line_y = line_y + line_count * (tf and tf:getHeight() or 20)

        local cx_cursor = bx + 40 + (tf and tf:getWidth(current_line) or 0)
        local blink = (math.floor(t * 2) % 2 == 0) and 1.0 or 0.2
        love.graphics.setColor(0.75, 0.40, 1.00, blink * eased)
        love.graphics.rectangle("fill", cx_cursor + 1, line_y - 2, 2, 18)
    end

    love.graphics.pop()
end

-- ============================================
-- ВКЛАДКА SETTINGS
-- ============================================
local function draw_settings_tab(panel_x, panel_y, panel_w, pal)
    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    local list_x = panel_x + 60
    local list_y = panel_y + 200
    local list_w = panel_w - 120
    local row_h  = 90

    local ch = G.jokerstream_channel
    ch.setting_rects     = {}
    ch.setting_ctrl_rects = {}
    ch.setting_reset_rect = nil

    local cs = ch.chat_settings
    local base_t = ch.settings_anim or 1
    local row_delay = 0.08
    local row_dur   = 0.45

    for i, setting in ipairs(CHAT_SETTINGS) do
        local start_t = (i - 1) * row_delay
        local row_t = (base_t - start_t) / row_dur
        row_t = math.max(0, math.min(1, row_t))
        local eased = 1 - math.pow(1 - row_t, 3)
        local y_off = (1 - eased) * 110
        local row_alpha = eased

        local ry = list_y + (i - 1) * row_h
        local rect = { x=list_x, y=ry, w=list_w, h=row_h - 12, id=setting.id }
        table.insert(ch.setting_rects, rect)
        local unlocked = level >= setting.level

        if row_alpha > 0.01 then
            love.graphics.push()
            love.graphics.translate(0, y_off)

            with_alpha(row_alpha, function()
                if unlocked then
                    love.graphics.setColor(pal.bg[1]+0.15, pal.bg[2]+0.10, pal.bg[3]+0.20, 0.95)
                else
                    love.graphics.setColor(0.08, 0.05, 0.10, 0.95)
                end
                love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, 10)
                love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], unlocked and 1 or 0.3)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h, 10)
                love.graphics.setLineWidth(1)

                local nf = jokerstream_channel_font(22); if nf then love.graphics.setFont(nf) end
                love.graphics.setColor(1, 1, 1, unlocked and 1 or 0.4)
                love.graphics.print(setting.name, rect.x + 20, rect.y + 15)
                local df = jokerstream_channel_font(14); if df then love.graphics.setFont(df) end
                love.graphics.setColor(0.7, 0.7, 0.7, unlocked and 1 or 0.4)
                love.graphics.print(setting.desc, rect.x + 20, rect.y + 47)

                if not unlocked then
                    local lf = jokerstream_channel_font(16); if lf then love.graphics.setFont(lf) end
                    love.graphics.setColor(1, 0.4, 0.4, 1)
                    love.graphics.printf("Requires level " .. setting.level,
                        rect.x + rect.w - 260, rect.y + 30, 240, "right")
                else
                    local ctrl_h = 40
                    local ctrl_y = rect.y + (rect.h - ctrl_h) / 2

                    if setting.kind == "toggle" then
                        local ctrl = { id=setting.id, kind="toggle",
                                       x = rect.x + rect.w - 200 - 20, y = ctrl_y,
                                       w = 200, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrl)
                        draw_toggle(ctrl, cs[setting.id], pal.accent)

                        if setting.id == "drag_chat" and cs.drag_chat then
                            local rr = { id="drag_reset", kind="reset",
                                         x = ctrl.x - 130, y = ctrl_y, w = 110, h = ctrl_h }
                            table.insert(ch.setting_ctrl_rects, rr)
                            ch.setting_reset_rect = rr
                            love.graphics.setColor(0.35, 0.10, 0.15, 0.95)
                            love.graphics.rectangle("fill", rr.x, rr.y, rr.w, rr.h, 8)
                            love.graphics.setColor(1, 0.5, 0.5, 1)
                            love.graphics.setLineWidth(2)
                            love.graphics.rectangle("line", rr.x, rr.y, rr.w, rr.h, 8)
                            love.graphics.setLineWidth(1)
                            local rf = jokerstream_channel_font(16); if rf then love.graphics.setFont(rf) end
                            love.graphics.setColor(1, 1, 1, 1)
                            love.graphics.printf("RESET POS", rr.x, rr.y + 11, rr.w, "center")
                        end

                    elseif setting.kind == "picker" then
                        local ctrl = { id=setting.id, kind="picker",
                                       x = rect.x + rect.w - 200 - 20, y = ctrl_y,
                                       w = 200, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrl)
                        local cur = cs[setting.id] or 1
                        local pal_label = (cur == 1) and "Standard" or ("Palette #" .. cur)
                        draw_dropdown(ctrl, pal_label, pal.accent)
                        local cur_pal = G.jokerstream_channel_palettes[cur]
                        if cur_pal then
                            love.graphics.setColor(1, 1, 1, 1)
                            draw_palette_circle(cur_pal, ctrl.x - 30, ctrl.y + ctrl.h/2, 16)
                            love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
                            love.graphics.setLineWidth(2)
                            love.graphics.circle("line", ctrl.x - 30, ctrl.y + ctrl.h/2, 16)
                            love.graphics.setLineWidth(1)
                        end

                    elseif setting.kind == "range" then
                        local ctrl = { id=setting.id, kind="range",
                                       x = rect.x + rect.w - 200 - 20, y = ctrl_y,
                                       w = 200, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrl)
                        local val = cs[setting.id] or setting.min
                        local pct = math.floor((val + 0.001) * 100)
                        draw_stepper(ctrl, pct .. "%", pal.accent)

                    elseif setting.kind == "size" then
                        local sz_w = 200
                        local ctrl1 = { id="font_size_prev", kind="step_size_font",
                                        x = rect.x + rect.w - sz_w*2 - 30, y = ctrl_y,
                                        w = sz_w, h = ctrl_h }
                        local ctrl2 = { id="font_size_next", kind="step_size_font",
                                        x = ctrl1.x + sz_w + 10, y = ctrl_y,
                                        w = sz_w, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrl1)
                        table.insert(ch.setting_ctrl_rects, ctrl2)
                        local fs = cs.chat_font_size or 18
                        draw_stepper(ctrl1, "Font " .. fs, pal.accent)
                        local bw = cs.chat_box_width or 320
                        draw_stepper(ctrl2, "Width " .. bw, pal.accent)

                    elseif setting.kind == "font" then
                        local arrow_w = 40
                        local mid_w = 220
                        local total_w = arrow_w + mid_w + arrow_w
                        local base_x = rect.x + rect.w - total_w - 20
                        local ctrlL = { id="font_prev", kind="font_prev",
                                        x = base_x, y = ctrl_y, w = arrow_w, h = ctrl_h }
                        local ctrlM = { id="font_mid", kind="noop",
                                        x = base_x + arrow_w, y = ctrl_y, w = mid_w, h = ctrl_h }
                        local ctrlR = { id="font_next", kind="font_next",
                                        x = base_x + arrow_w + mid_w, y = ctrl_y, w = arrow_w, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrlL)
                        table.insert(ch.setting_ctrl_rects, ctrlM)
                        table.insert(ch.setting_ctrl_rects, ctrlR)

                        love.graphics.setColor(0.15, 0.10, 0.20, 0.95)
                        love.graphics.rectangle("fill", ctrlL.x, ctrlL.y, ctrlL.w, ctrlL.h, 8)
                        love.graphics.rectangle("fill", ctrlR.x, ctrlR.y, ctrlR.w, ctrlR.h, 8)
                        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
                        love.graphics.setLineWidth(2)
                        love.graphics.rectangle("line", ctrlL.x, ctrlL.y, ctrlL.w, ctrlL.h, 8)
                        love.graphics.rectangle("line", ctrlR.x, ctrlR.y, ctrlR.w, ctrlR.h, 8)
                        love.graphics.setLineWidth(1)

                        draw_arrow_triangle(ctrlL.x + ctrlL.w/2, ctrlL.y + ctrlL.h/2, "left",  8, { 1, 1, 1, 1 })
                        draw_arrow_triangle(ctrlR.x + ctrlR.w/2, ctrlR.y + ctrlR.h/2, "right", 8, { 1, 1, 1, 1 })

                        local fi = cs.chat_font or 1
                        draw_font_preview(ctrlM, fi, pal.accent)
                        local fonts_list = G.jokerstream_chat_fonts_list()
                        local fname = fonts_list[fi] and fonts_list[fi].name or "?"
                        local lf = jokerstream_channel_font(14); if lf then love.graphics.setFont(lf) end
                        love.graphics.setColor(0.9, 0.9, 0.9, 1)
                        love.graphics.printf(fname, ctrlM.x, ctrlM.y - 20, ctrlM.w, "center")

                    elseif setting.kind == "anim" then
                        local arrow_w = 40
                        local mid_w = 220
                        local total_w = arrow_w + mid_w + arrow_w
                        local base_x = rect.x + rect.w - total_w - 20
                        local ctrlL = { id="anim_prev", kind="anim_prev",
                                        x = base_x, y = ctrl_y, w = arrow_w, h = ctrl_h }
                        local ctrlM = { id="anim_mid", kind="noop",
                                        x = base_x + arrow_w, y = ctrl_y, w = mid_w, h = ctrl_h }
                        local ctrlR = { id="anim_next", kind="anim_next",
                                        x = base_x + arrow_w + mid_w, y = ctrl_y, w = arrow_w, h = ctrl_h }
                        table.insert(ch.setting_ctrl_rects, ctrlL)
                        table.insert(ch.setting_ctrl_rects, ctrlM)
                        table.insert(ch.setting_ctrl_rects, ctrlR)

                        love.graphics.setColor(0.15, 0.10, 0.20, 0.95)
                        love.graphics.rectangle("fill", ctrlL.x, ctrlL.y, ctrlL.w, ctrlL.h, 8)
                        love.graphics.rectangle("fill", ctrlR.x, ctrlR.y, ctrlR.w, ctrlR.h, 8)
                        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
                        love.graphics.setLineWidth(2)
                        love.graphics.rectangle("line", ctrlL.x, ctrlL.y, ctrlL.w, ctrlL.h, 8)
                        love.graphics.rectangle("line", ctrlR.x, ctrlR.y, ctrlR.w, ctrlR.h, 8)
                        love.graphics.setLineWidth(1)

                        draw_arrow_triangle(ctrlL.x + ctrlL.w/2, ctrlL.y + ctrlL.h/2, "left",  8, { 1, 1, 1, 1 })
                        draw_arrow_triangle(ctrlR.x + ctrlR.w/2, ctrlR.y + ctrlR.h/2, "right", 8, { 1, 1, 1, 1 })

                        local ai = cs.chat_anim or 2
                        draw_anim_preview(ctrlM, ai, pal.accent, 1)
                        local lf = jokerstream_channel_font(14); if lf then love.graphics.setFont(lf) end
                        love.graphics.setColor(0.9, 0.9, 0.9, 1)
                        love.graphics.printf(CHAT_ANIM_NAMES[ai] or "?", ctrlM.x, ctrlM.y - 20, ctrlM.w, "center")
                    end
                end
            end)

            love.graphics.pop()
        end
    end

    local rb_w, rb_h = 360, 44
    local rb_x = panel_x + (panel_w - rb_w) / 2
    local rb_y = list_y + #CHAT_SETTINGS * row_h + 20

    local rb_start_t = #CHAT_SETTINGS * row_delay
    local rb_t = (base_t - rb_start_t) / row_dur
    rb_t = math.max(0, math.min(1, rb_t))
    local rb_eased = 1 - math.pow(1 - rb_t, 3)
    local rb_y_off = (1 - rb_eased) * 110
    local rb_alpha = rb_eased

    if rb_alpha > 0.01 then
        love.graphics.push()
        love.graphics.translate(0, rb_y_off)

        with_alpha(rb_alpha, function()
            ch.setting_reset_all_rect = { x = rb_x, y = rb_y, w = rb_w, h = rb_h }
            local mx, my = love.mouse.getPosition()
            local rhover = mx >= rb_x and mx <= rb_x + rb_w and my >= rb_y and my <= rb_y + rb_h
            if rhover then
                love.graphics.setColor(0.65, 0.10, 0.15, 0.95)
            else
                love.graphics.setColor(0.35, 0.08, 0.12, 0.95)
            end
            love.graphics.rectangle("fill", rb_x, rb_y, rb_w, rb_h, 10)
            love.graphics.setColor(1, 0.45, 0.45, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", rb_x, rb_y, rb_w, rb_h, 10)
            love.graphics.setLineWidth(1)
            local rbf = jokerstream_channel_font(18)
            if rbf then love.graphics.setFont(rbf) end
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf("RESET ALL SETTINGS", rb_x, rb_y + 12, rb_w, "center")
        end)

        love.graphics.pop()
    end
end

-- ============================================
-- ВКЛАДКА ACCOUNT
-- ============================================
local function draw_account_tab(panel_x, panel_y, panel_w, pal)
    local ch = G.jokerstream_channel
    local a_anim = ch.account_anim or 1
    local eased  = 1 - math.pow(1 - a_anim, 3)
    local y_off  = (1 - eased) * 100
    local a_alpha = eased
    if a_alpha < 0.01 then return end

    love.graphics.push()
    love.graphics.translate(0, y_off)

    with_alpha(a_alpha, function()

    local ax, ay, asz = panel_x + 40, panel_y + 190, 220
    love.graphics.setColor(0.10, 0.06, 0.14, 0.9)
    love.graphics.rectangle("fill", ax, ay, asz, asz, 16)
    local av = jokerstream_load_avatar()
    if av then
        local iw, ih = av:getWidth(), av:getHeight()
        local sc = math.max(asz/iw, asz/ih)
        local dw, dh = iw*sc, ih*sc
        local dx = ax + (asz - dw)/2
        local dy = ay + (asz - dh)/2
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", ax, ay, asz, asz, 16, 16)
        end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(av, dx, dy, 0, sc, sc)
        love.graphics.setStencilTest()
    else
        local name = ""
        if G.jokerstream_account and G.jokerstream_account.account_name then
            name = G.jokerstream_account.account_name
        elseif G.jokerstream_config and G.jokerstream_config.account_name then
            name = G.jokerstream_config.account_name
        end
        local letter = "?"
        if name ~= "" then letter = name:sub(1,1):upper() end
        local bgf = jokerstream_channel_font(120); if bgf then love.graphics.setFont(bgf) end
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 0.35)
        local lw = bgf and bgf:getWidth(letter) or 0
        love.graphics.print(letter, ax + (asz - lw)/2, ay + (asz - 120)/2)
    end
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", ax, ay, asz, asz, 16)
    love.graphics.setLineWidth(1)

    local ix, iy = ax + asz + 35, ay + 30
    local account_name, real_name, stream_theme
    if G.jokerstream_account then
        account_name = G.jokerstream_account.account_name
        real_name = G.jokerstream_account.real_name
        stream_theme = G.jokerstream_account.stream_theme
    end
    if not account_name and G.jokerstream_config then
        account_name = G.jokerstream_config.account_name
        real_name = G.jokerstream_config.real_name
        stream_theme = G.jokerstream_config.stream_theme
    end

    local current_ms = { subs = 0, name = "No Rank", desc = "" }
    local cur_subs = G.jokerstream_channel.subs or 0
    for _, m in ipairs(G.jokerstream_milestones or {}) do
        if cur_subs >= m.subs then
            current_ms = m
        else
            break
        end
    end

    local status_label = "[" .. tostring(current_ms.name) .. "]"
    local stf = jokerstream_channel_font(20)
    if stf then love.graphics.setFont(stf) end
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.print(status_label, ix, iy - 30)

    local lvf = jokerstream_channel_font(14)
    if lvf then love.graphics.setFont(lvf) end
    love.graphics.setColor(0.7, 0.7, 0.7, 0.9)
    local level_num = 0
    if G.jokerstream_get_level then level_num = G.jokerstream_get_level() end
    love.graphics.print("LVL " .. level_num .. " / 20", ix, iy - 8)

    local has_name = account_name and type(account_name) == "string"
                     and #account_name:gsub("%s","") > 0
    if has_name then
        local nf = jokerstream_channel_font(42); if nf then love.graphics.setFont(nf) end
        love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
        love.graphics.print("@" .. account_name, ix, iy + 20)
        if real_name and real_name ~= "" then
            local rf = jokerstream_channel_font(20); if rf then love.graphics.setFont(rf) end
            love.graphics.setColor(0.7, 0.6, 0.85, 1)
            love.graphics.print(real_name, ix, iy + 72)
        end
    else
        local nf = jokerstream_channel_font(40); if nf then love.graphics.setFont(nf) end
        love.graphics.setColor(1.0, 0.35, 0.35, 1)
        love.graphics.print("NOT REGISTERED", ix, iy + 20)
    end
    if stream_theme and stream_theme ~= "" then
        local sf = jokerstream_channel_font(22); if sf then love.graphics.setFont(sf) end
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.print("\"" .. stream_theme .. "\"", ix, iy + 115)
    end
    local desc = jokerstream_channel_get_description()
    local df = jokerstream_channel_font(18); if df then love.graphics.setFont(df) end
    love.graphics.setColor(0.75, 0.70, 0.85, 1)
    love.graphics.printf(desc, ix, iy + 155, panel_w - (ix - panel_x) - 40, "left")

    if ch.display_subs     == nil then ch.display_subs     = ch.subs end
    if ch.display_received == nil then ch.display_received = ch.total_received end
    if ch.display_clips    == nil then ch.display_clips    = #ch.clips end
    if ch.display_time     == nil then ch.display_time     = ch.stream_time_total end
    local counters = {
        { label="SUBS",     value=fmt_number(ch.display_subs),            key="subs" },
        { label="RECEIVED", value="$" .. fmt_number(ch.display_received), key="received" },
        { label="CLIPS",    value=fmt_number(ch.display_clips),           key="clips" },
        { label="TIME",     value=fmt_time(ch.display_time),              key="time" },
    }
    local cy = panel_y + 445
    local cw = (panel_w - 100)/4
    local chh = 120
    local cpos = {}
    local idle = love.timer.getTime()
    for i, c in ipairs(counters) do
        local cxx = panel_x + 40 + (i-1)*cw
        cpos[c.key] = { x=cxx, y=cy, w=cw-10, h=chh }
        local flash = ch.counter_flash[c.key] or 0
        local pulse = math.sin(idle*1.5 + i*1.2)*0.5 + 0.5
        local tscl = 1.0 + pulse*0.15
        local tbr  = 0.65 + pulse*0.35
        local br = 0.08 + pulse*0.18
        local bg = 0.05 + pulse*0.14
        local bb = 0.12 + pulse*0.20
        if flash > 0 then br = br + flash*0.4; bg = bg + flash*0.4; bb = bb + flash*0.4 end
        love.graphics.setColor(br, bg, bb, 0.9)
        love.graphics.rectangle("fill", cxx, cy, cw - 10, chh, 14)
        love.graphics.setColor(pal.dim[1], pal.dim[2], pal.dim[3], 0.3 + pulse*0.6)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", cxx, cy, cw - 10, chh, 14)
        local vf = jokerstream_channel_font(40); if vf then love.graphics.setFont(vf) end
        local cx_text = cxx + (cw-10)/2; local cy_text = cy + 46
        love.graphics.push()
        love.graphics.translate(cx_text, cy_text)
        love.graphics.scale(tscl, tscl)
        love.graphics.translate(-cx_text, -cy_text)
        love.graphics.setColor(1.0*tbr, 0.75*tbr, 1.0*tbr, 1)
        love.graphics.printf(c.value, cxx, cy + 26, cw - 10, "center")
        love.graphics.pop()
        local lf = jokerstream_channel_font(18); if lf then love.graphics.setFont(lf) end
        love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
        love.graphics.printf(c.label, cxx, cy + 80, cw - 10, "center")
    end
    for _, ft in ipairs(ch.float_texts) do
        local pos = cpos[ft.counter]
        if pos then
            local p2 = ft.timer / ft.duration
            local off = -p2 * 60
            local a = 1 - p2
            local cf = jokerstream_channel_font(28); if cf then love.graphics.setFont(cf) end
            love.graphics.setColor(ft.color[1], ft.color[2], ft.color[3], a)
            local tw = cf and cf:getWidth(ft.text) or 40
            love.graphics.print(ft.text, pos.x + pos.w/2 - tw/2, pos.y + 20 + off)
        end
    end

    love.graphics.setColor(pal.dim[1], pal.dim[2], pal.dim[3], 0.6)
    love.graphics.rectangle("fill", panel_x + 30, panel_y + 585, panel_w - 60, 1)
    local hf = jokerstream_channel_font(24); if hf then love.graphics.setFont(hf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print("CLIPS:", panel_x + 40, panel_y + 595)

    local clips_list = (G.jokerstream_clips and G.jokerstream_clips.list) or {}
    local clips_count = #clips_list
    local car_y = panel_y + 627
    local car_h = 220
    local card_w, card_h = 150, 210
    local gap = 15
    local car_x = panel_x + 40
    local car_w = panel_w - 80
    local ccf = jokerstream_channel_font(16); if ccf then love.graphics.setFont(ccf) end
    love.graphics.setColor(0.7, 0.6, 0.85, 1)
    love.graphics.print("Total: " .. clips_count .. "/10", car_x + car_w - 150, panel_y + 597)

    ch.clips_scroll = ch.clips_scroll or 0
    local scroll = ch.clips_scroll
    local total_w = clips_count * (card_w + gap)
    local max_scroll = math.max(0, total_w - car_w)
    ch.clip_card_rects = {}
    ch.scrollbar_rect = nil
    if clips_count == 0 then
        local ef = jokerstream_channel_font(18); if ef then love.graphics.setFont(ef) end
        love.graphics.setColor(0.5, 0.4, 0.6, 1)
        love.graphics.print("No clips yet. Play and create!", car_x + 20, car_y + 80)
    else
        for i, clip in ipairs(clips_list) do
            local cxx = car_x + (i-1)*(card_w+gap) - scroll
            local cyy = car_y
            if cxx + card_w > car_x and cxx < car_x + car_w then
                love.graphics.setScissor(car_x, car_y, car_w, car_h)
                local mx, my = love.mouse.getPosition()
                local hov = mx >= cxx and mx <= cxx + card_w and my >= cyy and my <= cyy + card_h
                if hov then love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 0.25)
                else love.graphics.setColor(0.10, 0.06, 0.14, 0.9) end
                love.graphics.rectangle("fill", cxx, cyy, card_w, card_h, 10)
                love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
                love.graphics.setLineWidth(hov and 3 or 2)
                love.graphics.rectangle("line", cxx, cyy, card_w, card_h, 10)
                love.graphics.setLineWidth(1)
                local tf2 = jokerstream_channel_font(48); if tf2 then love.graphics.setFont(tf2) end
                love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 0.8)
                local tt = "CLIP"
                if clip.type == "score_10k" then tt = "10K"
                elseif clip.type == "score_100k" then tt = "100K"
                elseif clip.type == "score_1m" then tt = "1M"
                elseif clip.type == "victory" then tt = "WIN" end
                local tw = tf2 and tf2:getWidth(tt) or 60
                love.graphics.print(tt, cxx + (card_w - tw)/2, cyy + 30)
                love.graphics.setColor(0.05, 0.03, 0.08, 1)
                love.graphics.rectangle("fill", cxx + 10, cyy + 90, card_w - 20, 50, 6)
                local pf2 = jokerstream_channel_font(14); if pf2 then love.graphics.setFont(pf2) end
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
                love.graphics.printf("click to open", cxx + 10, cyy + 105, card_w - 20, "center")
                local nf = jokerstream_channel_font(13); if nf then love.graphics.setFont(nf) end
                love.graphics.setColor(1, 0.95, 1, 1)
                local tt2 = clip.title or "Clip"
                if #tt2 > 16 then tt2 = tt2:sub(1,14) .. ".." end
                love.graphics.printf(tt2, cxx + 5, cyy + 150, card_w - 10, "center")
                local sf = jokerstream_channel_font(12); if sf then love.graphics.setFont(sf) end
                love.graphics.setColor(0.7, 0.8, 1.0, 1)
                love.graphics.printf("VIEWS " .. (clip.views or 0), cxx + 5, cyy + 172, card_w - 10, "center")
                love.graphics.setColor(1.0, 0.5, 0.7, 1)
                love.graphics.printf("LIKES " .. (clip.likes or 0), cxx + 5, cyy + 190, card_w - 10, "center")
                love.graphics.setScissor()
                table.insert(ch.clip_card_rects,
                    { x=cxx, y=cyy, w=card_w, h=card_h, id=clip.id })
            end
        end
    end

    local sb_y = car_y + car_h + 8
    local sb_h = 12
    local sb_x = car_x
    local sb_w = car_w
    love.graphics.setColor(0.10, 0.06, 0.14, 1)
    love.graphics.rectangle("fill", sb_x, sb_y, sb_w, sb_h, sb_h/2)
    if max_scroll > 0 then
        local thumb_w = math.max(40, sb_w * (car_w / total_w))
        local thumb_x = sb_x + (sb_w - thumb_w) * (scroll / max_scroll)
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.rectangle("fill", thumb_x, sb_y, thumb_w, sb_h, sb_h/2)
        ch.scrollbar_rect = { x=sb_x, y=sb_y, w=sb_w, h=sb_h,
                              thumb_w=thumb_w, max_scroll=max_scroll }
    end

    local pr_y = car_y + car_h + 60
    love.graphics.setColor(pal.dim[1], pal.dim[2], pal.dim[3], 0.6)
    love.graphics.rectangle("fill", panel_x + 30, pr_y - 5, panel_w - 60, 1)
    local mf = jokerstream_channel_font(28); if mf then love.graphics.setFont(mf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print("POPULARITY ROAD:", panel_x + 40, pr_y + 15)
    local cur_subs = G.jokerstream_channel.subs
    local cf = jokerstream_channel_font(26); if cf then love.graphics.setFont(cf) end
    love.graphics.setColor(1.0, 0.85, 1.0, 1)
    love.graphics.printf(fmt_number(cur_subs) .. " subs",
        panel_x + panel_w - 300, pr_y + 15, 260, "right")
    local _, nx, prog2 = jokerstream_get_milestone_progress()
    if nx then
        local nf2 = jokerstream_channel_font(20); if nf2 then love.graphics.setFont(nf2) end
        love.graphics.setColor(1, 0.9, 0.5, 1)
        love.graphics.print("Next: " .. nx.name .. " (" .. nx.subs .. " subs)  " .. nx.desc,
            panel_x + 40, pr_y + 55)
    else
        local nf2 = jokerstream_channel_font(22); if nf2 then love.graphics.setFont(nf2) end
        love.graphics.setColor(1, 0.9, 0.5, 1)
        love.graphics.print("ALL GOALS COMPLETED. YOU ARE A LEGEND.", panel_x + 40, pr_y + 55)
    end
    local bar_y = pr_y + 95
    local bar_x = panel_x + 50
    local bar_w = panel_w - 100
    local bar_h = 40
    local bar_r = bar_h/2
    love.graphics.setColor(0.08, 0.04, 0.12, 1)
    love.graphics.rectangle("fill", bar_x - 3, bar_y - 3, bar_w + 6, bar_h + 6, bar_r + 3)
    love.graphics.setColor(0.14, 0.08, 0.20, 1)
    love.graphics.rectangle("fill", bar_x, bar_y, bar_w, bar_h, bar_r)
    local fill_w = bar_w * prog2
    if fill_w > 0 then
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.rectangle("fill", bar_x, bar_y, fill_w, bar_h, bar_r)
    end
    local t2 = love.timer.getTime()
    for i, m in ipairs(G.jokerstream_milestones) do
        local dx = bar_x + (i-1)/(#G.jokerstream_milestones - 1)*bar_w
        local dy = bar_y + bar_h/2 + math.sin(t2*2 + i*0.7)*4
        local passed = cur_subs >= m.subs
        love.graphics.setColor(0, 0, 0, 0.5); love.graphics.circle("fill", dx, dy, 11)
        local r = passed and 11 or 9
        if passed then love.graphics.setColor(1, 0.95, 1.0, 1)
        else love.graphics.setColor(0.30, 0.20, 0.40, 1) end
        love.graphics.circle("fill", dx, dy, r)
        if passed then
            love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
            love.graphics.circle("fill", dx, dy, r - 4)
        end
    end
    local mkx = bar_x + fill_w
    local pulse = 0.5 + math.abs(math.sin(t2*2))*0.5
    local mkr = bar_h/2 + 5
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 0.35*pulse)
    love.graphics.circle("fill", mkx, bar_y + bar_h/2, mkr + 8)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", mkx, bar_y + bar_h/2, mkr - 2)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.circle("fill", mkx, bar_y + bar_h/2, mkr - 6)
    local pct_f = jokerstream_channel_font(20); if pct_f then love.graphics.setFont(pct_f) end
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.printf(math.floor(prog2*100) .. "%",
        panel_x + panel_w - 300, bar_y + bar_h + 12, 260, "right")

    end)

    love.graphics.pop()
end

-- ============================================
-- МОДАЛЬНЫЙ ВЫБОР ПАЛИТРЫ ДЛЯ ЧАТА
-- ============================================
local function draw_palette_picker(pal, screen_w, screen_h)
    local ch = G.jokerstream_channel
    if not ch.palette_picker_open then return end

    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)

    local total = #G.jokerstream_channel_palettes
    local cols, ss, gap, pad = 14, 40, 8, 20
    local rows = math.ceil(total / cols)
    local mw = cols*ss + (cols-1)*gap + pad*2
    local mh = rows*ss + (rows-1)*gap + pad*2 + 80
    local mx = screen_w/2 - mw/2
    local my = screen_h/2 - mh/2

    love.graphics.setColor(pal.bg[1]+0.05, pal.bg[2]+0.05, pal.bg[3]+0.05, 0.99)
    love.graphics.rectangle("fill", mx, my, mw, mh, 16)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", mx, my, mw, mh, 16)
    love.graphics.setLineWidth(1)

    local hf = jokerstream_channel_font(28); if hf then love.graphics.setFont(hf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print("CHAT PALETTE", mx + 25, my + 20)
    local sf = jokerstream_channel_font(16); if sf then love.graphics.setFont(sf) end
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.printf("click to select. right click / Esc to close.", mx + 25, my + 56, mw - 50, "left")

    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    local cur = ch.chat_settings.chat_palette or 1

    ch.palette_picker_rects = {}
    for i, pi in ipairs(G.jokerstream_channel_palettes) do
        local ci = (i-1) % cols
        local ri = math.floor((i-1) / cols)
        local sx = mx + pad + ci*(ss+gap)
        local sy = my + 90 + pad + ri*(ss+gap)
        ch.palette_picker_rects[i] = { x=sx, y=sy, w=ss, h=ss }
        local locked = pi.level_required and level < pi.level_required
        if locked then
            love.graphics.setColor(0.15, 0.15, 0.15, 1)
            love.graphics.circle("fill", sx + ss/2, sy + ss/2, ss/2 - 3)
            love.graphics.setColor(0.4, 0.4, 0.4, 1)
            love.graphics.setLineWidth(1); love.graphics.circle("line", sx + ss/2, sy + ss/2, ss/2 - 3)
            local lf = jokerstream_channel_font(12); if lf then love.graphics.setFont(lf) end
            love.graphics.print("X", sx + ss/2 - 5, sy + ss/2 - 8)
        else
            love.graphics.setColor(1, 1, 1, 1)
            draw_palette_circle(pi, sx + ss/2, sy + ss/2, ss/2 - 3)
            if i == cur then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setLineWidth(3)
                love.graphics.circle("line", sx + ss/2, sy + ss/2, ss/2 - 1)
                love.graphics.setLineWidth(1)
            end
        end
    end
end

-- ============================================
-- ГЛАВНАЯ ОТРИСОВКА
-- ============================================
function G.jokerstream_channel_draw_panel()
    local p = G.jokerstream_channel.panel
    if not p.open and p.anim <= 0.001 then return end
    local ch = G.jokerstream_channel
    local pal = jokerstream_get_palette()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local panel_w, panel_h = PANEL_W, PANEL_H
    local panel_x = w/2 - panel_w/2
    local target_y, hidden_y = 20, -panel_h - 30
    local eased = p.anim * p.anim * (3 - 2 * p.anim)
    local panel_y = hidden_y + (target_y - hidden_y) * eased

    love.graphics.setColor(0, 0, 0, 0.78 * eased)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(pal.bg[1], pal.bg[2], pal.bg[3], 0.98)
    love.graphics.rectangle("fill", panel_x, panel_y, panel_w, panel_h, 20)
    love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", panel_x, panel_y, panel_w, panel_h, 20)
    love.graphics.setLineWidth(1)

    local tf = jokerstream_channel_font(38); if tf then love.graphics.setFont(tf) end
    love.graphics.setColor(pal.title[1], pal.title[2], pal.title[3], 1)
    love.graphics.print("CHANNEL", panel_x + 35, panel_y + 25)

    local close_x = panel_x + panel_w - 55
    local close_y = panel_y + 28
    love.graphics.setColor(0.9, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", close_x, close_y, 36, 36, 8)
    love.graphics.setColor(1, 1, 1, 1)
    local cx = jokerstream_channel_font(24); if cx then love.graphics.setFont(cx) end
    love.graphics.print("X", close_x + 10, close_y + 3)

    local tab_w, tab_h = 200, 50
    local tab_y = panel_y + 90
    ch.tab_rects = {
        { x=panel_x + 40,                 y=tab_y, w=tab_w, h=tab_h, id="account" },
        { x=panel_x + 40 + tab_w + 10,    y=tab_y, w=tab_w, h=tab_h, id="settings" },
    }
    for _, tab in ipairs(ch.tab_rects) do
        local active = (ch.active_tab == tab.id)
        if active then love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        else love.graphics.setColor(pal.bg[1]+0.15, pal.bg[2]+0.10, pal.bg[3]+0.20, 0.95) end
        love.graphics.rectangle("fill", tab.x, tab.y, tab.w, tab.h, 10)
        love.graphics.setColor(pal.accent[1], pal.accent[2], pal.accent[3], 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", tab.x, tab.y, tab.w, tab.h, 10)
        love.graphics.setLineWidth(1)
        local label = (tab.id == "account") and "ACCOUNT" or "SETTINGS"
        local f = jokerstream_channel_font(20); if f then love.graphics.setFont(f) end
        love.graphics.setColor(1, 1, 1, 1)
        local lw = f and f:getWidth(label) or 100
        love.graphics.print(label, tab.x + (tab.w - lw)/2, tab.y + 12)
    end

    local kb_w, kb_h = 200, 50
    local kb_x = panel_x + 40 + tab_w + 10 + tab_w + 20
    local kb_y = tab_y
    ch.karal_button_rect = { x = kb_x, y = kb_y, w = kb_w, h = kb_h }

    local mx, my = love.mouse.getPosition()
    local hover = mx >= kb_x and mx <= kb_x + kb_w and my >= kb_y and my <= kb_y + kb_h

    if hover then
        love.graphics.setColor(0.75, 0.40, 1.00, 0.4)
    else
        love.graphics.setColor(0.75, 0.40, 1.00, 0.15)
    end
    love.graphics.rectangle("fill", kb_x, kb_y, kb_w, kb_h, 10)
    love.graphics.setColor(0.75, 0.40, 1.00, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", kb_x, kb_y, kb_w, kb_h, 10)
    love.graphics.setLineWidth(1)

    local kf = jokerstream_channel_font(18)
    if kf then love.graphics.setFont(kf) end
    love.graphics.setColor(0.95, 0.85, 1.0, 1)
    local ktext = "KARAL"
    local klw = kf and kf:getWidth(ktext) or 100
    love.graphics.print(ktext, kb_x + (kb_w - klw)/2, kb_y + 13)

    love.graphics.setColor(pal.dim[1], pal.dim[2], pal.dim[3], 0.6)
    love.graphics.rectangle("fill", panel_x + 30, panel_y + 160, panel_w - 60, 1)

    local content_x = panel_x + 30
    local content_y = panel_y + 170
    local content_w = panel_w - 60
    local content_h = panel_h - 190

    love.graphics.setScissor(content_x, content_y, content_w, content_h)

    if ch.pending_tab then
        local prog = ch.tab_anim
        local dir_sign = (ch.pending_tab == "settings") and -1 or 1
        local out_x =  prog * dir_sign * content_w
        local in_x  = -(1 - prog) * dir_sign * content_w

        love.graphics.push()
        love.graphics.translate(out_x, 0)
        if ch.tab_from == "account" then
            draw_account_tab(panel_x, panel_y, panel_w, pal)
        elseif ch.tab_from == "settings" then
            draw_settings_tab(panel_x, panel_y, panel_w, pal)
        end
        love.graphics.pop()

        love.graphics.push()
        love.graphics.translate(in_x, 0)
        if ch.pending_tab == "account" then
            draw_account_tab(panel_x, panel_y, panel_w, pal)
        elseif ch.pending_tab == "settings" then
            draw_settings_tab(panel_x, panel_y, panel_w, pal)
        end
        love.graphics.pop()
    else
        if ch.active_tab == "account" then
            draw_account_tab(panel_x, panel_y, panel_w, pal)
        elseif ch.active_tab == "settings" then
            draw_settings_tab(panel_x, panel_y, panel_w, pal)
        end
    end

    love.graphics.setScissor()

    jokerstream_draw_palette_menu(pal, close_x, close_y)
    jokerstream_draw_clip_view(pal, w, h, panel_x, panel_y, panel_w, panel_h)
    jokerstream_draw_loading(pal, w, h)
    draw_palette_picker(pal, w, h)
    draw_karal_letter(pal, w, h)
end

function G.jokerstream_channel_draw()
    G.jokerstream_channel_draw_button()
    G.jokerstream_channel_draw_panel()
end

-- ============================================
-- КЛИКИ
-- ============================================
function G.jokerstream_channel_mousepressed(x, y, button)
    local ch = G.jokerstream_channel

    if ch.karal_letter_open then
        if button == 1 then
            local w = love.graphics.getWidth()
            local h = love.graphics.getHeight()
            local bw, bh = 820, 620
            local bx = w/2 - bw/2
            local by = h/2 - bh/2

            local cx_x = bx + bw - 50
            local cx_y = by + 25
            if x >= cx_x and x <= cx_x + 36 and y >= cx_y and y <= cx_y + 36 then
                ch.karal_letter_open = false
                return true
            end

            if x < bx or x > bx + bw or y < by or y > by + bh then
                ch.karal_letter_open = false
                return true
            end

            return true
        end
        return true
    end

    local kb = ch.karal_button_rect
    if kb and ch.panel.open and button == 1 then
        if x >= kb.x and x <= kb.x + kb.w and y >= kb.y and y <= kb.y + kb.h then
            ch.karal_letter_open = true
            ch.karal_letter_text_progress = 0
            spawn_karal_particles()
            return true
        end
    end

    if ch.palette_picker_open then
        if button == 2 then
            ch.palette_picker_open = false
            return true
        end
        if button == 1 then
            local level = 0
            if G.jokerstream_get_level then level = G.jokerstream_get_level() end
            for i, rect in ipairs(ch.palette_picker_rects or {}) do
                if x >= rect.x and x <= rect.x + rect.w
                   and y >= rect.y and y <= rect.y + rect.h then
                    local pi = G.jokerstream_channel_palettes[i]
                    if pi.level_required and level < pi.level_required then return true end
                    ch.chat_settings.chat_palette = i
                    ch.save()
                    ch.palette_picker_open = false
                    return true
                end
            end
            ch.palette_picker_open = false
            return true
        end
    end

    if button ~= 1 then return false end
    local p = ch.panel

    if p.open then
        local w = love.graphics.getWidth()
        local panel_w, panel_h = PANEL_W, PANEL_H
        local panel_x = w/2 - panel_w/2
        local eased = p.anim * p.anim * (3 - 2 * p.anim)
        local panel_y = (-panel_h - 30) + (30 + panel_h + 30) * eased

        if ch.clip_loading.active then return true end

        if ch.clip_view.active then
            local ow = panel_w - 100; local oh = panel_h - 150
            local ox = panel_x + 50;  local oy = panel_y + 75
            local cx_x = ox + ow - 50; local cx_y = oy + 15
            if x >= cx_x and x <= cx_x + 36 and y >= cx_y and y <= cx_y + 36 then
                jokerstream_close_clip_view(); return true
            end
            if x < ox or x > ox + ow or y < oy or y > oy + oh then
                jokerstream_close_clip_view(); return true
            end
            return true
        end

        local close_x = panel_x + panel_w - 55
        local close_y = panel_y + 28
        if x >= close_x and x <= close_x + 36 and y >= close_y and y <= close_y + 36 then
            p.open = false
            ch.palette_menu_open = false
            ch.karal_letter_open = false
            jokerstream_unmute_music()
            return true
        end

        for _, tab in ipairs(ch.tab_rects) do
            if x >= tab.x and x <= tab.x + tab.w and y >= tab.y and y <= tab.y + tab.h then
                if tab.id ~= ch.active_tab and not ch.pending_tab then
                    ch.pending_tab = tab.id
                    ch.tab_from    = ch.active_tab
                    ch.tab_anim    = 0
                    if tab.id == "settings" then ch.settings_anim = 0 end
                    if tab.id == "account"  then ch.account_anim  = 0 end
                end
                return true
            end
        end

        if ch.pending_tab then return true end

        local br = ch.palette_button_rect
        if br and x >= br.x and x <= br.x + br.w and y >= br.y and y <= br.y + br.h then
            ch.palette_menu_open = not ch.palette_menu_open
            return true
        end

        if ch.palette_menu_open then
            local level = 0
            if G.jokerstream_get_level then level = G.jokerstream_get_level() end
            for i, rect in ipairs(ch.palette_swatch_rects) do
                if x >= rect.x and x <= rect.x + rect.w and y >= rect.y and y <= rect.y + rect.h then
                    local pi = G.jokerstream_channel_palettes[i]
                    if pi.level_required and level < pi.level_required then return true end
                    jokerstream_save_palette_file(i)
                    ch.palette_menu_open = false
                    return true
                end
            end
            ch.palette_menu_open = false
            return true
        end

        if ch.active_tab == "settings" then
            local level = 0
            if G.jokerstream_get_level then level = G.jokerstream_get_level() end
            local cs = ch.chat_settings

            local ra = ch.setting_reset_all_rect
            if ra and x >= ra.x and x <= ra.x + ra.w
               and y >= ra.y and y <= ra.y + ra.h then
                cs.donations_enabled = true
                cs.drag_chat = false
                cs.drag_chat_pos = nil
                cs.chat_palette = 1
                cs.chat_alpha = 1.0
                cs.chat_font_size = 18
                cs.chat_box_width = 320
                cs.chat_font = 1
                cs.chat_anim = 2
                ch.save()
                return true
            end

            for _, ctrl in ipairs(ch.setting_ctrl_rects or {}) do
                if x >= ctrl.x and x <= ctrl.x + ctrl.w
                   and y >= ctrl.y and y <= ctrl.y + ctrl.h then

                    if ctrl.kind == "reset" then
                        cs.drag_chat_pos = nil
                        ch.save()
                        return true
                    end

                    if ctrl.kind == "noop" then return true end

                    if ctrl.kind == "toggle" then
                        cs[ctrl.id] = not cs[ctrl.id]
                        ch.save()
                        return true
                    end

                    if ctrl.kind == "picker" then
                        ch.palette_picker_open = true
                        return true
                    end

                    if ctrl.kind == "range" then
                        local setting
                        for _, s in ipairs(CHAT_SETTINGS) do
                            if s.id == ctrl.id then setting = s; break end
                        end
                        if setting then
                            local cur = cs[ctrl.id] or setting.min
                            if x < ctrl.x + ctrl.w / 2 then
                                cur = math.max(setting.min, cur - setting.step)
                            else
                                cur = math.min(setting.max, cur + setting.step)
                            end
                            cur = math.floor(cur*100 + 0.5)/100
                            cs[ctrl.id] = cur
                            ch.save()
                        end
                        return true
                    end

                    if ctrl.kind == "step_size_font" then
                        if ctrl.id == "font_size_prev" then
                            local idx = 1
                            for j, v in ipairs(FONT_SIZE_OPTIONS) do
                                if v == (cs.chat_font_size or 18) then idx = j; break end
                            end
                            if x < ctrl.x + ctrl.w/2 then
                                idx = idx - 1
                                if idx < 1 then idx = #FONT_SIZE_OPTIONS end
                            else
                                idx = idx + 1
                                if idx > #FONT_SIZE_OPTIONS then idx = 1 end
                            end
                            cs.chat_font_size = FONT_SIZE_OPTIONS[idx]
                        else
                            local idx = 1
                            for j, v in ipairs(BOX_WIDTH_OPTIONS) do
                                if v == (cs.chat_box_width or 320) then idx = j; break end
                            end
                            if x < ctrl.x + ctrl.w/2 then
                                idx = idx - 1
                                if idx < 1 then idx = #BOX_WIDTH_OPTIONS end
                            else
                                idx = idx + 1
                                if idx > #BOX_WIDTH_OPTIONS then idx = 1 end
                            end
                            cs.chat_box_width = BOX_WIDTH_OPTIONS[idx]
                        end
                        ch.save()
                        return true
                    end

                    if ctrl.kind == "font_prev" then
                        local list = G.jokerstream_chat_fonts_list()
                        local fi = (cs.chat_font or 1) - 1
                        if fi < 1 then fi = #list end
                        cs.chat_font = fi
                        ch.save()
                        return true
                    end
                    if ctrl.kind == "font_next" then
                        local list = G.jokerstream_chat_fonts_list()
                        local fi = (cs.chat_font or 1) + 1
                        if fi > #list then fi = 1 end
                        cs.chat_font = fi
                        ch.save()
                        return true
                    end
                    if ctrl.kind == "anim_prev" then
                        local total = #CHAT_ANIM_NAMES
                        local ai = (cs.chat_anim or 2) - 1
                        if ai < 1 then ai = total end
                        cs.chat_anim = ai
                        ch.save()
                        return true
                    end
                    if ctrl.kind == "anim_next" then
                        local total = #CHAT_ANIM_NAMES
                        local ai = (cs.chat_anim or 2) + 1
                        if ai > total then ai = 1 end
                        cs.chat_anim = ai
                        ch.save()
                        return true
                    end
                end
            end
        end

        if ch.clip_card_rects then
            for _, r in ipairs(ch.clip_card_rects) do
                if x >= r.x and x <= r.x + r.w and y >= r.y and y <= r.y + r.h then
                    if G.jokerstream_clips and G.jokerstream_clips.view then
                        G.jokerstream_clips.view(r.id)
                    end
                    jokerstream_start_clip_loading(r.id)
                    return true
                end
            end
        end

        if ch.scrollbar_rect then
            local sb = ch.scrollbar_rect
            if x >= sb.x and x <= sb.x + sb.w and y >= sb.y and y <= sb.y + sb.h then
                ch.dragging_scrollbar = true
                local ratio = (x - sb.x) / sb.w
                ch.clips_scroll = ratio * sb.max_scroll
                return true
            end
        end

        if x < panel_x or x > panel_x + panel_w
           or y < panel_y or y > panel_y + panel_h then
            p.open = false
            ch.palette_menu_open = false
            jokerstream_unmute_music()
            return true
        end
        return true
    end

    if btn_cache and G.STATE == G.STATES.MENU then
        if x >= btn_cache.x and x <= btn_cache.x + btn_cache.w
           and y >= btn_cache.y and y <= btn_cache.y + btn_cache.h then
            p.open = true
            if ch.active_tab == "settings" then ch.settings_anim = 0 end
            if ch.active_tab == "account"  then ch.account_anim  = 0 end
            jokerstream_mute_music()
            return true
        end
    end
    return false
end

-- ============================================
-- UPDATE
-- ============================================
local original_game_update_channel = Game.update
function Game:update(dt)
    original_game_update_channel(self, dt)

    local ch = G.jokerstream_channel
    local p = ch.panel
    if p.open then
        p.anim = math.min(p.anim + dt / 0.75, 1)
    else
        p.anim = math.max(p.anim - dt / 0.75, 0)
        ch.palette_menu_open = false
        ch.palette_picker_open = false
        ch.karal_letter_open = false
    end

    if p.open and p.anim > 0.3 and not ch.music_muted then
        jokerstream_mute_music()
    elseif (not p.open or p.anim <= 0.3) and ch.music_muted then
        jokerstream_unmute_music()
    end

    if ch.pending_tab then
        ch.tab_anim = math.min(ch.tab_anim + dt / 0.35, 1)
        if ch.tab_anim >= 1 then
            ch.active_tab = ch.pending_tab
            ch.pending_tab = nil
            ch.tab_from    = nil
        end
    else
        if ch.tab_anim < 1 then ch.tab_anim = 1 end
        if ch.settings_anim == nil then ch.settings_anim = 1 end
        if ch.account_anim  == nil then ch.account_anim  = 1 end
        if p.open then
            if ch.active_tab == "settings" and ch.settings_anim < 1 then
                ch.settings_anim = math.min(ch.settings_anim + dt * 2.0, 1)
            end
            if ch.active_tab == "account" and ch.account_anim < 1 then
                ch.account_anim = math.min(ch.account_anim + dt * 2.0, 1)
            end
        end
    end

    if ch.karal_letter_open and ch.karal_letter_anim > 0.05 then
        update_karal_particles(dt)
    end

    check_counter_changes()

    if ch.display_subs     == nil then ch.display_subs     = ch.subs end
    if ch.display_received == nil then ch.display_received = ch.total_received end
    if ch.display_clips    == nil then ch.display_clips    = #ch.clips end
    if ch.display_time     == nil then ch.display_time     = ch.stream_time_total end

    local ls = math.min(dt * 2.5, 1)
    ch.display_subs     = ch.display_subs     + (ch.subs - ch.display_subs) * ls
    ch.display_received = ch.display_received + (ch.total_received - ch.display_received) * ls
    ch.display_clips    = ch.display_clips    + (#ch.clips - ch.display_clips) * ls
    ch.display_time     = ch.display_time     + (ch.stream_time_total - ch.display_time) * ls

    if math.abs(ch.display_subs - ch.subs) < 0.5 then ch.display_subs = ch.subs end
    if math.abs(ch.display_received - ch.total_received) < 0.5 then ch.display_received = ch.total_received end
    if math.abs(ch.display_clips - #ch.clips) < 0.1 then ch.display_clips = #ch.clips end
    if math.abs(ch.display_time - ch.stream_time_total) < 0.5 then ch.display_time = ch.stream_time_total end

    for k, v in pairs(ch.counter_flash) do
        if v > 0 then ch.counter_flash[k] = math.max(0, v - dt*2) end
    end
    for i = #ch.float_texts, 1, -1 do
        local ft = ch.float_texts[i]
        ft.timer = ft.timer + dt
        if ft.timer >= ft.duration then table.remove(ch.float_texts, i) end
    end

    local load = ch.clip_loading
    if load.active then
        load.timer = load.timer + dt
        if load.duration and load.timer >= load.duration then
            jokerstream_finish_clip_loading()
        end
    end

    local view = ch.clip_view
    if view.active then
        if not view.finished then
            view.playback_t = view.playback_t + dt
            if view.playback_t >= view.playback_duration then
                view.playback_t = view.playback_duration
                view.finished = true
            end
        end
        view.comment_timer = view.comment_timer + dt
        if view.comments_shown < view.comments_total then
            if view.comment_timer >= 0.3 then
                view.comment_timer = 0
                view.comments_shown = math.min(view.comments_shown + 10, view.comments_total)
            end
        end
    end

    if G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH then
        ch.stream_time_total = ch.stream_time_total + dt
    end

    ch._save_timer = (ch._save_timer or 0) + dt
    if ch._save_timer >= 5 then
        ch._save_timer = 0
        ch.save()
    end
end

-- ============================================
-- LOVE HOOKS
-- ============================================
local orig_mousemoved_ch = love.mousemoved
function love.mousemoved(x, y, dx, dy, istouch)
    local ch = G.jokerstream_channel
    if ch.dragging_scrollbar then
        local sb = ch.scrollbar_rect
        if sb then
            local ratio = (x - sb.x) / sb.w
            ratio = math.max(0, math.min(1, ratio))
            ch.clips_scroll = ratio * sb.max_scroll
        end
    end
    if ch.chat_settings.drag_chat and G.jokerstream_dragging_chat then
        local start = G.jokerstream_dragging_chat
        local cs = ch.chat_settings
        if not cs.drag_chat_pos then
            cs.drag_chat_pos = { x = 0, y = 0 }
        end
        cs.drag_chat_pos.x = cs.drag_chat_pos.x + (x - start.last_x)
        cs.drag_chat_pos.y = cs.drag_chat_pos.y + (y - start.last_y)
        start.last_x = x
        start.last_y = y
    end
    if orig_mousemoved_ch then return orig_mousemoved_ch(x, y, dx, dy, istouch) end
end

local orig_mousereleased_ch = love.mousereleased
function love.mousereleased(x, y, button, istouch, presses)
    G.jokerstream_channel.dragging_scrollbar = false
    G.jokerstream_dragging_chat = nil
    if orig_mousereleased_ch then return orig_mousereleased_ch(x, y, button, istouch, presses) end
end

local orig_wheelmoved_ch = love.wheelmoved
function love.wheelmoved(x, y)
    local view = G.jokerstream_channel.clip_view
    if view.active then
        local panel_w, panel_h = PANEL_W, PANEL_H
        local w = love.graphics.getWidth()
        local panel_x = w/2 - panel_w/2
        local p = G.jokerstream_channel.panel
        local eased = p.anim * p.anim * (3 - 2 * p.anim)
        local panel_y = (-panel_h - 30) + (30 + panel_h + 30) * eased
        local ow = panel_w - 100; local oh = panel_h - 150
        local ox = panel_x + 50;  local oy = panel_y + 75
        local mx, my = love.mouse.getPosition()
        local vx = ox + 30
        local vw = ow - 30 - 30 - 350
        local cmx = vx + vw + 30
        local cmy = oy + 95
        local cmw, cmh = 320, oh - 130
        if mx >= cmx and mx <= cmx + cmw and my >= cmy and my <= cmy + cmh then
            local lh = 28
            local max_scroll = math.max(0, view.comments_shown * lh - (cmh - 60))
            view.comments_scroll = view.comments_scroll - y * 30
            view.comments_scroll = math.max(0, math.min(view.comments_scroll, max_scroll))
            return
        end
    end
    if orig_wheelmoved_ch then return orig_wheelmoved_ch(x, y) end
end

local orig_quit = love.quit
function love.quit()
    if G.jokerstream_channel and G.jokerstream_channel.save then
        G.jokerstream_channel.save()
    end
    if G.jokerstream_account_save then G.jokerstream_account_save() end
    if orig_quit then return orig_quit() end
end

local orig_keypressed_channel = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and G.jokerstream_channel.karal_letter_open then
        G.jokerstream_channel.karal_letter_open = false
        return
    end
    if key == "escape" and G.jokerstream_channel.palette_picker_open then
        G.jokerstream_channel.palette_picker_open = false
        return
    end
    if key == "f7" then G.jokerstream_channel.add_subs(1000); return end
    if key == "f6" then G.jokerstream_channel.subs = 0; G.jokerstream_channel.save(); return end
    if key == "f5" then G.jokerstream_channel.save(); return end
    if orig_keypressed_channel then
        return orig_keypressed_channel(key, scancode, isrepeat)
    end
end