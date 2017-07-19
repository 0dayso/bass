<%@page contentType="text/html;charset=gb2312"%>
<jsp:useBean id="cppool" scope="application" class="bass.database.compete.CompetePool"/>
<%@ page    import="bass.common.DevidePageBean, java.util.Calendar" %>
<SCRIPT language="JavaScript">
function help()                    
{                    
var userwindow=window.open('cp_queryhelp.jsp' , "SelectUserWindow", "height=230, width=400, left=620, top=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no");
userwindow.focus();
}
function isNumeric(tstValue)
{
   var i=0;
   var str=""+tstValue;
   var l=str.length;
   var c=str.charAt(i++);
   var Ok="0123456789., ";

   while ((c==' ') && (i<l)) {
      c=str.charAt(i++);
   }
   if (i==l) return (Ok.indexOf(c)>=0);
   if ((c=='+')||(c=='-')) c=str.charAt(i++);
   while ((Ok.indexOf(c)>=0) && (i<l)) {
      c=str.charAt(i++);
   }
   if (i==l) return (Ok.indexOf(c)>=0);
   if ((c=='e')||(c=='E')) {
      c=str.charAt(i++);
      while ((c==' ') && (i<l)) {
         c=str.charAt(i++);
      }
      if (i==l) return true;
      if ((c=='+')||(c=='-')) c=str.charAt(i++);
      if (Ok.indexOf(c)<0) return false;
      while ((((c>='0')&&(c<='9'))||(c==' ')) && (i<l)) {
         c=str.charAt(i++);
      }
      return ((i==l) && (((c>='0')&&(c<='9'))||(c==' ')));
   }
   else
      return false;
}
function changeView(num)
{
	if(num==0)
	{
		option.style.display="none";
		batchoption.style.display="none";
		//Layer1.style.display="";
	}
	else if(num==1)
	{
		option.style.display="none";
		batchoption.style.display="";
		//Layer1.style.display="";
	}
	else if(num==2)
	{
		batchoption.style.display="none";
		option.style.display = "";
		//Layer1.style.display="none";
	}
}

function isEmpty(){
  if(document.formx.acc_nbr.value==""){
          alert("请输入要查询手机号码！");
          return false;
  }
  
  if(isNumeric(document.formx.acc_nbr.value)){
	if(document.formx.acc_nbr.value.length!=11){
		alert("输入位数不对！");
   	    return false;
	}
  }else	{
	alert("输入中有非数字！");
	return false;
   }
}

function onClickSubmit()
{
	
	var usertype="";
	var userarea="";
	if(document.formx.radio[0].checked)
	{
		if(isEmpty()==false)
		{
			document.formx.acc_nbr.focus();
        	document.formx.acc_nbr.select();
			return;
		}
		
	}
	else if(document.formx.radio[2].checked)
	{
		temp = parseInt(document.formx.rowcount.value);
		//alert(temp);
	
		if(isNaN(temp))
		{
			alert("输入中有非数字");
			document.formx.rowcount.focus();
			document.formx.rowcount.select();
			return;
		}
		if(document.formx.area.options(document.formx.area.selectedIndex).value==11 || document.formx.area.options(document.formx.area.selectedIndex).value == 0)
		{
			if(temp > 15000)
			{
				alert("所选条数不能超过15000");
				document.formx.rowcount.focus();
				document.formx.rowcount.select();
				return;
			}
		}
		else
		{
			if(temp > 15000)
			{
				alert("所选条数不能超过15000");
				document.formx.rowcount.focus();
				document.formx.rowcount.select();
				return;
			}
		}

	}

	document.formx.Submit.disabled=true;
	document.formx.action = "pagination.jsp";
  document.formx.submit();
}

</SCRIPT>
<%!String[] months = {"01","02","03","04","05","06","07","08","09","10","11","12"};%>
<%

int area_id = Integer.parseInt((String)session.getAttribute("area_id"));
String[][] areaarray = cppool.getAreaArray(area_id,2);
String wherearea=(area_id==0?" where area_id<>0":" where area_id="+area_id+" ");

//取当天的日期
Calendar calendar =Calendar.getInstance();
int year=calendar.get(calendar.YEAR);
int month=calendar.get(calendar.MONTH)+1;
int day=calendar.get(calendar.DATE);
int beginyear=year-2;
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>
<title>挖高分析</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">

<!--

@import url("/hbbass/css/com.css");

-->

</style>
<style type="text/css">

<%--

input {

border: 1px solid #000000;

background-color: #F7F7F7;

color: 004E1D;

}

--%>
.style1 {font-size: 7}
.style2 {font-size: 14px}
.style1 {color: #663399}
.style3 {	color: #663399;
	font-size: 12px;
	font-weight: bold;
}
.style4 {font-family: "宋体"; font-size: 12px; line-height: 20px; color: #FF3300; background-color: #EBEBEB; }
</style>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="/hbbass/common2/alertsms.js"></script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="${mvcPath}/images/bg.gif">

<form name="formx" method="post" action="">
<table   width="86%"  border="0" align="center" cellpadding="0">
  <tr>
 	<td>
      <input id="single" name="radio" type="radio" value="single" onClick="changeView(0)">
      <label for="single" style="cursor:hand "><span class="style2">请输入竞争对手号码:</span></label>
      <input name="acc_nbr" type="text" size="11" maxlength="11">
	</td>
  </tr>
  <tr>
 	<td><input name="radio" type="radio" id="batch" onClick="changeView(1)" value="batch" checked>
 	<label for="batch" style="cursor:hand "><span class="style2">批量选取高端客户:</span></label>
    </td>
  </tr>
  <tr id='batchoption' style="display:"><td>
  &nbsp;&nbsp;&nbsp;
  	 <select name="area_high">   
     <%  
		         DevidePageBean cityInit=new DevidePageBean();
		         String citySQL="Select dm_city_id,cityname from FPF_user_city where parentid='-1'"; 
		     		 if(area_id>0)
		     		 citySQL=citySQL+" and cityid='"+area_id+"'";
		     		 citySQL=citySQL+" order by cityid";
		     		 cityInit.setQuerySQL(citySQL);
		     		 for(int i=1;i<=cityInit.getAllRowCount();i++){
 		     %>
              <option value="<%=cityInit.getFieldValue("dm_city_id",i)%>" ><%=cityInit.getFieldValue("cityname",i)%></option>
         <%}%>
			      </select>
			    
    <font color="#000066">对端类型:
    <select name="1calledtype">
      <option value="ug">联通GSM</option>
      <option value="uc">电信C网</option>
      <option value="ph">小灵通</option>
    </select>
统计时间:
<select name="1abegintime1">
                <%

						 for(int y=year;y>beginyear;y--){

                         %>
                <option value="<%=y%>"><%=y%></option>
                <%}%>
              </select>
年
<select name="1abegintime2">
  <%for(int i =1;i<13;i++){%>
  <option value="<%=months[i-1]%>" <%if(i == (month-1)) out.println("selected");%>><%=months[i-1]%></option>
  <%}%>
</select>
月</font></td>
  </tr>
  <tr>
 	<td>
      <input id="all" name="radio" type="radio" value="all" onClick="changeView(2)">
      <label for="all" style="cursor:hand "><span class="style2">批量选取竞争对手号码,请选择下列条件:</span></label>
    </td>
  </tr>
  <tr>
    <td>&nbsp;
         <table id="option" style="display:none" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#e7e7e7" >
          <tr bgcolor="#e4e9ff"> 
            <td width="117" height="32"> <div align="left"><font color="#000066">检索地域</font></div></td>
            <td width="240">
			 <div align="left"> 
          <select name="area">   
          <%  
		         DevidePageBean cityInit2=new DevidePageBean();
		         String citySQL2="Select dm_city_id,cityname from FPF_user_city where parentid='-1'"; 
		     		 if(area_id>0)
		     		 citySQL2=citySQL2+" and cityid='"+area_id+"'";
		     		 citySQL2=citySQL2+" order by cityid";
		     		 cityInit2.setQuerySQL(citySQL2);
		     		
		     		 for(int i=1;i<=cityInit2.getAllRowCount();i++){
 		     %>
              <option value="<%=cityInit2.getFieldValue("dm_city_id",i)%>"><%=cityInit2.getFieldValue("cityname",i)%></option>
         <%}%>
			      </select>
              </div></td>
            <td><font color="#000066">通话时长层次</font>
            	
            	</td>
            <td><select name="callduratype">
                <option value="10">所有</option>
                <option value="1">主叫</option>
                <option value="0">被叫</option>
              </select> 大于<input type=text name="calldura" size=6 value="">分钟</td>

          </tr>

          <tr> 

            <td width="117" height="35"> <div align="left"><font color="#000066">对端类型</font></div></td>

            <td width="240"> <div align="left"> 

                <select name="calledtype">
                  <option value="ug">联通GSM</option>

                  <option value="uc">电信C网</option>

                 <option value="ph">小灵通</option>

                </select>

              </div></td>

            <td width="135"> <font color="#000066">通话次数层次</font>
            	
            </td>

            <td width="232">
            <select name="calltimetype">
                <option value="10">所有</option>
                <option value="1">主叫</option>
                <option value="0">被叫</option>
              </select> 大于<input type=text name="calltimes" size=6 value="">次数</select> </td>

          </tr>

          <tr bgcolor="#e4e9ff"> 

            <td height="29"><font color="#000066">统计时间</font></td>

            <td ><select name="abegintime1">
              <%

						 for(int y=year;y>beginyear;y--){

                         %>
              <option value="<%=y%>"><%=y%></option>
              <%}%>
            </select>
年
<select name="abegintime2">
  <%for(int i =1;i<13;i++){%>
  <option value="<%=months[i-1]%>" <%if(i == (month-1)) out.println("selected");%>><%=months[i-1]%></option>
  <%}%>
</select>
月 </td>

            <td><div align="left"><font color="#000066">选取条数</font></div></td>

            <td><input name="rowcount" type="text" value="100" size="10" maxlength="5"></td>

          </tr>

        </table>
	  </td>
	</tr>
        <table width="100%"  border="0">
          <tr>
            <td width="40%">
             <div align="center">
             <input type="button" name="Submit" value=" 查询 "  onClick="onClickSubmit();" style="height:20px;">
             </div>
            </td>
          </tr>
        </table>
     </td>
   </tr>
 </table>
</form>  
</body>
</html>