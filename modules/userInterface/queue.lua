local xs, ys = 1, 1;

local headerFont = getFont("Ultra.ttf", 30*xs);
local font1 = getFont("Roboto-Medium.ttf", 10*xs);

queueVotes = {};

local px, py = 5*xs, sy/2 - (450*ys)/2;
local bx, by = px+3*xs, py + 450*ys - 120*ys - 9*ys - 3*ys;

local visible = false;

local queueList			= dxCreateList(px+3*xs, py+60*ys+3*ys, 225*xs-6*xs, 250*ys);

local reqButton 		= dxCreateButton(bx, by, 225*xs-6*xs, 30*ys, "Request Video", font1, 1);
local vskipButton 		= dxCreateButton(bx, by+((30*ys)*1)+((3*ys)*1), 225*xs-6*xs, 30*ys, "Vote Skip", font1, 1);
local fullscreenButton	= dxCreateButton(bx, by+((30*ys)*2)+((3*ys)*2), 225*xs-6*xs, 30*ys, "Toggle Fullscreen", font1, 1);
local refreshButton 	= dxCreateButton(bx, by+((30*ys)*3)+((3*ys)*3), 225*xs-6*xs, 30*ys, "Refresh Theater", font1, 1);

local function drawPanel()
	dxDrawRectangle(px, py, 225*xs, 450*ys, tocolor(47, 49, 54));
	--dxDrawRectangle(x+2, y+2, 250-4, 450-4, tocolor(22, 160, 133));
	dxDrawRectangle(px, py, 225*xs, 60*ys, tocolor(32, 34, 37));
	dxDrawText("Queue", px, py, px+225*xs, py+60*ys, tocolor(200, 200, 200),1, headerFont, "center", "center");
	
	--yy = y + 60;
	dxDrawList(queueList);
	
	dxDrawButton(reqButton);
	dxDrawButton(vskipButton);
	dxDrawButton(fullscreenButton);
	dxDrawButton(refreshButton);
end

local function onButtonClick(button)
	if (button == reqButton) then
		if isSpam() then return end;
		preventSpam();
		if (not getElementData(localPlayer, "controlTheater")) then
			local locked = getElementData(resourceRoot, "lockedQueue");
			local theaterName = getElementData(localPlayer, "theater").name;
			if (locked[theaterName]) then
				outputChatBox(config.theaterText.."Queue is locked", 255, 255, 255, true);
				return false;
			end
		end
		openVideoRequest();
	elseif (button == vskipButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("voteskip", localPlayer)
	elseif (button == fullscreenButton) then
		if isSpam() then return end;
		preventSpam();
		toggleFullscreen();
	elseif (button == refreshButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("refreshTheater", localPlayer)
	end
end
addEvent("onClientdxButtonClick", true);

local function onVote(vote, url)
	triggerServerEvent("voteVideo", localPlayer, url, vote)
end
addEvent("onClientVote", true);

function openQueue()
	visible = true;
	videoInfo()
	addEventHandler("onClientRender", root, drawPanel);
	addEventHandler("onClientdxButtonClick", localPlayer, onButtonClick);
	addEventHandler("onClientVote", localPlayer, onVote);
	showCursor(true, "queue");
	dxListEnableScroll(queueList, true);
	if (getElementData(localPlayer, "controlTheater")) then
		openTheaterControl();
	end
end

function closeQueue()
	visible = false;
	--closeVideoRequest()
	removeEventHandler("onClientRender", root, drawPanel);
	removeEventHandler("onClientdxButtonClick", localPlayer, onButtonClick);
	removeEventHandler("onClientVote", localPlayer, onVote);
	showCursor(false, "queue");
	dxListEnableScroll(queueList, false);
	if (getElementData(localPlayer, "controlTheater")) then
		closeTheaterControl();
	end
end

function isQueueOpen()
	return visible;
end

function toggleQueue()
	if (not visible) then
		openQueue();
	else
		closeQueue();
	end
end

addEvent("updateQueue", true)
addEventHandler("updateQueue", root,
function(queue)
	setListData(queueList, queue)
end)

addEvent("updateMyVotes", true)
addEventHandler("updateMyVotes", root,
function(url, vote)
	queueVotes[url] = vote;
end)