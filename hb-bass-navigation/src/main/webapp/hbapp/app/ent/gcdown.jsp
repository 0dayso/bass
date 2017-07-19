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
var cityCode = "<%=cityCode%>";

var pieces=[];

pieces[10]={filename:"wxshOrderMember"
,title:"地区,集团编码,集团名称,成员号码,出账收入"
,sql:"select value(itemname,'未知'),value(a.groupcode,'未知'),value(b.groupname,'未知'),value(acc_nbr,'未知'),sum(a.sum_charge)/1000 from NMK.ENT_PRODMEMBER_ORDER_#{month} a left join  NMK.ENT_SUM_#{month} b on a.groupcode=b.groupcode left join  mk.dim_areacity c  on substr(a.staff_org_id,1,5)=c.itemid	where a.prod_code = 'WXSH' and pstatus = 'stcmNml' group by value(itemname,'未知'),value(a.groupcode,'未知'),value(b.groupname,'未知'),value(acc_nbr,'未知')"
};

pieces[11]={filename:"wxshOrderGroup"
,title:"地区,集团编码,集团名称,统付收入,非统付收入"
,sql:"select value(itemname,'未知'),groupcode,groupname,sum(tf_charge)/1000,sum(sum_charge)/1000 from NMK.ENT_PROD_#{month}  a left join mk.dim_areacity b on substr(a.own_org_id,1,5)=b.itemid where a.prod_code = 'WXSH' group by value(itemname,'未知'),groupcode,groupname	with ur "
};



function download(sSeq)
{
	if(sSeq==16){
		tabAdd({title:'校讯通业务订购用户清单',url:"${mvcPath}/report/8638"});
	}else if(sSeq==17){
		tabAdd({title:'效能快信MAS用户清单',url:"${mvcPath}/report/9319"});
	}else if(sSeq==20){
		tabAdd({title:'集团价值评估 ',url:"${mvcPath}/report/9588"});
	}else if(sSeq==21){
		tabAdd({title:'集团统付清单',url:"${mvcPath}/report/9591"});
	}else{
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
  	<div style="margin: 20 px;text-align: center;font-size: 22px;font-weight: bold;font-family: 黑体">集团客户数据下载专区</div>
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
	 <!-- <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">1</td>
	    <td class="grid_row_cell_text">虚假集团客户成员清单</td>
	    <td class="grid_row_cell_text">虚假集团客户成员清单（只提供最新月份）月份,地市,县域,所属集团客户编码,集团客户名称,虚假集团成员手机号码</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(1)"></td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">2</td>
	    <td class="grid_row_cell_text">集团客户关键人清单</td>
	    <td class="grid_row_cell_text">集团客户关键人清单（只提供最新月份）月份,地市,县域,所属集团客户,集团客户名称,关键人手机号码,关键人职务,关键人当月消费金额,是否捆绑</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(2)"></td>
	  </tr>
	   <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">3</td>
	    <td class="grid_row_cell_text">农信通订购用户清单</td>
	    <td class="grid_row_cell_text">农信通订购用户清单：县,用户号码,订购业务编码,业务名称,订购生效时间,业务收入<br>（仅提供在平台上订购的用户,该收入合计并非农信通业务收入）</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(3)"></td>
	  </tr>
 <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">4</td>
	    <td class="grid_row_cell_text">校信通订购用户清单</td>
	    <td class="grid_row_cell_text">校信通订购用户清单：县,用户号码,订购业务编码,业务名称,订购生效时间,业务收入<br>（仅提供最新月份数据）</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(4)"></td>
	  </tr>
	   <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">5</td>
	    <td class="grid_row_cell_text">动力100订购业务清单下载</td>
	    <td class="grid_row_cell_text">动力100订购业务清单下载：县,集团客户编号,客户经理编号,客户经理名称,动力100包名称,订购时间,业务总收入,<br>仅提供最新月份数据</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(5)"></td>
	  </tr>
	   <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">6</td>
	    <td class="grid_row_cell_text">集团客户成员中拍照中高端客户预警明细</td>
	    <td class="grid_row_cell_text">集团客户成员中拍照中高端客户预警明细清单下载：对拍照中高端客户,本年内任意1个月话费低于50元的中高端客户,即将流失的集团客户成员；仅提供最新月份数据:集团客户编号,手机号码,捆绑标识,客户经理编号,客户经理姓名</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(6)"></td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">7</td>
	    <td class="grid_row_cell_text">集团客户欠费清单</td>
	    <td class="grid_row_cell_text">对集团客户产品统付类的欠费提供清单下载，欠费包含历史欠费，每列信息为：
                                        帐期、地市、集团客户编号、集团客户名称、客户经理编号、客户经理名称、
                                        集团客户统付账号、欠费金额(单位：分)
</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(7)"></td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">8</td>
	    <td class="grid_row_cell_text">集团客户产品订购明细</td>
	    <td class="grid_row_cell_text">提供截至到当前月份，集团客户订购的所有标准化产品的明细清单，每月信息为：
                                        月份、地市、集团客户编号、集团客户名称、集团客户经理编号、客户经理名称、
                                        订购产品名称、订购生效时间</td>
	     <td class="grid_row_cell"><input type="button" class="form_button_short" value="下载" onclick="download(8)"></td>
	  </tr>
	  
	   <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">9</td>
	    <td class="grid_row_cell_text">重点关注集团关键人清单</td>
	    <td class="grid_row_cell_text">提供截至到当前月份,重点关注集团关键人使用数据业务明细。</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(9)"></td>
	  </tr>  -->
	  
				<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">10</td>
	    <td class="grid_row_cell_text">无线商话号码清单</td>
	    <td class="grid_row_cell_text"> 无线商话订购成员清单：地市、集团编码、集团名称、用户号码、出账收入（仅提供最新月份数据）</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(10)"></td>
	  </tr>
	  	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">11</td>
	    <td class="grid_row_cell_text">无线商话订购集团清单</td>
	    <td class="grid_row_cell_text"> 无线商话订购集团清单：地市、集团编码、集团名称、统付收入、非统付收入（仅提供最新月份数据） </td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(11)"></td>
	  </tr>
	  
	  <!--	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">12</td>
	    <td class="grid_row_cell_text">S前缀集团订购产品清单</td>
	    <td class="grid_row_cell_text"> 到达集团客户中名称为S开头的集团订购产品个数的清单下载 </td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(12)"></td>
	  	</tr>
	  	
	   <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">13</td>
	    <td class="grid_row_cell_text">集团客户信息化产品欠费明细</td>
	    <td class="grid_row_cell_text">集团客户信息化产品欠费明细</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(13)"></td>
	  	</tr>
	  
	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">14</td>
	    <td class="grid_row_cell_text">真实成员清单下载</td>
	    <td class="grid_row_cell_text">真实成员清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(14)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">15</td>
	    <td class="grid_row_cell_text">省级重点关注集团年累计离网率和累计收入降幅清单下载</td>
	    <td class="grid_row_cell_text">省级重点关注集团年累计离网率和累计收入降幅清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(15)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">16</td>
	    <td class="grid_row_cell_text">校讯通业务订购用户清单</td>
	    <td class="grid_row_cell_text">校讯通业务订购用户清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(16)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">17</td>
	    <td class="grid_row_cell_text">效能快信MAS用户清单</td>
	    <td class="grid_row_cell_text">效能快信MAS用户清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(17)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">18</td>
	    <td class="grid_row_cell_text">新增综合评价指标比值</td>
	    <td class="grid_row_cell_text">新增综合评价指标比值下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(18)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">19</td>
	    <td class="grid_row_cell_text">新增综合评价指标得分</td>
	    <td class="grid_row_cell_text">新增综合评价指标得分下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(19)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">20</td>
	    <td class="grid_row_cell_text">集团价值评估  </td>
	    <td class="grid_row_cell_text">集团价值评估  </td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(20)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">21</td>
	    <td class="grid_row_cell_text">集团统付清单</td>
	    <td class="grid_row_cell_text">集团统付清单</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(21)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">22</td>
	    <td class="grid_row_cell_text">全省集团客户信息化产品使用情况</td>
	    <td class="grid_row_cell_text">全省集团客户信息化产品使用情况下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(22)"></td>
	  	</tr> -->
	  	
	  	
	</table>
		</form>
  </body>
</html>
<%@ include file="/hbapp/resources/old/loadmask.htm"%>
<div id="sqlview"></div>