<html> 
<head> 
    <title>日志审计</title> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
    <script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
	<style type="text/css">
        #fm
        {
            margin: 0;
            padding: 10px 30px;
        }
        .ftitle
        {
            font-size: 14px;
            font-weight: bold;
            padding: 5px 0;
            margin-bottom: 10px;
            border-bottom: 1px solid #ccc;
        }
        .fitem
        {
            margin-bottom: 5px;
        }
        .fitem label
        {
            display: inline-block;
            width: 80px;
        }
        .mask{
        	background:#252222;
        	position:fixed;
			top: 0;
			right:0;
			bottom:0;
			left: 0;
			filter:alpha(opacity=80);
			opacity: 0.5;
        	display: none; 
        	-moz-opacity: 0.5;
        	z-index: 2;
        }
	</style>
	
	<script type="text/javascript">

		window.onload = function() {
			onlosd();
			var userid = '${Session["user"].id}';
			console.log(userid);
			if(userid != "admin" && userid != "hujuan7" && userid != "zhaojing"){
				$("#gedit").hide();
				$("#gdel").hide();
				$("#gadd").hide();
			}
		}
		
		$(function(){
			$(".panel-tool-close").click(function(){
				$(".mask").hide();
			})
		});

		function onlosd() {
			$("#notice_datagrid").datagrid({
				url : "${mvcPath}/NoticeCenter/noticeIndex",
				fit : true,
				fitColumns : true,
				striped : true,
				pagination : true,
				idField : 'newsid',
				pageSize : 20,
				pageList : [ 10, 20, 30, 50 ],
				sortName : 'newsdate',
				sortOrder : 'desc',
				nowrap : false,
				singleSelect : false,
				checkOnSelect : true,
				selectOnCheck : true,
				columns : [ [ {
					field : 'newsid',
					width : 150,
					hidden : 'ture'
				}, {
					field : 'ck',
					checkbox : true
				}, {
					field : 'newstitle',
					title : '公告标题',
					width : 50
				}, {
					field : 'newsmsg',
					title : '公告信息',
					width : 180
				}, {
					field : 'newsdate',
					title : '公告时间',
					width : 25,
					sortable : true,
					formatter : function(value, row, index) {
						return value.substring(0, 10);
					}
				}, {
					field : 'creator',
					title : '创建人',
					width : 20
				}, ] ],
			});
		}

		function queryNotice() {
			$('#notice_datagrid').datagrid('load', {
				newstitle : $("#newstitle").val(),
				startDate : $("input[name='startDate']").val(),
				endDate : $("input[name='endDate']").val()
			});
		}

		function resetQuery() {
			$('#notice_searchForm').form('clear');
			$('#notice_datagrid').datagrid('load', {});
		}
		
	</script>
<script type="text/javascript">
	var url;
	var type;
	function change() {
		$(".mask").show();
		var row = $("#notice_datagrid").datagrid("getChecked");
		var rows = row[0];
			if(row.length > 1){
				$.messager.alert("提示信息", "请选择单行进行修改");
				$(".mask").hide();
			}else if (row.length == 1) {
					$("#dlg").dialog("open").dialog('setTitle', '修改公告信息');
					$("#ntitle").val(rows.newstitle);
					$("#nmsg").val(rows.newsmsg);
					$("#ndate").datebox('setValue',rows.newsdate.substring(0, 10));
					$("#ncreator").val(rows.creator);
					$("#newsid").val(rows.newsid);
				} else {
					$.messager.alert("提示信息", "请选择要修改的公告信息");
					$(".mask").hide();
				}
		}
	function saveuser() {
		$("#fm").form("submit", {
			type: 'post', // 提交方式 get/post
			url : '${mvcPath}/NoticeCenter/EditNotice',
			dataType:'json',
			async:false,
			data: $('#fm').serialize(),
			success : function(data) {
				if (data) {
					$.messager.alert("提示信息", "修改成功");
					$("#dlg").dialog("close");
					$("#notice_datagrid").datagrid("load");
					$(".mask").hide();
				} else {
					$.messager.alert("提示信息", "修改失败");
				}
			}
		});
	}
	
	
	function del() {
		var row = $('#notice_datagrid').datagrid('getChecked');
		console.log(row);
			if (row.length > 0) {
				$.messager.confirm('Confirm',
						'你确定要删除吗?', function(r) {
							if (r) {
								for(var i = 0;i < row.length;i++){
									var rows = row[i];
									var ros = rows.newsid;
									delajax(ros);
								}
							}
						});
			}else{
				$.messager.alert("提示信息", "请选择要删除的公告信息！");
			}
	}
	
	function delajax(ros){
		$.post('${mvcPath}/NoticeCenter/delNotice', {
			newsid : ros
		}, function(result) {
			if (result == 1) {
				$('#notice_datagrid').datagrid('load'); // reload the user data 
			} else {
				$.messager.show({ // show error message 
					title : 'Error',
					msg : result.errorMsg
				});
			}
		}, 'json');
	}
</script>
<script type="text/javascript">
aihb.Util.addEventListener(document, "keypress", function(e) {
	if (e.keyCode == 13) {
		onlosd();
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
	_cont.appendChild($CT("   开始时间格式：yyyy-mm-dd，开始时间不填，即立即生效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("结束时间：    "));
	_cont.appendChild(_iEnddate);
	_cont.appendChild($CT("   结束时间格式：yyyy-mm-dd，结束时间不填，即一直有效"));
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("是否发送掌分："));
	_cont.appendChild(_iIssend);
	_cont.appendChild($C("BR"));
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
	<div id="notice_layout" class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',title:'查询条件',border:false" style="height: 50px;">
			<form id="notice_searchForm">
				&nbsp;&nbsp;&nbsp;检索公告:<input id="newstitle" type="text" name="newstitle"/>
			 	公告日期:<input id="startDate" type="text" name="startDate" class="easyui-datebox" editable="false" /> --至--
			 	<input id="endDate" type="text" name="endDate" class="easyui-datebox" editable="false"/>
			 	<a href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="queryNotice();">查询</a>
			 	<a id="gedit" class="easyui-linkbutton" iconcls="icon-edit" onclick="change()" plain="true">修改</a>
			 	<a id="gdel" class="easyui-linkbutton" iconcls="icon-remove" plain="true" onclick="del()">删除</a>
			 	
			  	<input id="gadd" style="height: 22px;float: right;margin-right: 22px;margin-top: 1px;" type="button" class="form_button_short" value="新增" onClick="add()">
			  	<span id="grid" style="display:none;"></span>
			</form>
		</div>
		<div data-options="region:'center',border:false"style="padding-right:20px;">
			<table id="notice_datagrid" style="padding-right:20px;"></table>
		</div>
	</div>
	<div class="mask"></div>
	<div>
		<div id="dlg" class="easyui-dialog" style="width: 400px; height: 280px; padding: 10px 20px;" closed="true" buttons="#dlg-buttons">
			<div class="ftitle">信息编辑</div>
			<form id="fm" method="post">
				<div class="fitem">
					<label> 公告标题 </label> <input id="ntitle" name="newstitle" class="easyui-validatebox" required="true" />
				</div>
				<div class="fitem">
					<label> 公告信息</label> <input id="nmsg" name="newsmsg" class="easyui-validatebox" required="true" />
				</div>
				<div class="fitem">
					<label> 公告时间</label> <input id="ndate" name="newsdate" class="easyui-datebox" required="true" />
				</div>
				<div class="fitem">
					<label> 创建人</label> <input id="ncreator" name="creator" class="easyui-vlidatebox" />
				</div>
				<input type="hidden" name="newsid" id="newsid" />
			</form>
		</div>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveuser()" iconcls="icon-save">保存</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dlg').dialog('close');$('.mask').hide();" iconcls="icon-cancel">取消</a>
		</div>
	</div>
</body>
</html>