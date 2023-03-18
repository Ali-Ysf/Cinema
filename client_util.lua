function getPositionFromElementOffset(element,offX,offY,offZ) 
    local m = getElementMatrix ( element )  -- Get the matrix 
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform 
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2] 
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3] 
    return x, y, z                               -- Return the transformed point 
end 

function createWhiteSofa(r, x, y, z, rx, ry, rz)
	local cx, cy, cz = unpack(config.cinema.position);
	local x, y, z = cx+x, cy+y, cz+z;

	local object 	= createObject(1702, x, y, z, rx, ry, rz);
	local x, y ,z 	= getPositionFromElementOffset(object, 0.9, -0.2, 0);
	local marker 	= alw7shMarker(x, y, z, 0.5);
	setElementData(marker, "action", {name="whitecouchSit", element=object, seat=1, id=r.."-1"}, false)
	local x, y ,z 	= getPositionFromElementOffset(object, 0.9, -0.9, 0);
	local marker 	= alw7shMarker(x, y, z, 0.5);
	setElementData(marker, "action", {name="whitecouchSit", element=object, seat=2, id=r.."-2"}, false)
end

function createCafeTable(r, x, y, z, rx, ry, rz)
	local cx, cy, cz = unpack(config.cinema.position);
	local x, y, z = cx+x, cy+y, cz+z;

	local ctable 	= createObject(2635, x, y, z, rx, ry, rz);
	
	local object 	= createObject(2121, x+1, y-0.2, z, rx, ry, rz+90);
	local object 	= createObject(2121, x-1, y+0.2, z, rx, ry, rz-90);
	local object 	= createObject(2121, x-0.2, y-1, z, rx, ry, rz);
	local object 	= createObject(2121, x+0.2, y+1, z, rx, ry, rz-180);
end

local spamSitTick = 0;
function isSpamSit()
	if (getTickCount()-spamSitTick < 500) then
		return true;
	end
	return false;
end
function preventSpamSit()
	spamSitTick = getTickCount();
end


local cursor = {};
_showCursor = showCursor;
function showCursor(visible, name)
	if (visible) then
		cursor[name] = true;
	else
		cursor[name] = nil;
	end
	for k,v in pairs(cursor) do
		_showCursor(true);
		return;
	end
	_showCursor(false);
end