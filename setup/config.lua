if LuaJ.setup.user.unbindInstallerJs or LuaJ.setup.user.deleteInstallerJs then
    LuaJ.removeScriptTrigger("installer.js",nil,true)
end

if LuaJ.setup.user.deleteInstallerJs then
    local File = FS:open(JsMacros:getConfig().configFolder:getPath().."/Macros/installer.js"):getFile()
    FS:unlink(File)
end

local hasjLoader = function ()
    local tiggers = JsMacros:getProfile():getRegistry():getScriptTriggers()

    for i,v in pairs(tiggers) do
        if tostring(v.triggerType) == "EVENT" and v.event == "LaunchGame" and v.scriptFile  then
            return true
    end end
end

if not hasjLoader() then LuaJ.addScriptTrigger("jLoader.lua","event","LaunchGame") end

for i,v in pairs(LuaJ.setup["Keybinds"]) do
    if v.url == "" then return nil end

    local filename = Import.download(v.url,"scripts/macros/"..(v.folder or ""))

    if v.folder then
        if v.folder:sub(-1) ~= "/" then v.folder = v.folder .. "/" end
        if v:match("%.lua$") then Chat:log("§cKeybinds: "..tostring(v.folder).. " is not a valid folder name.") return false end
    end

    local dir = "unified/"..(v.folder and (v.folder.."/"..filename) or filename)
    LuaJ.addScriptTrigger(dir,v.event or "keydown",v.key)
end

GlobalVars:remove("LauJConfiguration")