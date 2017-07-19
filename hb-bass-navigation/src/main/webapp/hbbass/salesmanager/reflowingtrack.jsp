<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import = "bass.common.*"%>
<%
// 用户登录超时判断
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

java.util.Calendar cal = java.util.GregorianCalendar.getInstance();
java.util.Calendar cal1 = java.util.GregorianCalendar.getInstance();
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM");
cal.add(java.util.Calendar.MONTH,-1);
String queryMonth = sdf1.format(cal.getTime());
cal1.add(java.util.Calendar.DATE,-1);
String queryDay = sdf.format(cal1.getTime());
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>用户回流信息跟踪分析</title>
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></SCRIPT>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/common2/alertsms.js"></script> <!-- 顺序也很重要 -->
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js"></SCRIPT>
	<script type="text/javascript" src="/hcr/jscript/calendar/calendar.js"></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css"/>
	<script type="text/javascript">
		cellclass[0]="grid_row_cell_number";
		cellclass[1]="grid_row_cell_text";
		cellclass[2]="grid_row_cell_text";
		cellclass[3]="grid_row_cell_text";
		cellclass[4]="grid_row_cell_number";
		cellclass[5]="grid_row_cell_number";
		cellclass[6]="grid_row_cell_number";
		cellclass[7]="grid_row_cell_number";
		cellclass[8]="grid_row_cell_number";
		cellclass[9]="grid_row_cell";
		cellclass[10]="grid_row_cell_text";
		cellclass[11]="grid_row_cell_text";
		cellclass[12]="grid_row_cell_text";
		cellclass[13]="grid_row_cell_text";
		cellclass[14]="grid_row_cell_text";
		cellclass[15]="grid_row_cell_number";
		cellclass[16]="grid_row_cell_number";
		cellclass[17]="grid_row_cell_number";
		cellclass[18]="grid_row_cell_number";
		
		//cellfunc = new Array();
		
		var fetchRows = 150;
		 cellfunc[8]=percentFormat;
		cellfunc[18]=percentFormat;
		cellfunc[12]=function(datas,options)
		{
			if(brand[datas[options.seq]] == undefined) return "";
			else return brand[datas[options.seq]];
		}
		cellfunc[0] = fuzzFormat;
		cellfunc[14] = fuzzFormat;
			
		function toQuery()
		{			 
			//=============  配置sql区  ============
			
			var columns = "opp_nbr,manager_name,value((select b.itemname from  MK.DIM_AREACITY b where  substr(a.CHANNEL_CODE,1,5)=b.ITEMID),'') ,value((select c.itemname from MK.DIM_AREACOUNTY c  where substr(CHANNEL_CODE,1,8)=c.ITEMID),''),substr(char(date),1,7),decimal(value(dura_1,0)/60,16,2),decimal(value(dura_2,0)/60,16,2),decimal(value(dura_3,0)/60,16,2),"+
					"value(decimal(dura_rate,16,2)/100,0),case when value(isbreach,0)=0 then '回流不成功' else '回流成功' end,acc_nbr,innet_date,brand_id,groupname,cust_name,decimal(double(value(yd_dura3,0))/60,16,2),decimal(double(YD_BILLCHARGE/1000),16,2),decimal(double(YD_BILLCHARGE2/1000),16,2),decimal(FUHE,16,2)/100";

			var tables = "nmk.DEFECTION_OPER a  ";
			var condition = "  1=1  ";
			var postfix = "fetch first #{fetchRows} rows only";
			postfix = postfix.replace('#{fetchRows}',fetchRows);
						
			//=============  拼写sql区  ============
			var sql = "select ${columns} from ${tables} where ${condition} ${postfix} with ur";
			
			var city = document.form1.city.value;
			var county = document.form1.county.value;
			/**/
			if(city != "0" )
			{
				condition += " and ucase(channel_code) like ucase('"+city+"%')";
			}
			if(county != "0" && county != "")
			{
				condition += " and ucase(channel_code) like ucase('"+county+"%')";
			}
			var query_month = document.form1.query_month.value;
			condition += " and char(date) like '"+query_month+"%'";
			var manager_id = document.form1.manager_id.value;
			if(manager_id != "")
			{
				condition += " and ucase(manager_id) like ucase('"+manager_id+"%')";
			}
			var manager_name = document.form1.manager_name.value;
			if(manager_name != "")
			{
				condition += " and ucase(manager_name) like ucase('"+manager_name+"%')";
			}
			var isbreach = document.form1.isbreach.value;			
			if(isbreach != "-1")
			{
				condition += " and value(isbreach,0) = "+isbreach;
			}
			var opp_nbr = document.form1.opp_nbr.value;
			if(opp_nbr != "")
			{
				condition += " and opp_nbr like '"+opp_nbr+"%'";
			}
			var acc_nbr = document.form1.acc_nbr.value;
			if(acc_nbr != "")
			{
				condition += " and acc_nbr like '"+acc_nbr+"%'";
			}
			
			sql=sql.replace("${tables}",tables).replace("${condition}",condition);
			
			var countSql= sql.replace("${columns}","count(*)").replace("${postfix}","");//生成统计行数SQL
			
			sql = sql.replace("${columns}",columns);
			
			document.getElementById("sql").value=sql.replace("${postfix}","");//保存完整的SQL
			
			sql = sql.replace("${postfix}",postfix);//加上截取后缀
		  //========     执行区  =================
			ajaxSubmitWrapper(sql,countSql); //执行查询显示
		}
	</SCRIPT>
</head>
<body>
<form name="form1" action="" method="post">
<div id="hidden_div">
	<input type="hidden" id="allPageNum" name="allPageNum" value="">
	<input type="hidden" id="sql" name="sql" value="">
  <input type=hidden name=filename value="">
  <input type=hidden name=title value="">
  <input type=hidden name=order value="lt_accnbr">
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="dim_row">
			<td class="dim_cell_title" align="left">回流月份</td>
			<td class="dim_cell_content">
				<input type="text" size="12" name="query_month" value="<%=queryMonth%>" />
					<SPAN title="请选择日期" style="cursor:hand">
							<IMG src="/hbbass/images/icon_date.gif" align="absMiddle" style="cursor:hand" width="27" height="25" border="0" onclick="javascript: var t=document.all.item('query_month').value; var x=window.showModalDialog('/hbbass/channel/surrogateanalysis/monthCalendar.htm',null,'dialogLeft:'+window.event.screenX+'px;dialogTop:'+window.event.screenY+'px;dialogWidth:250px;dialogHeight:140px;resizable:no;status:no;scroll:no');if (x != null && x.length >0) document.all.item('query_month').value = x; if(x!=t&&x!=null) monthChanged();" width="20" align="absbottom" />
					</SPAN>
			</td>
			<td class="dim_cell_title">地市</td>
			<td class="dim_cell_content"><span name="substr(CHANNEL_CODE,1,5)"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),false,"areacombo(1)")%></span></td>
			<td class="dim_cell_title">县域</td>
			<td class="dim_cell_content"><span name="substr(CHANNEL_CODE,1,8)"><%=QueryTools2.getCountyHtml("county","areacombo(2)")%></span></td>			
		</tr>		
		<tr class="dim_row">
			<td class="dim_cell_title">客服经理工号</td>
			<td class="dim_cell_content"><span name="manager_id"><input type="text" name="manager_id"></span></td>
			<td class="dim_cell_title">客服经理名称</td>
			<td class="dim_cell_content"><span name="manager_name"><input type="text" name="manager_name"></span></td>
			<td class="dim_cell_title">是否回流成功</td>
			<td class="dim_cell_content">
				<select name="isbreach">
					<option value="-1">全部</option>
					<option value="1">回流成功</option>
					<option value="0">回流不成功</option>										
				</select>
			</td>
		</tr>
		<tr class="dim_row">
		<!--
			<td class="dim_cell_title" align="left">跟踪时间</td>
			<td class="dim_cell_content">
				<input type="text" size="12" name="query_day" value="<%=queryDay%>" />
					<SPAN title="请选择日期" style="cursor:hand" onClick="calendar(document.form1.query_day)">
						<IMG src="/hbbass/images/icon_date.gif" align="absMiddle" width="27" height="25" border="0">
					</SPAN>
			</td>
			-->
			<td class="dim_cell_title">竞争对手号码</td>
			<td class="dim_cell_content"><span name="opp_nbr"><input type="text" name="opp_nbr"></span></td>
			<td class="dim_cell_title">移动号码</td>
			<td class="dim_cell_content" colspan="3"><span name="acc_nbr"><input type="text" name="acc_nbr"></span></td>						
		</tr>
	</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit" >
				<td align="right">
					<input type="button" class="form_button" value="查询" onClick="toQuery()">&nbsp;
					<input type="button" class="form_button" value="下载" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</div><br>

<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="show_div"><div id="showSum"></div><div id="showResult"></div></div>
</fieldset>
</div><br>
<div id="title_div" style="display:none;">
	<table id="resultTable" align="center" width="140%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
			 <span id ="0"><td id="0" class="grid_title_cell">竞争对手号码</td></span>
 		   <span id ="1"><td id="0" class="grid_title_cell">策反客户经理</td></span>
 		   <td id="0" class="grid_title_cell">地市</td>
 		   <td id="0" class="grid_title_cell">县市</td>
 		   <td id="0" class="grid_title_cell">回流月</td>
 		   <td id="0" class="grid_title_cell">回流上月<br>时长(分钟)</td>
 		   <td id="0" class="grid_title_cell">回流本月<br>时长(分钟)</td>
 		   <td id="0" class="grid_title_cell">回流下月<br>时长(分钟)</td>
 		   <td id="0" title="(回流上月时长-回流下月时长)/回流上月时长*100%" class="grid_title_cell">通话量<br>下降幅度</td> 		   
 		   <td id="0" class="grid_title_cell">是否<br>回流成功</td>
 		   <td id="0" class="grid_title_cell">移动号码</td>
 		   <td id="0" class="grid_title_cell">入网时间</td>
 		   <td id="0" class="grid_title_cell">品牌</td>
 		   <td id="0" class="grid_title_cell">集团名称</td>
 		   <td id="0" class="grid_title_cell">客户姓名</td>
 		   <td id="0" class="grid_title_cell">移动号码本月<br>计费时长(分钟)</td>
 		   <td id="0" class="grid_title_cell">移动号码回流月<br>本月收入(元/户)</td>
 		   <td id="0" class="grid_title_cell">移动号码回流月<br>下月收入(元/户)</td>
 		   <td id="0" class="grid_title_cell">符合度</td>
		</tr>
	</table>
</div>
</form>
</body>
</html>
<%@ include file="/hbbass/common2/loadmask.htm"%>