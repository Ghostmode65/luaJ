local loaded
if LuaJ then loaded = true goto skip end

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

::skip::

local roaming = LuaJ.getRoaming()
local configFolder = JsMacros:getConfig().configFolder:getPath()

if loaded then goto skip2 end

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

loaded = true

::skip2::

--Relink unified folder if missing 
if not FS:exists(LuaJ.directory.config.unified) then
    local url = LuaJ.github.."setup/directory.lua"
    local success = pcall(function() load(Request:create(url):get():text())() end)
    if not success then Chat:log("Failed to setup directory: ".."\n§d"..url) return nil end
end


local loadLibraries = function()
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

--get nested folders for libraries to load

--need to set lua option to global
    --could try to edit JsMacros:getConfig().options
    ---might need to do it in js
    ---edit the config file in table from the json directly
    
--Rename library to globals?