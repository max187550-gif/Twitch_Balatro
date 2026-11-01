-- ============================================
-- VOUCHERS.LUA — Twitch Balatro
-- ============================================

-- Хелпер: есть ли указанный джокер в активных слотах
local function has_joker(joker_key)
    if not G.jokers or not G.jokers.cards then return false end
    for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center
           and j.config.center.key == joker_key then
            return true
        end
    end
    return false
end

-- Фабрика in_pool: ваучер появится только если джокер у игрока
local function need_joker(joker_key)
    return function(self)
        return has_joker(joker_key)
    end
end

-- ============================================
-- ЛИНИЯ АЛГОРИТМА (шанс выпадения твич-джокеров)
-- ============================================

SMODS.Voucher {
    key = "twitch_algorithm",
    atlas = "TwitchAlgorithmAtlas",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
}

SMODS.Voucher {
    key = "twitch_algorithm_plus",
    atlas = "TwitchAlgorithmPlusAtlas",
    pos = { x = 0, y = 0 },
    cost = 20,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_twitch_algorithm" },
}

-- ============================================
-- ЛИНИЯ ЕДЫ
-- ============================================

SMODS.Voucher {
    key = "food_tips",
    atlas = "FoodTipsAtlas",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
}

SMODS.Voucher {
    key = "food_tips_plus",
    atlas = "FoodTipsPlusAtlas",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_food_tips" },
}

SMODS.Voucher {
    key = "food_all",
    atlas = "FoodAllAtlas",
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_food_tips_plus" },
    in_pool = need_joker("j_jokerstream_toha"),
}

-- ============================================
-- ЛИНИЯ ЧАТА
-- ============================================

SMODS.Voucher {
    key = "unlimited_chat",
    atlas = "UnlimitedChatAtlas",
    pos = { x = 0, y = 0 },
    cost = 12,
    unlocked = true,
    discovered = true,
    in_pool = need_joker("j_jokerstream_chat_balatro"),
}

SMODS.Voucher {
    key = "meme_chat",
    atlas = "MemeChatAtlas",
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_unlimited_chat" },
    in_pool = need_joker("j_jokerstream_chat_balatro"),
}

SMODS.Voucher {
    key = "virus_chat",
    atlas = "VirusChatAtlas",
    pos = { x = 0, y = 0 },
    cost = 23,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_meme_chat" },
    in_pool = need_joker("j_jokerstream_chat_balatro"),
}

-- ============================================
-- ЛИНИЯ МОДЕРАТОРА
-- ============================================

SMODS.Voucher {
    key = "moderator_of_moderator",
    atlas = "ModeratorOfModeratorAtlas",
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    in_pool = need_joker("j_jokerstream_moderator"),
}

SMODS.Voucher {
    key = "moderator_of_moderator_of_moderator",
    atlas = "ModeratorOfModeratorOfModeratorAtlas",
    pos = { x = 0, y = 0 },
    cost = 25,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_moderator_of_moderator" },
    in_pool = need_joker("j_jokerstream_moderator"),
}

SMODS.Voucher {
    key = "moderator_pocket_universe",
    atlas = "ModeratorPocketUniverseAtlas",
    pos = { x = 0, y = 0 },
    cost = 40,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_moderator_of_moderator_of_moderator" },
    in_pool = need_joker("j_jokerstream_moderator"),
}

-- ============================================
-- ЛИНИЯ ДЕЛОВОГО МАЗЕЛОЛА
-- ============================================

SMODS.Voucher {
    key = "business_mazelol_office",
    atlas = "BizMazelolOfficeAtlas",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    in_pool = need_joker("j_jokerstream_caseoh_mazelol"),
}

SMODS.Voucher {
    key = "business_mazelol_cold",
    atlas = "BizMazelolColdAtlas",
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_business_mazelol_office" },
    in_pool = need_joker("j_jokerstream_caseoh_mazelol"),
}
SMODS.Voucher {
    key = "dedsec_booster",
    atlas = "DedsecBoosterAtlas",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    
    -- Проверка: ваучер появляется ТОЛЬКО если аддон Watch Dogs включен
    in_pool = function(self, args)
        if not G.jokerstream_addon_enabled then return false end
        return G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}
SMODS.Voucher {
    key = "perfect_firewall",
    atlas = "FirewallAtlas", 
    pos = { x = 0, y = 0 },
    cost = 20, -- ★ Цена изменена на 20
    unlocked = true,
    discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
}
SMODS.Voucher {
    key = "ip_locator",
    atlas = "IpLocatorAtlas",
    pos = { x = 0, y = 0 },
    cost = 12,
    unlocked = true,
    discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
}
SMODS.Voucher {
    key = "one_equals_two",
    atlas = "OneEqualsTwoAtlas",
    pos = { x = 0, y = 0 },
    cost = 12,
    unlocked = true,
    discovered = true,
    in_pool = function(self, args)
        return G.jokerstream_addon_enabled and G.jokerstream_addon_enabled("watch_dogs") == true
    end,
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
}