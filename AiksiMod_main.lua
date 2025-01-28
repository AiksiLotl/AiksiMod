--- STEAMODDED HEADER
--- MOD_NAME: AiksiMod
--- MOD_ID: aiksimod
--- MOD_AUTHOR: [Aiksi, Amy Lily]
--- MOD_DESCRIPTION: Some Jokers and Decks!
--- BADGE_COLOUR: cb4bc6
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1216c]
--- VERSION: 0.1

----------------------------------------------
------------MOD CODE -------------------------

local joker_list = {
    --- Uncommon
    -- Currently doesn't work due to a Cryptid bug :c
--    "cry_flipped_joker"
    "amelie_joker",
    "tf2_scout"
}

local deck_list = {
    "deflationdeck",
    "pauperdeck",
    "cry_pauperdeck"
}

-- Jokers Atlas
SMODS.Atlas {
	key = "aiksi_mod_atlas_jokers",
	path = "aiksi_mod_atlas_jokers.png",
	px = 71,
	py = 95,
}

-- Decks Atlas
SMODS.Atlas {
	key = "aiksi_mod_atlas_decks",
	path = "aiksi_mod_atlas_decks.png",
	px = 71,
	py = 95,
}

-- Load all jokers
for _, v in ipairs(joker_list) do
    local joker = SMODS.load_file("content/jokers/" .. v .. ".lua")()

    --joker.discovered = true
    if joker.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
    if joker.antidependency and (SMODS.Mods[joker.antidependency] or {}).can_load then goto continue end
    joker.key = v

    if not joker.pos then
        joker.pos = { x = 0, y = 0 }
    end

    local joker_obj = SMODS.Joker(joker)

    for k_, v_ in pairs(joker) do
        if type(v_) == 'function' then
            joker_obj[k_] = joker[k_]
        end
    end

    ::continue::
end

-- Load all decks
for _, v in ipairs(deck_list) do
    local deck = SMODS.load_file("content/decks/" .. v .. ".lua")()

    if deck.dependency and not (SMODS.Mods[deck.dependency] or {}).can_load then goto continue end
    if deck.antidependency and (SMODS.Mods[deck.antidependency] or {}).can_load then goto continue end
    deck.key = v

    if not deck.pos then
        deck.pos = { x = 0, y = 0 }
    end

    local deck_obj = SMODS.Back(deck)

    for k_, v_ in pairs(deck) do
        if type(v_) == 'function' then
            deck_obj[k_] = deck[k_]
        end
    end

    ::continue::
end

----------------------------------------------
------------MOD CODE END----------------------