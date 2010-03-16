var $container = window.$webos.$container = {};
$container.id = $webos.id + "Container";
$container.containerId = $container.id;
$container.getContainer = function(){
	return $("#" + $container.containerId);
};
$container.initial = function(){
	$container.getContainer().css({
		height : ($portal.getPortal()[0].clientHeight - $taskbar.getTaskbar()[0].clientHeight - $dock.clientHeight) + "px"
	});
};
