--v0.2.0

--- Roblox Services
local MemoryStoreService = game:GetService('MemoryStoreService')
local DataStoreService = game:GetService('DataStoreService')

--- Custom Modules
local ModuleFunctions = require(script.MatchmakingFunctions)
local Util = require(script.Util)


local SimpleMatchmaking = {}
SimpleMatchmaking.__index = SimpleMatchmaking

-- main
function SimpleMatchmaking:GetQueue(name:string, options:{matchPlaceId: number, numberOfTeams: number, maxPlayersPerTeam: number, matchExpirationTime: number})
	if not options then error("Missing options.") end
	
	local self = {}
	setmetatable(self, ModuleFunctions)

	self.Name = name
	self.Queue = MemoryStoreService:GetSortedMap(name)
	self.Options = options

	return self
end

function SimpleMatchmaking:NewOptions()
	local NewOptions = {}

	NewOptions.MatchPlaceId = 0
	NewOptions.NumberOfTeams = 1
	NewOptions.MaxPlayersPerTeam = 1
	NewOptions.MatchExpirationTime = 600
	NewOptions.UseCustomTeleporting = true

	return NewOptions
end

return SimpleMatchmaking
