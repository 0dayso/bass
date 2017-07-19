<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	copied from college_analysis.jsp
  --%>
    <title>余额低于10元用户预警</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="default.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
  </head>
  <script type="text/javascript">
 	queryTime = "";//照旧定义一个全局变量
 	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_text";
	cellfunc[0] = function (datas,options) {
		var parts = datas[options.seq].split("@parts@");
		return parts[0];
	}
	window.onload = doSubmit2;
	function formatDate(date) {
		return date.substr(0,4) + "-" + date.substr(4,2) + "-01";
	}
	function doSubmit2() {
		queryTime = document.forms[0].date.value;
		var condition = " where up_date>='" + formatDate(queryTime) + "' ";
		var balance = document.forms[0].balance.value;//已经验证过了，所以这里的值绝对合法
		condition += " and decimal(balance/100,15,2) <= " + balance;
		//alert(rgroup_num + "///条件已注掉");
		//alert(document.forms[0].city.value);
		if(document.forms[0].city.value !="0")	condition += " and a.area_id='" + document.forms[0].city.value + "'";
		if(document.forms[0].college_name_given.value != "支持模糊查询") condition += " and info.college_name like'%" + document.forms[0].college_name_given.value + "%'";
		if(document.forms[0].brand.value != "all") {
			if("qqt" == document.forms[0].brand.value)
				condition += " and brand_id in (1,2,3)";
			else if("mzone" == document.forms[0].brand.value)
				condition += " and brand_id=8";
			else
				condition += " and brand_id in (4,5,6,7)";
		}
		condition += " and a.college_id=info.college_id ";
		//alert(condition);
		//condition += " and dim_brand.db_tid=a.brand_id ";
		//alert(condition);
		//取消用户名称
		//--dim_brand.prod_tname--
		var sql = "select rtrim(char(bigint(a.acc_nbr))) || '@parts@' || rtrim(char(bigint(a.mbuser_id))),info.college_name ,case when STATE_TID = 'US364' then '欠费停机' when STATE_TID='US10' then '在网' else '未知' end,case when brand_id in (1,2,3) then '全球通' when brand_id = 8 then '动感地带' else '省内用户' end,case when balance is null then 0 else decimal(balance/100,15,2) end from nmk.College_Mbuser_" + queryTime + " a, nwh.college_info info " +  condition;
		var countSql = "select count(*) from nmk.College_Mbuser_" + queryTime + " a, nwh.college_info info "  + condition;
		document.forms[0].sql.value = sql + " with ur";//这个sql是全查的。数据量有可能会很慢。
		ajaxSubmitWrapper(sql+ " fetch first 1000 rows only with ur",countSql);
	}

function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();

	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}
	
  </script>
  <script type="text/javascript" defer="defer">
	function checkBlur() {
		var oInput = document.getElementById("college_name_given");
		if(oInput.value == "") {
			oInput.value="支持模糊查询";
			oInput.style.color = "gray";
			oInput.style.fontStyle = "italic";
		}
	}
	function checkFocus() {
		//alert("checkfocus");
		var oInput = document.getElementById("college_name_given");
		oInput.value="";//清空文本
		oInput.style.color = "black";
		oInput.style.fontStyle = "normal";
		
	}
	function checkBlurNum() {
		var oNumValue = document.forms[0].balance.value;
		//alert("blured");
		var patten=/^[0-9]+$/;//由且仅由1-2个数字组成。
		 if(oNumValue.match(patten) == null) {
		 	alert('用户余额填写不正确，请重新填写。用户余额由两位数字组成。');
		 	document.forms[0].balance.value=10;//恢复默认值
		 	document.forms[0].balance.focus();
		 }
	}
  </script>
  <body>
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="a.acc_nbr">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
					<td class="dim_cell_title">统计月份
					</td>
						<td class="dim_cell_content">
							<%=QueryTools2.getDateYMHtml("date",12)%>
						</td>
							
						
						<td class="dim_cell_title">地市</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%>
						</td>
						<td class="dim_cell_title">高校名称</td>
						<td class="dim_cell_content"><input type="text" name="college_name_given" id=""college_name_given"" value="支持模糊查询" style="color:gray; font-style: italic;" onblur="checkBlur()" onfocus="checkFocus()"></td>
					</tr>
					
						<tr class="dim_row">
					<td class="dim_cell_title">品牌
					</td>
						<td class="dim_cell_content">
							<select id="brand" name="brand">
								<option selected="selected" value="all">全部</option>
								<option value="mzone">动感地带</option>
								<option value="snpp">省内品牌</option>
								<option value="qqt">全球通</option>
							</select>
						</td>
						<td class="dim_cell_title">用户余额<(元)</td>
						<td class="dim_cell_content" colspan="3">
							<%-- 
							<select id="counts" name="counts">
								<option selected="selected" value="4">4</option>
								<option value="5">5</option>
								<option value="3">3</option>
								<option value="2">2</option>
								<option value="1">1</option>
							</select>
							--%>
							<input type="text" name="balance" id="balance" value="10" title="填写填写用户余额" onblur="checkBlurNum()"/>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="查询" onclick="doSubmit2()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown()"/>&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
	
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
				<%-- 此处有可能显示有可能隐藏，完全取决与fecth first n rows 中n的值 --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 <%-- 表头变化部分 --%>
				  	<td width="" class="grid_title_cell">移动号码</td>
				  	<%-- 
				  	暂时取消用户名称 <td width="" class="grid_title_cell">用户名称</td>
				  	--%>
				 	<td width="" class="grid_title_cell">高校名称</td>
				 	<td width="" class="grid_title_cell">用户状态</td>
				 	<td width="" class="grid_title_cell">品牌</td>
				 	<td width="" class="grid_title_cell">用户余额</td>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
