fonts = {};

function getFont(name, size)
	if not fonts[name] then fonts[name] = {} end;
	if not fonts[name][size] then
		fonts[name][size] = dxCreateFont("//data/fonts/"..name, size, false, "antialiased");
	end
	return fonts[name][size];
end;