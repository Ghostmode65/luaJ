
--need to set lua option to global
    --could try to edit JsMacros:getConfig().options
    ---might need to do it in js
    ---edit the config file in table from the json directly




local urls = {
    paths = "https://raw.githubusercontent.com/Ghostmode65/mclib/refs/heads/main/luaj/library/main/paths.lua",
    import = "https://raw.githubusercontent.com/Ghostmode65/mclib/refs/heads/main/luaj/library/main/import.lua",
}

for key, url in pairs(urls) do
local success, result = pcall(function()
        local script = load(Request:create(url):get():text())
            return script and script() or nil
        end)
    if not success then Chat:log("§cUrl failed to load: ".."\n§d"..url) return nil end
end

--Import.download() the main library files from github
--Make a table of files to download and their paths
--Check if they exist, if not download them