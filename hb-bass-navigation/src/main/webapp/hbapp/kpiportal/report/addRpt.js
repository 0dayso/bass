function _new(appNameDefault){
	$("sid").value="";
	$("feedback_div").style.display="";
	document.forms[0].desc.value="";
	document.forms[0].name.value="";
	objAppName=kpiSelect.select({container: $("selection"),kpiContainer:$("list1"),appNameDefault:appNameDefault})
	$("list2").length=0;
}
var objAppName=undefined;
function _reportEdit(sid,appNameDefault){
	objAppName=kpiSelect.select({container: $("selection"),kpiContainer:$("list1"),appNameDefault:appNameDefault});
	$("list2").length=0;
	$("sid").value=sid;
	var _ajax = new aihb.Ajax({
		url : "/hb-bass-navigation/hbirs/action/dynamicrpt?method=edit"
		,parameters : "sid="+sid
		
		,callback : function(xmlrequest){
			var obj={};
			eval("obj="+xmlrequest.responseText);
			objAppName.value=obj.subject[0].value;
			document.forms[0].desc.value=obj.subject[0].desc;
			document.forms[0].name.value=obj.subject[0].name;
			
			var list=obj.indicators
			var elems1 = $("list1");
			var elems2 = $("list2");
			for(var j=0;j<list.length;j++){
				for(var i=0; i<elems1.options.length;i++){
					if(elems1[i].value==list[j].data_index){
						elems2.options.add(new Option(elems1[i].text, elems1[i].value));
						elems1.remove(i);
						i=i-1;
						break;
					}
				}
			}
			$("feedback_div").style.display="";
		}
	});
	_ajax.request();
}

function _check(){
	if($("name").value.length==0){
		alert("�������д�������");
		return false;
	}
	
	if($("list2").length==0){
		alert("�����ѡ��һ�����ϵ�ָ��");
		return  false;
	}
	return true;
}

function _submit(){
	if(!_check())return;
	
	var elems = $("list2");
	var ids = "";
	var names = "";
	for(var i=0; i< elems.length;i++){
		if(ids.length>0)ids +=",";
		ids += elems[i].value
		if(names.length>0)names +=",";
		names += elems[i].text;
	}
	var _ajax = new aihb.Ajax({
		url : "/hb-bass-navigation/hbirs/action/dynamicrpt?method=save"
		,parameters : "pid="+$("pid").value+"&sid="+$("sid").value+"&appName="+objAppName.value+"&ids="+ids+"&names="+encodeURIComponent(encodeURIComponent(names))+"&name="+encodeURIComponent(encodeURIComponent(document.forms[0].name.value))+"&desc="+encodeURIComponent(encodeURIComponent(document.forms[0].desc.value))
		,callback : function(xmlrequest){
			$("feedback_div").style.display="none";
			_render();
		}
	});
	//alert(_ajax.options.parameters)
	_ajax.request();
}