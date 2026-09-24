return {
    descriptions = {
        Joker = {
            j_jokerstream_apple = {
                name = "National Product \"Apple\"",
                text = {
                    "Gives {C:chips}+#1#{} Chips",
                    "when hand is played",
                    "{C:inactive}(+1 at end of round, permanently)"
                }
            },
            j_jokerstream_banana = {
                name = "Morning Banana",
                text = {
                    "Gives {C:mult}+#1#{} Mult",
                    "when hand is played",
                    "{C:inactive}(+1 at end of round, permanently)"
                }
            },
            j_jokerstream_toha = {
                name = "Toha (tx2x2)",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}At end of round eats",
                    "a random {C:attention}Food{} Joker,",
                    "doubling its multiplier",
                    "{C:red}I WANT TO EAT{}"
                }
            },
            j_jokerstream_ishowspeed = {
                name = "IShowSpeed",
                text = {
                    "Chance at end of round",
                    "to receive donations:",
                    "{C:money}1 in 3{} — {C:money}$5{}",
                    "{C:money}1 in 5{} — {C:money}$10{}",
                    "{C:money}1 in 7{} — {C:money}$13{}",
                    "{C:money}1 in 12{} — {C:money}$100{}",
                    "{C:inactive}(chances are independent)"
                }
            },
            j_jokerstream_stinta = {
                name = "Stinta",
                text = {
                    "On the {C:attention}first{} and {C:attention}last{}",
                    "hand of the round gives",
                    "{C:chips}+250{} Chips and {C:mult}+5{} Mult,",
                    "and levels up",
                    "the played poker hand",
                    "{C:money}NELYA PLEASE BRING THE TEA{}"
                }
            },
            j_jokerstream_orange = {
                name = "Orange",
                text = {
                    "Gives {C:money}$#1#{}",
                    "at end of round",
                    "{C:inactive}(+$1 permanently each round)"
                }
            },
            j_jokerstream_nelya = {
                name = "Nelya",
                text = {
                    "If hand is {C:attention}Full House{},",
                    "each {C:attention}Ace{} when scoring gives",
                    "{C:chips}+35{} Chips and {C:mult}+4{} Mult",
                    "{C:attention}Streamer family with Stinta{}"
                }
            },
            j_jokerstream_mazelol = {
                name = "Mazelol",
                text = {
                    "If the played hand",
                    "is the same type as",
                    "the previous one — gives",
                    "{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult"
                }
            },
            j_jokerstream_mazelol_thoughtful = {
                name = "Thoughtful Mazelol",
                text = {
                    "If the played hand",
                    "has NOT been played yet",
                    "this round — gives {C:mult}+#1#{} Mult",
                    "{C:inactive}(list resets each round)"
                }
            },
            j_jokerstream_drake = {
                name = "Drake",
                text = {
                    "Gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{C:inactive}Increases by {C:chips}+60{} Chips",
                    "{C:inactive}and {C:mult}+4{} Mult for each",
                    "{C:inactive}defeated Boss Blind"
                }
            },
            j_jokerstream_watermelon = {
                name = "Watermelon",
                text = {
                    "Gives {C:attention}+1 Hand{}",
                    "this round",
                    "after the first played hand",
                    "{C:inactive}(Toha eats in #2# bites, #1# left)"
                }
            },
            j_jokerstream_pyaterka = {
                name = "Pyaterka",
                text = {
                    "Each {C:attention}5{} card when scoring",
                    "gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{C:inactive}Every {C:attention}5th round{} it upgrades",
                    "{C:inactive}by {C:chips}+155{} Chips and {C:mult}+55{} Mult"
                }
            },
            j_jokerstream_chat_balatro = {
                name = "Chat Balatro",
                text = {
                    "{C:dark_edition}Negative{}",
                    "Gives {C:chips}+#1#{} Chips",
                    "Each time {C:attention}any Joker{}",
                    "activates — {C:chips}+#2#{} Chips",
                    "{C:inactive}(#3#){}",
                    "{C:mult}+#4#{} Mult {C:inactive}(Maximum: +100){}",
                    "{X:mult,C:white}X#5#{} Mult {C:inactive}(Maximum: X7.5){}"
                }
            },
            j_jokerstream_farfadox = {
                name = "Farfadox — Paradox Miner",
                text = {
                    "Every {C:attention}3 rounds{} adds",
                    "a {C:attention}Crying Obsidian{} to the deck",
                    "{C:inactive}(No limit on amount){}",
                    "{C:inactive}(Rounds passed: #1#/3){}"
                }
            },
            j_jokerstream_moderator = {
                name = "Moderator",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "for each purchased {C:attention}Voucher{}",
                    "{C:inactive}(Maximum: X#2#){}",
                    "{C:inactive}(Now: {X:mult,C:white}X#3#{}{C:inactive}){}",
                    "{C:dark_edition}#4#{}"
                }
            },
            j_jokerstream_ad_banner = {
                name = "Ad Banner",
                text = {
                    "{C:dark_edition}Negative{}",
                    "After {C:attention}Small{} and {C:attention}Boss{} blinds",
                    "adds {C:attention}+1 Voucher{} to the shop",
                    "But all Vouchers cost {C:money}50%{} more",
                    "{C:inactive}small stakes — small wins{}",
                    "{C:inactive}big stakes — zero wins{}"
                }
            },
            j_jokerstream_voucher_sponsor = {
                name = "Voucher Sponsor",
                text = {
                    "{C:dark_edition}Negative{}",
                    "After {C:attention}Small{} and {C:attention}Boss{} blinds",
                    "adds {C:attention}+1 Voucher{} to the shop",
                    "Gives {C:money}+$#1#{} at end of round",
                    "But all Vouchers cost {C:money}30%{} more",
                    "{C:dark_edition}i'll give vouchers but only for a fee{}"
                }
            },
            j_jokerstream_broker = {
                name = "Broker",
                text = {
                    "{C:dark_edition}Negative{}",
                    "After {C:attention}Small{} and {C:attention}Boss{} blinds",
                    "adds {C:attention}+2 Vouchers{} to the shop",
                    "Gives {C:money}+$#1#{} at end of round",
                    "But all Vouchers cost {C:money}20%{} more",
                    "{C:dark_edition}everything sells and everything buys{}"
                }
            },
            j_jokerstream_sin_rarity = {
                name = "Raro ga nai pero aru?",
                text = {
                    "{C:inactive}I don't know how this works but it does{}",
                    "{C:inactive}¿No が hay レア pero ない?{}",
                    "Si 無い tiene 有る → {C:money}+$#1#{} y {C:mult}+#2#{} マルチ",
                    "{C:inactive}¿Pero 何これ? わからん pero たぶん わかる{}",
                    "{C:inactive}sí no hay レア entonces 有る だろう{}"
                }
            },
            j_jokerstream_lurker = {
                name = "tx2x2 gift from a fan",
                text = {
                    "If hand is {C:attention}Four of a Kind{},",
                    "each scoring card gives",
                    "{C:chips}+#1#{} Chips",
                    "and {C:mult}+#2#{} Mult",
                    "{C:inactive}i am lion{}"
                }
            },
            j_jokerstream_pixel_stinta = {
                name = "Pixel Stinta",
                text = {
                    "If the played hand contains",
                    "both a {C:attention}2{} and an {C:attention}8{},",
                    "each scoring card gives",
                    "{C:chips}+#1#{} Chips"
                }
            },
            j_jokerstream_bath_stinta = {
                name = "Bath Stinta",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "If you play {C:attention}Pair{}, {C:attention}Set{}",
                    "and {C:attention}Full House{} in one round,",
                    "gains {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}(Max: X#3#){}",
                    "{C:chips}i'm a fish hedgehog{}"
                }
            },
            j_jokerstream_caseoh = {
                name = "switched to light theme (CaseOh)",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "If {C:green}1 in #2#{} chance succeeds,",
                    "gains {X:mult,C:white}X#3#{} Mult",
                    "{C:inactive}(Max: X#4#){}"
                }
            },
            j_jokerstream_national_equality = {
                name = "{C:red}National Equality{}",
                text = {
                    "{C:inactive}All are equal, but some are more equal{}",
                    "For each {C:attention}repeated suit{}",
                    "gives {C:chips}+#1#{} Chips",
                    "Every {C:attention}#2#{} rounds gives",
                    "a random {C:tarot}Tarot{}:",
                    "{C:attention}Star{}, {C:attention}Moon{}, {C:attention}Sun{}, {C:attention}World{}",
                    "{C:inactive}(if there's room){}",
                    "{C:inactive}(Rounds passed: #3#/#2#){}"
                }
            },
            j_jokerstream_fourth_wheel = {
                name = "The Odd One Out",
                text = {
                    "After defeating a {C:attention}Boss Blind{}",
                    "creates {C:attention}#1#{} random",
                    "{C:attention}streamer Jokers{} from the collection",
                    "{C:inactive}(if there's room){}",
                    "{C:inactive}girls, what is he even doing in our company{}"
                }
            },
            j_jokerstream_clown_streamer = {
                name = "Clown Streamer",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "For each Joker {C:attention}without edition{},",
                    "gains {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}(Doesn't count itself){}",
                    "{C:inactive}the more circus — the funnier{}"
                }
            },
            j_jokerstream_gojo_stint = {
                name = "Gojo stint",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "for each {C:dark_edition}edition{} in your deck",
                    "{C:inactive}(Foil +X#2#, Holo +X#2#, Poly +X#3#, Neg +X#4#){}"
                }
            },
            j_jokerstream_pixel_drake = {
                name = "Pixel Drake",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "for each {C:attention}Rare{} Joker",
                    "Gives {X:mult,C:white}X#2#{} Mult",
                    "for each {C:attention}Uncommon{} Joker",
                    "Gives {C:chips}+#3#{} Chips",
                    "for each {C:attention}Common{} Joker"
                }
            },
            j_jokerstream_ogorodnik = {
                name = "Ogorodnik (tx2x2)",
                text = {
                    "Each time a Joker triggers",
                    "{C:attention}twice in one hand{},",
                    "gains {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}(Small bucket, big ambitions){}"
                }
            },
            j_jokerstream_dessert = {
                name = "Dessert",
                text = {
                    "At end of round, gives",
                    "{C:attention}1 random Food Joker{}",
                    "If {C:attention}Toha{} is in your deck,",
                    "{C:green}1 in #1#{} chance Toha eats him",
                    "{C:inactive}(Each 2 Food Jokers: chance +1){}",
                    "{C:inactive}(Current: 1 in #2#){}",
                    "{C:0xFF87C0}i'm so sweet you'd think i'm a cherry{}"
                }
            },
        },
        Voucher = {
            v_jokerstream_food_tips = {
                name = "Food Tips",
                text = {
                    "When {C:attention}Toha{} eats",
                    "a {C:attention}Food{} Joker, you receive",
                    "{C:money}50%{} of its cost as money"
                }
            },
            v_jokerstream_food_tips_plus = {
                name = "Food Tips+",
                text = {
                    "When {C:attention}Toha{} eats",
                    "a {C:attention}Food{} Joker, you receive",
                    "{C:money}$10{} (common)",
                    "{C:money}$15{} (Foil) / {C:money}$17{} (Holo)",
                    "{C:money}$22{} (Poly / Negative)"
                }
            },
            v_jokerstream_food_all = {
                name = "Food = All",
                text = {
                    "{C:attention}Toha{} can now eat",
                    "consumables and cards",
                    "{C:attention}Ace{}/{C:attention}Jack{} when scoring",
                    "{C:inactive}(maximum 2 of each card per game)"
                }
            },
            v_jokerstream_unlimited_chat = {
                name = "Unlimited Chat",
                text = {
                    "{C:attention}Chat Balatro{} loses its {C:chips}700{} Chips cap",
                    "Growth is now {C:chips}+65{} instead of {C:chips}+45{}",
                    "{C:inactive}(Level I){}"
                }
            },
            v_jokerstream_meme_chat = {
                name = "Meme Chat",
                text = {
                    "{C:attention}Chat Balatro{} now gives",
                    "{C:mult}+10{} Mult for each activation",
                    "{C:inactive}(Maximum: +100){}",
                    "{C:inactive}(Level II){}"
                }
            },
            v_jokerstream_virus_chat = {
                name = "Viral Chat",
                text = {
                    "{C:attention}Chat Balatro{} now gives",
                    "{X:mult,C:white}+X0.5{} Mult for each activation",
                    "{C:inactive}(Maximum: X7.5){}",
                    "Changes the appearance of {C:attention}Chat Balatro{}",
                    "{C:inactive}(Level III){}"
                }
            },
            v_jokerstream_moderator_of_moderator = {
                name = "Moderator of Moderator",
                text = {
                    "{C:attention}Moderator{} now gives",
                    "{X:mult,C:white}X1{} Mult for each",
                    "purchased {C:attention}Voucher{}",
                    "{C:inactive}(Maximum: X7){}",
                    "{C:inactive}Who moderates the moderators?{}"
                }
            },
            v_jokerstream_moderator_of_moderator_of_moderator = {
                name = "Moderator of Moderator of Moderator",
                text = {
                    "{C:attention}Moderator{} now gives",
                    "{X:mult,C:white}X1.5{} Mult for each",
                    "purchased {C:attention}Voucher{}",
                    "{C:inactive}(Maximum: X10){}",
                    "{C:inactive}There are three now. Chat is safe. Probably.{}"
                }
            },
            v_jokerstream_moderator_pocket_universe = {
                name = "Pocket Universe of Moderators",
                text = {
                    "{C:attention}Moderator{} now gives",
                    "{X:mult,C:white}X2{} Mult for each",
                    "purchased {C:attention}Voucher{}",
                    "{C:inactive}(Maximum: X15){}",
                    "{C:inactive}You have a whole universe in your pocket.{}",
                    "{C:inactive}Don't ask how it fits in there.{}"
                }
            },
        },
        Blind = {
            bl_jokerstream_roulette = {
                name = "Roulette",
                text = {
                    "After each played hand,",
                    "if you have {C:attention}no discards left{},",
                    "a random Joker will be",
                    "{C:red}destroyed{}"
                }
            },
        },
        Enhanced = {
            m_jokerstream_crying_obsidian = {
                name = "Crying Obsidian",
                text = {
                    "{C:mult}+#1#{} Mult when scored",
                    "Gives {C:money}$2{} when destroyed"
                }
            },
        },
    },
}