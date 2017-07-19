<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="gbk"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
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
	{"name":"报表ID","dataIndex":"rep_id","cellStyle":"grid_row_cell_text"}
	,{"name":"报表名称","dataIndex":"rep_name","cellStyle":"grid_row_cell_text"}
	,{"name":"报表路径","dataIndex":"xml","cellStyle":"grid_row_cell_text"}
	,{"name":"报表SQL","dataIndex":"rep_sql","cellStyle":"grid_row_cell_text"
		,cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,33)));
			return span;
		} 
	}
	,{"name":"打横参数","dataIndex":"rep_papr","cellStyle":"grid_row_cell_text"}
	,{"name":"报表类型","dataIndex":"type","cellStyle":"grid_row_cell_text"}
	,{"name":"报表状态","dataIndex":"state","cellStyle":"grid_row_cell_text"}
	,{"name":"Email","dataIndex":"email","cellStyle":"grid_row_cell_text"}
	,{"name":"电话","dataIndex":"phone","cellStyle":"grid_row_cell_text"}
	,{"name":"操作","dataIndex":"rep_id","cellStyle":"grid_row_cell","cellFunc":"oper"}
];

function oper(val,options){
	var _obj=$C("div");
	var _aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("编辑"));
	_aEdit.record=options.record
	_aEdit.onclick=function(){
		update(this.record);
	};
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	
	_aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("删除"));
	_aEdit.record=options.record
	_aEdit.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/finance/bat"
			,data: "_method=delete&rep_id="+encodeURIComponent(this.record.rep_id)
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
	return _obj;
}
window.oper=oper;

function query(){
	var sql = "select rep_id, rep_name, xml, rep_sql, rep_papr, type, state, email, phone from NMK.CFG_FINANCE_BAT order by rep_id with ur ";
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: sql
		,ds:"web"
		,isCached : false
	});
	grid.run();
}
var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});
function add(elements){
	elements=elements||{};
	_cont.innerHTML="";
	
	var _iId=$C("input");
	_iId.id="ipt_id";
	_iId.type="text";
	_iId.style.cssText="width:200px;"
	_iId.value=elements.rep_id||"";
	var _iName=$C("input");
	_iName.id="ipt_name";
	_iName.type="text";
	_iName.style.cssText="width:200px;"
	_iName.value=elements.rep_name||"";
	var _iXml=$C("input");
	_iXml.id="ipt_xml";
	_iXml.type="text";
	_iXml.value=elements.xml||"";
	
	var _iSql=$C("textarea");
	_iSql.id="ipt_sql";
	_iSql.cols="60";
	_iSql.rows="5";
	_iSql.value=elements.rep_sql||"";
	
	var _iPapr=$C("input");
	_iPapr.id="ipt_papr";
	_iPapr.type="text";
	_iPapr.style.cssText="width:400px;"
	_iPapr.value=elements.rep_papr||"";
	
	var _iType=$C("input");
	_iType.id="ipt_type";
	_iType.type="text";
	_iType.value=elements.type||"";
	
	var _iEmail=$C("input");
	_iEmail.id="ipt_email";
	_iEmail.type="text";
	_iEmail.value=elements.email||"";
	
	var _iPhone=$C("input");
	_iPhone.id="ipt_phone";
	_iPhone.type="text";
	_iPhone.value=elements.phone||"";
	
	_cont.appendChild($CT("报表ID：  "));
	_cont.appendChild(_iId);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表名称："));
	_cont.appendChild(_iName);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表路径："));
	_cont.appendChild(_iXml);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表SQL： "));
	_cont.appendChild(_iSql);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("打横参数："));
	_cont.appendChild(_iPapr);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表类型："));
	_cont.appendChild(_iType);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("Email：   "));
	_cont.appendChild(_iEmail);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("电话：    "));
	_cont.appendChild(_iPhone);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.rep_id=elements.rep_id;
	iBtn.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/finance/save"
			,data: "_method=put&rep_id="+encodeURIComponent($("#ipt_id").val())+"&rep_name="+encodeURIComponent($("#ipt_name").val())+"&xml="+encodeURIComponent($("#ipt_xml").val())+"&rep_sql="+encodeURIComponent($("#ipt_sql").val())+"&rep_papr="+encodeURIComponent($("#ipt_papr").val())+"&type="+encodeURIComponent($("#ipt_type").val())+"&email="+encodeURIComponent($("#ipt_email").val())+"&phone="+encodeURIComponent($("#ipt_phone").val())
			,dataType : "json"
			,success: function(data){
     			if(data.status == "操作成功"){
     				location.reload();
	     		}
   			}
		});
	}
	_cont.appendChild(iBtn);
	
	_mask.show();
}

function update(elements){
	elements=elements||{};
	_cont.innerHTML="";
	
	var _iId=$C("input");
	_iId.id="ipt_id";
	_iId.type="text";
	_iId.disabled = true;
	_iId.style.cssText="width:200px;"
	_iId.value=elements.rep_id||"";
	var _iName=$C("input");
	_iName.id="ipt_name";
	_iName.type="text";
	_iName.style.cssText="width:200px;"
	_iName.value=elements.rep_name||"";
	var _iXml=$C("input");
	_iXml.id="ipt_xml";
	_iXml.type="text";
	_iXml.value=elements.xml||"";
	
	var _iSql=$C("textarea");
	_iSql.id="ipt_sql";
	_iSql.cols="60";
	_iSql.rows="5";
	_iSql.value=elements.rep_sql||"";
	
	var _iPapr=$C("input");
	_iPapr.id="ipt_papr";
	_iPapr.type="text";
	_iPapr.style.cssText="width:400px;"
	_iPapr.value=elements.rep_papr||"";
	
	var _iType=$C("input");
	_iType.id="ipt_type";
	_iType.type="text";
	_iType.value=elements.type||"";
	
	var _iEmail=$C("input");
	_iEmail.id="ipt_email";
	_iEmail.type="text";
	_iEmail.value=elements.email||"";
	
	var _iPhone=$C("input");
	_iPhone.id="ipt_phone";
	_iPhone.type="text";
	_iPhone.value=elements.phone||"";
	
	_cont.appendChild($CT("报表ID：  "));
	_cont.appendChild(_iId);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表名称："));
	_cont.appendChild(_iName);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表路径："));
	_cont.appendChild(_iXml);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表SQL： "));
	_cont.appendChild(_iSql);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("打横参数："));
	_cont.appendChild(_iPapr);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("报表类型："));
	_cont.appendChild(_iType);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("Email：   "));
	_cont.appendChild(_iEmail);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("电话：    "));
	_cont.appendChild(_iPhone);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.rep_id=elements.rep_id;
	iBtn.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/finance/update"
			,data: "_method=put&rep_id="+encodeURIComponent($("#ipt_id").val())+"&rep_name="+encodeURIComponent($("#ipt_name").val())+"&xml="+encodeURIComponent($("#ipt_xml").val())+"&rep_sql="+encodeURIComponent($("#ipt_sql").val())+"&rep_papr="+encodeURIComponent($("#ipt_papr").val())+"&type="+encodeURIComponent($("#ipt_type").val())+"&email="+encodeURIComponent($("#ipt_email").val())+"&phone="+encodeURIComponent($("#ipt_phone").val())
			,dataType : "json"
			,success: function(data){
     			alert( data.status );
     			if(data.status == "操作成功"){
     				location.reload();
	     		}
   			}
		});
	}
	_cont.appendChild(iBtn);
	
	_mask.show();
}

function checkBlur(obj,text) {
	if(obj.value == "") {
		obj.value=text;
		obj.style.color = "gray";
		obj.style.fontStyle = "italic";
	}
}

function checkFocus(obj,text) {
	if(obj.value == text) {
		obj.value="";
		obj.style.color = "black";
		obj.style.fontStyle = "normal";
	}
}
</script>
  </head>
  <body>
  	<div style="text-align: right;padding: 3px 0px 5px 6px;">
  	<input type="button" class="form_button_short" value="新增" onClick="add()"></div>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
