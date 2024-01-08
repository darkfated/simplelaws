--[[
    * SimpleLaws *
    GitHub: https://github.com/darkfated/simplelaws
    Author's discord: darkfated
]]

local function run_scripts()
    local cl = SERVER and AddCSLuaFile or include
    local sv = SERVER and include or function() end

    sv('config.lua')

    cl('nets.lua')
    sv('nets.lua')

    cl('hud.lua')
    cl('menu.lua')
end

local function init()
    SimpleLawsConfig = SimpleLawsConfig or {}

    run_scripts()
end

init()
