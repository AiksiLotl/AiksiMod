local joker = {
    name = "cry_flipped_joker",
    pos = {x = 0, y = 0},
    --soul_pos = { x = 3, y = 3 },
    atlas = "aiksi_mod_atlas_jokers",
    rarity = 2,
    cost = 5,
    discovered = true,
    config = {},
    dependency = "Cryptid",
    loc_txt = {
        name = "Flipped Joker",
        text = {
            "{C:attention}Flips{} all joker values",
            "(Example: +2 Mult becomes -2 Mult)"}
    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
}

function invert_jokers(card)
    for i, v in pairs (G.jokers.cards) do
        if not Card.no(v, "immutable", true) then
            if not v.config.inverted then
                cry_with_deck_effects(G.jokers.cards[1], function(card)
                    cry_misprintize(v, { min = 2.0, max = 2.0}, nil, true)
                    v.config.inverted = true
                end)
            end
        end
    end
end

function revert_jokers(card)
    for i, v in pairs (G.jokers.cards) do
        if not Card.no(v, "immutable", true) then
            if v.config.inverted then
                cry_with_deck_effects(G.jokers.cards[1], function(card)
                    cry_misprintize(v, { min = 2.0, max = 2.0}, nil, true)
                    v.config.inverted = false
                end)
            end
        end
    end
end

joker.add_to_deck = function(self, card)
    print("added")
    if G.jokers then
        invert_jokers(card)
    end
end

joker.remove_from_deck = function(self, card)
    print("removed")
    if G.jokers then
        revert_jokers(card)
    end
end

joker.update = function(self, card)
    if G.jokers then
        invert_jokers(card)
    end
end

return joker