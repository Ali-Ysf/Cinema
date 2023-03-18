addEvent("playVideo:youtube", true);
addEventHandler("playVideo:youtube", root,
function(url, tim)
	closeSeek()
	if (url) then
		if (tim) then
			url = url.."&start="..tim;
		end
		loadBrowserURL(Screen, url);
		injectBrowserMouseDown(Screen,'left');
		toRender = screenShader;
	else
		loadBrowserURL(Screen, "https://www.youtube.com");
		injectBrowserMouseDown(Screen,'left');
		toRender = blackScreen;
	end
end)

addEvent("playVideo:twitch", true);
addEventHandler("playVideo:twitch", root,
function(url)
	closeSeek()
	if (url) then
		loadBrowserURL(Screen, url);
		injectBrowserMouseDown(Screen,'left');
		toRender = screenShader;
	else
		loadBrowserURL(Screen, "https://www.twitch.tv");
		injectBrowserMouseDown(Screen,'left');
		toRender = blackScreen;
	end
end)