local theaters 					= {};
local enterTheaterMarkers 		= {};

local dimensions 				= 1

function createTheater(theaterType, name, friendlyName, playersLimit, enterPosition, exitPosition, screenPosition, spawnPosition, seats, previewPosition)
	if (not theaters[name]) then
		theaters[name] 				= {};
		local cPosition 			= config.cinema.position;
		
		theaters[name].type						= theaterType;
		theaters[name].name 					= name;
		theaters[name].friendlyName 			= friendlyName;
		theaters[name].dimension				= 0;
		theaters[name].playersLimit			= playersLimit;
		theaters[name].enterMarker 			= alw7shMarker(cPosition[1]+enterPosition[1], cPosition[2]+enterPosition[2], cPosition[3]+enterPosition[3], enterPosition[4]);
		enterTheaterMarkers[theaters[name].enterMarker] = name;
		theaters[name].exitMarker 			= alw7shMarker(cPosition[1]+exitPosition[1], cPosition[2]+exitPosition[2], cPosition[3]+exitPosition[3], exitPosition[4]);
		--setElementDimension(theaters[name].exitMarker, theaters[name].dimension);
		
		--1562
		
		theaters[name].screenPosition		= screenPosition;
		theaters[name].screenPosition[1] 	= cPosition[1] + theaters[name].screenPosition[1];
		theaters[name].screenPosition[2] 	= cPosition[2] + theaters[name].screenPosition[2];
		theaters[name].screenPosition[3] 	= cPosition[3] + theaters[name].screenPosition[3];
		theaters[name].screenPosition[4] 	= cPosition[1] + theaters[name].screenPosition[4];
		theaters[name].screenPosition[5] 	= cPosition[2] + theaters[name].screenPosition[5];
		theaters[name].screenPosition[6] 	= cPosition[3] + theaters[name].screenPosition[6];
		theaters[name].screenPosition[8]	= theaters[name].screenPosition[8] and cPosition[1] + theaters[name].screenPosition[8] or theaters[name].screenPosition[1];
		theaters[name].screenPosition[9]	= theaters[name].screenPosition[9] and cPosition[2] + theaters[name].screenPosition[9] or 0;
		theaters[name].screenPosition[10]	= theaters[name].screenPosition[10] and cPosition[3] + theaters[name].screenPosition[10] or theaters[name].screenPosition[3];
		theaters[name].previewPosition		= previewPosition;
		theaters[name].previewPosition[1] 	= cPosition[1] + theaters[name].previewPosition[1];
		theaters[name].previewPosition[2] 	= cPosition[2] + theaters[name].previewPosition[2];
		theaters[name].previewPosition[3] 	= cPosition[3] + theaters[name].previewPosition[3];
		theaters[name].previewPosition[4] 	= cPosition[1] + theaters[name].previewPosition[4];
		theaters[name].previewPosition[5] 	= cPosition[2] + theaters[name].previewPosition[5];
		theaters[name].previewPosition[6] 	= cPosition[3] + theaters[name].previewPosition[6];
		theaters[name].previewPosition[8] 	= cPosition[1] + theaters[name].previewPosition[8];
		theaters[name].previewPosition[9] 	= cPosition[2] + theaters[name].previewPosition[9];
		theaters[name].previewPosition[10] 	= cPosition[3] + theaters[name].previewPosition[10];
		theaters[name].spawnPosition		= spawnPosition;
		theaters[name].queue				= {};
		theaters[name].videoVotes			= {};
		theaters[name].currentVideo			= nil;
		theaters[name].playingTimer			= nil;
		
		return name;
	end
	return false;
end

function outputTheaterChat(str, theater, r, g, b, color)
	if (theater and theaters[theater]) then
		for k,v in ipairs(getTheaterPlayers(theater)) do
			outputChatBox(str, v, r, g, b, color);
		end
	end
end

function sendThumbnails(player)
	local thumbnails = {};
	for theater,data in pairs(theaters) do
		if (data.previewPosition) then
			if (isVideoPlaying(theater)) then
				table.insert(thumbnails, {url=data.currentVideo.thumbnail, title=data.currentVideo.title, theaterName=theater, friendlyName=data.friendlyName})
			else
				table.insert(thumbnails, {url="", theaterName=theater, friendlyName=data.friendlyName})
			end
		end
	end
	triggerClientEvent(player, "downloadThumbnail", player, thumbnails);
end

function getTheaterPlayers(theater)
	if (theaters[theater]) then
		local players = {};
		for k,v in ipairs(getElementsByType("player")) do
			local plrTheater = getElementData(v, "theater");
			if (plrTheater and plrTheater.name == theater) then
				table.insert(players, v);
			end
		end
		return players;
	end
	return false;
end

function getLobbyPlayers()
	local players = {};
	for k,v in ipairs(getElementsByType("player")) do
		if (not getElementData(v, "theater")) then
			table.insert(players, v);
		end
	end
	return players;
end

function isVideoPlaying(theater)
	return theaters[theater].currentVideo and true or false;
end

function getVideoTimeLeft(theater)
	if (isVideoPlaying(theater)) then
		return math.ceil( ((theaters[theater].currentVideo.duration*1000)-getTimerDetails(theaters[theater].playingTimer)+3000)/1000 )
	end
	return false;
end

function resetTheater(theaterName, player)
	local theater = theaters[theaterName];
	
	theater.queue = {}
	triggerClientEvent(getTheaterPlayers(theaterName), "updateQueue", resourceRoot, theater.queue);
	
	if (isVideoPlaying(theaterName)) then
		videoEnds(theaterName);
	end
	
	outputTheaterChat(config.theaterText.."The theater has been reset by " .. getPlayerName(player), theaterName, 255, 255, 255, true);
end

function videoSeek(theaterName, t, player)
	local t = math.ceil(t);
	local player = isElement(player) and player or nil;
	local theater = theaters[theaterName];
	if (isVideoPlaying(theaterName)) then
		if (t > 0 and t < theater.currentVideo.duration-5) then
			killTimer(theater.playingTimer)
			theater.playingTimer = setTimer(videoEnds, ((theater.currentVideo.duration-t)*1000)+3000, 1, theaterName);
			
			triggerClientEvent(getTheaterPlayers(theaterName), "playVideo", resourceRoot, theater.currentVideo.service, theater.currentVideo.url, t);
		else
			if (player) then
				outputChatBox(config.theaterText.."Invalid time.", player, 255, 255, 255, true);
			end
		end
	end
end

function voteVideo(player, url, requestedVote)
	if (isElement(player)) then
		local playerTheater = getElementData(player, "theater")
		local playerSerial = getPlayerSerial(player);
		if (playerTheater) then
			local theater = theaters[playerTheater.name];
			local vote = theater.videoVotes[url][playerSerial];
			if not vote or vote and vote ~= requestedVote then
				theater.videoVotes[url][playerSerial] = requestedVote;

				for k,v in ipairs(theater.queue) do
					if (v.url == url) then
						v.upvotes = requestedVote == "upvote" and v.upvotes+1 or v.upvotes-1;
						sortQueue(theater.queue);
						triggerClientEvent(getTheaterPlayers(playerTheater.name), "updateQueue", resourceRoot, theater.queue);
						triggerClientEvent(player, "updateMyVotes", player, url, requestedVote);
						break;
					end
				end
			end
		end
	end
end

function videoEnds(theater)
	if (theaters[theater].vk) then
		killTimer(theaters[theater].vk.timer);
		theaters[theater].vk = nil;
	end
	if (theaters[theater].playingTimer and isTimer(theaters[theater].playingTimer)) then killTimer(theaters[theater].playingTimer) end
	theaters[theater].currentVideo = nil;
	if ((#theaters[theater].queue > 0)) then
		playVideo(theater);
	else
		triggerClientEvent(getTheaterPlayers(theater), "playVideo", resourceRoot);
		triggerClientEvent(getLobbyPlayers(), "downloadThumbnail", resourceRoot, "", theater, theaters[theater].friendlyName);
	end
end

function skipVideo(theaterName, player)
	local player = isElement(player) and player or nil;
	local theater = theaters[theaterName];
	if (isVideoPlaying(theaterName)) then
		videoEnds(theaterName);
		outputTheaterChat(config.theaterText.."The video has been skipped" .. (player and " by "..getPlayerName(player) or ""), theaterName, 255, 255, 255, true);
	end
end

function voteSkipVideo(theaterName, player)
	local theater = theaters[theaterName];
	if (isVideoPlaying(theaterName)) then
		if (not theater.vk) then
			theater.vk = {};
			theater.vk.timer = setTimer(function()
				theater.vk = nil;
				outputChatBox(config.theaterText.."Video skip vote has expired, not enough votes to skip.", player, 255, 255, 255, true);
			end, 20000, 1);
			theater.vk.votes = {};
		end
		local playerSerial = getPlayerSerial(player);
		if (not findValue(theater.vk.votes, playerSerial)) then
			table.insert(theater.vk.votes, playerSerial);
			outputTheaterChat(config.theaterText..""..getPlayerName(player).."#FFFFFF voted to skip (".. #theater.vk.votes .."/".. math.ceil(#getTheaterPlayers(theaterName)/2) ..") (".. (getTimerDetails(theater.vk.timer)/1000) .."s)", theaterName, 255, 255, 255, true)
			if (#theater.vk.votes >= math.ceil(#getTheaterPlayers(theaterName)/2)) then
				skipVideo(theaterName);
			end
		else
			outputChatBox(config.theaterText.."You already voted", player, 255, 255, 255, true);
		end
	end
end

function playVideo(theaterName)
	if (theaterName and theaters[theaterName]) then
		local theater = theaters[theaterName];
		if (#theater.queue > 0) then
			theater.currentVideo = theater.queue[1];
			table.remove(theater.queue, 1);
			if isTimer(theater.playingTimer) then killTimer(theater.playingTimer); end
			
			theater.playingTimer = setTimer(videoEnds, (theater.currentVideo.duration*1000)+3000, 1, theaterName);
			
			theater.videoVotes[theater.currentVideo.url] = nil;
			
			triggerClientEvent(getLobbyPlayers(), "downloadThumbnail", resourceRoot, theater.currentVideo.thumbnail, theaterName, theater.friendlyName, theater.currentVideo.title);
			triggerClientEvent(getTheaterPlayers(theaterName), "playVideo", resourceRoot, theater.currentVideo.service, theater.currentVideo.url);
			triggerClientEvent(getTheaterPlayers(theaterName), "updateQueue", resourceRoot, theater.queue);
			
			outputTheaterChat(" ", theaterName, 255, 255, 255, true);
			outputTheaterChat(config.theaterText.."Playing: #C8C8C8"..theater.currentVideo.title, theaterName, 255, 255, 255, true);
			outputTheaterChat(config.theaterText.."By: #C8C8C8"..theater.currentVideo.by, theaterName, 255, 255, 255, true);
		end
	end
end

function addVideo(theater, data, player)
	if (theaters[theater]) then
		for k,v in ipairs(theaters[theater].queue) do
			if (v.url == data.url) then
				if (isElement(player)) then
					outputChatBox(config.theaterText.."Video is already in the queue.", player, 255, 255, 255, true);
				end
				return false;
			end
		end
		table.insert(theaters[theater].queue, data);
		theaters[theater].videoVotes[data.url] = {};
		if (#theaters[theater].queue > 0) then
			sortQueue(theaters[theater].queue);
			triggerClientEvent(getTheaterPlayers(theater), "updateQueue", resourceRoot, theaters[theater].queue);
		end
		if (not isVideoPlaying(theater) and #theaters[theater].queue == 1) then
			playVideo(theater)
		end
		
		if (isElement(player)) then
			triggerClientEvent(player, "addHistory", player, {title=data.title, url=data.url, duration=data.duration, service=data.service});
		end
	end
end

function enterTheater(player, theaterName)
	local theater 	= theaters[theaterName];
	
	local cPosition = config.cinema.position;
	setElementPosition(player, cPosition[1]+theater.spawnPosition.inside[1], cPosition[2]+theater.spawnPosition.inside[2], cPosition[3]+theater.spawnPosition.inside[3]);
	setElementRotation(player, 0, 0, theater.spawnPosition.inside[4]);
	setElementData(player, "theater", {name=theaterName, friendlyName=theater.friendlyName});
	unbindKey(player, "e", "down", attemptEnterTheater);
	bindKey(player, "e", "down", attemptExitTheater);
	
	local myVotes = {};
	local mySerial = getPlayerSerial(player);
	for url,v in pairs(theater.videoVotes) do
		for serial,vote in pairs(v) do
			if (serial == mySerial) then
				myVotes[url] = vote;
			end
		end
	end
	
	fadeCamera(player, false);
	
	if (theater.type == "public") then
		if ( hasObjectPermissionTo(player, "resource.Cinema.controlPublicTheaters", false) ) then
			setElementData(player, "controlTheater", true);
		end
	elseif (theater.type == "private") then
		if ( hasObjectPermissionTo(player, "resource.Cinema.controlPrivateTheaters", false) ) then
			setElementData(player, "controlTheater", true);
		else
			if (config.firstToJoinPrivate) then
				if (#getTheaterPlayers(theaterName) == 1) then
					setElementData(player, "controlTheater", true);
					setElementData(player, "theaterOwner", theaterName, false);
				end
			end
		end
	elseif (theater.type == "vip") then
		if ( hasObjectPermissionTo(player, "resource.Cinema.controlVIPTheaters", false) ) then
			setElementData(player, "controlTheater", true);
		end
	end
	
	triggerClientEvent(player, "onPlayerJoinTheater", player, theater.screenPosition, myVotes)
	triggerClientEvent(player, "updateQueue", player, theater.queue);
	if (isVideoPlaying(theaterName)) then
		triggerClientEvent(player, "playVideo", player, theater.currentVideo.service, theater.currentVideo.url, theater.currentVideo.service == "youtube" and getVideoTimeLeft(theaterName));
	end
end

function attemptEnterTheater(player)
	--if (getElementDimension(player) == 0) then
		for k,v in pairs(enterTheaterMarkers) do
			if (isElementWithinColShape(player, k)) then
				enterTheater(player, v)
				return true
			end
		end
	--end
	return false
end

function exitTheater(player, theaterName)
	local currentTheater = theaterName or getElementData(player, "theater").name;
	if (currentTheater) then
		local cPosition = config.cinema.position;
		local theater 	= theaters[currentTheater];
	
		setElementPosition(player, cPosition[1]+theater.spawnPosition.outside[1], cPosition[2]+theater.spawnPosition.outside[2], cPosition[3]+theater.spawnPosition.outside[3]);
		setElementRotation(player, 0, 0, theater.spawnPosition.outside[4]);
		setElementData(player, "theater", nil);
		setElementData(player, "controlTheater", nil);
		if (config.firstToJoinPrivate) then
			local theaterOwner = getElementData(player, "theaterOwner");
			if (theaterOwner) then
				local theaterPlayers = getTheaterPlayers(theaterOwner);
				if (#theaterPlayers > 0) then
					local randomPlayer = theaterPlayers[math.random(1, #theaterPlayers)];
					setElementData(randomPlayer, "theaterOwner", true, false);
				end
				
				local locked = getElementData(resourceRoot, "lockedQueue");
				if (locked[theaterOwner]) then
					locked[theaterOwner] = nil;
				end
				setElementData(resourceRoot, "lockedQueue", locked);
				
				setElementData(player, "theaterOwner", nil, false);
			end
		end
		
		bindKey(player, "e", "down", attemptEnterTheater);
		unbindKey(player, "e", "down", attemptExitTheater);
		sendThumbnails(player)
		
		triggerClientEvent(player, "onPlayerQuitTheater", player)
		if (isVideoPlaying(theaterName)) then
			triggerClientEvent(player, "playVideo", player);
		end
	end
end

function theaterKickPlayer(theaterName, player, by)
	local by = isElement(by) and by or nil;
	exitTheater(player, theaterName);
	outputChatBox(config.theaterText.."You have been kicked"..(by and " by "..getPlayerName(by)), player, 255, 255, 255, true);
	outputChatBox(config.theaterText.."You have kicked "..getPlayerName(by), player, 255, 255, 255, true);
end

function attemptExitTheater(player)
	--if (getElementDimension(player) == 0) then
		local currentTheater = getElementData(player, "theater");
		if (currentTheater) then
			currentTheater = currentTheater.name;
			if (isElementWithinColShape(player, theaters[currentTheater].exitMarker)) then
				exitTheater(player, currentTheater)
			end
		end
	--end
	return false
end

for k,v in ipairs(config.theaters) do
	createTheater(v.type, v.name, v.friendlyName, v.limit, v.enterPosition, v.exitPosition, v.screenPosition, v.spawnPosition, v.seats, v.previewPosition);
end

addEvent("voteskip", true);
addEventHandler("voteskip", root,
function()
	voteSkipVideo(getElementData(client, "theater").name, client);
end)

addEvent("voteVideo", true);
addEventHandler("voteVideo", root,
function(url, vote)
	voteVideo(client, url, vote)
end)

addEvent("refreshTheater", true);
addEventHandler("refreshTheater", root,
function()
	local theater = getElementData(client, "theater");
	if (theater and theater.name and theaters[theater.name] and isVideoPlaying(theater.name)) then
		theater = theater.name;
		triggerClientEvent(client, "playVideo", client, theaters[theater].currentVideo.service, theaters[theater].currentVideo.url, getVideoTimeLeft(theater));
	end
end)


addEvent("skipVideo", true);
addEventHandler("skipVideo", root,
function()
	skipVideo(getElementData(client, "theater").name, client)
end)

addEvent("resetTheater", true);
addEventHandler("resetTheater", root,
function()
	resetTheater(getElementData(client, "theater").name, client)
end)

addEvent("getVideoLength", true);
addEventHandler("getVideoLength", root,
function()
	local theaterName = getElementData(client, "theater").name;
	if (theaters[theaterName] and isVideoPlaying(theaterName)) then
		triggerClientEvent(client, "showSeek", client, theaters[theaterName].currentVideo.duration);
	end
end)

addEvent("onPlayerSeek", true);
addEventHandler("onPlayerSeek", root,
function(t)
	videoSeek(getElementData(client, "theater").name, t, client)
end)

addEvent("theaterKickPlayer", true);
addEventHandler("theaterKickPlayer", root,
function(player)
	theaterKickPlayer(getElementData(client, "theater").name, player, client);
end)

addEvent("toggleTheaterLock", true);
addEventHandler("toggleTheaterLock", root,
function()
	local theaterName = getElementData(client, "theater").name;
	local locked = getElementData(resourceRoot, "lockedQueue");
	if (locked[theaterName]) then
		locked[theaterName] = nil;
		outputTheaterChat(config.theaterText.."Queue has been unlocked by "..getPlayerName(client), theaterName, 255, 255, 255, true);
	else
		locked[theaterName] = true;
		outputTheaterChat(config.theaterText.."Queue has been locked by "..getPlayerName(client), theaterName, 255, 255, 255, true);
	end
	setElementData(resourceRoot, "lockedQueue", locked);
end)

--createObject(1723, -3.05649, -65.66, 204.32, 0, 0, 180)
--createObject(1827, -3.05649+0.5, -65.66-1.6, 204.32, 0, 0, 90)
--createObject(1723, 3.05649, -65.66, 204.32, 0, 0, 180)
--createObject(1827, 3.05649+0.5, -65.66-1.6, 204.32, 0, 0, 90)

--createObject(1713, -8, -66, 204.32, 0, 0, 0)
--createObject(1827, -8-0.87, -66-1.2, 204.32, 0, 0, 90)
--createObject(1713, 10.5, -66, 204.32, 0, 0, 0)
--createObject(1827, 10.5-0.87, -66-1.2, 204.32, 0, 0, 90)

--createObject(1713, -8, -71.5, 204.15, 0, 0, 0)
--createObject(1827, -8-0.87, -71.5-1.2, 204.15, 0, 0, 90)
--createObject(1713, 10.5, -71.5, 204.15, 0, 0, 0)
--createObject(1827, 10.5-0.87, -71.5-1.2, 204.15, 0, 0, 90)

--createObject(2232, 11.6, -92.1, 203.56, 0, 180, 0)
--createObject(2232, -12.7, -92.1, 203.56, 0, 180, 0)
--createObject(2232, 11.6, -65.6, 210.5, 0, 0, 180)
--createObject(2232, -12.7, -65.6, 210.5, 0, 0, 180)

--createObject(1562, 6.40, -31.48, 201.52, 0, 0, 180) -- 0.2 from wall
--createObject(1562, 6.40, -33.08, 201.759, 0, 0, 180) -- 0.2 from wall
--createObject(2635, -4.42307, -14.11960, 201.38125)

--[[createObject(1702, 21.6, -0.6+1.8, 198.156, 0, 0, 180);
createObject(1702, 21.6, -0.6, 198.156, 0, 0, 180);
createObject(1702, 21.6, -0.6-1.8, 198.156, 0, 0, 180);

createObject(1702, -4.5, -8, 201.28125, 0, 0, 45);
createObject(1702, -4.5-(1.3*1), -8+(1.3*1), 201.28125, 0, 0, 45);
createObject(1702, -4.5-(1.3*2), -8+(1.3*2), 201.28125, 0, 0, 45);
createObject(1702, -4.5-(1.3*3), -8+(1.3*3), 201.28125, 0, 0, 45);

createObject(1702, -4, 8.5, 201.28125, 0, 0, -45);
createObject(1702, -4-(1.3*1), 8.5-(1.3*1), 201.28125, 0, 0, -45);
createObject(1702, -4-(1.3*2), 8.5-(1.3*2), 201.28125, 0, 0, -45);
createObject(1702, -4-(1.3*3), 8.5-(1.3*3), 201.28125, 0, 0, -45);]]

--createObject(2635, -8.70209, -13.28734, 201.281, 0, 0, 0);

function sortQueue(tbl)
	table.sort(tbl, function(a, b)
		if (a.upvotes ~= b.upvotes) then
			return a.upvotes > b.upvotes;
		end
		return a.added < b.added;
	end )
end