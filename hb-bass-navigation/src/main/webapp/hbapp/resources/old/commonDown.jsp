<%@ page autoFlush="true" contentType="application/octet-stream; charset=utf-8"%>
<%@page import="bass.common.SQLSelect"%>
<%@page import="java.util.List"%>
<%
	String title= new String(request.getParameter("title").getBytes("ISO-8859-1"),"gbk");
	String filename=request.getParameter("filename");
	String sql= new String(request.getParameter("sql").getBytes("ISO-8859-1"),"gbk");	
	
	//设置HTTP头
	response.addHeader("Content-Disposition","attachment; filename="+filename+".csv");
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