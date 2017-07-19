<%@ page language="java" pageEncoding="utf-8"%>
<%
	String method=request.getParameter("method");
	if("".equals(method)||null==method){
		method="fail";
	}
%>
<HTML>
	<HEAD>
		<TITLE>湖北移动经营分析系统-区域化未导入成功用户查看</TITLE>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<!--
	@author:yulei3
	@date:20120918
	@desc:对区域化暂未归属用户进一步个性化改造 前台导入数据
-->
	</head>
	<body bgcolor="#EFF5FB" margin=0>
	<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td>
								<img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
								&nbsp;操作区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div style="text-align:center;">
					<input type="button" id="queryBtn" onclick='down()' class="form_button"  style="width : 120px" value=""/>&nbsp;
					<input type="button" onclick='window.close();' class="form_button"  style="width : 120px" value="关闭窗口"/>
				</div>
			</fieldset>
		</div>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td>
								<img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="grid" style="display: none;"></div>
			</fieldset>
		</div>
		<form name="tempForm" action=""></form>
	</body>
	
	<script type="text/javascript">
		var etl_cycle_id=new Date().format("yyyyMMdd");
		var tableName="nmk.bureau_mbuser_nobelong_"+etl_cycle_id.substring(0,6);
		var method='<%=method%>';
		var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"mbuser_id",
					"name":["用户ID"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"acc_nbr",
					"name":["用户号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_name",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"county_code",
					"name":["区县编码"],
					"title":"",
					"cellFunc":""
				}
			];
		window.onload=function(){
			aihb.Util.loadmask();
			loadmask.style.display="";
			var sql="";
			if(method=="fail"){
				sql="select mbuser_id,acc_nbr,b.area_name,county_code from "+tableName+" a,nmk.cmcc_area b where a.area_code=char(b.new_code) and a.succ_flag='0' and a.etl_cycle_id="+etl_cycle_id;
				$("queryBtn").value="未成功号码下载";
			}else{
				sql="select mbuser_id,acc_nbr,b.area_name,county_code from "+tableName+" a,nmk.cmcc_area b where a.area_code=char(b.new_code) and a.succ_flag='1' and a.etl_cycle_id="+etl_cycle_id;
				$("queryBtn").value="成功号码下载";
			}
			var grid = new aihb.SimpleGrid({
					header:_header
					,sql: sql
					,isCached : false
				});
				grid.run();
		}
		function down(){
				aihb.AjaxHelper.down({
					sql : sql
					,header : _header
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
		}
	</script>
	
</html>
