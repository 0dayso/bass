<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-本省人口导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	查看：查看当月数据，如果存在当月的先删除再导入
	下载：下载所有的记录 
-->
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=人口导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div>
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
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
				
			   	vault.setFormField("tableName", "local_person_load");
		    	vault.setFormField("columns", "taskid,area_id,value,month_id");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		
		    		var sql = encodeURIComponent("update local_person_load set area_id='HB.ES' where area_id='恩施' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.XG' where area_id='孝感' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.JM' where area_id='荆门' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.JH' where area_id='江汉' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.YC' where area_id='宜昌' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.XF' where (area_id='襄樊' or area_id='襄阳') and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.XN' where area_id='咸宁' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.JZ' where area_id='荆州' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.WH' where area_id='武汉' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.SY' where area_id='十堰' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.HS' where area_id='黄石' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.HG' where area_id='黄冈' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.EZ' where area_id='鄂州' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.SZ' where area_id='随州' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.TM' where area_id='天门' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB.QJ' where area_id='潜江' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("update local_person_load set area_id='HB' where area_id='全省' and taskid='" + taskId + "' ");
		    		sql+="&sqls=" +encodeURIComponent("delete from (select a.*,row_number() over(partition by month_id,area_id order by taskid desc) rn from local_person_load a) a where rn<>1");
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
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_id",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"value",
					"name":["人口数"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"month_id",
					"name":["年份"],
					"title":"",
					"cellFunc":""
				}       
			              ];
	 			
			 		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select area_id,value,month_id from local_person_load  order by month_id with ur"
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
				//$("cycle_id").value=_d.format("yyyymm");
				//$("import_date").value=_d.format("yyyy-mm-dd");
				/*
				$("failNum").onclick=function(){
		 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/channel/uploadinfo.html?taskId=" + taskId + "&" +_params._oriUri})
				}
				*/
				$("queryBtn").onclick = query;
				//$("delBtn").onclick = _delete;
				//$("downBtn").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>