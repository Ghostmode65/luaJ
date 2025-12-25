# Luaj

| ✅ | Features |
|---|---|
| ☑️ | Auto installs the lua extension for JsMacros |
| ☑️ | Creates one shared folder for all launchers, all your scripts will be available on feather, lunar, prism, vanilla, and more. |
| ☑️ | Loads libraries and globals on game launch |


| Default Library | Functions | Info |
|-----------------|-----------|------|
| **Import** | `download(url, saveDirectory)`<br>`file(path, cache)`<br>`url(url, cache)` |`Import.file` and `Import.url` execute the script<br>Similar to `loadstring(Http)()` |
| **Json** | `encode(table)`<br>`decode(string)` | `encode` returns a string<br>`decode` returns a table |
| **Math (Roman Numerals)** | `roman.ToRoman(number)`<br>`roman.ToNumber(string)` |  |

Shared folder is created in `roaming/.jsMacros/`
It will show up in your macro folder as `unified` 


**⚠️This is still in development**     
• This does not work on linux (yet)
