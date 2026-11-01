-- ============================================
-- CHALLENGES.LUA — Мини-задания канала (safe v2)
-- ============================================

local function round(x) return math.floor(x + 0.5) end

G.jokerstream_challenge = G.jokerstream_challenge or {
    active     = false,
    current    = nil,
    state      = nil,
    nick       = nil,
    pink_ratio = 0.5,
    target_pink = 0.5,
    anim_in    = 0,
    anim_out   = 0,
    result     = nil,
    result_t   = 0,
    reward     = 20,

    last_ante  = 0,
    roll_accum = 0,
    appeared_this_run = false,
    run_initialized = false,

    card_rect  = nil,
    flames     = {},
    _last_hand_uid = nil,
    TEST_ANTE3_ALWAYS = fals,
}

G.jokerstream_challenge_state = G.jokerstream_challenge.state

-- ============================================
-- ПУЛ ЗАДАНИЙ
-- ============================================
local POOL = {
    { id = "three_full_houses", title = "3 FULL HOUSES", desc = "Play 3 Full Houses this ante",
      target = 3,
      start = function(s) s.full_houses = 0 end,
      progress = function(s) return math.min(1, (s.full_houses or 0) / 3) end,
      check = function(s) return (s.full_houses or 0) >= 3 end },

    { id = "three_flushes", title = "3 FLUSHES", desc = "Play 3 Flushes this ante",
      target = 3,
      start = function(s) s.flushes = 0 end,
      progress = function(s) return math.min(1, (s.flushes or 0) / 3) end,
      check = function(s) return (s.flushes or 0) >= 3 end },

    { id = "two_four_kinds", title = "2 FOUR OF A KINDS", desc = "Play 2 Four of a Kinds",
      target = 2,
      start = function(s) s.four_kinds = 0 end,
      progress = function(s) return math.min(1, (s.four_kinds or 0) / 2) end,
      check = function(s) return (s.four_kinds or 0) >= 2 end },

    { id = "big_score", title = "10K IN ONE HAND", desc = "Score 10 000 in a single hand",
      target = 10000, big_number = true,
      start = function(s) s.max_hand_score = 0; s._chips_at_hand_start = nil; s._last_hp = nil end,
      progress = function(s) return math.min(1, (s.max_hand_score or 0) / 10000) end,
      check = function(s) return (s.max_hand_score or 0) >= 10000 end },

    { id = "mega_score", title = "30K IN ONE HAND", desc = "Score 30 000 in a single hand",
      target = 30000, big_number = true,
      start = function(s) s.max_hand_score = 0; s._chips_at_hand_start = nil; s._last_hp = nil end,
      progress = function(s) return math.min(1, (s.max_hand_score or 0) / 30000) end,
      check = function(s) return (s.max_hand_score or 0) >= 30000 end },

    { id = "hoarder", title = "HOLD $50", desc = "Hold $50 by end of ante",
      target = 50, money = true,
      start = function(s) end,
      progress = function(s) local d = (G.GAME and G.GAME.dollars) or 0; return math.min(1, d / 50) end,
      check = function(s) return ((G.GAME and G.GAME.dollars) or 0) >= 50 end },

    { id = "no_discards", title = "NO DISCARDS", desc = "Do not discard this ante",
      target = nil,
      start = function(s) s.discards_used = 0 end,
      progress = function(s) return (s.discards_used or 0) == 0 and 1 or 0 end,
      check = function(s) return (s.discards_used or 0) == 0 end },

    { id = "hands_master", title = "10 HANDS", desc = "Play 10 hands this ante",
      target = 10,
      start = function(s) s.hands_played = 0 end,
      progress = function(s) return math.min(1, (s.hands_played or 0) / 10) end,
      check = function(s) return (s.hands_played or 0) >= 10 end },

    { id = "straight", title = "STRAIGHT+", desc = "Play a Straight or higher",
      target = 1,
      start = function(s) s.got_straight = false end,
      progress = function(s) return s.got_straight and 1 or 0 end,
      check = function(s) return s.got_straight == true end },

    { id = "spade_hands", title = "3 SPADE HANDS", desc = "Play 3 hands with 3+ Spades",
      target = 3,
      start = function(s) s.spade_hands = 0 end,
      progress = function(s) return math.min(1, (s.spade_hands or 0) / 3) end,
      check = function(s) return (s.spade_hands or 0) >= 3 end },
}

local function pick_challenge_nick()
    local list = (G.jokerstream_nicks and G.jokerstream_nicks.fans) or { "pogmaster" }
    return list[math.random(1, #list)]
end

local function fmt_counter(n)
    n = tonumber(n) or 0
    if n >= 1000000 then return string.format("%.1fM", n / 1000000) end
    if n >= 1000 then return string.format("%.1fK", n / 1000) end
    return tostring(math.floor(n))
end

-- ============================================
-- СПАВН
-- ============================================
local function jokerstream_challenge_spawn()
    local ch = G.jokerstream_challenge
    local pick = POOL[math.random(1, #POOL)]
    ch.current = pick
    ch.state = {}
    ch.nick  = pick_challenge_nick()
    if pick.start then pcall(pick.start, ch.state) end
    ch.active = true
    ch.anim_in = 0
    ch.anim_out = 0
    ch.result = nil
    ch.result_t = 0
    ch.appeared_this_run = true
    ch.pink_ratio = 0.5
    ch.target_pink = 0.5
    ch._last_hand_uid = nil

    ch.flames = {}
    for i = 1, 14 do
        ch.flames[i] = {
            phase = math.random() * math.pi * 2,
            speed = 3.0 + math.random() * 3.0,
            scale = 0.9 + math.random() * 0.4,
        }
    end

    G.jokerstream_challenge_state = ch.state

    if G.jokerstream_chat_current then
        table.insert(G.jokerstream_chat_current, {
            nick = ch.nick,
            text = "challenge: " .. pick.title .. " — +$20!",
            color = {0.7, 0.85, 1.0},
            role = "viewer", anim = 0,
        })
        while #G.jokerstream_chat_current > (G.jokerstream_chat_visible or 16) do
            table.remove(G.jokerstream_chat_current, 1)
        end
    end
end

local function jokerstream_challenge_resolve(win)
    local ch = G.jokerstream_challenge
    ch.result = win and "win" or "lose"
    ch.result_t = 0

    if win then
        pcall(function()
            if ease_dollars then ease_dollars(ch.reward) end
        end)
        if G.jokerstream_chat_current then
            table.insert(G.jokerstream_chat_current, {
                nick = "system",
                text = ch.nick .. " paid $" .. ch.reward .. "!",
                color = {0.5, 1.0, 0.7}, role = "viewer", sub = true, anim = 0,
            })
            while #G.jokerstream_chat_current > (G.jokerstream_chat_visible or 16) do
                table.remove(G.jokerstream_chat_current, 1)
            end
        end
    else
        if G.jokerstream_chat_current then
            table.insert(G.jokerstream_chat_current, {
                nick = "system",
                text = "Challenge from " .. ch.nick .. " failed...",
                color = {1.0, 0.4, 0.4}, role = "viewer", anim = 0,
            })
            while #G.jokerstream_chat_current > (G.jokerstream_chat_visible or 16) do
                table.remove(G.jokerstream_chat_current, 1)
            end
        end
    end
end

function G.jokerstream_challenge_reset()
    local ch = G.jokerstream_challenge
    ch.active = false; ch.current = nil; ch.state = nil; ch.nick = nil
    ch.anim_in = 0; ch.anim_out = 0; ch.result = nil; ch.result_t = 0
    ch.last_ante = 0; ch.roll_accum = 0
    ch.appeared_this_run = false; ch.run_initialized = false
    ch._last_hand_uid = nil
    G.jokerstream_challenge_state = nil
end

function G.jokerstream_challenge_on_run_start()
    G.jokerstream_challenge_reset()
end

local function jokerstream_challenge_try_spawn(ante)
    local ch = G.jokerstream_challenge
    if ch.appeared_this_run then return end
    if ante < 3 or ante > 8 then return end
    if ch.TEST_ANTE3_ALWAYS and ante == 3 then
        jokerstream_challenge_spawn()
        return
    end
    ch.roll_accum = ch.roll_accum + 0.15
    if math.random() < ch.roll_accum then
        jokerstream_challenge_spawn()
        ch.roll_accum = 0
    end
end

-- ============================================
-- ХУК: подсчёт типов рук (без записи в G.GAME!)
-- ============================================
local _chal_orig_calc_joker = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = _chal_orig_calc_joker(self, context)

    pcall(function()
        local ch = G.jokerstream_challenge
        if not ch.active or not ch.state or ch.result then return end
        if not context or not context.joker_main then return end

        local cur_hands = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played) or 0
        local cur_ante  = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 0
        local hand_uid  = cur_ante .. "_" .. cur_hands

        if ch._last_hand_uid ~= hand_uid then
            ch._last_hand_uid = hand_uid
            local s = ch.state
            local name = context.scoring_name
            if name then
                s.hands_played = (s.hands_played or 0) + 1
                if name == "Full House" then
                    s.full_houses = (s.full_houses or 0) + 1
                end
                if name == "Flush" or name == "Straight Flush"
                   or name == "Flush House" or name == "Flush Five" then
                    s.flushes = (s.flushes or 0) + 1
                end
                if name == "Four of a Kind" or name == "Five of a Kind" then
                    s.four_kinds = (s.four_kinds or 0) + 1
                end
                if name == "Straight" or name == "Straight Flush" then
                    s.got_straight = true
                end

                if context.scoring_hand then
                    local spades = 0
                    for _, c in ipairs(context.scoring_hand) do
                        if c.base and (c.base.suit == "Spades" or c.base.suit == "S") then
                            spades = spades + 1
                        end
                    end
                    if spades >= 3 then
                        s.spade_hands = (s.spade_hands or 0) + 1
                    end
                end
            end
        end
    end)

    return ret
end

-- Трекинг дискрарда
if G.FUNCS and G.FUNCS.discard_cards_from_highlighted then
    local _chal_orig_discard = G.FUNCS.discard_cards_from_highlighted
    G.FUNCS.discard_cards_from_highlighted = function(e)
        pcall(function()
            local ch = G.jokerstream_challenge
            if ch.active and ch.state and not ch.result then
                ch.state.discards_used = (ch.state.discards_used or 0) + 1
            end
        end)
        return _chal_orig_discard(e)
    end
end

-- ============================================
-- UPDATE
-- ============================================
function G.jokerstream_challenge_update(dt)
    local ch = G.jokerstream_challenge
    local in_run = G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH
    local cur_ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 0

    -- Старт нового рана
    if in_run and cur_ante == 1 and not ch.run_initialized then
        ch.run_initialized = true
        ch.last_ante = 0
        ch.appeared_this_run = false
        ch.roll_accum = 0
    end

    -- Смена анты: резолв ТОЛЬКО когда игра готова выбирать блайнд
    if in_run and cur_ante > ch.last_ante then
        if G.STATE == G.STATES.BLIND_SELECT then
            if ch.active and not ch.result then
                local win = false
                pcall(function()
                    win = ch.current and ch.current.check and ch.current.check(ch.state) or false
                end)
                jokerstream_challenge_resolve(win and true or false)
            end
            ch.last_ante = cur_ante
            jokerstream_challenge_try_spawn(cur_ante)
        end
    end

    -- Анимации
    if ch.active and not ch.result then
        ch.anim_in = math.min(ch.anim_in + dt * 3.0, 1)
    elseif ch.result then
        ch.result_t = ch.result_t + dt
        if ch.result_t > 3.5 then
            ch.anim_out = math.min(ch.anim_out + dt * 2.5, 1)
            if ch.anim_out >= 1 then
                ch.active = false
                ch.current = nil; ch.state = nil; ch.nick = nil; ch.result = nil
                ch.anim_in = 0; ch.anim_out = 0
                ch._last_hand_uid = nil
                G.jokerstream_challenge_state = nil
            end
        end
    end

    -- ============================================
    -- ТРЕКИНГ СКОРА ЗА РУКУ (безопасный)
    -- ============================================
    -- Никаких записей в G.GAME. Только чтение.
    -- Отслеживаем смену hands_played → сбрасываем "начало руки".
    -- Пока руки играется, обновляем max_hand_score дельтой чипсов.
    if ch.active and ch.state and not ch.result
       and ch.current and ch.current.big_number
       and G.GAME and G.STATE and G.STATE ~= G.STATES.MENU then
        pcall(function()
            local cur_chips = tonumber(G.GAME.chips) or 0
            local hp = (G.GAME.current_round and G.GAME.current_round.hands_played) or 0

            if ch.state._last_hp ~= hp then
                -- Новая рука началась: фиксируем точку отсчёта
                ch.state._last_hp = hp
                ch.state._chips_at_hand_start = cur_chips
            end

            if ch.state._chips_at_hand_start then
                local delta = cur_chips - ch.state._chips_at_hand_start
                if delta > (ch.state.max_hand_score or 0) then
                    ch.state.max_hand_score = delta
                end
            end
        end)
    end

    -- Ставки
    if ch.active and ch.current and ch.state and not ch.result then
        local prog = 0
        pcall(function()
            prog = ch.current.progress and ch.current.progress(ch.state) or 0
        end)
        prog = math.max(0, math.min(1, prog))
        local target = 0.55 - prog * 0.35
        target = target + math.sin(love.timer.getTime() * 0.7) * 0.03
        ch.target_pink = math.max(0.10, math.min(0.90, target))
        ch.pink_ratio = ch.pink_ratio + (ch.target_pink - ch.pink_ratio) * math.min(dt * 0.8, 1)
    end
end

-- ============================================
-- ОТРИСОВКА
-- ============================================
function G.jokerstream_challenge_draw(screen_w, screen_h, chat_x, chat_y, chat_w)
    local ch = G.jokerstream_challenge
    if not ch.active or not ch.current then return end

    local card_w = 260
    local card_h = 104
    local margin_right = 12
    local margin_bottom = 12

    local base_x = screen_w - card_w - margin_right
    local base_y = chat_y - card_h - margin_bottom

    local reveal = ch.anim_in
    if ch.anim_out > 0 then reveal = 1 - ch.anim_out end
    local eased = 1 - math.pow(1 - reveal, 3)
    local offset_x = (1 - eased) * (card_w + margin_right + 10)

    local x = base_x + offset_x
    local y = base_y

    ch.card_rect = { x = x, y = y, w = card_w, h = card_h }

    local t = love.timer.getTime()
    local pink_n = ch.pink_ratio

    love.graphics.setColor(0.04, 0.03, 0.08, 0.72)
    love.graphics.rectangle("fill", x, y, card_w, card_h, 8)

    love.graphics.setColor(0.75, 0.75, 0.85, 0.65)
    love.graphics.setLineWidth(1.2)
    love.graphics.rectangle("line", x, y, card_w, card_h, 8)
    love.graphics.setLineWidth(1)

    local f_label = jokerstream_channel_font and jokerstream_channel_font(11) or nil
    if f_label then love.graphics.setFont(f_label) end
    love.graphics.setColor(0.70, 0.70, 0.80, 0.9)
    love.graphics.print("CHALLENGE", x + 12, y + 8)

    -- Счётчик
    if ch.current.target then
        local cur_val = 0
        pcall(function()
            if ch.current.big_number then
                cur_val = ch.state and ch.state.max_hand_score or 0
            elseif ch.current.money then
                cur_val = (G.GAME and G.GAME.dollars) or 0
            else
                local prog0 = ch.current.progress and ch.current.progress(ch.state) or 0
                prog0 = math.max(0, math.min(1, prog0))
                cur_val = math.floor(prog0 * ch.current.target + 0.5)
            end
        end)
        local counter_text
        if ch.current.big_number then
            counter_text = fmt_counter(cur_val) .. "/" .. fmt_counter(ch.current.target)
        elseif ch.current.money then
            counter_text = "$" .. math.floor(cur_val) .. "/$" .. ch.current.target
        else
            counter_text = cur_val .. "/" .. ch.current.target
        end

        local f_cnt = jokerstream_channel_font and jokerstream_channel_font(12) or nil
        if f_cnt then love.graphics.setFont(f_cnt) end
        love.graphics.setColor(1, 1, 1, 0.95)
        love.graphics.printf(counter_text, x + card_w - 100, y + 8, 88, "right")
    end

    local f_title = jokerstream_channel_font and jokerstream_channel_font(17) or nil
    if f_title then love.graphics.setFont(f_title) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(ch.current.title, x + 12, y + 26)

    local f_nick = jokerstream_channel_font and jokerstream_channel_font(11) or nil
    if f_nick then love.graphics.setFont(f_nick) end
    love.graphics.setColor(0.70, 0.70, 0.80, 0.85)
    love.graphics.print("by " .. (ch.nick or "?"), x + 12, y + 50)

    local bar_x = x + 12
    local bar_y = y + 78
    local bar_w = card_w - 24
    local bar_h = 14
    local radius = bar_h / 2

    love.graphics.setColor(0.05, 0.03, 0.10, 0.85)
    love.graphics.rectangle("fill", bar_x, bar_y, bar_w, bar_h, radius)

    local bar_divider = bar_x + bar_w * (1 - pink_n)

    love.graphics.stencil(function()
        love.graphics.rectangle("fill", bar_x, bar_y, bar_w, bar_h, radius)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    local blue_w = bar_divider - bar_x
    if blue_w > 0 then
        love.graphics.setColor(0.35, 0.65, 1.0, 1)
        love.graphics.rectangle("fill", bar_x, bar_y, blue_w, bar_h)
        local shine_pos = ((t * 0.8) % 1) * blue_w
        local shine_w = 30
        for i = 0, shine_w do
            local a = (1 - math.abs(i - shine_w / 2) / (shine_w / 2)) * 0.45
            love.graphics.setColor(0.75, 0.92, 1.0, a)
            love.graphics.rectangle("fill", bar_x + shine_pos + i, bar_y, 1, bar_h)
        end
    end

    local pink_w = bar_x + bar_w - bar_divider
    if pink_w > 0 then
        love.graphics.setColor(1.0, 0.40, 0.78, 1)
        love.graphics.rectangle("fill", bar_divider, bar_y, pink_w, bar_h)
        local shine_pos = ((t * 0.8 + 0.5) % 1) * pink_w
        local shine_w = 30
        for i = 0, shine_w do
            local a = (1 - math.abs(i - shine_w / 2) / (shine_w / 2)) * 0.45
            love.graphics.setColor(1.0, 0.75, 0.95, a)
            love.graphics.rectangle("fill", bar_divider + shine_pos + i, bar_y, 1, bar_h)
        end
    end

    love.graphics.setStencilTest()

    love.graphics.setColor(0.65, 0.65, 0.75, 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", bar_x, bar_y, bar_w, bar_h, radius)

    -- Огоньки
    local flame_total = 12
    local pad_left  = 10
    local pad_right = 10

    local blue_zone_x0 = x + pad_left
    local blue_zone_x1 = bar_divider
    local pink_zone_x0 = bar_divider
    local pink_zone_x1 = x + card_w - pad_right

    local flames_pink = math.max(1, round(flame_total * pink_n))
    local flames_blue = flame_total - flames_pink

    local function flame_at(fx, col, idx)
        local f = ch.flames[idx] or { phase = idx * 0.9, speed = 3.5, scale = 1.0 }
        local flick  = 0.55 + 0.45 * math.sin(t * f.speed + f.phase)
        local flick2 = 0.5 + 0.5 * math.sin(t * f.speed * 1.7 + f.phase * 1.3)
        local h = (11 + 7 * flick) * f.scale
        local w = (4 + 1.5 * flick2) * f.scale
        local base_y = y

        love.graphics.setColor(col[1], col[2], col[3], 0.30 * flick)
        love.graphics.polygon("fill",
            fx - w, base_y + 1,
            fx + w, base_y + 1,
            fx,     base_y - h * 1.25
        )
        love.graphics.setColor(col[1], col[2], col[3], 0.7 * flick)
        love.graphics.polygon("fill",
            fx - w * 0.55, base_y + 1,
            fx + w * 0.55, base_y + 1,
            fx,            base_y - h * 0.78
        )
        love.graphics.setColor(1, 1, 1, 0.85 * flick)
        love.graphics.polygon("fill",
            fx - w * 0.22, base_y,
            fx + w * 0.22, base_y,
            fx,            base_y - h * 0.38
        )
    end

    local idx = 1
    if flames_blue > 0 and blue_zone_x1 > blue_zone_x0 then
        local step = (blue_zone_x1 - blue_zone_x0) / flames_blue
        for i = 0, flames_blue - 1 do
            local fx = blue_zone_x0 + step * (i + 0.5)
            flame_at(fx, {0.45, 0.80, 1.0}, idx)
            idx = idx + 1
        end
    end
    if flames_pink > 0 and pink_zone_x1 > pink_zone_x0 then
        local step = (pink_zone_x1 - pink_zone_x0) / flames_pink
        for i = 0, flames_pink - 1 do
            local fx = pink_zone_x0 + step * (i + 0.5)
            flame_at(fx, {1.0, 0.45, 0.80}, idx)
            idx = idx + 1
        end
    end

    if ch.result then
        local a = math.min(1, ch.result_t * 2)
        love.graphics.setColor(0.05, 0.03, 0.10, 0.72 * a)
        love.graphics.rectangle("fill", x, y, card_w, card_h, 8)

        local f_big = jokerstream_channel_font and jokerstream_channel_font(18) or nil
        if f_big then love.graphics.setFont(f_big) end
        if ch.result == "win" then
            love.graphics.setColor(0.5, 1.0, 0.7, a)
            love.graphics.printf("DONE! +$" .. ch.reward,
                x, y + card_h / 2 - 12, card_w, "center")
        else
            love.graphics.setColor(1.0, 0.4, 0.4, a)
            love.graphics.printf("FAILED",
                x, y + card_h / 2 - 12, card_w, "center")
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function G.jokerstream_challenge_mousepressed(x, y, button)
    local ch = G.jokerstream_challenge
    if not ch.active or not ch.card_rect then return false end
    if button ~= 1 then return false end
    local r = ch.card_rect
    if x >= r.x and x <= r.x + r.w and y >= r.y and y <= r.y + r.h then
        return true
    end
    return false
end

-- ============================================
-- ХУКИ
-- ============================================
local _chal_orig_update = Game.update
function Game:update(dt)
    _chal_orig_update(self, dt)
    pcall(G.jokerstream_challenge_update, dt)
end

local _chal_orig_mousepressed = love.mousepressed
function love.mousepressed(x, y, button, ...)
    if pcall(G.jokerstream_challenge_mousepressed, x, y, button) then
        -- pcall returns true, result1; if result1 true → handled
        local ok, handled = pcall(G.jokerstream_challenge_mousepressed, x, y, button)
        if ok and handled then return end
    end
    if _chal_orig_mousepressed then return _chal_orig_mousepressed(x, y, button, ...) end
end