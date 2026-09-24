-- ============================================
-- ACCOUNT.LUA — Регистрация аккаунта игрока
-- ============================================

print("[JOKER STREAM] account.lua loaded")

G.jokerstream_account = G.jokerstream_account or {
    api_key = nil,
    account_name = nil,
    real_name = nil,
    stream_theme = nil,
}

-- Гарантируем, что config существует
if not G.jokerstream_config then
    G.jokerstream_config = {}
end

local MOD_PATH = "C:/Users/МАКСИМУШКА/AppData/Roaming/Balatro/Mods/Twitch Balatro"
local SAVE_FILE_NFS = MOD_PATH .. "/jokerstream_save.txt"
local SAVE_FILE_LFS = "jokerstream_save.txt"

-- ============================================
-- ФАЙЛОВЫЕ ОПЕРАЦИИ
-- ============================================
local function jokerstream_save_write(content)
    if NFS then
        local ok, err = pcall(NFS.write, SAVE_FILE_NFS, content)
        print("[JOKER STREAM] >>> WRITE NFS:", ok, err)
    end
    local ok2, err2 = pcall(love.filesystem.write, SAVE_FILE_LFS, content)
    print("[JOKER STREAM] >>> WRITE LFS:", ok2, err2)
end

local function jokerstream_save_read()
    if NFS then
        local ok, data = pcall(NFS.read, SAVE_FILE_NFS)
        if ok and data and data ~= "" then
            print("[JOKER STREAM] <<< READ NFS: OK, length =", #data)
            return data
        end
        print("[JOKER STREAM] <<< READ NFS: FAIL", data)
    end
    local ok2, data2 = pcall(love.filesystem.read, SAVE_FILE_LFS)
    if ok2 and data2 and data2 ~= "" then
        print("[JOKER STREAM] <<< READ LFS: OK, length =", #data2)
        return data2
    end
    print("[JOKER STREAM] <<< READ LFS: FAIL", data2)
    return nil
end

local function jokerstream_save_remove()
    if NFS then pcall(NFS.remove, SAVE_FILE_NFS) end
    pcall(love.filesystem.remove, SAVE_FILE_LFS)
end

local function jokerstream_save_serialize()
    return table.concat({
        "api_key=" .. (G.jokerstream_account.api_key or ""),
        "account_name=" .. (G.jokerstream_account.account_name or ""),
        "real_name=" .. (G.jokerstream_account.real_name or ""),
        "stream_theme=" .. (G.jokerstream_account.stream_theme or ""),
        "saved_at=" .. os.date("%Y-%m-%d %H:%M:%S"),
    }, "\n")
end

local function jokerstream_save_parse(content)
    if not content then return nil end
    local data = {}
    for line in content:gmatch("[^\r\n]+") do
        local k, v = line:match("^([^=]+)=(.*)$")
        if k and v then data[k] = v end
    end
    return data
end

local function jokerstream_remove_old_files()
    if NFS then
        pcall(NFS.remove, MOD_PATH .. "/account.txt")
        pcall(NFS.remove, MOD_PATH .. "/account_data.txt")
    end
    pcall(love.filesystem.remove, "account.txt")
    pcall(love.filesystem.remove, "account_data.txt")
    pcall(love.filesystem.remove, "jokerstream_account.txt")
end
jokerstream_remove_old_files()

local function jokerstream_generate_api_key()
    local key = ""
    for _ = 1, 12 do
        key = key .. tostring(math.random(0, 9))
    end
    return key
end

-- ============================================
-- ПУБЛИЧНЫЕ ФУНКЦИИ
-- ============================================
function G.jokerstream_account_load()
    local content = jokerstream_save_read()
    if not content then
        print("[JOKER STREAM] Save file not found")
        G.jokerstream_account = { api_key = nil, account_name = nil, real_name = nil, stream_theme = nil }
        return false
    end
    local data = jokerstream_save_parse(content)
    if not data
       or not data.api_key or data.api_key == ""
       or not data.account_name or data.account_name == ""
       or not data.real_name or data.real_name == ""
       or not data.stream_theme or data.stream_theme == "" then
        print("[JOKER STREAM] Save file incomplete")
        G.jokerstream_account = { api_key = nil, account_name = nil, real_name = nil, stream_theme = nil }
        return false
    end
    G.jokerstream_account.api_key = data.api_key
    G.jokerstream_account.account_name = data.account_name
    G.jokerstream_account.real_name = data.real_name
    G.jokerstream_account.stream_theme = data.stream_theme

    -- Записываем и в account, и в config
    G.jokerstream_config.api_key = data.api_key
    G.jokerstream_config.account_name = data.account_name
    G.jokerstream_config.real_name = data.real_name
    G.jokerstream_config.stream_theme = data.stream_theme
    G.jokerstream_config.welcome_shown = true

    print("[JOKER STREAM] Account loaded: @" .. data.account_name .. " -> config = " .. tostring(G.jokerstream_config.account_name))
    return true
end

function G.jokerstream_account_save()
    local content = jokerstream_save_serialize()
    jokerstream_save_write(content)

    G.jokerstream_config.api_key = G.jokerstream_account.api_key
    G.jokerstream_config.account_name = G.jokerstream_account.account_name
    G.jokerstream_config.real_name = G.jokerstream_account.real_name
    G.jokerstream_config.stream_theme = G.jokerstream_account.stream_theme
    G.jokerstream_config.welcome_shown = true

    if SMODS and SMODS.save_mod_config and SMODS.current_mod then
        SMODS.save_mod_config(SMODS.current_mod)
    end
    print("[JOKER STREAM] Account saved: @" .. (G.jokerstream_account.account_name or "?"))
end

function G.jokerstream_account_is_registered()
    return G.jokerstream_account.api_key and G.jokerstream_account.api_key ~= ""
       and G.jokerstream_account.account_name and G.jokerstream_account.account_name ~= ""
       and G.jokerstream_account.real_name and G.jokerstream_account.real_name ~= ""
       and G.jokerstream_account.stream_theme and G.jokerstream_account.stream_theme ~= ""
end

function G.jokerstream_account_reset()
    jokerstream_save_remove()
    G.jokerstream_account = { api_key = nil, account_name = nil, real_name = nil, stream_theme = nil }
    G.jokerstream_config.api_key = nil
    G.jokerstream_config.account_name = nil
    G.jokerstream_config.real_name = nil
    G.jokerstream_config.stream_theme = nil
    G.jokerstream_config.welcome_shown = false
    G.jokerstream_registration_start()
    print("[JOKER STREAM] Account reset, registration started")
end

-- ============================================
-- РЕГИСТРАЦИЯ (UI)
-- ============================================
G.jokerstream_registration = {
    active = false,
    phase = "matrix",
    timer = 0,
    alpha = 0,
    matrix_cols = {},
    fields = { account_name = "", real_name = "", stream_theme = "" },
    focused = 1,
    error = "",
    error_timer = 0,
    field_rects = {},
    button_rect = nil,
}

local jokerstream_submit_sequence = {
    { text = "SUBMITTING...",                start = 0.0, dur = 1.5 },
    { text = "REVIEWING APPLICATION...",     start = 1.5, dur = 1.5 },
    { text = "MODERATOR KARAL APPROVED YOU", start = 3.0, dur = 1.8 },
    { text = "GOOD LUCK",                    start = 4.8, dur = 1.2 },
}
local JOKERSTREAM_SUBMIT_TOTAL = 6.0
local JOKERSTREAM_DONE_HOLD = 1.2
local JOKERSTREAM_CLOSE_TIME = 1.2

local function jokerstream_account_font(size)
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
            G.jokerstream_font_cache[size] = font
            return font
        end
    end
    if G.FONTS then
        for _, f in pairs(G.FONTS) do
            if type(f) == "userdata" and f.getHeight then
                G.jokerstream_font_cache[size] = f
                return f
            end
        end
    end
    local ok, font = pcall(love.graphics.newFont, size)
    if ok and font then G.jokerstream_font_cache[size] = font; return font end
    return nil
end

local function jokerstream_draw_matrix(A, timer)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    local cs = 16
    local font = jokerstream_account_font(14)
    if font then love.graphics.setFont(font) end

    for _, col in ipairs(G.jokerstream_registration.matrix_cols) do
        for j = 0, 15 do
            local y = col.head_y - j * cs
            if y > -cs and y < screen_h then
                local a = math.max(0, 1 - j / 15) * A
                if j == 0 then
                    love.graphics.setColor(1.0, 0.6, 1.0, a)
                else
                    love.graphics.setColor(0.75, 0.25, 0.9, a * 0.85)
                end
                local ch = (math.floor(timer * 8 + j + col.x) % 2 == 0) and "0" or "1"
                love.graphics.print(ch, col.x, y)
            end
        end
    end
end

function G.jokerstream_registration_start()
    local reg = G.jokerstream_registration
    reg.active = true
    reg.phase = "matrix"
    reg.timer = 0
    reg.alpha = 0
    reg.focused = 1
    reg.error = ""
    reg.error_timer = 0

    if not G.jokerstream_account.api_key or G.jokerstream_account.api_key == "" then
        G.jokerstream_account.api_key = jokerstream_generate_api_key()
    end

    reg.fields.account_name = G.jokerstream_account.account_name or ""
    reg.fields.real_name = G.jokerstream_account.real_name or ""
    reg.fields.stream_theme = G.jokerstream_account.stream_theme or ""

    reg.matrix_cols = {}
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    local col_w = 16
    for x = 0, screen_w, col_w do
        table.insert(reg.matrix_cols, {
            x = x,
            head_y = math.random(-screen_h, 0),
            speed = math.random(180, 520),
        })
    end
    print("[JOKER STREAM] Registration started")
end

function G.jokerstream_registration_submit()
    local reg = G.jokerstream_registration
    local f = reg.fields
    if f.account_name == "" or f.real_name == "" or f.stream_theme == "" then
        reg.error = "ALL FIELDS REQUIRED"
        reg.error_timer = 2
        return
    end
    G.jokerstream_account.account_name = f.account_name
    G.jokerstream_account.real_name = f.real_name
    G.jokerstream_account.stream_theme = f.stream_theme
    G.jokerstream_account_save()
    reg.phase = "submitting"
    reg.timer = 0
end

function G.jokerstream_registration_update(dt)
    local reg = G.jokerstream_registration
    if not reg.active then return end
    reg.timer = reg.timer + dt
    if reg.error_timer > 0 then reg.error_timer = reg.error_timer - dt end

    for _, col in ipairs(reg.matrix_cols) do
        col.head_y = col.head_y + col.speed * dt
        if col.head_y > love.graphics.getHeight() + 400 then
            col.head_y = math.random(-400, 0)
        end
    end

    if reg.phase == "matrix" then
        reg.alpha = math.min(reg.timer / 0.4, 1)
        if reg.timer >= 3 then
            reg.phase = "form"
            reg.timer = 0
            reg.alpha = 0
        end
    elseif reg.phase == "form" then
        reg.alpha = math.min(reg.timer / 0.7, 1)
    elseif reg.phase == "submitting" then
        reg.alpha = 1
        if reg.timer >= JOKERSTREAM_SUBMIT_TOTAL then
            reg.phase = "done"
            reg.timer = 0
        end
    elseif reg.phase == "done" then
        reg.alpha = 1
        if reg.timer >= JOKERSTREAM_DONE_HOLD then
            reg.phase = "closing"
            reg.timer = 0
        end
    elseif reg.phase == "closing" then
        local p = math.min(reg.timer / JOKERSTREAM_CLOSE_TIME, 1.0)
        local eased = 1 - math.pow(1 - p, 3)
        reg.alpha = 1 - eased
        if p >= 1.0 then
            reg.active = false
            reg.alpha = 0
            print("[JOKER STREAM] Registration closed smoothly")
        end
    end
end

function G.jokerstream_registration_draw()
    local reg = G.jokerstream_registration
    if not reg.active then return end

    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    local A = reg.alpha
    if A <= 0 then return end

    love.graphics.setColor(0, 0, 0, 0.96 * A)
    love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)
    jokerstream_draw_matrix(A, reg.timer)

    if reg.phase == "matrix" then
        local big = jokerstream_account_font(28)
        if big then love.graphics.setFont(big) end
        love.graphics.setColor(1.0, 0.5, 1.0, A)
        local t1 = "INITIALIZING STREAM PROTOCOL..."
        local tw = big and big:getWidth(t1) or 400
        love.graphics.print(t1, screen_w / 2 - tw / 2, screen_h / 2 - 20)
        local dots = string.rep(".", math.floor(reg.timer * 3) % 4)
        local t2 = "CONNECTING" .. dots
        local tw2 = big and big:getWidth(t2) or 200
        love.graphics.setColor(0.75, 0.35, 1.0, A)
        love.graphics.print(t2, screen_w / 2 - tw2 / 2, screen_h / 2 + 20)
        return
    end

    local pw, ph = 600, 520
    local cx, cy = screen_w / 2, screen_h / 2
    local px, py = cx - pw / 2, cy - ph / 2

    local spin_progress = 1.0
    if reg.phase == "form" then
        spin_progress = math.min(reg.timer / 0.7, 1.0)
    end
    local eased = 1 - math.pow(1 - spin_progress, 3)
    local rotation = (1 - eased) * math.rad(360)
    local scale = 0.3 + 0.7 * eased

    if reg.phase == "closing" then
        local p = math.min(reg.timer / JOKERSTREAM_CLOSE_TIME, 1.0)
        local close_eased = p * p
        scale = scale * (1 - 0.15 * close_eased)
        py = py - 30 * close_eased
    end

    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.rotate(rotation)
    love.graphics.scale(scale, scale)
    love.graphics.translate(-cx, -cy)

    love.graphics.setColor(0.08, 0.05, 0.12, 0.98 * A)
    love.graphics.rectangle("fill", px, py, pw, ph, 16)
    love.graphics.setColor(0.75, 0.35, 1.0, A)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", px, py, pw, ph, 16)
    love.graphics.setLineWidth(1)

    local title_font = jokerstream_account_font(28)
    if title_font then love.graphics.setFont(title_font) end
    love.graphics.setColor(1, 0.6, 1, A)
    love.graphics.print("REGISTER STREAMER", px + 30, py + 25)

    if reg.phase == "submitting" then
        local sf = jokerstream_account_font(24)
        if sf then love.graphics.setFont(sf) end
        for _, m in ipairs(jokerstream_submit_sequence) do
            local lt = reg.timer - m.start
            if lt >= 0 and lt <= m.dur then
                local a = 1
                if lt < 0.3 then a = lt / 0.3 end
                if lt > m.dur - 0.3 then a = (m.dur - lt) / 0.3 end
                a = math.max(0, math.min(1, a))
                local tw = sf and sf:getWidth(m.text) or 200
                love.graphics.setColor(1, 0.85, 1.0, a * A)
                love.graphics.print(m.text, px + pw / 2 - tw / 2, py + ph / 2 - 12)
            end
        end
        love.graphics.pop()
        return
    end

    if reg.phase == "done" or reg.phase == "closing" then
        local done_font = jokerstream_account_font(26)
        if done_font then love.graphics.setFont(done_font) end
        love.graphics.setColor(0.6, 1, 0.6, A)
        love.graphics.printf("ACCOUNT SAVED!", px, py + ph/2 - 20, pw, "center")

        local sub_font = jokerstream_account_font(18)
        if sub_font then love.graphics.setFont(sub_font) end
        love.graphics.setColor(0.75, 0.85, 1.0, A * 0.9)
        love.graphics.printf("@" .. (G.jokerstream_account.account_name or ""),
            px, py + ph/2 + 20, pw, "center")
        love.graphics.pop()
        return
    end

    local key_font = jokerstream_account_font(18)
    if key_font then love.graphics.setFont(key_font) end
    love.graphics.setColor(0.7, 0.5, 1, A)
    love.graphics.print("YOUR API KEY:", px + 40, py + 80)
    local key_val_font = jokerstream_account_font(22)
    if key_val_font then love.graphics.setFont(key_val_font) end
    love.graphics.setColor(1.0, 0.7, 1.0, A)
    love.graphics.print(G.jokerstream_account.api_key or "000000000000", px + 40, py + 104)

    local labels = { "ACCOUNT NAME", "REAL NAME", "STREAM THEME" }
    local keys = { "account_name", "real_name", "stream_theme" }
    local field_font = jokerstream_account_font(16)
    local input_font = jokerstream_account_font(20)

    reg.field_rects = {}
    for i = 1, 3 do
        local y = py + 150 + (i-1) * 75
        if field_font then love.graphics.setFont(field_font) end
        love.graphics.setColor(0.7, 0.5, 1, A)
        love.graphics.print(labels[i], px + 40, y)

        local bx, by = px + 40, y + 22
        local bw, bh = pw - 80, 36

        reg.field_rects[i] = { x = bx, y = by, w = bw, h = bh }

        if reg.focused == i then
            love.graphics.setColor(0.3, 0.15, 0.4, 0.9 * A)
        else
            love.graphics.setColor(0.12, 0.08, 0.15, 0.9 * A)
        end
        love.graphics.rectangle("fill", bx, by, bw, bh, 6)
        if reg.focused == i then
            love.graphics.setColor(0.85, 0.5, 1, A)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", bx, by, bw, bh, 6)
            love.graphics.setLineWidth(1)
        end

        if input_font then love.graphics.setFont(input_font) end
        love.graphics.setColor(1, 0.95, 1, A)
        local text = reg.fields[keys[i]] or ""
        if reg.focused == i and (math.floor(love.timer.getTime() * 2) % 2 == 0) then
            text = text .. "|"
        end
        love.graphics.print(text, bx + 10, by + 6)
    end

    local btn_w, btn_h = 400, 50
    local btn_x = px + (pw - btn_w)/2
    local btn_y = py + ph - 80

    reg.button_rect = { x = btn_x, y = btn_y, w = btn_w, h = btn_h }

    love.graphics.setColor(0.5, 0.25, 0.7, A)
    love.graphics.rectangle("fill", btn_x, btn_y, btn_w, btn_h, 10)
    love.graphics.setColor(1, 0.6, 1, A)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", btn_x, btn_y, btn_w, btn_h, 10)
    love.graphics.setLineWidth(1)

    local btn_font = jokerstream_account_font(24)
    if btn_font then love.graphics.setFont(btn_font) end
    love.graphics.setColor(1, 1, 1, A)
    local btn_text = "SUBMIT REGISTRATION"
    local tw = btn_font and btn_font:getWidth(btn_text) or 200
    love.graphics.print(btn_text, btn_x + (btn_w - tw)/2, btn_y + 10)

    if reg.error_timer > 0 then
        local err_font = jokerstream_account_font(18)
        if err_font then love.graphics.setFont(err_font) end
        love.graphics.setColor(1, 0.2, 0.2, math.min(reg.error_timer, 1) * A)
        love.graphics.printf(reg.error, px, py + ph - 110, pw, "center")
    end

    love.graphics.pop()
end

-- ============================================
-- ХУКИ ВВОДА
-- ============================================
local orig_keypressed = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if key == "f8" then
        if G.jokerstream_account_reset then
            G.jokerstream_account_reset()
        end
        return
    end
    if key == "f9" then
        jokerstream_save_write(jokerstream_save_serialize())
        print("[JOKER STREAM] FORCED SAVE. account_name =", G.jokerstream_account.account_name)
        print("[JOKER STREAM] config.account_name =", G.jokerstream_config.account_name)
        return
    end

    local reg = G.jokerstream_registration
    if reg.active and reg.phase == "form" then
        if key == "tab" then
            reg.focused = (reg.focused % 3) + 1
        elseif key == "backspace" then
            local keys = { "account_name", "real_name", "stream_theme" }
            local k = keys[reg.focused]
            if #reg.fields[k] > 0 then
                reg.fields[k] = reg.fields[k]:sub(1, -2)
            end
        elseif key == "return" or key == "kpenter" then
            G.jokerstream_registration_submit()
        end
        return
    end
    if orig_keypressed then return orig_keypressed(key, scancode, isrepeat) end
end

local orig_textinput = love.textinput
function love.textinput(text)
    local reg = G.jokerstream_registration
    if reg.active and reg.phase == "form" then
        local keys = { "account_name", "real_name", "stream_theme" }
        local k = keys[reg.focused]
        if #reg.fields[k] < 40 then
            reg.fields[k] = reg.fields[k] .. text
        end
        return
    end
    if orig_textinput then return orig_textinput(text) end
end

local orig_mousepressed = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
    local reg = G.jokerstream_registration
    if reg.active and reg.phase == "form" then
        if button == 1 then
            if reg.button_rect then
                local r = reg.button_rect
                if x >= r.x and x <= r.x + r.w and y >= r.y and y <= r.y + r.h then
                    G.jokerstream_registration_submit()
                    return
                end
            end
            if reg.field_rects then
                for i, r in ipairs(reg.field_rects) do
                    if x >= r.x and x <= r.x + r.w and y >= r.y and y <= r.y + r.h then
                        reg.focused = i
                        return
                    end
                end
            end
        end
        return
    end
    if orig_mousepressed then return orig_mousepressed(x, y, button, istouch, presses) end
end

-- ============================================
-- ИНИЦИАЛИЗАЦИЯ
-- ============================================
if G.jokerstream_account_load then
    local loaded = G.jokerstream_account_load()
    if not loaded then
        if not G.jokerstream_account.api_key or G.jokerstream_account.api_key == "" then
            G.jokerstream_account.api_key = jokerstream_generate_api_key()
        end
        jokerstream_save_write(jokerstream_save_serialize())
        print("[JOKER STREAM] Created save file on startup")
    end
    if not G.jokerstream_account_is_registered() then
        G.jokerstream_registration_start()
    end
end

local orig_quit_init = love.quit
function love.quit()
    if G.jokerstream_account_save then
        jokerstream_save_write(jokerstream_save_serialize())
    end
    if orig_quit_init then return orig_quit_init() end
end