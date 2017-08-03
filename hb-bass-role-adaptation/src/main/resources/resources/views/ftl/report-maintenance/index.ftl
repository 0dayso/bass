<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>湖北移动经营分析系统</title>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/jquery-easyui-1.5/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/jquery-easyui-1.5/themes/icon.css">
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/jquery.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/locale/easyui-lang-zh_CN.js"></script>
	<style type="text/css">
		form table{
			margin: 20px;
		}
		form table tr{
			margin: 5px;
		}
	</style>
</head>
<body>
<div>
		<table style="width: 100%;">
			<tr>
				<td><span>指标ID:</span></td>
				<td><input id="q_reportId" type="text" class="easyui-textbox"></input>
				</td>
				<td><span>指标名称:</span></td>
				<td><input id="q_reportName" type="text" class="easyui-textbox"></input>
				<td><span>后台程序名:</span></td>
				<td><input id="q_procedureName" type="text" class="easyui-textbox"></input>
				<td><span>开发人员:</span></td>
				<td><input id="q_developerName" type="text" class="easyui-textbox"></input>
			</tr>
			<tr>
				<td><span>负责人:</span></td>
				<td><input id="q_manager" type="text" class="easyui-textbox"></input>
				</td>
				<td><span>重要级别:</span></td>
				<td><input class="easyui-combobox" name="q_level" id="q_level" style="width:130px"></input>
				<td><span>是否云化上线:</span></td>
				<td><input class="easyui-combobox" name="q_online" id="q_online" style="width:130px"></input>
				<td><span>是否交维:</span></td>
				<td><input class="easyui-combobox" name="q_maintenance" id="q_maintenance" style="width:130px"></input>
			</tr>
			<tr>
				<td colspan="8">
					<div style="float: right;margin-right: 90px;">
						<button id="query">查询</button>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table id="reportMaintenance"></table>
	</div>
 	<div id="addReportWind" class="easyui-dialog" style="width:600px;height:400px">
 			<input type="hidden" id="mvcPath" name="mvcPath" value="${mvcPath}">
			<form action="" method="post">
				<input type="hidden" id="id" name="id" value="">
				<table>
					<tr>
						<td class="width=250px;text-align:right;"><label for="reportId">报表ID: </label></td>
						<td><input class="easyui-textbox" name="reportId" id="reportId" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="reportName">报表名称: </label></td>
						<td><input class="easyui-textbox" name="reportName" id="reportName" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="procedureName">后台程序名: </label></td>
						<td><input class="easyui-textbox" name="procedureName" id="procedureName" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="developerName">开发人员: </label></td>
						<td><input class="easyui-textbox" name="developerName" id="developerName" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="manager">负责人: </label></td>
						<td><input class="easyui-textbox" name="manager" id="manager" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="level">重要级别: </label></td>
						<td><input class="easyui-combobox" name="level" id="level" style="width:200px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="online">是否云化上线: </label></td>
						<td><input class="easyui-combobox" name="online" id="online" style="width:100px"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="maintenance">是否交维: </label></td>
						<td><input class="easyui-combobox" name="maintenance" id="maintenance"><td>
					</tr>
					<tr>
						<td class="width=250px;text-align:right;"><label for="expectationDate">期望时间: </label></td>
						<td><input class="easyui-datebox" name="expectationDate" id="expectationDate" style="width:100px"><td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript" src="${mvcPath}/resources/js/report-maintenance.js"></script>

</body>
</html>


