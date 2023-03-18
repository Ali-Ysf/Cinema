--[[interactionMarker;
addEventHandler("onMarkerHit", root,
function(player)
	if (player and getElementType(player) == "player") then
		local action = getElementData(source, "action");
		if (action) then
			interactionMarker = source;
		end
	end
end)

addEventHandler("onMarkerLeave", root,
function(player)
	if (player and getElementType(player) == "player") then
		
	end
end)

function interact(player)
	if (interactionMarker)
end]]--
local reservedSeats	= {
	["tsSit"] = {},
	["couchSit"] = {},
	["redcouchSit"] = {},
	["whitecouchSit"] = {}
}

addEvent("interact", true)
addEventHandler("interact", root,
function(action, data1, data2, data3, data4, data5)
	if (action == "standup") then
		local sitting = getElementData(client, "sitting");
		if (sitting) then
			setPedAnimation(client);
			--setElementPosition(localPlayer, sitting[1], sitting[2], sitting[3]);
			--setElementRotation(localPlayer, 0, 0, sitting[4]);
			reservedSeats[sitting.name][sitting.id] = nil;
			setElementData(client, "sitting", nil);
			return
		end
	elseif (action == "tsSit") then
		if (not reservedSeats[action][data1]) then
			setElementPosition(client, data2, data3, data4);
			setElementRotation(client, 0, 0, data5);
			setPedAnimation(client, "ped", "SEAT_IDLE", -1, false, false, false, true);
			setElementData(client, "sitting", {name=action, id=data1});
			reservedSeats[action][data1] = true;
		end
	elseif (action == "couchSit") then
		if (not reservedSeats[action][data1]) then
			setElementPosition(client, data2, data3, data4);
			setElementRotation(client, 0, 0, data5);
			setPedAnimation(client, "ped", "SEAT_IDLE", -1, false, false, false, true);
			setElementData(client, "sitting", {name=action, id=data1});
			reservedSeats[action][data1] = true;
		end
	elseif (action == "redcouchSit") then
		if (not reservedSeats[action][data1]) then
			setElementPosition(client, data2, data3, data4);
			setElementRotation(client, 0, 0, data5);
			setPedAnimation(client, "ped", "SEAT_IDLE", -1, false, false, false, true);
			setElementData(client, "sitting", {name=action, id=data1});
			reservedSeats[action][data1] = true;
		end
	elseif (action == "whitecouchSit") then
		if (not reservedSeats[action][data1]) then
			setElementPosition(client, data2, data3, data4);
			setElementRotation(client, 0, 0, data5);
			setPedAnimation(client, "ped", "SEAT_IDLE", -1, false, false, false, true);
			setElementData(client, "sitting", {name=action, id=data1});
			reservedSeats[action][data1] = true;
		end
	end
end)

local cx, cy, cz = unpack(config.cinema.position);
local vipEntrance 	= createColCuboid(cx+-1.2, cy+44.45, cz+1.28125, 2.4, 0.8, 2)
local vipExit 		= createColCuboid(cx+-1.2, cy+45.4, cz+1.28125, 2.4, 0.8, 2)

function attemptEnterVIP(player)
	if (isElementWithinColShape(player, vipEntrance)) then
		if ( hasObjectPermissionTo(player, "resource.Cinema.controlVIPTheaters", false) ) then
			local cx, cy, cz = unpack(config.cinema.position);
			setElementPosition(player, cx+0, cy+46.59952, cz+2.28125);
			setElementRotation(player, 0, 0, 0);
		else
			outputChatBox(config.theaterText.."You don't have permissions to access this area.", player, 255, 255, 255, true);
		end
	end
	if (isElementWithinColShape(player, vipExit)) then
		local cx, cy, cz = unpack(config.cinema.position);
		setElementPosition(player, cx+0, cy+44, cz+2.28125);
		setElementRotation(player, 0, 0, 180);
	end
end