<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@ page import="org.apache.log4j.Logger"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
<!--
.grid-tab-blue{
	/**/background-color:#c3daf9;
}
.grid_title_blue {
	background:#ebf3fd url(../../image/default/grid3-hrow-over.gif) repeat-x left bottom;
}
.grid_title_cell {
	color: #000000;
	font-family: "????";
	font-size: 12px;
	line-height: 25px;
	height:25px;
	text-align: center;
	font-weight : normal;
	font-variant: normal;
}
.grid_row_blue {
	/**/background-color: #FFFFFF;
}
.grid_row_cell {
	font-family: "????";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	text-align: center;
	padding: 0 px 3 px 0px 3px;
}
.dim_row{
	padding-left: 3 px;
	height:23px;
}
.dim_row_submit{
	height:20px;
}
.dim_cell_title {
	padding-left: 3 px;
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width: 10%;
	background-color: #D9ECF6;
}
/* 查询条件值  */
.dim_cell_content {
	padding-left: 3 px;
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	color: #000000;
	width: 23%;
	background-color:#EFF5FB;
}
.form_button{
	BORDER-RIGHT: #7b9ebd 1px solid; 
	BORDER-TOP: #7b9ebd 1px solid; 
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px ,2px; 
	FONT-SIZE: 12px; 
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); 
	CURSOR: hand; 
	COLOR: black;
 	width:80px;
 	height:20px;
 	margin-left:5px;
}
-->
</style>

<style type="text/css">
.tipFont {
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
}
</style>
		
<%
	Logger log = Logger.getLogger("jsp." + request.getServletPath());
	log.info("================jsp path:" + request.getServletPath());
	String userId = (String)request.getSession().getAttribute("loginname");
	String cityId = (String)request.getSession().getAttribute("area_id");
	String username = (String)request.getSession().getAttribute("username");
	String BASS_IP = "10.25.124.29";
	request.getSession().setAttribute("BASS_IP","10.25.124.29");
	String WEB_DS = "jdbc/WEBDB";
	String DW_DS = "jdbc/DWDB";
	request.getSession().setAttribute("WEB_DS","jdbc/WEBDB");
	request.getSession().setAttribute("DW_DS","jdbc/DWDB");
	String tipTitle = "操作提示";
%>
</head>
<input type="hidden" id="userId" value="<%=userId %>"/>
<input type="hidden" id="cityId" value="<%=cityId %>"/>
<input type="hidden" id="username" value="<%=username %>"/>
<script type="text/javascript">
//设置Ext超时时长
Ext.Ajax.timeout = 1000 * 600;

Ext.BLANK_IMAGE_URL="<%=request.getContextPath()%>/common/script/ext/resources/images/default/s.gif";
/**
 * 获得当前时间的字符串(无中间连接符)
 */
function getCurrentTimeStr(){
	var now = new Date();
	var year = now.getYear();
	var month = now.getMonth()+1;
	if (month < 10) {
		month = "0" + month;
	}
	var day = now.getDate();
	if (day < 10) {
		day = "0" + day;
	}
	var hours = now.getHours();
	if (hours < 10) {
		hours = "0" + hours;
	}
	var minutes = now.getMinutes();
	if (minutes < 10) {
		minutes = "0" + minutes;
	}
	var seconds = now.getSeconds();
	if (seconds < 10) {
		seconds = "0" + seconds;
	}
	var milliseconds = now.getMilliseconds();
	var currentTimeStr = year+""+month+""+day+""+hours+""+minutes+""+seconds+""+milliseconds;
	return currentTimeStr;
}
/**
 * 获得当前时间的yyyyMMddhhmmssSSS字符串(无中间连接符)
 */
function getCurrentTimeStryyyyMMdd(){
	var now = new Date();
	var year = now.getYear();
	var month = now.getMonth()+1;
	if (month < 10) {
		month = "0" + month;
	}
	var day = now.getDate();
	if (day < 10) {
		day = "0" + day;
	}
	var hours = now.getHours();
	if (hours < 10) {
		hours = "0" + hours;
	}
	var minutes = now.getMinutes();
	if (minutes < 10) {
		minutes = "0" + minutes;
	}
	var seconds = now.getSeconds();
	if (seconds < 10) {
		seconds = "0" + seconds;
	}
	var milliseconds = now.getMilliseconds();
	var currentTimeStr = year+""+month+""+day;
	return currentTimeStr;
}
/**
 * 获得当前日期的字符串(带中间连接符)
 */
function getCurrentDate(currentTimeStr){
	var currentTime = currentTimeStr.substr(0, 4) + "-" + currentTimeStr.substr(4, 2) + "-" + currentTimeStr.substr(6, 2);
	return currentTime;
}
/**
 * 获得当前时间的字符串(带中间连接符)
 */
function getCurrentTime(currentTimeStr){
	var currentTime = currentTimeStr.substr(0, 4) + "-" + currentTimeStr.substr(4, 2) + "-" + currentTimeStr.substr(6, 2)+ " " + currentTimeStr.substr(8, 2)+ ":" + currentTimeStr.substr(10, 2)+ ":" + currentTimeStr.substr(12, 2)+ "." + currentTimeStr.substr(14, 3);
	return currentTime;
}

/** 
* 格式化数字显示方式 
* 用法 
* formatNumber('','')=0                                        
* formatNumber(123456789012.129,null)=123456789012             
* formatNumber(null,null)=0                                    
* formatNumber(123456789012.129,'#,##0.00')=123,456,789,012.12 
* formatNumber(123456789012.129,'#,##0.##')=123,456,789,012.12 
* formatNumber(123456789012.129,'#0.00')=123,456,789,012.12    
* formatNumber(123456789012.129,'#0.##')=123,456,789,012.12    
* formatNumber(12.129,'0.00')=12.12                            
* formatNumber(12.129,'0.##')=12.12                            
* formatNumber(12,'00000')=00012                               
* formatNumber(12,'#.##')=12                                   
* formatNumber(12,'#.00')=12.00                                
* formatNumber(0,'#.##')=0                                     
* @param num 
* @param pattern 
*/   
function formatNumber(num,pattern){    
  var strarr = num?num.toString().split('.'):['0'];    
  var fmtarr = pattern?pattern.split('.'):[''];    
  var retstr='';    
   
  // 整数部分    
  var str = strarr[0];    
  var fmt = fmtarr[0];    
  var i = str.length-1;      
  var comma = false;    
  for(var f=fmt.length-1;f>=0;f--){    
    switch(fmt.substr(f,1)){    
      case '#':    
        if(i>=0 ) retstr = str.substr(i--,1) + retstr;    
        break;    
      case '0':    
        if(i>=0) retstr = str.substr(i--,1) + retstr;    
        else retstr = '0' + retstr;    
        break;    
      case ',':    
         comma = true;    
         retstr=','+retstr;    
        break;    
     }    
   }    
  if(i>=0){    
    if(comma){    
      var l = str.length;    
      for(;i>=0;i--){    
         retstr = str.substr(i,1) + retstr;    
        if(i>0 && ((l-i)%3)==0) retstr = ',' + retstr;    
       }    
     }    
    else retstr = str.substr(0,i+1) + retstr;    
   }    
   
   retstr = retstr+'.';    
  // 处理小数部分    
   str=strarr.length>1?strarr[1]:'';    
   fmt=fmtarr.length>1?fmtarr[1]:'';    
   i=0;    
  for(var f=0;f<fmt.length;f++){    
    switch(fmt.substr(f,1)){    
      case '#':    
        if(i<str.length) retstr+=str.substr(i++,1);    
        break;    
      case '0':    
        if(i<str.length) retstr+= str.substr(i++,1);    
        else retstr+='0';    
        break;    
     }    
   }    
  return retstr.replace(/^,+/,'').replace(/\.$/,'');    
}

/**
 *取得单选按钮的值 
 */
function getRadioValue(name) {
	var obj = document.getElementsByName(name);
	var value = "";
	for ( var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			value = obj[i].value;
		}
	}
	return value;
}
/**
 * 获得当前浏览器类型及版本
 */
function browserInfo(){
	var Browser_Name=navigator.appName;
	var Browser_Version=parseFloat(navigator.appVersion);
	var Browser_Agent=navigator.userAgent;
	var Actual_Version,Actual_Name;
	var is_IE=(Browser_Name=="Microsoft Internet Explorer");//判读是否为ie浏览器
	var is_NN=(Browser_Name=="Netscape");//判断是否为netscape浏览器
	var is_op=(Browser_Name=="Opera");//判断是否为Opera浏览器
	if(is_NN){
		//upper 5.0 need to be process,lower 5.0 return directly
		if(Browser_Version>=5.0){
			if(Browser_Agent.indexOf("Netscape")!=-1){
				var Split_Sign=Browser_Agent.lastIndexOf("/");
				var Version=Browser_Agent.lastIndexOf(" ");
				var Bname=Browser_Agent.substring(0,Split_Sign);
				var Split_sign2=Bname.lastIndexOf(" ");
				Actual_Version=Browser_Agent.substring(Split_Sign+1,Browser_Agent.length);
				Actual_Name=Bname.substring(Split_sign2+1,Bname.length);
			}
			if(Browser_Agent.indexOf("Firefox")!=-1){
				var Split_Sign=Browser_Agent.lastIndexOf("/");
				var Version=Browser_Agent.lastIndexOf(" ");
				Actual_Version=Browser_Agent.substring(Split_Sign+1,Browser_Agent.length);
				Actual_Name=Browser_Agent.substring(Version+1,Split_Sign);
			}
			if(Browser_Agent.indexOf("Safari")!=-1){
				if(Browser_Agent.indexOf("Chrome")!=-1){
					var Split_Sign=Browser_Agent.lastIndexOf(" ");
					var Version=Browser_Agent.substring(0,Split_Sign);;
					var Split_Sign2=Version.lastIndexOf("/");
					var Bname=Version.lastIndexOf(" ");
					Actual_Version=Version.substring(Split_Sign2+1,Version.length);
					Actual_Name=Version.substring(Bname+1,Split_Sign2);
				}
				else{
					var Split_Sign=Browser_Agent.lastIndexOf("/");
					var Version=Browser_Agent.substring(0,Split_Sign);;
					var Split_Sign2=Version.lastIndexOf("/");
					var Bname=Browser_Agent.lastIndexOf(" ");
					Actual_Version=Browser_Agent.substring(Split_Sign2+1,Bname);
					Actual_Name=Browser_Agent.substring(Bname+1,Split_Sign);

				}
			}
		}
		else{
			Actual_Version=Browser_Version;
			Actual_Name=Browser_Name;
		}
	}
	else if(is_IE){
		var Version_Start=Browser_Agent.indexOf("MSIE");
		var Version_End=Browser_Agent.indexOf(";",Version_Start);
		Actual_Version=Browser_Agent.substring(Version_Start+5,Version_End)
		Actual_Name=Browser_Name;

		if(Browser_Agent.indexOf("Maxthon")!=-1||Browser_Agent.indexOf("MAXTHON")!=-1){
			var mv=Browser_Agent.lastIndexOf(" ");
			var mv1=Browser_Agent.substring(mv,Browser_Agent.length-1);
			mv1="遨游版本:"+mv1;
			Actual_Name+="(Maxthon)";
			Actual_Version+=mv1;
		}
	}
	else if(Browser_Agent.indexOf("Opera")!=-1){
		Actual_Name="Opera";
		var tempstart=Browser_Agent.indexOf("Opera");
		var tempend=Browser_Agent.length;
		Actual_Version=Browser_Version;
	}
	else{
		Actual_Name="Unknown Navigator";
		Actual_Version="Unknown Version";
	}
	/*------------------------------------------------------------------------------
	--Your Can Create new properties of navigator(Acutal_Name and Actual_Version) --
	--Userage:                                                                     --
	--1,Call This Function.                                                        --
	--2,use the property Like This:navigator.Actual_Name/navigator.Actual_Version;--
	------------------------------------------------------------------------------*/
	navigator.Actual_Name=Actual_Name;
	navigator.Actual_Version=Actual_Version;

	/*---------------------------------------------------------------------------
	--Or Made this a Class.                                                     --
	--Userage:                                                                  --
	--1,Create a instance of this object like this:var browser=new browserinfo;--
	--2,user this instance:browser.Version/browser.Name;                        --
	---------------------------------------------------------------------------*/
	this.Name=Actual_Name;
	this.Version=Actual_Version;
	//document.write("你使用的浏览器是:"+navigator.userAgent);
	//document.write("<br>");
	//document.write("你使用的浏览器是:"+navigator.Actual_Name+",版本号:"+navigator.Actual_Version);
	var resultArr = new Array();
	resultArr[0] = navigator.Actual_Name;
	resultArr[1] = navigator.Actual_Version;
	return resultArr;
}
//-------------------------------项目内公共方法------------------------------------
// 取得所有选中行的column这个字段值,用','拼接起来
function getSelectedColumnValue(obj, column) {
	var result = "";
	var selections = obj.getSelectionModel().getSelections();
	if (selections.length < 1) {
		return "";
	} else {
		for ( var i = 0; i < selections.length; i++) {
			var record = selections[i];
			if (record.get(column) && record.get(column) != '') {
				result += "," + record.get(column);
			}
		}
		result = result.substring(1);
		return result;
	}
}
//清除下拉框的值
function clearValue(objId) {
	Ext.getCmp(objId).clearValue();
}

//多数页面被包含的常量
var userId = $('#userId').val();
var cityId = $('#cityId').val();
var userName = $('#username').val();

var SEPERATOR = "~@~";
//设置每页显示多少条记录
var itemsPerPage = 10;
var WEB_DS = "jdbc/WEBDB";
var DW_DS = "jdbc/DWDB";
</script> 

</html>