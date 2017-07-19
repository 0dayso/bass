<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.asiainfo.hbbass.ws.bo.DealBO"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.asiainfo.bass.components.models.Util"%>
<%@page import="com.asiainfo.hbbass.ws.common.Constant;"%>
<%
	String optype = (String) request.getParameter("optype");
	String userId = (String) request.getSession().getAttribute(
			"loginname");
	String ip = Util.getRemoteAddr(request);
	if ("account".equals(optype)) {
		String account = (String) request.getParameter("account");
		ArrayList<String> arrayList = new ArrayList<String>();
		arrayList.add(account);
		request.getSession().setAttribute("accounts", arrayList);
	}
	if ("remoteAuth".equals(optype)) {
		String appSessionId = (String) request
				.getParameter("appSessionId");
		String clientIp = (String) request.getParameter("clientIp");
		String sceneId = (String) request.getParameter("sceneId");
		String account = (String) request.getParameter("account");
		String time = (String) request.getParameter("time");
		String approver = (String) request.getParameter("approver");
		String caseDesc = URLDecoder.decode((String) request
				.getParameter("caseDesc"), "utf-8");
		SimpleDateFormat sdf = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.HOUR, Integer.valueOf(time));
		int hour = calendar.get(calendar.HOUR_OF_DAY);
		String beginTime = sdf.format(new Date());
		String endTime = sdf.format(calendar.getTime());
		boolean isPass = DealBO.getInstance().remoteFirstAuth(userId, clientIp,
				appSessionId, approver, caseDesc, beginTime, endTime,
				ip, account, sceneId);
		if (isPass) {
			request.getSession().setAttribute("passFlag", Constant.TRUE);
		} else {
			request.getSession().setAttribute("passFlag", Constant.FALSE);
		}
	}
	if ("remoteAuth2".equals(optype)) {
		String appSessionId = (String) request
				.getParameter("appSessionId");
		String clientIp = (String) request.getParameter("clientIp");
		String sceneId = (String) request.getParameter("sceneId");
		String account = (String) request.getParameter("account");
		String time = (String) request.getParameter("time");
		String approver = (String) request.getParameter("approver");
		String pwCode = (String) request.getParameter("pwCode");
		SimpleDateFormat sdf = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.HOUR, Integer.valueOf(time));
		int hour = calendar.get(calendar.HOUR_OF_DAY);
		String beginTime = sdf.format(new Date());
		String endTime = sdf.format(calendar.getTime());
		boolean isPass = DealBO.getInstance().remoteSecondAuth(userId,
				clientIp, appSessionId, approver, pwCode, beginTime,
				endTime, ip, account, sceneId);
		if (isPass) {
			request.getSession().setAttribute("passFlag", Constant.TRUE);
		} else {
			request.getSession().setAttribute("passFlag", Constant.FALSE);
		}
	}
	if ("siteAuth".equals(optype)) {
		String appSessionId = (String) request
				.getParameter("appSessionId");
		String clientIp = (String) request.getParameter("clientIp");
		String sceneId = (String) request.getParameter("sceneId");
		String account = (String) request.getParameter("account");
		String time = (String) request.getParameter("time");
		String approver = (String) request.getParameter("approver");
		String pwCode = (String) request.getParameter("pwCode");
		SimpleDateFormat sdf = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.HOUR, Integer.valueOf(time));
		int hour = calendar.get(calendar.HOUR_OF_DAY);
		String beginTime = sdf.format(new Date());
		String endTime = sdf.format(calendar.getTime());
		boolean isPass = DealBO.getInstance().siteAuth(userId,
				clientIp, appSessionId, approver, pwCode, beginTime,
				endTime, ip, account, sceneId);
		if (isPass) {
			request.getSession().setAttribute("passFlag", Constant.TRUE);
		} else {
			request.getSession().setAttribute("passFlag", Constant.FALSE);
		}
	}
	if ("workOrderAuth".equals(optype)) {
		String appSessionId = (String) request
				.getParameter("appSessionId");
		String clientIp = (String) request.getParameter("clientIp");
		String sceneId = (String) request.getParameter("sceneId");
		String account = (String) request.getParameter("account");
		String time = (String) request.getParameter("time");
		String approver = (String) request.getParameter("approver");
		String operContent = (String) request.getParameter("operContent");
		String workorderNO = (String) request.getParameter("workorderNO");
		SimpleDateFormat sdf = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.HOUR, Integer.valueOf(time));
		int hour = calendar.get(calendar.HOUR_OF_DAY);
		String beginTime = sdf.format(new Date());
		String endTime = sdf.format(calendar.getTime());
		String cerReason = (String) request.getParameter("caseDesc");
		boolean isPass = DealBO.getInstance().workOrderAuth(userId, clientIp, 
				appSessionId, operContent, workorderNO, beginTime, endTime, cerReason,
				ip, account, sceneId);
		if (isPass) {
			request.getSession().setAttribute("passFlag", Constant.TRUE);
		} else {
			request.getSession().setAttribute("passFlag", Constant.FALSE);
		}
	}
%>