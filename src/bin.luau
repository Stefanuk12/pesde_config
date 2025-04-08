-- // Dependencies
local process = require("@lune/process")
local lib = require("./lib")

-- // Load the configuration and create the individual files
local pesde_path = process.args[1] or "pesde.toml"
local pesde = lib.loadPesde(pesde_path)
for i, v in pesde.configuration do
    lib.createConfigFile(i, v)
end
