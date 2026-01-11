local directory = {}
local _jsMacros = LuaJ.directory.roaming[".jsMacros"]

directory.setupFolders = function()
    local dirc = { --/roaming/.jsmacros/
        scripts = {
            library = {},
            extensions = {},
            macros = {},
            plugins = {},
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
    makeDirectories(dirc)
end



local status, err = pcall(directory.setupFolders)
if not status then Chat:log("§cError setting up folders") end

