-- Joker
local joker = {
    name = "amelie_joker",
    pos = {x = 2, y = 0},
    atlas = "aiksi_mod_atlas_jokers",
    rarity = 3,
    cost = 8,
    discovered = true,
    config = {},
    loc_txt = {
        name = "Witch Amelie",
        text = {
            "Applies a random {C:dark_edition}Edition{}",
            "To a random {C:attention}scored card{}"}
    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
-- The function
    calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
            local cards_without_edition = {}
        -- Gets all scored cards that dont already have an edition
            for i = 1, #context.scoring_hand do
                local card = context.scoring_hand[i]
                if not card.edition then
                    cards_without_edition[#cards_without_edition + 1] = card
                end
            end

            if #cards_without_edition > 0 then
            -- Applies an edition to a random card that doesn't already have one
                local edition = poll_edition('amelie_joker', nil, true, true)
                local random_card = pseudorandom_element(cards_without_edition, pseudoseed('amelie_joker'))
                random_card:set_edition(edition, true)
            
            -- Joker juice
                return {
                    message = "Hehehe~",
                    colour = G.C.PURPLE,
                    card = self,
                }
            end
            return true
		end
	end
}

return joker