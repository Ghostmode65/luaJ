local directory = {}

directory.getRoaming = function()
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

local _jsMacros = directory.getRoaming().."/.jsMacros/"

directory.setupFolders = function()
        local directory = { --/roaming/.jsmacros/
            scripts = {
                library = {},
                extensions = {},
                macros = {},
            },
            logs = {},
            assets = {},
            settings = {},
            config = "config.lua",
        }

    local function makeDirectories(dir, basePath)
        basePath = basePath or ""
        for key, value in pairs(dir) do
            if type(value) == "table" then
                local newPath = basePath..key.."/"
                if not FS:exists(_jsMacros..newPath) then FS:makeDir(_jsMacros..newPath) end
                makeDirectories(value, newPath)
            end
            if type(value) == "string" then
                local filePath = _jsMacros .. basePath .. value
                if not FS:exists(filePath) then FS:createFile(_jsMacros..basePath,value ,true) end
                end
        end
    end

    makeDirectories(directory)
end

directory.unfiyFolder = function (delete)
        local instancePath = JsMacros:getConfig().configFolder:getPath().."/macros/unified"
        local unifyPath = _jsMacros.."scripts/macros"

    local Runtime = luajava.bindClass("java.lang.Runtime");
    local File = luajava.bindClass("java.io.File");

    local junctionDir = Reflection:newInstance(
        File,
            {instancePath}
    )
    if junctionDir:exists() and delete then junctionDir:delete() else return true end

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

local status, err = pcall(directory.getRoaming)
if not status then Chat:log("§cError getting roaming path") end

local status, err = pcall(directory.setupFolders)
if not status then Chat:log("§cError setting up folders") end

local status, err = pcall(directory.unfiyFolder)
if not status then Chat:log("§cError unifying folders") end