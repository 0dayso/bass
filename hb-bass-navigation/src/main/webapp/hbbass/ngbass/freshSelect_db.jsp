<%@ page contentType="text/html; charset=gb2312" %> 
<%@ page import="com.asiainfo.database.*" %>
<%
  out.clear(); 
  String sql = request.getParameter("sql");
  sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
  sql=sql.replaceAll("btbtbt","+");
  StringBuffer sb = new StringBuffer();
  Sqlca sqlca=null;
	try
	{
		 sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
		 sqlca.execute(sql);
		 while(sqlca.next())
		 {
		    if(sb.toString().equals(""))
		    		sb.append(sqlca.getString("col1")).append("@").append(sqlca.getString("col2"));
		    else
		    	  sb.append("|").append(sqlca.getString("col1")).append("@").append(sqlca.getString("col2"));
		  	
		 }
	}
	catch(Exception excep)
	{
	
		 excep.printStackTrace();
		 System.out.println(excep.getMessage());
	}
	finally
	{
		if(null != sqlca)
			sqlca.closeAll();
	}
	
   response.setCharacterEncoding("gb2312");
	 response.setContentType("text/html; charset=gb2312");
   out.print(sb.toString());
 
 %>