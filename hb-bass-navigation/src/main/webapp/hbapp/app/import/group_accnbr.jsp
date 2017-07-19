<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%User user = (User)session.getAttribute("user");
if(null == user){
	user = new User();user.setId("admin");;
} %>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-集团编码导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	集团编码导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=集团编码.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<!-- 
		<div>导入说明：</div>
		<div>一次只能导入一个周期的数据</div>
		<div>每次导入会自动覆盖历史导入的同一周期数据</div>
		 -->
	<div></div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>操作</td>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
				</div>
			</td>
		</tr>
	</table>
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


	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	var tempDate = new Date();
	var year = tempDate.getYear();
	var month = tempDate.getMonth();
	tempDate = new Date(year,month);
	tempDate.setMonth(tempDate.getMonth() - 1);//上月
	//上月
	var _date = tempDate.format("yyyymm");
	
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymmdd") + "@" + '<%=user.getId()%>';
			var currentDate = new Date().format("yyyymm");
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		}
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					} else return true;
				};						
				
			   	vault.setFormField("tableName", "nmk.ent_key_group_new");
		    	vault.setFormField("columns", "taskid, groupcode");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		//删除“集团编码”几个字
		    		var sql = encodeURIComponent("delete from  nmk.ent_key_group_new where groupcode like '%集团%' ");
		    		var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql
						,loadmask : false
						,callback : function(xmlrequest){
							alert("导入完成");
							query();
							loadmask.style.display="none";
						}
					});
					ajax.request();
		    		
		    	}
			};
			
			var _header= [
	 			 {
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"groupcode",
					"name":["集团编码"],
					"title":"",
					"cellFunc":""
				}];
			function query(){
				var grid = new aihb.AjaxGrid({
					header:_header
					,sql: "select groupcode from  nmk.ent_key_group_new with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				$("queryBtn").onclick = query;
			}
		
		}(window,document);
		
	</script>
</body>
</html>