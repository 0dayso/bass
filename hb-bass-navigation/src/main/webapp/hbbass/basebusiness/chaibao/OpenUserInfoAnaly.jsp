<%@ page contentType="text/html; charset=gb2312" %>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cp" scope="session" class="bass.database.compete.CompetePool"/>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="scircle" scope="page" class="bass.database.report.ReportBean"/>
<%@ page import="bass.common.DevidePageBean"%>
<%@ include file="/hbbass/common/queryload.html"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>拆包用户信息查询和分析</title>
<style type="text/css">
@import url("/hbbass/css/com.css");
</style>
<script language="JavaScript">  
// 提交事件
function clickSubmit()
{
  document.form1.nextPage2.value=0;
  document.form1.confirm.disabled=true;
  queryload.style.display="block";
 	document.form1.action = "OpenUserInfoAnaly.jsp?submit=submit";
  document.form1.target = "_self";
	document.form1.submit();
}
 
// 地市变化决定县市变化 
function selCounty()
{
	form1.hidcounty.value="0";
	form1.hidchannel.value="0";
	
	var cid = this.document.form1.city.value;
	var county_id	=this.document.form1.hidcounty.value;
	frmCounty.location.href="/hbbass/common/county2.jsp?city_id="+cid+"&county_id="+county_id;
  frmChannel.location.href="/hbbass/common/select.jsp";

}


//渠道类型变化
function selectChannel()
{ 
 city_id=form1.city.value;
 countyValue=form1.hidcounty.value;
 channel_type_name=form1.channel_type_name.value;
 channel_name=form1.hidchannel.value;
 frmChannel.location.href="/hbbass/common/com_channel.jsp?city_id="+city_id+"&county_id="+countyValue+"&channel_type_name="+channel_type_name;

}

function down()
{
 	var pagenum=form1.pagenum.value;
 	if(pagenum==0)
 	{
 		 alert("没有查询记录!");
 		 return;
 	}
 	else if(pagenum>20000)
 	{

   	document.form1.action = "OpenUserInfoAnalyDown1.jsp?pagenum="+pagenum;
   	document.form1.target = "_blank";
  }
  else
	{
		document.form1.action = "OpenUserInfoAnalyDown.jsp";	
		document.form1.target = "_top";
	}
	
	document.form1.submit();
}

function help()                    
{                    
var userwindow=window.open('TerBind_help.jsp' , "SelectUserWindow", "height=480, width=600, left=420, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
userwindow.focus();
}
</script> 
</head>
<%
String loginname="";
if(session.getAttribute("loginname")==null){
  response.sendRedirect("/hbbass/error/loginerror.jsp");
	return;
}
else{
	loginname=(String)session.getAttribute("loginname");
}
//session.setAttribute("area_id","270");
int area_id = Integer.parseInt((String)session.getAttribute("area_id")); 

String imeiType=request.getParameter("imeiType")==null?"0":request.getParameter("imeiType");
imeiType=new String(imeiType.getBytes("ISO-8859-1"),"gb2312");  
String addImei = (!imeiType.equals("0")==true)?(" and imei_type like '%"+imeiType+"%'"):"";

java.util.Calendar cal=java.util.GregorianCalendar.getInstance();
cal.add(java.util.Calendar.MONTH,-1);
int year = cal.get(java.util.Calendar.YEAR);
int month = cal.get(java.util.Calendar.MONTH)+1;
String optime=String.valueOf(year*100+month);

String time_id=request.getParameter("time_id")==null?optime:request.getParameter("time_id");
String city=request.getParameter("city")==null?cp.getONAreaidName((String)session.getAttribute("area_id")):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String mobilebrand=request.getParameter("mobilebrand")==null?"0":request.getParameter("mobilebrand");
mobilebrand=new String(mobilebrand.getBytes("ISO-8859-1"),"gb2312");      

String channel_type_name=request.getParameter("channel_type_name")==null?"0":request.getParameter("channel_type_name");
String hidchannel=request.getParameter("hidchannel")==null?"0":request.getParameter("hidchannel");
String acc_nbr=request.getParameter("acc_nbr")==null?"":request.getParameter("acc_nbr");
String submit=request.getParameter("submit")==null?"":request.getParameter("submit");

String sql=" select DISTINCT  b.FEE_NAME,rec_position_type,area_name,substr(rec_channel_id,1,8) county,"
	+" acc_nbr,case when res_imei is null or res_imei='' then '不详' else res_imei end  as imei,"
	+" cust_name,sex_id,age,brand_id,billing_name,a.createdate,a.res_name,rec_channel_name,decimal(bill_charge/1000,10,2) "
	+" bill_charge from nmk.gmi_bindimei_"+time_id+"  a,nwh.fee b where  a.privsetid=b.FEE_ID and is_bind=0 "
	+" and replace(substr(char(date(a.statusdate)+ 1 month),1,7),'-','')=  '"+time_id +"'";


  if(!city.equals("0"))
  sql+=" and a.rec_channel_id like '"+city+"%'";
  if(!hidcounty.equals("0"))
  sql+=" and a.rec_channel_id like '"+hidcounty+"%'";
  if(!mobilebrand.equals("0"))
  sql+=" and a.res_name like '"+mobilebrand+"%'";
  if(!channel_type_name.equals("0"))
  sql+=" and a.rec_position_type ='"+channel_type_name+"'";
  
  if(!hidchannel.equals("0")&&(!channel_type_name.equals("9")))
  sql+=" and a.rec_channel_id ='"+hidchannel+"'";
  
  sql += addImei;
  
  sql+="  order by area_name,substr(rec_channel_id,1,8), Bill_charge desc with ur";
//out.println(sql);
int perPage=15;
int nextPage=0;
try          
  {          
	   nextPage = Integer.parseInt(request.getParameter("nextPage2"));
  }
catch (Exception e)
  {
  }
 
if(submit.equals("submit"))
{ 
Divpage.setNextPage(nextPage);
Divpage.setPerPage(perPage);
Divpage.setQuerySQL(sql);
} 
%>
<body background="/hbbass/images/bg-1.gif">  
<form id="form1" name="form1" method="post" action="">
<input type=hidden name=hidchannel value="<%=hidchannel%>" size=10>
<input type=hidden name=hidcounty value="<%=hidcounty%>" size=10>
<input type=hidden name=state value="srstUsd" size=10>
<input type=hidden name=pagenum value="<%=Divpage.getAllRowCount()%>" size=10>
<table border=0 cellpadding=0 cellspacing=0 width=100% align=center>
    <tr> 
      <td valign="top" width="12"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"></td>
      <td style="font-size:10.8pt;color:#ff6622" nowrap align=left>拆包用户信息查询和分析</td>
      <td width="30"><a href="javascript:help();">帮助</a></td> 
    </tr>
</table>
  <table width=100% height=25 border=0 align=center cellpadding="1" cellspacing="1">
    <tr>
      <td width=11% align="right" class="query_t">时间</td>
      <td width=13% align="left" class="query_v">
        <select name="time_id">
          <% 
			       	        DevidePageBean timeInit=new DevidePageBean();
			       	       // String timeSQL="select distinct time_id from nmk.gms_imeiuser_num order by time_id desc fetch first 12 rows only with ur "; 
			       	     		String timeSQL="select time_id   from pt_date where time_id<="+optime+" order by time_id desc fetch first 12 rows only";
			       	     		timeInit.setQuerySQL(timeSQL);
			       	     		for(int i=1;i<=timeInit.getAllRowCount();i++){
 		
			       	 %>
          <option value="<%=timeInit.getFieldValue("time_id",i)%>"    <%if(timeInit.getFieldValue("time_id",i).equals(time_id)) out.print("selected");%>><%=timeInit.getFieldValue("time_id",i)%></option>
          <%}%>
        </select>
      </td>
      <td width=11% align="right"   class="query_t">地域</td>
      <td width=13% align="left" class="query_v" >
        <select name="city" onChange="selCounty()">
        <%  
            DevidePageBean cityInit=new DevidePageBean();
            String citySQL="Select dm_city_id,cityname from FPF_user_city where parentid='-1'"; 
        		if(area_id>0)
        		citySQL=citySQL+" and cityid='"+area_id+"'";
        		citySQL=citySQL+" order by cityid";
        		cityInit.setQuerySQL(citySQL);
        		for(int i=1;i<=cityInit.getAllRowCount();i++){
        		
        %>
             <option value="<%=cityInit.getFieldValue("dm_city_id",i)%>" <%if(cityInit.getFieldValue("dm_city_id",i).equals(city)) out.print("selected");%>><%=cityInit.getFieldValue("cityname",i)%></option>
        <%}%>
      </select>
      </td>
      <td width=11% align="right"   class="query_t">县域</td>
      <td width=13% align="left" class="query_v" >
         <iframe name="frmCounty" src="/hbbass/common/county2.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe> </td>
      </td>
     	<td width=10% align="right" class="query_t">渠道类型</td>
      <td width=18% align="left" class="query_v" >
        	<select name="channel_type_name" onchange="selectChannel()">
          <option value="0"  <%if(channel_type_name.equals("0")) out.print("selected");%>>全部</option>
          <option value="1"  <%if(channel_type_name.equals("1")) out.print("selected");%>>自办</option>
          <option value="2"  <%if(channel_type_name.equals("2")) out.print("selected");%>>特许(他建他营)</option>
          <option value="3"  <%if(channel_type_name.equals("3")) out.print("selected");%>>授权代理</option>
          <option value="4"  <%if(channel_type_name.equals("4")) out.print("selected");%>>其它</option>
          <option value="9"  <%if(channel_type_name.equals("9")) out.print("selected");%>>未知</option>  
        </select>
      </td>
    	  
    </tr>
    <tr>
     <td align="right"  class="query_t">营业网点代码</td>  
      <td align="left"   class="query_v" >
         	 <iframe name="frmChannel" src="/hbbass/common/com_channel.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>&channel_type_name=<%=channel_type_name%>&rec_channel_name=<%=hidchannel%>" height="20" width="140" frameborder="0" scrolling="no"></iframe>
       </td>  
    
       <td align="right" class="query_t">终端品牌型号</td>
       <td align="left" class="query_v">
        <select name="mobilebrand" style="width:100">
          <option value="0"  <% if(mobilebrand.equals("0")) out.print("selected"); %>>全部</option>
          <% 
			       	        String brandInitsql="select distinct res_name from nmk.bind_imei_type order by res_name with ur  "; 
			       	     		scircle.execute(brandInitsql);
			       	     		for(int i=0;i<scircle.getRowCount();i++)
			       	     		{
			       	 %>
          <option value="<%=scircle.getStringValue("res_name",i)%>"  <%if(scircle.getStringValue("res_name",i).equals(mobilebrand)) out.print("selected");%>><%=scircle.getStringValue("res_name",i)%></option>
          <%}%>
        </select>
      </td>
       <td align="right" class="query_t">IMEI类型</td>
       <td align="left" class="query_v">
        <select name="imeiType" style="width:100">
          <option value="0" <% if("0".equals(imeiType)) out.print("selected"); %>>全部</option>
          <% 
			       	        String imeiTypeSql="select distinct imei_type from NMK.BIND_IMEI_TYPE where analyse_state  =1 order by imei_type with ur"; 
			       	     		scircle.execute(imeiTypeSql);
			       	     		for(int i=0;i<scircle.getRowCount();i++)
			       	     		{
			    %>
          <option value="<%=scircle.getStringValue("imei_type",i)%>"  <%if(scircle.getStringValue("imei_type",i).equals(imeiType)) out.print("selected");%>><%=scircle.getStringValue("imei_type",i)%></option>
          <%}%>
        </select>
      </td>
        <td colspan=2 align=center class="query_v" >    
<input type="button" name="confirm"   value="查询" onClick="clickSubmit()">
<input type="button" name="xiazai" value="下载" onClick="down()" width="10">

      </td>
      
    </tr>
  </table>
  
  <br>
   <table width="140%" border="1" borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0  align="center" >
    <tr class="result_t">
      <td width=4% align="center">地市</td>
      <td width=6% align="center">县域</td>
      <td width=6% align="center">时间</td>               
      <td width=7% align="center">手机号码</td>                  
      <td width=9% align="center" nowrap>IMEI信息</td>                 
      <td width=6% align="center" nowrap>用户姓名</td>                 
      <td width=5% align="center" nowrap>性别</td>             
      <td width=3% align="center" nowrap>年龄</td>                    
      <td width=7% align="center" nowrap>客户品牌</td>
      <td width=8% align="center" nowrap>计费类别</td>                 
      <td width=8% align="center" nowrap>资费营销案</td>                
      <td width=7% align="center" nowrap>入网时间</td>                
      <td width=7% align="center" nowrap>终端品牌型号</td>             
      <td width=5% align="center" nowrap>渠道类型</td>
      <td width=7% align="center" nowrap>渠道名称</td>           
      <td width=8% align="center" nowrap>本月消费<br>
      金额(元)</td>             
    </tr>
    <%    
    String tr_class="";  
     for(int i=1;i<=Divpage.getRowNum();i++)
     {
      if(i%2==0)
        tr_class="result_v_2";
     else
   	   tr_class ="result_v_1";
    %>
      <tr class=<%=tr_class%>  onMouseOver="this.className='result_v_3'"  onMouseOut="this.className='<%=tr_class%>'">
         <td align=center nowrap class="result_t"><%=Divpage.getFieldValue("area_name",i)%></td>
         <td align=left nowrap><%=cp.getNewAreaName(Divpage.getFieldValue("county",i).trim())%></td>
         <td align=left nowrap><%=optime%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("acc_nbr",i)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("imei",i)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("cust_name",i)%></td>
         <td align=left nowrap>&nbsp;<%=Divpage.getFieldValue("Sex_id",i).equals("1")?"男":"女"%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("Age",i).equals("")?"不详":Divpage.getFieldValue("Age",i)%></td>
         <td align=left nowrap><%=cp.getBrandNname(Divpage.getFieldValue("brand_id",i))%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("billing_name",i)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("FEE_NAME",i)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("createdate",i).substring(0,10)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("res_name",i)%></td>
         <td align=left nowrap><%=cp.getChannelType(Divpage.getFieldValue("channel_type",i))%>&nbsp;</td>
         <td align=left nowrap><%=Divpage.getFieldValue("rec_channel_name",i).equals("")?"不详":Divpage.getFieldValue("rec_channel_name",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("bill_charge",i).equals("")?"0":Divpage.getFieldValue("bill_charge",i)%></td>
    </tr> 
      <%}%>      
  </table>

  <%@ include file="/hbbass/common/common_page.jsp"%> 
  <table border=0 width=90% align=center>
  <tr><td><font color=blue size=2>展示说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此表信息表示为统计月份内分析上月捆绑拆包用户资料信息。</font></center>       
</td></tr></table>  
</form>
</body>
</html>
