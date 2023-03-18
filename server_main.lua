local isAdminResourceRunning = getResourceFromName( "admin" )

local function onPlayerJoin(player)
	local cx, cy, cz = unpack(config.cinema.position);
	spawnPlayer(player, cx+config.cinema.spawnPosition[1], cy+config.cinema.spawnPosition[2], cz+config.cinema.spawnPosition[3]);
	fadeCamera(player, true);
	setCameraTarget(player, player);
	setPlayerHudComponentVisible(player, "all", false);
	bindKey(player, "e", "down", attemptEnterTheater);
	bindKey(player, "e", "down", attemptEnterVIP);
	bindKey(player, "g", "down", "chatbox", "global");
	sendThumbnails(player)
end

addEvent("playerJoined", true)
addEventHandler("playerJoined", root,
function(accepted)
	if (accepted) then
		onPlayerJoin(client);
		setElementData(client, "sitting", nil);
		setElementData(client, "theater", nil);
		setElementData(client, "theaterOwner", nil);
		setElementData(client, "controlTheater", nil);
	else
		kickPlayer(client, "You have to accept the urls")
	end
end)

function setScoreboardData()
	local cCode = isAdminResourceRunning and exports.admin:getPlayerCountry( source )
	if (hasFlag(cCode:lower())) then
		setElementData( source, "Country", ":admin/client/images/flags/" .. cCode:lower() .. ".png" )
	end
end

addEventHandler( "onPlayerJoin", getRootElement(), setScoreboardData )

addEventHandler("onResourceStart", resourceRoot,
function()
	setTime(19, 00);
	setMinuteDuration(3600000);
	
	for i, player in ipairs( getElementsByType( "player" ) ) do
		local cCode = isAdminResourceRunning and exports.admin:getPlayerCountry( player ) or ""
		if (hasFlag(cCode:lower())) then
			setElementData( player, "Country",  ":admin/client/images/flags/" .. cCode:lower() .. ".png" )
		end
	end
	
	setElementData(resourceRoot, "lockedQueue", {});
end)