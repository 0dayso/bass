<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-季度终端补贴预算导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset align="center" style="width:94%;margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=季度终端补贴预算导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>说明：</div>
			<div>1.查询条件中时间批次和导入时间可以任选其一进行查询</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div style="text-align:right;">
	<table align="center" style="width:96%;margin: 10px 0px 0px 10px;" class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>时间批次</td>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-M'})" class="Wdate"/>
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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
		var tempDate = new Date();
		var year = tempDate.getYear();
		var month = tempDate.getMonth();
		tempDate = new Date(year,month);
		tempDate.setMonth(tempDate.getMonth() - 1);//上月
		//debugger;
		var _date = tempDate.format("yyyymm");
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymmdd") + "@" + '<%=user.getId()%>';
			//因为数据库格式为字符串“2011-1”，需要判断月份是否大于10
			var month = new Date().getMonth();
			var currentDate=new Date().format("yyyy-mm");
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
				
				/*
				（4）导入周期：不定期，但每日导入时间为早上9:00-当日24:00前，以免生成和导入数据不同步。
				（5）允许导入时间范围：7月15日至9月30日
				*/
				/*
				vault.enableAddButton(function(time){
					
					if(time.getHours() >  9 &&
					   ((time.getMonth()+1) >= 7 && time.getDate() >= 15) &&
					   ((time.getMonth()+1) <= 9 && time.getDate() <= 30)
					)
					
					if(time <= new Date(2010,08,31) && time >= new Date(2010,06,15) && time.getHours() >= 9)
						return true;
					else {
						alert("当前时间禁止导入。导入时间为7月15日至9月30日之9:00~24:00");
						return false;
					}
					
					return true;
				}(new Date()));
				*/
			   	vault.setFormField("tableName", "nmk.DIM_TERMINAL_COST_QUARTER_BUDGET_temp");
		    	vault.setFormField("columns", "taskid,AREA_CODE,COST_budget_M,ETL_CYCLE_ID");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
					//debugger;
		    		//var tempDate = new Date();
		    		//tempDate.setMonth(tempDate.getMonth() - 1);//上个月的
		    		//tempDate.setDate(tempDate.getDate() - 2); //推迟两天
					//var _date = tempDate.format("yyyymm");
		    		//var sql=encodeURIComponent("update college_jiajika_import_temp set flag='成功' where taskid='" + taskId + "'"); //先全部置为成功
		    		/*
		    		sql += "&sqls=" + encodeURIComponent("update NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP set flag='已存在相同渠道编码' where taskid='" + taskId + "' and channel_id in (select distinct channel_id from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " )");
					sql += "&sqls=" + encodeURIComponent("insert into  NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " (CHANNEL_ID,Customer_service_score,Competitive_strategy_score,Image_score,Development_strategy_score) select CHANNEL_ID,round(Customer_service_score,2),round(Competitive_strategy_score,2),round(Image_score,2),round(Development_strategy_score,2) from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP where taskid='" + taskId + "' and flag='成功'");
					*/
					//第0行,第0列验证浮点数不通过，该行略过序号
					 /* 删除当前月份记录,可能没有 */					
					var sql= encodeURIComponent("insert into nmk.DIM_TERMINAL_COST_QUARTER_BUDGET(AREA_CODE,COST_budget_M,ETL_CYCLE_ID,import_date) select AREA_CODE,COST_budget_M,ETL_CYCLE_ID,CURRENT DATE from NMK.DIM_TERMINAL_COST_QUARTER_BUDGET_temp ");
					sql += "&sqls=" + encodeURIComponent("delete from NMK.DIM_TERMINAL_COST_QUARTER_BUDGET_temp");
					var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						alert("导入完成请查看结果");
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
					"dataIndex":"area_code",
					"name":["地市"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"cost_budget_m",
					"name":["预算(元)"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"etl_cycle_id",
					"name":["时间批次"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"import_date",
					"name":["导入时间"],
					"title":"",
					"cellFunc":""
				}
			];
		
			function query(){
				//loadmask.style.display="";
				var etl_cycle_id = $("cycle_id").value;
				if(etl_cycle_id.substr(5,1)==0){
					etl_cycle_id = etl_cycle_id.substr(0,5)+etl_cycle_id.substr(6,1);
				}
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select AREA_CODE,COST_budget_M,ETL_CYCLE_ID,import_date from nmk.DIM_TERMINAL_COST_QUARTER_BUDGET where etl_cycle_id='"+$("cycle_id").value+"'"+" or import_date=date('"+$("import_date").value+"') order by ETL_CYCLE_ID desc with ur"
					,isCached : false
					,callback : function() {
						//alert("导入成功!") 
						//loadmask.style.display="none";
					}
				});
				grid.run();
			}

			function down(){
				var etl_cycle_id = $("cycle_id").value;
				if(etl_cycle_id.substr(5,1)==0){
					etl_cycle_id = etl_cycle_id.substr(0,5)+etl_cycle_id.substr(6,1);
				}
				aihb.AjaxHelper.down({
					sql : "select AREA_CODE,COST_budget_M,ETL_CYCLE_ID,import_date from nmk.DIM_TERMINAL_COST_QUARTER_BUDGET where etl_cycle_id='"+$("cycle_id").value+"'"+" or import_date=date('"+$("import_date").value+"') order by ETL_CYCLE_ID desc with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}

			function _delete() {
				if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
					return;
				var sql=encodeURIComponent("delete from nmk.DIM_TERMINAL_COST_QUARTER_BUDGET where import_date="+taskId.split("@")[0]);
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
				$("cycle_id").value=_d.format("yyyy-mm");
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