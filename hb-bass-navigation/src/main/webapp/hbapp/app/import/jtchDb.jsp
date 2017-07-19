<%@page import="com.asiainfo.bass.components.models.ConnectionManage"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.HashMap,java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%
 		out.clear();
		String actionType = request.getParameter("actiontype");
		System.out.println("actionType="+actionType);
		StringBuffer returnValue = new StringBuffer();
		Connection conn = null;
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
			conn.setAutoCommit(false);
			String sql = "";
			if("singleDelete".equals(actionType)){
				String imei = request.getParameter("imei");
				sql = "delete from NWH.TERMINAL_SJ_LOAD where imei='"+imei+"'";
				returnValue.append(imei+" 集团串货数据删除成功！");			
			}else if("singleUpd".equals(actionType)){
				String imei = request.getParameter("imei");
				String prod = request.getParameter("prod");
				String device_name = request.getParameter("device_name");
				String use_locate = request.getParameter("use_locate");
				String sell_locate = request.getParameter("sell_locate");
				String time_id = request.getParameter("time_id");
				sql = "update NWH.TERMINAL_SJ_LOAD set prod='"+prod+"',device_name='"+device_name+"',use_locate='"+use_locate+"',sell_locate='"+sell_locate+"',time_id="+time_id;
				sql += " where imei='"+imei+"'";
				System.out.println("sqlUpd="+sql);
				returnValue.append(imei+" 集团串货数据修改成功！");
			}
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.execute();
			ps.close();
			conn.commit();
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.delete(0,returnValue.length()-1);
			returnValue.append("操作失败！");
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
%>