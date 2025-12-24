
local roaming = LuaJ.getRoaming()

LuaJ.directory  =  {
    roaming = {
        folder = roaming,
        jsmacros = roaming.. "/.jsMacros/",
        library = roaming.. "/.jsMacros/scripts/library",
        extensions = roaming.. "/.jsMacros/scripts/extensions",
        macros = roaming.. "/.jsMacros/scripts/Macros",

    }
}

return LuaJ.Folders