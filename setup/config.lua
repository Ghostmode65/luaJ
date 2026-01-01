if GlobalVars:getBoolean("unbindInstallerJs") or GlobalVars:getBoolean("deleteInstallerJs") then
    LuaJ.removeScriptTrigger("installer.js",nil,true)
    GlobalVars:remove("unbindInstallerJs")
end

if GlobalVars:getBoolean("deleteInstallerJs") then
    local File = FS:open(JsMacros:getConfig().configFolder:getPath().."/Macros/installer.js"):getFile()
    FS:unlink(File)
    GlobalVars:remove("deleteInstallerJs")
end

LuaJ.addScriptTrigger("jLoader.lua","event","LaunchGame")

for i,v in ipairs(LuaJ.setup["Keybinds"]) do
    local filename = v.url and v.url:match("([^/]+)$") or v.filename
    if v.url == "" then return nil end
    if v.url then filename = Import.download() end

    local dir = LuaJ.directory.roaming.macros..(v.folder and (v.folder.."/"..filename) or filename)
    LuaJ.addScriptTrigger(dir,"keydown",v.keybind)
end