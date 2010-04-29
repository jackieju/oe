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

function showMemo(){
//alert("/memos?t="+ new Date().getTime());
alert("1");
	 if (hasMemo == 1){
		hideMemo();
			return;
	}
	alert("1");
	$.ajax({
			type: "get",
			url: "/memos?t="+ new Date().getTime(),
			data: {
			//	authenticity_token:window._token
			}, 
			success: function(data, textStatus){
			//	alert( "Data Saved: " + data +","+ textStatus);
							$("#memopad").css("display", "block");
			    $("#memopad").html(data);
			hasMemo=1;
	
			},
			error: function(xhr, textStatus, errorThrow){
				alert("error"+errorThrow+","+textStatus+","+xhr.responseText);
			}
	});	
alert("1");
}


function addNewMemo(){
	$.ajax({
			type: "get",
			url: "/memos/addNewMemo/1?t="+ new Date().getTime(),
			data: {
			//	authenticity_token:window._token
			}, 
			success: function(data, textStatus){
			//	alert( "Data Saved: " + data +","+ textStatus);
			//	$("#memopad").css("display", "block");
			    $("#memopad").append(data);
			//hasMemo=1;
	
			},
			error: function(xhr, textStatus, errorThrow){
				alert("error"+errorThrow+","+textStatus+","+xhr.responseText);
			}
	});

}

function onMemoBlur(e){
//	alert(e.target);
	t = $(e.target);
 	changed = t.attr('changed');

	if (t.attr('id') == "dummy")
		return;
	if (changed == 0)
		return;
	$.ajax({
			type: "get",
			url: "/memos/save/1?t="+ new Date().getTime(),
			data: {
				memoid:t.attr('id'),
				content:t.val()
			//	authenticity_token:window._token
			}, 
			success: function(data, textStatus){
				//alert( "Data Saved: " + data +","+ textStatus);
			//	$("#memopad").css("display", "block");
			    $("#memo_status").html(data);
			//hasMemo=1;
			t.attr("changed", 0);
				
			},
			error: function(xhr, textStatus, errorThrow){
				alert("error"+errorThrow+","+textStatus+","+xhr.responseText);
			}
	});
	$("#memo_status").html("saving");
	//return true;
}

function delMemo(t){
	$.ajax({
			type: "get",
			url: "/memos/del/1?t="+ new Date().getTime(),
			data: {
				memoid:t.attr('id'),
				content:t.val()
			//	authenticity_token:window._token
			}, 
			success: function(data, textStatus){
				//alert( "Data Saved: " + data +","+ textStatus);
			//	$("#memopad").css("display", "block");
			    $("#memo_status").html(data);
			//hasMemo=1;
			t.attr("changed", 0);
				
			},
			error: function(xhr, textStatus, errorThrow){
				alert("error"+errorThrow+","+textStatus+","+xhr.responseText);
			}
	});
	 $("#memo_status").html("deleting");
}
function onMemoMove(e, p){
	t = e.find("textarea");
	
	//alert("s"+toJSON(p));
	if (p.left < 0 ){
		p.width += p.left;
		p.width = Math.max(p.width, 200);
		p.left=0;
	}
	if (p.top < 0 ){
		//alert("h:"+p.height+"t:"+p.top);
		p.height += p.top;
		p.height = Math.max(p.height, 200);
		p.top=0;
	}

	$.ajax({
			type: "get",
			url: "/memos/savePos/1?t="+ new Date().getTime(),
			data: {
				memoid:t.attr('id'),
				pos:toJSON(p)
			//	authenticity_token:window._token
			}, 
			success: function(data, textStatus){
				//alert( "Data Saved: " + data +","+ textStatus);
			//	$("#memopad").css("display", "block");
			    $("#memo_status").html(data);
			//hasMemo=1;
			},
			error: function(xhr, textStatus, errorThrow){
				alert("error"+errorThrow+","+textStatus+","+xhr.responseText);
			}
	});
	 $("#memo_status").html("Moving memo");
}
