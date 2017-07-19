<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>市场运营信息快报</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../../resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="calendar.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../../resources/css/default/default.css" />
	<link type="text/css" rel="stylesheet" href="calendar.css">
	<script type="text/javascript">

var loginname = "<%=((User)session.getAttribute("user")).getId()%>";

gNow.setDate(gNow.getDate()-1);	
Calendar.prototype.setReturnDate = function(returnDate,el) {
	var _month = (parseInt(this.gMonth,10)+1)+"";
	_month = (_month.length==1?"0":"")+_month;
	var _date = parseInt(returnDate,10)+"";
	_date = (_date.length==1?"0":"")+_date;
	this.returnDate = this.gYear+_month+_date;
	gNow.setDate(_date);
	calendar.render();
	getContent();
}
Calendar.prototype.lastYear = function() {
	this.gYear = (parseInt(this.gYear,10)-1) +"";
	gNow.setYear(parseInt(this.gYear,10));
	this.render();
}

Calendar.prototype.nextYear = function() {
	this.gYear = (parseInt(this.gYear,10)+1) +"";
	gNow.setYear(parseInt(this.gYear,10));
	this.render();
}

Calendar.prototype.lastMonth = function() {
	var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];
	gNow.setYear(parseInt(prevYYYY,10));
	gNow.setMonth(parseInt(prevMM,10));
	this.gYear = prevYYYY+"";
	this.gMonth = prevMM+"";
	this.render();
}

Calendar.prototype.nextMonth = function() {
	var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];
	gNow.setYear(parseInt(nextYYYY,10));
	gNow.setMonth(parseInt(nextMM,10));
	this.gYear = nextYYYY+"";
	this.gMonth = nextMM+"";
	this.render();
}
function _render(list){
	var str = "";	
	for (var i=0; i < list.length; i++){
		str += list[i][0].replace(/\r\n/gi,"<br>");
	}
	$("text").innerHTML=str;
	$("feedback_div").style.display="none";
}

function getContent(){
	var date = calendar.returnDate;
	var sql = "select content from FPF_OM_MMSREPORT where time_id = '"+date+"' order by id  with ur";
	var ajax = new aihb.Ajax({
		url:"${mvcPath}/hbirs/action/jsondata"
		,parameters : "sql="+strEncode(sql)+"&ds=web&isCached=false"
		,callback:function(xhr){
			var list = null;
			eval("list="+xhr.responseText);
			var str = "";
			for (var i=0; i < list.length; i++){
				str += list[i].content.replace(/\r\n/gi,"<br>");
			}
			$("text").innerHTML=str;
			$("feedback_div").style.display="none";
		}
	});
	ajax.request();
		
	//ajaxGetListWrapper(sql,_render,undefined,undefined,"&ds=web");
	$("dt").innerText=date;
}

function _import(){
	if(document.getElementById("time_id").value!=""){
		var ajax = new aihb.Ajax({
			url:"${mvcPath}/hbirs/action/operMonitor"
			,parameters : "method=omDailyImport&time_id="+document.getElementById("time_id").value+"&content="+encodeURIComponent(document.getElementById("content").value)
			,callback:function(xmlHttp){
				document.getElementById("time_id").value="";
				document.getElementById("content").value="";
				document.getElementById("feedback_div").style.display="none";
				getContent();
			}
		});	
		ajax.request();
	}else {
		alert("时间不能为空");
	}
}

function showFeedback(id)
{
	$("fid_"+id).style.display="";
}

window.onload=function(){
	if(loginname=="meikefu" || loginname=="zhaozheng" || loginname=="zhangtao2" || loginname=="admin"){
		$("hid").style.display="";
	}
	getContent();
}

aihb.Util.loadmask();
aihb.Util.watermark();
	</script>
  </head>
  <body>
  <div style="padding: 3 px 5 px; display:none;" id="hid">
  	<input type="button" class="form_button_short" value="导入" onclick='{document.getElementById("feedback_div").style.display="";}'>
  </div>
  <table width="98%" align="left" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div  class="portlet">
		    	<div class="title">
		    		市场运营信息快报<span id="dt"></span>
		    	</div>
		    	<div id="dim" class="content">
	            	
	            	<div id="calcont" style="padding: 10 px 5 px 0 px 2 px;float: right;">aaa</div>
				    <script>
			       	calendar = new Calendar({container:"calcont"});
			        calendar.render();
			    	</script> 
	            	<span id="text" style="font-size: 16 px;">
	           
 					</span>
				 </div>
        	</div>
	    </td>
	  </tr>
	</table>
  
  
	<div id="feedback_div" style="display:none;">
	<div style="width:100%;height:200%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='${mvcPath}/hbbass/common2/image/tab-close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
		<table width="99%"><tr>
	 		<td >时间(YYYYMMDD)：<input type='text' id='time_id' name='time_id' size="60" ></td>
	 		<td align="right"><input type="button" class="form_button_short" value="提交" onclick="_import()"></td>
	 		</tr>
	 	</table>
		<div id="text">
			<textarea rows="10" cols="80" id="content" name="content"></textarea>
		</div>
	</div>
	</div>
</body>
</html>