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
var userwindow=window.open('rej_oldcustlist_help.jsp?' , "SelectUserWindow", "height=260, width=380, left=640, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
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
	document.form1.action = "rej_oldcustlist.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function todown()
{
	document.form1.action = "rej_oldcustlist_down.jsp";
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
int area_id = Integer.parseInt((String)session.getAttribute("area_id"));


// ʱ��ѡ�����������ݿ�Ŀ���ȡ��
DevidePageBean timeInit=new DevidePageBean();
timeInit.setQuerySQL("Select distinct replace(substr(char(rn_date),1,7),'-','') timeid from NMK.DMRN_ARREAR_USER_MS order by timeid desc fetch first 12 row only ");
String defaulttime="200602"; // ����ȱʡ��ʱ��Ϊ���ݿ�������ʱ�䣬������ݿ�ȡ����ֵ����Ϊ200602
if(timeInit.getAllRowCount()>0)
 defaulttime=timeInit.getFieldValue("timeid",1);

String starttime=request.getParameter("starttime")==null?defaulttime:request.getParameter("starttime");
String endtime=request.getParameter("endtime")==null?defaulttime:request.getParameter("endtime");
String city=request.getParameter("city")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("city");
String hidcounty=request.getParameter("hidcounty")==null?"0":request.getParameter("hidcounty");
String curbrand=request.getParameter("curbrand")==null?"0":request.getParameter("curbrand");
String hisbrand=request.getParameter("hisbrand")==null?"0":request.getParameter("hisbrand");
String unpay_level=request.getParameter("unpay_level")==null?"P":request.getParameter("unpay_level");
String flea_flag=request.getParameter("flea_flag")==null?"X":request.getParameter("flea_flag");
String change_flag=request.getParameter("change_flag")==null?"X":request.getParameter("change_flag");
String same_flag=request.getParameter("same_flag")==null?"X":request.getParameter("same_flag");


String order=request.getParameter("order")==null?"UNPAY_FEE":request.getParameter("order");
String querysql="";

//Ʒ�� 
DevidePageBean brandInit=new DevidePageBean();
brandInit.setQuerySQL("Select distinct db_tid,case when db_tid=2 then '���ű�׼�ʷ��ײ�' else db_tname end as db_tname from NWH.DIM_BRAND ORDER BY db_tid");

//Ƿ�Ѳ��
DevidePageBean UnPayLev=new DevidePageBean();
UnPayLev.setQuerySQL("select unpay_level,level_name from NMK.DMRN_DIM_UNPAY_LEVEL order by unpay_level");


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
querysql =		"select a.RN_DATE,a.REGION_CODE,a.COUNTY_CODE,a.BRAND_ID,a.HIS_BRAND_ID,LEVEL_NAME,a.FLEA_FLAG,"+
 "a.CARD_CODE_SAME_FLAG,a.CHANGE_PHONE_FLAG,a.rN_USER_NUMBER,a.HIS_USER_NUMBER,a.UNPAY_FEE,c.RN_BASE_ORG_ID,c.rn_base_dept_code "+
				" from NMK.DMRN_ARREAR_USER_MS a,NMK.DMRN_DIM_UNPAY_LEVEL b,nmk.DMRN_USER_MS c where a.UNPAY_LEVEL=b.UNPAY_LEVEL and a.rn_user_id=c.rn_user_id and "+
				" replace(substr(char(a.rn_date),1,7),'-','')>='"+starttime+
				"' and replace(substr(char(a.rn_date),1,7),'-','')<='"+endtime+"' ";

if((!city.equals("1"))&&(!city.equals("0")))
{
 if((!hidcounty.equals("1"))&&(!hidcounty.equals("0")))
 {
 querysql=querysql+" and a.REGION_CODE ='"+city.substring(3,5)+"' and a.COUNTY_CODE='"+hidcounty.substring(6,8)+"'";
 }
 else
 	{
 querysql=querysql+" and a.REGION_CODE ='"+city.substring(3,5)+"'";
 }
}
if((!curbrand.equals("0"))&&(!curbrand.equals("X")))
{
 querysql=querysql+" and a.BRAND_ID = "+curbrand;
}
if((!hisbrand.equals("0"))&&(!hisbrand.equals("X")))
{
 querysql=querysql+" and a.HIS_BRAND_ID = "+hisbrand;
}

if((!unpay_level.equals("P"))&&(!unpay_level.equals("X")))
{
 querysql=querysql+" and a.UNPAY_LEVEL= "+unpay_level;
}
if(!flea_flag.equals("X"))
{
 querysql=querysql+" and a.FLEA_FLAG= "+flea_flag;
}
if(!change_flag.equals("X"))
{
 querysql=querysql+" and a.CHANGE_PHONE_FLAG= "+change_flag;
}
if(!same_flag.equals("X"))
{
 querysql=querysql+" and a.CARD_CODE_SAME_FLAG= "+same_flag;
}
querysql+=" order by a.UNPAY_FEE desc,a.rn_date with ur";
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
 <td colspan="2" align="left" ><img src="/hbbass/images/kpihead_icon.gif" width="12" height="13" hspace="5"><span style="font-size:10.8pt;color:#ff6622">Ƿ��������ϯ��ѯ</span></td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" >&nbsp;</td>
 <td align="center" ><a href="javascript:help();" ><span class="style2">����</span><img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
 </tr>
 <tr>
 <td width=14% align="right" class="query_t">��ʼʱ��</td>
 <td width=9% align="left" class="query_v">
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
 <td width=10% align="right" class="query_t">����</td>
 <td width=13% align="left" class="query_v">
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
 <td width=10% align="right" class="query_t">��ǰƷ��</td>
 <td width=10% align="left" class="query_v"><select name="curbrand" id="curbrand">
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
 <td width=12% align="right" nowrap class="query_t">Ƿ�Ѳ��</td>
 <td width=22% align="left" class="query_v"><select name="unpay_level" id="unpay_level">
 <option value="P"<% if (unpay_level.equals("��ʾȫ��")) out.print("selected");%>>��ʾȫ��</OPTION>
 <%
 for(int m=1;m<=UnPayLev.getAllRowCount();m++)
		 					{
			 			%>
 <option value="<%=UnPayLev.getFieldValue("unpay_level",m)%>" <%if(UnPayLev.getFieldValue("unpay_level",m).equals(unpay_level)) out.print("selected"); %>><%=UnPayLev.getFieldValue("level_name",m)%></OPTION>
 <% 
		 						 }
		 	
 				%>
 </select></td>
 </tr>
 <tr>
 <td align="right" class="query_t">����ʱ��</td>
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
 <td align="right" class="query_t">����</td>
 <td align="left" class="query_v"><iframe name="frmCounty" src="county_rn.jsp?city_id=<%=city%>&county_id=<%=hidcounty%>" height="20" width="120" frameborder="0" scrolling="no"></iframe></td>
 <td align="right" class="query_t">��ʷƷ��</td>
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
 <td align="right" nowrap class="query_t">��֤ͬ������</td>
 <td align="left" class="query_v"><select name="same_flag" id="same_flag">
 <option value="X"<% if (same_flag.equals("X")) out.print("selected");%>>ȫ��</OPTION>
 <option value="0"<% if (same_flag.equals("0")) out.print("selected");%>>��</OPTION>
 <option value="1"<% if (same_flag.equals("1")) out.print("selected");%>>��</OPTION>
 </select></td>
 </tr>
 <tr>
 <td align="right" class="query_t">�����������־</td>
 <td align="left" class="query_v"><select name="flea_flag" id="flea_flag">
 <option value="X"<% if (flea_flag.equals("X")) out.print("selected");%>>ȫ��</OPTION>
 <option value="0"<% if (flea_flag.equals("0")) out.print("selected");%>>��</OPTION>
 <option value="1"<% if (flea_flag.equals("1")) out.print("selected");%>>��</OPTION>
 </select></td>
 <td align="right" class="query_t">������־</td>
 <td align="left" class="query_v"><select name="change_flag" id="change_flag">
 <option value="X"<% if (change_flag.equals("X")) out.print("selected");%>>ȫ��</OPTION>
 <option value="0"<% if (change_flag.equals("0")) out.print("selected");%>>��</OPTION>
 <option value="1"<% if (change_flag.equals("1")) out.print("selected");%>>��</OPTION>
 </select></td>
 <td colspan="4" align="center" class="query_v">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <input type="button" name="confirm" value="��ѯ��OK��" onClick="tosubmit()" />
&nbsp;&nbsp;&nbsp;&nbsp;
 <input type="button" name="Submit2" value="��������" onClick="todown()" /></td>
 </tr>
 </table>
 <br>
	<table  id="resultTable" width="130%" border="1" cellspacing="0" cellpadding="1" bordercolorlight="#000000" bordercolordark="#e7e7e7">
  <THEAD id="resultHead">   
 <tr class="result_t"> 
  <td width=5% rowspan="3" align="center" style="display:none">����</td>  
 <td align="center" width=70>����</td>
 <td align="center" width=60>��������</td>
 <td align="center" width=110>��������</td>
 <td width=60 align="center" nowrap>��ǰƷ��</td>
 <td width=60 align="center" nowrap>��ʷƷ��</td>
 <td width=60 align="center" nowrap>Ƿ�Ѳ��</td>
 <td width=60 align="center" nowrap>�������<br>����־</td>
 <td width=60 align="center" nowrap>���֤����<br>�Ƿ���ͬ</td>
 <td width=60 align="center" nowrap>����<br>��־</td>
 <td width=60 align="center" nowrap>����������</td>
 <td width=60 align="center" nowrap>��ʷ����</td>
 <td width=60 align="center" nowrap id=12><A class="a2" onclick="changeText(12); return sortTable('resultTbody', 12, true,0);" href="#" title="��Ƿ�ѽ�������">Ƿ�ѽ��</a></td>
 <td width=60 align="center">��ǰ��<br>������</td>
 <td width=60 align="center">��ǰ��<br>������</td>
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
 <td align="left" ><%=city.equals("1")?"ȫ��":cptool.getNewAreaName("HB."+Divpage.getFieldValue("REGION_CODE",i).trim())%></td>
 <td align="left" ><%
 if (hidcounty.equals("1")||city.equals("1"))
 {
		out.print("ȫ��");
	}
 else 
 {
 	 if ((Divpage.getFieldValue("BRAND_ID",i).trim().equals("11"))||(Divpage.getFieldValue("HIS_BRAND_ID",i).trim().equals("11")))
	 {
		out.print("����");
	 }
	 else
	 {
	 	out.print(cptool.getNewAreaName("HB."+Divpage.getFieldValue("REGION_CODE",i).trim()+"."+Divpage.getFieldValue("COUNTY_CODE",i)));
	 }
	 }
 %></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("BRAND_ID",i).trim())%></td>
 <td align="left" nowrap ><%=cptool.getBrandNname(Divpage.getFieldValue("HIS_BRAND_ID",i).trim())%></td>
 
 <td align="left" nowrap ><%=Divpage.getFieldValue("LEVEL_NAME",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("FLEA_FLAG",i).equals("0")?"��":"��"%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("CARD_CODE_SAME_FLAG",i).equals("0")?"��":"��"%></td>	
 <td align="left" nowrap ><%=Divpage.getFieldValue("CHANGE_PHONE_FLAG",i).equals("0")?"��":"��"%></td>	
 <td align="left" nowrap ><%=Divpage.getFieldValue("RN_USER_NUMBER",i)%></td>	
 <td align="left" nowrap ><%=Divpage.getFieldValue("HIS_USER_NUMBER",i)%></td>	
 <td align="right" nowrap >&nbsp;<%=mp.round(Divpage.getFieldValue("UNPAY_FEE",i),2)%>Ԫ</td>	
  <td align="left" nowrap ><%=Divpage.getFieldValue("RN_BASE_ORG_ID",i).equals("-1")?"����":Divpage.getFieldValue("RN_BASE_ORG_ID",i)%></td>
 <td align="left" nowrap ><%=Divpage.getFieldValue("rn_base_dept_code",i)%></td>

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
