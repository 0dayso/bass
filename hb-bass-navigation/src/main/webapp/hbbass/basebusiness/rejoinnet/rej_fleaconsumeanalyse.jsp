<%@ page contentType="text/html; charset=gb2312"%>

<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cptool" scope="session" class="bass.database.compete.CompetePool" /> 
<%@ page import = "bass.common.DevidePageBean"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ include file="/hbbass/common/queryload.html"%>
<HTML>
<HEAD>
<TITLE>湖北移动经营分析系统</TITLE>
<META http-equiv=/hbbass/images/content-Type /hbbass/images/content="text/html; charset=gb2312"> 
<script type="text/javascript" src="/hbbass/js/tablesort.js"></script>
<script language="javascript">
function help() 
{ 
var userwindow=window.open('rej_fleaconsumeanalyse_help.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
userwindow.focus();
}
function selCounty()
{
	form1.hidcounty.value="0";
	var cid = this.document.form1.city.value;	
	frmCounty.location.href="county_rn.jsp?city_id="+cid+"&county_id=0";
}
function tosubmit()
{
	document.form1.confirm.disabled=true;
  queryload.style.display="block";
  document.form1.nextPage2.value=0;
	document.form1.action = "rej_fleaconsumeanalyse.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_fleaconsumeanalyse_down.jsp";
	document.form1.target = "_top";
	document.form1.submit();
}
</script>
<style type="text/css">
<!--
@import url("/hbbass/css/com.css");
-->
</style>
<style type="text/css">

</style>
<style type="text/css">
a:link { text-decoration: none;color: #0000FF}
a:active { text-decoration: underline; color: red}
a:hover { text-decoration: none; color: red} 
a:visited { text-decoration: none;color: #0000FF}
.style2 {color: #0000FF}
</style>
</HEAD>
<%--本页 jsp 初始化程序段--%>
<%
response.setHeader("Cache-Control","no-store");

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

//根据登录名查询用户的信息 如用户所属的区域
int area_id = Integer.parseInt((String)session.getAttribute("area_id"));


// 时间选择条件由数据库目标表取出
DevidePageBean timeInit=new DevidePageBean();
timeInit.setPerPage(20);
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from nmk.DMRN_STAT_RNUSER_MS order by timeid desc fetch first 20 row only ");
String defaulttime="200602"; // 设置缺省的时间为数据库中最大的时间，如果数据库取不到值则设为200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String curbrand=request.getParameter("curbrand")==null?"0":request.getParameter("curbrand");
String dbname=request.getParameter("dbname")==null?"":request.getParameter("dbname");
String hisbrand=request.getParameter("hisbrand")==null?"0":request.getParameter("hisbrand");
String hisdbname=request.getParameter("hisdbname")==null?"":request.getParameter("hisdbname");
String now_consumelev=request.getParameter("now_consumelev")==null?"P":request.getParameter("now_consumelev");
String his_consumelev=request.getParameter("his_consumelev")==null?"P":request.getParameter("his_consumelev");

dbname=new String(dbname.getBytes("ISO-8859-1"),"gb2312"); 
hisdbname=new String(hisdbname.getBytes("ISO-8859-1"),"gb2312"); 
String order=request.getParameter("order")==null?"cust_num":request.getParameter("order");
String querysql="";

//品牌 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("Select distinct db_tid,case when db_tid=2 then '集团标准资费套餐' else db_tname end as db_tname from NWH.DIM_BRAND ORDER BY db_tid");

//消费层次
DevidePageBean ConsumeLev=new DevidePageBean();
ConsumeLev.setQuerySQL("select consumelev,level_name from nmk.dmrn_dim_cust_consumelev order by consumelev");

// 分页模块代码开始
int perPage=10;
int nextPage=0;
try
 {
	nextPage = Integer.parseInt(request.getParameter("nextPage2"));
 }
catch (Exception e)
 {
 }
Divpage.setNextPage(nextPage);
Divpage.setPerPage(perPage);
// 分页模块代码结束
//0 显示全部 1 不参与分组
querysql="Select RN_DATE";
if (!city.equals("1")) //按地市分组或者单一地市
{
	querysql+=",RN_BASE_REGION_CODE";
}
if((!hidcounty.equals("1"))&&(!city.equals("1"))) 
{
	querysql+=",RN_BASE_COUNTY_CODE";
}
if(!curbrand.equals("X"))
{
	querysql+=",RN_BASE_BRAND_ID";
}
if(!hisbrand.equals("X"))
{
	querysql+=",HIS_BEFORE_BRAND_ID";
}
/*
if(!dbname.equals(""))
{
	querysql+=",d.brand_name as base_plan_name";
}	
if(!hisdbname.equals(""))
{
	querysql+=",e.brand_name as before_plan_name";
}
*/	
querysql+=",d.brand_name as base_plan_name";
querysql+=",e.brand_name as before_plan_name";
if(!now_consumelev.equals("X"))
{
	querysql+=",b.level_name as now_level";
}
if(!his_consumelev.equals("X"))
{
	querysql+=",c.level_name as his_level";
}


querysql+=		" ,count(*) as cust_num,sum(RN_NEXT_SHOULD_FEE) as next_should_fee,sum(RN_NEXT_FAV_FEE) as nex_fav_fee,"+
				"sum(HIS_BEFORE_SHOULD_FEE) as before_should_fee,sum(HIS_BEFORE_FAV_FEE) as before_fav_fee"+
				" from (select * from nmk.DMRN_USER_MS where "+
				"replace(substr(char(rn_date),1,7),'-','')>='"+starttime+
				"' and replace(substr(char(rn_date),1,7),'-','')<='"+endtime+"' and flea_flag=1) a"+
				" LEFT OUTER JOIN nmk.dmrn_dim_cust_consumelev b on a.rn_next_consumelev=b.consumelev"+
 " LEFT OUTER JOIN nmk.dmrn_dim_cust_consumelev c on a.his_before_consumelev=c.consumelev"+
				" left outer join nwh.dim_brand d on a.rn_base_plan_id=d.brand_id"+
				" left outer join nwh.dim_brand e on a.HIS_BEFORE_PLAN_ID=e.brand_id where 1=1 ";

if((!city.equals("1"))&&(!city.equals("0")))
{
 if((!hidcounty.equals("1"))&&(!hidcounty.equals("0")))
 {
 querysql=querysql+" and RN_BASE_REGION_CODE ='"+city.substring(3,5)+"' and RN_BASE_COUNTY_CODE='"+hidcounty.substring(6,8)+"'";
 }
 else
 	{
 querysql=querysql+" and RN_BASE_REGION_CODE ='"+city.substring(3,5)+"'";
 }
}
if((!curbrand.equals("0"))&&(!curbrand.equals("X")))
{
 querysql=querysql+" and RN_BASE_BRAND_ID = "+curbrand;
}
if((!hisbrand.equals("0"))&&(!hisbrand.equals("X")))
{
 querysql=querysql+" and HIS_BEFORE_BRAND_ID = "+hisbrand;
}

if(!dbname.equals(""))
{
 querysql=querysql+" and base_plan_name like '%"+dbname+"%'";
}
if(!hisdbname.equals(""))
{
 querysql=querysql+" and before_plan_name like '%"+hisdbname+"%'";
}
now_consumelev=new String(now_consumelev.getBytes("ISO-8859-1"),"gb2312"); 
his_consumelev=new String(his_consumelev.getBytes("ISO-8859-1"),"gb2312"); 
if((!now_consumelev.equals("P"))&&(!now_consumelev.equals("X")))
{
 querysql=querysql+" and a.rn_next_consumelev ="+now_consumelev;
}
if((!his_consumelev.equals("P"))&&(!his_consumelev.equals("X")))
{
 querysql=querysql+" and a.his_before_consumelev= "+his_consumelev;
}
querysql+=" group by rn_date";
if (!city.equals("1")) //按地市分组或者单一地市
{
	querysql+=",RN_BASE_REGION_CODE";
}
if((!hidcounty.equals("1"))&&(!city.equals("1"))) 
{
	querysql+=",RN_BASE_COUNTY_CODE";
}
if(!curbrand.equals("X"))
{
	querysql+=",RN_BASE_BRAND_ID";
}
if(!hisbrand.equals("X"))
{
	querysql+=",HIS_BEFORE_BRAND_ID";
}
/*
if(!dbname.equals(""))
{
	querysql+=",d.brand_name";
}	
if(!hisdbname.equals(""))
{
	querysql+=",e.brand_name";
}
*/	
querysql+=",d.brand_name";
querysql+=",e.brand_name";
if(!now_consumelev.equals("X"))
{
	querysql+=",b.level_name";
}
if(!his_consumelev.equals("X"))
{
	querysql+=",c.level_name";
}
querysql+=" order by "+order+" desc,rn_date with ur";
if(request.getMethod().equals("POST"))
{
Divpage.setQuerySQL(querysql);
}
//out.println(querysql);
%>
<body>
<form id="form1" name="form1" method="post" action="">
<!-- 隐藏表单区 -->
 <input type=hidden name=hidcounty value="<%=hidcounty%>" size=10>
 <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="tt">
 <tr>
 <td colspan="8" align="center" ><table border=0 align="left" cellpadding=0 cellspacing=0>
 <tr>
 <td valign="top"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"></td>
 <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap><A class="a2" onClick="changeText(11); return sortTable('resultTbody', 11, true,0);" href="#" title="按多次重入网客户次月收入降序排列"></a>多次重入网客户消费变化分析</td>
 <td></td>
 </tr>
 </table>   <a href="javascript:help();" ><span class="style2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;帮助</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=11% align="right" nowrap class="query_t">起始时间</td>
 <td width=7% align="left" class="query_v">
 <select name="starttime">
 				<%
 for(int m=1;m<=timeInit.getAllRowCount();m++)
		 					{
	 String timeid=timeInit.getFieldValue("timeid",m);
		 			%>
		 						<option value="<%=timeid%>" <%if(timeid.equals(starttime)) out.print("selected"); %>><%=timeid%></OPTION>
		 				<% 
		 						 }
 				%>
 	 </select> </td>
 <td width=6% align="right" nowrap class="query_t">地区</td>
 <td width=14% align="left" class="query_v">
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
 </select></td>
 <td width=9% align="right" nowrap class="query_t">当前品牌</td>
 <td width=13% align="left" class="query_v"><select name="curbrand" id="curbrand">
 <option value="0"<% if (curbrand.equals("0")) out.print("selected");%>>显示全部品牌</OPTION>
 <%
 for(int m=1;m<=brandInit.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=brandInit.getFieldValue("db_tid",m)%>" <%if(brandInit.getFieldValue("db_tid",m).equals(curbrand)) out.print("selected"); %>><%=brandInit.getFieldValue("db_tname",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 <option value="-1" <%if(curbrand.equals("-1")) out.print("selected"); %>>其他</OPTION>
 </select></td>
 <td width=9% align="right" nowrap class="query_t">当前消费层次</td>
 <td width=31% align="left" class="query_v"><select name="now_consumelev" id="now_consumelev">
 <option value="P"<% if (now_consumelev.equals("显示全部")) out.print("selected");%>>显示全部</OPTION>
 <%
 for(int m=1;m<=ConsumeLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=ConsumeLev.getFieldValue("consumelev",m)%>" <%if(ConsumeLev.getFieldValue("consumelev",m).equals(now_consumelev)) out.print("selected"); %>><%=ConsumeLev.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 </tr>
 <tr>
 <td align="right" nowrap class="query_t">结束时间</td>
 <td align="left" class="query_v"><select name="endtime">
 <%
 for(int m=1;m<=timeInit.getAllRowCount();m++)
		 					{
	 String timeid=timeInit.getFieldValue("timeid",m);
		 			%>
 <option value="<%=timeid%>" <%if(timeid.equals(endtime)) out.print("selected"); %>><%=timeid%></OPTION>
 <% 
		 						 }
 				%>
 </select></td>
 <td align="right" nowrap class="query_t">县市</td>
 <td align="left" class="query_v"><iframe name="frmCounty" src="county_rn.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe></td>
 <td align="right" nowrap class="query_t">历史品牌</td>
 <td align="left" class="query_v"><select name="hisbrand" id="hisbrand">
 <option value="0"<% if (hisbrand.equals("0")) out.print("selected");%>>显示全部品牌</OPTION>
 <%
 for(int m=1;m<=brandInit.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=brandInit.getFieldValue("db_tid",m)%>" <%if(brandInit.getFieldValue("db_tid",m).equals(hisbrand)) out.print("selected"); %>><%=brandInit.getFieldValue("db_tname",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 <option value="-1" <%if(hisbrand.equals("-1")) out.print("selected"); %>>其他</OPTION>
 </select></td>
 <td align="right" nowrap class="query_t">历史消费层次</td>
 <td align="left" nowrap class="query_v"><select name="his_consumelev" id="his_consumelev">
 <option value="P"<% if (his_consumelev.equals("显示全部")) out.print("selected");%>>显示全部</OPTION>
 <%
 for(int m=1;m<=ConsumeLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=ConsumeLev.getFieldValue("consumelev",m)%>" <%if(ConsumeLev.getFieldValue("consumelev",m).equals(his_consumelev)) out.print("selected"); %>><%=ConsumeLev.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select>
   &nbsp;&nbsp;&nbsp;
   <input type="button" name="confirm" value="查询（OK）" onClick="tosubmit()" />
   &nbsp;
   <input type="button" name="Submit2" value="数据下载" onClick="todown()" /></td>
 </tr>
 </table>
 <br>
	<table id="resultTable" width="110%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
  <THEAD id="resultHead">
 <tr class="result_t"> 
  <td width=5% rowspan="3" align="center" style="display:none">排序</td>    
 <td align="center" width=6%>日期</td>
 <td align="center" width=5%>地区名称</td>
 <td align="center" width=8%>区域名称</td>
 <td align="center" width=8%>当前品牌</td>
 <td align="center" width=6%>历史品牌</td>
 <td align="center" width=5%>当前消<br>费层次 </td>
 <td align="center" width=5%>历史消<br>费层次 </td>
 <td align="center" id=9  width=6%> <A class="a2" onClick="changeText(9);  return sortTable('resultTbody', 9 , true,0);" href="#" title="按多次重入网客户数降序排列">多次重入<br>网客户数</a></td>
 <td align="center" id=10 width=8%> <A class="a2" onClick="changeText(10); return sortTable('resultTbody', 10, true,0);" href="#" title="按多次重入网客户次月收入降序排列">多次重入网<br>客户月收入</a></td>
 <td align="center" id=11 width=8%> <A class="a2" onClick="changeText(11); return sortTable('resultTbody', 11, true,0);" href="#" title="按多次重入网客户次月收入降序排列">多次重入网<br>客户优惠金额</a></td>
 <td align="center" id=12 width=8%> <A class="a2" onClick="changeText(12); return sortTable('resultTbody', 12, true,0);" href="#" title="按多次重入网客户次月收入降序排列">多次重入网历<br>史客户月收入</a></td>
 <td align="center" id=13 width=8%> <A class="a2" onClick="changeText(13); return sortTable('resultTbody', 13, true,0);" href="#" title="按多次重入网客户次月收入降序排列">多次重入网历史<br>客户优惠金额</a></td>
 </tr>
     </THEAD>                       
     <TBODY id="resultTbody">      

 <%
 double per1=0;
 double per2=0;
 String tr_class="";
 for(int i=1;i<=Divpage.getRowNum();i++)
		 { 
		 if(i%2==0)
 tr_class="result_v_2";
 else
 	 tr_class ="result_v_1";
 %> 
 <tr class=<%=tr_class%> onMouseOver="this.className='result_v_3'" onMouseOut="this.className='<%=tr_class%>'">
 <td align=center class="result_t" style="display:none">&nbsp;</td>
 <td align="left" ><%=Divpage.getFieldValue("RN_DATE",i)%></td>
 <td align="left" ><%=city.equals("1")?"全部":cptool.getNewAreaName("HB."+Divpage.getFieldValue("RN_BASE_REGION_CODE",i).trim())%></td>
 <td align="left" ><%=(hidcounty.equals("1")||city.equals("1"))?"全部":cptool.getNewAreaName("HB."+Divpage.getFieldValue("RN_BASE_REGION_CODE",i).trim()+"."+Divpage.getFieldValue("RN_BASE_COUNTY_CODE",i))%></td>
 <td align="left" ><%=cptool.getBrandNname(Divpage.getFieldValue("RN_BASE_BRAND_ID",i).trim())%></td>
 <td align="left" ><%=Divpage.getFieldValue("before_plan_name",i).equals("")?"其它套餐":Divpage.getFieldValue("before_plan_name",i)%></td>
 <td align="right" ><%=Divpage.getFieldValue("now_level",i)%></td>
 <td align="right" ><%=Divpage.getFieldValue("his_level",i)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("cust_num",i),0)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("next_should_fee",i),0)%></td>	
 <td align="right" ><%=mp.round(Divpage.getFieldValue("nex_fav_fee",i),0)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("before_should_fee",i),0)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("before_fav_fee",i),0)%></td>
 </tr>
 <%
 }
 %>
    </TBODY>
 </table>
<!-- 分页控制页面 共用 -->
 <%@ include file="/hbbass/common/common_page.jsp"%> 
</form>
</body>
</html>
