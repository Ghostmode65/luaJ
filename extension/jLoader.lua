LuaJ = {
    github = "https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/heads/main/",
}

LuaJ.getRoaming = function()
    if GlobalVars:getString(".roaming") then return GlobalVars:getString(".roaming") end

        local File = luajava.bindClass("java.io.File");
        local System = luajava.bindClass("java.lang.System");
        local roaming = Reflection:newInstance(
            File,
                {System:getenv("APPDATA")}
        )
        GlobalVars:putString(".roaming",roaming:getAbsolutePath())
        return roaming:getAbsolutePath();
end

local roaming = LuaJ.getRoaming()
local configFolder = JsMacros:getConfig().configFolder:getPath()

LuaJ.directory  =  {
    roaming = {
        folder = roaming,
        [".jsMacros"] = roaming.. "/.jsMacros/",
        library = roaming.. "/.jsMacros/scripts/library",
        extensions = roaming.. "/.jsMacros/scripts/extensions",
        macros = roaming.. "/.jsMacros/scripts/Macros",
    },
    config = {
        folder = configFolder,
        unified = configFolder.."/unified",
    }
}

local Setup = {
    directory = LuaJ.github.."setup/directory.lua",
    download = LuaJ.github.."setup/download.lua",
    config = LuaJ.github.."setup/config.lua",
}

--Setup directory if doesn't exist
if not FS:exists(LuaJ.directory.config.unified) then
        local success = pcall(load,Request:create(Setup.directory):get():text())
        if not success then Chat:log("Failed to setup directory: ".."\n§d"..Setup.directory) return nil end
end

--Setup extensions if they don't exist otherwise load them
if not FS:exists(LuaJ.directory.roaming.extensions.."/DefaultLibrary.lua") then
    local success = pcall(load, Request:create(Setup.download):get():text())
    if not success then Chat:log("Failed to download Default Library: ".."\n§d"..Setup.download) return nil end
else
    local success = pcall(dofile(), LuaJ.directory.roaming.extensions.."/DefaultLibrary.lua")
    if not success then Chat:log("Failed to load Default Library") return nil end
end


local hasLaunchGame = function ()
    local tiggers = JsMacros:getProfile():getRegistry():getScriptTriggers()

    for i,v in pairs(tiggers) do
        if tostring(v.triggerType) == "EVENT" and v.event == "LaunchGame" and v.scriptFile  then
            return true
    end end
    
    local success = pcall(load, Request:create(Setup.config):get():text())
    if not success then Chat:log("Failed to setup config: ".."\n§d"..Setup.config) return nil end
end

hasLaunchGame()

--need to set lua option to global
    --could try to edit JsMacros:getConfig().options
    ---might need to do it in js
    ---edit the config file in table from the json directly

--move most of the setup to one file and only ran once when installer is ran. (execpt for linking the unified folder, sometimes unlinked)

--should all libraries by loaded by default?
    --or should all extensions be loaded by default?