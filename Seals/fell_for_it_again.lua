SMODS.Seal {
	name = "Fell For It Again Award",
	key = "fell_for_it_again",
	atlas = "fell_for_it_again_atlas",
	pos = {x = 0, y = 0},
	badge_colour = HEX('FDBC00'),

	-- self - this seal prototype
    -- card - card this seal is applied to
    calculate = function(self, card, context)
        if  context.before and
            context.cardarea == G.play
        then
            if
                not G.GAME.hands[context.scoring_name] or
                G.GAME.hands[context.scoring_name].played_this_round < 2
            then
                sendDebugMessage("Fell For It Again :: Debuffing Card", "BoosterPackDBG")
                card:set_debuff(true)
            else
                card:set_debuff(false)
            end
        end
	end,
}

-- Overwrite the Wheel of Fortune calculate:
SMODS.Consumable:take_ownership('wheel_of_fortune', -- object key (class prefix not required)
    { -- table of properties to change from the existing object

    config = { extra = { odds = 4 } },

	-- Wheel of Fortune, adapted from VanillaRemade [Permalink](https://github.com/nh6574/VanillaRemade/blob/014b0b0c62a3cd7bccd04872b84fc572a52f8fe4/src/tarots.lua#L616)
	use = function(self, card, area, copier)
		-- String here is just a seed
        if SMODS.pseudorandom_probability(card, 'wheel_of_fortune', 1, card.ability.extra.odds) then
            G.GAME.siri_wheel_failure = false
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

            local eligible_card = pseudorandom_element(editionless_jokers, 'vremade_wheel_of_fortune')
            local edition = poll_edition('vremade_wheel_of_fortune', nil, true, true,
                { 'e_polychrome', 'e_holo', 'e_foil' })
            eligible_card:set_edition(edition, true)
            check_for_unlock({ type = 'have_edition' })
        else
            G.GAME.siri_wheel_failure = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					sendDebugMessage("Adding Fell For It Seal", "BoosterPackDBG")
					local num_cards = 0
                    local card_indices = {}
					for k, v in ipairs(G.playing_cards) do
						if v:get_seal(true) ~= 'siri_fell_for_it_again' then
                            card_indices[num_cards] = k
                            num_cards = num_cards + 1
                        end
					end
					G.playing_cards[card_indices[math.random(num_cards - 1)]]:set_seal('siri_fell_for_it_again', nil, true)
                return true end }))
        end
    end,
    },
    false -- silent | suppresses mod badge
)
