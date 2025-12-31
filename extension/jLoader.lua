LuaJ = LuaJ or {}

local roaming = os.getenv("APPDATA")
local configFolder = JsMacros:getConfig().configFolder:getPath()

LuaJ.directory = LuaJ.directory or  {
    roaming = {
        folder = roaming,
        [".jsMacros"] = roaming.. "/.jsMacros/",
        library = roaming.. "/.jsMacros/scripts/library/",
        extensions = roaming.. "/.jsMacros/scripts/extensions/",
        macros = roaming.. "/.jsMacros/scripts/Macros/",
        --loader = roaming.. "/.jsMacros/scripts/Macros/loader/jLoader.lua", --Moved to config
    },
    config = {
        folder = configFolder,
        macros = configFolder.."/Macros/",
        unified = configFolder.."/Macros/unified",
        loader = configFolder.."/Macros/jLoader.lua",
    }
}

--Relink unified folder if missing 
if not FS:exists(LuaJ.directory.config.unified) then
    local url = "https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/tags/v1.0.1/".."setup/directory.lua"
    local success = pcall(function() load(Request:create(url):get():text())() end)
    if not success then Chat:log("Failed to setup directory: ".."\n§d"..url) return nil end
end

LuaJ.loadLibraries = LuaJ.loadLibraries or function()
    local folders = FS:list(LuaJ.directory.roaming.library)
    local library = {}

    local loadfile = function(path,filename)
        local success = pcall(dofile, path..filename)
        if not success then Chat:log("Failed to load library: ".."\n§d"..filename) return nil end
    end

    library.nest = function(folder)
        local files = FS:list(LuaJ.directory.roaming.library.."/"..folder)
        if not files then return nil end
        for _,filename in pairs(files) do
            local path = LuaJ.directory.roaming.library.."/"..folder.."/"
            if filename:sub(-4) == ".lua" then loadfile(path, filename)
                elseif FS:isDir(path..filename) then --does this gurantee it's a folder?
            library.nest(folder.."/"..filename) end
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

LuaJ.loadLibraries()
