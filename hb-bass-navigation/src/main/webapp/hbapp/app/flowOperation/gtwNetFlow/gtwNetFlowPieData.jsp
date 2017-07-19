<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject" %>
<%
	String time_id = (String) request.getParameter("time_id");
	String cityCode = (String) request.getParameter("cityCode");
	
	
	Connection conn = null;

	if (StringUtils.isNotEmpty(time_id)) {
		time_id = URLDecoder.decode(time_id, "utf-8");
	}
	if (StringUtils.isNotEmpty(cityCode)) {
		cityCode = URLDecoder.decode(cityCode, "utf-8");
	}
	
	try {
		conn = ConnectionManage.getInstance().getDWConnection();
		
		String sql="select count(1) from nmk.ST_FLOW_KIND_TREND_MS where 1=1 ";

		if (StringUtils.isNotEmpty(cityCode)) {
			sql += (" and ucase(city_id) like '%" + cityCode + "%' ");
		
		}
		
		sql += " with ur";
		System.out.println(sql);

		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		StringBuilder buf = null;
		buf = new StringBuilder();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}
		System.out.println(count + "****:::::::::::::::::::");
		if (count > 0) {
			String infosql ="select decimal(decimal(sum(gsm_flow),22,2)/1024/1024/1024,12,3),decimal(decimal(sum(td_flow),22,2)/1024/1024/1024,12,3),decimal(decimal(sum(wlan_flow),22,2)/1024/1024/1024,12,3) from nmk.ST_FLOW_KIND_TREND_MS where 1=1 ";
			if (StringUtils.isNotEmpty(cityCode)) {
			infosql += (" and ucase(city_id) like '%" + cityCode + "%' ");
			}
			if (StringUtils.isNotEmpty(time_id)) {
			infosql += (" and time_id  =" + time_id + " ");
			}
			System.out.println(infosql);
			ps = conn.prepareStatement(infosql);
			rs = ps.executeQuery();
			buf.append("<chart palette='2'caption='GTW "+time_id+"月"+cityCode+"流量' numberScaleValue='1048576' numberScaleUnit='G'  bgColor='#FFFFFF'>");
			if(rs.next()){
				buf.append("<set label='GSM' value='"+rs.getString(1)+"'/>");
				buf.append("<set label='TD' value='"+rs.getString(2)+"'/>");
				buf.append("<set label='WLAN' value='"+rs.getString(3)+"'/>");
				}
			buf.append("</chart>");
			System.out.println(buf);
		}
		rs.close();
		ps.close();
		PrintWriter outs = null;
		JSONObject json = new JSONObject();
		json.put("xmldata",buf.toString() );
		outs = response.getWriter();
		outs.print(json);
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
