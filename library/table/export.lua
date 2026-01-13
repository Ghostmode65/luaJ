LuaJ.saveTable = function(filename,folder,Table) --.roaming/.JsMacros/
    if not Serpent then return nil end
    if not folder then folder = "" end
        if folder ~= "" and not folder:find("/$") then folder = folder .. "/" end
        folder = LuaJ.directory.roaming[".jsMacros"]..folder
       
        if not filename:match("%.lua$") then filename = filename .. ".lua" end
        local file = folder..filename

    --if disableOverwrite and FS:exists(file) then return false end
    if not FS:exists(file) then FS:createFile(folder,file,true) Client:waitTick() end
        local content = Serpent.dump(Table)
        FS:open(file):write(content)
    return true
end