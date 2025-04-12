-- // Dependencies
local fs = require("@lune/fs")
local serde = require("@lune/serde")

-- // Load and parse the `pesde.toml` file
local function loadPesde(path: string)
    -- // Ensure the path exists
    assert(fs.isFile(path), `could not find pesde file at {path}`)

    -- // Decode from TOML and ensure the configuration key exists
    local pesde_text = fs.readFile(path):gsub("%[%s*%]", "\"EMPTY_ARRAY\"")
    local pesde = serde.decode("toml", pesde_text)
    assert(typeof(pesde.configuration) == "table", `invalid pesde configuration found for {path} (expected table, got {typeof(pesde)})`)
    return pesde
end

-- // Creates the configuration file from the TOML representation
local defaultFileTypes = {
    luaurc = "json",
    json = "json",
    toml = "toml",
    yaml = "yaml",
}
local function createConfigFile(name: string, data: any)
    -- // Ensure we know where to output the file
    local output_file: string = data.pesde_config_file
    assert(typeof(output_file) == "string", `invalid pesde_config_file found for {name} (expected string, got {typeof(output_file)})`)
    data.pesde_config_file = nil

    -- // Resolve the file type
    local file_type_split = output_file:split(".")
    local file_type = file_type_split[#file_type_split]

    -- // Custom logic to allow custom file types. If custom, `data` property must be passed.
    local encoded
    if defaultFileTypes[file_type] then
        -- // Simply output the encoded repr
        local encode_type = defaultFileTypes[file_type]
        encoded = serde.encode(encode_type, data, true)
    else
        -- // Assume it's like an ignore file or something
        encoded = data.data
        assert(typeof(encoded) == "string", `invalid data found for {name}, assuming is misc file (expected string, got {typeof(encoded)})`)
    end

    -- // Write the file
    encoded = encoded:gsub("\"EMPTY_ARRAY\"", "[]")
    fs.writeFile(output_file, encoded)
end

return {
    loadPesde = loadPesde,
    createConfigFile = createConfigFile
}
