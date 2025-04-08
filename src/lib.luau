-- // Dependencies
local fs = require("@lune/fs")
local serde = require("@lune/serde")

-- // Load and parse the `pesde.toml` file
local function loadPesde(path: string)
    -- // Ensure the path exists
    assert(fs.isFile(path), `could not find pesde file at {path}`)

    -- // Decode from TOML and ensure the configuration key exists
    local pesde = serde.decode("toml", fs.readFile(path))
    assert(typeof(pesde.configuration) == "table", `invalid pesde configuration found (expected table, got {typeof(pesde)})`)
    return pesde
end

-- // Creates the configuration file from the TOML representation
local function createConfigFile(name: string, data: any)
    -- // Ensure we know where to output the file
    local output_file: string = data.pesde_config_file
    assert(typeof(output_file) == "string", `invalid pesde_config_file found (expected string, got {typeof(output_file)})`)

    -- // Resolve the file type
    local file_type_split = output_file:split(".")
    local file_type = file_type_split[#file_type_split]

    -- // Output the final file
    local encoded = serde.encode(file_type :: any, data, true)
    fs.writeFile(output_file, encoded)
end

return {
    loadPesde = loadPesde,
    createConfigFile = createConfigFile
}
