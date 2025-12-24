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

--need to check if jLoader exists otherwise it throws error
--Remove installer trigger after setup
