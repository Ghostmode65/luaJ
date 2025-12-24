local ScriptTrigger = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger")
local TriggerType = Reflection:getClass("xyz.wagyourtail.jsmacros.core.config.ScriptTrigger$TriggerType")

local trigger = Reflection:newInstance(
    ScriptTrigger,
    {
        TriggerType.event,
        "LaunchGame",
        FS:open("unified/loader/jLoader.lua"):getFile(),
        true,
        false
    }
)
JsMacros:getProfile():getRegistry():addScriptTrigger(trigger);


--Remove installer trigger after setup