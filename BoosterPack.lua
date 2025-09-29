SMODS.current_mod.description_loc_vars = function(self)
    return {
        text_colour = G.C.WHITE,
        background_colour = G.C.L_BLACK
    }
end

assert(SMODS.load_file("Seals/Seals.lua"))()
assert(SMODS.load_file("Jokers/Jokers.lua"))()
assert(SMODS.load_file("Atlases/Atlases.lua"))()
assert(SMODS.load_file("Keybinds/Keybinds.lua"))()

