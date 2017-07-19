<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-升级投诉数据导入2</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	升级投诉数据导入2
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=升级投诉2.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
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
				
			   	vault.setFormField("tableName", "up_complain_dep");
		    	vault.setFormField("columns", "taskid, id, time_id, is_res, resp_dept1, cnt1,resp_dept2,cnt2,resp_dept3,cnt3");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		alert("导入完成,请查看本次导入结果");
					loadmask.style.display="none";
					query();
		    	}
			};
			
			var _header= [
				 			 {
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"id",
								"name":["序号"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"time_id",
								"name":["日期"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"is_res",
								"name":["是否定责"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"resp_dept1",
								"name":["责任部门1"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"cnt1",
								"name":["责任量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"resp_dept2",
								"name":["责任部门2"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"cnt2",
								"name":["责任量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"resp_dept3",
								"name":["责任部门3"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"cnt3",
								"name":["责任量"],
								"title":"",
								"cellFunc":""
							}];
			 		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select id, time_id, is_res, resp_dept1, cnt1,resp_dept2,cnt2,resp_dept3,cnt3 from up_complain_dep where taskid='" + taskId + "' order by 1 with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			/**
			function down(){
				aihb.AjaxHelper.down({
					sql : "select area_code,chl_reward,chl_newuser_reward,promote_fee,term_fee,ad_fee,ad_busi_prop_fee,ad_bill_fee,ad_show_fee,service_fee,service_score_fee,service_ep_fee,total_marketing_fee,discount,operation_charge,operat_lease_fee,baddebt_reserve_fee,over_manage_service_fee,other_manage_service_fee,repair_fee,lowval_goods_amort_fee,manpower_fee,rent_circuit_nets_fee,depreciate_amort_fee,resources_takeup_fee,busi_tech_support_fee,cycle_id,import_date from nwh.cost_use_load where CYCLE_ID="+$("cycle_id").value +" or import_date=date('"+$("import_date").value+"') with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
				});
			}
			*/
			function _delete() {
				if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
					return;
				var sql=encodeURIComponent("delete from nwh.cost_use_load ");
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						var result = eval("(" + xmlrequest.responseText + ")");
						alert(result.message);
					}
				});
				ajax.request();
			}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
			}
		
		}(window,document);
		
	</script>
</body>
</html>