var $portal = window.$webos.$portal = {};
$portal.id = $webos.id + "Portal";
$portal.portalId = $portal.id;
$portal.getPortal = function(){
	return $("#" + $portal.portalId);
};
$portal.minHeight = 440;
$portal.minWidth = 760;
$portal.setHeight = function(){
	var canvasHeight = document.body.parentNode.clientHeight > document.body.clientHeight ? document.body.parentNode.clientHeight : document.body.clientHeight;
	$portal.getPortal().css({
		height : (canvasHeight > $portal.minHeight ? canvasHeight : $portal.minHeight) + "px"
	});
};
$portal.setWidth = function(){
	var canvasWidth = document.body.parentNode.clientWidth > document.body.clientWidth ? document.body.parentNode.clientWidth : document.body.clientWidth;
	$portal.getPortal().css({
		width : (canvasWidth > $portal.minWidth ? canvasWidth : $portal.minWidth) + "px"
	});
};
$portal.getResolution = function(){
	var resolutions = [0, 800, 1024, 1280, 1440, 1680, 2550];
	for(var i = 0; i < resolutions.length; i++){
		if(screen.width > resolutions[i] && screen.width <= resolutions[i + 1]){
			return resolutions[i + 1];
		}
	}
	return 2550;
};
$portal.setBackground = function(){
	$portal.getPortal().addClass("webos-portal-" + $portal.getResolution());
};
$portal.initial = function(){
	$portal.setHeight();
	$portal.setWidth();
	$portal.setBackground();
};
