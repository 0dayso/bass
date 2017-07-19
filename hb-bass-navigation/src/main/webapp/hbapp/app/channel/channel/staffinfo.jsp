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
  response.sendRedirect("/hbbass/error/loginerror.jsp");
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
  <script type="text/javascript">
<%
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getDWConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String channel_code = request.getParameter("channel_code");
	String condition = " where channel_id=" + channel_code;
	String sql = "select employee_num,securityer_num,cleaner_num from NMK.CHL_INFO "+condition;
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
				<td class="dim_cell_title">员工人数</td>
				<td class="dim_cell_content"><%=lines.get("employee_num")==null?"":lines.get("employee_num") %></td>
				<td class="dim_cell_title" >保安人数（位）</td>
				<td class="dim_cell_content"><%=lines.get("securityer_num")==null?"":lines.get("securityer_num") %></td>
				<td class="dim_cell_title" >保洁人数（位）</td>
				<td class="dim_cell_content"><%=lines.get("cleaner_num")==null?"":lines.get("cleaner_num") %></td>
			</tr>
		</table>
		<%  	
		}
 %>
  </body>
</html>
