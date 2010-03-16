var $dock = window.$webos.$dock = {};
$dock.id = $webos.id + "Dock";
$dock.items = [];
$dock.dockId = $dock.id;
$dock.dockContainerId = $dock.dockId + "Container";
$dock.getDock = function(){
	return $("#" + $dock.dockId);
};
$dock.containerId = "dockContainer";
$dock.add = function(widget){
	var options = {};
	//id
	options.dockId = widget.widgetOptions.widgetId + "Dock";
	options.dockImageId = options.dockId + "Image";
	//html
	if(widget.widgetOptions.imageSrc){
		options.imageSrc = widget.widgetOptions.imageSrc;
	}
	else{
		options.imageSrc = "img/dock_" + widget.widgetOptions.name.toLowerCase() + ".png";
	}
	options.dockHTML = '<a class="webos-dock-item" href="#" id="' + options.dockId + '"><span>' + widget.widgetOptions.title + '</span><img src="' + options.imageSrc + '" alt="' + widget.widgetOptions.title + '" id="' + options.dockImageId + '" /></a>';
	var dockItem = $(options.dockHTML);
	//bind to widget
	dockItem.dockOptions = options;
	widget.dock = dockItem;
	dockItem.mousedown(function(){
		$widget.setZIndexes(widget);
		if(widget.widgetOptions.isMinimized){
			$widget.minimize(widget);
		}
	});
	dockItem.dblclick(function(){
		$widget.setZIndexes(widget);
		$widget.minimize(widget);
	});
	$dock.items[$dock.items.length] = dockItem;
	$dock.initial();
};
$dock.remove = function(widget){
	for(var i = 0; i < $dock.items.length; i++){
		if(widget.dock == $dock.items[i]){
			$dock.items.splice(i, 1);
			return false;
		}
	}
};
$dock.clientHeight = 46;
$dock.initial = function(){
	if($dock.getDock()){
		$dock.getDock().remove();
	}
	var dock = $('<div class="webos-dock" id="' + $dock.dockId + '"></div>');
	var dockContainer = $('<div class="webos-dock-container" id="' + $dock.dockContainerId + '"></div>');
	for(var i = 0; i < $dock.items.length; i++){
		dockContainer.append($dock.items[i]);
	}
	dock.append(dockContainer);
	//render
	$portal.getPortal().append(dock);
	//effect
	dock.Fisheye({
		maxWidth: 60,
		items: 'a',
		itemsText: 'span',
		container: "#" + $dock.dockContainerId,
		itemWidth: 40,
		proximity: 80,
		alignment : 'left',
		valign: 'bottom',
		halign : 'center'
	});
	//show
	dock.css({
		visibility : "visible"
	});
};