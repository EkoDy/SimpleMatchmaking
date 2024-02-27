local TeleportService = game:GetService('TeleportService')
local RunService = game:GetService('RunService')

local Util = {}

function Util:CompileDefaultServer(matchmakingOptions, matchCredentials)
	local newServer = {}
	newServer.Teams = {}
	newServer.Credentials = matchCredentials

	for i = 1, matchmakingOptions.NumberOfTeams do
		newServer.Teams["t"..tostring(i)] = {}
	end

	return newServer
end


function Util:TeleportPlayers(matchPlaceId: number, players: {Instance}, accessCode)
	if RunService:IsStudio() then return true, "studio" end
	
	local debounce = 0
	local success, result
	
	local teleportOptions = Instance.new('TeleportOptions')
	teleportOptions.ReservedServerAccessCode = accessCode
	
	for i = 1, 5 do
		success, result = pcall(function()
			return TeleportService:TeleportAsync(matchPlaceId, players, teleportOptions)
		end)
		
		if not success then
			debounce += 1
			task.wait(debounce)
		end
	end
	
	return success, result
end


function Util:AddPlayersToMatch(serverData, players: {Instance}, options)
	if not players or #players == 0 then error("No players given.") end	
	
	local newServerData = serverData
	local success = false
	
	for i, v in newServerData.Teams do
		if #v + #players > options.MaxPlayersPerTeam then
			continue
		end
		
		for x, y in players do
			table.insert(newServerData.Teams[i], y.UserId)
		end
		
		success = true
		break
	end
	
	return success, newServerData
end


function Util:IsPlayerInMatch(player: Player, serverData)
	local isInMatch = false
	local teamChecked = nil
	
	for i, v in serverData.Teams do
		for x, y in v do
			if y ~= player.UserId then
				continue
			end
			
			isInMatch = true
			teamChecked = i
			break
		end
	end
	
	return isInMatch, teamChecked
end

return Util
