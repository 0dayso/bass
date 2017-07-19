<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    
    <title>流量产品评估</title>
    <link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/chart/FusionCharts.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/app/flowOperation/gprsAssessment/css/stFlowproduct.css" />
		<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/app/flowOperation/gprsAssessment/js/stFlowproduct.js" charset=utf-8></script>	
  </head>
  
  <body>
		<div id="gprsAssessment">
			<div class="header">
				<div id="dim_div">
					<table align='center' width='960px' class='grid-tab-blue'
						cellspacing='1' cellpadding='0' border='0' style="display: ''">
						<tr class='dim_row'>
							<td class=''>统计周期</td>
							<td class='' >
								<input align="right" type="text" id="time_id" name="time_id"  style="width:100px" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
							</td>
							<td class=''>
								地市
							</td>
							<td class=''>
								<select name='area_code' id='area_code'  style="width: 100px" onChange="changeArea()">
									<option value="" >
										全省
									</option>
								</select>
							</td>
							<td class=''>
								县域
							</td>
							<td class=''>
								<select name='county_code' id='county_code'  onchange="changeCounty()" style="width: 100px">
									<option value="" >
										请选择地市
									</option>
								</select>
							</td>
							
							<td class=''>
								营销中心
							</td>
							<td class=''>
								<select name='zone_code' id='zone_code'  style="width: 100px">
									<option value="" >
										请选择县域
									</option>
								</select>
							</td>
							<td class=''>
								业务类型
							</td>
							<td class=''>
								<select name='fee_id' id='fee_id' style="width: 200px">
									<option value="" >
										请选择
									</option>
								</select>
							</td>
							
							<td>
								<input type="button"  type="button" id="queryBtn" class="form_button" value="查询">
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="bodyStyle">
				<div class="orderDiv">
					<div class="orderTitle"><h2>用户规模</h2></div>
					<hr>
					<div class="orderLeft"  id="orderUserchart"></div>
					<div class="orderCenter"  id="orderNewchart"></div>
					<div class="orderRight" id="avaFlowchart"></div>
				</div>
				<div class="chargeDiv" >
					<div class="chargeTitle"><h2>收益</h2></div>
					<hr>
					<div class="chargeLeft" id="chargeFlowchart"></div>
					<div class="chargeCenter" id="FlowMouchart"></div>
					<div class="chargeRight"  id="FlowUsechart"></div>
				</div>
				<div class="reportDivTitle"><h1>相关报表</h1></div>
				<hr>
				<div class="reportDiv" >
				<table align='center' width='960px' class='grid-tab-blue'>
					<tr>
						<td align='center'><a href=http://10.25.124.29/mvc/report/6393>GPRS按照业务代码统计流量<br></td>
						<td align='center'><a href=http://10.25.124.29/mvc/report/4051>手机上网<br></td>
						<td align='center'><a href=http://10.25.124.29/mvc/report/4045>手机报付费用户数统计表<br></td>
					</tr>
					<tr>
						<td align='center'><a href=http://10.25.124.29/mvc/report/4047>手机游戏<br></td>
						<td align='center'><a href=http://10.25.124.29/mvc/report/4046>手机电视<br></td>
						<td align='center'><a href=http://10.25.124.29/mvc/report/4207>号簿管家业务套餐统计<br></td>
					</tr>
				</table>
				</div>
			</div>
		</div>
	</body>
</html>
