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
		form div {
			margin-top: 10px;
		}
	</style>
</head>
<body>
 	<h1><div style="text-align: center;">自定义报表</div></h1>
 	<table id="customReports"></table>
 	<div id="addReportWind" class="easyui-dialog" title="My Window" style="width:600px;height:400px">
 			<input type="hidden" id="mvcPath" name="reportId" value="${mvcPath}">
			<form action="" method="post">
				<input type="hidden" id="reportId" name="reportId" value="">

				<div>
					<label for="reportName">报表名称: </label>
					<input class="easyui-textbox" name="reportName" id="reportName" style="width:200px">
				</div>
				<div>
					<label for="reportDesc">报表描述: </label>
					<input class="easyui-textbox" name="reportDesc" id="reportDesc" data-options="multiline:true" style="width:400px;height:100px">
				</div>
				<div>
					<input class="easyui-combobox" id="kpiApp" name="kpiApp" value="日指标" />
					<input class="easyui-combobox" id="kpiType" name="kpiType" value=""  />
				</div>
				<div>

					<table>
						<tr>
							<td>
								<select id="appValues" name="appValues" style="width: 220px;height: 125px;" multiple="multiple">
								</select>
							</td>
							<td>
								<table>
									<tr>
										<td>
											<input type="button" class="form_button_short" value="添加" onclick="moveOptionRight();">
										</td>
									</tr>
									<tr>
										<td>
											<INPUT onclick="moveOptionLeft();" class=form_button_short type=button value=删除>
										</td>
									</tr>
									
								</table>
							</td>
							<td>
								<select id="selectValues" name="selectValues" style="width: 220px;height: 125px;" multiple="multiple">
								</select>
							</td>
							<td>
								<table>
									<tr>
										<td>
											<INPUT onclick=moveUp(this.form.selectValues) class=form_button_short type=button value=上移>
										</td>
									</tr>
									<tr>
										<td>
											<INPUT onclick=moveDown(this.form.selectValues) class=form_button_short type=button value=下移>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</form>
		</div>
		<script type="text/javascript" src="${mvcPath}/resources/js/custom-report.js"></script>

</body>
</html>


