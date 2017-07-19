<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.asiainfo.bass.components.models.ConnectionManage"%>
<%
	out.clear();
	String actionType = request.getParameter("actiontype");

	if ("delete".equals(actionType))
	{
		String queryTime = request.getParameter("querytime");
		//queryTime = queryTime.replaceAll("-","");
		System.out.println("queryTime = "+queryTime);
		StringBuffer returnValue = new StringBuffer();
		Connection conn = null;
		try
		{
			conn = ConnectionManage.getInstance().getConnection("java:comp/env/jdbc/AiomniMPM");
			conn.setAutoCommit(false);

			Statement stat = conn.createStatement();
			String sql = "delete from npd.import_imei where time_id = " + queryTime;
			PreparedStatement ps = conn.prepareCall(sql);			
			ps.execute();
			ps.close();
			conn.commit();
			returnValue.append("清除上传记录成功！");
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.append("清除上传记录失败！");
		}
		finally
		{
			if (conn != null)
			{
				conn.setAutoCommit(true);
				conn.close();
			}
		}		
		out.print(returnValue.toString());
	}
%>
