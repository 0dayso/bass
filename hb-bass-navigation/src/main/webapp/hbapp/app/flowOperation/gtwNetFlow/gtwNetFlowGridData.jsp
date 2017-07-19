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
	System.out.println("+++++++++++++++"+cityCode);
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	if (StringUtils.isNotEmpty(time_id)) {
		time_id = URLDecoder.decode(time_id, "utf-8");
	}
	if (StringUtils.isNotEmpty(cityCode)) {
		cityCode = URLDecoder.decode(cityCode, "utf-8");
	}
	
	try {
		conn = ConnectionManage.getInstance().getDWConnection();
		String result="";
		
		String infosql ="select  decimal(decimal(sum(gsm_flow),22,2)/1024/1024/1024,12,3) as gsm_flow,  TRIM(REPLACE(strip(replace( char(decimal(decimal(sum(GSM_FLOW))*100/sum(TOTAL_FLOW),8,2)) , '0.', '#'),B,'0'),'#','0.'))|| '%' as g_per ,"
		 +" decimal(decimal(sum(td_flow),22,2)/1024/1024/1024,12,3) as td_flow,TRIM(REPLACE(strip(replace( char(decimal(decimal(sum(TD_FLOW))*100/sum(TOTAL_FLOW),8,2)) , '0.', '#'),B,'0'),'#','0.'))||'%' as t_per,"
         +" decimal(decimal(sum(wlan_flow),22,2)/1024/1024/1024,12,3) as wlan_flow,TRIM(REPLACE(strip(replace( char(decimal(decimal(sum(WLAN_FLOW))*100/sum(TOTAL_FLOW),8,2)) , '0.', '#'),B,'0'),'#','0.'))||'%' as w_per,"
         +"decimal(decimal(sum(total_flow),22,2)/1024/1024/1024,12,3) as total_flow  from NMK.ST_FLOW_KIND_TREND_MS where 1=1";
		if (StringUtils.isNotEmpty(cityCode)) {
			infosql += (" and ucase(city_id) like '%" + cityCode + "%' ");
		}
		if (StringUtils.isNotEmpty(time_id)) {
			infosql += (" and time_id =" + time_id);
		}
		System.out.println(infosql);
		ps = conn.prepareStatement(infosql);
		rs = ps.executeQuery();
		if(rs.next()){
				result+=rs.getDouble(1)+"|"+rs.getString(2)+"|"+rs.getDouble(3)+"|"+rs.getString(4)+"|"+rs.getDouble(5)+"|"+rs.getString(6)+"|"+rs.getString(7);
			}
		
		rs.close();
		ps.close();
		if (StringUtils.isNotEmpty(cityCode)) {
			String sql="select area_name from  mk.bt_area where area_code like '%"+cityCode+"%'";
			System.out.println("test"+sql);
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
			result+="|"+rs.getString(1);
			}
			rs.close();
			ps.close();
		}
		else{
			result+="|全省";
		}
		System.out.println(result);
		PrintWriter outs = null;
		JSONObject json = new JSONObject();
		json.put("gridData",result);
		outs = response.getWriter();
		outs.print(json);
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
