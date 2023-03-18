local interactionMarker;

addEventHandler("onClientColShapeHit", root,
function(player)
	if (player and getElementType(player) == "player" and player == localPlayer) then
		local action = getElementData(source, "action");
		if (action) then
			interactionMarker = source;
		end
	end
end)

addEventHandler("onClientColShapeLeave", root,
function(player)
	if (player and getElementType(player) == "player" and player == localPlayer) then
		if (interactionMarker and source == interactionMarker) then
			interactionMarker = nil;
		end
	end
end, true, "normal+1")

bindKey("e","down",
function()
	if (isSpamSit()) then return end
	preventSpamSit()
	local sitting = getElementData(localPlayer, "sitting");
	if (sitting) then
		triggerServerEvent("interact", localPlayer, "standup")
		return
	end
	if (interactionMarker) then
		local action = getElementData(interactionMarker, "action");
		if (action.name == "tsSit") then
			local seat = action.element;
			local x, y ,z = getPositionFromElementOffset(seat,0,-0.8,1);
			local _,_, rz = getElementRotation(seat);
			--setElementPosition(localPlayer, x, y, z);
			--setElementRotation(localPlayer, 0, 0, rz-180);
			--setPedAnimation(localPlayer, "ped", "SEAT_IDLE", -1, false, false, false, true);
			--local sx, sy, sz = getPositionFromElementOffset(seat,0,-1,0)
			--setElementData(localPlayer, "sitting", true, false);
			triggerServerEvent("interact", localPlayer, action.name, action.id, x, y, z, rz-180)
			return
		elseif (action.name == "couchSit") then
			local couch = action.element;
			local x, y, z, rz = 0, 0, 0, 0;
			if (action.seat == 1) then
				x, y ,z = getPositionFromElementOffset(couch,-0.1,1,0.8);
				_,_, rz = getElementRotation(couch);
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz);
			elseif (action.seat == 2) then
				x, y ,z = getPositionFromElementOffset(couch,0.4,1,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz+35
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz+35);
			elseif (action.seat == 3) then
				x, y ,z = getPositionFromElementOffset(couch,0.75,1.3,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz+50
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz+50);
			elseif (action.seat == 4) then
				x, y ,z = getPositionFromElementOffset(couch,0.9,1.8,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz+70
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz+70);
			elseif (action.seat == 5) then
				x, y ,z = getPositionFromElementOffset(couch,-0.5-0.1,1,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-22.5
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-22.5);
			elseif (action.seat == 6) then
				x, y ,z = getPositionFromElementOffset(couch,-0.75-0.1,1.3,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-50
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-50);
			elseif (action.seat == 7) then
				x, y ,z = getPositionFromElementOffset(couch,-0.9-0.1,1.8,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-70
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-70);
			end
			--setPedAnimation(localPlayer, "ped", "SEAT_IDLE", -1, false, false, false, true);
			--setElementData(localPlayer, "sitting", true, false);
			triggerServerEvent("interact", localPlayer, action.name, action.id, x, y, z, rz)
			return
		elseif (action.name == "redcouchSit") then
			local couch = action.element;
			local x, y, z, rz = 0, 0, 0, 0;
			if (action.seat == 1) then
				x, y ,z = getPositionFromElementOffset(couch,-0.2,-0.9,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-180
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-180);
			elseif (action.seat == 2) then
				x, y ,z = getPositionFromElementOffset(couch,-0.9,-0.9,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-180
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-180);
			elseif (action.seat == 3) then
				x, y ,z = getPositionFromElementOffset(couch,-1.8,-0.9,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-180
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-180);
			elseif (action.seat == 4) then
				x, y ,z = getPositionFromElementOffset(couch,-2.5,-0.9,0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-180
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-180);
			end
			--setPedAnimation(localPlayer, "ped", "SEAT_IDLE", -1, false, false, false, true);
			--setElementData(localPlayer, "sitting", true, false);
			triggerServerEvent("interact", localPlayer, action.name, action.id, x, y, z, rz)
			return 
		elseif (action.name == "whitecouchSit") then
			local couch = action.element;
			local x, y, z, rz = 0, 0, 0, 0;
			if (action.seat == 1) then
				x, y ,z = getPositionFromElementOffset(couch,0.9, -0.2, 0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-90
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-90);
			elseif (action.seat == 2) then
				x, y ,z = getPositionFromElementOffset(couch,0.9, -0.9, 0.8);
				_,_, rz = getElementRotation(couch);
				rz = rz-90
				--setElementPosition(localPlayer, x, y, z);
				--setElementRotation(localPlayer, 0, 0, rz-90);
			end
			--setPedAnimation(localPlayer, "ped", "SEAT_IDLE", -1, false, false, false, true);
			--setElementData(localPlayer, "sitting", true, false);
			triggerServerEvent("interact", localPlayer, action.name, action.id, x, y, z, rz)
			return 
		end
	end
end)