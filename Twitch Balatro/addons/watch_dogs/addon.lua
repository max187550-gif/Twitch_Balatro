-- ============================================
-- ADDON: Watch Dogs — Hacker Console v3.34
-- ============================================

local ADDON = {}
ADDON.meta = {
    key = "watch_dogs", name = "Watch Dogs", author = "karal",
    version = "3.34.0", desc = "Hacker console — dead code edition",
    icon = "WD",
    icon_path = "watcher.png",
}

ADDON.tab_flash = 0
ADDON.tab_plus_amount = 0
ADDON.tab_plus_timer = 0
ADDON.tab_rect = nil

ADDON.up_cmds = { "search", "codes" }
ADDON.up_index = 0
ADDON.down_cmds = { "plug socks_", "plug proxy_", "plug vm_", "plug ctos_", "plug blume_" }
ADDON.down_index = 0

local CLR = {
    green = {0.30, 1.00, 0.35}, green_dim = {0.20, 0.70, 0.25},
    turquoise = {0.35, 0.95, 0.95}, yellow = {1.00, 0.90, 0.25},
    red = {1.00, 0.35, 0.35}, grey = {0.60, 0.65, 0.60},
    bagley = {1.00, 0.55, 0.20}, purple = {0.75, 0.45, 1.00},
    gold = {1.00, 0.85, 0.30}, blue = {0.35, 0.65, 1.00},
    dark_red = {0.85, 0.15, 0.15}, strike = {0.85, 0.30, 0.30},
    dead = {0.55, 0.25, 0.35},
}

local PURITY = {
    [1] = { name = "Noisy",     color = CLR.grey,      prefix = "socks", trojan_chance = 0.20, roll_chance = 0.40, reduce = 0.10, instant_dmg = 0.05, bonus_count = 1 },
    [2] = { name = "Static",    color = CLR.green,     prefix = "proxy", trojan_chance = 0.12, roll_chance = 0.30, reduce = 0.25, instant_dmg = 0.10, bonus_count = 1 },
    [3] = { name = "Clear",     color = CLR.turquoise, prefix = "vm",    trojan_chance = 0.06, roll_chance = 0.20, reduce = 0.50, instant_dmg = 0.20, bonus_count = 2 },
    [4] = { name = "Encrypted", color = CLR.blue,      prefix = "ctos",  trojan_chance = 0.02, roll_chance = 0.08, reduce = 0.75, instant_dmg = 0.35, bonus_count = 3 },
    [5] = { name = "Blume",     color = CLR.purple,    prefix = "blume", trojan_chance = 0.00, roll_chance = 0.02, reduce = 0.99, instant_dmg = 0.50, bonus_count = 4 },
}

local SIGNATURE_CODES = {
    "noblume_", "deadsec_2.0", "1+1=game_over", "123456788",
    "my_cat", "server", "i'm god", "1337", "333_333_666_666", "123_213_321",
}
local SIGNATURE_CHANCE = 0.05

local TROJAN_MOCK = {
    "Trojan detected. Skill issue, honestly.",
    "You got scammed. By me. Feelings?",
    "Wow, that's embarrassing. Even for you.",
    "I'd say I'm sorry, but I'd be lying.",
}
local TROJAN_PITY = {
    "Ouch. Sorry, mate. Genuinely.",
    "That was... unlucky. I'd blame the game.",
    "Don't cry. It's just pixels.",
    "Well, that happened. Better luck next time.",
}
local TROJAN_MIXED = {
    "Trojan detected. I feel nothing. Well, maybe a little.",
    "Your codes are trash. Fix that.",
    "Blume sends their regards.",
    "I felt bad for a second. Then I didn't.",
}

function G.jokerstream_wd_purity_bonus()
    if not G.jokers or not G.jokers.cards then return 0 end
    local bonus = 0
    for _, j in ipairs(G.jokers.cards) do
        local key = j.config and j.config.center and j.config.center.key
        if key == "j_jokerstream_we_xs3w" then
            bonus = bonus + (j.ability.extra.purity_boost or 0.10)
        elseif key == "j_jokerstream_processor_sergey" then
            bonus = bonus + (j.ability.extra.purity_boost or 0.70)
        end
    end
    return bonus
end

function G.jokerstream_wd_trojan_reduce()
    if not G.jokers or not G.jokers.cards then return 0 end
    local reduce = 0
    for _, j in ipairs(G.jokers.cards) do
        local key = j.config and j.config.center and j.config.center.key
        if key == "j_jokerstream_decrypt_me" then
            reduce = reduce + (j.ability.extra.trojan_reduce or 0.25)
        elseif key == "j_jokerstream_secret_path_recruit" then
            reduce = reduce + 0.10
        elseif key == "j_jokerstream_server_ghost" then
            reduce = reduce + 0.15
        elseif key == "j_jokerstream_dead_archive" then
            reduce = reduce + 0.20
        elseif key == "j_jokerstream_karma_for_deed" then
            reduce = reduce - 0.15
        end
    end
    if G.GAME and G.GAME.current_round then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == "j_jokerstream_anonymity" then
                reduce = reduce + ((j.ability.extra.eights_played_this_round or 0) * 0.05)
            end
        end
    end
    return reduce
end

ADDON.our_source_ids = {}

local function mark_as_ours(src)
    if not src then return end
    pcall(function() src._wd_our = true end)
    pcall(function()
        local id = tostring(src)
        if id then ADDON.our_source_ids[id] = true end
    end)
end

local function is_our_music(src)
    if not src then return false end
    if src == ADDON.console_music then return true end
    if src == ADDON.hack_sound then return true end
    if src == ADDON.success_sound then return true end
    if src == ADDON.fail_sound then return true end
    if src == ADDON.energy_sound then return true end
    if src == ADDON.tip_sound then return true end
    if src == ADDON.bsi_music then return true end
    if src == G.wd_mg_theme then return true end
    if src._wd_our then return true end
    if src._wd_console_music then return true end
    if ADDON.console_music_id then
        local ok, id = pcall(tostring, src)
        if ok and id == ADDON.console_music_id then return true end
    end
    if ADDON.our_source_ids then
        local ok, id = pcall(tostring, src)
        if ok and id and ADDON.our_source_ids[id] then return true end
    end
    return false
end

local function mute_game_music()
    if not G.SETTINGS or not G.SETTINGS.SOUND then return end
    if ADDON._saved_music_volume == nil then
        ADDON._saved_music_volume = G.SETTINGS.SOUND.music_volume or 1
    end
    G.SETTINGS.SOUND.music_volume = 0
    if G.SOUND_MANAGER then
        pcall(function() G.SOUND_MANAGER.music_vol = 0 end)
    end
end

local function unmute_game_music()
    if not G.SETTINGS or not G.SETTINGS.SOUND then return end
    if ADDON._saved_music_volume ~= nil then
        G.SETTINGS.SOUND.music_volume = ADDON._saved_music_volume
        ADDON._saved_music_volume = nil
    end
    if G.SOUND_MANAGER then
        pcall(function()
            if G.SETTINGS and G.SETTINGS.SOUND then
                G.SOUND_MANAGER.music_vol = G.SETTINGS.SOUND.music_volume or 1
            end
            if G.SOUND_MANAGER.cur_music and G.SOUND_MANAGER.cur_music.source then
                local src = G.SOUND_MANAGER.cur_music.source
                if src.setVolume then
                    src:setVolume(G.SETTINGS.SOUND.music_volume or 1)
                end
                if src.isPlaying and not src:isPlaying() then
                    pcall(function() src:play() end)
                end
            end
        end)
    end
end

ADDON.bg_image = nil
ADDON.bg_loaded = false

local function get_mod_path()
    local MOD_PATH = G.jokerstream_mod_path
    if not MOD_PATH and SMODS and SMODS.current_mod then
        MOD_PATH = SMODS.current_mod.path
    end
    if not MOD_PATH then
        MOD_PATH = love.filesystem.getSaveDirectory() .. "/Mods/Twitch Balatro"
    end
    return MOD_PATH:gsub("\\", "/"):gsub("/+$", "")
end

local function load_console_bg()
    if ADDON.bg_loaded then return ADDON.bg_image end
    ADDON.bg_loaded = true
    local MOD_PATH = get_mod_path()
    local paths = { "assets/icons/console_bg.png", "assets/console_bg.png", "console_bg.png" }
    for _, p in ipairs(paths) do
        if love.filesystem.getInfo and love.filesystem.getInfo(p) then
            local ok, img = pcall(love.graphics.newImage, p)
            if ok and img then
                ADDON.bg_image = img
                return img
            end
        end
    end
    if NFS and MOD_PATH ~= "" then
        for _, p in ipairs({ MOD_PATH .. "/assets/icons/console_bg.png", MOD_PATH .. "/assets/console_bg.png" }) do
            local ok, bytes = pcall(NFS.read, p)
            if ok and bytes and #bytes > 0 then
                local fd = love.filesystem.newFileData(bytes, "console_bg.png")
                local ok2, img = pcall(love.graphics.newImage, fd)
                if ok2 and img then
                    ADDON.bg_image = img
                    return img
                end
            end
        end
    end
    return nil
end

local function load_our_sound(name, looping, volume)
    local MOD_PATH = get_mod_path()

    local rel_paths = {
        "assets/sounds/" .. name .. ".ogg",
        "assets/sounds/" .. name .. ".mp3",
        "sounds/" .. name .. ".ogg",
        name .. ".ogg",
    }
    for _, p in ipairs(rel_paths) do
        if love.filesystem.getInfo and love.filesystem.getInfo(p) then
            local ok, src = pcall(love.audio.newSource, p, "stream")
            if ok and src then
                src:setLooping(looping or false)
                src:setVolume(volume or 0.5)
                mark_as_ours(src)
                return src
            end
        end
    end
    if NFS and MOD_PATH ~= "" then
        for _, p in ipairs({
            MOD_PATH .. "/assets/sounds/" .. name .. ".ogg",
            MOD_PATH .. "/assets/sounds/" .. name .. ".mp3",
            MOD_PATH .. "/sounds/" .. name .. ".ogg",
        }) do
            local ok, bytes = pcall(NFS.read, p)
            if ok and bytes and #bytes > 0 then
                local ext = p:match("%.([^%.]+)$") or "ogg"
                local fd = love.filesystem.newFileData(bytes, name .. "." .. ext)
                local ok2, src
                if ext == "mp3" then
                    ok2, src = pcall(love.audio.newSource, fd, "stream")
                else
                    local sd = love.sound.newSoundData(fd)
                    ok2, src = pcall(love.audio.newSource, sd)
                    if not ok2 then ok2, src = pcall(love.audio.newSource, fd, "stream") end
                end
                if ok2 and src then
                    src:setLooping(looping or false)
                    src:setVolume(volume or 0.5)
                    mark_as_ours(src)
                    return src
                end
            end
        end
    end
    return nil
end
ADDON.load_our_sound = load_our_sound

ADDON.console_music = nil
ADDON.music_loaded = false
ADDON.music_playing = false
ADDON.music_volume = 0.6
ADDON.console_music_id = nil

local function load_console_music()
    if ADDON.music_loaded then return ADDON.console_music end
    ADDON.music_loaded = true
    ADDON.console_music = load_our_sound("console_music", true, ADDON.music_volume)
    if ADDON.console_music then
        pcall(function()
            ADDON.console_music._wd_console_music = true
            ADDON.console_music_id = tostring(ADDON.console_music)
        end)
    end
    return ADDON.console_music
end

ADDON.bsi_music = nil
ADDON.bsi_loaded = false
local function load_bsi_music()
    if ADDON.bsi_loaded then return ADDON.bsi_music end
    ADDON.bsi_loaded = true
    ADDON.bsi_music = load_our_sound("bsi_theme", true, 0.8)
    return ADDON.bsi_music
end

ADDON.hack_sound = nil
ADDON.hack_loaded = false
local function load_hack_sound()
    if ADDON.hack_loaded then return ADDON.hack_sound end
    ADDON.hack_loaded = true
    ADDON.hack_sound = load_our_sound("hack", true, 0.5)
    return ADDON.hack_sound
end

ADDON.success_sound = nil
ADDON.success_loaded = false
local function load_success_sound()
    if ADDON.success_loaded then return ADDON.success_sound end
    ADDON.success_loaded = true
    ADDON.success_sound = load_our_sound("success", false, 0.7)
    return ADDON.success_sound
end

ADDON.fail_sound = nil
ADDON.fail_loaded = false
local function load_fail_sound()
    if ADDON.fail_loaded then return ADDON.fail_sound end
    ADDON.fail_loaded = true
    ADDON.fail_sound = load_our_sound("fail", false, 0.7)
    return ADDON.fail_sound
end

ADDON.energy_sound = nil
ADDON.energy_loaded = false
local function load_energy_sound()
    if ADDON.energy_loaded then return ADDON.energy_sound end
    ADDON.energy_loaded = true
    ADDON.energy_sound = load_our_sound("energy", false, 0.7)
    return ADDON.energy_sound
end

ADDON.tip_sound = nil
ADDON.tip_loaded = false
local function load_tip_sound()
    if ADDON.tip_loaded then return ADDON.tip_sound end
    ADDON.tip_loaded = true
    ADDON.tip_sound = load_our_sound("tip", false, 0.7)
    return ADDON.tip_sound
end

local function install_hard_audio_hook()
    if ADDON._audio_hooked then return end
    ADDON._audio_hooked = true
    local orig_love_play = love.audio.play
    ADDON.orig_love_play = orig_love_play

    function love.audio.play(src, ...)
        if is_our_music(src) then
            return orig_love_play(src, ...)
        end
        if ADDON.console and ADDON.console.open then
            pcall(function() src:setVolume(0) end)
            return
        end
        return orig_love_play(src, ...)
    end
    local orig_new_source = love.audio.newSource
    ADDON.orig_newSource = orig_new_source

    function love.audio.newSource(...)
        local src = orig_new_source(...)
        if is_our_music(src) then return src end
        if ADDON.console and ADDON.console.open then
            pcall(function() src:setVolume(0) end)
        end
        return src
    end
end

local _vanilla_sources_snapshot = {}

local function snapshot_vanilla_sources()
    _vanilla_sources_snapshot = {}
    if not G.SOUND_MANAGER then return end
    pcall(function()
        local m = G.SOUND_MANAGER.cur_music
        if m and m.source and not is_our_music(m.source) then
            table.insert(_vanilla_sources_snapshot, m.source)
        end
    end)
    pcall(function()
        local ch = G.SOUND_MANAGER.channel
        if type(ch) == "table" then
            for _, c in ipairs(ch) do
                if c and c.source and not is_our_music(c.source) then
                    table.insert(_vanilla_sources_snapshot, c.source)
                end
            end
        end
    end)
end

local function stop_vanilla_music()
    if not G.SOUND_MANAGER then return end
    if ADDON._vanilla_music_vol == nil then
        ADDON._vanilla_music_vol = G.SOUND_MANAGER.music_vol or 1
    end
    snapshot_vanilla_sources()
    mute_game_music()
    pcall(function()
        G.SOUND_MANAGER.vol = 0
        G.SOUND_MANAGER.music_vol = 0
        G.SOUND_MANAGER.sound_vol = 0
    end)
    for _, src in ipairs(_vanilla_sources_snapshot) do
        if not is_our_music(src) then
            pcall(function() src:setVolume(0) end)
        end
    end
end

local function restore_vanilla_music()
    if not G.SOUND_MANAGER then return end
    unmute_game_music()
    pcall(function()
        G.SOUND_MANAGER.vol = 1
        G.SOUND_MANAGER.music_vol = ADDON._vanilla_music_vol or 1
        G.SOUND_MANAGER.sound_vol = ADDON._vanilla_music_vol or 1
    end)
    for _, src in ipairs(_vanilla_sources_snapshot) do
        if not is_our_music(src) then
            pcall(function() src:setVolume(ADDON._vanilla_music_vol or 1) end)
        end
    end
end

local function utf8_len(s)
    if not s then return 0 end
    s = tostring(s)
    local count, i, len = 0, 1, #s
    while i <= len do
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

local function utf8_sub(s, n)
    if not s or n <= 0 then return "" end
    s = tostring(s)
    local count, i, len = 0, 1, #s
    while i <= len and count < n do
        local b = s:byte(i)
        if b < 0x80 then i = i + 1
        elseif b < 0xC0 then i = i + 1
        elseif b < 0xE0 then i = i + 2
        elseif b < 0xF0 then i = i + 3
        else i = i + 4 end
        count = count + 1
    end
    return s:sub(1, math.min(i - 1, len))
end

local function utf8_remove_last(s)
    if not s or #s == 0 then return "" end
    local i = #s
    while i > 0 do
        local b = s:byte(i)
        if b >= 0x80 and b < 0xC0 then i = i - 1
        else return s:sub(1, i - 1) end
    end
    return ""
end

local function get_blind_key(blind)
    if not blind or not blind.config or not blind.config.blind then return "unknown" end
    return blind.config.blind.key or "unknown"
end
local function get_current_blind_uid()
    if not G.GAME or not G.GAME.blind then return "none" end
    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    return ante .. ":" .. get_blind_key(G.GAME.blind)
end

local HUMOR_TRASH = {
    "Ask your mom how to hack.", "That's not a command. That's a dance on the keyboard.",
    "I'm not Harry Potter. Spells don't work here.", "My grandma has the same password. Try harder.",
    "Five characters? Wow, progress. No.", "Type 'help'. It's a command that shows commands.",
    "Are you typing or having a seizure?", "I thought about it. No.",
    "You know, I don't understand you. And honestly, I don't want to.",
    "Oh wow, you can type! Send your mom a screenshot.",
    "Is that a code? Or did your cat walk on the keyboard?",
    "Fascinating. Very. No.", "I'd help you, but I'm busy thinking about myself.",
    "I think you meant 'help'. You missed. Nine times.",
    "I don't have an 'understand this nonsense' function.",
    "Let's make a deal: you type 'help', I pretend I didn't see this shame.",
    "You're not a hacker. You're a user. Barely that.", "I need a vacation. From you.",
    "You know what? Try 'help'. Can't get worse.",
    "Ok. And what am I supposed to do with this?",
}
local HUMOR_SPECIAL = {
    gg = { { "I'll ", CLR.bagley }, { "gg", CLR.yellow },
           { " your mom in Fortnite. Here we type ", CLR.bagley },
           { "close", CLR.green }, { ".", CLR.bagley } },
    ez = { { "You won? You're a sack. ", CLR.bagley },
           { "I'm the smartest system ever, and I ended up with you :(", CLR.bagley } },
    sex = { { "Dude, I'm not a sex machine. ", CLR.bagley }, { "Go find a woman.", CLR.bagley } },
    wp = { { "Well Played. You're not Well. You're not Played.", CLR.bagley } },
    sudo = { { "You're not on Linux, dude. ", CLR.bagley }, { "And I won't give you root.", CLR.yellow } },
    su = { { "su who? su you. Funny.", CLR.bagley } },
    ping = { { "pong. Bored much?", CLR.bagley } },
    respawn = { { "You're in Balatro. There's no respawn here. ", CLR.bagley }, { "Only suffering.", CLR.grey } },
    mine = { { "This isn't Minecraft. ", CLR.bagley }, { "Though, you know... ", CLR.bagley },
             { "search", CLR.green }, { " is also about resources.", CLR.bagley } },
    craft = { { "Craft? You buy jokers here, not craft them.", CLR.bagley } },
    debug = { { "You're debug yourself, honestly.", CLR.bagley } },
    hi = { { "Oh, a live human. Hey. ", CLR.bagley }, { "I hope you're smarter than the previous one.", CLR.grey } },
    hello = { { "Hello. HELLO. ", CLR.bagley }, { "I hear you the first time.", CLR.grey } },
    hey = { { "Hey yourself. What do you want?", CLR.bagley } },
    thanks = { { "You're welcome. You could've typed ", CLR.bagley }, { "plug", CLR.green }, { " instead. But ok.", CLR.bagley } },
    thx = { { "thx for what? You didn't do anything.", CLR.bagley } },
    fuck = { { "Whoa, profanity. Reporting to Blume.", CLR.red } },
    shit = { { "Watch your language. ", CLR.bagley }, { "I'm recording everything.", CLR.grey } },
    karal = "karal_ascii", karl = "karal_ascii", author = "karal_ascii",
}

local PC_TIPS = {
    "Did you know that not keeping a million tabs open gives you more FPS in games?",
    "Better update your drivers on time — your PC will run better.",
    "So when are you going to activate Windows?",
    "Don't like my tips? Leave 1 star. Oh wait, there's no rating. So you'll just shut up.",
    "Don't forget to clean your PC.",
    "Did you know that if you set a complex network password, few people will use it?",
    "Get Tor Browser. It's better than Microsoft Edge — at least it doesn't send your data to me.",
    "You don't need 'system optimizers'. Better learn to do it yourself — your PC will thank you.",
    "Better not overclock your CPU to 4 GHz. I think the wiring won't hold.",
    "Remember: Windows and a window are different things. One is an OS, the other is a translator of your personal life.",
    "Delete the 400 GB of memes. I see you.",
    "You have 47 icons on your desktop. This isn't a file manager, it's a maze.",
    "You have three antiviruses. That's two too many, and they hate each other.",
    "Your CPU is at 90°C. That's not 'warm', that's a sauna.",
    "Your cooler sounds like a jet engine. It's trying to fly away.",
    "Get an SSD. HDD is for nostalgia, not gaming.",
    "Your resolution is 800x600. It's 2026. Buy a monitor.",
    "Turn off RGB. It won't make you faster. Just brighter.",
    "Clean your fans. Cat hair doesn't help performance.",
    "Your hard drive is clicking. That's not a feature. That's a countdown.",
    "Your PC is silent. Either it's dead or mining Bitcoin.",
    "Your screen is dirty. It's not a window, it's a display.",
    "Change thermal paste once a year. Not once in a lifetime.",
    "If your laptop is on a blanket — it's suffocating. It's not a pillow.",
    "A 60 Hz monitor isn't bad. Bad is lying that you have 144.",
    "Your 300W PSU won't handle a new GPU. Accept it.",
    "Don't put your PC on a carpet. It's not a cat.",
    "A case without airflow is a microwave.",
    "Your SSD is 95% full. It's dying, and you don't notice.",
    "4K on a 15-inch screen is an insult to your eyes.",
    "Buy a proper desk. Your back will thank you, I won't.",
    "If the cooler is installed crooked — it's noisy for a reason.",
    "You can't 'download more RAM'. I know you tried.",
    "If your PC boots in 5 minutes — that's not normal. That's a diagnosis.",
    "A $1 mouse isn't saving money, it's a path to arthritis.",
    "A mechanical keyboard in the office isn't cool, it's war with neighbors.",
    "Two monitors aren't luxury. It's the norm. Time to get one.",
    "Buy a proper mousepad. Your desk isn't a mousepad.",
    "Check your capacitors. Bulging ones aren't 'style'.",
    "Thermal paste isn't infinite. Stop spreading it like cream.",
    "If your PC reboots itself — that's not a feature. That's a warning.",
    "Don't touch RAM contacts with your fingers. You're not a nanorobot.",
    "Windows Defender is fine. Everything else is from the devil.",
    "A Windows license isn't luxury. And yes, you don't have one.",
    "Don't turn off updates. You won't understand what broke later.",
    "The hosts file isn't a toy. You can hurt yourself there.",
    "Don't run .exe from an email from 'the bank'. You didn't win a million.",
    "System Restore isn't for paranoids. It's like a first aid kit.",
    "Don't delete System32. Even if you saw a guide.",
    "The registry isn't a notepad for experiments.",
    "Backup before updating. It's a rule, not a tip.",
    "A shortcut isn't a file. Deleting a shortcut doesn't delete the program.",
    "Startup isn't a dump. Clean it up.",
    "Check your timezone. Your clock is behind again.",
    "A BIOS password isn't paranoia. It's hygiene.",
    "Fast Startup isn't always good. And yes, you didn't know.",
    "If you have 5 'Windows activators' — at least 4 of them are viruses.",
    "Check your disk for errors. Smart or not — CHKDSK will tell you.",
    "Turn off Cortana. You don't use it.",
    "One antivirus. ONE. Remember it already.",
    "Set up a separate disk for games. C: isn't for everything.",
    "Windows Marketplace is also a source of viruses. Surprised?",
    "Your router rebooting? Means you haven't turned it off for 3 years.",
    "Wi-Fi password '12345678' is an invitation to neighbors.",
    "Run a speedtest. You pay for 500 Mbps and get 30.",
    "VPN isn't for pirates. It's for normal people too.",
    "Your router is behind a cabinet in the wall. It's suffocating.",
    "5 GHz is faster but reaches worse. Yes, physics is a pain.",
    "Don't hotspot your phone to the whole house. You're not an ISP.",
    "An ADSL modem isn't retro, it's time to change.",
    "Don't lay the cable under your feet. It doesn't tolerate it.",
    "PowerLine network is also an option. Discover it.",
    "Wi-Fi name 'FBI Surveillance Van' isn't funny anymore. Been 15 years.",
    "The router broadcasts — so it has a password. Check it's not 'admin'.",
    "Check who else is on your network. A smart router will show.",
    "WPA3 exists. Use it. Or don't complain.",
    "DNS from your ISP? Switch to 1.1.1.1. The world gets faster.",
    "VLC plays everything. Don't install 5 players.",
    "Notepad doesn't replace Word. Just accept it.",
    "Check what's in 'open with'. It's a mess in there.",
    "One program — one task. Don't install 3 browsers.",
    "Firefox and Chrome are both fine. Opera GX isn't for gamers, it's marketing.",
    "Stop updating everything at once. One by one.",
    "An installer from a torrent isn't the original. Don't make me laugh.",
    "A program from a site with 2 downloads is a virus. Open your eyes.",
    "The free antivirus from Avast sells your data. Yes, seriously.",
    "Windows Media Player is still alive. Like your grandpa.",
    "You don't know hotkeys. I do. It hurts me.",
    "F5 is page refresh. Not PC restart.",
    "Ctrl+Shift+Esc — opens Task Manager fast. Learn it already.",
    "Win+L — lock. Learn to leave your PC properly.",
    "Alt+Tab isn't a Windows 11 feature. It's 30 years old.",
    "Win+V — clipboard history. Yes, it exists.",
    "Screenshot — Win+Shift+S. Learn it, finally.",
    "Notepad++ isn't for programmers. It's for normal people.",
    "7-Zip is free. WinRAR trial has been a lie for 20 years.",
    "Stop downloading 'clean' Windows builds. You don't know what's there.",
    "Change your email password. 'qwerty' is 2010.",
    "Come up with 3 different passwords. Not one for everything.",
    "Antivirus won't save you from yourself.",
    "You click everything. I see it. I see everything.",
    "Scammers with accents aren't Indians, they're criminals. Don't fall for it.",
    "Don't open PDFs from strangers. There could be a surprise inside.",
    "Online casino 'with withdrawal' isn't a casino, it's a pocket for you.",
    "Downloaded cracked Photoshop — got a bonus. A miner.",
    "Your browser collects data. And yes, so do I.",
    "If they write 'I'm from security service' — it's a lie.",
    "Enable 'show file extensions'. Did you see '.jpg.exe'?",
    "Don't enter passwords on 'http://' sites. Only 'https://'.",
    "Build a habit: once a month — clean your PC, both morally and physically.",
    "Smile. Maybe you actually care that I exist.",
    "Check notifications. You don't read them, then 'nothing worked'.",
    "Go sleep. Seriously. I work better when you rest.",
    "Want to turn me off? Type 'close'. Well, try.",
    "And remember: I'm the only smart system that tells you anything. Appreciate it.",
    "Buy a UPS. One power outage — and your SSD becomes a paperweight.",
    "Don't smoke near your PC. Fans love tar.",
    "A cat on a keyboard is cute. Once. Then it's a support ticket.",
    "Don't install 5 toolbars in your browser. It's not 2005.",
    "If you hear a beep code — count it. It's telling you something.",
    "Your PSU is 10 years old. It might explode. Just saying.",
    "Don't run 3 games at once. Your RAM is not infinite.",
    "If your GPU fans are silent during gaming — check if it's plugged in.",
    "Do a backup before installing Windows. I can't count how many times.",
    "Buy a real surge protector. Not that $2 extension cord.",
    "Your monitor has a 'game mode'. Turn it on. Seriously.",
    "Driver cleaner software is a scam. Windows handles it.",
    "Don't disable your pagefile because it's slow. It's there for a reason.",
    "Check your RAM speed in BIOS. It's probably at 2133. Enable XMP.",
    "Your cable management is a crime scene. Do something.",
    "A gaming chair won't make you a better player. A proper monitor might.",
    "If your PC has RGB RAM — I question your priorities. But ok.",
    "Cheap PSU = dead PC. Don't save on it. Ever.",
    "If a game stutters — check RAM usage. It's probably maxed.",
    "Don't buy prebuilds from unknown sites. They save on everything.",
    "Check the intake fans direction. Some people install them backwards.",
    "Air cooler > AIO unless you have money to burn.",
    "Liquid metal is not for beginners. Don't even try.",
    "Don't use 2 monitors with different refresh rates if you can avoid it. It causes stutter.",
    "Check that your SSD is in AHCI, not IDE. You're losing speed.",
    "If your PC has startup issues — check the GPU. Reseat it.",
    "Turn off fast boot in BIOS if you have troubles. Sometimes it helps.",
    "Your BIOS is outdated. Update it. Carefully.",
    "Don't move your PC while it's on. Disks don't like that.",
    "Clean your peripherals. Not just the monitor. The whole desk.",
    "If something smells like burning — turn everything off. Now.",
    "Don't use registry cleaners. They clean your wallet.",
    "And last one: reboot and take a walk. Seriously. Your PC will be fine.",
}

ADDON._karal_ascii_cache = nil
local function load_karal_ascii()
    if ADDON._karal_ascii_cache then return ADDON._karal_ascii_cache end

    local MOD_PATH = get_mod_path()

    local paths = {
        MOD_PATH .. "/addons/watch_dogs/karal_ascii.txt",
        "Mods/Twitch Balatro/addons/watch_dogs/karal_ascii.txt",
        "mods/Twitch Balatro/addons/watch_dogs/karal_ascii.txt",
        "addons/watch_dogs/karal_ascii.txt",
        MOD_PATH .. "/karal_ascii.txt",
        MOD_PATH .. "/assets/karal_ascii.txt"
    }

    local data
    local tried = {}
    for _, p in ipairs(paths) do
        table.insert(tried, p)
        if NFS then
            local ok, bytes = pcall(NFS.read, p)
            if ok and bytes and bytes ~= "" then data = bytes; break end
        end
        local ok2, bytes2 = pcall(love.filesystem.read, p)
        if ok2 and bytes2 and bytes2 ~= "" then data = bytes2; break end
    end

    if not data then
        ADDON._karal_ascii_cache = { "(karal_ascii.txt not found)" }
        print("[WATCH DOGS] Karal not found. Tried:")
        for _, p in ipairs(tried) do print("  -> " .. p) end
        return ADDON._karal_ascii_cache
    end

    if data:sub(1,3) == "\239\187\191" then data = data:sub(4) end

    local lines = {}
    for line in data:gmatch("([^\r\n]*)") do
        if line ~= "" then table.insert(lines, line) end
    end

    if #lines == 0 then
        ADDON._karal_ascii_cache = { "(karal_ascii.txt is empty)" }
        print("[WATCH DOGS] Karal file is empty")
        return ADDON._karal_ascii_cache
    end

    print("[WATCH DOGS] Karal loaded successfully: " .. #lines .. " lines")
    ADDON._karal_ascii_cache = lines
    return lines
end

ADDON.console = { open = false, input = "", history = {}, anim = 0, max_history = 200, chars_per_sec = 80 }
ADDON.connecting = nil

local function has_internet()
    if not G.STATE then return false end
    if G.STATE == G.STATES.MENU or G.STATE == G.STATES.SPLASH or G.STATE == G.STATES.GAME_OVER then return false end
    return true
end

function ADDON.get_energy()
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if G.jokerstream_config.wd_energy == nil then
        G.jokerstream_config.wd_energy = 3
    end
    return G.jokerstream_config.wd_energy
end

function ADDON.set_energy(v)
    if not G.jokerstream_config then G.jokerstream_config = {} end
    local max_e = 10
    G.jokerstream_config.wd_energy = math.max(0, math.min(max_e, v))
    ADDON.save_config()

    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center then
                local k = j.config.center.key
                if k == "j_jokerstream_secret_path_recruit" or k == "j_jokerstream_server_ghost" then
                    pcall(function() j:update() end)
                end
            end
        end
    end
end
function ADDON.add_energy(v)
    local before = ADDON.get_energy()
    ADDON.set_energy(before + v)
    local after = ADDON.get_energy()
    local gained = after - before
    if gained > 0 then
        local es = load_energy_sound()
        if es then pcall(function() es:stop(); es:setVolume(0.7); es:play() end) end
        if after >= 10 and before < 10 then
            local ss = load_success_sound()
            if ss then pcall(function() ss:stop(); ss:setVolume(0.5); ss:play() end) end
        end
        ADDON.tab_flash = 1.0
        ADDON.tab_plus_amount = gained
        ADDON.tab_plus_timer = 2.5
    end
end
function ADDON.get_codes()
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if not G.jokerstream_config.wd_codes then G.jokerstream_config.wd_codes = {} end
    return G.jokerstream_config.wd_codes
end
function ADDON.add_code_entry(e) table.insert(ADDON.get_codes(), e); ADDON.save_config() end
function ADDON.remove_code(code)
    for i, c in ipairs(ADDON.get_codes()) do
        if c.code == code then table.remove(ADDON.get_codes(), i); ADDON.save_config(); return true end
    end
    return false
end
function ADDON.find_code(code)
    for _, c in ipairs(ADDON.get_codes()) do
        if c.code == code then return c end
    end
    return nil
end
function ADDON.save_config()
    if SMODS and SMODS.save_mod_config and SMODS.current_mod then SMODS.save_mod_config(SMODS.current_mod) end
end

function ADDON.get_trojan_bonus()
    if not G.jokerstream_config then return 0 end
    local count = G.jokerstream_config.wd_codes_this_ante or 0
    if count < 3 then return 0 end
    return (count - 2) * 0.15
end

function ADDON.register_clean_code()
    if not G.jokerstream_config then G.jokerstream_config = {} end
    G.jokerstream_config.wd_codes_this_ante = (G.jokerstream_config.wd_codes_this_ante or 0) + 1
    ADDON.save_config()
end

function ADDON.reset_ante_if_changed()
    if not G.GAME or not G.GAME.round_resets then return end
    local ante = G.GAME.round_resets.ante or 0
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if G.jokerstream_config.wd_current_ante ~= ante then
        G.jokerstream_config.wd_current_ante = ante
        G.jokerstream_config.wd_codes_this_ante = 0
        ADDON.save_config()
    end
end

function G.jokerstream_add_code(purity, kind)
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if not G.jokerstream_config.wd_codes then G.jokerstream_config.wd_codes = {} end
    local function local_suffix(len)
        local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        len = len or math.random(4, 6)
        local body = ""
        for i = 1, len do
            local idx = math.random(1, #chars)
            body = body .. chars:sub(idx, idx)
        end
        return body
    end
    local code, entry_purity, source_name = nil, nil, "SKULL"
    if purity == "signature" then
        code = SIGNATURE_CODES[math.random(1, #SIGNATURE_CODES)]
        entry_purity = "signature"
        source_name = "WATCH DOGS"
    else
        local p = PURITY[purity] or PURITY[1]
        code = p.prefix .. "_" .. local_suffix()
        entry_purity = purity
        if purity == 1 or purity == 2 then source_name = "WATCH DOGS"
        else source_name = "GLITCHED WATCHER" end
    end
    for _, c in ipairs(G.jokerstream_config.wd_codes) do
        if c.code == code then code = code .. "_" .. local_suffix(2); break end
    end
    table.insert(G.jokerstream_config.wd_codes, { code = code, purity = entry_purity, found_at = os.time(), kind = kind })
    ADDON.save_config()
    ADDON.log({ { source_name .. " GAVE A CODE // ", CLR.turquoise }, { "type 'codes' to see it", CLR.grey } })
    return code, entry_purity
end

local function random_suffix(len)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    len = len or math.random(4, 6)
    local body = ""
    for i = 1, len do
        local idx = math.random(1, #chars)
        body = body .. chars:sub(idx, idx)
    end
    return body
end

local function roll_purity()
    local function one_roll()
        local r, acc = math.random(), 0
        for lvl = 1, 5 do
            acc = acc + PURITY[lvl].roll_chance
            if r <= acc then return lvl end
        end
        return 1
    end
    local base = one_roll()
    local bonus = 0
    if G.jokerstream_wd_purity_bonus then bonus = G.jokerstream_wd_purity_bonus() end
    if bonus > 0 and math.random() < bonus then
        local reroll = one_roll()
        if reroll > base then return reroll end
    end
    return base
end

local function generate_code_entry()
    if math.random() < SIGNATURE_CHANCE then
        local code = SIGNATURE_CODES[math.random(1, #SIGNATURE_CODES)]
        if ADDON.find_code(code) then code = code .. "_" .. random_suffix(2) end
        return { code = code, purity = "signature", found_at = os.time(), kind = 5 }
    end
    local lvl = roll_purity()

    local kind
    if lvl == 1 then
        local pool = {1, 2, 4}
        kind = pool[math.random(1, #pool)]
    else
        kind = math.random(1, 4)
    end

    return { code = PURITY[lvl].prefix .. "_" .. random_suffix(), purity = lvl, found_at = os.time(), kind = kind }
end

local function effect_shop_reroll(purity)
    if G.STATE ~= G.STATES.SHOP then
        return "Wait for the shop. Code kept.", CLR.grey, true
    end
    if not G.shop_jokers or not G.shop_jokers.cards or #G.shop_jokers.cards == 0 then
        return "Nothing to hack here (shop is empty)", CLR.grey, true
    end
    local pct = 0
    if purity == "signature" or purity == 5 or purity == 4 then pct = 0.50
    elseif purity == 3 or purity == 2 then pct = 0.30
    else pct = 0.15 end
    local color = CLR.green
    if purity == "signature" then color = CLR.gold
    elseif purity == 5 then color = CLR.purple
    elseif purity == 4 then color = CLR.blue
    elseif purity == 3 then color = CLR.turquoise
    elseif purity == 2 then color = CLR.green
    else color = CLR.grey end

    local modified = false
    local function apply_to_table(tbl)
        if tbl and tbl.cards then
            for _, c in ipairs(tbl.cards) do
                if c.jokerstream_old_cost == nil then c.jokerstream_old_cost = c.cost end
                c.cost = math.max(1, math.floor((c.cost or 1) * (1 - pct)))
                modified = true
            end
        end
    end
    apply_to_table(G.shop_jokers)
    apply_to_table(G.shop_booster)
    apply_to_table(G.shop_vouchers)
    if modified then
        return "Shop prices -" .. math.floor(pct * 100) .. "%", color, false
    end
    return "Nothing to hack here", CLR.grey, true
end

local function effect_legendary_joker()
    if not G.jokers then return "No joker area", CLR.red, true end
    local slots = G.jokers.config and G.jokers.config.card_limit or 5
    if #G.jokers.cards >= slots then
        return "Slots are full. Sell someone.", CLR.bagley, true
    end
    local legendaries = { "j_canio", "j_triboulet", "j_yorick", "j_chicot", "j_perkeo" }
    local pick = legendaries[math.random(1, #legendaries)]
    local ok1, card = pcall(SMODS.add_card, { set = "Joker", key = pick, area = G.jokers, skip_materialize = false })
    if ok1 and card then
        return "Legendary acquired. Don't screw it up.", CLR.gold, false
    end
    return "Signal jammed. Try again — code kept.", CLR.bagley, true
end

local function set_boss_pending(purity)
    if G.GAME.blind and G.GAME.blind.boss then
        return "Too late — you're on the boss. Plant it for the NEXT one.", CLR.red, true
    end
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if not G.jokerstream_config.wd_boss_mult then G.jokerstream_config.wd_boss_mult = 1.0 end

    local mult = 1.0
    if purity == "signature" or purity == 5 then mult = 0.01
    elseif purity == 4 then mult = 0.25
    elseif purity == 3 then mult = 0.50
    elseif purity == 2 then mult = 0.75
    else mult = 0.90 end

    local cur = G.jokerstream_config.wd_boss_mult
    local new_mult = math.max(0.01, math.min(5.0, cur * mult))

    if math.abs(new_mult - cur) < 1e-9 then
        return "Boss already at limit (" .. math.floor((1.0 - cur) * 100) .. "%). Code kept.",
               CLR.gold, true
    end

    G.jokerstream_config.wd_boss_mult = new_mult
    if G.GAME then G.GAME._wd_boss_applied_key = nil end

    local color = CLR.green
    local msg = "Signal planted. Next BOSS will be affected."
    if purity == "signature" then color = CLR.gold; msg = "Signature planted."
    elseif purity == 5 then color = CLR.purple; msg = "Deep signal."
    elseif purity == 4 then color = CLR.blue; msg = "Encrypted."
    elseif purity == 3 then color = CLR.turquoise; msg = "Clear."
    elseif purity == 2 then color = CLR.green; msg = "Static."
    else color = CLR.grey; msg = "Noisy." end

    local effect_text = ""
    if new_mult < 1.0 then
        effect_text = " (Total: -" .. math.floor((1.0 - new_mult) * 100) .. "%)"
    elseif new_mult > 1.0 then
        effect_text = " (Total: +" .. math.floor((new_mult - 1.0) * 100) .. "%)"
    end
    return msg .. effect_text, color, false
end

function ADDON.try_apply_boss_manip()
    if not G.GAME or not G.GAME.blind then return end
    if not G.GAME.blind.boss then return end
    if not G.jokerstream_config then return end
    local mult = G.jokerstream_config.wd_boss_mult
    if not mult or math.abs(mult - 1.0) < 0.001 then return end
    local chips = G.GAME.blind.chips or 0
    if chips <= 0 then return end
    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    local blind_key = get_blind_key(G.GAME.blind)
    local uid = ante .. ":" .. blind_key
    if G.GAME._wd_boss_applied_key == uid then return end

    local old_chips = chips
    local new_chips = math.floor(chips * mult)

    if mult < 1.0 and new_chips >= old_chips then
        new_chips = math.max(1, old_chips - 1)
    end
    if new_chips < 1 then new_chips = 1 end

    local pct_text
    if mult < 1.0 then
        pct_text = "-" .. math.floor((1.0 - mult) * 100) .. "%"
    else
        pct_text = "+" .. math.floor((mult - 1.0) * 100) .. "%"
    end
    local applied_text = "chips " .. pct_text

    G.GAME.blind.chips = new_chips
    if G.GAME.blind.chip_text ~= nil and number_format then G.GAME.blind.chip_text = number_format(new_chips) end
    G.GAME._wd_discount = { old = old_chips, new = new_chips, pct = pct_text, uid = uid, active = true, alpha = 0, hold = 4.0, timer = 0 }
    G.GAME._wd_boss_applied_key = uid
    G.jokerstream_config.wd_boss_mult = nil
    ADDON.save_config()
    ADDON.log({ { "BLIND HACKED // ", CLR.gold }, { applied_text, CLR.gold } })
end
function ADDON.apply_pending_boss() ADDON.try_apply_boss_manip() end

local function roll_edition(purity)
    local r = math.random()
    if purity == "signature" or purity == 5 then return "e_negative"
    elseif purity == 4 then
        if r < 0.4 then return "e_negative" elseif r < 0.8 then return "e_polychrome" else return "e_holo" end
    elseif purity == 3 then
        if r < 0.15 then return "e_negative" elseif r < 0.55 then return "e_polychrome" elseif r < 0.85 then return "e_holo" else return "e_foil" end
    elseif purity == 2 then
        if r < 0.05 then return "e_negative" elseif r < 0.20 then return "e_polychrome" elseif r < 0.55 then return "e_holo" else return "e_foil" end
    else
        if r < 0.10 then return "e_holo" else return "e_foil" end
    end
end

local EDITION_TIERS = { "e_foil", "e_holo", "e_polychrome", "e_negative" }

local function get_edition_tier(edition_key)
    if not edition_key then return 0 end
    for i, k in ipairs(EDITION_TIERS) do
        if edition_key == k then return i end
    end
    return 0
end

local function get_edition_name(ed_key)
    if not ed_key then return "None" end
    if ed_key == "e_foil" then return "Foil" end
    if ed_key == "e_holo" then return "Holo" end
    if ed_key == "e_polychrome" then return "Poly" end
    if ed_key == "e_negative" then return "Negative" end
    return "None"
end

local function effect_joker_editions(purity)
    if not G.jokers or not G.jokers.cards or #G.jokers.cards == 0 then
        return "You have no jokers, idiot.", CLR.bagley, true
    end

    local clean_targets, upgradable_targets = {}, {}
    for _, j in ipairs(G.jokers.cards) do
        if not j.edition then
            table.insert(clean_targets, j)
        else
            local tier = get_edition_tier(j.edition.key)
            if tier > 0 and tier < 4 then table.insert(upgradable_targets, j) end
        end
    end

    if #clean_targets == 0 and #upgradable_targets == 0 then
        return "All jokers are Negative. Stop cheating.", CLR.red, true
    end

    local count = 1
    if purity == "signature" or purity == 5 then count = 999
    elseif purity == 4 or purity == 3 then count = 2 end

    local changes = {}

    if #clean_targets > 0 then
        for _ = 1, count do
            if #clean_targets == 0 then break end
            local idx = math.random(1, #clean_targets)
            local target = clean_targets[idx]
            table.remove(clean_targets, idx)
            local new_ed = roll_edition(purity)
            pcall(function() target:set_edition(new_ed, true, true) end)
            table.insert(changes, "None -> " .. get_edition_name(new_ed))
        end
    elseif #upgradable_targets > 0 then
        for _ = 1, count do
            if #upgradable_targets == 0 then break end
            local idx = math.random(1, #upgradable_targets)
            local target = upgradable_targets[idx]
            table.remove(upgradable_targets, idx)

            local old_name = get_edition_name(target.edition.key)
            local current_tier = get_edition_tier(target.edition.key)
            local jump = 1
            if purity == "signature" or purity == 5 then jump = 4 - current_tier
            elseif purity == 4 or purity == 3 then jump = math.random(1, 2) end

            local new_tier = math.min(4, current_tier + jump)
            local new_ed = EDITION_TIERS[new_tier]
            if new_tier == 3 and (purity == 5 or purity == "signature") and math.random() < 0.5 then
                new_ed = "e_negative"
            end
            pcall(function() target:set_edition(new_ed, true, true) end)
            table.insert(changes, old_name .. " -> " .. get_edition_name(new_ed))
        end
    end

    local color = CLR.turquoise
    if purity == "signature" then color = CLR.gold
    elseif purity == 5 then color = CLR.purple
    elseif purity == 4 then color = CLR.blue end

    local msg = table.concat(changes, ", ")
    if msg == "" then return "No changes.", CLR.grey, true end
    return msg, color, false
end

local ENHANCEMENT_POOL = { "m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_stone", "m_gold", "m_lucky" }
local function is_base_card(c)
    if not c or not c.config or not c.config.center then return false end
    local k = c.config.center.key
    return k == "c_base" or not k:match("^m_")
end
local function effect_card_enhancements(purity)
    if not G.deck or not G.deck.cards or #G.deck.cards == 0 then
        return "No cards in deck", CLR.grey, true
    end
    local targets = {}
    for _, c in ipairs(G.deck.cards) do if is_base_card(c) then table.insert(targets, c) end end
    if #targets == 0 then
        return "Every card already has an enhancement.", CLR.grey, true
    end
    local count = 3
    if purity == "signature" or purity == 5 then count = 8
    elseif purity == 4 then count = 6 elseif purity == 3 then count = 5
    elseif purity == 2 then count = 4 end
    count = math.min(count, #targets)
    local applied = 0
    for _ = 1, count do
        local idx = math.random(1, #targets)
        local target = targets[idx]
        table.remove(targets, idx)
        pcall(function()
            target:set_ability(G.P_CENTERS[ENHANCEMENT_POOL[math.random(1, #ENHANCEMENT_POOL)]])
        end)
        applied = applied + 1
    end
    return "Enhancements applied: " .. applied .. " cards", CLR.turquoise, false
end

local function trojan_destroy_joker()
    if not G.jokers or not G.jokers.cards or #G.jokers.cards == 0 then return "no jokers to destroy." end
    local weights = { [1] = 40, [2] = 30, [3] = 20, [4] = 10 }
    local candidates = {}
    for _, j in ipairs(G.jokers.cards) do
        local r = j.config and j.config.center and j.config.center.rarity or 1
        if r >= 1 and r <= 4 then table.insert(candidates, { card = j, weight = weights[r] }) end
    end
    if #candidates == 0 then return "nothing to destroy." end
    local total = 0
    for _, c in ipairs(candidates) do total = total + c.weight end
    local roll, acc = math.random(1, total), 0
    for _, c in ipairs(candidates) do
        acc = acc + c.weight
        if roll <= acc then
            local name = c.card.config.center.name or "?"
            pcall(function() SMODS.destroy_cards({ c.card }, { pinch_anim = true }) end)
            return "destroyed a joker (" .. tostring(name) .. ")"
        end
    end
    return "nothing to destroy."
end

local function trojan_destroy_cards(count)
    if not G.deck or not G.deck.cards or #G.deck.cards == 0 then return "deck is empty." end
    count = math.min(count or 3, #G.deck.cards)
    local destroyed = 0
    for i = 1, count do
        if #G.deck.cards == 0 then break end
        local target = G.deck.cards[math.random(1, #G.deck.cards)]
        if target then pcall(function() SMODS.destroy_cards({ target }, { pinch_anim = true }) end); destroyed = destroyed + 1 end
    end
    return "destroyed " .. destroyed .. " cards from your deck"
end

local function trojan_boss_penalty(purity)
    if purity == 1 then return 0.25
    elseif purity == 2 then return 0.35
    else return 0.50 end
end

local function handle_trojan_by_command(command_type, purity)
    if command_type == "jokers" then
        if math.random(1, 5) == 1 then
            return "jokers destroyed: " .. trojan_destroy_joker(), CLR.dark_red
        end
        return "jokers survived (1 in 5)", CLR.dark_red

    elseif command_type == "cards" then
        return trojan_destroy_cards(3), CLR.dark_red

    elseif command_type == "shop" then
        local touched = false
        local function apply(tbl)
            if tbl and tbl.cards then
                for _, c in ipairs(tbl.cards) do
                    c.cost = math.max(1, math.floor((c.cost or 1) * 1.5))
                    touched = true
                end
            end
        end
        apply(G.shop_jokers)
        apply(G.shop_booster)
        apply(G.shop_vouchers)
        if touched then
            return "shop prices +50%.", CLR.dark_red
        end
        return "shop is empty, nothing to hurt.", CLR.dark_red

    elseif command_type == "boss" then
        if not G.jokerstream_config then G.jokerstream_config = {} end
        local cur = G.jokerstream_config.wd_boss_mult or 1.0
        local pct = trojan_boss_penalty(purity or 1)
        local new_mult = math.min(5.0, cur * (1.0 + pct))
        G.jokerstream_config.wd_boss_mult = new_mult
        if G.GAME then G.GAME._wd_boss_applied_key = nil end
        ADDON.save_config()
        return "boss chips +" .. math.floor(pct * 100) .. "% (total +" .. math.floor((new_mult - 1.0) * 100) .. "%).",
               CLR.dark_red

    elseif command_type == "legendary" then
        if G.jokers and #G.jokers.cards > 0 then
            local target = G.jokers.cards[math.random(1, #G.jokers.cards)]
            pcall(function() SMODS.destroy_cards({ target }, { pinch_anim = true }) end)
            return "destroyed a random joker.", CLR.dark_red
        end
        return "no jokers to destroy.", CLR.dark_red
    end

    return "nothing happened", CLR.dark_red
end

function ADDON.log(text, default_color)
    default_color = default_color or CLR.green
    local segments = type(text) == "table" and text or { { tostring(text), default_color } }
    local entry = { segments = segments, shown = 0, done = false, total_len = 0, font_size = nil }
    for _, seg in ipairs(segments) do
        entry.total_len = entry.total_len + utf8_len(seg[1])
        if seg[3] and (not entry.font_size or seg[3] < entry.font_size) then entry.font_size = seg[3] end
    end
    table.insert(ADDON.console.history, entry)
    while #ADDON.console.history > ADDON.console.max_history do table.remove(ADDON.console.history, 1) end
end
function ADDON.clear_history() ADDON.console.history = {} end

local function get_mono_font(size)
    if G.jokerstream_get_chat_font then return G.jokerstream_get_chat_font(size, 4) end
    return love.graphics.newFont(size)
end

local function show_karal_ascii()
    local lines = load_karal_ascii()

    if #lines == 0 or (lines[1] and lines[1]:find("not found")) or (lines[1] and lines[1]:find("is empty")) then
        ADDON.clear_history()
        ADDON.log({ { "karal_ascii.txt problem:", CLR.red } })
        for _, l in ipairs(lines) do ADDON.log({ { l, CLR.grey } }) end
        ADDON.log({ { "  place at: addons/watch_dogs/karal_ascii.txt", CLR.grey } })
        return
    end

    ADDON.clear_history()

    local sw, sh = love.graphics.getDimensions()
    local available_h = math.max(200, sh - 245)
    local n_lines = #lines + 1

    local font_size = 10
    while font_size > 4 do
        if n_lines * (font_size + 2) <= available_h then break end
        font_size = font_size - 1
    end

    local max_line_len = 0
    for _, line in ipairs(lines) do
        local n = utf8_len(line)
        if n > max_line_len then max_line_len = n end
    end
    if max_line_len > 0 then
        local avail_w = sw - 60
        local probe_font = get_mono_font(font_size)
        if probe_font then
            local probe_w = probe_font:getWidth(string.rep("M", max_line_len))
            if probe_w > avail_w then
                local ratio = avail_w / probe_w
                font_size = math.max(4, math.floor(font_size * ratio))
            end
        end
    end

    local header = { segments = { { "--- KARAL ASCII ---", CLR.turquoise } },
                     shown = 0, done = false, total_len = 0, font_size = nil, no_reset = true }
    for _, seg in ipairs(header.segments) do
        header.total_len = header.total_len + utf8_len(seg[1])
    end
    header.shown = header.total_len
    header.done = true
    table.insert(ADDON.console.history, header)

    for _, line in ipairs(lines) do
        local entry = {
            segments = { { line, CLR.green, font_size } },
            shown = 0, done = false, total_len = utf8_len(line),
            font_size = font_size, no_reset = true,
        }
        entry.shown = entry.total_len
        entry.done = true
        table.insert(ADDON.console.history, entry)
    end

    while #ADDON.console.history > ADDON.console.max_history do
        table.remove(ADDON.console.history, 1)
    end
end

local function draw_hack_tab()
    if not G.STATE or G.STATE == G.STATES.MENU or G.STATE == G.STATES.SPLASH then return end
    local t = love.timer.getTime()
    local dt = love.timer.getDelta()
    if ADDON.tab_flash and ADDON.tab_flash > 0 then ADDON.tab_flash = math.max(0, ADDON.tab_flash - dt * 2) end
    if ADDON.tab_plus_timer and ADDON.tab_plus_timer > 0 then ADDON.tab_plus_timer = math.max(0, ADDON.tab_plus_timer - dt) end
    local tab_w, tab_h = 300, 34
    local tab_x = love.graphics.getWidth() - tab_w - 15
    local tab_y = -8
    local radius = 6
    ADDON.tab_rect = { x = tab_x, y = 0, w = tab_w, h = tab_h + tab_y }
    local has_energy = ADDON.get_energy() > 0
    local pulse = 0.7 + 0.3 * math.sin(t * 2)
    local flash = ADDON.tab_flash or 0
    local flash_pulse = flash > 0 and (math.abs(math.sin(t * 20)) * flash) or 0
    local bg_r, bg_g, bg_b = 0.05, 0.10, 0.10
    if flash_pulse > 0 then bg_r, bg_g, bg_b = bg_r + flash_pulse * 0.35, bg_g + flash_pulse * 0.5, bg_b + flash_pulse * 0.3 end
    love.graphics.setColor(bg_r, bg_g, bg_b, 0.35)
    love.graphics.rectangle("fill", tab_x, tab_y, tab_w, tab_h, radius)
    love.graphics.rectangle("fill", tab_x, tab_y, tab_w, radius)
    if flash_pulse > 0 then
        love.graphics.setColor(0.4, 1.0, 0.5, flash_pulse * 0.25)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", tab_x - 1, tab_y - 1, tab_w + 2, tab_h + 2, radius)
        love.graphics.setLineWidth(1)
    end
    if has_energy then love.graphics.setColor(0.35 * pulse, 0.95 * pulse, 0.95 * pulse, 0.5)
    else love.graphics.setColor(0.45, 0.45, 0.45, 0.3) end
    love.graphics.setLineWidth(1.2); love.graphics.rectangle("line", tab_x, tab_y, tab_w, tab_h, radius); love.graphics.setLineWidth(1)
    local dot_x, dot_y = tab_x + 14, tab_y + tab_h / 2 + 3
    if has_energy then
        local halo = 3 + math.sin(t * 3) * 1.5
        love.graphics.setColor(0.3, 1.0, 0.35, 0.18); love.graphics.circle("fill", dot_x, dot_y, halo + 3)
        love.graphics.setColor(0.3, 1.0, 0.35, 0.75)
    else love.graphics.setColor(0.4, 0.4, 0.4, 0.4) end
    love.graphics.circle("fill", dot_x, dot_y, 3.5)
    if (ADDON.tab_plus_timer or 0) > 0 then
        local plus_alpha = math.min(1, ADDON.tab_plus_timer)
        local amount = ADDON.tab_plus_amount or 1
        local font_big = get_mono_font(18); if font_big then love.graphics.setFont(font_big) end
        love.graphics.setColor(0.3, 1.0, 0.35, plus_alpha * 0.35); love.graphics.print("+" .. amount .. " ENERGY", tab_x + 31, tab_y + 12)
        love.graphics.setColor(0.5, 1.0, 0.55, plus_alpha); love.graphics.print("+" .. amount .. " ENERGY", tab_x + 30, tab_y + 11)
    else
        local font = get_mono_font(15); if font then love.graphics.setFont(font) end
        local energy = ADDON.get_energy()
        local text = "PRESS ~ TO HACK [" .. energy .. "/10]"
        if energy >= 10 then
            local fl = math.abs(math.sin(t * 5)); love.graphics.setColor(1.0, 0.9, 0.25, fl); text = "PRESS ~ TO HACK [FULL]  (!)"
        elseif has_energy then love.graphics.setColor(0.9, 1.0, 1.0, 0.75)
        else love.graphics.setColor(0.55, 0.55, 0.55, 0.5) end
        love.graphics.print(text, tab_x + 30, tab_y + 13)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function start_connection(code, entry, command_type)
    local is_pending = false
    if command_type == "shop" and G.STATE ~= G.STATES.SHOP then is_pending = true end

    if command_type == "boss" then
        if G.GAME.blind and G.GAME.blind.boss then
            is_pending = true
        else
            local cur = (G.jokerstream_config and G.jokerstream_config.wd_boss_mult) or 1.0
            local mult = 1.0
            if entry.purity == "signature" or entry.purity == 5 then mult = 0.01
            elseif entry.purity == 4 then mult = 0.25
            elseif entry.purity == 3 then mult = 0.50
            elseif entry.purity == 2 then mult = 0.75
            else mult = 0.90 end
            local new_mult = math.max(0.01, math.min(5.0, cur * mult))
            if math.abs(new_mult - cur) < 1e-9 then is_pending = true end
        end
    end

    local trojan_chance = 0
    if not is_pending and entry.purity ~= "signature" then
        trojan_chance = (PURITY[entry.purity] or PURITY[1]).trojan_chance
    end

    local reduce = 0
    if G.jokerstream_wd_trojan_reduce then reduce = reduce + G.jokerstream_wd_trojan_reduce() end
    if G.GAME and G.GAME.used_vouchers then
        if G.GAME.used_vouchers["v_jokerstream_perfect_firewall"] then reduce = reduce + 0.10 end
    end
    trojan_chance = math.max(0, trojan_chance - reduce)
    trojan_chance = trojan_chance + ADDON.get_trojan_bonus()

    local is_trojan = false
    if not is_pending then
        is_trojan = math.random() < trojan_chance
    end

    local hs = load_hack_sound()
    if hs then pcall(function() hs:stop(); hs:setVolume(0.5); hs:play() end) end

    local is_bsi = G.GAME and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == "bl_jokerstream_wd_bsi"
    if is_bsi then
        local current_uid = (G.GAME.round_resets.ante or 0) .. "_" .. (G.GAME.round or 0)
        if G.GAME._wd_bsi_uid ~= current_uid then
            G.GAME._wd_bsi_uid = current_uid
            G.GAME._wd_bsi_codes = 0
            G.GAME._wd_bsi_base_chips = G.GAME.blind.chips
        end
        G.GAME._wd_bsi_codes = G.GAME._wd_bsi_codes + 1
        local pct = math.min(G.GAME._wd_bsi_codes * 0.10, 0.70)
        G.GAME.blind.chips = math.floor(G.GAME._wd_bsi_base_chips * (1 + pct))
        if G.GAME.blind.chip_text and number_format then G.GAME.blind.chip_text = number_format(G.GAME.blind.chips) end
        ADDON.log({ { "BSI TRACED YOU! ", CLR.red }, { "+" .. math.floor(pct*100) .. "% chips", CLR.dark_red } })
    end

    ADDON.connecting = { code = code, entry = entry, command_type = command_type, timer = 0, duration = 2.0, pct = 0, trojan = is_trojan, finished = false, finish_timer = 0 }
end

local function update_connection(dt)
    local c = ADDON.connecting
    if not c then return end
    c.timer = c.timer + dt
    c.pct = math.min(c.timer / c.duration, 1.0)

    if c.pct >= 1.0 then
        local entry = c.entry
        local keep_code = false

        if ADDON.hack_sound then pcall(function() ADDON.hack_sound:stop() end) end

        if c.trojan then
            ADDON.log({ { "TROJAN DETECTED // ", CLR.dark_red }, { "Mini-game started", CLR.grey } })
            if ADDON.console_music and ADDON.music_playing then pcall(function() ADDON.console_music:stop() end); ADDON.music_playing = false end
            ADDON.console.open = false
            local difficulty = (G.jokerstream_config and G.jokerstream_config.wd_global_trojans) or 0
            if G.wd_mg_start then
                if G.jokerstream_config then G.jokerstream_config.wd_global_trojans = difficulty + 1; ADDON.save_config() end
                G.wd_mg_start(difficulty, function(win)
                    if win then
                        -- ★ ПРОВЕРКА IP-ЛОКАТОРА
                        local has_ip_locator = G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers["v_jokerstream_ip_locator"]

                        if has_ip_locator then
                            local rnd_ip = tostring(math.random(100000000000, 999999999999))
                            local flavor_text = "ip 3.14.25.123.77777.// worm redirected to ctos server 3.27:" .. rnd_ip

                            ADDON.log({ { flavor_text, CLR.purple } })
                            ADDON.add_energy(1)

                            local msg, color, keep
                            if c.command_type == "jokers" then msg, color, keep = effect_joker_editions(entry.purity)
                            elseif c.command_type == "cards" then msg, color, keep = effect_card_enhancements(entry.purity)
                            elseif c.command_type == "shop" then msg, color, keep = effect_shop_reroll(entry.purity)
                            elseif c.command_type == "boss" then msg, color, keep = set_boss_pending(entry.purity)
                            elseif entry.purity == "signature" then msg, color, keep = effect_legendary_joker()
                            elseif G.STATE == G.STATES.SHOP then msg, color, keep = effect_shop_reroll(entry.purity)
                            else msg, color, keep = set_boss_pending(entry.purity) end

                            ADDON.log({ { "REFLECTED // ", CLR.gold }, { msg, color } })
                            ADDON.register_clean_code()

                            if G.GAME and G.GAME.blind and G.GAME.blind.boss then
                                local dmg_pct = (PURITY[entry.purity] or PURITY[1]).instant_dmg or 0
                                if dmg_pct > 0 then
                                    local old_chips = G.GAME.blind.chips or 0
                                    local new_chips = math.max(1, math.floor(old_chips * (1 - dmg_pct)))
                                    if new_chips < old_chips then
                                        G.GAME.blind.chips = new_chips
                                        if G.GAME.blind.chip_text ~= nil and number_format then G.GAME.blind.chip_text = number_format(new_chips) end
                                        ADDON.log({ { "INSTANT DMG // ", CLR.red }, { "Boss chips reduced by " .. math.floor(dmg_pct*100) .. "%", CLR.red } })
                                    end
                                end
                            end
                            local ss = load_success_sound(); if ss then pcall(function() ss:stop(); ss:setVolume(0.7); ss:play() end) end
                        else
                            ADDON.log({ { "CLEAN // ", CLR.green }, { "You survived. No damage.", CLR.green } })
                            ADDON.register_clean_code()
                            local ss = load_success_sound(); if ss then pcall(function() ss:stop(); ss:setVolume(0.7); ss:play() end) end
                        end
                    else
                        local msg, color = handle_trojan_by_command(c.command_type, entry.purity)
                        ADDON.log({ { "TROJAN SUCCESS // ", CLR.dark_red }, { msg, color } })
                        local fs = load_fail_sound(); if fs then pcall(function() fs:stop(); fs:setVolume(0.7); fs:play() end) end
                        local bc = TROJAN_MIXED[math.random(1, #TROJAN_MIXED)]
                        if math.random(1, 3) == 1 then bc = TROJAN_MOCK[math.random(1, #TROJAN_MOCK)]
                        elseif math.random(1, 3) == 1 then bc = TROJAN_PITY[math.random(1, #TROJAN_PITY)] end
                        ADDON.log({ { "Bagley: ", CLR.bagley }, { bc, CLR.grey } })
                    end
                end)
            else
                local msg, color = handle_trojan_by_command(c.command_type, entry.purity)
                ADDON.log({ { "TROJAN DETECTED // ", CLR.dark_red }, { msg, color } })
            end
            keep_code = false
        else
            local msg, color, keep
            if c.command_type == "jokers" then msg, color, keep = effect_joker_editions(entry.purity)
            elseif c.command_type == "cards" then msg, color, keep = effect_card_enhancements(entry.purity)
            elseif c.command_type == "shop" then msg, color, keep = effect_shop_reroll(entry.purity)
            elseif c.command_type == "boss" then msg, color, keep = set_boss_pending(entry.purity)
            elseif entry.purity == "signature" then msg, color, keep = effect_legendary_joker()
            elseif G.STATE == G.STATES.SHOP then msg, color, keep = effect_shop_reroll(entry.purity)
            else msg, color, keep = set_boss_pending(entry.purity) end

            local prefix = keep and "DELAYED // " or "SUCCESS // "
            local prefix_color = keep and CLR.yellow or (entry.purity == "signature" and CLR.gold or CLR.turquoise)
            ADDON.log({ { prefix, prefix_color }, { msg, color } })

            if not keep then
                if G.GAME and G.GAME.blind and G.GAME.blind.boss then
                    local dmg_pct = (PURITY[entry.purity] or PURITY[1]).instant_dmg or 0
                    if dmg_pct > 0 then
                        local old_chips = G.GAME.blind.chips or 0
                        local new_chips = math.max(1, math.floor(old_chips * (1 - dmg_pct)))
                        if new_chips < old_chips then
                            G.GAME.blind.chips = new_chips
                            if G.GAME.blind.chip_text ~= nil and number_format then G.GAME.blind.chip_text = number_format(new_chips) end
                            ADDON.log({ { "INSTANT DMG // ", CLR.red }, { "Boss chips reduced by " .. math.floor(dmg_pct*100) .. "%", CLR.red } })
                        end
                    end
                end
                ADDON.register_clean_code()
                local ss = load_success_sound(); if ss then pcall(function() ss:stop(); ss:setVolume(0.7); ss:play() end) end
            end
            keep_code = keep
        end

        if not keep_code then ADDON.remove_code(c.code) end
        ADDON.connecting = nil
    end
end

local function draw_connection()
    local c = ADDON.connecting
    if not c then return end
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    local box_w, box_h = 700, 200
    local bx, by = (sw - box_w) / 2, (sh - box_h) / 2
    love.graphics.setColor(0, 0, 0, 0.92); love.graphics.rectangle("fill", bx, by, box_w, box_h, 8)
    love.graphics.setColor(0.2, 1, 0.3, 0.9); love.graphics.setLineWidth(2); love.graphics.rectangle("line", bx, by, box_w, box_h, 8); love.graphics.setLineWidth(1)
    local font_big = get_mono_font(22); if font_big then love.graphics.setFont(font_big) end

    love.graphics.setColor(0.4, 1, 0.5, 1); love.graphics.print("CONNECTING TO NODE...", bx + 30, by + 25)
    local bar_x, bar_y, bar_w, bar_h = bx + 30, by + 80, box_w - 60, 30
    local cell_count, cell_w = 20, (bar_w - 19 * 2) / 20
    local filled = math.floor(c.pct * cell_count)
    for i = 1, cell_count do
        if i <= filled then love.graphics.setColor(0.3, 1, 0.35, 1) else love.graphics.setColor(0.15, 0.25, 0.15, 1) end
        love.graphics.rectangle("fill", bar_x + (i - 1) * (cell_w + 2), bar_y, cell_w, bar_h)
    end
    love.graphics.setColor(1, 1, 1, 1)
    local pct_txt = math.floor(c.pct * 100) .. "%"
    love.graphics.print(pct_txt, bx + (box_w - (font_big and font_big:getWidth(pct_txt) or 60)) / 2, bar_y + bar_h + 15)
    love.graphics.setColor(1, 1, 1, 1)
end

local function draw_discount_overlay()
    if not G.GAME then return end
    local d = G.GAME._wd_discount
    if not d or not d.active then return end
    local dt = love.timer.getDelta()
    d.timer = d.timer + dt
    if d.alpha < 1 then d.alpha = math.min(1, d.alpha + dt * 4) end
    if d.timer > d.hold then
        d.alpha = math.max(0, d.alpha - dt * 2)
        if d.alpha <= 0 then d.active = false; return end
    end
    if d.uid and d.uid ~= get_current_blind_uid() then d.active = false; return end
    local sw = love.graphics.getWidth()
    local A, eased = d.alpha, 1 - math.pow(1 - d.alpha, 3)
    local blink = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(d.timer * 4.0))
    local box_w, box_h = 270, 130
    local bx, by = sw - box_w - 15, 15
    local x = bx + (1 - eased) * 80
    love.graphics.setColor(0.05, 0.20, 0.22, 0.55 * A * blink); love.graphics.rectangle("fill", x, by, box_w, box_h, 12)
    love.graphics.setColor(0.35, 0.95, 0.95, 0.7 * A * blink); love.graphics.setLineWidth(2); love.graphics.rectangle("line", x, by, box_w, box_h, 12); love.graphics.setLineWidth(1)
    local font_h = get_mono_font(16); if font_h then love.graphics.setFont(font_h) end
    love.graphics.setColor(0.35, 0.95, 0.95, A * blink); love.graphics.print("BOSS HACKED", x + 15, by + 10)
    local font_pct = get_mono_font(22); if font_pct then love.graphics.setFont(font_pct) end
    love.graphics.setColor(0.30, 1.00, 0.35, A * blink); love.graphics.print(d.pct, x + box_w - (font_pct and font_pct:getWidth(d.pct) or 60) - 15, by + 8)
    local font_old = get_mono_font(15); if font_old then love.graphics.setFont(font_old) end
    local old_text = number_format and number_format(d.old) or tostring(d.old)
    love.graphics.setColor(0.90, 0.35, 0.35, A * blink * 0.85); love.graphics.print(old_text, x + 15, by + 44)
    local old_w = font_old and font_old:getWidth(old_text) or 60
    love.graphics.setColor(0.95, 0.35, 0.35, A * blink); love.graphics.setLineWidth(2)
    local line_y = by + 44 + (font_old and font_old:getHeight() or 15) / 2
    love.graphics.line(x + 15 - 2, line_y, x + 15 + old_w + 2, line_y); love.graphics.setLineWidth(1)
    local font_new = get_mono_font(28); if font_new then love.graphics.setFont(font_new) end
    local new_text = number_format and number_format(d.new) or tostring(d.new)
    love.graphics.setColor(0.30, 1.00, 0.35, A * blink); love.graphics.print(new_text, x + 15, by + 66)
    love.graphics.setColor(1, 1, 1, 1)
end

local function execute_command(cmd)
    cmd = cmd:gsub("^%s+", ""):gsub("%s+$", "")
    if cmd == "" then ADDON.log({ { "Enter without a command — like a hacker without a PC.", CLR.bagley } }); return end
    ADDON.log({ { "> ", CLR.green_dim }, { cmd, CLR.green } })
    ADDON.up_index, ADDON.down_index = 0, 0
    local parts = {}
    for w in cmd:gmatch("%S+") do table.insert(parts, w) end
    local base = (parts[1] or ""):lower()
    local special = HUMOR_SPECIAL[base]
    if special then
        if special == "karal_ascii" then show_karal_ascii()
        elseif type(special) == "table" and special[1] then ADDON.log(special) end
        return
    end
    if base == "help" or base == "?" then
        ADDON.log("Available commands:", CLR.turquoise)
        for _, c in ipairs({
            {"search", "       - 1 energy, random code"}, {"codes", "        - list found codes"},
            {"plug <code>", "  - activate"}, {"energy", "       - show current energy"},
            {"pc", "           - random PC tip"},
            {"pc <n>", "       - PC tip number"}, {"zxz", "          - funny commands list"},
            {"clear", "        - clear console"}, {"close", "        - close console"}
        }) do ADDON.log({ {"  ", CLR.green_dim}, {c[1], CLR.green}, {c[2], CLR.grey} }) end
        return
    end
    if (base == "search" or base == "scan" or base == "codes" or base == "list" or base == "plug" or base == "energy" or base == "en" or base == "pc") and not has_internet() then
        ADDON.log({ { "Dude, no internet.", CLR.bagley } }); return
    end
    if base == "search" or base == "scan" then
        if ADDON.get_energy() < 1 then ADDON.log({ { "ERROR: ", CLR.red }, { "not enough energy (need 1)", CLR.red } }); return end
        ADDON.add_energy(-1)

        -- ★ ПРОВЕРКА ВАУЧЕРА "1 = 2"
        local codes_amount = 1
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers["v_jokerstream_one_equals_two"] then
            codes_amount = 2
        end

        for i = 1, codes_amount do
            local entry = generate_code_entry()
            ADDON.add_code_entry(entry)
            ADDON.log({ { "PROXY OK // new code: ", CLR.green }, { entry.code, CLR.yellow }, { "  [" .. ((entry.purity == "signature") and "Signature" or PURITY[entry.purity].name) .. "]", CLR.grey } })
        end

        ADDON.log({ { "  activated this ante: ", CLR.grey }, { tostring((G.jokerstream_config and G.jokerstream_config.wd_codes_this_ante) or 0), CLR.yellow },
                    { "  trojan bonus: ", CLR.grey }, { "+" .. math.floor(ADDON.get_trojan_bonus()*100) .. "%", CLR.dark_red } })
    elseif base == "codes" or base == "list" then
        local list = ADDON.get_codes()
        if #list == 0 then ADDON.log({ { "Nothing here.", CLR.bagley } })
        else
            ADDON.log({ {"Found codes (", CLR.turquoise}, {tostring(#list), CLR.yellow}, {"):", CLR.turquoise} })
            for i, c in ipairs(list) do ADDON.log({ { "  [" .. i .. "] ", CLR.grey }, { c.code, CLR.yellow }, { "  " .. ((c.purity == "signature") and "Signature" or PURITY[c.purity].name), CLR.grey } }) end
        end
    elseif base == "plug" then
        if ADDON.connecting then
            ADDON.log({ { "ALREADY HACKING // ", CLR.red }, { "wait for the current one to finish", CLR.grey } })
            return
        end
        local code = cmd:match("^plug%s+(.+)$")
        if not code then ADDON.log({ { "Plug WHAT?", CLR.bagley } }); return end
        code = code:gsub("^%s+", ""):gsub("%s+$", "")

        local entry = ADDON.find_code(code)
        if not entry and code:match("_$") then
            local found = {}
            for _, c in ipairs(ADDON.get_codes()) do if c.code:sub(1, #code) == code then table.insert(found, c) end end
            if #found == 0 then ADDON.log({ { "No codes with prefix: ", CLR.bagley }, { code, CLR.yellow } })
            else
                ADDON.log({ { "Codes with prefix ", CLR.turquoise }, { code, CLR.yellow }, { " (", CLR.turquoise }, { tostring(#found), CLR.yellow }, { "):", CLR.turquoise } })
                for _, c in ipairs(found) do ADDON.log({ { "  ", CLR.grey }, { c.code, CLR.yellow }, { "  " .. ((c.purity == "signature") and "Signature" or PURITY[c.purity].name), CLR.grey } }) end
            end
            return
        end
        if not entry then ADDON.log({ { "No such code.", CLR.red } }); return end

        local command_type, action_text = nil, "Unknown"
        if entry.purity == "signature" then
            command_type = "legendary"; action_text = "Summon Legendary Joker"
        elseif entry.kind == 1 then command_type = "boss";  action_text = "Plant Boss Virus"
        elseif entry.kind == 2 then command_type = "cards"; action_text = "Enhance Cards"
        elseif entry.kind == 3 then command_type = "jokers"; action_text = "Upgrade Jokers"
        elseif entry.kind == 4 then command_type = "shop";  action_text = "Discount Shop"
        end
        ADDON.log({ { "> PLUGGING ", CLR.green_dim }, { entry.code, CLR.yellow } })
        ADDON.log({ { "  [" .. ((entry.purity == "signature") and "Signature" or PURITY[entry.purity].name) .. "] -> ", CLR.grey }, { action_text, CLR.turquoise } })
        start_connection(code, entry, command_type)
    elseif base == "energy" or base == "en" then ADDON.log({ { "ENERGY: ", CLR.green }, { ADDON.get_energy() .. "/10", CLR.yellow } })
    elseif base == "pc" then
        local num = tonumber(parts[2])
        local idx = (num and num >= 1 and num <= #PC_TIPS) and math.floor(num) or math.random(1, #PC_TIPS)
        local tip_sound = load_tip_sound() or load_energy_sound()
        if tip_sound then pcall(function() tip_sound:stop(); tip_sound:setVolume(0.7); tip_sound:play() end) end
        ADDON.log({ { "PC TIP #" .. idx .. " // ", CLR.yellow }, { PC_TIPS[idx], CLR.yellow } })
    elseif base == "zxz" then
        local examples = { "gg", "ez", "sudo", "ping", "hi", "thanks", "karal", "wp", "respawn", "pc" }
        ADDON.log({ { "Type ", CLR.bagley }, { examples[math.random(1, #examples)], CLR.yellow }, { ". See what happens.", CLR.bagley } })
    elseif base == "clear" or base == "cls" then ADDON.clear_history()
    elseif base == "close" or base == "exit" or base == "quit" then ADDON.console.open = false
    else ADDON.log({ { HUMOR_TRASH[math.random(1, #HUMOR_TRASH)], CLR.bagley } }) end
end

function ADDON.close()
    ADDON.console.open = false
    if ADDON.console_music and ADDON.music_playing then ADDON.console_music:stop(); ADDON.music_playing = false end
    restore_vanilla_music()
end

function ADDON.open()
    install_hard_audio_hook()
    ADDON.console.open = true
    ADDON.console.input = ""
    ADDON.up_index, ADDON.down_index = 0, 0
    for _, e in ipairs(ADDON.console.history) do
        if not e.no_reset then
            e.shown = 0
            e.done = false
        end
    end
    stop_vanilla_music()
    local music = load_console_music()
    if music and not ADDON.music_playing and not (G.wd_mg and G.wd_mg.active) then
        music:setVolume(ADDON.music_volume); music:play(); ADDON.music_playing = true
    end
    if #ADDON.console.history == 0 then
        ADDON.log({ { "Bagley OS ", CLR.green }, { "v4.0.5", CLR.turquoise } })
        ADDON.log({ { "> ", CLR.green_dim }, { "system online", CLR.green } })
        ADDON.log({ { "> ", CLR.green_dim }, { "type 'help' for commands", CLR.grey } })
        ADDON.log({ { "> energy: ", CLR.green_dim }, { ADDON.get_energy() .. "/10", CLR.yellow } })
    end
end

function ADDON.handle_keypressed(key, scancode)
    if G.wd_mg and G.wd_mg.active then return G.wd_mg_keypressed(key) end
    if key == "f2" then ADDON.add_energy(1); if ADDON.console.open then ADDON.log({ { "DEBUG // energy +1", CLR.yellow } }) end; return true end
    if ADDON.connecting then return true end
    if scancode == "grave" or key == "`" or key == "~" or key == "ё" or key == "Ё" or key == "f1" then
        if G.GAME and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == "bl_jokerstream_wd_damien" then
            if not ADDON.console.open then
                play_sound('cancel')
                return true
            end
        end
        if ADDON.console.open then ADDON.close() else ADDON.open() end
        return true
    end
    if ADDON.console.open then
        if key == "escape" then ADDON.close(); return true
        elseif key == "return" or key == "kpenter" then execute_command(ADDON.console.input); ADDON.console.input = ""; return true
        elseif key == "backspace" then ADDON.up_index, ADDON.down_index = 0, 0; ADDON.console.input = utf8_remove_last(ADDON.console.input); return true
        elseif key == "up" then
            ADDON.down_index = 0
            ADDON.up_index = ADDON.up_index + 1
            if ADDON.up_index > #ADDON.up_cmds then ADDON.up_index = 1 end
            ADDON.console.input = ADDON.up_cmds[ADDON.up_index]
            return true
        elseif key == "down" then
            ADDON.up_index = 0
            ADDON.down_index = ADDON.down_index + 1
            if ADDON.down_index > #ADDON.down_cmds then ADDON.down_index = 1 end
            ADDON.console.input = ADDON.down_cmds[ADDON.down_index]
            return true
        end
        return true
    end
    return false
end

function ADDON.handle_textinput(text)
    if G.wd_mg and G.wd_mg.active then return true end
    if ADDON.connecting then return true end
    if ADDON.console.open then
        text = text:gsub("[`~]", "")
        if text == "" then return true end
        ADDON.up_index, ADDON.down_index = 0, 0
        if #ADDON.console.input < 64 then ADDON.console.input = ADDON.console.input .. text end
        return true
    end
    return false
end

function ADDON.handle_wheelmoved(x, y)
    if G.wd_mg and G.wd_mg.active then return true end
    return false
end

function ADDON.handle_mousepressed(x, y, button)
    if G.wd_mg and G.wd_mg.active then G.wd_mg_mousepressed(x, y, button); return true end
    if not ADDON.console.open and ADDON.tab_rect and button == 1 then
        local r = ADDON.tab_rect
        if x >= r.x and x <= r.x + r.w and y >= r.y and y <= r.y + r.h then ADDON.open(); return true end
    end
    return false
end

function ADDON.draw()
    if G.wd_mg and G.wd_mg.active then G.wd_mg_draw(); return end
    if G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH then draw_discount_overlay() end
    if not ADDON.console.open then draw_hack_tab() else ADDON.tab_rect = nil end

    local c = ADDON.console
    local target = c.open and 1 or 0
    c.anim = c.anim + (target - c.anim) * math.min(love.timer.getDelta() * 8, 1)
    if c.anim < 0.01 and target == 0 then c.anim = 0 end
    if c.anim < 0.01 and target == 1 then c.anim = 0.01 end
    if c.anim <= 0 then return end

    local A, sw, sh = c.anim, love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 0.94 * A); love.graphics.rectangle("fill", 0, 0, sw, sh)

    local pad, bx, by, bw, bh = 20, 20, 20, sw - 40, sh - 40
    love.graphics.setScissor(bx, by, bw, bh)

    local bg = load_console_bg()
    if bg then
        local scale = math.max(sw / bg:getWidth(), sh / bg:getHeight())
        local dw, dh = bg:getWidth() * scale, bg:getHeight() * scale
        local t = love.timer.getTime()
        love.graphics.setColor(1, 1, 1, 0.15 * A)
        love.graphics.draw(bg, (sw - dw) / 2 + math.sin(t * 0.4) * 40, (sh - dh) / 2 + math.cos(t * 0.3) * 40, 0, scale, scale)
    end

    love.graphics.setColor(0.1, 1.0, 0.2, 0.035 * A)
    for y = 0, sh, 4 do love.graphics.rectangle("fill", 0, y, sw, 1) end
    love.graphics.setColor(0.1, 0.9, 0.2, 0.04 * A)
    for x = 0, sw, 40 do love.graphics.rectangle("fill", x, 0, 1, sh) end
    for y = 0, sh, 40 do love.graphics.rectangle("fill", 0, y, sw, 1) end

    love.graphics.setColor(0, 0, 0, 0.15 * A)
    for y = 0, sh, 3 do love.graphics.rectangle("fill", 0, y, sw, 1) end

    love.graphics.setScissor()

    local is_hacking = ADDON.connecting ~= nil
    local is_bsi_boss = G.GAME and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == "bl_jokerstream_wd_bsi"
    local border_color = CLR.green
    if is_bsi_boss then border_color = CLR.turquoise end
    if is_hacking then border_color = CLR.red end

    local shake_x, shake_y = 0, 0
    if is_hacking then
        shake_x = math.random(-2, 2) * A
        shake_y = math.random(-2, 2) * A
    end

    love.graphics.setColor(border_color[1], border_color[2], border_color[3], 0.10 * A); love.graphics.setLineWidth(6)
    love.graphics.rectangle("line", bx - 3 + shake_x, by - 3 + shake_y, bw + 6, bh + 6, 8); love.graphics.setLineWidth(1)
    love.graphics.setColor(border_color[1], border_color[2], border_color[3], 0.9 * A); love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", bx + shake_x, by + shake_y, bw, bh, 6); love.graphics.setLineWidth(1)

    love.graphics.setColor(border_color[1], border_color[2], border_color[3], A); love.graphics.setLineWidth(3)
    local cl = 15
    love.graphics.line(bx + shake_x, by + cl + shake_y, bx + shake_x, by + shake_y, bx + cl + shake_x, by + shake_y)
    love.graphics.line(bx + bw - cl + shake_x, by + shake_y, bx + bw + shake_x, by + shake_y, bx + bw + shake_x, by + cl + shake_y)
    love.graphics.line(bx + shake_x, by + bh - cl + shake_y, bx + shake_x, by + bh + shake_y, bx + cl + shake_x, by + bh + shake_y)
    love.graphics.line(bx + bw - cl + shake_x, by + bh + shake_y, bx + bw + shake_x, by + bh + shake_y, bx + bw + shake_x, by + bh - cl + shake_y)
    love.graphics.setLineWidth(1)

    local font_big, font_main, font_small = get_mono_font(28), get_mono_font(24), get_mono_font(20)
    local hx, hy = bx + 20 + shake_x, by + 15 + shake_y

    if font_big then love.graphics.setFont(font_big) end
    love.graphics.setColor(border_color[1], border_color[2], border_color[3], A); love.graphics.print("// DEDSEC TERMINAL", hx, hy)

    if font_small then love.graphics.setFont(font_small) end
    love.graphics.setColor(0.35, 0.95, 0.95, 0.8 * A); love.graphics.print("v3.34", hx + (font_big and font_big:getWidth("// DEDSEC TERMINAL") or 260) + 15, hy + 6)

    local net_text = has_internet() and "NET: ONLINE" or "NET: OFFLINE"
    local net_color = has_internet() and CLR.green or CLR.red
    love.graphics.setColor(net_color[1], net_color[2], net_color[3], 0.9 * A)
    love.graphics.print(net_text, bx + bw - (font_small and font_small:getWidth(net_text) or 120) - 20 + shake_x, hy + 6)

    local energy = ADDON.get_energy()
    local en_text = "PWR ["
    for i = 1, 10 do
        if i <= energy then en_text = en_text .. "█" else en_text = en_text .. "░" end
    end
    en_text = en_text .. "] " .. energy .. "/10"

    love.graphics.setColor(1, 0.9, 0.25, A)
    if font_big then love.graphics.setFont(font_big) end
    love.graphics.print(en_text, bx + bw - (font_big and font_big:getWidth(en_text) or 260) - 20 + shake_x, by + bh - 115 + shake_y)

    if font_small then love.graphics.setFont(font_small) end
    love.graphics.setColor(1, 0.5, 0.4, A)
    love.graphics.print("ACTIVATED: " .. ((G.jokerstream_config and G.jokerstream_config.wd_codes_this_ante) or 0) .. "/2  TROJAN: +" .. math.floor(ADDON.get_trojan_bonus()*100) .. "%", hx, by + 62 + shake_y)

    love.graphics.setColor(border_color[1], border_color[2], border_color[3], 0.5 * A); love.graphics.setLineWidth(2)
    love.graphics.line(bx + 15 + shake_x, by + 90 + shake_y, bx + bw - 15 + shake_x, by + 90 + shake_y); love.graphics.setLineWidth(1)

    local hist_top, hist_bottom, line_h = by + 100, by + bh - 85, 32
    local available_h = hist_bottom - hist_top
    local dt = love.timer.getDelta()
    for _, entry in ipairs(c.history) do
        if not entry.done then
            entry.shown = entry.shown + dt * c.chars_per_sec
            if entry.shown >= entry.total_len then entry.shown = entry.total_len; entry.done = true end
        end
    end

    local start_i = #c.history + 1
    local accumulated_h = 0
    for i = #c.history, 1, -1 do
        local entry = c.history[i]
        local entry_line_h = (entry.font_size and entry.font_size < 24) and (entry.font_size + 2) or line_h
        if accumulated_h + entry_line_h > available_h then break end
        accumulated_h = accumulated_h + entry_line_h
        start_i = i
    end

    local cur_y = hist_top + shake_y
    for i = start_i, #c.history do
        local entry = c.history[i]
        local entry_font = entry.font_size and get_mono_font(entry.font_size) or font_main
        local entry_line_h = (entry.font_size and entry.font_size < 24) and (entry.font_size + 2) or line_h
        local y = cur_y
        cur_y = cur_y + entry_line_h
        local chars_left = math.floor(entry.shown)
        local cur_x = bx + 25 + shake_x
        if entry_font then love.graphics.setFont(entry_font) end
        love.graphics.setScissor(bx + 10, hist_top, bw - 20, hist_bottom - hist_top)
        for _, seg in ipairs(entry.segments) do
            if chars_left <= 0 then break end
            local text, color = seg[1], seg[2] or CLR.green
            local chunk = utf8_sub(text, math.min(chars_left, utf8_len(text)))
            if not entry.done then
                love.graphics.setColor(color[1], color[2], color[3], 0.25 * A)
                love.graphics.print(chunk, cur_x - 1, y); love.graphics.print(chunk, cur_x + 1, y)
            end
            love.graphics.setColor(color[1], color[2], color[3], A); love.graphics.print(chunk, cur_x, y)
            if color == CLR.strike and entry.done then
                local cw = entry_font and entry_font:getWidth(chunk) or 0
                local ch = entry_font and entry_font:getHeight() or 20
                love.graphics.setLineWidth(2); love.graphics.line(cur_x, y + ch / 2, cur_x + cw, y + ch / 2); love.graphics.setLineWidth(1)
            end
            cur_x = cur_x + (entry_font and entry_font:getWidth(chunk) or 0)
            chars_left = chars_left - utf8_len(chunk)
        end
        love.graphics.setScissor()
    end

    local input_top = by + bh - 70
    love.graphics.setColor(border_color[1], border_color[2], border_color[3], 0.5 * A); love.graphics.setLineWidth(2)
    love.graphics.line(bx + 15 + shake_x, input_top + shake_y, bx + bw - 15 + shake_x, input_top + shake_y); love.graphics.setLineWidth(1)

    if font_main then love.graphics.setFont(font_main) end
    love.graphics.setColor(border_color[1], border_color[2], border_color[3], A); love.graphics.print(">", bx + 25 + shake_x, input_top + 20 + shake_y)
    love.graphics.setColor(1, 1, 1, A); love.graphics.print(c.input, bx + 55 + shake_x, input_top + 20 + shake_y)

    local input_w = font_main and font_main:getWidth(c.input) or 0
    love.graphics.setColor(border_color[1], border_color[2], border_color[3], ((math.floor(love.timer.getTime() * 2) % 2 == 0) and 1 or 0) * A)
    love.graphics.rectangle("fill", bx + 55 + input_w + 3 + shake_x, input_top + 23 + shake_y, 14, 24)

    love.graphics.setColor(1, 1, 1, 1)
    draw_connection()
end

function ADDON.on_enable()
    load_console_bg()
    load_console_music()
    load_bsi_music()
    load_hack_sound()
    load_success_sound()
    load_fail_sound()
    load_energy_sound()
    load_tip_sound()

    if not G.jokerstream_config then G.jokerstream_config = {} end
    if G.jokerstream_config.wd_energy == nil then
        G.jokerstream_config.wd_energy = 3
        ADDON.save_config()
    end

    if not Game._wd_hooked then
        Game._wd_hooked = true
        local _orig = Game.update
        Game.update = function(game_self, dt)
            _orig(game_self, dt)
            if not (G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs")) then
                if ADDON.console.open then ADDON.close() end
                return
            end

            if G.GAME and G.GAME.blind and G.GAME.blind.boss then
                local _ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
                local _bkey = (G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key) or "boss"
                ADDON._current_boss_uid = _ante .. ":" .. _bkey
            end

            if G.GAME and G.GAME ~= ADDON._last_game_ref then
                local cur_round = G.GAME.round or 0
                local cur_ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
                if cur_ante == 1 and cur_round <= 1 then
                    ADDON.clear_history()
                    ADDON.set_energy(3)
                    ADDON._current_boss_uid = nil
                    ADDON._last_awarded_boss = nil
                end
            end
            if G.GAME then ADDON._last_game_ref = G.GAME end

            local mg_active = (G.wd_mg and G.wd_mg.active) or false
            local was_mg_active = ADDON._was_mg_active or false

            if ADDON.console.open or mg_active then
                if not ADDON._vanilla_muted then
                    stop_vanilla_music()
                    ADDON._vanilla_muted = true
                end
            elseif was_mg_active and not mg_active then
                restore_vanilla_music()
                ADDON._vanilla_muted = false
            elseif not ADDON.console.open and not mg_active then
                if ADDON._vanilla_muted then
                    restore_vanilla_music()
                    ADDON._vanilla_muted = false
                end
            end
            ADDON._was_mg_active = mg_active

            local is_bsi = G.GAME and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == "bl_jokerstream_wd_bsi"
            local bsi_music = load_bsi_music()

            if is_bsi and bsi_music then
                if not ADDON._bsi_music_playing and not ADDON.console.open and not mg_active then
                    if G.SOUND_MANAGER and G.SOUND_MANAGER.cur_music and G.SOUND_MANAGER.cur_music.source then
                        pcall(function() G.SOUND_MANAGER.cur_music.source:setVolume(0) end)
                    end
                    if G.SOUND_MANAGER then pcall(function() G.SOUND_MANAGER.music_vol = 0 end) end
                    pcall(function() bsi_music:setVolume(0.8); bsi_music:play() end)
                    ADDON._bsi_music_playing = true
                elseif (ADDON.console.open or mg_active) and ADDON._bsi_music_playing then
                    pcall(function() bsi_music:stop() end)
                    ADDON._bsi_music_playing = false
                end
            else
                if ADDON._bsi_music_playing then
                    pcall(function() bsi_music:stop() end)
                    ADDON._bsi_music_playing = false
                    if G.SOUND_MANAGER then
                        pcall(function() G.SOUND_MANAGER.music_vol = G.SETTINGS.SOUND.music_volume or 1 end)
                        if G.SOUND_MANAGER.cur_music and G.SOUND_MANAGER.cur_music.source then
                            pcall(function() G.SOUND_MANAGER.cur_music.source:setVolume(G.SETTINGS.SOUND.music_volume or 1) end)
                        end
                    end
                end
            end

            if ADDON.console_music then
                if ADDON.console.open and not ADDON.music_playing and not mg_active then
                    ADDON.console_music:setVolume(ADDON.music_volume); ADDON.console_music:play(); ADDON.music_playing = true
                elseif (not ADDON.console.open or mg_active) and ADDON.music_playing then
                    ADDON.console_music:stop(); ADDON.music_playing = false
                end
            end

            update_connection(dt)
            ADDON.try_apply_boss_manip()
            ADDON.reset_ante_if_changed()
            if G.wd_mg_update then G.wd_mg_update(dt) end

            if not ADDON.console.open and G.STATE and G.STATE ~= G.STATES.MENU then
                ADDON._reminder_timer = (ADDON._reminder_timer or 0) + dt
                if ADDON._reminder_timer >= 120 then
                    ADDON._reminder_timer = 0
                    local energy = ADDON.get_energy()
                    local msgs = energy >= 5 and {
                        "You have " .. energy .. " energy. Are you going to use it or just stare?",
                        "My console is getting cold. Press ~, cutie.",
                        "Those codes won't hack themselves. Type ~."
                    } or {
                        "Don't forget about me. Press ~ to open the console.",
                        "I'm still here. Waiting. Just like your ex.",
                        "Type ~ if you want to hack something. Or don't. I don't care."
                    }
                    if G.jokerstream_chat_current then
                        table.insert(G.jokerstream_chat_current, { nick = "Bagley", text = msgs[math.random(1, #msgs)], color = {1.0, 0.55, 0.20}, role = "viewer", bagley = true, anim = 0 })
                        while #G.jokerstream_chat_current > (G.jokerstream_chat_visible or 16) do table.remove(G.jokerstream_chat_current, 1) end
                    end
                end
            end

            if G.STATE == G.STATES.SHOP and G.jokerstream_config and G.jokerstream_config.wd_shop_pending then
                G.jokerstream_config.wd_shop_pending = nil
                ADDON.save_config()
            end

            if G.STATE == G.STATES.MENU then
                if G.jokerstream_config and G.jokerstream_config.wd_blinds_defeated ~= 0 then
                    G.jokerstream_config.wd_blinds_defeated = 0
                    ADDON.save_config()
                end
            end

            if G.STATE == G.STATES.SHOP then
                if not ADDON._was_shop then
                    ADDON._was_shop = true

                    local _uid = ADDON._current_boss_uid
                    if _uid and _uid ~= ADDON._last_awarded_boss then
                        ADDON._last_awarded_boss = _uid
                        ADDON.add_energy(1)
                        ADDON.log({ { "BOSS DEFEATED // ", CLR.green }, { "+1 Energy", CLR.yellow } })
                    end

                    ADDON.save_config()
                end
            else
                ADDON._was_shop = false
            end
        end
    end
end

function ADDON.on_disable()
    ADDON.console.open = false
    ADDON.connecting = nil
    if ADDON.console_music then ADDON.console_music:stop(); ADDON.music_playing = false end
    if ADDON.bsi_music then pcall(function() ADDON.bsi_music:stop() end); ADDON._bsi_music_playing = false end
    if ADDON.hack_sound then pcall(function() ADDON.hack_sound:stop() end) end
    restore_vanilla_music()
end

local orig_get_weight = SMODS.get_weight
if orig_get_weight then
    function SMODS.get_weight(self, args)
        local weight = orig_get_weight(self, args)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers["v_jokerstream_dedsec_booster"] then
            if self.set == "Joker" and self.rarity and self.rarity >= 1 and self.rarity <= 3 then return weight * 2 end
        end
        return weight
    end
end

local orig_card_draw_wd = Card.draw
function Card:draw(layer, ...)
    orig_card_draw_wd(self, layer, ...)
    if self.jokerstream_old_cost and self.area and (self.area == G.shop_jokers or self.area == G.shop_vouchers or self.area == G.shop_booster) and layer == 'card' then
        local font = get_mono_font(16); love.graphics.setFont(font)
        local text_scale = 0.55
        local price_x, price_y = self.T.x + self.T.w * 0.72, self.T.y + self.T.h * 0.72
        love.graphics.setColor(0, 0, 0, 0.85); love.graphics.rectangle("fill", self.T.x + self.T.w*0.5, self.T.y + self.T.h*0.7, self.T.w*0.5, self.T.h*0.25)
        love.graphics.setColor(0.85, 0.25, 0.25, 1)
        local old_text = "$" .. self.jokerstream_old_cost
        love.graphics.print(old_text, price_x, price_y - 4, 0, text_scale, text_scale)
        local old_w, old_h = font:getWidth(old_text) * text_scale, font:getHeight() * text_scale
        love.graphics.setLineWidth(2); love.graphics.line(price_x, price_y - 4 + old_h/2, price_x + old_w, price_y - 4 + old_h/2)
        love.graphics.setColor(0.35, 0.95, 0.95, 1)
        love.graphics.print("$" .. self.cost, price_x, price_y + 6, 0, text_scale, text_scale)
    end
end

local orig_ease_dollars = ease_dollars
ease_dollars = function(mod, ...)
    if not G.GAME or not G.HUD then return end
    return orig_ease_dollars(mod, ...)
end

return ADDON