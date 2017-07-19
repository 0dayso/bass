/*
	author : higherzl,
	date : 2010.05.27
	create reason : for reuseable,flexable app using
*/


/*
2010-7-2 局方需求5分钟相同的操作只发一次，先做一个变通的方法
使用全局变量，相同的操作就只发一次，会少很多，但是可以暂时满足，到时候再系统级重构
by Mei Kefu
*/
var oriContent="";
(function(){
var _params = aihb.Util.paramsObj(),
	phoneDic = {
		"0" : "13808685006;13808682211",
		//"0" : "13697339119;13659878710",
		"11" : "13871005115",
		"12" : "13971759996",
		"13" : "13871806060",
		"14" : "15872459786",
		"15" : "13697189803",
		"16" : "13971906961",
		"17" : "13807270001",
		"18" : "13907229015",
		"19" : "13886520246",
		"20" : "13507212600",
		"23" : "15807260008",
		"24" : "15826785511",
		"25" : "13995944300",
		"26" : "13508692999"
	}
function sendFunc(name) {
	var content='[湖北经分告警][工号:' + _params.loginname + '(' + aihb.Constants.getArea(_params.cityId).cityName + ')]'+name+'了标识为一级敏感的内容。'+'[应用名称: '+ document.title + ']，请关注。';
	
	if(oriContent==content){
		return;
	}
	oriContent = content;
	var contact = phoneDic[_params.cityId];
	if(!contact)
		return ; //不找麻烦 by meikf
	
	var jsonStr = '&json=' + '{"sql":"' + encodeURIComponent(" values ('"+content+"')") + '","contacts":"' + contact + '","ds":"web"}';
	var _ajax = new aihb.Ajax({
		url : '/hbirs/action/scheduler?method=add'
		,parameters : "jobClassName=com.asiainfo.hbbass.component.scheduler.job.PushSmsJob"+jsonStr
		,callback : function(xmlrequest){
			//debugger;
		}
	});
	_ajax.request();
}
_addEventListener(window,"load",function(){
	/* 2010.05.28 去除查询通知
	if(typeof doSubmit != "undefined"){
		doSubmit = _after(doSubmit, function(){
			sendFunc("查询");
		});
	}
	*/
	
	if(typeof toDown != "undefined"){
		toDown = _after(toDown, function(){
			sendFunc("下载");
		});
	}
	
	if(typeof toXls != "undefined"){
		toXls = _after(toXls, function(){
			sendFunc("清单下载");
		});
	}
	/* 2010.05.28 去除查询通知
	// 挖高分析
	if(typeof onClickSubmit != "undefined"){
		onClickSubmit = _after(onClickSubmit, function(){
			sendFunc("查询");
		});
	}
	*/
	/* 2010.05.28 去除查询通知
	//
	if(typeof toQuery != "undefined"){
		toQuery = _after(toQuery, function(){
			sendFunc("查询");
		});
	}
	*/
	/* 2010.05.28 去除查询通知
	//定制终端预拆包用户情况 
	if(typeof clickSubmit != "undefined"){
		clickSubmit = _after(clickSubmit, function(){
			sendFunc("查询");
		});
	}
	*/
	//挖高的下载也是这个
	if(typeof down != "undefined"){
		down = _after(down, function(){
			sendFunc("下载");
		});
	}
	
	
});
})();