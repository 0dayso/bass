<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import = "bass.common.SQLSelect"%>
<%@page import = "java.util.List"%>
<%
	out.clear();
	String sql = request.getParameter("sql");
	System.out.println("sql="+sql);
	sql= URLDecoder.decode(sql,"UTF-8");
	// System.out.println("decode="+decodeURIComponent(sql));
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	System.out.println("sql="+sql);
	String param0 = "year(eff_date)*100+month(eff_date)";
	String param1 = "year(state_date)*100+month(state_date)";
	sql = sql.replace("collegemonthparam0", param0).replace("collegemonthparam1", param1);
	System.out.println("sql="+sql);
	String ds = request.getParameter("ds");
	System.out.println("ds="+ds);
	try
	{
		if("web".equalsIgnoreCase(ds))ds ="jdbc/AiomniDB";
		else if("am".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/JDBC_AM";
		
		SQLSelect sqlSelect = ds!=null&&ds.length()>0? new SQLSelect(ds):new SQLSelect((List)session.getAttribute("mappingTagNameQuery"));
		out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		out.write("\r\n");
		out.write("<resultRoot>");
		out.write("\r\n");
		
		List list = sqlSelect.getTotalList(sql);
		
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