<%@ page contentType="text/html; charset=gb2312"%>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cptool" scope="session" class="bass.database.compete.CompetePool" /> 
<%@ page import = "bass.common.DevidePageBean"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ include file="/hbbass/common/queryload.html"%>
<HTML>
<HEAD>
<TITLE>�����ƶ���Ӫ����ϵͳ</TITLE>
<META http-equiv=/hbbass/images/content-Type /hbbass/images/content="text/html; charset=gb2312">
<script type="text/javascript" src="/hbbass/js/tablesort.js"></script>
<script language="javascript">
function help() 
{ 
var userwindow=window.open('rej_custlisthelp.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
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
	document.form1.action = "rej_custlist.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_custlist_down.jsp";
	document.form1.target = "_top";
	document.form1.submit();
}
</script>
<style type="text/css">
<!--
@import url("/hbbass/css/com.css");
#queryload {
	position:absolute;
	width:200px;
	height:41px;
	z-index:2;
	left: 300px;
	top: 180px;
	background-color: #00FFCC;
}
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
<%--��ҳ jsp ��ʼ�������--%>
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

//���ݵ�¼����ѯ�û�����Ϣ ���û�����������
//session.setAttribute("area_id","270");
int area_id = Integer.parseInt((String)session.getAttribute("area_id"));


// ʱ��ѡ�����������ݿ�Ŀ���ȡ��
DevidePageBean timeInit=new DevidePageBean();
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from nmk.DMRN_USER_MS order by timeid desc fetch first 12 row only ");
String defaulttime="200602"; // ����ȱʡ��ʱ��Ϊ���ݿ�������ʱ�䣬������ݿ�ȡ����ֵ����Ϊ200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");

String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String curbrand=request.getParameter("curbrand")==null?"0":request.getParameter("curbrand");
String hisbrand=request.getParameter("hisbrand")==null?"0":request.getParameter("hisbrand");
String now_consumelev=request.getParameter("now_consumelev")==null?"P":request.getParameter("now_consumelev");
String his_consumelev=request.getParameter("his_consumelev")==null?"P":request.getParameter("his_consumelev");
String his_before_onlinelev=request.getParameter("his_before_onlinelev")==null?"P":request.getParameter("his_before_onlinelev");
String life_flag=request.getParameter("life_flag")==null?"X":request.getParameter("life_flag");
String change_flag=request.getParameter("change_flag")==null?"X":request.getParameter("change_flag");



String querysql="";

//Ʒ�� 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("Select distinct db_tid,case when db_tid=2 then '���ű�׼�ʷ��ײ�' else db_tname end as db_tname from NWH.DIM_BRAND ORDER BY db_tid");

//���Ѳ��
DevidePageBean ConsumeLev=new DevidePageBean();
ConsumeLev.setQuerySQL("select consumelev,level_name from nmk.dmrn_dim_cust_consumelev order by consumelev");

//����ʱ�����
DevidePageBean OnLineLev=new DevidePageBean();
OnLineLev.setQuerySQL("select onlinelev,level_name from NMK.DMRN_DIM_CUST_ONLINELEV order by onlinelev");

// ��ҳģ����뿪ʼ
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
// ��ҳģ��������
//0 ��ʾȫ�� 1 ���������
querysql ="select RN_USER_NUMBER,HIS_USER_NUMBER,RN_BASE_BRAND_ID,rn_next_consumelev,HIS_BEFORE_BRAND_ID,RN_BASE_ORG_ID,rn_base_dept_code,RN_BASE_PLAN_ID,HIS_BEFORE_PLAN_ID,"+
 "HIS_BASE_UNPAY_FEE,HIS_BASE_AVG_PAYED_COUNT,HIS_BASE_AVG_PAYED_MONEY,HIS_BEFORE_PLAN_ID,RN_NEXT_CONSUMELEV,his_create_date,HIS_NEXT_LIFE_FLAG,CHANGE_PHONE_FLAG,rn_base_plan_id,HIS_BEFORE_CONSUMELEV  from nmk.DMRN_USER_MS  where  year(rn_date)*100+month(rn_date)="+starttime;


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

if((!his_before_onlinelev.equals("P"))&&(!his_before_onlinelev.equals("X")))
{
 querysql=querysql+" and his_before_onlinelev= "+his_before_onlinelev;
}
if(!life_flag.equals("X"))
{
 querysql=querysql+" and HIS_NEXT_LIFE_FLAG= "+life_flag;
}
if(!change_flag.equals("X"))
{
 querysql=querysql+" and CHANGE_PHONE_FLAG= "+change_flag;
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

querysql+=" order by RN_USER_NUMBER,HIS_BASE_AVG_PAYED_MONEY desc with ur";

//out.println(querysql);
if(request.getMethod().equals("POST"))
{
  Divpage.setQuerySQL(querysql);
}

%>
<body>
<form id="form1" name="form1" method="post" action="">
<!-- ���ر��� -->
 <input type=hidden name=hidcounty value="<%=hidcounty%>" size=10>
 <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="tt">
 <tr>
 <td colspan="2" align="left" ><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"><span style="font-size:10.8pt;color:#ff6622">�������ͻ�������ϯ��ѯ</span></td>
 <td align="left" ></td>
 <td align="left"></td>
 <td align="left" ></td>
 <td align="left" ></td>
 <td width="4%" align="left" ></td>
 <td width="19%" align="left" ><a href="javascript:help();" ><span class="style2">����</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=15% align="right" nowrap class="query_t" >&nbsp;ʱ ��</td>
 <td width=14% align="left" class="query_v" >
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
 <td width=13% align="right" nowrap class="query_t">&nbsp;�� ��</td>
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
 </select> </td>
 <td width=15% align="right" nowrap class="query_t"> &nbsp;�� ��</td>
 <td width=9% align="left" class="query_v">
 <iframe name="frmCounty" src="county_rn.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe> </td>
 <td colspan="2" align="left" class="query_v"><a href="javascript:help();" ></a></td>
 </tr>
 <tr>
 <td align="right" nowrap class="query_t">����ʱ��</td>
 <td align="left" class="query_v"><select name="his_before_onlinelev" id="his_before_onlinelev">
 <option value="P"<% if (his_before_onlinelev.equals("��ʾȫ��")) out.print("selected");%>>��ʾȫ��</OPTION>
 <%
 for(int m=1;m<=OnLineLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=OnLineLev.getFieldValue("onlinelev",m)%>" <%if(OnLineLev.getFieldValue("onlinelev",m).equals(his_before_onlinelev)) out.print("selected"); %>><%=OnLineLev.getFieldValue("level_name",m)%></OPTION>
 <%}%>
 </select></td>
 <td align="right" nowrap class="query_t">�ͻ�����־</td>
 <td align="left" class="query_v"><select name="life_flag" id="life_flag">
 <option value="X"<% if (life_flag.equals("X")) out.print("selected");%>>ȫ��</OPTION>
 <option value="0"<% if (life_flag.equals("0")) out.print("selected");%>>��</OPTION>
 <option value="1"<% if (life_flag.equals("1")) out.print("selected");%>>��</OPTION>
 </select></td>
 <td align="right" nowrap class="query_t">������־</td>
 <td colspan="3" align="left" class="query_v"><select name="change_flag" id="change_flag">
 <option value="X"<% if (change_flag.equals("X")) out.print("selected");%>>ȫ��</OPTION>
 <option value="0"<% if (change_flag.equals("0")) out.print("selected");%>>��</OPTION>
 <option value="1"<% if (change_flag.equals("1")) out.print("selected");%>>��</OPTION>
 </select> </td>
 </tr>
 <tr>
 <td align="right" nowrap class="query_t">��ǰƷ��</td>
 <td align="left" class="query_v"><select name="curbrand" id="curbrand">
 <option value="0"<% if (curbrand.equals("0")) out.print("selected");%>>��ʾȫ��Ʒ��</OPTION>
 <%
 for(int m=1;m<=brandInit.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=brandInit.getFieldValue("db_tid",m)%>" <%if(brandInit.getFieldValue("db_tid",m).equals(curbrand)) out.print("selected"); %>><%=brandInit.getFieldValue("db_tname",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 <option value="11" <%if(curbrand.equals("11")) out.print("selected"); %>>��׼������</OPTION>
 </select></td>
 <td align="right" nowrap class="query_t">��ǰ���Ѳ��</td>
 <td align="left" class="query_v"><select name="now_consumelev" id="now_consumelev">
 <option value="P"<% if (now_consumelev.equals("��ʾȫ��")) out.print("selected");%>>��ʾȫ��</OPTION>
 <%
 for(int m=1;m<=ConsumeLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=ConsumeLev.getFieldValue("consumelev",m)%>" <%if(ConsumeLev.getFieldValue("consumelev",m).equals(now_consumelev)) out.print("selected"); %>><%=ConsumeLev.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 <td colspan="4" align="left" class="query_v">&nbsp; </td>
 </tr>
 <tr>
 <td align="right" nowrap class="query_t"> ��ʷƷ��</td>
 <td align="left" class="query_v"><select name="hisbrand" id="hisbrand">
 <option value="0"<% if (hisbrand.equals("0")) out.print("selected");%>>��ʾȫ��Ʒ��</OPTION>
 <%
 for(int m=1;m<=brandInit.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=brandInit.getFieldValue("db_tid",m)%>" <%if(brandInit.getFieldValue("db_tid",m).equals(hisbrand)) out.print("selected"); %>><%=brandInit.getFieldValue("db_tname",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 <option value="11" <%if(hisbrand.equals("11")) out.print("selected"); %>>��׼������</OPTION>
 </select></td>
 <td align="right" nowrap class="query_t">��ʷ���Ѳ��</td>
 <td align="left" class="query_v"><select name="his_consumelev" id="his_consumelev">
 <option value="P"<% if (his_consumelev.equals("��ʾȫ��")) out.print("selected");%>>��ʾȫ��</OPTION>
 <%
 for(int m=1;m<=ConsumeLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=ConsumeLev.getFieldValue("consumelev",m)%>" <%if(ConsumeLev.getFieldValue("consumelev",m).equals(his_consumelev)) out.print("selected"); %>><%=ConsumeLev.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 <td colspan="4" align="center" class="query_v"><input type="button" name="confirm" value="��ѯ��OK��" onClick="tosubmit()" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <input type="button" name="Submit2" value="��������" onClick="todown()" /></td>
 </tr>
 </table>
 <br>
	<table id="resultTable" width="180%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
   <THEAD id="resultHead"> 
 <tr class="result_t">
 <td width=1% rowspan="3" align="center" style="display:none">����</td> 
 <td align="center" width=4%>ʱ��</td>
 <td align="center" width=4%>������<br>����</td>
 <td align="center" width=4%>��ʷ<br>����</td>
 <td align="center" width=5%>��ǰƷ��</td>
 <td align="center" width=4%>��ʷƷ��</td>
 <td align="center" width=5%>��ǰ��<br>�Ѳ��</td>
 <td align="center" width=5%>��ʷ��<br>�Ѳ��</td>
 <td align="center" width=5%>��ǰ��<br>������</td>
 <td align="center" width=5%>��ǰ��<br>������</td>
 <td align="center" width=4%>��ʷ��<br>������</td>
 <td align="center" width=6%>��ʷ��<br>������</td>
 <td align="center" width=5%>��ʷ��<br>��ʱ��</td>
 <td align="center" width=5%>��ʷ��<br>���־</td>
 <td align="center" width=4%>������־</td>
 <td align="center" width=4%>��ǰ��<br>�ʹ���</td>
 <td align="center" width=5%>��ʷ��<br>�ʹ���</td>
 <td align="center" id=17 width=3%><A class="a2" onClick="changeText(17); return sortTable('resultTbody', 17, true,0);" href="#" title="��Ƿ�ѽ�������">��ʷǷ<br>�ѽ��</a></td>
 <td align="center" width=5%>��ʷƽ��ÿ<br>�³�ֵ���</td>
 <td align="center" width=5%>��ʷƽ��ÿ<br>�³�ֵ����</td>
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
 <td align="left" nowrap ><%=starttime%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("RN_USER_NUMBER",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_USER_NUMBER",i)%></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("RN_BASE_BRAND_ID",i))%></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("HIS_BEFORE_BRAND_ID",i))%></td>
 <td align="left" nowrap ><%=cptool.getXiaoFei(Divpage.getFieldValue("rn_next_consumelev",i))%></td>
 <td align="left" nowrap ><%=cptool.getXiaoFei(Divpage.getFieldValue("HIS_BEFORE_CONSUMELEV",i))%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("RN_BASE_ORG_ID",i).equals("-1")?"����":Divpage.getFieldValue("RN_BASE_ORG_ID",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_base_dept_code",i)%></td>
 <td align="left" nowrap >����</td>
 <td align="left" nowrap >����</td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("his_create_date",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_NEXT_LIFE_FLAG",i).equals("1")?"��":"��"%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("CHANGE_PHONE_FLAG",i).equals("1")?"��":"��"%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_base_plan_id",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_BEFORE_PLAN_ID",i)%></td>
 <td width="2%" align="right" ><%=mp.round(Divpage.getFieldValue("HIS_BASE_UNPAY_FEE",i),2)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("HIS_BASE_AVG_PAYED_MONEY",i),2)%></td>
 <td align="right" ><%=mp.round(Divpage.getFieldValue("HIS_BASE_AVG_PAYED_COUNT",i),0)%></td>	
 </tr>
 <%
 }
 %> 
     </TBODY>
 </table>
<!-- ��ҳ����ҳ�� ���� -->
 <%@ include file="/hbbass/common/common_page.jsp"%> 
</form>
</body>
</html>
