<%@ page contentType="text/html; charset=utf-8"%>
<%
	java.util.List list = (java.util.List)request.getAttribute("resultList");
	
	out.clear();
	out.write("<?xml version=\"1.0\" encoding=\"GB2312\"?>");
	out.write("<resultRoot>");
	
	StringBuffer sb=new StringBuffer();
	
	for (int i = 0; list!=null&&i < list.size(); i++)
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
	out.flush();
%>