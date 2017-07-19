<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
	<head>
		<title>湖北移动经营分析系统-IMEI剔除拆包数据导入</title>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/des.js" charset=utf-8></script>
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
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=非定制终端导入模版.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div>导入说明：</div>
						<div>1.除终端品牌外所有导入项不能为空；</div>
						<div>2.tac码、机型名称同时重复时做修改操作不做新增操作；</div>
						<div>3.入库时间导入项格式为：YYYYMMDD；</div>
						<div>4.导入项中终端制式的值只能为2G、3G、4G；</div>
						<div>5.导入项中tac需进行验证，仅8位，具体数值不做要求；</div>
						<div>6.如果在导入过程中出现故障，请联系张韬(13986023266)</div>
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
							<input align="right" type="text" style="display:none;" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" class="Wdate"/>
							<input align="right" type="text" id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
						</td>
						<td class='dim_cell_title'>供应商名称</td>
						<td class='dim_cell_content4'>
							<input align="right" type="text" id="supplier" name="supplier"/>		
						</td>
						<td class='dim_cell_title'>终端机型</td>
						<td class='dim_cell_content4'>
							<input align="right" type="text" id="phone_model" name="phone_model"/>
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title'>终端制式</td>
						<td class='dim_cell_content4'>
							<select name="terminal_standard" id="terminal_standard">
								<option value="" selected>全部</option>
								<option value="2G">2G</option>
								<option value="3G">3G</option>
								<option value="4G">4G</option>
							</select>
						</td>
						<td class='dim_cell_title'></td>
						<td class='dim_cell_title'>操作</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="导入数据查询"/>&nbsp;
								<input type="button" id="downBtn" class="form_button" style="width: 100px" value="导入数据下载">&nbsp;
							</div>
						</td>
						<td class='dim_cell_content4'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn1" class="form_button"  style="width: 100px" value="导入未成功数据查询"/>&nbsp;
								<input type="button" id="downBtn1" class="form_button" style="width: 100px" value="导入未成功数据下载">&nbsp;
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
					vault.setFormField("tableName", "NWH.PARAMENTER_UPLOAD_TEMP");
					vault.setFormField("columns", "TASK_ID,SER_NO,SUPPLIER,STORAGE,PHONE_MODEL,TAC,TERMINAL_STANDARD,TERMINAL_TYPE, STORAGE_DATE");
					vault.setFormField("date", taskId);
					vault.setFormField("ds", "web");
					vault.onUploadComplete = function(files) {
						alert("数据正在后台导入,无需重复导入 ! \r\n请半个小时后在此页面查询已导入数据，点击 未导入成功号码按钮查询未成功导入数据!");
						this.removeAllItems();
						loadmask.style.display="none";
						var sql=encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag='succ' where task_id='" + taskId + "'");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '供应商名称不能为空' where task_id = '"+taskId+"' and SUPPLIER is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '入库批次不能为空' where task_id = '"+taskId+"' and SER_NO is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '入库批次格式不对' where task_id = '"+taskId+"' and length(SER_NO)!=8");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '入库时间不能为空' where task_id = '"+taskId+"' and STORAGE_DATE is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '入库时间格式不对' where task_id = '"+taskId+"' and length(int(DATE(STORAGE_DATE)))=8");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '终端机型不能为空' where task_id = '"+taskId+"' and PHONE_MODEL is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '终端制式不能为空' where task_id = '"+taskId+"' and TERMINAL_STANDARD is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '终端类型不能为空' where task_id = '"+taskId+"' and TERMINAL_TYPE is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = 'TAC码不能为空' where task_id = '"+taskId+"' and TAC is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = '终端制式的值只能为2G、3G或者4G' where task_id = '"+taskId+"' and TERMINAL_STANDARD not in ('2G','3G','4G')");
						    sql+="&sqls="+encodeURIComponent("update NWH.PARAMENTER_UPLOAD_TEMP set flag = 'TAC码的长度仅为8位' where task_id = '"+taskId+"' and length(TAC) !=8");
						    sql+="&sqls="+encodeURIComponent("insert into NWH.PARAMENTER_UPLOAD (SER_NO,SUPPLIER,PHONE_MODEL,STORAGE,TERMINAL_STANDARD,TERMINAL_TYPE,TAC,STORAGE_DATE,USERID) select SER_NO,SUPPLIER,PHONE_MODEL,STORAGE,TERMINAL_STANDARD,TERMINAL_TYPE,TAC,STORAGE_DATE,'"+userId+"' from NWH.PARAMENTER_UPLOAD_TEMP where task_id ='"+taskId+"' and flag = 'succ'");
						    sql+="&sqls="+encodeURIComponent("delete FROM (SELECT SUPPLIER,PHONE_MODEL,IMPORT_DATE,ROW_NUMBER() OVER(PARTITION BY SUPPLIER,PHONE_MODEL ORDER BY PHONE_MODEL DESC) RN FROM NWH.PARAMENTER_UPLOAD) WHERE IMPORT_DATE <> char(date('"+data+"'))");
						    sql+="&sqls="+encodeURIComponent("delete from NWH.PARAMENTER_UPLOAD_TEMP where task_id='" + taskId + "' and flag='succ'");
						    var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql+"&ds=web"
							,loadmask : false
							,callback : function(xmlrequest){
								query();
							}
						});
						ajax.request();
						location.refresh();
					}
				};
				var _header= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"ser_no",
									"name":["导入批次"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"supplier",
									"name":["供应商名称"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"storage",
									"name":["终端品牌"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"phone_model",
									"name":["终端机型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"terminal_standard",
									"name":["终端制式"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"terminal_type",
									"name":["终端类型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"tac",
									"name":["TAC码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"storage_date",
									"name":["入库时间"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"import_date",
									"name":["导入日期"],
									"title":"",
									"cellFunc":""
								}
								];
								var header= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"ser_no",
									"name":["导入批次"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"supplier",
									"name":["供应商名称"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"storage",
									"name":["终端品牌"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"phone_model",
									"name":["终端机型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"terminal_standard",
									"name":["终端制式"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"terminal_type",
									"name":["终端类型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"tac",
									"name":["TAC码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"storage_date",
									"name":["入库时间"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"import_date",
									"name":["导入日期"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"flag",
									"name":["状态"],
									"title":"",
									"cellFunc":""
								}
				];
								function genSQL() {
									var sql = "";	
									sql = "select SER_NO, SUPPLIER, PHONE_MODEL, STORAGE, TERMINAL_STANDARD, TERMINAL_TYPE, TAC, STORAGE_DATE, IMPORT_DATE from NWH.PARAMENTER_UPLOAD WHERE  1=1 ";	
									if($("choice").value != "" && $("choice").value == '1'){
										if($("date1").value != null && $("date1").value != "") {
											sql += " and import_date like '%" + $("date1").value + "%'";
										}
									}else if($("choice").value != "" && $("choice").value == '2'){
										if($("date2").value != null && $("date2").value != "") {
											sql += " and import_date like '%" + $("date2").value + "%'";
										}
									}
									if($("supplier").value != null && $("supplier").value != "") {
										sql += " and supplier like '%" + $("supplier").value + "%'";
									}
									if($("phone_model").value != null && $("phone_model").value != "") {
										sql += " and phone_model like '%" + $("phone_model").value + "%'";
									}
									if($("terminal_standard").value != null && $("terminal_standard").value != "") {
										sql += " and terminal_standard like '%" + $("terminal_standard").value + "%'";
									}
									return sql;
								};
								function genSQLForDown() {
									var sql = "";					
									sql = "select SER_NO, SUPPLIER, PHONE_MODEL, STORAGE, TERMINAL_STANDARD, TERMINAL_TYPE, TAC, STORAGE_DATE, IMPORT_DATE, FLAG from NWH.PARAMENTER_UPLOAD_TEMP WHERE 1=1 ";	
									if($("choice").value != "" && $("choice").value == '1'){
										if($("date1").value != null && $("date1").value != "") {
											sql += " and import_date like '%" + $("date1").value + "%'";
										}
									}else if($("choice").value != "" && $("choice").value == '2'){
										if($("date2").value != null && $("date2").value != "") {
											sql += " and import_date like '%" + $("date1").value + "%'";
										}
									}
									if($("supplier").value != null && $("supplier").value != "") {
										sql += " and supplier like '%" + $("supplier").value + "%'";
									}
									if($("phone_model").value != null && $("phone_model").value != "") {
										sql += " and phone_model like '%" + $("phone_model").value + "%'";
									}
									if($("terminal_standard").value != null && $("terminal_standard").value != "") {
										sql += " and terminal_standard like '%" + $("terminal_standard").value + "%'";
									}
									return sql;
								};
								function query(){
									var grid = new aihb.AjaxGrid({
										header:_header
										,ds:"web"
										,isCached : false
										,sql: genSQL()
									});
									grid.run();
								};
								function down(){
									aihb.AjaxHelper.down({
										sql : genSQL()
										,header : _header
										,ds:"web"
										,isCached : false
										,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
										,form : document.tempForm
									});
								};
								function queryForFalse(){
									var grid = new aihb.AjaxGrid({
										header:header
										,ds:"web"
										,isCached : false
										,sql: genSQLForDown()
									});
									grid.run();
								};
								function downForFalse(){
									aihb.AjaxHelper.down({
										sql : genSQLForDown()
										,header : header
										,ds:"web"
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
									//if(hours>=14&&hours<=24){
										//aihb.Util.loadmask();
										//showPanel();
									//}else{
										//alert("导入时间为每日14：00-17：00其他时间不允许导入!");
								//s	}
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
				}else if(s=='2'){
					$("date2").style.display="block";
					$("date1").style.display="none";
				}
			};
		</script>
	</body>
</html>