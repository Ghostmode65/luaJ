LuaJ.saveTable = function(filepath,Table) --.roaming/.JsMacros/
    if not Serpent then return nil end

    local folder = LuaJ.directory.roaming[".jsMacros"]..(filepath:match("(.*/)") or "")
        
    if not filepath:match("%.lua$") then filepath = filepath .. ".lua" end
    local file = LuaJ.directory.roaming[".jsMacros"]..filepath
        
    --if disableOverwrite and FS:exists(file) then return false end
    if not FS:exists(file) then FS:createFile(folder,file,true) Client:waitTick() end
        local content = Serpent.dump(Table)
        FS:open(file):write(content)
    return true
end

