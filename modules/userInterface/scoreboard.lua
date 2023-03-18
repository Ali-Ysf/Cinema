local ys = xs;

local rtWidth, rtHeight = (1000*xs)-16, (500*ys)-2
local white, red, faded = tocolor(255, 255, 255, 255), tocolor(255, 0, 0, 255), tocolor(255, 255, 255, 150);
local renderTarget = dxCreateRenderTarget(rtWidth, rtHeight, true)

local visible = false;

function isScoreboardOpen()
	return visible;
end

local d = {
	players = {
		scrolling = false,
		scroll = 0,
		endOfGrid = 0,
		data = {};
		update = 0;
	},
	fonts = {
		head = getFont("Ultra.ttf", 30*xs),
		players = getFont("Roboto-Medium.ttf", 13),
		playerssmall = getFont("Roboto-Medium.ttf", 9),
		playersping = getFont("Roboto-Medium.ttf", 10),
		settingshead = getFont("BebasNeue.ttf", 17*xs),
		settingsbody = getFont("Roboto-Medium.ttf", 8*xs),
	}
}

local px, py = sx/2 - (1000*xs)/2, sy/2 - (800*ys)/2

local volumeController = dxCreateProgressbar(px + 5, py + 70 + 30 + 5 + 20, 250);
addEvent("onClientProgressbarChanged", true)
addEventHandler("onClientProgressbarChanged", localPlayer,
function(element, vol)
	if (element == volumeController) then
		setVolume(vol);
	end
end)

local hdButton = dxCreateCheckbox(px + 10, py + 70*ys + 30*ys + 5*ys + 20*ys + 10 + 20*ys, "HD Video Playback", d.fonts.settingsbody)
--local hidePlayers = dxCreateCheckbox(px + 10, py + 70*ys + 30*ys + 5*ys + 20*ys + 10 + 20*ys + 20*ys, "Hide Players in Theater", d.fonts.settingsbody)

addEventHandler("onClientdxButtonClick", localPlayer,
function(element, selected)
	if (element == hdButton) then
		toggleHD(selected);
	elseif (element == hidePlayers) then
		--hidePlayers(selected);
	end
end)

local function drawScoreboard()
	dxDrawRectangle(px, py, 1000*xs, 70*ys, tocolor(32, 34, 37));
	dxDrawText(config.servername.." Cinema", px, py, px+1000*xs, py+70*ys, tocolor(255, 255, 255), 1, d.fonts.head, "center", "center");
	dxDrawRectangle(px, py+70*ys-2, 1000*xs, 2, tocolor(0, 0, 0, 20));
	
	local y = py + 70*ys;
	dxDrawRectangle(px, y, 1000*xs, 30*ys, tocolor(47, 49, 54));
	dxDrawText("Settings", px, y, px+1000*xs, y+30*ys, tocolor(255, 255, 255), 1, d.fonts.settingshead, "center", "center");
	
	y = y + 30*ys;
	dxDrawRectangle(px, y, 1000*xs, 200*ys, tocolor(54, 57, 63));
	local yy = y + 5*ys;
	local xx = px + 5;
	dxDrawText("Volume", xx, yy, xx+1000*xs, yy+30*ys, tocolor(255, 255, 255), 1, d.fonts.settingsbody);
	dxDrawProgressbar(volumeController, xx+10, yy+20*ys, 0, 0);
	
	--yy = yy + 20*ys + 7*ys + 20*ys;
	dxDrawCheckbox(hdButton);
	--dxDrawCheckbox(hidePlayers);
	
	
	y = y + 200*ys;
	dxDrawRectangle(px, y, 1000*xs, 500*ys, tocolor(41, 43, 47));
	dxDrawRectangle(px, y, 1000*xs, 2, tocolor(0, 0, 0, 30));
	
	y = y + 2;
	
	if (getTickCount()-d.players.update > config.updateScoreboardEvery) then
		d.players.data = {};
		
		for k,v in ipairs(getElementsByType("player")) do
			local theater = getElementData(v, "theater");
			table.insert(d.players.data, {
				player = v,
				nickname = getPlayerName(v),
				theater = theater and theater.friendlyName or "Lobby";
				country = getElementData(v, "Country"),
				ping = getPlayerPing(v),
				})
		end
		
		d.players.update = getTickCount();
	end
	
	posY = 0;
	dxSetRenderTarget(renderTarget, true);
    dxSetBlendMode("modulate_add")

	for i=1, #d.players.data do
		local player = d.players.data[i];
		dxDrawText(player.nickname, 10*xs, posY+5-d.players.scroll, nil, nil, tocolor(255, 255, 255, 255), 1, d.fonts.players);
		dxDrawText(player.theater, 10*xs, posY+5+20-d.players.scroll, nil, nil, tocolor(255, 255, 255, 255), 1, d.fonts.playerssmall);
		dxDrawText(player.ping, rtWidth-30, posY-d.players.scroll, nil, posY+50-d.players.scroll, tocolor(255, 255, 255, 255), 1, d.fonts.playersping, nil, "center");
		
		if (player.country) then
			dxDrawImage(rtWidth-30-4-5-4-1-4-1-15-10*xs, posY+19-d.players.scroll, 15, 10, player.country[1]);
		end
		local color1 = white;
		local color2 = white;
		local color3 = white;
		if (player.ping > 120 and player.ping < 200) then
			color3 = faded;
		elseif (player.ping > 200) then
			color1 = red;
			color2 = faded;
			color3 = faded;
		end
		dxDrawRectangle(rtWidth-30-4-5, posY+19-d.players.scroll, 4, 10, color3);
		dxDrawRectangle(rtWidth-30-4-5-4-1, posY+19+3-d.players.scroll, 4, 7, color2);
		dxDrawRectangle(rtWidth-30-4-5-4-1-4-1, posY+19+6-d.players.scroll, 4, 4, color1);
		
		posY = posY + 50;
		dxDrawRectangle(200*xs, posY-d.players.scroll, rtWidth-400*xs, 2, tocolor(200, 200, 200, 100));
	end
	
	dxSetBlendMode("blend")
	dxSetRenderTarget();
	
	dxSetBlendMode("add")
	dxDrawImage(px, y, rtWidth, rtHeight, renderTarget);
	dxSetBlendMode("blend")
	
	local scx = px+1000*xs-16;
	--dxDrawRectangle(scx, y, 16, 500*ys, tocolor(0, 0, 0, 30))
	local arrowHeight = 16;
	local viewportHeight = 498*ys;
	local contentHeight = 50*#d.players.data;
	
	if contentHeight > viewportHeight then
		local viewableRatio = viewportHeight / contentHeight
		local scrollBarArea = viewportHeight - arrowHeight * 2
		local thumbHeight = scrollBarArea * viewableRatio
		
		local endOfGrid = contentHeight-viewportHeight
		if d.players.endOfGrid ~= endOfGrid then
			d.players.endOfGrid = endOfGrid
		end
		local endOfScroll = endOfGrid/(scrollBarArea-thumbHeight)
		local thumbY = d.players.scroll/endOfScroll
		
			if isMouseInPosition(scx,y+arrowHeight,arrowHeight,scrollBarArea) or d.players.scrolling then
				if getKeyState("mouse1") then
					if (d.players.scrolling == false) then
						d.players.scrolling = true
					end
				else
					if (d.players.scrolling == true) then
						d.players.scrolling = false
					end
				end
				if d.players.scrolling then
					local _,sY = getCursorPosition()
					local sY = sY*sy
					local thumbY = sY-(y+arrowHeight)-(thumbHeight/2)
					local alw7sh = thumbY*endOfScroll
					if alw7sh > 0 then alw7sh = alw7sh else alw7sh = 0 end
					if alw7sh < endOfGrid then alw7sh = alw7sh else alw7sh = endOfGrid end
					d.players.scroll = alw7sh
				end
			end
		
		--dxDrawRectangle(d.x+d.w-16,d.y+30,16,16)
		--dxDrawImage(d.x+d.w-16,d.y+30,16,16,"img/arrow.png",0,0,0,tocolor(212,212,212,d.alpha))
		dxDrawRectangle(scx,y+arrowHeight+thumbY,arrowHeight,thumbHeight,tocolor(0,0,0,150))
		--dxDrawRectangle(d.x+d.w-16,d.y+d.h-16,16,16)
		--dxDrawImage(d.x+d.w-16,d.y+d.h-16,16,16,"img/arrow.png",180,0,0,tocolor(212,212,212,d.alpha))
	end
end
local finalY = py + 70*ys + 30*ys + 5*ys + 20*ys + 7*ys + 20*ys + 20*ys + 200*ys + 2;

function dxGridlistScroll(key)
	if (isMouseInPosition(px, finalY, (1000*xs)-16, (500*ys)-2)) then
		if key == "mouse_wheel_up" then
			d.players.scroll = d.players.scroll-50*ys > 0 and d.players.scroll-50*ys or 0
		elseif key == "mouse_wheel_down" then
			d.players.scroll = d.players.scroll+50*ys < d.players.endOfGrid and d.players.scroll+50*ys or d.players.endOfGrid
		end
	end
end

bindKey("tab", "down",
function()
	visible = not visible;
	showCursor(visible, "scoreboard");
	if (visible) then
		addEventHandler("onClientRender", root, drawScoreboard);
		bindKey("mouse_wheel_up","down",dxGridlistScroll)
		bindKey("mouse_wheel_down","down",dxGridlistScroll)
	else
		removeEventHandler("onClientRender", root, drawScoreboard);
		unbindKey("mouse_wheel_up","down",dxGridlistScroll)
		unbindKey("mouse_wheel_down","down",dxGridlistScroll)
	end
end)