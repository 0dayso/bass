<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("${mvcPath}/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	

%>
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
  </head>
  
<% 
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getDWConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String channel_code = request.getParameter("channel_code");
	String condition = " where channel_id=" + channel_code;
	String sql = "select channel_id ,channel_id_zmh,channel_name ,area_name_boss ,country_name_boss ,market_org_id,market_org_code,town  ,village ,longitude ,dimensionality ,position_type ,bureau_type ,customer_volume  ,channel_modle  ,channel_type    ,channel_classific ,joint_channel_code ,tenement_type ,connect_type ,channel_level ,business_start_time ,business_end_time ,opening_date ,address ,response_name ,response_phone ,channel_state ,chain_distribution_type ,exclusiveness_flag ,mobilephone_store_flag from nmk.chl_info " + condition;
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
<script type="text/javascript">
  </script>
  <body>
  
  <%-- 改成迭代版 --%>
  <%
  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  %>
  		 <table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
  		 	<tr class="dim_row">
				<td class="dim_cell_title">渠道编码（boss）</td>
				<td class="dim_cell_content"><%=lines.get("channel_id")==null?"":lines.get("channel_id") %></td>
				<td class="dim_cell_title">渠道编码（经分）</td>
				<td class="dim_cell_content"><%=lines.get("channel_id_zmh")==null?"":lines.get("channel_id_zmh") %></td>
				<td class="dim_cell_title" >渠道名称</td>
				<td class="dim_cell_content"><%=lines.get("channel_name")==null?"":lines.get("channel_name") %></td>
				</tr>
			<tr class="dim_row">
			<td class="dim_cell_title" >市州</td>
				<td class="dim_cell_content"><%=lines.get("area_name_boss")==null?"":lines.get("area_name_boss") %></td>
			
				<td class="dim_cell_title" >区县</td>
				<td class="dim_cell_content"><%=lines.get("country_name_boss")==null?"":lines.get("country_name_boss") %></td>
				<td class="dim_cell_title">区域营销中心（片区）</td>
				<td class="dim_cell_content"><%=lines.get("market_org_id")==null?"":lines.get("market_org_id") %></td>
				</tr>
			<tr class="dim_row">	
			<td class="dim_cell_title" >区域营销中心编码</td>
				<td class="dim_cell_content"><%=lines.get("market_org_code")==null?"":lines.get("market_org_code") %></td>
						
				<td class="dim_cell_title" >乡镇</td>
				<td class="dim_cell_content"><%=lines.get("town")==null?"":lines.get("town") %></td>
				<td class="dim_cell_title" >行政村</td>
				<td class="dim_cell_content"><%=lines.get("village")==null?"":lines.get("village") %></td>
				</tr>
			<tr class="dim_row">
			<td class="dim_cell_title">经度（单位：°）</td>
				<td class="dim_cell_content"><%=lines.get("longitude")==null?"":lines.get("longitude") %></td>
			
				<td class="dim_cell_title" >纬度（单位：°）</td>
				<td class="dim_cell_content"><%=lines.get("dimensionality")==null?"":lines.get("dimensionality") %></td>
				<td class="dim_cell_title" >地理位置类型</td>
				<td class="dim_cell_content"><%=lines.get("position_type")==null?"":lines.get("position_type") %></td>
					</tr>
			<tr class="dim_row">
			<td class="dim_cell_title" >区域形态</td>
				<td class="dim_cell_content"><%=lines.get("bureau_type")==null?"":lines.get("bureau_type") %></td>
		
				<td class="dim_cell_title">月均客流量</td>
				<td class="dim_cell_content"><%=lines.get("customer_volume")==null?"":lines.get("customer_volume") %></td>
				<td class="dim_cell_title" >经营模式</td>
				<td class="dim_cell_content"><%=lines.get("channel_modle")==null?"":lines.get("channel_modle") %></td>
				</tr>
			<tr class="dim_row">
			<td class="dim_cell_title" >渠道基础类型</td>
				<td class="dim_cell_content"><%=lines.get("channel_type")==null?"":lines.get("channel_type") %></td>
			
				<td class="dim_cell_title" >自有渠道分类</td>
				<td class="dim_cell_content"><%=lines.get("channel_classific")==null?"":lines.get("channel_classific") %></td>
				<td class="dim_cell_title">合建营业厅的渠道编码</td>
				<td class="dim_cell_content"><%=lines.get("joint_channel_code")==null?"":lines.get("joint_channel_code") %></td>
					</tr>
			<tr class="dim_row">
			<td class="dim_cell_title" >自有渠道物业来源类型</td>
				<td class="dim_cell_content"><%=lines.get("tenement_type")==null?"":lines.get("tenement_type") %></td>
		
				<td class="dim_cell_title" >联网方式</td>
				<td class="dim_cell_content"><%=lines.get("connect_type")==null?"":lines.get("connect_type") %></td>
				<td class="dim_cell_title" >自营厅分类/社会渠道分级</td>
				<td class="dim_cell_content"><%=lines.get("channel_level")==null?"":lines.get("channel_level") %></td>
				</tr>
			<tr class="dim_row">
			<td class="dim_cell_title">营业起始时间</td>
				<td class="dim_cell_content"><%=lines.get("business_start_time")==null?"":lines.get("business_start_time") %></td>
			
				<td class="dim_cell_title" >营业结束时间</td>
				<td class="dim_cell_content"><%=lines.get("business_end_time")==null?"":lines.get("business_end_time") %></td>
				<td class="dim_cell_title" >开业时间</td>
				<td class="dim_cell_content"><%=lines.get("opening_date")==null?"":lines.get("opening_date") %></td>
				</tr>
			<tr class="dim_row">
				<td class="dim_cell_title" >渠道地址</td>
				<td class="dim_cell_content"><%=lines.get("address")==null?"":lines.get("address") %></td>
			
				<td class="dim_cell_title">渠道联系人</td>
				<td class="dim_cell_content"><%=lines.get("response_name")==null?"":lines.get("response_name") %></td>
				<td class="dim_cell_title" >联系电话</td>
				<td class="dim_cell_content"><%=lines.get("response_phone")==null?"":lines.get("response_phone") %></td>
			</tr>
			<tr class="dim_row">	
				<td class="dim_cell_title" >渠道状态</td>
				<td class="dim_cell_content"><%=lines.get("channel_state")==null?"":lines.get("channel_state") %></td>
			
				<td class="dim_cell_title" >连锁分销属性</td>
				<td class="dim_cell_content"><%=lines.get("chain_distribution_type")==null?"":lines.get("chain_distribution_type") %></td>
				<td class="dim_cell_title">是否排他</td>
				<td class="dim_cell_content"><%=lines.get("exclusiveness_flag")==null?"":lines.get("exclusiveness_flag") %></td>
				</tr>
			<tr class="dim_row">
			<td class="dim_cell_title" >是否为手机卖场</td>
				<td class="dim_cell_content"><%=lines.get("mobilephone_store_flag")==null?"":lines.get("mobilephone_store_flag") %></td>
				
			<tr>
		</table>
<%  	
		}
 %>
	</body>
</html>