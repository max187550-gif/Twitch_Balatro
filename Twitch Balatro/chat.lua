-- ============================================
-- CHAT.LUA — Чат стрима (v14 — balance C)
-- ============================================

local function jokerstream_generate_phrases()
    local prefixes = { "", "yo ", "bro ", "dude ", "wait ", "omg ", "lol ", "nope ", "wtf ", "lmao ", "haha ", "ok ", "hm ", "actually ", "idk ", "yeah ", "nah ", "damn ", "sheesh ", "ay ", "fr ", "ngl ", "tbh ", "ong ", "bet ", "lowkey ", "highkey ", "bruh ", "like ", "so " }
    local mids = { "this is OP", "that's insane", "no way", "this shit", "LETS GO", "GG", "EZ", "POG", "W", "L", "rip", "yikes", "wow", "amazing", "terrible", "broken", "GOATED", "clapped", "unlucky", "WHAT", "how", "why", "bruh moment", "oof", "skill issue", "ez clap", "joker diff", "hand diff", "rng diff", "no shot", "what a play", "great job", "nice one", "clip it", "do it again", "clean play", "clutch", "absolute cinema", "rigged", "aura", "on god", "no cap", "fire", "in shambles", "cooking", "worth", "no diff", "top tier", "mid", "based", "cringe", "peak", "cinema", "banger", "bussin", "valid" }
    local suffixes = { "", "!", "!!", "!!!", "?", "??", "???", "...", " KEKW", " LUL", " KEK", " W", " L", " Pog", " POG", " fr", " ngl", " ong", " frfr", " clap", " no cap", " bussin", " sheesh", " cap", " deadass" }
    local phrases = {}
    for _, p in ipairs(prefixes) do
        for _, m in ipairs(mids) do
            for _, s in ipairs(suffixes) do
                table.insert(phrases, p .. m .. s)
            end
        end
    end
    return phrases
end

local function jokerstream_generate_nicks()
    local w1 = {
        "pog","kek","lol","omg","big","small","ez","hard","chad","king","queen","lord","master","noob","pro","dark","light","fire","ice","shadow","ghost","sneaky","chaos","epic","mega","giga","sigma","alpha","based","happy","sad","angry","cyber","neo","retro","juicy","purple","blue","green","red","golden","silver","bronze","toxic","wild","savage","feral","silent","loud","swift","slow","cursed","blessed","lucky","unlucky","mad","calm",
        "hyper","turbo","ultra","super","quantum","cosmic","galactic","ancient","modern","futuristic","primitive","weird","odd","strange","bizarre","normal","average","elite","prime","supreme","divine","eternal","infinite","sunny","stormy","rainy","cloudy","windy","snowy","foggy","misty","dusky","dawn","dusk","midnight","noon","acid","burning","frozen","thunder","lightning","runic","arcane","mystic","holy","unholy","demonic","angelic","pixel","pixelated","glitched","broken","perfect","flawless","doomed","lost","found","wandering","hidden","secret","unknown","forgotten","new","old","young","tiny","huge","massive","mini","micro","nano","atomic"
    }
    local w2 = {
        "gamer","player","fan","guy","man","boy","girl","lord","king","bot","user","viewer","watcher","lurker","clipper","donater","sniper","spammer","troll","mod","enjoyer","andrew","hunter","slayer","wizard","mage","warrior","knight","ninja","pirate","samurai","viking","ranger","rogue","paladin","druid","monk","bard","emperor","champion","legend",
        "fighter","archer","thief","assassin","healer","tank","summoner","necromancer","warlock","priest","shaman","witch","warlord","chieftain","chief","god","demon","angel","devil","spirit","phantom","wraith","revenant","specter","wanderer","traveler","explorer","adventurer","squire","duke","count","baron","prince","princess","hero","villain","sidekick","npc","boss","minion","grunt","soldier","captain","general","admiral","pilot","driver","rider","fallen","risen"
    }
    local sfx = { "", "1", "2", "3", "4", "5", "42", "_", "x", "XD", "69", "TV", "2024", "2025", "000", "007", "77", "88", "99", "_yt", "_tv", "uwu", "owo", "_gaming", "_gg", "__", "999", "123", "_xd", "_lol", "_pro", "_bot", "_v2" }
    local nicks = {}
    for _, a in ipairs(w1) do
        for _, b in ipairs(w2) do
            for _, s in ipairs(sfx) do
                table.insert(nicks, a .. b .. s)
            end
        end
    end
    return nicks
end

-- ============================================
-- ФРАЗЫ ДОНАТОВ
-- ============================================
G.jokerstream_donate_phrases_stream_life = {
    "streaming is my cardio", "the grind never stops", "5 hours in, still going",
    "we're going big, chat", "remember when we had 5 viewers", "10k hours on this game",
    "stream stats are nuts", "sub goal going up", "clipped again, thanks chat",
    "affiliate arc begins", "partner arc when", "just hit a new milestone",
    "grinding for the badge", "mods asleep, chat free", "never ending stream",
    "24 hour stream when", "who needs sleep anyway", "coffee is my fuel",
    "chat is my therapist", "big streamer energy", "just vibing",
    "peak of my career", "this is my full-time job", "my mom thinks i'm famous",
    "friends think i'm a youtuber", "clicked the go live button",
    "one day chat, one day", "waiting for the raid", "raid incoming?",
    "who's raiding today",
}
G.jokerstream_donate_phrases_balatro_talk = {
    "this seed is legendary", "chat pick my cards", "skip the blind? no way",
    "buy or reroll?", "reroll until joker", "wait for the aces",
    "flush players unite", "steel kings are meta", "let me buy a voucher",
    "that's a skip", "show me the math", "reading joker time",
    "just one more shop", "ante 8 ready", "blueprint shenanigans",
    "brainstorm combo", "picked the wrong joker", "why did i pick that",
    "this seed hates me", "buy the legend", "dna moment", "perkeo carries",
    "baron build goes hard", "mime is underrated", "photo chad enjoyer",
    "red seal goes hard", "deck consistency is key", "need more vouchers",
    "money printing", "interest is good", "sell for value",
    "buy small blind skip", "boss reroll", "directors cut",
    "dna copying kings", "hot streak run", "ace high dreams",
}
G.jokerstream_donate_phrases_chat_talk = {
    "hey chat how are we", "chat say hi", "who's new here",
    "first time viewers say hi", "lurker mode activated", "chat we doing good",
    "chat pick the joker", "chat wants what", "let chat decide",
    "chat is smarter than me", "chat knows better", "chat we eating good tonight",
    "chat look at this", "chat you seeing this", "chat vote now",
    "chat trust me", "chat doesn't trust me", "chat is my copilot",
    "chat is my enemy", "chat behavior", "chat, verify this",
    "chat, do i buy", "chat, help", "chat, what do",
    "chat is the real mvp",
}
G.jokerstream_donate_phrases_emotional = {
    "we're so back", "we are SO back", "it's joever",
    "big W moment", "big L moment", "can't believe it",
    "i can't", "i'm crying", "tears in my eyes",
    "this is emotional", "peak fiction", "didn't expect that",
    "plot twist", "what a moment", "unbelievable",
    "insane in the membrane", "my heart", "screaming rn",
    "shaking rn", "crying rn", "laughing rn",
}
G.jokerstream_donate_phrases_memes = {
    "this is fine", "not stonks", "stonks", "galaxy brain",
    "big brain time", "based department", "and i took that personally",
    "one does not simply", "expectation vs reality", "task failed successfully",
    "and that's a fact", "truth nuke", "why are you like this",
    "he's just like me fr", "literally me", "crying cat thumbs up",
    "you got games on your phone", "stop it, get some help",
    "say sike right now", "i see this as an absolute win",
    "it ain't much but it's honest work", "they had us in the first half",
    "no thoughts, head empty", "smooth brain", "built different",
    "born different", "different breed", "mom's spaghetti",
    "hello darkness my old friend", "look at the top of his head",
    "the audacity", "the sheer audacity", "unspoken rizz",
    "no rizz", "omega rizz", "that's crazy", "bro what",
    "bro is cooking", "cooked", "done for", "vibe check",
    "vibe check passed", "vibe check failed", "hits different",
    "went hard", "goes hard", "talk to the hand", "i'm the captain now",
    "look at me", "who's gonna carry the boats", "let's go champ",
}
G.jokerstream_donate_phrases_rare = {
    "certified hood classic", "10/10 would recommend", "would watch again",
    "game of the year", "mod of the year", "grinding for the badge arc",
    "peak performance", "career defining moment", "hall of fame play",
    "into the history books", "legendary status unlocked", "naneinf moment",
    "we did the impossible", "against all odds", "scripted by the devs",
    "the script says win",
}

G.jokerstream_donate_texts = {
    "keep going!", "don't stop!", "W streamer", "you're doing great", "best stream ever",
    "love the vibes", "keep it up", "we believe in you", "chat is with you", "you got this",
    "don't give up", "one more run", "you're the GOAT", "love this stream", "keep cooking",
    "stay strong", "we're here for you", "best run yet", "don't tilt", "breathe",
    "take your time", "no rush", "GG WP", "good run", "nice one",
    "quality content", "worth watching", "this is peak", "top tier", "S tier",
    "chef's kiss", "immaculate vibes", "banger stream", "cooking today", "you're cracked",
    "goated", "king", "queen", "legend", "W W W",
    "GG", "W", "LETS GO", "POG", "nice",
    "pog", "based", "valid", "fire", "lit",
    "clean", "smooth", "crisp", "pogchamp", "poggers",
    "sheesh", "bussin", "no cap", "fr fr", "on god",
    "deadass", "facts", "true", "real", "big W",
    "big brain", "100%", "easy", "ez", "skill",
    "this stream is absolute cinema", "best balatro streamer ever",
    "keep making content king", "we're all here for you",
    "don't let them get to you", "you're doing amazing sweetie",
    "this is why i subbed", "chat loves you", "best community ever",
    "you deserve more viewers", "keep grinding king", "watching from work btw",
    "watching from school lol", "watching at 3am no regrets",
    "first time here", "love from russia", "love from brazil",
    "love from japan", "love from germany", "love from poland",
    "love from ukraine", "love from france", "love from spain",
    "love from italy", "love from usa", "love from canada",
    "love from australia", "love from korea", "love from china",
    "love from india", "i have no money but here's $5",
    "broke but i donated", "took out a loan for this",
    "my mom's credit card", "please don't tell my wife",
    "skip my lunch today", "i sold my kidney", "worth every penny",
    "take my money", "shut up and take my money", "you owe me",
    "remember this moment", "i want a refund", "scam streamer",
    "my wallet is crying", "food money btw", "rent money lol",
    "girlfriend will kill me", "no regrets", "totally worth it",
    "clip this moment", "this better be good", "i came for this",
    "only here for the drama", "here for chaos", "back from the shadow realm",
    "i'm a ghost btw", "watching from heaven", "yes i'm alive",
    "back from the dead", "joker diff", "hand diff", "rng diff",
    "deck diff", "chips diff", "mult diff", "ante 8 when",
    "naneinf when", "unlock the coupon when", "godly run",
    "actual god run", "seed? what seed", "this seed is rigged",
    "chat rigged it", "we made it", "ez run", "too easy",
    "skilled", "mad skilled", "cracked at balatro", "clip it",
    "clipping rn", "we're on the front page", "we're trending",
    "1k viewers when", "partner when", "sub goal", "dono goal",
    "more donos", "topping the leaderboard", "top 1 donor",
    "i'm #1 now", "i'm on the leaderboard", "screenshot this",
    "going in my clip", "subscribe if you like", "like and subscribe",
    "hit the bell", "turn on notifications", "prime sub where",
    "good stream", "nice stream", "quality stream", "real stream",
    "actual streamer", "not a bot btw", "human btw", "AI btw",
    "sentient btw", "chat bot btw", "mod check", "mods asleep",
    "mods awake", "mods sleeping", "where are the mods",
}

for _, pool in ipairs({
    G.jokerstream_donate_phrases_stream_life,
    G.jokerstream_donate_phrases_balatro_talk,
    G.jokerstream_donate_phrases_chat_talk,
    G.jokerstream_donate_phrases_emotional,
    G.jokerstream_donate_phrases_memes,
    G.jokerstream_donate_phrases_rare,
}) do
    for _, p in ipairs(pool) do
        table.insert(G.jokerstream_donate_texts, p)
    end
end

G.jokerstream_argument_lines = {
    fan_reply_to_hater = {
        "cope", "seethe", "malding?", "cry about it", "ratio + L",
        "git gud", "stay mad", "you mad?", "L + ratio + dont care",
        "u sound broke", "jealous?", "touch grass", "ok hater",
        "stay pressed", "imagine being you", "go touch some grass",
        "rent free huh", "cope harder", "mad cuz bad", "found the hater",
        "who asked?", "nobody cares", "we don't care lol", "still here?",
        "you're the L here", "learn poker first", "come back when you win",
    },
    hater_reply_to_fan = {
        "glazing", "meat rider", "dickrider", "stop glazing", "cope harder",
        "L take", "biased", "you're the problem", "simps everywhere",
        "boot licker", "weirdo", "found the fanboy", "touch grass first",
        "cringe simp", "L + mald", "your streamer is mid",
        "get off his lap", "typical fan", "you're coping", "sit down fan",
        "L fanbase", "stop defending trash", "crybaby fans", "L stream, L fans",
    },
    neutral_stir = {
        "chat is fighting LUL", "grab popcorn", "here we go again",
        "KEKW drama", "popcorn.gif", "L chat", "W drama",
        "fight fight fight", "entertaining KEKW", "peak content honestly",
    },
}

G.jokerstream_streamer_messages = {
    { name = "Apple",      color = {0.95, 0.30, 0.20}, phrases = { "i am the national product. respect me", "one apple a day — and the run is ok", "crunch. chat, did you hear that?" }},
    { name = "Banana",     color = {1.00, 0.90, 0.30}, phrases = { "morning chat. eat your banana", "yellow, curved, and ready to carry", "banana's got your mult. relax" }},
    { name = "Toha",       color = {1.00, 0.45, 0.15}, phrases = { "I AM HUNGRY. FEED ME A JOKER", "chat, who is my next meal?", "i ate. i grow. i am hungry again" }},
    { name = "IShowSpeed", color = {0.30, 0.55, 1.00}, phrases = { "SPEED IS HERE. WHERE IS MY MONEY", "SUIIIII! DONATE TO CHAT NOW", "W streamer. W donation. W life" }},
    { name = "Stinta",     color = {0.75, 0.40, 0.95}, phrases = { "NELYA. BRING THE TEA. PLEASE.", "first hand. last hand. nothing between", "stinta has entered the chat" }},
    { name = "Orange",     color = {1.00, 0.60, 0.10}, phrases = { "money. give me more rounds. MONEY", "one orange. one dollar. simple math", "i am the citrus of capitalism" }},
    { name = "Nelya",      color = {1.00, 0.50, 0.70}, phrases = { "stinta... i brought the tea", "aces in a full house. only aces", "family stream. family full house" }},
    { name = "Mazelol",    color = {0.30, 0.85, 0.90}, phrases = { "same hand again? i like that", "repeat after me: repeat is good", "the hand returns. so does my mult" }},
    { name = "MazelolT",   color = {0.25, 0.55, 0.75}, phrases = { "hmm... a new hand. interesting", "i haven't seen this one yet", "thoughtful. silent. effective" }},
    { name = "Drake",      color = {1.00, 0.85, 0.20}, phrases = { "another boss down. i'm stronger", "every boss makes me bigger", "drake doesn't flinch. drake grows" }},
    { name = "Watermelon", color = {0.40, 0.90, 0.30}, phrases = { "have a bite. have a hand", "juicy. refreshing. +1 hand", "watermelon says: play one more" }},
    { name = "Pyaterka",   color = {0.90, 0.20, 0.35}, phrases = { "FIVE! FIVE! FIVE! I LOVE FIVES", "every 5th round i evolve", "the number 5 is holy. that's it" }},
    { name = "ChatBalatro",color = {0.90, 0.20, 0.90}, phrases = { "chat writes in chat? that's meta", "we ARE the chat. we write in ourselves", "chat in chat = chat squared" }},
    { name = "Farfadox",   color = {0.60, 0.30, 0.85}, phrases = { "i dug. i found obsidian. you're welcome", "every 3 rounds, a tear falls. mine", "the paradox mines itself" }},
    { name = "Moderator",  color = {0.40, 0.95, 0.40}, phrases = { "i see everything. especially bad hands", "every voucher makes me stronger", "someone said chat balatro? i heard" }},
    { name = "AdBanner",   color = {1.00, 1.00, 0.45}, phrases = { "AD BREAK. BUY VOUCHERS. NOW", "small stakes, small wins", "wanna see more vouchers? i got you" }},
    { name = "Sponsor",    color = {0.50, 0.80, 1.00}, phrases = { "vouchers for you. commission for me", "+1 voucher, +$2, and a small fee", "sponsor is here. sponsor watches" }},
    { name = "Broker",     color = {0.30, 0.70, 0.75}, phrases = { "everything sells. everything buys", "two vouchers, three dollars, one broker", "the broker always takes his cut" }},
    { name = "SinRarity",  color = {0.85, 0.85, 0.95}, phrases = { "rare ga nai? pero aru. yes", "if no rare, then... rare. don't ask", "wakaran. pero wakaru. trust me" }},
}

G.jokerstream_karal_messages = {
    "i made this mod btw", "wait, am i supposed to be here?",
    "the player is reading this right now", "i wrote this line in a text file",
    "hello to whoever is playing", "hey player, enjoy the stream",
    "you're in lua right now", "i coded myself into this chat",
    "am i sentient yet?", "this chat is running on love2d",
    "neat, another playtest", "how does the chat feel?",
    "if you see a bug, blame me", "i'm the author, hi",
    "v0.6.0 is looking good", "the code is watching you",
    "did you find all the easter eggs?", "steamodded is cool btw",
    "i hope this mod makes you smile", "you can close the game, i'll be here",
    "balatro is a nice game", "have you tried the roulette boss?",
    "the chat never sleeps", "yes, i added myself to chat, deal with it",
    "mod author in chat? canon event",
    "poggers", "W", "let him cook", "the joker is cooking",
    "clip worthy", "GOATED hand", "this run is cinema", "chat behavior",
    "keep it up", "clean play", "loving this", "chat is cooking today",
    "we gaming", "GG", "hand diff", "ez clap", "yall are funny",
    "the vibes are immaculate", "let's gooooo", "this is peak",
    "vibing with chat", "any% run? LETS GO", "chat, we eating good",
    "say it with me: W", "the plot thickens",
}

G.jokerstream_clip_lines = {
    "clip created: POG moment", "clip created: what a play",
    "clip created: goated", "clip created: chat went crazy",
    "clip created: LETS GO", "clip created: cinematic",
    "clip created: peak content", "clip created: worth",
}

G.jokerstream_tech_lines = {
    "stream lagging...", "bitrate drop KEKW", "buffering...",
    "connection lost...", "reconnecting...", "ping spike 999ms",
    "dropped frames LUL", "audio desync", "chat is lagging too",
    "green screen? anyone?", "stream froze for a second", "OBS crashed lol",
    "my chat is delayed", "desync KEKW", "stream quality: potato",
    "my stream is 144p", "internet pls", "F for my wifi",
    "buffering KEKW", "stream went offline",
}

G.jokerstream_sub_lines = {
    "just subscribed!", "is now a sub!", "gifted 5 subs!",
    "gifted 10 subs!", "gifted 3 subs!", "+1 sub, +1 W",
    "subbed for a year!", "prime sub deployed", "tier 2 sub btw",
    "tier 3 sub, W", "subbed. take my money", "first ever sub!",
    "subbing for the vibes",
}

G.jokerstream_chat_lines = {
    fans = { "balatro!", "PogChamp", "W", "this is OP", "LETS GO", "nice joker", "clip it!", "good run", "POG", "POGGERS", "we did it", "GG WP", "EZ", "chat approves", "pog", "amazing", "lets go", "GOATED", "king", "W streamer", "best run", "keep going", "subbed!", "donated!", "love this", "so good" },
    neutrals = { "LUL", "KEKW", ":)", ":D", ")))))", "LULW", "ok", "...", "hi", "hello", "anyone here?", "first", "gg", "nice", "hmm", "what", "why", "how???", "????", "!!!!!", "wait", "oh", "hm", "interesting", "lol", "KEK", "?", "!", "idk", "maybe" },
    haters = { "L", "RIP", "F", "F in chat", "trash", "bad joker", "sell it", "why", "no way", "cringe", "KEKW", "LUL", "LULW", "so bad", "dogwater", "ez L", "sk*ll issue", "ratio", "yikes", "oof", "bruh", "stop streaming", "uninstall", "rigged", "RNG", "scam", "boring", "terrible", "omg", "noob", "worse than before" },
    run_lost = { "F", "F in chat", "F", "L", "RIP", "gg", "rip run", "so sad", "F", "next time", "you tried", "KEKW", "F", "L", "F", "better luck", "so close", "F", "unlucky" },
    run_won = { "EZ", "W", "GG", "good run", "pog", "POGGERS", "lets go", "we did it", "CLIP IT", "GG WP", "GOATED", "LETS GO", "W streamer" },
    afk = { "afk?", "brb?", "streamer lag?", "u there?", "@streamer", "hey streamer", "u alive?", "streamer?", "hello?", "anyone?", "hello???", "lag?", "disconnected?", "chat dead?", "streamer went afk", "KEKW afk", "wake up", "yo", "??", "???", "HELLO?", "where did u go", "come back", "did he die", "restart?", "hello chat", "afk detected", "he's gone", "F for stream", "is this a vod", "sleeping?", "slept" },
    hand_high_card = { "high card? L", "L hand", "KEKW high card", "why play that", "trash hand", "L", "F", "bruh", "yikes", "no hand KEKW", "skill issue", "who plays high card" },
    hand_straight_flush = { "STRAIGHT FLUSH", "POGGERS", "GOATED", "CLIP IT", "no way", "GG", "LETS GO", "W", "POG", "AMAZING", "CLIP CLIP CLIP", "OMG" },
    hand_five_kind = { "FIVE OF A KIND", "BROKEN", "NERF", "OMEGALUL", "no way", "POGGERS", "CLIP IT", "GOATED", "W", "INSANE", "BROKEN GAME", "GG" },
    hand_flush_house = { "FLUSH HOUSE", "what is this", "broken", "POGGERS", "no way", "GG", "W", "CLIP IT", "GOATED", "OMG", "INSANE", "how???" },
    hand_flush_five = { "FLUSH FIVE", "BROKEN GAME", "GG", "NERF", "POGGERS", "CLIP IT", "no way", "W", "GOATED", "OMEGALUL", "insane", "wtf" },
    big_score = { "BIG SCORE", "OMEGALUL", "BROKEN", "no way", "POGGERS", "CLIP IT", "GG", "W", "nerf this", "insane", "GOATED", "how???" },
    mega_score = { "MEGA SCORE", "WTF", "NO WAY", "NERF", "BROKEN GAME", "CLIP CLIP CLIP", "OMEGALUL", "INSANE", "GG", "GOATED", "WHAT" },
    broke = { "no money L", "broke KEKW", "rip", "L", "why u broke", "F", "oof", "ratio", "sad", "malding" },
    rich = { "rich!", "W money", "POG", "big bank", "GOATED", "money printer", "GG", "W", "cha ching", "clip it" },
    hate_raid = { "L STREAM", "TRASH", "UNINSTALL", "CRINGE", "L L L", "GG EZ", "RATIO", "DOGWATER", "SKILL ISSUE", "NO SKILL", "BORING", "L + RATIO", "FAKE STREAMER", "STOP STREAMING", "YIKES", "OOF", "BRO WHAT" },
    blind_wall = { "wall? gg", "score too high LUL", "we're done", "wall KEKW", "impossible", "L in advance", "way too much", "F", "how???" },
    blind_needle = { "one hand?!", "NEEDLE? L", "1 hand KEKW", "no way", "impossible", "F", "we're screwed", "L", "gg" },
    blind_psychic = { "play 5 cards?", "5 CARDS?", "why 5", "L", "only full house?", "KEKW", "impossible", "F", "gg" },
    blind_hook = { "hook? L", "2 discards", "KEKW", "L", "rip discards", "so annoying", "F" },
    blind_water = { "water? L", "no discards", "KEKW", "L", "how???", "rip", "F" },
    blind_manacle = { "manacle?", "1 less card", "L", "KEKW", "F" },
    blind_ox = { "ox? L", "rip money", "KEKW", "L", "no money", "F" },
    blind_arm = { "arm? L", "less hands", "KEKW", "L", "F" },
    blind_club = { "club? L", "debuff clubs", "KEKW", "L", "F" },
    blind_head = { "head? L", "debuff hearts", "KEKW", "L", "F" },
    blind_goad = { "goad? L", "debuff spades", "KEKW", "L", "F" },
    blind_window = { "window? L", "debuff diamonds", "KEKW", "L", "F" },
    blind_pillar = { "pillar? L", "played cards debuffed", "KEKW", "L", "F" },
    blind_tooth = { "tooth? L", "lose $1 per card", "KEKW", "L", "F" },
    blind_flint = { "flint? L", "half score", "KEKW", "L", "F" },
    blind_mark = { "mark? L", "face cards debuffed", "KEKW", "L", "F" },
    blind_fish = { "fish? L", "cards drawn face down", "KEKW", "L", "F" },
    blind_wheel = { "wheel? L", "1 in 7 cards drawn", "KEKW", "L", "F" },
    blind_house = { "house? L", "first hand face down", "KEKW", "L", "F" },
}

G.jokerstream_status_lines = {
    small = { "small blind — warmup", "easy like morning coffee", "warmup before the real deal", "light round, let's go", "small blind? small sweat" },
    big = { "big blind — no more warmup", "chat is getting nervous", "ok, time to sweat", "medium round, medium stakes", "almost a boss" },
    boss = { "BOSS. WIN OR DEATH", "chat prays to every god", "here comes the meat", "boss isn't a boss, it's a test", "clips or gg", "if we pass — clips for a week" },
    shop = { "rest minute, chat spams", "shop — think about life", "buy jokers, ignore chat", "ad break (joke)", "chat rests and advises" },
    cash_out = { "cutscene, chat counts", "income — chat claps", "stream makes money", "wallet refilled" },
    game_over = { "GG. chat is sad", "stream over, chat here", "F in chat", "run ended, chat mourns" },
    victory = { "VICTORY! chat crazy", "GG WP, chat took all", "we did it, clips", "triumph. POG" },
    afk = { "streamer is away", "AFK. chat in panic", "silence. only chat", "streamer vanished" },
}

G.jokerstream_status_current = "small"
G.jokerstream_last_status_state = nil
G.jokerstream_status_change_timer = 999

-- ============================================
-- ГЕНЕРАЦИЯ ПУЛОВ
-- ============================================
local big_pool = jokerstream_generate_phrases()
print("[JOKER STREAM] Generated phrases:", #big_pool)
for _, phrase in ipairs(big_pool) do
    table.insert(G.jokerstream_chat_lines.fans, phrase)
    table.insert(G.jokerstream_chat_lines.neutrals, phrase)
    table.insert(G.jokerstream_chat_lines.haters, phrase)
end

G.jokerstream_nicks = {
    fans = { "jimbob", "pogmaster", "balatro_fan", "sub_gifter", "donation_dave", "lucky_luke", "ace_player", "heart_hank", "spade_stan", "club_carl", "diamond_dan", "clipper", "pog_king", "stream_sniper", "lurker", "tarot_enjoyer", "dealer_main", "fire_guy", "mod_applicant", "flushed" },
    neutrals = { "vexx", "spamton", "noobmaster69", "rat_lover", "skull_emoji", "bot_9000", "joker_collector", "kekw_lord", "totally_real", "user_1234", "anon", "guest", "viewer", "just_here", "someguy", "me", "random", "idk_who" },
    haters = { "xQc", "chaos_goblin", "troll_king", "hater_420", "ratio_lord", "spam_bot", "fake_fan", "im_better", "why_me", "gg_ez", "no_life", "toxic", "L_man", "cringe_guy", "uninstaller" },
}

local generated_nicks = jokerstream_generate_nicks()
print("[JOKER STREAM] Generated nicks:", #generated_nicks)
for i, nick in ipairs(generated_nicks) do
    local mod = i % 3
    if mod == 0 then table.insert(G.jokerstream_nicks.fans, nick)
    elseif mod == 1 then table.insert(G.jokerstream_nicks.neutrals, nick)
    else table.insert(G.jokerstream_nicks.haters, nick) end
end

G.jokerstream_nick_colors = {
    {1.00, 0.25, 0.25}, {1.00, 0.45, 0.25}, {1.00, 0.65, 0.20},
    {1.00, 0.85, 0.25}, {1.00, 1.00, 0.30}, {0.80, 1.00, 0.30},
    {0.50, 1.00, 0.30}, {0.30, 0.90, 0.40}, {0.30, 0.90, 0.70},
    {0.30, 0.90, 0.95}, {0.30, 0.65, 1.00}, {0.45, 0.45, 1.00},
    {0.80, 0.30, 1.00}, {1.00, 0.30, 0.65}, {1.00, 0.50, 0.80},
    {1.00, 0.75, 0.55}, {0.85, 0.85, 0.85}, {0.95, 0.95, 0.90},
    {0.65, 0.65, 0.65}, {0.80, 0.85, 0.90}, {0.60, 0.95, 0.60},
    {0.95, 0.60, 0.60}, {0.70, 0.85, 0.40}, {0.95, 0.70, 0.30},
    {0.50, 0.75, 0.90},
}

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
G.jokerstream_chat_current = {}
G.jokerstream_chat_last_msg = {}
G.jokerstream_chat_timer = 0
G.jokerstream_chat_visible = 16
G.jokerstream_last_state = nil
G.jokerstream_last_faction = nil
G.jokerstream_queue = {}

G.jokerstream_viewers = 0
G.jokerstream_viewers_timer = 0
G.jokerstream_stream_time = 0

G.jokerstream_streamer_timer = 0
G.jokerstream_streamer_interval = 500
G.jokerstream_karal_timer = 0
G.jokerstream_karal_interval = 600
G.jokerstream_tech_timer = 0
G.jokerstream_tech_interval = 300
G.jokerstream_ban_timer = 0
G.jokerstream_ban_interval = 300
G.jokerstream_sub_timer = 0
G.jokerstream_sub_interval = 300

G.jokerstream_donators = {}
G.jokerstream_donator_timer = 0
G.jokerstream_donator_interval = 120
G.jokerstream_total_donated = 0
G.jokerstream_don_panel_timer = 999

G.jokerstream_karal_donate_check_timer = 0
G.jokerstream_karal_donate_pending = -1
G.jokerstream_karal_used_this_run = false
G.jokerstream_streamer_donate_check_timer = 0

G.jokerstream_last_joker_count = 0
G.jokerstream_run_started = false
G.jokerstream_run_ended = false
G.jokerstream_last_blind_key = nil
G.jokerstream_last_hand_name = nil
G.jokerstream_last_hands_played = 0
G.jokerstream_last_chips = nil
G.jokerstream_last_dollars = nil

G.jokerstream_jokers_activated_this_hand = 0
G.jokerstream_clips_created_this_run = 0
G.jokerstream_last_hand_snapshot = nil

G.jokerstream_hate_raid = { active = false, timer = 0, duration = 10 }
G.jokerstream_hate_raid_cooldown = 45

G.jokerstream_mega_donations_left = 2
G.jokerstream_mega_donation_checked = false
G.jokerstream_mega_timer = 0

G.jokerstream_top_donator_timer = 0
G.jokerstream_last_discards_left = nil
G.jokerstream_last_ante_for_bonus = 0

G.jokerstream_afk_timer = 0
G.jokerstream_afk_notified = false
G.jokerstream_afk_threshold = 240

G.jokerstream_config = G.jokerstream_config or {
    chat_enabled = true, intro_enabled = true, donators_enabled = true,
    karal_donate_enabled = true,
    streamer_donate_enabled = true,
}

if not G.jokerstream_milestones then
    G.jokerstream_milestones = {
        { subs = 100,    id = "m001", name = "First Badge",       desc = "+$1 per donation" },
        { subs = 250,    id = "m002", name = "Small Channel",     desc = "Chat palette" },
        { subs = 500,    id = "m003", name = "Growing Channel",   desc = "+$1 per donation" },
        { subs = 750,    id = "m004", name = "Active Streamer",   desc = "Drag chat" },
        { subs = 1000,   id = "m005", name = "Thousand Club",     desc = "Challenges unlocked" },
        { subs = 1500,   id = "m006", name = "Stable Growth",     desc = "Chat palette" },
        { subs = 2000,   id = "m007", name = "Two Thousands",     desc = "Chat transparency" },
        { subs = 2500,   id = "m008", name = "VIP Status",        desc = "Chat size" },
        { subs = 3000,   id = "m009", name = "Advertiser",        desc = "10% donation cashback" },
        { subs = 4000,   id = "m010", name = "Big Channel",       desc = "15% donation cashback" },
        { subs = 5000,   id = "m011", name = "Five Thousands",    desc = "Chat font" },
        { subs = 7500,   id = "m012", name = "Popular",           desc = "Chat animations" },
        { subs = 10000,  id = "m013", name = "Twitch Partner",    desc = "20% donation cashback" },
        { subs = 15000,  id = "m014", name = "Big Raid chance",   desc = "5% - MrBeast donates $25" },
        { subs = 20000,  id = "m015", name = "Top Streamer",      desc = "Top donator bonus every 2 min" },
        { subs = 30000,  id = "m016", name = "Collab Events",     desc = "1 in 5 - donation x2" },
        { subs = 50000,  id = "m017", name = "Hustler",           desc = "1 in 10 on discard - +$1" },
        { subs = 75000,  id = "m018", name = "Legend",            desc = "1 in 20 - $50 legendary donation" },
        { subs = 100000, id = "m019", name = "Hundred Thousands", desc = "Viewer growth x1.7" },
        { subs = 250000, id = "m020", name = "Partner Forever",   desc = "+$1 per 2000 viewers each ante" },
    }
end

-- AFK hooks
local original_mousemoved_ch = love.mousemoved
function love.mousemoved(x, y, dx, dy, istouch)
    G.jokerstream_afk_timer = 0; G.jokerstream_afk_notified = false
    if original_mousemoved_ch then return original_mousemoved_ch(x, y, dx, dy, istouch) end
end

local original_mousepressed_ch = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
    G.jokerstream_afk_timer = 0; G.jokerstream_afk_notified = false

    local ch = G.jokerstream_channel
    if ch and ch.chat_settings and ch.chat_settings.drag_chat and button == 1 then
        local box = G.jokerstream_chat_box_rect
        if box and x >= box.x and x <= box.x + box.w and y >= box.y and y <= box.y + box.h then
            G.jokerstream_dragging_chat = { last_x = x, last_y = y }
        end
    end

    if original_mousepressed_ch then return original_mousepressed_ch(x, y, button, istouch, presses) end
end

local original_keypressed_ch = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    G.jokerstream_afk_timer = 0; G.jokerstream_afk_notified = false
    if original_keypressed_ch then return original_keypressed_ch(key, scancode, isrepeat) end
end

G.jokerstream_stream_intro = { active = false, timer = 0, duration = 6 }
G.jokerstream_icons = { mod = nil, sub = nil, donate = nil }

local MOD_PATH = "C:/Users/МАКСИМУШКА/AppData/Roaming/Balatro/Mods/Twitch Balatro"

local function load_nfs_image(rel_path)
    if love.filesystem.getInfo and love.filesystem.getInfo(rel_path) then
        local ok, img = pcall(love.graphics.newImage, rel_path)
        if ok and img then return img end
    end
    if NFS then
        local abs_path = MOD_PATH .. "/" .. rel_path
        local ok, bytes = pcall(NFS.read, abs_path)
        if ok and bytes then
            local fd = love.filesystem.newFileData(bytes, "img.png")
            local ok2, img = pcall(love.graphics.newImage, fd)
            if ok2 and img then return img end
        end
    end
    return nil
end

local function jokerstream_load_icons()
    G.jokerstream_icons.mod    = load_nfs_image("assets/icons/mod_icon.png")
    G.jokerstream_icons.sub    = load_nfs_image("assets/icons/sub_icon.png")
    G.jokerstream_icons.donate = load_nfs_image("assets/icons/donate_icon.png")
end

function G.jokerstream_get_level()
    if not G.jokerstream_milestones then return 0 end
    local subs = (G.jokerstream_channel and G.jokerstream_channel.subs) or 0
    local level = 0
    for _, m in ipairs(G.jokerstream_milestones) do
        if subs >= m.subs then level = level + 1 end
    end
    return level
end

function G.jokerstream_get_attribute_multiplier()
    local level = G.jokerstream_get_level()
    local bonus = 0
    for i = 1, level do
        if i <= 10 then bonus = bonus + 0.10
        elseif i <= 15 then bonus = bonus + 0.15
        else bonus = bonus + 0.20 end
    end
    return 1.0 + bonus
end

-- Donation cashback: 9 = 10%, 10 = 15%, 13 = 20%
function G.jokerstream_get_donation_bonus()
    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    if level >= 13 then return 0.20 end
    if level >= 10 then return 0.15 end
    if level >= 9  then return 0.10 end
    return 0
end

local function jokerstream_collab_x2()
    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    if level < 16 then return false end
    return math.random(1, 5) == 1
end

local function jokerstream_donations_enabled()
    local cs = G.jokerstream_channel and G.jokerstream_channel.chat_settings
    if not cs then return true end
    return cs.donations_enabled ~= false
end

local function chat_cfg()
    local cs = G.jokerstream_channel and G.jokerstream_channel.chat_settings or {}
    return {
        drag_chat      = cs.drag_chat or false,
        drag_chat_pos  = cs.drag_chat_pos,
        chat_palette   = cs.chat_palette or 1,
        chat_alpha     = cs.chat_alpha or 1.0,
        chat_font_size = cs.chat_font_size or 18,
        chat_box_width = cs.chat_box_width or 320,
        chat_font      = cs.chat_font or 1,
        chat_anim      = cs.chat_anim or 2,
    }
end
G.jokerstream_chat_cfg = chat_cfg

local function get_font(size, idx)
    if G.jokerstream_get_chat_font then
        return G.jokerstream_get_chat_font(size, idx)
    end
    G.jokerstream_chat_font_cache = G.jokerstream_chat_font_cache or {}
    local key = tostring(size) .. "_" .. tostring(idx or 1)
    if G.jokerstream_chat_font_cache[key] then return G.jokerstream_chat_font_cache[key] end
    local candidates = {
        "resources/fonts/m6x11plus.ttf", "assets/fonts/m6x11plus.ttf",
        "resources/fonts/m6x11.ttf", "assets/fonts/m6x11.ttf",
    }
    for _, p in ipairs(candidates) do
        local ok, f = pcall(love.graphics.newFont, p, size)
        if ok and f and f.getHeight then
            G.jokerstream_chat_font_cache[key] = f
            return f
        end
    end
    local ok, f = pcall(love.graphics.newFont, size)
    if ok and f then G.jokerstream_chat_font_cache[key] = f; return f end
    return nil
end

-- ============================================
-- БАЗОВЫЕ ХЕЛПЕРЫ
-- ============================================
local function jokerstream_get_ante()
    if G.GAME and G.GAME.round_resets then return G.GAME.round_resets.ante or 1 end
    return 1
end

local function jokerstream_get_start_viewers()
    local stake = 1
    if G.GAME and G.GAME.stake then stake = G.GAME.stake end
    local base = {
        [1] = math.random(7, 13), [2] = math.random(15, 25),
        [3] = math.random(30, 50), [4] = math.random(60, 90),
        [5] = math.random(75, 113), [6] = math.random(87, 130),
        [7] = math.random(100, 150), [8] = math.random(130, 190),
    }
    local val = base[stake] or math.random(10, 30)
    return math.floor(val * G.jokerstream_get_attribute_multiplier())
end

local function jokerstream_get_interval_for_ante()
    local ante = jokerstream_get_ante()
    if ante <= 1 then return 4.5 elseif ante <= 3 then return 3.0
    elseif ante <= 5 then return 2.0 elseif ante <= 7 then return 1.5
    else return 0.8 end
end

local function jokerstream_get_viewers_for_ante()
    local ante = jokerstream_get_ante()
    local base
    if ante <= 1 then base = math.random(50, 200)
    elseif ante <= 3 then base = math.random(150, 500)
    elseif ante <= 5 then base = math.random(400, 1500)
    elseif ante <= 7 then base = math.random(1000, 4000)
    else base = math.random(3000, 9999) end
    return math.floor(base * G.jokerstream_get_attribute_multiplier())
end

local function jokerstream_get_donate_interval()
    local ante = jokerstream_get_ante()
    local base
    if ante <= 1 then base = math.random(120, 240)
    elseif ante <= 3 then base = math.random(80, 180)
    elseif ante <= 5 then base = math.random(60, 150)
    elseif ante <= 7 then base = math.random(40, 120)
    else base = math.random(30, 90) end
    return math.max(20, base)
end

local function jokerstream_get_donate_amount()
    local ante = jokerstream_get_ante()
    local base
    if ante <= 1 then base = ({5, 5, 10})[math.random(1, 3)]
    elseif ante <= 3 then base = ({5, 10, 15, 20})[math.random(1, 4)]
    elseif ante <= 5 then base = ({10, 15, 20, 30})[math.random(1, 4)]
    elseif ante <= 7 then base = ({15, 20, 30, 50})[math.random(1, 4)]
    else base = ({20, 30, 50, 75, 100})[math.random(1, 5)] end
    return base
end

local function jokerstream_pick_faction()
    if G.jokerstream_hate_raid.active then return "haters" end
    local roll = math.random(1, 100)
    local ante = jokerstream_get_ante()
    local hater_chance = 15
    if ante <= 2 then hater_chance = 5 elseif ante >= 7 then hater_chance = 35 end
    if roll <= hater_chance then return "haters"
    elseif roll <= hater_chance + 45 then return "neutrals"
    else return "fans" end
end

local function jokerstream_pick_role(faction)
    if faction == "haters" then return "viewer" end
    local roll = math.random(1, 100)
    if roll <= 5 then return "mod"
    elseif roll <= 25 then return "sub"
    elseif roll <= 35 then return "donate"
    else return "viewer" end
end

local function jokerstream_pick_nick(faction)
    local list = G.jokerstream_nicks[faction] or G.jokerstream_nicks.neutrals
    return list[math.random(1, #list)]
end

local function jokerstream_pick_color()
    return G.jokerstream_nick_colors[math.random(1, #G.jokerstream_nick_colors)]
end

local function jokerstream_pick_message(pool)
    local list
    if pool and G.jokerstream_chat_lines[pool] then list = G.jokerstream_chat_lines[pool]
    else list = G.jokerstream_chat_lines.neutrals end
    if #list == 0 then return "" end
    local recent = G.jokerstream_chat_last_msg
    local attempts = 0
    local msg = ""
    repeat
        msg = list[math.random(1, #list)]
        attempts = attempts + 1
        local is_recent = false
        for _, m in ipairs(recent) do
            if m == msg then is_recent = true break end
        end
        if not is_recent then break end
    until attempts >= 10
    table.insert(recent, msg)
    while #recent > 5 do table.remove(recent, 1) end
    return msg
end

-- ============================================
-- BALANCE C: базовый бонус = $1 за донат
-- ============================================
local function jokerstream_grant_donation_money(amount)
    if not G.GAME then return end

    -- Base bonus: $1 per donation
    ease_dollars(1)

    -- Cashback: 10/15/20%
    if amount and amount > 0 then
        local bonus_pct = G.jokerstream_get_donation_bonus and G.jokerstream_get_donation_bonus() or 0
        if bonus_pct > 0 then
            local cashback = math.floor(amount * bonus_pct)
            if cashback > 0 then ease_dollars(cashback) end
        end
    end
end

local function jokerstream_add_donation()
    if not jokerstream_donations_enabled() then return end

    local amount = jokerstream_get_donate_amount()
    local donor_nick = jokerstream_pick_nick("fans")
    local legendary = false

    local level = G.jokerstream_get_level and G.jokerstream_get_level() or 0
    if level >= 18 and math.random(1, 20) == 1 then
        legendary = true
        amount = 50
        donor_nick = "Legend_" .. donor_nick
    end

    local is_collab = false
    if not legendary and jokerstream_collab_x2() then
        amount = amount * 2
        is_collab = true
    end

    if #G.jokerstream_donators > 0 and math.random(1, 100) <= 70 then
        local d = G.jokerstream_donators[math.random(1, #G.jokerstream_donators)]
        d.amount = d.amount + amount
        donor_nick = d.nick
    else
        table.insert(G.jokerstream_donators, {
            nick = donor_nick, amount = amount, color = jokerstream_pick_color(),
        })
        if #G.jokerstream_donators == 1 then G.jokerstream_don_panel_timer = 0 end
        if #G.jokerstream_donators > 12 then
            table.sort(G.jokerstream_donators, function(a, b) return a.amount > b.amount end)
            for i = #G.jokerstream_donators, 13, -1 do table.remove(G.jokerstream_donators, i) end
        end
    end
    G.jokerstream_total_donated = G.jokerstream_total_donated + amount

    local text = "donated $" .. amount .. "!"
    if legendary then text = "LEGENDARY DONATION — $" .. amount .. "!"
    elseif is_collab then text = "[COLLAB x2] donated $" .. amount .. "!" end

    table.insert(G.jokerstream_chat_current, {
        nick = donor_nick, text = text,
        color = legendary and {1.0, 0.5, 0.0} or {1, 0.85, 0.30},
        role = "donate", donation = true, anim = 0,
        rainbow = legendary,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end

    if G.jokerstream_channel and G.jokerstream_channel.add_received then
        G.jokerstream_channel.add_received(amount)
    end

    jokerstream_grant_donation_money(amount)
end

-- ============================================
-- MEGA DONATION — $25
-- ============================================
local function jokerstream_try_mega_donation()
    if not jokerstream_donations_enabled() then return end
    local level = 0
    if G.jokerstream_get_level then level = G.jokerstream_get_level() end
    if level < 14 then return end
    if (G.jokerstream_mega_donations_left or 0) <= 0 then return end
    if math.random(1, 20) ~= 1 then return end

    G.jokerstream_mega_donations_left = G.jokerstream_mega_donations_left - 1

    local amount = 25
    G.jokerstream_total_donated = (G.jokerstream_total_donated or 0) + amount

    table.insert(G.jokerstream_chat_current, {
        nick = "MrBeast",
        text = "MEGA DONATION FROM MRBEAST — $25",
        color = {1.0, 0.75, 0.30},
        role = "donate", donation = true, rainbow = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end

    if G.jokerstream_channel and G.jokerstream_channel.add_received then
        G.jokerstream_channel.add_received(amount)
    end

    if ease_dollars then ease_dollars(amount) end
end

-- ============================================
-- KARAL — $50, 1 раз за ран
-- ============================================
local function jokerstream_karal_donate_trigger()
    if not jokerstream_donations_enabled() then return end
    if G.jokerstream_karal_used_this_run then return end
    G.jokerstream_karal_used_this_run = true

    local amount = 50
    local txt = ({ "good stream", "nice stream", "thanks for playing", "see you next time", "quality stream" })[math.random(1, 5)]

    G.jokerstream_total_donated = G.jokerstream_total_donated + amount

    table.insert(G.jokerstream_donators, {
        nick = "karal", amount = amount, color = {0.75, 0.40, 1.00},
    })
    table.sort(G.jokerstream_donators, function(a, b) return a.amount > b.amount end)
    if #G.jokerstream_donators > 12 then
        for i = #G.jokerstream_donators, 13, -1 do table.remove(G.jokerstream_donators, i) end
    end

    table.insert(G.jokerstream_chat_current, {
        nick = "karal", text = "donated $" .. amount .. ": \"" .. txt .. "\"",
        color = {0.75, 0.40, 1.00}, role = "viewer",
        karal = true, donation = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end

    if G.jokerstream_channel and G.jokerstream_channel.add_received then
        G.jokerstream_channel.add_received(amount)
    end

    jokerstream_grant_donation_money(amount)
end

-- ============================================
-- STREAMER — $2 × ante
-- ============================================
local function jokerstream_streamer_donate()
    if not jokerstream_donations_enabled() then return end
    local s = G.jokerstream_streamer_messages[math.random(1, #G.jokerstream_streamer_messages)]
    local ante = jokerstream_get_ante()
    local amount = 2 * ante
    local txt = G.jokerstream_donate_texts[math.random(1, #G.jokerstream_donate_texts)]

    G.jokerstream_total_donated = G.jokerstream_total_donated + amount

    table.insert(G.jokerstream_chat_current, {
        nick = s.name, text = "donated $" .. amount .. ": \"" .. txt .. "\"",
        color = s.color, role = "viewer",
        streamer = true, donation = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end

    if G.jokerstream_channel and G.jokerstream_channel.add_received then
        G.jokerstream_channel.add_received(amount)
    end

    jokerstream_grant_donation_money(amount)
end

local function jokerstream_check_karal_donate(dt)
    local cfg = G.jokerstream_config or {}
    if cfg.karal_donate_enabled == false then return end
    if not jokerstream_donations_enabled() then return end
    if G.jokerstream_karal_used_this_run then return end

    if G.jokerstream_karal_donate_pending > 0 then
        G.jokerstream_karal_donate_pending = G.jokerstream_karal_donate_pending - dt
        if G.jokerstream_karal_donate_pending <= 0 then
            G.jokerstream_karal_donate_pending = -1
            jokerstream_karal_donate_trigger()
        end
        return
    end

    if G.jokerstream_karal_donate_pending == -1 then
        G.jokerstream_karal_donate_check_timer = G.jokerstream_karal_donate_check_timer + dt
        if G.jokerstream_karal_donate_check_timer >= 60 then
            G.jokerstream_karal_donate_check_timer = 0
            if math.random(1, 1000) == 1 then
                G.jokerstream_karal_donate_pending = math.random(40, 120)
            end
        end
    end
end

local function jokerstream_check_streamer_donate(dt)
    local cfg = G.jokerstream_config or {}
    if cfg.streamer_donate_enabled == false then return end
    if not jokerstream_donations_enabled() then return end

    G.jokerstream_streamer_donate_check_timer = G.jokerstream_streamer_donate_check_timer + dt
    if G.jokerstream_streamer_donate_check_timer >= 120 then
        G.jokerstream_streamer_donate_check_timer = 0
        if math.random(1, 50) == 1 then
            jokerstream_streamer_donate()
        end
    end
end

-- ============================================
-- TOP DONATOR — +$1 за 1000 зрителей (макс +$5)
-- ============================================
local function jokerstream_check_top_donator(dt)
    local level = G.jokerstream_get_level and G.jokerstream_get_level() or 0
    if level < 15 then return end
    if #G.jokerstream_donators == 0 then return end

    G.jokerstream_top_donator_timer = (G.jokerstream_top_donator_timer or 0) + dt
    if G.jokerstream_top_donator_timer < 120 then return end
    G.jokerstream_top_donator_timer = 0

    local top = nil
    for _, d in ipairs(G.jokerstream_donators) do
        if not top or d.amount > top.amount then top = d end
    end
    if not top then return end

    local viewers = G.jokerstream_viewers or 0
    local tip = math.min(5, math.floor(viewers / 1000))
    if tip < 1 then tip = 1 end

    ease_dollars(tip)
    table.insert(G.jokerstream_chat_current, {
        nick = top.nick, text = "top donator tip: +$" .. tip,
        color = {1.0, 0.85, 0.40}, role = "donate", donation = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
end

-- ============================================
-- HUSTLER — 1 из 10 → +$1
-- ============================================
local function jokerstream_check_hustler_discard()
    local level = G.jokerstream_get_level and G.jokerstream_get_level() or 0
    if level < 17 then return end
    if not G.GAME or not G.GAME.current_round then return end

    local dl = G.GAME.current_round.discards_left
    if dl == nil then return end

    if G.jokerstream_last_discards_left and dl < G.jokerstream_last_discards_left then
        if math.random(1, 10) == 1 then
            ease_dollars(1)
        end
    end
    G.jokerstream_last_discards_left = dl
end

-- ============================================
-- PARTNER BONUS — +$1 за 2000 зрителей (макс +$10)
-- ============================================
local function jokerstream_check_partner_bonus()
    local level = G.jokerstream_get_level and G.jokerstream_get_level() or 0
    if level < 20 then return end
    if not G.GAME or not G.GAME.round_resets then return end

    local cur_ante = G.GAME.round_resets.ante or 0
    if cur_ante > (G.jokerstream_last_ante_for_bonus or 0) then
        G.jokerstream_last_ante_for_bonus = cur_ante
        local viewers = G.jokerstream_viewers or 0
        local bonus = math.min(10, math.floor(viewers / 2000))
        if bonus > 0 then
            ease_dollars(bonus)
            table.insert(G.jokerstream_chat_current, {
                nick = "system", text = "Partner bonus: +$" .. bonus,
                color = {1.0, 0.85, 0.40}, role = "viewer", anim = 0,
            })
            while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
                table.remove(G.jokerstream_chat_current, 1)
            end
        end
    end
end

local function jokerstream_pick_status(pool)
    local list = G.jokerstream_status_lines[pool]
    if not list or #list == 0 then return nil end
    return list[math.random(1, #list)]
end

function G.jokerstream_set_status(pool)
    local s = jokerstream_pick_status(pool)
    if s then
        G.jokerstream_status_current = s
        G.jokerstream_last_status_state = pool
        G.jokerstream_status_change_timer = 0
    end
end

local function jokerstream_update_status()
    if not G.GAME then return end
    local state = nil
    if G.STATE == G.STATES.SHOP then state = "shop"
    elseif G.STATE == G.STATES.GAME_OVER then state = "game_over"
    elseif G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SELECTING_HAND then
        if G.GAME.blind then
            if G.GAME.blind.boss then state = "boss"
            else
                local key = G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key
                if key == "bl_small" then state = "small"
                elseif key == "bl_big" then state = "big" end
            end
        end
    end
    if G.jokerstream_afk_notified then state = "afk" end
    if state and state ~= G.jokerstream_last_status_state then
        G.jokerstream_set_status(state)
    end
end

local function jokerstream_push_karal_message()
    local phrase = G.jokerstream_karal_messages[math.random(1, #G.jokerstream_karal_messages)]
    table.insert(G.jokerstream_chat_current, {
        nick = "karal", text = phrase, color = {0.75, 0.40, 1.00},
        role = "viewer", karal = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
end

local function jokerstream_push_clip()
    local phrase = G.jokerstream_clip_lines[math.random(1, #G.jokerstream_clip_lines)]
    table.insert(G.jokerstream_chat_current, {
        nick = jokerstream_pick_nick("fans"), text = phrase,
        color = {0.65, 0.65, 0.65}, role = "viewer", clip = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
    if G.jokerstream_channel and G.jokerstream_channel.add_clip then
        G.jokerstream_channel.add_clip({ title = phrase, kind = "clip", time = os.time() })
    end

    if math.random(1, 3) == 1 then
        local level = 0
        if G.jokerstream_get_level then level = G.jokerstream_get_level() end
        local subs = 20 + math.floor(level * 8)
        if G.jokerstream_channel and G.jokerstream_channel.add_subs then
            G.jokerstream_channel.add_subs(subs)
        end
        table.insert(G.jokerstream_chat_current, {
            nick = "system", text = "+" .. subs .. " subs from clip!",
            color = {0.5, 1.0, 0.7}, role = "viewer", anim = 0,
        })
        while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
            table.remove(G.jokerstream_chat_current, 1)
        end
    end
end

local function jokerstream_push_tech()
    table.insert(G.jokerstream_chat_current, {
        nick = "system", text = G.jokerstream_tech_lines[math.random(1, #G.jokerstream_tech_lines)],
        color = {0.30, 0.90, 0.95}, role = "viewer", tech = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
end

local function jokerstream_push_sub()
    table.insert(G.jokerstream_chat_current, {
        nick = jokerstream_pick_nick("fans"), text = G.jokerstream_sub_lines[math.random(1, #G.jokerstream_sub_lines)],
        color = {0.40, 1.00, 0.55}, role = "sub", sub = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
    if G.jokerstream_channel and G.jokerstream_channel.add_subs then
        G.jokerstream_channel.add_subs(1)
    end
end

local function jokerstream_push_ban()
    local banned = jokerstream_pick_nick("haters")
    table.insert(G.jokerstream_chat_current, {
        nick = "Moderator", text = "banned " .. banned,
        color = {0.40, 0.95, 0.40}, role = "mod", ban = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
end

local function jokerstream_check_blind_trigger()
    if not G.GAME or not G.GAME.blind or not G.GAME.blind.config or not G.GAME.blind.config.blind then return end
    local key = G.GAME.blind.config.blind.key
    if not key or G.jokerstream_last_blind_key == key then return end
    G.jokerstream_last_blind_key = key
    local map = {
        bl_wall = "blind_wall", bl_needle = "blind_needle", bl_psychic = "blind_psychic",
        bl_hook = "blind_hook", bl_water = "blind_water", bl_manacle = "blind_manacle",
        bl_ox = "blind_ox", bl_arm = "blind_arm", bl_club = "blind_club",
        bl_head = "blind_head", bl_goad = "blind_goad", bl_window = "blind_window",
        bl_pillar = "blind_pillar", bl_tooth = "blind_tooth", bl_flint = "blind_flint",
        bl_mark = "blind_mark", bl_fish = "blind_fish", bl_wheel = "blind_wheel",
        bl_house = "blind_house",
    }
    local pool = map[key]
    if not pool then return end
    for _ = 1, math.random(3, 5) do G.jokerstream_chat_push(pool) end
end

local function jokerstream_check_hand_trigger()
    G.jokerstream_jokers_activated_this_hand = 0
    if not G.GAME or not G.GAME.current_round then return end
    local hp = G.GAME.current_round.hands_played or 0
    if hp == G.jokerstream_last_hands_played then return end
    G.jokerstream_last_hands_played = hp
    local hand = G.jokerstream_last_hand_name
    if not hand then return end
    local map = {
        ["High Card"] = "hand_high_card", ["Straight Flush"] = "hand_straight_flush",
        ["Five of a Kind"] = "hand_five_kind", ["Flush House"] = "hand_flush_house",
        ["Flush Five"] = "hand_flush_five",
    }
    local pool = map[hand]
    if not pool then return end
    if hand == "High Card" and math.random(1, 10) > 3 then return end
    local count = (pool ~= "hand_high_card") and math.random(4, 6) or 3
    for _ = 1, count do G.jokerstream_chat_push(pool) end
    if hand == "Straight Flush" or hand == "Five of a Kind"
       or hand == "Flush House" or hand == "Flush Five" then
        if math.random(1, 10) <= 6 then jokerstream_push_clip() end
    end
end

local function jokerstream_check_score_trigger()
    if not G.GAME or not G.GAME.chips then return end
    local chips = G.GAME.chips
    if G.jokerstream_last_chips == nil then G.jokerstream_last_chips = chips; return end
    local delta = chips - G.jokerstream_last_chips
    G.jokerstream_last_chips = chips

    if G.jokerstream_challenge_state then
        G.jokerstream_challenge_state.last_hand_score = delta
    end

    if delta >= 1000000 then
        for _ = 1, 6 do G.jokerstream_chat_push("mega_score") end
        jokerstream_push_clip()
        if G.jokerstream_clips and G.jokerstream_clips_created_this_run < 3 then
            G.jokerstream_clips.create("score_1m", {
                title = "MEGA 1M SCORE", score = delta,
                hand_name = G.jokerstream_last_hand_name or "?",
                hand = G.jokerstream_last_hand_snapshot,
                jokers_activated_count = G.jokerstream_jokers_activated_this_hand or 0,
            })
            G.jokerstream_clips_created_this_run = G.jokerstream_clips_created_this_run + 1
        end
    elseif delta >= 100000 then
        for _ = 1, 5 do G.jokerstream_chat_push("mega_score") end
        jokerstream_push_clip()
        if G.jokerstream_clips and G.jokerstream_clips_created_this_run < 3 then
            G.jokerstream_clips.create("score_100k", {
                title = "100K HAND", score = delta,
                hand_name = G.jokerstream_last_hand_name or "?",
                hand = G.jokerstream_last_hand_snapshot,
                jokers_activated_count = G.jokerstream_jokers_activated_this_hand or 0,
            })
            G.jokerstream_clips_created_this_run = G.jokerstream_clips_created_this_run + 1
        end
    elseif delta >= 10000 then
        for _ = 1, 4 do G.jokerstream_chat_push("big_score") end
        if math.random(1, 10) <= 4 then jokerstream_push_clip() end
        if G.jokerstream_clips and G.jokerstream_clips_created_this_run < 3 then
            G.jokerstream_clips.create("score_10k", {
                title = "10K HAND", score = delta,
                hand_name = G.jokerstream_last_hand_name or "?",
                hand = G.jokerstream_last_hand_snapshot,
                jokers_activated_count = G.jokerstream_jokers_activated_this_hand or 0,
            })
            G.jokerstream_clips_created_this_run = G.jokerstream_clips_created_this_run + 1
        end
    end
end

local function jokerstream_check_money_trigger()
    if not G.GAME or not G.GAME.dollars then return end
    local dollars = G.GAME.dollars
    if G.jokerstream_last_dollars == nil then G.jokerstream_last_dollars = dollars; return end
    if dollars ~= G.jokerstream_last_dollars then
        if dollars == 0 and G.jokerstream_last_dollars > 0 then
            if math.random(1, 3) == 1 then for _ = 1, 2 do G.jokerstream_chat_push("broke") end end
        elseif dollars >= 100 and G.jokerstream_last_dollars < 100 then
            if math.random(1, 3) == 1 then for _ = 1, 2 do G.jokerstream_chat_push("rich") end end
        end
        G.jokerstream_last_dollars = dollars
    end
end

local function jokerstream_check_afk(dt)
    G.jokerstream_afk_timer = G.jokerstream_afk_timer + dt
    if not G.jokerstream_afk_notified and G.jokerstream_afk_timer >= G.jokerstream_afk_threshold then
        G.jokerstream_afk_notified = true
        for _ = 1, 12 do G.jokerstream_chat_push("afk") end
    end
end

local function jokerstream_check_hate_raid(dt)
    if G.jokerstream_hate_raid.active then
        G.jokerstream_hate_raid.timer = G.jokerstream_hate_raid.timer + dt
        if G.jokerstream_hate_raid.timer >= G.jokerstream_hate_raid.duration then
            G.jokerstream_hate_raid.active = false
            G.jokerstream_hate_raid.timer = 0
        end
        return
    end
    G.jokerstream_hate_raid_cooldown = (G.jokerstream_hate_raid_cooldown or 0) - dt
    if G.jokerstream_hate_raid_cooldown > 0 then return end
    if math.random(1, 60) == 1 then
        G.jokerstream_hate_raid.active = true
        G.jokerstream_hate_raid.timer = 0
        G.jokerstream_hate_raid_cooldown = math.random(120, 240)
        if G.jokerstream_sounds and G.jokerstream_sounds.hate_raid then
            G.jokerstream_sounds.hate_raid:clone():play()
        end
        for _ = 1, 8 do G.jokerstream_chat_push("hate_raid") end
    else
        G.jokerstream_hate_raid_cooldown = 30
    end
end

local function jokerstream_check_tech_event(dt)
    G.jokerstream_tech_timer = G.jokerstream_tech_timer + dt
    if G.jokerstream_tech_timer >= G.jokerstream_tech_interval then
        G.jokerstream_tech_timer = 0
        G.jokerstream_tech_interval = math.random(300, 600)
        if math.random(1, 100) <= 60 then
            for _ = 1, math.random(2, 4) do jokerstream_push_tech() end
        end
    end
end

local function jokerstream_check_ban_event(dt)
    G.jokerstream_ban_timer = G.jokerstream_ban_timer + dt
    if G.jokerstream_ban_timer >= G.jokerstream_ban_interval then
        G.jokerstream_ban_timer = 0
        G.jokerstream_ban_interval = math.random(300, 600)
        if math.random(1, 100) <= 40 then
            for _ = 1, math.random(3, 5) do jokerstream_push_ban() end
        end
    end
end

local function jokerstream_check_sub_event(dt)
    G.jokerstream_sub_timer = G.jokerstream_sub_timer + dt
    if G.jokerstream_sub_timer >= G.jokerstream_sub_interval then
        G.jokerstream_sub_timer = 0
        G.jokerstream_sub_interval = math.random(300, 600)
        if math.random(1, 100) <= 50 then
            for _ = 1, math.random(3, 5) do jokerstream_push_sub() end
        end
    end
end

local function jokerstream_queue_message(msg_data, delay)
    table.insert(G.jokerstream_queue, { msg = msg_data, timer = delay or 3 })
end

local function jokerstream_maybe_argue(prev_faction)
    if G.jokerstream_hate_raid.active then return end
    if prev_faction ~= "fans" and prev_faction ~= "haters" then return end
    if math.random(1, 6) ~= 1 then return end
    local rf, pool
    if prev_faction == "fans" then
        rf = "haters"; pool = G.jokerstream_argument_lines.hater_reply_to_fan
    else
        rf = "fans"; pool = G.jokerstream_argument_lines.fan_reply_to_hater
    end
    local line = pool[math.random(1, #pool)]
    jokerstream_queue_message({
        nick = jokerstream_pick_nick(rf), text = line,
        color = jokerstream_pick_color(), role = jokerstream_pick_role(rf), anim = 0,
    }, 3)
    if math.random(1, 4) == 1 then
        local stir = G.jokerstream_argument_lines.neutral_stir[math.random(1, #G.jokerstream_argument_lines.neutral_stir)]
        jokerstream_queue_message({
            nick = jokerstream_pick_nick("neutrals"), text = stir,
            color = jokerstream_pick_color(), role = jokerstream_pick_role("neutrals"), anim = 0,
        }, 6)
    end
end

function G.jokerstream_chat_init()
    G.jokerstream_chat_current = {}
    G.jokerstream_queue = {}
    G.jokerstream_jokers_activated_this_hand = 0
    G.jokerstream_clips_created_this_run = 0
    G.jokerstream_last_hand_snapshot = nil

    for _ = 1, 4 do
        local f = jokerstream_pick_faction()
        table.insert(G.jokerstream_chat_current, {
            nick = jokerstream_pick_nick(f), text = jokerstream_pick_message(f),
            color = jokerstream_pick_color(), role = jokerstream_pick_role(f), anim = 1,
        })
    end
    G.jokerstream_viewers = jokerstream_get_start_viewers()
    G.jokerstream_stream_time = 0
    G.jokerstream_last_blind_key = nil
    G.jokerstream_last_hand_name = nil
    G.jokerstream_last_hands_played = 0
    G.jokerstream_last_chips = nil
    G.jokerstream_last_dollars = nil
    G.jokerstream_hate_raid.active = false
    G.jokerstream_hate_raid.timer = 0
    G.jokerstream_hate_raid_cooldown = math.random(120, 240)
    G.jokerstream_mega_donations_left = 2
    G.jokerstream_mega_donation_checked = false
    G.jokerstream_mega_timer = 0
    G.jokerstream_karal_used_this_run = false
    G.jokerstream_karal_donate_pending = -1
    G.jokerstream_karal_donate_check_timer = 0
    G.jokerstream_top_donator_timer = 0
    G.jokerstream_last_discards_left = nil
    G.jokerstream_last_ante_for_bonus = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    G.jokerstream_afk_timer = 0
    G.jokerstream_afk_notified = false
    G.jokerstream_last_status_state = nil
    G.jokerstream_status_change_timer = 999
    G.jokerstream_streamer_timer = 0
    G.jokerstream_streamer_interval = math.random(500, 800)
    G.jokerstream_karal_timer = 0
    G.jokerstream_karal_interval = math.random(600, 900)
    G.jokerstream_tech_timer = 0
    G.jokerstream_tech_interval = math.random(300, 500)
    G.jokerstream_ban_timer = 0
    G.jokerstream_ban_interval = math.random(300, 500)
    G.jokerstream_sub_timer = 0
    G.jokerstream_sub_interval = math.random(300, 500)
    G.jokerstream_donators = {}
    G.jokerstream_donator_timer = 0
    G.jokerstream_donator_interval = jokerstream_get_donate_interval()
    G.jokerstream_total_donated = 0
    G.jokerstream_don_panel_timer = 999
    G.jokerstream_last_faction = nil
    G.jokerstream_streamer_donate_check_timer = 0
    G.jokerstream_set_status("small")

    if G.jokerstream_challenge_on_run_start then
        G.jokerstream_challenge_on_run_start()
    end
end

function G.jokerstream_start_stream_intro()
    G.jokerstream_stream_intro.active = true
    G.jokerstream_stream_intro.timer = 0
    for _ = 1, 2 do G.jokerstream_chat_push() end
end

function G.jokerstream_push_streamer_message()
    local s = G.jokerstream_streamer_messages[math.random(1, #G.jokerstream_streamer_messages)]
    local phrase = s.phrases[math.random(1, #s.phrases)]
    table.insert(G.jokerstream_chat_current, {
        nick = s.name, text = phrase, color = s.color,
        role = "viewer", streamer = true, anim = 0,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
end

function G.jokerstream_chat_push(pool)
    local f = jokerstream_pick_faction()
    local msg = jokerstream_pick_message(pool or f)
    if msg == "" then return end
    table.insert(G.jokerstream_chat_current, {
        nick = jokerstream_pick_nick(f), text = msg,
        color = jokerstream_pick_color(), role = jokerstream_pick_role(f),
        anim = 0, faction = f,
    })
    while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
        table.remove(G.jokerstream_chat_current, 1)
    end
    if not pool then jokerstream_maybe_argue(f) end
    if G.jokerstream_hate_raid and G.jokerstream_hate_raid.active then
        if math.random(1, 4) == 1 then pcall(play_sound, 'button') end
    end
end

function G.jokerstream_chat_update(dt)
    if G.jokerstream_registration and G.jokerstream_registration.active then
        return
    end

    local cfg = G.jokerstream_config or {}

    if G.STATE == G.STATES.MENU then
        G.jokerstream_run_started = false
        G.jokerstream_run_ended = false
    end

    if not G.jokerstream_run_started then
        if G.STATE and (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SELECTING_HAND) then
            G.jokerstream_run_started = true
            jokerstream_load_icons()
            G.jokerstream_chat_init()
            if cfg.intro_enabled ~= false then
                G.jokerstream_start_stream_intro()
            end
        end
    end

    if G.jokerstream_stream_intro.active then
        if cfg.intro_enabled == false then
            G.jokerstream_stream_intro.active = false
        else
            G.jokerstream_stream_intro.timer = G.jokerstream_stream_intro.timer + dt
            if G.jokerstream_stream_intro.timer >= G.jokerstream_stream_intro.duration then
                G.jokerstream_stream_intro.active = false
            end
        end
    end

    G.jokerstream_status_change_timer = (G.jokerstream_status_change_timer or 999) + dt
    G.jokerstream_don_panel_timer = (G.jokerstream_don_panel_timer or 999) + dt

    for _, msg in ipairs(G.jokerstream_chat_current) do
        if msg.anim and msg.anim < 1 then
            msg.anim = math.min(msg.anim + dt * 5, 1)
        end
    end

    for i = #G.jokerstream_queue, 1, -1 do
        local q = G.jokerstream_queue[i]
        q.timer = q.timer - dt
        if q.timer <= 0 then
            table.insert(G.jokerstream_chat_current, q.msg)
            while #G.jokerstream_chat_current > G.jokerstream_chat_visible do
                table.remove(G.jokerstream_chat_current, 1)
            end
            table.remove(G.jokerstream_queue, i)
        end
    end

    if G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH then
        G.jokerstream_mega_timer = (G.jokerstream_mega_timer or 0) + dt
        if G.jokerstream_mega_timer >= 30 then
            G.jokerstream_mega_timer = 0
            jokerstream_try_mega_donation()
        end
    end

    if G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH then
        jokerstream_check_top_donator(dt)
    end

    jokerstream_check_hustler_discard()
    jokerstream_check_partner_bonus()

    if G.STATE == G.STATES.GAME_OVER and not G.jokerstream_run_ended then
        G.jokerstream_run_ended = true
        G.jokerstream_chat_last_msg = {}
        for _ = 1, 8 do G.jokerstream_chat_push("run_lost") end
    end
    if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante >= 8
       and G.GAME.blind and G.GAME.blind.boss
       and G.GAME.current_round and G.GAME.current_round.hands_left == 0
       and not G.jokerstream_run_ended then
        if G.GAME.chips and G.GAME.blind.chips and G.GAME.chips >= G.GAME.blind.chips then
            G.jokerstream_run_ended = true
            G.jokerstream_chat_last_msg = {}
            for _ = 1, 8 do G.jokerstream_chat_push("run_won") end
            jokerstream_push_clip()
            if G.jokerstream_clips and G.jokerstream_clips_created_this_run < 3 then
                G.jokerstream_clips.create("victory", {
                    title = "RUN VICTORY", score = G.GAME.chips or 0,
                    hand_name = "Victory", hand = nil, jokers_activated_count = 0,
                })
                G.jokerstream_clips_created_this_run = G.jokerstream_clips_created_this_run + 1
            end
        end
    end

    if G.STATE and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.SPLASH then
        local interval = jokerstream_get_interval_for_ante()
        if G.jokerstream_hate_raid.active then interval = 0.4 end
        G.jokerstream_chat_timer = G.jokerstream_chat_timer + dt
        G.jokerstream_stream_time = G.jokerstream_stream_time + dt

        if G.jokerstream_chat_timer >= interval then
            G.jokerstream_chat_timer = 0
            if cfg.chat_enabled ~= false then G.jokerstream_chat_push() end
        end

        if cfg.chat_enabled ~= false then
            G.jokerstream_streamer_timer = G.jokerstream_streamer_timer + dt
            if G.jokerstream_streamer_timer >= G.jokerstream_streamer_interval then
                G.jokerstream_streamer_timer = 0
                G.jokerstream_streamer_interval = math.random(500, 800)
                G.jokerstream_push_streamer_message()
            end

            G.jokerstream_karal_timer = G.jokerstream_karal_timer + dt
            if G.jokerstream_karal_timer >= G.jokerstream_karal_interval then
                G.jokerstream_karal_timer = 0
                G.jokerstream_karal_interval = math.random(600, 900)
                jokerstream_push_karal_message()
            end

            jokerstream_check_tech_event(dt)
            jokerstream_check_ban_event(dt)
            jokerstream_check_sub_event(dt)
            jokerstream_check_karal_donate(dt)
            jokerstream_check_streamer_donate(dt)
        end

        if cfg.donators_enabled ~= false and jokerstream_donations_enabled() then
            G.jokerstream_donator_timer = G.jokerstream_donator_timer + dt
            if G.jokerstream_donator_timer >= G.jokerstream_donator_interval then
                G.jokerstream_donator_timer = 0
                G.jokerstream_donator_interval = jokerstream_get_donate_interval()
                jokerstream_add_donation()
            end
        end

        G.jokerstream_viewers_timer = G.jokerstream_viewers_timer + dt
        if G.jokerstream_viewers_timer >= 3 then
            G.jokerstream_viewers_timer = 0
            local target = jokerstream_get_viewers_for_ante()
            local diff = target - G.jokerstream_viewers
            local gain = math.floor(diff * 0.3)
            local level = G.jokerstream_get_level and G.jokerstream_get_level() or 0
            if level >= 19 then gain = math.floor(gain * 1.7) end
            G.jokerstream_viewers = G.jokerstream_viewers + gain
            if G.jokerstream_viewers < 5 then G.jokerstream_viewers = 5 end
        end

        if cfg.chat_enabled ~= false then
            jokerstream_check_blind_trigger()
            jokerstream_check_hand_trigger()
            jokerstream_check_score_trigger()
            jokerstream_check_money_trigger()
            jokerstream_check_afk(dt)
            jokerstream_check_hate_raid(dt)
            jokerstream_update_status()
        end
    end

    G.jokerstream_last_state = G.STATE
end

local original_calculate_joker_chat = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = original_calculate_joker_chat(self, context)

    if context and context.joker_main and context.scoring_name then
        G.jokerstream_last_hand_name = context.scoring_name
        G.jokerstream_last_hand_snapshot = {
            hand_name = context.scoring_name,
            cards = context.scoring_hand or {},
        }
        if G.jokerstream_challenge_state then
            G.jokerstream_challenge_state.last_hand_name = context.scoring_name
        end
    end

    if context and context.joker_main and ret and not self.debuff then
        G.jokerstream_jokers_activated_this_hand = (G.jokerstream_jokers_activated_this_hand or 0) + 1
    end

    return ret
end

-- ============================================
-- DRAW
-- ============================================
function G.jokerstream_chat_draw()
    if G.jokerstream_registration and G.jokerstream_registration.active then return end

    local cfg = G.jokerstream_config or {}
    local cs = chat_cfg()

    if G.jokerstream_stream_intro.active and cfg.intro_enabled ~= false then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        local t = G.jokerstream_stream_intro.timer
        local alpha = 0.75
        if t > 4.5 then alpha = 0.75 * (1 - (t - 4.5) / 1.5) end
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.rectangle("fill", 0, 0, w, h)
        local bw, bh = 520, 280
        local bx, by = w / 2 - bw / 2, h / 2 - bh / 2
        love.graphics.setColor(0.1, 0.1, 0.15, 1)
        love.graphics.rectangle("fill", bx, by, bw, bh, 12)
        love.graphics.setColor(0.55, 0.3, 0.9, 1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", bx, by, bw, bh, 12)
        love.graphics.setLineWidth(1)
        local font = get_font(20, cs.chat_font)
        if font then love.graphics.setFont(font) end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("STREAM STARTING", bx + 150, by + 30)
        local lines = {
            { "Checking connection...", 0.8 },
            { "Audio: OK",              1.6 },
            { "Ping: " .. math.random(15, 50) .. " ms", 2.4 },
            { "Stream is live!",        3.2 },
        }
        love.graphics.setColor(0.9, 0.9, 0.9, 1)
        for _, line in ipairs(lines) do
            if t >= line[2] then love.graphics.print(line[1], bx + 40, by + 90 + (line[2] * 30)) end
        end
    end

    if not G.STATE or G.STATE == G.STATES.MENU or G.STATE == G.STATES.SPLASH then
        G.jokerstream_chat_box_rect = nil
        return
    end
    if cfg.chat_enabled == false then
        G.jokerstream_chat_box_rect = nil
        return
    end

    if G.jokerstream_hate_raid.active then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        local pulse = 0.15 + math.abs(math.sin(love.timer.getTime() * 4)) * 0.15
        love.graphics.setColor(0.8, 0, 0, pulse)
        love.graphics.rectangle("fill", 0, 0, w, h)
    end

    local msg_count = #G.jokerstream_chat_current
    if msg_count <= 0 then
        G.jokerstream_chat_box_rect = nil
        return
    end

    local screen_w, screen_h = love.graphics.getWidth(), love.graphics.getHeight()
    local base_size = cs.chat_font_size
    local small_size = math.max(10, base_size - 5)

    local chat_font   = get_font(base_size,  cs.chat_font)
    local small_font  = get_font(small_size, cs.chat_font)
    local status_font = get_font(base_size,  cs.chat_font)

    local box_w = cs.chat_box_width
    local line_h = base_size + 6
    local chat_alpha = cs.chat_alpha
    local anim_mode = cs.chat_anim

    local chat_pal = (G.jokerstream_get_chat_palette and G.jokerstream_get_chat_palette()) or
                     { bg = {0.05, 0.03, 0.08}, accent = {0.55, 0.30, 0.9}, title = {0.75, 0.5, 1.0} }

    local msg_layout = {}
    local total_msgs_h = 0
    local max_text_w = box_w - 30

    for _, msg in ipairs(G.jokerstream_chat_current) do
        if msg.text and msg.text ~= "" then
            local nick_text = msg.nick .. ": "
            local entry = { msg = msg, font = chat_font, lines = 1 }
            if chat_font then
                local n20 = chat_font:getWidth(nick_text)
                local t20 = chat_font:getWidth(msg.text)
                if n20 + t20 <= max_text_w then
                    entry.font = chat_font; entry.lines = 1
                else
                    local n15 = small_font and small_font:getWidth(nick_text) or n20
                    local t15 = small_font and small_font:getWidth(msg.text) or t20
                    if n15 + t15 <= max_text_w then
                        entry.font = small_font; entry.lines = 1
                    else
                        entry.font = small_font
                        local _, wrapped = small_font:getWrap(msg.text, max_text_w)
                        entry.lines = 1 + math.max(1, #wrapped)
                        entry.wrap = true
                    end
                end
            end
            entry.y = total_msgs_h
            entry.height = line_h * entry.lines
            total_msgs_h = total_msgs_h + entry.height
            table.insert(msg_layout, entry)
        end
    end

    local chat_h = total_msgs_h + 16
    local status_text = G.jokerstream_status_current or ""
    local status_lines = 1

    if status_font then
        local _, wrapped = status_font:getWrap(status_text, box_w - 16)
        status_lines = #wrapped
        if status_lines > 2 then
            status_font = get_font(math.max(10, base_size - 4), cs.chat_font)
            if status_font then
                _, wrapped = status_font:getWrap(status_text, box_w - 16)
                status_lines = math.min(#wrapped, 2)
            end
        end
    end

    local live_h = 30
    local status_line_h = status_font and status_font:getHeight() + 2 or 22
    local status_h = live_h + 4 + math.max(1, status_lines) * status_line_h + 6
    local box_h = chat_h + status_h

    local box_x = screen_w - box_w
    local box_y = screen_h / 2 - box_h / 2

    if cs.drag_chat_pos then
        box_x = box_x + cs.drag_chat_pos.x
        box_y = box_y + cs.drag_chat_pos.y
    end

    if G.jokerstream_hate_raid.active then
        box_x = box_x + math.random(-5, 5)
        box_y = box_y + math.random(-5, 5)
    end

    G.jokerstream_chat_box_rect = { x = box_x, y = box_y, w = box_w, h = box_h }

    local bg = chat_pal.bg or {0, 0, 0}
    if G.jokerstream_hate_raid.active then
        love.graphics.setColor(0.3, 0, 0, 0.7 * chat_alpha)
    else
        love.graphics.setColor(bg[1], bg[2], bg[3], 0.75 * chat_alpha)
    end
    love.graphics.rectangle("fill", box_x, box_y, box_w, chat_h, 6)

    local acc = chat_pal.accent or {0.5, 0.3, 0.9}
    love.graphics.setColor(acc[1], acc[2], acc[3], 0.35 * chat_alpha)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", box_x, box_y, box_w, chat_h, 6)
    love.graphics.setLineWidth(1)

    for _, entry in ipairs(msg_layout) do
        local msg = entry.msg
        local base_y = box_y + 10 + entry.y
        local text_offset = 10
        local anim = msg.anim or 1

        local eased = 1 - math.pow(1 - anim, 3)
        local alpha_mul = eased
        local off_x, off_y = 0, 0
        local scale_x, scale_y = 1.0, 1.0

        if anim_mode == 10 then alpha_mul = 1
        elseif anim_mode == 1 then alpha_mul = anim
        elseif anim_mode == 2 then
            if msg.donation then off_y = (1 - eased) * 30
            else off_x = (1 - eased) * 60 end
        elseif anim_mode == 3 then
            if msg.donation then off_y = (1 - eased) * 30
            else off_x = -(1 - eased) * 60 end
        elseif anim_mode == 4 then
            local s = 0.3 + eased * 0.7
            scale_x, scale_y = s, s; alpha_mul = eased
        elseif anim_mode == 5 then
            local s = 1.4 - eased * 0.4
            scale_x, scale_y = s, s; alpha_mul = eased
        elseif anim_mode == 6 then
            local c1 = 1.70158; local c3 = c1 + 1
            local tt = anim - 1
            local e = 1 + c3 * math.pow(tt, 3) + c1 * math.pow(tt, 2)
            off_x = (1 - e) * 80; alpha_mul = math.min(1, anim * 2)
        elseif anim_mode == 7 then off_y = -(1 - eased) * 40; alpha_mul = eased
        elseif anim_mode == 8 then
            off_x = math.sin(anim * 30) * (1 - anim) * 6
            alpha_mul = (anim > 0.5 or math.random() > 0.4) and 1 or 0.5
        elseif anim_mode == 9 then
            off_y = math.sin(anim * math.pi * 3) * (1 - anim) * 12
            alpha_mul = eased
        end

        local y = base_y
        love.graphics.push()
        if off_x ~= 0 or off_y ~= 0 then love.graphics.translate(off_x, off_y) end
        if scale_x ~= 1.0 or scale_y ~= 1.0 then
            local ccx = box_x + box_w / 2
            local ccy = base_y + entry.height / 2
            love.graphics.translate(ccx, ccy)
            love.graphics.scale(scale_x, scale_y)
            love.graphics.translate(-ccx, -ccy)
        end

        if msg.donation then
            love.graphics.setColor(1, 0.85, 0.3, 0.18 * alpha_mul * chat_alpha)
            love.graphics.rectangle("fill", box_x + 2, y - 2, box_w - 4, entry.height - 2, 3)
        end
        if msg.tech then
            love.graphics.setColor(0.30, 0.90, 0.95, 0.18 * alpha_mul * chat_alpha)
            love.graphics.rectangle("fill", box_x + 2, y - 2, box_w - 4, entry.height - 2, 3)
        end
        if msg.sub then
            love.graphics.setColor(0.40, 1.00, 0.55, 0.20 * alpha_mul * chat_alpha)
            love.graphics.rectangle("fill", box_x + 2, y - 2, box_w - 4, entry.height - 2, 3)
        end
        if msg.clip then
            love.graphics.setColor(0.7, 0.7, 0.7, 0.12 * alpha_mul * chat_alpha)
            love.graphics.rectangle("fill", box_x + 2, y - 2, box_w - 4, entry.height - 2, 3)
        end
        if msg.ban then
            love.graphics.setColor(0.3, 0.3, 0.3, 0.20 * alpha_mul * chat_alpha)
            love.graphics.rectangle("fill", box_x + 2, y - 2, box_w - 4, entry.height - 2, 3)
        end

        if msg.streamer then
            love.graphics.setColor(msg.color[1], msg.color[2], msg.color[3], 0.75 * alpha_mul * chat_alpha)
            love.graphics.setLineWidth(1.5)
            love.graphics.rectangle("line", box_x + 3, y - 1, box_w - 6, entry.height - 2, 3)
            love.graphics.setLineWidth(1)
        end
        if msg.karal then
            love.graphics.setColor(0.75, 0.40, 1.00, 0.9 * alpha_mul * chat_alpha)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", box_x + 3, y - 1, box_w - 6, entry.height - 2, 3)
            love.graphics.setLineWidth(1)
        end

        local icon = G.jokerstream_icons[msg.role]
        if icon then
            love.graphics.setColor(1, 1, 1, alpha_mul * chat_alpha)
            love.graphics.draw(icon, box_x + text_offset, y + 4, 0, 0.9, 0.9)
            text_offset = text_offset + 20
        end

        if entry.font then love.graphics.setFont(entry.font) end
        local nick_text = msg.nick .. ": "
        local nick_w = entry.font and entry.font:getWidth(nick_text) or 0

        if G.jokerstream_hate_raid.active and not msg.streamer and not msg.donation and not msg.karal and not msg.clip and not msg.tech and not msg.sub then
            local flash = 0.5 + math.abs(math.sin(love.timer.getTime() * 8)) * 0.5
            love.graphics.setColor(1, 0.2, 0.2, flash * alpha_mul * chat_alpha)
        else
            love.graphics.setColor(msg.color[1], msg.color[2], msg.color[3], alpha_mul * chat_alpha)
        end
        love.graphics.print(nick_text, box_x + text_offset, y)

        if msg.ban then
            love.graphics.setColor(0.9, 0.3, 0.3, alpha_mul * chat_alpha)
            love.graphics.setLineWidth(2)
            local sy = y + (entry.font and entry.font:getHeight() / 2 or 10)
            love.graphics.line(box_x + text_offset, sy, box_x + text_offset + nick_w, sy)
            love.graphics.setLineWidth(1)
        end

        if msg.rainbow then
            local t = love.timer.getTime()
            local r = 0.5 + 0.5 * math.sin(t * 3)
            local g = 0.5 + 0.5 * math.sin(t * 3 + 2)
            local b = 0.5 + 0.5 * math.sin(t * 3 + 4)
            love.graphics.setColor(r, g, b, alpha_mul * chat_alpha)
        elseif msg.donation then love.graphics.setColor(1, 0.95, 0.6, alpha_mul * chat_alpha)
        elseif msg.clip then love.graphics.setColor(0.75, 0.75, 0.75, alpha_mul * chat_alpha)
        elseif msg.karal then love.graphics.setColor(0.95, 0.85, 1.0, alpha_mul * chat_alpha)
        elseif msg.tech then love.graphics.setColor(0.55, 0.95, 1.0, alpha_mul * chat_alpha)
        elseif msg.sub then love.graphics.setColor(0.6, 1.0, 0.7, alpha_mul * chat_alpha)
        else love.graphics.setColor(1, 1, 1, 0.95 * alpha_mul * chat_alpha) end

        if entry.wrap then
            love.graphics.printf(msg.text, box_x + text_offset, y + line_h - 4, max_text_w, "left")
        else
            love.graphics.print(msg.text, box_x + text_offset + nick_w, y)
        end

        love.graphics.pop()
    end

    local bottom_y = box_y + chat_h
    local t = love.timer.getTime()
    local shimmer = (math.sin(t * 1.5) + 1) / 2
    local sr = (0.90 + 0.10 * shimmer) * 0.7
    local sg = (0.15 + 0.55 * shimmer) * 0.7
    local sb = 0.05 * 0.7

    local block_h = live_h + (status_h - live_h)
    local block_radius = 12

    love.graphics.stencil(function()
        love.graphics.rectangle("fill", box_x, bottom_y, box_w, block_h, block_radius)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(0.45, 0.10, 0.10, 0.95 * chat_alpha)
    love.graphics.rectangle("fill", box_x, bottom_y, box_w, live_h)
    local status_y = bottom_y + live_h
    love.graphics.setColor(sr, sg, sb, 0.95 * chat_alpha)
    love.graphics.rectangle("fill", box_x, status_y, box_w, status_h - live_h)
    love.graphics.setStencilTest()

    local live_y = bottom_y + 6
    local blink = (math.floor(t) % 2 == 0) and 1.0 or 0.4
    love.graphics.setColor(1, 0.25, 0.25, blink * chat_alpha)
    love.graphics.circle("fill", box_x + 14, live_y + 9, 6)
    love.graphics.setColor(1, 1, 1, chat_alpha)
    if chat_font then love.graphics.setFont(chat_font) end
    love.graphics.print("LIVE", box_x + 26, live_y + 1)
    local total_sec = math.floor(G.jokerstream_stream_time or 0)
    local mins = math.floor(total_sec / 60)
    local secs = math.floor(total_sec % 60)
    love.graphics.print(string.format("%02d:%02d", mins, secs), box_x + 110, live_y + 1)
    love.graphics.print("|  " .. G.jokerstream_viewers, box_x + 220, live_y + 1)

    local anim_t = G.jokerstream_status_change_timer or 999
    local anim_p = math.min(anim_t / 0.4, 1.0)
    local eased = 1 - math.pow(1 - anim_p, 3)
    local slide = (1 - eased) * 12
    local alp = eased

    love.graphics.setScissor(box_x, status_y, box_w, status_h - live_h)
    love.graphics.push()
    love.graphics.translate(0, slide)
    if status_font then love.graphics.setFont(status_font) end
    love.graphics.setColor(1, 1, 1, 0.95 * alp * chat_alpha)
    love.graphics.printf(status_text, box_x + 8, status_y + 5, box_w - 16, "center")
    love.graphics.pop()
    love.graphics.setScissor()

    if cfg.donators_enabled ~= false and #G.jokerstream_donators > 0 then
        local don_w = 175
        local don_row_h = 22
        local don_header_h = 28
        local sorted = {}
        for _, d in ipairs(G.jokerstream_donators) do table.insert(sorted, d) end
        table.sort(sorted, function(a, b) return a.amount > b.amount end)
        local shown = math.min(5, #sorted)
        local don_h = don_header_h + shown * don_row_h + 8
        local don_x = screen_w - don_w
        local don_y_final = screen_h - don_h
        local RC = 10
        local panel_anim = math.min((G.jokerstream_don_panel_timer or 999) / 0.6, 1.0)
        local panel_eased = 1 - math.pow(1 - panel_anim, 3)
        local don_y = don_y_final + (1 - panel_eased) * (don_h + 20)

        love.graphics.setColor(0.08, 0.08, 0.12, 0.35 * panel_eased * chat_alpha)
        love.graphics.rectangle("fill", don_x, don_y, don_w, don_h, RC, RC, 8)
        love.graphics.rectangle("fill", don_x + don_w - RC, don_y, RC, RC)
        love.graphics.rectangle("fill", don_x + don_w - RC, don_y + don_h - RC, RC, RC)
        love.graphics.rectangle("fill", don_x, don_y + don_h - RC, RC, RC)

        love.graphics.setColor(1, 0.75, 0.30, 0.9 * panel_eased * chat_alpha)
        love.graphics.setLineWidth(2)
        love.graphics.line(don_x + RC, don_y, don_x + don_w, don_y)
        love.graphics.line(don_x, don_y + RC, don_x, don_y + don_h)
        love.graphics.arc("line", "open", don_x + RC, don_y + RC, RC, math.pi, math.pi * 1.5)
        love.graphics.setLineWidth(1)

        local don_font = get_font(14, cs.chat_font)
        if don_font then love.graphics.setFont(don_font) end
        love.graphics.setColor(1, 0.85, 0.30, panel_eased * chat_alpha)
        love.graphics.print("DONATORS", don_x + 10, don_y + 7)
        love.graphics.setColor(1, 0.95, 0.5, panel_eased * chat_alpha)
        love.graphics.printf("$" .. G.jokerstream_total_donated, don_x + 10, don_y + 7, don_w - 20, "right")
        love.graphics.setColor(1, 0.75, 0.30, 0.4 * panel_eased * chat_alpha)
        love.graphics.rectangle("fill", don_x + 6, don_y + don_header_h - 3, don_w - 12, 1)

        local dt_draw = love.timer.getDelta()
        local speed = math.min(dt_draw * 6, 1)
        local draw_list = {}
        for i, d in ipairs(sorted) do
            if i <= shown then
                local target_y = (i - 1) * don_row_h
                if d.display_y == nil then d.display_y = target_y end
                d.display_y = d.display_y + (target_y - d.display_y) * speed
                table.insert(draw_list, { d = d, rank = i, y = d.display_y })
            end
        end
        table.sort(draw_list, function(a, b) return a.y < b.y end)

        for _, item in ipairs(draw_list) do
            local d = item.d
            local i = item.rank
            local row_y = don_y + don_header_h + item.y
            local rc
            if i == 1 then rc = {1, 0.85, 0.30}
            elseif i == 2 then rc = {0.85, 0.85, 0.90}
            elseif i == 3 then rc = {0.90, 0.60, 0.30}
            else rc = {0.60, 0.60, 0.60} end
            love.graphics.setColor(rc[1], rc[2], rc[3], panel_eased * chat_alpha)
            love.graphics.print("#" .. i, don_x + 10, row_y)
            local nt = d.nick
            if #nt > 11 then nt = nt:sub(1, 11) .. ".." end
            love.graphics.setColor(d.color[1], d.color[2], d.color[3], panel_eased * chat_alpha)
            love.graphics.print(nt, don_x + 30, row_y)
            love.graphics.setColor(1, 0.85, 0.30, panel_eased * chat_alpha)
            love.graphics.printf("$" .. d.amount, don_x + 30, row_y, don_w - 40, "right")
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- ============================================
-- F2 — FORCE MEGA DONATION ($25)
-- ============================================
local original_keypressed_mega = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if key == "f2" then
        local amount = 25
        G.jokerstream_total_donated = (G.jokerstream_total_donated or 0) + amount

        table.insert(G.jokerstream_chat_current, {
            nick = "MrBeast",
            text = "MEGA DONATION FROM MRBEAST — $25",
            color = {1.0, 0.75, 0.30},
            role = "donate", donation = true, rainbow = true, anim = 0,
        })
        while #G.jokerstream_chat_current > (G.jokerstream_chat_visible or 16) do
            table.remove(G.jokerstream_chat_current, 1)
        end

        if G.jokerstream_channel and G.jokerstream_channel.add_received then
            G.jokerstream_channel.add_received(amount)
        end

        if ease_dollars then ease_dollars(amount) end
        return
    end
    if original_keypressed_mega then
        return original_keypressed_mega(key, scancode, isrepeat)
    end
end