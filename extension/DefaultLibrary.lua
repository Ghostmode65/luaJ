local dir = LuaJ.getRoaming()..".jsMacros/scripts/library/"

local library = {
    main ={
        import = {file = "import.lua"},
    },
        sub = {
            math = {file = "math.lua",folder = "math"},
            json = {file = "default.lua", folder = "json"}
        }
  
}

local function loadMain()
    for _,v in pairs(library.main) do
        local success, err = pcall(dofile,dir..v.file)
            if not success then Chat:log("Error loading library: " .."\n§d"..v.file) end
    end
end

local function loadSub()
    for _,v in pairs(library.main.sub) do
        local success, err = pcall(dofile,dir.. v.folder .. "/"..v.file)
            if not success then Chat:log("Error loading library: " .."\n§d"..v.file) end 
    end
end


loadMain()
loadSub()