# Luaj

Easily setup up Lua with 1 script no matter the instance.

| ✅ | Features |
|---|---|
| ☑️ | Auto installs the lua extension for JsMacros |
| ☑️ | Turns on Shared Global Context |
| ☑️ | Creates one shared folder, all your scripts will be available on feather, lunar, prism, vanilla, and more. |
| ☑️ | Executes libraries and globals on game launch |


| Default Library | Functions | Info |
|-----------------|-----------|------|
| **Import** | `download(url, saveDirectory)`<br>`file(path, cache)`<br>`url(url, cache)` |`Import.file` and `Import.url` execute the script<br>Similar to `loadstring(Http)()` |
| **Json** | `encode(table)`<br>`decode(string)` | `encode` returns a string<br>`decode` returns a table |
| **Math (Roman Numerals)** | `math.roman.ToRoman(number)`<br>`math.roman.ToNumber(string)` |  |

**Shared folder**  
Shared folder is created in `roaming/.jsMacros/`
It will show up in your macro folder as `unified` 

**⚠️This is still in development**     
• This does not work on linux (yet)
• useGlobalContext does not always save in the config
