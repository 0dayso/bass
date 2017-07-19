<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.asiainfo.hbbass.ws.common.Constant"%>
<%@page import="org.apache.log4j.Logger"%>
<html>
	<head>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<%!
			static Logger LOG = Logger.getLogger("com.asiainfo.index.jsp");
		%>
		<%
			String appSessionId = (String)request.getParameter("appSessionId");
			String lastUrl = (String)request.getParameter("url");
			String clientIp = (String)request.getParameter("ip");
			String maxTime = (String)request.getParameter("maxTime");
			String cooperate = (String)request.getParameter("cooperate");
			String sceneId = (String)request.getParameter("sceneId");
			String accounts = (String)request.getParameter("accounts");
			String returnUrl = (String)request.getParameter("returnUrl");
			String result = (String)request.getParameter("result");
			LOG.info(result);
			String cooperateStatus = (String)request.getParameter("cooperateStatus");
			LOG.info(cooperateStatus);
			boolean passFlag= false;
			String accountFlag = "N";
			if (cooperate == null || cooperate == "") {
				accountFlag = "Y";
			}
			//2表示已授权
			if(result.equals("2")){
				accountFlag = "Y";
			}
		%>
		<script type="text/javascript">
			Ext.onReady(function() {
			<%
			if(cooperateStatus=="0"){
			%>
				alert("无协作人，请联系4A管理员");
			<%
			}else{
				if(accountFlag=="N"){
			%>
					var params = {
							accounts:'<%=accounts%>'
					};
					var returnValue = window.showModalDialog('/hbapp/cooperative/account.jsp',params,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
					var accountReturn=returnValue.step;
					var account=returnValue.account;
					if('close' == accountReturn){
						window.location = '<%=returnUrl%>';
						return;
					}
					if('next' != accountReturn){
						return;
					}
					var PARAM_INFO = {
							appSessionId:'<%=appSessionId%>',
							clientIp:'<%=clientIp%>',	
							sceneId:'<%=sceneId%>',
							lastUrl:'<%=lastUrl%>',
							maxTime:'<%=maxTime%>',
							cooperate:'<%=cooperate%>',
							accounts:account
						};
					
						var RETRUN_INFO = window.showModalDialog('/hbapp/cooperative/show.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;center:yes');
						var uri = '<%=lastUrl%>';
						if('close' == RETRUN_INFO.isClose){
							window.location = '<%=returnUrl%>';
							return;
						}else if('pass' == RETRUN_INFO.isClose){
							alert("验证通过，请点击下载按钮下载！");
							location.href = uri;
							return;
						}
						if('remoteAuth' == RETRUN_INFO.model){
							var codeReturn = window.showModalDialog('/hbapp/cooperative/code.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
							if('close' == codeReturn.isClose){
								window.location = '<%=returnUrl%>';
								return;
							}else if('pass' == codeReturn.isClose){
								alert("验证通过，请点击下载按钮下载！");
								window.location = uri;
								return;
							}
						}
			<%
				}else{
					%>
						var url = '<%=lastUrl%>';
						window.location = url;
					<%
				}
			}
			%>	
				
				
			});
		</script>
	</head>
	<body>
	</body>
</html>