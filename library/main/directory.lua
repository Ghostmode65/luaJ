
local roaming = GlobalVars:get(".roaming")


LuaJ.Folders  =  {
    roaming = {
        folder = roaming,
        jsmacros = roaming.. "/.jsMacros/",
        library = roaming.. "/.jsMacros/scripts/library",
        extensions = roaming.. "/.jsMacros/scripts/extensions",
        macros = roaming.. "/.jsMacros/scripts/Macros",

    },
    url = {
        luaj = "https://raw.githubusercontent.com/Ghostmode65/mclib/refs/heads/main/luaj/",
    },
}

return LuaJ.Folders