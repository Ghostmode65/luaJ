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
        scripts = roaming.. "/.jsMacros/scripts/",
        plugins = roaming.. "/.jsMacros/scripts/plugins/",
    },
    config = {
        folder = configFolder,
        macros = configFolder.."/Macros/",
        unified = configFolder.."/Macros/unified",
        loader = configFolder.."/Macros/jLoader.lua",
    }
}

--Relink unified folder if missing 
local unfiyFolder = function(delete)
    local instancePath = LuaJ.directory.config.unified
    local unifyPath = LuaJ.directory.roaming.macros

    local File = luajava.bindClass("java.io.File");
    local junctionDir = Reflection:newInstance(
        File,
            {instancePath}
    )
    if (junctionDir:exists() and delete) then junctionDir:delete() elseif (junctionDir:exists() and not delete) then return true end

    os.execute('cmd /c rmdir "' .. instancePath .. '" >nul 2>&1')
    local exitCode = os.execute(
        'cmd /c mklink /J "' .. instancePath .. '" "' .. unifyPath .. '"'
    )

    if exitCode == true then
        Chat:log("✓ Linked unified folder")
        return true
    else
        Chat:log("✗ Failed to link unified folder (" .. tostring(exitCode) .. ")")
        return false
    end
end

LuaJ.loadLibraries = LuaJ.loadLibraries or function()
    local folders = FS:list(LuaJ.directory.roaming.library) or {}
    local library = {}

    local loadfile = function(path,filename)
        local success = pcall(dofile, path..filename)
        if not success then Chat:log("Failed to load library: ".."\n§d"..filename) return nil end
    end

    library.nest = function(folder)
        local files = FS:list(LuaJ.directory.roaming.library..folder)
        if not files then return nil end
        for _,filename in pairs(files) do
            local path = LuaJ.directory.roaming.library..folder.."/"
            if filename:sub(-4) == ".lua" then loadfile(path, filename)
                elseif FS:isDir(path..filename) then --does this gurantee it's a folder?
            library.nest(folder.."/"..filename) end
        end
    end

   library.main = function()
        for i, folder in pairs(folders) do
            if folder == "main" then library.nest(folder) break end
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

local status, err = pcall(unfiyFolder)
if not status then Chat:log("§cError linking unified folder") end

if not LuaJ.setup then LuaJ.loadLibraries() end
