<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="utf-8"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript">
var $j=jQuery.noConflict();
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
	{"name":"id","dataIndex":"id"}
	,{"name":"名称","dataIndex":"name","cellStyle":"grid_row_cell_text","cellFunc":"edit"}
	,{"name":"描述","dataIndex":"desc","cellStyle":"grid_row_cell_text"
		,cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,33)));
			return span;
		} 
	}
	,{"name":"后台程序","dataIndex":"proc"
		,cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,14)));
			return span;
		} 
	}
	,{"name":"创建用户","dataIndex":"user_id"
		,"cellFunc":function(val,options){
			var _div=$C("a");
			_div.href="javascript:void(0)";
			_div.appendChild($CT(val));
			_div.elements=options.record;
			_div.onclick=function(elements){
				_new(this.elements);
			}
			return _div	
			
		}
	}
	,{"name":"局方责任人","dataIndex":"resp"}
	,{"name":"状态","dataIndex":"status"}
	,{"name":"最后修改","dataIndex":"lastupd"}
	,{"name":"源表","dataIndex":"value"
		,cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,20)));
			return span;
		} 
	}
	,{"name":"统计口径说明","dataIndex":"caliber_descript"
		,cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,20)));
			return span;
		} 
	}
];

function query(){
	var sql = "select id, name, desc, user_id, lastupd, status, proc, resp, value(caliber_descript,'') caliber_descript, value(value,'') value from VIEW_IRS_SUBJECT left join (select sid, max(case when code = 'Resp' then value end) resp, max(case when code = 'Proc' then value end) proc  from fpf_irs_subject_ext where code in ('Resp', 'Proc') group by sid) b on id = sid where kind in ('配置') ";
	var codi="";
	if($("sName").value!="id与名称模糊查询"){
		codi+=" and (name like '%"+$("sName").value+"%' or char(int(id)) like '%"+$("sName").value+"%')";
	}
	
	if($("sUser").value!="创建用户"){
		codi+=" and user_id like '%"+$("sUser").value+"%'";
	}
	
	sql += codi + "  order by lastupd desc";
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
function _new(elements){
	elements=elements||{};
	_cont.innerHTML="";
	
	var _iName=$C("input");
	_iName.id="ipt_name";
	_iName.type="text";
	_iName.style.cssText="width:200px;"
	_iName.value=elements.name||"";
	var _iDesc=$C("textarea");
	_iDesc.id="ipt_desc";
	_iDesc.cols="60";
	_iDesc.rows="5";
	_iDesc.value=elements.desc||"";
	var _iUser=$C("input");
	_iUser.id="ipt_user";
	_iUser.type="text";
	_iUser.value=elements.user_id||"";
	
	var _iProc=$C("input");
	_iProc.id="ipt_proc";
	_iProc.type="text";
	_iProc.value=elements.proc||"";
	
	var _iResp=$C("input");
	_iResp.id="ipt_resp";
	_iResp.type="text";
	_iResp.value=elements.resp||"";
	
	var _iSour=$C("input");
	_iSour.id="ipt_sour";
	_iSour.type="text";
	_iSour.value=elements.value||"";
	
	var _iCali=$C("textarea");
	_iCali.id="ipt_cali";
	_iCali.cols="60";
	_iCali.rows="5";
	_iCali.value=elements.caliber_descript||"";
	
	_cont.appendChild($CT("名    称：    "));
	_cont.appendChild(_iName);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("描    述：    "));
	_cont.appendChild(_iDesc);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("创 建 人：    "));
	_cont.appendChild(_iUser);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("后台程序：    "));
	_cont.appendChild(_iProc);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("局方责任人：  "));
	_cont.appendChild(_iResp);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("源    表：    "));
	_cont.appendChild(_iSour);
	_cont.appendChild($CT("(用半角逗号分隔如',')"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("统计口径说明："));
	_cont.appendChild(_iCali);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.sid=elements.id;
	iBtn.onclick=function(){
		$j.ajax({
			type: "post"
			,url: this.sid?"${mvcPath}/report/"+this.sid:"${mvcPath}/report/save"
			,data: "_method=put&name="+encodeURIComponent($("ipt_name").value)+"&desc="+encodeURIComponent($("ipt_desc").value)+"&resp="+encodeURIComponent($("ipt_resp").value)+"&user="+encodeURIComponent($("ipt_user").value)+"&proc="+encodeURIComponent($("ipt_proc").value)+"&source_table="+encodeURIComponent($("ipt_sour").value)+"&caliber_descript="+encodeURIComponent($("ipt_cali").value)+(this.sid?"&sid="+this.sid:"")
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

function edit(val,options){
	var _div=$C("a");
	_div.sid=options.record.id;
	_div.href="javascript:void(0)";
	_div.title=val;
	_div.appendChild($CT(_short(val,18)));
	_div.onclick=function(){
		tabAdd({title:this.title,url:"${mvcPath}/report/conf/"+this.sid});
	}
	return _div
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
  	<div style="padding: 3px 0px 5px 6px;">
  	<input type="text" id="sName" value="id与名称模糊查询" style="color:gray; font-style: italic;" onfocus="checkFocus(this,'id与名称模糊查询')" onblur="checkBlur(this,'id与名称模糊查询')"> 
  	<input type="text" id="sUser" value="创建用户" style="color:gray; font-style: italic;width: 70px;" onfocus="checkFocus(this,'创建用户')" onblur="checkBlur(this,'创建用户')">
  	<input type="button" class="form_button_short" value="查询" onClick="query()"> 
  	<input type="button" class="form_button_short" value="新增" onClick="_new()"></div>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
