sx, sy = guiGetScreenSize();
xs, ys = (sx/1920), (sy/1920)
--xs, ys = (1280/1920), (720/1920)
--xs, ys = (800/1920), (600/1920)

local font1 = getFont("Roboto-Medium.ttf", 10*xs);

local roundTexture = dxCreateTexture("data/images/round.tga", "dxt3", true)

local function dxDrawRRectangle(x,y,w,h,color,radius,postGUI)
	local color = color or tocolor(0,255,255,255)
	local postGUI = postGUI or false
	local radius = radius or 5
	dxDrawImageSection(x,y,radius,radius,0,0,32,32,roundTexture,0,0,0,color,postGUI) -- left up
	dxDrawRectangle(x+radius,y,w-radius-radius,radius,color,postGUI) -- up
	dxDrawImageSection(x+w-radius,y,radius,radius,0,0,32,32,roundTexture,90,0,0,color,postGUI) -- right up
	dxDrawRectangle(x+w-radius,y+radius,radius,h-radius-radius,color,postGUI) -- right
	dxDrawImageSection(x+w-radius,y+h-radius,radius,radius,0,0,32,32,roundTexture,180,0,0,color,postGUI) -- right down
	dxDrawRectangle(x,y+radius,radius,h-radius-radius,color,postGUI) -- left
	dxDrawImageSection(x,y+h-radius,radius,radius,0,0,32,32,roundTexture,-90,0,0,color,postGUI) -- left down
	dxDrawRectangle(x+radius,y+h-radius,w-radius-radius,radius,color,postGUI) -- down
	dxDrawRectangle(x+radius,y+radius,w-radius-radius,h-radius-radius,color,postGUI) -- middle
end

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing ( ) ) then
        return false
    end
 

    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

--[[			Buttons				 ]]--
local buttons = {};
function dxCreateButton(x, y, w, h, text, font, fontSize)
	local button = createElement("dxButton");
	buttons[button] = {
		x = x,
		y = y,
		w = w,
		h = h,
		text = text,
		font = font,
		fontSize = fontSize,
		enabled = true,
		
		state = "up",
		alpha = 20}
	return button;
end

function dxDrawButton(button)
	if (button) then
		local d = buttons[button];
		
		if isMouseInPosition(d.x,d.y,d.w,d.h) and d.enabled then
			dxDrawRectangle(d.x, d.y, d.w, d.h, tocolor(255, 255, 255, d.alpha));
			if getKeyState("mouse1") then
				dxDrawRectangle(d.x, d.y, d.w, d.h, tocolor(255, 255, 255, d.alpha));
				if d.state ~= "down" then
					d.state = "down"
					triggerEvent("onClientdxButtonClick", localPlayer, button,"down")
				end
			else
				if d.state == "down" then
					if d.state ~= " up" then
						d.state = "up"
						--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
					end
				end
			end
		end
		
		dxDrawRectangle(d.x, d.y, d.w, d.h, tocolor(255, 255, 255, d.alpha));
		dxDrawText(d.text, d.x, d.y, d.x+d.w, d.y+d.h, tocolor(200, 200, 200, 255), d.fontSize, d.font, "center", "center");
	end
end

function dxDrawButtonPicture(button)
	if (button) then
		local d = buttons[button];
		
		if isMouseInPosition(d.x,d.y,d.w,d.h) and d.enabled then
			dxDrawRectangle(d.x, d.y, d.w, d.h, tocolor(255, 255, 255, d.alpha));
			if getKeyState("mouse1") then
				dxDrawRectangle(d.x, d.y, d.w, d.h, tocolor(255, 255, 255, d.alpha));
				if d.state ~= "down" then
					d.state = "down"
					triggerEvent("onClientdxButtonClick", localPlayer, button,"down")
				end
			else
				if d.state == "down" then
					if d.state ~= " up" then
						d.state = "up"
						--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
					end
				end
			end
		end
		
		dxDrawImage(d.x, d.y, d.w, d.h, d.text);
	end
end

--[[			LIST			 ]]--
local lists = {};
local scrollLists = {};

function dxCreateList(x, y, w, h, fontSize)
	local list = createElement("dxGridlist");
	lists[list] = {
		x = x,
		y = y,
		w = w,
		h = h,
		fontSize = fontSize,
		
		listHovered 	= false,
		data 			= {},--{{ ["duration"]= 982, ["added"]= 9194459, ["title"]= "أكثر مقطع ضحكت عليه بحياتي藍", ["by"]= "ALw7sH", ["upvotes"]= 0,{ ["duration"]= 982, ["added"]= 9194459, ["title"]= "أكثر مقطع ضحكت عليه بحياتي藍", ["by"]= "ALw7sH", ["upvotes"]= 0, ["service"]= "youtube"}}},
		selectedRow 	= 0,
		upState 		= "up",
		downState 		= "up",
		rt 				= dxCreateRenderTarget(w, h, true),
		enabled 		= true,
		scrolling		= false,
		
		scroll 		= 0,
		endOfGrid 	= 0,
	};
	return list;
end

function dxDrawList(list)
	if (list) then
		local d = lists[list];
		local lw = d.w-8;
		
		if (isMouseInPosition(d.x, d.y, d.w, d.h)) then
			if (d.listHovered == false) then
				d.listHovered = true;
			end
		else
			if (d.listHovered == true) then
				d.listHovered = false;
			end
		end
		
		local posY = 0;
		dxSetRenderTarget(d.rt, true);
		for i=1, #d.data do
			local row = d.data[i];
			dxDrawRectangle(0, posY-d.scroll, lw, 30, tocolor(255, 255, 255, 120));
			dxDrawText(row['title'], 5, posY-d.scroll, 5+lw-70, posY+21-d.scroll, tocolor(255, 255, 255), d.fontSize, "default-bold", "left", "center", true);
			dxDrawText(SecondsToClock(row['duration']), 5, posY-d.scroll, 5+lw-70, posY+30-d.scroll, tocolor(200, 200, 200), d.fontSize, "default-bold", "left", "bottom", true);
			
			dxDrawText(row['upvotes'], lw-65+5, posY+7-d.scroll, lw-5, posY+7+16-d.scroll, tocolor(255, 255, 255), d.fontSize, "default-bold", "center", "center");
			if (queueVotes[row.url] and queueVotes[row.url] == "upvote") then
				dxDrawImage(lw-65+5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 0, 0, 0, tocolor(34,139,34, 255))
				dxDrawImage(lw-16-5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 180, 0, 0, tocolor(255, 255, 255, 170))
			elseif (queueVotes[row.url] and queueVotes[row.url] == "downvote") then
				dxDrawImage(lw-65+5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 0, 0, 0, tocolor(255, 255, 255, 170))
				dxDrawImage(lw-16-5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 180, 0, 0, tocolor(204, 0, 0, 255))
			else
				dxDrawImage(lw-65+5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 0, 0, 0, tocolor(255, 255, 255, 170))
				dxDrawImage(lw-16-5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 180, 0, 0, tocolor(255, 255, 255, 170))
			end
			
			if (d.listHovered) then
				if (isMouseInPosition(d.x, d.y+posY-d.scroll, lw, 30)) then
					if (d.selectedRow ~= i) then
						d.selectedRow = i;
						d.upState = "up";
						d.downState = "up";
					end
					if (isMouseInPosition(d.x+lw-65+5, d.y+posY+7-d.scroll, 16, 16)) then
						dxDrawImage(lw-65+5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 0, 0, 0, tocolor(255, 255, 255, 205))
						if getKeyState("mouse1") then
							if d.upState ~= "down" then
								d.upState = "down"
								if (d.enabled and not d.scrolling) then
									triggerEvent("onClientVote", localPlayer, "upvote", row.url)
								end
							end
						else
							if d.upState == "down" then
								if d.upState ~= " up" then
									d.upState = "up"
									--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
								end
							end
						end
					end
					if (isMouseInPosition(d.x+lw-16-5, d.y+posY+7-d.scroll, 16, 16)) then
						dxDrawImage(lw-16-5, posY+7-d.scroll, 16, 16, "data/images/ui/up.png", 180, 0, 0, tocolor(255, 255, 255, 205))
						if getKeyState("mouse1") then
							if d.downState ~= "down" then
								d.downState = "down"
								if (d.enabled and not d.scrolling) then
									triggerEvent("onClientVote", localPlayer, "downvote", row.url)
								end
							end
						else
							if d.downState == "down" then
								if d.downState ~= " up" then
									d.downState = "up"
									--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
								end
							end
						end
					end
				end
			end
			
			posY = posY + 30 + 2;
		end
		dxSetRenderTarget();
		
		dxDrawImage(d.x, d.y, d.w, d.h, d.rt);
		
		local arrowHeight = 8;
		local viewportHeight = d.h;
		local contentHeight = #d.data*32;
		
		if contentHeight > viewportHeight then
			local viewableRatio = viewportHeight / contentHeight
			local scrollBarArea = viewportHeight - arrowHeight * 2
			local thumbHeight = scrollBarArea * viewableRatio
			
			local endOfGrid = contentHeight-viewportHeight
			if d.endOfGrid ~= endOfGrid then
				d.endOfGrid = endOfGrid
			end
			local endOfScroll = endOfGrid/(scrollBarArea-thumbHeight)
			local thumbY = d.scroll/endOfScroll
			
				if isMouseInPosition(d.x+d.w-8,d.y+8,8,scrollBarArea) or d.scrolling then
					if (getKeyState("mouse1")) then
						if (d.scrolling == false) then
							d.scrolling = true
						end
					else
						if (d.scrolling == true) then
							d.scrolling = false
						end
					end
					if d.scrolling then
						local _,sY = getCursorPosition()
						local sY = sY*sy
						local thumbY = sY-(d.y+8)-(thumbHeight/2)
						local alw7sh = thumbY*endOfScroll
						if alw7sh > 0 then alw7sh = alw7sh else alw7sh = 0 end
						if alw7sh < endOfGrid then alw7sh = alw7sh else alw7sh = endOfGrid end
						d.scroll = alw7sh
					end
				end
			
			--dxDrawRectangle(d.x+d.w-16,d.y+30,16,16)
			--dxDrawImage(d.x+d.w-16,d.y+30,16,16,"img/arrow.png",0,0,0,tocolor(212,212,212,d.alpha))
			dxDrawRectangle(d.x+lw,d.y+8+thumbY,8,thumbHeight,tocolor(212,212,212,d.alpha))
			--dxDrawRectangle(d.x+d.w-16,d.y+d.h-16,16,16)
			--dxDrawImage(d.x+d.w-16,d.y+d.h-16,16,16,"img/arrow.png",180,0,0,tocolor(212,212,212,d.alpha))
		end
	end
end

function dxDrawHistoryList(list)
	if (list) then
		local d = lists[list];
		local lw = d.w-4;
		local lx = d.x+2
		
		--[[if (isMouseInPosition(d.x, d.y, d.w, d.h)) then
			if (d.listHovered == false) then
				d.listHovered = true;
			end
		else
			if (d.listHovered == true) then
				d.listHovered = false;
			end
		end]]
		
		local posY = d.y;
		for i=1, #d.data do
			local row = d.data[i];
			dxDrawRectangle(lx, posY, lw, 30*xs, tocolor(255, 255, 255, 20));
			dxDrawText(row['title'], lx+5*xs, posY+3*xs, lx+lw-16*xs-5*xs-16*xs-5*xs-10*xs, posY+30, tocolor(255, 255, 255), 1, font1, "left", "top", true);
			--dxDrawText(SecondsToClock(row['duration']), lx+5*xs, posY, lx+5*xs+150*xs, posY+30*xs, tocolor(200, 200, 200), 0.8*xs, "default-bold", "left", "bottom", true);
			
			dxDrawImage(lx+lw-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs, "data/images/ui/trashbin.png", 0, 0, 0, tocolor(255,255,255, 70))
			dxDrawImage(lx+lw-16*xs-5*xs-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs, "data/images/ui/play.png", 0, 0, 0, tocolor(255,255,255, 70))
			
			--if (d.listHovered) then
				if (isMouseInPosition(lx, posY, lw, 30*xs)) then
					if (d.selectedRow ~= i) then
						d.selectedRow = i;
						d.upState = "up";
						d.downState = "up";
					end
					if (isMouseInPosition(lx+lw-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs)) then
						dxDrawImage(lx+lw-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs, "data/images/ui/trashbin.png", 0, 0, 0, tocolor(205,0,0, 200))
						if getKeyState("mouse1") then
							if d.upState ~= "down" then
								d.upState = "down"
								triggerEvent("onClientClick:history", localPlayer, "delete", row.url)
							end
						else
							if d.upState == "down" then
								if d.upState ~= " up" then
									d.upState = "up"
									--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
								end
							end
						end
					end
					if (isMouseInPosition(lx+lw-16*xs-5*xs-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs)) then
						dxDrawImage(lx+lw-16*xs-5*xs-16*xs-5*xs, posY+7*xs, 16*xs, 16*xs, "data/images/ui/play.png", 0, 0, 0, tocolor(255,255,255, 200))
						if getKeyState("mouse1") then
							if d.downState ~= "down" then
								d.downState = "down"
								triggerEvent("onClientClick:history", localPlayer, "play", row.url, row.service)
							end
						else
							if d.downState == "down" then
								if d.downState ~= " up" then
									d.downState = "up"
									--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
								end
							end
						end
					end
				end
			--end
			
			posY = posY + 30*xs + 2*xs;
		end
	end
end

function dxDrawPlayersList(list)
	if (list) then
		local d = lists[list];
		local lw = d.w-8;
		
		if (isMouseInPosition(d.x, d.y, d.w, d.h)) then
			if (d.listHovered == false) then
				d.listHovered = true;
			end
		else
			if (d.listHovered == true) then
				d.listHovered = false;
			end
		end
		
		local posY = 0;
		dxSetRenderTarget(d.rt, true);
		for i=1, #d.data do
			local row = d.data[i];
			dxDrawRectangle(0, posY-d.scroll, lw, 30, tocolor(255, 255, 255, 120));
			dxDrawText(row['name'], 5, posY-d.scroll, 5+lw-70, posY+30-d.scroll, tocolor(255, 255, 255), d.fontSize, "default-bold", "left", "center", true);
			
			dxDrawImage(lw-20-5, posY+5-d.scroll, 20, 20, "data/images/ui/kick.png", 0, 0, 0, tocolor(255,255,255, 170))
			
			if (d.listHovered) then
				if (isMouseInPosition(d.x, d.y+posY-d.scroll, lw, 30)) then
					if (d.selectedRow ~= i) then
						d.selectedRow = i;
						d.upState = "up";
						d.downState = "up";
					end
					if (isMouseInPosition(d.x+lw-20-5, d.y+posY+5-d.scroll, 20, 20)) and d.enabled and not d.scrolling then
						dxDrawImage(lw-20-5, posY+5-d.scroll, 20, 20, "data/images/ui/kick.png", 0, 0, 0, tocolor(255, 255, 255, 205))
						if getKeyState("mouse1") then
							if d.upState ~= "down" then
								d.upState = "down"
								triggerEvent("onClickKickPlayer", localPlayer, row.player);
							end
						else
							if d.upState == "down" then
								if d.upState ~= " up" then
									d.upState = "up"
									--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
								end
							end
						end
					end
				end
			end
			
			posY = posY + 30 + 2;
		end
		dxSetRenderTarget();
		
		dxDrawImage(d.x, d.y, d.w, d.h, d.rt);
		
		local arrowHeight = 8;
		local viewportHeight = d.h;
		local contentHeight = #d.data*32;
		
		if contentHeight > viewportHeight then
			local viewableRatio = viewportHeight / contentHeight
			local scrollBarArea = viewportHeight - arrowHeight * 2
			local thumbHeight = scrollBarArea * viewableRatio
			
			local endOfGrid = contentHeight-viewportHeight
			if d.endOfGrid ~= endOfGrid then
				d.endOfGrid = endOfGrid
			end
			local endOfScroll = endOfGrid/(scrollBarArea-thumbHeight)
			local thumbY = d.scroll/endOfScroll
			
			if (d.enabled) then
				if isMouseInPosition(d.x+d.w-8,d.y+8,8,scrollBarArea) or d.scrolling then
					if (getKeyState("mouse1")) then
						if (d.scrolling == false) then
							d.scrolling = true
						end
					else
						if (d.scrolling == true) then
							d.scrolling = false
						end
					end
					if d.scrolling then
						local _,sY = getCursorPosition()
						local sY = sY*sy
						local thumbY = sY-(d.y+8)-(thumbHeight/2)
						local alw7sh = thumbY*endOfScroll
						if alw7sh > 0 then alw7sh = alw7sh else alw7sh = 0 end
						if alw7sh < endOfGrid then alw7sh = alw7sh else alw7sh = endOfGrid end
						d.scroll = alw7sh
					end
				end
			end
			
			--dxDrawRectangle(d.x+d.w-16,d.y+30,16,16)
			--dxDrawImage(d.x+d.w-16,d.y+30,16,16,"img/arrow.png",0,0,0,tocolor(212,212,212,d.alpha))
			dxDrawRectangle(d.x+lw,d.y+8+thumbY,8,thumbHeight,tocolor(212,212,212,d.alpha))
			--dxDrawRectangle(d.x+d.w-16,d.y+d.h-16,16,16)
			--dxDrawImage(d.x+d.w-16,d.y+d.h-16,16,16,"img/arrow.png",180,0,0,tocolor(212,212,212,d.alpha))
		end
	end
end

function dxListsScroll(key)
	if (#scrollLists > 0) then
		for i=1,#scrollLists do
			local d = lists[scrollLists[i]]
			if d and d.listHovered == true then
				if key == "mouse_wheel_up" then
					d.scroll = d.scroll-32 > 0 and d.scroll-32 or 0
				elseif key == "mouse_wheel_down" then
					d.scroll = d.scroll+32 < d.endOfGrid and d.scroll+32 or d.endOfGrid
				end
			end
		end
	end
end

function dxListEnableScroll(list, enabled)
	if (list and lists[list]) then
		if (enabled) then
			table.insert(scrollLists, list);
			if (#scrollLists == 1) then
				bindKey("mouse_wheel_up","down",dxListsScroll);
				bindKey("mouse_wheel_down","down",dxListsScroll);
			end
		else
			local found = tableFind(scrollLists, list);
			if (found) then
				table.remove(scrollLists, found);
			end
			if (#scrollLists == 0) then
				unbindKey("mouse_wheel_up","down",dxListsScroll);
				unbindKey("mouse_wheel_down","down",dxListsScroll);
			end
		end
	end
end

function dxListSetEnabled(list, enabled)
	if (list and lists[list]) then
		lists[list].enabled = enabled;
	end
end

function dxListGetEnabled(list, data)
	if (list and lists[list]) then
		return lists[list].enabled;
	end
end

function setListData(list, data)
	if (list and lists[list]) then
		lists[list].data = data;
	end
end

--[[		Progress Bar		 ]]--

local progressbar = {}

function dxCreateProgressbar(x,y,w)
	local theProg = createElement("dxProgressbar")
	progressbar[theProg] = {x=x or 0,y=y or 0,w=w or 50 ,hovered=false,prog=100,alpha=255}
	return theProg
end

function dxDrawProgressbar(element,x,y,rX,rY)
	if isElement(element) and getElementType(element) == "dxProgressbar" then
		local d = progressbar[element]
		local x = x or d.x
		local y = y or d.y
		local hx,hy
		if rX and rY then
			hx = x+rX
			hy = y+rY
		end
		
		if isMouseInPosition(hx,hy,d.w,10) then
			if getKeyState("mouse1") then
				local cX, cY = getCursorPosition();
				cX, cY = (cX*sx), (cY*sy);
				local start = cX-(x+1+rX)
				local prog = math.floor((start/(d.w-2))*100)
				if prog > 100 then prog = 100 end
				if prog < 0 then prog = 0 end
				if prog ~= d.prog then
					d.prog = prog
					triggerEvent("onClientProgressbarChanged",localPlayer, element, prog)
				end
			end
		end
		
		dxDrawRRectangle(x,y,d.w,10,tocolor(51,52,53,255))
		dxDrawRRectangle(x+1,y+1,d.w-2,10-2,tocolor(28,29,32,255))
		if d.prog > 0 then
			dxDrawRRectangle(x+1,y+1,(d.prog/100)*d.w-2,10-2,tocolor(123,123,123,255),3)
		end
		local w = (d.prog/100)*d.w-2
		dxDrawRRectangle(x+1+w-7, y-2, 14, 14,tocolor(51,52,53,255),7)
		--dxDrawText(d.prog,x+1+d.w/2+w-7,y-2+15,x+1+d.w/2+w-7+14,y-2+14+15,tocolor(255,255,255,255),1,"default","center","center")
	end
end

function dxGetProgressbar(element)
	if isElement(element) and getElementType(element) == "dxProgressbar" then
		return progressbar[element].prog
	end
end

function dxSetProgressbar(element,n)
	if isElement(element) and getElementType(element) == "dxProgressbar" then
		progressbar[element].prog = n
	end
end

--[[		Check box		 ]]--

local checkbox = {}

function dxCreateCheckbox(x,y,text, font)
	local theCheckbox = createElement("dxCheckbox-LOGIN")
	checkbox[theCheckbox] = {}
	checkbox[theCheckbox].data = {x=x,y=y,text=text,font=font, alpha=255,selected=false}
	return theCheckbox
end

function dxDrawCheckbox(element)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		local d = checkbox[element].data
		if (not d.textWidth) then
			d.textWidth = dxGetTextWidth(d.text,1,"default-bold")
		end
		local width = 15
		if d.text then width = 15+10+d.textWidth end
		if isMouseInPosition(d.x,d.y,width,15) then
			if getKeyState("mouse1") then
				if d.state ~= "down" then
					d.state = "down"
					d.selected = not d.selected
					triggerEvent("onClientdxButtonClick",localPlayer, element, d.selected)
				end
			else
				if d.state == "down" then
					if d.state ~= " up" then
						d.state = "up"
						--triggerEvent("onClientdxButtonClick",element,localPlayer,"up")
					end
				end
			end
		end
		
		local color = d.selected == false and tocolor(32,32,32,255) or tocolor(139,139,139,255)
		dxDrawRRectangle(d.x,d.y,14*xs,14*xs,tocolor(0,0,0,127.5),7*xs)
		dxDrawRRectangle(d.x+4*xs,d.y+4*xs,6*xs,6*xs,color,3*xs)
		--[[if d.selected == true then
			dxDrawText("✓",d.x,d.y,d.x+15,d.y+15,tocolor(191,191,191,d.alpha),1*(sX/1280),"default","center","center")
		end]]--
		if d.text then
			dxDrawText(d.text,d.x+10*xs+10*xs,d.y,d.x+15*xs+10+d.textWidth,d.y+15*xs,tocolor(255,255,255,255),1, d.font or "default-bold","left","center")
		end
	end
end

function dxCheckboxDestroy(element)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		checkbox[element] = nil
		destroyElement(element)
		return true
	end
end

function dxCheckboxSetAlpha(element,alpha)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		checkbox[element].data.alpha = alpha
		return true
	end
end

function dxCheckboxSetPosition(element,x,y)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		if x then checkbox[element].data.x = x end
		if y then checkbox[element].data.y = y end
		return true
	end
end

function dxCheckboxSetState(element,state)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		checkbox[element].data.selected = state
		return true
	end
end

function dxCheckboxGetState(element)
	if isElement(element) and getElementType(element) == "dxCheckbox-LOGIN" then
		return checkbox[element].data.selected
	end
end

--[[		Misc		 ]]--

local spamTick = 0;
function isSpam()
	if (getTickCount()-spamTick < 500) then
		return true;
	end
	return false;
end
function preventSpam()
	spamTick = getTickCount();
end