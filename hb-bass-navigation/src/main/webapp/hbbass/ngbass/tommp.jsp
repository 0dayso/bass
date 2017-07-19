<%@page contentType="text/html; charset=gb2312"%>
<script type="text/javascript">
<%
	//info of mmp application
	String ip = "10.25.124.46";
	String port = "8081";
	String action = request.getParameter("action");//目前有可能action="stcPlan",这是转到资费营销案首页的情况,并且都是先转到higherzl。.jsp
	if(action == null)
		action = "";
	String url = "http://" + ip + ":" + port + "/mmp/higherzl.jsp?loginname=" + (String)session.getAttribute("loginname") + "&action=" + action;//目前暂时不带参数,直接跳转到首页,但是username是必须带的
		//url = "http://" + ip + ":" + port + "/mmp/stcplan/generalAction.stcplando";//资费营销案首页，不是集成在营管中的情况
	System.out.println("the url : " + url);
	//out.println("alert('" + url + "')");
	response.sendRedirect(url); 
%>
</script>