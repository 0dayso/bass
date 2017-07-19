<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%@page import="org.apache.commons.httpclient.methods.PostMethod"%>
<%!
static Logger log = Logger.getLogger("cachefresh");
%>
<%
	String[] ipadds = //{"http://localhost:28080"}; 
		{"http://localhost:8080"};
	int[] code = new int[ipadds.length];
	String uri = "";
	
	Map map = request.getParameterMap();
   	StringBuffer param = new StringBuffer();
   	param.append("type=").append(request.getParameter("type"));
   	for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();)
	{
		Map.Entry entry = (Map.Entry) iterator.next();
		if(!"type".equalsIgnoreCase((String)entry.getKey()))
			param.append("&").append(entry.getKey())
			.append("=").append(((String[])entry.getValue())[0]);
		
	}
	log.info(param);
	
	HttpClient httpClient = new HttpClient();
	for(int i=0; i< ipadds.length;i++)
	{
		uri = ipadds[i]+"${mvcPath}/hbapp/resources/old/cacherefreshprototype.jsp?nologin=true&"+param;
		PostMethod method = new PostMethod(uri);
		code[i] = httpClient.executeMethod(method);
		log.info(uri+",returncode="+code[i]);
		method.releaseConnection();
	}
	httpClient=null;
	
	boolean bl = true;
	for(int i=0; i< ipadds.length;i++){
		if(code[i]!=200)bl=false;
	}
	
	if(bl){
		out.println("更新成功");
	}else {
		out.println("更新失败");
	}
%>

