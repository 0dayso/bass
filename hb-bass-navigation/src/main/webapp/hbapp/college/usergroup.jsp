<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.SQLSelect, java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  copies from userdetail.jsp
  090831:���һ�����󣬱��������ڲ���д����ҳ�����ˣ���������µ�45��46��114��115
  --%>
    <title>�������ֽ���Ȧ�û���Ϣ</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
  </head>
 
 
 <script type="text/javascript">
	cellclass[2]="grid_row_cell_text";
	cellclass[3]="grid_row_cell_text";
	cellclass[4]="grid_row_cell_text";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=numberFormatDigit2;
</script>
  <body>
  
  <!-- ��ȫû�õ����򣬵�Ϊ�˲��������� -->
  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
  
  
  <div id="show_div">
				<%-- �˴��п�����ʾ�п������أ���ȫȡ����fecth first n rows ��n��ֵ --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
  <div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 <%-- ��ͷ�仯���� --%>
				  <td class="grid_title_cell">�ƶ��û�����</td>
				<td class="grid_title_cell" >�������ֺ���</td>
				<td class="grid_title_cell" >��������Ʒ��</td>
				<td class="grid_title_cell" >��У����</td>
				<td class="grid_title_cell" >����ʱ��</td>
				<td class="grid_title_cell" >�����ۼ�ͨ��ʱ��</td>
				<td class="grid_title_cell" >�����ۼ�ͨ������</td>
				 </tr>
			</table>
		</div>	
  
   <%@ include file="/hbbass/common2/loadmask.htm"%>
    <script type="text/javascript">
   <% 
	//String college_id = request.getParameter("college_id");
  	// queryTime = request.getParameter("queryTime");
  	String mbuser_id = request.getParameter("mbuser_id");
	String queryTime = request.getParameter("queryTime");
  	//String date = request.getParameter("date");
	String countSql = "select count(*) from nmk.College_Mbuser_" + queryTime + " a,NMK.GMS_COLLEGE_GROUP_" + queryTime + " b,nmk.College_Ruser_" + queryTime + " c where a.mbuser_id = b.mbuser_id  and b.opp_nbr = c.acc_nbr and a.mbuser_id=" + mbuser_id;
	String sql = "select a.acc_nbr,c.acc_nbr, (select rv_brand_name from nwh.dim_rvbrand where c.rvbrand_id = RVBRAND_ID) ,(select college_name from nwh.college_info where college_id=c.college_id),c.eff_date,c.sum_dura_m,c.sum_times_m from nmk.College_Mbuser_" + queryTime + " a,NMK.GMS_COLLEGE_GROUP_" + queryTime + " b,nmk.College_Ruser_" + queryTime + " c where a.mbuser_id = b.mbuser_id  and b.opp_nbr = c.acc_nbr and a.mbuser_id=" + mbuser_id;
	out.print(
			"ajaxSubmitWrapper(\"" + sql + " fetch first 1000 rows only with ur\",\"" + countSql + "\")"
	);
	%> 
 	</script>
  </body>
</html>
