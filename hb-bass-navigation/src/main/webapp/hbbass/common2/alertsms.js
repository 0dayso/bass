/*
	author : higherzl,
	date : 2010.05.27
	create reason : for reuseable,flexable app using
*/


/*
2010-7-2 �ַ�����5������ͬ�Ĳ���ֻ��һ�Σ�����һ����ͨ�ķ���
ʹ��ȫ�ֱ�������ͬ�Ĳ�����ֻ��һ�Σ����ٺܶ࣬���ǿ�����ʱ���㣬��ʱ����ϵͳ���ع�
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
	var content='[�������ָ澯][����:' + _params.loginname + '(' + aihb.Constants.getArea(_params.cityId).cityName + ')]'+name+'�˱�ʶΪһ�����е����ݡ�'+'[Ӧ������: '+ document.title + ']�����ע��';
	
	if(oriContent==content){
		return;
	}
	oriContent = content;
	var contact = phoneDic[_params.cityId];
	if(!contact)
		return ; //�����鷳 by meikf
	
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
	/* 2010.05.28 ȥ����ѯ֪ͨ
	if(typeof doSubmit != "undefined"){
		doSubmit = _after(doSubmit, function(){
			sendFunc("��ѯ");
		});
	}
	*/
	
	if(typeof toDown != "undefined"){
		toDown = _after(toDown, function(){
			sendFunc("����");
		});
	}
	
	if(typeof toXls != "undefined"){
		toXls = _after(toXls, function(){
			sendFunc("�嵥����");
		});
	}
	/* 2010.05.28 ȥ����ѯ֪ͨ
	// �ڸ߷���
	if(typeof onClickSubmit != "undefined"){
		onClickSubmit = _after(onClickSubmit, function(){
			sendFunc("��ѯ");
		});
	}
	*/
	/* 2010.05.28 ȥ����ѯ֪ͨ
	//
	if(typeof toQuery != "undefined"){
		toQuery = _after(toQuery, function(){
			sendFunc("��ѯ");
		});
	}
	*/
	/* 2010.05.28 ȥ����ѯ֪ͨ
	//�����ն�Ԥ����û���� 
	if(typeof clickSubmit != "undefined"){
		clickSubmit = _after(clickSubmit, function(){
			sendFunc("��ѯ");
		});
	}
	*/
	//�ڸߵ�����Ҳ�����
	if(typeof down != "undefined"){
		down = _after(down, function(){
			sendFunc("����");
		});
	}
	
	
});
})();