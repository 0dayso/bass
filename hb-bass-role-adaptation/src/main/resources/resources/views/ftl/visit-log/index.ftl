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
</head>
<body>
<div>
		<input type="hidden" id="mvcPath" name="mvcPath" value="${mvcPath}">
		<table style="width: 100%;">
			<tr>
				<td><span>地市:</span></td>
				<td><input class="easyui-combobox" name="cityList" id="cityList" data-options="editable:false"></input>
				</td>
				<td><span>开始日期:</span></td>
				<td><input id="q_startDate" class="easyui-datebox" data-options="editable:false"></input>
				<td><span>结束日期:</span></td>
				<td><input id="q_endDate"  class="easyui-datebox" data-options="editable:false,validType:'equaldDate[\'#q_startDate\']'"></input>
			</tr>
			
			<tr>
				<td colspan="6">
					<div style="float: right;">
						<button id="query">查询</button>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table id="visitLogList" style="height:360px;"></table>
	</div>
	<script type="text/javascript" src="${mvcPath}/resources/js/visit-log.js"></script>

</body>
</html>


