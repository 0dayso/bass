<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>湖北移动经营分析系统</title>
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/jquery.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jquery-easyui-1.5/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/reports-seach.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/jquery-easyui-1.5/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/jquery-easyui-1.5/themes/icon.css">
</head>
<body>
	<input type="hidden" id="mvcPath" name="mvcPath" value="${mvcPath}">
	<input type="hidden" id="reportId" name="reportId" value="${reportId}">
	<input type="hidden" id="defaultDate" name="defaultDate" value="${defaultDate}">
	<input type="hidden" id="type" name="type" value="${type}">
	<div>
		<table style="width: 100%;">
			<tr>
				<td><span>统计周期:</span></td>
				<td><input id="kpi_date" type="text" class="easyui-datebox" required="required"></input>
				</td>
				<td><span>地市:</span></td>
				<td><input id="cityList" name="cityList"></td>
				<td><span>县市</span><input type="checkbox" id="countyX" name="countyX" value="1"> 细分</td>
				<td><input id="countyList" name="countyList"></td>
				<td></td><td></td>
				<!--
				<td><span>营销中心</span><input type="checkbox" id="marktingX" name="marktingX"> 细分</td>
				<td><input id="marketing_center" name="marketing_center" id="marketing_center"></td>-->
			</tr>
			<tr>
				<td colspan="8">
					<!--
					<input type="checkbox" name="compare_type" value="1"> 环比增长
					<input type="checkbox" name="compare_type" value="2"> 同比增长
					<input type="checkbox" name="compare_type" value="3"> 年同比增长-->
				</td>
			</tr>
			<tr>
				<td colspan="8">
					<div style="float: right;margin-right: 90px;"><button id="query">查询</button>
						<!--
						<button id="download">下载</button>-->
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table id="reportDataGrid"></table>
	</div>
</body>
</html>