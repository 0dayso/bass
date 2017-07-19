<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
	<head>
		<title>湖北移动经营分析系统-积分兑换数据导入</title>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
					<td width="450"><div id="uploadDiv"></div></td>
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=积分兑换数据导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div>导入说明：</div>
						<div>1.产品类只能是'实物类','话费类','电子类','合作类','其他自有类'</div>
						<div>2.奖品id不能重复</div>
						<div>3.导入完成后会自动展示导入失败的记录，如果没有失败记录则全部导入成功</div>
					</td>
				</tr>
			</table>
		</fieldset>
		<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title'>导入日期</td>
						<td class='dim_cell_content'>
							<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
						</td>
						
						<td class='dim_cell_title'>操作</td>
						<td class='dim_cell_content'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="导入数据查询"/>&nbsp;
								<input type="button" id="downBtn" class="form_button" style="width: 100px" value="导入数据下载">&nbsp;
								<input type="button" id="downBtn1" class="form_button"  style="width: 100px" value="导入失败数据下载"/>&nbsp;
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
	<script type="text/javascript">
		var userId = '<%=user.getId()%>';
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
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
					vault.setFormField("tableName", "NWH.PC_JF_HD_temp");
					vault.setFormField("columns", "taskid,prodid, prodname, privid, privname, rewardid, rewardname, prod_type");
					vault.setFormField("date", taskId);
					vault.setFormField("ds","dw");
					vault.onUploadComplete = function(files) {
						//删除第一行非法数据
						var sql = encodeURIComponent("delete from NWH.PC_JF_HD_temp where prodid='产品ID'");
						//标记非法数据
						sql+="&sqls=" +	encodeURIComponent("update NWH.PC_JF_HD_temp a set flag='1' where  taskid='" + taskId + "' and (prod_type not in('实物类','话费类','电子类','合作类','其他自有类') or exists(select 1 from NWH.PC_JF_HD b where b.prodid=a.prodid and b.privid=a.privid and b.rewardid=a.rewardid ))");
						sql+="&sqls=" +	encodeURIComponent("insert into NWH.PC_JF_HD select prodid, prodname, privid, privname, rewardid, rewardname, prod_type,taskid,current timestamp from  NWH.PC_JF_HD_temp where  taskid='" + taskId + "' and flag='0' ");
			    		sql+="&sqls=" +encodeURIComponent("delete from NWH.PC_JF_HD_temp where taskid='" + taskId + "' and flag='0' ");
						var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql+"&isCached=false"+"&ds=dw"
						,loadmask : false
						,callback : function(xmlrequest){
							alert("导入完成请查看未导入成功的记录");
							loadmask.style.display="none";
							query1();
						}
					});
						ajax.request();
					}//end onUploadComplete
				};
				var _header= [
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"prodid",
					"name":["产品id"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"prodname",
					"name":["产品名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell",
					"dataIndex":"privid",
					"name":["兑换策略id"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"privname",
					"name":["兑换策略名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"rewardid",
					"name":["奖品id"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"rewardname",
					"name":["奖品名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"prod_type",
					"name":["产品类型"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"import_date",
					"name":["导入日期"],
					"title":"",
					"cellFunc":""
				}];
				function genSQL() {
					var	sql = "select prodid, prodname, privid, privname, rewardid, rewardname, prod_type,import_date FROM NWH.PC_JF_HD where 1=1 " + ($("date1").value ? " and date(IMPORT_DATE)='" + $("date1").value + "'" : "");	
					return sql;
				}
				function genSQL1() {
					var sql = "select prodid, prodname, privid, privname, rewardid, rewardname, prod_type FROM NWH.PC_JF_HD_temp where taskid ='"+taskId+"' and flag='1' " ;	
					return sql;
				}
				function query(){
					var grid = new aihb.AjaxGrid({
						header:_header
						,isCached : false
						,ds:"dw"
						,sql: genSQL()
					});
					grid.run();
				}
				function query1(){
					var grid = new aihb.AjaxGrid({
						header:_header
						,isCached : false
						,ds:"dw"
						,sql: genSQL1()
					});
					grid.run();
				}
				function down(){
					aihb.AjaxHelper.down({
						sql : genSQL()
						,header : _header
						,isCached : false
						,ds:"dw"
						,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
						,form : document.tempForm
					});
				}
				function down1(){
					//剩下的都是导入失败的数据
					aihb.AjaxHelper.down({
						sql : genSQL1()
						,header : _header
						,isCached : false
						,ds:"dw"
						,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
						,form : document.tempForm
					});
				}
				window.onload=function(){
					aihb.Util.loadmask();
					showPanel();
					$("queryBtn").onclick = query;
					$("downBtn").onclick = down;
					$("downBtn1").onclick = down1;
				}
			}(window,document);
		</script>
	</body>
</html>