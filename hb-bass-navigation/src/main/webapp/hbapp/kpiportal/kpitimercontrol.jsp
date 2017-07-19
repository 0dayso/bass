<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIEntityContainerFactory"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIEntityCache"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIEntity"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.asiainfo.hbbass.component.tree.TreeEntity"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIPortalContext"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%!static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger("JSPKpiTimer");%><%
//bass.kpiportal.KpiPortalConstant.DAILY_CURRENT="20081123";
%>
<html>
  <head>
    <title></title>
	<script language="javascript" src="../resources/js/extree/xtree.js"></script>
	<script type="text/javascript" src="../resources/old/basscommon.js" charset=utf-8></script>
	<link type="text/css" rel="stylesheet" href="../resources/js/extree/xtree.css" />
  </head>
  <script language="javascript">
	function doSubmit(obj)
	{
		var ajax = new AIHBAjax.Request({
			url:"../resources/old/cacherefreshprototype.jsp",
			param:"type="+obj+"&appName="+document.forms[0].appName.value+"&date="+document.forms[0].date.value+"&zbcode="+document.forms[0].zbcode.value,
			callback:function(xmlHttp)
			{
				alert(xmlHttp.responseText);
				window.location.reload();
			}
		});
		//document.forms[0].action="/hbbass/common2/cacherefresh.jsp?who="+obj;
		//document.forms[0].target = "_self";
		//document.forms[0].submit();
	}
	webFXTreeConfig.setImagePath("./../resources/js/extree/images/");
	var tree = new WebFXTree("缓存", "");
  </script>
  <body style="font-size: 12px;">
  <form action="" method="post">
  调度目前的状态:<%=application.getAttribute("KpiPortalTimer")==null?"关闭":"开启"%>
  <br>
  应用:
  <select name="appName">
  	<option value="ChannelD">ChannelD(渠道日)</option>
  	<option value="ChannelM">ChannelM(渠道月)</option>
  	<option value="BureauD">BureauD(区域化日)</option>
  	<option value="BureauM">BureauM(区域化月)</option>
  	<option value="GroupcustD">GroupcustD(集团日)</option>
  	<option value="GroupcustM">GroupcustM(集团月)</option>
  	<option value="CollegeD">CollegeD(高校日)</option>
  	<option value="CollegeM">CollegeM(高校月)</option>
  	<option value="EntGridD">EntGridD(网格化日)</option>
  	<option value="CsD">CsD(客服日)</option>
  	<option value="CsM">CsM(客服月)</option>
  </select>
  日期:<input type="text" name="date" value="">
  指标:<input type="text" name="zbcode" value="">
   <input type="button" value="刷新单个指标" onclick="doSubmit('kpi')">
   <input type="button" value="刷新全部指标" onclick="doSubmit('kpi')">
   <input type="button" value="刷新kpiDate" onclick="doSubmit('kpiDate')">
   <input type="button" value="刷新bassCache" onclick="doSubmit('bassCache')">
   <input type="button" value="刷新KPICustom" onclick="doSubmit('kpiCustomize')">
   
   <br>
   </form>
<div >
   <script language="javascript">
	<%
	/*List result = null;
	String[] lines = null;
	TreeEntity tree = null;
	KPIEntityCache kpiEntityCache = null;

	for (Iterator iterator = KPIPortalContext.getKpiApp().entrySet().iterator(); iterator.hasNext();) {
		
		Map.Entry entry = (Map.Entry) iterator.next();
		String appName = (String)entry.getKey();
		kpiEntityCache =  KPIEntityContainerFactory.getInstance().getCache(appName);
		if(kpiEntityCache!=null){
			result = new ArrayList();
			List list = kpiEntityCache.getKeys();
			for(int i=0; list!=null && i<list.size(); i++)
			{
				String key = (String)list.get(i);
				lines = new String[3];
				lines[0]=appName+"_"+key;
				lines[1]=lines[0];
				lines[2]="";
				result.add(lines);
				LOG.info("CacheName:"+kpiEntityCache.getName());
				Map cmap = (Map)kpiEntityCache.getKPIEntities(key);
				if(cmap!=null){
					
					for (Iterator citerator = cmap.entrySet().iterator(); citerator.hasNext();)
					{
						Map.Entry cobject = (Map.Entry) citerator.next();
						
						KPIEntity centry = (KPIEntity)cobject.getValue();
						lines = new String[3];
						lines[0]=centry.getId();
						lines[1]=centry.toString();
						lines[2]=appName+"_"+key;
						result.add(lines);
					}
				}
			}
			if(result.size()>0){
				tree = new TreeEntity();
				tree.init(result);
				tree.useExtreeProcess();
				tree.iterator();
				StringBuffer sb = (StringBuffer)tree.getProcess().getObject();
				out.print(sb);
			}
		}
	}*/
%>
   //document.write(tree);tree.expand();
</script>
</div>
  </body>
</html>

