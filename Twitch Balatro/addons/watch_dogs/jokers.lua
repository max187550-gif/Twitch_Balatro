-- ============================================
-- WATCH DOGS JOKERS — addons/watch_dogs/jokers.lua
-- ============================================

SMODS.Joker {
    key = "watcher",
    atlas = "WatcherAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { rounds = 0, need = 2, full_house_mult = 35 } },
    rarity = 1, cost = 7, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.need, card.ability.extra.rounds or 0, card.ability.extra.full_house_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Full House" then
            return { mult = card.ability.extra.full_house_mult, card = card }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
            if card.ability.extra.rounds >= card.ability.extra.need then
                card.ability.extra.rounds = 0
                local purity = (math.random() < 0.75) and 1 or 2
                if G.jokerstream_add_code then G.jokerstream_add_code(purity, 1) end
                return { message = "CODE", colour = G.C.GREEN, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "watcher_glitched",
    atlas = "WatcherGlitchedAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { rounds = 0, need = 3, chips_per_card = 100 } },
    rarity = 2, cost = 15, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.need, card.ability.extra.rounds or 0, card.ability.extra.chips_per_card } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local hand = context.scoring_hand or {}
            local suits = {}
            for _, c in ipairs(hand) do
                local s = c.base and c.base.suit
                if s then suits[s] = true end
            end
            local suit_count = 0
            for _ in pairs(suits) do suit_count = suit_count + 1 end
            if suit_count >= 3 then
                return { chips = card.ability.extra.chips_per_card, card = card }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
            if card.ability.extra.rounds >= card.ability.extra.need then
                card.ability.extra.rounds = 0
                local purity = math.random(3, 5)
                if G.jokerstream_add_code then G.jokerstream_add_code(purity, 3) end
                return { message = "RARE CODE", colour = G.C.PURPLE, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "secret_path_recruit",
    atlas = "VhsGlitchAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 66, energy_threshold = 5 } },
    rarity = 2, cost = 7, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        local energy = 3
        if G.jokerstream_config then
            energy = G.jokerstream_config.wd_energy or 3
        end
        local active = energy < card.ability.extra.energy_threshold
        local status = active and "ACTIVE" or "INACTIVE"
        return { vars = { card.ability.extra.mult, card.ability.extra.energy_threshold, energy, status } }
    end,
        calculate = function(self, card, context)
        if context.joker_main then
            local energy = 3
            if G.jokerstream_config then
                energy = G.jokerstream_config.wd_energy or 3
            end
            if energy < card.ability.extra.energy_threshold then
                return { mult = card.ability.extra.mult, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "you_see_me_in_donut_verse",
    atlas = "DedsecCoreAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips_per_card = 50, codes_per_round = 1, codes_given_this_round = 0, last_round = -1 } },
    rarity = 2, cost = 7, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_per_card, card.ability.extra.codes_per_round } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local cur_round = (G.GAME and G.GAME.round) or 0
            if card.ability.extra.last_round ~= cur_round then
                card.ability.extra.last_round = cur_round
                card.ability.extra.codes_given_this_round = 0
            end
            return
        end
        if context.joker_main and context.scoring_name == "Three of a Kind" then
            if card.ability.extra.codes_given_this_round < card.ability.extra.codes_per_round then
                card.ability.extra.codes_given_this_round = card.ability.extra.codes_given_this_round + 1
                if G.jokerstream_add_code then G.jokerstream_add_code(2, 2) end
                return { message = "CODE", colour = G.C.PURPLE, card = card }
            end
            return
        end
        if context.individual and context.cardarea == G.play then
            if context.scoring_name == "Three of a Kind" then
                return { chips = card.ability.extra.chips_per_card, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "server_ghost",
    atlas = "ServerGhostAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult = 3, energy_threshold = 5 } },
    rarity = 2, cost = 7, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        local energy = 3
        if G.jokerstream_config then
            energy = G.jokerstream_config.wd_energy or 3
        end
        local active = energy > card.ability.extra.energy_threshold
        local status = active and "ACTIVE" or "INACTIVE"
        return { vars = { card.ability.extra.xmult, card.ability.extra.energy_threshold, energy, status } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local energy = 3
            if G.jokerstream_config then
                energy = G.jokerstream_config.wd_energy or 3
            end
            if energy > card.ability.extra.energy_threshold then
                return { Xmult = card.ability.extra.xmult, card = card }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local energy = 3
            if G.jokerstream_config then
                energy = G.jokerstream_config.wd_energy or 3
            end
            if energy > card.ability.extra.energy_threshold then
                -- ★ МИНИ-ЭФФЕКТ: шанс создать код
                if math.random(1, 4) == 1 and G.jokerstream_add_code then
                    G.jokerstream_add_code(3, 3) -- vm
                    return { message = "CODE!", colour = G.C.TURQUOISE }
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "deadsec_",
    atlas = "DeadsecAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { given_this_round = 0, per_round = 1, last_round = -1 } },
    rarity = 3, cost = 12, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per_round } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local cur_round = (G.GAME and G.GAME.round) or 0
            if card.ability.extra.last_round ~= cur_round then
                card.ability.extra.last_round = cur_round
                card.ability.extra.given_this_round = 0
            end
            return
        end
        if not context.joker_main then return end
        if card.ability.extra.given_this_round >= card.ability.extra.per_round then return end

        local hand = context.scoring_hand
        if not hand then return end

        local aces, queens, ranks_set = 0, 0, {}
        for _, c in ipairs(hand) do
            local id = c:get_id()
            if id == 14 then aces = aces + 1 end
            if id == 12 then queens = queens + 1 end
            ranks_set[id] = true
        end
        local hand_name = context.scoring_name or ""

        if hand_name == "Full House" and aces >= 3 then
            card.ability.extra.given_this_round = card.ability.extra.given_this_round + 1
            if G.jokerstream_add_code then G.jokerstream_add_code(4, 1) end
            return { message = "BOSS CODE", colour = G.C.BLUE, card = card }
        end
        if hand_name == "Four of a Kind" and queens == 4 then
            card.ability.extra.given_this_round = card.ability.extra.given_this_round + 1
            if G.jokerstream_add_code then G.jokerstream_add_code(3, 2) end
            return { message = "CARDS CODE", colour = G.C.TURQUOISE, card = card }
        end
        if (hand_name == "Straight" or hand_name == "Straight Flush")
           and ranks_set[14] and ranks_set[13] and ranks_set[12]
           and ranks_set[11] and ranks_set[10] then
            card.ability.extra.given_this_round = card.ability.extra.given_this_round + 1
            if G.jokerstream_add_code then G.jokerstream_add_code(5, 3) end
            return { message = "JOKERS CODE", colour = G.C.PURPLE, card = card }
        end
        if hand_name == "Pair" and #hand == 2 then
            local c1, c2 = hand[1], hand[2]
            if c1 and c2 and c1:get_id() == c2:get_id() then
                local s1 = c1.base and c1.base.suit
                local s2 = c2.base and c2.base.suit
                if s1 and s2 and s1 == s2 then
                    card.ability.extra.given_this_round = card.ability.extra.given_this_round + 1
                    if G.jokerstream_add_code then G.jokerstream_add_code(2, 4) end
                    return { message = "SHOP CODE", colour = G.C.GREEN, card = card }
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "decrypt_me",
    atlas = "DecryptMeAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 75, mult = 25, trojan_reduce = 0.25, tier = 3 } },
    rarity = 3, cost = 8, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, math.floor(card.ability.extra.trojan_reduce * 100), card.ability.extra.tier } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Three of a Kind" then
            return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
        end
    end,
}

SMODS.Joker {
    key = "we_xs3w",
    atlas = "WeXs3wAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 30, mult = 10, purity_boost = 0.10, tier = 2 } },
    rarity = 1, cost = 6, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, math.floor(card.ability.extra.purity_boost * 100), card.ability.extra.tier } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Pair" then
            return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
        end
    end,
}

SMODS.Joker {
    key = "processor_sergey",
    atlas = "ProcessorSergeyAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 160, purity_boost = 0.70, tier = 4 } },
    rarity = 4, cost = 15, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, math.floor(card.ability.extra.purity_boost * 100), card.ability.extra.tier } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Three of a Kind" then
            return { chips = card.ability.extra.chips, card = card }
        end
    end,
}

SMODS.Joker {
    key = "city_of_terror",
    atlas = "CityOfTerrorAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult_per_ace = 20 } },
    rarity = 3, cost = 9, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_per_ace } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 then
                return { mult = card.ability.extra.mult_per_ace, card = card }
            end
        end
        if context.joker_main then
            local has_ace = false
            for _, c in ipairs(context.scoring_hand or {}) do
                if c:get_id() == 14 then has_ace = true; break end
            end
            -- ★ МИНИ-ЭФФЕКТ: шанс создать код
            if has_ace and math.random(1, 3) == 1 and G.jokerstream_add_code then
                G.jokerstream_add_code(4, 3) -- ctos
                return { message = "ACE CODE", colour = G.C.BLUE, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "dedsec_txt",
    atlas = "DedsecTxtAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 80 } },
    rarity = 1, cost = 4, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local hand = context.scoring_hand or {}
            local rank_count = {}
            for _, c in ipairs(hand) do
                local id = c:get_id()
                rank_count[id] = (rank_count[id] or 0) + 1
            end
            for _, count in pairs(rank_count) do
                if count >= 2 then
                    return { chips = card.ability.extra.chips, card = card }
                end
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            -- ★ МИНИ-ЭФФЕКТ: шанс создать код
            if math.random(1, 4) == 1 and G.jokerstream_add_code then
                G.jokerstream_add_code(1, 1) -- socks
                return { message = "CODE", colour = G.C.GREEN }
            end
        end
    end,
}

SMODS.Joker {
    key = "mamular",
    atlas = "MamularAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 175 } },
    rarity = 1, cost = 8, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local hand = context.scoring_hand or {}
            local rank_count = {}
            for _, c in ipairs(hand) do
                local id = c:get_id()
                rank_count[id] = (rank_count[id] or 0) + 1
            end
            local pairs_count, sets_count = 0, 0
            for _, count in pairs(rank_count) do
                if count == 2 then pairs_count = pairs_count + 1 end
                if count >= 3 then sets_count = sets_count + 1 end
            end
            local total = (pairs_count + sets_count) * card.ability.extra.chips
            if total > 0 then
                return { chips = total, card = card }
            end
        end
    end,
}
SMODS.Joker {
    key = "deg75",
    atlas = "Deg75Atlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult_per_card = 15 } },
    rarity = 2, cost = 6, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_per_card } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local hand = context.scoring_hand or {}
            local has_spades, has_clubs = false, false
            for _, c in ipairs(hand) do
                local s = c.base and c.base.suit
                if s == "Spades" or s == "S" then has_spades = true end
                if s == "Clubs" or s == "C" then has_clubs = true end
            end
            if has_spades and has_clubs then
                local s = context.other_card.base and context.other_card.base.suit
                if s == "Spades" or s == "S" or s == "Clubs" or s == "C" then
                    return { mult = card.ability.extra.mult_per_card, card = card }
                end
            end
        end
        if context.joker_main then
            local hand = context.scoring_hand or {}
            local has_spades, has_clubs = false, false
            for _, c in ipairs(hand) do
                local s = c.base and c.base.suit
                if s == "Spades" or s == "S" then has_spades = true end
                if s == "Clubs" or s == "C" then has_clubs = true end
            end
            -- ★ МИНИ-ЭФФЕКТ: шанс создать код
            if has_spades and has_clubs and math.random(1, 5) == 1 and G.jokerstream_add_code then
                G.jokerstream_add_code(3, 3) -- vm
                return { message = "CODE", colour = G.C.TURQUOISE, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "karma_for_deed",
    atlas = "KarmaSkullAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 77, mult = 66 } },
    rarity = 3, cost = 10, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local hearts, clubs = 0, 0
            for _, c in ipairs(context.scoring_hand) do
                local s = c.base and c.base.suit
                if s == "Hearts" or s == "H" then hearts = hearts + 1 end
                if s == "Clubs" or s == "C" then clubs = clubs + 1 end
            end
            if hearts >= 2 and clubs >= 2 then
                local ret = { chips = card.ability.extra.chips, mult = card.ability.extra.mult, card = card }
                -- ★ МИНИ-ЭФФЕКТ: шанс создать сигнатурный код
                if math.random(1, 10) == 1 and G.jokerstream_add_code then
                    G.jokerstream_add_code("signature", 1)
                    ret.message = "SIGNATURE!"
                    ret.colour = G.C.MONEY
                end
                return ret
            end
        end
    end,
}

SMODS.Joker {
    key = "wsw_ghost",
    atlas = "WswGhostAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult = 5, destroy_chance = 3 } },
    rarity = 3, cost = 10, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.destroy_chance } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { Xmult = card.ability.extra.xmult, card = card }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if math.random(1, card.ability.extra.destroy_chance) == 1 then
                local jokers_to_destroy = {}
                for _, j in ipairs(G.jokers.cards) do
                    if j ~= card then table.insert(jokers_to_destroy, j) end
                end
                if #jokers_to_destroy > 0 then
                    local target = pseudorandom_element(jokers_to_destroy, pseudoseed('wsw_glitch'))
                    SMODS.destroy_cards({ target }, { pinch_anim = true })
                    return { message = "SYSTEM CRASH!", colour = G.C.RED, card = card }
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "dead_archive",
    atlas = "DeadArchiveAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 25 } },
    rarity = 3, cost = 9, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.scoring_name == "Pair" or context.scoring_name == "Two Pair" then
                return { mult = card.ability.extra.mult, card = card }
            end
        end
        if context.joker_main then
            -- ★ МИНИ-ЭФФЕКТ: шанс создать код магазина
            if context.scoring_name == "Two Pair" and math.random(1, 3) == 1 and G.jokerstream_add_code then
                G.jokerstream_add_code(2, 4) -- shop
                return { message = "SHOP CODE", colour = G.C.GREEN, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "binary_code",
    atlas = "BinaryAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 25 } },
    rarity = 2, cost = 6, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local enhanced_count = 0
            for _, c in ipairs(context.scoring_hand) do
                if c.config and c.config.center and c.config.center.key ~= 'c_base' then
                    enhanced_count = enhanced_count + 1
                end
            end
            if enhanced_count >= 2 then
                return { chips = card.ability.extra.chips, card = card }
            end
        end
        if context.joker_main then
            local enhanced_count = 0
            for _, c in ipairs(context.scoring_hand or {}) do
                if c.config and c.config.center and c.config.center.key ~= 'c_base' then
                    enhanced_count = enhanced_count + 1
                end
            end
            -- ★ МИНИ-ЭФФЕКТ: шанс получить энергию
            if enhanced_count >= 2 and math.random(1, 4) == 1 then
                local wd = G.jokerstream_addons_loaded and G.jokerstream_addons_loaded["watch_dogs"]
                if wd and wd.add_energy then wd.add_energy(1) end
                return { message = "ENERGY!", colour = G.C.GREEN, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "dead_exe",
    atlas = "DeadExeAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { rounds = 0, need = 3, amount = 3 } },
    rarity = 1, cost = 4, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.need, card.ability.extra.amount, card.ability.extra.rounds or 0 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
            if card.ability.extra.rounds >= card.ability.extra.need then
                card.ability.extra.rounds = 0
                local pool = { "m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_stone", "m_gold", "m_lucky" }
                local applied = 0
                for i = 1, card.ability.extra.amount do
                    if G.deck and G.deck.cards and #G.deck.cards > 0 then
                        local c = pseudorandom_element(G.deck.cards, pseudoseed('dead_exe_' .. i))
                        if c and c.config and c.config.center and c.config.center.key == 'c_base' then
                            local enh = pseudorandom_element(pool, pseudoseed('dead_exe_pool_' .. i))
                            c:set_ability(G.P_CENTERS[enh], nil, true)
                            applied = applied + 1
                        end
                    end
                end
                if applied > 0 then
                    -- ★ МИНИ-ЭФФЕКТ: всегда даёт код
                    if G.jokerstream_add_code then G.jokerstream_add_code(1, 2) end
                    return { message = "EXECUTED + CODE", colour = G.C.GREEN, card = card }
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "vinyl_hack",
    atlas = "VinylAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { min_jokers = 2 } },
    rarity = 2, cost = 8, unlocked = true, discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min_jokers } }
    end,
    calculate = function(self, card, context)
        if context.before then
            G.GAME.wd_vinyl_triggered = false
            G.GAME.wd_vinyl_code_given = false
            for _, c in ipairs(context.scoring_hand or {}) do
                c.wd_vinyl_retriggered = nil
            end
        end

        if context.repetition and context.cardarea == G.play then
            local active_jokers = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if not j.debuff then active_jokers = active_jokers + 1 end
                end
            end

            if active_jokers >= card.ability.extra.min_jokers then
                if context.other_card and not context.other_card.wd_vinyl_retriggered then
                    context.other_card.wd_vinyl_retriggered = true
                    
                    -- ★ МИНИ-ЭФФЕКТ: шанс создать код при ретриггере
                    if not G.GAME.wd_vinyl_code_given and math.random(1, 15) == 1 and G.jokerstream_add_code then
                        G.GAME.wd_vinyl_code_given = true
                        G.jokerstream_add_code(2, 4) -- proxy
                        return { repetitions = 1, card = card, message = "CODE!", colour = G.C.GREEN }
                    end
                    
                    return { repetitions = 1, card = card }
                end
            end
        end

        if context.joker_main and not G.GAME.wd_vinyl_triggered then
            local active_jokers = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if not j.debuff then active_jokers = active_jokers + 1 end
                end
            end
            if active_jokers >= card.ability.extra.min_jokers then
                G.GAME.wd_vinyl_triggered = true
                return { message = "REPLAY", colour = G.C.BLUE, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "nuclear_gift",
    atlas = "NuclearGiftAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 450, rounds = 0, max_rounds = 5, destroy_chance = 2 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        local rounds_left = math.max(0, card.ability.extra.max_rounds - (card.ability.extra.rounds or 0))
        return { vars = { card.ability.extra.chips, card.ability.extra.max_rounds, card.ability.extra.destroy_chance, rounds_left } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips, card = card }
        end
        
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
            
            if card.ability.extra.rounds >= card.ability.extra.max_rounds then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        play_sound('timpani')
                        card:juice_up(0.3, 0.5)
                        
                        -- ★ МИНИ-ЭФФЕКТ: даёт 2 кода
                        if G.jokerstream_add_code then
                            G.jokerstream_add_code(math.random(1, 3), math.random(1, 4))
                            G.jokerstream_add_code(math.random(1, 3), math.random(1, 4))
                        end

                        if math.random(1, card.ability.extra.destroy_chance) == 1 then
                            local valid_targets = {}
                            for _, j in ipairs(G.jokers.cards) do
                                if j ~= card then table.insert(valid_targets, j) end
                            end
                            if #valid_targets > 0 then
                                local target = pseudorandom_element(valid_targets, pseudoseed('nuclear_gift'))
                                SMODS.destroy_cards({ target }, { pinch_anim = true })
                            end
                        end
                        
                        SMODS.destroy_cards({ card }, { pinch_anim = true })
                        return true
                    end
                }))
                
                return { message = "BOOM + 2 CODES!", colour = G.C.RED, card = card }
            end
        end
    end,
}

SMODS.Joker {
    key = "anonymity",
    atlas = "AnonymityAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 24, played_8_this_round = false } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then card.ability.extra.played_8_this_round = false end
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 8 then
                card.ability.extra.played_8_this_round = true
                return { 
                    mult = card.ability.extra.mult, 
                    card = card 
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            -- ★ МИНИ-ЭФФЕКТ: шанс создать код
            if card.ability.extra.played_8_this_round and math.random(1, 5) == 1 and G.jokerstream_add_code then
                G.jokerstream_add_code(4, 1) -- ctos
                return { message = "CODE", colour = G.C.BLUE }
            end
        end
    end,
}