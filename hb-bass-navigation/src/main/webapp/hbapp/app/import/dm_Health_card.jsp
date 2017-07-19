<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-地市健康卡数据导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	说明： 地市健康卡导入的表样与正式表结构差异大，需要对导入的临时表做处理再插入正式表
-->
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	地市健康卡数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=地市健康卡.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
	<div>考核收入完成进度，运营收入同比增幅等百分比指标需填写为小数格式，如15%须填写成0.15 </div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div>
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>账期</td>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
			</td>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
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
				
			   	vault.setFormField("tableName", "DM_HEALTH_CARD_LOAD");
		    	vault.setFormField("columns", "taskid, area_id, zb_1, zb_2, zb_4, zb_5,zb_7,zb_8,zb_17,zb_26,zb_27,zb_32,zb_33,zb_34,zb_35,zb_36,zb_37,zb_38,month_id");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		var caseWhen = "case area_id   when '恩施' then 'HB.ES' when '天门' then 'HB.TM' when '潜江' then 'HB.QJ'  when '孝感' then 'HB.XG'  when '荆门' then 'HB.JM'  when '江汉' then 'HB.JH'  when '宜昌' then 'HB.YC'  when '襄樊' then 'HB.XF'  when '襄阳' then 'HB.XF' when '咸宁' then 'HB.XN'  when '荆州' then 'HB.JZ'  when '武汉' then 'HB.WH'  when '十堰' then 'HB.SY'  when '黄石' then 'HB.HS'  when '黄冈' then 'HB.HG'  when '鄂州' then 'HB.EZ'  when '随州' then 'HB.SZ'  when '全省' then 'HB' end area_id";
		    		var _sql="insert into dm_Health_card";
		    		_sql=_sql+"(select int(month_id),"+caseWhen+",1 zb_code,zb_1 zb_value from dm_Health_card_load where taskid='"+taskId+"'"  ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",2 zb_code,zb_2 zb_value from dm_Health_card_load where taskid='"+taskId+"'"   ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",4 zb_code,zb_4 zb_value from dm_Health_card_load where taskid='"+taskId+"'"   ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",5 zb_code,zb_5 zb_value from dm_Health_card_load where taskid='"+taskId+"'"   ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",7 zb_code,zb_7 zb_value from dm_Health_card_load where taskid='"+taskId+"'"   ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",8 zb_code,zb_8 zb_value from dm_Health_card_load where taskid='"+taskId+"'"   ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",17 zb_code,zb_17 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",26 zb_code,zb_26 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",27 zb_code,zb_27 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",32 zb_code,zb_32 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",33 zb_code,zb_33 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",34 zb_code,zb_34 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",35 zb_code,zb_35 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",36 zb_code,zb_36 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",37 zb_code,zb_37 zb_value from dm_Health_card_load where taskid='"+taskId+"'" ;
		    		_sql=_sql+" union all "                                                                                    ;
		    		_sql=_sql+"select int(month_id),"+caseWhen+",38 zb_code,zb_38 zb_value from dm_Health_card_load where taskid='"+taskId+"')";
		    		var sql = " delete from dm_Health_card where (month_id,area_id) in (select int(month_id),area_id from DM_HEALTH_CARD_LOAD where taskid='"+taskId+"')";
		    		 sql += "&sqls=" +encodeURIComponent(_sql);
		    		//sql += "&sqls=" + encodeURIComponent("delete from dm_Health_card_load where taskid='"+taskId+"'");
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
					"dataIndex":"month_id",
					"name":["账期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_id",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"zb_code",
					"name":["指标编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"zb_value",
					"name":["指标值"],
					"title":"",
					"cellFunc":""
				}];
			 		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select month_id,area_id,zb_code,zb_value from dm_Health_card where month_id="+$("cycle_id").value+" with ur"
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
				var _d=new Date();
				
				$("cycle_id").value=currentDate;
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