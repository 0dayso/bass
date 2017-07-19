<!--
说明:此页面适用于集团客户模块,此模块的特点是:查询结果均为汇总后的数据,数据量不会很大
     故下载方法只使用了:
     1.查询结果小于页面行数设置时,直接从页面提取数据;
     2.当查询结果大于页面行数设置时,使用公用的commonDown.jsp文件下载,保存为单个文件
  如果涉及到清单文件下载(结果集行数>2万行),需要用分文件下载的方法处理.
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
<TITLE>湖北移动经营分析系统</TITLE>
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
<%--本页 jsp 初始化程序段--%>
<%
response.setHeader("Cache-Control","no-store");

//根据登录名查询用户的信息 如用户所属的区域
//int area_id = Integer.parseInt((String)session.getAttribute("area_id"));
int area_id=0;

String colname = "地区";
/* 获取表单区开始 */
String arealevel=request.getParameter("arealevel")==null?cptool.getONAreaidName(String.valueOf(area_id)):request.getParameter("arealevel");
String arealevel1=request.getParameter("hidarealevel1")==null?"0":request.getParameter("hidarealevel1");

String starttime=request.getParameter("time_id")==null?"":request.getParameter("time_id");

String groupCode = request.getParameter("groupcode")==null?"":request.getParameter("groupcode");
String groupId = request.getParameter("groupid")==null?"":request.getParameter("groupid");

//资费测算模式 1、从业务单价、业务量推算总收入  2、从总收入、业务量推算出单价
String model = request.getParameter("model")==null?"fee":request.getParameter("model");
//页面上资费分析按钮状态值
String buttonStatus = request.getParameter("buttonstatus")==null?"unclicked":request.getParameter("buttonstatus");

/* 获取表单区结束 */

String downlevel="";
/* 分页模块代码开始  以下代码一般不要做修改 */
int perPage=15;   //设置每页显示行数
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
/* 分页模块代码结束  */

/* 定义业务代码开始 组装自己的sql */

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

/* 组装sql的 where 条件
if(!groupabc.equals(""))
{
	commonwheresql.append(" and ='"+groupabc+"'");
}
*/
/* 组装查询字段 */
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
/* 定义业务代码结束 组装自己的sql */

/*  用户初次进入此页面时不作查询,只有用户点击了查询按钮后才作查询  以下代码不要作修改*/
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
	<table width="100%" cellspacing="0" cellpadding="0" border="0" onClick="hideTitle(document.all.IMG_TITLE,'searchCond','查询条件区域')" class="dBoxHeaderArea">
		<tr title="展开/隐藏">
			<td class="main">查询条件区域</td>
			<td class="misc" align="right"><img border="0" name="IMG_TITLE" ShowFlag=1 src="/hbbass/images/search_show.gif">
			</td>
		</tr>
	</table>
</div>
<table id="searchCond" width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse;display:block" bordercolor="#537EE7">
  	<tr><td>
      	<table class="bule" align="center" width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#FFFFFF">
	      	<tr height="23">
	      		<td width=10% bgcolor='#DCEBFC' align="right">时间</td>
	      		<td width=15% bgcolor="#EFF5FB"><%=QuertTools.getDateYM("time_id",starttime)%></td>
	      		<td width=13% bgcolor='#DCEBFC' align="right">地市</td>
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
	      		<td align="right" bgcolor='#DCEBFC'>集团编号
            	<td bgcolor="#EFF5FB"><input name="groupcode" type="text" id="groupcode" size="16" maxlength="64" value="<%=groupCode%>"></td>
	      		<td bgcolor="#EFF5FB" colspan="2">&nbsp;</td>
      	  </tr>
      	  <tr height="23">
	      	  <td align="right" bgcolor='#DCEBFC'>模型推算方式：
              <td colspan="5" align="right" bgcolor='#EFF5FB'>
                <div align="left">
                  <input type="radio" name="radiobutton" value="radiobutton" <%if(!model.equals("incoming")) out.print("checked");%> onClick="getradiovalue('0')">
    从资费单价、业务量预测总收入
    <input type="radio" name="radiobutton" value="radiobutton" <%if(model.equals("incoming")) out.print("checked");%> onClick="getradiovalue('1')">
    从总收入、业务量预测资费单价</div>
   	      	    <td colspan="2" align="right" bgcolor='#EFF5FB'>&nbsp;</td>
      	  </tr>
      	  <tr height="23">
      	  <td align="right" colspan="8" ><input type="button" name="queryBtn" id="queryBtn" value="资费分析" onClick="query()">
      	  &nbsp;&nbsp;
      	  <!--<input type="button" name="defaultBtn" id="defaultBtn" value="恢复成调整前的值" onClick="setDefault()">-->
      	  &nbsp;&nbsp;</td>
      	  </tr>
	    </table>
		</td></tr>
 </table>
<br>
<%
/** 资费单价规则定义
 *  long_zj_price = long_zj_charge/long_zj_dura
 *  long_bj_price = long_bj_charge/long_bj_dura
 *  local_zj_price = local_zj_charge/local_zj_dura
 *  roam_zj_price = (roam_sn_zj_charge+roam_sj_zj_charge)/roam_zj_dura
 *  roam_bj_price = (roam_sn_bj_charge+roam_sj_bj_charge)/roam_bj_dura
 *  by_price = by_charge/by_dura
 */
float long_zj_price = 0;      //长途主叫单价
float local_zj_price = 0;     //本地主叫单价
float roam_zj_price =0;       //漫游主叫单价
float long_bj_price = 0;      //长途被叫单价
float roam_bj_price = 0;      //漫游被叫单价
float by_price = 0;           //包月费
float sum_price = 0;          //平均单价

float roam_zj_charge = 0;      //漫游主叫收入
float roam_bj_charge = 0;      //漫游被叫收入
float roam_zj_dura = 0;        //漫游主叫时长
float roam_bj_dura = 0;        //漫游被叫时长
float sum_dura = 0;            //总时长

float local_zj_price_num_charge = 0;    //本地主叫平均单价(按用户)
float long_zj_price_num_charge = 0;     //长途主叫平均单价(按用户)
float long_bj_price_num_charge = 0;     //长途被叫平均单价(按用户)
float roam_zj_price_num_charge = 0;     //漫游主叫平均单价(按用户)
float roam_bj_price_num_charge = 0;     //漫游被叫平均单价(按用户)
float by_price_num_charge = 0;          //包月单价(按用户)

String sum_num = "0";             //总用户数

String long_zj_charge = "0";     //长途主叫收入
String long_zj_dura = "0";       //长途主叫时长
String long_zj_num = "0";        //长途主叫用户数
String long_bj_charge = "0";     //长途被叫收入
String long_bj_dura = "0";       //长途被叫时长
String long_bj_num = "0";        //长途被叫用户数
String local_zj_charge = "0";    //本地主叫收入
String local_zj_dura ="0";       //本地主叫时长
String local_zj_num = "0";       //本地主叫用户数
String roam_sn_zj_charge = "0";  //省内漫游主叫收入
String roam_sn_zj_dura = "0";    //省内漫游主叫时长
String roam_sn_bj_charge = "0";  //省内漫游被叫收入
String roam_sn_bj_dura = "0";    //省内漫游被叫时长
String roam_sj_zj_charge = "0";  //省际漫游主叫收入
String roam_sj_zj_dura = "0";    //省际漫游主叫时长
String roam_sj_bj_charge = "0";  //省际漫游被叫收入
String roam_sj_bj_dura = "0";    //省际漫游被叫时长
String roam_zj_num = "0";        //漫游主叫用户数
String roam_bj_num = "0";        //漫游被叫用户数
String by_charge = "0";          //包月收入
String by_dura = "0";            //包月时长
String by_num = "0";             //包月用户数
String sum_charge = "0";        //总收入

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
       <!--<img src="/hbbass/images/new/col.gif"  style="cursor:hand" Alt = "调整显示的列" width=30 height=25 border="0" onclick="opennew()">-->
       <img src="/hbbass/images/new/excel.gif"  Alt = "保存为excel" width=30 height=25 border="0" onclick="SaveAsExcel1('资费测算.csv')">
       <img src="/hbbass/images/new/help2.gif"  style="cursor:hand" Alt = "页面操作帮助" width=30 height=25 border="0" onclick="help()">
    </td>
  </tr>
</table>
<div class="dBoxHeaderLayout">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" onClick="hideTitle(document.all.IMG_DATA,'resultTable','数据展示区域')" class="dBoxHeaderArea">
		<tr title="展开/隐藏">
			<td class="main">数据展示区域</td>
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
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">资费单价</div></td>
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">业务量</div></td>
	      	  <td colspan="2" align="right" bgcolor='#EFF5FB'><div align="center">用户数</div></td>
	      	  <td colspan="2" bgcolor="#EFF5FB"><div align="center">业务收入</div></td>
	      	-->
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">资费单价(元/分)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">业务量(分)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td align="right" bgcolor='#EFF5FB'><div align="center">用户数(户)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	  <td bgcolor="#EFF5FB"><div align="center">业务收入(元)</div></td>
	      	  <td bgcolor="#EFF5FB">&nbsp;</td>
	      	</tr>
	      	<tr height="23">
	      		<td bgcolor='#DCEBFC' align="right">本地主叫单价</td>
	      		<td bgcolor="#EFF5FB"><textarea name="local_zj_price" cols="18" rows="1" class="input" id="local_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(local_zj_price).toString(),2)%></textarea></td>
	      		<td bgcolor='#DCEBFC' align="right">本地主叫时长</td>
      		    <td bgcolor="#EFF5FB"><textarea name="local_zj_dura" cols="18" rows="1" class="input" id="local_zj_dura" onscroll=scrolltextarea(this,0,999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=local_zj_dura%></textarea></td>
      		    <td align="right" bgcolor='#DCEBFC'>本地主叫用户数</td>
   		      <td bgcolor="#EFF5FB"><textarea name="local_zj_num" cols="18" rows="1" class="input" id="local_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=local_zj_num%></textarea></td>
      		    <td align="right" bgcolor='#DCEBFC'>本地主叫收入</td>
   		      <td bgcolor="#EFF5FB"><textarea name="local_zj_charge" cols="18" rows="1" class="input" id="local_zj_charge" onscroll=scrolltextarea(this,0,999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=local_zj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      		<td width="11%" align="right" bgcolor='#DCEBFC'>长途主叫单价</td>
      			<td width="17%" bgcolor="#EFF5FB">
      			<textarea name="long_zj_price" cols="18" rows="1" class="input" id="long_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(long_zj_price).toString(),2)%></textarea>
   			  <!--<input type="text" name="currentcharge" size=20>--></td>
	      		<td width="11%" align="right" bgcolor='#DCEBFC'>长途主叫时长</td>
      		    <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_dura" cols="18" rows="1" class="input" id="long_zj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=long_zj_dura%></textarea>
   		      <!--<input type="text" name="currentcharge" size=20>--></td>
   		        <td width="12%" align="right" bgcolor='#DCEBFC'>长途主叫用户数</td>
	          <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_num" cols="18" rows="1" class="input" id="long_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=long_zj_num%></textarea></td>
	            <td width="10%" align="right" bgcolor='#DCEBFC'>长途主叫收入</td>
              <td width="13%" bgcolor="#EFF5FB"><textarea name="long_zj_charge" cols="18" rows="1" class="input" id="long_zj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=long_zj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">长途被叫单价</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_price" cols="18" rows="1" class="input" id="long_bj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(long_bj_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">长途被叫时长</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_dura" cols="18" rows="1" class="input" id="long_bj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=long_bj_dura%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>长途被叫用户数</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_num" cols="18" rows="1" class="input" id="long_bj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=long_bj_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>长途被叫收入</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="long_bj_charge" cols="18" rows="1" class="input" id="long_bj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=long_bj_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      		<td bgcolor='#DCEBFC' align="right">漫游主叫单价</td>
	      		<td bgcolor="#EFF5FB"><textarea name="roam_zj_price" cols="18" rows="1" class="input" id="roam_zj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(roam_zj_price).toString(),2)%></textarea></td>
	      		<td bgcolor='#DCEBFC' align="right">漫游主叫时长</td>
	      		<td bgcolor="#EFF5FB"><textarea name="roam_zj_dura" cols="18" rows="1" class="input" id="roam_zj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(roam_zj_dura).toString(),0)%></textarea></td>
	      		<td align="right" bgcolor='#DCEBFC'>漫游主叫用户数</td>
      		  <td bgcolor="#EFF5FB"><textarea name="roam_zj_num" cols="18" rows="1" class="input" id="roam_zj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=roam_zj_num%></textarea></td>
	      		<td align="right" bgcolor='#DCEBFC'>漫游主叫收入</td>
      		  <td bgcolor="#EFF5FB"><textarea name="roam_zj_charge" cols="18" rows="1" class="input" id="roam_zj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=mp.round(new Float(roam_zj_charge).toString(),0)%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">漫游被叫单价</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_price" cols="18" rows="1" class="input" id="roam_bj_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(roam_bj_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">漫游被叫时长</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_dura" cols="18" rows="1" class="input" id="roam_bj_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(roam_bj_dura).toString(),0)%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>漫游被叫用户数</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_num" cols="18" rows="1" class="input" id="roam_bj_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=roam_bj_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>漫游被叫收入</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="roam_bj_charge" cols="18" rows="1" class="input" id="roam_bj_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=mp.round(new Float(roam_bj_charge).toString(),0)%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC' align="right">包月费</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_price" cols="18" rows="1" class="input" id="by_price" onscroll=scrolltextarea(this,0,100,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(by_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC' align="right">包月时长</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_dura" cols="18" rows="1" class="input" id="by_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=by_dura%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>包月用户数</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_num" cols="18" rows="1" class="input" id="by_num" onscroll=scrolltextarea(this,0,999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=by_num%></textarea></td>
	      	  <td align="right" bgcolor='#DCEBFC'>包月收入</td>
	      	  <td bgcolor="#EFF5FB"><textarea name="by_charge" cols="18" rows="1" class="input" id="by_charge" onscroll=scrolltextarea(this,0,9999999999,1,4); onselectstart="return false" onpropertychange=vpmncalc1(this,4)><%=by_charge%></textarea></td>
	      	</tr>
	      	<tr height="23">
	      	  <td bgcolor='#DCEBFC'><div align="right">平均单价</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_price" cols="18" rows="1" class="input" id="sum_price" onscroll=scrolltextarea(this,0,9999999999,0.01,1); onselectstart="return false" onpropertychange=vpmncalc1(this,1)><%=mp.round(new Float(sum_price).toString(),2)%></textarea></td>
	      	  <td bgcolor='#DCEBFC'><div align="right">总时长</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_dura" cols="18" rows="1" class="input" id="sum_dura" onscroll=scrolltextarea(this,0,9999999999,1,2); onselectstart="return false" onpropertychange=vpmncalc1(this,2)><%=mp.round(new Float(sum_dura).toString(),0)%></textarea></td>
	      	  <td bgcolor="#DCEBFC"><div align="right">总用户数</div></td>
	      	  <td bgcolor="#EFF5FB"><textarea name="sum_num" cols="18" rows="1" class="input" id="sum_num" onscroll=scrolltextarea(this,0,9999999999,1,3); onselectstart="return false" onpropertychange=vpmncalc1(this,3)><%=sum_num%></textarea></td>
	      	  <td bgcolor="#DCEBFC"><div align="right">V网总收入</div></td>
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
						<th align="middle"><font size=2>V网总收入的增减幅度</font></th>
						<th align="middle"><font size=2>V网包月费增减幅度</font></th>
						<th align="middle"><font size=2>漫游费增减幅度</font></th>
						<th align="middle"><font size=2>长途费增减幅度</font></th>
						<th align="middle"><font size=2>新增目标用户数</font></th>
						<th align="middle"><font size=2>新增话务量</font></th>
						<th align="middle"><font size=2>新增功能费</font></th>
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
     <td align="center">资费类型</td>
     <td align="center">单价</td>
     <td align="center">单价<br>(调整后)</td>
     <td align="center">调整<br>幅度(%)</td>
     <td align="center">业务量</td>
     <td align="center">业务量<br>(调整后)</td>
     <td align="center">调整<br>幅度(%)</td>
     <td align="center">用户数</td>
     <td align="center">用户数<br>(调整后)</td>
     <td align="center">调整<br>幅度(%)</td>
     <td align="center">业务收入</td>     
     <td align="center">业务收入<br>(调整后)</td>
     <td align="center">调整<br>幅度(%)</td>
  </tr>
  <tr>
     <td>本地主叫</td>
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
     <td>长途主叫</td>
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
     <td>长途被叫</td>
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
     <td>漫游主叫</td>
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
     <td>漫游被叫</td>
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
     <td>包月</td>
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
     <td >统计</td>
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
     <td>资费类型</td>
     <td>资费单价(元/分)</td>
     <td>业务量(分)</td>
     <td>用户数</td>
     <td>业务收入(元)</td>
  </tr>
  <tr>
     <td>长途主叫</td>
     <td id="long_zj_price_changed"></td>
     <td id="long_zj_dura_changed"></td>
     <td id="long_zj_num_changed"></td>
     <td id="long_zj_charge_changed"></td>
  </tr>
  <tr>
     <td>本地主叫</td>
     <td id="local_zj_price_changed"></td>
     <td id="local_zj_dura_changed"></td>
     <td id="local_zj_num_changed"></td>
     <td id="local_zj_charge_changed"></td>
  </tr>
  <tr>
     <td>漫游主叫</td>
     <td id="roam_zj_price_changed"></td>
     <td id="roam_zj_dura_changed"></td>
     <td id="roam_zj_num_changed"></td>
     <td id="roam_zj_charge_changed"></td>
  </tr>  
  <tr>
     <td>长途被叫</td>
     <td id="long_bj_price_changed"></td>
     <td id="long_bj_dura_changed"></td>
     <td id="long_bj_num_changed"></td>
     <td id="long_bj_charge_changed"></td>
  </tr>
  <tr>
     <td>漫游被叫</td>
     <td id="roam_bj_price_changed"></td>
     <td id="roam_bj_dura_changed"></td>
     <td id="roam_bj_num_changed"></td>
     <td id="roam_bj_charge_changed"></td>
  </tr>
  <tr>
     <td>包月</td>
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
<!-- 注意 使用的时候,form的名称必须为form1-->
	init_table(fromtab,totab,hiddiv,1,1,'y','湖北移动经分系统-',new Array(-1,1,2,3,4,5,6,7),new Array(-1,10,11),'pole','zong');
	//init_table(totab,hiddiv,'调整前','pole','heng')	
</script>
</html>