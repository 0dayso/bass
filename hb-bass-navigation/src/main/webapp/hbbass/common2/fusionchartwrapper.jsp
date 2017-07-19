<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.asiainfo.hbbass.component.chart.FusionChartHelper"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%
	out.clear();
	String sql = request.getParameter("sql");
	String name = request.getParameter("name");
	String chartType = request.getParameter("chartType");
	String valueType = request.getParameter("valueType");
	String numDivLines = request.getParameter("numDivLines");
	String showNames = request.getParameter("showNames");
	String ds = request.getParameter("ds");
	sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	if(name!=null)name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
	else name ="";
	LOG.info("chart SQL:"+sql);
	try{
		if("web".equalsIgnoreCase(ds))ds ="AiomniDB";
		else if("am".equalsIgnoreCase(ds))ds ="JDBC_AM";
		else ds ="JDBC_HB";
		LOG.info("ds:"+ds);
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list",ds);
		List list = (List)sqlQuery.query(sql);
		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(name);
		if(showNames!=null && showNames.length()>0)options.setShowNames(showNames);
		if(numDivLines!=null && numDivLines.length()>0)options.setNumDivLines(numDivLines);
		
		if("percent".equalsIgnoreCase(valueType))options.setValueType("percent");
		if("dy".equalsIgnoreCase(chartType)){
			String dySeriesName = request.getParameter("dySeriesName");
			if(dySeriesName!=null)dySeriesName = new String(dySeriesName.getBytes("ISO-8859-1"),"UTF-8");
			options.setDySeriesName(dySeriesName);
			LOG.error(FusionChartHelper.chartColLineDY(list,options));
			out.write(FusionChartHelper.chartColLineDY(list,options));
		}else if ( "mc".equalsIgnoreCase(chartType)){
			out.write(FusionChartHelper.chartMultiCol(list,options));
		}else {
			String trendlinesValue = request.getParameter("trendlinesValue");
			String trendlinesDisplayValue = request.getParameter("trendlinesDisplayValue");
			if(trendlinesDisplayValue!=null)trendlinesDisplayValue = new String(trendlinesDisplayValue.getBytes("ISO-8859-1"),"UTF-8");
			options.setTrendlinesValue(trendlinesValue);
			options.setTrendlinesDisplayValue(trendlinesDisplayValue);
			out.write(FusionChartHelper.chartNormal(list,options));
		}
		
		out.flush();
	}
	catch(Exception e){
		e.printStackTrace();
		LOG.error(e.getMessage(),e);
	}
%>
<%!
static Logger LOG = Logger.getLogger("fusionchartwrapper");
%>