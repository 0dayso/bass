/*KPI��ָ��ѡ��*/
var kpiSelect = {
	//containerΪhtml��������kpiContainer��Ϊkpi�����������Ѿ����ڣ�appNameDefault��ָ��Ӧ�õ�Ĭ��ֵ
	select : function(options){
		var objAppName=this.appNameSelection();
		var objZbKind=this.zbKindSelection();
		options.container.innerHTML="";
		options.container.appendChild(objAppName);
		options.container.appendChild($CT("ָ�����ͣ�"));
		options.container.appendChild(objZbKind);
		function _invoke(_container,appName,zbKind){
			var _ajax = new aihb.Ajax({
				url : "/hb-bass-navigation/hbirs/action/dynamicrpt?method=appIndicators"
				,parameters : "appName="+appName+"&zbKind="+zbKind
				,callback : function(xmlrequest){
					var datas=[];
					try{
						eval("datas="+xmlrequest.responseText);
					}catch(e){debugger;}
					_container.length=0;
					for(var i=0; i< datas.length;i++){
						_container[i]=new Option(datas[i].name,datas[i].key);
						if(_container.defaultKey==datas[i].key){
							_container[i].selected=true;
						}
					}
				}
			});
			_ajax.request();
		}
		objAppName.value=options.appNameDefault||"ChannelD";
		
		objAppName.onchange=function(){
			_invoke(options.kpiContainer,this.value,objZbKind.value);
		}
		
		objZbKind.onchange=function(){
			_invoke(options.kpiContainer,objAppName.value,this.value);
		}
		
		objAppName.onchange();
		
		return objAppName;
	}
	,appNames : [["ChannelD","��KPI"],["ChannelM","��KPI"],["BureauD","������KPI"],["BureauM","������KPI"],["GroupcustD","������KPI"],["GroupcustM","������KPI"],["CollegeD","��У��KPI"],["CollegeM","��У��KPI"]]
	,appNameSelection : function(options){
		var _selAppName=$C("select");
		if(options&&options.id)_selAppName.id=options.id;
		var datas=this.appNames;
		
		for(var i=0;i<datas.length;i++){
			_selAppName[i]=new Option(datas[i][1],datas[i][0]);
		}
		return _selAppName;
	}
	,zbKindSelection : function(options){
		var _selAppName=$C("select");
		if(options&&options.id)_selAppName.id=options.id;
		var datas=[["user","�û�"],["income","����"],["traffic","����"]];
		_selAppName[0]=new Option("ȫ��","");
		for(var i=0;i<datas.length;i++){
			_selAppName[i+1]=new Option(datas[i][1],datas[i][0]);
		}
		return _selAppName;
	}
}