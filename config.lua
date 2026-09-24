-- ============================================
-- НАСТРОЙКИ JOKER STREAM
-- ============================================

-- Привязываем глобальный конфиг к SMODS, чтобы всё сохранялось
if SMODS and SMODS.current_mod then
    SMODS.current_mod.config = SMODS.current_mod.config or {}
    G.jokerstream_config = SMODS.current_mod.config
else
    G.jokerstream_config = G.jokerstream_config or {}
end

local cfg = G.jokerstream_config

-- ============================================
-- ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ
-- ============================================
if cfg.chat_enabled == nil then cfg.chat_enabled = true end
if cfg.intro_enabled == nil then cfg.intro_enabled = true end
if cfg.donators_enabled == nil then cfg.donators_enabled = true end

if cfg.donate_threshold_yellow_center == nil then cfg.donate_threshold_yellow_center = 50 end
if cfg.donate_threshold_yellow_left == nil then cfg.donate_threshold_yellow_left = 20 end
if cfg.donate_threshold_red_top == nil then cfg.donate_threshold_red_top = 10 end

if cfg.karal_donate_enabled == nil then cfg.karal_donate_enabled = true end
if cfg.streamer_donate_enabled == nil then cfg.streamer_donate_enabled = true end

-- Аккаунт
if cfg.account_name == nil then cfg.account_name = nil end
if cfg.real_name == nil then cfg.real_name = nil end
if cfg.stream_theme == nil then cfg.stream_theme = nil end
if cfg.api_key == nil then cfg.api_key = nil end
if cfg.welcome_shown == nil then cfg.welcome_shown = false end

-- Канал
if cfg.channel_subs == nil then cfg.channel_subs = 0 end
if cfg.channel_received == nil then cfg.channel_received = 0 end
if cfg.channel_time == nil then cfg.channel_time = 0 end
if cfg.channel_clips == nil then cfg.channel_clips = {} end
if cfg.channel_milestones == nil then cfg.channel_milestones = {} end
if cfg.channel_description == nil then cfg.channel_description = nil end
if cfg.channel_palette == nil then cfg.channel_palette = 1 end

print("[JOKER STREAM] config.lua loaded, subs =", cfg.channel_subs)