var $widget = window.$webos.$widget = {};
$widget.id = $webos.id + "Widget";
$widget.zBase = 200000;
$widget.isContentsOpen = true;
$widget.isAlphaOnAction = false;
$widget.defaultContentWidth = 330;
$widget.defaultContentHeight = 350;
$widget.transferHelperId = $widget.id + "TransferHelper";
$widget.transferHelper = $('<div id="' + $widget.transferHelperId + '" class="webos-widget-transfer"></div>');
$widget.transferDuration = 600;
$widget.saveDuration = 5000;
$widget.saveJSONString = "";
$widget.items = [];
$widget.initial = function(){
	$widget.restore();
};
$widget.enableAlpha = function(widget){
	widget.css({
		filter : "alpha(opacity=50)",
		opacity: "0.5"
	});
};
$widget.disableAlpha = function(widget){
	widget.css({
		filter : "alpha(opacity=100)",
		opacity: "1"
	});
};
//must in $(document).ready
$widget.add = function(options){
	for(var i = 0; i < $widget.items.length; i++){
		if($widget.items[i].widgetOptions.name == options.name){
			$widget.setZIndexes($widget.items[i]);
			return;
		}
	}
	if(options.type == "ajax"){
		$.get(options.src + (options.src.indexOf("?") > 0 ? "&" : "?") + "id=" + Math.random(), function(response){
			options.ajaxResponse = response;
			$widget.createWidget(options, $widget.items.length);
		});
	}
	else{
		$widget.createWidget(options, $widget.items.length);
	}
};
$widget.remove = function(widget){
	$dock.remove(widget);
	$widget.items.splice(widget.widgetOptions.z, 1);
	widget.remove();
	$dock.initial();
	delete widget;
};
$widget.createWidget = function(options, z){
	options.z = z;
	options.isMaximizable = (options.isResizable == true) && (!!options.contentMaxWidth == false) && (!!options.contentMaxHeight == false);
	if(!options.contentWidth){
		options.contentWidth = $widget.defaultContentWidth;
	}
	if(!options.contentHeight){
		options.contentHeight = $widget.defaultContentHeight;
	}
	if(!options.left){
		options.left = $widget.getLeftByWidth(options.contentWidth);
	}
	if(!options.top){
		options.top = $widget.getTopByHeight(options.contentHeight);
	}
	if(!options.title){
		options.title = options.name;
	}
	//id
	options.widgetId = $widget.id + options.name;
	options.widgetTitleId = options.widgetId + "Title";
	options.widgetExpanderId = options.widgetId + "Expander";
	options.widgetDraggerId = options.widgetId + "Dragger";
	options.widgetMinimizerId = options.widgetId + "Minimizer";
	options.widgetMaximizerId = options.widgetId + "Maximizer";
	options.widgetCloserId = options.widgetId + "Closer";
	options.widgetBodyId = options.widgetId + "Body";
	options.widgetCenterId = options.widgetId + "Center";
	options.widgetContentId = options.widgetId + "Content";
	options.widgetHelperId = options.widgetId + "Helper";
	options.widgetResizerId = options.widgetId + "Resizer";
	options.widgetBottomId = options.widgetId + "Bottom";
    options.widgetLeftResizerId= options.widgetId+ "LeftResizer";
    options.widgetRightResizerId= options.widgetId+ "RightResizer";
	//title html
	var widgetExpanderHTML = '<a href="#" class="webos-widget-title-expander" title="Expand" id="' + options.widgetExpanderId + '">&nbsp;</a>';
	var widgetDraggerHTML = '<td class="webos-widget-title-text" id="' + options.widgetDraggerId + '">' + options.title + '</td>';
	var widgetMinimizerHTML = '<a href="#" class="webos-widget-title-minimizer" title="Minimize" id="' + options.widgetMinimizerId + '">&nbsp;</a>';
	var widgetMaximizerHTML;
	if(options.isMaximizable){
		widgetMaximizerHTML = '<a href="#" class="webos-widget-title-maximizer" title="Maximize / Restore" id="' + options.widgetMaximizerId + '">&nbsp;</a>';
	}
	else{
		widgetMaximizerHTML = '<a href="#" class="webos-widget-title-maximizer-invalid" title="Maximize is invalid" id="' + options.widgetMaximizerId + '">&nbsp;</a>';
	}
	var widgetCloserHTML = '<a href="#" class="webos-widget-title-closer" title="Close" id="' + options.widgetCloserId + '">&nbsp;</a>';
	var widgetTitleHTML =  '<div class="webos-widget-title" id="' + options.widgetTitleId + '">';
		widgetTitleHTML +=     '<table>';
		widgetTitleHTML +=         '<tr>';
		widgetTitleHTML +=             '<td class="webos-widget-shadow-nw">&nbsp;</td>';
		widgetTitleHTML +=             '<td class="webos-widget-title-left"></td>';
		widgetTitleHTML +=             '<td class="webos-widget-title-expand">'+ widgetExpanderHTML +'</td>';
		widgetTitleHTML +=             widgetDraggerHTML;
		widgetTitleHTML +=             '<td class="webos-widget-title-operation">' + widgetMinimizerHTML + widgetMaximizerHTML + widgetCloserHTML + '</td>';
		widgetTitleHTML +=             '<td class="webos-widget-title-right"></td>';
		widgetTitleHTML +=             '<td class="webos-widget-shadow-ne">&nbsp;</td>';
		widgetTitleHTML +=         '</tr>';
		widgetTitleHTML +=     '</table>';
		widgetTitleHTML += '</div>';
	//body html
	var widgetContentHTML = "&nbsp;";
	switch(options.type){
		case "iframe":
			var widgetContentIframeScrolling = "no";
			if(options.isContentIframeScrollable){
				widgetContentIframeScrolling = "yes";
			}
			widgetContentHTML = '<div class="webos-widget-body-content" id="' + options.widgetContentId + '"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" vspace="0" scrolling="' + widgetContentIframeScrolling + '" src="' + options.src + '" style="height:100%; width:100%;"></iframe></div>';
			break;
		case "img":
			widgetContentHTML = '<div class="webos-widget-body-content" id="' + options.widgetContentId + '"><img src="' + options.src + '" /></div>';
			break;
		case "html":
			widgetContentHTML = '<div class="webos-widget-body-content" id="' + options.widgetContentId + '">' + (options.src ? options.src : '&nbsp;') + '</div>';
			break;
		case "ajax":
			widgetContentHTML = '<div class="webos-widget-body-content" id="' + options.widgetContentId + '">' + (options.ajaxResponse ? options.ajaxResponse : '&nbsp;') + '</div>';
			break;
	}
	var widgetCenterHTML = '<td class="webos-widget-body-center" id="' + options.widgetCenterId + '">' + widgetContentHTML + '</td>';
	var widgetHelperHTML = '<div class="webos-widget-helper" id="' + options.widgetHelperId + '"></div>';
		widgetBodyHTML =  '<div class="webos-widget-body" id="' + options.widgetBodyId + '">';
		widgetBodyHTML +=     '<table>';
		widgetBodyHTML +=         '<tr>';
		widgetBodyHTML +=             '<td class="webos-widget-shadow-w">&nbsp;</td>';
        widgetBodyHTML +=             '<td class="webos-widget-body-left" />';
		widgetBodyHTML +=             widgetCenterHTML;
        widgetBodyHTML +=             '<td class="webos-widget-body-right" />';
		widgetBodyHTML +=             '<td class="webos-widget-shadow-e">&nbsp;</td>';
		widgetBodyHTML +=         '</tr>';
		widgetBodyHTML +=     '</table>';
		widgetBodyHTML +=     widgetHelperHTML;
		widgetBodyHTML += '</div>';
	//resizer
	var widgetResizerHTML =  '<div class="webos-widget-resizer" id="' + options.widgetResizerId + '"></div>';
	//bottom
	var widgetBottomHTML =  '<div class="webos-widget-bottom" id="' + options.widgetBottomId + '">';
		widgetBottomHTML +=     '<table>';
		widgetBottomHTML +=         '<tr>';
		widgetBottomHTML +=             '<td class="webos-widget-shadow-sw">&nbsp;</td>';
		widgetBottomHTML +=             '<td class="webos-widget-bottom-left" ></td>';
		widgetBottomHTML +=             '<td class="webos-widget-bottom-center"></td>';
		widgetBottomHTML +=             '<td class="webos-widget-bottom-right" id="'+ options.widgetRightResizerId+ '"></td>';
		widgetBottomHTML +=             '<td class="webos-widget-shadow-se">&nbsp;</td>';
		widgetBottomHTML +=         '</tr>';
		widgetBottomHTML +=         '<tr>';
		widgetBottomHTML +=             '<td class="webos-widget-shadow-sw">&nbsp;</td>';
		widgetBottomHTML +=             '<td></td>';            
		widgetBottomHTML +=             '<td class="webos-widget-shadow-s">&nbsp;</td>';
		widgetBottomHTML +=             '<td></td>';            
		widgetBottomHTML +=             '<td class="webos-widget-shadow-se">&nbsp;</td>';
		widgetBottomHTML +=         '</tr>';
		widgetBottomHTML +=     '</table>';
		widgetBottomHTML += '</div>';
	//widget html
	var widgetHTML = '<div class="webos-widget" id="' + options.widgetId + '">';
		widgetHTML += widgetTitleHTML;
		widgetHTML += widgetBodyHTML;
		widgetHTML += widgetResizerHTML;
		widgetHTML += widgetBottomHTML;
		widgetHTML += '</div>';
	//widget
	var widget = $(widgetHTML);
	widget.widgetOptions = options;
	//render
	$widget.items[$widget.items.length] = widget;
	$container.getContainer().append(widget);
	$dock.add(widget);
	//parts
	widget.title = $('#' + options.widgetTitleId);
	widget.expander = $('#' + options.widgetExpanderId);
	widget.dragger = $('#' + options.widgetDraggerId);
	widget.minimizer = $('#' + options.widgetMinimizerId);
	widget.maximizer = $('#' + options.widgetMaximizerId);
	widget.closer = $('#' + options.widgetCloserId);
	widget.body = $('#' + options.widgetBodyId);
	widget.center = $('#' + options.widgetCenterId);
	widget.content = $('#' + options.widgetContentId);
	widget.helper = $('#' + options.widgetHelperId);
	widget.resizer = $('#' + options.widgetResizerId);
	widget.bottom = $('#' + options.widgetBottomId);
    widget.rightResizer= $('#' + options.widgetRightResizerId);
	//effects
	widget.body.css({
		width : "100%",
		height : options.contentHeight + "px"
	});
	widget.content.css({
		height : options.contentHeight + "px"
	});
	widget.css({
		left : options.left + "px",
		top : options.top + "px",
		width : (options.contentWidth + widget.body.find("td")[0].clientWidth + widget.body.find("td")[widget.body.find("td").length- 1].clientWidth) + "px",
		height : (widget.title[0].clientHeight + options.contentHeight + widget.bottom[0].clientHeight) + "px"
	});
	$widget.resizable(widget);
	$widget.setZIndex(widget, z);
	$widget.setDimensions(widget);
	$widget.setCoordinates(widget);
	//events
	//bind the click event, when click a widget, it must be the top one
	widget.mousedown(function(){
		$widget.setZIndexes(widget);
	});
	widget.body.mousedown(function(){
		$widget.setZIndexes(widget);
	});
	widget.title.mousedown(function(){
		$widget.setZIndexes(widget);
	});
	widget.title.dblclick(function(){
		$widget.maximize(widget);
	});
	//bind the expand event
	widget.expander.click(function(){
		$widget.expand(widget);
	});
	//bind the minimize event
	widget.minimizer.click(function(){
		$widget.minimize(widget);
	});
	//bind the maximize event
	widget.maximizer.click(function(){
		$widget.maximize(widget);
	});
	//bind the close event
	widget.closer.click(function(){
		$widget.close(widget);
	});
	//show
	widget.css({
		visibility : "visible"
	});
	//status
	//alert(options.isExpanded);
	if(options.isExpanded === false){
		options.isExpanded = true;
		$widget.expand(widget);
	}
	else{
		options.isExpanded = true;
	}
	if(options.isMaximized === true){
		widget.widgetOptions.restoredWidth = widget.widgetOptions.contentWidth;
		widget.widgetOptions.restoredHeight = widget.widgetOptions.contentHeight;
		widget.widgetOptions.restoredTop = widget.widgetOptions.top;
		widget.widgetOptions.restoredLeft = widget.widgetOptions.left;
		options.isMaximized = false;
		$widget.maximize(widget);
	}
	else{
		options.isMaximized = false;
	}
	if(options.isMinimized === true){
		options.isMinimized = false;
		$widget.minimize(widget);
	}
	else{
		options.isMinimized = false;
	}
	//callback
	if(widget.widgetOptions.callback && widget.widgetOptions.callback.constructor == String){
		setTimeout(function(){
			eval(widget.widgetOptions.callback);
		}, 1000);
	}
	return widget;
};
$widget.setZIndexes = function(widget){
	if(widget){
		$widget.items.splice(widget.widgetOptions.z, 1);
		$widget.items[$widget.items.length] = widget;
		for(var i = widget.widgetOptions.z; i < $widget.items.length; i++){
			$widget.setZIndex($widget.items[i], i);
		}
	}
	else{
		for(var i = 0; i < $widget.items.length; i++){
			$widget.setZIndex($widget.items[i], i);
		}
	}
};
$widget.setZIndex = function(widget, z){
	widget.widgetOptions.z = z;
	widget.css({
		zIndex : $widget.zBase + z * 100
	});
};

$widget.openContent  = function(widget){
	widget.helper.css({
		display: "none"
	});
};
$widget.closeContent = function(widget){
	widget.helper.css({
		width  : widget.content[0].clientWidth +  "px",
		height : widget.content[0].clientHeight + "px",
		display: "block"
	});
};
$widget.openContents = function(){
	if($widget.isContentsOpen != true){
		$widget.isContentsOpen = true;
		for(var i = 0; i < $widget.items.length; i++){
			$widget.openContent($widget.items[i]);
		}
	}
};
$widget.closeContents = function(){
	if($widget.isContentsOpen){
		$widget.isContentsOpen = false;
		for(var i = 0; i < $widget.items.length; i++){
			$widget.closeContent($widget.items[i]);
		}
	}
};
$widget.setDimensions = function(widget){
	widget.widgetOptions.previousWidth = widget.widgetOptions.clientWidth;
	widget.widgetOptions.previousHeight = widget.widgetOptions.clientHeight;
	widget.widgetOptions.clientWidth = widget[0].clientWidth;
	widget.widgetOptions.clientHeight = widget[0].clientHeight;
	if(!widget.widgetOptions.isMaximized){
		widget.widgetOptions.restoredWidth = widget.widgetOptions.clientWidth;
		widget.widgetOptions.restoredHeight = widget.widgetOptions.clientHeight;
	}
};
$widget.setCoordinates = function(widget){
	widget.widgetOptions.previousTop = widget.widgetOptions.clientTop;
	widget.widgetOptions.previousLeft = widget.widgetOptions.clientLeft;
	widget.widgetOptions.clientTop = parseInt(widget.css("top"));
	widget.widgetOptions.clientLeft = parseInt(widget.css("left"));
	if(!widget.widgetOptions.isMaximized){
		widget.widgetOptions.restoredTop = widget.widgetOptions.clientTop;
		widget.widgetOptions.restoredLeft = widget.widgetOptions.clientLeft;
	}
};
$widget.close = function(widget){
	if($widget.isAlphaOnAction){
		widget.fadeTo("slow", 0, function(){
			$widget.remove(widget);
		});
	}
	else{
		$widget.setZIndexes(widget);
		$widget.remove(widget);
		$widget.setZIndexes();
	}
};
$widget.startResize = function(widget){
	$widget.setZIndexes(widget);
	if($widget.isAlphaOnAction){
		widget.fadeTo(10, 0.5);
	}
	widget.resizer.bind("mousemove", $widget.closeContents);
};
$widget.stopResize = function(widget){
	widget.content.css({
		height : widget.body.css("height")
	});
	if($widget.isAlphaOnAction){
		widget.fadeTo("normal", 1);
	}
	$widget.setDimensions(widget);
	widget.resizer.unbind("mousemove", $widget.closeContents);
	$widget.openContents();
};
$widget.resizing = function(widget){
	widget.body.css({
		height : (parseInt(widget.css("height")) - widget.title[0].clientHeight - widget.bottom[0].clientHeight) + "px"
	});
};
$widget.startDrag = function(widget){
	$widget.setZIndexes(widget);
	if($widget.isAlphaOnAction){
		widget.fadeTo(10, 0.5);
	}
	widget.dragger.bind("mousemove", $widget.closeContents);
};
$widget.stopDrag = function(widget){
	if($widget.isAlphaOnAction){
		widget.fadeTo("normal", 1);
	}
	widget.dragger.unbind("mousemove", $widget.closeContents);
	$widget.openContents();
	$widget.setCoordinates(widget);
};
$widget.expand = function(widget){
	//expand
	if(!widget.widgetOptions.isExpanded){
		if(widget.widgetOptions.isResizable){
			widget.resizer.css({
				display : "block"
			});
		}
		widget.css({
			height : (widget.title[0].clientHeight + parseInt(widget.body.css("height")) + widget.bottom[0].clientHeight) + "px"
		});
		widget.body.css({
			display : "block"
		});
		widget.widgetOptions.isExpanded = true;
	}
	//hide
	else{
		if(widget.widgetOptions.isResizable){
			widget.resizer.css({
				display : "none"
			});
		}
		widget.css({
			height : (widget.title[0].clientHeight + widget.bottom[0].clientHeight) + "px"
		});
		widget.body.css({
			display : "none"
		});
		widget.widgetOptions.isExpanded = false;
	}
	//blur
	//widget.expander[0].blur();
	$widget.setDimensions(widget);
};
$widget.minimize = function(widget){
	if(!widget.widgetOptions.isMinimized){
		$widget.transferHelper.css({
			width : widget.widgetOptions.clientWidth + "px",
			height : widget.widgetOptions.clientHeight + "px",
			left : widget.css("left"),
			top : widget.css("top")
		});
		var dockImage = document.getElementById(widget.dock.dockOptions.dockImageId);
		var dockImagePosition = jQuery.iUtil.getPosition(dockImage);
		$widget.transferHelper.appendTo($container.getContainer());
		widget.css({
			visibility : "hidden",
			display : "none"
		});
		$widget.transferHelper.animate({
			width: dockImage.clientWidth + "px",
			height: dockImage.clientHeight + "px",
			left: dockImagePosition.x,
			top: dockImagePosition.y
		},
		$widget.transferDuration,
		function(){
			$widget.transferHelper.remove();
			widget.widgetOptions.isMinimized = true;
		});
	}
	else{
		var dockId = widget.widgetOptions.widgetId + "Dock";
		var dockImageId = dockId + "Image";
		var dockImage = document.getElementById(dockImageId);
		var dockImagePosition = jQuery.iUtil.getPosition(dockImage);
		$widget.transferHelper.css({
			width : dockImage.clientWidth + "px",
			height : dockImage.clientHeight + "px",
			left : dockImagePosition.x,
			top : dockImagePosition.y
		});
		$widget.transferHelper.appendTo($container.getContainer());
		$widget.transferHelper.animate({
			width : widget.widgetOptions.clientWidth + "px",
			height : widget.widgetOptions.clientHeight + "px",
			left : widget.css("left"),
			top : widget.css("top")
		},
		$widget.transferDuration,
		function(){
			widget.css({
				visibility : "visible",
				display : "block"
			});
			$widget.transferHelper.remove();
			widget.widgetOptions.isMinimized = false;
		});
	}
};
$widget.maximize = function(widget){
	if(widget.widgetOptions.isMaximizable){
		//maximize
		if(!widget.widgetOptions.isMaximized){
			//Expand first
			if(!widget.widgetOptions.isExpanded){
				$widget.expand(widget);
			}
			widget.animate({
				width: $container.getContainer()[0].clientWidth + "px",
				height: $container.getContainer().css("height"),
				left: "0px",
				top: $taskbar.getTaskbar().css("height")
			},
			$widget.transferDuration,
			function(){
				widget.content.css({
					height : (parseInt(widget.css("height")) - widget.title[0].clientHeight - widget.bottom[0].clientHeight) + "px"
				});
				widget.body.animate({
					height : widget.content.css("height")
				},
				$widget.transferDuration,
				function(){
					widget.widgetOptions.isMaximized = true;
					$widget.setDimensions(widget);
					$widget.setCoordinates(widget);
				});
			});
		}
		//restore
		else{
			widget.animate({
				width: widget.widgetOptions.restoredWidth + "px",
				height: widget.widgetOptions.restoredHeight + "px",
				left: widget.widgetOptions.restoredLeft + "px",
				top: widget.widgetOptions.restoredTop + "px"
			},
			$widget.transferDuration,
			function(){
				widget.body.css({
					height : (parseInt(widget.css("height")) - widget.title[0].clientHeight - widget.bottom[0].clientHeight) + "px"
				});
				widget.content.css({
					height : widget.body.css("height")
				});
				$widget.setDimensions(widget);
				$widget.setCoordinates(widget);
				widget.widgetOptions.isMaximized = false;
			});
		}
	}
};
$widget.resizable = function(widget){
	if(widget.widgetOptions.isResizable){
		widget.Resizable({
			minTop : $taskbar.getTaskbar()[0].clientHeight,
			dragHandle : "#" + widget.widgetOptions.widgetDraggerId,
			minWidth : 200 ,//widget.widgetOptions.contentMinWidth,
			maxWidth : widget.widgetOptions.contentMaxWidth,
			minHeight : 45 ,//widget.widgetOptions.contentMinHeight,
			maxHeight : widget.widgetOptions.contentMaxHeight,
			handlers : {
				se : "#" + widget.widgetOptions.widgetResizerId
			},
			onStart : function(){
				$widget.startResize(widget);
			},
			onStop : function(){
				$widget.stopResize(widget);
			},
			onResize : function(){
				$widget.resizing(widget);
			},
			onDragStart : function(){
				$widget.startDrag(widget);
			},
			onDragStop : function(){
				$widget.stopDrag(widget);
			}
		});
	}
	else{
		widget.Resizable({
			minTop : $taskbar.getTaskbar()[0].clientHeight,
			dragHandle : "#" + widget.widgetOptions.widgetDraggerId,
			handlers : {
				se : "#" + widget.widgetOptions.widgetResizerId
			},
			onDragStart : function(){
				$widget.startDrag(widget);
			},
			onDragStop : function(){
				$widget.stopDrag(widget);
			}
		});
		widget.resizer.css({
			display : "none"
		});
	}
};
$widget.getOptions = function(widget){
	return {
		name : widget.widgetOptions.name,
		title : widget.widgetOptions.title,
		left : widget.widgetOptions.restoredLeft,
		top : widget.widgetOptions.restoredTop,
		contentWidth : widget.widgetOptions.restoredWidth - 14,
//这里利用js取得当前高度的方法在FireFox 
		contentHeight : widget.widgetOptions.restoredHeight -29,//- widget.title[0].clientHeight - widget.bottom[0].clientHeight,
		isResizable : widget.widgetOptions.isResizable,
		contentMinWidth : widget.widgetOptions.contentMinWidth,
		contentMinHeight : widget.widgetOptions.contentMinHeight,
		contentMaxWidth : widget.widgetOptions.contentMaxWidth,
		contentMaxHeight : widget.widgetOptions.contentMaxHeight,
		type : widget.widgetOptions.type,
		src : widget.widgetOptions.src,
		imageSrc : widget.widgetOptions.imageSrc,
		isContentIframeScrollable : widget.widgetOptions.isContentIframeScrollable,
		isExpanded : widget.widgetOptions.isExpanded,
		isMaximized : widget.widgetOptions.isMaximized,
		isMinimized : widget.widgetOptions.isMinimized,
		callback : widget.widgetOptions.callback
	};
};
//save and restore
$widget.saveTimeout;
$widget.save = function(){
	var items = [];
	for(var i = 0; i < $widget.items.length; i++){
		items[i] = $widget.getOptions($widget.items[i]);
	}
	var saveJSONString = JSON.stringify(items);
	//if change happened
	if(saveJSONString != $widget.saveJSONString){
		$widget.saveJSONString = saveJSONString;
		$.post($webos.urls.userSaveWidgets,{widgets : $widget.saveJSONString}, function(response){
			if(response != 1){
				$webos.networkError();
			}
		});
	}
	$widget.saveTimeout = setTimeout($widget.save, $widget.saveDuration);
};
$widget.cancelSave = function(){
	if($widget.saveTimeout){
		clearTimeout($widget.saveTimeout);
	}
};
$widget.restoredCount = 0;
$widget.restore = function(){
	try{
		if($webos.isDebug){
			var items = $server.user.widgetsState;
			if(items.length == 0){
				$widget.restoreDefault();
				$widget.save();
			}
			else{
				for(var i = 0; i < items.length; i++){
					setTimeout(function(){
						$widget.add(items[$widget.restoredCount++]);
						if(items.length == $widget.restoredCount){
							$widget.save();
						}
					}, i * 1000);
				}
			}
		}
		else{
			$.post("/getwidgets", {}, function(jsonString){
				var items = JSON.parse(jsonString);
				if(items.length == 0){
					$widget.restoreDefault();
					$widget.save();
				}
				else{
					for(var i = 0; i < items.length; i++){
						setTimeout(function(){
							$widget.add(items[$widget.restoredCount++]);
							if(items.length == $widget.restoredCount){
								$widget.save();
							}
						}, i * 500);
					}
				}
			});
		}
	}
	catch(error){
		$widget.restoreDefault();
		$widget.save();
	}
	finally{}
};
$widget.restoreDefault = function(){
//	$widget.start("controlpanel");
};
$widget.getLeftByWidth = function(contentWidth){
	var canvasWidth = document.body.parentNode.clientWidth > document.body.clientWidth ? document.body.parentNode.clientWidth : document.body.clientWidth;
	return canvasWidth > contentWidth ? parseInt((canvasWidth - contentWidth) / 2) : 0
};
$widget.getTopByHeight = function(contentHeight){
	var canvasHeight = document.body.parentNode.clientHeight > document.body.clientHeight ? document.body.parentNode.clientHeight : document.body.clientHeight;
	return (canvasHeight > contentHeight ? parseInt((canvasHeight - contentHeight) / 2) : 0) + $taskbar.getTaskbar()[0].clientHeight;
};
$widget.start = function(name){
	switch(name){
		case "stock":
			$widget.add({
				name : "Stock",
				title : "Stock",
				contentWidth : 545,
				contentHeight : 300,
				isResizable : false,
				type : "iframe",
                isContentIframeScrollable : true,
				src : "appstock.jsp"
			});
			break;	
	 	case "dictionary":
			$widget.add({
				name : "Dictionary",
				title : "Dictionary",
				contentWidth : 180,
				contentHeight : 70,
				isResizable : false,
				type : "iframe",
				src : "dic.html"
			});
			break;	
	 	case "calculator":
			$widget.add({
				name : "Calculator",
				title : "Calculator",
				contentWidth : 270,
				contentHeight : 260,
				isResizable : false,
				type : "iframe",
				src : "calculator.html"
			});
			break;	
	 	case "musicplayer":
			$widget.add({
				name : "MusicPlayer",
				title : "MusicPlayer",
				contentWidth : 335,
				contentHeight : 270,
				isResizable : false,
				type : "iframe",
				src : "player.html"
			});
			break; 
		case "controlpanel":
			$widget.add({
				name : "ControlPanel",
				title : "Control Panel",
				contentWidth : 250,
				contentHeight : 450,
				isResizable : false,
				type : "iframe",
				src : "webos_userInfo.jsp"
			});
			break;
		case "bookmark":
			$widget.add({
				name : "Bookmark",
				title : "Bookmark",
				contentWidth : 600,
				contentHeight : 400,
				isResizable : true,
				type : "iframe",
				src : "webos_main.jsp",
				isContentIframeScrollable : true
			});
			break;
		case "rss":
			$widget.add({
				name : "RSS",
				title : "RSS",
				contentWidth : 600,
				contentHeight : 400,
				isResizable : true,
				type : "iframe",
				src : "webos_viewrss.jsp",
				isContentIframeScrollable : true
			});
			break;
		case "picture":
			$widget.add({
				name : "Picture",
				title : "Picture",
				contentWidth : 712,
				contentHeight : 400,
				isResizable : false,
				type : "iframe",
				src : "webos_pic.jsp",
				isContentIframeScrollable : true
			});
			break;
		case "weather":
			$widget.add({
				name : "Weather",
				contentWidth : 280,
				contentHeight : 252,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://www.labpixies.com/campaigns/weather/weather.xml&up_degree_unit_type=0&up_city_code=none&up_zip_code=none&synd=open&w=320&h=240&title=&border=%23ffffff%7C3px%2C0px+none+%23999999"
			});
			break;
		case "note":
			$widget.add({
				name : "Note",
				contentHeight : 275,
				isResizable : false,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://www.labpixies.com/campaigns/todo/todo.xml&up_saved_tasks=&synd=open&w=320&h=460&title=&lang=all&country=ALL&border=%23ffffff%7C3px%2C0px+none+%23999999"
			});
			break;
		case "gtalk":
			$widget.add({
				name : "GTalk",
				contentWidth : 330,
				contentHeight : 465,
				isResizable : true,
				type : "iframe",
				src : "http://talkgadget.google.com/talkgadget/client?hl=en"
			});
			break;
		case "msn":
			$widget.add({
				name : "MSN",
				contentHeight : 435,
				isResizable : true,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://www.livebug.com/gadget/webmsn.xml&synd=open&w=320&h=200&title=MSN+Messenger&border=%23ffffff%7C3px%2C1px+solid+%23999999"
			});
			break;
		case "googlenews":
			$widget.add({
				name : "GoogleNews",
				title : "Google News",
				contentHeight : 415,
				isResizable : true,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://www.google.com/ig/modules/tabnews.xml&up_ned=&up_items=9&up_show_image=1&up_selectedTab=0&up_tabs=&synd=open&w=320&h=400&title=&lang=en&country=US&border=%23ffffff%7C3px%2C0px+none+%23999999"
			});
			break;
		case "diggnews":
			$widget.add({
				name : "DiggNews",
				title : "Digg News",
				contentHeight : 500,
				isResizable : true,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://dannyjoo.googlepages.com/diggstop24.xml&synd=open&w=320&h=200&title=Digg.com+-+Top+in+24+hours&border=%23ffffff%7C3px%2C1px+solid+%23999999"
			});
			break;
		case "cnnnews":
			$widget.add({
				name : "CNNNews",
				title : "CNN News",
				contentHeight : 415,
				isResizable : true,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://quotesandlines.googlepages.com/cnn-news-customized-rss-feeds.xml&up_entries=4&up_summaries=100&up_subject=CNN.com&up_feedname1=Top&up_feed1=http%3A%2F%2Frss.cnn.com%2Frss%2Fcnn_topstories.rss&up_feedname2=World&up_feed2=http%3A%2F%2Frss.cnn.com%2Frss%2Fcnn_world.rss&up_feedname3=Business&up_feed3=http%3A%2F%2Frss.cnn.com%2Frss%2Fmoney_topstories.rss&up_feedname4=Sports&up_feed4=http%3A%2F%2Frss.cnn.com%2Frss%2Fsi_topstories.rss&up_feedname5=Markets&up_feed5=http%3A%2F%2Frss.cnn.com%2Frss%2Fmoney_markets.rss&up_feedname6=Entertainment&up_feed6=http%3A%2F%2Frss.cnn.com%2Frss%2Fcnn_showbiz.rss&up_feedname7=Technology&up_feed7=http%3A%2F%2Frss.cnn.com%2Frss%2Fcnn_tech.rss&up_selectedTab=&synd=open&w=320&h=270&title=__UP_subject__&border=%23ffffff%7C3px%2C1px+solid+%23999999"
			});
			break;
		case "iptracker":
			$widget.add({
				name : "IPTracker",
				title : "IP Tracker",
				contentHeight : 180,
				type : "iframe",
				src : "http://people.cis.ksu.edu/~aruljohn/gadget/ip/?lang=en&country=us&.lang=en&.country=us&synd=open&mid=0&ifpctok=-697489660297984108&parent=&libs=noMTUVQnUJw/lib/libcore.js"
			});
			break;
		case "moonphase":
			$widget.add({
				name : "MoonPhase",
				title : "Moon Phase",
				contentHeight : 185,
				type : "iframe",
				src : "http://www.calculatorcat.com/gmodules/current_moon.php?up_h=1&upt_h=enum&lang=en&country=us&.lang=en&.country=us&synd=open&mid=0&ifpctok=-8814993242484519969&parent=&libs=noMTUVQnUJw/lib/libcore.js"
			});
			break;
		case "hotmail":
			$widget.add({
				name : "Hotmail",
				contentHeight : 415,
				isResizable : true,
				type : "iframe",
				src : "http://gmodules.com/ig/ifr?url=http://googatrix.googlepages.com/HotmailGadget.xml&up_defaultPage=Inbox&up_refreshInterval=0&synd=open&w=320&h=400&title=Hotmail&border=%23ffffff%7C3px%2C1px+solid+%23999999"
			});
			break;
		case "gmail":
			$widget.add({
				name : "Gmail",
				contentHeight : 415,
				isResizable : true,
				type : "iframe",
				src : "https://www.google.com/accounts/ServiceLogin?service=mail&passive=true&rm=false&continue=https%3A%2F%2Fmail.google.com%2Fmail%2Fx%2F1uuixlbj60w8t%2F%3Fnsr%3D1%26ui%3Dhtml%26zy%3Dl&ltmpl=ecobh&nui=5&btmpl=mobile"
			});
			break;
		case "chinesedate":
			$widget.add({
				name : "ChineseDate",
				title : "Chinese Date",
				contentWidth : 260,
				contentHeight : 230,
				type : "iframe",
				src : "http://www.ourgoogle.net/lists/calendar/chnCalendar.html?lang=en&country=us&.lang=en&.country=us&synd=open&mid=0&ifpctok=5003639430722929489&parent=&libs=noMTUVQnUJw/lib/libcore.js"
			});
			break;
		case "translate":
			$widget.add({
				name : "GoogleTranslate",
				title : "Google Translate",
				contentWidth : 430,
				contentHeight : 160,
				type : "iframe",
				src : '/apptranslate.html'
			});
			break;
        case "sinanews":
            $widget.add({
                name: "SinaNews",
                title: "Sina News",
				contentWidth : 320,
				contentHeight : 390,
				type : "iframe",
				src : '/sina_news.html'                
            });
            break;
        case "traininfo":
            $widget.add({
                name: "traininfo",
                title: "Train Infomation",
				contentWidth : 320,
				contentHeight : 120,
				type : "iframe",
				src : 'webos/widget/trainsearch/trainsearch.html'                
            });
            break;
        case "hotalsearch":
            $widget.add({
                name: "hotalsearch",
                title: "Hotal Search",
				contentWidth : 320,
				contentHeight :220,
				type : "iframe",
				src : 'webos/widget/hotalsearch/hotal.html'                
            });
            break;
		default:
			break;
	}
};
