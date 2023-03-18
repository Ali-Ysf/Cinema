function alw7shMarker(x, y, z, size)
	return createColTube(x,y,z, size*0.5, 2)
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function tableFind(tbl, value)
	for k,v in ipairs(tbl) do
		if (v == value) then
			return k;
		end
	end
	return false;
end