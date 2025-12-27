local github = LuaJ.github or nil --https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/heads/main/
if not github then return end

local files = {
    main = {
        import = {url = github.."library/main/import.lua", downloadTo = "scripts/".."library/main/"},
    },
    sub = {
        roman = {url = github.."library/math/roman.lua", downloadTo = "scripts/".."library/math/"},
        json = {url = github.."library/json/convert.lua", downloadTo = "scripts/".."library/json/"},
    },
    extension = {
        jLoader = {url = github.."extension/jLoader.lua", downloadTo = "scripts/".."macros/loader/"},
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
        pcall(function() Import.download(file.url, file.downloadTo) end)
    end

    for _, file in pairs(files.sub) do
        pcall(function() Import.download(file.url, file.downloadTo) end)
    end

    for _, file in pairs(files.extension) do
        pcall(function() Import.download(file.url, file.downloadTo) end)
    end

    for _, url in pairs(LuaJ["External Library"]) do
        pcall(function() Import.download(url, "scripts/".."library/custom/") end)
    end
end

download()

--might need to add a status check on pcalls (should fail in import)
--Might add better checks to see if files exist before downloading
    --only checks if jloader is installed or not