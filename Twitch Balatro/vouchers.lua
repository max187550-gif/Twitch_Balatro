-- ============================================
-- VOUCHERS.LUA — Twitch Balatro
-- ============================================

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
}

SMODS.Voucher {
    key = "meme_chat",
    atlas = "MemeChatAtlas",
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_unlimited_chat" },
}

SMODS.Voucher {
    key = "virus_chat",
    atlas = "VirusChatAtlas",
    pos = { x = 0, y = 0 },
    cost = 23,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_meme_chat" },
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
}

SMODS.Voucher {
    key = "moderator_of_moderator_of_moderator",
    atlas = "ModeratorOfModeratorOfModeratorAtlas",
    pos = { x = 0, y = 0 },
    cost = 25,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_moderator_of_moderator" },
}

SMODS.Voucher {
    key = "moderator_pocket_universe",
    atlas = "ModeratorPocketUniverseAtlas",
    pos = { x = 0, y = 0 },
    cost = 40,
    unlocked = true,
    discovered = true,
    requires = { "v_jokerstream_moderator_of_moderator_of_moderator" },
}