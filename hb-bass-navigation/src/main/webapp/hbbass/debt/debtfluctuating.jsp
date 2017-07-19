<%@ page contentType="text/html; charset=gb2312"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Ƿ�Ѳ�������</title>
    <link href="js/ntree.css" rel="stylesheet" type="text/css" />
	<script language="javascript" src="js/ntree.js"></script>
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
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
	String zbname = new String(request.getParameter("zbname").getBytes("iso-8859-1"),"gbk");
	String[] area = new String(request.getParameter("area").getBytes("iso-8859-1"),"gbk").split("@");
	%>
	<script type="text/javascript">
	var dirNum = 3 ;//������ʱ�洢�ӽڵ������,��ʼֵ��Ϊ3 
	var onclicks = [];//onclick��������
	var curDim ="zb_name" ;//γ��
	var condition =  "<%=request.getParameter("condition")%>";//����
	var curCompareName="����";
	var curConfDim=false;
	
	var normalformat = [numberFormatDigit2,numberFormatDigit2,percentFormat];
	
	var zhanbiformat = [percentFormat,percentFormat,percentFormat];
	
	var cellformat = normalformat;
	var orizbcode = "<%=request.getParameter("zbcode")%>";
	var zbcode = orizbcode;
	var zbname = "<%=zbname%>";
	var sArea = "<%=area[0]%>";
	var sValueType = "<%=request.getParameter("valuetype")%>";
	var division= "<%=request.getParameter("division")%>";
	var tableName= "<%=request.getParameter("tableName")%>";
	var dtype= "<%=request.getParameter("dtype")%>";
	var sDate = "<%=date%>";
	var hasFluctuating = [];
	hasFluctuating["nmk.st_debt_all_MM"]=["mcust_Lid,viptype,�ͻ��ȼ�","biz_type,2,ҵ��ṹ","nbilling_tid,nbilling_tid,�Ʒ����"];
	
	var bizType=[];
	bizType["'����'"]="debtcharge_rent_s";
	bizType["'����'"]="debtcharge_call_s";
	bizType["'��ֵ'"]="debtcharge_incre_s";
	bizType["'����'"]="debtcharge_data_s";
	bizType["'SP'"]="debtcharge_sp_s";
	bizType["'����'"]="debtcharge_other_s";
	
	if(tableName in hasFluctuating)curConfDim=hasFluctuating[tableName];
	else curConfDim=[];
	
	if(sValueType=="tongbi")curCompareName="ͬ��";
	else if(sValueType=="yeartongbi")curCompareName="��ͬ��";
	
	function search()
	{
		document.getElementById("odiv").style.display ="";
		document.getElementById("odiv").innerHTML ="" ;
		
		aa = new System.UI.ntree($("odiv"),initTable(zbname));
		
		fluctuatingAction("zbcode="+zbcode+"&date="+sDate+"&area="+sArea+"&dim="+curDim+"&valuetype="+sValueType+"&condition="+encodeURIComponent(condition)+"&division="+division+"&tableName="+tableName+"&dtype="+dtype);
		//aa.rootNode.afterLineTd.style.display = "" ;
	}
	
	function getOption(sDim,mapping,bizType)
	{
		curDim=sDim;
		fluctuatingAction("zbcode="+zbcode+"&date="+sDate+"&bizType="+bizType+"&area="+sArea+"&mappingTagName="+mapping+"&dim="+curDim+"&valuetype="+sValueType+"&condition="+encodeURIComponent(condition)+"&division="+division+"&tableName="+tableName+"&dtype="+dtype);
	}
	
	function fluctuatingAction(sParam)
	{
		var ajax = new AIHBAjax.Request({
			url:"debtAction.jsp?method=fluctuating",
			loadmask : true,
			param:sParam,
			callback:function(foo)
			{
				data = foo.responseText;
				var list = new Array();
				lines = data.split("|");//�ָ���
				for (i =0;i < lines.length; i++)
				{
					line = lines[i].split(",");//��Ϊ��
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
  		<%=area.length>1?area[1]:"ȫʡ"%> <%=date!=null?date.split("@")[0]:""%> <%=zbname%> 
  	</div>
  	<div class="content">
	<div id="odiv"></div>
	<div id="tip" style="position:absolute;visibility:hidden" ></div>
    </div>
  </div>
   <%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>