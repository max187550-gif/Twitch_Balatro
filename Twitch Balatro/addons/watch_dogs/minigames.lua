-- ============================================
-- MINIGAMES.LUA — троян (findme + mathquiz + intro + tiers + music)
-- ============================================

G.wd_mg = G.wd_mg or {
    active = false,
    type = nil,
    difficulty = 0,
    state = {},
    result = nil,
    on_finish = nil,
}

-- ============================================
-- ШРИФТ
-- ============================================
local FONT_CACHE = {}
local function get_mono(size)
    if FONT_CACHE[size] then return FONT_CACHE[size] end
    local f
    if G.jokerstream_get_chat_font then
        f = G.jokerstream_get_chat_font(size, 1)
    end
    if not f then
        local ok, font = pcall(love.graphics.newFont, "resources/fonts/m6x11plus.ttf", size)
        if ok then f = font end
    end
    if not f then
        local ok, font = pcall(love.graphics.newFont, size)
        if ok then f = font end
    end
    FONT_CACHE[size] = f
    return f
end

-- ============================================
-- УТИЛИТЫ
-- ============================================
local function utf8_len(s)
    local n = 0
    for _ in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do n = n + 1 end
    return n
end

local function pad(s, n)
    s = tostring(s)
    if #s > n then return s:sub(1, n) end
    return s .. string.rep(" ", n - #s)
end

local function random_folder_name()
    local prefixes = {
        "AppData", "Windows", "Program", "Users", "Temp", "Cache",
        "System", "Data", "Config", "Library", "Shared", "Public",
        "Backup", "Archive", "Logs", "Bin", "Lib", "Docs",
        "Assets", "Audio", "Video", "Fonts", "Drivers", "Kernel",
        "Boot", "Root", "Home", "Media", "Mount", "Dev",
        "Proc", "Sys", "Var", "Etc", "Opt", "Srv",
    }
    local suffixes = {
        "32", "64", "x86", "x64", "nt", "os", "core", "base",
        "cache", "tmp", "old", "new", "backup", "v1", "v2",
        "data", "info", "settings", "profiles", "defaults",
    }
    local p = prefixes[math.random(1, #prefixes)]
    local s = suffixes[math.random(1, #suffixes)]
    return p .. s .. math.random(1, 9999)
end

-- ============================================
-- ПАЛИТРЫ ПО СЛОЖНОСТИ
-- ============================================
local TIER_PALETTE = {
    [1] = {
        text = {0.95, 0.95, 0.95}, dim = {0.55, 0.55, 0.55},
        accent = {0.95, 0.95, 0.95},
        sel_bg = {0.95, 0.95, 0.95}, sel_fg = {0, 0, 0},
        hover_bg = {0.25, 0.25, 0.25},
    },
    [2] = {
        text = {0.95, 0.85, 0.30}, dim = {0.55, 0.48, 0.15},
        accent = {1.00, 0.90, 0.40},
        sel_bg = {0.95, 0.85, 0.30}, sel_fg = {0, 0, 0},
        hover_bg = {0.30, 0.25, 0.08},
    },
    [3] = {
        text = {0.95, 0.30, 0.30}, dim = {0.55, 0.15, 0.15},
        accent = {1.00, 0.30, 0.30},
        sel_bg = {0.95, 0.30, 0.30}, sel_fg = {0, 0, 0},
        hover_bg = {0.30, 0.08, 0.08},
    },
}

local function get_tier(difficulty)
    if difficulty <= 1 then return 1 end
    if difficulty <= 3 then return 2 end
    return 3
end

-- ============================================
-- МУЗЫКА
-- ============================================
local MG_TRACK_NAME = "mg_theme"
local TIER_VOLUME = {
    [1] = 0.30,
    [2] = 0.55,
    [3] = 0.85,
}

local MG_CURRENT = nil

local function load_track(name)
    local possible_paths = {}
    if G.jokerstream_mod_path and G.jokerstream_mod_path ~= "" then
        local clean_path = (G.jokerstream_mod_path:gsub("\\", "/"):gsub("/+$", ""))
        table.insert(possible_paths, clean_path)
    end
    local smods_path = (SMODS and SMODS.current_mod and SMODS.current_mod.path) or ""
    if smods_path ~= "" then
        local clean_smods = (smods_path:gsub("\\", "/"):gsub("/+$", ""))
        table.insert(possible_paths, clean_smods)
    end
    local save_dir = love.filesystem.getSaveDirectory()
    if save_dir then
        table.insert(possible_paths, save_dir .. "/Mods/Twitch Balatro")
    end
    table.insert(possible_paths, "")

    local rel_files = {
        "/assets/sounds/" .. name .. ".ogg",
        "/assets/sounds/" .. name .. ".mp3",
        "/sounds/" .. name .. ".ogg",
        name .. ".ogg"
    }

    for _, base_path in ipairs(possible_paths) do
        for _, rel in ipairs(rel_files) do
            local full_path = base_path .. rel
            local clean_path = (full_path:gsub("^%s+", ""):gsub("%s+$", ""))
            
            if NFS and clean_path ~= "" then
                local ok, bytes = pcall(NFS.read, clean_path)
                if ok and bytes and #bytes > 0 then
                    local ext = clean_path:match("%.([^%.]+)$") or "ogg"
                    local fd = love.filesystem.newFileData(bytes, name .. "." .. ext)
                    local ok2, src = pcall(love.audio.newSource, fd, "stream")
                    if ok2 and src then 
                        pcall(function() src._wd_our = true end)
                        local _wd = G.jokerstream_addons_loaded and G.jokerstream_addons_loaded["watch_dogs"]
                        if _wd and _wd.our_source_ids then
                            _wd.our_source_ids[tostring(src)] = true
                        end
                        print("[MINIGAMES] Loaded track via NFS: " .. clean_path)
                        return src 
                    end
                end
            end
            
            if love.filesystem.getInfo and clean_path ~= "" then
                if love.filesystem.getInfo(clean_path) then
                    local ok, src = pcall(love.audio.newSource, clean_path, "stream")
                    if ok and src then 
                        pcall(function() src._wd_our = true end)
                        local _wd = G.jokerstream_addons_loaded and G.jokerstream_addons_loaded["watch_dogs"]
                        if _wd and _wd.our_source_ids then
                            _wd.our_source_ids[tostring(src)] = true
                        end
                        print("[MINIGAMES] Loaded track via LFS: " .. clean_path)
                        return src 
                    end
                end
            end
        end
    end
    print("[MINIGAMES] FAILED to find track: " .. name)
    return nil
end

local function start_tier_music(tier)
    local vol = TIER_VOLUME[tier] or TIER_VOLUME[1]
    if MG_CURRENT then
        pcall(function() MG_CURRENT:setVolume(vol) end)
        return
    end
    local src = load_track(MG_TRACK_NAME)
    if src then
        G.wd_mg_theme = src
        src:setLooping(true)
        src:setVolume(vol)
        pcall(function() src:play() end)
        MG_CURRENT = src
    end
end

local function stop_tier_music()
    if MG_CURRENT then
        pcall(function() MG_CURRENT:stop() end)
        MG_CURRENT = nil
        G.wd_mg_theme = nil
    end
end

-- ============================================
-- ТЕКСТЫ ИНТРО
-- ============================================
local LOAD_LOG_POOL = {
    "loading kernel32.dll", "checking user permissions",
    "scanning C:\\Users", "mounting volume C:",
    "reading system registry", "verifying integrity",
    "decrypting cache.bin", "loading modules",
    "checking network adapter", "opening socket",
    "resolving hostname", "fetching remote manifest",
    "unpacking archive", "verifying signature",
    "writing temp files", "indexing documents",
    "loading fonts", "starting services",
    "reading user profile", "init graphics",
}

local BAGLEY_LINES = {
    "you're getting hacked, cutie",
    "nice system. too bad it's mine now.",
    "surprise, cutie. i'm already inside.",
    "hello sweetie. did you miss me?",
    "oops. wrong window to open.",
    "gotcha. no hard feelings, cutie.",
    "your files? mine now. cutie.",
    "peekaboo. yes, that's me in your ports.",
    "hi cutie. say bye to your saves.",
    "sup. i'm your new admin.",
}

-- ============================================
-- FINDME: ГЕНЕРАЦИЯ ДЕРЕВА
-- ============================================
local function build_tree(depth, cfg)
    local node = { name = random_folder_name(), children = {}, is_target = false, parent = nil }
    if depth >= cfg.max_depth then return node end
    local n = math.random(cfg.min_children, cfg.max_children)
    for i = 1, n do
        local child = build_tree(depth + 1, cfg)
        child.parent = node
        table.insert(node.children, child)
    end
    return node
end

local function find_all_nodes(node, list)
    list = list or {}
    table.insert(list, node)
    for _, c in ipairs(node.children) do
        find_all_nodes(c, list)
    end
    return list
end

local OBFUSCATE_CHANCE_HARD = 0.80

local function apply_display_names(all_nodes, difficulty)
    for _, n in ipairs(all_nodes) do
        if difficulty >= 4 and math.random() < OBFUSCATE_CHANCE_HARD then
            local len = math.min(#n.name, 8)
            n.display_name = string.rep("*", len)
        else
            n.display_name = n.name
        end
    end
end

local function generate_tree(difficulty)
    local cfg
    if difficulty <= 1 then
        cfg = { max_depth = 2, min_children = 2, max_children = 3 }
    elseif difficulty <= 3 then
        cfg = { max_depth = 3, min_children = 3, max_children = 5 }
    else
        cfg = { max_depth = 4, min_children = 4, max_children = 6 }
    end

    local roots = {}
    local root_count = (difficulty <= 1) and 4 or (difficulty <= 3) and 6 or 8
    for i = 1, root_count do
        table.insert(roots, build_tree(1, cfg))
    end

    local all = {}
    for _, r in ipairs(roots) do
        find_all_nodes(r, all)
    end
    local candidates = {}
    for _, n in ipairs(all) do
        if #n.children > 0 then
            table.insert(candidates, n)
        end
    end
    if #candidates == 0 then candidates = all end
    local target = candidates[math.random(1, #candidates)]
    target.is_target = true

    apply_display_names(all, difficulty)

    return roots, target
end

-- ============================================
-- MATHQUIZ: ГЕНЕРАЦИЯ ВОПРОСА
-- ============================================
local function gen_math_question(tier)
    if tier == 1 then
        local a, b
        if math.random(1, 2) == 1 then
            a = math.random(1, 20); b = math.random(1, 20)
            return string.format("%d + %d", a, b), a + b
        else
            a = math.random(5, 25); b = math.random(1, a)
            return string.format("%d - %d", a, b), a - b
        end
    elseif tier == 2 then
        local op = math.random(1, 3)
        if op == 1 then
            local a = math.random(10, 99); local b = math.random(10, 99)
            return string.format("%d + %d", a, b), a + b
        elseif op == 2 then
            local a = math.random(30, 99); local b = math.random(1, a)
            return string.format("%d - %d", a, b), a - b
        else
            local a = math.random(2, 12); local b = math.random(2, 12)
            return string.format("%d * %d", a, b), a * b
        end
    else
        local op = math.random(1, 4)
        if op == 1 then
            local a = math.random(1000, 9999); local b = math.random(100, 9999)
            return string.format("%d + %d", a, b), a + b
        elseif op == 2 then
            local a = math.random(2000, 9999); local b = math.random(100, a)
            return string.format("%d - %d", a, b), a - b
        elseif op == 3 then
            local a = math.random(11, 99); local b = math.random(11, 99)
            return string.format("%d * %d", a, b), a * b
        else
            local b = math.random(2, 20)
            local ans = math.random(3, 50)
            local a = b * ans
            return string.format("%d / %d", a, b), ans
        end
    end
end

local function gen_distractors(ans, tier, count)
    local used = { [ans] = true }
    local out = {}
    local spread = (tier == 1) and 5 or (tier == 2) and 20 or 3
    for i = 1, count do
        local d, tries = 0, 0
        repeat
            tries = tries + 1
            local off = math.random(1, spread)
            if math.random(1, 2) == 1 then off = -off end
            d = ans + off
        until ((not used[d]) and d >= 0) or tries >= 100
        if used[d] or d < 0 then d = ans + i + 1000 end
        used[d] = true
        table.insert(out, d)
    end
    return out
end

-- ============================================
-- СТАРТ: FINDME
-- ============================================
function G.wd_mg_start_findme(difficulty, on_finish)
    local mg = G.wd_mg
    mg.active = true
    mg.type = "findme"
    mg.difficulty = math.min(difficulty or 0, 5)
    mg.on_finish = on_finish
    mg.result = nil
    mg.tier = get_tier(mg.difficulty)
    mg.palette = TIER_PALETTE[mg.tier]

    local roots, target = generate_tree(mg.difficulty)

    local total_time
    if mg.tier == 1 then total_time = 40
    elseif mg.tier == 2 then total_time = 80
    else total_time = 145 end

    mg.state = {
        roots = roots,
        current = nil,
        path = {},
        target = target,
        time_left = total_time,
        total_time = total_time,
        deleting = false,
        deleting_t = 0,
        clicked_node = nil,
        system32 = { name = "system32", is_target = true, is_file = true,
                     display_name = "system32" },
        glitch_lines = {},
        glitch_t = 0,

        phase = "loading",
        phase_t = 0,
        loading_pct = 0,
        hack_at_pct = math.random(60, 99),
        loading_speed = 25 + math.random() * 25,
        red_pause_t = 0,
        bar_turned_red = false,
        bagley_text = BAGLEY_LINES[math.random(1, #BAGLEY_LINES)],
        load_log = {},
        load_log_timer = 0,
        _bagley_rain = nil,
        _dos_screens = nil,
        fade_alpha = 0,
    }
    start_tier_music(mg.tier)
end

-- ============================================
-- СТАРТ: MATHQUIZ
-- ============================================
function G.wd_mg_start_mathquiz(difficulty, on_finish)
    local mg = G.wd_mg
    mg.active = true
    mg.type = "mathquiz"
    mg.difficulty = math.min(difficulty or 0, 5)
    mg.on_finish = on_finish
    mg.result = nil
    mg.tier = get_tier(mg.difficulty)
    mg.palette = TIER_PALETTE[mg.tier]

    local total_time
    if mg.tier == 1 then total_time = 15
    elseif mg.tier == 2 then total_time = 10
    else total_time = 6 end

    local q_text, ans = gen_math_question(mg.tier)
    local distractors = gen_distractors(ans, mg.tier, 3)
    local answers = { ans, distractors[1], distractors[2], distractors[3] }
    for i = #answers, 2, -1 do
        local j = math.random(1, i)
        answers[i], answers[j] = answers[j], answers[i]
    end
    local correct_idx = 1
    for i, v in ipairs(answers) do
        if v == ans then correct_idx = i; break end
    end

    mg.state = {
        question = q_text,
        answers = answers,
        correct_idx = correct_idx,
        time_left = total_time,
        total_time = total_time,
        selected_idx = nil,
        feedback_t = 0,
        correct = false,
        _hit_rects = nil,

        phase = "loading",
        phase_t = 0,
        loading_pct = 0,
        hack_at_pct = math.random(60, 99),
        loading_speed = 25 + math.random() * 25,
        red_pause_t = 0,
        bar_turned_red = false,
        bagley_text = BAGLEY_LINES[math.random(1, #BAGLEY_LINES)],
        load_log = {},
        load_log_timer = 0,
        _bagley_rain = nil,
        _dos_screens = nil,
        fade_alpha = 0,
    }
    start_tier_music(mg.tier)
end

-- ============================================
-- ФИНИШ
-- ============================================
function G.wd_mg_finish(win)
    local mg = G.wd_mg
    if not mg.active or mg.result then return end
    stop_tier_music()
    mg.result = win and "win" or "lose"
    local cb = mg.on_finish
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.6,
        func = function()
            mg.active = false
            if cb then cb(win) end
            return true
        end
    }))
end

-- ============================================
-- ОБЩАЯ ЛОГИКА ИНТРО
-- ============================================
local function update_intro(s, dt)
    if s.phase == "loading" then
        s.phase_t = s.phase_t + dt
        if not s.bar_turned_red then
            s.loading_pct = s.loading_pct + s.loading_speed * dt
            s.load_log_timer = s.load_log_timer + dt
            if s.load_log_timer >= 0.14 then
                s.load_log_timer = 0
                local pick = LOAD_LOG_POOL[math.random(1, #LOAD_LOG_POOL)]
                local hex = string.format("%04X", math.random(0, 65535))
                table.insert(s.load_log, "> " .. pick .. " ... 0x" .. hex)
                while #s.load_log > 8 do table.remove(s.load_log, 1) end
            end
            if s.loading_pct >= s.hack_at_pct then
                s.loading_pct = s.hack_at_pct
                s.bar_turned_red = true
                s.red_pause_t = 0
            end
        else
            s.red_pause_t = s.red_pause_t + dt
            if s.red_pause_t >= 1.0 then
                s.phase = "bagley"
                s.phase_t = 0
                s._bagley_rain = nil
                s._dos_screens = nil
                s.fade_alpha = 0
            end
        end
        return true
    end
    
    if s.phase == "bagley" then
        s.phase_t = s.phase_t + dt
        if s.phase_t >= 2.2 then
            s.fade_alpha = math.min(1, (s.fade_alpha or 0) + dt * 2.5)
            if s.fade_alpha >= 1 then
                s.phase = "play"
                s.phase_t = 0
                s._bagley_rain = nil
                s._dos_screens = nil
            end
        end
        return true
    end
    
    if s.fade_alpha and s.fade_alpha > 0 then
        s.fade_alpha = math.max(0, s.fade_alpha - dt * 2.5)
    end
    return false
end

-- ============================================
-- UPDATE
-- ============================================
function G.wd_mg_update(dt)
    local mg = G.wd_mg
    if not mg.active or mg.result then return end

    local s = mg.state
    if update_intro(s, dt) then return end

    if mg.type == "findme" then
        if s.deleting then
            s.deleting_t = s.deleting_t + dt
            s.glitch_t = s.glitch_t + dt
            if s.glitch_t >= 0.05 then
                s.glitch_t = 0
                local sw = love.graphics.getWidth()
                local sh = love.graphics.getHeight()
                local len = math.random(20, 80)
                local chars = "#@$%&*!?<>/\\|=+-_:;."
                local line = ""
                for i = 1, len do
                    local idx = math.random(1, #chars)
                    line = line .. chars:sub(idx, idx)
                end
                table.insert(s.glitch_lines, {
                    text = line, x = math.random(-100, sw), y = math.random(0, sh),
                    life = 0.4, timer = 0,
                })
                while #s.glitch_lines > 25 do
                    table.remove(s.glitch_lines, 1)
                end
            end
            for i = #s.glitch_lines, 1, -1 do
                local g = s.glitch_lines[i]
                g.timer = g.timer + dt
                if g.timer >= g.life then
                    table.remove(s.glitch_lines, i)
                end
            end
            if s.deleting_t >= 1.8 then
                G.wd_mg_finish(true)
            end
            return
        end
        s.time_left = s.time_left - dt
        if s.time_left <= 0 then
            s.time_left = 0
            G.wd_mg_finish(false)
        end
        return
    end

    if mg.type == "mathquiz" then
        if s.selected_idx then
            s.feedback_t = s.feedback_t + dt
            if s.feedback_t >= 1.4 then
                G.wd_mg_finish(s.correct)
            end
            return
        end
        s.time_left = s.time_left - dt
        if s.time_left <= 0 then
            s.time_left = 0
            s.correct = false
            s.selected_idx = -1
            s.feedback_t = 0
        end
        return
    end
end

-- ============================================
-- ASCII ХЕЛПЕРЫ
-- ============================================
local FOLDER_ICON = {
    "  _____ ",
    " /    /|",
    "/____/ |",
    "|    | |",
    "|____|/ ",
}
local FILE_ICON = {
    "  _____ ",
    " |     |",
    " |     |",
    " |     |",
    " |_____|",
}

local function draw_ascii_box(x, y, w_cols, h_rows, cw, ch, title, color)
    color = color or {0.95, 0.95, 0.95}
    love.graphics.setColor(color[1], color[2], color[3], 1)

    local top
    if title and #title + 4 <= w_cols - 2 then
        local t = " " .. title .. " "
        local total = w_cols - 2
        local left = 1
        local right = total - #t - left
        top = "+" .. string.rep("-", left) .. t .. string.rep("-", right) .. "+"
    else
        top = "+" .. string.rep("-", w_cols - 2) .. "+"
    end
    love.graphics.print(top, x, y)
    love.graphics.print("+" .. string.rep("-", w_cols - 2) .. "+",
        x, y + (h_rows - 1) * ch)
    local rx = x + (w_cols - 1) * cw
    for i = 1, h_rows - 2 do
        love.graphics.print("|", x, y + i * ch)
        love.graphics.print("|", rx, y + i * ch)
    end
end

-- ============================================
-- ИНТРО: ЗАГРУЗКА (СТАРАЯ ВЕРСИЯ)
-- ============================================
local function draw_intro_loading(s, sw, sh)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, sw, sh)

    local font = get_mono(18)
    if not font then return end
    love.graphics.setFont(font)
    local cw = font:getWidth("M")
    local ch = font:getHeight()

    local win_cols = math.max(70, math.floor(sw / cw * 0.75))
    local win_rows = 22
    local win_w = win_cols * cw
    local win_h = win_rows * ch
    local win_x = math.floor((sw - win_w) / 2)
    local win_y = math.floor((sh - win_h) / 2)

    draw_ascii_box(win_x, win_y, win_cols, win_rows, cw, ch,
        "WATCHDOGS  SETUP", {0.95, 0.95, 0.95})

    local in_x = win_x + cw
    local in_y = win_y + ch
    local in_cols = win_cols - 2

    love.graphics.setColor(0.95, 0.95, 0.95, 1)
    love.graphics.print(" " .. pad("WATCHDOGS // SYSTEM INITIALIZATION", in_cols - 2) .. " ",
        in_x, in_y)

    love.graphics.setColor(0.55, 0.55, 0.55, 1)
    love.graphics.print("+" .. string.rep("-", in_cols) .. "+", win_x, in_y + ch)

    local log_y = in_y + 2 * ch
    local log_font = get_mono(14)
    if log_font then love.graphics.setFont(log_font) end
    local log_ch = log_font and log_font:getHeight() or ch
    local log_cw = log_font and log_font:getWidth("M") or cw

    for i, line in ipairs(s.load_log or {}) do
        local a = 0.55 + 0.25 * (i / math.max(1, #s.load_log))
        love.graphics.setColor(0.75, 0.75, 0.75, a)
        love.graphics.print(line, in_x + log_cw, log_y + (i - 1) * log_ch)
    end

    if font then love.graphics.setFont(font) end
    local bar_y = in_y + (win_rows - 5) * ch
    local bar_cols = in_cols - 16
    local pct = math.max(0, math.min(1, s.loading_pct / 100))
    local filled = math.floor(bar_cols * pct)
    local bar = string.rep("#", filled) .. string.rep(".", bar_cols - filled)
    local bar_line = "[" .. bar .. "]"

    local blink = 1
    if s.bar_turned_red then
        blink = (math.floor(s.phase_t * 8) % 2 == 0) and 1.0 or 0.55
        love.graphics.setColor(1.0, 0.15, 0.15, blink)
    else
        love.graphics.setColor(0.95, 0.95, 0.95, 1)
    end
    local bar_x = in_x + math.floor((in_cols - #bar_line) / 2) * cw
    love.graphics.print(bar_line, bar_x, bar_y)

    local pct_str = string.format("%d%%", math.floor(s.loading_pct))
    if s.bar_turned_red then
        love.graphics.setColor(1.0, 0.2, 0.2, blink)
    else
        love.graphics.setColor(0.95, 0.95, 0.95, 1)
    end
    local pct_w = #pct_str * cw
    love.graphics.print(pct_str,
        in_x + math.floor((in_cols * cw - pct_w) / 2),
        bar_y + ch)

    if s.bar_turned_red then
        local warn = "!! SIGNAL INTERRUPTED !!"
        local warn_w = #warn * cw
        love.graphics.setColor(1.0, 0.2, 0.2, 1)
        love.graphics.print(warn,
            in_x + math.floor((in_cols * cw - warn_w) / 2),
            bar_y + 2 * ch)
    end
end

-- ============================================
-- ИНТРО: БЭГЛИ (Matrix Rain + Amber CRT Панели)
-- ============================================
local function draw_intro_bagley(s, sw, sh)
    local t = s.phase_t
    local dt = love.timer.getDelta()

    if not s._bagley_rain then
        s._bagley_rain = {}
        local col_w = 24
        for x = 0, sw, col_w do
            local is_red = math.random(1, 2) == 1
            table.insert(s._bagley_rain, {
                x = x,
                y = math.random(-sh, 0),
                speed = math.random(800, 1500),
                color = is_red and {1, 0.2, 0.2} or {0.2, 1, 0.3},
                chars = {}
            })
            local col = s._bagley_rain[#s._bagley_rain]
            for i = 1, math.ceil(sh / 18) + 30 do
                col.chars[i] = tostring(math.random(1, 9))
            end
        end
    end

    local font = get_mono(18)
    if not font then return end
    local font_h = font:getHeight()

    for _, col in ipairs(s._bagley_rain) do
        col.y = col.y + col.speed * dt
        local tail_bottom = col.y - (#col.chars - 1) * font_h
        if tail_bottom > sh + 50 then
            col.y = -math.random(100, 500)
            col.speed = math.random(800, 1500)
            col.color = (math.random(1, 2) == 1) and {1, 0.2, 0.2} or {0.2, 1, 0.3}
            for i = 1, #col.chars do
                col.chars[i] = tostring(math.random(1, 9))
            end
        end
        if math.random() < dt * 20 then
            col.chars[math.random(1, #col.chars)] = tostring(math.random(1, 9))
        end
    end

    love.graphics.setColor(0.02, 0.01, 0.01, 1)
    love.graphics.rectangle("fill", 0, 0, sw, sh)

    love.graphics.setFont(font)
    for _, col in ipairs(s._bagley_rain) do
        for i, ch in ipairs(col.chars) do
            local y = col.y - (i - 1) * font_h
            if y > -font_h and y < sh then
                local alpha = math.max(0, 1 - (i - 1) / #col.chars)
                if i == 1 then
                    love.graphics.setColor(1, 1, 1, 1)
                else
                    love.graphics.setColor(col.color[1], col.color[2], col.color[3], alpha)
                end
                love.graphics.print(ch, col.x, y)
            end
        end
    end

    -- ============================================
    -- СЕРЫЕ ПРОЗРАЧНЫЕ ПАНЕЛИ (Вариант 2: Amber CRT)
    -- ============================================
    if not s._dos_screens then
        s._dos_screens = {}
        local tier = G.wd_mg.tier or 1
        local num_screens = 1
        if tier == 1 then num_screens = math.random(1, 2)
        elseif tier == 2 then num_screens = math.random(2, 4)
        else num_screens = math.random(5, 8) end

        for i = 1, num_screens do
            local w = math.random(280, 380) -- Большие панели
            local h = math.random(180, 250)
            local left_side = math.random(1, 2) == 1
            local x
            if left_side then
                x = math.random(20, math.max(20, math.floor(sw/2 - w - 80)))
            else
                x = math.random(math.min(sw - w - 20, math.floor(sw/2 + 80)), sw - w - 20)
            end
            
            local y
            if math.random(1, 2) == 1 then
                y = math.random(20, math.max(20, math.floor(sh/2 - 180 - h)))
            else
                y = math.random(math.min(sh - h - 20, math.floor(sh/2 + 180)), sh - h - 20)
            end

            local lines = {}
            local line_count = math.floor(h / 20)
            for j = 1, line_count do
                table.insert(lines, "0x" .. string.format("%04X", math.random(0, 65535)))
            end

            table.insert(s._dos_screens, {
                x = x, y = y, w = w, h = h,
                lines = lines,
                red_idx_1 = math.random(1, line_count),
                red_idx_2 = (math.random(1, 2) == 1) and math.random(1, line_count) or nil,
                timer = 0,
                update_rate = 0.03 + math.random() * 0.05,
            })
        end
    end

    local dos_font = get_mono(18)
    if dos_font then love.graphics.setFont(dos_font) end
    local lh = dos_font and dos_font:getHeight() or 18

    for _, screen in ipairs(s._dos_screens) do
        screen.timer = screen.timer + dt
        if screen.timer >= screen.update_rate then
            screen.timer = 0
            local idx = math.random(1, #screen.lines)
            screen.lines[idx] = "0x" .. string.format("%04X", math.random(0, 65535))
            
            if math.random() < 0.15 then
                screen.red_idx_1 = math.random(1, #screen.lines)
                screen.red_idx_2 = (math.random(1, 2) == 1) and math.random(1, #screen.lines) or nil
            end
        end

        -- Черный прозрачный фон
        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", screen.x, screen.y, screen.w, screen.h)

        -- Янтарная (желто-оранжевая) рамка
        love.graphics.setColor(1.0, 0.7, 0.1, 0.9)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", screen.x, screen.y, screen.w, screen.h)
        love.graphics.setLineWidth(1)

        -- Заголовок панели
        love.graphics.setColor(0.8, 0.5, 0.1, 0.8)
        love.graphics.rectangle("fill", screen.x, screen.y, screen.w, lh + 4)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(">_ CMD.EXE", screen.x + 5, screen.y + 2)

        local blink = (math.floor(t * 15) % 2 == 0)
        for i, line in ipairs(screen.lines) do
            if screen.y + (i)*lh < screen.y + screen.h - 5 then
                local is_red = (i == screen.red_idx_1 or i == screen.red_idx_2)
                if is_red then
                    love.graphics.setColor(1, 0.1, 0.1, blink and 1 or 0.2)
                else
                    love.graphics.setColor(1.0, 0.7, 0.1, 0.8) -- Янтарный текст
                end
                love.graphics.print(line, screen.x + 8, screen.y + (i)*lh + 2)
            end
        end
    end

    -- ============================================
    -- ЦЕНТРАЛЬНЫЙ ТЕКСТ (Строго по центру)
    -- ============================================
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, sh / 2 - 150, sw, 300)

    love.graphics.setColor(1, 0.1, 0.1, 0.6)
    love.graphics.rectangle("fill", 0, sh / 2 - 150, sw, 2)
    love.graphics.rectangle("fill", 0, sh / 2 + 150, sw, 2)

    local big_font = get_mono(36)
    if big_font then love.graphics.setFont(big_font) end
    local header = "[ INTRUSION DETECTED ]"
    love.graphics.setColor(1, 0.15, 0.15, 1)
    love.graphics.printf(header, 0, sh / 2 - 110, sw, "center")

    local med_font = get_mono(24)
    if med_font then love.graphics.setFont(med_font) end
    local nick = "Bagley:"
    love.graphics.setColor(1, 0.55, 0.2, 1)
    love.graphics.printf(nick, 0, sh / 2 - 40, sw, "center")

    local text = "\"" .. s.bagley_text .. "\""
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(text, 0, sh / 2 + 10, sw, "center")

    if font then love.graphics.setFont(font) end
    local hint = "> countermeasure loading ..."
    local a = 0.4 + 0.4 * math.abs(math.sin(t * 3))
    love.graphics.setColor(0.85, 0.85, 0.85, a)
    love.graphics.printf(hint, 0, sh / 2 + 100, sw, "center")
end

-- ============================================
-- ОТРИСОВКА — FINDME
-- ============================================
local function draw_findme_play()
    local mg = G.wd_mg
    local s = mg.state
    local P = mg.palette or TIER_PALETTE[1]
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, sw, sh)

    local font = get_mono(16)
    if not font then return end
    love.graphics.setFont(font)

    local cw = font:getWidth("M")
    local ch = font:getHeight()

    local pad_x = 50
    local pad_y = 50
    local cols = math.floor((sw - pad_x * 2) / cw)
    local rows = math.floor((sh - pad_y * 2) / ch)

    local win_w = cols * cw
    local win_h = rows * ch
    local win_x = math.floor((sw - win_w) / 2)
    local win_y = math.floor((sh - win_h) / 2)

    draw_ascii_box(win_x, win_y, cols, rows, cw, ch,
        "WATCHDOGS  FILE MANAGER  v3.22", P.text)

    local in_x = win_x + cw
    local in_y = win_y + ch
    local in_cols = cols - 2

    love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    local title_line = " " .. pad("WATCHDOGS // FILE MANAGER", in_cols - 12) .. "[X] QUIT "
    love.graphics.print(title_line:sub(1, in_cols), in_x, in_y)

    love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
    love.graphics.print("+" .. string.rep("-", in_cols) .. "+", win_x, in_y + ch)

    local back_str = (#s.path > 0) and "[<] BACK" or "[ ] BACK"
    local path_str = "PATH: C:\\"
    for _, node in ipairs(s.path) do
        path_str = path_str .. node.display_name .. "\\"
    end
    local line2 = " " .. pad(back_str, 10) .. "  " .. pad(path_str, in_cols - 20)
    love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    love.graphics.print(line2:sub(1, in_cols), in_x, in_y + 2 * ch)

    love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
    love.graphics.print("+" .. string.rep("-", in_cols) .. "+", win_x, in_y + 3 * ch)

    local items = {}
    if s.current then
        for _, n in ipairs(s.current.children) do
            table.insert(items, { node = n, is_file = false })
        end
        if s.current.is_target and not s.deleting then
            table.insert(items, { node = s.system32, is_file = true })
        end
    else
        for _, n in ipairs(s.roots) do
            table.insert(items, { node = n, is_file = false })
        end
    end

    local grid_y = in_y + 4 * ch
    local grid_h = (rows - 4 - 4) * ch

    local CELL_W = 15
    local CELL_H = 8
    local cols_per_row = math.max(3, math.floor(in_cols / CELL_W))

    local mx, my = love.mouse.getPosition()
    s._hit_rects = {}

    love.graphics.setScissor(win_x + cw, grid_y, in_cols * cw, grid_h)

    for i, item in ipairs(items) do
        local col = (i - 1) % cols_per_row
        local row = math.floor((i - 1) / cols_per_row)
        local cell_x = in_x + col * CELL_W * cw
        local cell_y = grid_y + row * CELL_H * ch

        local cell_w_px = CELL_W * cw
        local cell_h_px = CELL_H * ch

        if cell_y + cell_h_px > grid_y and cell_y < grid_y + grid_h then
            local hover = mx >= cell_x and mx <= cell_x + cell_w_px
                       and my >= cell_y and my <= cell_y + cell_h_px
            local selected = (s.clicked_node == item.node)

            if selected then
                love.graphics.setColor(P.sel_bg[1], P.sel_bg[2], P.sel_bg[3], 1)
                love.graphics.rectangle("fill", cell_x, cell_y, cell_w_px, cell_h_px)
                love.graphics.setColor(P.sel_fg[1], P.sel_fg[2], P.sel_fg[3], 1)
            elseif hover then
                love.graphics.setColor(P.hover_bg[1], P.hover_bg[2], P.hover_bg[3], 1)
                love.graphics.rectangle("fill", cell_x, cell_y, cell_w_px, cell_h_px)
                love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
            else
                love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
            end

            local icon = item.is_file and FILE_ICON or FOLDER_ICON
            local icon_w = 8
            local icon_offset = math.floor((CELL_W - icon_w) / 2)
            for ly, line in ipairs(icon) do
                love.graphics.print(line, cell_x + icon_offset * cw, cell_y + (ly - 1) * ch)
            end

            local name = item.node.display_name or item.node.name
            if #name > CELL_W - 2 then
                name = name:sub(1, CELL_W - 4) .. ".."
            end
            local name_offset = math.floor((CELL_W - #name) / 2)
            if name_offset < 0 then name_offset = 0 end
            love.graphics.print(name, cell_x + name_offset * cw, cell_y + 6 * ch)

            table.insert(s._hit_rects, {
                x = cell_x, y = cell_y,
                w = cell_w_px, h = cell_h_px,
                node = item.node, is_file = item.is_file,
            })
        end
    end

    love.graphics.setScissor()

    if #items == 0 then
        love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
        love.graphics.print("(empty)", in_x + 3 * cw, grid_y + 2 * ch)
    end

    local tf = get_mono(48)
    if tf then love.graphics.setFont(tf) end
    
    local mins = math.floor(s.time_left / 60)
    local secs = math.floor(s.time_left % 60)
    local time_str = string.format("%d:%02d", mins, secs)
    
    love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    local tw = tf and tf:getWidth(time_str) or 0
    love.graphics.print(time_str, (sw - tw) / 2, win_y + win_h - ch * 6)

    if s.deleting then
        local t = s.deleting_t
        love.graphics.setColor(0, 0, 0, 0.85)
        love.graphics.rectangle("fill", 0, 0, sw, sh)

        local chars_font = get_mono(16)
        love.graphics.setFont(chars_font)
        for _, g in ipairs(s.glitch_lines) do
            local a = 1 - (g.timer / g.life)
            love.graphics.setColor(0.9, 0.3, 0.3, a * 0.85)
            love.graphics.print(g.text, g.x, g.y)
        end

        local cf = get_mono(28)
        if cf then love.graphics.setFont(cf) end
        local big_cw = cf and cf:getWidth("M") or 16
        local big_ch = cf and cf:getHeight() or 28

        local msgs = { "DELETING SYSTEM32 ...", "PLEASE WAIT", "DO NOT TURN OFF" }
        local mid_y = sh / 2 - big_ch * 2
        love.graphics.setColor(1, 0.3, 0.3, 1)
        for i, m in ipairs(msgs) do
            love.graphics.print(m, (sw - #m * big_cw) / 2, mid_y + (i - 1) * big_ch * 2)
        end

        local prog = math.min(t / 1.5, 1)
        local bar_len = 30
        local fill = math.floor(bar_len * prog)
        local pbar = "[" .. string.rep("#", fill) .. string.rep(".", bar_len - fill) .. "]"
        local pw = #pbar * big_cw
        local px = (sw - pw) / 2
        local py = mid_y + big_ch * 6
        love.graphics.print(pbar, px, py)
        love.graphics.print(string.format(" %d%%", math.floor(prog * 100)), px + pw + 10, py)

        local hint = "> PROCESS CANNOT BE STOPPED <"
        love.graphics.print(hint, (sw - #hint * big_cw) / 2, py + big_ch * 2)
    end

    if mg.result then
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill", 0, 0, sw, sh)
        local bf = get_mono(48)
        if bf then love.graphics.setFont(bf) end
        local bw = bf and bf:getWidth("M") or 26
        local bh = bf and bf:getHeight() or 48
        love.graphics.setColor(1, 1, 1, 1)
        if mg.result == "win" then
            local l1 = "[ SYSTEM32 DELETED ]"
            love.graphics.print(l1, (sw - #l1 * bw) / 2, sh / 2 - bh)
            local l2 = "> ACCESS GRANTED <"
            love.graphics.print(l2, (sw - #l2 * bw) / 2, sh / 2 + bh)
        else
            local l1 = "[ TIME OUT ]"
            love.graphics.print(l1, (sw - #l1 * bw) / 2, sh / 2 - bh)
            local l2 = "> ACCESS DENIED <"
            love.graphics.print(l2, (sw - #l2 * bw) / 2, sh / 2 + bh)
        end
    end
end

-- ============================================
-- ОТРИСОВКА — MATHQUIZ
-- ============================================
local function draw_mathquiz_play()
    local mg = G.wd_mg
    local s = mg.state
    local P = mg.palette or TIER_PALETTE[1]
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, sw, sh)

    local font = get_mono(16)
    if not font then return end
    love.graphics.setFont(font)
    local cw = font:getWidth("M")
    local ch = font:getHeight()

    local pad_x = 50
    local pad_y = 50
    local cols = math.floor((sw - pad_x * 2) / cw)
    local rows = math.floor((sh - pad_y * 2) / ch)

    local win_w = cols * cw
    local win_h = rows * ch
    local win_x = math.floor((sw - win_w) / 2)
    local win_y = math.floor((sh - win_h) / 2)

    draw_ascii_box(win_x, win_y, cols, rows, cw, ch,
        "WATCHDOGS  MATH CHALLENGE  v3.23", P.text)

    local in_x = win_x + cw
    local in_y = win_y + ch
    local in_cols = cols - 2

    love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    local head = " " .. pad("WATCHDOGS // SOLVE THE PROBLEM", in_cols - 2) .. " "
    love.graphics.print(head:sub(1, in_cols), in_x, in_y)

    love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
    love.graphics.print("+" .. string.rep("-", in_cols) .. "+", win_x, in_y + ch)

    local q_len = #s.question
    local qfont_size = 80
    if q_len <= 3 then qfont_size = 120
    elseif q_len <= 5 then qfont_size = 100
    elseif q_len <= 7 then qfont_size = 80
    else qfont_size = 60 end

    local qfont = get_mono(qfont_size)
    if qfont then love.graphics.setFont(qfont) end
    local qcw = qfont and qfont:getWidth(s.question) or 0
    local qch = qfont and qfont:getHeight() or 80
    love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    love.graphics.print(s.question, (sw - qcw) / 2, sh / 2 - qch * 1.5)

    local hint_font = get_mono(18)
    if hint_font then love.graphics.setFont(hint_font) end
    local hint = "[ PRESS 1-4 OR CLICK ]"
    local hcw = hint_font and hint_font:getWidth("M") or 8
    love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
    love.graphics.print(hint, (sw - #hint * hcw) / 2, sh / 2 - qch * 0.5)

    local max_ans_len = 0
    for _, a in ipairs(s.answers) do
        local l = #tostring(a)
        if l > max_ans_len then max_ans_len = l end
    end

    local box_w = 260
    local box_h = 90
    local gap = 30
    if box_w * 2 + gap > sw * 0.9 then
        box_w = math.floor((sw * 0.9 - gap) / 2)
    end
    local total_w = 2 * box_w + gap
    local start_x = (sw - total_w) / 2
    local start_y = sh / 2 + 40

    local abox_font_size = 48
    if max_ans_len >= 6 then abox_font_size = 36 end
    if max_ans_len >= 8 then abox_font_size = 28 end
    local box_font = get_mono(abox_font_size)
    if box_font then love.graphics.setFont(box_font) end
    local bcw = box_font and box_font:getWidth("M") or 12
    local bch = box_font and box_font:getHeight() or 32

    local mx, my = love.mouse.getPosition()
    s._hit_rects = {}

    for i = 1, 4 do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local bx = start_x + col * (box_w + gap)
        local by = start_y + row * (box_h + gap)

        local hover = mx >= bx and mx <= bx + box_w
                   and my >= by and my <= by + box_h

        local is_selected = (s.selected_idx == i)
        local is_correct = (i == s.correct_idx)
        local show_feedback = s.selected_idx ~= nil

        if show_feedback then
            if is_selected and s.correct then
                love.graphics.setColor(0.20, 0.85, 0.35, 1)
            elseif is_selected and not s.correct then
                love.graphics.setColor(0.85, 0.15, 0.15, 1)
            elseif is_correct then
                love.graphics.setColor(0.20, 0.55, 0.25, 1)
            else
                love.graphics.setColor(0.10, 0.10, 0.10, 1)
            end
            love.graphics.rectangle("fill", bx, by, box_w, box_h, 6)
            love.graphics.setColor(1, 1, 1, 1)
        elseif hover then
            love.graphics.setColor(P.hover_bg[1], P.hover_bg[2], P.hover_bg[3], 1)
            love.graphics.rectangle("fill", bx, by, box_w, box_h, 6)
            love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
        else
            love.graphics.setColor(P.sel_bg[1] * 0.08, P.sel_bg[2] * 0.08, P.sel_bg[3] * 0.08, 1)
            love.graphics.rectangle("fill", bx, by, box_w, box_h, 6)
            love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
        end

        love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", bx, by, box_w, box_h, 6)
        love.graphics.setLineWidth(1)

        local badge = "[" .. i .. "]"
        local b18 = get_mono(18)
        if b18 then love.graphics.setFont(b18) end
        love.graphics.setColor(P.dim[1], P.dim[2], P.dim[3], 1)
        love.graphics.print(badge, bx + 12, by + 8)

        if box_font then love.graphics.setFont(box_font) end
        local ans_text = tostring(s.answers[i])
        love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
        love.graphics.printf(ans_text, bx + 30, by + (box_h - bch) / 2, box_w - 40, "center")

        table.insert(s._hit_rects, {
            x = bx, y = by, w = box_w, h = box_h, idx = i,
        })
    end

    local tf = get_mono(48)
    if tf then love.graphics.setFont(tf) end

    local time_str = string.format("%.1fs", s.time_left)
    local pct = math.max(0, math.min(1, s.time_left / s.total_time))
    
    if pct < 0.3 then
        love.graphics.setColor(1, 0.3, 0.3, 1)
    else
        love.graphics.setColor(P.text[1], P.text[2], P.text[3], 1)
    end
    
    local tw = tf and tf:getWidth(time_str) or 0
    love.graphics.print(time_str, (sw - tw) / 2, win_y + win_h - ch * 6)

    if mg.result then
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill", 0, 0, sw, sh)
        local bf = get_mono(48)
        if bf then love.graphics.setFont(bf) end
        local bw = bf and bf:getWidth("M") or 26
        local bh = bf and bf:getHeight() or 48
        love.graphics.setColor(1, 1, 1, 1)
        if mg.result == "win" then
            local l1 = "[ CORRECT ]"
            love.graphics.print(l1, (sw - #l1 * bw) / 2, sh / 2 - bh)
            local l2 = "> ACCESS GRANTED <"
            love.graphics.print(l2, (sw - #l2 * bw) / 2, sh / 2 + bh)
        else
            local l1 = "[ WRONG ]"
            love.graphics.print(l1, (sw - #l1 * bw) / 2, sh / 2 - bh)
            local l2 = "> ACCESS DENIED <"
            love.graphics.print(l2, (sw - #l2 * bw) / 2, sh / 2 + bh)
        end
    end
end

-- ============================================
-- ДИСПЕТЧЕР ОТРИСОВКИ
-- ============================================
local function draw_findme()
    local mg = G.wd_mg
    local s = mg.state
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    if s.phase == "loading" then
        draw_intro_loading(s, sw, sh)
    elseif s.phase == "bagley" then
        draw_intro_bagley(s, sw, sh)
    else
        draw_findme_play()
    end
end

local function draw_mathquiz()
    local mg = G.wd_mg
    local s = mg.state
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    if s.phase == "loading" then
        draw_intro_loading(s, sw, sh)
    elseif s.phase == "bagley" then
        draw_intro_bagley(s, sw, sh)
    else
        draw_mathquiz_play()
    end
end

function G.wd_mg_draw()
    local mg = G.wd_mg
    if not mg.active then return end
    love.graphics.push("all")
    love.graphics.origin()
    love.graphics.setScissor()
    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    
    if mg.type == "findme" then draw_findme()
    elseif mg.type == "mathquiz" then draw_mathquiz() end
    
    local s = mg.state
    if s and s.fade_alpha and s.fade_alpha > 0 then
        love.graphics.setColor(0, 0, 0, s.fade_alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    
    love.graphics.pop()
end

-- ============================================
-- КЛИКИ / ВВОД
-- ============================================
local function findme_click(x, y, button)
    local mg = G.wd_mg
    local s = mg.state
    if mg.result or s.phase ~= "play" or s.deleting then return end

    for _, r in ipairs(s._hit_rects or {}) do
        if x >= r.x and x <= r.x + r.w
           and y >= r.y and y <= r.y + r.h then
            if r.is_file then
                s.deleting = true
                s.deleting_t = 0
                s.glitch_lines = {}
                s.glitch_t = 0
            else
                s.current = r.node
                table.insert(s.path, r.node)
                s.clicked_node = nil
            end
            return
        end
    end

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    local font = get_mono(16)
    if font then
        local cw = font:getWidth("M")
        local ch = font:getHeight()
        local pad_x, pad_y = 50, 50
        local cols = math.floor((sw - pad_x * 2) / cw)
        local rows = math.floor((sh - pad_y * 2) / ch)

        local win_w = cols * cw
        local win_h = rows * ch
        local win_x = math.floor((sw - win_w) / 2)
        local win_y = math.floor((sh - win_h) / 2)

        local back_y = win_y + 3 * ch
        if #s.path > 0
           and x >= win_x + cw and x <= win_x + cw + 10 * cw
           and y >= back_y and y <= back_y + ch then
            table.remove(s.path)
            s.current = (#s.path > 0) and s.path[#s.path] or nil
            s.clicked_node = nil
            return
        end

        local qx = win_x + win_w - 12 * cw
        local qy = win_y + ch
        if x >= qx and x <= qx + 12 * cw
           and y >= qy and y <= qy + ch then
            G.wd_mg_finish(false)
            return
        end
    end
end

local function mathquiz_click(x, y, button)
    local mg = G.wd_mg
    local s = mg.state
    if mg.result or s.phase ~= "play" or s.selected_idx then return end

    for _, r in ipairs(s._hit_rects or {}) do
        if x >= r.x and x <= r.x + r.w
           and y >= r.y and y <= r.y + r.h then
            s.selected_idx = r.idx
            s.correct = (r.idx == s.correct_idx)
            s.feedback_t = 0
            return
        end
    end
end

function G.wd_mg_mousepressed(x, y, button)
    local mg = G.wd_mg
    if not mg.active or mg.result then return false end
    local s = mg.state
    if s.fade_alpha and s.fade_alpha > 0.1 then return true end
    
    if button ~= 1 then return false end
    if mg.type == "findme" then
        findme_click(x, y, button)
        return true
    elseif mg.type == "mathquiz" then
        mathquiz_click(x, y, button)
        return true
    end
    return false
end

function G.wd_mg_keypressed(key)
    local mg = G.wd_mg
    if not mg.active or mg.result then return false end
    local s = mg.state

    if key == "space" then
        if s.phase == "loading" or s.phase == "bagley" then
            s.phase = "play"
            s.phase_t = 0
            s._bagley_rain = nil
            s._dos_screens = nil
            s.fade_alpha = 1
            return true
        end
    end

    if key == "escape" then
        G.wd_mg_finish(false)
        return true
    end

    if s.fade_alpha and s.fade_alpha > 0.1 then return true end

    if mg.type == "mathquiz" then
        if s.phase == "play" and not s.selected_idx then
            local n = tonumber(key)
            if n and n >= 1 and n <= 4 then
                s.selected_idx = n
                s.correct = (n == s.correct_idx)
                s.feedback_t = 0
                return true
            end
        end
    end

    return true
end

-- ============================================
-- СТАРТОВАЯ ОБЁРТКА
-- ============================================
function G.wd_mg_start(difficulty, on_finish)
    if math.random(1, 2) == 1 then
        G.wd_mg_start_findme(difficulty, on_finish)
    else
        G.wd_mg_start_mathquiz(difficulty, on_finish)
    end
end