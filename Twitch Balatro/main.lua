-- ============================================
-- TWITCH BALATRO — main.lua
-- ============================================

if SMODS and SMODS.current_mod and SMODS.current_mod.path then
    G.jokerstream_mod_path = SMODS.current_mod.path
end

-- ============================================
-- АТЛАСЫ
-- ============================================
SMODS.Atlas{ key = "AppleAtlas", path = "apple.png", px = 71, py = 95 }
SMODS.Atlas{ key = "BananaAtlas", path = "banana.png", px = 71, py = 95 }
SMODS.Atlas{ key = "TohaAtlas", path = "toha.png", px = 71, py = 95 }
SMODS.Atlas{ key = "SpeedAtlas", path = "ishowspeed.png", px = 71, py = 95 }
SMODS.Atlas{ key = "StintaAtlas", path = "stinta.png", px = 71, py = 95 }
SMODS.Atlas{ key = "OrangeAtlas", path = "orange.png", px = 71, py = 95 }
SMODS.Atlas{ key = "NelyaAtlas", path = "nelya.png", px = 71, py = 95 }
SMODS.Atlas{ key = "MazelolAtlas", path = "mazelol.png", px = 71, py = 95 }
SMODS.Atlas{ key = "DrakeAtlas", path = "drake.png", px = 71, py = 95 }
SMODS.Atlas{ key = "WatermelonAtlas", path = "watermelon.png", px = 71, py = 95 }
SMODS.Atlas{ key = "FoodTipsAtlas", path = "food_tips.png", px = 71, py = 95 }
SMODS.Atlas{ key = "FoodTipsPlusAtlas", path = "food_tips_plus.png", px = 71, py = 95 }
SMODS.Atlas{ key = "FoodAllAtlas", path = "food_all.png", px = 71, py = 95 }
SMODS.Atlas{ key = "PyaterkaAtlas", path = "pyaterka.png", px = 71, py = 95 }
SMODS.Atlas{ key = "MazelolThoughtfulAtlas", path = "mazelol_thoughtful.png", px = 71, py = 95 }
SMODS.Atlas{ key = "SinRareAtlas", path = "sin_rarity.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ChatAtlas", path = "chat.png", px = 71, py = 95 }
SMODS.Atlas{ key = "MinecraftAtlas", path = "minecraft.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorAtlas", path = "moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "AdsAtlas", path = "ads.png", px = 71, py = 95 }
SMODS.Atlas{ key = "SponsorAtlas", path = "sponsor.png", px = 71, py = 95 }
SMODS.Atlas{ key = "BrokerAtlas", path = "broker.png", px = 71, py = 95 }
SMODS.Atlas{ key = "CryingObsidianAtlas", path = "crying_obsidian.png", px = 71, py = 95 }
SMODS.Atlas{ key = "LurkerAtlas", path = "lurker.png", px = 71, py = 95 }
SMODS.Atlas{ key = "PixelStintaAtlas", path = "pixel_stinta.png", px = 71, py = 95 }
SMODS.Atlas{ key = "BathStintaAtlas", path = "bath_stinta.png", px = 71, py = 95 }
SMODS.Atlas{ key = "CaseOhAtlas", path = "caseoh.png", px = 71, py = 95 }
SMODS.Atlas{ key = "TwitchAtlas", path = "twitch.png", px = 71, py = 95 }
SMODS.Atlas{ key = "StintAtlas", path = "stint.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ClownAtlas", path = "clown.png", px = 71, py = 95 }
SMODS.Atlas{ key = "GojoAtlas", path = "gojo.png", px = 71, py = 95 }
SMODS.Atlas{ key = "PixelDrakeAtlas", path = "pixel_drake.png", px = 71, py = 95 }
SMODS.Atlas{ key = "OgorodnikAtlas", path = "ogorodnik.png", px = 71, py = 95 }
SMODS.Atlas{ key = "DessertAtlas", path = "dessert.png", px = 71, py = 95 }

-- Watch Dogs
SMODS.Atlas{ key = "WatcherAtlas",         path = "watcher.png",          px = 71, py = 95 }
SMODS.Atlas{ key = "WatcherGlitchedAtlas", path = "watcher_glitched.png", px = 71, py = 95 }
SMODS.Atlas{ key = "VhsGlitchAtlas",       path = "vhs_glitch.png",       px = 71, py = 95 }
SMODS.Atlas{ key = "DedsecCoreAtlas",      path = "dedsec_core.png",      px = 71, py = 95 }
SMODS.Atlas{ key = "ServerGhostAtlas",     path = "server_ghost.png",     px = 71, py = 95 }
SMODS.Atlas{ key = "DeadsecAtlas",         path = "deadsec.png",          px = 71, py = 95 }
SMODS.Atlas{ key = "DecryptMeAtlas",       path = "decrypt_me.png",       px = 71, py = 95 }
SMODS.Atlas{ key = "WeXs3wAtlas",          path = "we_xs3w.png",          px = 71, py = 95 }
SMODS.Atlas{ key = "ProcessorSergeyAtlas", path = "processor_sergey.png", px = 71, py = 95 }
SMODS.Atlas{ key = "CityOfTerrorAtlas",    path = "city_of_terror.png",   px = 71, py = 95 }
SMODS.Atlas{ key = "DedsecTxtAtlas",       path = "dedsec_txt.png",       px = 71, py = 95 }
SMODS.Atlas{ key = "MamularAtlas",         path = "mamular.png",          px = 71, py = 95 }
SMODS.Atlas{ key = "Deg75Atlas",           path = "deg75.png",            px = 71, py = 95 }
SMODS.Atlas{ key = "KarmaSkullAtlas",      path = "karma_skull.png",      px = 71, py = 95 }
SMODS.Atlas{ key = "DedsecBoosterAtlas",   path = "dedsec_booster.png",   px = 71, py = 95 }
SMODS.Atlas{ key = "WswGhostAtlas",        path = "wsw_ghost.png",        px = 71, py = 95 }
SMODS.Atlas{ key = "DeadArchiveAtlas",     path = "dead_archive.png",     px = 71, py = 95 }
SMODS.Atlas{ key = "BinaryAtlas",          path = "binary_code.png",      px = 71, py = 95 }
SMODS.Atlas{ key = "DeadExeAtlas",         path = "dead_exe.png",         px = 71, py = 95 }
SMODS.Atlas{ key = "VinylAtlas",           path = "vinyl_hack.png",       px = 71, py = 95 }
SMODS.Atlas{ key = "NuclearGiftAtlas",     path = "nuclear_gift.png",     px = 71, py = 95 }
SMODS.Atlas{ key = "AnonymityAtlas",       path = "anonymity.png",        px = 71, py = 95 }
SMODS.Atlas{ key = "FirewallAtlas",        path = "perfect_firewall.png", px = 71, py = 95 }
SMODS.Atlas{ key = "IpLocatorAtlas",       path = "ip_locator.png",       px = 71, py = 95 }
-- Босс
SMODS.Atlas{
    key = "RouletteBossAtlas",
    path = "roulette_boss.png",
    px = 71, py = 95,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1
}

-- Ваучеры
SMODS.Atlas{ key = "UnlimitedChatAtlas", path = "unlimited_chat.png", px = 71, py = 95 }
SMODS.Atlas{ key = "MemeChatAtlas", path = "meme_chat.png", px = 71, py = 95 }
SMODS.Atlas{ key = "VirusChatAtlas", path = "virus_chat.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorOfModeratorAtlas", path = "moderator_of_moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorOfModeratorOfModeratorAtlas", path = "moderator_of_moderator_of_moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorPocketUniverseAtlas", path = "moderator_pocket_universe.png", px = 71, py = 95 }
SMODS.Atlas{ key = "TwitchAlgorithmAtlas",     path = "twitch_algorithm.png",      px = 71, py = 95 }
SMODS.Atlas{ key = "TwitchAlgorithmPlusAtlas", path = "twitch_algorithm_plus.png", px = 71, py = 95 }
SMODS.Atlas{ key = "CaseOhDrakeAtlas",   path = "caseoh_drake.png",   px = 71, py = 95 }
SMODS.Atlas{ key = "CaseOhMazelolAtlas", path = "caseoh_mazelol.png", px = 71, py = 95 }
SMODS.Atlas{ key = "CaseOhAlphaAtlas",   path = "caseoh_alpha.png",   px = 71, py = 95 }
SMODS.Atlas{ key = "CaseOhTohaAtlas",    path = "caseoh_toha.png",    px = 71, py = 95 }
SMODS.Atlas{ key = "BizMazelolOfficeAtlas", path = "biz_mazelol_office.png", px = 71, py = 95 }
SMODS.Atlas{ key = "BizMazelolColdAtlas",   path = "biz_mazelol_cold.png",   px = 71, py = 95 }
SMODS.Atlas { key = "OneEqualsTwoAtlas", path = "one_equals_two.png", px = 71, py = 95 }



-- Алерты
SMODS.Atlas {
    key = "BullAlert", path = "bull_alert.png", px = 138, py = 190,
    frames = 8, atlas_table = 'ANIMATION_ATLAS',
}
SMODS.Atlas { key = "CoinAlert", path = "coin_alert.png", px = 138, py = 190 }
SMODS.Atlas {
    key = "AntAlert", path = "ant_alert.png", px = 138, py = 190,
    frames = 9, atlas_table = 'ANIMATION_ATLAS',
}

-- ============================================
-- ЗВУКИ
-- ============================================
SMODS.Sound{ key = "shotgun_rack", path = "shotgun_rack.ogg", pitch = 1, volume = 1 }
SMODS.Sound{ key = "shotgun_shot", path = "shotgun_shot.ogg", pitch = 1, volume = 1 }
SMODS.Sound{ key = "hate_raid",    path = "hate_raid.ogg",    pitch = 1, volume = 1 }

G.jokerstream_sounds = G.jokerstream_sounds or {}

local function try_load_sound(name)
    local MOD_PATH = SMODS.current_mod.path
    local rel_paths = {
        "resources/sounds/" .. name .. ".ogg",
        "sounds/" .. name .. ".ogg",
        "assets/sounds/" .. name .. ".ogg",
        "assets/" .. name .. ".ogg",
        name .. ".ogg",
    }
    for _, p in ipairs(rel_paths) do
        if love.filesystem.getInfo(p) then
            local ok, src = pcall(love.audio.newSource, p, "static")
            if ok and src then return src end
        end
    end
    if NFS then
        local abs_paths = {
            MOD_PATH .. "/resources/sounds/" .. name .. ".ogg",
            MOD_PATH .. "/sounds/" .. name .. ".ogg",
            MOD_PATH .. "/assets/sounds/" .. name .. ".ogg",
        }
        for _, p in ipairs(abs_paths) do
            local ok, bytes = pcall(NFS.read, p)
            if ok and bytes then
                local fd = love.filesystem.newFileData(bytes, name .. ".ogg")
                local sd = love.sound.newSoundData(fd)
                return love.audio.newSource(sd)
            end
        end
    end
    return nil
end

G.jokerstream_sounds.shotgun_rack = try_load_sound("shotgun_rack")
G.jokerstream_sounds.shotgun_shot = try_load_sound("shotgun_shot")
G.jokerstream_sounds.hate_raid    = try_load_sound("hate_raid")

-- ============================================
-- ЗАГРУЗКА ФАЙЛОВ МОДА
-- ============================================
local files_to_load = {
    "config.lua", "jokers.lua", "enhancements.lua", "vouchers.lua",
    "blinds.lua", "channel.lua", "chat.lua", "account.lua",
    "clips.lua", "challenges.lua"
}

for _, file in ipairs(files_to_load) do
    local loader = SMODS.load_file(file, SMODS.current_mod.id)
    if loader then
        local ok, err = pcall(loader)
        if not ok then
            print("[JOKER STREAM] ОШИБКА В ФАЙЛЕ " .. file .. ": " .. tostring(err))
        end
    else
        print("[JOKER STREAM] ФАЙЛ НЕ НАЙДЕН: " .. file)
    end
end

-- Загружаем миниигры
do
    local loader = SMODS.load_file("addons/watch_dogs/minigames.lua", SMODS.current_mod.id)
    if loader then
        local ok, err = pcall(loader)
        if not ok then
            print("[JOKER STREAM] minigames.lua ERROR:", tostring(err))
        end
    else
        print("[JOKER STREAM] minigames.lua NOT FOUND")
    end
end

-- Загружаем аддон Watch Dogs
local addon_loader = SMODS.load_file("addons.lua", SMODS.current_mod.id)
if addon_loader then
    local ok, err = pcall(addon_loader)
    if not ok then
        print("[JOKER STREAM] addons.lua ERROR:", tostring(err))
    end
else
    print("[JOKER STREAM] addons.lua NOT FOUND")
end

G.jokerstream_roulette_overlay = nil

-- ============================================
-- ХЕЛПЕРЫ
-- ============================================
local function _wd_get()
    if not G.jokerstream_addons_loaded then return nil end
    return G.jokerstream_addons_loaded["watch_dogs"] or nil
end

local function _wd_on()
    if not G.jokerstream_addon_enabled then return false end
    return G.jokerstream_addon_enabled("watch_dogs") == true
end

-- KEYPRESSED
local original_love_keypressed = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    local _wd = _wd_get()
    if _wd and _wd_on() and _wd.handle_keypressed then
        if _wd.handle_keypressed(key, scancode) then return end
    end
    if original_love_keypressed then
        return original_love_keypressed(key, scancode, isrepeat)
    end
end

-- TEXTINPUT
local original_love_textinput = love.textinput
function love.textinput(text)
    local _wd = _wd_get()
    if _wd and _wd_on() and _wd.handle_textinput then
        if _wd.handle_textinput(text) then return end
    end
    if original_love_textinput then
        return original_love_textinput(text)
    end
end

-- WHEELMOVED
local original_love_wheelmoved = love.wheelmoved
function love.wheelmoved(x, y)
    local _wd = _wd_get()
    if _wd and _wd_on() and _wd.handle_wheelmoved then
        if _wd.handle_wheelmoved(x, y) then return end
    end
    if original_love_wheelmoved then
        return original_love_wheelmoved(x, y)
    end
end

-- DRAW
local original_love_draw = love.draw
function love.draw()
    original_love_draw()

    if G.jokerstream_roulette_overlay then
        love.graphics.setColor(G.jokerstream_roulette_overlay)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end

    if G.jokerstream_chat_draw then G.jokerstream_chat_draw() end
    if G.jokerstream_alerts_draw then G.jokerstream_alerts_draw() end

    if G.jokerstream_challenge_draw then
        local box = G.jokerstream_chat_box_rect
        if box then
            G.jokerstream_challenge_draw(
                love.graphics.getWidth(), love.graphics.getHeight(),
                box.x, box.y, box.w
            )
        end
    end

    if G.jokerstream_channel_draw then G.jokerstream_channel_draw() end
    if G.jokerstream_registration_draw then G.jokerstream_registration_draw() end

    local _wd = _wd_get()
    if _wd and _wd_on() and _wd.draw then _wd.draw() end
end

-- UPDATE
local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)
    if G.jokerstream_chat_update then G.jokerstream_chat_update(dt) end
    if G.jokerstream_alerts_update then G.jokerstream_alerts_update(dt) end
    if G.jokerstream_registration_update then G.jokerstream_registration_update(dt) end
    if G.jokerstream_clips and G.jokerstream_clips.passive_tick then
        G.jokerstream_clips.passive_tick(dt)
    end
end

-- MOUSEPRESSED
local original_love_mousepressed = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
    local _wd = _wd_get()
    if _wd and _wd_on() and _wd.handle_mousepressed then
        if _wd.handle_mousepressed(x, y, button) then return end
    end
    if _wd and _wd_on() and _wd.console and _wd.console.open then return end
    if _wd and _wd_on() and _wd.connecting then return end
    if G.jokerstream_channel_mousepressed then
        if G.jokerstream_channel_mousepressed(x, y, button) then return end
    end
    if original_love_mousepressed then
        return original_love_mousepressed(x, y, button, istouch, presses)
    end
end

-- ВКЛАДКА НАСТРОЕК
if SMODS and SMODS.current_mod then
    G.jokerstream_config = G.jokerstream_config or {
        chat_enabled = true, intro_enabled = true, donators_enabled = true,
    }
    SMODS.current_mod.config_tab = function()
        return {
            n = G.UIT.ROOT,
            config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, minw = 7, minh = 3, emboss = 0.05 },
            nodes = {
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({ label = "Chat", ref_table = G.jokerstream_config, ref_value = "chat_enabled",
                        callback = function() if SMODS.save_mod_config then SMODS.save_mod_config(SMODS.current_mod) end end })
                }},
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({ label = "Run Intro", ref_table = G.jokerstream_config, ref_value = "intro_enabled",
                        callback = function() if SMODS.save_mod_config then SMODS.save_mod_config(SMODS.current_mod) end end })
                }},
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({ label = "Donators Panel", ref_table = G.jokerstream_config, ref_value = "donators_enabled",
                        callback = function() if SMODS.save_mod_config then SMODS.save_mod_config(SMODS.current_mod) end end })
                }},
            }
        }
    end
    SMODS.current_mod.has_config = true
end