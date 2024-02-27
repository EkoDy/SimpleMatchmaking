--- Roblox Services
local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')
local MemoryStoreService = game:GetService('MemoryStoreService')
local RunService = game:GetService('RunService')

--- Custom Modules
local Util = require(script.Parent.Util)

--- Misc Variables
local readServer = nil
local isReading = false

local MatchmakingFunctions = {}
MatchmakingFunctions.__index = MatchmakingFunctions


--- Core Functions ---
function MatchmakingFunctions:AddAsync(matchCredentials, players:{Instance}?)
	local queue = self.Queue
	local options = self.Options
	local expirationTime = options.MatchExpirationTime
	
	local numberOfTeams = options.NumberOfTeams
	local maxPlayersPerTeam = options.MaxPlayersPerTeam
	local matchmakingEndedEvent = options.matchmakingEndedEvent
	
	local newServer = Util:CompileDefaultServer(self.Options, matchCredentials)
	local playersInMatch = 0
	
	local success, serverData
	if players and #players > 0 then
		success, serverData = Util:AddPlayersToMatch(newServer, players, options)
		
		playersInMatch += #players
	end
	
	
	local aSuccess, NewData, playersInMatch = queue:UpdateAsync(matchCredentials.matchId, function(oldData)
		local returnData = HttpService:JSONEncode(serverData)
		return returnData, playersInMatch
	end, expirationTime)
	
	return aSuccess, NewData, playersInMatch
end


function MatchmakingFunctions:ReadAsync(matchId)
	local queue = self.Queue
	local options = self.Options
	local expirationTime = options.MatchExpirationTime
	local newData, playersInMatch
	
	local gSuccess, gResult, playerCount = pcall(function()
		return queue:UpdateAsync(matchId, function(oldData, oldPlayerCount)
			newData = HttpService:JSONDecode(oldData)
			playersInMatch = oldPlayerCount
			
			return nil
		end, expirationTime)
	end)
	
	return gSuccess, newData, playersInMatch
end


function MatchmakingFunctions:UpdateAsync(matchId, players:{Instance})
	--- Variables
	local queue = self.Queue
	local options = self.Options
	local maxPlayersPerTeam = options.MaxPlayersPerTeam
	local numberOfTeams = options.NumberOfTeams
	local expirationTime = options.MatchExpirationTime
	local returnedData
	
	--- Add players to the match
	local uSuccess, uData, playerCount = pcall(function()
		return queue:UpdateAsync(matchId, function(oldData, oldPlayerCount)

			if not oldData or (oldPlayerCount + #players) > (maxPlayersPerTeam * numberOfTeams) then
				return nil, oldPlayerCount
			end

			local data = HttpService:JSONDecode(oldData)

			local success, newData = Util:AddPlayersToMatch(data, players, options)

			if not success then
				return nil
			end

			returnedData = newData
			local encodedData = HttpService:JSONEncode(newData)
			local newPlayerCount = oldPlayerCount + #players

			return encodedData, newPlayerCount
		end, expirationTime)
	end)
		
	return uSuccess, returnedData, playerCount
end


function MatchmakingFunctions:RemoveAsync(matchId: string)
	local queue = self.Queue

	local success, result
	local debounce = 0
	
	repeat
		task.wait(debounce)
		
		success, result = pcall(function()
			queue:RemoveAsync(matchId)
		end)
		
		debounce += 1
	until success
	
	return success, result
end


function MatchmakingFunctions:GetRangeAsync()
	local queue = self.Queue
	local success, result
	local debounce = 0

	for i = 1, 5 do
		task.wait(debounce)
		
		success, result = pcall(function()
			return queue:GetRangeAsync(Enum.SortDirection.Descending, 10)
		end)
		
		if success and result then break end
		debounce += 1
	end
	
	return success, result
end


--- Custom Functions ---
function MatchmakingFunctions:CreateMatchAsync(players: {Instance}?): {}
	local matchPlaceId = self.Options.MatchPlaceId
	
	local accessCode, matchId = TeleportService:ReserveServer(matchPlaceId)
	local credentials = {matchId = matchId, accessCode = accessCode}
	
	local aSuccess, aResult = self:AddAsync(credentials, players)
	
	return credentials
end


function MatchmakingFunctions:QueuePlayers(players:{Instance})
	if not players or #players == 0 then error("No players to be queued") end
	
	local options = self.Options
	
	local gSuccess, gResult = self:GetRangeAsync()
	
	
	if gSuccess and gResult and #gResult > 0 then
		for i, v in gResult do
			local uSuccess, uData = self:UpdateAsync(v.key, players)

			if not uSuccess or not uData then
				continue
			end
			
			Util:TeleportPlayers(options.MatchPlaceId, players, uData.Credentials.accessCode)
			return uSuccess, uData.Credentials
		end
	end
	
	local credentials = self:CreateMatchAsync(players)

	if not credentials or not credentials.accessCode then
		return false, nil
	end
	
	Util:TeleportPlayers(options.MatchPlaceId, players, credentials.accessCode)
	return true, credentials
end


function MatchmakingFunctions:CheckPlayerTeam(player: Player)
	local matchId = game.PrivateServerId
	
	local rSuccess, rData
	local isInMatch, team = false, nil
	
	if not readServer then
		rSuccess, readServer = self:ReadAsync(matchId)
	end
	
	for i = 1, 2 do
		repeat task.wait() until not isReading
		
		isInMatch, team = Util:IsPlayerInMatch(player, readServer)
		
		if isInMatch or i >= 2 then
			return isInMatch, team
		end
		
		if isReading then
			continue
		end
		
		isReading = true
		rSuccess, readServer = self:ReadAsync(matchId)
		isReading = false
	end
end


return MatchmakingFunctions
