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
<script type="text/javascript" src="/hbbass/js/hbcommon.js"></SCRIPT> 

<script language="javascript">
function help() 
{ 
var userwindow=window.open('rej_kpihelp.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
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
	document.form1.action = "rej_kpi.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	SaveAsExcel('KPI指标.csv');
}


</script>
<style type="text/css">
<!--
@import url("/hbbass/css/com.css");
-->
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
timeInit.setQuerySQL("Select distinct year(rn_date)*100+month(rn_date) timeid from nmk.DMRN_STAT_RNUSER_MS order by timeid desc fetch first 12 row only ");
String defaulttime="200602"; // 设置缺省的时间为数据库中最大的时间，如果数据库取不到值则设为200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String brand=request.getParameter("brand")==null?"0":request.getParameter("brand");

String order=request.getParameter("order")==null?"RN_COUNT":request.getParameter("order");
String cb=request.getParameter("rb")==null?"dy":request.getParameter("rb");

//品牌类型 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("select brand_id,brand_name from brand_cfg order by brand_id");

String withsql=" with t1(f1,f2,f3,f4,f5,f6,f7,f8,f9) as ( ";
String commansql=",sum(RN_COUNT) RN_COUNT,sum(FLEA_COUNT) FLEA_COUNT,sum(GIVEUP_CARD_COUNT) GIVEUP_CARD_COUNT,"+
 " decimal(sum(RN_COUNT),10,4)*100/sum(NEW_USER_COUNT) RN_PROPORTION,decimal(sum(FLEA_COUNT),10,4)*100/sum(NEW_USER_COUNT) FLEA_PROPORTION,sum(CHANGE_BRAND_COUNT) CHANGE_BRAND_COUNT,sum(CHANGE_PLAN_COUNT) CHANGE_PLAN_COUNT, sum(NEW_USER_COUNT) NEW_USER_COUNT from nmk.DMRN_KPI_ANALYSE_MS a ";

String querysql=""; 
String fieldsql="select 'HB.'||region_code as area_id";
String wheresql=" where year(rn_date)*100+month(rn_date)>="+starttime+" and year(rn_date)*100+month(rn_date)<="+endtime;
String groupsql=" group by 'HB.'||region_code "; 
if(cb.equals("dy"))
{
	if(!city.equals("0"))
	 {
			fieldsql="select case when region_code=county_code then 'HB.'||region_code||'.'||'01' else 'HB.'||region_code||'.'||county_code end as area_id "; 
			groupsql=" group by case when region_code=county_code then 'HB.'||region_code||'.'||'01' else 'HB.'||region_code||'.'||county_code end "; 
			if(!hidcounty.equals("0"))
 {
 wheresql=wheresql+" and region_code ='"+city.substring(3,5)+"' ";
		 if (hidcounty.substring(6,8).equals("01")) 
		 {
		 	wheresql+=" and (county_code='"+hidcounty.substring(6,8)+"' or county_code='"+city.substring(3,5)+"') ";
		 }
		 else
		 {
		 	wheresql+=" and county_code='"+hidcounty.substring(6,8)+"' ";
		 }
 }
 else
 {
 	wheresql=wheresql+" and region_code ='"+city.substring(3,5)+"'";
 }
	
	}
}
else
{
fieldsql=" select RN_BRAND_ID as brand";
groupsql=" group by RN_BRAND_ID ";
 if(!city.equals("0"))
	 {
	 		if(!hidcounty.equals("0"))
 {
 wheresql=wheresql+" and region_code ='"+city.substring(3,5)+"' ";
		 if (hidcounty.substring(6,8).equals("01")) 
		 {
		 	wheresql+=" and (county_code='"+hidcounty.substring(6,8)+"' or county_code='"+city.substring(3,5)+"') ";
		 }
		 else
		 {
		 	wheresql+=" and county_code='"+hidcounty.substring(6,8)+"' ";
		 }
 }
 else
 {
 	wheresql=wheresql+" and region_code ='"+city.substring(3,5)+"'";
 }
	 
	 }
}	 
if(!brand.equals("0"))
{
 if(!brand.equals("-1"))
 {
 wheresql=wheresql+" and rn_brand_id = "+brand;
 }
 else
 	{
 	 wheresql=wheresql+" and rn_brand_id is null "; //brand=-1 表示品牌类型不详
 	}
}
wheresql+=" and rn_brand_id is not null ";
querysql=withsql+fieldsql+commansql+wheresql+groupsql+" having sum(RN_COUNT)>0 or sum(FLEA_COUNT)>0 or sum(GIVEUP_CARD_COUNT)>0 "+" order by "+order+" desc ) ";

if(cb.equals("dy"))
{
	if(!city.equals("0"))
	{
		querysql+=" select a.county_code as area_id,coalesce(f2,0) RN_COUNT,coalesce(f3,0) FLEA_COUNT,coalesce(f4,0) GIVEUP_CARD_COUNT, "+
			 " coalesce(f5,0) RN_PROPORTION,coalesce(f6,0) FLEA_PROPORTION,coalesce(f7,0) CHANGE_BRAND_COUNT,coalesce(f8,0) CHANGE_PLAN_COUNT,coalesce(f9,0) NEW_USER_COUNT "+
				 " from MK.BT_AREA_ALL a left join t1 b on b.f1=a.county_code "+
			 " where area_code='"+city+"' ";
		if(!hidcounty.equals("0"))
		 {
		 querysql+=" and a.county_code ='"+hidcounty+"' ";
		 }
		querysql+=" order by "+order;
	}
	else
	{
		querysql+=" select a.ITEMID as area_id,coalesce(f2,0) RN_COUNT,coalesce(f3,0) FLEA_COUNT,coalesce(f4,0) GIVEUP_CARD_COUNT, "+
			 " coalesce(f5,0) RN_PROPORTION,coalesce(f6,0) FLEA_PROPORTION,coalesce(f7,0) CHANGE_BRAND_COUNT,coalesce(f8,0) CHANGE_PLAN_COUNT,coalesce(f9,0) NEW_USER_COUNT"+
				 " from MK.DIM_AREACITY a left join t1 b on b.f1=a.ITEMID "+
			 " order by  "+order;
	}
}
else
{
	querysql+=" select a.brand_id as brand,coalesce(f2,0) RN_COUNT,coalesce(f3,0) FLEA_COUNT,coalesce(f4,0) GIVEUP_CARD_COUNT, "+
			 " coalesce(f5,0) RN_PROPORTION,coalesce(f6,0) FLEA_PROPORTION,coalesce(f7,0) CHANGE_BRAND_COUNT,coalesce(f8,0) CHANGE_PLAN_COUNT,coalesce(f9,0) NEW_USER_COUNT"+
				 " from brand_cfg a left join t1 b on b.f1=a.brand_id ";
 if(!brand.equals("0"))
	 {
 	querysql+=" where a.brand_id ="+brand;
	 }
	querysql+=" order by  RN_COUNT desc ";

}	 
querysql+=" with ur";
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
 <td valign="top" nowrap><span style="font-size:10.8pt;color:#ff6622"><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5">KPI指标</span></td>
 <td nowrap bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622">&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
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
 <td width=10% align="right" class="query_t">当前品牌</td>
 <td width=10% align="left" class="query_v">
 <select name="brand">
 <option value="0" <%if(brand.equals("0")) out.print("selected"); %>>全部</OPTION>
 				<%
 for(int m=1;m<=brandInit.getAllRowCount();m++)
		 					{
			 			%>
		 						<option value="<%=brandInit.getFieldValue("brand_id",m)%>" <%if(brandInit.getFieldValue("brand_id",m).equals(brand)) out.print("selected"); %>><%=brandInit.getFieldValue("brand_name",m)%></OPTION>
		 				<% 
		 						 }
		 	
 				%>
 	</select> </td>
 </tr>

 <tr>
 <td colspan="8"><label>
 <input name="rb" type="radio" value="dy" <%if(cb.equals("dy")) out.print("checked");%>>地域 
 <input type="radio" name="rb" value="pp" <%if(cb.equals("pp")) out.print("checked");%>>品牌</label></td>
 <td align="center"><input type="button" name="confirm" value="查询" onClick="tosubmit()" /></td>
 <td align="center"><input type="button" name="Submit2" value="数据下载" onclick="todown()" /></td>
 </tr>
 </table>
	<table id="resultTable" width="100%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
  <THEAD id="resultHead"> 
 <tr class="result_t">
 <%if(cb.equals("dy")){%>
 <td align="center" width=15% id=0%><A class="a2" onclick="changeText(0); return sortTable('resultTbody',0, true,0);" href="#"  title="点击按此排序">地域</a></td>
 <%}else{%>
 	<td align="center" width=15% id=0%><A class="a2" onclick="changeText(0); return sortTable('resultTbody',0, true,0);" href="#"  title="点击按此排序">当前品牌</a></td>
 <%}%> 	
 <td align="center" width=12% id=1><A class="a2" onclick="changeText(1); return sortTable('resultTbody',1, true,0);" href="#"  title="点击按此排序">月新增<br>重入网数<br></a></td>
 <td align="center" width=12% id=2><A class="a2" onclick="changeText(2); return sortTable('resultTbody',2, true,0);" href="#"  title="点击按此排序">月新增多次<br>重入网客户数<br></a></td>
 <td align="center" width=12% id=3><A class="a2" onclick="changeText(3); return sortTable('resultTbody',3, true,0);" href="#"  title="点击按此排序">月新增一次<br>性弃卡客户数<br></a></td>
 <td align="center" width=12% id=4><A class="a2" onclick="changeText(4); return sortTable('resultTbody',4, true,0);" href="#"  title="点击按此排序">新增客户中<br>重入网比例<br></a></td>
 <td align="center" width=12% id=5><A class="a2" onclick="changeText(5); return sortTable('resultTbody',5, true,0);" href="#"  title="点击按此排序">新增客户中多次<br>重入网客户比例</td>
 <td align="center" width=12% id=6><A class="a2" onclick="changeText(6); return sortTable('resultTbody',6, true,0);" href="#"  title="点击按此排序">月品牌变更<br>重入网客户数</td>
 <td align="center" width=12% id=7><A class="a2" onclick="changeText(7); return sortTable('resultTbody',7, true,0);" href="#"  title="点击按此排序">月套餐变更<br>重入网客户数</a></td>
 </tr> 
   </THEAD>                     
     <TBODY id="resultTbody">   
 <%

 String tr_class="";
 int[] man=new int[6];
 for(int i=1;i<=Divpage.getRowNum();i++)
		 { 
		 if(i%2==0)
 tr_class="result_v_2";
 else
 	 tr_class ="result_v_1";
 	    man[0]+=Integer.parseInt(Divpage.getFieldValue("RN_COUNT",i));
 	    man[1]+=Integer.parseInt(Divpage.getFieldValue("FLEA_COUNT",i));
 	    man[2]+=Integer.parseInt(Divpage.getFieldValue("GIVEUP_CARD_COUNT",i));
 	    man[3]+=Integer.parseInt(Divpage.getFieldValue("CHANGE_BRAND_COUNT",i));
 	    man[4]+=Integer.parseInt(Divpage.getFieldValue("CHANGE_PLAN_COUNT",i));
 	    man[5]+=Integer.parseInt(Divpage.getFieldValue("NEW_USER_COUNT",i));
 %> 
 <tr class=<%=tr_class%> onMouseOver="this.className='result_v_3'" onMouseOut="this.className='<%=tr_class%>'">
 <td  align="left" bgcolor="#B6CEEF"><% if(cb.equals("dy")) out.print(cptool.getNewAreaName(Divpage.getFieldValue("area_id",i).trim())==null?"不详":cptool.getNewAreaName(Divpage.getFieldValue("area_id",i).trim()));else out.println(cptool.getBrandNname(Divpage.getFieldValue("brand",i).trim()));%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("RN_COUNT",i)%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("FLEA_COUNT",i)%></td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("GIVEUP_CARD_COUNT",i)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("RN_PROPORTION",i),2)%>%</td>
 <td align="right" >&nbsp;<%=mp.round(Divpage.getFieldValue("FLEA_PROPORTION",i),2)%>%</td>
 <td align="right" >&nbsp;<%=Divpage.getFieldValue("CHANGE_BRAND_COUNT",i)%></td>
 <td align="right" ><%=Divpage.getFieldValue("CHANGE_PLAN_COUNT",i)%></td>	
 </tr>
 <%
 }
 %> 
   </TBODY>
 <tr class="<%if(Divpage.getRowNum()%2==0) out.print("result_v_2");else out.print("result_v_1");%>">
    <td  align="left" bgcolor="#B6CEEF">合计</td>
    <td align=right><%=man[0]%></td>
    <td align=right><%=man[1]%></td>
    <td align=right><%=man[2]%></td>
    <td align=right><%=mp.div(String.valueOf(man[0]*100),String.valueOf(man[5]),2)%>%</td>
    <td align=right><%=mp.div(String.valueOf(man[1]*100),String.valueOf(man[5]),2)%>%</td>
    <td align=right><%=man[3]%></td>
    <td align=right><%=man[4]%></td>
  </tr>    
 </table>
<!-- 分页控制页面 共用 -->
<textarea name="downcontent"  cols="122" rows="12" style="display:none"></textarea>
</form>
</body>
</html>
