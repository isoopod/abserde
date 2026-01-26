-- Services
local ServerScriptService = game:GetService("ServerScriptService")
-- Modules
local Pack = require(script.Parent.roblox_packages.Pack)
local types = require(script.Parent.types)

-- stylua: ignore
local PROJECT = assert(ServerScriptService:FindFirstChild("abserde_project"), "No abserde_project found in ServerScriptService, create one with `abserde init`.") :: types.AbserdeProject

local Schemas = {}

function Schemas.GetLatestSnapshot(schemaName: string): (ModuleScript?, number)
	local snapshots = PROJECT.Schemas.Snapshots:FindFirstChild(schemaName) :: ModuleScript?
	if not snapshots then return nil, 0 end

	local latestVersion = 0
	local latestSnapshot = nil
	for _, version in snapshots:GetChildren() do
		local versionNumber = tonumber(version.Name)
		if versionNumber and versionNumber > latestVersion then
			latestVersion = versionNumber
			latestSnapshot = version :: ModuleScript
		end
	end
	return latestSnapshot, latestVersion
end

-- Creates a schema, used inside Schema files
-- `file` should just be `script`
function Schemas.Schema<T, U>(file: ModuleScript, format: U, encode: ((T) -> U)?, decode: ((U) -> T)?): types._AbserdeSchema<T>
	local schemaName = file.Name
	local _, lastestVersion = Schemas.GetLatestSnapshot(schemaName)
	local schema = Pack:Define(Pack.Transformer(Pack.Struct(format), encode, decode))

	return {
		schema = schema,
		name = schemaName,
		version = lastestVersion + 1,
	}
end

local function requireSchema(module: ModuleScript): types._AbserdeSchema<any>
	local s, schema = pcall(require, module)
	assert(s, `Failed to require schema module: {schema}`)
	return schema
end

-- For decoding older versions
function Schemas.GetSchema(schemaName: string, version: number?): types._AbserdeSchema<any>?
	local latestSnapshot, latestVersion = Schemas.GetLatestSnapshot(schemaName)
	local targetVersion = version or latestVersion
	if not latestSnapshot then return requireSchema(PROJECT.Schemas:FindFirstChild(schemaName)) end
	if latestVersion == targetVersion then return requireSchema(latestSnapshot) end

	local snapshotsFolder: Folder = assert(PROJECT.Schemas.Snapshots:FindFirstChild(schemaName) :: any)
	return requireSchema(snapshotsFolder:FindFirstChild(tostring(version)) :: ModuleScript)
end

return Schemas
