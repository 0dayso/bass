<%@ page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
String type=request.getParameter("type");

// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	

%>
<html>
  <head>
    <title>收入预测分析</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset="utf-8"></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../kpiportal/localres/kpi.js" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  	pagenum=31;
	hbbasscommonpath="../../resources/old/"
  	function footbar(){return "";}
  	cellclass[1]="grid_row_cell_number";
  	cellclass[2]="grid_row_cell_number";
	cellfunc[2]=numberFormatDigit2;
	
	cellfunc[0]=function(datas,options){
		if(datas[0].length==8){
			return datas[0].substring(0,6);
		}
		return datas[0];
	}	
	cellfunc[1]=function(datas,options){
		console.log(datas);
		console.log(options);
		if(datas[0].length==6 && options.rownum ==10){
			return "预测收入：<font color=red>"+numberFormatDigit2(datas,options)+"</font>";
		}
		return numberFormatDigit2(datas,options);
	}
	
	function chargeAlert()
	{
		var ajax = new AIHBAjax.Request({
			<%if("city".equalsIgnoreCase(type)){ %>
			url: "action.jsp?method=chargeForecast&type=city",
			callback:function(xmlHttp){
				var obj = {};
				eval("obj="+xmlHttp.responseText.trim()+";");
				seqformat[0]=obj.date;
				ajaxSubmitWrapper(obj.sql);
			}
			<%}else{ %>
			url: "action.jsp?method=chargeForecast&type=grid",
			callback:function(xmlHttp){
				ajaxSubmitWrapper(xmlHttp.responseText);
			}
			<%} %>
			
		});
	}
  </script>
  <body onload='chargeAlert()'>
  
   	<div id="grid" class="content" style="width: 100%;;">
    	<div id="showResult" ></div>
           <div id="title_div" style="display:none;">
           	<table id="resultTable" align="center" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				<tr class="grid_title_blue">
				   <%if("city".equalsIgnoreCase(type)){ %>
				   <td class="grid_title_cell">地市</td>
				   <td class="grid_title_cell">#{0}预测收入(万元)</td>
				   <td class="grid_title_cell">上月收入(万元)</td>
				   <%}else{ %>
				   <td class="grid_title_cell">时间</td>
				   <td class="grid_title_cell">收入(万元)</td>
				   <%} %>
				</tr>
			</table>
		</div>
    </div>
	        	
	</form>
</body>
</html>

