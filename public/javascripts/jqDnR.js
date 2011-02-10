/*
 * jqDnR - Minimalistic Drag'n'Resize for jQuery.
 *
 * Copyright (c) 2007 Brice Burgess <bhb@iceburg.net>, http://www.iceburg.net
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * $Version: 2007.08.19 +r2
 */

(function($){
var ff,ff2;
$.fn.jqDrag=function(h, fn){ff=fn;return i(this,h,'d');};
$.fn.jqResize=function(h, fn){ff2 =fn;return i(this,h,'r');};
$.jqDnR={
	dnr:{},
	e:0,
	drag:function(v){
 		if(M.k == 'd'){
			E.css({left:M.X+v.pageX-M.pX,top:M.Y+v.pageY-M.pY});
		//	if (ff) ff(E, {left:M.X+v.pageX-M.pX,top:M.Y+v.pageY-M.pY, width:M.W, height: M.H} );
		//	M.vx = v.pageX;M.vy = v.pageY;
		}
 		else{
			var w = Math.max(v.pageX-M.pX+M.W,0);
			var h = Math.max(v.pageY-M.pY+M.H,0);
			if (w<200) w = 200;
			if (h< 100) h = 100;
 			E.css({width:w,height:h});
		//	M.w = w; M.h=h;
			EE = E.find('textarea');	
			EE.css({width:w-50,height:h-50});
		//	if (ff2) ff2(E, {left:M.X, top:M.Y, width:w,height:h});
			//alert("height="+(Math.max(v.pageY-M.pY+M.H,0)-20));
		}
  		return false;
		},
	stop:function(){
		if (M.k != 'd'){
	//		var EE = E.find('textarea');
		//	if (ff2) ff2(EE, {left:M.X, top:M.Y, width:M.w,height:M.h});
			if (ff2) ff2(E, {left:E.offset().left, top:E.offset().top, width:E.width(), height:E.height()});
		}else{
			//if (ff ) ff(E, {left:M.X+M.vx-M.pX,top:M.Y+M.vy-M.pY, width:M.W, height: M.H});
			if (ff ) ff(E, {left:E.offset().left, top:E.offset().top, width:E.width(), height:E.height()});
		}
		E.css('opacity',M.o);
		$().unbind('mousemove',J.drag).unbind('mouseup',J.stop);
	}
	
};
var J=$.jqDnR,M=J.dnr,E=J.e,EE=0,
i=function(e,h,k){
	return e.each(
		function(){
			h=(h)?$(h,e):e;
 			h.bind(
					'mousedown',
					{e:e,k:k},
					function(v){
						var d=v.data,p={};E=d.e;
 						// attempt utilization of dimensions plugin to fix IE issues
 						if(E.css('position') != 'relative'){
							try{
								E.position(p);
								}catch(e){}
						}
 						M={X:p.left||f('left')||0,Y:p.top||f('top')||0,W:f('width')||E[0].scrollWidth||0,H:f('height')||E[0].scrollHeight||0,pX:v.pageX,pY:v.pageY,k:d.k,o:E.css('opacity')};
 						E.css({opacity:0.8});
						
						EE = E.find('textarea');
 						if(EE != null &&  EE.css('position') != 'relative'){
							try{
								EE.position(p);
								}catch(oe){}
						}
 					
						$().mousemove($.jqDnR.drag).mouseup($.jqDnR.stop);

 						return false;
 					});
		});
},
f=function(k){return parseInt(E.css(k))||false;};
})(jQuery);
