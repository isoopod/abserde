-- Services
local ServerScriptService = game:GetService("ServerScriptService")
-- Modules
local Pack = require(script.roblox_packages.Pack)

local PROJECT = assert(ServerScriptService:FindFirstChild("abserde_project"), "No abserde_project found in ServerScriptService, create one with `abserde init`.")

local Abserde = {}

Abserde.Pack = Pack :: Pack.Datatypes

function Abserde.Schema<T, U>(file: ModuleScript, format: U, encode: ((T) -> U)?, decode: ((U) -> T)?)
	local schemaName = file.Name
	local lastVersion
	local schema = Pack:Define(Pack.Transformer(Pack.Struct(format), encode, decode))
end

return Abserde
