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
var userwindow=window.open('rej_oldnofullanalyse_help.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
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
	document.form1.action = "rej_oldnofullanalyse.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_oldnofullanalyse_down.jsp";
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
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from nmk.DMRN_STAT_RNUSER_MS order by timeid desc fetch first 15 row only ");
String defaulttime="200602"; // 设置缺省的时间为数据库中最大的时间，如果数据库取不到值则设为200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String hisbrand=request.getParameter("hisbrand")==null?"0":request.getParameter("hisbrand");
String now_consumelev=request.getParameter("now_consumelev")==null?"P":request.getParameter("now_consumelev");
String his_consumelev=request.getParameter("his_consumelev")==null?"P":request.getParameter("his_consumelev");

String order=request.getParameter("order")==null?"cust_num":request.getParameter("order");
String querysql="";

//品牌 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("Select distinct db_tid,case when db_tid=2 then '集团标准资费套餐' else db_tname end as db_tname from NWH.DIM_BRAND ORDER BY db_tid");

//充值次数层次
DevidePageBean payed_count=new DevidePageBean();
payed_count.setQuerySQL("select payed_count_level,level_name from nmk.DMRN_DIM_PAYED_COUNT_LEVEL order by payed_count_level");

//充值金额层次
DevidePageBean payed_sum=new DevidePageBean();
payed_sum.setQuerySQL("select payed_sum_level,level_name from nmk.DMRN_DIM_PAYED_SUM_LEVEL order by payed_sum_level");


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
querysql="Select RN_DATE";
if (!city.equals("1")) //按地市分组或者单一地市
{
	querysql+=",REGION_CODE";
}
if((!hidcounty.equals("1"))&&(!city.equals("1"))) 
{
	querysql+=",COUNTY_CODE";
}
if(!hisbrand.equals("X"))
{
	querysql+=",HIS_BRAND_ID";
}
if(!now_consumelev.equals("X"))
{
	querysql+=",B.LEVEL_NAME AS PAYED_COUNT_LEVEL";
}
if(!his_consumelev.equals("X"))
{
	querysql+=",C.LEVEL_NAME AS PAYED_SUM_LEVEL";
}

querysql+= " ,sum(RN_USER_COUNT) as RN_CUST_NUM"+
				" from nmk.DMRN_ST_OLAPUSER_MS a,nmk.DMRN_DIM_PAYED_COUNT_LEVEL b, nmk.DMRN_DIM_PAYED_SUM_LEVEL c"+
				" where "+
				"replace(substr(char(rn_date),1,7),'-','')>='"+starttime+
				"' and replace(substr(char(rn_date),1,7),'-','')<='"+endtime+"' "+
				" and HIS_PAYED_COUNT_LEVEL=PAYED_COUNT_LEVEL and HIS_PAYED_SUM_LEVEL=PAYED_SUM_LEVEL ";
if((!city.equals("1"))&&(!city.equals("0")))
{
 if((!hidcounty.equals("1"))&&(!hidcounty.equals("0")))
 {
 querysql=querysql+" and REGION_CODE ='"+city.substring(3,5)+"' and COUNTY_CODE='"+hidcounty.substring(6,8)+"'";
 }
 else
 	{
 querysql=querysql+" and REGION_CODE ='"+city.substring(3,5)+"'";
 }
}
if((!hisbrand.equals("0"))&&(!hisbrand.equals("X")))
{
 querysql=querysql+" and HIS_BRAND_ID = "+hisbrand;
}
if((!now_consumelev.equals("P"))&&(!now_consumelev.equals("X")))
{
 querysql=querysql+" and PAYED_COUNT_LEVEL ="+now_consumelev;
}
if((!his_consumelev.equals("P"))&&(!his_consumelev.equals("X")))
{
 querysql=querysql+" and PAYED_SUM_LEVEL= "+his_consumelev;
}
querysql+=" group by RN_DATE";
if (!city.equals("1")) //按地市分组或者单一地市
{
	querysql+=",REGION_CODE";
}
if((!hidcounty.equals("1"))&&(!city.equals("1"))) 
{
	querysql+=",COUNTY_CODE";
}
if(!hisbrand.equals("X"))
{
	querysql+=",HIS_BRAND_ID";
}
if(!now_consumelev.equals("X"))
{
	querysql+=",B.LEVEL_NAME";
}
if(!his_consumelev.equals("X"))
{
	querysql+=",C.LEVEL_NAME";
}
querysql+=" order by RN_CUST_NUM desc,rn_date with ur";

// out.println(querysql);

if(request.getMethod().equals("POST"))
{
 Divpage.setQuerySQL(querysql);
}
%>
<body>
<form id="form1" name="form1" method="post" action="">
<!-- 隐藏表单区 -->
 <input type=hidden name=hidcounty value="<%=hidcounty%>" size=10>
 <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="tt">
 <tr>
 <td align="center" ><table border=0 cellpadding=0 cellspacing=0>
 <tr>
 <td valign="top"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"></td>
 <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap> 重入网老号码充值分析</td>
 <td></td>
 </tr>
 </table></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ><a href="javascript:help();" ><span class="style2">帮助</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=14% align="right" class="query_t">起始时间</td>
 <td width=11% align="left" class="query_v">
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
 <td width=17% align="right" class="query_t">地区</td>
 <td width=11% align="left" class="query_v">
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
 <td width=18% align="right" nowrap class="query_t">累计充值次数层次</td>
 <td width=29% align="left" class="query_v"><select name="now_consumelev" id="now_consumelev">
 <option value="P"<% if (now_consumelev.equals("显示全部")) out.print("selected");%>>显示全部</OPTION>
 <%
 for(int m=1;m<=payed_count.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=payed_count.getFieldValue("payed_count_level",m)%>" <%if(payed_count.getFieldValue("payed_count_level",m).equals(now_consumelev)) out.print("selected"); %>><%=payed_count.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 </tr>
 <tr>
 <td align="right" class="query_t">结束时间</td>
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
 <td align="right" class="query_t">县市</td>
 <td align="left" class="query_v"><iframe name="frmCounty" src="county_rn.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe></td>
 <td align="right" nowrap class="query_t">累计充值金额层次</td>
 <td align="left" class="query_v"><select name="his_consumelev" id="his_consumelev">
 <option value="P"<% if (his_consumelev.equals("显示全部")) out.print("selected");%>>显示全部</OPTION>
 <%
 for(int m=1;m<=payed_sum.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=payed_sum.getFieldValue("payed_sum_level",m)%>" <%if(payed_sum.getFieldValue("payed_sum_level",m).equals(his_consumelev)) out.print("selected"); %>><%=payed_sum.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 </tr>
 <tr>
 <td align="right" class="query_t">历史品牌</td>
 <td align="left" class="query_v"><select name="hisbrand" id="hisbrand">
 <option value="0" selected<% if (hisbrand.equals("0")) out.print("selected");%>>全部品牌</OPTION>
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
 <td colspan="4" align="left" class="query_v"> &nbsp;&nbsp;</td>
 </tr>
 <tr>
 
 </tr>
 <tr>
 
 <td colspan="6" align="right" nowrap> <input type="button" name="confirm" value="查询（OK）" onClick="tosubmit()" />
 &nbsp;&nbsp;
 <input type="button" name="Submit2" value="数据下载" onClick="todown()" /></td>
 </tr>
 <tr>
 
 </tr>
 </table>
 <br>
	<table  id="resultTable" width="100%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
  <THEAD id="resultHead">
 <td width=5% rowspan="3" align="center" style="display:none">排序</td>  
 <tr class="result_t">
 <td align="center" width=10%>日期</td>
 <td align="center" width=13%>地区名称</td>
 <td align="center" width=16%>区域名称</td>
 <td align="center" width=16%>历史品牌</td>
 <td align="center" width=17%>累计充值次数层次</td>
 <td align="center" width=16%>累计充值金额层次</td>
 <td align="center" width=12% id=7><A class="a2" onclick="changeText(7); return sortTable('resultTbody', 7, true,0);" href="#" title="按重入网客户数降序排列"> 重入网客户数 </a></td>
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
 <td align="left" ><%=city.equals("1")?"全部":cptool.getNewAreaName("HB."+Divpage.getFieldValue("REGION_CODE",i).trim())%></td>
 <td align="left" >
 <%
 if ((hidcounty.equals("1")||city.equals("1"))) out.print("全部");
 if (cptool.getNewAreaName("HB."+Divpage.getFieldValue("REGION_CODE",i).trim()+"."+Divpage.getFieldValue("COUNTY_CODE",i))==null)
 {out.print("不祥");}
 else
 {out.print(cptool.getNewAreaName("HB."+Divpage.getFieldValue("REGION_CODE",i).trim()+"."+Divpage.getFieldValue("COUNTY_CODE",i)));}
 %>
 </td> 
 
 <td align="left" ><%=cptool.getBrandNname(Divpage.getFieldValue("HIS_BRAND_ID",i).trim())%></td>
 <td align="right" ><%=Divpage.getFieldValue("PAYED_COUNT_LEVEL",i)%></td>
 <td align="right" ><%=Divpage.getFieldValue("PAYED_SUM_LEVEL",i)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("RN_CUST_NUM",i),0)%></td>
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
