addEventHandler("onPlayerChat", root,
function(message, messageType)
	if (messageType == 1) then
		return false;
	end
	if (messageType == 0) then
		cancelEvent();
		local playerTheater = getElementData(source, "theater");
		local playerName = getPlayerName(source);
		if (playerTheater) then
			outputTheaterChat(config.theaterText:upper()..playerName.."#FFFFFF: "..message, playerTheater.name, 255, 255, 255, true);
		else
			for k,v in ipairs(getElementsByType("player")) do
				if (not getElementData(v, "theater")) then
					outputChatBox("#202225[LOBBY]#FFFFFF "..playerName.."#FFFFFF: "..message, v, 255, 255, 255, true);
				end
			end
		end
	end
end)

function globalChat(player, cmd, ...)
	local message = table.concat({...}, " ");
	local playerName = getPlayerName(player);
	outputChatBox("#202225[GLOBAL]#FFFFFF "..playerName.."#FFFFFF: "..message, root, 255, 255, 255, true);
end
addCommandHandler("global", globalChat)