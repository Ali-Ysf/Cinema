local serviceName = "twitch"

local function validateURL(url)
	return string.match( url, "twitch.tv" )
end

local function getChannelName(url)
	local cn = string.match( url, "/([%w_]+)$" )

	if not cn or string.len(cn) < 1 then
		return false
	end

	return cn
end

addEvent("requestVideo:"..serviceName, true);
addEventHandler("requestVideo:"..serviceName, root,
function(url)
	if (validateURL(url)) then
		local playerTheater = getElementData(client, "theater").name
		if (playerTheater) then
			local channelName = getChannelName(url);
			if (channelName) then
				local data = {
					service=serviceName,
					url=string.format("https://player.twitch.tv/?channel=%s&muted=false&parent=localhost&autoplay=true", channelName),
					title=string.format("%s's Stream", channelName),
					by = getPlayerName(client):gsub("#%x%x%x%x%x%x", ""),
					bySerial = getPlayerSerial(client),
					added = getTickCount(),
					upvotes = 0
				}
				
				addVideo(playerTheater, data, client);
			end
		end
	end
end)