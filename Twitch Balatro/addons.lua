-- ============================================
-- ADDONS.LUA — Реестр аддонов + условная загрузка Watch Dogs
-- Загружается ПОСЛЕДНИМ в main.lua
-- ============================================

G.jokerstream_addons_loaded    = G.jokerstream_addons_loaded    or {}
G.jokerstream_addons_enabled   = G.jokerstream_addons_enabled   or {}
G.jokerstream_wd_jokers_loaded = G.jokerstream_wd_jokers_loaded or false

local function ensure_config()
    if not G.jokerstream_config then G.jokerstream_config = {} end
    if not G.jokerstream_config.addons then G.jokerstream_config.addons = {} end
    return G.jokerstream_config.addons
end

-- ============================================
-- СОХРАНЕНИЕ И ЗАГРУЗКА СОСТОЯНИЯ АДДОНОВ (В ФАЙЛ)
-- ============================================
local MOD_PATH = (SMODS and SMODS.current_mod and SMODS.current_mod.path) or G.jokerstream_mod_path or ""
local ADDON_FILE_NFS = MOD_PATH .. "/addons_state.txt"
local ADDON_FILE_LFS = "addons_state.txt"

local function save_addon_state()
    local cfg = ensure_config()
    local lines = {}
    for k, v in pairs(cfg) do
        lines[#lines + 1] = tostring(k) .. "=" .. (v and "1" or "0")
    end
    local content = table.concat(lines, "\n")
    
    -- Пишем напрямую в файл (надежнее, чем вложенные таблицы SMODS)
    if NFS then pcall(NFS.write, ADDON_FILE_NFS, content) end
    pcall(love.filesystem.write, ADDON_FILE_LFS, content)
    
    -- Дополнительно сохраняем в конфиг Steamodded на всякий случай
    if SMODS and SMODS.save_mod_config and SMODS.current_mod then
        SMODS.save_mod_config(SMODS.current_mod)
    end
end

local function load_addon_state()
    local content
    if NFS then
        local ok, data = pcall(NFS.read, ADDON_FILE_NFS)
        if ok and data and data ~= "" then content = data end
    end
    if not content then
        local ok, data = pcall(love.filesystem.read, ADDON_FILE_LFS)
        if ok and data and data ~= "" then content = data end
    end
    if not content then return end
    
    local cfg = ensure_config()
    for line in content:gmatch("[^\r\n]+") do
        local k, v = line:match("^([^=]+)=(.*)$")
        if k and v then
            cfg[k] = (v == "1")
        end
    end
end

-- Экспортируем наружу, чтобы account.lua мог вызвать при регистрации
function G.jokerstream_save_addon_state() save_addon_state() end

-- ============================================
-- ПУБЛИЧНЫЙ API
-- ============================================
function G.jokerstream_addon_enabled(key)
    local cfg = ensure_config()
    if cfg[key] ~= nil then return cfg[key] == true end
    local a = G.jokerstream_addons_loaded[key]
    if a and a.meta and a.meta.enabled_default ~= nil then
        return a.meta.enabled_default == true
    end
    return true
end

function G.jokerstream_addon_list()
    local list = {}
    for k, _ in pairs(G.jokerstream_addons_loaded) do
        table.insert(list, k)
    end
    table.sort(list)
    return list
end

function G.jokerstream_addon_get(key) return G.jokerstream_addons_loaded[key] end

function G.jokerstream_addon_icon(key)
    local a = G.jokerstream_addons_loaded[key]
    return (a and a.meta and a.meta.icon) or "?"
end
function G.jokerstream_addon_label(key)
    local a = G.jokerstream_addons_loaded[key]
    return (a and a.meta and a.meta.name) or key
end
function G.jokerstream_addon_desc(key)
    local a = G.jokerstream_addons_loaded[key]
    return (a and a.meta and a.meta.desc) or ""
end
function G.jokerstream_addon_author(key)
    local a = G.jokerstream_addons_loaded[key]
    return (a and a.meta and a.meta.author) or "?"
end
function G.jokerstream_addon_icon_image(key)
    local a = G.jokerstream_addons_loaded[key]
    return a and a.icon_image or nil
end

-- ============================================
-- ДЖОКЕРЫ WATCH DOGS — ЗАГРУЗКА / ВЫГРУЗКА
-- ============================================
local WD_JOKER_KEYS = {
    "j_jokerstream_watcher",
    "j_jokerstream_watcher_glitched",
    "j_jokerstream_secret_path_recruit",
    "j_jokerstream_you_see_me_in_donut_verse",
    "j_jokerstream_server_ghost",
    "j_jokerstream_deadsec_",
    "j_jokerstream_decrypt_me",
    "j_jokerstream_we_xs3w",
    "j_jokerstream_processor_sergey",
    "j_jokerstream_city_of_terror",
    "j_jokerstream_dedsec_txt",
    "j_jokerstream_mamular",
    "j_jokerstream_deg75",
    "j_jokerstream_karma_for_deed",
    "j_jokerstream_wsw_ghost",
    "j_jokerstream_dead_archive",
    "j_jokerstream_binary_code",
    "j_jokerstream_dead_exe",
    "j_jokerstream_vinyl_hack",
    "j_jokerstream_nuclear_gift",
    "j_jokerstream_anonymity",
}

local function is_wd_joker_key(k)
    if not k then return false end
    for _, wd in ipairs(WD_JOKER_KEYS) do
        if k == wd then return true end
    end
    return false
end

function G.jokerstream_load_wd_jokers()
    if G.jokerstream_wd_jokers_loaded then return end
    local loader = SMODS.load_file("addons/watch_dogs/jokers.lua")
    if not loader then
        print("[JOKER STREAM] addons/watch_dogs/jokers.lua NOT FOUND")
        return
    end
    local ok, err = pcall(loader)
    if ok then
        G.jokerstream_wd_jokers_loaded = true
        print("[JOKER STREAM] Watch Dogs jokers LOADED")
    else
        print("[JOKER STREAM] Watch Dogs jokers load FAILED:", tostring(err))
    end
end

function G.jokerstream_unload_wd_jokers()
    if G.jokers and G.jokers.cards then
        for i = #G.jokers.cards, 1, -1 do
            local j = G.jokers.cards[i]
            local k = j.config and j.config.center and j.config.center.key
            if is_wd_joker_key(k) then
                pcall(function() SMODS.destroy_cards({ j }, { pinch_anim = true }) end)
            end
        end
    end
    if G.shop_jokers and G.shop_jokers.cards then
        for i = #G.shop_jokers.cards, 1, -1 do
            local c = G.shop_jokers.cards[i]
            local k = c.config and c.config.center and c.config.center.key
            if is_wd_joker_key(k) then
                pcall(function() SMODS.destroy_cards({ c }, { pinch_anim = true }) end)
            end
        end
    end
    print("[JOKER STREAM] Watch Dogs jokers purged from board/shop")
end

-- ============================================
-- ПЕРЕКЛЮЧАТЕЛЬ АДДОНА
-- ============================================
function G.jokerstream_set_addon(key, value)
    local cfg = ensure_config()
    local new_val = (value == true)
    cfg[key] = new_val

    -- ВЫЗЫВАЕМ СОХРАНЕНИЕ
    save_addon_state()

    if key == "watch_dogs" then
        if new_val then
            G.jokerstream_load_wd_jokers()
        else
            G.jokerstream_unload_wd_jokers()
        end
    end

    local a = G.jokerstream_addons_loaded[key]
    if a then
        if new_val and a.on_enable then pcall(a.on_enable) end
        if not new_val and a.on_disable then pcall(a.on_disable) end
    end
end

-- ============================================
-- РЕГИСТРАЦИЯ АДДОНА
-- ============================================
function G.jokerstream_register_addon(addon)
    if not addon or not addon.meta or not addon.meta.key then
        print("[JOKER STREAM] register_addon: invalid addon")
        return
    end
    local key = addon.meta.key
    G.jokerstream_addons_loaded[key] = addon

    if addon.meta.icon_path then
        local MOD_PATH = (SMODS and SMODS.current_mod and SMODS.current_mod.path) or ""
        local rel = "addons/" .. key .. "/" .. addon.meta.icon_path

        local function try_lfs(p)
            if love.filesystem.getInfo and love.filesystem.getInfo(p) then
                local ok, img = pcall(love.graphics.newImage, p)
                if ok and img then return img end
            end
            return nil
        end

        local img = try_lfs(rel)
        if not img then
            for _, p in ipairs({
                "assets/" .. addon.meta.icon_path,
                "assets/icons/" .. addon.meta.icon_path,
                addon.meta.icon_path,
            }) do
                img = try_lfs(p); if img then break end
            end
        end
        if not img and NFS and MOD_PATH ~= "" then
            for _, p in ipairs({
                MOD_PATH .. "/" .. rel,
                MOD_PATH .. "/assets/" .. addon.meta.icon_path,
                MOD_PATH .. "/assets/icons/" .. addon.meta.icon_path,
            }) do
                local ok, bytes = pcall(NFS.read, p)
                if ok and bytes and #bytes > 0 then
                    local fd = love.filesystem.newFileData(bytes, addon.meta.icon_path)
                    local ok2, i2 = pcall(love.graphics.newImage, fd)
                    if ok2 and i2 then img = i2; break end
                end
            end
        end
        if img then addon.icon_image = img end
    end

    if G.jokerstream_addon_enabled(key) then
        if key == "watch_dogs" then G.jokerstream_load_wd_jokers() end
        if addon.on_enable then pcall(addon.on_enable) end
    end

    print("[JOKER STREAM] Addon registered:", key,
          "| enabled:", tostring(G.jokerstream_addon_enabled(key)))
end

-- ============================================
-- ЗАГРУЗКА ADDON.LUA (мета + консоль)
-- ============================================
do
    local loader = SMODS.load_file("addons/watch_dogs/addon.lua")
    if not loader then
        print("[JOKER STREAM] addons/watch_dogs/addon.lua NOT FOUND")
    else
        local ok, wd = pcall(loader)
        if ok and type(wd) == "table" and wd.meta then
            G.jokerstream_register_addon(wd)
        else
            print("[JOKER STREAM] addon.lua bad return:", type(wd), tostring(wd))
        end
    end
end

-- ============================================
-- ХУК: не рисовать джокеры Watch Dogs, если аддон выключен
-- ============================================
local _orig_card_draw_wd = Card.draw
function Card:draw(layer, ...)
    local k = self.config and self.config.center and self.config.center.key
    if is_wd_joker_key(k) and not G.jokerstream_addon_enabled("watch_dogs") then
        return
    end
    return _orig_card_draw_wd(self, layer, ...)
end

-- ============================================
-- ЗАГРУЗКА СОСТОЯНИЯ И ДЕФОЛТЫ
-- ============================================
load_addon_state() -- Сначала грузим сохранения из файла

do
    local cfg = ensure_config()
    if cfg.watch_dogs == nil then 
        cfg.watch_dogs = true 
        save_addon_state() -- Сохраняем дефолт при первом запуске
    end
end

print("[JOKER STREAM] addons.lua loaded, registered:",
      table.concat(G.jokerstream_addon_list(), ", "))