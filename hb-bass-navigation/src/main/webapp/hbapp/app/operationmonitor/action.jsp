<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.List"%>
<%@page import="com.asiainfo.hbbass.component.chart.FusionChartHelper"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.asiainfo.bass.apps.jsp.sql.ChargeForecast"%>
<%!static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JSPOMAction");%>
<%
try{
	String method = request.getParameter("method");
	
	if ("chartkpiconntrywide".equalsIgnoreCase(method))
	{
		String sql = request.getParameter("sql");
		String name = request.getParameter("name");
		//String ds = request.getParameter("ds");
		if(sql!=null)
		{
			String result = ChargeForecast.chartKpiConntryWide(sql, name);
			request.setAttribute("result",result);
			request.getRequestDispatcher("../../resources/old/translateData.jsp").forward(request,response);
		}
	}
	else if ("chargeAlert".equalsIgnoreCase(method))
	{
		String date1 = request.getParameter("date1");
		String date2 = request.getParameter("date2");
		String zbCode = request.getParameter("zbCode");
		String area = request.getParameter("area");
		String result = ChargeForecast.chargeAlert(date1, date2, zbCode, area);
		request.setAttribute("result",result);
		request.getRequestDispatcher("../../resources/old/translateData.jsp").forward(request,response);
	}
	else if ("chargeForecast".equalsIgnoreCase(method))
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		Calendar cal = GregorianCalendar.getInstance();
		int lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		if(lastDate==cal.get(Calendar.DATE)){
			String timeid = sdf.format(cal.getTime())+(lastDate-1);
			List list = ChargeForecast.chargeForecastList(timeid);
			if(list.size()==0){
				cal.add(Calendar.MONTH, -1);
			}
		}else {
			cal.add(Calendar.MONTH, -1);
		}
		
		StringBuilder sb1 = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		StringBuilder sb = new StringBuilder();
		
		lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		String currentyyyyMM=sdf.format(cal.getTime())+(lastDate-1);
		String yearStr = String.valueOf(cal.get(Calendar.YEAR));
		String preyyyyMM = "";
		for (int i = 0; i < 12; i++) {
			cal.add(Calendar.MONTH, -1);
			lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			
			String yyyyMM = sdf.format(cal.getTime());
			if(i==0)preyyyyMM=yyyyMM+lastDate;
			if(sb1.length()>0)sb1.append(",");
			sb1.append("'").append(yyyyMM+lastDate).append("'");
			
			if(yyyyMM.startsWith(yearStr)){
				if(sb.length()>0)sb.append(",");
				sb.append("'").append(yyyyMM+lastDate).append("'");
			}
			if(sb2.length()>0)sb2.append(",");
			sb2.append("'").append(yyyyMM+(lastDate-1)).append("'");
		}
		
		StringBuilder sql = ChargeForecast.chargeForecastSql(sb1, sb2, sb, currentyyyyMM);
		
		String type = request.getParameter("type");
		if("grid".equalsIgnoreCase(type)){
			String sqlStr= ChargeForecast.chargeForecastSql(sql, currentyyyyMM);
			out.print(sqlStr);
		}else if("chart".equalsIgnoreCase(type)){
			String result = ChargeForecast.chargeForecastChart(sql, currentyyyyMM);
			request.setAttribute("result",result);
			request.getRequestDispatcher("../../resources/old/translateData.jsp").forward(request,response);
		}else if("city".equalsIgnoreCase(type)){
			StringBuilder sql2 = new StringBuilder();
			sql2 = ChargeForecast.chargeForecastCity(sb1, sb2, currentyyyyMM, preyyyyMM);
			log.debug(sql2);
			out.print("{\"date\": \""+currentyyyyMM.substring(0,6)+"\",\"sql\":\""+sql2.toString()+"\"}");
		}
	}
	
}catch(Exception e){
	e.printStackTrace();
	throw e;
}
%>