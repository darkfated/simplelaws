--[[
    * SimpleLaws *
    GitHub: https://github.com/darkfated/simplelaws
    Author's discord: darkfated
]]--

local function run_scripts()
    Mantle.run_sv('config.lua')

    Mantle.run_cl('nets.lua')
    Mantle.run_sv('nets.lua')

    Mantle.run_cl('hud.lua')
    Mantle.run_cl('menu.lua')
end

local function init()
    SimpleLawsConfig = SimpleLawsConfig or {}

    run_scripts()
end

init()
