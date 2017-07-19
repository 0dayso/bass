<%@ page autoFlush="true" contentType="application/octet-stream; charset=utf-8"%>
<%@page import="java.util.List"%>
<%
	String title= request.getParameter("title");
	//title= new String(title.getBytes("ISO-8859-1"),"gbk");
	String filename=request.getParameter("filename");
	//filename=new String(filename.getBytes("ISO-8859-1"),"gbk");
	
	//设置HTTP头
	response.addHeader("Content-Disposition","attachment; filename="+filename+".csv");
	out.clear();
	out.println(title);

	List list = (List)request.getAttribute("resultList");
	
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