<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.asiainfo.bass.components.models.DES"%>
<%
	String m_strLoginUserID = (String)session.getAttribute("loginname");
		String pageIdParam = "pageId";
	String urlParam = "targetUrl";
	String realUrl = "";
	String targetUrl = java.net.URLDecoder.decode(request.getParameter(urlParam));
	if (request.getParameter(pageIdParam) != null && request.getParameter(pageIdParam) != ""){ 
		targetUrl = 	targetUrl + "&pageId=" + java.net.URLDecoder.decode(request.getParameter(pageIdParam));
	}
	String userId = DES.encrypt(m_strLoginUserID);
	String seg = targetUrl.substring(targetUrl.lastIndexOf('/') + 1);
	System.out.println("seg=[" + seg + "]");
	if (seg.contains("&")) {
		realUrl = targetUrl + "&userId=" + userId+ "&ailk_autoLogin_userId=" + userId;
	} else if (seg.contains("?") && !seg.endsWith("?")) {
		realUrl = targetUrl + "&userId=" + userId+ "&ailk_autoLogin_userId=" + userId;
	} else {
		realUrl = targetUrl + "?userId=" + userId+ "&ailk_autoLogin_userId=" + userId;
	}
%>

<script language="javascript">
        var _url = '<%=realUrl%>';
        /*if(url.indexOf("10.25.124.115:8084/mmp") != -1){
            window.open(url);
        }else if(url.indexOf("10.25.124.112:8080/db2app55") != -1){
        	//正式10.25.124.112:8080/db2app55
        	//测试10.25.125.12:808/db2app55
        	 window.open(url);
        } else{
            window.location.href=url;
        }*/
if(/^http:/i.test(_url)){
	window.open(_url,'',',location=yes,menubar=yes,toolbar=yes,titlebar=yes,scrollbars=yes,resizable=yes,status=yes,width='+screen.availWidth+',height='+screen.availHeight);

} else{
	window.location.href=url;
}
</script>