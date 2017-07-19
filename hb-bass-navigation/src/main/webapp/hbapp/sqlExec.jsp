<%@ page language="java" import="com.asiainfo.hb.web.models.User,java.util.*" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");
String sql = request.getParameter("sql");
%>
<html xmlns:ai>
<HEAD>
<TITLE>湖北移动经营分析系统</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js" charset=utf-8></script>
<script type="text/javascript">
window.onload=function(){
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/sqlExec"
		,parameters : "sqls='"+<%=sql%>+"'"
		,loadmask : false
		,callback : function(xmlrequest){
			//alert(xmlrequest.responseText);
			//location.reload();
		}
	});
	ajax.request();	
}
</script>
</head>                                                                                                                                                                                                                                                                                                             
<body>

</body>
</html>
