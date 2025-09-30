SMODS.Joker {
	name = "Nothing Ever Happens",
	key = "nothing_ever_happens",

    atlas = "nothing_ever_happens_atlas",
	pos = {x = 0, y = 0},

    rarity = 3,
    cost = 5,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = { extra = { mult = 5, Xmult = 0.1, miss_streak = 0 } },

    loc_vars = function(self, info_queue, card)
		local num_fell_for_it_again = 0
        if G.playing_cards then
            for k, v in ipairs(G.playing_cards) do
                if v:get_seal(true) == 'siri_fell_for_it_again' then
                    num_fell_for_it_again = num_fell_for_it_again + 1
                end
            end
        end
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.Xmult,
                num_fell_for_it_again * card.ability.extra.mult,
                card.ability.extra.miss_streak * card.ability.extra.Xmult + 1,

                colours = { HEX('FDBC00') }
            }
        }
    end,

    -- TODO I think the mult per award in deck is fine but maybe experiment with award in hand later
    calculate = function (self, card, context)
        if  context.using_consumeable and
            not context.blueprint and
            context.consumeable.ability.set == "Tarot" and
            context.consumeable.ability.name == "The Wheel of Fortune"
        then
            if G.GAME.siri_wheel_failure then
                card.ability.extra.miss_streak = card.ability.extra.miss_streak + 1
                return {
                    message = "Upgraded!",
                    colour = G.C.GREEN
                }
            else
                card.ability.extra.miss_streak = 0
                return {
                    message = localize("k_reset"),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            local num_fell_for_it_again = 0
            for k, v in ipairs(G.playing_cards) do
                if v:get_seal(true) == 'siri_fell_for_it_again' then
                    num_fell_for_it_again = num_fell_for_it_again + 1
                end
            end
            return {
                mult = num_fell_for_it_again * card.ability.extra.mult,
                xmult = card.ability.extra.miss_streak * card.ability.extra.Xmult + 1
            }
        end
    end
}

