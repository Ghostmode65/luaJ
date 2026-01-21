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
    local filename = v.url and v.url:match("([^/]+)$") or v.name
 
    if v.url then filename = Import.download() end

    local dir = v.filepath and (v.filepath.."/"..filename) or filename
    LuaJ.addScriptTrigger(dir,v.event or "keydown",v.key)
end

GlobalVars:remove("LauJConfiguration")