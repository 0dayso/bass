<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "bass.common.NgbassTools,com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%
 NgbassTools.init();
 BassDimCache.getInstance().initialize();
out.println("缓存更新完毕!");
%>
<input type="button" name="bt1" value="关闭" onclick="window.close()">
