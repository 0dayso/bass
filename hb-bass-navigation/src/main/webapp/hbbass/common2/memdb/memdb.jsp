<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String table = (String)request.getParameter("table");
	
	StringBuffer sb =new StringBuffer(5000);
	
	sb.append("<html><head><metahttp-equiv=\"Content-Type\"content=\"text/html;charset=utf-8\"><linkrel=\"stylesheet\"type=\"text/css\"href=\"resources/css/ext-all.css\"/><!--GC--><!--LIBS--><scripttype=\"text/javascript\"src=\"adapter/ext/ext-base.js\"></script><!--ENDLIBS--><scripttype=\"text/javascript\"src=\"ext-all.js\"></script></head><body>");
	
	java.util.List list = bass.common2.MemoryDataBase.getInstance().getList(table,1,1);
	
	
	sb.append("<div id=\"header\" class=\"x-grid3-header\"><div class=\"x-grid3-header-offset\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr class=\"x-grid3-hd-row\">");
	
	String[] lines = (String[])list.get(0);
	
	for(int i = 0; i < lines.length ; i++)
	{
		sb.append("<td class=\"x-grid3-hd x-grid3-cell\" style=\"width: 100px;\">").append("<div class=\"x-grid3-hd-inner\">").append(lines[i]).append("</div></td>");
	}
	sb.append("</tr></table></div></div>");
	
	//data
	sb.append("<div id=\"data\" class=\"x-grid3-scroller\"><div id=\"inner-data\" class=\"x-grid3-body\" >");
	for(int j = 1; j < list.size() ; j++)
	{
		lines = (String[])list.get(j);
		
		if(j%2==0)
		{
			sb.append("<div class=\"x-grid3-row\"");
		}
		else
		{
			sb.append("<div class=\"x-grid3-row x-grid3-row-alt\"");
		}
		sb.append("><table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" class=\"x-grid3-row-table\"><tbody><tr>");
		for(int i = 0; i < lines.length ; i++)
		{
			sb.append("<td tabindex=\"0\" class=\"x-grid3-col x-grid3-cell\"  style=\"width: 100px;\">").append("<div class=\"x-grid3-cell-inner\">").append(lines[i]).append("</div></td>");
		}
		sb.append("</tr></tbody></table></div>"); 
	}
	sb.append("</div></div>");
	
	sb.append("</body></html>");
	
	out.clear();
	out.print(sb.toString());
%>