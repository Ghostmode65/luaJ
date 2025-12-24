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

local Setup = {
    directory = LuaJ.github.."setup/directory.lua",
    library = LuaJ.github.."setup/library.lua",
    extensions = LuaJ.github.."setup/extensions.lua",
}

if not FS:exists(JsMacros:getConfig().configFolder:getPath().."/unified") then
    for key, url in pairs(Setup) do
        local success, result = pcall(function()
            dofile(Request:create(url):get():text()) end)
        if not success then Chat:log("Failed to setup"..key.."\n§d"..url) return nil end
    end
end

if not FS:exists(LuaJ.getRoaming().."/.jsMacros") then
    Chat:log("Failed to find jsMacros folder")
return nil end

local success, result = pcall(function()
    dofile(LuaJ.getRoaming().."/.jsMacros/scripts/extensions/DefaultLibrary.lua")
end)

if not success then
    Chat:log("Failed to load Default Library")
return nil end

--should all libraries by loaded by default?
    --or should all extensions be loaded by default?