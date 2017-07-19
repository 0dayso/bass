<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common.QueryTools3"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%-- 
	copied from keyBusiReport.jsp
	需求改变:分母不变
--%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH,-1);//昨天
	DateFormat formater = new SimpleDateFormat("yyyyMMdd");
	String day1 = formater.format(cal.getTime());
	//改变了业务逻辑，两个日期使用同一个日期，默认昨天
%>
<html>
	<HEAD> 
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>客户投诉汇总报表</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/old/basscommon.js"	charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/bass21.css" />
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<!-- 
		<script type="text/javascript" src="../ngbass/js/common.js"></script>
		 -->
		 <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
<script type="text/javascript">
	var titleMap = new Array();
		titleMap["user_area_id"] = "地域";
		titleMap["item_name_lev1"] = "投诉类型一级";
		titleMap["item_name_lev2"] = "投诉类型二级";
		titleMap["item_name_lev3"] = "投诉类型三级";
	var sample = "<td class='grid_title_cell'>@area@</td>"
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
			
			
			if(level3.value)
				outerCond += " and ITEM_ID_LEV3='" + level3.value + "'";
			else if(level2.value)
				outerCond += " and ITEM_ID_LEV2='" + level2.value + "'";
			else if(level1.value)
				outerCond += " and ITEM_ID_LEV1='" + level1.value + "'";
			//嵌套主要是为了把null转成HB.WH,同时用where条件筛选，还有只差必要的字段
			
			
			if(brand.value!=""){
				outerCond += " and brand_id  in (" + brand.value + ")";
			}
			
			if(Partner_type.value!=""){
				outerCond += " and Partner_type = '" + Partner_type.value + "'";
			}
			
			if(Foreigner_flag.value!=""){
				outerCond += " and Foreigner_flag = " + Foreigner_flag.value ;
			}
			
			if(county.value!=""){
				outerCond += " and user_area_id = '" + county.value + "'";
			}else{
				var areaCond = cityId == "0" ? "" : " and user_area_id='" + cityId + "'";
				//从condition中分离出areaCond
				condition += areaCond;
				
			}
			_table = "(select value(substr(user_channel_code,1,8),'HB.WH.01')user_area_id,complain_num,Foreigner_flag,Partner_type,brand_id,acc_nbr,complain_type from NMK.COMPLAIN_RECEIVE_" + tableTime + " where " + condition +
			" ) a left outer join nmk.vdim_complain_type b on a.complain_type =  b.item_id_lev3 ";
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
			for(var i = 0; i < 8; i ++) {
				if(i < keys.length) {
					cellclass[i]="grid_row_cell_text";
					cellfunc[i] = undefined;
				} else {
					cellclass[i]="grid_row_cell_number";
					cellfunc[i] = numberFormatDigit2;
				}
				if(i==(keys.length+1) || i == (keys.length + 3))
					cellfunc[i] = percentFormat;
			}
			//收尾			
		titleDiv += "<td class='grid_title_cell'>投诉人数</td>"
				+ "<td class='grid_title_cell'>投诉人数占比</td>"
				+ "<td class='grid_title_cell'>投诉次数</td>"
				+ "<td class='grid_title_cell'>投诉次数占比</td>";	
				+ "</tr></table>";
		
		var sql = "with temp as (" + 
					" select " + highestLevel + " area,count(distinct acc_nbr)total_counts,sum(complain_num)total_times " + 
					//" from " + _table.replace(" where " + condition,"") + //复用了_table,但不需要where条件
					" from " + _table.replace(areaCond,"") + //去掉地市条件
					//董勇认为只带时间条件" where " + outerCond +//added
					" group by " + highestLevel + 
					")";//查出全省及各个地市的总投诉人数count1,和次数count2,null代表武汉
		var	totalCounts = "(select temp.total_counts from temp where area='HB')";//投诉人数
		var totalTimes = "(select temp.total_times from temp where area='HB')";//投诉次数
		var constantPart = ", count(distinct acc_nbr)" + //投诉人数 
		",case when " + totalCounts + "=0 then 0 else decimal(count(distinct acc_nbr),16,2)/" + totalCounts + " end " + //地市总投诉人数
		",sum(complain_num)" + //投诉次数
		",case when " + totalTimes + "=0 then 0 else decimal(sum(complain_num),16,2)/" + totalTimes + " end ";
		
		if(cityId == "0"){
			areaName=groupByPart.replace("user_area_id","(select area_name from mk.bt_area where area_code=substr(user_area_id,1,5))");
			groupByPart=groupByPart.replace("user_area_id","substr(user_area_id,1,5)");
		}else
			areaName=groupByPart.replace("user_area_id","(select county_name from MK.BT_AREA_all where county_code=user_area_id)");

		
		sql += " select " + areaName + constantPart +  
				  " from " + _table + 
				  " where " + outerCond + 
				  " group by " + groupByPart ;
		document.form1.sql.value = sql;
		document.getElementById("title_div").innerHTML = titleDiv;
		ajaxSubmitWrapper(sql + " with ur");
	}
	
	function complaincombo(i,sync){		
		selects = new Array();
		selects.push(document.forms[0].level1);
		sqls = new Array();
		if(document.forms[0].level2 != undefined)
		{
			selects.push(document.forms[0].level2);
			sqls.push("select distinct item_id_lev2,replace(item_name_lev2,item_name_lev1,'') from nmk.vdim_complain_type where item_id_lev1='#{value}' order by 1 with ur");
		}
		
		if(document.forms[0].level3!= undefined)
		{
			selects.push(document.forms[0].level3);
			sqls.push("select distinct item_id_lev3,replace(item_name_lev3,item_name_lev2,'') from nmk.vdim_complain_type where item_id_lev2='#{value}' order by 1 with ur");
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
		var sql = " select acc_nbr,(select area_name from mk.bt_area where area_code=user_area_id) area_name,case when BRAND_ID in (1,2,3) then '全球通' when BRAND_ID in (4,5,6,7) or brand_id is null then '神州行' when BRAND_ID=8 then '动感地带' else '其他' end brand,ITEM_NAME_LEV3 complain_type,etl_cycle_id ,c.rowname , replace(complain_desc,',','，') complain_desc,complain_num "
   		+ " from NMK.COMPLAIN_RECEIVE_" + tableTime + " a, nmk.vdim_complain_type b,NWH.VDIM_TIME_LEV c "
  		+ " where a.complain_type =  b.item_id_lev3 and a.complain_time_lev = c.rowid and " + condition + " and " + outerCond;
		//document.forms[1].sql.value = sql;
		//document.forms[1].filename.value = document.title;
		//document.forms[1].title.value = ["用户号码","地域","品牌","投诉类型","投诉日期","投诉时段","投诉描述","投诉次数"];//暂未加
		//document.forms[1].action = "/hbbass/common2/commonDown.jsp";
		//document.forms[1].target = "_top";
		//document.forms[1].submit();
		aihb.AjaxHelper.down({
			sql : sql
			,fileName : document.title
			,header : '{"acc_nbr":"用户号码","area_name":"地域","brand":"品牌","complain_type":"投诉类型","etl_cycle_id":"投诉日期","rowname":"投诉时段","complain_desc":"投诉描述","complain_num":"投诉次数"}'
		});

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
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
				 				<td class="dim_cell_content" ><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title" title="根据复选框,确认展现哪些纬度,默认选择地市">&nbsp;维度选项</td>
									<td class="dim_cell_content" colspan="3">
										地市<input checked="checked" type="checkbox" value="user_area_id" name="display" />
										投诉类型一级<input type="checkbox" value="item_name_lev1" name="display" />
										投诉类型二级<input type="checkbox" value="item_name_lev2" name="display" />
										投诉类型三级<input type="checkbox" value="item_name_lev3" name="display" />
									</td>
									<td class="dim_cell_title">&nbsp;县市</td>
				 					<td class="dim_cell_content" ><%=QueryTools2.getCountyHtml("county","")%></td>
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">&nbsp;投诉业务类型一级</td>
									<td class="dim_cell_content">
										<select name="level1" onchange="complaincombo(1)">
											<option value="">全部</option>
										</select>
										<script type="text/javascript" defer="defer">
											renderSelect("select distinct item_id_lev1,item_name_lev1 from nmk.vdim_complain_type ",document.forms[0].level1.value,document.forms[0].level1,undefined,undefined);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;投诉业务类型二级</td>
									<td class="dim_cell_content">
										<select name="level2" onchange="complaincombo(2)">
											<option value="">全部</option>
										</select>
										<script type="text/javascript" defer="defer">
											complaincombo(2);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;投诉业务类型三级</td>
									<td class="dim_cell_content">
										<select name="level3">
											<option value="">全部</option>
										</select>
									</td>
									
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">品牌</td>
									<td class="dim_cell_content"><%=QueryTools3.getStaticHTMLSelect("brand","")%></td>
									<td class="dim_cell_title">运营商</td>
									<td class="dim_cell_content"><span name="Partner_type"><select name="Partner_type" class='form_select'><option value="">全部</option><option value="yd">移动</option><option value="dx">电信</option><option value="lt">联通</option></select></span></td>
									<td class="dim_cell_title">地域属性</td>
									<td class="dim_cell_content"><span name="Foreigner_flag"><select name="Foreigner_flag" class='form_select'><option value="">全部</option><option value="0">本省</option><option value="1">外省</option></select></span></td>
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
									
									<input type="button" class="form_button" value="图形分析" onClick="tabAdd({id : 'complainCollect',title : '图形分析',url : 'http://10.25.124.114:8080/hbbass/ngbass/analyMain.jsp?pid=275&reportname=客户投诉汇总分析'})">
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
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
		<%@ include file="/hbapp/resources/old/loadmask.htm"%>
		</body>
</html>
