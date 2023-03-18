local ys = xs;

local headerFont = getFont("Ultra.ttf", 30*xs);
local font1 = getFont("Roboto-Medium.ttf", 10*xs);

local px, py = sx/2 - (1450*xs)/2, sy/2 - (810*ys)/2;
local ix, iy = px, py+35*ys;
local lx, ly = px+ 1450*xs-300*xs, py;

local refreshPageTimer;
local currentPage = "";
local currentService = "";
local services = {{name="youtube"}} -- {name="twitch"}
local serviceURL = {
	["youtube"] = "https://www.youtube.com",
	--["twitch"] = "https://www.twitch.tv",
}

local visible = false;
local homePage = false;

local iconX, iconY = (ix+1450*xs-300*xs)/2 + ((( (128*xs)*#services )+((20*xs)*(#services-1)))/2), iy/2 + (810*ys-35*ys)/2
for i=1, #services do
	services[i].button = dxCreateButton(iconX, iconY, 128*xs, 128*ys, "data/images/ui/"..services[i].name..".png");
	iconX = iconX + 128*xs;
end

local browser;
local theBrowser;

local ipx = px + 7*xs;
local ipy = py + 7*ys;
local backButton = dxCreateButton(ipx, ipy, 21*xs, 21*ys, "<", font1, 1);
ipx = ipx + 21*xs + 10*xs
local forwardButton = dxCreateButton(ipx, ipy, 21*xs, 21*ys, ">", font1, 1);
ipx = ipx + 21*xs + 10*xs
local refreshButton = dxCreateButton(ipx, ipy, 21*xs, 21*ys, "data/images/ui/refresh.tga");
ipx = ipx + 21*xs + 10*xs
local homeButton = dxCreateButton(ipx, ipy, 21*xs, 21*ys, "data/images/ui/home.tga");
ipx = ipx + 21*xs + 5*xs + 750*xs + 10*xs
local reqButton = dxCreateButton(ipx, ipy, 255*xs, 21*ys, "Request URL", font1, 1);
local closeButton = dxCreateButton(lx+300*xs-21*xs-7*xs, ipy, 21*xs, 21*ys, "X", font1, 1);


myHistory = {};
local historyList = dxCreateList(lx, ly+67*xs, 300*xs, 743*ys) -- limit is 22
local clearButton = dxCreateButton(lx, ly+67*xs+743*ys-23*ys, 300*xs, 23*ys, "Clear", font1, 1);

local function drawPanel()
	dxDrawRectangle(px, py, 1450*xs-300*xs, 35*ys, tocolor(32, 34, 37))
	
	dxDrawButton(backButton);
	dxDrawButton(forwardButton);
	dxDrawButtonPicture(refreshButton);
	dxDrawButtonPicture(homeButton);
	dxDrawButton(reqButton);
	dxDrawRectangle(ipx-750*xs-10*xs, ipy, 750*xs, 21*ys, tocolor(200, 200, 200));
	dxDrawText(currentPage, ipx-750*xs-10*xs+10*xs, ipy, ipx-750*xs-10*xs+750*xs, ipy+21*ys, tocolor(0, 0, 0), 1, font1, "left", "center");
	
	if (homePage) then
		dxDrawRectangle(ix, iy, 1450*xs-300*xs, 810*ys-35*ys, tocolor(54, 57, 63));
		for i=1, #services do
			dxDrawButtonPicture(services[i].button);
		end
	end
	
	dxDrawRectangle(lx, ly, 300*xs, 810*ys, tocolor(47, 49, 54));
	dxDrawRectangle(lx, ly+65*xs, 300*xs, 2*ys, tocolor(35, 37, 39));
	dxDrawText("History" , lx, ly, lx+300*xs, ly+64*xs, tocolor(200, 200, 200), 1, headerFont, "center", "center");
	--dxDrawRectangle(lx, ly+67*xs, 300*xs, 743*ys);
	dxDrawHistoryList(historyList)
	dxDrawButton(clearButton);
	dxDrawButton(closeButton);
end
--addEventHandler("onClientRender", root, drawPanel);

function toggleHomePage(bool)
	homePage = bool;
	if (homePage) then
		guiSetVisible(browser, false);
		if (isTimer(refreshPageTimer)) then
			killTimer(refreshPageTimer);
		end
		currentPage = "Home Page";
		currentService = "";
	else
		guiSetVisible(browser, true);
		refreshPageTimer = setTimer(refreshURL, 1000, 0);
	end
end

local function onButtonClick(button)
	if (button == backButton) then
		navigateBrowserBack(theBrowser);
		return;
	elseif (button == forwardButton) then
		navigateBrowserForward(theBrowser);
		return;
	elseif (button == refreshButton) then
		reloadBrowserPage(theBrowser);
		return;
	elseif (button == homeButton) then
		toggleHomePage(true);
		return;
	elseif (button == closeButton) then
		closeVideoRequest();
		return;
	elseif (button == reqButton) then
		triggerServerEvent("requestVideo:"..currentService, localPlayer, getBrowserURL(theBrowser));
		closeVideoRequest()
	elseif (button == clearButton) then
		myHistory = {};
		setListData(historyList, myHistory);
	end
	for k,v in ipairs(services) do
		if (v.button == button) then
			toggleHomePage(false);
			currentService = v.name;
			loadBrowserURL( theBrowser, serviceURL[v.name] );
			break;
		end
	end
end

local function onHistoryClick(action, url, service)
	if (action == "play") then
		triggerServerEvent("requestVideo:"..service, localPlayer, url);
		closeVideoRequest()
	elseif (action == "delete") then
		for k,v in ipairs(myHistory) do
			if (v.url == url) then
				table.remove(myHistory, k);
				break;
			end
		end
	end
end
addEvent("onClientClick:history", true);

function refreshURL()
	currentPage = getBrowserURL(theBrowser);
end

function openVideoRequest()
	if (not visible) then
		addEventHandler("onClientRender", root, drawPanel);
		addEventHandler("onClientdxButtonClick", localPlayer, onButtonClick);
		addEventHandler("onClientClick:history", localPlayer, onHistoryClick);
		browser = guiCreateBrowser(ix, iy, 1450*xs-300*xs, 810*ys-35*ys, false,  false, false)
		theBrowser = guiGetBrowser(browser)
		visible = true;
		showCursor(true, "request");
		toggleHomePage(true)
	end
end

function closeVideoRequest()
	if (visible) then
		removeEventHandler("onClientRender", root, drawPanel);
		removeEventHandler("onClientdxButtonClick", localPlayer, onButtonClick);
		removeEventHandler("onClientClick:history", localPlayer, onHistoryClick);
		showCursor(false, "request");
		toggleHomePage(true);
		destroyElement(browser);
		visible = false;
	end
end

function isVideoRequestOpen()
	return visible;
end

addEventHandler("onClientElementDataChange", resourceRoot,
function(theKey, _, value)
	if (theKey == "lockedQueue") then
		if (not getElementData(localPlayer, "controlTheater")) then
			local playerTheater = getElementData(localPlayer, "theater");
			if (playerTheater) then
				playerTheater = playerTheater.name;
				if (value[playerTheater]) then
					closeVideoRequest()
					--outputChatBox(config.theaterText.."Queue has been locked", 255, 255, 255, true);
					return false;
				end
			end
		end
	end
end)

addEvent("addHistory", true);
addEventHandler("addHistory", localPlayer,
function(data)
	for k,v in ipairs(myHistory) do
		if (v.url == data.url) then
			table.remove(myHistory, k);
		end
	end
	if (#myHistory == 22) then
		table.remove(myHistory, #myHistory);
	end
	table.insert(myHistory, 1, data);
	setListData(historyList, myHistory);
end)

function saveHistory()
	if fileExists("@history.alw7sh") then fileDelete("@history.alw7sh") end
	if (#myHistory > 0) then
		local file = fileCreate("@history.alw7sh");
		if (file) then
			fileWrite(file, toJSON(myHistory));
			fileClose(file);
		end
	end
end
addEventHandler("onClientResourceStop", resourceRoot, saveHistory);
addEventHandler("onClientPlayerQuit", localPlayer, saveHistory);

function loadHistory()
	if (fileExists("@history.alw7sh")) then
		local file = fileOpen("@history.alw7sh");
		if (file) then
			myHistory = fromJSON(fileRead(file,  fileGetSize(file)));
			setListData(historyList, myHistory);
			fileClose(file);
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadHistory);