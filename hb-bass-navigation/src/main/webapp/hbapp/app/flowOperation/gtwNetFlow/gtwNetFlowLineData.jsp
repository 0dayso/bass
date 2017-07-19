<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@page import="com.asiainfo.hbbass.component.util.*"%>
<%@page import="net.sf.json.JSONObject" %>
<%
		String time_id = request.getParameter("time_id");
		//String time_id="201202";
		//String cityCode="";
		String cityCode = request.getParameter("cityCode");
	
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuffer xmlheader=null;
		xmlheader=new StringBuffer();
		StringBuffer xmlgsm=null;
		xmlgsm=new StringBuffer();
		StringBuffer xmltd=null;
		xmltd=new StringBuffer();
		StringBuffer xmlwlan=null;
		xmlwlan=new StringBuffer();
		StringBuffer xmlline=null;
		xmlline=new StringBuffer();
		
		xmlheader.append("<chart caption='GTW网络"+cityCode+"流量近6月趋势图'  lineThickness='1'  showValues='0' formatNumberScale='0' anchorRadius='2'  bgColor='#f4f5f6' divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridAlpha='5' alternateHGridColor='CC3300' shadowAlpha='40' labelStep='2' numvdivlines='5' chartRightMargin='35'  bgAngle='270' bgAlpha='10,10'>");
		xmlheader.append("<categories >");
		//for(int i=-5;i<=0;i++){
		//	xmlheader.append("<category label='"+AIDateUtil.getMonth("yyyyMM",time_id,i)+"'/>");
		//}
		//xmlheader.append("</categories>");
		xmlgsm.append("<dataset seriesName='GSM' color='1D8BD1' anchorBorderColor='1D8BD1' anchorBgColor='1D8BD1'>");
		xmltd.append("<dataset seriesName='TD' color='F1683C' anchorBorderColor='F1683C' anchorBgColor='F1683C'>");
		xmlwlan.append("<dataset seriesName='WLAN' color='DBDC25' anchorBorderColor='DBDC25' anchorBgColor='DBDC25'>");
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			String startTime=AIDateUtil.getMonth("yyyyMM",time_id,-5);
			System.out.print(startTime);
			String sql="select time_id,value(sum(GSM_FLOW)/1024/1024,0),value(sum(td_flow)/1024/1024,0),value(sum(wlan_flow)/1024/1024,0) from nmk.ST_FLOW_KIND_TREND_MS where time_id between "
						+startTime+" and " +time_id ;
			if(cityCode!=""){
				sql+=" and city_id like '%" + cityCode + "%'";
			}
			sql+=" group by time_id order by time_id  ";
			System.out.println(sql);
			ps = conn
					.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()) {
						xmlheader.append("<category label='"+rs.getString(1)+"'/>");
						xmlgsm.append("<set value='"+rs.getDouble(2)+"' />");
						xmltd.append("<set value='"+rs.getDouble(3)+"' />");
						xmlwlan.append("<set value='"+rs.getDouble(4)+"' />");
			}
			
			xmlheader.append("</categories>");
			rs.close();
			ps.close();
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();

		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		xmlgsm.append("</dataset>");
		xmltd.append("</dataset>");
		xmlwlan.append("</dataset>");
		xmlline.append(xmlheader);
		xmlline.append(xmlgsm);
		xmlline.append(xmltd);
		xmlline.append(xmlwlan);
		xmlline.append("</chart>");
		PrintWriter outs = null;
		JSONObject json = new JSONObject();
		json.put("xmldata",xmlline.toString() );
		outs = response.getWriter();
		outs.print(json);
%>
