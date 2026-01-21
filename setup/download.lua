if not LuaJ.setup or not LuaJ.setup.github then return nil end

local files = {
    main = {
        import = {url = LuaJ.setup.github.."library/main/import.lua"},
        scripttrigger = {url = LuaJ.setup.github.."library/main/scriptTrigger.lua"},
    },
    sub = {
        roman = {url = LuaJ.setup.github.."library/math/roman.lua", downloadTo = "math/"},
        encode = {url = LuaJ.setup.github.."library/json/encode.lua", downloadTo = "json/"},
        decode = {url = LuaJ.setup.github.."library/json/decode.lua", downloadTo = "json/"},
        serpent = {url = LuaJ.setup.github.."library/table/serpent.lua", downloadTo = "table/"},
        export = {url = LuaJ.setup.github.."library/table/export.lua", downloadTo = "table/"},
    },
    extension = {
        jLoader = {url = LuaJ.setup.github.."extension/jLoader.lua", downloadTo = {}},
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
        pcall(function() Import.download(file.url, "scripts/library/main/",true) end)
    end

    for _, file in pairs(files.sub) do
        pcall(function() Import.download(file.url, "scripts/library/"..file.downloadTo,true) end)
    end

    for _, file in pairs(files.extension) do
        pcall(function() Import.download(file.url, file.downloadTo,true) end)
    end

    for _, v in pairs(LuaJ.setup["External Library"]) do
        if v.folder then
            if v.folder:sub(-1) ~= "/" then v.folder = v.folder .. "/" end
            if v.folder:match("%.lua$") then Chat:log("§cExternal Library: "..tostring(v.folder).. " is not a valid folder name.") return false end
        end
        pcall(function() Import.download(v.url, "scripts/library/"..v.folder,false) end)
    end
end

download()

