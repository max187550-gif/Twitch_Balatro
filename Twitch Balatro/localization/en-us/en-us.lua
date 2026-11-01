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
            j_jokerstream_caseoh_drake = {
                name = "Business Drake",
                text = {
                    "If hand is {C:attention}Pair{} or {C:attention}Two Pair{},",
                    "each scoring card gives",
                    "{C:chips}+#1#{} Chips",
                    "{C:inactive}Business is business{}"
                }
            },
            j_jokerstream_caseoh_mazelol = {
                name = "Business Mazelol",
                text = {
                    "If hand is {C:attention}Three of a Kind{}",
                    "or {C:attention}Four of a Kind{},",
                    "each scoring card gives",
                    "{C:mult}+#1#{} Mult",
                    "{C:inactive}Same hand — same money{}"
                }
            },
            j_jokerstream_caseoh_alpha = {
                name = "Alpha Genius Businessman Male",
                text = {
                    "If hand is {C:attention}Full House{},",
                    "each scoring card gives",
                    "{C:chips}+#1#{} Chips",
                    "{C:inactive}Sigma grindset never stops{}"
                }
            },
            j_jokerstream_caseoh_toha = {
                name = "Business Toha",
                text = {
                    "If hand is {C:attention}Five of a Kind{},",
                    "{C:attention}Straight{} or {C:attention}Flush{},",
                    "each scoring card gives",
                    "{C:mult}+#1#{} Mult",
                    "{C:inactive}Contracts signed. Deals closed.{}"
                }
            },
            j_jokerstream_watcher = {
                name = "Watch Dogs",
                text = {
                    "If played hand is a {C:attention}Full House{} — gives",
                    "{C:mult}+#3#{} Mult",
                    "Every {C:attention}#1#{} rounds: gives",
                    "a random code",
                    "{C:inactive}(75% weak, 25% strong){}",
                    "{C:inactive}Progress: #2#/#1#{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_watcher_glitched = {
                name = "Watch Dogs: Glitched",
                text = {
                    "If played hand has {C:attention}3+ suits{} —",
                    "{C:chips}+#3#{} Chips for each scored card",
                    "Every {C:attention}#1#{} rounds: gives",
                    "a {C:purple}rare code{}",
                    "{C:inactive}(Clear / Encrypted / Blume){}",
                    "{C:inactive}Progress: #2#/#1#{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_secret_path_recruit = {
                name = "Secret Path Recruit",
                text = {
                    "Gives {C:mult}+#1#{} Mult",
                    "while {C:attention}energy < #2#{}",
                    "{C:green}+10%{} trojan resistance (always)",
                    "Current: {C:attention}#3#{} energy ({#4#})",
                    "----- addon Watch Dogs"
                },
            },
            j_jokerstream_you_see_me_in_donut_verse = {
                name = "You See Me in the Donut Verse",
                text = {
                    "If played hand is a {C:attention}Three of a Kind{}:",
                    "{C:chips}+#1#{} Chips for each scored card",
                    "and gives {C:purple}1 code{} of level 2",
                    "once per round (max #2#)",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_server_ghost = {
                name = "Server Ghost",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "while {C:attention}energy > #2#{}",
                    "{C:green}25%{} chance to generate a code at end of round",
                    "{C:green}+15%{} trojan resistance (always)",
                    "Current: {C:attention}#3#{} energy ({#4#})",
                    "----- addon Watch Dogs"
                },
            },
            j_jokerstream_deadsec_ = {
                name = "deadsec_",
                text = {
                    "{C:inactive}Special hands give codes:{}",
                    "{C:attention}Full House{} with 3 Aces, {C:attention}Four Queens{},",
                    "{C:attention}Royal Straight{}, {C:attention}Same-suit Pair{}",
                    "{C:inactive}Max #1# code per round{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_decrypt_me = {
                name = "Decrypt Me",
                text = {
                    "If hand is a {C:attention}Three of a Kind{},",
                    "gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{C:inactive}While held: reduces {C:red}Trojan{} chance",
                    "{C:inactive}by {C:attention}#3#%{}",
                    "{C:inactive}(Tier #4#)",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_we_xs3w = {
                name = "we//xs3w",
                text = {
                    "If hand is a {C:attention}Pair{},",
                    "gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{C:inactive}While held: adds {C:attention}#3#%{} chance",
                    "{C:inactive}to roll a {C:purple}better code tier{}",
                    "{C:inactive}(Tier #4#)",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_processor_sergey = {
                name = "Sergey's Processor",
                text = {
                    "If hand is a {C:attention}Three of a Kind{},",
                    "gives {C:chips}+#1#{} Chips",
                    "{C:inactive}While held: adds {C:attention}#2#%{} chance",
                    "{C:inactive}to roll a {C:purple}better code tier{}",
                    "{C:inactive}(Tier #3#)",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_city_of_terror = {
                name = "{C:money}City of Terror{}",
                text = {
                    "Each {C:attention}Ace{} scored gives {C:mult}+#1#{} Mult",
                    "{C:green}1 in 3{} chance to generate a code",
                    "{C:inactive}London is calling{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_dedsec_txt = {
                name = "dedsec.txt",
                text = {
                    "If hand contains a {C:attention}Pair{},",
                    "gives {C:chips}+#1#{} Chips",
                    "{C:green}1 in 4{} chance for a code at end of round",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_mamular = {
                name = "Mamular",
                text = {
                    "If played hand contains a",
                    "{C:attention}Pair{} — gives {C:chips}+#1#{} Chips,",
                    "if it contains a {C:attention}Set{} — gives",
                    "another {C:chips}+#1#{} Chips",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_deg75 = {
                name = "75°",
                text = {
                    "If hand has {C:attention}Spades{} and {C:attention}Clubs{},",
                    "each such card gives {C:mult}+#1#{} Mult",
                    "{C:green}1 in 5{} chance to generate a code",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_karma_for_deed = {
                name = "Karma for the Deed",
                text = {
                    "If hand has {C:attention}2+ Hearts{} and {C:attention}2+ Clubs{},",
                    "each scoring card gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{C:green}1 in 10{} chance for a {C:purple}Signature{} code",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_wsw_ghost = {
                name = "Project: wsw",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "At end of round, {C:green}1 in #2#{} chance to {C:red}destroy{} a Joker",
                    "{C:inactive}I see everything. I am everywhere.{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_dead_archive = {
                name = "Dead Archive",
                text = {
                    "If hand is {C:attention}Pair{} or {C:attention}Two Pair{},",
                    "each scoring card gives {C:mult}+#1#{} Mult",
                    "{C:green}1 in 3{} chance for a {C:attention}Shop{} code on Two Pair",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_binary_code = {
                name = "11110001110000",
                text = {
                    "If hand contains {C:attention}2+ enhanced{} cards,",
                    "each scoring card gives {C:chips}+#1#{} Chips",
                    "{C:green}1 in 4{} chance to gain {C:money}+$1{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_dead_exe = {
                name = "dead.exe",
                text = {
                    "Every {C:attention}#1#{} rounds, enhances {C:attention}#2#{} random cards",
                    "{C:inactive}(Progress: #3#/#1#){}",
                    "Always generates a code when executed",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_vinyl_hack = {
                name = "Broken Record",
                text = {
                    "If you have {C:attention}2+ active Jokers{},",
                    "retriggers {C:attention}all{} played cards",
                    "Each retrigger has a {C:green}1 in 15{} chance to generate a code",
                    "{C:inactive}I'll put this track on repeat.{}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_nuclear_gift = {
                name = "Nuclear Gift",
                text = {
                    "Gives {C:chips}+#1#{} Chips",
                    "After {C:attention}#2#{} rounds, {C:red}explodes{},",
                    "{C:green}1 in #3#{} chance to {C:red}destroy{} a Joker,",
                    "{C:inactive}(Rounds left: #4#){}",
                    "----- addon Watch Dogs"
                }
            },
            j_jokerstream_anonymity = {
                name = "Anonymity",
                text = {
                    "Each {C:attention}8{} scored gives {C:mult}+#1#{} Mult",
                    "If an 8 was played, {C:green}1 in 5{} chance to generate a code",
                    "{C:inactive}Everything is anonymous until it is needed.{}",
                    "----- addon Watch Dogs"
                }
            },
        },
        Voucher = {
            v_jokerstream_twitch_algorithm = {
                name = "Twitch Algorithm",
                text = {
                    "{C:attention}Twitch Jokers{} appear",
                    "{C:attention}2x{} more often in the shop",
                    "{C:inactive}(Works on all mod jokers){}"
                }
            },
            v_jokerstream_twitch_algorithm_plus = {
                name = "Twitch Algorithm+",
                text = {
                    "{C:attention}Twitch Jokers{} appear",
                    "{C:attention}4x{} more often in the shop",
                    "{C:inactive}(Replaces Twitch Algorithm){}"
                }
            },
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
            v_jokerstream_business_mazelol_office = {
                name = "Work in Office",
                text = {
                    "{C:attention}Business Mazelol{} now gives",
                    "{C:mult}+120{} Mult for each scoring card",
                    "{C:inactive}(instead of +80){}"
                }
            },
            v_jokerstream_business_mazelol_cold = {
                name = "Work with Cold Air",
                text = {
                    "{C:attention}Business Mazelol{} now gives",
                    "{C:mult}+160{} Mult for each scoring card",
                    "{C:inactive}(instead of +120){}"
                }
            },
            v_jokerstream_dedsec_booster = {
                name = "DedSec Booster",
                text = {
                    "{C:attention}Watch Dogs{} and normal Jokers appear",
                    "{C:attention}2x{} more often in the shop",
                    "{C:inactive}(Only appears if Watch Dogs addon is enabled){}"
                }
            },
            v_jokerstream_perfect_firewall = {
                name = "Perfect Firewall",
                text = {
                    "Reduces {C:red}Trojan{} chance by {C:attention}50%{}.",
                    "{C:inactive}(The system is now perfectly protected){}",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_ip_locator = {
                name = "IP Locator",
                text = {
                    "Upon {C:green}reflecting a Trojan{}, redirects packets.",
                    "The code activates anyway.",
                    "Prints a trace log on success.",
                    "{C:inactive}(The worm is redirected to a CTOS server){}",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_one_equals_two = {
                name = "1 = 2",
                text = {
                    "Using {C:attention}search{} in the console",
                    "gives {C:attention}2 codes{}",
                    "instead of 1",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_dedsec_battery = {
                name = "DedSec Battery",
                text = {
                    "Boosts console performance.",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_dedsec_battery_plus = {
                name = "DedSec Battery+",
                text = {
                    "Boosts console performance even more.",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_firewall = {
                name = "Firewall",
                text = {
                    "Reduces {C:red}Trojan{} chance by {C:attention}15%{}.",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_firewall_plus = {
                name = "Advanced Firewall",
                text = {
                    "Reduces {C:red}Trojan{} chance by another {C:attention}15%{}.",
                    "{C:inactive}(Total 30% reduction)",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_encryption_key = {
                name = "Encryption Key",
                text = {
                    "Codes can no longer roll {C:attention}Noisy{}.",
                    "{C:inactive}(Minimum tier is now Static){}",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_deep_web_access = {
                name = "Deep Web Access",
                text = {
                    "{C:green}15%{} chance to upgrade any generated code",
                    "to the next tier.",
                    "{C:inactive}(Requires Watch Dogs addon){}"
                }
            },
            v_jokerstream_shop_scanner = {
                name = "Shop Scanner",
                text = {
                    "When entering the shop, {C:green}20%{} chance",
                    "to reduce all prices by {C:attention}15%{}.",
                    "{C:inactive}(Requires Watch Dogs addon){}"
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
        Other = {
            jokerstream_code_line_hidden = {
                name = "🔑 Security Code",
                text = {
                    "{C:0x66FF66}-------{}",
                    "{C:inactive}(buy to reveal){}"
                }
            },
            jokerstream_code_line_revealed = {
                name = "🔑 Security Code",
                text = {
                    "{C:0x66FF66}#1#{}",
                    "{C:inactive}(use in console to activate){}"
                }
            },
        },
    },
    misc = {
        dictionary = {
            k_active = "ACTIVE",
            k_inactive = "INACTIVE",
        },
    },
}