<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-当月成本财务数据导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	查看：查看当月数据，如果存在当月的先删除再导入
	下载：下载所有的记录 
-->
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="width:94%;margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=当月各项年累计成本财务数据导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>说明：</div>
			<div>1.查询条件中时间批次和导入时间可以任选其一进行查询</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div>
	<table align="center" style="width:96%;margin: 10px 0px 0px 10px;" class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>时间批次</td>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
			</td>
			<td class='dim_cell_title'>导入时间</td>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="import_date" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
			</td>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
				</div>
			</td>
		</tr>
	</table>
</div>
<!--  
<div style="text-align:right;">
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看"/>&nbsp;
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看全部"/>&nbsp;
	<input type="button" id="downBtn" class="form_button" style="width : 120px" value="下载" onclick="down()">&nbsp;
</div>
-->
<div class="divinnerfieldset">
<fieldset align="left" style="width:94%;margin: 10px 0px 0px 10px;">
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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset="utf-8"></script>
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
				
			   	vault.setFormField("tableName", "nwh.cost_use_load_temp");
		    	vault.setFormField("columns", "taskid,AREA_CODE,CHL_REWARD,CHL_NEWUSER_REWARD,PROMOTE_FEE,TERM_FEE,AD_FEE,AD_BUSI_PROP_FEE,AD_BILL_FEE,AD_SHOW_FEE,SERVICE_FEE,SERVICE_SCORE_FEE,SERVICE_EP_FEE,TOTAL_MARKETING_FEE,DISCOUNT,OPERATION_CHARGE,OPERAT_LEASE_FEE,BADDEBT_RESERVE_FEE,OVER_MANAGE_SERVICE_FEE,OTHER_MANAGE_SERVICE_FEE,REPAIR_FEE,LOWVAL_GOODS_AMORT_FEE,MANPOWER_FEE,RENT_CIRCUIT_NETS_FEE,DEPRECIATE_AMORT_FEE,RESOURCES_TAKEUP_FEE,BUSI_TECH_SUPPORT_FEE,CYCLE_ID");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		
		    		var sql = encodeURIComponent("insert into nwh.cost_use_load(AREA_CODE,CHL_REWARD,CHL_NEWUSER_REWARD,PROMOTE_FEE,TERM_FEE,AD_FEE,AD_BUSI_PROP_FEE,AD_BILL_FEE,AD_SHOW_FEE,SERVICE_FEE,SERVICE_SCORE_FEE,SERVICE_EP_FEE,TOTAL_MARKETING_FEE,DISCOUNT,OPERATION_CHARGE,OPERAT_LEASE_FEE,BADDEBT_RESERVE_FEE,OVER_MANAGE_SERVICE_FEE,OTHER_MANAGE_SERVICE_FEE,REPAIR_FEE,LOWVAL_GOODS_AMORT_FEE,MANPOWER_FEE,RENT_CIRCUIT_NETS_FEE,DEPRECIATE_AMORT_FEE,RESOURCES_TAKEUP_FEE,BUSI_TECH_SUPPORT_FEE,CYCLE_ID,IMPORT_DATE) select AREA_CODE,CHL_REWARD,CHL_NEWUSER_REWARD,PROMOTE_FEE,TERM_FEE,AD_FEE,AD_BUSI_PROP_FEE,AD_BILL_FEE,AD_SHOW_FEE,SERVICE_FEE,SERVICE_SCORE_FEE,SERVICE_EP_FEE,TOTAL_MARKETING_FEE,DISCOUNT,OPERATION_CHARGE,OPERAT_LEASE_FEE,BADDEBT_RESERVE_FEE,OVER_MANAGE_SERVICE_FEE,OTHER_MANAGE_SERVICE_FEE,REPAIR_FEE,LOWVAL_GOODS_AMORT_FEE,MANPOWER_FEE,RENT_CIRCUIT_NETS_FEE,DEPRECIATE_AMORT_FEE,RESOURCES_TAKEUP_FEE,BUSI_TECH_SUPPORT_FEE,CYCLE_ID,CURRENT DATE from nwh.cost_use_load_temp where taskid='" + taskId + "' ");
		    		sql += "&sqls=" + encodeURIComponent("delete from nwh.cost_use_load_temp ");
					var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						alert("导入完成请查询结果");
						loadmask.style.display="none";
						query();
						//tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/report/college/uploadinfo.html?taskId=" + taskId + "&" + _params._oriUri});
					}
				});
					ajax.request();
		    	}
			};
			
			var _header= [
	 			 {"cellStyle":"grid_row_cell_text","name":["地域"],"dataIndex":"area_code","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["社会渠道酬金合计"],"dataIndex":"chl_reward","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["其中：放号酬金"],"dataIndex":"chl_newuser_reward","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["促销费用合计"],"dataIndex":"promote_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["其中：终端补贴"],"dataIndex":"term_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["广告宣传费合计"],"dataIndex":"ad_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["其中：业务宣传费"],"dataIndex":"ad_busi_prop_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["广告费"],"dataIndex":"ad_bill_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["展览费"],"dataIndex":"ad_show_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["客户服务费合计"],"dataIndex":"service_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["其中：积分计划兑现"],"dataIndex":"service_score_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["客服外包费"],"dataIndex":"service_ep_fee","title":""}			
	 			,{"cellStyle":"grid_row_cell_text","name":["营销费用合计"],"dataIndex":"total_marketing_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["折扣折让"],"dataIndex":"discount","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["运营收入"],"dataIndex":"operation_charge","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["经营租赁费"],"dataIndex":"operat_lease_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["坏账准备"],"dataIndex":"baddebt_reserve_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["上缴管理服务费"],"dataIndex":"over_manage_service_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["其他管理费"],"dataIndex":"other_manage_service_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["维修费"],"dataIndex":"repair_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["低值易耗品摊销"],"dataIndex":"lowval_goods_amort_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["人工成本"],"dataIndex":"manpower_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["电路及网元租赁费"],"dataIndex":"rent_circuit_nets_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["折旧及摊销"],"dataIndex":"depreciate_amort_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["资源占用费"],"dataIndex":"resources_takeup_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["业务技术支撑费"],"dataIndex":"busi_tech_support_fee","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["时间批次"],"dataIndex":"cycle_id","title":""}
	 			,{"cellStyle":"grid_row_cell_text","name":["导入时间"],"dataIndex":"import_date","title":""}];
			 		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select area_code,chl_reward,chl_newuser_reward,promote_fee,term_fee,ad_fee,ad_busi_prop_fee,ad_bill_fee,ad_show_fee,service_fee,service_score_fee,service_ep_fee,total_marketing_fee,discount,operation_charge,operat_lease_fee,baddebt_reserve_fee,over_manage_service_fee,other_manage_service_fee,repair_fee,lowval_goods_amort_fee,manpower_fee,rent_circuit_nets_fee,depreciate_amort_fee,resources_takeup_fee,busi_tech_support_fee,cycle_id,import_date from nwh.cost_use_load where CYCLE_ID="+$("cycle_id").value +" or import_date=date('"+$("import_date").value+"') with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			function down(){
				aihb.AjaxHelper.down({
					sql : "select area_code,chl_reward,chl_newuser_reward,promote_fee,term_fee,ad_fee,ad_busi_prop_fee,ad_bill_fee,ad_show_fee,service_fee,service_score_fee,service_ep_fee,total_marketing_fee,discount,operation_charge,operat_lease_fee,baddebt_reserve_fee,over_manage_service_fee,other_manage_service_fee,repair_fee,lowval_goods_amort_fee,manpower_fee,rent_circuit_nets_fee,depreciate_amort_fee,resources_takeup_fee,busi_tech_support_fee,cycle_id,import_date from nwh.cost_use_load where CYCLE_ID="+$("cycle_id").value +" or import_date=date('"+$("import_date").value+"') with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			
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
				var _d=new Date();
				$("cycle_id").value=_d.format("yyyymm");
				$("import_date").value=_d.format("yyyy-mm-dd");
				/*
				$("failNum").onclick=function(){
		 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/channel/uploadinfo.html?taskId=" + taskId + "&" +_params._oriUri})
				}
				*/
				$("queryBtn").onclick = query;
				//$("delBtn").onclick = _delete;
				$("downBtn").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>