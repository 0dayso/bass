<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
String cityCode = (String)BassDimCache.getInstance().get("area_id").get((String)session.getAttribute("area_id"));
DateFormat monthFormater1 = new SimpleDateFormat("yyyyMM");
DateFormat monthFormater2 = new SimpleDateFormat("yyyy-MM");
DateFormat monthFormater3 = new SimpleDateFormat("yyyyMMdd");
Calendar c = Calendar.getInstance();
c.add(Calendar.MONTH,-1);
c.add(Calendar.DATE,-3);
String date = monthFormater1.format(c.getTime());

String fdate = monthFormater2.format(c.getTime()) + "-01";//增加上个月第一天yyyy-MM-dd格式

c.add(Calendar.MONTH,-1);
String ldate = monthFormater1.format(c.getTime()); //增加上上个月

c.setTime(new java.util.Date());
c.add(Calendar.DATE,-2);
String currentdate=monthFormater3.format(c.getTime());
%>
<html>
  <head>
    <title>集团客户预警类</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="../../css/bass21.css" />
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
<script type="text/javascript">
	var condiction="";
	var condiction2="";
	if("<%=cityCode%>"!=0)
	{
	condiction= " and substr(a.staff_org_id,1,5)='<%=cityCode%>' " ;
	condiction2= " and substr(b.staff_org_id,1,5)='<%=cityCode%>' " ;
}
/* === authority added in 20100908  === */
var cityCode = "<%=cityCode%>"; // like "HB.WH"  or "0"   
	

var pieces=[];
pieces[1]={
	filename:"offLineFlag"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"dim1"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V1'"
+" order by area_name"
+" with ur"
};

pieces[2]={
	filename:"us30Days"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind2"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V2'"
+" order by area_name"
+" with ur"
};

pieces[3]={
	filename:"innerNetCycle"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind1"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V3'"
+" order by area_name"
+" with ur"
};

pieces[4]={
	filename:"ZeroCallDays"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind2"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V4'"
+" order by area_name"
+" with ur"
};

pieces[5]={
	filename:"CallerTimerCycle"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind1"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V5'"
+" order by area_name"
+" with ur"
};

pieces[6]={
	filename:"CompetitorsDays"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind2"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V6'"
+" order by area_name"
+" with ur"
};

pieces[7]={
	filename:"MonthToMonth"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind1"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V7'"
+" order by area_name"
+" with ur"
};

pieces[8]={
	filename:"BindingOnTime"
	,title:"地市,集团id,集团名称,预警号码,是否关键人,是否中高端,预警指标值"
	,sql:"select area_name,"
+"groupcode,"
+"groupname,"
+"acc_nbr,"
+"is_keymember,"
+"is_snapuser,"
+"ind2"
+" from nmk.ent_member_warn_#{currentdate}"
+" where warn_code = 'V8'"
+" order by area_name"
+" with ur"
};

pieces[9]={
	filename:"MemberGroupBy"
	,title:"指标,武汉,荆州,襄阳,宜昌,黄冈,孝感,十堰,荆门,恩施,江汉,黄石,咸宁,随州,鄂州,天门,潜江"
	,sql:"select dim2 ,"
+"ind1 ,"
+"ind2 ,"
+"ind3 ,"
+"ind4 ,"
+"ind5 ,"
+"ind6 ,"
+"ind7 ,"
+"ind8 ,"
+"ind9 ,"
+"ind10,"
+"ind11,"
+"ind12,"
+"ind13,"
+"ind14,"
+"ind15,"
+"ind16"
+" from nmk.ent_member_warn_total_#{currentdate}"
+" order by dim1"
+" with ur"
};

pieces[10]={
	filename:"GroupDetailHighWarn"
	,title:"地市,预警周期,集团id,集团名称,预警指标G1值,预警指标G2值,预警指标G3值,预警指标G4值"
	,sql:"select area_name, groupcode, groupname, g1, g2, g3, g4"
+" from nmk.ent_group_warn_#{currentdate}"
+" where group_warn_level = '高' with ur"
};

pieces[11]={
	filename:"GroupDetailMidWarn"
	,title:"地市,预警周期,集团id,集团名称,预警指标G1值,预警指标G2值,预警指标G3值,预警指标G4值"
	,sql:"select area_name, groupcode, groupname, g1, g2, g3, g4"
+" from nmk.ent_group_warn_#{currentdate}"
+" where group_warn_level = '中' with ur"
};
pieces[12]={
	filename:"GroupDetailLowWarn"
	,title:"地市,预警周期,集团id,集团名称,预警指标G1值,预警指标G2值,预警指标G3值,预警指标G4值"
	,sql:"select area_name, groupcode, groupname, g1, g2, g3, g4"
+" from nmk.ent_group_warn_#{currentdate}"
+" where group_warn_level = '低' with ur"
};
pieces[13]={
	filename:"GroupSum"
	,title:"指标,武汉,荆州,襄阳,宜昌,黄冈,孝感,十堰,荆门,恩施,江汉,黄石,咸宁,随州,鄂州,天门,潜江"
	,sql:"select dim2 ,"
+"ind1 ,"
+"ind2 ,"
+"ind3 ,"
+"ind4 ,"
+"ind5 ,"
+"ind6 ,"
+"ind7 ,"
+"ind8 ,"
+"ind9 ,"
+"ind10,"
+"ind11,"
+"ind12,"
+"ind13,"
+"ind14,"
+"ind15,"
+"ind16"
+" from nmk.ent_group_warn_total_#{currentdate}"
+" order by dim1"
+" with ur"
};
function download(sSeq)
{
	var piece=pieces[sSeq];
	if(piece.sql.indexOf("currentdate")>-1){
		var cd='<%=currentdate%>';
		document.forms[0].filename.value=piece.filename+cd
	}else{
		document.forms[0].filename.value=piece.filename;
	}
	document.forms[0].title.value=piece.title;
	document.forms[0].sql.value=piece.sql.replace(/#{month}/gi,document.forms[0].date.value).replace(/#{lmonth}/gi,document.forms[0].ldate.value).replace(/#{fdate}/gi,document.forms[0].fdate.value).replace(/#{currentdate}/gi,document.forms[0].currentdate.value).replace(/#{lastmonth}/gi,document.forms[0].ldate.value);
	
	if(document.forms[0].sql.value.toLowerCase().indexOf("with ur")==0){
		document.forms[0].sql.value+= " with ur "
	}
	// document.getElementById("sqlview").innerHTML=document.forms[0].sql.value;
	var ajax=new aihb.Ajax({
		url: "${mvcPath}/jinku/kpiCheck"
		,loadmask : true
		,parameters : "date="+sSeq
		,callback : function(xmlrequest){
			var resultMap = xmlrequest.responseText;
			resultMap = eval("("+resultMap+")");
			var flag = resultMap.flag;
			var msg = resultMap.msg;
			if(!flag){
				alert(msg);
				var appSessionId = resultMap.appSessionId;
				var clientIp = resultMap.ip;
				var maxTime = resultMap.maxTime;
				var cooperate = resultMap.cooperate;
				var sceneId = resultMap.sceneId;
				var accounts = resultMap.accounts;
				var nid = resultMap.nid;
				var cooperateStatus = resultMap.cooperateStatus;
				var passFlag= false;
				var accountFlag = "N";
				if (cooperate == null || cooperate == "") {
					accountFlag = "Y";
				}
				if(cooperateStatus=="0"){
					return;
				}else{
					if(accountFlag=="N"){
						var params = {
								accounts:accounts
						}	
						var returnValue = window.showModalDialog('/hbapp/cooperative/account.jsp',params,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
						var accountReturn=returnValue.step;
						var account=returnValue.account;						
						if('close' == accountReturn){
							alert("金库认证未通过，请重新认证！");
							window.location = url;
							return;
						}else if('next' == accountReturn){
							var PARAM_INFO = {
								appSessionId:appSessionId,
								clientIp:clientIp,
								sceneId:sceneId,
								maxTime:maxTime,
								cooperate:cooperate,
								accounts:account,
								nid:nid
							};
							
							var RETRUN_INFO = window.showModalDialog('/hbapp/cooperative/show.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;center:yes');
							if('close' == RETRUN_INFO.isClose){
								alert("金库认证未通过，请重新认证！");
								window.location = url;
								return;
							}else if('pass' == RETRUN_INFO.isClose){
								alert("金库认证通过！");
								toDown();
							}
							if('remoteAuth' == RETRUN_INFO.model){
								var codeReturn = window.showModalDialog('/hbapp/cooperative/code.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
								if('close' == codeReturn.isClose){
									alert("金库认证未通过，请重新认证！");
									window.location = url;
									return;
								}else if('pass' == codeReturn.isClose){
									alert("金库认证通过！");
									toDown();
								}
							}
						}
					}
				}
			}else{
				toDown();
			}
		}
	});
	ajax.request();
}

function toDown()
{
	document.forms[0].action = "gcdownAction.jsp";
	document.forms[0].target = "_top";
	document.forms[0].submit();
}
</script>
  </head>
  <body>
  	<div style="margin: 20 px;text-align: center;font-size: 22px;font-weight: bold;font-family: 黑体">集团客户预警类</div>
	<form action="" method="post">
  	<input type="hidden" name="sql" value="">
  	<input type="hidden" name="title" value="">
  	<input type="hidden" name="filename" value="">
  	<div style="padding: 10 px;"></div>
  
  	<table align="center" width="83%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
	  <tr class="grid_title_blue" height="26">
	    <td width="10%" class="grid_title_cell">序号</td>
	    <td width="18%" class="grid_title_cell">跟踪产品</td>
	    <td width="52%" class="grid_title_cell">描述</td>
	    <td width="10%" class="grid_title_cell">下载</td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26" >
	  	<td width="10%" class="grid_row_cell"></td>
	  	<td colspan="3" class="grid_row_cell_text">月份 ：<%=date%>
	  		<input type="hidden" name="date" value="<%=date %>">
	  		<input type="hidden" name="ldate" value="<%= ldate%>" />
	  		<input type="hidden" name="fdate" value="<%= fdate%>" />
	  		<input type="hidden" name="currentdate" value="<%=currentdate%>" />
	  		</td>
	  </tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">1</td>
	    <td class="grid_row_cell_text">集团成员是否离网</td>
	    <td class="grid_row_cell_text">集团成员是否离网下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(1)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">2</td>
	    <td class="grid_row_cell_text">用户停机天数</td>
	    <td class="grid_row_cell_text">用户停机天数下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(2)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">3</td>
	    <td class="grid_row_cell_text">用户移动网内通话时长占用户总时长比重环比降幅</td>
	    <td class="grid_row_cell_text">用户移动网内通话时长占用户总时长比重环比降幅下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(3)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">4</td>
	    <td class="grid_row_cell_text">零次通话天数</td>
	    <td class="grid_row_cell_text">零次通话天数下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(4)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">5</td>
	    <td class="grid_row_cell_text">主叫通话时长环比下降比例</td>
	    <td class="grid_row_cell_text">主叫通话时长环比下降比例下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(5)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">6</td>
	    <td class="grid_row_cell_text">呼转至竞争对手号码天数</td>
	    <td class="grid_row_cell_text">呼转至竞争对手号码天数下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(6)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">7</td>
	    <td class="grid_row_cell_text">月收入较上月降幅</td>
	    <td class="grid_row_cell_text">月收入较上月降幅下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(7)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">8</td>
	    <td class="grid_row_cell_text">是否捆绑到期</td>
	    <td class="grid_row_cell_text">是否捆绑到期下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(8)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">9</td>
	    <td class="grid_row_cell_text">成员汇总</td>
	    <td class="grid_row_cell_text">成员汇总下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(9)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">10</td>
	    <td class="grid_row_cell_text">集团明细-高预警</td>
	    <td class="grid_row_cell_text">集团明细-高预警下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(10)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">11</td>
	    <td class="grid_row_cell_text">集团明细-中预警</td>
	    <td class="grid_row_cell_text">集团明细-中预警下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(11)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">12</td>
	    <td class="grid_row_cell_text">集团明细-低预警</td>
	    <td class="grid_row_cell_text">集团明细-低预警下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(12)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">13</td>
	    <td class="grid_row_cell_text">集团汇总</td>
	    <td class="grid_row_cell_text">集团汇总下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(13)"></td>
	  	</tr>
	  	
	</table>
		</form>
  </body>
</html>
<%@ include file="/hbapp/resources/old/loadmask.htm"%>
<div id="sqlview"></div>