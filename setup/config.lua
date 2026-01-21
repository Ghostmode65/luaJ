if LuaJ.setup.user.unbindInstallerJs or LuaJ.setup.user.deleteInstallerJs then
    LuaJ.removeScriptTrigger("installer.js",nil,true)
end

if LuaJ.setup.user.deleteInstallerJs then
    local File = FS:open(JsMacros:getConfig().configFolder:getPath().."/Macros/installer.js"):getFile()
    FS:unlink(File)
end

LuaJ.addScriptTrigger("jLoader.lua","event","LaunchGame")

for i,v in ipairs(LuaJ.setup["Keybinds"]) do
    if v.url == "" then return nil end

    local filename = v.name or nil
    if not filename and v.url then filename = Import.download() end

    if v.folder then
        if v.folder:sub(-1) ~= "/" then v.folder = v.folder .. "/" end
        if v:match("%.lua$") then Chat:log("§cKeybinds: "..tostring(v.folder).. " is not a valid folder name.") return false end
    end

    local dir = v.filepath and (v.folder.."/"..filename) or filename
    LuaJ.addScriptTrigger(dir,v.event or "keydown",v.key)
end

GlobalVars:remove("LauJConfiguration")