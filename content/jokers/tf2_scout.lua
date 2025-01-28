-- Joker
local joker = {
    name = "tf2_scout",
    pos = {x = 1, y = 1},
    atlas = "aiksi_mod_atlas_jokers",
    rarity = 3,
    cost = 8,
    discovered = true,
    config = {extra = {current_odds = 3, odds = 4}},
    loc_txt = {
        name = "Scout Joker",
        text = {
            "{C:green}#1# in #2#{} chance to gain a {C:blue}hand{} instead of dying",
            "Each time this happens, {C:red}reduce{} the chance by {C:green}#3#{} this round,",
            "and {C:purple}create{} a {C:attention,T:j_diet_cola}Diet Cola{} {C:inactive}(Must have room){}",
            "Each time a {C:attention,T:j_diet_cola}Diet Cola{} is sold,",
            "increase the odds permanently by {C:green}#3#{}",
            "{C:inactive,s:0.8}WOOSH! Miss me! Nanananana~"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.current_odds * (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, ''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
-- The function
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers then
            if (G.GAME.chips + hand_chips * mult) < G.GAME.blind.chips and G.GAME.current_round.hands_left < 1 then
                if card.ability.extra.current_odds > 0 then
                    if pseudorandom("tf2_scout") < card.ability.extra.current_odds * G.GAME.probabilities.normal / card.ability.extra.odds then
                        ease_hands_played(1)
                        card.ability.extra.current_odds = card.ability.extra.current_odds - 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                if #G.jokers.cards < G.jokers.config.card_limit then  
                                    add_joker('j_diet_cola', nil, nil, nil)
                                end
                            return true
                            end
                        }))
                        return {
                            message = "WOOSH!",
                            colour = G.C.BLUE,
                        }
                    end
                end
            end
        end
        if context.end_of_round then
            card.ability.extra.current_odds = card.ability.extra.odds - 1
        end
        if context.selling_card then
            if context.card.ability.name == "Diet Cola" then
                card.ability.extra.odds = card.ability.extra.odds + 1
                card.ability.extra.current_odds = card.ability.extra.current_odds + 1
                return {
                    message = "BONK!",
                    colour = G.C.ORANGE,
                }
            end
        end
	end
}

return joker