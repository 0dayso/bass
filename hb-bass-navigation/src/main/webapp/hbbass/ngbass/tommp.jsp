<%@page contentType="text/html; charset=gb2312"%>
<script type="text/javascript">
<%
	//info of mmp application
	String ip = "10.25.124.46";
	String port = "8081";
	String action = request.getParameter("action");//Ŀǰ�п���action="stcPlan",����ת���ʷ�Ӫ������ҳ�����,���Ҷ�����ת��higherzl��.jsp
	if(action == null)
		action = "";
	String url = "http://" + ip + ":" + port + "/mmp/higherzl.jsp?loginname=" + (String)session.getAttribute("loginname") + "&action=" + action;//Ŀǰ��ʱ��������,ֱ����ת����ҳ,����username�Ǳ������
		//url = "http://" + ip + ":" + port + "/mmp/stcplan/generalAction.stcplando";//�ʷ�Ӫ������ҳ�����Ǽ�����Ӫ���е����
	System.out.println("the url : " + url);
	//out.println("alert('" + url + "')");
	response.sendRedirect(url); 
%>
</script>