<!--
˵��:��ҳ�������ڼ��ſͻ�ģ��,��ģ����ص���:��ѯ�����Ϊ���ܺ������,����������ܴ�
     �����ط���ֻʹ����:
     1.��ѯ���С��ҳ����������ʱ,ֱ�Ӵ�ҳ����ȡ����;
     2.����ѯ�������ҳ����������ʱ,ʹ�ù��õ�commonDown.jsp�ļ�����,����Ϊ�����ļ�
  ����漰���嵥�ļ�����(���������>2����),��Ҫ�÷��ļ����صķ�������.
-->
<%@ page contentType="text/html; charset=gb2312"%>
<jsp:useBean id="QuertTools" scope="application" class="bass.common.QueryTools"/>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/>
<jsp:useBean id="mp" scope="session" class="bass.database.report.MapReportBean"/>
<jsp:useBean id="cptool" scope="session" class="bass.database.compete.CompetePool" />
<%@ page import = "bass.common.DevidePageBean"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ include file="/hbbass/common/queryload.html"%>
<HTML xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<HEAD>
<TITLE>�����ƶ���Ӫ����ϵͳ</TITLE>
<script type="text/javascript" src="/hbbass/js/hbcommon.js"></SCRIPT>
<script type="text/javascript" src="/hbbass/js/tablesort.js"></script>
<script type="text/javascript" src="vpmnCalc.js"></script>
<script type="text/javascript" src="chart.js"></script>
<script type="text/javascript">
onit=true
num=0
function query()
{
	document.form1.action = "chargePreview.jsp";
	document.form1.target = "_self";
	document.form1.submit();
}
function help()
{          
	var userwindow=window.open('chargPreviewHelp.jsp' , "HelpWindow", "height=280, width=400, left=620, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
	userwindow.focus();
}
</script>
<style type="text/css">
<!--
v\:*         {behavior:url(#default#VML);}                                                                                                                                                                                                                                                                                                                                                                         
o\:*         { behavior: url(#default#VML) }                                                                                                                                                                                                                                                                                                                                                                       
.shape       { behavior: url(#default#VML) }
@import url("/hbbass/css/com.css");
#queryload {
	position:absolute;
	width:200px;
	height:41px;
	z-index:2;
	left: 318px;
	top: 200px;
	background-color: #00FFCC;
}
.input{
    FONT-FAMILY: Tahoma;
    font-size:8pt;
    height: 17px;
    padding-right:2px;
    text-align:right;
}
.scdiv {
	BORDER-RIGHT: windowframe 1px solid; BORDER-TOP: buttonface 1px solid; OVERFLOW-Y: auto; SCROLLBAR-FACE-COLOR: #ffffff; SCROLLBAR-HIGHLIGHT-COLOR: #ffffff; BORDER-LEFT: buttonface 1px solid; SCROLLBAR-SHADOW-COLOR: #006699; SCROLLBAR-3DLIGHT-COLOR: #006699; SCROLLBAR-ARROW-COLOR: #006699; SCROLLBAR-TRACK-COLOR: #ffffff; BORDER-BOTTOM: windowframe 1px solid; SCROLLBAR-DARKSHADOW-COLOR: #ffffff; SCROLLBAR-BASE-COLOR: #ffffff; HEIGHT: 50px; BACKGROUND-COLOR: #efffff
}
-->
</style>
<%--��ҳ jsp ��ʼ�������--%>
<%
response.setHeader("Cache-Control","no-store");

//���ݵ�¼����ѯ�û�����Ϣ ���û�����������
//int area_id = Integer.parseInt((String)session.getAttribute("area_id"));
int area_id=0;

String colname = "����";
/* ��ȡ������ʼ */
String arealevel=request.getParameter("arealevel")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("arealevel");
String arealevel1=request.getParameter("hidarealevel1")==null?"0":request.getParameter("hidarealevel1");

String starttime=request.getParameter("time_id")==null?"":request.getParameter("time_id");

String groupCode = request.getParameter("groupcode")==null?"":request.getParameter("groupcode");
String groupId = request.getParameter("groupid")==null?"":request.getParameter("groupid");

//�ʷѲ���ģʽ 1����ҵ�񵥼ۡ�ҵ��������������  2���������롢ҵ�������������
String model = request.getParameter("model")==null?"fee":request.getParameter("model");
//ҳ�����ʷѷ�����ť״ֵ̬
String buttonStatus = request.getParameter("buttonstatus")==null?"unclicked":request.getParameter("buttonstatus");

/* ��ȡ�������� */

String downlevel="";
/* ��ҳģ����뿪ʼ  ���´���һ�㲻Ҫ���޸� */
int perPage=15;   //����ÿҳ��ʾ����
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
/* ��ҳģ��������  */

/* ����ҵ����뿪ʼ ��װ�Լ���sql */

String querysql="";
String commonfield =  "";
if(!groupCode.equals(""))
{
	commonfield = " decimal(sum(value(sum_charge,0)/1000),16,0) as sum_charge,decimal(sum(value(dura1,0)/60),16,0) as dura1,decimal(sum(value(sum_dura,0)/60),16,0) as sum_dura,decimal(sum(value(ww_th_num,0)/1000),16,0) as ww_th_num,"+
	" decimal(sum(value(zj_charge,0)/1000),16,0) as zj_carge,decimal(sum(value(zj_dura,0)/60),16,0) as zj_dura,sum(value(zj_num,0)) as zj_num,"+
	" decimal(sum(value(bj_charge,0)/1000),16,0) as bj_charge,decimal(sum(value(bj_dura,0)/60),16,0) as bj_dura,sum(value(bj_num,0)) as bj_num,"+
	" decimal(sum(value(by_charge,0)/1000),16,0) as by_charge,decimal(sum(value(by_dura,0)/60),16,0) as by_dura,sum(value(by_num,0)) as by_num,"+
	" decimal(sum(value(local_zj_charge,0)/1000),16,0) as local_zj_charge,decimal(sum(value(local_zj_dura,0)/60),16,0) as local_zj_dura,sum(value(local_zj_num,0)) as local_zj_num,"+
	" decimal(sum(value(local_bj_charge,0)/1000),16,0) as local_bj_charge,decimal(sum(value(local_bj_dura,0)/60),16,0) as local_bj_dura,sum(value(local_bj_num,0)) as local_bj_num,"+
	" decimal(sum(value(roam_sn_zj_charge,0)/1000),16,0) as roam_sn_zj_charge,decimal(sum(value(roam_sn_zj_dura,0)/60),16,0) as roam_sn_zj_dura,sum(value(roam_sn_zj_num,0)) as roam_sn_zj_num,"+
	" decimal(sum(value(roam_sn_bj_charge,0)/1000),16,0) as roam_sn_bj_charge,decimal(sum(value(roam_sn_bj_dura,0)/60),16,0) as roam_sn_bj_dura,sum(value(roam_sn_bj_num,0)) as roam_sn_bj_num,"+
	" decimal(sum(value(roam_sj_zj_charge,0)/1000),16,0) as roam_sj_zj_charge,decimal(sum(value(roam_sj_zj_dura,0)/60),16,0) as roam_sj_zj_dura,sum(value(roam_sj_zj_num,0)) as roam_sj_zj_num,"+
    " decimal(sum(value(roam_sj_bj_charge,0)/1000),16,0) as roam_sj_bj_charge,decimal(sum(value(roam_sj_bj_dura,0)/60),16,0) as roam_sj_bj_dura,sum(value(roam_sj_bj_num,0)) as roam_sj_bj_num,"+
    " decimal(sum(value(long_bj_charge,0)/1000),16,0) as long_bj_charge,decimal(sum(value(long_bj_dura,0)/60),16,0) as long_bj_dura,sum(value(long_bj_num,0)) as long_bj_num,"+
    " decimal(sum(value(long_zj_charge,0)/1000),16,0) as long_zj_charge,decimal(sum(value(long_zj_dura,0)/60),16,0) as long_zj_dura,sum(value(long_zj_num,0)) as long_zj_num "+
    " from NMK.GROUP_VPMN_INFO_"+starttime+" where 1=1";
}
else
{
	commonfield = " decimal(sum(value(sum_charge,0)/1000),16,0) as sum_charge,decimal(sum(value(dura1,0)/60),16,0) as dura1,decimal(sum(value(sum_dura,0)/60),16,0) as sum_dura,decimal(sum(value(ww_th_num,0)/1000),16,0) as ww_th_num,"+
	" decimal(sum(value(zj_charge,0)/1000),16,0) as zj_charge,decimal(sum(value(zj_dura,0)/60),16,0) as zj_dura,sum(value(zj_num,0)) as zj_num,"+
	" decimal(sum(value(bj_charge,0)/1000),16,0) as bj_charge,decimal(sum(value(bj_dura,0)/60),16,0) as bj_dura,sum(value(bj_num,0)) as bj_num,"+
	" decimal(sum(value(by_charge,0)/1000),16,0) as by_charge,decimal(sum(value(by_dura,0)/60),16,0) as by_dura,sum(value(by_num,0)) as by_num,"+
	" decimal(sum(value(local_zj_charge,0)/1000),16,0) as local_zj_charge,decimal(sum(value(local_zj_dura,0)/60),16,0) as local_zj_dura,sum(value(local_zj_num,0)) as local_zj_num,"+
	" decimal(sum(value(local_bj_charge,0)/1000),16,0) as local_bj_charge,decimal(sum(value(local_bj_dura,0)/60),16,0) as local_bj_dura,sum(value(local_bj_num,0)) as local_bj_num,"+
	" decimal(sum(value(roam_sn_zj_charge,0)/1000),16,0) as roam_sn_zj_charge,decimal(sum(value(roam_sn_zj_dura,0)/60),16,0) as roam_sn_zj_dura,sum(value(roam_sn_zj_num,0)) as roam_sn_zj_num,"+
	" decimal(sum(value(roam_sn_bj_charge,0)/1000),16,0) as roam_sn_bj_charge,decimal(sum(value(roam_sn_bj_dura,0)/60),16,0) as roam_sn_bj_dura,sum(value(roam_sn_bj_num,0)) as roam_sn_bj_num,"+
	" decimal(sum(value(roam_sj_zj_charge,0)/1000),16,0) as roam_sj_zj_charge,decimal(sum(value(roam_sj_zj_dura,0)/60),16,0) as roam_sj_zj_dura,sum(value(roam_sj_zj_num,0)) as roam_sj_zj_num,"+
    " decimal(sum(value(roam_sj_bj_charge,0)/1000),16,0) as roam_sj_bj_charge,decimal(sum(value(roam_sj_bj_dura,0)/60),16,0) as roam_sj_bj_dura,sum(value(roam_sj_bj_num,0)) as roam_sj_bj_num,"+
    " decimal(sum(value(long_bj_charge,0)/1000),16,0) as long_bj_charge,decimal(sum(value(long_bj_dura,0)/60),16,0) as long_bj_dura,sum(value(long_bj_num,0)) as long_bj_num,"+
    " decimal(sum(value(long_zj_charge,0)/1000),16,0) as long_zj_charge,decimal(sum(value(long_zj_dura,0)/60),16,0) as long_zj_dura,sum(value(long_zj_num,0)) as long_zj_num "+
    " from NMK.GROUP_VPMN_INFO_"+starttime+" where 1=1";
}

StringBuffer commonwheresql=new StringBuffer();
//commonwheresql.append(" ");
String wheresql="";
String groupsql="";

/* ��װsql�� where ����
if(!groupabc.equals(""))
{
	commonwheresql.append(" and ='"+groupabc+"'");
}
*/
/* ��װ��ѯ�ֶ� */
if(!arealevel.equals("0") && groupCode.equals(""))
{
	downlevel="1";
	wheresql=" and area_id = '"+arealevel+"'";
	querysql="select ";
}
else
{
	querysql="select ";
}
if(!groupCode.equals(""))
{
	querysql = "select ";
	wheresql = " and vpmn_group_id = "+groupCode;
}
commonwheresql.append(wheresql);
querysql+=commonfield+commonwheresql.toString()+groupsql;

//out.println(querysql);
/* ����ҵ�������� ��װ�Լ���sql */

/*  �û����ν����ҳ��ʱ������ѯ,ֻ���û�����˲�ѯ��ť�������ѯ  ���´��벻Ҫ���޸�*/
if(request.getMethod().equals("POST"))
{
	buttonStatus = "clicked";
	Divpage.setQuerySQL(querysql);
}

%>
<body onload=onLoadScript() MS_POSITIONING="GridLayout">
<form name="form1" action="" method="POST">
  <input type=hidden name=model size=5 value="<%=model%>">
  <input type=hidden name=buttonstatus size=5 value="<%=buttonStatus%>">
  <input type=hidden name=sql size=5 value="<%=querysql%>">
<div class="dBoxHeaderLayout">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" onClick="hideTitle(document.all.IMG_TITLE,'searchCond','��ѯ��������')" class="dBoxHeaderArea">
		<tr title="չ��/����">
			<td class="main">��ѯ��������</td>
			<td class="misc" align="right"><img border="0" name="IMG_TITLE" ShowFlag=1 src="/hbbass/images/search_show.gif">
			</td>
		</tr>
	</table>
</div>
<table id="searchCond" width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse;display:block" bordercolor="#537EE7">
  	<tr><td>
      	<table class="bule" align="center" width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#FFFFFF">
	      	<tr height="23">
	      		<td width=10% bgcolor='#DCEBFC' align="right">ʱ��</td>
	      		<td width=15% bgcolor="#EFF5FB"><%=QuertTools.getDateYM("time_id",starttime)%></td>
	      		<td width=13% bgcolor='#DCEBFC' align="right">����</td>
	      		<td width=12% bgcolor="#EFF5FB">
	      		<select name="arealevel">
					  		<%
					            DevidePageBean cityInit=new DevidePageBean();
					            String citySQL="Select dm_city_id,cityname from FPF_user_city where parentid='-1'";
					        		if(area_id>0)
					        		citySQL=citySQL+" and cityid='"+area_id+"'";
					        		citySQL=citySQL+" order by cityid";
					        		cityInit.setQuerySQL(citySQL);
					        		for(int i=1;i<=cityInit.getAllRowCount();i++){

					        %>
					             <option value="<%=cityInit.getFieldValue("dm_city_id",i)%>" <%if(cityInit.getFieldValue("dm_city_id",i).equals(arealevel)) out.print("selected");%>><%=cityInit.getFieldValue("cityname",i)%></option>
					        <%}%>
				  </select>
	      		</td>
	      		<td align="right" bgcolor='#DCEBFC'>���ű��
            	<td bgcolor="#EFF5FB"><input name="groupcode" type="text" id="groupcode" size="16" maxlength="64" value="<%=groupCode%>"></td>
	      		<td bgcolor="#EFF5FB" colspan="2">&nbsp;</td>
      	  </tr>
      	  <tr height="23">
	      	  <td align="right" bgcolor='#DCEBFC'>ģ�����㷽ʽ��
              <td colspan="5" align="right" bgcolor='#EFF5FB'>
                <div align="left">
                  <input type="radio" name="radiobutton" value="radiobutton" <%if(!model.equals("incoming")) out.print("checked");%> onClick="getradiovalue('0')">
    ���ʷѵ��ۡ�ҵ����Ԥ��������
    <input type="radio" name="radiobutton" value="radiobutton" <%if(model.equals("incoming")) out.print("checked");%> onClick="getradiovalue('1')">
    �������롢ҵ����Ԥ���ʷѵ���</div>
   	      	    <td colspan="2" align="right" bgcolor='#EFF5FB'>&nbsp;</td>
      	  </tr>
      	  <tr height="23">
      	  <td align="right" colspan="8" ><input type="button" name="queryBtn" id="queryBtn" value="�ʷѷ���" onClick="query()">
      	  &nbsp;&nbsp;
      	  <!--<input type="button" name="defaultBtn" id="defaultBtn" value="�ָ��ɵ���ǰ��ֵ" onClick="setDefault()">-->
      	  &nbsp;&nbsp;</td>
      	  </tr>
	    </table>
		</td></tr>
 </table>
<br>
<%
/** �ʷѵ��۹�����
 *  long_zj_price = long_zj_charge/long_zj_dura
 *  long_bj_price = long_bj_charge/long_bj_dura
 *  local_zj_price = local_zj_charge/local_zj_dura
 *  roam_zj_price = (roam_sn_zj_charge+roam_sj_zj_charge)/roam_zj_dura
 *  roam_bj_price = (roam_sn_bj_charge+roam_sj_bj_charge)/roam_bj_dura
 *  by_price = by_charge/by_dura
 */
float long_zj_price = 0;      //��;���е���
float local_zj_price = 0;     //�������е���
float roam_zj_price =0;       //�������е���
float long_bj_price = 0;      //��;���е���
float roam_bj_price = 0;      //���α��е���
float by_price = 0;           //���·�
float sum_price = 0;          //ƽ������

float roam_zj_charge = 0;      //������������
float roam_bj_charge = 0;      //���α�������
float roam_zj_dura = 0;        //��������ʱ��
float roam_bj_dura = 0;        //���α���ʱ��
float sum_dura = 0;            //��ʱ��

float local_zj_price_num_charge = 0;    //��������ƽ������(���û�)
float long_zj_price_num_charge = 0;     //��;����ƽ������(���û�)
float long_bj_price_num_charge = 0;     //��;����ƽ������(���û�)
float roam_zj_price_num_charge = 0;     //��������ƽ������(���û�)
float roam_bj_price_num_charge = 0;     //���α���ƽ������(���û�)
float by_price_num_charge = 0;          //���µ���(���û�)

String sum_num = "0";             //���û���

String long_zj_charge = "0";     //��;��������
String long_zj_dura = "0";       //��;����ʱ��
String long_zj_num = "0";        //��;�����û���
String long_bj_charge = "0";     //��;��������
String long_bj_dura = "0";       //��;����ʱ��
String long_bj_num = "0";        //��;�����û���
String local_zj_charge = "0";    //������������
String local_zj_dura ="0";       //��������ʱ��
String local_zj_num = "0";       //���������û���
String roam_sn_zj_charge = "0";  //ʡ��������������
String roam_sn_zj_dura = "0";    //ʡ����������ʱ��
String roam_sn_bj_charge = "0";  //ʡ�����α�������
String roam_sn_bj_dura = "0";    //ʡ�����α���ʱ��
String roam_sj_zj_charge = "0";  //ʡ��������������
String roam_sj_zj_dura = "0";    //ʡ����������ʱ��
String roam_sj_bj_charge = "0";  //ʡ�����α�������
String roam_sj_bj_dura = "0";    //ʡ�����α���ʱ��
String roam_zj_num = "0";        //���������û���
String roam_bj_num = "0";        //���α����û���
String by_charge = "0";          //��������
String by_dura = "0";            //����ʱ��
String by_num = "0";             //�����û���
String sum_charge = "0";        //������

//System.out.println("/-------------Divpage.getRowNum() = " +Divpage.getRowNum());

if(Divpage.getRowNum() > 0)
{
	if(!groupCode.equals(""))
	{
		long_zj_charge = Divpage.getFieldValue("long_zj_charge",1);
		if(long_zj_charge.equals("")) long_zj_charge = "0";
		long_zj_dura = Divpage.getFieldValue("long_zj_dura",1);
		if(long_zj_dura.equals("")) long_zj_dura = "0";
		long_zj_num = Divpage.getFieldValue("long_zj_num",1);
		if(long_zj_num.equals("")) long_zj_num = "0";
		long_bj_charge = Divpage.getFieldValue("long_bj_charge",1);
		if(long_bj_charge.equals("")) long_bj_charge = "0";
		long_bj_dura = Divpage.getFieldValue("long_bj_dura",1);
		if(long_bj_dura.equals("")) long_bj_dura = "0";
		long_bj_num = Divpage.getFieldValue("long_bj_num",1);
		if(long_bj_num.equals("")) long_bj_num = "0";
		local_zj_charge = Divpage.getFieldValue("local_zj_charge",1);
		if(local_zj_charge.equals("")) local_zj_charge = "0";
		local_zj_dura = Divpage.getFieldValue("local_zj_dura",1);
		if(local_zj_dura.equals("")) local_zj_dura = "0";
		local_zj_num = Divpage.getFieldValue("local_zj_num",1);
		if(local_zj_num.equals("")) local_zj_num = "0";
		roam_sn_zj_charge = Divpage.getFieldValue("roam_sn_zj_charge",1);
		if(roam_sn_zj_charge.equals("")) roam_sn_zj_charge = "0";
		roam_sn_zj_dura = Divpage.getFieldValue("roam_sn_zj_dura",1);
		if(roam_sn_zj_dura.equals("")) roam_sn_zj_dura = "0";
		roam_sn_bj_charge = Divpage.getFieldValue("roam_sn_bj_charge",1);
		if(roam_sn_bj_charge.equals("")) roam_sn_bj_charge = "0";
		roam_sn_bj_dura = Divpage.getFieldValue("roam_sn_bj_dura",1);
		if(roam_sn_bj_dura.equals("")) roam_sn_bj_dura = "0";
		roam_sj_zj_charge = Divpage.getFieldValue("roam_sj_zj_charge",1);
		if(roam_sj_zj_charge.equals("")) roam_sj_zj_charge = "0";
		roam_sj_zj_dura = Divpage.getFieldValue("roam_sj_zj_dura",1);
		if(roam_sj_zj_dura.equals("")) roam_sj_zj_dura = "0";
		roam_sj_bj_charge = Divpage.getFieldValue("roam_sj_bj_charge",1);
		if(roam_sj_bj_charge.equals("")) roam_sj_bj_charge = "0";
		roam_sj_bj_dura = Divpage.getFieldValue("roam_sj_bj_dura",1);
		if(roam_sj_bj_dura.equals("")) roam_sj_bj_dura = "0";
		roam_zj_num = Divpage.getFieldValue("roam_zj_num",1);
		if(roam_zj_num.equals("")) roam_zj_num = "0";
		roam_bj_num = Divpage.getFieldValue("roam_bj_num",1);
		if(roam_bj_num.equals("")) roam_bj_num = "0";
		sum_charge = Divpage.getFieldValue("sum_charge",1);
		if(sum_charge.equals("")) sum_charge = "0";
		by_charge = Divpage.getFieldValue("by_charge",1);
		if(by_charge.equals("")) by_charge = "0";
		by_dura = Divpage.getFieldValue("by_dura",1);
		if(by_dura.equals("")) by_dura = "0";
		by_num = Divpage.getFieldValue("by_num",1);
	}
	else
	{
		long_zj_charge = Divpage.getFieldValue("long_zj_charge",1);
		if(long_zj_charge.equals("")) long_zj_charge = "0";
		long_zj_dura = Divpage.getFieldValue("long_zj_dura",1);
		if(long_zj_dura.equals("")) long_zj_dura = "0";
		long_zj_num = Divpage.getFieldValue("long_zj_num",1);
		if(long_zj_num.equals("")) long_zj_num = "0";
		long_bj_charge = Divpage.getFieldValue("long_bj_charge",1);
		if(long_bj_charge.equals("")) long_bj_charge = "0";
		long_bj_dura = Divpage.getFieldValue("long_bj_dura",1);
		if(long_bj_dura.equals("")) long_bj_dura = "0";
		long_bj_num = Divpage.getFieldValue("long_bj_num",1);
		if(long_bj_num.equals("")) long_bj_num = "0";
		local_zj_charge = Divpage.getFieldValue("local_zj_charge",1);
		if(local_zj_charge.equals("")) local_zj_charge = "0";
		local_zj_dura = Divpage.getFieldValue("local_zj_dura",1);
		if(local_zj_dura.equals("")) local_zj_dura = "0";
		local_zj_num = Divpage.getFieldValue("local_zj_num",1);
		if(local_zj_num.equals("")) local_zj_num = "0";
		roam_sn_zj_charge = Divpage.getFieldValue("roam_sn_zj_charge",1);
		if(roam_sn_zj_charge.equals("")) roam_sn_zj_charge = "0";
		roam_sn_zj_dura = Divpage.getFieldValue("roam_sn_zj_dura",1);
		if(roam_sn_zj_dura.equals("")) roam_sn_zj_dura = "0";
		roam_sn_bj_charge = Divpage.getFieldValue("roam_sn_bj_charge",1);
		if(roam_sn_bj_charge.equals("")) roam_sn_bj_charge = "0";
		roam_sn_bj_dura = Divpage.getFieldValue("roam_sn_bj_dura",1);
		if(roam_sn_bj_dura.equals("")) roam_sn_bj_dura = "0";
		roam_sj_zj_charge = Divpage.getFieldValue("roam_sj_zj_charge",1);
		if(roam_sj_zj_charge.equals("")) roam_sj_zj_charge = "0";
		roam_sj_zj_dura = Divpage.getFieldValue("roam_sj_zj_dura",1);
		if(roam_sj_zj_dura.equals("")) roam_sj_zj_dura = "0";
		roam_sj_bj_charge = Divpage.getFieldValue("roam_sj_bj_charge",1);
		if(roam_sj_bj_charge.equals("")) roam_sj_bj_charge = "0";
		roam_sj_bj_dura = Divpage.getFieldValue("roam_sj_bj_dura",1);
		if(roam_sj_bj_dura.equals("")) roam_sj_bj_dura = "0";
		roam_zj_num = Divpage.getFieldValue("roam_zj_num",1);
		if(roam_zj_num.equals("")) roam_zj_num = "0";
		roam_bj_num = Divpage.getFieldValue("roam_bj_num",1);
		if(roam_bj_num.equals("")) roam_bj_num = "0";
		sum_charge = Divpage.getFieldValue("sum_charge",1);
		if(sum_charge.equals("")) sum_charge = "0";
		by_charge = Divpage.getFieldValue("by_charge",1);
		if(by_charge.equals("")) by_charge = "0";
		by_dura = Divpage.getFieldValue("by_dura",1);
		if(by_dura.equals("")) by_dura = "0";
		by_num = Divpage.getFieldValue("by_num",1);
	}

	long_zj_price = (Float.parseFloat(long_zj_charge))/(Float.parseFloat(long_zj_dura));
	long_zj_price_num_charge = (Float.parseFloat(long_zj_charge))/(Float.parseFloat(long_zj_num));
	
	local_zj_price = (Float.parseFloat(local_zj_charge))/(Float.parseFloat(local_zj_dura));
	local_zj_price_num_charge = (Float.parseFloat(local_zj_charge))/(Float.parseFloat(local_zj_num));
	
	roam_zj_charge = Float.parseFloat(roam_sn_zj_charge)+Float.parseFloat(roam_sj_zj_charge);
	roam_zj_dura = Float.parseFloat(roam_sn_zj_dura)+Float.parseFloat(roam_sj_zj_dura);
	if(roam_zj_dura == 0) roam_zj_dura = 1;
	roam_zj_price = roam_zj_charge/roam_zj_dura;
	if(roam_zj_num.equals("0"))
	{
		roam_zj_price_num_charge = roam_zj_charge/1;
	}
	else
	{
		roam_zj_price_num_charge = roam_zj_charge/Float.parseFloat(roam_zj_num);
	}
	roam_bj_charge = Float.parseFloat(roam_sn_bj_charge)+Float.parseFloat(roam_sj_bj_charge);
	roam_bj_dura = Float.parseFloat(roam_sn_bj_dura)+Float.parseFloat(roam_sj_bj_dura);
	roam_bj_price = roam_bj_charge/roam_bj_dura;
	if(roam_bj_num.equals("0"))
	{
		roam_bj_price_num_charge = roam_bj_charge/1;
	}
	else
	{
		roam_bj_price_num_charge = roam_bj_charge/Float.parseFloat(roam_bj_num);
	}
	if(long_bj_dura.equals("0") || long_bj_num.equals("0")) long_bj_dura = "1";
	long_bj_price = Float.parseFloat(long_bj_charge)/Float.parseFloat(long_bj_dura);
	long_bj_price_num_charge = Float.parseFloat(long_bj_charge)/Float.parseFloat(long_bj_num);
	
	if(by_num.equals("") || by_num.equals("0")) 
	{
		by_price = 0;
	}
	else by_price = (Float.parseFloat(by_charge))/(Float.parseFloat(by_num));
	sum_dura = Float.parseFloat(long_zj_dura)+Float.parseFloat(local_zj_dura)+roam_zj_dura+roam_bj_dura+Float.parseFloat(long_bj_dura)+Float.parseFloat(by_dura);
	sum_num = Divpage.getFieldValue("wn_th_num",1);
	if(sum_num.equals("")) sum_num = "0";
	//sum_num = Float.parseFloat(long_zj_num)+Float.parseFloat(local_zj_num)+Float.parseFloat(roam_zj_num)+Float.parseFloat(roam_bj_num)+Float.parseFloat(long_bj_num)+Float.parseFloat(by_num);
	sum_charge = new Float(Float.parseFloat(long_zj_charge)+Float.parseFloat(local_zj_charge)+roam_zj_charge+roam_bj_charge+Float.parseFloat(long_bj_charge)+Float.parseFloat(by_charge)).toString();
	if(sum_charge.equals("0") || sum_charge.equals("")) sum_charge = "0";
	sum_price = Float.parseFloat(sum_charge)/sum_dura;
}
%>
<table width="100%" border="0" >
  <tr>
  <td width = "80%" colspan="3"></td>
	<td width="20%" align="right">
       <!--<img src="/hbbass/images/new/col.gif"  style="cursor:hand" Alt = "������ʾ����" width=30 height=25 border="0" onclick="opennew()">-->
       <img src="/hbbass/images/new/excel.gif"  Alt = "����Ϊexcel" width=30 height=25 border="0" onclick="SaveAsExcel1('�ʷѲ���.csv')">
       <img src="/hbbass/images/new/help2.gif"  style="cursor:hand" Alt = "ҳ���������" width=30 height=25 border="0" onclick="help()">
    </td>
  </tr>
</table>
<div class="dBoxHeaderLayout">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" onClick="hideTitle(document.all.IMG_DATA,'resultTable','����չʾ����')" class="dBoxHeaderArea">
		<tr title="չ��/����">
			<td class="main">����չʾ����</td>
			<td class="misc" align="right"><img border="0" name="IMG_DATA" ShowFlag=1 src="/hbbass/images/search_show.gif">
			</td>
		</tr>
	</table>
</div>
<table id="resultTable" width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#537EE7">
 <THEAD id="resultHead">
 	<tr><td colspan="8">
      	 <table class="bule" align="center" width="100%" border="1" cellpadding="0" cellspacing="1" style="border-collapse: collapse" >
	      	<tr height="23">
	      	<!--
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">�ʷѵ���</div></td>
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">ҵ����</div></td>
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">�û���</div></td>
	      	  <td colspan="2" bgcolor="#EFF5FB"><div align="center">ҵ������</div></td>
	      	-->
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">�ʷѵ���(Ԫ/��)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">ҵ����(��)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">�û���(��)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td bgcolor="#EFF5FB"><div align="center">ҵ������(Ԫ)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	</tr>
	      	<tr height="23">
	      		<td bgcolor='#DCEBFC' align="right">�������е���</td>
	      		<td bgcolor="#EFF5FB"><textarea name="local_zj_price" cols="18" rows="1" class="input" id="local_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(local_zj_price).toString(),2)%></textarea></td>
	      		<td bgcolor='#DCEBFC' align="right">��������ʱ��</td>
      		    <td bgcolor="#EFF5FB"><textarea name="local_zj_dura" cols="18" rows="1" class="input" id="local_zj_dura" onscroll=scrolltextarea(this,0,999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=local_zj_dura%></textarea></td>
      		    <td align="right" bgcolor='#DCEBFC'>���������û���</td>
   		      <td bgcolor="#EFF5FB"><textarea name="local_zj_num" cols="18" rows="1" class="input" id="local_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=local_zj_num%></textarea></td>
      		    <td align="right" bgcolor='#DCEBFC'>������������</td>
   		      <td bgcolor="#EFF5FB"><textarea name="local_zj_charge" cols="18" rows="1" class="input" id="local_zj_charge" onscroll=scrolltextarea(this,0,999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=local_zj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      		<td width="11%" align="right" bgcolor='#DCEBFC'>��;���е���</td>
      			<td width="17%" bgcolor="#EFF5FB">
      			<textarea name="long_zj_price" cols="18" rows="1" class="input" id="long_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(long_zj_price).toString(),2)%></textarea>
   			  <!--<input type="text" name="currentcharge" size=20>--></td>
	      		<td width="11%" align="right" bgcolor='#DCEBFC'>��;����ʱ��</td>
      		    <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_dura" cols="18" rows="1" class="input" id="long_zj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=long_zj_dura%></textarea>
   		      <!--<input type="text" name="currentcharge" size=20>--></td>
   		        <td width="12%" align="right" bgcolor='#DCEBFC'>��;�����û���</td>
	          <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_num" cols="18" rows="1" class="input" id="long_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=long_zj_num%></textarea></td>
	            <td width="10%" align="right" bgcolor='#DCEBFC'>��;��������</td>
              <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_charge" cols="18" rows="1" class="input" id="long_zj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=long_zj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">��;���е���</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_price" cols="18" rows="1" class="input" id="long_bj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(long_bj_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">��;����ʱ��</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_dura" cols="18" rows="1" class="input" id="long_bj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=long_bj_dura%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>��;�����û���</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_num" cols="18" rows="1" class="input" id="long_bj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=long_bj_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>��;��������</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_charge" cols="18" rows="1" class="input" id="long_bj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=long_bj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      		<td bgcolor='#DCEBFC' align="right">�������е���</td>
	      		<td bgcolor="#EFF5FB"><textarea name="roam_zj_price" cols="18" rows="1" class="input" id="roam_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(roam_zj_price).toString(),2)%></textarea></td>
	      		<td bgcolor='#DCEBFC' align="right">��������ʱ��</td>
	      		<td bgcolor="#EFF5FB"><textarea name="roam_zj_dura" cols="18" rows="1" class="input" id="roam_zj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(roam_zj_dura).toString(),0)%></textarea></td>
	      		<td align="right" bgcolor='#DCEBFC'>���������û���</td>
      		  <td bgcolor="#EFF5FB"><textarea name="roam_zj_num" cols="18" rows="1" class="input" id="roam_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=roam_zj_num%></textarea></td>
	      		<td align="right" bgcolor='#DCEBFC'>������������</td>
      		  <td bgcolor="#EFF5FB"><textarea name="roam_zj_charge" cols="18" rows="1" class="input" id="roam_zj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=mp.round(new Float(roam_zj_charge).toString(),0)%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">���α��е���</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_price" cols="18" rows="1" class="input" id="roam_bj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(roam_bj_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">���α���ʱ��</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_dura" cols="18" rows="1" class="input" id="roam_bj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(roam_bj_dura).toString(),0)%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>���α����û���</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_num" cols="18" rows="1" class="input" id="roam_bj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=roam_bj_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>���α�������</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_charge" cols="18" rows="1" class="input" id="roam_bj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=mp.round(new Float(roam_bj_charge).toString(),0)%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">���·�</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_price" cols="18" rows="1" class="input" id="by_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(by_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">����ʱ��</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_dura" cols="18" rows="1" class="input" id="by_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=by_dura%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>�����û���</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_num" cols="18" rows="1" class="input" id="by_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=by_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>��������</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_charge" cols="18" rows="1" class="input" id="by_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=by_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC'><div align="right">ƽ������</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_price" cols="18" rows="1" class="input" id="sum_price" onscroll=scrolltextarea(this,0,9999999999,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(sum_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC'><div align="right">��ʱ��</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_dura" cols="18" rows="1" class="input" id="sum_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(sum_dura).toString(),0)%></textarea></td>
	      	  <td bgcolor="#DCEBFC"><div align="right">���û���</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_num" cols="18" rows="1" class="input" id="sum_num" onscroll=scrolltextarea(this,0,9999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=sum_num%></textarea></td>
	      	  <td bgcolor="#DCEBFC"><div align="right">V��������</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_charge" cols="18" rows="1" class="input" id="sum_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=mp.round(new Float(sum_charge).toString(),0)%></textarea></td>
	      	  </tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">&nbsp;</td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td bgcolor='#DCEBFC' align="right">&nbsp;</td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td bgcolor="#DCEBFC">&nbsp;</td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td bgcolor="#DCEBFC"></td>
	      	  <td bgcolor="#EFF5FB"></td>
	      	  </tr>
	      	  <tr height="23">
	      	  <td colspan="8" bgcolor="#EFF5FB"></td>
	      	  </tr>
			</table>
		</td></tr>
		<!--
 		<tr>
 		   <td>
 		   	<div id="divReturnList" class="scdiv">
				<table id="Table3" dataSrc="#xmldso" width="100%" border="0" bgColor="#ffffff">
				<thead>
					<tr class="head">
						<th align="middle"><font size=2>V�����������������</font></th>
						<th align="middle"><font size=2>V�����·���������</font></th>
						<th align="middle"><font size=2>���η���������</font></th>
						<th align="middle"><font size=2>��;����������</font></th>
						<th align="middle"><font size=2>����Ŀ���û���</font></th>
						<th align="middle"><font size=2>����������</font></th>
						<th align="middle"><font size=2>�������ܷ�</font></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td align="left"><span dataFld="Times"></span></td>
						<td align="left"><span dataFld="Year"></span></td>
						<td align="right"><span dataFld="RateSum"></span></td>
						<td align="right"><span dataFld="Corpus"></span></td>
						<td align="right"><span dataFld="CorpusRate"></span></td>
						<td align="right"><span dataFld="LeavCorpus"></span></td>
						<td align="right"><span dataFld="Incoming"></span></td>
					</tr>
				</tbody>
				</table>
			</div>
 		   </td>
	  </tr>
	  -->
 </THEAD>
</table>
<br>
<textarea name="downcontent"  cols="122" rows="12" style="display:none"></textarea>
<input type=hidden name=long_zj_price_old value="<%=mp.round(new Float(long_zj_price).toString(),2)%>">
<input type=hidden name=local_zj_price_old value="<%=mp.round(new Float(local_zj_price).toString(),2)%>">
<input type=hidden name=roam_zj_price_old value="<%=mp.round(new Float(roam_zj_price).toString(),2)%>">
<input type=hidden name=long_bj_price_old value="<%=mp.round(new Float(long_bj_price).toString(),2)%>">
<input type=hidden name=roam_bj_price_old value="<%=mp.round(new Float(roam_bj_price).toString(),2)%>">
<input type=hidden name=by_price_old value="<%=mp.round(new Float(by_price).toString(),2)%>">
<input type=hidden name=roam_zj_charge_old value="<%=mp.round(new Float(roam_zj_charge).toString(),0)%>">
<input type=hidden name=roam_bj_charge_old value="<%=mp.round(new Float(roam_bj_charge).toString(),0)%>">
<input type=hidden name=roam_zj_dura_old value="<%=mp.round(new Float(roam_zj_dura).toString(),0)%>">
<input type=hidden name=roam_bj_dura_old value="<%=mp.round(new Float(roam_bj_dura).toString(),0)%>">
<input type=hidden name=long_zj_charge_old value="<%=long_zj_charge%>">
<input type=hidden name=long_zj_dura_old value="<%=long_zj_dura%>">
<input type=hidden name=long_zj_num_old value="<%=long_zj_num%>">
<input type=hidden name=long_bj_charge_old value="<%=long_bj_charge%>">
<input type=hidden name=long_bj_dura_old value="<%=long_bj_dura%>">
<input type=hidden name=long_bj_num_old value="<%=long_bj_num%>">
<input type=hidden name=local_zj_charge_old value="<%=local_zj_charge%>">
<input type=hidden name=local_zj_dura_old value="<%=local_zj_dura%>">
<input type=hidden name=local_zj_num_old value="<%=local_zj_num%>">
<input type=hidden name=roam_sn_zj_charge_old value="<%=roam_sn_zj_charge%>">
<input type=hidden name=roam_sn_zj_dura_old value="<%=roam_sn_zj_dura%>">
<input type=hidden name=roam_sn_bj_charge_old value="<%=roam_sn_bj_charge%>">
<input type=hidden name=roam_sn_bj_dura_old value="<%=roam_sn_bj_dura%>">
<input type=hidden name=roam_sj_zj_charge_old value="<%=roam_sj_zj_charge%>">
<input type=hidden name=roam_sj_zj_dura_old value="<%=roam_sj_zj_dura%>">
<input type=hidden name=roam_sj_bj_charge_old value="<%=roam_sj_bj_charge%>">
<input type=hidden name=roam_sj_bj_dura_old value="<%=roam_sj_bj_dura%>">
<input type=hidden name=roam_zj_num_old value="<%=roam_zj_num%>">
<input type=hidden name=roam_bj_num_old value="<%=roam_bj_num%>">
<input type=hidden name=by_charge_old value="<%=by_charge%>">
<input type=hidden name=by_dura_old value="<%=by_dura%>">
<input type=hidden name=by_num_old value="<%=by_num%>">
<input type=hidden name=sum_price_old value="<%=mp.round(new Float(sum_price).toString(),2)%>">
<input type=hidden name=sum_dura_old value="<%=mp.round(new Float(sum_dura).toString(),0)%>">
<input type=hidden name=sum_num_old value="<%=sum_num%>">
<input type=hidden name=sum_charge_old value="<%=mp.round(new Float(sum_charge).toString(),0)%>">
<input type=hidden name=local_zj_price_num_charge value="<%=local_zj_price_num_charge%>">
<input type=hidden name=long_zj_price_num_charge value="<%=long_zj_price_num_charge%>">
<input type=hidden name=long_bj_price_num_charge value="<%=long_bj_price_num_charge%>">
<input type=hidden name=roam_zj_price_num_charge value="<%=roam_zj_price_num_charge%>">
<input type=hidden name=roam_bj_price_num_charge value="<%=roam_bj_price_num_charge%>">
<input type=hidden name=by_price_num_charge value="<%=by_price%>">
<table id="fromtab" width="100%" height="0" border="1" cellpadding="0" cellspacing="1" style="border-collapse: collapse;display:block">
  <tr>
     <td align="center">�ʷ�����</td>
     <td align="center">����</td>
     <td align="center">����<br>(������)</td>
     <td align="center">����<br>����(%)</td>
     <td align="center">ҵ����</td>
     <td align="center">ҵ����<br>(������)</td>
     <td align="center">����<br>����(%)</td>
     <td align="center">�û���</td>
     <td align="center">�û���<br>(������)</td>
     <td align="center">����<br>����(%)</td>
     <td align="center">ҵ������</td>     
     <td align="center">ҵ������<br>(������)</td>
     <td align="center">����<br>����(%)</td>
  </tr>
  <tr>
     <td>��������</td>
     <td align="right"><%=mp.round(new Float(local_zj_price).toString(),2)%></td>
     <td align="right" id="local_zj_price_changed"></td>
     <td align="right" id="local_zj_price_range"></td>
     <td align="right"><%=local_zj_dura%></td>
     <td align="right" id="local_zj_dura_changed"></td>
     <td align="right" id="local_zj_dura_range"></td>
     <td align="right"><%=local_zj_num%></td>
     <td align="right" id="local_zj_num_changed"></td>
     <td align="right" id="local_zj_num_range"></td>
     <td align="right"><%=local_zj_charge%></td>     
     <td align="right" id="local_zj_charge_changed"></td>
     <td align="right" id="local_zj_charge_range"></td>
  </tr>
  <tr>
     <td>��;����</td>
     <td align="right"><%=mp.round(new Float(long_zj_price).toString(),2)%></td>
     <td align="right" id="long_zj_price_changed"></td>
     <td align="right" id="long_zj_price_range"></td>
     <td align="right"><%=long_zj_dura%></td>
     <td align="right" id="long_zj_dura_changed"></td>
     <td align="right" id="long_zj_dura_range"></td>
     <td align="right"><%=long_zj_num%></td>
     <td align="right" id="long_zj_num_changed"></td>
     <td align="right" id="long_zj_num_range"></td>
     <td align="right"><%=long_zj_charge%></td>     
     <td align="right" id="long_zj_charge_changed"></td>
     <td align="right" id="long_zj_charge_range"></td>
  </tr>   
  <tr>
     <td>��;����</td>
     <td align="right"><%=mp.round(new Float(long_bj_price).toString(),2)%></td>
     <td align="right" id="long_bj_price_changed"></td>
     <td align="right" id="long_bj_price_range"></td>
     <td align="right"><%=long_bj_dura%></td>
     <td align="right" id="long_bj_dura_changed"></td>
     <td align="right" id="long_bj_dura_range"></td>
     <td align="right"><%=long_bj_num%></td>
     <td align="right" id="long_bj_num_changed"></td>
     <td align="right" id="long_bj_num_range"></td>
     <td align="right"><%=long_bj_charge%></td>
     <td align="right" id="long_bj_charge_changed"></td>
     <td align="right" id="long_bj_charge_range"></td>
  </tr>
  <tr>
     <td>��������</td>
     <td align="right"><%=mp.round(new Float(roam_zj_price).toString(),2)%></td>
     <td align="right" id="roam_zj_price_changed"></td>
     <td align="right" id="roam_zj_price_range"></td>
     <td align="right"><%=mp.round(new Float(roam_zj_dura).toString(),0)%></td>
     <td align="right" id="roam_zj_dura_changed"></td>
     <td align="right" id="roam_zj_dura_range"></td>
     <td align="right"><%=roam_zj_num%></td>
     <td align="right" id="roam_zj_num_changed"></td>
     <td align="right" id="roam_zj_num_range"></td>
     <td align="right"><%=mp.round(new Float(roam_zj_charge).toString(),0)%></td>
     <td align="right" id="roam_zj_charge_changed"></td>
     <td align="right" id="roam_zj_charge_range"></td>
  </tr>  
  <tr>
     <td>���α���</td>
     <td align="right"><%=mp.round(new Float(roam_bj_price).toString(),2)%></td>
     <td align="right" id="roam_bj_price_changed"></td>
     <td align="right" id="roam_bj_price_range"></td>
     <td align="right"><%=mp.round(new Float(roam_bj_dura).toString(),0)%></td>
     <td align="right" id="roam_bj_dura_changed"></td>
     <td align="right" id="roam_bj_dura_range"></td>
     <td align="right"><%=roam_bj_num%></td>
     <td align="right" id="roam_bj_num_changed"></td>
     <td align="right" id="roam_bj_num_range"></td>
     <td align="right"><%=mp.round(new Float(roam_bj_charge).toString(),0)%></td>
     <td align="right" id="roam_bj_charge_changed"></td>
     <td align="right" id="roam_bj_charge_range"></td>
  </tr>
  <tr>
     <td>����</td>
     <td align="right"><%=mp.round(new Float(by_price).toString(),2)%></td>
     <td align="right" id="by_price_changed"></td>
     <td align="right" id="by_price_range"></td>
     <td align="right"><%=by_dura%></td>
     <td align="right" id="by_dura_changed"></td>
     <td align="right" id="by_dura_range"></td>
     <td align="right"><%=by_num%></td>
     <td align="right" id="by_num_changed"></td>
     <td align="right" id="by_num_range"></td>
     <td align="right"><%=by_charge%></td>
     <td align="right" id="by_charge_changed"></td>
     <td align="right" id="by_charge_range"></td>
  </tr>
  <tr>
     <td >ͳ��</td>
     <td align="right"><%=mp.round(new Float(sum_price).toString(),2)%></td>
     <td align="right" id="sum_price_changed"></td>
     <td align="right" id="sum_price_range"></td>
     <td align="right"><%=mp.round(new Float(sum_dura).toString(),0)%></td>
     <td align="right" id="sum_dura_changed"></td>
     <td align="right" id="sum_dura_range"></td>
     <td align="right"><%=sum_num%></td>
     <td align="right" id="sum_num_changed"></td>
     <td align="right" id="sum_num_range"></td>
     <td align="right"><%=mp.round(new Float(sum_charge).toString(),0)%></td>
     <td align="right" id="sum_charge_changed"></td>
     <td align="right" id="sum_charge_range"></td>
  </tr>
</table>
<div id="hiddiv" style="width:120%;height:400;overflow:auto;align:left"></div>
<table id="totab" width="0 height="0" border="1" style="display:none">
  <tr>     
     <td>&nbsp;</td>
  </tr>
</table>
<!--
<table id="totab1" width="0 height="0" border="1" style="display:block">
  <tr>
     <td>�ʷ�����</td>
     <td>�ʷѵ���(Ԫ/��)</td>
     <td>ҵ����(��)</td>
     <td>�û���</td>
     <td>ҵ������(Ԫ)</td>
  </tr>
  <tr>
     <td>��;����</td>
     <td id="long_zj_price_changed"></td>
     <td id="long_zj_dura_changed"></td>
     <td id="long_zj_num_changed"></td>
     <td id="long_zj_charge_changed"></td>
  </tr>
  <tr>
     <td>��������</td>
     <td id="local_zj_price_changed"></td>
     <td id="local_zj_dura_changed"></td>
     <td id="local_zj_num_changed"></td>
     <td id="local_zj_charge_changed"></td>
  </tr>
  <tr>
     <td>��������</td>
     <td id="roam_zj_price_changed"></td>
     <td id="roam_zj_dura_changed"></td>
     <td id="roam_zj_num_changed"></td>
     <td id="roam_zj_charge_changed"></td>
  </tr>  
  <tr>
     <td>��;����</td>
     <td id="long_bj_price_changed"></td>
     <td id="long_bj_dura_changed"></td>
     <td id="long_bj_num_changed"></td>
     <td id="long_bj_charge_changed"></td>
  </tr>
  <tr>
     <td>���α���</td>
     <td id="roam_bj_price_changed"></td>
     <td id="roam_bj_dura_changed"></td>
     <td id="roam_bj_num_changed"></td>
     <td id="roam_bj_charge_changed"></td>
  </tr>
  <tr>
     <td>����</td>
     <td id="by_price_changed"></td>
     <td id="by_dura_changed"></td>
     <td id="by_num_changed"></td>
     <td id="by_charge_changed"></td>
  </tr>  
</table>
-->
</form>
</body>
<script language="javascript">
<!-- ע�� ʹ�õ�ʱ��,form�����Ʊ���Ϊform1-->
	init_table(fromtab,totab,hiddiv,1,1,'y','�����ƶ�����ϵͳ-',new Array(-1,1,2,3,4,5,6,7),new Array(-1,10,11),'pole','zong');
	//init_table(totab,hiddiv,'����ǰ','pole','heng')	
</script>
</html>