<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>湖北移动经营分析系统</title>
<link rel="Shortcut Icon" type="images/x-icon" href="${mvcPath}/hb-bass-frame/images/he.ico" />
<script type="text/javascript" src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/gVerify.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/md5.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/bass_common.css" />
<style>
.text_input{border:0;font-size:20px;color:#333;font-family:Helvetica, Arial, sans-serif;font-weight:bold;height:24px;width:270px;line-height:24px;background:#D1D1D1;}
.text_input_{border:0;font-size:20px;color:#333;font-family:Helvetica, Arial, sans-serif;font-weight:bold;height:24px;width:68px;line-height:24px;background:#FAFFBD;}
/*.bodyImg{position:relative;width:550px;height:363px;display:inline-block;background:url(${mvcPath}/resources/views/ftl/frame/login_form.png);}*/
.bodyImg{position:relative;width:550px;height:429px;display:inline-block;background:url(${mvcPath}/resources/views/ftl/frame/login.png);}
</style>
</head>
<body style="background:#ffffff;text-align: center;">
 <div style="position:absolute;top:10px;left:20px;background:url(${mvcPath}/resources/image/default/cm_logo_blue.gif);width:143px;height:54px;"></div> 
<!--<div style="position:absolute;top:10px;left:20px;background:url(${mvcPath}/resources/image/default/sgdl_logo_blue.png);width:202px;height:95px;"></div>-->
<!-- 
<div style="position:absolute;bottom:10px;right:10px;background:url(${mvcPath}/resources/image/default/ailogo.png);width:122px;height:21px;"></div>
 -->
<div style="position:relative;height:130px;width:550px;line-height:200px;display:inline-block;">
<span style="font-family: 微软雅黑;color:#999;position:absolute;left:15px;top:5px;font-size:30px;">
${appName}
</span></div>
<br/>
<div class="bodyImg">
<form action="${mvcPath}/login" method="post">
	<div style="position:absolute;left:195px;top:128px;"><input type="text" id="name" name="userId" class="text_input" value="<#if userId?? >${userId}</#if>admin"/></div>
	
	<div style="position:absolute;left:195px;top:195px;"><input type=password id="pass" name="pwd" class="text_input" value="<#if pwd?? >${pwd}</#if>let me pass"/></div>
	
	<div style="position:absolute;left:195px;top:265px;">
		<input id="code_input" type=text name="verification"  class="text_input_" /></div>
		<div id="v_container" style="position:absolute;left:295px;top:263px;width:120px;height:32px;"></div>
		<a onclick="verifyCode.refresh()"href="javascript:void(0)" style="position:absolute;left:416px;top:257px;width:120px;height:32px;">看不清楚？<br/>换一张</a>
	<div style="position:absolute;left:150px;top:295px;line-height:20px;color:red;" id="msg"><#if msg??>${msg}</#if></div>
	
	<div style="position:absolute;left:60px;top:323px;line-height:26px;color:#666;font-family: 黑体;">
	<input type="checkbox" id="rememberme" name="rememberme"/> 记住用户</div>
	<input type="hidden" name="redirect" value=""/>
	<a id="btn1" style="position:absolute;left:312px;top:321px;width:98px;height:33px;display:inline-block;cursor: pointer;"></a>
</form>
</div>
</body>
</html>

<script type="text/javascript" >

var verifyCode = new GVerify("v_container");

function setCookie(name,value){
    var days = 7;
    var exp  = new Date();
    exp.setTime(exp.getTime() + days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name){
	var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	if(arr != null) return unescape(arr[2]); return null;
}
function delCookie(name){
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}
$(document).ready(function(){
	timer(parseInt(${time}),function(){
	$("#msg").text("");
	$("#btn1").click(submit1);
	$("#btn1").css("cursor","pointer");
	});
	$("#btn1").click(submit1);
	var msg = $('#msg').text();
	if(msg != null && msg.length>0){
		alert(msg);
	}
	var count=0;
	$(document).keydown(function(event){  
	  if(event.keyCode==13){
		  submit1();
	  }
	});
	function verification(){
		var verification=$.trim(document.forms[0].verification.value);
		if(verification.length!=0){
			if(verifyCode.validate(verification)){return true;}else{$("#msg").text("验证码输入不正确");return false;}
		}else{
			$("#msg").text("验证码不能为空");
			return false;
		}
	}
	function submit1() {
	    if (verification()) {
	        var userName =document.forms[0].userId.value;
	        var passWord =hex_md5(document.forms[0].pwd.value);
	        if (document.forms[0].rememberme.checked) {
	            setCookie("loginUserId", document.forms[0].userId.value);
	        } else {
	            delCookie("loginUserId");
	        }
	        $("#loadmask").show();
	        $("#msg").text("");
	        var code=verifyCode.q();
	        var code_input=$("#code_input").val();
	        var _data={"userId":userName,"pwd":passWord,"code":code,"code_input":code_input};
	        $.ajax({
	            url: "${mvcPath}/login?redirect=" + document.forms[0].redirect.value,
	            type: "post",
	            data: _data,
	            dataType: "json",
	            success: function(data) {
	                if (data.success) {
	                    $("#btn1").unbind();
	                    var timeout = 1000;
	                    function _redirect() {
	                        var regExp = new RegExp(splitSymbol, "g");
	                        //location.href=data.redirect.replace(regExp,"&");
	                        location.href = data.redirect;
	                    }
	                    setTimeout(_redirect, timeout);
	                } else {
	                    verifyCode.refresh();
	                    $("#msg").text(data.msg);
	                    if (data.succ) {
	                        $("#msg").text(data.info);
	                        timer(60, function() {
	                            $("#msg").text("");
	                            $("#btn1").click(submit1);
	                            $("#btn1").css("cursor", "pointer");
	                        });
	                    } else {
	                        $("#msg").text(data.info);
	                    }
	                    $("#loadmask").hide();
	                }
	            }
	        });
	    }
	}
	function timer(intDiff ,callback){
		if(intDiff>0){
			$("#btn1").unbind();
			$("#btn1").css("cursor","");
			var timer=setInterval(function(){
				var second=0;//时间默认值	
				day = Math.floor(intDiff / (60 * 60 * 24));
				hour = Math.floor(intDiff / (60 * 60)) - (day * 24);
				minute = Math.floor(intDiff / 60) - (day * 24 * 60) - (hour * 60);
				second = Math.floor(intDiff) - (day * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60);
				if (second <= 9) second = '0' + second;
				$('#msg').text("你的密码输入超过2次请"+second+'秒再登陆');
				intDiff--;
				if(intDiff==0){
					clearInterval(timer);
					callback();
				}
			}, 1000);
		}
		
		
	} 
	var cookieUserId = getCookie("loginUserId");
	if(cookieUserId&&cookieUserId.length>0){
		document.forms[0].rememberme.checked=true;
		if(document.forms[0].userId.value.length==0){
			document.forms[0].userId.value=cookieUserId
		}
	}
	var splitSymbol="@@";
	var _loc = window.parent.location||window.location;
	var _param =window.location.search;
	var redirectKey="redirect";
	if(_param && _param.length>0 && _param.indexOf(redirectKey)!= -1){
		_param=_param.substring(_param.indexOf(redirectKey)+redirectKey.length+1);
		
		if(_param.indexOf("&")>0){
			//_param=_param.substring(0, _param.indexOf("&"));
			_param=_param.replace(/\&/g, splitSymbol);
		}
	}
	document.forms[0].redirect.value=_param||'${redirectUri}';
});
</script>
