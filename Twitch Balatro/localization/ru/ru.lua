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
        },
        Voucher = {
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
    },
}