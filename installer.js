//Installer config
const lua = "https://github.com/JsMacros/JsMacros-Lua/releases/download/1.2.2/jsmacros-lua-1.2.2.jar"; //latest version
const LauJ = "https://raw.githubusercontent.com/Ghostmode65/luaJ/refs/tags/v1.1.0/setup/jSetup.lua"; //luaJ setup

//Installer options
const unbindInstallerJs = true; //Unbind installer.js after install
const deleteInstallerJs = false; //Delete installer.js after install

//Installer
const Installer = {};
Installer.runLuaSetup = () => { 
    try {
        JsMacros.runScript('lua', 'load(Request:create(' + LauJ + ')):get():text())()'); 
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
    const file = dir + lua; 

    if (!FS.exists(file)) { 
        try {
            FS.makeDir(dir);
            const URL = Java.type("java.net.URL");
            Java.type("java.nio.file.Files").copy(
                new URL(lua).openStream(),
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

if (Installer.lua()) {
    Installer.editConfig();
        GlobalVars.putBoolean("unbindInstallerJs",unbindInstallerJs);
        GlobalVars.putBoolean("deleteInstallerJs", deleteInstallerJs);
    Installer.runLuaSetup()
}
  
   
