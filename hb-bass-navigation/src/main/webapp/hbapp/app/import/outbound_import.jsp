<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="UTF-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-满意度调研号码导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
	<legend>
		数据导入
	</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top">
			<a style="text-decoration: underline;" href="/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=impTempl&amp;fileName=满意度调研号码导入摸版.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>请严格按照模板格式导入数据</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
	<div style="text-align:right;">
		<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看"/>&nbsp;
		<input type="button" id="downBtn" class="form_button" style="width : 120px" value="下载" onclick="down()">&nbsp;
	</div>
	
	<div class="divinnerfieldset">
	<fieldset>
		<legend><table><tr>
			<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
			<td></td>
		</tr></table>
		</legend>
		<div id="grid" style="display:none;"></div>
	</fieldset>
	</div><br>
</form>

<form name="tempForm" action=""></form>
<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset="UTF-8"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js" charset="UTF-8"></script>
<script type="text/javascript">
+function(window,document,undefined){
	var _params = aihb.Util.paramsObj();
	var now=new Date();
	now.setMonth(now.getMonth()-1);
	var taskId = now.format("yyyymm");
	function showPanel() {
		var vault = new dhtmlXVaultObject();
		vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
		vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
		vault.setFilesLimit(1);
		vault.create("uploadDiv");
		vault.onFileUpload=function(){
			return true;
		}
		vault.onAddFile = function(fileName) {
			var ext = this.getFileExtension(fileName);
			if (ext != 'xls') {
				alert("本应用只支持扩展名.xls,请重新上传.");
				return false;
			} else return true;
		};
		vault.setFormField("tableName", "NWH.DIM_PHONE_IMPORT_TMP");
		vault.setFormField("columns", "TASK_ID,TIME_ID,ACC_NBR");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","dw");
		vault.onUploadComplete = function(files) {
			var tempSql = encodeURIComponent("delete from NWH.DIM_PHONE_IMPORT_TMP where task_id !='" + taskId + "'");
			var _tempAjax  = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/sqlExec"
				,parameters : "sqls="+tempSql+"&ds=dw"
				,asynchronous: true
				,loadmask : false
				,callback : function(xmlrequest){
					var _sql = "select count(*) cnt from NWH.DIM_PHONE_IMPORT_TMP where TASK_ID='" + taskId + "' and ACC_NBR NOT LIKE '%号码%'";
					var _ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/jsondata?method=query"
						,parameters : "sql="+strEncode(_sql)+"&isCached=false"+"&ds=dw"
						,loadmask : true
						,callback : function(xmlrequest){
							try{
								var result = xmlrequest.responseText;
								result = eval(result);
								//如果导入数为空，则导入失败
								if(!result || !result[0].cnt){
									alert("导入失败，请查询数据是否正确");
									return;
								}else{
									alert("有"+result[0].cnt+"条记录将导入正式表");
								}
								if(confirm("您确定要将这批数据入库吗?")){
									//删除正式表指定STATIS_DATE数据
									var sql = encodeURIComponent("delete from NWH.DIM_PHONE_IMPORT where time_id in (select time_id from NWH.DIM_PHONE_IMPORT_TMP where acc_nbr not like '%号码%' fetch first 1 rows only)");
									var ajaxAdd = new aihb.Ajax({
										url : "${mvcPath}/hbirs/action/sqlExec"
										,parameters : "sqls="+sql+"&ds=dw"
										,asynchronous: true
										,loadmask : false
										,callback : function(xmlrequest){
											 if(xmlrequest.responseText=='{\"message\":\"执行成功\"}'&&xmlrequest.status==200){
													var sql= encodeURIComponent("insert INTO NWH.DIM_PHONE_IMPORT (TIME_ID,ACC_NBR) SELECT TIME_ID,ACC_NBR FROM NWH.DIM_PHONE_IMPORT_TMP where ACC_NBR not like '%号码%'");
													var ajaxAdd = new aihb.Ajax({
														url : "${mvcPath}/hbirs/action/sqlExec"
														,parameters : "sqls="+sql+"&ds=dw"
														,asynchronous: true
														,loadmask : false
														,callback : function(xmlrequest){
																 if(xmlrequest.responseText=='{\"message\":\"执行成功\"}'&&xmlrequest.status==200){
																	alert("成功导入"+result[0].cnt+"条记录至正式表");
																	//最后再查询最新数据
																	aihb.Util.loadmask();
																	query();
																}
															}
													})
													ajaxAdd.request();
												}
										}

									})
									ajaxAdd.request();
								}
							}catch(e){
								alert("导入失败，请查询数据是否正确");
								return;
							}
						}
					});
					_ajax.request();
				}
			});
			_tempAjax.request();
			
		}
	};
					

	var _header=[
		{"name":"导入批次","dataIndex":"time_id","cellStyle":"grid_row_cell_text"},
		{"name":"号码","dataIndex":"acc_nbr","cellStyle":"grid_row_cell_text"},
		{"name":"导入时间","dataIndex":"import_date","cellStyle":"grid_row_cell_text"}
	];	
	
	function genSQL() {
		var now=new Date();
		now.setMonth(now.getMonth()-1);
		var taskId = now.format("yyyymm");
		var sql = "SELECT time_id, acc_nbr, char(import_date) import_date FROM NWH.DIM_PHONE_IMPORT " 
				+ "WHERE time_id=(select time_id from NWH.DIM_PHONE_IMPORT_TMP where acc_nbr not like '%号码%' fetch first 1 rows only)";
		return sql;
	}
		
	function query(){
		var grid = new aihb.AjaxGrid({
			header:_header
			,sql: genSQL()
			,ds:"dw"
			,isCached : false
		});
		grid.run();
	}
	
	function down(){
		aihb.AjaxHelper.down({
			sql : genSQL()
			,header : _header
			,ds : "dw"
			,isCached : false
			,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
			,form : document.tempForm
		});
	}

	window.onload=function(){
		aihb.Util.loadmask();
		showPanel();
		$("queryBtn").onclick = query;
		$("downBtn").onclick = down;
	}
			
}(window,document);
</script>
</body>
</html>