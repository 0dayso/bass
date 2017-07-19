<%@ page contentType="text/html; charset=utf-8"%>
<%
String url = "http://10.25.10.144/VGOP";
String vgop = (String)session.getAttribute("vgop");
System.out.println("vgop======================="+vgop);
if(vgop!=null){
	url = vgop;
}
%>
<script>
window.location="<%=url%>";
//window.parent.parent.parent.location="<%=url%>";
</script>
