<%@ page contentType="text/html; charset=gb2312"%>
<%@page import = "java.util.*,java.io.*"%>
<%
	out.clear();  

	try
	{
		List list = (List)request.getAttribute("result");
		out.write("<?xml version=\"1.0\" encoding=\"GB2312\"?>");
		out.write("\r\n");
		out.write("<resultRoot>");
		out.write("\r\n");
		
		StringBuffer sb=new StringBuffer();
		
		for (int i = 0; i < list.size(); i++)
		{
			String[] line = (String[])list.get(i);
			sb.append("<result id='").append(i).append("'>");
			
			for (int j = 0; j < line.length; j++)
			{
				if(line[j] != null && line[j].length() > 0)
				{
					line[j] = line[j].replace('<','{').replace('>','}');
				}
				sb.append("<col").append(j).append(">").append(line[j]==null?"":line[j]).append("</col").append(j).append(">");
			}
			sb.append("</result>\r\n");
			out.write(sb.toString());
			sb.delete(0, sb.length());
		}
		
		out.write("</resultRoot>");
		out.flush();
		//bw.close();
	}
	catch(Exception e)
	{
	   e.printStackTrace();
	}
	
	//out.print(filename);
%>