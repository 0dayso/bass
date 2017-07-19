<%@ page contentType="application/octet-stream; charset=utf-8" language="java" %><jsp:useBean id="cp" scope="session" class="bass.database.compete.CompetePool"/><%@page import = "java.util.*,struts.utility.*,java.io.*"%><%
String title=request.getParameter("title");
title=new String(title.getBytes("ISO-8859-1"),"gb2312");      
String colnum=request.getParameter("colnum");
String sql=request.getParameter("sql");
sql=new String(sql.getBytes("ISO-8859-1"),"gb2312"); 
String filename=request.getParameter("filename")==null?"down":request.getParameter("filename");
out.println(title);
int pageNum = Integer.parseInt(request.getParameter("page"));
int perFile = Integer.parseInt(request.getParameter("perPage"));
response.addHeader("Content-Disposition","attachment; filename="+filename+pageNum+".csv");
String  outStr="";
List result = StaticSelect.searchResults2(sql,pageNum,perFile);
if(result !=null)
for(int i = 0;i<result.size();i++)
{
      outStr= "";
      for(int j=0;j<Integer.parseInt(colnum);j++)
       {
         outStr+=StaticSelect.getValue2(result,i,j)+",";
       }
     out.println(outStr);
     out.flush();  
     response.flushBuffer();  

} 
%>