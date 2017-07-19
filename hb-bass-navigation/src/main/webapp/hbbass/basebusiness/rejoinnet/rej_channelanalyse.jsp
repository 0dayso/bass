<%@ page contentType="text/html; charset=gb2312"%>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cptool" scope="session" class="bass.database.compete.CompetePool" /> 
<%@ page import = "bass.common.DevidePageBean"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ include file="/hbbass/common/queryload.html"%>
<!-- 
	增加
	try catch 部分,如下：解决数组下标越界异常
	 
	 String tmpVal = "";
	  String tmpText = "";
	  try{
		  tmpVal = agentInit.getFieldValue("rowid",m);
		  tmpText = agentInit.getFieldValue("rowname",m);
	  } catch(Exception e) {
		  e.printStackTrace();
	  }
 -->
<HTML>
<HEAD>
<TITLE>湖北移动经营分析系统</TITLE>
<META http-equiv=/hbbass/images/content-Type /hbbass/images/content="text/html; charset=gb2312">
<script type="text/javascript" src="/hbbass/js/tablesort.js"></script>
<script language="javascript">
function help()  
{  
var userwindow=window.open('rej_channelanaly_help.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
userwindow.focus();
}

function selCounty()
{
	form1.hidcounty.value="0";
	var cid = this.document.form1.city.value;	
	frmCounty.location.href="/hbbass/common/county.jsp?city_id="+cid;
}
function tosubmit()
{
	document.form1.confirm.disabled= true;
	queryload.style.display="block";
	document.form1.nextPage2.value=0;
	document.form1.action = "rej_channelanalyse.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_channelanalyse_down.jsp";
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
//session.setAttribute("area_id","270");
int area_id = Integer.parseInt((String)session.getAttribute("area_id"));


// 时间选择条件由数据库目标表取出
DevidePageBean timeInit=new DevidePageBean();
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from nmk.DMRN_STAT_RNUSER_MS order by timeid desc fetch first 12 row only ");
String defaulttime="200602"; // 设置缺省的时间为数据库中最大的时间，如果数据库取不到值则设为200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String agent=request.getParameter("agent")==null?"0":request.getParameter("agent");
String deptname=request.getParameter("deptname")==null?"":request.getParameter("deptname");
deptname=new String(deptname.getBytes("ISO-8859-1"),"gb2312"); 
String order=request.getParameter("order")==null?"RN_USER_COUNT":request.getParameter("order");


//代理类型 
DevidePageBean agentInit=new DevidePageBean();
agentInit.setQuerySQL("select rowid,rowname from nmk.VDIM_ORG_TYPE order by rowid asc");

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

String querysql="select DEPT_CODE,max(DEPT_NAME) DEPT_NAME,sum(RN_USER_COUNT) RN_USER_COUNT,sum(FLEA_USER_COUNT) FLEA_USER_COUNT,sum(NEW_USER_COUNT) NEW_USER_COUNT,"+
 " case when sum(NEW_USER_COUNT)=0 then 0 else decimal(sum(RN_USER_COUNT),10,4)*100/sum(NEW_USER_COUNT) end as rn_percent,case when sum(NEW_USER_COUNT)=0 then 0 else decimal(sum(FLEA_USER_COUNT),10,4)*100/sum(NEW_USER_COUNT) end as fl_percent from nmk.DMRN_STAT_RNUSER_MS where 1=1 "+
 " and replace(substr(char(rn_date),1,7),'-','')>='"+starttime+"' and replace(substr(char(rn_date),1,7),'-','')<='"+endtime+"'";
if(!city.equals("0"))
{
 if(!hidcounty.equals("0"))
 {
 querysql=querysql+" and region_code ='"+city.substring(3,5)+"' and county_code='"+hidcounty.substring(6,8)+"'";
 }
 else
 	{
 querysql=querysql+" and region_code ='"+city.substring(3,5)+"'";
 }
}
if(!agent.equals("0"))
{
 if(!agent.equals("-1"))
 {
 querysql=querysql+" and org_id = '"+agent+"'";
 }
 else
 	{
 	 querysql=querysql+" and org_id is null "; //agent=-1 表示代理类型不详
 	}
}
if(!deptname.equals(""))
{
 querysql=querysql+" and dept_name like '%"+deptname+"%'";
}
querysql=querysql+" group by DEPT_CODE,DEPT_NAME order by "+order+" desc,DEPT_CODE with ur";
//out.println(querysql);

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
 <td colspan="3" align="left" ><span style="font-size:10.8pt;color:#ff6622"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5">渠道因素分析</span></td>
 <td align="center">&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center">&nbsp;</td>
 <td align="center">&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" ><a href="javascript:help();" ><span class="style2">帮助</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=10% align="right" class="query_t">起始时间</td>
 <td width=10% align="left" class="query_v">
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
 <td width=10% align="right" class="query_t">结束时间</td>
 <td width=10% align="left" class="query_v">
  <select name="endtime">
 				<%
  for(int m=1;m<=timeInit.getAllRowCount();m++)
		 					{
	  String timeid=timeInit.getFieldValue("timeid",m);
		 			%>
		 						<option value="<%=timeid%>" <%if(timeid.equals(endtime)) out.print("selected"); %>><%=timeid%></OPTION>
		 				<% 
		 						 }
 				%>
 	</select> </td>
 <td width=10% align="right" class="query_t">地区</td>
 <td width=10% align="left" class="query_v">
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
 </select> </td>
 <td width=10% align="right" class="query_t">县市</td>
 <td width=10% align="left" class="query_v">
 <iframe name="frmCounty" src="/hbbass/common/county.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe> </td>
 <td width=10% align="right" class="query_t">代理类型</td>
 <td width=10% align="left" class="query_v">
 <select name="agent">
  <option value="0" <%if(agent.equals("0")) out.print("selected"); %>>全部</OPTION>
  
 				<%
  for(int m=1;m<=agentInit.getAllRowCount();m++)
		 					{
	  String tmpVal = "";
	  String tmpText = "";
	  try{
		  tmpVal = agentInit.getFieldValue("rowid",m);
		  tmpText = agentInit.getFieldValue("rowname",m);
	  } catch(Exception e) {
		  e.printStackTrace();
	  }
		 
			 			%>
  <option value="<%=tmpVal%>"><%=tmpText%></option>
		 				<% 
		 						 }
		 	
 				%>
							<option value="-1">其他</option>
 	</select> </td>
 </tr>
 <tr>
 <td width=10% align="center" nowrap class="query_t">代理商名称</td>
 <td width=10% align="center" class="query_v"><input type=text name=deptname value="<%=deptname%>" size=10> </td>
 <td width=10% align="center" class="query_v">&nbsp;</td>
 <td width=10% align="center" class="query_v"> </td>
 <td colspan="6" align="center" nowrap class="query_v">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <input type="button" name="confirm" value="查询（OK）" onClick="tosubmit()" />
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
 <input type="button" name="Submit2" value="数据下载" onClick="todown()" /></td>
 </tr>
 </table>
 <br>
	<table id="resultTable" width="100%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
  <THEAD id="resultHead">
 <tr class="result_t">
 <td width=5% rowspan="3" align="center" style="display:none">排序</td>
 <td align="center" width=15%>代理商代码</td>
 <td align="center" width=25%>代理商名称</td>
 <td align="center" id=3 width=12%><A class="a2" onclick="changeText(3); return sortTable('resultTbody', 3, true,0);" href="#"  title="按重入网客户数降序排列">重入网客户数</a></td>
 <td align="center" id=4 width=12%><A class="a2" onclick="changeText(4); return sortTable('resultTbody', 4, true,0);" href="#" title="按多次重入网客户数降序排列">多次重入网客户数</a></td>
 <td align="center" id=5 width=12%><A class="a2" onclick="changeText(5); return sortTable('resultTbody', 5, true,0);" href="#" title="按新增客户数降序排列">新增客户数</a></td>
 <td align="center" id=6 width=12%><A class="a2" onclick="changeText(6); return sortTable('resultTbody', 6, true,0);" href="#" title="按重入网客户比例降序排列">重入网客户比例</a></td>
 <td align="center" id=7 width=12%><A class="a2" onclick="changeText(7); return sortTable('resultTbody', 7, true,0);" href="#" title="按多次重入网客户数比例降序排列">多次重入网客户数比例</a></td>
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
 <td align="left" ><%=Divpage.getFieldValue("DEPT_CODE",i)%></td>
 <td align="left" ><%=Divpage.getFieldValue("DEPT_NAME",i)==""?"不详":Divpage.getFieldValue("DEPT_NAME",i)%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("RN_USER_COUNT",i)%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("FLEA_USER_COUNT",i)%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("NEW_USER_COUNT",i)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("rn_percent",i),2)%>%</td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("fl_percent",i),2)%>%</td>	
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
