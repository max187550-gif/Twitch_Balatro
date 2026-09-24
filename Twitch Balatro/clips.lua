-- ============================================
-- CLIPS.LUA — Система клипов
-- ============================================

print("[JOKER STREAM] clips.lua loaded")

local MOD_PATH       = "C:/Users/МАКСИМУШКА/AppData/Roaming/Balatro/Mods/Twitch Balatro"
local CLIPS_DIR_NFS  = MOD_PATH .. "/clips"
local CLIPS_DIR_LFS  = "jokerstream_clips"

G.jokerstream_clips = G.jokerstream_clips or {
    list = {},
    next_slot = 1,
    max_clips = 10,
    passive_timer = 0,
    _loaded = false,
}

-- ============================================
-- МНОЖИТЕЛЬ ПОПУЛЯРНОСТИ ОТ УРОВНЯ КАНАЛА (+20% за уровень)
-- ============================================
local function clips_pop_mult()
    local level = 0
    if G.jokerstream_get_level then
        level = G.jokerstream_get_level()
    elseif G.jokerstream_milestones and G.jokerstream_channel then
        local subs = G.jokerstream_channel.subs or 0
        for _, m in ipairs(G.jokerstream_milestones) do
            if subs >= m.subs then level = level + 1 end
        end
    end
    return 1.0 + level * 0.20
end

-- ============================================
-- ПУЛЫ КОММЕНТОВ
-- ============================================
local comment_nicks = {
    "pogmaster", "clipper", "xQc", "lurker", "gg_ez", "ratio_lord",
    "kekw_lord", "joker_collector", "spade_stan", "diamond_dan",
    "totally_real", "user_1234", "noobmaster69", "troll_king",
    "chaos_goblin", "based_andy", "vibe_check", "stream_sniper",
    "ace_player", "lucky_luke",
}

local comment_texts = {
    "CLIP IT", "GOATED moment", "rewatching this", "still insane",
    "peak Balatro", "no way", "POG", "POGGERS", "LETS GO", "GG",
    "W", "this is cinema", "absolute cinema", "naneinf in my heart",
    "clip of the year", "certified hood classic", "based", "valid",
    "immaculate", "clip it now", "how???", "what seed", "rigged KEKW",
    "LUL", "KEKW", "no shot", "clean play", "clutch", "banger",
    "top tier", "S tier", "worth", "10/10", "rewatch of the year",
    "he's cooking", "let him cook", "put him in the hall of fame",
    "history books", "peak performance", "god gamer", "cracked",
    "this clip lives in my head rent free", "RNG blessed",
    "RNG cursed", "one more view", "first", "early", "here before 1k",
}

local comment_colors = {
    {1.00, 0.25, 0.25}, {1.00, 0.45, 0.25}, {1.00, 0.65, 0.20},
    {1.00, 0.85, 0.25}, {0.80, 1.00, 0.30}, {0.30, 0.90, 0.40},
    {0.30, 0.90, 0.70}, {0.30, 0.90, 0.95}, {0.30, 0.65, 1.00},
    {0.45, 0.45, 1.00}, {0.80, 0.30, 1.00}, {1.00, 0.30, 0.65},
    {0.85, 0.85, 0.85}, {0.65, 0.65, 0.65}, {0.60, 0.95, 0.60},
}

local function pick_comment_nick()
    return comment_nicks[math.random(1, #comment_nicks)]
end
local function pick_comment_text()
    return comment_texts[math.random(1, #comment_texts)]
end
local function pick_comment_color()
    return comment_colors[math.random(1, #comment_colors)]
end

-- ============================================
-- ФАЙЛОВЫЕ ОПЕРАЦИИ
-- ============================================
local function ensure_dirs()
    if NFS then
        pcall(function() NFS.createDirectory(CLIPS_DIR_NFS) end)
    end
    pcall(function() love.filesystem.createDirectory(CLIPS_DIR_LFS) end)
end

local function write_file(rel_name, content)
    local nfs_path = CLIPS_DIR_NFS .. "/" .. rel_name
    local lfs_path = CLIPS_DIR_LFS .. "/" .. rel_name
    local ok1, err1 = false, nil
    if NFS then
        ok1, err1 = pcall(NFS.write, nfs_path, content)
    end
    local ok2, err2 = pcall(love.filesystem.write, lfs_path, content)
    if not ok1 and not ok2 then
        print("[JOKER STREAM] write failed:", rel_name, err1, err2)
    end
end

local function read_file(rel_name)
    local nfs_path = CLIPS_DIR_NFS .. "/" .. rel_name
    local lfs_path = CLIPS_DIR_LFS .. "/" .. rel_name
    if NFS then
        local ok, data = pcall(NFS.read, nfs_path)
        if ok and data and data ~= "" then return data end
    end
    local ok2, data2 = pcall(love.filesystem.read, lfs_path)
    if ok2 and data2 and data2 ~= "" then return data2 end
    return nil
end

local function file_exists(rel_name)
    local nfs_path = CLIPS_DIR_NFS .. "/" .. rel_name
    local lfs_path = CLIPS_DIR_LFS .. "/" .. rel_name
    if NFS then
        local ok = pcall(NFS.getInfo, nfs_path)
        if ok then return true end
    end
    return love.filesystem.getInfo(lfs_path) ~= nil
end

-- ============================================
-- СЕРИАЛИЗАЦИЯ КЛИПА
-- ============================================
local function serialize_clip(clip)
    local lines = {
        "id=" .. (clip.id or ""),
        "slot=" .. tostring(clip.slot or 0),
        "type=" .. (clip.type or ""),
        "title=" .. (clip.title or ""),
        "created_at=" .. (clip.created_at or ""),
        "ante=" .. tostring(clip.ante or 0),
        "round=" .. tostring(clip.round or 0),
        "blind=" .. (clip.blind or ""),
        "score=" .. tostring(clip.score or 0),
        "hand_name=" .. (clip.hand_name or ""),
        "views=" .. tostring(clip.views or 0),
        "likes=" .. tostring(clip.likes or 0),
        "subs_earned=" .. tostring(clip.subs_earned or 0),
        "jokers_total=" .. tostring(clip.jokers_total or 0),
        "jokers_activated=" .. tostring(clip.jokers_activated or 0),
        "hands_left=" .. tostring(clip.hands_left or 0),
        "discards_left=" .. tostring(clip.discards_left or 0),
    }
    for _, c in ipairs(clip.cards or {}) do
        lines[#lines + 1] = "card=" .. c
    end
    for _, j in ipairs(clip.jokers or {}) do
        lines[#lines + 1] = "joker=" .. j
    end
    return table.concat(lines, "\n")
end

local function deserialize_clip(content)
    if not content then return nil end
    local clip = { cards = {}, jokers = {} }
    for line in content:gmatch("[^\r\n]+") do
        local key, value = line:match("^([^=]+)=(.*)$")
        if key == "id" then clip.id = value
        elseif key == "slot" then clip.slot = tonumber(value) or 0
        elseif key == "type" then clip.type = value
        elseif key == "title" then clip.title = value
        elseif key == "created_at" then clip.created_at = value
        elseif key == "ante" then clip.ante = tonumber(value) or 0
        elseif key == "round" then clip.round = tonumber(value) or 0
        elseif key == "blind" then clip.blind = value
        elseif key == "score" then clip.score = tonumber(value) or 0
        elseif key == "hand_name" then clip.hand_name = value
        elseif key == "views" then clip.views = tonumber(value) or 0
        elseif key == "likes" then clip.likes = tonumber(value) or 0
        elseif key == "subs_earned" then clip.subs_earned = tonumber(value) or 0
        elseif key == "jokers_total" then clip.jokers_total = tonumber(value) or 0
        elseif key == "jokers_activated" then clip.jokers_activated = tonumber(value) or 0
        elseif key == "hands_left" then clip.hands_left = tonumber(value) or 0
        elseif key == "discards_left" then clip.discards_left = tonumber(value) or 0
        elseif key == "card" then table.insert(clip.cards, value)
        elseif key == "joker" then table.insert(clip.jokers, value)
        end
    end
    if not clip.id then return nil end
    clip.comments = {}
    return clip
end

-- ============================================
-- СЕРИАЛИЗАЦИЯ КОММЕНТОВ
-- ============================================
local function serialize_comments(comments)
    local lines = {}
    for _, c in ipairs(comments or {}) do
        local col = c.color or {1,1,1}
        lines[#lines + 1] = string.format("%s|%s|%.2f,%.2f,%.2f|%s",
            c.nick or "?", c.text or "?", col[1], col[2], col[3], c.time or "")
    end
    return table.concat(lines, "\n")
end

local function deserialize_comments(content)
    local comments = {}
    if not content then return comments end
    for line in content:gmatch("[^\r\n]+") do
        local nick, text, col, time = line:match("^(.-)|(.-)|(.-)|(.*)$")
        if nick then
            local r, g, b = col:match("([%d%.]+),([%d%.]+),([%d%.]+)")
            table.insert(comments, {
                nick = nick, text = text,
                color = { tonumber(r) or 1, tonumber(g) or 1, tonumber(b) or 1 },
                time = time,
            })
        end
    end
    return comments
end

-- ============================================
-- СОЗДАНИЕ КЛИПА
-- ============================================
function G.jokerstream_clips.create(clip_type, data)
    data = data or {}
    local slot = G.jokerstream_clips.next_slot
    G.jokerstream_clips.next_slot = (slot % G.jokerstream_clips.max_clips) + 1

    local id = string.format("clip_%02d", slot)

    local cards = {}
    if data.hand and data.hand.cards then
        for _, c in ipairs(data.hand.cards) do
            local rank = c:get_id() or 0
            local suit = (c.base and c.base.suit) or "?"
            local enh = (c.config and c.config.center and c.config.center.key) or "none"
            table.insert(cards, rank .. "|" .. suit .. "|" .. enh)
        end
    end

    local jokers = {}
    local jokers_total = 0
    local jokers_activated = 0
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            jokers_total = jokers_total + 1
            local key = (j.config and j.config.center and j.config.center.key) or "?"
            local ed = (j.edition and j.edition.key) or "none"
            table.insert(jokers, key .. "|" .. ed)
        end
    end
    if data.jokers_activated_count then
        jokers_activated = data.jokers_activated_count
    end

    local mult = clips_pop_mult()

    local clip = {
        id = id,
        slot = slot,
        type = clip_type,
        title = data.title or clip_type,
        created_at = os.date("%Y-%m-%d %H:%M:%S"),
        ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 0,
        round = (G.GAME and G.GAME.round and G.GAME.round) or 0,
        blind = (G.GAME and G.GAME.blind and G.GAME.blind.name) or "",
        score = data.score or (G.GAME and G.GAME.chips) or 0,
        hand_name = data.hand_name or "",
        views = math.floor(math.random(0, 30) * mult),
        likes = 0,
        subs_earned = 0,
        cards = cards,
        jokers = jokers,
        jokers_total = jokers_total,
        jokers_activated = jokers_activated,
        hands_left = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left) or 0,
        discards_left = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0,
        comments = {},
    }
    clip.likes = math.floor(clip.views / 3) + math.floor(math.random(0, 130) * mult)

    local initial_comments = math.random(2, 6)
    for i = 1, initial_comments do
        table.insert(clip.comments, {
            nick = pick_comment_nick(),
            text = pick_comment_text(),
            color = pick_comment_color(),
            time = os.date("%H:%M:%S"),
        })
    end

    ensure_dirs()
    write_file(id .. ".txt", serialize_clip(clip))
    write_file(id .. "_comments.txt", serialize_comments(clip.comments))

    pcall(function()
        love.graphics.captureScreenshot(function(imageData)
            local fd = imageData:encode("png")
            local bytes = fd:getString()
            if NFS then
                pcall(NFS.write, CLIPS_DIR_NFS .. "/" .. id .. ".png", bytes)
            end
            pcall(love.filesystem.write, CLIPS_DIR_LFS .. "/" .. id .. ".png", bytes)
            print("[JOKER STREAM] Clip preview saved:", id .. ".png")
        end)
    end)

    local replaced = false
    for i, c in ipairs(G.jokerstream_clips.list) do
        if c.slot == slot then
            G.jokerstream_clips.list[i] = clip
            replaced = true
            break
        end
    end
    if not replaced then
        table.insert(G.jokerstream_clips.list, clip)
    end

    local subs = G.jokerstream_clips.calculate_subs(clip)
    if subs > 0 then
        clip.subs_earned = subs
        write_file(id .. ".txt", serialize_clip(clip))
        if G.jokerstream_channel and G.jokerstream_channel.add_subs then
            G.jokerstream_channel.add_subs(subs)
        end
        print("[JOKER STREAM] Clip created:", id, clip.title, "| +" .. subs .. " subs")
    else
        print("[JOKER STREAM] Clip created:", id, clip.title, "| no subs (roll failed)")
    end

    return clip
end

-- ============================================
-- ФОРМУЛА САБОВ
-- ============================================
function G.jokerstream_clips.calculate_subs(clip)
    if math.random(1, 3) ~= 1 then return 0 end

    local level = 0
    if G.jokerstream_get_level then
        level = G.jokerstream_get_level()
    elseif G.jokerstream_channel then
        local subs = G.jokerstream_channel.subs or 0
        if G.jokerstream_milestones then
            for _, m in ipairs(G.jokerstream_milestones) do
                if subs >= m.subs then level = level + 1 end
            end
        end
    end

    local base = 30 + math.floor(level * 4.7)

    local hand_bonus    = (clip.hands_left or 0) * 5
    local discard_bonus = (clip.discards_left or 0) * 3

    local condition_bonus = 0
    if clip.jokers_total > 0 and clip.jokers_activated >= clip.jokers_total then
        condition_bonus = condition_bonus + 20
    end
    if clip.hand_name == "Straight Flush"
       or clip.hand_name == "Five of a Kind"
       or clip.hand_name == "Flush House"
       or clip.hand_name == "Flush Five" then
        condition_bonus = condition_bonus + 15
    end
    if (clip.score or 0) >= 100000 then
        condition_bonus = condition_bonus + 30
    end
    if clip.type == "victory" then
        condition_bonus = condition_bonus + 50
    end

    local total = base + hand_bonus + discard_bonus + condition_bonus
    return total
end

-- ============================================
-- ПРОСМОТР КЛИПА
-- ============================================
function G.jokerstream_clips.view(id)
    for _, clip in ipairs(G.jokerstream_clips.list) do
        if clip.id == id then
            local mult = clips_pop_mult()
            clip.views = clip.views + math.floor(math.random(2, 3) * mult)
            clip.likes = clip.likes + math.floor(math.random(0, 5) * mult)

            local n = math.random(1, 5)
            for i = 1, n do
                table.insert(clip.comments, {
                    nick = pick_comment_nick(),
                    text = pick_comment_text(),
                    color = pick_comment_color(),
                    time = os.date("%H:%M:%S"),
                })
            end

            write_file(id .. ".txt", serialize_clip(clip))
            write_file(id .. "_comments.txt", serialize_comments(clip.comments))
            return clip
        end
    end
    return nil
end

-- ============================================
-- ПАССИВНЫЙ РОСТ
-- ============================================
function G.jokerstream_clips.passive_tick(dt)
    G.jokerstream_clips.passive_timer = G.jokerstream_clips.passive_timer + dt

    if G.jokerstream_clips.passive_timer >= 300 then
        G.jokerstream_clips.passive_timer = 0

        local mult = clips_pop_mult()
        for _, clip in ipairs(G.jokerstream_clips.list) do
            clip.views = clip.views + math.floor(math.random(5, 25) * mult)
            clip.likes = clip.likes + math.floor(math.random(0, 8) * mult)

            if math.random(1, 3) == 1 then
                table.insert(clip.comments, {
                    nick = pick_comment_nick(),
                    text = pick_comment_text(),
                    color = pick_comment_color(),
                    time = os.date("%H:%M:%S"),
                })
            end

            write_file(clip.id .. ".txt", serialize_clip(clip))
            write_file(clip.id .. "_comments.txt", serialize_comments(clip.comments))
        end
    end
end

-- ============================================
-- ЗАГРУЗКА ПРИ СТАРТЕ
-- ============================================
function G.jokerstream_clips.load()
    ensure_dirs()
    G.jokerstream_clips.list = {}
    G.jokerstream_clips.next_slot = 1

    for slot = 1, G.jokerstream_clips.max_clips do
        local id = string.format("clip_%02d", slot)
        local content = read_file(id .. ".txt")
        if content then
            local clip = deserialize_clip(content)
            if clip then
                local comments_content = read_file(id .. "_comments.txt")
                clip.comments = deserialize_comments(comments_content)
                table.insert(G.jokerstream_clips.list, clip)
                G.jokerstream_clips.next_slot = (slot % G.jokerstream_clips.max_clips) + 1
            end
        end
    end

    local mult = clips_pop_mult()
    for _, clip in ipairs(G.jokerstream_clips.list) do
        clip.views = clip.views + math.floor(math.random(20, 150) * mult)
        clip.likes = math.floor(clip.views / 3) + math.floor(math.random(0, 130) * mult)
        write_file(clip.id .. ".txt", serialize_clip(clip))
    end

    print("[JOKER STREAM] Clips loaded:", #G.jokerstream_clips.list,
          "| next slot:", G.jokerstream_clips.next_slot)
end

G.jokerstream_clips.load()