--  Deck
local deck = {
    key = "cry_pauperdeck",
--  Disables interest and hands reward money
    config = {no_interest = true, extra_hand_bonus = 0},
	dependency = "Cryptid",
    pos = { x = 1, y = 0 },
	atlas = "aiksi_mod_atlas_decks",
    loc_txt = {
        name = "Pauper Deck",
        text = {
            "Only {C:attention}Jokers{} can earn you {C:money}${}",
			"Start with",
			"an {C:purple}Eternal{} {C:dark_edition}Negative{} {C:attention,T:j_gift}Gift Card{p:1}",
			"Shop has no {C:attention}Jokers{}",
			"Open a {C:attention,T:p_buffoon_jumbo_1}Jumbo Pack{}",
			"after defeating a {C:attention}Blind{}",
        }
    },

	apply = function()
--  Disables jokers from appearing in the shop
		G.GAME.joker_rate = 0
--  Disables blind reward money
		G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
		G.GAME.modifiers.no_blind_reward.Small = true
		G.GAME.modifiers.no_blind_reward.Big = true
		G.GAME.modifiers.no_blind_reward.Boss = true
--  Bans
		G.GAME.banned_keys['m_gold'] = true
		G.GAME.banned_keys['m_lucky'] = true
		G.GAME.banned_keys['Gold'] = true
		G.GAME.banned_keys['c_judgement'] = true
		G.GAME.banned_keys['c_hermit'] = true
		G.GAME.banned_keys['c_temperance'] = true
		G.GAME.banned_keys['c_devil'] = true
		G.GAME.banned_keys['c_magician'] = true
		G.GAME.banned_keys['c_immolate'] = true
		G.GAME.banned_keys['c_talisman'] = true
		G.GAME.banned_keys['p_buffoon_normal_1'] = true
		G.GAME.banned_keys['p_buffoon_normal_2'] = true
		G.GAME.banned_keys['p_buffoon_jumbo_1'] = true
		G.GAME.banned_keys['p_buffoon_mega_1'] = true
		G.GAME.banned_keys['tag_rare'] = true
		G.GAME.banned_keys['tag_uncommon'] = true
		G.GAME.banned_keys['tag_holo'] = true
		G.GAME.banned_keys['tag_polychrome'] = true
		G.GAME.banned_keys['tag_negative'] = true
		G.GAME.banned_keys['tag_foil'] = true
		G.GAME.banned_keys['tag_buffoon'] = true
		G.GAME.banned_keys['tag_top_up'] = true
		G.GAME.banned_keys['tag_investment'] = true
		G.GAME.banned_keys['tag_handy'] = true
		G.GAME.banned_keys['tag_garbage'] = true
		G.GAME.banned_keys['tag_skip'] = true
		G.GAME.banned_keys['tag_economy'] = true
		G.GAME.banned_keys['v_seed_money'] = true
		G.GAME.banned_keys['v_money_tree'] = true
		G.GAME.banned_keys['j_swashbuckler'] = true
		G.GAME.banned_keys['j_midas_mask'] = true
		G.GAME.banned_keys['j_to_the_moon'] = true
		G.GAME.banned_keys['j_lucky_cat'] = true
		G.GAME.banned_keys['j_ticket'] = true
--  Cryptid bans
        G.GAME.banned_keys['e_cry_gold'] = true
        G.GAME.banned_keys['c_cry_vacuum'] = true
        G.GAME.banned_keys['c_cry_pointer'] = true
        G.GAME.banned_keys['c_cry_payload'] = true
        G.GAME.banned_keys['c_cry_class'] = true
        G.GAME.banned_keys['c_cry_rework'] = true
        G.GAME.banned_keys['tag_cry_epic'] = true
        G.GAME.banned_keys['tag_cry_glitched'] = true
        G.GAME.banned_keys['tag_cry_mosaic'] = true
        G.GAME.banned_keys['tag_cry_oversat'] = true
        G.GAME.banned_keys['tag_cry_glass'] = true
        G.GAME.banned_keys['tag_cry_gold'] = true
        G.GAME.banned_keys['tag_cry_blur'] = true
        G.GAME.banned_keys['tag_cry_astral'] = true
        G.GAME.banned_keys['tag_cry_m'] = true
        G.GAME.banned_keys['tag_cry_double_m'] = true
        G.GAME.banned_keys['tag_cry_bettertop_up'] = true
        G.GAME.banned_keys['tag_cry_bundle'] = true
        G.GAME.banned_keys['tag_cry_gourmand'] = true
        G.GAME.banned_keys['tag_cry_rework'] = true
        G.GAME.banned_keys['tag_cry_schematic'] = true
        G.GAME.banned_keys['tag_cry_banana'] = true
        G.GAME.banned_keys['v_cry_moneybean'] = true
        G.GAME.banned_keys['j_cry_lucky_joker'] = true
        G.GAME.banned_keys['j_cry_goldjoker'] = true

--  Spawns an Eternal Negative Gift Card at the beginning of the game
		G.E_MANAGER:add_event(Event({
			func = function()
				add_joker('j_gift', 'negative', true, true)
			return true
			end
		}))
	end,

	trigger_effect = function(self, args)
		if args.context == 'eval' and G.GAME.last_blind then
			G.E_MANAGER:add_event(Event({
				trigger = "condition",
				blocking = false, 
				func = function() 
					if G.STATE == G.STATES.SHOP then
--  Spawns a Jumbo Pack after a Blind is defeated
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							func = function()
								local key = "p_buffoon_jumbo_1"
								local card = Card(
									G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
									G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
									G.CARD_W * 1.27,
									G.CARD_H * 1.27,
									G.P_CARDS.empty,
									G.P_CENTERS[key],
									{ bypass_discovery_center = true, bypass_discovery_ui = true }
								)
								card.cost = 0
								G.FUNCS.use_card({ config = { ref_table = card } } )
								card:start_materialize()
								return true
							end,
						}))
						return true
					end
					return false
				end
			}))

--  Decreases the price of each consumable at the end of the round to counterract Gift Card's effect
			for k, v in ipairs(G.consumeables.cards) do
				if v.set_cost then 
					v.ability.extra_value = (v.ability.extra_value or 0) - 1
					v:set_cost()
				end
			end
			return true
		end
    end
}

return deck