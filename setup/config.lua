local ScriptTrigger = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger")
local TriggerType = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger$TriggerType")

local file = FS:open("unified/loader/jLoader.lua"):getFile()
    if not file then return nil end

local trigger = Reflection:newInstance(
    ScriptTrigger,
    {
        TriggerType.EVENT,
        "LaunchGame",
        file,
        true,
        false
    }
)
JsMacros:getProfile():getRegistry():addScriptTrigger(trigger);

--Remove installer trigger after setup
