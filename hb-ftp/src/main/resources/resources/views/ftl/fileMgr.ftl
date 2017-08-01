<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>文件管理</title>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/css/Ext.ux.UploadDialog.css" />
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/zclip/jquery.zclip.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery.form.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/Ext.ux.UploadDialog.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/locale/ru.utf-8_zh.js"></script>
<script type="text/javascript">
var userName = "";
var userId = "";
$(function(){
	Ext.QuickTips.init();
	// 文件上传
	$('#objFilePath').click(function() {
		document.getElementById("newFileName").value = ""; // 将hidden值置空
		dialog = new Ext.ux.UploadDialog.Dialog({
			title : '文件上传',
			url : '${mvcPath}/uploadfile/upload',
			post_var_name : 'uploadFiles', // 这里是自己定义的，默认的名字叫file
			width : 450,
			height : 300,
			minWidth : 450,
			minHeight : 300,
			draggable : true,
			resizable : true,
			// autoCreate: true,
			constraintoviewport : true,
			permitted_extensions : [ 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'ppts', 'txt', 'png', 'bmp', 'jpg', 'jpeg', 'gif' ], // 只能上传文本文件
			modal : true,
			reset_on_hide : false,
			allow_close_on_upload : false, // 关闭上传窗口是否仍然上传文件
			upload_autostart : false
		});
		dialog.show();
		dialog.on('uploadsuccess', onUploadSuccess); // 定义上传成功回调函数
		dialog.on('uploadfailed', onUploadFailed); // 定义上传失败回调函数
		dialog.on('uploaderror', onUploadFailed); // 定义上传出错回调函数
		dialog.on('uploadcomplete', onUploadComplete); // 定义上传完成回调函数
	});

	// 文件上传成功后的回调函数
	onUploadSuccess = function(dialog, filename, data, record) {
		document.getElementById("objFilePath").value = filename;
		document.getElementById("upload_image").style.display = "";
		document.getElementById("newFileName").value = data.newFileName; // 上传的文件在服务器上的名称
		$("#addFileName").val(data.newFileName);
	};
	// 文件上传失败后的回调函数
	onUploadFailed = function(dialog, filename, resp_data, record) {
		// alert("Fail:"+resp_data);
	};
	// 文件上传完成后的回调函数
	onUploadComplete = function(dialog) {
		// alert("Complete:"+'所有文件上传完成');
		// dialog.hide();
	};
			
	$.ajax({
		type : "POST",
		url : 'getCurrentUser',
		data : {},
		dataType : 'json',
		success : function(data) {
			userName = data.user.name;
			userId = data.user.id;
		}
	});
	
	$('#auditBtn').bind('click', function() {
		var filelist = $('#dataTable').datagrid('getChecked');
		if (filelist.length > 1) {
			$.messager.alert("信息", "只能选择一行", "info");
			return false;
		}
		
		if (filelist.length == 0 || filelist.length < 1) {
			$.messager.alert("信息", "不能一行也不选", "info");
			return false;
		}
		
		var approver = filelist[0].approver_id;
		if(approver != userId){
			$.messager.alert("信息", "您没有权限审核此文件", "info");
			return false;
		}
		
		var fileId = filelist[0].file_id;
		$.ajax({
			url : "toExamine",
			async : false,
			data : {
				file_id : fileId
			},
			type : "get",
			success : function(msg) {
				if (msg == 1) {
					$.parser.parse();
					$.messager.alert("操作信息", "该信息已经审核通过", "info");
				} else {
					$("#audit").html(msg);
					$("#audit").dialog({
						title : '审核',
						modal: true,
						cache : false,
						buttons : [ {
							text : '保存',
							handler : function() {
								$('#auditForm').ajaxSubmit({
									url : '${mvcPath}/fileAudit',
									success : function(data) {
										if (data) {
											$(function() {
												$.messager.alert("信息", "修改成功", "info");
												$('#dataTable').datagrid('load', {});
											});
										}
										$('#audit').dialog('close')
									}
								});
							}
						}, {
							text : '关闭',
							handler : function() {
								$('#audit').dialog('close');
							}
						} ],
						onClose : function() {
							$('#dataTable').datagrid('load', {});
						}
					});
				}
			}
		});
	});
});
//日期格式化
function formatter(value, row, index) {
	if (value != null) {
		return new Date(parseInt(value)).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
	} else {
		return "";
	}
}
function delFileInfo() {
	var rows = getChecked();
	var fileids = '';
	if (rows.length == 0) {
		$.messager.alert('提示信息', '请勾选要删除的文件信息');
		return;
	}
	
	for ( var i = 0; i < rows.length; i++) {
		if(rows[i].creator_id != userId && rows[i].approver_id != userId){
			alert("您没有权限删除文件：" + rows[i].file_id);
			return ;
		}
		fileids += (rows[i].file_id + ',');
	}
	fileids = fileids.substring(0, fileids.length - 1);
	if (fileids.length > 0) {
		$.messager.confirm('确认删除?', '确认删除所选文件么?', function(r) {
			if (r) {
				$.post('fileDel', {
					fileids : fileids
				}, function(result) {
					$.messager.alert('操作结果', '删除成功');
					$('#dataTable').datagrid('load'); // reload the user data 
				}, 'json');
			}
		});
	}
}

function addFile(){
	$("#addReqId").val("");
	$("#addApprover").val("zhaojing");
	$("#addApproverName").val("赵静");
	$("#addFileCode").val("");
	$("#addFileName").val("");
	$("#objFilePath").val("");
	$("#upload_image")
	document.getElementById("upload_image").style.display = "none";
	$("#addFileDesc").val("");
	$('#dlg').dialog('open');
}
	
function checkAddInfo(){
	var addReqId = $("#addReqId").val().trim();
	var addApprover = $("#addApproverName").val().trim();
	var addFileName = $("#addFileName").val().trim();
	if(addReqId.length == 0){
		alert("需求编号不能为空");
		return false;
	}
	if(addApprover.length == 0){
		alert("审核人不能为空");
		return false;
	}
	if(addFileName.length == 0){
		alert("文件名称不能为空");
		return false;
	}
	return true;
}
		
function getChecked() {
	var rows = $("#dataTable").datagrid("getChecked");
	return rows;
}
function doSearch() {
	$('#dataTable').datagrid('load', {
		filename : $('#filename').val(),
		reqid : $('#reqid').val(),
		creator:$('#creator').val(),
		status:$('#status').val()
	});
}
function strToDate(str) {
	var date = new Date(str);
	var Y = date.getFullYear() + '-';
	var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
	var D = date.getDate() + ' ';
	var h = date.getHours() + ':';
	var m = date.getMinutes() + ':';
	var s = date.getSeconds();
	var time = Y + M + D + h + m + s;
	return time;
}

function queryDetail() {
	var filelist = $('#dataTable').datagrid('getChecked');
	if (filelist.length > 1) {
		alert("请选择单个文件!");
		return false;
	} else if (filelist.length == 0) {
		alert("请选择要查看的文件!");
		return false;
	} else {
		$('#w').window('open');
		var fileId = filelist[0].file_id;
		$.ajax({
			type : "POST",
			url : 'detail',
			data : {
				fileId : fileId
			},
			dataType : 'json',
			success : function(data) {
				var detail = data.detail;
				detail.create_time = strToDate(detail.create_time);
				$('#ff').form('load', {
					fileName : detail.file_name,
					createTime : detail.create_time,
					creator : detail.creator,
					approve : detail.approver,
					status : detail.status,
					url : detail.file_path
				});
				var loglist = data.logList;
				for ( var a = 0; a < loglist.length; a++) {
					loglist[a].oper_time = strToDate(loglist[a].oper_time);
				}
				var logHtml = "";
				for ( var i = 0; i < loglist.length; i++) {
					logHtml += "<tr><td style='width: 145px;'><span>" + loglist[i].oper_time + "</span></td><td style='width: 145px;'><span>" + loglist[i].user_name + "</span></td><td style='width: 145px;'><span>" + loglist[i].oper_type + "</span></td></tr>";
				}
				$("#logTab").html(logHtml);
			},
			error : function(result) {
			}
		});
	}
}


function downFile(parameter, callbake) {
	var filelist = $('#dataTable').datagrid('getChecked');
	if (filelist.length > 1) {
		alert("请选择单个文件下载!");
		return false;
	}
	if (filelist.length == 0 || filelist.length < 1) {
		alert("请选择要下载文件!");
		return false;
	}
	
	var status = filelist[0].status;
	if(status != '审核通过'){
		alert("此文件未审核通过，不能下载");
		return;
	}
	
	var fileId = filelist[0].file_id;
	var fileName = filelist[0].file_name;
	$.ajax({
		type : "POST",
		url : 'detail',
		data : {
			fileId : fileId
		},
		dataType : 'json',
		success : function(data) {

			if (filelist[0].creator_id == userId) {
				var url = "${mvcPath}/download?fileName=" + fileName + "&fileId=" + fileId;
				var download = data.urlBegin + "/download?fileName=" + fileName + "&fileId=" + fileId;
				if (parameter) {
					callbake(download);
				} else {
					window.location.href = url;
				}
			} else {
				alert("您没有权限下载此文件!");
				return false;
			}
		},
		error : function(result) {
		}
	});

}

var firstTime = true;
function downaddr() {
	downFile(true, function(download) {
		$("#outDownUrl").html(download);
		$('#info').dialog('open');
		if(firstTime){
			copyUrl();
			firstTime = false;
		}
	})
}

function copyUrl(){
	//IE使用zclip复制，没有取实时内容，改为使用setData方法
	if(window.clipboardData != null){
		if(!firstTime){
			window.clipboardData.setData("Text", $("#outDownUrl").html());
			alert('复制成功');
			$('#info').dialog('close');
			return;
		}
	}else{
		$("#copy").zclip({
			path: "${mvcPath}/resources/jslib/zclip/ZeroClipboard.swf",
			copy: function(){
				return $("#outDownUrl").html();
			},
			afterCopy:function(){
				alert('复制成功');
				$('#info').dialog('close');
	        }
		});
	}
}

function getAuditor(){
	var reqCode = $("#addReqId").val().trim();
	if(reqCode.length == 0){
		$("#addApprover").val("zhaojing");
		$("#addApproverName").val("赵静");
		return;
	}
	$.ajax({
		type : "POST",
		url : 'getAuditor',
		data : {
			reqCode : reqCode
		},
		dataType : 'json',
		success : function(data) {
			if(data!= null && data.req_charge != null){
				$("#addApprover").val(data.req_charge_id);
				$("#addApproverName").val(data.req_charge);
			}else{
				$("#addApprover").val("zhaojing");
				$("#addApproverName").val("赵静");
			}
		}
	});
}
	
</script>
</head>
<body>
<div style="margin: 2px 0;"></div>
<table id="dataTable" class="easyui-datagrid" title="文件信息列表"
	style="width: auto; height: auto"
	data-options="fit:true,fitColumns : true,striped:true,pagination : true,idField : 'fileid',pageSize : 10,pageList : [ 10, 20, 30, 50 ],
				sortName : 'create_time',rownumbers:true,singleSelect:false,checkOnSelect : false,
				selectOnCheck : true,url:'fileSearch',toolbar:'#search'">
	<thead>
		<tr>
			<th data-options="field:'ck',checkbox:true" id='ck'></th>
			<th data-options="field:'file_id',width:100">文件id</th>
			<th data-options="field:'req_id',width:100">需求编号</th>
			<th data-options="field:'file_name',width:120">文件名称</th>
			<th data-options="field:'creator_id',width:80,hidden:'true'">上传人</th>
			<th data-options="field:'creator',width:80">上传人</th>
			<th data-options="field:'create_time',formatter:formatter,width:120">上传时间</th>
			<th data-options="field:'approver_id',width:60, hidden:'true'">审批人</th>
			<th data-options="field:'approver',width:60">审批人</th>
			<th data-options="field:'status',width:60">状态</th>
		</tr>
	</thead>
</table>
<div id="search" style="padding: 5px; height: auto">
	<div style="margin-bottom: 5px">
		<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addFile()">新增</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delFileInfo()">删除</a> 
		<a href="#" class="easyui-linkbutton" iconCls="icon-tip" plain="true" onclick="queryDetail()" >详情</a> 
		<a href="#" class="easyui-linkbutton" iconCls="icon-back" plain="true" id="auditBtn">文件审核</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-down_load" plain="true" onclick="downFile()">本地下载</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-download" plain="true" onclick="downaddr()">外部下载</a>
	</div>
	<div>
		文件名称: <input class="easyui-text" style="width: 120px; height:20px; line-height:20px;" id="filename">
		需求编号： <input class="easyui-text" style="width: 120px; height:20px; line-height:20px;" id="reqid">
		<!-- 上传人，状态 -->
		上传人：<input class="easyui-text" style="width: 120px; height:20px; line-height:20px;" id="creator">
		状态：<select id="status" style="width: 120px; height:20px; line-height:20px;">
				<option value="">---请选择---</option>
				<option value="待审核">待审核</option>
				<option value="审核通过">审核通过</option>
				<option value="审核不通过">审核不通过</option>
		   </select>
		<a href="#" class="easyui-linkbutton" iconCls="icon-search"
			onclick="doSearch()">查询</a>
	</div>
</div>

<div id="info" class="easyui-dialog" title="下载地址" style="width:450px; height:150px;"
		data-options="
			modal:true,
			closed:true,
			buttons: [{
					text:'复制地址',
					id: 'copy',
					handler:function(){
						copyUrl();
					}
				},{
					text:'取消',
					handler:function(){
						$('#info').dialog('close');
					}
				}]">
	<div id="outDownUrl" style="margin: 8px;"></div>
</div>

<div id="audit" style='padding: 10px 20px;'></div>
<!--审核弹框-->
<div id="dlg" class="easyui-dialog" title="上传文件"
	style="width: 400px; height: auto; padding: 10px;"
	data-options="
				closed:true,
				modal:true,
				iconCls: 'icon-add',
				buttons: [{
					text:'提交',
					iconCls:'icon-ok',
					handler:function(){
						$('#addfileform').form('submit', {
							url:'fileAdd',
							onSubmit: function(param){					
								console.log(param);
								return checkAddInfo();
							},
							success:function(data){
								alert('提交成功');
								$('#dlg').dialog('close');
								doSearch();
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
	<form id="addfileform" method="post">
		<table cellpadding="5">
			<tr>
				<td>需求编号:</td>
				<td><input class="easyui-textbox" type="text" onblur="getAuditor()" name="reqid" id="addReqId" style="width:200px;"
					data-options="required:true"></input></td>
			</tr>
			<tr>
				<td>审核人:</td>
				<td>
					<input type="hidden" name="approver" id="addApprover" value="zhaojing" ></input>
					<input class="easyui-textbox" type="text" name="approverName" id="addApproverName" style="width: 200px;"
						data-options="required:true" value="赵静" readonly="readonly"></input>
				</td>
			</tr>
			<tr>
				<td>文件编号:</td>
				<td><input class="easyui-textbox" type="text" name="filecode" id="addFileCode" style="width: 200px;"></input></td>
			</tr>
			<tr>
				<td>文件名称:</td>
				<td><input class="easyui-textbox" type="text" name="filename" id="addFileName" style="width: 200px;"
					data-options="required:true" readonly="readonly" placeholder="文件上传后自动带出内容"></input></td>
			</tr>
			<tr>
				<td>文件上传:</td>
				<td><input type="text" name="filepath" id="objFilePath"
					size="20" value="" readonly="readonly" data-options="required:true" style="color: gray; width: 200px;" /> <input
					type="hidden" id="newFileName" /> <img id="upload_image"
					src="${mvcPath}/resources/js/ext/resources/images/default/dd/drop-yes.gif"
					style="display: none" alt="" /></td>
			</tr>
			<tr>
				<td>文件描述:</td>
				<td><textarea name="filedesc" id="addFileDesc" style="height: 60px; width: 198px;"></textarea></td>
			</tr>
		</table>
	</form>
</div>
<!-- 弹框开始-->
<div id="w" class="easyui-window" iconCls="icon-fileDetail" title="文件详情"
	style="width: 390%; height: 500px;" data-options="modal:true"
	closed="true">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'south',split:true"
			style="left: 430px; width: 430px; height: 230px;" title="日志信息">
			<form id="logInfo" method="get">
				<table style="margin: 10px;">
					<th>
					<tr>
						<td style="width: 145px;"><span>操作时间</span></td>
						<td style="width: 145px;"><span>操作人员</span></td>
						<td style="width: 145px;"><span>操作类型</span></td>
					</tr>
					</th>
					<tbody id="logTab"></tbody>
				</table>
			</form>
		</div>
		<div data-options="region:'center'"
			style="padding: 10px; width: 430px" title="基本信息">
			<form id="ff" method="get">


				<table cellpadding="6">
					<tr>
						<td style="text-align: right; width: 100px;">文件名称:</td>
						<td><input id="fileName" type="text" name="fileName"
							style="width:100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>
					</tr>
					<tr>&nbsp</tr>
					<tr>&nbsp</tr>
					<tr>
						<td style="text-align: right;">创建时间:</td>
						<td><input id="createTime" type="text" name="createTime"
							style="width: 100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>
					</tr>
					<tr>&nbsp</tr>
					<tr>&nbsp</tr>
					<tr>
						<td style="text-align: right;">上传人:</td>
						<td><input id="creator" type="text" name="creator"
							style="width: 100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>

						</td>
					</tr>
					<tr>&nbsp</tr>
					<tr>&nbsp</tr>
					<tr>
						<td style="text-align: right;">审核人:</td>
						<td><input id="approve" type="text" name="approve"
							style="width: 100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>
					</tr>
					<tr>&nbsp</tr>
					<tr>&nbsp</tr>
					<tr>
						<td style="text-align: right;">文件状态:</td>
						<td><input id="status" type="text" name="status"
							style="width: 100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>
					</tr>
					<tr>&nbsp</tr>
					<tr>&nbsp</tr>
					<tr>
						<td style="text-align: right;">文件地址:</td>
						<td><input id="url" type="text" name="url"
							style="width: 100%;" class="easyui-textbox"
							data-options="required:true" disabled="disabled" /></td>
					</tr>
			</form>
		</div>
	</div>
</div>
<!-- 弹框结束-->
</body>
</html>