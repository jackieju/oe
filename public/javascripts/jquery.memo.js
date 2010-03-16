var hasMemo=0;
function activate(e){
	$('.jqmNotice').css('z-index', 100);
	$(e).css('z-index', 1000);
}

function hideMemo(){
	//h.w.slideUp("slow",function() { if(h.o) h.o.remove(); }); 
	$("#memopad").fadeOut();
	hasMemo=0;
//	$("#memopad").css("display", "none");
	
}