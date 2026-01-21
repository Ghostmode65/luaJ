
LuaJ.addScriptTrigger = function(file,type,event) --config/Macros/
    local Types = {
        ["event"] = "EVENT",
        ["keydown"] = "KEY_RISING",
        ["keyup"] = "KEY_FALLING",

    }

local ScriptTrigger = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger")
local TriggerType = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger$TriggerType")

local dir = io.open(LuaJ.directory.config.macros..file)
if not dir then Chat:log("§cScriptTrigger: Directory does not exist: "..dir) return nil else dir:close() end

local trigger = Reflection:newInstance(
    ScriptTrigger,
    {
        (Types[type] and TriggerType[Types[type]] or TriggerType.EVENT),
        event, --if event is a key then it needs to be the key code key.keyboard.keypad.4
        file,
        true,
        false
    }
)
    JsMacros:getProfile():getRegistry():addScriptTrigger(trigger)
end

LuaJ.removeScriptTrigger = function(filename,ignoreFolder,ignoreLanguage) --Might add some parameters later to remove tiggers with specific events or keys
    if not filename then return nil end
    if not ignoreLanguage and string.sub(filename, #filename - 4, #filename) ~= ".lua" then return nil end

local registry = JsMacros:getProfile():getRegistry()
local tiggers = registry:getScriptTriggers()
    if not tiggers then return nil end

    for i, v in ipairs(tiggers) do
        if (not ignoreFolder and v.scriptFile == filename) or (ignoreFolder and v.scriptFile:match("^.+/(.+)$") == filename) then
            registry:removeScriptTrigger(v)
        end
    end
end


--Example Usage:
    --LuaJ.addScriptTrigger("installer.js","keydown","key.keyboard.keypad.4")