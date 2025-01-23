--  Deck
local deck = {
    key = "deflationdeck",
--  Grants Clearance Sale and Liquidation vouchers at the start of a run
    config = {vouchers = {'v_clearance_sale','v_liquidation'}},
    pos = { x = 0, y = 0 },
	atlas = "aiksi_mod_atlas_decks",
    loc_txt = {
        name = "Deflation Deck",
        text = {
            "Start run with {C:money,T:v_clearance_sale}Clearance Sale{}",
            "and {C:money,T:v_liquidation}Liquidation{}",
            "After defeating a {C:attention}Blind{},",
            "{C:red}reduce{} the sell value",
            "of {C:attention}everything{} you have by {C:money}3${}",
        }
    },
	trigger_effect = function(self, args)
		if args.context == 'eval' and G.GAME.last_blind then
--  Decreases the price of each joker at the end of the round
            for k, v in ipairs(G.jokers.cards) do
                if v.set_cost then 
                    v.ability.extra_value = (v.ability.extra_value or 0) - 3
                    v:set_cost()
                end
            end
--  Decreases the price of each consumable at the end of the round
			for k, v in ipairs(G.consumeables.cards) do
				if v.set_cost then 
					v.ability.extra_value = (v.ability.extra_value or 0) - 3
					v:set_cost()
				end
			end
			return true
		end
    end
}

return deck