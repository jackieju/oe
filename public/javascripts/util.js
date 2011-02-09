function evalJs(data){

	re = /<script[\s\S]*?>([\s\S]*)<\/script>/i;
	s = re.test(data);
	if (!s)
		return;
	h = RegExp.$1;
   eval(h);
}

function isElement(object) {
   return !!(object && object.nodeType == 1);
 }

function isArray(object) {
   return object != null && typeof object == "object" &&
     'splice' in object && 'join' in object;
 }

function isHash(object) {
   return object instanceof Hash;
 }

function isFunction(object) {
   return typeof object == "function";
 }

function isString(object) {
   return typeof object == "string";
 }

function isNumber(object) {
   return typeof object == "number";
 }

function isUndefined(object) {
   return typeof object == "undefined";
 }
function toJSON(object) {

  var type = typeof object;
//	alert("---"+type);
  switch (type) {
    case 'undefined':
    case 'function':
    case 'unknown': return;
    case 'boolean': return object.toString();
	case 'number': return ""+object;
	case 'string': return "\""+object+"\"";
  }

  if (object === null) return 'null';
  if (object.toJSON) return object.toJSON();
  if (isElement(object)) return;

  var results = [];
  for (var property in object) {
//	alert(property+":"+object[property]);
    var value = toJSON(object[property]);
//	alert("---");
    if (!isUndefined(value))
      results.push(toJSON(property) + ': ' + value);

  }
//	alert('{' + results.join(', ') + '}');
  return '{' + results.join(', ') + '}';
}

function AutoImgSize(e, w, h){
	r = e.height/e.width;
	if (e.height>e.width)
	{	
		if (e.height > h){
			e.style.height=h+"px";
			e.style.width=h/r+"px";
//	alert(""+e.style.width+", "+e.style.height);

		}
	}else if(e.width>w){
        e.style.width=w+"px";
		e.style.height=w*r+"px";
	}	
//	alert(""+e.style.width+","+e.style.width);
}
function autoPos(a, b){
//	alert("dd"+b);
//	alert($(a).height()+"-"+b.height);
   var c_h = ($(a).height()-b.height)/2;
   var c_w = ($(a).width()-b.width)/2;
    $(b).css("margin-left", c_w);
    $(b).css("margin-top", c_h);
//	alert(c_w+","+c_h);
}

