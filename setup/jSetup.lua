LuaJ = {}

local config = GlobalVars.getObject("LauJConfiguration")

LuaJ.setup = {
    github = config.github,
  
    ["External Library"] = config.externalLibraries or {},
    ["Keybinds"] = config.keybinds or {},
    user = config.user or {},
}

local Setup = {
    directory = LuaJ.setup.github.."setup/directory.lua",
    download = LuaJ.setup.github.."setup/download.lua",
    config = LuaJ.setup.github.."setup/config.lua",

    loader = LuaJ.setup.github.."extension/jLoader.lua",
}

--run jLoader
local success = pcall(function() load(Request:create(Setup.loader):get():text())() end)
if not success then Chat:log("Failed to load jLoader: ".."\n§d"..Setup.loader) return nil end

--Setup directory
local success = pcall(function() load(Request:create(Setup.directory):get():text())() end)
if not success then Chat:log("Failed to setup directory: ".."\n§d"..Setup.directory) return nil end

--Download files
local success = pcall(function() return load(Request:create(Setup.download):get():text())() end)
if not success then Chat:log("Failed to download loader: ".."\n§d"..Setup.download) return nil end

local addjLoader = function ()
    local tiggers = JsMacros:getProfile():getRegistry():getScriptTriggers()

    for i,v in pairs(tiggers) do
        if tostring(v.triggerType) == "EVENT" and v.event == "LaunchGame" and v.scriptFile  then
            return true
    end end
    
    local success = pcall(function() load(Request:create(Setup.config):get():text())() end)
    if not success then Chat:log("Failed to setup config: ".."\n§d"..Setup.config) return nil end
end

addjLoader()

--Load all libraries
LuaJ.loadLibraries()
LuaJ.setup = nil

Chat:log("§a☻ LuaJ Setup Complete ☻")


