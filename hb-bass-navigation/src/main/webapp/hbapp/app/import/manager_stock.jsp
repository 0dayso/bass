<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-责任人区域架构导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<div id="importDiv">
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	责任人区域架构导入
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
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
					<input type="button" id="queryForWarningBtn" class="form_button"  style="width: 100px" value="查询未导入成功清单"/>&nbsp;
					<input type="button" id="downForWarningBtn" class="form_button" style="width: 100px" value="下载未导入成功清单">&nbsp;
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
				
			   	vault.setFormField("tableName", "nmk.manager_region_tmp");
		    	vault.setFormField("columns", "TASK_ID,MANAGER_ACCNBR,MANAGER_NAME,COUNTY_NAME,ZONE_NAME");
		    	vault.setFormField("date", taskId);  
		    	vault.setFormField("ds","dw");
		    	
		    	vault.onUploadComplete = function(files) {
									var ajaxCheck = new aihb.Ajax({
										url : "${mvcPath}/import/checkForStockRegion"
										,parameters : "ds=dw"
										,loadmask : true
										,callback : function(xmlresult){
											var result = xmlresult.responseText;
											result = eval('(' + result + ')');
											alert("有"+result.count+"条记录将导入正式表，有"+result.cnt+"条记录未导入成功，详情点击查看未导入记录！");
											if(confirm("您确定要将这批数据入库吗?")){
												var sql = encodeURIComponent("INSERT INTO NMK.MANAGER_REGION(TIME_ID,MANAGER_ACCNBR,MANAGER_NAME,COUNTY_NAME,ZONE_NAME) SELECT INT(subStr(TASK_ID,1,6)),MANAGER_ACCNBR,MANAGER_NAME,COUNTY_NAME,ZONE_NAME FROM NMK.MANAGER_REGION_TMP");
												// 删除临时表的数据
												sql += "&sqls=" + encodeURIComponent("DELETE FROM NMK.MANAGER_REGION_TMP");
												var ajaxAdd = new aihb.Ajax({
													url : "${mvcPath}/hbirs/action/sqlExec"
													,parameters : "sqls="+sql+"&ds=dw"
													,loadmask : false
												})
												ajaxAdd.request();
											}
											alert("成功导入"+result.count+"条记录");
											//最后再查询最新数据
											aihb.Util.loadmask();
											query();
										}
									})
									ajaxCheck.request();
								
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
					"dataIndex":"manager_accnbr",
					"name":["维系人手机号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"manager_name",
					"name":["维系人员姓名"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"county_name",
					"name":["县分公司"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"zone_name",
					"name":["区域营销中心"],
					"title":"",
					"cellFunc":""
				}
			    ];
	 			
			 		
			function query(){
				var sql = "select * from nmk.manager_region where 1=1 ";
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
			
			function queryForWarning(){
				var userid = '<%=user.getId()%>';
				var sql = "select subStr(TASK_ID,1,6) time_id,manager_accnbr,manager_name, county_name,zone_name from nmk.manager_region_view_tmp where task_id like '%"+userid+"%'' "
				if($("date1").value!=null){
					sql = sql + " adn subStr(TASK_ID,1,6)="+$("date1").value+" "
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
					sql : "select * from nmk.manager_region with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			
			function downForWarning(){
				var userid = '<%=user.getId()%>';
				var sql = "select subStr(TASK_ID,1,6) time_id,manager_accnbr,manager_name, county_name,zone_name from nmk.manager_region_view_tmp where task_id like '%"+userid+"%'' "
				if($("date1").value!=null){
					sql = sql + " adn subStr(TASK_ID,1,6)="+$("date1").value+" "
				}
				aihb.AjaxHelper.down({
					sql : sql
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
				$("queryForWarningBtn").onclick = queryForWarning;
				$("downBtn").onclick = down;
				$("downForWarningBtn").onclick = downForWarning;
			}
		
		}(window,document);
		
	</script>
</body>
</html>