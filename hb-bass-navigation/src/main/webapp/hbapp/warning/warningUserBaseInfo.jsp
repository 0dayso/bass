<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLDecoder"%>

<%
	String start = (String) request.getParameter("start");
	String limit = (String) request.getParameter("limit");
	
	
	int index = Integer.parseInt(start);
	int pageSize = Integer.parseInt(limit);
	int end = index + pageSize;
	Connection conn = null;

	System.out.println(index + ":" + end );

	String cityStr = (String) request.getParameter("cityStr");
	String areaStr = (String) request.getParameter("areaStr");

	if (StringUtils.isNotEmpty(cityStr)) {
		cityStr = URLDecoder.decode(cityStr, "utf-8");
	}
	if (StringUtils.isNotEmpty(areaStr)) {
		areaStr = URLDecoder.decode(areaStr, "utf-8");
	}
	
	try {
		conn = ConnectionManage.getInstance().getDWConnection();
		
		String countsql = "select count(*) from  warning_userinfo_log where 1=1 ";
		//System.out.print(countsql);

		if (StringUtils.isNotEmpty(cityStr)) {
			countsql += (" and ucase(cityName) like '%" + cityStr + "%' ");
		}
		if (StringUtils.isNotEmpty(areaStr)) {
			countsql += (" and ucase(countyName) like '%" + areaStr + "%' ");
		
		}
		
		countsql += " with ur";
		//System.out.print(countsql);

		PreparedStatement ps = conn.prepareStatement(countsql);
		ResultSet rs = ps.executeQuery();

		StringBuffer buf = null;
		buf = new StringBuffer();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}

		System.out.println(count + ":::::::::::::::::::");
		if (count > 0) {
			String sql ="select a.* from (select  level,cityName,countyName,channelName ,redWarnVal ,redUserName ,redUserPhone ,orangeWarnVal ,orangeUserName ,orangeUserPhone ,blueWarnVal ,blueUserName ,blueUserPhone,createUser,createDate, ";
			sql +=(" row_number() over(partition by 1 ORDER BY createDate DESC) as row_num");
			sql +=(" from warning_userinfo_log  where 1=1  ");
			if (StringUtils.isNotEmpty(cityStr)) {
				sql += (" and ucase(cityName) like '%" + cityStr + "%' ");
			}
			if (StringUtils.isNotEmpty(areaStr)) {
				sql += (" and ucase(countyName) like '%" + areaStr + "%' ");
			}
			sql += "   ) a    where row_num > " + index + " and row_num <= "
					+ end + " with ur";
			System.out.print(sql);
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			buf.append("{Total:").append(count).append(",Info:[");

			for (int i = 0; rs.next(); i++) {
				if (i != 0) {
					buf.append(",");
				}
				buf.append("{level:'").append(rs.getString(1))
						.append("',cityName:'").append(
								rs.getString(2)).append("',countyName:'")
						.append(rs.getString(3))
						.append("',channelName:'")
						.append(rs.getString(4))
						.append("',redWarnVal:'")
						.append(rs.getString(5)).append(
								"',redUserName:'").append(
								rs.getString(6)).append(
								"',redUserPhone:'")
						.append(rs.getString(7)).append(
								"',orangeWarnVal:'").append(
								rs.getString(8)).append(
								"',orangeUserName:'").append(
								rs.getString(9)).append(
								"',orangeUserPhone:'")
						.append(rs.getString(10))
						.append("',blueWarnVal:'").append(
								rs.getString(11)).append(
								"',blueUserName:'").append(
								rs.getString(12)).append(
								"',blueUserPhone:'").append(
								rs.getString(13)).append(
								"',createDate:'").append(
								rs.getString(14)).
								append("',createUser:'")
						.append(rs.getString(15)).append("'}");
			}
			buf.append("]}");
		} else {
			buf.append("{Total:0,Info:[]}");
		}
		System.out.println(buf.toString() + ":::::::::::::::::::");

		rs.close();
		ps.close();

		PrintWriter outs = null;
		outs = response.getWriter();
		outs.write(buf.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
