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


if not FS:exists(JsMacros:getConfig().configFolder:getPath().."/unified") then
    --Run setups
return nil end

if not FS:exists(LuaJ.getRoaming().."/.jsMacros") then
    Chat:log("Failed to find jsMacros folder")
return nil end

--execute extension to load main library
--execute extension to load some of the other libraries

--