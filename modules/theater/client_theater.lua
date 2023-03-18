local static = dxCreateTexture("data/images/STATIC.tga")
local blackScreen = dxCreateTexture("data/images/standby.tga")
local screenShader = dxCreateShader("data/shaders/screen.fx");
local Screen = createBrowser(1280, 720,false,false);
dxSetShaderValue(screenShader,"gTexture",Screen)
local toRender = blackScreen;
local screenPosition;
local elements = {};

local thumbnails = {};

local fullscreen = false;

function toggleFullscreen()
	fullscreen = not fullscreen;
end

function setVolume(volume)
	setBrowserVolume(Screen, volume/100)
end

function toggleHD(bool)
	if (bool) then
		resizeBrowser(Screen, 1920, 1080);
	else
		resizeBrowser(Screen, 1280, 720);
	end
end

local function findTheater(theaterName)
	for k,v in ipairs(config.theaters) do
		if (v.name == theaterName) then
			return k;
		end
	end
	return false;
end

function destroyTheaterObjects()
	for k,v in ipairs(elements) do
		destroyElement(v);
	end
	elements = {};
end

function createTheaterObjects()
	local theaterName = getElementData(localPlayer, "theater");
	if (theaterName) then
		theaterName = theaterName.name;
		local cPosition = config.cinema.position;
		local theater = findTheater(theaterName);
		local objects = config.theaters[theater].objects;
		
		if (objects.seats and #objects.seats > 0) then
			for r=1, #objects.seats do
				local seat 		= objects.seats[r];
				local offsetx 	= 0;
				local offsety 	= 0;
				for s=1, seat[4] do
					local object 	= createObject(1562, cPosition[1] + seat[1]+offsetx, cPosition[2] + seat[2]+offsety, cPosition[3] + seat[3], 0, 0, seat[7]);
					table.insert(elements, object);
					local x, y ,z 	= getPositionFromElementOffset(object,0,-1,0);
					local marker 	= alw7shMarker(x, y, z, 0.5);
					table.insert(elements, marker);
					setElementData(marker, "action", {name="tsSit", element=object, id=r.."-"..s}, false)
					offsetx = offsetx + seat[5];
					offsety = offsety + seat[6];
				end
			end
		end
		
		if (objects.objects and #objects.objects > 0) then
			for r=1, #objects.objects do
				local object 	= objects.objects[r];
				local obj 		= createObject(object[1], cPosition[1] + object[2], cPosition[2] + object[3], cPosition[3] + object[4], object[5], object[6], object[7]);
				table.insert(elements, obj);
			end
		end
		
		if (#objects.bigSofa and #objects.bigSofa > 0) then
			for r=1, #objects.bigSofa do
				local object 	= objects.bigSofa[r];
				local obj 		= createObject(object[1], cPosition[1] + object[2], cPosition[2] + object[3], cPosition[3] + object[4], object[5], object[6], object[7]);
				table.insert(elements, obj);
				local x, y ,z 	= getPositionFromElementOffset(obj,-0.05,0.9,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=1, id=r.."-1"}, false)
				local x, y ,z = getPositionFromElementOffset(obj,0.45,1,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=2, id=r.."-2"}, false)
				local x, y ,z = getPositionFromElementOffset(obj,0.8,1.3,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=3, id=r.."-3"}, false)
				local x, y ,z = getPositionFromElementOffset(obj,0.95,1.8,0);
				local marker = alw7shMarker(x, y, z,0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=4, id=r.."-4"}, false)
				
				local x, y ,z = getPositionFromElementOffset(obj,-0.45-0.1,1,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=5, id=r.."-5"}, false)
				local x, y ,z = getPositionFromElementOffset(obj,-0.8-0.1,1.3,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=6, id=r.."-6"}, false)
				local x, y ,z = getPositionFromElementOffset(obj,-0.95-0.1,1.8,0);
				local marker = alw7shMarker(x, y, z, 0.35);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="couchSit", element=obj, seat=7, id=r.."-7"}, false)
			end
		end
		
		if (objects.redSofa and #objects.redSofa > 0) then
			for r=1, #objects.redSofa do
				local object 	= objects.redSofa[r];
				local obj 		= createObject(object[1], cPosition[1] + object[2], cPosition[2] + object[3], cPosition[3] + object[4], object[5], object[6], object[7]);
				table.insert(elements, obj);
				local x, y ,z 	= getPositionFromElementOffset(obj,-0.2,-0.9,0);
				local marker = alw7shMarker(x, y, z, 0.4);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="redcouchSit", element=obj, seat=1, id=r.."-1"}, false)
				local x, y ,z 	= getPositionFromElementOffset(obj,-0.9,-0.9,0);
				local marker = alw7shMarker(x, y, z, 0.4);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="redcouchSit", element=obj, seat=2, id=r.."-2"}, false)
				local x, y ,z 	= getPositionFromElementOffset(obj,-1.8,-0.9,0);
				local marker = alw7shMarker(x, y, z, 0.4);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="redcouchSit", element=obj, seat=3, id=r.."-3"}, false)
				local x, y ,z 	= getPositionFromElementOffset(obj,-2.5,-0.9,0);
				local marker = alw7shMarker(x, y, z, 0.4);
				table.insert(elements, marker);
				setElementData(marker, "action", {name="redcouchSit", element=obj, seat=4, id=r.."-4"}, false)
			end
		end
		
	end
end

function videoInfo()
	injectBrowserMouseMove(Screen, math.random(2,3), math.random(2,3));
	--injectBrowserMouseMove(Screen, math.random(1,2), math.random(1,2));
end

local function drawTheaterScreen()
	if (not fullscreen) then
		dxDrawMaterialLine3D(screenPosition[1], screenPosition[2], screenPosition[3], screenPosition[4], screenPosition[5], screenPosition[6], toRender, screenPosition[7], tocolor(255, 255, 255), false, screenPosition[8], screenPosition[9], screenPosition[10]);
	else
		dxDrawImage(0, 0, sx, sy, toRender);
	end
end

local function updateTheaterThumbnail(theaterName, friendlyName, title, image)
	if not thumbnails[theaterName] then
		local t = findTheater(theaterName);
		thumbnails[theaterName] = {rt=dxCreateRenderTarget(512, 256, true), previewPosition=config.theaters[t].previewPosition};
		local cPosition 		= config.cinema.position;
		thumbnails[theaterName].previewPosition[1] 	= cPosition[1] + thumbnails[theaterName].previewPosition[1];
		thumbnails[theaterName].previewPosition[2] 	= cPosition[2] + thumbnails[theaterName].previewPosition[2];
		thumbnails[theaterName].previewPosition[3] 	= cPosition[3] + thumbnails[theaterName].previewPosition[3];
		thumbnails[theaterName].previewPosition[4] 	= cPosition[1] + thumbnails[theaterName].previewPosition[4];
		thumbnails[theaterName].previewPosition[5] 	= cPosition[2] + thumbnails[theaterName].previewPosition[5];
		thumbnails[theaterName].previewPosition[6] 	= cPosition[3] + thumbnails[theaterName].previewPosition[6];
		thumbnails[theaterName].previewPosition[8] 	= cPosition[1] + thumbnails[theaterName].previewPosition[8];
		thumbnails[theaterName].previewPosition[9] 	= cPosition[2] + thumbnails[theaterName].previewPosition[9];
		thumbnails[theaterName].previewPosition[10] = cPosition[3] + thumbnails[theaterName].previewPosition[10];
	end
	dxSetRenderTarget(thumbnails[theaterName].rt, true);
		dxDrawImage(0, 0, 512, 256, image or static);
		dxDrawText(friendlyName, 0, 15, 512, nil, tocolor(255, 255, 255), 3, "default-bold", "center");
		dxDrawText(title, 10, 220, 512, nil, tocolor(255, 255, 255), 2, "default-bold", "left");
	dxSetRenderTarget();
end
local function dxDrawPreviewScreen()
	for k,v in pairs(thumbnails) do
		local data = v.previewPosition;
		dxDrawMaterialLine3D(data[1], data[2], data[3], data[4], data[5], data[6], v.rt, data[7], tocolor(255, 255, 255), false, data[8], data[9], data[10]);
	end
end

addEvent("onPlayerJoinTheater", true);
addEventHandler("onPlayerJoinTheater", root,
function(sp, myVotes)
	removeEventHandler("onClientPreRender", root, dxDrawPreviewScreen);
	--[[for k,v in pairs(thumbnails) do
		destroyElement(v.rt);
	end
	thumbnails = {};]]
	createTheaterObjects();
	screenPosition = sp;
	queueVotes = myVotes
	addEventHandler("onClientPreRender", root, drawTheaterScreen);
	bindKey("q", "down", openQueue);
	bindKey("q", "up", closeQueue);
	fadeCamera(true);
end)

addEvent("onPlayerQuitTheater", true);
addEventHandler("onPlayerQuitTheater", root,
function()
	if (fullscreen) then
		toggleFullscreen();
	end
	destroyTheaterObjects()
	removeEventHandler("onClientPreRender", root, drawTheaterScreen);
	screenPosition = nil;
	unbindKey("q", "down", openQueue);
	unbindKey("q", "up", closeQueue);
	vote = {};
	closeQueue();
	closeVideoRequest();
	closeTheaterControl();
end)


--[[addEventHandler("onClientBrowserResourceBlocked", Screen, function(url, domain, reason)
	if (reason == 2) then return end;
	if (not domain) then return end;
	requestBrowserDomains({domain}, false, function(accepted, newDomains)
		if (accepted == true) then
			reloadBrowserPage(Screen)
		end
	end)
end)]]--

addEvent("playVideo", true);
addEventHandler("playVideo", root,
function(service, url, tim)
	closeSeek()
	if (url) then
		if (tim) then
			url = url.."&start="..tim;
		end
		--toggleBrowserDevTools(Screen, true)
		loadBrowserURL(Screen, url);
		injectBrowserMouseDown(Screen,'left');
		toRender = screenShader;
	else
		loadBrowserURL(Screen, "https://www.youtube.com");
		injectBrowserMouseDown(Screen,'left');
		toRender = blackScreen;
	end
end)

local function thumbnailCallback(data, errno, theaterName, friendlyName, title)
	if (errno == 0) then
		local thumbnail = dxCreateTexture(data);
		updateTheaterThumbnail(theaterName, friendlyName, title, thumbnail)
		destroyElement(thumbnail);
	end
end

addEvent("downloadThumbnail", true);
addEventHandler("downloadThumbnail", root,
function(url, theaterName, friendlyName, title)
	if (#thumbnails == 0) then
		addEventHandler("onClientPreRender", root, dxDrawPreviewScreen);
	end
	if (type(url) == "string") then
		if (url == "") then
			updateTheaterThumbnail(theaterName, friendlyName, "No Video Playing");
			return;
		end
		fetchRemote(url, "thumbnails", 10, 10000, thumbnailCallback, "", false, theaterName, friendlyName, title)
	elseif (type(url) == "table") then
		for k,v in ipairs(url) do
			if (v.url == "") then
				updateTheaterThumbnail(v.theaterName, v.friendlyName, "No Video Playing");
			else
				fetchRemote(v.url, "thumbnails", 10, 10000, thumbnailCallback, "", false, v.theaterName, v.friendlyName, v.title)
			end
		end
	end
end)

local sx, sy = guiGetScreenSize();
addEventHandler("onClientRender", root,
function()
	--[[local x, y = 5, sy/2 - 450/2;
	dxDrawRectangle(x, y, 250, 450, tocolor(47, 49, 54));
	--dxDrawRectangle(x+2, y+2, 250-4, 450-4, tocolor(22, 160, 133));
	dxDrawRectangle(x, y, 250, 60, tocolor(32, 34, 37));
	
	yy = y + 60;
	
	yy = y + 450 - 120 - 9 - 3;
	dxDrawRectangle(x+3, yy, 250-6, 30, tocolor(255, 255, 255, 20));
	yy = yy + 30 + 3
	dxDrawRectangle(x+3, yy, 250-6, 30, tocolor(255, 255, 255, 20));
	yy = yy + 30 + 3
	dxDrawRectangle(x+3, yy, 250-6, 30, tocolor(255, 255, 255, 20));
	yy = yy + 30 + 3
	dxDrawRectangle(x+3, yy, 250-6, 30, tocolor(255, 255, 255, 20));]]
end)