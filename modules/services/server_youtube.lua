local serviceName = "youtube"

local API_KEY = ""
if (API_KEY == "") then
	outputChatBox("You must configure youtube service. Youtube service missing API_KEY", root, 255, 0, 0);
end

local METADATA_URL = "https://www.googleapis.com/youtube/v3/videos?id=%s" ..
		"&key=" .. API_KEY ..
		"&part=snippet,contentDetails,status" ..
		"&videoEmbeddable=true&videoSyndicated=true"

local function convertISO8601Time( duration )
	local a = {}

	for part in string.gmatch(duration, "%d+") do
	   table.insert(a, part)
	end

	if duration:find('M') and not (duration:find('H') or duration:find('S')) then
		a = {0, a[1], 0}
	end

	if duration:find('H') and not duration:find('M') then
		a = {a[1], 0, a[2]}
	end

	if duration:find('H') and not (duration:find('M') or duration:find('S')) then
		a = {a[1], 0, 0}
	end

	duration = 0

	if #a == 3 then
		duration = duration + tonumber(a[1]) * 3600
		duration = duration + tonumber(a[2]) * 60
		duration = duration + tonumber(a[3])
	end

	if #a == 2 then
		duration = duration + tonumber(a[1]) * 60
		duration = duration + tonumber(a[2])
	end

	if #a == 1 then
		duration = duration + tonumber(a[1])
	end

	return duration
end

local function validateURL(url)
	return string.find( url:lower(), "youtube.com/watch" ) or string.find( url:lower(), "youtube.com/embed" );
end

local function getVideoCode(url)
	--[[local code = pregMatch(url, "(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^\"&?\/\s]{11})", "i", 1);
	if (code) then
		return code[1];
	end
	return false;]]
	url = url:gsub("?autoplay=1", "");
	if (string.match(url, "v=(...........)")) then
		return string.match(url, "v=(...........)");
	elseif (string.match(url, "/v/([%a%d-_]+)")) then
		return string.match(url, "/v/([%a%d-_]+)");
	elseif (string.match(url, "/embed/([%a%d-_]+)")) then
		return string.match(url, "/embed/([%a%d-_]+)");
	elseif (string.match(url, "youtu.be") and string.match(url, "/([%a%d-_]+)")) then
		return string.match(url, "/([%a%d-_]+)$");
	end
end

local function getVideoInfo(data, errno, player, code, playerTheater)
	if (isElement(player)) then
		if (errno == 0) then
			local dataArray = fromJSON(data);
			if (dataArray) then
				local live = dataArray['items'][1]['snippet']['liveBroadcastContent']; -- none / live
				if (live ~= "none") then
					outputChatBox(config.theaterText.."This video can not be added (2).", player, 255, 255, 255, true)
					return false
				end
				
				local embeddable = dataArray['items'][1]['status']['embeddable'];
				if (embeddable ~= true) then
					outputChatBox(config.theaterText.."This video can not be added (1).", player, 255, 255, 255, true)
					return false
				end
				local title = dataArray['items'][1]['snippet']['title'];
				local duration = dataArray['items'][1]['contentDetails']['duration'];
				local thumbnail = dataArray['items'][1]['snippet']['thumbnails']['medium']['url'];
				
				local data = {
					service=serviceName,
					url = string.format("https://www.youtube.com/embed/%s?autoplay=1", code),
					thumbnail = thumbnail;
					title = title,
					duration = convertISO8601Time(duration),
					by = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""),
					bySerial = getPlayerSerial(player),
					added = getTickCount(),
					upvotes = 0,
				}
				outputTheaterChat(config.theaterText.."#C8C8C8".. title:sub(0, 150) .." #FFFFFFhas been added by#C8C8C8 ".. getPlayerName(player), playerTheater, 255, 255, 255, true);
				outputConsole(toJSON(data).." has been added by "..getPlayerSerial(player));
				addVideo(playerTheater, data, player);
			else
				outputChatBox(config.theaterText.."This video can not be added (3).", player, 255, 255, 255, true)
			end
		else
			outputChatBox(config.theaterText.."This video can not be added (#"..errno..").", player, 255, 255, 255, true)
		end
	end
end

addEvent("requestVideo:"..serviceName, true);
addEventHandler("requestVideo:"..serviceName, root,
function(url)
	if (validateURL(url)) then
		local playerTheater = getElementData(client, "theater").name
		if (playerTheater) then
			local code = getVideoCode(url);
			if code then
				local url = METADATA_URL:format( code );
				fetchRemote(url, getVideoInfo, "", false, client, code, playerTheater);
			else
				outputChatBox(config.theaterText.."This video can not be added (3).", player, 255, 255, 255, true);
			end
		end
	end
end)