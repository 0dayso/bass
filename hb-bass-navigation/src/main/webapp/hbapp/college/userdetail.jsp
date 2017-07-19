<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="bass.common.SQLSelect, java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbbass/report/financing/dim_conf.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
  </head>
 
 
 <script type="text/javascript">
 	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_text";
	cellclass[3]="grid_row_cell_text";
	cellclass[4]="grid_row_cell_text";
	cellclass[5]="grid_row_cell_text";
	cellclass[6]="grid_row_cell_text";
	cellclass[7]="grid_row_cell_text";
	cellclass[8]="grid_row_cell_text";
	cellclass[9]="grid_row_cell_text";
	cellclass[10]="grid_row_cell_text";
	
	cellfunc[5]=function(datas,options) {
		return citycode[datas[5]];
	}
	
</script>
  <body>
  
  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
  
  
  <div id="show_div">
				<%-- 此处有可能显示有可能隐藏，完全取决与fecth first n rows 中n的值 --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
  <div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 <%-- 表头变化部分 --%>
				  <td class="grid_title_cell">用户编码</td>
				<td class="grid_title_cell" >用户号码</td>
				<td class="grid_title_cell" >用户类型</td>
				<td class="grid_title_cell" >高校基占归属</td>
				<td class="grid_title_cell" >高校编码</td>
				<td class="grid_title_cell" >所属地市</td>
				<td class="grid_title_cell" >渠道名称</td>
				<td class="grid_title_cell" >用户状态</td>
				 </tr>
			</table>
		</div>	
  
   <%@ include file="/hbbass/common2/loadmask.htm"%>
    <script type="text/javascript">
   <%
	String college_id = request.getParameter("college_id");
  	String queryTime = request.getParameter("queryTime");
  	
	//String date = request.getParameter("date");
	String sql = "select MBUSER_ID, ACC_NBR, CUST_TID,(select BUREAU_name from nwh.bureau_cfg where BUREAU_ID=COLLEGE_BUREAU_ID) ,COLLEGE_ID ,AREA_ID, (select site_name from nwh.res_site where site_id=CHANNEL_CODE),case when STATE_TID = 'US364' then '欠费停机' when STATE_TID='US10' then '在网' else '未知' end from nmk.College_Mbuser_" + queryTime + " where college_id='" + college_id + "'";
	String countSql = "select count(*) from nmk.College_Mbuser_" + queryTime + " where college_id='" + college_id + "'";
	out.print(
			"ajaxSubmitWrapper(\"" + sql + " fetch first 1000 rows only with ur\",\"" + countSql + "\")"
	);
	%> 
 	</script>
  </body>
</html>
