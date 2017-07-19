<%@page import="com.asiainfo.hb.web.models.User"%>
<%User user = (User)session.getAttribute("user");%>
<%@page contentType="text/html; charset=utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>双卡双待参数导入</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body>
	<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
		<legend>
			数据导入
		</legend>
		<table border="0" cellpadding="0" cellspacing="0">
			<tr style="padding: 5px;">
				<td width="450"><div id="uploadDiv"></div>
				<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=双卡双待参数导入模板.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
					<div>导入说明：</div>
					<div>1.入库时间导入项格式为：YYYYMMDD；</div>
					<div>2.导入项中终端制式的值只能为2G、3G、4G、其他；</div>
					<div>3.导入项中TAC码需进行验证，仅8位且不能重复，具体数值不做要求；</div>
					<div>4.所有列都不能为空，如果"支持串号类型"这一项确实为空时，请填写"无"或者"其他"；</div>
					<div>5.每个月导入增量；</div>
				</td>
			</tr>
		</table>
	</fieldset>
	<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title'>导入时间</td>
						<td class='dim_cell_content4'>
							<select name="choice" id="choice" onchange="changeDateFormat(this.options[this.options.selectedIndex].value)">
								<option value="1">按月份查询</option>
								<option value="2" selected>按日期查询</option>
							</select>							
						</td>
						<td class='dim_cell_content4'>
							<input align="right" type="text" style="display:none;" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
							<input align="right" type="text" id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
						</td>
						<td class='dim_cell_title' rowspan="2">操作</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn" class="form_button"  style="width: 120px" value="导入数据查询"/>								
							</div>
						</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="downBtn" class="form_button" style="width: 120px" value="导入数据下载">
							</div>
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title'>终端制式</td>
						<td class='dim_cell_content4' colspan="2">
							<select name="terminal_standard" id="terminal_standard">
								<option value="" selected>全部</option>
								<option value="2G">2G</option>
								<option value="3G">3G</option>
								<option value="4G">4G</option>
								<option value="其他">其他</option>
							</select>
						</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn1" class="form_button"  style="width: 120px" value="导入未成功数据查询"/>
							</div>
						</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="downBtn1" class="form_button" style="width: 120px" value="导入未成功数据下载">
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend><table><tr>
					<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>&nbsp;数据展现区域：</td>
						<td></td>
					</tr></table>
				</legend>
				<div id="grid" style="display: none;"></div>
			</fieldset>
		</div><br>
	</form>
	<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/util.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript">
	var userId = '<%=user.getId()%>';
	+function(window,document,undefined){
		var taskId = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
		var data = new Date().format("yyyy-mm-dd");
		function showPanel() {
			var vault = new dhtmlXVaultObject();
			vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			vault.setFilesLimit(1);
			vault.create("uploadDiv");
			vault.onFileUpload=function(){
				loadmask.style.display="";
				return true;
			};
			vault.onAddFile = function(fileName) {
				var ext = this.getFileExtension(fileName);
				if (ext != "xls") {
					alert("本应用只支持扩展名.xls,请重新上传.");
					return false;
				} else return true;
			};
			vault.setFormField("tableName", "NWH.DOUBLE_IMEI_CFG_TMP");
			vault.setFormField("columns", "TASK_ID,TIME_ID,TERMINAL_STANDARD,TAC_CODE,IS_SUPPORT,CH_TYPE");
			vault.setFormField("date", taskId);
			vault.setFormField("ds", "dw");
			vault.onUploadComplete = function(files) {
				//更新不符合条件数据的状态
				var sql = encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='suc' where task_id='" + taskId + "'");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='导入日期不能为空' where task_id='" + taskId + "' and (time_id is null or length(time_id)=0)");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='导入日期格式不对' where task_id='" + taskId + "' and  length(time_id)!=8 and flag='suc'");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='终端制式不能为空' where task_id='" + taskId + "' and  (TERMINAL_STANDARD is null or length(TERMINAL_STANDARD)=0)");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='TAC码不能为空' where task_id='" + taskId + "' and  (tac_code is null or length(tac_code)=0)");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='TAC码格式不对' where task_id='" + taskId + "' and  length(tac_code)!=8 and flag='suc'");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='是否支持双卡双待不能为空' where task_id='" + taskId + "' and  (is_support is null  or length(is_support)=0)");
					sql += "&sqls=" + encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP  set flag='支持串号类型不能为空' where task_id='" + taskId + "' and (CH_TYPE is null or length(CH_TYPE)=0)");
					sql += "&sqls=" + encodeURIComponent("update nwh.DOUBLE_IMEI_CFG_TMP set flag='TAC码重复' where task_id='" + taskId 
						+ "' and id in (select id from (select id, tac_code,row_number() over(partition by tac_code order by tac_code) as row_num from nwh.DOUBLE_IMEI_CFG_TMP where flag='suc')  where row_num >1)");
				var saveAjax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql+"&ds=dw"
						,loadmask : false
						,callback : function(xmlrequest){
							
							var repeSql = "select tac_code from NWH.DOUBLE_IMEI_CFG_TMP where flag='suc' and task_id='" + taskId + "' and tac_code in (select tac_code from NWH.DOUBLE_IMEI_CFG)";
							var repeAjax = new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/jsondata?method=query"
									,parameters : "sql="+strEncode(repeSql)+"&isCached=false"+"&ds=dw"
									,loadmask : true
									,callback : function(xmlrequest){
										var result = xmlrequest.responseText;
										result = eval(result);
										
										if(result != null && result.length > 0){
											var repeStr = "";
											var tcode = "";
											for(var i =0; i<result.length; i++){
												if(i != 0){
													repeStr += "、";
													tcode += ",";
												}
												repeStr += result[i].tac_code;
												tcode += "'" + result[i].tac_code + "'";
											}
											var repeUpSql = "";
											if(confirm("表中已包含TAC码：" +  repeStr + "数据，是否更新已有数据？")){
												repeUpSql = encodeURIComponent("delete from NWH.DOUBLE_IMEI_CFG where tac_code in (" + tcode + ")");
											}else{
												repeUpSql = encodeURIComponent("update NWH.DOUBLE_IMEI_CFG_TMP set flag='TAC码重复' where tac_code in (" + tcode + ")");
											}
											
											var rAjax = new aihb.Ajax({
												url : "${mvcPath}/hbirs/action/sqlExec"
													,parameters : "sqls="+repeUpSql+"&ds=dw"
													,loadmask : false
													,callback : function(xmlrequest){
														insertT();
													}
											});
											rAjax.request();
										}else{
											insertT();
										}
									}
							});
							repeAjax.request();
							
						}
				});
				saveAjax.request();
			};
		};
		
		function insertT(){
			//查询导入成功和失败条数
			var cntSql = "select sum(case when flag='suc' then 1 else 0 end) succnt, sum (case when flag!= 'suc' then 1 else 0 end) failcnt from nwh.double_imei_cfg_tmp where task_id='" + taskId + "'";
			var cntAjax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/jsondata?method=query"
					,parameters : "sql="+strEncode(cntSql)+"&isCached=false"+"&ds=dw"
					,loadmask : true
					,callback : function(xmlrequest){
						var result = xmlrequest.responseText;
						result = eval(result);
						if(!result || (!result[0].succnt && !result[0].failcnt)){
							alert("导入失败，请查询数据是否正确");
							return;
						}	
						
						//导入正式表，删除临时表中成功数据
						var insertSql = encodeURIComponent("insert into nwh.double_imei_cfg select time_id, terminal_standard, tac_code, is_support, ch_type, '" + userId + "' from nwh.double_imei_cfg_tmp where task_id='" + taskId + "' and flag='suc'");
							insertSql += "&sqls=" + encodeURIComponent("delete from nwh.double_imei_cfg_tmp where task_id='" + taskId + "' and flag ='suc'");
						
						var insertAjax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
								,parameters : "sqls="+insertSql+"&ds=dw"
								,loadmask : false
								,callback : function(xmlrequest){
									alert("导入成功" + result[0].succnt + "条，失败" + result[0].failcnt + "条");
								}
						});
						insertAjax.request();
					}
			});
			cntAjax.request();
		}
				
		
		var header = [
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"time_id",
		            	  "name":["导入日期"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"terminal_standard",
		            	  "name":["终端制式"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"tac_code",
		            	  "name":["TAC码"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"is_support",
		            	  "name":["是否支持双卡双待"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"ch_type",
		            	  "name":["支持串号类型"],
		            	  "title":"",
		            	  "cellFunc":""
		              }
		              ];
		var header1 = [
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"time_id",
		            	  "name":["导入日期"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"terminal_standard",
		            	  "name":["终端制式"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"tac_code",
		            	  "name":["TAC码"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"is_support",
		            	  "name":["是否支持双卡双待"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"ch_type",
		            	  "name":["支持串号类型"],
		            	  "title":"",
		            	  "cellFunc":""
		              },
		              {
		            	  "cellStyle":"grid_row_cell_number",
		            	  "dataIndex":"flag",
		            	  "name":["失败原因"],
		            	  "title":"",
		            	  "cellFunc":""
		              }
		              ];
		
		function genSQL(){
			var sql = "select time_id, terminal_standard, tac_code, is_support, ch_type from  nwh.double_imei_cfg where 1=1";
			if($("choice").value != "" && $("choice").value == '1'){
				if($("date1").value != null && $("date1").value != "") {
					sql += " and time_id like '%" + $("date1").value + "%'";
				}
			}else if($("choice").value != "" && $("choice").value == '2'){
				if($("date2").value != null && $("date2").value != "") {
					sql += " and time_id like '%" + $("date2").value + "%'";
				}
			}
			
			if($("terminal_standard").value != null && $("terminal_standard").value != "") {
				sql += " and terminal_standard like '%" + $("terminal_standard").value + "%'";
			}
			
			return sql;
		}
		
		function query(){
			var grid = new aihb.AjaxGrid({
				header:header
				,ds:"dw"
				,isCached : false
				,sql: genSQL()
			});
			grid.run();
		}
		
		function down(){
			aihb.AjaxHelper.down({
				sql : genSQL()
				,header : header
				,ds:"dw"
				,isCached : false
				,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
				,form : document.tempForm
			});
		};
		
		function getFalseSql(){
			var sql = "select time_id, terminal_standard, tac_code, is_support, ch_type, flag from  nwh.double_imei_cfg_tmp where flag!='suc'";
			if($("choice").value != "" && $("choice").value == '1'){
				if($("date1").value != null && $("date1").value != "") {
					sql += " and time_id like '%" + $("date1").value + "%'";
				}
			}else if($("choice").value != "" && $("choice").value == '2'){
				if($("date2").value != null && $("date2").value != "") {
					sql += " and time_id like '%" + $("date2").value + "%'";
				}
			}
			
			if($("terminal_standard").value != null && $("terminal_standard").value != "") {
				sql += " and terminal_standard like '%" + $("terminal_standard").value + "%'";
			}
			
			return sql;
		}
		
		function queryForFalse(){
			var grid = new aihb.AjaxGrid({
				header:header1
				,ds:"dw"
				,isCached : false
				,sql: getFalseSql()
			});
			grid.run();
		}
		
		function downForFalse(){
			aihb.AjaxHelper.down({
				sql : getFalseSql()
				,header : header1
				,ds:"dw"
				,isCached : false
				,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
				,form : document.tempForm
			});
		};
		
		
		window.onload=function(){
			aihb.Util.loadmask();
			showPanel();
			var _d=new Date();
			var hours = _d.getHours();
			$("queryBtn").onclick = query;
			$("downBtn").onclick = down;
			$("queryBtn1").onclick = queryForFalse;
			$("downBtn1").onclick = downForFalse;
		};
		}(window,document);
		
		function changeDateFormat(s){
			if(s=='1'){
				$("date1").style.display="block";
				$("date2").style.display="none";
				$("date2").value = "";
			}else if(s=='2'){
				$("date2").style.display="block";
				$("date1").style.display="none";
				$("date1").value = "";
			}
		};
	</script>
</body>
</html>