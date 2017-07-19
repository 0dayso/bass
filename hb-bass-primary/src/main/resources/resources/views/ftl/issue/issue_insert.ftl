<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>发申告</title>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>

<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/Ext.ux.UploadDialog.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/locale/ru.utf-8_zh.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/css/Ext.ux.UploadDialog.css" />
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/bass_common.css" />
<style>
.banner_panel{width:100%;height:80px;background:#CEEEF4;position:relative;}
.menu_panel{height:100%;width:180px;background:#DDF3F7;}
.content_panel{height:100%;font-size:14px;position:absolute;left:180;top:60;border-top:1px solid;border-left:1px solid;border-color:#c1c1c1;background:#fff;}
</style>
<script>
(function($) {
    $(document).ready(function() {
        Ext.QuickTips.init();
        // 文件上传
        $('#objFilePath').click(function() {
            document.getElementById("newFileName").value = ""; // 将hidden值置空
            dialog = new Ext.ux.UploadDialog.Dialog({
                title: '文件上传',
                url: '${mvcPath}/issue/upload',
                post_var_name: 'uploadFiles', // 这里是自己定义的，默认的名字叫file
                width: 450,
                height: 300,
                minWidth: 450,
                minHeight: 300,
                draggable: true,
                resizable: true,
                // autoCreate: true,
                constraintoviewport: true,
                permitted_extensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'ppts', 'txt', 'png', 'bmp', 'jpg', 'jpeg', 'gif'], // 只能上传文本文件
                modal: true,
                reset_on_hide: false,
                allow_close_on_upload: false, // 关闭上传窗口是否仍然上传文件
                upload_autostart: false
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
            document.getElementById("saveBtn").disabled = false;
            document.getElementById("newFileName").value = data.newFileName; // 上传的文件在服务器上的名称
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
        $("#saveBtn").click(function() {
            saveIssue("${mvcPath}/issue/addSave")
        });
        $(".content_panel").css("width", (document.body.clientWidth - 183) + "px");
        $("#commentBtn").prependTo($(".content_panel"));

    });
    function htmlEncode0(str) {
        var s = "";
        if (str.length == 0) return "";
        s = str.replace(/&/g, "&amp;");
        s = s.replace(/</g, "&lt;");
        s = s.replace(/>/g, "&gt;");
        s = s.replace(/ /g, "&nbsp;");
        s = s.replace(/\'/g, "&#39;");
        s = s.replace(/\"/g, "&quot;");
        s = s.replace(/\n/g, "<br>");
        return s;
    }
    function htmlDecode(str) {
        var s = "";
        if (str.length == 0) return "";
        s = str.replace(/&amp;/g, "&");
        s = s.replace(/&lt;/g, "<");
        s = s.replace(/&gt;/g, ">");
        s = s.replace(/&nbsp;/g, " ");
        s = s.replace(/&#39;/g, "\'");
        s = s.replace(/&quot;/g, "\"");
        s = s.replace(/<br>/g, "\n");
        return s;
    }
    function saveIssue(url, data) {
    	var title = $("#issue_title").val().trim();
        var content = $("#content").val().trim();
        var telephone = $("#issue_telephone").val().trim();
        var fileName = $("#newFileName").val().trim();
        var endTime = $("#end_time").val().trim();
        var issueType = $("#issue_type").val().trim();
        
        if(issueType.length == 0){
    		alert('请选择申告类型');
    		return;
    	}
        
        if (title.length == 0) {
            alert("标题不能为空");
            return;
        }
        if (content.length == 0) {
            alert("内容不能为空");
            return;
        }
        
        if(endTime.length == 0){
        	alert("要求完成时间不能为空");
            return;
        }
        
        if (telephone.length == 0) {
            alert("联系方式不能为空");
            return;
        }
        
        if(telephone.length > 11){
        	alert("手机号不能超过11位");
        	return;
        }
        
        if (/[\x00-\x2F]|[\x3A-\x40]|[\x5B-\x60]|[\x7B-\xFF]/.test(title)) {
            alert("标题不能输入特殊字符");
            return;
        }
        if (/[\x00-\x2F]|[\x3A-\x40]|[\x5B-\x60]|[\x7B-\xFF]/.test(content)) {
            alert("内容不能输入特殊字符");
            return;
        }
        if (/[\x00-\x2F]|[\x3A-\x40]|[\x5B-\x60]|[\x7B-\xFF]/.test(telephone)) {
            alert("联系方式不能输入特殊字符");
            return;
        }

        title = encodeURIComponent(htmlDecode(title));
        content = encodeURIComponent(htmlEncode0(content));
        telephone = encodeURIComponent(htmlEncode0(telephone));
        fileName = encodeURIComponent(htmlEncode0(fileName));
        
        $.ajax({
            url: url,
            type: "get",
            dataType: "json",
            data:{
            	state: encodeURIComponent("申告"),
            	content: "#" + title + "# " + content,
            	telephone: telephone,
            	fileName: fileName,
            	issueType: issueType,
            	endTime: endTime
            },
            success: function(res) {
            	alert("保存成功");
                var url = "${mvcPath}/issue";
                location.href = url;
            }
        });
    }

})(jQuery)
</script>
</head>
<body>
<div class="banner_panel">

<div style="position:absolute;z-index:0;FILTER: alpha(opacity=60);opacity:0.6;left:90 px;top:0 px;background:url(${mvcPath}/resources/image/default/ask_pic.png);width:112px;height:133px;"></div>

<a href="${mvcPath}/issue" title="问题申告" style="text-decoration:none;cursor:pointer;"><div style="padding:5px;position:absolute;left:10 px;top:30 px;z-index:2;font-size:28px;font-family:黑体;color:#c1c1c1">问题申告</div></a>

<div style="position:absolute;z-index:2000;left:200px;top:0;">
	<form id="form1" action="${mvcPath}/issue" method="post">
	<input type="text" name="kw" id="kw" style="width:390px;line-height:24px;font-size:20px;margin:3;padding:3px;" maxlength="100">
	
	<a href="#" id="search" style="display:inline-block;background:#4B8CF7;border:1px solid #3079ED;width:75px;line-height:28px;height:28px;text-align:center;">
	 <b class="search-white" style="display:inline-block;background:no-repeat url(${mvcPath}/resources/image/default/hpimgs19.png) 0 2px;width:16px;height:16px;margin-top:3px;"></b>
	</a>
	</form>
</div>

</div>

<div class="menu_panel">

	<ul style="width:100%;">
		<li style="border-bottom:1px #ccc solid; padding: 5;">活跃用户</li>
		<#list actives as u>
			<li id="act_${u.id}" style="height: 83px;width:70px;float:left;padding: 5 0 0 6; text-align: center;font-size: 12px;">
				<div style="width:42px;height:39px;border:#bbb 1px solid;padding:2px;background-color: #fff;margin:0 auto;">
					<img src="${mvcPath}/resources/image/default/default_face.gif" width="39" height="36">
				</div>
				<a href="#">${u.name}</a>
			</li>
		</#list>
	</ul>
</div>

<div class="content_panel">
	<ul style="padding-left:5;">
		<div>
		标题：<input type="text" id="issue_title" value="" style="font-size:16px;line-height:22px;width:500px;margin:3;">
			<select id="issue_type" style="font-size:16px;line-height:22px;">
				<option value="">--请选择类型--</option>
				<#list typeList as type>
					<option value="${type.type}">${type.type}</option>
				</#list>
			</select>
		</div>
		<textarea id="content" cols=90 rows=15 style="font-size:14px;margin:5;"></textarea>
		<div style="margin-top: 5px; margin-left: 10px; margin-right: 10px;">
			要求完成时间：<input type="test" name="end_time" value="${defTime}" readonly id="end_time" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" />
		</div>
		<div style="margin-top: 5px; margin-left: 10px; margin-right: 10px;">
		联系方式：<input type="text" id="issue_telephone" value="" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="font-size:16px;line-height:15px;width:200px;margin:3;">请填写联系方式以便在回复后第一时间通知
		</div>
		<div style="margin-top: 5px; margin-left: 10px; margin-right: 10px;">
			上传文件：<input type="text" id="objFilePath" size="50" value="" readonly="readonly" style="color: gray;" />
			<input type="hidden" id="newFileName" />
			<img id="upload_image" src="${mvcPath}/resources/js/ext/resources/images/default/dd/drop-yes.gif" style="display: none" alt="" />
		</div>
		<div>
		<a href="javascript:void(0)" id="saveBtn" class="aBtn greenBtn"><b >提交</b></a>
		<a href="${mvcPath}/issue" id="commentBtn" class="aBtn greenBtn"><b>返回</b></a>
		
		</div>
	</ul>
</div>
</body>
</html>