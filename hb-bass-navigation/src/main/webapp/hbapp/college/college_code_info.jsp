<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.text.DecimalFormat"%>

<%
	String areaCode = (String) request.getParameter("areaCode");
	Connection conn = null;
	try {
		conn = ConnectionManage.getInstance().getDWConnection();

		String sql = "select max(COLLEGE_ID) from COLLEGE_INFO_PT where STATUS <> 'FAL' AND STATE = 1 AND AREA_ID = '"
				+ areaCode + "' with ur";
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		String collegeCode = "";
		if (rs.next()) {
			collegeCode = rs.getString(1);
		}

		if ("".equals(collegeCode)) {
			collegeCode = areaCode + ".C0001";
		} else if (collegeCode == null) {
			collegeCode = areaCode + ".C0001"; //没有地市信息赋值
		} else {
			DecimalFormat df = new DecimalFormat("0000");
			String tempStr = collegeCode
					.substring(collegeCode.length() - 4);
			int tempInt = Integer.parseInt(tempStr) + 1;
			collegeCode = areaCode + ".C" + df.format(tempInt);
		}

		rs.close();
		ps.close();

		PrintWriter outs = null;
		StringBuffer buf = null;

		outs = response.getWriter();
		buf = new StringBuffer();

		buf.append("{Info:[{collegeCode:'").append(collegeCode).append(
				"'}]}");
		outs.write(buf.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
