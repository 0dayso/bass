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
var f = _url.indexOf('http://10.25.124.29:8088/db2app55/indexBi.jsp');
var ie = isIE();
if(f>=0){
	if(!ie){
		alert("对不起,由于您将访问的平台暂不支持除IE以外的浏览器,若要继续访问，请选择IE浏览器打开本系统再继续访问该平台!");
	}else{
		if(/^http:/i.test(_url)){
			window.open(_url,'',',location=yes,menubar=yes,toolbar=yes,titlebar=yes,scrollbars=yes,resizable=yes,status=yes,width='+screen.availWidth+',height='+screen.availHeight);

		} else{
			window.location.href=url;
		}
	}
}else{
	if(/^http:/i.test(_url)){
		window.open(_url,'',',location=yes,menubar=yes,toolbar=yes,titlebar=yes,scrollbars=yes,resizable=yes,status=yes,width='+screen.availWidth+',height='+screen.availHeight);

	} else{
		window.location.href=url;
	}
}


function isIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
	  return true;
	  else
	  return false;
} 
</script>