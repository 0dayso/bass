<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>

<%
	String collegeCode = (String) request.getParameter("collegeCode");
	Connection conn = null;
	try {
		conn = ConnectionManage.getInstance().getDWConnection();

		String sql = "select college_id,college_name,value(college_type,''),value(college_add,'') from  NWH.COLLEGE_INFO where college_id = '"
				+ collegeCode + "' with ur";
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		String cCode = "";
		String cName = "";
		String cAdd = "";
		String cType = "";
		if (rs.next()) {
			cCode = rs.getString(1);
			cName = rs.getString(2);
			cType = rs.getString(3);
			cAdd = rs.getString(4);
		}

		rs.close();
		ps.close();

		PrintWriter outs = null;
		StringBuffer buf = null;

		outs = response.getWriter();
		buf = new StringBuffer();

		buf.append("{Info:[{cCode:'").append(cCode).append("',cName:'").append(
				cName).append("',cType:'").append(cType).append("',cAdd:'")
				.append(cAdd).append("'}]}");
		outs.write(buf.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
