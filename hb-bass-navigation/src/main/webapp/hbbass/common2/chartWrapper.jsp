<%@ page contentType="text/html; charset=gb2312"%>
<%@page import = "bass.common.SQLSelect"%>
<%@page import = "java.util.List"%>
<%@page import="bass.kpiportal.KpFChartHelper"%>
<%
	String sql = request.getParameter("sql");
	sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	String showNames = request.getParameter("showNames");
	String chartName = request.getParameter("chartName");
	chartName = new String(chartName.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	System.out.println(sql);
	String ds = request.getParameter("ds");
	try
	{
		if("web".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/AiomniDB";
		else if("am".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/JDBC_AM";
		
		SQLSelect sqlSelect = ds!=null&&ds.length()>0? new SQLSelect(ds):new SQLSelect((List)session.getAttribute("mappingTagNameQuery"));
		
		List list = sqlSelect.getTotalList(sql);
		KpFChartHelper.Options options = new KpFChartHelper.Options();
		options.setCaption(chartName);
		options.setShowNames(showNames);
		options.setShowValues("1");
		
		String result = KpFChartHelper.chartNormal(list,options);
		result.replaceAll("-","");
		System.out.print(result);
		out.clear();
		out.write(result);
		out.flush();
	}
	catch(Exception e)
	{
	   e.printStackTrace();
	   System.out.println("Éú³ÉxmlÊ§°Ü");
	}
%>