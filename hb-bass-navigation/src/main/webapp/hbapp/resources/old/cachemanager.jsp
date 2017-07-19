<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="bass.common2.BassDimCache"%>
<%@page import="java.util.Map"%>
<%@page import="bass.common2.TreeEntry"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<script language="javascript" src="/hbbass/js/extree/xtree.js"></script>
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<link type="text/css" rel="stylesheet" href="/hbbass/js/jscript/extree/xtree.css" />
  </head>
  <script language="javascript">
	function doSubmit(obj)
	{
		var ajax = new AIHBAjax.Request({
			url:"${mvcPath}/hbapp/resources/old/cacherefreshprototype.jsp",
			param:"who="+obj+"&date="+document.forms[0].date.value+"&zbcode="+document.forms[0].zbcode.value,
			callback:function(xmlHttp)
			{
				alert(xmlHttp.responseText);
				window.location.reload();
			}
		});
		//document.forms[0].action="/hbbass/common2/cacherefresh.jsp?who="+obj;
		//document.forms[0].submit();
	}
  </script>
  <body>
  <form action="" method="post">
  <br>
  日期:<input type="text" name="date">
  指标:<input type="text" name="zbcode">
   <input type="button" value="刷新单个指标" onclick="doSubmit('kpidatecode')">
   <input type="button" value="刷新全部指标" onclick="doSubmit('kpidate')">
   <br>
   <input type="button" value="刷新BASS缓存" onclick="doSubmit('bassCache')">
   <input type="button" value="刷新KpiCustomize缓存" onclick="doSubmit('kpicustomize')">
   </form>
   
   <div style="font-size: 12px;">
   <script language="javascript">
   webFXTreeConfig.setImagePath("/hbbass/js/extree/images/");
	var tree = new WebFXTree("缓存", "");
	<%
List result = new ArrayList();
String[] lines = null;
for (Iterator iterator = BassDimCache.MAP_INDEX.entrySet().iterator(); iterator.hasNext();)
{
	Map.Entry obj = (Map.Entry) iterator.next();
	lines = new String[3];
	lines[0]=(String)obj.getKey();
	lines[1]=lines[0];
	lines[2]="";
	
	result.add(lines);
	
	Map cmap = (Map)obj.getValue();
	int i = 0;
	for (Iterator citerator = cmap.entrySet().iterator(); citerator.hasNext();)
	{
		Map.Entry cobject = (Map.Entry) citerator.next();
		if(cobject.getKey()==null ||((String)cobject.getKey()).length()==0||"全部".equalsIgnoreCase((String)cobject.getValue()))continue;
		lines = new String[3];
		lines[0]=(String)obj.getKey()+"_child"+i;
		//lines[0]=(String)cobject.getKey() ;
		lines[1]= (String)cobject.getKey()+":"+(String)cobject.getValue();
		lines[2]=(String)obj.getKey();
		result.add(lines);
		i++;
	}
}
TreeEntry tree = new TreeEntry();
tree.init(result);
tree.useExtreeProcess();
tree.iterator();
StringBuffer sb = (StringBuffer)tree.getProcess().getObject();
out.print(sb);
%>
document.write(tree);tree.expand();</script>
</div>
  </body>
</html>

