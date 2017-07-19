//日期格式化
function formatter(value, row, index) {
	if (value != null) {
		return new Date(parseInt(value)).toLocaleString().replace(/年|月/g, "-")
				.replace(/日/g, " ");
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
	for (var i = 0; i < rows.length; i++) {
		fileids += (rows[i].file_id + ',');
	}
	fileids = fileids.substring(0, fileids.length - 1);
	if (fileids.length > 0) {
		$.messager.confirm('确认删除?', '确认删除所选文件么?', function(r) {
			if (r) {
				$.post('fileDel', {
					fileids : fileids
				}, function(result) {
					if (result == true) {
						$.messager.alert('操作结果', '删除成功');
						$('#dataTable').datagrid('load'); // reload the user data 
					} else {
						$.messager.show({ // show error message 
							title : 'Error',
							msg : '删除失败!'
						});
					}
				}, 'json');
			}
		});
	}

}
(function($) {
	$(document)
			.ready(
					function() {
						Ext.QuickTips.init();
						// 文件上传
						$('#objFilePath')
								.click(
										function() {
											document
													.getElementById("newFileName").value = ""; // 将hidden值置空
											dialog = new Ext.ux.UploadDialog.Dialog(
													{
														title : '文件上传',
														url : '/hb-ftp/uploadfile/upload',
														post_var_name : 'uploadFiles', // 这里是自己定义的，默认的名字叫file
														width : 450,
														height : 300,
														minWidth : 450,
														minHeight : 300,
														draggable : true,
														resizable : true,
														// autoCreate: true,
														constraintoviewport : true,
														permitted_extensions : [
																'doc', 'docx',
																'xls', 'xlsx',
																'ppt', 'ppts',
																'txt', 'png',
																'bmp', 'jpg',
																'jpeg', 'gif' ], // 只能上传文本文件
														modal : true,
														reset_on_hide : false,
														allow_close_on_upload : false, // 关闭上传窗口是否仍然上传文件
														upload_autostart : false
													});
											dialog.show();
											dialog.on('uploadsuccess',
													onUploadSuccess); // 定义上传成功回调函数
											dialog.on('uploadfailed',
													onUploadFailed); // 定义上传失败回调函数
											dialog.on('uploaderror',
													onUploadFailed); // 定义上传出错回调函数
											dialog.on('uploadcomplete',
													onUploadComplete); // 定义上传完成回调函数
										});

						// 文件上传成功后的回调函数
						onUploadSuccess = function(dialog, filename, data,
								record) {
							document.getElementById("objFilePath").value = filename;
							document.getElementById("upload_image").style.display = "";
							document.getElementById("saveBtn").disabled = false;
							document.getElementById("newFileName").value = data.newFileName; // 上传的文件在服务器上的名称
						};
						// 文件上传失败后的回调函数
						onUploadFailed = function(dialog, filename, resp_data,
								record) {
							// alert("Fail:"+resp_data);
						};
						// 文件上传完成后的回调函数
						onUploadComplete = function(dialog) {
							// alert("Complete:"+'所有文件上传完成');
							// dialog.hide();
						};
						$("#saveBtn").click(function() {
							saveIssue("${mvcPath}/uploadfile/addSave");
						});
						$(".content_panel").css("width",
								(document.body.clientWidth - 183) + "px");
						$("#commentBtn").prependTo($(".content_panel"));

					});
	function htmlEncode0(str) {
		var s = "";
		if (str.length == 0)
			return "";
		s = str.replace(/&/g, "&amp;");
		s = s.replace(/</g, "&lt;");
		s = s.replace(/>/g, "&gt;");
		s = s.replace(/ /g, "&nbsp;");
		s = s.replace(/\'/g, "&#39;");
		s = s.replace(/\"/g, "&quot;");
		s = s.replace(/\n/g, "<br>");
		return s;
	}

	function saveIssue(url, data) {
		var fileName = $("#newFileName").val().trim();

		fileName = encodeURIComponent(htmlEncode0(fileName));

	}

})(jQuery)
function getChecked() {
	var rows = $("#dataTable").datagrid("getChecked");
	return rows;
}
function doSearch() {
	$('#dataTable').datagrid('load', {
		filename : $('#filename').val(),
		reqid : $('#reqid').val()
	});
}
function strToDate(str) {
	var date = new Date(str);
	var Y = date.getFullYear() + '-';
	var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date
			.getMonth() + 1)
			+ '-';
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
				console.log(data);
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
				for (var a = 0; a < loglist.length; a++) {
					loglist[a].oper_time = strToDate(loglist[a].oper_time);
				}
				console.log(loglist);
				var logHtml = "";
				for (var i = 0; i < loglist.length; i++) {
					logHtml += "<tr><td style='width: 145px;'><span>"
							+ loglist[i].oper_time
							+ "</span></td><td style='width: 145px;'><span>"
							+ loglist[i].user_id
							+ "</span></td><td style='width: 145px;'><span>"
							+ loglist[i].oper_type + "</span></td></tr>";
				}
				$("#logTab").html(logHtml);
			},
			error : function(result) {
			}
		});
	}
}
$('#btn')
		.bind(
				'click',
				function() {
					var row = $('#dataTable').datagrid('getSelected');
					$
							.ajax({
								url : "/hb-ftp/toExamine",
								async : false,
								data : {
									file_id : row.file_id
								},
								type : "get",
								success : function(msg) {
									if (msg == 1) {
										$.parser.parse();
										$(function() {
											$.messager.alert("操作信息",
													"该信息已经审核通过", "info");
										});
									} else {
										var targetObj = $(msg).appendTo("#dd");
										$("#dd")
												.dialog(
														{
															left : "650px",
															top : "100px",
															title : '审核',
															inline : false,
															width : "400px",
															height : "550px",
															cache : false,
															buttons : [
																	{
																		text : '保存',
																		handler : function() {
																			$(
																					'#loginForm')
																					.ajaxSubmit(
																							{
																								url : '/hb-ftp/from',
																								success : function(
																										data) {
																									if (data) {
																										$(function() {
																											$.messager
																													.alert(
																															"信息",
																															"修改成功",
																															"info");
																											$(
																													'#dataTable')
																													.datagrid(
																															'load',
																															{});
																										});
																									}
																									$(
																											'#diaEdit')
																											.dialog(
																													'close')
																								}
																							});
																		}
																	},
																	{
																		text : '关闭',
																		handler : function() {
																			$(
																					'#dd')
																					.dialog(
																							'close');
																		}
																	} ],
															onClose : function() {
																$('#dataTable')
																		.datagrid(
																				'load',
																				{});
															}
														});
									}
								}
							});
				})
function downFile() {
	//var user="${user}";
	//console.log(user);
	var filelist = $('#dataTable').datagrid('getChecked');
	if (filelist.length > 1) {
		alert("请选择单个文件下载!");
		return false;
	} else if (filelist.length == 0 || filelist.length < 1) {
		alert("请选择要下载文件!");
		return false;
	} else {
		var fileId = filelist[0].file_id;
		var url = "/hb-ftp/download?fileName=11.txt&fileId=" + fileId;
		window.location.href = url;
		//   if(filelist.creator=="${user.name}"){
		//       window.location.href="/hb-ftp/download?fileName=11.txt&amp;fileId="+fileId;
		//    }else{
		//    alert("您没有权限下载此文件!");
		//    return false;
		//    }
	}
}