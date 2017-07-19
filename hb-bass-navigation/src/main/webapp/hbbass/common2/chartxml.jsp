<%@ page contentType="text/html; charset=gb2312"%>
<%@page import = "bass.common.SQLSelect,bass.common2.FusionChart,java.util.List"%>
<%
	out.clear();
	
	String sql = request.getParameter("sql");
	String name = request.getParameter("name");
	String tagname = request.getParameter("tagname");
	
	sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
	
	System.out.println("========"+sql);
	
	try
	{
		SQLSelect sqlSelect = new SQLSelect();
		List list = sqlSelect.getTotalList(sql);
		out.write(FusionChart.getXML(list,name,tagname));
		out.flush();
		//bw.close();
	}
	catch(Exception e)
	{
	   e.printStackTrace();
	   System.out.println("Éú³ÉxmlÊ§°Ü");
	}
	//out.print(filename);
%>