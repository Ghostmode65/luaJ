if LuaJ.setut.user.unbindInstallerJs or LuaJ.setup.user.deleteInstallerJs then
    LuaJ.removeScriptTrigger("installer.js",nil,true)
end

if LuaJ.setut.user.unbindInstallerJs then
    local File = FS:open(JsMacros:getConfig().configFolder:getPath().."/Macros/installer.js"):getFile()
    FS:unlink(File)
end

LuaJ.addScriptTrigger("jLoader.lua","event","LaunchGame")

for i,v in ipairs(LuaJ.setup["Keybinds"]) do
    local filename = v.url and v.url:match("([^/]+)$") or v.filename
    if v.url == "" then return nil end
    if v.url then filename = Import.download() end

    local dir = LuaJ.directory.roaming.macros..(v.folder and (v.folder.."/"..filename) or filename)
    LuaJ.addScriptTrigger(dir,"keydown",v.keybind)
end

GlobalVars.remove("LauJConfiguration")