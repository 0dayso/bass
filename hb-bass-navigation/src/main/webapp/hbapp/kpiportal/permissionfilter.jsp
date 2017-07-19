<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.message.ShortMessage"%>
<%@page import="bass.message.PhoneException"%>
<%@page import="java.util.Map"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%
	if(session.getAttribute("KPI_CITY")==null){
		Map map = (Map)BassDimCache.getInstance().get("kpiportal");
		String permStr = (String)session.getAttribute("loginname");
		if(map==null||map.size()==0||map.containsKey(permStr))
		{
			if(map==null||map.size()==0)
			{
				ShortMessage sm = new ShortMessage();
				try {
					sm.setPhone("13697339119");
					sm.setMessage("kpiportal 的缓存不正确");
					sm.sendShortMessage();
				} catch (PhoneException e) {
					e.printStackTrace();
				}
			}
			session.setAttribute("KPI_CITY","0");
			String url = request.getParameter("suburl");
			String prefix = "${mvcPath}/hbapp/";
			response.sendRedirect(prefix+url.replace('|', '&'));
		}
		else{
			response.sendRedirect("/kpi/daily.jsp");
		}
	}else{
		String url = request.getParameter("suburl");
		String prefix = "${mvcPath}/hbapp/";
		response.sendRedirect(prefix+url.replace('|', '&'));
	}
%>