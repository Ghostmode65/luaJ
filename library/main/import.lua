local _Env = {
    Import_Cache = {},
}

Import = {} --The name isn't the best, but you can already do most similar things with lua 

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

Import.download = function(url, saveDirectory) --*.jsMacros/saveDirectory/github filename
    local valid = pcall(function() Request:create(url):get() return true end)
    if not valid then Chat:log("Invalid URL".."\n§d"..url) return nil end

    local dir = LuaJ.directory.roaming[".jsMacros"]..(saveDirectory and saveDirectory or "")
    if not FS:exists(dir) then FS:makeDir(dir) end

    local filename = url:match("^.+/(.+)$") 
    Chat:log("Downloading §d"..filename.."§f to \n§f.jsMacros/"..saveDirectory)

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

    if not FS:exists(dir..filename) then
        Chat:log("Failed to download file: ".."\n§d"..url)
    end

    return filename
end


--Import.download -> improve regex to get filename
