local mod_id = "j_cuck_migano"
local mod_name = "Cuck Joker"
local mod_version = "0.9.1"
local mod_author = "migano"

local function jokerEffect(card, context)
    sendDebugMessage("#G.play.cards: " .. tostring(#G.play.cards))
    if card.ability.name == "Cuck" and context.cardarea == G.jokers and not context.before and not context.after and context.scoring_hand and G.play.cards then
        -- Count jacks and kings in hand
        local card_count = 0.0
        for i=1, #G.hand.cards do
            local card = G.hand.cards[i]
            if card.base.id == 11 or card.base.id == 13 then card_count = card_count + 1.0 end
        end

        -- Check if queen played
        local queen_found = false
        for i = 1, #G.play.cards do
            if G.play.cards[i]:get_id() == 12 then 
                queen_found = true
            end
        end
        
        sendDebugMessage("queen_found: " .. tostring(queen_found))


        if not queen_found then
            -- Queen not played
            card_count = 0.0
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function() 
                play_sound('timpani') 
                return true end }))
        else
            if card_count == 0.0 then
                -- Queen played but no jack or king in hand: x1
                card_count = 1.0
            else
                -- Queen played, x2 for each king and jack
                card_count = 2.0 * card_count
            end
        end
        return {
            message = localize{type='variable', key='a_xmult', vars = {card_count}},
            Xmult_mod = card_count
        }
    end
end

table.insert(mods, {
    mod_id = mod_id,
    name = mod_name,
    version = mod_version,
    author = mod_author,
    description = "Adds the \"The Cuck\" Joker.",
    enabled = true,
    on_enable = function()
        centerHook.addJoker(self, 
            'j_cuck_migano',  --id
            'Cuck',         --name
            jokerEffect,        --effect function
            nil,                --order
            true,               --unlocked
            true,               --discovered
            1,                  --cost
            {x=0,y=0},          --sprite position
            nil,                --internal effect description
            {extra={Xmult = 1.8}},         --config
            {"Each {C:attention}Jack{} and {C:attention}King{} in hand", "gives {X:red,C:white} X2 {} Mult if played", "hand contains a {C:attention}Queen{}, ", "{X:red,C:white} X0 {} if no {C:attention}Queen{} is played"}, --description text
            1,                  --rarity
            false,               --blueprint compatibility
            true,               --eternal compatibility
            nil,                --exclusion pool flag
            nil,                --inclusion pool flag
            nil,                --unlock condition
            true,               --collection alert
            "assets",           --sprite path
            "the cuck.png",     --sprite name
            {px=71, py=95}      --sprite size
        )
    end,
    on_disable = function()
        centerHook.removeJoker(self, "j_cuck_migano")
    end,

})