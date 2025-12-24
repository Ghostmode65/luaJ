


local github = LuaJ.github or nil
if not github then return end

local dir = "scripts/"

local files = {
    main = {
        import = {url = github.."/library/main/import.lua", downloadTo = dir.."library/main/"},
    },
    sub = {
        roman = {url = github.."/library/math/roman.lua", downloadTo = dir.."library/math/"},
    },
    extension = {
        defaultLibrary = {url = github.."/extension/defaultLibrary.lua", downloadTo = dir.."extensions/"},
        jLoader = {url = github.."/extension/jLoader.lua", downloadTo = dir.."extensions/"},
    },
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

local function download()
    for _, file in pairs(files.main) do
        Import.download(file.url, file.downloadTo)
    end

    for _, file in pairs(files.sub) do
        Import.download(file.url, file.downloadTo)
    end

    for _, file in pairs(files.extension) do
        Import.download(file.url, file.downloadTo)
    end
    
end

download()

--Might add a check to see if files exist before downloading, but for now if you want to override my global try a different fucken name