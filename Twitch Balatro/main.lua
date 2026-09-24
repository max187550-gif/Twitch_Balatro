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
SMODS.Atlas{ key = "GojoAtlas",       path = "gojo.png",        px = 71, py = 95 }
SMODS.Atlas{ key = "PixelDrakeAtlas", path = "pixel_drake.png", px = 71, py = 95 }
SMODS.Atlas{ key = "OgorodnikAtlas",  path = "ogorodnik.png",   px = 71, py = 95 }
SMODS.Atlas{ key = "DessertAtlas", path = "dessert.png", px = 71, py = 95 }
SMODS.Atlas{

    key = "RouletteBossAtlas",
    path = "roulette_boss.png",
    px = 71, py = 95,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1
}

SMODS.Atlas{ key = "UnlimitedChatAtlas", path = "unlimited_chat.png", px = 71, py = 95 }
SMODS.Atlas{ key = "MemeChatAtlas",      path = "meme_chat.png",      px = 71, py = 95 }
SMODS.Atlas{ key = "VirusChatAtlas",     path = "virus_chat.png",     px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorAtlas", path = "moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorOfModeratorAtlas", path = "moderator_of_moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorOfModeratorOfModeratorAtlas", path = "moderator_of_moderator_of_moderator.png", px = 71, py = 95 }
SMODS.Atlas{ key = "ModeratorPocketUniverseAtlas", path = "moderator_pocket_universe.png", px = 71, py = 95 }

SMODS.Sound{ key = "shotgun_rack", path = "shotgun_rack.ogg", pitch = 1, volume = 1 }
SMODS.Sound{ key = "shotgun_shot", path = "shotgun_shot.ogg", pitch = 1, volume = 1 }
SMODS.Sound{ key = "hate_raid",    path = "hate_raid.ogg",    pitch = 1, volume = 1 }

G.jokerstream_sounds = G.jokerstream_sounds or {}

local function try_load_sound(name)
    local MOD_PATH = "C:/Users/МАКСИМУШКА/AppData/Roaming/Balatro/Mods/Twitch Balatro"
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
SMODS.load_file("jokers.lua")()
SMODS.load_file("enhancements.lua")()
SMODS.load_file("vouchers.lua")()
SMODS.load_file("blinds.lua")()
SMODS.load_file("config.lua")()
SMODS.load_file("channel.lua")()
SMODS.load_file("chat.lua")()
SMODS.load_file("account.lua")()
SMODS.load_file("clips.lua")()
SMODS.load_file("challenges.lua")()

G.jokerstream_roulette_overlay = nil

-- ============================================
-- DRAW
-- ============================================
local original_love_draw = love.draw

function love.draw()
    original_love_draw()

    if G.jokerstream_roulette_overlay then
        love.graphics.setColor(G.jokerstream_roulette_overlay)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end

    if G.jokerstream_chat_draw then
        G.jokerstream_chat_draw()
    end

    -- Челлендж выезжает СЛЕВА от чата
    if G.jokerstream_challenge_draw then
        local box = G.jokerstream_chat_box_rect
        if box then
            G.jokerstream_challenge_draw(
                love.graphics.getWidth(),
                love.graphics.getHeight(),
                box.x, box.y, box.w
            )
        end
    end

    if G.jokerstream_channel_draw then
        G.jokerstream_channel_draw()
    end

    if G.jokerstream_registration_draw then
        G.jokerstream_registration_draw()
    end
end

-- ============================================
-- UPDATE
-- ============================================
local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)

    if G.jokerstream_chat_update then
        G.jokerstream_chat_update(dt)
    end

    if G.jokerstream_registration_update then
        G.jokerstream_registration_update(dt)
    end

    if G.jokerstream_clips and G.jokerstream_clips.passive_tick then
        G.jokerstream_clips.passive_tick(dt)
    end

    -- Челленджи сами вызывают свой update внутри challenges.lua
    -- (там есть собственный хук на Game.update)
end

-- ============================================
-- MOUSEPRESSED
-- ============================================
local original_love_mousepressed = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
    -- Сначала панель канала (у неё приоритет над чатом)
    if G.jokerstream_channel_mousepressed then
        local handled = G.jokerstream_channel_mousepressed(x, y, button)
        if handled then return end
    end
    if original_love_mousepressed then
        return original_love_mousepressed(x, y, button, istouch, presses)
    end
end

-- ============================================
-- ВКЛАДКА НАСТРОЕК В ПАНЕЛИ МОДА
-- ============================================
if SMODS and SMODS.current_mod then
    G.jokerstream_config = G.jokerstream_config or {
        chat_enabled = true, intro_enabled = true, donators_enabled = true,
    }

    SMODS.current_mod.config_tab = function()
        return {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                padding = 0.1,
                r = 0.1,
                colour = G.C.BLACK,
                minw = 7,
                minh = 3,
                emboss = 0.05,
            },
            nodes = {
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({
                        label = "Chat",
                        ref_table = G.jokerstream_config,
                        ref_value = "chat_enabled",
                        callback = function()
                            if SMODS.save_mod_config then
                                SMODS.save_mod_config(SMODS.current_mod)
                            end
                        end,
                    }),
                }},
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({
                        label = "Run Intro",
                        ref_table = G.jokerstream_config,
                        ref_value = "intro_enabled",
                        callback = function()
                            if SMODS.save_mod_config then
                                SMODS.save_mod_config(SMODS.current_mod)
                            end
                        end,
                    }),
                }},
                { n = G.UIT.R, config = { align = "cm", padding = 0.15 }, nodes = {
                    create_toggle({
                        label = "Donators Panel",
                        ref_table = G.jokerstream_config,
                        ref_value = "donators_enabled",
                        callback = function()
                            if SMODS.save_mod_config then
                                SMODS.save_mod_config(SMODS.current_mod)
                            end
                        end,
                    }),
                }},
            }
        }
    end

    SMODS.current_mod.has_config = true
end