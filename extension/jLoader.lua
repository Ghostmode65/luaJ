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

--add something to relink the unified folder if unlinked

local loadLibraries = function()
    local folders = FS:list(LuaJ.directory.roaming.library)
    local library = {}

    local loadfile = function(path,filename)
        local success = pcall(dofile, path..filename)
        if not success then Chat:log("Failed to load library: ".."\n§d"..filename) return nil end
    end

    library.nest = function(folder)
        for _,filename in pairs(FS:list(LuaJ.directory.roaming.library.."/"..folder.."/")) do
            local path = LuaJ.directory.roaming.library.."/"..folder.."/"
            if filename:sub(-4) == ".lua" then loadfile(path, filename)
            else library.nest(filename) end
        end
        
    end

   library.main = function()
        local files = FS:list(LuaJ.directory.roaming.library.."/main/")
        for _,filename in pairs(files) do
            library.nest("main/"..filename)
        end
   end

    library.sub = function()
        for _,folder in pairs(folders) do
            if folder ~= "main" then library.nest(folder) end
        end
    end


   library.main()
   library.sub()

end

loadLibraries()

--need to set lua option to global
    --could try to edit JsMacros:getConfig().options
    ---might need to do it in js
    ---edit the config file in table from the json directly
    



