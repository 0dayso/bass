<%@ page contentType="text/html; charset=gb2312"%>
<%
String reportid=request.getParameter("reportid");
String reportname=request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");

String fixNo = "5";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>湖北移动经营分析系统</title>
<link href="../../hbapp/resources/css/default/mainbass.css" rel="stylesheet" type="text/css" />
<script src="../../hbapp/resources/js/default/bass.js" language="javascript" type="text/javascript" charset=utf-8></script>
</head>

<body>
<input type="hidden" name="tabStr" id="tabStr" value="查询条件配置,mainFrame,/hbbass/ngbass/queryConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>|查询sql及结果配置,mainFrame,/hbbass/ngbass/resultConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>|指标分析配置,mainFrame,/hbbass/ngbass/analyConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>|查询测试,mainFrame,/hbbass/ngbass/queryMain.jsp?pid=<%=reportid%>|分析测试,mainFrame,/hbbass/ngbass/analyMain.jsp?pid=<%=reportid%>" />

<input type="hidden" name="openTab" id="openTab" value="1" />
<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="top_bg_table">
	<tr>
	<td style="background-image: url(../../hbapp/resources/image/tabs/top_bgline.gif);background-repeat: repeat-x;"background-position: bottom;>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td valign="bottom" width="100%" height="100%" id="tabTD"></td>
        <td valign="bottom" nowrap="nowrap" style="padding:4px;">
            <img src="../../hbapp/resources/image/tabs/tab_scroll_left.gif" width="7" height="9" border="0" style="cursor:pointer;margin-right:4px;visibility:hidden;" id="iconScrollLeft" onMouseOver="this.src='image/tabs/tab_scroll_left_over.gif';theCreateTab.moveL();" onMouseOut="this.src='../../hbapp/resources/image/tabs/tab_scroll_left.gif';theCreateTab.stopMove();" onMouseDown="theCreateTab.moveLF();" onMouseUp="theCreateTab.moveL();">
            <img src="../../hbapp/resources/image/tabs/tab_scroll_right.gif" width="7" height="9" border="0" style="cursor:pointer;margin-right:4px;visibility:hidden;" id="iconScrollRight" onMouseOver="this.src='image/tabs/tab_scroll_right_over.gif';theCreateTab.moveR();" onMouseOut="this.src='../../hbapp/resources/image/tabs/tab_scroll_right.gif';theCreateTab.stopMove();" onMouseDown="theCreateTab.moveRF();" onMouseUp="theCreateTab.moveR();">
        </td>
        <td valign="bottom" width="5%" height="100%"><img src="../../hbapp/resources/image/default/docs.gif" style="cursor: hand;" bordor=0 onclick="window.open('help.mht')" title="操作说明"></img></td>
    </tr>
</table>
</td>
    </tr>
</table>
</body>
</html>
<script language="JavaScript" type="text/javascript">
	//定义TAB图片路径及TAB样式
	var tabLeftOff = "../../hbapp/resources/image/tabs/tab_title_left_off.gif";
	var tabRightOff = "../../hbapp/resources/image/tabs/tab_title_right_off.gif";
	var tabLeftOn = "../../hbapp/resources/image/tabs/tab_title_left_on.gif";
	var tabRightOn = "../../hbapp/resources/image/tabs/tab_title_right_on.gif";
	var tabTextClassOff = "tab_title_text_off";
	var tabTextClassOn = "tab_title_text_on";
	
	var path = "../../hbapp/resources/";
	
	var theCreateTab = new createTab();
	theCreateTab.fixNo=<%=fixNo%>;
	//页面加载或刷新时
	window.onload = function() {
		//重置菜单状态
		theCreateTab.init();
		
	}
	//改变窗口大小时
	document.body.onresize = function() {
		//显示隐藏左右稳动箭头
		theCreateTab.cSIcon();
		
		var helpWindow;
	}
</script>