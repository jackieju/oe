var $sign = window.$sign = {};

$sign.isDebug = false;

//resolutions
$sign.resolutions = [0, 800, 1024, 1280, 1440, 1680, 2550];

//url
$sign.urls = {};
$sign.urls.signin = $sign.isDebug ? "" : "/webossignin";
$sign.urls.signup = $sign.isDebug ? "" : "/webossignup";
$sign.urls.desktop = $sign.isDebug ? "" : "/webos_desktop.jsp";
$sign.urls.signinSecurityCode = $sign.isDebug ? "img/sign_security.jpg" : "/webossigninsecuritycode";
$sign.urls.signupSecurityCode = $sign.isDebug ? "img/sign_security.jpg" : "/webossignupsecuritycode";

//cache
$sign.caches = ['<img src="img/blank.gif" />',
	'<img src="img/dock_bookmark.png" />',
	'<img src="img/dock_chinesedate.png" />',
	'<img src="img/dock_cnnnews.png" />',
	'<img src="img/dock_controlpanel.png" />',
	'<img src="img/dock_diggnews.png" />',
	'<img src="img/dock_gmail.png" />',
	'<img src="img/dock_googlenews.png" />',
	'<img src="img/dock_gtalk.png" />',
	'<img src="img/dock_hotmail.png" />',
	'<img src="img/dock_iptracker.png" />',
	'<img src="img/dock_moonphase.png" />',
	'<img src="img/dock_msn.png" />',
	'<img src="img/dock_note.png" />',
	'<img src="img/dock_picture.png" />',
	'<img src="img/dock_rss.png" />',
	'<img src="img/dock_weather.png" />'];

//messages
$sign.messages = {};
$sign.messages.signinInitial = "请填写完整信息";
$sign.messages.signinError = "用户名与密码不匹配";
$sign.messages.signinSecurityCodeError = "验证码不正确";
$sign.messages.signinLoading = "请稍等...";
$sign.messages.signinUsernameTooShort = "用户名为字母、数字划线组成，5-10字符内";
$sign.messages.signinPasswordTooShort = "密码必须为英文字母、数字或下划线，长度为5~20";
$sign.messages.signinSecurityCodeTooShort = "验证码长度不够";

$sign.messages.signupInitial = "请填写完整信息";
$sign.messages.signupError = "登陆错误，请刷新重试";
$sign.messages.signupSecurityCodeError = "验证码不正确";
$sign.messages.signupLoading = "请稍等...";
$sign.messages.signupUsernameUsed = "用户名已经被注册";
$sign.messages.signupUsernameTooShort = "用户名为字母、数字划线组成，5-10字符内";
$sign.messages.signupPasswordTooShort = "密码必须为英文字母、数字或下划线，长度为5~20";
$sign.messages.signupPasswordConfirmFaild = "密码不一致";
$sign.messages.signupSecurityCodeTooShort = "验证码长度不够";
$sign.messages.signupEmailUsed = "Email 已经注册过";
$sign.messages.signupEmailError = "请检查Email地址";

//get containers
$sign.getSign = function(){
	return $sign.$("Sign");
};
$sign.getCanvas = function(){
	return $sign.$("Canvas");
};
$sign.getSigninContent = function(){
	return $sign.$("SigninContent");
};
$sign.getSignupContent = function(){
	return $sign.$("SignupContent");
};
//get fields
$sign.getSigninUsername = function(){
	return $sign.$("SigninUsername");
};
$sign.getSigninPassword = function(){
	return $sign.$("SigninPassword");
};
$sign.getSigninSecurityCode = function(){
	return $sign.$("SigninSecurityCode");
};
$sign.getSignupUsername = function(){
	return $sign.$("SignupUsername")
};
$sign.getSignupPassword = function(){
	return $sign.$("SignupPassword");
};
$sign.getSignupConfirm = function(){
	return $sign.$("SignupConfirm");
};
$sign.getSignupEmail = function(){
	return $sign.$("SignupEmail");
};
$sign.getSignupSecurityCode = function(){
	return $sign.$("SignupSecurityCode");
};
//get buttons
$sign.getSigninActionSignup = function(){
	return $sign.$("SigninActionSignup");
};
$sign.getSigninActionLoad = function(){
	return $sign.$("SigninActionLoad");
};
$sign.getSignupActionSignin = function(){
	return $sign.$("SignupActionSignin");
};
$sign.getSignupActionLoad = function(){
	return $sign.$("SignupActionLoad");
};
$sign.getSigninShutdown = function(){
	return $sign.$("SignShutdown");
};
//get cache
$sign.getSigninCache = function(){
	return $sign.$("Cache");
};
//get messages
$sign.getSigninMessage = function(){
	return $sign.$("SigninMessage");
};
$sign.getSignupMessage = function(){
	return $sign.$("SignupMessage");
};
//get security codes
$sign.getSigninSecurityCodeContent = function(){
	return $sign.$("SigninSecurityCodeContent");
};
$sign.getSignupSecurityCodeContent = function(){
	return $sign.$("SignupSecurityCodeContent");
};
$sign.getSigninSecurityCodeImg = function(){
	return $sign.$("SigninSecurityCodeImg");
};
$sign.getSignupSecurityCodeImg = function(){
	return $sign.$("SignupSecurityCodeImg");
};

//utilities
$sign.$ = function(id){
	return document.getElementById("webos" + id);
};
$sign.getRequest = function(){
	try{
		return new XMLHttpRequest();
	}
	catch(e){}
	try{
		return new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e){}
	try{
		return new ActiveXObject("Microsoft.XMLHTTP");
	}
	catch(e){}
};
$sign.request = function(data, url, callback){
	var xmlHttp = $sign.getRequest();
	xmlHttp.open("post", url, true);
	xmlHttp.onreadystatechange = function(){
		if(xmlHttp.readyState == 4 && xmlHttp.status == 200){
			callback(xmlHttp.responseText);
		}
		else{
			//network error
		}
	};
	xmlHttp.send(data);
};
$sign.getResolution = function(){
	for(var i = 0; i < $sign.resolutions.length - 1; i++){
		if(screen.width > $sign.resolutions[i] && screen.width <= $sign.resolutions[i + 1]){
			return $sign.resolutions[i + 1];
		}
	}
	return $sign.resolutions[$sign.resolutions.length - 1];
};
$sign.redirect = function(){
	location.replace($sign.urls.desktop);
};

//visual effects
$sign.focusInput = function(input){
	input.parentNode.className = "webos-sign-body-signin-data-focus";
};
$sign.blurInput = function(input){
	input.parentNode.className = "";
};
$sign.showSignupSecurityCodeContent = function(){
	$sign.getSignupSecurityCodeContent().style.visibility = "visible";
};
$sign.hideSignupSecurityCodeContent = function(){
	$sign.getSignupSecurityCodeContent().style.visibility = "hidden";
};
$sign.showSigninSecurityCodeContent = function(){
	$sign.getSigninSecurityCodeContent().style.visibility = "visible";
};
$sign.hideSigninSecurityCodeContent = function(){
	$sign.getSigninSecurityCodeContent().style.visibility = "hidden";
};

//ajax
$sign.signin = function(){
	if($sign.checkSigninFields()){
		$sign.setSigninMessage($sign.messages.signinLoading);
		var json = '{"username":"' + $sign.getSigninUsername().value + '",';
		json += '"password":"' + $sign.getSigninPassword().value + '",';
		json += '"security":"' + $sign.getSigninSecurityCode().value + '"}';
		$sign.request(json, $sign.urls.signin, function(response){
			if(response == 1){
				//success
				$sign.redirect();
			}
			else if(response == 2){
				//security code error
				$sign.setSigninMessage($sign.messages.signinSecurityCodeError);
			}
			else{
				//other error
				$sign.setSigninMessage($sign.messages.signinError);
			}
		});
	}
};
$sign.signup = function(){
	if($sign.checkSignupFields()){
		$sign.setSignupMessage($sign.messages.signupLoading);
		var json = '{"username":"' + $sign.getSignupUsername().value + '",';
		json += '"password":"' + $sign.getSignupPassword().value + '",';
		json += '"security":"' + $sign.getSignupSecurityCode().value + '",';
		json += '"email":"' + $sign.getSignupEmail().value + '"}';
		$sign.request(json, $sign.urls.signup, function(response){
			if(response == 1){
				//success
				$sign.redirect();
			}
			else if(response == 2){
				//security code error
				$sign.setSignupMessage($sign.messages.signupSecurityCodeError);
			}
			else if(response == 3){
				//username error
				$sign.setSignupMessage($sign.messages.signupUsernameUsed);
			}
			else if(response == 4){
				//email error
				$sign.setSignupMessage($sign.messages.signupEmailUsed);
			}
			else{
				//unknown error
				$sign.setSignupMessage($sign.messages.signupError);
			}
		});
	}
};

//set messages
$sign.setSigninMessage = function(message){
	$sign.getSigninMessage().innerHTML = message;
};
$sign.resetSigninMessage = function(){
	$sign.setSigninMessage($sign.messages.signinInitial);
};
$sign.setSignupMessage = function(message){
	$sign.getSignupMessage().innerHTML = message;
};
$sign.resetSignupMessage = function(){
	$sign.setSignupMessage($sign.messages.signupInitial) ;
};

//check fields
$sign.checkSigninFields = function(){
	if($sign.getSigninUsername().value.length < 5){
		$sign.setSigninMessage($sign.messages.signinUsernameTooShort);
		return false;
	}
	else if($sign.getSigninPassword().value.length < 5){
		$sign.setSigninMessage($sign.messages.signinPasswordTooShort);
		return false;
	}
	else if($sign.getSigninSecurityCode().value.length < 4){
		$sign.setSigninMessage($sign.messages.signinSecurityCodeTooShort);
		return false;
	}
	return true;
};
$sign.checkSignupFields = function(){
	if($sign.getSignupUsername().value.length < 5){
		$sign.setSignupMessage($sign.messages.signupUsernameTooShort);
		return false;
	}
	else if($sign.getSignupPassword().value.length < 5){
		$sign.setSignupMessage($sign.messages.signupPasswordTooShort);
		return false;
	}
	else if($sign.getSignupSecurityCode().value.length < 4){
		$sign.setSignupMessage($sign.messages.signupSecurityCodeTooShort);
		return false;
	}
	else if($sign.getSignupPassword().value != $sign.getSignupConfirm().value){
		$sign.setSignupMessage($sign.messages.signupPasswordConfirmFaild);
		return false;
	}
	else if(!/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test($sign.getSignupEmail().value)){
		$sign.setSignupMessage($sign.messages.signupEmailError);
		return false;
	}
	return true;
};

//initial when load
$sign.initialLayout = function(){
	//positions
	var canvasWidth = document.body.parentNode.clientWidth > document.body.clientWidth ? document.body.parentNode.clientWidth : document.body.clientWidth;
	var canvasHeight = document.body.parentNode.clientHeight > document.body.clientHeight ? document.body.parentNode.clientHeight : document.body.clientHeight;
	var signinWidth = $sign.getSign().clientWidth;
	var x = canvasWidth > signinWidth ? parseInt((canvasWidth - signinWidth) / 2) : 0;
	var signinHeight = $sign.getSign().clientHeight;
	var y = canvasHeight > signinHeight ? parseInt((canvasHeight - signinHeight) / 2) : 0;
	$sign.getCanvas().style.width = canvasWidth + "px";
	$sign.getCanvas().style.height = canvasHeight + "px";
	$sign.getSign().style.left = x + "px";
	$sign.getSign().style.top = y + "px";
	//presentations
	$sign.getCanvas().className = "webos-canvas-" + $sign.getResolution();
	if($sign.getCanvas().style.visibility != "visible"){
		$sign.getCanvas().style.visibility = "visible";
	}
};
$sign.initialFields = function(){
	//signin
	$sign.getSigninUsername().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSigninUsername().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSigninUsername().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signin();
		}
	};
	$sign.getSigninPassword().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSigninPassword().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSigninPassword().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signin();
		}
	};
	$sign.getSigninSecurityCode().onfocus = function(){
		$sign.focusInput(this);
		$sign.showSigninSecurityCodeContent();
	};
	$sign.getSigninSecurityCode().onblur = function(){
		$sign.blurInput(this);
		$sign.hideSigninSecurityCodeContent();
	};
	$sign.getSigninSecurityCode().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signin();
		}
	};
	//signup
	$sign.getSignupUsername().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSignupUsername().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSignupUsername().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signup();
		}
	};
	$sign.getSignupPassword().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSignupPassword().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSignupPassword().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signup();
		}
	};
	$sign.getSignupConfirm().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSignupConfirm().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSignupConfirm().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signup();
		}
	};
	$sign.getSignupEmail().onfocus = function(){
		$sign.focusInput(this);
	};
	$sign.getSignupEmail().onblur = function(){
		$sign.blurInput(this);
	};
	$sign.getSignupEmail().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signup();
		}
	};
	$sign.getSignupSecurityCode().onfocus = function(){
		$sign.focusInput(this);
		$sign.showSignupSecurityCodeContent();
	};
	$sign.getSignupSecurityCode().onblur = function(){
		$sign.blurInput(this);
		$sign.hideSignupSecurityCodeContent();
	};
	$sign.getSignupSecurityCode().onkeydown = function(){
		var e = arguments[0] ? arguments[0] : event;
		if(e.keyCode == 13){
			$sign.signup();
		}
	};
};
$sign.initialSecurityCode = function(){
	$sign.getSigninSecurityCodeImg().src = $sign.urls.signinSecurityCode;
	$sign.getSignupSecurityCodeImg().src = $sign.urls.signupSecurityCode;
};
$sign.initialButtons = function(){
	//signin
	$sign.getSigninActionSignup().onclick = function(){
		$sign.resetSignupMessage();
		$sign.getSigninContent().style.display = "none";
		$sign.getSignupContent().style.display = "block";
	};
	$sign.getSigninActionLoad().onclick = function(){
		$sign.signin();
	};
    document.getElementById("webosSigninActionSubmit").onclick= function(){
		$sign.signin();
	};
	//signup
	$sign.getSignupActionSignin().onclick = function(){
		$sign.resetSigninMessage();
		$sign.getSignupContent().style.display = "none";
		$sign.getSigninContent().style.display = "block";
	};
	$sign.getSignupActionLoad().onclick = function(){
		$sign.signup();
	};
    document.getElementById("webosSignupActionSubmit").onclick= function(){
		$sign.signup();
	};
	//bottom
	$sign.getSigninShutdown().onclick = function(){
		if(confirm("Shut down now?")){
			opener = null;
			close();
		}
	};
};
$sign.initialCache = function(){
	$sign.getSigninCache().innerHTML = $sign.caches.join(" ");
};
$sign.initial = function(){
	$sign.initialLayout();
	$sign.initialFields();
	$sign.initialSecurityCode();
	$sign.initialButtons();
	$sign.initialCache();
};

window.onload = function(){
	$sign.initial();
};

window.onresize = function(){
	$sign.initialLayout();
};