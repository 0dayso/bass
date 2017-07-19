<%@ page contentType="text/html; charset=utf-8"%>
<%@page import = "java.util.List"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%
	out.clear();
	String sql = request.getParameter("sql");
	//sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	System.out.println(sql);
	String ds = request.getParameter("ds");
	try
	{
		if("web".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/AiomniDB";
		else if("am".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/JDBC_AM";
		
		SQLQuery sqlQuery = null;
		
		if(ds!=null&&ds.length()>0){
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list",ds);
		}else 
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		
		out.write("<?xml version=\"1.0\" encoding=\"GBK\"?>");
		out.write("\r\n");
		out.write("<resultRoot>");
		out.write("\r\n");
		
		List list = (List)sqlQuery.query(sql);
		
		StringBuffer sb=new StringBuffer();
		
		for (int i = 0; i < list.size(); i++)
		{
			String[] line = (String[])list.get(i);
			sb.append("<result id='").append(i).append("'>");
			
			for (int j = 0; j < line.length; j++)
			{
				if(line[j] != null && line[j].length() > 0)
				{
					line[j] = line[j].replace('<','{').replace('>','}').replace('&','|').replace('\'','‘').replace('\"','“');
				}
				sb.append("<col").append(j).append(">").append(line[j]==null?"":line[j]).append("</col").append(j).append(">");
			}
			sb.append("</result>\r\n");
			out.write(sb.toString());
			sb.delete(0, sb.length());
		}
		
		out.write("</resultRoot>");
		//out.flush();
		//bw.close();
	}
	catch(Exception e)
	{
	   e.printStackTrace();
	   System.out.println("生成xml失败");
	}
	
	//out.print(filename);
%>