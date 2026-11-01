SMODS.Enhancement {
    key = "crying_obsidian",
    atlas = "CryingObsidianAtlas",
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            return { mult = self.config.extra.mult }
        end
    end,
}

local original_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.config and self.config.center
       and self.config.center.key == "m_jokerstream_crying_obsidian"
       and not self.jokerstream_obsidian_paid then
        self.jokerstream_obsidian_paid = true
        ease_dollars(2)
    end
    return original_dissolve(self, ...)
end