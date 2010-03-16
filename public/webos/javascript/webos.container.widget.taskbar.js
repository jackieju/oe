var $taskbar = window.$webos.$taskbar = {};
$taskbar.id = $webos.id + "Taskbar";
$taskbar.taskbarId = $taskbar.id;
$taskbar.getTaskbar = function(){
	return $("#" + $taskbar.taskbarId);
};
$taskbar.initial = function(){
	$taskbar.displayTime();
	$taskbar.displayHead();
	//start
	$("#webosTaskbarStartShutDown").click(function(){
		var message = "Shut down now?";
		if($.browser.mozilla){
			message += "\n\nWe detected you are using Firefox, your browser may be not closed correctly by us.";
			message += "\n\nPlease:";
			message += '\n1. Type "about:config" in the address bar of Firefox;';
			message += '\n2. Change the value of "dom.allow_scripts_to_close_windows" into "true";';
			message += '\n\nThank you and have fun!';
		}
		if(confirm(message)){
			opener = window;
			close();
//			top.window.opener = top;
//			top.window.open('','_parent','');
//			top.window.close();
		}
	});
    $("#webosTaskbarHelpAbout").click(
        function(){
            alert('Monweb Desktop v0.6\n欢迎试用');
        }
    );
	$("#webosTaskbarStartLogOff").click(function(){
		location = "webos_logout.jsp";
	});
	$("#webosTaskbarStartControlPanel").click(function(){
		$widget.start("controlpanel");
	});
	$("#webosTaskbarStartUser").click(function(){
		$widget.start("controlpanel");
	});
	//program
	$("#webosTaskbarStartProgramBookmark").click(function(){
		$widget.start("bookmark");
	});
	$("#webosTaskbarStartProgramSinaNews").click(function(){
        $widget.start("sinanews");
    });
	$("#webosTaskbarStartProgramRSS").click(function(){
		$widget.start("rss");
	});
	$("#webosTaskbarStartProgramPicture").click(function(){
		$widget.start("picture");
	});
	$("#webosTaskbarStartProgramDiggNews").click(function(){
		$widget.start("diggnews");
	});
	$("#webosTaskbarStartProgramGoogleNews").click(function(){
		$widget.start("googlenews");
	});
	$("#webosTaskbarStartProgramCNNNews").click(function(){
		$widget.start("cnnnews");
	});
	$("#webosTaskbarStartProgramMoonPhase").click(function(){
		$widget.start("moonphase");
	});
	$("#webosTaskbarStartProgramTranslate").click(function(){
		$widget.start("translate");
	});
	$("#webosTaskbarStartProgramWeather").click(function(){
		$widget.start("weather");
	});
	$("#webosTaskbarStartProgramIPTracker").click(function(){
		$widget.start("iptracker");
	});
	$("#webosTaskbarStartProgramChineseDate").click(function(){
		$widget.start("chinesedate");
	});
	$("#webosTaskbarStartProgramNote").click(function(){
		$widget.start("note");
	});
	$("#webosTaskbarStartProgramHotmail").click(function(){
		$widget.start("hotmail");
	});
	$("#webosTaskbarStartProgramGmail").click(function(){
		$widget.start("gmail");
	});
	$("#webosTaskbarStartProgramMSN").click(function(){
		$widget.start("msn");
	});
	$("#webosTaskbarStartProgramGTalk").click(function(){
		$widget.start("gtalk");
	});
	$("#webosTaskbarStartProgramScratchPad").click(function(){
		$widget.add({
			name : "ScratchPad",
			title : "ScratchPad",
			contentWidth : 460,
			contentHeight : 430,
			isResizable : true,
			type : "iframe",
			src : "/ModelServlet?req=tagModel&model=scratchpad&output=innerHtml"
		});
	});
	$("#webosTaskbarStartProgramTodo").click(function(){
		$widget.add({
			name : "Todo",
			title : "Todo",
			contentWidth : 460,
			contentHeight : 430,
			isResizable : true,
			type : "ajax",
			src : $app.urls.todoInit,
			callback : "$app.$todo.init();"
		});
	});
	$("#webosTaskbarStartProgramStock").click(function(){
		$widget.start("stock");
	});
	$("#webosTaskbarStartProgramMusicPlayer").click(function(){
		$widget.start("musicplayer");
	});
	$("#webosTaskbarStartProgramCalculator").click(function(){
		$widget.start("calculator");
	});
	$("#webosTaskbarStartProgramDictionary").click(function(){
		$widget.start("dictionary");
	});
	//view
	$("#webosTaskbarViewThemeTiger").click(function(){
		$theme.set("tiger");
	});
	$("#webosTaskbarViewThemeLeopard").click(function(){
		$theme.set("leopard");
	});
	$("#webosTaskbarViewAlpha").click(function(){
		$widget.isAlphaOnAction = !$widget.isAlphaOnAction;
		document.getElementById("webosTaskbarViewAlphaCheckbox").checked = $widget.isAlphaOnAction;
	});
	$("#webosTaskbarViewShowDesktop").click(function(){
		for(var i = 0; i < $widget.items.length; i++){
			$widget.items[i].css({
				display : "none",
				visibility : "visible"
			});
		}
	});

	//window
	$("#webosTaskbarWindowBookmark").click(function(){
		$widget.start("bookmark");
	});
	$("#webosTaskbarWindowRSS").click(function(){
		$widget.start("rss");
	});
	$("#webosTaskbarWindowPicture").click(function(){
		$widget.start("picture");
	});
	$("#webosTaskbarWindowDiggNews").click(function(){
		$widget.start("diggnews");
	});
    $("#webosTaskbarWindowSinaNews").click(function(){
        $widget.start("sinanews");
    });
	$("#webosTaskbarWindowGoogleNews").click(function(){
		$widget.start("googlenews");
	});
	$("#webosTaskbarWindowCNNNews").click(function(){
		$widget.start("cnnnews");
	});
	$("#webosTaskbarWindowMoonPhase").click(function(){
		$widget.start("moonphase");
	});
	$("#webosTaskbarWindowWeather").click(function(){
		$widget.start("weather");
	});
	$("#webosTaskbarWindowIPTracker").click(function(){
		$widget.start("iptracker");
	});
	$("#webosTaskbarWindowChineseDate").click(function(){
		$widget.start("chinesedate");
	});
	$("#webosTaskbarWindowNote").click(function(){
		$widget.start("note");
	});
	$("#webosTaskbarWindowHotmail").click(function(){
		$widget.start("hotmail");
	});
	$("#webosTaskbarWindowGmail").click(function(){
		$widget.start("gmail");
	});
	$("#webosTaskbarWindowMSN").click(function(){
		$widget.start("msn");
	});
	$("#webosTaskbarWindowGTalk").click(function(){
		$widget.start("gtalk");
	});
	$("#webosTaskbarWindowMusicPlayer").click(function(){
		$widget.start("musicplayer");
	});
	$("#webosTaskbarWindowCalculator").click(function(){
		$widget.start("calculator");
	});
    $("#webosTaskbarStartProgramTrainInfo").click(function(){
        $widget.start("traininfo");
    });
	$("#webosTaskbarWindowTrainInfo").click(function(){
		$widget.start("traininfo");
	});
	$("#webosTaskbarWindowDictionary").click(function(){
		$widget.start("dictionary");
	});
	$("#webosTaskbarWindowTodo").click(function(){
		$widget.add({
			name : "Todo",
			title : "Todo",
			contentWidth : 460,
			contentHeight : 430,
			isResizable : true,
			type : "ajax",
			src : $app.urls.todoInit,
			callback : "$app.$todo.init();"
		});
	});
	$("#webosTaskbarWindowStock").click(function(){
		$widget.start("stock");
	});
    $("#webosTaskbarWindowTranslate").click(function(){
        $widget.start("translate");
    });
    $("#webosTaskbarWindowHotalSearch").click(function(){
        $widget.start("hotalsearch");
    });
    $("#webosTaskbarStartProgramHotalSearch").click(function(){
        $widget.start("hotalsearch");
    });
	$("#webosTaskbarWindowScratchPad").click(function(){
		$widget.add({
			name : "ScratchPad",
			title : "ScratchPad",
			contentWidth : 460,
			contentHeight : 430,
			isResizable : true,
			type : "iframe",
			src : "/ModelServlet?req=tagModel&model=scratchpad&output=innerHtml"
		});
	});
	//search
	$("#webosTaskbarNotificationSearch").click(function(){
		if($("#webosTaskbarNotificationSearchPanel").css("display") == "none"){
			$("#webosTaskbarNotificationSearchPanel").css({
				display : "block"
			});
			this.className = "webos-taskbar-notification-seach-active";
		}
		else{
			$("#webosTaskbarNotificationSearchPanel").css({
				display : "none"
			});
			this.className = "webos-taskbar-notification-seach";
		}
	});
	$("#webosTaskbarNotificationSearch").mouseover(function(){
		if(this.className != "webos-taskbar-notification-seach-active"){
			this.className = "webos-taskbar-notification-seach-active";
		}
	});
	$("#webosTaskbarNotificationSearch").mouseout(function(){
		if(this.className == "webos-taskbar-notification-seach-active" && $("#webosTaskbarNotificationSearchPanel").css("display") == "none"){
			this.className = "webos-taskbar-notification-seach";
		}
	});
	$("#webosTaskbarNotificationSearchPanelAction").click(function(){
		var keyword = $("#webosTaskbarNotificationSearchPanelKeyword").val();
		if(keyword != ""){
			keyword = encodeURI(keyword);
			var select = $("#webosTaskbarNotificationSearchPanelEngine")[0];
			var engine = select.options[select.selectedIndex].value;
			var url = "";
			switch(engine){
				case "google":
					url = "http://www.google.com/search?q=" + keyword;
					break;
				case "baidu":
					url = "http://www.baidu.com/s?ie=utf-8&wd=" + keyword;
					break;
				default:
					url = "http://www.google.com/search?q=" + keyword;
					break;
			}
			open(url);
		}
	});
    //music player actions
//    $("#webosTaskbarNotificationMusicPlayer").click(function(){
//		if($("#webosTaskbarNotificationMusicPlayerPanel").css("display") == "none"){
//			$("#webosTaskbarNotificationMusicPlayerPanel").css({
//	        	display : "block"
//			});
//		//	this.className = "webos-taskbar-notification-seach-active";
//		}
//		else{
//			$("#webosTaskbarNotificationMusicPlayerPanel").css({
//				display : "none"
//			});
//		//	this.className = "webos-taskbar-notification-seach";
//		}
//    });
};
$taskbar.timerId = $taskbar.id + "NotificationTime";
$taskbar.timeDuration = 60000;
$taskbar.displayTime = function(){
	var date = (new Date()).toLocaleDateString();
	var display = function(){
		var now = new Date();
		var hour = now.getHours().toString();
		if(hour.length == 1){
			hour = "0" + hour;
		}
		var minute = now.getMinutes().toString();
		if(minute.length == 1){
			minute = "0" + minute;
		}
		$("#" + $taskbar.timerId).text(date + " " + hour + ":" + minute);
		setTimeout(display, $taskbar.timeDuration);
	};
	display();
};
$taskbar.displayHead = function(){
	$.post("/getuserpicture", {}, function(response){
		if(response){
			$("#webosTaskbarStartUser").css({
				backgroundImage : "url(" + response + ")"
			});
		}
	});
};
