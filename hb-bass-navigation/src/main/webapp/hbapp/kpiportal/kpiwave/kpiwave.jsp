<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI波动分析</title>
    <script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<script language="javascript" src="waventree.js"></script>
	<link rel="stylesheet" type="text/css" href="../localres/ntree.css" />
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
	<style type="text/css">
	.selectarea {
		font-size:12 px;
		width:130px;
		padding: 5 px;
		z-index:30;background-color: #EFF5FB;
		border:1px solid #c3daf9;
		filter:alpha(opacity=80);
	}
	.selectarea .close{
		position:absolute ;
		top:1px;right : 1px;
		font:bold 10px tahoma,arial,helvetica;
	}
	</style>
	<% 
	String date = request.getParameter("date");
	String zbname = request.getParameter("zbname");
	//zbname = new String(zbname.getBytes("iso-8859-1"),"gbk");
	String[] area = request.getParameter("area").split("@");
	//String[] area = new String(request.getParameter("area").getBytes("iso-8859-1"),"gbk").split("@");
	%>
	<script type="text/javascript">
	var dirNum = 3 ;//用来临时存储子节点的数量,初始值设为3 
	var onclicks = [];//onclick函数数组
	var curDim ="zb_name" ;//纬度
	var condition ="" ;//条件
	var curCompareName="环比";
	var curConfDim=false;
	nodepath="../localres/images/";
	var normalformat = [numberFormatDigit2,numberFormatDigit2,percentFormat];
	
	var zhanbiformat = [percentFormat,percentFormat,percentFormat];
	
	var cellformat = normalformat;
	
	var zbcode = "<%=request.getParameter("zbcode")%>";
	var zbname = "<%=zbname%>";
	var sArea = "<%=area[0]%>";
	var sValueType = "<%=request.getParameter("valuetype")%>";
	var sDate = "<%=date%>";
	
	if(zbcode in hasFluctuating)
	{
		curConfDim=hasFluctuating[zbcode];
		if(curConfDim==zhanbi)cellformat=zhanbiformat;
	}
	else curConfDim=[];
	
	if(sValueType=="tongbi")curCompareName="同比";
	else if(sValueType=="yeartongbi")curCompareName="年同比";
	
	function search()
	{
		document.getElementById("odiv").style.display ="";
		document.getElementById("odiv").innerHTML ="" ;
		
		aa = new System.UI.ntree($("odiv"),initTable(zbname));
		
		fluctuatingAction("zbcode="+zbcode+"&date="+sDate+"&area="+sArea+"&dim="+curDim+"&valuetype="+sValueType+"&condition=");
		//aa.rootNode.afterLineTd.style.display = "" ;
	}
	
	function getOption(sDim,mapping)
	{
		curDim=sDim;
		fluctuatingAction("zbcode="+zbcode+"&date="+sDate+"&area="+sArea+"&mappingTagName="+mapping+"&dim="+curDim+"&valuetype="+sValueType+"&condition="+encodeURIComponent(condition));
	}
	
	function fluctuatingAction(sParam)
	{
		var ajax = new AIHBAjax.Request({
			url:"../action.jsp?appName=<%=request.getParameter("appName")%>&method=wave",
			loadmask : true,
			param:sParam,
			callback:function(foo)
			{
				data = foo.responseText;
				var list = new Array();
				lines = data.split("|");//分割行
				for (i =0;i < lines.length; i++)
				{
					line = lines[i].split(",");//分为列
					var inner = new Array();
					for (j =0;j < line.length; j++)
					{
						inner.push(line[j]);
					}
					list.push(inner);
				}
				renderTable(list);
			}
		});
	}
	
	function showBox(elem){

		var childs = elem.parentElement.parentElement.parentElement.parentElement.childNodes ;
		childs[3].style.display="none" ;
		childs[4].style.display="block" ;
		for(var i=1;i<=2;i++){
			childs[i].style.display = "" ;
		}
		elem.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement._instance.resizeBar();
	}
	function hiddenBox(elem){

		var childs = elem.parentElement.parentElement.parentElement.parentElement.childNodes ;
		childs[3].style.display = "block" ;
		childs[4].style.display = "none" ;
		for(var i=1;i<=2;i++){
			childs[i].style.display = "none" ;
		}
		var tag = "from";
		elem.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement._instance.resizeBar();
	}
	</script>
  </head>
  <body onload="search()">
  <div class="portlet">
  	<div class="title" style="height: 23 px;font-weight:bold;">
  		<%=area.length>1?area[1]:"全省"%> <%=date%> <%=zbname%> 
  	</div>
  	<div class="content">
	<div id="odiv"></div>
	<div id="tip" style="position:absolute;visibility:hidden" ></div>
    </div>
  </div>
</body>
</html>
<script>
aihb.Util.loadmask();
aihb.Util.watermark();
</script>