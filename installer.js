//Installer settings for anyone
const user = {
    unbindInstallerJs: true, //Unbind installer.js after install
    deleteInstallerJs: false, //Delete installer.js after install
};


//Installer settings for developers
const lua = {
    url: "https://github.com/JsMacros/JsMacros-Lua/releases/download/1.2.2/",
    version: "jsmacros-lua-1.2.2.jar",
    
};

const dev = {
    github: "https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/tags/v1.2.1/", //If your forking Change this to your github raw url

    ExternalLibraries: [//Add the libraries or scripts you want to download and execute automatically here 
        //"https://raw.github.com/example/repo/path/to/file.lua"
    ],

    keybinds: {
        //example: {filepath: "installer.js", event: "keydown", key: "keyboard.key.4" },
    },
};

//Installer
const Installer = {};

Installer.runLuaJSetup = () => { 
    try {
        JsMacros.runScript('lua', 'load(Request:create("' + dev.github + 'setup/jSetup.lua"):get():text())()'); 
    }   catch (error) {
        Chat.log("§dError Running lua setup");
    }
}

Installer.editConfig = () => {
    const configFile = JsMacros.getConfig().configFolder.getPath() + "\\options.json";
    let configContent = FS.open(configFile).read();
    let config = JSON.parse(configContent);
    
    // Check if useGlobalContext is false and set it to true
    if (config.lua && config.lua.useGlobalContext === false) {
        Chat.log("Set useGlobalContext to §etrue");
        config.lua.useGlobalContext = true;
    
        const updatedContent = JSON.stringify(config, null, 2);
        FS.open(configFile).write(updatedContent);
    
        return true;
    }
    return false;
}

Installer.lua = () => { //Downloads lua if not installed
    const dir = JsMacros.getConfig().configFolder.getPath() + "\\LanguageExtensions\\"; 
    const file = dir + lua.version; 

    if (!FS.exists(file)) { 
        try {
            FS.makeDir(dir);
            const URL = Java.type("java.net.URL");
            Java.type("java.nio.file.Files").copy(
                new URL(lua.url + lua.version).openStream(),
                Java.type("java.nio.file.Paths").get(file),
                Java.type("java.nio.file.StandardCopyOption").REPLACE_EXISTING
            );
            Chat.log("§dFile downloaded successfully to " + file); 
            Chat.actionbar("§dGoing to Restart game in 10 seconds, relaunch after exit");
                Client.waitTick(200);
                Client.exitGamePeacefully();
            return false;
            
        } catch (error) {
            Chat.log("§dError downloading file: " + error);
        }
    } else {
        // Lua is installed
        try {
            JsMacros.runScript('lua', 'Chat:actionbar("§dLua Extension Loaded")'); 
            return true;
        } catch (error) {
            Chat.log("§dError loading lua: " + error);
            return false;
        }
    }
    return true;
};

Installer.LuaJConfiguration = () => {
    const HashMap = Java.type("java.util.HashMap");
    const ArrayList = Java.type("java.util.ArrayList");

    let keybindsList = new ArrayList();
    for (let name in dev.keybinds) {
        let bindMap = new HashMap();
        bindMap.put("name", name);
        Object.entries(dev.keybinds[name]).forEach(([k, v]) => bindMap.put(k, v));
        keybindsList.add(bindMap);
    }

    let userMap = new HashMap();
    userMap.put("unbindInstallerJs", user.unbindInstallerJs);
    userMap.put("deleteInstallerJs", user.deleteInstallerJs);

    let libs = new ArrayList();
    dev.ExternalLibraries.forEach(lib => libs.add(lib));

    let map = new HashMap();
    map.put("github", dev.github);
    map.put("libs", libs);
    map.put("keybinds", keybindsList);
    map.put("user", userMap);

    GlobalVars.putObject("LuaJConfiguration", map);
};

if (Installer.lua()) {
    Installer.editConfig();
    Installer.LuaJConfiguration();
    Installer.runLuaJSetup()
}
  
   
