<%@ page contentType="text/html; charset=gb2312" %>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cp" scope="session" class="bass.database.compete.CompetePool"/>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="scircle" scope="page" class="bass.database.report.ReportBean"/>
<%@ page import="bass.common.DevidePageBean"%>
<%@ include file="/hbbass/common/queryload.html"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<script type="text/javascript" src="/hbbass/js/tablesort.js"></script>
<script type="text/javascript" src="/hbbass/js/hbcommon.js"></SCRIPT> 
<head>
<title>终端捆绑销售分析</title>
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
 	document.form1.action = "new_TerBindAnalyQuery.jsp?submit=submit";
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
 	if(form1.city.value==0)
 	{
 			SaveAsExcel('终端捆绑销售分析.csv');
 	}
 	else
 	{
 	document.form1.action = "new_TerBindAnalyQueryDown.jsp";
	document.form1.target = "_top";
	document.form1.submit();
 	}
 
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
String submit=request.getParameter("submit")==null?"":request.getParameter("submit");

String imeiType=request.getParameter("imeiType")==null?"0":request.getParameter("imeiType");
imeiType=new String(imeiType.getBytes("ISO-8859-1"),"gb2312");  

String addImei = (!imeiType.equals("0")==true)?(" and imei_type like '%"+imeiType+"%'"):"";
 

/* 计算查询时间的上一月份 */

java.util.Calendar cal1=java.util.GregorianCalendar.getInstance();
cal1.set(java.util.Calendar.YEAR,Integer.parseInt(time_id.substring(0,4)));
cal1.set(java.util.Calendar.MONTH,Integer.parseInt(time_id.substring(4,6))-1);
cal1.add(java.util.Calendar.MONTH,-1);
int year1 = cal1.get(java.util.Calendar.YEAR);
int month1 = cal1.get(java.util.Calendar.MONTH)+1;
String time_id1=String.valueOf(year1*100+month1);


String sql="";

  sql="select substr(a.channel_code,1,5) as area_name ,substr(a.channel_code,1,8) as county,value(a.channel_type,'9') as channel_type,a.channel_name,a.rec_name,value(a.sale_num,0) sale_num,value(b.bind_num,0) bind_num, value(b.no_bindnum,0) no_bindnum,value(b.per,0) per from  "+
      "(select channel_code,channel_type,rec_tid,rec_name,channel_name,count(*) sale_num from nmk.bindimei_sale_"+time_id+ " where 1=1 "+ addImei +" group by channel_code,channel_type,rec_tid,rec_name,channel_name) a "+
      "left join  (select rec_channel_id,rec_channel_type,restypeid,count(case when year(statusdate)*100+month(statusdate) = "+time_id+" then mbuser_id else null end) bind_num,  count(case when year(statusdate)*100+month(statusdate) = "+time_id1+" and is_bind = 0 then mbuser_id else null end) no_bindnum, decimal(round(decimal(decimal(sum(case when year(statusdate)*100+month(statusdate) = "+time_id1+" and is_bind = 0 then 1 else 0 end)*100)/value(sum(case when year(statusdate)*100+month(statusdate) = "+time_id1+" then 1 else null end),1),10,3),2),10,2) per from NMK.GMI_BINDIMEI_"+time_id+" where year(statusdate)*100+month(statusdate) >= "+time_id1+ addImei +" group by rec_channel_id,rec_channel_type,restypeid) b on a.channel_code = b.rec_channel_id and a.rec_tid= b.restypeid where 1=1 and a.channel_code is not null and num1 is not null ";
  if(!city.equals("0"))
  sql+=" and a.channel_code like '"+city+"%'";
  if(!hidcounty.equals("0"))
  sql+=" and a.channel_code like '"+hidcounty+"%'";
  if(!mobilebrand.equals("0"))
  sql+=" and rec_name like '"+mobilebrand+"%'";
  if(!channel_type_name.equals("0"))
  sql+=" and a.channel_type ='"+channel_type_name+"'";
  
  if(!hidchannel.equals("0")&&(!channel_type_name.equals("9")))
  sql+=" and a.channel_code ='"+hidchannel+"'";
  
  sql+="  order by a.channel_code ,rec_name  with ur";
  // 赵静增加需求　选择全省时显示１４地市的汇总数据
  if(city.equals("0"))
  {
     sql="select  '0' as area_name,CASE         WHEN a.channel_code IS NULL THEN          substr(b.rec_channel_id, 1, 5)         ELSE          substr(a.channel_code, 1, 5)       END AS county, '0' as channel_type,'全部' as channel_name ,'全部' as rec_name , sum(sale_num) sale_num,sum(bind_num) bind_num,sum(no_bindnum) no_bindnum,case when sum(num2)>0 then decimal(round(decimal(sum(num1),10,3)*100/sum(num2),2),10,2) else 0 end per,sum(num1) num1,sum(num2) num2 from  "+
      "(select channel_code,position_type,rec_tid,rec_name,channel_name,count(*) sale_num from nmk.bindimei_sale_"+time_id+ " where 1=1 "+ addImei +" group by channel_code,position_type,rec_tid,rec_name,channel_name) a "+
      "full join  (select rec_channel_id,rec_channel_type,restypeid,count(case when year(statusdate)*100+month(statusdate) = "+time_id+" then mbuser_id else null end) bind_num,  count(case when year(statusdate)*100+month(statusdate) = "+time_id1+" and is_bind = 0 then mbuser_id else null end) no_bindnum, sum(case when year(statusdate)*100+month(statusdate) = "+time_id1+" and is_bind = 0 then 1 else 0 end) as num1,sum(case when year(statusdate)*100+month(statusdate) = "+time_id1+" then 1 else 0 end) as num2 from NMK.GMI_BINDIMEI_"+time_id+" where year(statusdate)*100+month(statusdate) >= "+time_id1+ addImei +" group by rec_channel_id,rec_channel_type,restypeid) b on a.channel_code = b.rec_channel_id and a.rec_tid= b.restypeid where 1=1 and num1 is not null and a.channel_code is not null ";
  
  if(!mobilebrand.equals("0"))
  sql+=" and rec_name like '"+mobilebrand+"%'";
  if(!channel_type_name.equals("0"))
  sql+=" and a.position_type ='"+channel_type_name+"'";
  
  if(!hidchannel.equals("0")&&(!channel_type_name.equals("9")))
  sql+=" and a.channel_code ='"+hidchannel+"'";
  
  sql+="  GROUP BY CASE            WHEN a.channel_code IS NULL THEN             substr(b.rec_channel_id, 1, 5)            ELSE             substr(a.channel_code, 1, 5)          END ORDER BY CASE            WHEN a.channel_code IS NULL THEN             substr(b.rec_channel_id, 1, 5)            ELSE             substr(a.channel_code, 1, 5)          END WITH ur";
  }

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
//out.println(sql);
} 
%>
<body background="/hbbass/images/bg-1.gif">  
<form id="form1" name="form1" method="post" action="">
<input type=hidden name=hidchannel value="<%=hidchannel%>" size=10>
<input type=hidden name=hidcounty value="<%=hidcounty%>" size=10>
<input type=hidden name=state value="srstUsd" size=10>
<table border=0 cellpadding=0 cellspacing=0 width=95% align=center>
    <tr> 
      <td valign="top" width="12"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"></td>
      <td style="font-size:10.8pt;color:#ff6622" nowrap align=left>终端捆绑销售分析</td>
      <td width="30"><a href="javascript:help();">帮助</a></td> 
    </tr>
</table>
  <table width=95% height=25 border=0 align=center cellpadding="1" cellspacing="1">
    <tr>
      <td width=11% align="right" class="query_t">时间</td>
      <td width=13% align="left" class="query_v">
        <select name="time_id">
          <% 
			       	        DevidePageBean timeInit=new DevidePageBean();
			       	        timeInit.setPerPage(15);
			       	       // String timeSQL="select distinct time_id from nmk.gms_imeiuser_num order by time_id desc fetch first 12 rows only with ur "; 
			       	     		String timeSQL="select time_id   from pt_date where time_id<="+optime+" order by time_id desc fetch first 12 rows only";
			       	     		timeInit.setQuerySQL(timeSQL);
			       	     		for(int i=1;i<=timeInit.getRowNum();i++){
 		
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
        		for(int i=1;i<=cityInit.getRowNum();i++){
        		
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
     <td align="right"  class="query_t">渠道名称</td>  
      <td align="left"   class="query_v" >
         	 <iframe name="frmChannel" src="/hbbass/common/com_channel.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>&channel_type_name=<%=channel_type_name%>&channel_name=<%=hidchannel%>" height="20" width="140" frameborder="0" scrolling="no"></iframe>
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
   <table id="resultTable" width="95%" border="1" borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0  align="center" >

    <tr class="result_t">
      <td width=6% align="center">时间</td>
      <td width=6% align="center">地域</td>
      <td width=14% align="center">县域</td>
      <td width=10% align="center">渠道类型</td>
      <td width=10% align="center">渠道名称</td>
      <td width=10% align="center">终端品牌型号</td>
      <td width=10% align="center">终端数量<br>(已销售(部))</td>
      <td width=10% align="center">捆绑销售<br>终端数(部)</td>
      <td width=8% align="center">拆包用<br>户数(户)</td>
      <td width=8% align="center">拆包率(%)</td>
     
     </tr>
    <%    
    String tr_class="";  
    int[] man=new int[5]; 
     for(int i=1;i<=Divpage.getRowNum();i++)
     {
      if(i%2==0)
        tr_class="result_v_2";
     else
   	   tr_class ="result_v_1";
   	   if(!city.equals("0"))
   	   {
    %>
      <tr class=<%=tr_class%>  onMouseOver="this.className='result_v_3'"  onMouseOut="this.className='<%=tr_class%>'">
         <td align=left nowrap><%=time_id%></td>
         <td align=left><%=cp.getNewAreaName(Divpage.getFieldValue("area_name",i))%></td>
         <td align=left nowrap><%=cp.getNewAreaName(Divpage.getFieldValue("county",i).trim())%></td>
         <td align=left nowrap><%=cp.getChannelType(Divpage.getFieldValue("channel_type",i))%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("CHANNEL_NAME",i)%></td>
         <td align=left nowrap><%=Divpage.getFieldValue("rec_name",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("sale_num",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("bind_num",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("no_bindnum",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("per",i)%>%</td>
     </tr> 
      <%
      }
    else
    	{
    	
    	man[0]+=Integer.parseInt(Divpage.getFieldValue("sale_num",i));
 	    man[1]+=Integer.parseInt(Divpage.getFieldValue("bind_num",i));
 	    man[2]+=Integer.parseInt(Divpage.getFieldValue("no_bindnum",i));
 	    man[3]+=Integer.parseInt(Divpage.getFieldValue("num1",i));
 	    man[4]+=Integer.parseInt(Divpage.getFieldValue("num2",i));
 	    
    	%>
    	<tr class=<%=tr_class%>  onMouseOver="this.className='result_v_3'"  onMouseOut="this.className='<%=tr_class%>'">
         <td align=left nowrap><%=time_id%></td>
         <td align=left>全省</td>
         <td align=left nowrap><%=cp.getNewAreaName(Divpage.getFieldValue("county",i).trim())%></td>
         <td align=left nowrap>全部</td>
         <td align=left nowrap>全部</td>
         <td align=left nowrap>全部</td>
         <td align=right nowrap><%=Divpage.getFieldValue("sale_num",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("bind_num",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("no_bindnum",i)%></td>
         <td align=right nowrap><%=Divpage.getFieldValue("per",i)%>%</td>
     </tr> 
    	<%
    	}
      }
      if(city.equals("0")&&submit.equals("submit"))
   	   {
   	   %>
   	    <tr class="result_t">
   	      <td align=left nowrap><%=time_id%></td>
   	      <td  align="left" >全省</td>
			    <td  align="left" >合计</td>
			    <td align=left nowrap>全部</td>
          <td align=left nowrap>全部</td>
          <td align=left nowrap>全部</td>
			    <td align=right><%=man[0]%></td>
			    <td align=right><%=man[1]%></td>
			    <td align=right><%=man[2]%></td>
			    <td align=right><%=mp.div(String.valueOf(man[3]*100),String.valueOf(man[4]),2)%>%</td>
	
			  </tr>    
   	   <%
   	   }
      %>      
  </table>

  <%@ include file="/hbbass/common/common_page.jsp"%>  
  <textarea name="downcontent"  cols="122" rows="12" style="display:none"></textarea>
</form>
</body>
</html>
