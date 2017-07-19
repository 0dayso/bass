<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common.SQLSelect"%>
<%
// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	

%>
<%-- 
	copied from busiComplain.jsp
	refer sql :
	select area_id,county_id,channel_id,count(*),count(*),sum(case when result in ('1','2') then 1 else 0 end),count(*)/count(*),decimal(sum(case when result in ('1','2') then 1 else 0 end)*1.0000/count(*),6,4)
from NWH.CS_SATISFY_SMS
group by area_id,county_id,channel_id
	还有点数据问题，董勇说先上线 2009.12.30
--%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH,-1);//昨天
	DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	String day1 = formater.format(cal.getTime());
%>
<html>
	<HEAD> 
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>营业厅短信评测满意度分析</title>
		<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
		<script type="text/javascript" src="../js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="../ngbass/js/common.js"></script>
<script type="text/javascript">
	var condition;
	function doSubmit(sortNum)
	{	
		var groupByPart = "";
		var titleDiv = titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
			 	+"<tr class='grid_title_blue'>"
		
		var var1 = 2;
		with(document.forms[0]) {
			var startDate = date1.value;
			var endDate = date2.value;
			
			/* 分组，筛选区域 */
			if(startDate > endDate) {
				alert("开始日期不能大于截止日期。");
				return;
			}
			/*
			if(startDate.substr(4,2)!= endDate.substr(4,2)) {
				alert("暂不支持跨月查询，请重新选择日期。");
				return;
			}
			*/
			condition = " substr(char(sms_date),1,10) >='" + startDate + "' and substr(char(sms_date),1,10) <='" + endDate + "'"  ;
			/*if(city.value != "0") {
				condition += " and area_id='" + city.value + "'";
				country_detail.checked = "true";
			} else {
				//全省
				groupByPart = "area_id,";
				titleDiv += "<td class='grid_title_cell'>地市</td>";
			}
			
			if(country.value) {
				condition += " and county_id='" + country.value + "'";
				channel_detail.checked = "true";
			}
			if(channel_code.value) {
				condition += " and channel_id='" + channel_code.value + "'";
				channel_detail.checked = "true";
			}
			if(channel_detail.checked) {
				groupByPart += "county_id,channel_name ";
				titleDiv += "<td class='grid_title_cell'>县市</td>"
				 + "<td class='grid_title_cell'>渠道</td>";
			} else if(country_detail.checked) {
				groupByPart = "area_id,county_id";
				titleDiv += "<td class='grid_title_cell'>地市</td>" + 
				"<td class='grid_title_cell'>县市</td>";
			}
			*/
			if(channel_detail.checked) {
				/*
				//1. 冻结县市
				country.selectedIndex = 0;
				country.disabled = "true";
				//2. 冻结渠道
				channel_code.selectedIndex = 0;
				channel_code.disabled = "true";
				*/
				if(city.value != "0") {
					groupByPart = "county_id,channel_name";
					condition += " and area_id='" + city.value + "'";
					titleDiv += "<td class='grid_title_cell'>县市</td>" + 
				"<td class='grid_title_cell'>渠道</td>" ;
				} else {
					var1 = 3;
					groupByPart = "area_id,county_id,channel_name";
					titleDiv += "<td class='grid_title_cell'>地市</td>" + 
				"<td class='grid_title_cell'>县市</td>" + 
				"<td class='grid_title_cell'>渠道</td>";
				}
			} else if(country_detail.checked) {
				groupByPart = "area_id, county_id";
				titleDiv += "<td class='grid_title_cell'>地市</td>" + 
				"<td class='grid_title_cell'>县市</td>"; 
			} else {
				if(channel_code.value) {
					condition += " and channel_id='" + channel_code.value + "' and county_id='" + country.value + "' and area_id='" + city.value + "'";
					groupByPart = "county_id, channel_name";
					titleDiv += "<td class='grid_title_cell'>县市</td>" + 
					"<td class='grid_title_cell'>渠道</td>"; 
				} else if(country.value) {
					condition += " and county_id='" + country.value + "' and area_id='" + city.value + "'";
					groupByPart = "county_id, channel_name";
					titleDiv += "<td class='grid_title_cell'>县市</td>" + 
					"<td class='grid_title_cell'>渠道</td>"; 
				} else if(city.value != "0") {
					groupByPart = "area_id,county_id";
					condition += " and area_id='" + city.value + "'";
					titleDiv += "<td class='grid_title_cell'>地市</td>" + 
					"<td class='grid_title_cell'>县市</td>" ;
				} else {
					//全省-默认细分至地市
					var1 = 1;
					groupByPart = "area_id";
					titleDiv += "<td class='grid_title_cell'>地市</td>"; 
				}
			}
		}
			//收尾								
		titleDiv += "<td class='grid_title_cell'><a onclick='window.open()'>触发量</a></td>"
				+ "<td class='grid_title_cell'>参与量</td>"
				+ "<td class='grid_title_cell'>满意量</td>"
				//不要这个+ "<td class='grid_title_cell'>触发率</td>"
				+ "<td class='grid_title_cell'>参与率</td>"
				+ "<td class='grid_title_cell'>满意率</td>";	
				+ "</tr></table>";
		
		for(var i = 0; i < var1 + 6; i ++) {
				if(i < var1) {
					cellclass[i]="grid_row_cell_text";
					cellfunc[i] = undefined;
				} else {
					cellclass[i]="grid_row_cell_number";
					cellfunc[i] = numberFormatDigit2;
				}
				if(i>=var1 + 3)
					cellfunc[i] = percentFormat;
		}
		
		
		//董勇说触发量就是参与量(count(*))
		var constantPart = ",count(*),count(*),sum(case when result in ('1','2') then 1 else 0 end)," + 
			"(case when count(*) != 0 then decimal(count(*),16,2)/count(*) else 0 end)," +//参与率= 参与量/触发量 + 
			"(case when count(*) != 0 then (decimal((sum(case when result in ('1','2') then 1 else 0 end)),16,2)/count(*)) else 0 end)";//满意率= 满意量/参与量;
		var _table = " NWH.CS_SATISFY_SMS a";
		var sql = " select " + groupByPart.replace("area_id","(select dim.itemname from mk.dim_areacity dim where dim.itemid=a.area_id)").replace("county_id","(select dim.county_name from MK.BT_AREA_ALL dim where dim.county_code=a.county_id)") + constantPart +  
				  " from " + _table +  
				  " where " + condition + 
				  " group by " + groupByPart ;
		document.form1.sql.value = sql;
		document.getElementById("title_div").innerHTML = titleDiv;
		ajaxSubmitWrapper(sql + " with ur");
	}
	
	function areacombo(i,sync){		
		selects = new Array();
		selects.push(document.forms[0].city);
		sqls = new Array();
		if(document.forms[0].country != undefined)
		{
			selects.push(document.forms[0].country);
			sqls.push("select distinct county_code,county_name from MK.BT_AREA_ALL where area_code='#{value}' order by 1 with ur");
		}  
		if(document.forms[0].channel_code != undefined)
		{
			selects.push(document.forms[0].channel_code);
			sqls.push("select distinct channel_id,channel_name from NWH.CS_SATISFY_SMS where county_id='#{value}' order by 1 with ur");
		}
		
		var bl = false;
		if(sync!=undefined)bl=sync;
		combolink(selects,sqls,i,bl);
	}
	function setDisable(evt) {
		with(document.forms[0]) {
			if(country_detail.checked) {
				city.selectedIndex = 0;
				city.disabled = true;
				country.selectedIndex = 0;
				country.disabled = true;
				channel_code.selectedIndex = 0;
				channel_code.disabled = true;
			} else if(channel_detail.checked) {
				city.disabled = false;
				country.selectedIndex = 0;
				country.disabled = true;
				channel_code.selectedIndex = 0;
				channel_code.disabled = true;
			} else {
				city.disabled = false;
				country.disabled = false;
				channel_code.disabled = false;
			}
				
		}
	}

 </script>
	<HEAD>
	<body>
		<form name="form1" method="post" action="">
			<div id="hidden_div">
				<input type="hidden" id="allPageNum" name="allPageNum" value="">
				<input type="hidden" id="sql" name="sql" value="">
				<input type="hidden" name="filename" value="">
				<input type="hidden" name="order" value="">
				<input type="hidden" name="title" value="">
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div')"
									title="点击隐藏">
									<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align="center" width="99%" class="grid-tab-blue"
							cellspacing="1" cellpadding="0" border="0">
								<tr class="dim_row">
								<td class="dim_cell_title" align="left">&nbsp;起始日期(>=)</td>
								<td class="dim_cell_content">
									<input type="text" value='<%=day1 %>' id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
							 	</td>
							 	
							 	<td class="dim_cell_title" align="left">&nbsp;结束日期(<=)</td>
								<td class="dim_cell_content" colspan="3">
									<input type="text" value='<%=day1 %>' id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
							 	</td>
							 	<%-- 
							 	<td class="dim_cell_title">&nbsp;地市</td>
				 			<td class="dim_cell_content" >
							<%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>	
							</td>
							--%>
							</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">&nbsp;地市</td>
				 			<td class="dim_cell_content" >
							<%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%>	
							</td>
							
							<td class="dim_cell_title">&nbsp;县市</td>
				 			<td class="dim_cell_content" >
							<%=QueryTools2.getCountyHtml("country","areacombo(2)")%>	
							</td>
							
							<td class="dim_cell_title">&nbsp;渠道</td>
				 			<td class="dim_cell_content" >
				 				<select name="channel_code" class="form_select">
				 					<option value="">全部</option>
				 				</select>
				 				<script type="text/javascript" defer="defer">
				 					areacombo(2);
				 				</script>
							</td>
								</tr>
								<tr class="dim_row">
								<td class="dim_cell_title">&nbsp;细分至: </td>
									<td class="dim_cell_content" colspan="5">
										县市<input type="checkbox" name="country_detail" onchange="setDisable()">
										渠道<input type="checkbox" name="channel_detail" onchange="setDisable()">
									</td>
								</tr>
								<%-- 
								<tr class="dim_row">
									<td class="dim_cell_title">&nbsp;投诉业务类型大类</td>
									<td class="dim_cell_content">
										<select name="level1" onchange="areacombo(1)">
											<option value="">全部</option>
										</select>
										<script type="text/javascript" defer="defer">
											renderSelect("select distinct item_id_lev1,item_name_lev1 from nmk.vdim_keybusi_complain_type ",document.forms[0].level1.value,document.forms[0].level1,undefined,undefined);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;投诉业务类型细类</td>
									<td class="dim_cell_content" colspan="3">
										<select name="level2">
											<option value="">全部</option>
										</select>
										<script type="text/javascript" defer="defer">
											areacombo(1);
										</script>
									</td>
									
								</tr>
								--%>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询"
										onClick="doSubmit()">
									&nbsp;
									<input type="button" class="form_button" value="下载"
										onclick="toDown()">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'show_div')"
									title="点击隐藏">
									<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
								<td></td>
							</tr>
						</table>
					</legend>
					
					<div id="show_div">
						<div id="showSum"></div>
						<div id="showResult"></div>
					</div>
				</fieldset>
			</div>
			<br>
			<div id="tempSql"></div>
			<div id="title_div" style="display:none;">
			</div>
		</form>
		<form name="form2" method="post" action="">
			<div id="hidden_div2">
				<input type="hidden" id="sql" name="sql" value="">
				<input type="hidden" name="filename" value="">
				<input type="hidden" name="title" value="">
			</div>
		</form>
		<%@ include file="/hbbass/common2/loadmask.htm"%>
		</body>
</html>
