var $theme = window.$webos.$theme = {};
$theme.items = ["tiger", "leopard"];
$theme.handlers = [];
$theme.setCSS = function(theme){
	$theme.handlers = $("link");
	for(var i = 0; i < $theme.handlers.length; i++){
		var fileHref = $theme.handlers[i].href;
		var lastSlashIndex = fileHref.lastIndexOf("/");
		var fileName = fileHref.substring(lastSlashIndex);
		fileHref = fileHref.substring(0, lastSlashIndex);
		lastSlashIndex = fileHref.lastIndexOf("/");
		fileHref = fileHref.substring(0, lastSlashIndex + 1);
		$theme.handlers[i].href = fileHref + theme + fileName;
	}
};
$theme.set = function(theme){
	switch(theme){
		case "tiger":
			$theme.setCSS("tiger");
			break;
		case "leopard":
			$theme.setCSS("leopard");
			break;
		default:
			$theme.setCSS("tiger");
			break;
	}
	$portal.initial();
};