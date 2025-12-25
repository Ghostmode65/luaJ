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
        loader = roaming.. "/.jsMacros/scripts/Macros/loader/jLoader.lua",
    },
    config = {
        folder = configFolder,
        macros = configFolder.."/Macros",
        unified = configFolder.."/Macros/unified",
    }
}

local Setup = {
    directory = LuaJ.github.."setup/directory.lua",
    download = LuaJ.github.."setup/download.lua",
    config = LuaJ.github.."setup/config.lua",
}

--Setup directory if doesn't exist
if not FS:exists(LuaJ.directory.config.unified) then
        local success = pcall(function() load(Request:create(Setup.directory):get():text())() end)
        if not success then Chat:log("Failed to setup directory: ".."\n§d"..Setup.directory) return nil end
end

--Setup extensions if they don't exist
if not FS:exists(LuaJ.directory.roaming.loader) then
    local success = pcall(function() return load(Request:create(Setup.download):get():text())() end)
    if not success then Chat:log("Failed to download loader: ".."\n§d"..Setup.download) return nil end
end

local hasLaunchGame = function ()
    local tiggers = JsMacros:getProfile():getRegistry():getScriptTriggers()

    for i,v in pairs(tiggers) do
        if tostring(v.triggerType) == "EVENT" and v.event == "LaunchGame" and v.scriptFile  then
            return true
    end end
    
    local success = pcall(function() load(Request:create(Setup.config):get():text())() end)
    if not success then Chat:log("Failed to setup config: ".."\n§d"..Setup.config) return nil end
end

hasLaunchGame()

--load jLoader
local success = pcall(dofile, LuaJ.directory.roaming.loader)
if not success then Chat:log("Failed to load Default Library") return nil end


Chat:log("§a☻ Setup Complete ☻")