<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common.SQLSelect"%>
<%-- 
	copied from complainCollect.jsp
	需求改变:分母不变
	表连接改成内连接
	问题: 清单下载的 投诉时段、重复投诉标志 不确定。
		2.生成的excel格式很怪，以确定不是sql问题,是英文逗号问题
		3.品牌的代码
	refer sql :
	select user_area_id,b.item_name_lev1,b.item_name ,sum(complain_num)
  from NMK.COMPLAIN_RECEIVE_200912 a, nmk.vdim_keybusi_complain_type b
  where a.complain_type =  b.item_id
    and a.etl_cycle_id>=20091201 and  a.etl_cycle_id<=20091202
group by  user_area_id,b.item_name_lev1,b.item_name 
--%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH,-1);//前天
	DateFormat formater = new SimpleDateFormat("yyyyMMdd");
	String day1 = formater.format(cal.getTime());
%>
<html>
	<HEAD> 
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>关键业务投诉汇总表</title>
		<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
		<script type="text/javascript" src="../js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="../ngbass/js/common.js"></script>
<script type="text/javascript">
	var titleMap = new Array();
		titleMap["user_area_id"] = "地市";
		titleMap["item_name_lev1"] = "投诉类型一级";
		titleMap["item_name"] = "投诉类型二级";
	var sample = "<td class='grid_title_cell'>@area@</td>";
	var condition;
	var outerCond = " 1=1 ";
	var tableTime = "";
	function doSubmit(sortNum)
	{	
		outerCond = " 1=1 ";
		var groupByPart = "";
		//var isEmpty = true;
		var highestLevel = "'HB'";//写死
		var _table;
		isEmpty = true;
		var titleDiv = titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
			 	+"<tr class='grid_title_blue'>"
		
		with(document.forms[0]) {
			startDate = date1.value;
			endDate = date2.value;
			cityId = city.value;
			for(var i = 0 ; i < display.length ; i ++) {
				if(display[i].checked) {
					groupByPart += display[i].value  + ",";
					isEmpty = false;
				}
			}
			if(isEmpty) {
				alert("您至少要选择一种展现。");
				return;
			}
			
			if(startDate > endDate) {
				alert("开始日期不能大于截止日期。");
				return;
			}
			if(startDate.substr(4,2)!= endDate.substr(4,2)) {
				alert("暂不支持跨月查询，请重新选择日期。");
				return;
			}
			tableTime = startDate.substr(0,6);
			/* 生成条件部分 */
			condition = " etl_cycle_id>="  + startDate + " and etl_cycle_id<=" + endDate;
			var areaCond = cityId == "0" ? "" : " and user_area_id='" + cityId + "'";
			condition += areaCond;
			
			if(level2.value)
				outerCond += " and ITEM_ID='" + level2.value + "'";
			else if(level1.value)
				outerCond += " and ITEM_ID_LEV1='" + level1.value + "'";
			
			_table = "(select value(user_area_id,'HB.WH')user_area_id ,complain_num,acc_nbr,complain_type,again_complain_num from NMK.COMPLAIN_RECEIVE_" + tableTime + " where " + condition +
			" ) a inner join nmk.vdim_keybusi_complain_type b on a.complain_type =  b.item_id ";
		}
		//var queryType = "lev1";
		groupByPart = groupByPart.replace(/,$/,""); //测试通过
			var keys = groupByPart.split(",");//没有,返回字符串本身
			for(indx in keys) {
				titleDiv += sample.replace("@area@",titleMap[keys[indx]]);
			}
			/* 样式 
				7 : max probable Length of this program
			*/
			for(var i = 0; i < 10; i ++) {
				if(i < keys.length) {
					cellclass[i]="grid_row_cell_text";
					cellfunc[i] = undefined;
				} else {
					cellclass[i]="grid_row_cell_number";
					cellfunc[i] = numberFormatDigit2;
				}
				if(i==(keys.length+1) || i == (keys.length + 3) || i == (keys.length + 5))
					cellfunc[i] = percentFormat;
			}
			//收尾			
		titleDiv += "<td class='grid_title_cell'>投诉人数</td>"
				+ "<td class='grid_title_cell'>投诉人数占比</td>"
				+ "<td class='grid_title_cell'>投诉次数</td>"
				+ "<td class='grid_title_cell'>投诉次数占比</td>"
				+ "<td class='grid_title_cell'>重复投诉次数</td>"
				+ "<td class='grid_title_cell'>重复投诉次数占比</td>";	
				+ "</tr></table>";
		
		var sql = "with temp as (" + 
					" select " + highestLevel + " area,count(distinct acc_nbr)total_counts,sum(complain_num)total_times,sum(again_complain_num)total_again_times " + 
					" from " + _table.replace(areaCond,"") + //去掉地市条件
					" group by " + highestLevel + 
					")";
		var	totalCounts = "(select temp.total_counts from temp where area='HB')";//投诉人数
		var totalTimes = "(select temp.total_times from temp where area='HB')";//投诉次数
		var	totalAgainTimes = "(select temp.total_again_times from temp where area='HB')";//重复投诉次数
		var constantPart = ", count(distinct acc_nbr)" + //投诉人数 
		",case when " + totalCounts + "=0 then 0 else decimal(count(distinct acc_nbr),16,2)/" + totalCounts + " end " + //地市总投诉人数
		",sum(complain_num)" + //投诉次数
		",case when " + totalTimes + "=0 then 0 else decimal(sum(complain_num),16,2)/" + totalTimes + " end " + 
		",sum(again_complain_num)" + //重复投诉次数
		",case when " + totalAgainTimes + "=0 then 0 else decimal(sum(again_complain_num),16,2)/" + totalAgainTimes + " end ";
		sql += " select " + groupByPart.replace("user_area_id","(select area_name from mk.bt_area where area_code=user_area_id)") + constantPart +  
				  " from " + _table + 
				  " where " + outerCond + 
				  " group by " + groupByPart ;
		document.form1.sql.value = sql;
		document.getElementById("title_div").innerHTML = titleDiv;
		ajaxSubmitWrapper(sql + " with ur");
	}
	
	function areacombo(i,sync){		
		selects = new Array();
		selects.push(document.forms[0].level1);
		sqls = new Array();
		if(document.forms[0].level2 != undefined)
		{
			selects.push(document.forms[0].level2);
			sqls.push("select distinct item_id,item_name from nmk.vdim_keybusi_complain_type where item_id_lev1='#{value}' order by 1 with ur");
		}
		
		var bl = false;
		if(sync!=undefined)bl=sync;
		combolink(selects,sqls,i,bl);
	}
	function toXls() {
		if(!condition) {
			alert("请先查询再下载清单。");
			return;
		}
		if(document.getElementById("maxCt")) {
			if(document.getElementById("maxCt").innerHTML == 0) {
				alert("没有查询结果，没有相应的清单下载。");
				return;
			}
		}
		var sql = " select ACC_NBR,(select area_name from mk.bt_area where area_code=user_area_id),case when BRAND_ID in (1,2,3) then '全球通' when BRAND_ID in (4,5,6,7) or brand_id is null then '神州行' when BRAND_ID=8 then '动感地带' else '其他' end,ITEM_NAME_LEV1,ETL_CYCLE_ID,c.rowname ,replace(COMPLAIN_DESC,',','，'),COMPLAIN_NUM,again_complain_num "
   		+ " from NMK.COMPLAIN_RECEIVE_" + tableTime + " a, nmk.vdim_keybusi_complain_type b ,NWH.VDIM_TIME_LEV c"
  		+ " where a.complain_type =  b.item_id and a.complain_time_lev = c.rowid and " + condition + " and " + outerCond;
		document.forms[1].sql.value = sql;
		document.forms[1].filename.value = document.title;
		document.forms[1].title.value = ["用户号码","地域","品牌","投诉类型","投诉日期","投诉时段","投诉描述","投诉次数","重复投诉次数"];
		document.forms[1].action = "/hbbass/common2/commonDown.jsp";
		document.forms[1].target = "_top";
		document.forms[1].submit();
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
									<input type="text" value='<%=day1 %>' id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
							 	</td>
							 	
							 	<td class="dim_cell_title" align="left">&nbsp;结束日期(<=)</td>
								<td class="dim_cell_content">
									<input type="text" value='<%=day1 %>' id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
							 	</td>
							 	
							 	<td class="dim_cell_title">&nbsp;地市</td>
				 			<td class="dim_cell_content" >
							<%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>	
							</tr>
								<tr class="dim_row">
									<td class="dim_cell_title" title="根据复选框,确认展现哪些纬度,默认选择地市">&nbsp;维度选项</td>
									<td class="dim_cell_content" colspan="5">
										地市<input checked="checked" type="checkbox" value="user_area_id" name="display" />
										投诉类型大类<input type="checkbox" value="item_name_lev1" name="display" />
										投诉类型细类<input type="checkbox" value="item_name" name="display" />
									</td>
								</tr>
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
									<input type="button" class="form_button" value="清单下载"
										onClick="toXls()">
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
