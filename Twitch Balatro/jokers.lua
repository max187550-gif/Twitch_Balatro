-- ============================================
-- JOKERS.LUA — Twitch Balatro
-- ============================================

local function L(en, ru)
    local lang = (G.SETTINGS and G.SETTINGS.language) or "en-us"
    if lang == "en-us" or lang == "en" then return en end
    return ru
end
local EN = (G.SETTINGS and (G.SETTINGS.language == "en-us" or G.SETTINGS.language == "en"))

local function jokerstream_classify_hand(cards)
    if not cards or #cards == 0 then return "High Card" end

    local rank_counts = {}
    for _, c in ipairs(cards) do
        local id = c:get_id()
        rank_counts[id] = (rank_counts[id] or 0) + 1
    end

    local counts = {}
    for _, v in pairs(rank_counts) do table.insert(counts, v) end
    table.sort(counts, function(a, b) return a > b end)

    if counts[1] == 4 then return "Four of a Kind" end
    if counts[1] == 3 and counts[2] == 2 then return "Full House" end
    if counts[1] == 3 then return "Three of a Kind" end
    if counts[1] == 2 and counts[2] == 2 then return "Two Pair" end
    if counts[1] == 2 then return "Pair" end
    return "High Card"
end

-- ============================================
-- APPLE
-- ============================================
SMODS.Joker {
    key = "apple",
    atlas = "AppleAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    food = true,
    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips, card = card }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.chips = card.ability.extra.chips + 1
            return { message = "+1", colour = G.C.CHIPS, card = card }
        end
    end
}

-- ============================================
-- BANANA
-- ============================================
SMODS.Joker {
    key = "banana",
    atlas = "BananaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    food = true,
    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult, card = card }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.mult = card.ability.extra.mult + 1
            return { message = "+1", colour = G.C.MULT, card = card }
        end
    end
}

-- ============================================
-- TOHA
-- ============================================
SMODS.Joker {
    key = "toha",
    atlas = "TohaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { Xmult = 1 } },
    rarity = 3,
    cost = 12,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { Xmult = card.ability.extra.Xmult, card = card }
        end

        if context.individual and context.cardarea == G.play then
            if G.GAME.used_vouchers["v_jokerstream_food_all"] then
                local id = context.other_card:get_id()
                local is_ace = id == 14
                local is_jack = id == 11

                if is_ace or is_jack then
                    G.GAME.jokerstream_eaten_ace = G.GAME.jokerstream_eaten_ace or 0
                    G.GAME.jokerstream_eaten_jack = G.GAME.jokerstream_eaten_jack or 0

                    local can_eat = (is_ace and G.GAME.jokerstream_eaten_ace < 2)
                                  or (is_jack and G.GAME.jokerstream_eaten_jack < 2)

                    if can_eat then
                        if is_ace then G.GAME.jokerstream_eaten_ace = G.GAME.jokerstream_eaten_ace + 1 end
                        if is_jack then G.GAME.jokerstream_eaten_jack = G.GAME.jokerstream_eaten_jack + 1 end

                        card.ability.extra.Xmult = card.ability.extra.Xmult + 0.5
                        SMODS.destroy_cards({ context.other_card }, { pinch_anim = true })

                        return {
                            message = "X" .. card.ability.extra.Xmult,
                            colour = G.C.MULT,
                            card = card
                        }
                    end
                end
            end
        end

        if context.end_of_round and context.cardarea == G.jokers then
            local food_jokers = {}
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center.food and j ~= card then
                    table.insert(food_jokers, j)
                end
            end

            if #food_jokers > 0 then
                local target = pseudorandom_element(food_jokers, pseudoseed('toha_eat'))
                card.ability.extra.Xmult = card.ability.extra.Xmult * 2

                if target.ability.extra.bites_left and target.ability.extra.bites_left > 1 then
                    target.ability.extra.bites_left = target.ability.extra.bites_left - 1
                    return {
                        message = "X" .. card.ability.extra.Xmult,
                        colour = G.C.MULT,
                        card = card
                    }
                else
                    local tip = 0
                    if not target.debuff then
                        if G.GAME.used_vouchers["v_jokerstream_food_tips_plus"] then
                            if target.edition then
                                if target.edition.polychrome then tip = 22
                                elseif target.edition.negative then tip = 22
                                elseif target.edition.holo then tip = 17
                                elseif target.edition.foil then tip = 15
                                else tip = 10 end
                            else
                                tip = 10
                            end
                        elseif G.GAME.used_vouchers["v_jokerstream_food_tips"] then
                            tip = math.floor((target.cost or 0) * 0.5)
                        end
                    end

                    SMODS.destroy_cards({ target }, { pinch_anim = true })
                    return {
                        dollars = tip > 0 and tip or nil,
                        message = "X" .. card.ability.extra.Xmult,
                        colour = G.C.MULT,
                        card = card
                    }
                end
            end

            if G.GAME.used_vouchers["v_jokerstream_food_all"] then
                if #G.consumeables.cards > 0 then
                    local target_consumable = pseudorandom_element(G.consumeables.cards, pseudoseed('toha_eat_consumable'))
                    card.ability.extra.Xmult = card.ability.extra.Xmult + 0.5
                    SMODS.destroy_cards({ target_consumable }, { pinch_anim = true })
                end
            end
        end
    end
}

-- ============================================
-- ISHOWSPEED
-- ============================================
SMODS.Joker {
    key = "ishowspeed",
    atlas = "SpeedAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = {} },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            local total = 0
            local hits = {}
            if pseudorandom('speed_donate_5') < G.GAME.probabilities.normal / 3 then
                total = total + 5; table.insert(hits, "$5")
            end
            if pseudorandom('speed_donate_10') < G.GAME.probabilities.normal / 5 then
                total = total + 10; table.insert(hits, "$10")
            end
            if pseudorandom('speed_donate_13') < G.GAME.probabilities.normal / 7 then
                total = total + 13; table.insert(hits, "$13")
            end
            if pseudorandom('speed_donate_100') < G.GAME.probabilities.normal / 12 then
                total = total + 100; table.insert(hits, "$100")
            end
            if total > 0 then
                return {
                    dollars = total,
                    message = table.concat(hits, " + ") .. "!",
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}

-- ============================================
-- STINTA
-- ============================================
SMODS.Joker {
    key = "stinta",
    atlas = "StintaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.hand_count = (card.ability.extra.hand_count or 0) + 1
            local is_first = card.ability.extra.hand_count == 1
            local is_last = G.GAME.current_round.hands_left == 0

            if is_first or is_last then
                if context.scoring_name then
                    level_up_hand(card, context.scoring_name, true)
                end
                return {
                    chips = 250,
                    mult = 5,
                    message = is_first and "1st!" or "Last!",
                    colour = G.C.RED,
                    card = card
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.hand_count = 0
        end
    end
}

-- ============================================
-- ORANGE
-- ============================================
SMODS.Joker {
    key = "orange",
    atlas = "OrangeAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { dollars = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    food = true,
    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            local payout = card.ability.extra.dollars
            card.ability.extra.dollars = card.ability.extra.dollars + 1
            return {
                dollars = payout,
                message = "+$" .. payout,
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

-- ============================================
-- NELYA
-- ============================================
SMODS.Joker {
    key = "nelya",
    atlas = "NelyaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = {} },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    food = true,
    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.scoring_name == "Full House" then
            if context.other_card:get_id() == 14 then
                return { chips = 35, mult = 4, card = card }
            end
        end
    end
}

-- ============================================
-- MAZELOL
-- ============================================
SMODS.Joker {
    key = "mazelol",
    atlas = "MazelolAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 60, mult = 3 } },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_hand = jokerstream_classify_hand(context.scoring_hand)
            local ret = nil

            if card.ability.extra.last_hand == current_hand then
                ret = { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
            end

            card.ability.extra.last_hand = current_hand
            return ret
        end
    end
}

-- ============================================
-- MAZELOL THOUGHTFUL
-- ============================================
SMODS.Joker {
    key = "mazelol_thoughtful",
    atlas = "MazelolThoughtfulAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 60 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.played_hands = card.ability.extra.played_hands or {}

            local current_hand = jokerstream_classify_hand(context.scoring_hand)
            local ret = nil

            if not card.ability.extra.played_hands[current_hand] then
                ret = { mult = card.ability.extra.mult, card = card }
                card.ability.extra.played_hands[current_hand] = true
            end

            return ret
        end

        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.played_hands = {}
        end
    end
}

-- ============================================
-- DRAKE
-- ============================================
SMODS.Joker {
    key = "drake",
    atlas = "DrakeAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 0, chips = 0 } },
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if G.GAME.blind and G.GAME.blind.boss then
                card.ability.extra.chips = card.ability.extra.chips + 60
                card.ability.extra.mult = card.ability.extra.mult + 4
            end
        end
    end
}

-- ============================================
-- WATERMELON
-- ============================================
SMODS.Joker {
    key = "watermelon",
    atlas = "WatermelonAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { bites_left = 2, max_bites = 2 } },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    food = true,
    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bites_left, card.ability.extra.max_bites } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.hand_count = (card.ability.extra.hand_count or 0) + 1
            if card.ability.extra.hand_count == 1 then
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.hand_count = 0
        end
    end
}

-- ============================================
-- PYATERKA
-- ============================================
SMODS.Joker {
    key = "pyaterka",
    atlas = "PyaterkaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 5, mult = 15 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 5 then
                return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.round_count = (card.ability.extra.round_count or 0) + 1
            if card.ability.extra.round_count % 5 == 0 then
                card.ability.extra.chips = card.ability.extra.chips + 155
                card.ability.extra.mult = card.ability.extra.mult + 55
                return { message = "POG", colour = G.C.RED, card = card }
            end
        end
    end
}

-- ============================================
-- CHAT BALATRO
-- ============================================
SMODS.Joker {
    key = "chat_balatro",
    atlas = "ChatAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 0, mult = 0, xmult = 1, cap = 700 } },
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args)
        if #SMODS.find_card("j_jokerstream_chat_balatro") > 0 then
            return false
        end
        local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 0
        return ante >= 3
    end,

    weight = function(self)
        local w = 3
        if G.GAME and G.GAME.used_vouchers then
            if G.GAME.used_vouchers["v_jokerstream_unlimited_chat"] then w = 6 end
            if G.GAME.used_vouchers["v_jokerstream_meme_chat"] then w = 10 end
            if G.GAME.used_vouchers["v_jokerstream_virus_chat"] then w = 14 end
        end
        return w
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card:set_edition("e_negative", true, true)
            if card.ability.extra.chips > 700 then
                card.ability.extra.chips = 700
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local unlimited = G.GAME.used_vouchers
                          and G.GAME.used_vouchers["v_jokerstream_unlimited_chat"]

        local shown = unlimited
            and (card.ability.extra.chips or 0)
            or math.min(card.ability.extra.chips or 0, 700)
        local bonus = unlimited and 65 or 45

        local cap_text
        if unlimited then
            cap_text = L("No limit", "Без ограничений")
        else
            cap_text = L("Maximum: 700", "Максимум: 700")
        end

        local mult_val = card.ability.extra.mult or 0
        local xmult_val = card.ability.extra.xmult or 1
        return { vars = { shown, bonus, cap_text, mult_val, xmult_val } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local unlimited = G.GAME.used_vouchers
                              and G.GAME.used_vouchers["v_jokerstream_unlimited_chat"]
            local meme = G.GAME.used_vouchers
                         and G.GAME.used_vouchers["v_jokerstream_meme_chat"]
            local virus = G.GAME.used_vouchers
                          and G.GAME.used_vouchers["v_jokerstream_virus_chat"]

            if virus and card.children and card.children.center then
                local sp = card.children.center.sprite_pos
                if not sp or sp.x == 0 then
                    pcall(function()
                        card.children.center:set_sprite_pos({ x = 1, y = 0 })
                    end)
                end
            end

            if not unlimited and card.ability.extra.chips > 700 then
                card.ability.extra.chips = 700
            end

            local current_mult = card.ability.extra.mult or 0
            local current_xmult = card.ability.extra.xmult or 1

            if meme and current_mult < 100 then
                card.ability.extra.mult = math.min(100, current_mult + 10)
            end
            if virus and current_xmult < 7.5 then
                card.ability.extra.xmult = math.min(7.5, current_xmult + 0.5)
            end

            local ret = {
                chips = card.ability.extra.chips,
                card = card
            }
            if meme and current_mult > 0 then
                ret.mult = current_mult
            end
            if virus and current_xmult > 1 then
                ret.Xmult = current_xmult
            end

            return ret
        end
    end
}

local original_calculate_joker = Card.calculate_joker

function Card:calculate_joker(context)
    local ret = original_calculate_joker(self, context)

    if ret and context and context.joker_main and not self.debuff then
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.config and j.config.center
                   and j.config.center.key == "j_jokerstream_chat_balatro"
                   and not j.debuff then
                    local unlimited = G.GAME.used_vouchers
                                      and G.GAME.used_vouchers["v_jokerstream_unlimited_chat"]
                    local bonus = unlimited and 65 or 45

                    if unlimited then
                        j.ability.extra.chips = (j.ability.extra.chips or 0) + bonus
                    else
                        j.ability.extra.chips = math.min(700, (j.ability.extra.chips or 0) + bonus)
                    end
                end
            end
        end
    end

    return ret
end

-- ============================================
-- FARFADOX
-- ============================================
SMODS.Joker {
    key = "farfadox",
    atlas = "MinecraftAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { rounds = 0 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rounds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds + 1

            if card.ability.extra.rounds >= 3 then
                card.ability.extra.rounds = 0

                local new_card = SMODS.add_card({
                    set = "Base",
                    enhancement = "m_jokerstream_crying_obsidian",
                    area = G.deck,
                    key_append = "farfadox",
                })

                if new_card then
                    return {
                        message = L("Obsidian!", "Обсидиан!"),
                        colour = G.C.PURPLE,
                        card = card
                    }
                end
            end
        end
    end
}

-- ============================================
-- MODERATOR
-- ============================================
SMODS.Joker {
    key = "moderator",
    atlas = "ModeratorAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = {
        xmult_per_voucher = 0.5,
        max_xmult = 5,
        xmult_per_voucher_upgraded = 1.0,
        max_xmult_upgraded = 7,
        xmult_per_voucher_final = 1.5,
        max_xmult_final = 10,
        xmult_per_voucher_universe = 2.0,
        max_xmult_universe = 15,
    } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        local v = G.GAME and G.GAME.used_vouchers or {}
        local lvl2 = v["v_jokerstream_moderator_of_moderator"]
        local lvl3 = v["v_jokerstream_moderator_of_moderator_of_moderator"]
        local lvl4 = v["v_jokerstream_moderator_pocket_universe"]

        local per, max_x
        if lvl4 then
            per   = card.ability.extra.xmult_per_voucher_universe or 2.0
            max_x = card.ability.extra.max_xmult_universe        or 15
        elseif lvl3 then
            per   = card.ability.extra.xmult_per_voucher_final or 1.5
            max_x = card.ability.extra.max_xmult_final        or 10
        elseif lvl2 then
            per   = card.ability.extra.xmult_per_voucher_upgraded or 1.0
            max_x = card.ability.extra.max_xmult_upgraded          or 7
        else
            per   = card.ability.extra.xmult_per_voucher or 0.5
            max_x = card.ability.extra.max_xmult         or 5
        end

        local count = 0
        for _, used in pairs(v) do
            if used then count = count + 1 end
        end

        local total = math.min(max_x, 1 + count * per)

        local has_chat = #SMODS.find_card("j_jokerstream_chat_balatro") > 0
        local synergy_text = has_chat
            and L("every chat needs a moderator", "каждому чату нужен модератор")
            or ""

        return { vars = { per, max_x, total, synergy_text } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local v = G.GAME and G.GAME.used_vouchers or {}
            local lvl2 = v["v_jokerstream_moderator_of_moderator"]
            local lvl3 = v["v_jokerstream_moderator_of_moderator_of_moderator"]
            local lvl4 = v["v_jokerstream_moderator_pocket_universe"]

            local per, max_x
            if lvl4 then
                per   = card.ability.extra.xmult_per_voucher_universe or 2.0
                max_x = card.ability.extra.max_xmult_universe        or 15
            elseif lvl3 then
                per   = card.ability.extra.xmult_per_voucher_final or 1.5
                max_x = card.ability.extra.max_xmult_final        or 10
            elseif lvl2 then
                per   = card.ability.extra.xmult_per_voucher_upgraded or 1.0
                max_x = card.ability.extra.max_xmult_upgraded          or 7
            else
                per   = card.ability.extra.xmult_per_voucher or 0.5
                max_x = card.ability.extra.max_xmult         or 5
            end

            local count = 0
            for _, used in pairs(v) do
                if used then count = count + 1 end
            end

            if count > 0 then
                local total = math.min(max_x, 1 + count * per)
                return { Xmult = total, card = card }
            end
        end
    end
}

-- ============================================
-- AD BANNER
-- ============================================
SMODS.Joker {
    key = "ad_banner",
    atlas = "AdsAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { extra_slots = 1, price_mult = 1.5 } },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card:set_edition("e_negative", true, true)
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.extra_slots } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local blind_key = G.GAME.blind and G.GAME.blind.config
                              and G.GAME.blind.config.blind
                              and G.GAME.blind.config.blind.key

            local is_small = (blind_key == "bl_small")
            local is_boss  = G.GAME.blind and G.GAME.blind.boss

            if is_small or is_boss then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        add_tag(Tag("tag_voucher"), true)
                        return true
                    end
                }))
            end
        end
    end
}

-- ============================================
-- VOUCHER SPONSOR
-- ============================================
SMODS.Joker {
    key = "voucher_sponsor",
    atlas = "SponsorAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { extra_slots = 1, price_mult = 1.3, income = 2 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card:set_edition("e_negative", true, true)
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.income } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local blind_key = G.GAME.blind and G.GAME.blind.config
                              and G.GAME.blind.config.blind
                              and G.GAME.blind.config.blind.key

            local is_small = (blind_key == "bl_small")
            local is_boss  = G.GAME.blind and G.GAME.blind.boss

            local ret = { dollars = card.ability.extra.income }

            if is_small or is_boss then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        add_tag(Tag("tag_voucher"), true)
                        return true
                    end
                }))
            end

            return ret
        end
    end
}

-- ============================================
-- BROKER
-- ============================================
SMODS.Joker {
    key = "broker",
    atlas = "BrokerAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { extra_slots = 2, price_mult = 1.2, income = 3 } },
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card:set_edition("e_negative", true, true)
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.income } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local blind_key = G.GAME.blind and G.GAME.blind.config
                              and G.GAME.blind.config.blind
                              and G.GAME.blind.config.blind.key

            local is_small = (blind_key == "bl_small")
            local is_boss  = G.GAME.blind and G.GAME.blind.boss

            local ret = { dollars = card.ability.extra.income }

            if is_small or is_boss then
                for i = 1, 2 do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1 * i,
                        func = function()
                            add_tag(Tag("tag_voucher"), true)
                            return true
                        end
                    }))
                end
            end

            return ret
        end
    end
}

local original_add_tag = add_tag
function add_tag(tag, silent, ...)
    if tag and tag.key == "tag_voucher" and silent then
        tag.jokerstream_hidden = true
    end
    return original_add_tag(tag, silent, ...)
end

local original_tag_draw = Tag.draw
function Tag:draw(offset_x, offset_y)
    if self.jokerstream_hidden then
        return
    end
    return original_tag_draw(self, offset_x, offset_y)
end

local original_update_price = Game.update
function Game:update(dt)
    original_update_price(self, dt)

    if G.STATE ~= G.STATES.SHOP then return end
    if not G.shop_vouchers or not G.shop_vouchers.cards then return end

    local has_ads = false
    local has_sponsor = false
    local has_broker = false
    local has_mod = false

    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center then
                local k = j.config.center.key
                if k == "j_jokerstream_ad_banner" then has_ads = true end
                if k == "j_jokerstream_voucher_sponsor" then has_sponsor = true end
                if k == "j_jokerstream_broker" then has_broker = true end
                if k == "j_jokerstream_moderator" then has_mod = true end
            end
        end
    end

    local penalty = 0
    if has_ads then
        penalty = math.max(penalty, has_mod and 0.4 or 0.5)
    end
    if has_sponsor then
        local p = has_mod and 0.2 or 0.3
        if penalty == 0 or p < penalty then penalty = p end
    end
    if has_broker then
        local p = has_mod and 0.1 or 0.2
        if penalty == 0 or p < penalty then penalty = p end
    end

    if penalty <= 0 then return end

    for _, c in ipairs(G.shop_vouchers.cards) do
        if c.jokerstream_base_price == nil then
            c.jokerstream_base_price = c.cost
        end
        local new_cost = math.max(1, math.floor(c.jokerstream_base_price * (1.0 + penalty)))
        if c.cost ~= new_cost then
            c.cost = new_cost
        end
    end
end

local original_get_cost_mod = Card.get_cost
function Card:get_cost()
    local base = original_get_cost_mod(self)

    if self.ability and self.ability.set == "Voucher" then
        local has_chat = #SMODS.find_card("j_jokerstream_chat_balatro") > 0
        local has_mod  = #SMODS.find_card("j_jokerstream_moderator") > 0
        if has_chat and has_mod then
            return math.max(1, math.floor(base * 0.8))
        end
    end

    return base
end

-- ============================================
-- SIN RARITY (специально суржик — не переводится)
-- ============================================
SMODS.Joker {
    key = "sin_rarity",
    atlas = "SinRareAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { dollars = 3, mult = 4 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local has_rare = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.config and j.config.center
                       and j.config.center.rarity == 3 then
                        has_rare = true
                        break
                    end
                end
            end

            if not has_rare then
                return {
                    dollars = card.ability.extra.dollars,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

-- ============================================
-- LURKER
-- ============================================
SMODS.Joker {
    key = "lurker",
    atlas = "LurkerAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 40, mult = 7 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args)
        return #SMODS.find_card(self.key) == 0
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.scoring_name == "Four of a Kind" then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

local lurker_font = nil
local original_card_draw_lurker = Card.draw
function Card:draw(layer, ...)
    local ret = original_card_draw_lurker(self, layer, ...)

    if self.config and self.config.center
       and self.config.center.key == "j_jokerstream_lurker"
       and layer == "card" then

        if not lurker_font then
            lurker_font = love.graphics.newFont(11)
        end

        love.graphics.setFont(lurker_font)
        love.graphics.setColor(1.0, 0.55, 0.75, 0.60)

        local text = L("i am lion", "я лев")

        love.graphics.printf(
            text,
            self.T.x,
            self.T.y + self.T.h * 0.72,
            self.T.w,
            "center"
        )

        love.graphics.setColor(1, 1, 1, 1)
    end

    return ret
end

-- ============================================
-- PIXEL STINTA
-- ============================================
SMODS.Joker {
    key = "pixel_stinta",
    atlas = "PixelStintaAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 75 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args)
        return #SMODS.find_card(self.key) == 0
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local has_two = false
            local has_eight = false
            if context.scoring_hand then
                for _, c in ipairs(context.scoring_hand) do
                    local id = c:get_id()
                    if id == 2 then has_two = true end
                    if id == 8 then has_eight = true end
                end
            end

            if has_two and has_eight then
                return {
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end
    end
}

-- ============================================
-- BATH STINTA
-- ============================================
SMODS.Joker {
    key = "bath_stinta",
    atlas = "BathStintaAtlas",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            xmult = 1,
            xmult_add = 0.5,
            max_xmult = 10,
            round_pair = false,
            round_set = false,
            round_full_house = false,
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        if not e.xmult then e.xmult = 1 end
        if not e.xmult_add then e.xmult_add = 0.5 end
        if not e.max_xmult then e.max_xmult = 10 end
        return { vars = { e.xmult, e.xmult_add, e.max_xmult } }
    end,

    calculate = function(self, card, context)
        local e = card.ability.extra

        if not e.xmult then e.xmult = 1 end
        if not e.xmult_add then e.xmult_add = 0.5 end
        if not e.max_xmult then e.max_xmult = 10 end

        if context.joker_main then
            local hand_name = context.scoring_name

            if hand_name == "Pair" then e.round_pair = true end
            if hand_name == "Three of a Kind" then e.round_set = true end
            if hand_name == "Full House" then e.round_full_house = true end

            if e.round_pair and e.round_set and e.round_full_house then
                if e.xmult < e.max_xmult then
                    e.xmult = math.min(e.max_xmult, e.xmult + e.xmult_add)
                end

                e.round_pair = false
                e.round_set = false
                e.round_full_house = false

                return {
                    Xmult = e.xmult,
                    message = "POG",
                    colour = G.C.MULT,
                    card = card
                }
            end

            if e.xmult > 1 then
                return { Xmult = e.xmult, card = card }
            end
        end

        if context.end_of_round and context.cardarea == G.jokers then
            e.round_pair = false
            e.round_set = false
            e.round_full_house = false
        end
    end
}

-- ============================================
-- CASEOH
-- ============================================
SMODS.Joker {
    key = "caseoh",
    atlas = "CaseOhAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chance = 10, xmult_add = 0.5, xmult = 1, max_xmult = 10 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        if not e.chance then e.chance = 10 end
        if not e.xmult_add then e.xmult_add = 0.5 end
        if not e.xmult then e.xmult = 1 end
        if not e.max_xmult then e.max_xmult = 10 end
        return { vars = { e.xmult, e.chance, e.xmult_add, e.max_xmult } }
    end,

    calculate = function(self, card, context)
        local e = card.ability.extra

        if not e.chance then e.chance = 10 end
        if not e.xmult_add then e.xmult_add = 0.5 end
        if not e.xmult then e.xmult = 1 end
        if not e.max_xmult then e.max_xmult = 10 end

        if context.joker_main then
            if pseudorandom('caseoh') < G.GAME.probabilities.normal / e.chance then
                if e.xmult < e.max_xmult then
                    e.xmult = math.min(e.max_xmult, e.xmult + e.xmult_add)
                    return {
                        message = "CASEOH!",
                        colour = G.C.MULT,
                        card = card,
                        Xmult = e.xmult
                    }
                end
            end

            if e.xmult > 1 then
                return { Xmult = e.xmult, card = card }
            end
        end
    end
}

-- ============================================
-- NATIONAL EQUALITY
-- ============================================
SMODS.Joker {
    key = "national_equality",
    atlas = "TwitchAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips_per_repeat = 50, rounds = 0, round_need = 3 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.chips_per_repeat,
            card.ability.extra.round_need,
            card.ability.extra.rounds,
        } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local suit_count = {}
            for _, c in ipairs(context.scoring_hand) do
                local suit = c.base and c.base.suit
                if suit then
                    suit_count[suit] = (suit_count[suit] or 0) + 1
                end
            end

            local total_chips = 0
            for suit, count in pairs(suit_count) do
                if count > 1 then
                    total_chips = total_chips + count * card.ability.extra.chips_per_repeat
                end
            end

            if total_chips > 0 then
                return {
                    chips = total_chips,
                    message = "+" .. total_chips,
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end

        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds + 1

            if card.ability.extra.rounds >= card.ability.extra.round_need then
                card.ability.extra.rounds = 0

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        if #G.consumeables.cards < G.consumeables.config.card_limit then
                            local tarot_keys = { "c_star", "c_moon", "c_sun", "c_world" }
                            local pick = tarot_keys[math.random(1, #tarot_keys)]
                            pcall(SMODS.add_card, { set = "Tarot", key = pick })
                        end
                        return true
                    end
                }))
            end
        end
    end
}

-- ============================================
-- FOURTH WHEEL
-- ============================================
SMODS.Joker {
    key = "fourth_wheel",
    atlas = "StintAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { copies = 2 } },
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args)
        return #SMODS.find_card(self.key) == 0
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.copies } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if G.GAME and G.GAME.blind and G.GAME.blind.boss then
                local streamer_keys = {
                    "j_jokerstream_apple",
                    "j_jokerstream_banana",
                    "j_jokerstream_toha",
                    "j_jokerstream_ishowspeed",
                    "j_jokerstream_stinta",
                    "j_jokerstream_pixel_stinta",
                    "j_jokerstream_bath_stinta",
                    "j_jokerstream_orange",
                    "j_jokerstream_nelya",
                    "j_jokerstream_mazelol",
                    "j_jokerstream_mazelol_thoughtful",
                    "j_jokerstream_drake",
                    "j_jokerstream_watermelon",
                    "j_jokerstream_pyaterka",
                    "j_jokerstream_chat_balatro",
                    "j_jokerstream_farfadox",
                    "j_jokerstream_moderator",
                    "j_jokerstream_ad_banner",
                    "j_jokerstream_voucher_sponsor",
                    "j_jokerstream_broker",
                    "j_jokerstream_sin_rarity",
                    "j_jokerstream_lurker",
                }

                local copies = card.ability.extra.copies
                for i = 1, copies do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5 * i,
                        func = function()
                            if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                                local pick = streamer_keys[math.random(1, #streamer_keys)]
                                pcall(SMODS.add_card, {
                                    key = pick,
                                    area = G.jokers,
                                    bypass_discovery_ui = true,
                                })
                            end
                            return true
                        end
                    }))
                end

                return {
                    message = L("COLLAB!", "КОЛЛАБ!"),
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end
}

-- ============================================
-- CLOWN STREAMER
-- ============================================
SMODS.Joker {
    key = "clown_streamer",
    atlas = "ClownAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult_per_joker = 0.5 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card:set_edition("e_holo", true, true)
        end
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card then
                    local has_ed = j.edition and (j.edition.foil or j.edition.holo
                                  or j.edition.polychrome or j.edition.negative)
                    if not has_ed then count = count + 1 end
                end
            end
        end
        local current = 1 + count * card.ability.extra.xmult_per_joker
        return { vars = { current, card.ability.extra.xmult_per_joker } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if not G.jokers or not G.jokers.cards then return end

            local count = 0
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card then
                    local has_ed = j.edition and (j.edition.foil or j.edition.holo
                                  or j.edition.polychrome or j.edition.negative)
                    if not has_ed then
                        count = count + 1
                    end
                end
            end

            if count > 0 then
                local xmult = 1 + count * card.ability.extra.xmult_per_joker
                return {
                    Xmult = xmult,
                    card = card,
                    message = "X" .. xmult,
                    colour = G.C.MULT,
                }
            end
        end
    end,
}

-- ============================================
-- GOJO STINT
-- ============================================
SMODS.Joker {
    key = "gojo_stint",
    atlas = "GojoAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { foil = 0.3, holo = 0.3, poly = 0.5, negative = 0.6 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        local total = 1
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.edition then
                    if j.edition.foil then total = total + e.foil end
                    if j.edition.holo then total = total + e.holo end
                    if j.edition.polychrome then total = total + e.poly end
                    if j.edition.negative then total = total + e.negative end
                end
            end
        end
        return { vars = { total, e.foil, e.poly, e.negative } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if not G.jokers or not G.jokers.cards then return end
            local e = card.ability.extra
            local total = 1
            for _, j in ipairs(G.jokers.cards) do
                if j.edition then
                    if j.edition.foil then total = total + e.foil end
                    if j.edition.holo then total = total + e.holo end
                    if j.edition.polychrome then total = total + e.poly end
                    if j.edition.negative then total = total + e.negative end
                end
            end
            if total > 1 then
                return { Xmult = total, card = card }
            end
        end
    end,
}

-- ============================================
-- PIXEL DRAKE
-- ============================================
SMODS.Joker {
    key = "pixel_drake",
    atlas = "PixelDrakeAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { rare = 1.0, uncommon = 0.5, common = 30 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        return { vars = { e.rare, e.uncommon, e.common } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if not G.jokers or not G.jokers.cards then return end
            local e = card.ability.extra
            local xmult = 1
            local chips = 0
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and j.config and j.config.center then
                    local r = j.config.center.rarity
                    if r == 3 then xmult = xmult + e.rare
                    elseif r == 2 then xmult = xmult + e.uncommon
                    elseif r == 1 then chips = chips + e.common end
                end
            end
            local ret = { card = card }
            if xmult > 1 then ret.Xmult = xmult end
            if chips > 0 then ret.chips = chips end
            if ret.Xmult or ret.chips then return ret end
        end
    end,
}

-- ============================================
-- OGORODNIK
-- ============================================
SMODS.Joker {
    key = "ogorodnik",
    atlas = "OgorodnikAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult_per_retrigger = 0.4 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_per_retrigger } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local triggers = G.GAME and G.GAME.jokerstream_trigger_count or {}
            local retrigger_count = 0
            for _, count in pairs(triggers) do
                if count > 1 then
                    retrigger_count = retrigger_count + (count - 1)
                end
            end
            if retrigger_count > 0 then
                local xmult = 1 + retrigger_count * card.ability.extra.xmult_per_retrigger
                return { Xmult = xmult, card = card }
            end
        end
    end,
}

local _ogorodnik_orig_calc = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = _ogorodnik_orig_calc(self, context)

    if context and context.joker_main and ret and not self.debuff then
        if self.config and self.config.center then
            local key = self.config.center.key
            if key and key ~= "j_jokerstream_ogorodnik" then
                G.GAME = G.GAME or {}
                G.GAME.jokerstream_trigger_count = G.GAME.jokerstream_trigger_count or {}
                G.GAME.jokerstream_trigger_count[key] =
                    (G.GAME.jokerstream_trigger_count[key] or 0) + 1
            end
        end
    end

    return ret
end

local _ogorodnik_orig_eval = G.FUNCS and G.FUNCS.evaluate_play
if _ogorodnik_orig_eval then
    G.FUNCS.evaluate_play = function(e)
        local r = _ogorodnik_orig_eval(e)
        if G.GAME then G.GAME.jokerstream_trigger_count = {} end
        return r
    end
end

-- ============================================
-- DESSERT
-- ============================================
SMODS.Joker {
    key = "dessert",
    atlas = "DessertAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { base_chance = 5 } },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,

    in_pool = function(self, args) return #SMODS.find_card(self.key) == 0 end,

    loc_vars = function(self, info_queue, card)
        local food_count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and j.config and j.config.center
                   and j.config.center.food then
                    food_count = food_count + 1
                end
            end
        end
        local chance = card.ability.extra.base_chance - math.floor(food_count / 2)
        if chance < 1 then chance = 1 end
        return { vars = { card.ability.extra.base_chance, chance } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local e = card.ability.extra

            local pool = {
                "j_jokerstream_apple",
                "j_jokerstream_banana",
                "j_jokerstream_orange",
                "j_jokerstream_watermelon",
                "j_jokerstream_nelya",
            }
            local pick = pool[math.random(1, #pool)]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                        pcall(SMODS.add_card, { key = pick, area = G.jokers })
                    end
                    return true
                end
            }))

            local food_count = 0
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and j.config and j.config.center
                   and j.config.center.food then
                    food_count = food_count + 1
                end
            end

            local chance = e.base_chance - math.floor(food_count / 2)
            if chance < 1 then chance = 1 end

            local toha_present = false
            for _, j in ipairs(G.jokers.cards) do
                if j.config and j.config.center
                   and j.config.center.key == "j_jokerstream_toha" then
                    toha_present = true
                    break
                end
            end

            if toha_present and math.random(1, chance) == 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.6,
                    func = function()
                        SMODS.destroy_cards({ card }, { pinch_anim = true })
                        return true
                    end
                }))
                return { message = L("EATEN!", "СЪЕДЕН!"), colour = G.C.RED }
            end

            return { message = L("Dessert!", "Десерт!"), colour = G.C.MULT }
        end
    end,
}