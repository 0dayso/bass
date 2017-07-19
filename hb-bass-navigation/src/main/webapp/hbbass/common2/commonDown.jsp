<%@ page autoFlush="true" contentType="application/octet-stream; charset=utf-8"%>
<%@page import="bass.common.SQLSelect"%>
<%@page import="java.util.List"%>
<%
	String oriChartset="iso-8859-1";
	String newChartset="utf-8";
	String title= request.getParameter("title");
	//if(title!=null)title= new String(title.getBytes(oriChartset),newChartset);
	String filename=request.getParameter("filename");if(filename!=null) filename= java.net.URLEncoder.encode(filename, "UTF-8");
	String sql= request.getParameter("sql");
	if(sql!=null)sql= new String(request.getParameter("sql").getBytes(oriChartset),newChartset);
	
	//设置HTTP头
	response.setContentType("text/html;charset=gbk");
	response.addHeader("Content-Disposition", "attachment;filename=" + filename+".csv");
	out.clear();
	out.println(title);
	
	//bass.common.SQLSelect select = new bass.common.SQLSelect((java.util.List)session.getAttribute("mappingTagNameDown"));
	String ds = request.getParameter("ds");
	if("web".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/AiomniDB";
	else if("am".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/JDBC_AM";
	
	SQLSelect select = ds!=null&&ds.length()>0? new SQLSelect(ds):new SQLSelect((List)session.getAttribute("mappingTagNameQuery"));
		
	
	List list = select.getTotalList(sql);
	
	StringBuffer sb = new StringBuffer();
	for ( int i=0; i < list.size(); i ++ )
	{
	  String[] data = (String[])list.get(i);
		for( int j = 0; j < data.length; j++ )
		{
			sb.append(data[j]==null?"":data[j]).append(",");
		}
		out.println(sb.toString());
		sb.delete(0,sb.length());
	}
	//out.flush();
	//response.flushBuffer();
%>