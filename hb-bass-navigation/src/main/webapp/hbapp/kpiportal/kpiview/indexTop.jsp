<%@ page contentType="text/html; charset=utf-8"%>
<%
String appName=request.getParameter("appName");
String fixNo = "1";
String value = "";

if("CollegeD".equalsIgnoreCase(appName)){
	value="高校日KPI统一视图,mainFrame,kpiview.jsp?appName="+appName;
}else if ("CollegeM".equalsIgnoreCase(appName)){
	value="高校月KPI统一视图,mainFrame,kpiview.jsp?appName="+appName;
}else if ("GroupcustD".equalsIgnoreCase(appName)){
	value="集团日KPI统一视图,mainFrame,kpiview.jsp?appName="+appName;
}else if ("GroupcustM".equalsIgnoreCase(appName)){
	value="集团月KPI统一视图,mainFrame,kpiview.jsp?appName=GroupcustM";
}else if ("ChannelM".equalsIgnoreCase(appName)){
	value="月KPI统一视图,mainFrame,kpiview.jsp?appName=ChannelM|月区域化视图,mainFrame,kpiview.jsp?appName=BureauM";
	fixNo="2";
}else if ("ChannelD".equalsIgnoreCase(appName)){

	String loginname=(String)session.getAttribute("loginname");
	if("huchun".equalsIgnoreCase(loginname)||"luolihui".equalsIgnoreCase(loginname)){
		value="KPI层级展现,mainFrame,../kpitree/ntree.jsp?a=a|日KPI统一视图,mainFrame,kpiview.jsp?appName=ChannelD|区域化视图,mainFrame,kpiview.jsp?appName=BureauD";
	}else {
		value="日KPI统一视图,mainFrame,kpiview.jsp?appName=ChannelD|区域归属统一视图,mainFrame,kpiview.jsp?appName=BureauD|KPI层级展现,mainFrame,../kpitree/ntree.jsp?a=a";
	}
	fixNo="3";	
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>湖北移动经营分析系统</title>
<link href="../../resources/css/default/mainbass.css" rel="stylesheet" type="text/css" />
<script src="../../resources/js/default/bass.js" language="javascript" type="text/javascript" charset=utf-8></script>
<script type="text/javascript" src="../../resources/js/default/default.js"></script>
</head>
<script language="JavaScript" type="text/javascript">
//定义TAB图片路径及TAB样式
var tabLeftOff = "../../resources/image/tabs/tab_title_left_off.gif";
var tabRightOff = "../../resources/image/tabs/tab_title_right_off.gif";
var tabLeftOn = "../../resources/image/tabs/tab_title_left_on.gif";
var tabRightOn = "../../resources/image/tabs/tab_title_right_on.gif";
var tabTextClassOff = "tab_title_text_off";
var tabTextClassOn = "tab_title_text_on";

var path = "../../resources/";

var theCreateTab = undefined;
var _val="<%=value%>";
//页面加载或刷新时
window.onload = function() {
	var _params = aihb.Util.paramsObj();
	var arrVal=_val.split("|");
	var resVal="";
	for(var _i=0;_i<arrVal.length;_i++){
		if(resVal.length>0)resVal+="|";
		resVal+=arrVal[_i]+"&"+_params._oriUri.replace("appName","appName1");
	}
	$("tabStr").value=resVal;
	
	theCreateTab = new createTab();
	theCreateTab.fixNo=<%=fixNo%>;
	//重置菜单状态
	theCreateTab.init();
	
	//改变窗口大小时
	document.body.onresize = function() {
		//显示隐藏左右稳动箭头
		theCreateTab.cSIcon();
	
		var helpWindow;
	}
}

</script>
<body>
<input type="hidden" name="tabStr" id="tabStr" value="" />
<input type="hidden" name="openTab" id="openTab" value="1" />
<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="top_bg_table">
	<tr>
	<td style="background-image: url(../../resources/image/tabs/top_bgline.gif);background-repeat: repeat-x;"background-position: bottom;>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td valign="bottom" width="100%" height="100%" id="tabTD"></td>
        <td valign="bottom" nowrap="nowrap" style="padding:4px;">
            <img src="../../resources/image/tabs/tab_scroll_left.gif" width="7" height="9" border="0" style="cursor:pointer;margin-right:4px;visibility:hidden;" id="iconScrollLeft" onMouseOver="this.src='image/tabs/tab_scroll_left_over.gif';theCreateTab.moveL();" onMouseOut="this.src='../../resources/image/tabs/tab_scroll_left.gif';theCreateTab.stopMove();" onMouseDown="theCreateTab.moveLF();" onMouseUp="theCreateTab.moveL();">
            <img src="../../resources/image/tabs/tab_scroll_right.gif" width="7" height="9" border="0" style="cursor:pointer;margin-right:4px;visibility:hidden;" id="iconScrollRight" onMouseOver="this.src='image/tabs/tab_scroll_right_over.gif';theCreateTab.moveR();" onMouseOut="this.src='../../resources/image/tabs/tab_scroll_right.gif';theCreateTab.stopMove();" onMouseDown="theCreateTab.moveRF();" onMouseUp="theCreateTab.moveR();">
        </td>
        <td valign="bottom" width="5%" height="100%"><img src="../../resources/image/default/docs.gif" style="cursor: hand;" bordor=0 onclick="window.open('../localres/help.mht')" title="操作说明"></img></td>
    </tr>
</table>
</td>
    </tr>
</table>
</body>
</html>