$(document).ready(function(){
	if($.browser.opera){
		var links = document.getElementsByTagName("a");
		for(var i = 0; i < links.length; i++){
			if(links[i].href == location.href){
				links[i].href = "#top";
			}
		}
	}
});