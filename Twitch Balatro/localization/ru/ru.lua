return {
    descriptions = {
        Joker = {
            j_jokerstream_apple = {
                name = "Национальный продукт \"Яблоко\"",
                text = {
                    "Даёт {C:chips}+#1#{} Фишек",
                    "при игре руки",
                    "{C:inactive}(+1 в конце раунда, навсегда)"
                }
            },
            j_jokerstream_banana = {
                name = "Утренний банан",
                text = {
                    "Даёт {C:mult}+#1#{} Множителя",
                    "при игре руки",
                    "{C:inactive}(+1 в конце раунда, навсегда)"
                }
            },
            j_jokerstream_toha = {
                name = "Toha (tx2x2)",
                text = {
                    "{X:mult,C:white}X#1#{} Множителя",
                    "{C:inactive}В конце раунда поедает",
                    "случайного Джокера {C:attention}Еда{},",
                    "удваивая свой множитель",
                    "{C:red}Я хочу ЕСТЬ{}"
                }
            },
            j_jokerstream_ishowspeed = {
                name = "IShowSpeed",
                text = {
                    "В конце раунда шанс",
                    "получить донаты:",
                    "{C:money}1 из 3{} — {C:money}$5{}",
                    "{C:money}1 из 5{} — {C:money}$10{}",
                    "{C:money}1 из 7{} — {C:money}$13{}",
                    "{C:money}1 из 12{} — {C:money}$100{}",
                    "{C:inactive}(шансы независимы)"
                }
            },
            j_jokerstream_stinta = {
                name = "Stinta",
                text = {
                    "На {C:attention}первой{} и {C:attention}последней{}",
                    "руке за раунд даёт",
                    "{C:chips}+250{} Фишек и {C:mult}+5{} Множителя,",
                    "и повышает уровень",
                    "сыгранной покерной руки",
                    "{C:money}НЕЛЬ ПРИНЕСИ ПОЖАЛУЙСТА ЧАЙ{}"
                }
            },
            j_jokerstream_orange = {
                name = "Апельсин",
                text = {
                    "Даёт {C:money}$#1#{}",
                    "в конце раунда",
                    "{C:inactive}(+$1 навсегда за каждый раунд)"
                }
            },
            j_jokerstream_nelya = {
                name = "Nelya",
                text = {
                    "Если рука — {C:attention}Фулл Хаус{},",
                    "каждый {C:attention}Туз{} при подсчёте даёт",
                    "{C:chips}+35{} Фишек и {C:mult}+4{} Множителя",
                    "{C:attention}Стримерская семья с Stinta{}"
                }
            },
            j_jokerstream_mazelol = {
                name = "Мазелол",
                text = {
                    "Если сыгранная рука",
                    "того же типа, что и",
                    "предыдущая — даёт",
                    "{C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя"
                }
            },
            j_jokerstream_mazelol_thoughtful = {
                name = "Задумчивый Мазелол",
                text = {
                    "Если сыгранная комбинация",
                    "ЕЩЁ НЕ встречалась в этом",
                    "раунде — даёт {C:mult}+#1#{} Множителя",
                    "{C:inactive}(список сбрасывается каждый раунд)"
                }
            },
            j_jokerstream_drake = {
                name = "Дрэйк",
                text = {
                    "Даёт {C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя",
                    "{C:inactive}Увеличивается на {C:chips}+60{} Фишек",
                    "{C:inactive}и {C:mult}+4{} Множителя за каждый",
                    "{C:inactive}побеждённый Босс Блайнд"
                }
            },
            j_jokerstream_watermelon = {
                name = "Арбуз",
                text = {
                    "Даёт {C:attention}+1 Руку{}",
                    "в этом раунде",
                    "после первой сыгранной руки",
                    "{C:inactive}(Тоха съедает за #2# укуса, осталось #1#)"
                }
            },
            j_jokerstream_pyaterka = {
                name = "Пятёрка",
                text = {
                    "Каждая карта {C:attention}5{} при подсчёте",
                    "даёт {C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя",
                    "{C:inactive}Каждый {C:attention}5-й раунд{} усиливается",
                    "{C:inactive}на {C:chips}+155{} Фишек и {C:mult}+55{} Множителя"
                }
            },
            j_jokerstream_chat_balatro = {
                name = "Чат Балатро",
                text = {
                    "{C:dark_edition}Негативный{}",
                    "Даёт {C:chips}+#1#{} Фишек",
                    "Каждый раз, когда {C:attention}любой Джокер{}",
                    "активируется — {C:chips}+#2#{} Фишек",
                    "{C:inactive}(#3#){}",
                    "{C:mult}+#4#{} Множителя {C:inactive}(Максимум: +100){}",
                    "{X:mult,C:white}X#5#{} Множителя {C:inactive}(Максимум: X7.5){}"
                }
            },
            j_jokerstream_farfadox = {
                name = "Фарфадокс — Шахтёр Парадоксов",
                text = {
                    "Каждые {C:attention}3 раунда{} добавляет",
                    "в колоду {C:attention}Плачущий обсидиан{}",
                    "{C:inactive}(Без ограничений по количеству){}",
                    "{C:inactive}(Прошло раундов: #1#/3){}"
                }
            },
            j_jokerstream_moderator = {
                name = "Модератор",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "за каждый купленный {C:attention}Ваучер{}",
                    "{C:inactive}(Максимум: X#2#){}",
                    "{C:inactive}(Сейчас: {X:mult,C:white}X#3#{}{C:inactive}){}",
                    "{C:dark_edition}#4#{}"
                }
            },
            j_jokerstream_ad_banner = {
                name = "Рекламный баннер",
                text = {
                    "{C:dark_edition}Негативный{}",
                    "После {C:attention}Малого{} и {C:attention}Босс{} блайндов",
                    "добавляет {C:attention}+1 Ваучер{} в магазин",
                    "Но все Ваучеры стоят на {C:money}50%{} дороже",
                    "{C:inactive}малые ставки — малые выигрыши{}",
                    "{C:inactive}большие ставки — нулевой выигрыш{}"
                }
            },
            j_jokerstream_voucher_sponsor = {
                name = "Спонсор ваучеров",
                text = {
                    "{C:dark_edition}Негативный{}",
                    "После {C:attention}Малого{} и {C:attention}Босс{} блайндов",
                    "добавляет {C:attention}+1 Ваучер{} в магазин",
                    "Даёт {C:money}+$#1#{} в конце раунда",
                    "Но все Ваучеры стоят на {C:money}30%{} дороже",
                    "{C:dark_edition}я готов давать ваучеры но только за комиссию{}"
                }
            },
            j_jokerstream_broker = {
                name = "Брокер",
                text = {
                    "{C:dark_edition}Негативный{}",
                    "После {C:attention}Малого{} и {C:attention}Босс{} блайндов",
                    "добавляет {C:attention}+2 Ваучера{} в магазин",
                    "Даёт {C:money}+$#1#{} в конце раунда",
                    "Но все Ваучеры стоят на {C:money}20%{} дороже",
                    "{C:dark_edition}всё продаётся и всё покупается{}"
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
                name = "tx2x2 подарок от фаната",
                text = {
                    "Если рука — {C:attention}Каре{},",
                    "каждая карта при подсчёте",
                    "даёт {C:chips}+#1#{} Фишек",
                    "и {C:mult}+#2#{} Множителя",
                    "{C:inactive}я лев{}"
                }
            },
            j_jokerstream_pixel_stinta = {
                name = "Пиксельный Stinta",
                text = {
                    "Если в руке есть",
                    "и {C:attention}2{}, и {C:attention}8{},",
                    "каждая карта при подсчёте",
                    "даёт {C:chips}+#1#{} Фишек"
                }
            },
            j_jokerstream_bath_stinta = {
                name = "Ванный Stinta",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "Если за раунд сыграть {C:attention}Пару{},",
                    "{C:attention}Сет{} и {C:attention}Фулл Хаус{},",
                    "даёт {X:mult,C:white}X#2#{} Множителя",
                    "{C:inactive}(Максимум: X#3#){}",
                    "{C:chips}я рыба ёж{}"
                }
            },
            j_jokerstream_caseoh = {
                name = "когда переключил на белую тему (CaseOh)",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "Если сработает {C:green}1 к #2#{},",
                    "даёт {X:mult,C:white}X#3#{} Множителя",
                    "{C:inactive}(Максимум: X#4#){}"
                }
            },
            j_jokerstream_national_equality = {
                name = "{C:red}Национальное Равенство{}",
                text = {
                    "{C:inactive}Все равны, но некоторые — ровнее{}",
                    "За каждую {C:attention}повторяющуюся масть{}",
                    "даёт {C:chips}+#1#{} Фишек",
                    "Каждые {C:attention}#2#{} раунда даёт",
                    "случайное {C:tarot}Таро{}:",
                    "{C:attention}Звезда{}, {C:attention}Луна{}, {C:attention}Солнце{}, {C:attention}Мир{}",
                    "{C:inactive}(если есть место){}",
                    "{C:inactive}(Прошло раундов: #3#/#2#){}"
                }
            },
            j_jokerstream_fourth_wheel = {
                name = "Четвёртый лишний",
                text = {
                    "После победы над {C:attention}Босс Блайндом{}",
                    "создаёт {C:attention}#1#{} случайных",
                    "{C:attention}стример-джокера{} из коллекции",
                    "{C:inactive}(если есть место){}",
                    "{C:inactive}девочки а что он забыл в нашей компании{}"
                }
            },
            j_jokerstream_clown_streamer = {
                name = "Клоун",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "За каждого джокера {C:attention}без эдишена{},",
                    "даёт {X:mult,C:white}X#2#{} Множителя",
                    "{C:inactive}(Не считает самого себя){}",
                    "{C:inactive}чем больше цирк — тем смешнее{}"
                }
            },
            j_jokerstream_gojo_stint = {
                name = "Годжо stint",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "за каждый {C:dark_edition}эдишен{} в колоде",
                    "{C:inactive}(Foil +X#2#, Holo +X#2#, Poly +X#3#, Neg +X#4#){}"
                }
            },
            j_jokerstream_pixel_drake = {
                name = "Пиксельный Дрэйк",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "за каждого {C:attention}Редкого{} джокера",
                    "Даёт {X:mult,C:white}X#2#{} Множителя",
                    "за каждого {C:attention}Необычного{} джокера",
                    "Даёт {C:chips}+#3#{} Фишек",
                    "за каждого {C:attention}Обычного{} джокера"
                }
            },
            j_jokerstream_ogorodnik = {
                name = "Огородник (tx2x2)",
                text = {
                    "Каждый раз, когда джокер срабатывает",
                    "{C:attention}дважды за руку{},",
                    "даёт {X:mult,C:white}X#1#{} Множителя",
                    "{C:inactive}(Маленький ковшик, большие амбиции){}"
                }
            },
            j_jokerstream_dessert = {
                name = "Десерт",
                text = {
                    "В конце раунда даёт",
                    "{C:attention}1 случайного Food-джокера{}",
                    "Если {C:attention}Тоха{} в колоде,",
                    "{C:green}1 к #1#{} что Тоха его съест",
                    "{C:inactive}(Каждые 2 Food-джокера: шанс +1){}",
                    "{C:inactive}(Сейчас: 1 к #2#){}",
                    "{C:0xFF87C0}я настолько сладкий что можно подумать что я вишня{}"
                }
            },
            j_jokerstream_caseoh_drake = {
                name = "Деловой Дрейк",
                text = {
                    "Если рука — {C:attention}Пара{} или {C:attention}Две Пары{},",
                    "каждая карта при подсчёте даёт",
                    "{C:chips}+#1#{} Фишек",
                    "{C:inactive}Бизнес — это бизнес{}"
                }
            },
            j_jokerstream_caseoh_mazelol = {
                name = "Деловой Мазелол",
                text = {
                    "Если рука — {C:attention}Сет{}",
                    "или {C:attention}Каре{},",
                    "каждая карта при подсчёте даёт",
                    "{C:mult}+#1#{} Множителя",
                    "{C:inactive}Одна рука — одни деньги{}"
                }
            },
            j_jokerstream_caseoh_alpha = {
                name = "Альфа Гений Бизнесмен Самец",
                text = {
                    "Если рука — {C:attention}Фулл Хаус{},",
                    "каждая карта при подсчёте даёт",
                    "{C:chips}+#1#{} Фишек",
                    "{C:inactive}Сигма-грайндсет никогда не останавливается{}"
                }
            },
            j_jokerstream_caseoh_toha = {
                name = "Деловой Тоха",
                text = {
                    "Если рука — {C:attention}Пять к Одному{},",
                    "{C:attention}Стрит{} или {C:attention}Флэш{},",
                    "каждая карта при подсчёте даёт",
                    "{C:mult}+#1#{} Множителя",
                    "{C:inactive}Контракты подписаны. Сделки закрыты.{}"
                }
            },
            j_jokerstream_watcher = {
                name = "Watch Dogs",
                text = {
                    "Если сыгран {C:attention}Фулл Хаус{} — даёт",
                    "{C:mult}+#3#{} Множителя",
                    "Каждые {C:attention}#1#{} раунда даёт",
                    "случайный код",
                    "{C:inactive}(75% слабый, 25% сильный){}",
                    "{C:inactive}Прогресс: #2#/#1#{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_watcher_glitched = {
                name = "Watch Dogs: Glitched",
                text = {
                    "Если в сыгранной руке {C:attention}3+ масти{} —",
                    "{C:chips}+#3#{} Фишек за каждую карту",
                    "Каждые {C:attention}#1#{} раунда даёт",
                    "{C:purple}редкий код{}",
                    "{C:inactive}(Clear / Encrypted / Blume){}",
                    "{C:inactive}Прогресс: #2#/#1#{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_secret_path_recruit = {
                name = "Вербовка тайного пути",
                text = {
                    "Даёт {C:mult}+#1#{} Множителя,",
                    "пока {C:attention}энергия < #2#{}",
                    "{C:green}+10%{} сопротивление троянам (всегда)",
                    "Сейчас: {C:attention}#3#{} энергии ({#4#})",
                    "----- аддон Watch Dogs"
                },
            },
            j_jokerstream_you_see_me_in_donut_verse = {
                name = "Ты меня видишь в доне вселенной",
                text = {
                    "Если сыгран {C:attention}Сет{}:",
                    "{C:chips}+#1#{} Фишек за каждую карту",
                    "и даёт {C:purple}1 код{} 2 уровня",
                    "раз в раунд (макс. #2#)",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_server_ghost = {
                name = "Сервер-призрак",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя,",
                    "пока {C:attention}энергия > #2#{}",
                    "{C:green}25%{} шанс создать код в конце раунда",
                    "{C:green}+15%{} сопротивление троянам (всегда)",
                    "Сейчас: {C:attention}#3#{} энергии ({#4#})",
                    "----- аддон Watch Dogs"
                },
            },
            j_jokerstream_deadsec_ = {
                name = "deadsec_",
                text = {
                    "{C:inactive}Особые комбинации дают коды:{}",
                    "{C:attention}Фулл Хаус{} с 3 тузами → код босса",
                    "{C:attention}Каре из дам{} → код на карты",
                    "{C:attention}Стрит A-K-Q-J-10{} → код джокеров",
                    "{C:attention}Пара одной масти{} → код магазина",
                    "{C:inactive}Максимум #1# код в раунд{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_decrypt_me = {
                name = "Расшифруй меня",
                text = {
                    "Если рука — {C:attention}Сет{},",
                    "даёт {C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя",
                    "{C:inactive}Пока на столе снижает шанс",
                    "{C:inactive}срабатывания {C:red}трояна{} на {C:attention}#3#%{}",
                    "{C:inactive}(Тир #4#)",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_we_xs3w = {
                name = "мы//xs3w",
                text = {
                    "Если рука — {C:attention}Пара{},",
                    "даёт {C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя",
                    "{C:inactive}Пока на столе добавляет {C:attention}#3#%{}",
                    "{C:inactive}шанс выбить {C:purple}код более высокого тира{}",
                    "{C:inactive}(Тир #4#)",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_processor_sergey = {
                name = "Процессор Сергея",
                text = {
                    "Если рука — {C:attention}Сет{},",
                    "даёт {C:chips}+#1#{} Фишек",
                    "{C:inactive}Пока на столе добавляет {C:attention}#2#%{}",
                    "{C:inactive}шанс выбить {C:purple}код более высокого тира{}",
                    "{C:inactive}(Тир #3#)",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_city_of_terror = {
                name = "{C:money}Город терактов{}",
                text = {
                    "Каждый {C:attention}Туз{} при подсчёте даёт {C:mult}+#1#{} Множителя",
                    "{C:green}Шанс 1 к 3{} создать код",
                    "{C:attention}London is calling{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_dedsec_txt = {
                name = "dedsec.txt",
                text = {
                    "Если в руке есть {C:attention}Пара{},",
                    "даёт {C:chips}+#1#{} Фишек",
                    "{C:green}Шанс 1 к 4{} создать код в конце раунда",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_mamular = {
                name = "Мамулар",
                text = {
                    "Если в разыгранной руке есть",
                    "{C:attention}пара{} — даёт {C:chips}+#1#{} Фишек,",
                    "если есть {C:attention}сет{} — даёт",
                    "ещё {C:chips}+#1#{} Фишек",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_deg75 = {
                name = "75°",
                text = {
                    "Если в руке есть {C:attention}Пики{} и {C:attention}Трефы{},",
                    "каждая такая карта даёт {C:mult}+#1#{} Множителя",
                    "{C:green}Шанс 1 к 5{} создать код",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_karma_for_deed = {
                name = "Карма за деяние",
                text = {
                    "Если в руке {C:attention}2+ Червы{} и {C:attention}2+ Трефы{},",
                    "каждая карта даёт {C:chips}+#1#{} Фишек и {C:mult}+#2#{} Множителя",
                    "{C:green}Шанс 1 к 10{} создать {C:purple}Сигнатурный{} код",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_wsw_ghost = {
                name = "Проект: wsw",
                text = {
                    "Даёт {X:mult,C:white}X#1#{} Множителя",
                    "В конце раунда {C:green}шанс 1 к #2#{} {C:red}уничтожить{} Джокера",
                    "{C:inactive}Я вижу всё. Я везде.{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_dead_archive = {
                name = "Мёртвый архив",
                text = {
                    "Если рука — {C:attention}Пара{} или {C:attention}Две Пары{},",
                    "каждая карта даёт {C:mult}+#1#{} Множителя",
                    "{C:green}Шанс 1 к 3{} создать {C:attention}код магазина{} при Двух Парах",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_binary_code = {
                name = "11110001110000",
                text = {
                    "Если в руке {C:attention}2+ улучшенных{} карты,",
                    "каждая карта даёт {C:chips}+#1#{} Фишек",
                    "{C:green}Шанс 1 к 4{} получить {C:money}+$1{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_dead_exe = {
                name = "dead.exe",
                text = {
                    "Каждые {C:attention}#1#{} раунда улучшает {C:attention}#2#{} случайные карты",
                    "{C:inactive}(Прогресс: #3#/#1#){}",
                    "Всегда создаёт код при улучшении",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_vinyl_hack = {
                name = "Заезженная пластинка",
                text = {
                    "Если у вас {C:attention}2+ активных Джокера{},",
                    "повторно активирует {C:attention}все{} сыгранные карты",
                    "Каждая повторная активация имеет {C:green}шанс 1 к 15{} создать код",
                    "{C:inactive}Я поставлю этот трек на репит.{}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_nuclear_gift = {
                name = "Ядерный подарок",
                text = {
                    "Даёт {C:chips}+#1#{} Фишек",
                    "Через {C:attention}#2#{} раундов {C:red}взорвётся{},",
                    "{C:green}шанс 1 к #3#{} {C:red}уничтожить{} Джокера",
                    "{C:inactive}(Осталось раундов: #4#){}",
                    "----- аддон Watch Dogs"
                }
            },
            j_jokerstream_anonymity = {
                name = "Анонимность",
                text = {
                    "Каждая {C:attention}8{} при подсчёте даёт {C:mult}+#1#{} Множителя",
                    "Если была сыграна 8, {C:green}шанс 1 к 5{} создать код",
                    "{C:inactive}Всё анонимно, пока это не понадобится.{}",
                    "----- аддон Watch Dogs"
                }
            },
        },
        Voucher = {
            v_jokerstream_twitch_algorithm = {
                name = "Алгоритм Твича",
                text = {
                    "{C:attention}Твич-джокеры{} появляются",
                    "в {C:attention}2 раза{} чаще в магазине",
                    "{C:inactive}(Работает на всех джокеров мода){}"
                }
            },
            v_jokerstream_twitch_algorithm_plus = {
                name = "Алгоритм Твича+",
                text = {
                    "{C:attention}Твич-джокеры{} появляются",
                    "в {C:attention}4 раза{} чаще в магазине",
                    "{C:inactive}(Заменяет Алгоритм Твича){}"
                }
            },
            v_jokerstream_food_tips = {
                name = "Чаевые за еду",
                text = {
                    "Когда {C:attention}Toha{} съедает",
                    "Джокера-Еду, получаете",
                    "{C:money}50%{} его стоимости деньгами"
                }
            },
            v_jokerstream_food_tips_plus = {
                name = "Чаевые за еду+",
                text = {
                    "Когда {C:attention}Toha{} съедает",
                    "Джокера-Еду, получаете",
                    "{C:money}$10{} (обычный)",
                    "{C:money}$15{} (Фольга) / {C:money}$17{} (Голографик)",
                    "{C:money}$22{} (Полихром / Негатив)"
                }
            },
            v_jokerstream_food_all = {
                name = "Еда = Всё",
                text = {
                    "{C:attention}Toha{} теперь может есть",
                    "расходники и карты",
                    "{C:attention}Туз{}/{C:attention}Валет{} при подсчёте",
                    "{C:inactive}(максимум 2 каждой карты за игру)"
                }
            },
            v_jokerstream_unlimited_chat = {
                name = "Безлимитный чат",
                text = {
                    "{C:attention}Чат Балатро{} теряет лимит в {C:chips}700{} Фишек",
                    "Прирост теперь {C:chips}+65{} вместо {C:chips}+45{}",
                    "{C:inactive}(Уровень I){}"
                }
            },
            v_jokerstream_meme_chat = {
                name = "Мемный чат",
                text = {
                    "{C:attention}Чат Балатро{} теперь даёт",
                    "{C:mult}+10{} Множителя за каждую свою активацию",
                    "{C:inactive}(Максимум: +100){}",
                    "{C:inactive}(Уровень II){}"
                }
            },
            v_jokerstream_virus_chat = {
                name = "Вирусный чат",
                text = {
                    "{C:attention}Чат Балатро{} теперь даёт",
                    "{X:mult,C:white}+X0.5{} Множителя за каждую свою активацию",
                    "{C:inactive}(Максимум: X7.5){}",
                    "Меняет внешний вид {C:attention}Чат Балатро{}",
                    "{C:inactive}(Уровень III){}"
                }
            },
            v_jokerstream_moderator_of_moderator = {
                name = "Модератор модератора",
                text = {
                    "{C:attention}Модератор{} теперь даёт",
                    "{X:mult,C:white}X1{} Множителя за каждый",
                    "купленный {C:attention}Ваучер{}",
                    "{C:inactive}(Максимум: X7){}",
                    "{C:inactive}А кто модерирует модераторов?{}"
                }
            },
            v_jokerstream_moderator_of_moderator_of_moderator = {
                name = "Модератор модератора модератора",
                text = {
                    "{C:attention}Модератор{} теперь даёт",
                    "{X:mult,C:white}X1.5{} Множителя за каждый",
                    "купленный {C:attention}Ваучер{}",
                    "{C:inactive}(Максимум: X10){}",
                    "{C:inactive}Теперь их трое. Чат в безопасности. Наверное.{}"
                }
            },
            v_jokerstream_moderator_pocket_universe = {
                name = "Карманная вселенная модераторов",
                text = {
                    "{C:attention}Модератор{} теперь даёт",
                    "{X:mult,C:white}X2{} Множителя за каждый",
                    "купленный {C:attention}Ваучер{}",
                    "{C:inactive}(Максимум: X15){}",
                    "{C:inactive}У тебя в кармане целая вселенная.{}",
                    "{C:inactive}Не спрашивай, как она туда влезла.{}"
                }
            },
            v_jokerstream_business_mazelol_office = {
                name = "Работа в офисе",
                text = {
                    "{C:attention}Деловой Мазелол{} теперь даёт",
                    "{C:mult}+120{} Множителя за каждую карту",
                    "{C:inactive}(вместо +80){}"
                }
            },
            v_jokerstream_business_mazelol_cold = {
                name = "Работа с холодным воздухом",
                text = {
                    "{C:attention}Деловой Мазелол{} теперь даёт",
                    "{C:mult}+160{} Множителя за каждую карту",
                    "{C:inactive}(вместо +120){}"
                }
            },
            v_jokerstream_dedsec_booster = {
                name = "Усилитель DedSec",
                text = {
                    "{C:attention}Watch Dogs{} и обычные Джокеры появляются",
                    "в {C:attention}2 раза{} чаще в магазине",
                    "{C:inactive}(Появляется только при включенном аддоне Watch Dogs){}"
                }
            },
            v_jokerstream_perfect_firewall = {
                name = "Идеальный Брандмауэр",
                text = {
                    "Уменьшает получение {C:red}трояна{} на {C:attention}50%{}.",
                    "{C:inactive}(Система теперь идеально защищена){}",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_ip_locator = {
                name = "IP-Локатор",
                text = {
                    "При {C:green}отражении трояна{} перенаправляет пакеты.",
                    "Код всё равно активируется.",
                    "Пишет лог трассировки при успехе.",
                    "{C:inactive}(Червь перенаправляется на сервер CTOS){}",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_one_equals_two = {
                name = "1 = 2",
                text = {
                    "Использование {C:attention}search{} в консоли",
                    "даёт {C:attention}2 кода{}",
                    "вместо одного",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_dedsec_battery = {
                name = "Батарея DedSec",
                text = {
                    "Повышает производительность консоли.",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_dedsec_battery_plus = {
                name = "Улучшенная батарея",
                text = {
                    "Повышает производительность консоли ещё сильнее.",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_firewall = {
                name = "Брандмауэр",
                text = {
                    "Снижает шанс {C:red}трояна{} на {C:attention}15%{}.",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_firewall_plus = {
                name = "Продвинутый брандмауэр",
                text = {
                    "Снижает шанс {C:red}трояна{} еще на {C:attention}15%{}.",
                    "{C:inactive}(Всего 30% снижения)",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_encryption_key = {
                name = "Ключ шифрования",
                text = {
                    "Коды больше не могут выпасть {C:attention}Noisy{}.",
                    "{C:inactive}(Минимальный уровень: Static){}",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_deep_web_access = {
                name = "Доступ к Глубокой Сети",
                text = {
                    "{C:green}15% шанс{}, что сгенерированный код",
                    "будет повышен до следующего уровня.",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
            v_jokerstream_shop_scanner = {
                name = "Сканер магазина",
                text = {
                    "При входе в магазин {C:green}20% шанс{},",
                    "что все цены упадут на {C:attention}15%{}.",
                    "{C:inactive}(Требуется аддон Watch Dogs){}"
                }
            },
        },
        Blind = {
            bl_jokerstream_roulette = {
                name = "Рулетка",
                text = {
                    "После каждой сыгранной руки,",
                    "если у вас {C:attention}не осталось сбросов{},",
                    "один случайный Джокер будет",
                    "{C:red}уничтожен{}"
                }
            },
        },
        Enhanced = {
            m_jokerstream_crying_obsidian = {
                name = "Плачущий обсидиан",
                text = {
                    "{C:mult}+#1#{} Множителя при подсчёте",
                    "При уничтожении даёт {C:money}$2{}"
                }
            },
        },
        Other = {
            jokerstream_code_line_hidden = {
                name = "🔑 Код доступа",
                text = {
                    "{C:0x66FF66}-------{}",
                    "{C:inactive}(купи чтобы раскрыть){}"
                }
            },
            jokerstream_code_line_revealed = {
                name = "🔑 Код доступа",
                text = {
                    "{C:0x66FF66}#1#{}",
                    "{C:inactive}(используй в консоли для активации){}"
                }
            },
        },
    },
    misc = {
        dictionary = {
            k_active = "АКТИВЕН",
            k_inactive = "НЕАКТИВЕН",
        },
    },
}