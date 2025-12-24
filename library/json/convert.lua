Json = { 
        encode = function(tbl) return Import.url("https://raw.githubusercontent.com/rxi/json.lua/refs/heads/master/json.lua") end,
        decode = function(str) return Import.url("https://raw.githubusercontent.com/rxi/json.lua/refs/heads/master/json.lua") end
    }
--Might need to rename if this interferes with other json libraries