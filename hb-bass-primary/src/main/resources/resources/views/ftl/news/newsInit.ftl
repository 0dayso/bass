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
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript" src="${mvcPath}/resources/js/cryptojs/aes.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/cryptojs/mode-ecb-min.js"></script>
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
	{"name":"发布时间","dataIndex":"newsdate","cellStyle":"grid_row_cell_text"}
	,{"name":"标题","dataIndex":"newstitle","cellStyle":"grid_row_cell_text"}
	,{"name":"内容","dataIndex":"newsmsg","cellStyle":"grid_row_cell_text",
		cellFunc : function(val,options){
			var span=$C("span");
			span.appendChild($CT(_short(val,33)));
			return span;
		} 
	}
	,{"name":"有效开始时间","dataIndex":"valid_begin_date","cellStyle":"grid_row_cell_text"}
	,{"name":"有效结束时间","dataIndex":"valid_end_date","cellStyle":"grid_row_cell_text"}
	,{"name":"状态","dataIndex":"status","cellStyle":"grid_row_cell_text"}
	,{"name":"是否发送掌分","dataIndex":"issend","cellStyle":"grid_row_cell_text"}
	,{"name":"操作","dataIndex":"newsid","cellStyle":"grid_row_cell","cellFunc":"oper"}
];

function oper(val,options){
	var _obj=$C("div");
	var _aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("修改"));
	_aEdit.record=options.record;
	_aEdit.onclick=function(){
		update(this.record);
	};
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	
	var _aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("发布"));
	_aEdit.record=options.record;
	_aEdit.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/news/auditing"
			,data: "_method=put&newsid="+encodeURIComponent(this.record.newsid)+"&issend="+encodeURIComponent(this.record.issend_value)
			,dataType : "json"
			,success: function(data){
				alert(data.status);
	    		if(data.status == "发布成功"){
	    			location.reload();
		   		}
	   		}
		});
	};
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	
	_aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("删除"));
	_aEdit.record=options.record;
	if (options.record.status=='已发布'){
		_aEdit.disabled=true;
	}else{
		_aEdit.onclick=function(){
			$.ajax({
				type: "post"
				,url: "${mvcPath}/news/delete"
				,data: "_method=delete&newsid="+encodeURIComponent(this.record.newsid)
				,dataType : "json"
				,success: function(data){
	     			alert( data.status );
	     			if(data.status == "删除成功"){
	     				location.reload();
		     		}
	   			}
			});
		};
	}
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	
	return _obj;
}
window.oper=oper;

var key  = CryptoJS.enc.Utf8.parse('o7H8uIM2O5qv65l2');//Latin1 w8m31+Yy/Nw6thPsMpO5fg==
function encode(text){
   var srcs = CryptoJS.enc.Utf8.parse(text);  
   var encrypted = CryptoJS.AES.encrypt(srcs, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});  
   return encrypted.toString(); 
}

function query(){
	var sql = "select NEWSID, CHAR(NEWSDATE) NEWSDATE, NEWSTITLE, NEWSMSG, VALID_BEGIN_DATE,VALID_END_DATE,CASE WHEN STATUS='0' THEN '未发布' ELSE '已发布' END STATUS ,CASE WHEN ISSEND='1' THEN '是' ELSE '否' END ISSEND, ISSEND ISSEND_VALUE,CREATOR from FPF_USER_NEWS ORDER BY NEWSDATE DESC ";
	sql = encode(strEncode(sql));
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
	
	var _iTitle=$C("input");
	_iTitle.id="ipt_newtitle";
	_iTitle.type="text";
	_iTitle.value=elements.newstitle||"";
	
	var _iContent=$C("textarea");
	_iContent.id="ipt_content";
	_iContent.cols="80";
	_iContent.rows="10";
	_iContent.value=elements.newsmsg||"";

	var _iBegindate=$C("input");
	_iBegindate.id="ipt_begindate";
	_iBegindate.type="text";
	_iBegindate.value=elements.valid_begin_date||"";
	
	var _iEnddate=$C("input");
	_iEnddate.id="ipt_enddate";
	_iEnddate.type="text";
	_iEnddate.value=elements.valid_end_date||"";
	
	var _iIssend=$C("select");
	_iIssend.id="ipt_issend";
	_iIssend.value=elements.issend||"";
	_iIssend[0]=new Option("否","0");
	_iIssend[1]=new Option("是","1");
	
	_cont.appendChild($CT("标      题：  "));
	_cont.appendChild(_iTitle);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("内      容：  "));
	_cont.appendChild(_iContent);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("开始时间：    "));
	_cont.appendChild(_iBegindate);
	_cont.appendChild($CT("开始时间格式：yyyy-mm-dd，开始时间不填，即立即生效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("结束时间：    "));
	_cont.appendChild(_iEnddate);
	_cont.appendChild($CT("结束时间格式：yyyy-mm-dd，结束时间不填，即一直有效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("是否发送掌分："));
	_cont.appendChild(_iIssend);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.onclick=function(){
		if($("#ipt_newtitle").val().trim()==""){
			alert("标题不能为空");
			return;
		}	
		if($("#ipt_content").val().trim()==""){
			alert("内容不能为空");
			return;
		}	
		var begindate = $("#ipt_begindate").val();
		var enddate = $("#ipt_enddate").val();
		var content = $("#ipt_content").val();
		var issend = $("#ipt_issend").val();
		if(issend=='1' && content.length>70){
			alert("发送给掌分的新闻公告内容不能多于70个字");
			return;
		}
		if(begindate!=""){
			var partten = new RegExp("^[1-2]\\d{3}-(0?[1-9]||1[0-2])-(0?[1-9]||[1-2][1-9]||3[0-1])$"); 
			if(!partten.test(begindate)){
				alert("有效开始时间格式不正确");
				return;
			}
			
		} 
		if(enddate!=""){
			var partten = new RegExp("^[1-2]\\d{3}-(0?[1-9]||1[0-2])-(0?[1-9]||[1-2][1-9]||3[0-1])$"); 
			if(!partten.test(enddate)){
				alert("有效结束时间格式不正确");
				return;
			}
		} 
		$.ajax({
			type: "post"
			,url: "${mvcPath}/news/save"
			,data: "_method=put&title="+encodeURIComponent($("#ipt_newtitle").val())+"&content="+encodeURIComponent($("#ipt_content").val())+"&begindate="+encodeURIComponent($("#ipt_begindate").val())+"&enddate="+encodeURIComponent($("#ipt_enddate").val())+"&issend="+encodeURIComponent($("#ipt_issend").val())
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
	
	var _iTitle=$C("input");
	_iTitle.id="ipt_newtitle";
	_iTitle.type="text";
	_iTitle.value=elements.newstitle||"";
	
	var _iContent=$C("textarea");
	_iContent.id="ipt_content";
	_iContent.cols="80";
	_iContent.rows="10";
	_iContent.value=elements.newsmsg||"";

	var _iBegindate=$C("input");
	_iBegindate.id="ipt_begindate";
	_iBegindate.type="text";
	_iBegindate.value=elements.valid_begin_date||"";
	
	var _iEnddate=$C("input");
	_iEnddate.id="ipt_enddate";
	_iEnddate.type="text";
	_iEnddate.value=elements.valid_end_date||"";
	
	var _iIssend=$C("select");
	_iIssend.id="ipt_issend";
	_iIssend.value=elements.issend_value||"";
	if(elements.issend_value=='0'){
		_iIssend[0]=new Option("否","0");
		_iIssend[1]=new Option("是","1");
	}else{
		_iIssend[0]=new Option("是","1");
		_iIssend[1]=new Option("否","0");
	}
	
	_cont.appendChild($CT("标      题：  "));
	_cont.appendChild(_iTitle);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("内      容：  "));
	_cont.appendChild(_iContent);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("开始时间：    "));
	_cont.appendChild(_iBegindate);
	_cont.appendChild($CT("开始时间格式：yyyy-mm-dd，开始时间不填，即立即生效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("结束时间：    "));
	_cont.appendChild(_iEnddate);
	_cont.appendChild($CT("结束时间格式：yyyy-mm-dd，结束时间不填，即一直有效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("是否发送掌分："));
	_cont.appendChild(_iIssend);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	var newsid=elements.newsid;
	iBtn.onclick=function(){
		if($("#ipt_newtitle").val().trim()==""){
			alert("标题不能为空");
			return;
		}	
		if($("#ipt_content").val().trim()==""){
			alert("内容不能为空");
			return;
		}	
		var begindate = $("#ipt_begindate").val();
		var enddate = $("#ipt_enddate").val();
		var content = $("#ipt_content").val();
		var issend = $("#ipt_issend").val();
		if(issend=='1' && content.length>70){
			alert("发送给掌分的新闻公告内容不能多于70个字");
			return;
		}
		if(begindate!=""){
			var partten = new RegExp("^[1-2]\\d{3}-(0?[1-9]||1[0-2])-(0?[1-9]||[1-2][1-9]||3[0-1])$"); 
			if(!partten.test(begindate)){
				alert("有效开始时间格式不正确");
				return;
			}
			
		} 
		if(enddate!=""){
			var partten = new RegExp("^[1-2]\\d{3}-(0?[1-9]||1[0-2])-(0?[1-9]||[1-2][1-9]||3[0-1])$"); 
			if(!partten.test(enddate)){
				alert("有效结束时间格式不正确");
				return;
			}
		} 
		$.ajax({
			type: "post"
			,url: "${mvcPath}/news/update"
			,data: "_method=put&newsid="+newsid+"&title="+encodeURIComponent($("#ipt_newtitle").val())+"&content="+encodeURIComponent($("#ipt_content").val())+"&begindate="+encodeURIComponent($("#ipt_begindate").val())+"&enddate="+encodeURIComponent($("#ipt_enddate").val())+"&issend="+encodeURIComponent($("#ipt_issend").val())
			,dataType : "json"
			,success: function(data){
     			alert( data.status );
     			if(data.status == "修改成功"){
     				location.reload();
	     		}
   			}
		});
	}
	_cont.appendChild(iBtn);
	_cont.appendChild($C("BR"));
	
	_mask.show();
}

</script>
  </head>
  <body>
  	<div style="text-align: right;padding: 3px 0px 5px 6px;">
  	<input type="button" class="form_button_short" value="新增" onClick="add()"></div>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
