local xs, ys = 1, 1;

local showSeek = false;
local seekTime = 0;
local videoDuration = 0;

local headerFont 	= getFont("Ultra.ttf", 15*xs);
local font1 		= getFont("Roboto-Medium.ttf", 10*xs);

local px, py 		=sx-225*xs-5*xs, sy/2 - (450*ys)/2;

local by 			= py+60*ys+5*xs;
local skipButton 	= dxCreateButton(px+3*xs, by, 225*xs-6*xs, 30*ys, "Skip Video", font1, 1);
by 					= by+30*ys+3*ys;
local seekButton 	= dxCreateButton(px+3*xs, by, 225*xs-6*xs, 30*ys, "Seek", font1, 1);
by 					= by+30*ys+3*ys;
local resetButton 	= dxCreateButton(px+3*xs, by, 225*xs-6*xs, 30*ys, "Reset", font1, 1);
by 					= by+30*ys+3*ys;
local lockButton 	= dxCreateButton(px+3*xs, by, 225*xs-6*xs, 30*ys, "Toggle Queue Lock", font1, 1);
by 					= by+30*ys+3*ys;
by 					= by+2*ys;
local playersList 	= dxCreateList(px+3*xs, by, 225*xs-6*xs, 250*ys);
local seekSlider	= dxCreateProgressbar(px+10*xs, by+10*ys, 190*ys);
local setSeek	 	= dxCreateButton(px+10*xs, by+10*ys+20*ys+30*xs, 70*xs, 30*ys, "Apply", font1, 1);
local cancelSeek	= dxCreateButton(px+10*xs+70*xs+5*xs, by+10*ys+20*ys+30*xs, 70*xs, 30*ys, "Cancel", font1, 1);

local tempTable = {};
for i=1,20 do 
	table.insert(tempTable, {name=getPlayerName(localPlayer), player=localPlayer});
end
setListData(playersList, tempTable);

local function drawPanel()
	dxDrawRectangle(px, py, 225*xs, 450*ys, tocolor(47, 49, 54));
	--dxDrawRectangle(x+2, y+2, 250-4, 450-4, tocolor(22, 160, 133));
	dxDrawRectangle(px, py, 225*xs, 60*ys, tocolor(32, 34, 37));
	dxDrawText("Theater Control", px, py, px+225*xs, py+60*ys, tocolor(200, 200, 200),1, headerFont, "center", "center");
	
	dxDrawButton(skipButton);
	dxDrawButton(seekButton);
	dxDrawButton(resetButton);
	dxDrawButton(lockButton);
	
	dxDrawPlayersList(playersList);
	
	if (showSeek) then
		dxDrawRectangle(px+3*xs, by, 225*xs-6*xs, 250*ys, tocolor(0, 0, 0, 220))
		dxDrawProgressbar(seekSlider, nil, nil, 0, 0)
		dxDrawButton(setSeek);
		dxDrawButton(cancelSeek);
		dxDrawText(SecondsToClock(seekTime), px+10*xs, by+10*ys+20*ys, px+10*xs+190*ys, by+10*ys+20*ys+30*ys, tocolor(255, 255, 255, 255), 1, font1, "right", "center");
	end
	
	--yy = y + 60;
end

local function onButtonClickTC(button)
	if (source ~= localPlayer) then return end;
	if (button == skipButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("skipVideo", localPlayer);
	elseif (button == seekButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("getVideoLength", localPlayer);
	elseif (button == resetButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("resetTheater", localPlayer);
	elseif (button == lockButton) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("toggleTheaterLock", localPlayer);
	elseif (button == setSeek) then
		if isSpam() then return end;
		preventSpam();
		triggerServerEvent("onPlayerSeek", localPlayer, seekTime);
	elseif (button == cancelSeek) then
		closeSeek();
	end
end
addEvent("onClientdxButtonClick", true);

function onSeekSliderChange(element, prog)
	if (element == seekSlider) then
		local prog = prog/100;
		seekTime = videoDuration*prog;
	end
end
addEvent("onClientProgressbarChanged", true);

function onClientKickPlayer(player)
	if isSpam() then return end;
	preventSpam();
	triggerServerEvent("theaterKickPlayer", localPlayer, player);
end
addEvent("onClickKickPlayer", true);

function openTheaterControl()
	addEventHandler("onClientRender", root, drawPanel);
	addEventHandler("onClientdxButtonClick", localPlayer, onButtonClickTC);
	addEventHandler("onClientProgressbarChanged", localPlayer, onSeekSliderChange);
	addEventHandler("onClickKickPlayer", localPlayer, onClientKickPlayer);
end

function closeTheaterControl()
	removeEventHandler("onClientRender", root, drawPanel);
	removeEventHandler("onClientdxButtonClick", localPlayer, onButtonClickTC);
	removeEventHandler("onClientProgressbarChanged", localPlayer, onSeekSliderChange);
	removeEventHandler("onClickKickPlayer", localPlayer, onClientKickPlayer);
	
	closeSeek()
end

function closeSeek()
	showSeek = false;
	seekTime = 0;
	videoDuration = 0;
	
	dxListSetEnabled(playersList, true);
end

addEvent("showSeek", true)
addEventHandler("showSeek", root,
function(length)
	if (length > 30) then
		showSeek = true;
		seekTime = 0;
		videoDuration = length-5;
		dxSetProgressbar(seekSlider, 0);
		
		dxListSetEnabled(playersList, false);
	else
		outputChatBox(config.theaterText.."Video is too short.", 255, 255, 255, true)
	end
end)