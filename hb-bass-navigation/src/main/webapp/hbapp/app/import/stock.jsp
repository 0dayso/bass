<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-用户与责任人清单导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<div id="importDiv">
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	用户与责任人清单导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=集团满意度数据导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
	<div>
		<ul>
			<li>对于同一周期内的多次导入，系统会自动更新上一次数据</li>
			<li>查询条件的时间对应关系：如201101对应2011年第1期</li>
		</ul>
	</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div id="condi1" style="display:none">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn1" class="form_button"  style="width: 100px" value="查询本次导入"/>&nbsp;
					<!--  
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
					-->
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>导入月份</td>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
			</td>
			<td class='dim_cell_title'>操作</td>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
				</div>
			</td>
		</tr>
	</table>
</div>

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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">

		+function(window,document,undefined){
			
			var taskId = new Date().format("yyyymm") + "@" + '<%=user.getId()%>';
			var currentTime = new Date().format("yyyymm");
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importForStock", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
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
				
			   	vault.setFormField("tableName", "nmk.manager_mbuser_tmp");
		    	vault.setFormField("columns", "TASK_ID,ACC_NBR,MANAGER_ACCNBR");
		    	vault.setFormField("date", taskId);  
		    	vault.setFormField("ds","web");
		    	
		    	vault.onUploadComplete = function(files) {
					alert("数据正在后台录入，请在15分钟后查看结果。");
					loadmask.style.display="none";
					//showPanel();
					window.location.href='stock.jsp';
				}
	    	
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"time_id",
					"name":["数据导入日期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"acc_nbr",
					"name":["目标客户手机号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"manager_accnbr",
					"name":["维系人手机号码"],
					"title":"",
					"cellFunc":""
				}
			    ];
	 			
			 		
			function query(){
				var sql = "select * from nmk.manager_mbuser where 1=1 ";
				if($("date1").value!=null){
					sql = sql + " adn time_id="+$("date1").value+" "
				}
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: sql
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			function down(){
				aihb.AjaxHelper.down({
					sql : "select * from nmk.manager_mbuser with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				var _d=new Date();
				$("date1").value=_d.format("yyyymm");
				$("queryBtn").onclick = query;
				//$("queryForWarningBtn").onclick = queryForWarning;
				$("downBtn").onclick = down;
				//$("downForWarningBtn").onclick = downForWarning;
			}
		
		}(window,document);
		
	</script>
</body>
</html>