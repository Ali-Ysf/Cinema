addEventHandler("onClientResourceStart", resourceRoot,
function()
	local cx, cy, cz = unpack(config.cinema.position);

	createObject(4585, cx, cy, cz)
	createObject(10027, cx, cy, cz)
	createObject(18264, cx, cy, cz)
	createObject(18239, cx, cy-21.28, cz)
	createObject(7584, cx, cy, cz)
	
	createObject(14492, cx, cy, cz)
	createObject(14492, cx, cy+8, cz)
	createObject(14492, cx, cy+16, cz)
	
	createObject(14859, cx, cy, cz)
	createObject(14859, cx, cy+8, cz)
	createObject(14859, cx, cy+16, cz)
	
	-- purple
	--[[
		2.	1.
		
		4.	3.
	]]--
	--[[createWater(1,-25,15, 16,-25,15, 1,-18,15, 16,-18,15); -- middle
	createWater(1,-18,15, 6,-18,15, 1,-12,15, 6,-12,15); -- right
	createWater(12,-18,15, 16,-18,15, 12,-12,15, 16,-12,15); -- left
	
	-- black
	createWater(-7,-7,15, -1,-7,15, -7,8,15, -1,8,15); -- middle
	createWater(-1,4,15, 4,3,15, -1,8,15, 4,8,15); -- right
	createWater(-1,-7,15, 4,-7,15, -1,-3,15, 4,-3,15); -- left
	
	-- blue
	createWater(1,19,15, 16,19,15, 1,26,15, 16,26,15); -- middle
	createWater(12,13,15, 16,13,15, 12,19,15, 16,19,15); -- right
	createWater(1,13,15, 6,13,15, 1,19,15, 6,19,15); -- left
	
	createMarker(0, 0, 6, "checkpoint", 1, 255, 0, 0)
	createMarker(10, 0, 6, "checkpoint", 1, 0, 255, 0)
	createMarker(0, 10, 6, "checkpoint", 1, 0, 0, 255)]]--

	requestBrowserDomains({ "ytimg.com", "youtube.com" }, false,
	function(accepted)
		toggleControl("jump", false);
		toggleControl("fire", false);
		triggerServerEvent("playerJoined", localPlayer, accepted);
	end);
	
	for k, object in ipairs(config.cinema.objects.decorations) do
		local x, y, z = cx+object[2], cy+object[3], cz+object[4];
		
		local obj = createObject(object[1], x, y, z, object[5], object[6], object[7]);
		if (object[8]) then
			setObjectScale(obj, object[8])
		end
	end
	
	for k,sofa in ipairs(config.cinema.objects.whiteSofa) do
		createWhiteSofa(k, sofa[1], sofa[2], sofa[3], sofa[4], sofa[5], sofa[6])
	end
	
	for k, cafeTable in ipairs(config.cinema.objects.cafeTable) do
		createCafeTable(k, unpack(cafeTable));
	end
end)

addEventHandler("onClientElementStreamIn", root,
function()
	if (getElementType(source) == "player") then
		setElementCollidableWith(source, localPlayer, false);
	end
end)