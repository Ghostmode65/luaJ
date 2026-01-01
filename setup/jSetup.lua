LuaJ = {}
LuaJ.setup = {
    github = "https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/tags/v1.1.0/",
    --- If Your Forking ---
    --- Add the libraries or scripts you want to download and execute automatically here (chances are high you won't need to touch anything else execpt installer.js)---
    ["External Library"] = {
        --"https://www.github.com/example1.lua",
        --"https://www.github.com/example2.lua"
    },
    ["Keybinds"] = {
        {url = "", keybind = "key.keyboard.keypad.4", folder = "custom"},
    }
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


