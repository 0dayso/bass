<%@page import="com.asiainfo.hb.web.models.User"%>
<% User user = (User)session.getAttribute("user");%>
<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<title>三表合一流程审核</title>
<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-ext.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/makingthreeformsto.css"/>
<style type="text/css">
	.down{cursor:pointer; color:blue;text-decoration:underline;}
</style>
<script type="text/javascript">
var userId = '<%=user.getId()%>';
var month = new Date().format("yyyymm");
var sheet;
Ext.onReady(function(){
	$('#fileMonth').val(month);
	quertUpload();
});


function changeMonth(){
	WdatePicker({
		readOnly:true,
		dateFmt:'yyyyMM',
		onpicked:function(){
			month = $('#fileMonth').val();
			quertUpload();
		}
	});
}

//查询已上传文件
function quertUpload(){
	$('#loadMask').show();
	$.ajax({
		url:"${mvcPath}/threeForms/queryUpload"
		,dataType:"json"
		,data:"month=" + month
		,type:"post"
		,success:function(data){
			if(data.flag == '1'){
				uploadSuccess(data.name, data.status, data.suggestion, data.isdelete);
				showLog(data.logList);
			}else if(data.flag == '-1'){
				$('#loadMask').hide();
				alert("查询已上传附件出错！");
			}else if(data.flag == '0'){
				$('#uploadBtn').show();
				$("#logInfo").html("");
				$('#status').html('未上传');
				$('#fileLink').hide();
				$('#fileLink').html("");
				$('#deleteImg').hide();
				$('#suggestTr').hide();
				$('#confirmTr').hide();
				$('#showExcPanel').hide();
				$('#excelTab').html("");
				$('#excelCont').html("");
				$('#noData').show();
				$('#loadMask').hide();
			}
		}
  });
}

function showLog(logList){
	var info = "";
	for(var i=0; i<logList.length; i++){
		info += "<li>";
		info += "<div class='td1'>" + logList[i].opttime + "</div>";
		info += "<div class='td2'>" + logList[i].optuser + "</div>";
		info += "<div title='" + logList[i].remark + "' class='td3'><nobr>" + logList[i].remark + "</nobr></div>";
		info += "</li>";
	}
	$("#logInfo").html(info);
}
  
  //显示上传窗口
 function showUploadDialog(){
  var formUpload = new Ext.form.FormPanel({  
	    baseCls: 'x-plain',  
	    labelWidth: 80,  
	    fileUpload:true,  
	    defaultType: 'textfield',  
	    items: [{  
	      xtype: 'textfield',  
	      fieldLabel: '三表合一附件',  
	      name: 'upload',  
	      inputType: 'file',  
	      allowBlank: false,  
	      blankText: '请上传文件',  
	      anchor: '90%'  
	    }]  
	  });  
  
  var dialog = new Ext.Window({
	  title:'附件上传',
	  width:400,
	  height:120,
	  closable:true,
	  modal:true,
	  bodyStyle:'padding:5px;',  
	  buttonAlign:'center',  
	  items: formUpload,
	  allowBlank:false,
	  buttons:[{
		  text:'上传',
		  handler:function(){
			  var uploadName = formUpload.getForm().findField('upload').getValue();
			  if(uploadName == ""){
				  alert('请先选择需要上传的文件');
				  return;
			  }
			  
			  var arr = uploadName.split('.');
			  if(arr[arr.length-1] != 'xls' && arr[arr.length-1] != 'xlsx'){
				  alert("文件类型不正确，请上传xls或xlsx类型文件");
				  return;
			  }
			  formUpload.getForm().submit({
				  url: "${mvcPath}/threeForms/upload?month=" + month,
				  success: function(response, action){
					  var fileNames = action.result.fileNames;
					  var fileName = fileNames[0].fileName;
					  alert("上传成功");
					  dialog.hide();
					  quertUpload();
		          }, 
	   			  failure: function(form, action){
	   				alert("上传失败");
	   			  }
			  });
		  }
	  },
	  {
		  text:'取消',
		  handler:function(){
			  dialog.hide();
		  }
	  }]
  });
  dialog.show();
}

function uploadSuccess(fileName, status, suggestion, isdelete){
	$('#status').html(status);
	
	$('#fileLink').show();
	$('#fileLink').html(fileName);
	$('#showExcPanel').show();
	$('#noData').hide();
	
	$('#uploadBtn').hide();
	$('#deleteImg').hide();
	$('#suggestTr').hide();
	$('#confirmTr').hide();
	
	if('已上传'== status){
		if(userId == 'lixianghui'){
			$('#confirmTr').show();
		}
	}
	
	if('退回' == status){
		$('#suggestion').html(suggestion);
		$('#suggestTr').show();
		$('#confirmTr').hide();
		
		//表示退回未删除附件
		if(isdelete == '1'){
			$('#deleteImg').show();
		}
		
		//退回并且已上传附件
		if(isdelete == '0'){
			$('#uploadBtn').show();
			$('#fileLink').hide();
			$('#showExcPanel').hide();
			$('#noData').show();
			$('#loadMask').hide();
			return;
		}
	}
	
	showExcel(fileName);
 	$('#fileLink').attr('href',"${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=threeForm/" + month + "&fileName=" + fileName);

}

function showExcel(fileName){
	var ajax=new aihb.Ajax({
		  url : "${mvcPath}/threeForms/readExcel",
		  parameters : "month="+month+"&fileName=" + encodeURIComponent(fileName),
		  callback : function(xmlrequest){
			    var result = xmlrequest.responseText;
			    result = eval("("+result+")");
				if(!result.flag){
					return;
				}
				
				var sheetCount = result.sheetCount;
				sheet = result.sheet;
				var tabs = '';
				var className = '';
				for(var i=0; i<sheetCount; i++){
					if(i==0){
						className = 'active';
					}else{
						className = 'excelTab';
					}
					tabs += "<a class='" + className + "' onclick=showContent('"+ i + "')>" + sheet[i].sheetName + "</a>";
				}
				$('#excelTab').html(tabs);
				$('#excelCont').html(sheet[0].sheetCont);
				$('#loadMask').hide();
		  }
	});
	ajax.request();
}

function showContent(index){
	$('#excelTab').children().each(function(i,n){
	    var obj = $(n);
	    obj.removeClass();
	    if(i == index){
	    	obj.addClass('active');
	    }else{
	    	obj.addClass('excelTab');
	    }
	}); 
	$('#excelCont').html(sheet[index].sheetCont);
}

function showBackDia(){
	var dialog = new Ext.Window({
		  title:'退回理由',
		  width:400,
		  height:200,
		  closable:true,
		  modal:true,
		  bodyStyle:'padding:5px;', 
		  items:[
		        formPanel = new Ext.FormPanel({
		        	defaultType : 'textfield',
		        	labelAlign : 'center',
		        	frame : true,
		        	width : 375,
		        	items :[
						new Ext.form.TextArea({//文本域
							fieldLabel:'内容',
							hideLabel:true,
							width:363,
							height:100,
							name:'sugContent'
						})
		            ]
		        })
	      ], 
		  buttonAlign:'center',
		  buttons:[{
			  text:'确定',
			  handler:function(){
				  var sugContent = formPanel.getForm().findField('sugContent').getValue();
				  if(sugContent.length == 0){
					  alert("请填写退回理由");
					  return;
				  }
				  submit('退回', sugContent);
				  dialog.hide();
			  }
		  },
		  {
			  text:'取消',
			  handler:function(){
				  dialog.hide();
			  }
		  }]
	  });
	  dialog.show();
}

function submit(status, suggestion){
	if(confirm("是否确定" + status)){
		$.ajax({
			url:"${mvcPath}/threeForms/updateStatus"
			,dataType:"json"
			,data:"month=" + month + "&status=" + encodeURIComponent(status) + "&suggestion=" + encodeURIComponent(suggestion)
			,type:"post"
			,success:function(data){
				if(data.flag == '1'){
					alert(status + '成功');
					quertUpload();
				}else if(data.flag == '-1'){
					alert('审核出错');
				}
			}
	  });
	}
	
}

function deleteFile(){
	if(confirm("您确定要删除该附件吗？")){
		var fileName = $('#fileLink').html();
		$.ajax({
			url:"${mvcPath}/threeForms/deleteFile"
			,dataType:"json"
			,data:"month=" + month + "&fileName=" + encodeURIComponent(fileName)
			,type:"post"
			,success:function(data){
				if(data.flag == '1'){
					alert('删除成功');
					quertUpload();
				}else if(data.flag == '-1'){
					alert('删除失败');
				}
			}
	  });
	}
}
</script>
</head>
<body>
<div class='wrap'>
<div id='panel' class='infoDv'>
<table id='infoTable' cellpadding="0" cellspacing="1" border="0">
	<tr>
		<td width='200px' style="background: #d6ecf9; color: #1a446f; text-align: right;">月份</td>
		<td width='800px'>
			<input type="text" class='Wdate' id="fileMonth" onclick='changeMonth();'/>
		</td>
	</tr>
	<tr>
		<td style="background: #d6ecf9; color: #1a446f; text-align: right;">三表合一附件</td>
		<td >
			<input id='uploadBtn' type='button' value='上传' onclick='showUploadDialog()'>
			<a class='down' id='fileLink' herf='javascript:;'></a>
			<img id='deleteImg' class='curs' onclick='deleteFile();' src="${mvcPath}/hbapp/resources/image/default/delete.png"/>
		</td>
	</tr>
	<tr>
		<td style="background: #d6ecf9; color: #1a446f; text-align: right;">当前状态</td>
		<td id='status'></td>
	</tr>
	<tr id='suggestTr'>
		<td style="background: #d6ecf9; color: #1a446f; text-align: right;">退回理由</td>
		<td id='suggestion'></td>
	</tr>
	<tr id='confirmTr'>
		<td style="background: #d6ecf9; color: #1a446f; text-align: right;">审核</td>
		<td>
			<input type="button" value='通过' onclick="submit('通过','')"/>
			<input type="button" value='退回' onclick="showBackDia('退回')"/>
		</td>
	</tr>
	<tr>
		<td style="background: #d6ecf9; color: #1a446f; text-align: right;">操作日志</td>
		<td>
			<ul id='logInfo'>
			</ul>
		</td>
	</tr>
</table>
</div>
<fieldset class='contentField'>
<legend align="center"><center>Excel内容展示区</center></legend>
<div id='showExcPanel'>
	<div id='excelTab'></div>
	<div id='excelCont' class='excelCont'></div>
</div>
<div>
	<div id='noData'>暂无数据……</div>
</div>
</fieldset>
<form name="tempForm" action=""></form>
</div>
<div id='loadMask' style="display: none;">
	<div class='maskBody'>
		<span class='loadingIcon'></span>
		<div class='mart14'>加载中请稍候...</div>
	</div>
</div>
</body>
</html>