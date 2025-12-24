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
        local success, result = pcall(function()
            dofile(Request:create(Setup.directory):get():text()) end)
        if not success then Chat:log("Failed to setup directory: ".."\n§d"..Setup.directory) return nil end
end

--Setup extensions if they don't exist otherwise load them
if not FS:exists(LuaJ.directory.roaming.extensions.."/DefaultLibrary.lua") then
    local success, result = pcall(function()
        dofile(Request:create(Setup.download):get():text()) end)
    if not success then Chat:log("Failed to download Default Library: ".."\n§d"..Setup.download) return nil end
else
    local success, result = pcall(function()
        dofile(LuaJ.directory.roaming.extensions.."/DefaultLibrary.lua")
    end)

    if not success then
        Chat:log("Failed to load Default Library")
    return nil end
end

--Setup config if jLoader is not in config.json



--shorten pcalls

--should all libraries by loaded by default?
    --or should all extensions be loaded by default?