SMODS.Blind {
    key = "roulette",
    atlas = "RouletteBossAtlas",
    pos = { x = 0, y = 0 },

    dollars = 5,
    mult = 2,

    boss = { min = 1, max = 999 },
    boss_colour = HEX('2b2b2b'),

    press_play = function(self)
        if not G.jokers or #G.jokers.cards == 0 then return end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.0,
            func = function()
                local discards_left = G.GAME.current_round.discards_left or 0

                if G.jokerstream_sounds and G.jokerstream_sounds.shotgun_rack then
                    G.jokerstream_sounds.shotgun_rack:clone():play()
                end

                if discards_left <= 0 then
                    G.jokerstream_roulette_overlay = {0.55, 0.10, 0.10, 0.45}

                    attention_text({
                        text = "Нет сбросов! Не повезло...",
                        scale = 1.5,
                        hold = 5,
                        major = G.ROOM_ATTACH,
                        colour = {1, 1, 1, 1},
                        cover_colour = {0, 0, 0, 0},
                        align = 'cm',
                    })

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 5.0,
                        func = function()
                            G.jokerstream_roulette_overlay = nil

                            if G.jokerstream_sounds and G.jokerstream_sounds.shotgun_shot then
                                G.jokerstream_sounds.shotgun_shot:clone():play()
                            end

                            if G.jokers and #G.jokers.cards > 0 then
                                local target = pseudorandom_element(
                                    G.jokers.cards,
                                    pseudoseed('roulette_target')
                                )
                                SMODS.destroy_cards({ target }, { pinch_anim = true })
                            end
                            return true
                        end
                    }))
                else
                    G.jokerstream_roulette_overlay = {0.95, 0.95, 0.90, 0.35}

                    attention_text({
                        text = "Пока что безопасно...",
                        scale = 1.5,
                        hold = 3,
                        major = G.ROOM_ATTACH,
                        colour = {0.15, 0.15, 0.15, 1},
                        cover_colour = {0, 0, 0, 0},
                        align = 'cm',
                    })

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 3.0,
                        func = function()
                            G.jokerstream_roulette_overlay = nil
                            return true
                        end
                    }))
                end
                return true
            end
        }))
    end
}