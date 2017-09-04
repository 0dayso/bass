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
		
		.td_label{
			text-align:right;
			float:right;
			margin-top:15px;
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
				<td><input class="easyui-combobox" name="q_level" id="q_level"></input>
				<td><span>是否云化上线:</span></td>
				<td><input class="easyui-combobox" name="q_online" id="q_online"></input>
				<td><span>是否交维:</span></td>
				<td><input class="easyui-combobox" name="q_maintenance" id="q_maintenance"></input>
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
		<table id="reportMaintenance" style="height:360px;"></table>
	</div>
 	<div id="addReportWind" class="easyui-dialog" style="width:600px;height:400px">
 			<input type="hidden" id="mvcPath" name="mvcPath" value="${mvcPath}">
			<form action="" method="post">
				<input type="hidden" id="id" name="id" value="">
				<table>
					<tr>
						<td class="width:120px;"><label for="reportId" class="td_label">报表ID: </label></td>
						<td><input class="easyui-textbox" name="reportId" id="reportId" style="width:200px">
						<td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="reportName" class="td_label">报表名称: </label></td>
						<td><input class="easyui-textbox" name="reportName" id="reportName" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="procedureName" class="td_label">后台程序名: </label></td>
						<td><input class="easyui-textbox" name="procedureName" id="procedureName" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="developerName" class="td_label">开发人员: </label></td>
						<td><input class="easyui-textbox" name="developerName" id="developerName" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="manager" class="td_label">负责人: </label></td>
						<td><input class="easyui-textbox" name="manager" id="manager" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="level" class="td_label">重要级别: </label></td>
						<td><input class="easyui-combobox" name="level" id="level" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="online" class="td_label">是否云化上线: </label></td>
						<td><input class="easyui-combobox" name="online" id="online" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="maintenance" class="td_label">是否交维: </label></td>
						<td><input class="easyui-combobox" name="maintenance" id="maintenance" style="width:200px"><td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
					<tr>
						<td colspan="3">
							时间格式: &nbsp;&nbsp;&nbsp;&nbsp;时:分<input type="radio" name="type" value="0" />&nbsp;&nbsp;
							日<input type="radio" name="type" value="1" />&nbsp;&nbsp;
							日 时:分<input type="radio" name="type" value="2" />&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="width:120px;"><label for="expectationDate" class="td_label">期望时间: </label></td>
						<td>
							<div id="date_div0" style="display: none;">
								<input id="time0" class="easyui-timespinner" style="width:80px;" required="required" data-options="min:'08:30',showSeconds:false" />
							</div>
							<div id="date_div1" style="display: none;">
								<select id="time1" class="easyui-combobox" name="dept" style="width:50px;">  
								    <option value="1">1</option>  
								    <option value="2">2</option>  
								    <option value="3">3</option>  
								    <option value="4">4</option>  
								    <option value="5">5</option> 
								    <option value="6">6</option> 
								    <option value="7">7</option> 
								    <option value="8">8</option> 
								    <option value="9">9</option> 
								    <option value="10">10</option> 
								    <option value="11">11</option> 
								    <option value="12">12</option> 
								    <option value="13">13</option> 
								    <option value="14">14</option> 
								    <option value="15">15</option> 
								    <option value="16">16</option> 
								    <option value="17">17</option> 
								    <option value="18">18</option> 
								    <option value="19">19</option> 
								    <option value="20">20</option> 
								    <option value="21">21</option> 
								    <option value="22">22</option> 
								    <option value="23">23</option> 
								    <option value="24">24</option> 
								    <option value="25">25</option> 
								    <option value="26">26</option> 
								    <option value="27">27</option> 
								    <option value="28">28</option> 
								    <option value="29">29</option> 
								    <option value="30">30</option>  
								    <option value="31">31</option>  
								</select>  
							</div>
							<div id="date_div2" style="display: none;">
								<input id="time2" class="easyui-datetimebox" data-options="formatter:monthFormat,showSeconds:false" style="width:150px;"  />
							</div>
						<td>
						<td><span style="color:red;">*必填项</span></td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript" src="${mvcPath}/resources/js/report-maintenance.js"></script>

</body>
</html>


