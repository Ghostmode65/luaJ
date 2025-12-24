
--need to set lua option to global
    --could try to edit JsMacros:getConfig().options
    ---might need to do it in js
    ---edit the config file in table from the json directly

local github = LuaJ.github or nil
if not github then return end

local files = {
    main = {
        import = {url = github.."/library/main/import.lua", downloadTo = "scripts/library/main/"},
        directory = {url = github.."library/main/import.lua", downloadTo = "scripts/library/main/"},
    },
    sub = {
        roman = {url = github.."/library/math/roman.lua", downloadTo = "scripts/library/math/"},
    }
}

local function load_mainLibrary()
    for _, file in pairs(files.main) do
    local success, result = pcall(function()
            local script = load(Request:create(file.url):get():text())
                return script and script() or nil
            end)
        if not success then Chat:log("§cUrl failed to load: ".."\n§d"..file.url) return nil end
    end
end


load_mainLibrary()
if not Import then return nil end

local function download_Library()
    for _, file in pairs(files.main) do
        Import.download(file.url, file.downloadTo)
    end

    for _, file in pairs(files.sub) do
        Import.download(file.url, file.downloadTo)
    end
end

--add extension to load default library

--Might add a check to see if files exist before downloading, but for now if you want to override my global try a different fucken name