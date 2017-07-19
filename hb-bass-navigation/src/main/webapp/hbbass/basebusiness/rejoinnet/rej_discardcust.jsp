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
var userwindow=window.open('rej_discardcust_help.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
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
	document.form1.action = "rej_discardcust.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_discardcust_down.jsp";
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
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from NMK.DMRN_GIVEUP_CARD_USER_MS order by timeid desc fetch first 12 row only ");
String defaulttime="200602"; // 设置缺省的时间为数据库中最大的时间，如果数据库取不到值则设为200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String curbrand=request.getParameter("curbrand")==null?"0":request.getParameter("curbrand");
String flea_flag=request.getParameter("flea_flag")==null?"X":request.getParameter("flea_flag");

String order=request.getParameter("order")==null?"PAYED_COUNT":request.getParameter("order");
String querysql="";

//品牌 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("Select distinct db_tid,case when db_tid=2 then '集团标准资费套餐' else db_tname end as db_tname from NWH.DIM_BRAND ORDER BY db_tid");


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
querysql =		"select a.rn_date,a.rn_user_number,a.his_user_number,b.RN_BASE_ORG_ID,b.rn_base_dept_code,b.rn_base_plan_id,a.BRAND_ID,a.HIS_BRAND_ID,b.rn_next_consumelev,b.HIS_BEFORE_CONSUMELEV,b.HIS_BEFORE_PLAN_ID,b.his_create_date,a.FLEA_FLAG"+
 ",b.CHANGE_PHONE_FLAG,b.HIS_BASE_UNPAY_FEE,b.HIS_BASE_AVG_PAYED_MONEY from NMK.DMRN_GIVEUP_CARD_USER_MS a,nmk.DMRN_USER_MS b where a.rn_user_id=b.rn_user_id and year(a.rn_date)*100+month(a.rn_date)>="+starttime+" and year(a.rn_date)*100+month(a.rn_date)<="+endtime ;

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
if((!curbrand.equals("0"))&&(!curbrand.equals("X")))
{
 querysql=querysql+" and BRAND_ID = "+curbrand;
}
if(!flea_flag.equals("X"))
{
 querysql=querysql+" and a.flea_flag= "+flea_flag;
}
//querysql+=" order by "+order+" desc,rn_date with ur";
querysql+=" order by RN_USER_NUMBER, "+order+" desc with ur";
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
 <td colspan="3" align="left" nowrap ><span style="font-size:10.8pt;color:#ff6622"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5">一次性弃卡客户名单即席查询</span></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td width="8%" align="center" ></td>
 <td width="9%" align="center" ></td>
 <td width="14%" align="center" ><a href="javascript:help();" ><span class="style2">帮助</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=10% align="right" class="query_t">起始时间</td>
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
 <td width=9% align="right" class="query_t">地区</td>
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
 <td width=15% align="right" nowrap class="query_t">业务品牌</td>
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
 <option value="11" <%if(curbrand.equals("11")) out.print("selected"); %>>标准神州行</OPTION>
 </select></td>
 <td colspan="3" align="right" class="query_v"></td>
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
 <td align="right" nowrap class="query_t">多次重入网标志</td>
 <td align="left" class="query_v"><select name="flea_flag" id="flea_flag">
 <option value="X"<% if (flea_flag.equals("X")) out.print("selected");%>>全部</OPTION>
 <option value="0"<% if (flea_flag.equals("0")) out.print("selected");%>>否</OPTION>
 <option value="1"<% if (flea_flag.equals("1")) out.print("selected");%>>是</OPTION>
 </select></td>
 <td colspan="3" align="center" nowrap class="query_v"><input type="button" name="confirm" value="查询（OK）" onClick="tosubmit()" />
 <label> &nbsp;&nbsp;
 <input type="button" name="Submit2" value="数据下载" onClick="todown()" />
 </label></td>
 </tr>
 </table>
 <br>
	<table id="resultTable" width="160%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
 <THEAD id="resultHead">   
 <tr class="result_t">
 <td width=1% rowspan="3" align="center" style="display:none">排序</td> 
 <td align="center" width=4%>时间</td>
 <td align="center" width=4%>一次性弃卡<br>客户号码</td>
 <td align="center" width=4%>历史客<br>户号码</td>
 <td align="center" width=5%>当前渠<br>道代码</td>
 <td align="center" width=5%>当前渠<br>道名称</td>
 <td align="center" width=3%>当前套<br>餐代码</td>
 <td align="center" width=5%>当前品牌</td>
 <td align="center" width=4%>历史品牌</td>
 <td align="center" width=5%>当前消<br>费层次</td>
 <td align="center" width=5%>历史消<br>费层次</td>
 <td align="center" width=3%>历史套<br>餐代码</td>
 <td align="center" width=5%>历史入<br>网时间</td>
 <td align="center" width=3%>多次重入<br>网标志</td>
 <td align="center" width=3%>换机标志</td>
 <td align="center" width=4%>历史渠<br>道代码</td>
 <td align="center" width=6%>历史渠<br>道名称</td>
 <td align="right" id=17 width=3%><A class="a2" onClick="changeText(17); return sortTable('resultTbody', 17, true,0);" href="#" title="按欠费金额降序排列">历史欠<br>费金额</a></td>
 <td align="right" width=4%>历史平均每<br>月充值金额</td>

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
 <td align="left" nowrap ><%=Divpage.getFieldValue("RN_DATE",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_user_number",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("his_user_number",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("RN_BASE_ORG_ID",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_base_dept_code",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_base_plan_id",i)%></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("BRAND_ID",i))%></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("HIS_BRAND_ID",i))%></td>
 <td align="left" nowrap ><%=cptool.getXiaoFei(Divpage.getFieldValue("rn_next_consumelev",i))%></td>
 <td align="left" nowrap ><%=cptool.getXiaoFei(Divpage.getFieldValue("HIS_BEFORE_CONSUMELEV",i))%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_BEFORE_PLAN_ID",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("his_create_date",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("FLEA_FLAG",i).equals("1")?"是":"否"%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("CHANGE_PHONE_FLAG",i).equals("1")?"是":"否"%></td>
 <td align="left" nowrap >不详</td>
 <td align="left" nowrap >不详</td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_BASE_UNPAY_FEE",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_BASE_AVG_PAYED_MONEY",i)%></td>
 

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
