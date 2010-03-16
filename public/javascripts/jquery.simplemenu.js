/*
 * SimpleMenu - jQuery plugin for creating a simple drop-down menu bar with sub-menus
 *
 * Copyright 2009 Pete Morris
 *
 * Licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Version 0.1 2009-08-24
 *
 */

jQuery.fn.extend({
	/* Sometimes fadeIn and fadeOut with 0 values have caused problems, so put in a manual version here */
	fadeInOrShow: function(speed) {
		return speed == 0 ? jQuery(this).show() : jQuery(this).fadeIn(speed);
	},
	fadeOutOrHide: function(speed) {
		return speed == 0 ? jQuery(this).hide() : jQuery(this).fadeOut(speed);
	},

	simplemenu: function(options) {
		var settings = {
			allowMouseover : true,
			mouseoverDelay : 200,
			fadeInSpeed : 150, 
			fadeOutSpeed : 200,
			submenuOffset : -5
		};
	
		jQuery.extend(settings, options);
	
		jQuery(this).addClass("simplemenu");

		// set height by computing from a dummy li
		jQuery(this).prepend("<li></li>").children("li:first").html("TEMP_^qg|");
		var menuHeight = jQuery(this).children("li:first").outerHeight();
		jQuery(this).css("height", menuHeight);
		jQuery(this).children("li:first").remove();

		var menubar = jQuery(this);
		jQuery(document).click(function() {
			menubar.children("li").children("ul").fadeOutOrHide(settings.fadeOutSpeed);
		});

		jQuery(this).find("a").click(function() {
			menubar.children("li").children("ul").fadeOutOrHide(settings.fadeOutSpeed);
		});

		jQuery(this).children("li").addClass("simplemenu_topitem");
		jQuery(this).children("li.simplemenu_topitem").children("ul").children("li").find("ul").addClass("simplemenu_submenu");

		// apply css styles
		jQuery(this).css("listStyle", "none");
		jQuery(this).find("ul").css("listStyle", "none");
		jQuery(this).find("li").css({ position: "relative", top: 0, left: 0 });
		jQuery(this).find("li.simplemenu_topitem").css("float", "left");
		jQuery(this).find("li.simplemenu_topitem").children("ul").css({ position: "absolute", top: menuHeight, left: 0 });
		jQuery(this).find("li.simplemenu_topitem").find("ul.simplemenu_submenu").css({ position: "absolute", top: 0, left: "1em" });
		
		jQuery(this).children("li.simplemenu_topitem").children("ul").find("li:has(ul)").addClass("simplemenu_hassubmenu").click(function() {
			jQuery(this).children("ul").css("left", jQuery(this).parent().outerWidth() + settings.submenuOffset);
		});
	
		jQuery(this).find("li").click(function(event) {
			event.stopPropagation();
			if (jQuery(this).children("ul:visible").size() == 0) {
				jQuery(this).siblings("li").children("ul").fadeOutOrHide(settings.fadeOutSpeed);
				menubar.children("li").children("ul").not(jQuery(this).parents("ul")).fadeOutOrHide(settings.fadeOutSpeed);
				jQuery(this).children("ul").fadeInOrShow(settings.fadeInSpeed);
				// NB have to call this after the fadeIn or else IE mucks up
				jQuery(this).children("ul").children("li").children("ul").hide();
			}
		});
		
		jQuery(this).data("context", false);
		jQuery(this).data("cancelCallback", function() {});
		
		if (settings.allowMouseover) jQuery(this).find("li").mouseover(function(event) {
			if (menubar.find("ul:visible").size() == 0) return;
			if (jQuery(this).children("ul:visible").size() == 0) {
				var keep = jQuery(this);
				var handle = window.setTimeout(function() { keep.click(); }, settings.mouseoverDelay);
				var cancelCallback = function() { window.clearTimeout(handle); };
				jQuery(this).data("cancel", cancelCallback);
			}
		});
		if (settings.allowMouseover) jQuery(this).find("li").mouseout(function(event) {
			if (jQuery(this).data("cancel") == null) return;
			var cancelCallback = jQuery(this).data("cancel");
			cancelCallback();
			jQuery(this).data("cancel", null)
		});
	
		jQuery(this).find("ul").hide();
	}
});

