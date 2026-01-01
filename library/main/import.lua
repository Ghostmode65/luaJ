local _Env = {
    Import_Cache = {},
}

Import = {} --The name isn't the best, but you can already do most similar things with lua 

local _jsMacros = LuaJ.directory.roaming[".jsMacros"]

Import.url = function(url,doCache)
    if not url or type(url) ~= "string" then Chat:log("url not a string".."\n§d"..tostring(url)) return nil end
    if doCache and _Env.Import_Cache[url] then return _Env.Import_Cache[url] end

    local success, result = pcall(function()
        local script = load(Request:create(url):get():text())
            return script and script() or nil
        end)
        if not success then Chat:log("§cUrl failed to load: ".."\n§d"..url) return nil end
        if doCache then _Env.Import_Cache[url] = result end
    return result
end

Import.file = function(file,doCache) --##Include file path in file, Starts at romaing/.jsMacros/
    if not file or type(file) ~= "string" then Chat:log("file not a string".."\n§d"..tostring(file)) return nil end
    if doCache and _Env.Import_Cache[file] then return _Env.Import_Cache[file] end

    if not file:match("%.lua$") then file = file .. ".lua" end

    local filepath = LuaJ.directory.roaming[".jsMacros"]..file
    if not FS:exists(filepath) then Chat:log("§cFile does not exist: ".."\n§d"..filepath) return nil end

    local success, result = pcall(function()
        local script = loadfile(filepath)
            return script and script() or nil
        end)
    if not success then Chat:log("§cFile Failed to load: ".."\n§d"..filepath) return nil end
        
    if doCache then _Env.Import_Cache[file] = result end
    return result
end


Import.download = function(url, saveDirectory, overwrite) --*.jsMacros/saveDirectory/github filename or config/saveDirectory/github filename
    local valid = pcall(function() Request:create(url):get() return true end)
    if not valid then Chat:log("Invalid URL".."\n§d"..url) return nil end

    local dir
    if type(saveDirectory) == "string" then
        dir = LuaJ.directory.roaming[".jsMacros"]..(saveDirectory or "")
    else
        dir = LuaJ.directory.config.macros..(saveDirectory[1] or "")
    end
    
    if not FS:exists(dir) then
        if not FS:makeDir(dir) then Chat:log("Failed to create directory: ".."\n§d"..dir) return nil end --Will fail if parent directories don't exist, should it make all parent directories?
    end

    local filename = url:match("^.+/(.+)$")
    if not overwrite and FS:exists(dir..filename) then return filename end --Test

    if filename == "jLoader.lua" then dir = LuaJ.directory.config.macros end

    Chat:log("Downloading §d"..filename.."§f to \n§f.jsMacros/"..(type(saveDirectory) == "string" and saveDirectory or ("§eMacros/".. (saveDirectory[1] or ""))))

    local URL_Manager = luajava.bindClass("java.net.URL")
    local Files = luajava.bindClass("java.nio.file.Files")
    local Paths,copyOption = luajava.bindClass("java.nio.file.Paths"), luajava.bindClass("java.nio.file.StandardCopyOption")

    local SavePath = Paths:get(dir..filename, {})

    local saveFile = Reflection:newInstance(
        URL_Manager,
        {url}
    ):openStream()
    
    Files:copy(
        saveFile,
        SavePath,
        {copyOption.REPLACE_EXISTING}
    )

    local file = io.open(dir..filename, "r")  --FS:exists() struggleing with the absolute path?
    if not file then Chat:log("Failed to download file: ".."\n§d"..url) return nil end
    file:close()
   
    return filename
end
