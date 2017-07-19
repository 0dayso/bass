<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript">
window.onload=function(){
	query();
}

aihb.Util.addEventListener(document,"keypress",function(e){
if(e.keyCode==13){
	query();
}
});

function _short(val,length){
	var text=val;
	var _len = length||30;
	if(text && text.length>_len){
		text=text.substring(0,_len)+"...";
	}
	return text;
}

var _header=[
	{"name":"协作人地市","dataIndex":"areaname","cellStyle":"grid_row_cell_text"}
	,{"name":"协作人4A帐号","dataIndex":"userid","cellStyle":"grid_row_cell_text"}
	,{"name":"协作人姓名","dataIndex":"username","cellStyle":"grid_row_cell_text"}
	,{"name":"协作人手机号","dataIndex":"mobile","cellStyle":"grid_row_cell_text"}
	,{"name":"操作","dataIndex":"id","cellStyle":"grid_row_cell","cellFunc":"oper"}
];

function oper(val,options){
	var _obj=$C("div");
	_aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("删除"));
	_aEdit.record=options.record;
	_aEdit.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/jinku/delete"
			,data: "_method=delete&id="+encodeURIComponent(this.record.id)
			,dataType : "json"
			,success: function(data){
	   			alert( data.status );
	   			if(data.status == "操作成功"){
	   				location.reload();
	     		}
	 		}
		});
	};
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	return _obj;
}
window.oper=oper;

function query(){
	var sql = "select ID, CITYID, case when cityid = '0' then '省公司' else AREA_NAME end AREANAME, USERID, USERNAME, MOBILE, LEVEL from FPF_MANAGE_4A left join mk.bt_area on int(cityid) = area_id ";
//	sql = strEncode(sql);
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: sql
		,ds:"web"
		,isCached : false
		,url:"${mvcPath}/sqlQuery"
	});
	grid.run();
}
var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont, mvcPath:'${mvcPath}'});
function add(elements){
	elements=elements||{};
	_cont.innerHTML="";
	
	var _iCityid=$C("select");
	_iCityid.id="ipt_cityid";
	_iCityid.value=elements.cityid||"";
	var sql="select area_id, area_name from (select area_id,area_name from mk.bt_area union all values(0,'省公司')) order by area_id";
	jQuery.ajax({
		url:"${mvcPath}/hbirs/action/jsondata?method=query&isLog=false"
		,data:"sql="+strEncode(sql)+"&ds=web"
		,dataType:"json"
		,type:"post"
		,success:function(datas){
			_iCityid.length=0;
			for(var i=0;i<datas.length;i++){
				var data=datas[i];
				_iCityid[i]=new Option(data.area_name,data.area_id);
			}
		}
	});
	
	
	var _iUserid=$C("input");
	_iUserid.id="ipt_userid";
	_iUserid.type="text";
	_iUserid.value=elements.userid||"";
	
	var _iUsername=$C("input");
	_iUsername.id="ipt_username";
	_iUsername.type="text";
	_iUsername.value=elements.username||"";
	
	var _iMobile=$C("input");
	_iMobile.id="ipt_mobile";
	_iMobile.type="text";
	_iMobile.value=elements.mobile||"";
	
	_cont.appendChild($CT("协作人地市：  "));
	_cont.appendChild(_iCityid);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("协作人4A帐号："));
	_cont.appendChild(_iUserid);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("协作人姓名：  "));
	_cont.appendChild(_iUsername);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("协作人手机号："));
	_cont.appendChild(_iMobile);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.rep_id=elements.rep_id;
	iBtn.onclick=function(){
		if($("#ipt_cityid").val().trim()==""){
			alert("协作人地市");
			return;
		}	
		if($("#ipt_userid").val().trim()==""){
			alert("协作人4A帐号");
			return;
		}	
		if($("#ipt_username").val().trim()==""){
			alert("协作人姓名");
			return;
		}
		if($("#ipt_mobile").val().trim()==""){
			alert("协作人手机号");
			return;
		}
		$.ajax({
			type: "post"
			,url: "${mvcPath}/jinku/save"
			,data: "_method=put&cityid="+encodeURIComponent($("#ipt_cityid").val())+"&userid="+encodeURIComponent($("#ipt_userid").val())+"&username="+encodeURIComponent($("#ipt_username").val())+"&mobile="+encodeURIComponent($("#ipt_mobile").val())
			,dataType : "json"
			,success: function(data){
     			alert(data.status);
     			if(data.status == "操作成功"){
     				location.reload();
	     		}
   			}
		});
	}
	_cont.appendChild(iBtn);
	
	_mask.show();
}

</script>
  </head>
  <body style="width:98%;">
  	<div style="text-align: right;padding: 3px 0px 5px 6px;">
  	<input type="button" class="form_button_short" value="新增" onClick="add()"></div>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
