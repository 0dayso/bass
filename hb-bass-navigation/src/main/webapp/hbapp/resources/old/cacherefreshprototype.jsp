<%@page import="java.util.Map"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIAppData"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPICustomize"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIPortalContext"%>
<%
	String type = request.getParameter("type");
	String appName = request.getParameter("appName");
	String date = request.getParameter("date");
	String zbcode = request.getParameter("zbcode");
	String result = "更新失败";
	if("bassCache".equalsIgnoreCase(type)){
		BassDimCache.getInstance().initialize();
		result="更新成功";
	}else if("kpiCustomize".equalsIgnoreCase(type)){
		KPICustomize.init();
		result="更新成功";
	}else if("kpiDate".equalsIgnoreCase(type)){
		if(date!=null && (date.length()==6||date.length()==8)){
			KPIPortalContext.resetDate(appName,date);
			Map kpiApp = KPIPortalContext.getKpiApp();
			KPIAppData appData = (KPIAppData) kpiApp.get(appName);
			if(date.equalsIgnoreCase(appData.getCurrent())){
				result="更新成功";
			}
		}else{
			result="时间有误";
		}
	}else if("kpi".equalsIgnoreCase(type)){
		if(date!=null && (date.length()==6||date.length()==8)){
			if(zbcode!=null && zbcode.length()>0)
				KPIPortalService.refreshKPIEntity(appName,date,zbcode);
			else 
				KPIPortalService.refreshKPIEntities(appName,date);
			result="更新成功";
		}else{
			result="时间有误";
		}
	}
	out.println(result);
%>

