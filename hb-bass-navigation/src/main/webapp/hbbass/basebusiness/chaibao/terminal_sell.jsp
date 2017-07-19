<%@ page contentType="text/html; charset=gb2312"  errorPage="error.jsp"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page import = "bass.common.DevidePageBean,java.math.BigDecimal"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="access" scope="application" class="bass.utilty.SecurityAccess" />
<jsp:useBean id="ReportBean" scope="session" class="bass.database.report.ReportBean"/>
<jsp:useBean id="ReportBean2" scope="session" class="bass.database.report.ReportBean"/>
<jsp:useBean id="cptool" scope="session" class="bass.database.compete.CompetePool" />
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<%@ include file="/hbbass/common/queryload.html"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>湖北移动业务日报表</title>
<style type="text/css">
@import url("/hbbass/css/com.css");
.style1 {color: #0000FF}
</style>
<script language="JavaScript">
function doHandleMonth(year,month)
{
   var today = new Date(); 
   nowday=today.getDate()-1;
	 intyear=2003;
	 form1.nextyear.options[year-intyear].selected=true;
   form1.nextmonth.options[month-1].selected=true;
	 form1.year.options[year-intyear].selected=true;
   form1.month.options[month-1].selected=true;

	if(month*1==2)
	{
		  if(year*1%4==0 || year*1%400==0)
		  {
		  	  for (var i = document.form1.day.options.length-1;i>=0;--i)
		  	  {
		  	  	document.form1.day.options.remove(i);
		  	  	document.form1.nextday.options.remove(i);
		  	  }
      	  var nullOption = document.createElement('OPTION');
		  	  nullOption.value="--";
		  	  nullOption.text="--";
      
		  	  //day.options.add(nullOption);
		  	  for(var i=1;i<30;++i)
		  	  {
		  	  	var oOption = document.createElement('OPTION');
		  	  	//i=(i>9)?i:""+"0"+i;
		  	  	oOption.value=i;
		  	  	oOption.text=i;
		  	  	document.form1.day.options.add(oOption);
		  	  	//经反复测试发现下面行必须单独在循环中，可能是javascript的option特性吧
		  	  	//document.form1.nextday.options.add(oOption);
			  	  }
		  	  for(var i=1;i<30;++i)
		  	  {
		  	  	var oOption = document.createElement('OPTION');
		  	  	//i=(i>9)?i:""+"0"+i;
		  	  	oOption.value=i;
		  	  	oOption.text=i;
		  	  	document.form1.nextday.options.add(oOption);
	
		  	  }
		   }
      else
      {
			   for (var i = document.form1.day.options.length-1;i>=0;--i)
		  	  {
		  	  	document.form1.day.options.remove(i);
		  	  	document.form1.nextday.options.remove(i);
		  	  }
	
			   var nullOption = document.createElement('OPTION');
			   nullOption.value="--";
			   nullOption.text="--";

			   //day.options.add(nullOption);
			   for(var i=1;i<29;++i)
			   {
				    var oOption = document.createElement('OPTION');
				    //i=(i>9)?i:""+"0"+i;
				    oOption.value=i;
				    oOption.text=i;
				    document.form1.day.options.add(oOption);
				   }
				  for(var i=1;i<29;++i)
		  	  {
		  	  	var oOption = document.createElement('OPTION');
		  	  	//i=(i>9)?i:""+"0"+i;
		  	  	oOption.value=i;
		  	  	oOption.text=i;
		  	  	document.form1.nextday.options.add(oOption);
		  	  	
		  	  }
		  }
	}
	else if(month*1==4||month*1==6||month*1==9||month*1==11)
 {
		for (var i = document.form1.day.options.length-1;i>=0;--i)
		  	  {
		  	  	document.form1.day.options.remove(i);
		  			document.form1.nextday.options.remove(i);
		  	  }
		  	 
		 var nullOption = document.createElement('OPTION');
		 nullOption.value="--";
		 nullOption.text="--";

		 //day.options.add(nullOption);
		 for(var i=1;i<31;++i)
		 {
		 	  var oOption = document.createElement('OPTION');
		 	  //i=(i>9)?i:""+"0"+i;
		 	  oOption.value=i;
		 	  oOption.text=i;
		 	  document.form1.day.options.add(oOption);
		 }
		 for(var i=1;i<31;++i)
		  	  {
		  	  	var oOption = document.createElement('OPTION');
		  	  	//i=(i>9)?i:""+"0"+i;
		  	  	oOption.value=i;
		  	  	oOption.text=i;
		  	  	document.form1.nextday.options.add(oOption);
		  	  	
		  	  }
	}else
	{
		  for (var i = document.form1.day.options.length-1;i>=0;--i)
		  	  {
		  	  	document.form1.day.options.remove(i);
		  	  	document.form1.nextday.options.remove(i);		  	  	
		  	  }
	
		  var nullOption = document.createElement('OPTION');
		  nullOption.value="--";
		  nullOption.text="--";
		  //day.options.add(nullOption);
		  for(var i=1;i<32;++i)
		  {
		  	var oOption = document.createElement('OPTION');
		  	//i=(i>9)?i:""+"0"+i;
		  	oOption.value=i;
		  	oOption.text=i;
		  	document.form1.day.options.add(oOption);

		  }
		  for(var i=1;i<32;++i)
		  	  {
		  	  	var oOption = document.createElement('OPTION');
		  	  	//i=(i>9)?i:""+"0"+i;
		  	  	oOption.value=i;
		  	  	oOption.text=i;
		  	  	document.form1.nextday.options.add(oOption);
		  	  			  	  	
		  	  }
	 }
	 

}

function prechange()
{ 
   form1.nextyear.options[form1.year.selectedIndex].selected=true;

}

function nextchange()
{
    form1.year.options[form1.nextyear.selectedIndex].selected=true;
}
function selCounty()
{
	
	form1.hidcounty.value="0";
	var cid = this.document.form1.city.value;	
	frmCounty.location.href="/hbbass/common/county.jsp?city_id="+cid;
}
function selChannel()
{
	form1.hidchannel.value="0";
	var countid = this.document.form1.hidcounty.value;	
	frmChannel.location.href="channel.jsp?county_id="+countid;
}


function clickSubmit()
{
  if(parseInt(form1.day.selectedIndex)>parseInt(form1.nextday.selectedIndex))
   {
   	alert("起始时间不能大于终止时间!");
   	return false;
   	}
	document.form1.nextPage2.value=0;
	queryload.style.display="block";
	document.form1.confirm.disabled=true;
	document.form1.action = "terminal_sell.jsp";
	document.form1.target = "";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "terminal_sell_down.jsp";
	document.form1.target = "_top";
	document.form1.submit();
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
int area_id = Integer.parseInt((String)session.getAttribute("area_id")); 

String imeiType=request.getParameter("imeiType")==null?"0":request.getParameter("imeiType");
imeiType=new String(imeiType.getBytes("ISO-8859-1"),"gb2312");  
String addImei = (!imeiType.equals("0")==true)?(" and imei_type like '%"+imeiType+"%'"):"";

java.util.Calendar cal=java.util.GregorianCalendar.getInstance();
cal.add(java.util.Calendar.DATE,-1);
String sYear=Integer.toString(Calendar.getInstance().get(Calendar.YEAR));
String sMonth=Integer.toString(Calendar.getInstance().get(Calendar.MONTH)+1);
if (sMonth.length()==1) {sMonth="0"+sMonth;}
int nowdate=Integer.parseInt(sYear+sMonth);

int year = cal.get(java.util.Calendar.YEAR);
int year1 = cal.get(java.util.Calendar.YEAR);
int month = cal.get(java.util.Calendar.MONTH)+1;
int day = cal.get(java.util.Calendar.DATE);

int nextyear=year;
int nextmonth=month;
int nextday=day;
if(request.getParameter("year")!=null){
	year=Integer.parseInt(request.getParameter("year"));
}
if(request.getParameter("month")!=null){
	month=Integer.parseInt(request.getParameter("month"));
}
if(request.getParameter("day")!=null){
	day=Integer.parseInt(request.getParameter("day"));
}
if(request.getParameter("nextyear")!=null){
	nextyear=Integer.parseInt(request.getParameter("nextyear"));
}
if(request.getParameter("nextmonth")!=null){
	nextmonth=Integer.parseInt(request.getParameter("nextmonth"));
}
if(request.getParameter("nextday")!=null){
	nextday=Integer.parseInt(request.getParameter("nextday"));
}
//获取地市
String city=request.getParameter("city")==null?(String)session.getAttribute("area_id"):request.getParameter("city");
//获取县市
String county=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String DetailArea=request.getParameter("DetailArea")==null?"0":request.getParameter("DetailArea");
String DetailType=request.getParameter("DetailType")==null?"0":request.getParameter("DetailType");
String res_name=request.getParameter("res_name")==null?"0":request.getParameter("res_name");
res_name=new String(res_name.getBytes("ISO-8859-1"),"gb2312"); 
String fee_name=request.getParameter("fee_name")==null?"0":request.getParameter("fee_name");
String channel=request.getParameter("hidchannel")==null?"0":request.getParameter("hidchannel");
channel=new String(channel.getBytes("ISO-8859-1"),"gb2312"); 
String ifSubmit=request.getParameter("ifSubmit")==null?"":request.getParameter("ifSubmit");


int startime=year*10000+month*100+day;
int endtime=nextyear*10000+nextmonth*100+nextday;


String areafied="";
String areawhere="";
if(city.equals("0"))
{
areafied=" substr(area_id,1,5) area_id ";
areawhere=" 1=1 ";
}
else
{
		if(county.equals("0"))
		{
		    areafied=" substr(area_id,1,8) area_id  ";
        areawhere=" substr(area_id,1,5) like '"+city+"%' ";
		}
	  else
		{
		areafied=" substr(area_id,1,11) area_id ";
		areawhere=" substr(area_id,1,8)='"+county+"'";
		}
}
String sql="with t0(area_id,res_name,new_code) as (select area_id,res_name,new_code from (select area_id,area_name,new_code from (select county_code as area_id,county_name as area_name,new_code from MK.BT_AREA_all union select area_code as area_id,area_name,new_code from mk.bt_area ) as tt where length(area_id)>5 ) a, (Select distinct res_name from NMK.BIND_IMEI_TYPE) b),"+
           "t1(state_date,res_name,stoeid,store_count) as (Select date(state_date),res_name,case when length(ltrim(rtrim(substr(storeid,1,8))))=5 then ltrim(rtrim(substr(storeid,1,8)))||'.01' else ltrim(rtrim(substr(storeid,1,8))) end ,count(0) from NMK.BINDIMEI_STORAGE";
if (!(nowdate==(nextyear*100+nextmonth))) {
   sql+= "_"+(nextyear*100+nextmonth);
}
sql+="  where state='srstAvl' and int(replace(char(date(state_date)),'-',''))<="+endtime+" group by date(state_date),res_name,case when length(ltrim(rtrim(substr(storeid,1,8))))=5 then ltrim(rtrim(substr(storeid,1,8)))||'.01' else ltrim(rtrim(substr(storeid,1,8))) end),";
sql+=" t2(area_id,res_name,store_count,new_code) as (select a.area_id, a.res_name, coalesce(store_count,0) as store_count,new_code from t0 a left join t1 b on a.area_id=b.stoeid  and a.res_name=b.res_name),";
sql+=" t3(state_date,res_name,stoeid,sell_count) as (select date(state_date),res_name,case when length(ltrim(rtrim(substr(storeid,1,8))))=5 then "+
           "ltrim(rtrim(substr(storeid,1,8)))||'.01' else ltrim(rtrim(substr(storeid,1,8))) end,count(0) from NMK.BINDIMEI_STORAGE";
if (!(nowdate==(nextyear*100+nextmonth))) {
   sql+= "_"+(nextyear*100+nextmonth);
}
sql+=" where state='srstUsd' and int(replace(char(date(state_date)),'-',''))<="+endtime+
     " and int(replace(char(date(state_date)),'-',''))>="+startime+
	 " group by date(state_date),res_name,case when length(ltrim(rtrim(substr(storeid,1,8))))=5 then ltrim(rtrim(substr(storeid,1,8)))||'.01' else ltrim(rtrim(substr(storeid,1,8))) end),";
sql+=" t4(area_id,res_name,sell_count,new_code) as (select a.area_id, a.res_name, coalesce(sell_count,0) as sell_count,new_code from t0 a left join t3 b on a.area_id=b.stoeid  and a.res_name=b.res_name),";

sql+= "t5(city_id,stoeid,res_name,imei_count) as (select ltrim(rtrim(substr(channel_code,1,5)))";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=",ltrim(rtrim(substr(channel_code,1,8))) as stoeid";}
else
{sql+=",'1' as stoeid";} 
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=",res_name";}
else
{sql+=",'1' as res_name";} 
sql+=",count(0) from NMK.GMI_BINDIMEI";
if (!(nowdate==(nextyear*100+nextmonth))) {
   sql+= "_"+(nextyear*100+nextmonth);
}
sql+= 	   " a,nwh.fee b,NWH.RES_SITE c left join NWH.DIM_UP_CHANNEL_TYPE d on c.settchannel_tid=d.itemid "+
           " where c.site_id=a.channel_code and privsetid=fee_id and a.status='stcmNml' ";
if (!fee_name.equals("0"))
{
       sql+=" and a.privsetid ='"+fee_name+"' ";
}
if ((!channel.equals("0"))&&(!channel.equals("6")))
{
       sql+=" and d.up_name ='"+channel+"' ";
}
if (channel.equals("6"))
{
       sql+=" and d.up_name is null ";
}
sql+=" and int(replace(char(date(a.statusdate)),'-',''))>="+startime+" and int(replace(char(date(a.statusdate)),'-',''))<="+endtime+" ";
sql+=" group by ltrim(rtrim(substr(channel_code,1,5))) ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=",ltrim(rtrim(substr(channel_code,1,8)))";}
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=",res_name";}
sql+="), ";

sql+="t6(city_id,stoeid,res_name,store_count,sell_count,new_code) as ( ";
sql+="select substr(a.city_id,1,5),a.area_id,a.res_name, coalesce(store_count,0),coalesce(sell_count,0),a.new_code from  ";
sql+="(select substr(area_id,1,5) as city_id,";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+="area_id,";}
else
{sql+="'1' as area_id,";} 
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+="res_name,";}
else
{sql+="'1' as res_name,";} 
sql+= "new_code,sum(store_count) store_count from t2 where 0=0 ";
if (!res_name.equals("0"))
{
       sql+=" and res_name ='"+res_name+"' ";
}
sql+= " group by substr(area_id,1,5) ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=",area_id";}
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=",res_name";}
 sql+= " ,new_code) a , ";
sql+= " (select substr(area_id,1,5) as city_id,";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+="area_id,";}
else
{sql+="'1' as area_id,";} 
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+="res_name,";}
else
{sql+="'1' as res_name,";} 
sql+=      "sum(sell_count) sell_count from t4 where 0=0 ";
if (!res_name.equals("0"))
{
       sql+=" and res_name ='"+res_name+"' ";
}
sql+=" group by substr(area_id,1,5) ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=",area_id";}
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=",res_name";}
 sql+= " ) b where ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{ sql+= " a.area_id=b.area_id ";}
else
{sql+= "  a.city_id=b.city_id ";}
sql+= " and a.res_name=b.res_name ";
if(!city.equals("0"))
{
    if(!county.equals("0"))
    {
       sql+=" and substr(a.city_id,1,5) ='"+city+"' and a.area_id='"+county+"' ";
    }
    else
  	{
       sql+=" and substr(a.city_id,1,5) ='"+city+"' ";
    }
}

sql+=" and 0=0)";

sql+=" (select a.city_id,";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+="a.stoeid,";}
else
{sql+="'1' as stoeid,";} 
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+="a.res_name,";}
else
{sql+="'1' as res_name,";} 

sql+="store_count,"+
     "sell_count,coalesce(imei_count,0) as imei_count "+
     " ,new_code from t6 a left join t5 b on a.city_id=b.city_id ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=" and a.stoeid=b.stoeid ";}
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=" and a.res_name=b.res_name ";}

sql+=" order by sell_count desc)  union all (select '合计' as city_id, '——' as stoeid,'——' as res_name,"; 
sql+="sum(store_count) as store_count,sum(sell_count) as sell_count,sum(coalesce(imei_count,0)) as imei_count "+
     " ,9999 as new_code from t6 a left join t5 b on a.city_id=b.city_id ";
if ((DetailArea.equals("show"))|(!(city.equals("0")))|(!(county.equals("0"))))
{sql+=" and a.stoeid=b.stoeid ";}
if ((DetailType.equals("show"))|(!(res_name.equals("0"))))
{sql+=" and a.res_name=b.res_name ";}

sql+=" ) order by new_code with ur "; 
//out.println(sql);
//out.println(county);
// 分页模块代码开始
int perPage=20;
int nextPage=0;
try
  {
	nextPage = Integer.parseInt(request.getParameter("nextPage2"));
	System.out.println(nextPage);
  }
catch (Exception e)
  {
  }
Divpage.setNextPage(nextPage);
Divpage.setPerPage(perPage);

// 分页模块代码结束
  Divpage.setQuerySQL(sql);

%>
<body background="/hbbass/images/bg-1.gif">
<form name="form1" method="post" action="">
<input type=hidden name=hidcounty value="<%=county%>" size=10   onChange="selChannel()">
<input type=hidden name=ifSubmit value="" size=10>
	    <table border=0 cellpadding=0 cellspacing=0>
          <tr> 
            <td valign="top"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"></td>
            <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap>定制终端总销售量及捆绑营销包统计</td>
            <td>&nbsp;</td>
          </tr>
        </table>

      <table width=100%  border=0 cellpadding=1 cellspacing=1 >
         <tr valign="middle">
           <td width="28%" nowrap bgcolor=#CCDDEE>起始时间 
            <select name="year"  onchange="prechange()">
<%
for(int i=2003;i<=year1;i++)
{
%>
			<option  value="<%=i%>" <%=(i==year)? "selected":""%>><%=i%></option>
<% 
}
%>
			</select>年
			<select name="month" onchange="doHandleMonth(document.form1.year.value,document.form1.month.value);">
<%
for(int i=1;i<13;i++)
{
%>
               <option value="<%=i%>" <%=(i==month)? "selected":""%>><%=i%></option>
<%
}
%>
			</select>月 
			<select name="day">
<%
for(int i=1;i<=bass.utilty.CharTool.getDayNum(year, month);i++)
{
%>
               <option value="<%=i%>" <%=(i==day)? "selected":""%>><%=i%></option>
<%
}
%>
			</select>日
</td>
			<td width="28%" nowrap bgcolor=#CCDDEE>终止时间 
       <select name="nextyear"  onchange="nextchange()">
<%
for(int i=2003;i<=year1;i++)
{
%>
			<option  value="<%=i%>" <%=(i==year)? "selected":""%>><%=i%></option>
<% 
}
%>
			</select>年
			<select name="nextmonth" onchange="doHandleMonth(document.form1.nextyear.value,document.form1.nextmonth.value);">
<%
for(int i=1;i<13;i++)
{
%>
               <option value="<%=i%>" <%=(i==month)? "selected":""%>><%=i%></option>
<%
}
%>
			</select>月 
			<select name="nextday" >
<%
for(int i=1;i<=bass.utilty.CharTool.getDayNum(year, month);i++)
{
%>
               <option value="<%=i%>" <%=(i==nextday)? "selected":""%>><%=i%></option>
<%
}
%>
		</select>日</td>
		    <td width="15%" align="left" bgcolor=#CCDDEE>地市 
                    <select name="city"  onChange="selCounty()">
                  	    <% if(area_id==0){%>
			       		            <option value="0" <% if(city.equals("0")) out.print("selected"); %>>全省</option>
			       		        <%}  
			       		                DevidePageBean cityInit=new DevidePageBean();
			       		                String citySQL="Select area_code,area_name from mk.bt_area "; 
			       		            		if(area_id>0)
			       		            		citySQL=citySQL+" where area_id="+area_id;
			       		            		citySQL=citySQL+" order by area_id";
			       		            		cityInit.setQuerySQL(citySQL);
			       		            		for(int i=1;i<=cityInit.getAllRowCount();i++){
			       		            		
			       		            %>
                                 <option value="<%=cityInit.getFieldValue("area_code",i)%>" <%if(cityInit.getFieldValue("area_code",i).equals(city)) out.print("selected");%>><%=cityInit.getFieldValue("area_name",i)%></option>
			       		            <%}%>
              </select>
            </td>
       <td width="29%" align="left"  bgcolor=#CCDDEE>县市
             <iframe name="frmCounty"  src="/hbbass/common/county.jsp?city_id=<%=city%>&county_id=<%=county%>"  height="20"  width="120"   frameborder="0" scrolling="no"></iframe> 
             分县域显示
             <input name="DetailArea" type="checkbox" value="show" <%if (DetailArea.equals("show")) out.print("checked");%> ></td>
          </tr>
         <tr valign="middle">
          <td height="22" nowrap bgcolor=#CCDDEE>渠道类型 
                    <select name="hidchannel">
	       		            <option value="0" <% if(channel.equals("0")) out.print("selected"); %>>全部</option>
			       		        <%  
			       		                DevidePageBean channelInit=new DevidePageBean();
			       		                String channelSQL="select distinct rec_num,up_name from  NWH.DIM_UP_CHANNEL_TYPE order by rec_num";
			       		            		channelInit.setQuerySQL(channelSQL);
			       		            		for(int i=1;i<=channelInit.getAllRowCount();i++){
			       		            		
			       		            %>
                                 <option value="<%=channelInit.getFieldValue("up_name",i)%>" <%if(channelInit.getFieldValue("up_name",i).equals(channel)) out.print("selected");%>><%=channelInit.getFieldValue("up_name",i)%></option>
			       		            <%}%>
	       		            <option value="6" <% if(channel.equals("6")) out.print("selected"); %>>其他</option>
              </select>
          </td>
          <td nowrap bgcolor=#CCDDEE>终端机型
             <select name="res_name">
			 <option value="0" <% if(res_name.equals("0")) out.print("selected"); %>>全部</option>
             <%
				String resSQL="select distinct res_name from NMK.BIND_IMEI_TYPE order by res_name with ur";
				ReportBean.execute(resSQL);
           		for (int i=0;i<ReportBean.getRowCount();i++){
             %>
             <option value="<%=ReportBean.getStringValue("res_name",i)%>" <%if(ReportBean.getStringValue("res_name",i).equals(res_name)) out.print("selected");%>><%=ReportBean.getStringValue("res_name",i)%></option>
            <%}%>
         </select>
		 <input name="DetailType" type="checkbox" value="show" <%if (DetailType.equals("show")) out.print("checked");%>>详细
         </td>
          <td align="left" bgcolor=#CCDDEE>营销案名称
		  </td>
          <td bgcolor=#CCDDEE>
		    <select name="fee_name" style="width:180">
			 <option value="0" <% if(fee_name.equals("0")) out.print("selected"); %>>全部</option>
             <%
				String feeSQL="select distinct privsetid, fee_name from NMK.GMI_BINDIMEI a,nwh.fee b where privsetid=fee_id and status='stcmNml' order by fee_name with ur";
				ReportBean2.execute(feeSQL);
           		for (int i=0;i<ReportBean2.getRowCount();i++){
             %>
             <option value="<%=ReportBean2.getStringValue("privsetid",i)%>" <%if(ReportBean2.getStringValue("privsetid",i).equals(fee_name)) out.print("selected");%>><%=ReportBean2.getStringValue("fee_name",i)%></option>
            <%}%>
            </select>
           </td>
        </tr>
        <tr>
        	<td colspan=4  align=right>
		        <input type="button" name="confirm" value="查询"  onClick="clickSubmit()">
            <input type="button" name="Submit2" value="下载"  onClick="todown()" /></td>
        	</tr>
        </table>
<table width="100%">
  <tr>
    <td align=right>单位：（个）</td>
  </tr>
</table>
 <table width="100%" border="1" borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0  align="center" >
  <tr class="result_t">
    <td width=8% align="center">地市</td>
    <td width=14% align="center">县域</td>
    <td width=27% align="center">终端机型</td>
    <td width=15% align="center">库存</td>
    <td width=17% align="center">总销售量</td>
    <td width=19% align="center">其中：捆绑IMEI业务包销售量</td>
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
    <td align=left><%
	if  (cptool.getNewAreaName(Divpage.getFieldValue("city_id",i).trim())==null) 
	{out.print("合计");}
	else {out.print(cptool.getNewAreaName(Divpage.getFieldValue("city_id",i).trim()));}%></td>
    <td align=left><%
	if (Divpage.getFieldValue("stoeid",i).trim().equals("1")) 
	{out.print("全部");}
	else
	{if (cptool.getNewAreaName(Divpage.getFieldValue("stoeid",i).trim())==null) 
	{out.print("——");}
	else
	{out.print(cptool.getNewAreaName(Divpage.getFieldValue("stoeid",i).trim()));}}%></td>
    <td align=left><%
	 if (Divpage.getFieldValue("res_name",i).equals("1")) 
	 {out.print("全部");}
	 else
	 {
	 if (Divpage.getFieldValue("res_name",i).equals("")) 
	 {
	   out.print(res_name);
	   System.out.println(res_name);
	  }
	  else
	  {out.print(Divpage.getFieldValue("res_name",i));}}
	  %></td>
    <td align=right><%=Divpage.getFieldValue("store_count",i)%></td>
    <td align=right><%=Divpage.getFieldValue("sell_count",i)%></td>
    <td align=right><a class="a2" href="terminal_sell_detail.jsp?startime=<%=startime%>&endtime=<%=endtime%>&city=<%=Divpage.getFieldValue("city_id",i).trim()%>&county=<%=Divpage.getFieldValue("stoeid",i).trim()%>&res_name=<%=Divpage.getFieldValue("res_name",i)%>&fee_name=<%=fee_name%>&channel=<%=channel%>&city_qry=<%=city%>&county_qry=<%=county%>&res_qry=<%=res_name%>"  title="点击查看用户详单"><%=Divpage.getFieldValue("imei_count",i)%></a></td>
  </tr>  
<%}%>  
</table>
<!-- 分页控制页面  共用 -->
<%@ include file="/hbbass/common/common_page.jsp"%>   
</form>
</body>
</html>
