<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
String method = (String)request.getParameter("method");

if("treeList".equalsIgnoreCase(method))
{
	out.clear();
	
	out.print(bass.common2.MemoryDataBase.getInstance().getJsonStringOfMeta());
}
else if ("updateTable".equalsIgnoreCase(method))
{
	System.out.println("=============table"+ request.getParameter("table"));
	
	Thread.sleep(3000);
	//bass.common2.MemoryDataBase.getInstance().refreshTable((String)request.getParameter("table"));
}

%>