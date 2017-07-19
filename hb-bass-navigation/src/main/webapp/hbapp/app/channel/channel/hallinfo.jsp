<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
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
<%
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getDWConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String channel_code = request.getParameter("channel_code");
	String condition = " where a.channel_id=" + channel_code+" and b.channel_id="+channel_code;
	String sql = "select a.building_area,a.using_area,a.business_area,g3_experience_area ,tv_screen_num ,in_airpay_plat_flag ,in_online_busihall_flag ,xj_experience_plat_num ,newbusi_experience_plat_num ,seats_num ,self24h_serv_hall_flag ,pos_machine_flag ,vip_room_flag ,vip_seat_flag ,queue_machine_flag ,his_bill_printer_num ,compre_selfserv_term_num ,house_property_card ,ic_regist_number ,construction_date ,construction_total_fee ,land_number ,avg_annual_rental ,lease_end_date ,lease_start_date ,furniture_total_invest ,equipment_total_invest ,decorate_total_invest ,partner_company_name ,legal_representative ,id_number ,signing_numbers ,cooperated_years ,sign_effdate ,sign_expdate ,reward_bank ,reward_accountid ,channel_bail ,water_cost ,electricity_cost ,total_labour_cost ,office_consumables_cost ,other_daily_cost from nmk.chl_info a,NMK.CHL_INFO_EXTENT b "+condition;
	list = (List)queryBase.query(sql);
}catch(Exception e)
{
	e.printStackTrace();
}
finally
{
	//连接已经在query方法释放过了，这里不用再释放了。
}	
%>
  </script>
  <body>
  <%
  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  %>
		 <table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">建筑面积（平方米）</td>
				<td class="dim_cell_content"><%=lines.get("building_area")==null?"":lines.get("building_area") %></td>
				<td class="dim_cell_title" >使用面积（平方米）</td>
				<td class="dim_cell_content"><%=lines.get("using_area")==null?"":lines.get("using_area") %></td>
				<td class="dim_cell_title" >前台营业面积（平方米）</td>
				<td class="dim_cell_content"><%=lines.get("business_area")==null?"":lines.get("business_area") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">G3体验区面积</td>
				<td class="dim_cell_content"><%=lines.get("g3_experience_area")==null?"":lines.get("g3_experience_area") %></td>
				<td class="dim_cell_title" >电视屏(个)</td>
				<td class="dim_cell_content"><%=lines.get("tv_screen_num")==null?"":lines.get("tv_screen_num") %></td>
				<td class="dim_cell_title" >是否接入空中充值平台</td>
				<td class="dim_cell_content"><%=lines.get("in_airpay_plat_flag")==null?"":lines.get("in_airpay_plat_flag") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">网上营业厅接入</td>
				<td class="dim_cell_content"><%=lines.get("in_online_busihall_flag")==null?"":lines.get("in_online_busihall_flag") %></td>
				<td class="dim_cell_title" >心机体验平台</td>
				<td class="dim_cell_content"><%=lines.get("xj_experience_plat_num")==null?"":lines.get("xj_experience_plat_num") %></td>
				<td class="dim_cell_title" >新业务体验营销平台接入情况</td>
				<td class="dim_cell_content"><%=lines.get("newbusi_experience_plat_num")==null?"":lines.get("newbusi_experience_plat_num") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">台席数量（个）</td>
				<td class="dim_cell_content"><%=lines.get("seats_num")==null?"":lines.get("seats_num") %></td>
				<td class="dim_cell_title" >有无24小时自助营业厅</td>
				<td class="dim_cell_content"><%=lines.get("self24h_serv_hall_flag")==null?"":lines.get("self24h_serv_hall_flag") %></td>
				<td class="dim_cell_title" >有无POS机</td>
				<td class="dim_cell_content"><%=lines.get("pos_machine_flag")==null?"":lines.get("pos_machine_flag") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">有无VIP室</td>
				<td class="dim_cell_content"><%=lines.get("vip_room_flag")==null?"":lines.get("vip_room_flag") %></td>
				<td class="dim_cell_title" >有无VIP专席</td>
				<td class="dim_cell_content"><%=lines.get("vip_seat_flag")==null?"":lines.get("vip_seat_flag") %></td>
				<td class="dim_cell_title" >有无排队叫号机</td>
				<td class="dim_cell_content"><%=lines.get("queue_machine_flag")==null?"":lines.get("queue_machine_flag") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">帐详单打印机</td>
				<td class="dim_cell_content"><%=lines.get("his_bill_printer_num")==null?"":lines.get("his_bill_printer_num") %></td>
				<td class="dim_cell_title" >综合性自助终端（含缴费）</td>
				<td class="dim_cell_content"><%=lines.get("compre_selfserv_term_num")==null?"":lines.get("compre_selfserv_term_num") %></td>
				<td class="dim_cell_title" >房产证号</td>
				<td class="dim_cell_content"><%=lines.get("house_property_card")==null?"":lines.get("house_property_card") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">工商注册号</td>
				<td class="dim_cell_content"><%=lines.get("ic_regist_number")==null?"":lines.get("ic_regist_number") %></td>
				<td class="dim_cell_title" >购建时间</td>
				<td class="dim_cell_content"><%=lines.get("construction_date")==null?"":lines.get("construction_date") %></td>
				<td class="dim_cell_title" >购建总价（万元）</td>
				<td class="dim_cell_content"><%=lines.get("construction_total_fee")==null?"":lines.get("construction_total_fee") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">土地证号</td>
				<td class="dim_cell_content"><%=lines.get("land_number")==null?"":lines.get("land_number") %></td>
				<td class="dim_cell_title" >年平均租金（万元）</td>
				<td class="dim_cell_content"><%=lines.get("avg_annual_rental")==null?"":lines.get("avg_annual_rental") %></td>
				<td class="dim_cell_title" >租赁截止时间</td>
				<td class="dim_cell_content"><%=lines.get("lease_end_date")==null?"":lines.get("lease_end_date") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">租赁起始时间</td>
				<td class="dim_cell_content"><%=lines.get("lease_start_date")==null?"":lines.get("lease_start_date") %></td>
				<td class="dim_cell_title" >办公和营业家具投资总额</td>
				<td class="dim_cell_content"><%=lines.get("furniture_total_invest")==null?"":lines.get("furniture_total_invest") %></td>
				<td class="dim_cell_title" >设备投资总额</td>
				<td class="dim_cell_content"><%=lines.get("equipment_total_invest")==null?"":lines.get("equipment_total_invest") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">装修投资总额</td>
				<td class="dim_cell_content"><%=lines.get("decorate_total_invest")==null?"":lines.get("decorate_total_invest") %></td>
				<td class="dim_cell_title" >合作方公司名称</td>
				<td class="dim_cell_content"><%=lines.get("partner_company_name")==null?"":lines.get("partner_company_name") %></td>
				<td class="dim_cell_title" >法人代表</td>
				<td class="dim_cell_content"><%=lines.get("legal_representative")==null?"":lines.get("legal_representative") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">身份证号码</td>
				<td class="dim_cell_content"><%=lines.get("id_number")==null?"":lines.get("id_number") %></td>
				<td class="dim_cell_title" >签约编号</td>
				<td class="dim_cell_content"><%=lines.get("signing_numbers")==null?"":lines.get("signing_numbers") %></td>
				<td class="dim_cell_title" >已合作年限</td>
				<td class="dim_cell_content"><%=lines.get("cooperated_years")==null?"":lines.get("cooperated_years") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">协议签署生效时间</td>
				<td class="dim_cell_content"><%=lines.get("sign_effdate")==null?"":lines.get("sign_effdate") %></td>
				<td class="dim_cell_title" >协议截止时间</td>
				<td class="dim_cell_content"><%=lines.get("sign_expdate")==null?"":lines.get("sign_expdate") %></td>
				<td class="dim_cell_title" >酬金开户行</td>
				<td class="dim_cell_content"><%=lines.get("reward_bank")==null?"":lines.get("reward_bank") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">酬金开户帐号</td>
				<td class="dim_cell_content"><%=lines.get("reward_accountid")==null?"":lines.get("reward_accountid") %></td>
				<td class="dim_cell_title" >渠道保证金（元）</td>
				<td class="dim_cell_content"><%=lines.get("channel_bail")==null?"":lines.get("channel_bail") %></td>
				<td class="dim_cell_title" >水费（元）</td>
				<td class="dim_cell_content"><%=lines.get("water_cost")==null?"":lines.get("water_cost") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">电费（元）</td>
				<td class="dim_cell_content"><%=lines.get("electricity_cost")==null?"":lines.get("electricity_cost") %></td>
				<td class="dim_cell_title" >人工成本及劳务费总额（元）</td>
				<td class="dim_cell_content"><%=lines.get("total_labour_cost")==null?"":lines.get("total_labour_cost") %></td>
				<td class="dim_cell_title" >办公用品及耗材（元）</td>
				<td class="dim_cell_content"><%=lines.get("office_consumables_cost")==null?"":lines.get("office_consumables_cost") %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">其他日常费用（元）</td>
				<td class="dim_cell_content"><%=lines.get("other_daily_cost")==null?"":lines.get("other_daily_cost") %></td>
				<td class="dim_cell_title" ></td>
				<td class="dim_cell_content"></td>
				<td class="dim_cell_title" ></td>
				<td class="dim_cell_content"></td>
			</tr>
			
		</table>
	<%  	
		}
 %>
		</body>
</html>

