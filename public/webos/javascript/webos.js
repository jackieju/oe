var $webos = window.$webos = {};
$webos.isDebug = false;
$webos.id = "webos";
$webos.urls = {};
$webos.urls.userSignout = "webos_logout.jsp?id=" + Math.random();
$webos.urls.userSaveWidgets = "/setwidgets";
$webos.urls.userHeadPicture = "/getuserpicture";
$webos.urls.pageSign = "sign.aspx";
$webos.urls.pageDesktop = "desktop.aspx";
$webos.networkError = function(){
	alert("Network error!");
};

var $app = $webos.$app = {};
$app.id = "app";
$app.networkError = function(){
	alert("Network error!");
};
$app.urls = {};
//todo
$app.urls.todoInit = $webos.isDebug ? "app/todo/widgetcontent.aspx" : "/apptodo.jsp";
$app.urls.todoUpdateItem = $webos.isDebug ? "app/todo/updateitem.aspx" : "/widget/todo/updateitem";
$app.urls.todoInsertItem = $webos.isDebug ? "app/todo/insertitem.aspx" : "/widget/todo/insertitem";
$app.urls.todoDeleteItem = $webos.isDebug ? "app/todo/deleteitem.aspx" : "/widget/todo/deleteitem";