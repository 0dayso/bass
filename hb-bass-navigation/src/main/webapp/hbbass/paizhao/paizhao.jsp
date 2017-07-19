<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.MONTH,-1);//上一个月
	DateFormat formater = new SimpleDateFormat("yyyyMM");
	String yearMonth = formater.format(cal.getTime());	
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>2010年拍照跟踪</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	{"name":"地区","dataIndex":"c1"}
	,{"name":"集团客户标识","dataIndex":"c2"}
	,{"name":"集团名称","dataIndex":"c3"}
	,{"name":"集团规模名称","dataIndex":"c4"}
	,{"name":"集团行业分类","dataIndex":"c5"}
	,{"name":"200912整体收入","dataIndex":"c6"}
	,{"name":"200912拍照成员数","dataIndex":"c7"}
	,{"name":"201001整体收入","dataIndex":"c8"}
	,{"name":"1月收入流失率","dataIndex":"c9"}
	,{"name":"201001离网拍照成员数","dataIndex":"c10"}
	,{"name":"201002整体收入","dataIndex":"c11"}
	,{"name":"2月收入流失率","dataIndex":"c12"}
	,{"name":"201002离网拍照成员数","dataIndex":"c13"}
	,{"name":"201003整体收入","dataIndex":"c14"}
	,{"name":"3月收入流失率","dataIndex":"c15"}
	,{"name":"201003离网拍照成员数","dataIndex":"c16"}
	,{"name":"201004整体收入","dataIndex":"c17"}
	,{"name":"4月收入流失率","dataIndex":"c18"}
	,{"name":"201004离网拍照成员数","dataIndex":"c19"}
	,{"name":"201005整体收入","dataIndex":"c20"}
	,{"name":"5月收入流失率","dataIndex":"c21"}
	,{"name":"201005离网拍照成员数","dataIndex":"c22"}
	,{"name":"201006整体收入","dataIndex":"c23"}
	,{"name":"6月收入流失率","dataIndex":"c24"}
	,{"name":"201006离网拍照成员数","dataIndex":"c25"}
	,{"name":"201007整体收入","dataIndex":"c26"}
	,{"name":"7月收入流失率","dataIndex":"c27"}
	,{"name":"201007离网拍照成员数","dataIndex":"c28"}
	,{"name":"201008整体收入","dataIndex":"c29"}
	,{"name":"8月收入流失率","dataIndex":"c30"}
	,{"name":"201008离网拍照成员数","dataIndex":"c31"}
	,{"name":"201009整体收入","dataIndex":"c32"}
	,{"name":"9月收入流失率","dataIndex":"c33"}
	,{"name":"201009离网拍照成员数","dataIndex":"c34"}
	,{"name":"201010整体收入","dataIndex":"c35"}
	,{"name":"10月收入流失率","dataIndex":"c36"}
	,{"name":"201010离网拍照成员数","dataIndex":"c37"}
	,{"name":"201011整体收入","dataIndex":"c38"}
	,{"name":"11月收入流失率","dataIndex":"c39"}
	,{"name":"201011离网拍照成员数","dataIndex":"c40"}
	,{"name":"201012整体收入","dataIndex":"c41"}
	,{"name":"12月收入流失率","dataIndex":"c42"}
	,{"name":"201012离网拍照成员数","dataIndex":"c43"}
];

function genSQL(){
	var sql="select b.area_name c1,t1.groupcode c2,t1.groupname c3, case when t1.custgrade='VC3000' then 'A类' when t1.custgrade='VC3100' then 'B类' when t1.custgrade='VC3200' then 'C类' else 'D类' end c4,t1.engage_TRADE_name c5, decimal((t1.total_charge/1000),15,2) c6, t1.member_num c7, 	value(decimal((t1.total_charge01/1000),15,2),0) c8, value(t1.sr_lv01,0)  c9, value(t1.lw_num01,0)  c10,value(decimal((t1.total_charge02/1000),15,2),0) c11,value(t1.sr_lv02,0)  c12,value(t1.lw_num02,0)  c13,value(decimal((t1.total_charge03/1000),15,2),0) c14,value(t1.sr_lv03,0)  c15,value(t1.lw_num03,0)  c16,value(decimal((t1.total_charge04/1000),15,2),0) c17,value(t1.sr_lv04,0)  c18,value(t1.lw_num04,0)  c19,value(decimal((t1.total_charge05/1000),15,2),0) c20,value(t1.sr_lv05,0)  c21,value(t1.lw_num05,0)  c22,value(decimal((t1.total_charge06/1000),15,2),0) c23,value(t1.sr_lv06,0)  c24,value(t1.lw_num06,0)  c25,value(decimal((t1.total_charge07/1000),15,2),0) c26,value(t1.sr_lv07,0)  c27,value(t1.lw_num07,0)  c28,value(decimal((t1.total_charge08/1000),15,2),0) c29,value(t1.sr_lv08,0)  c30,value(t1.lw_num08,0)  c31,value(decimal((t1.total_charge09/1000),15,2),0) c32,value(t1.sr_lv09,0)  c33,value(t1.lw_num09,0)  c34,value(decimal((t1.total_charge10/1000),15,2),0) c35,value(t1.sr_lv10,0)  c36,value(t1.lw_num10,0)  c37,value(decimal((t1.total_charge11/1000),15,2),0) c38,value(t1.sr_lv11,0)  c39,value(t1.lw_num11,0)  c40,value(decimal((t1.total_charge12/1000),15,2),0) c41,value(t1.sr_lv12,0)  c42,value(t1.lw_num12,0)  c43  from ENT_SNAPSHOP_<%=yearMonth%> t1 ,NMK.REP_AREA_REGION b where substr(t1.staff_org_id,1,5)=b.area_code"; 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
	});
	grid.run();
}

function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+genSQL()+"&fileName="+_fileName});
}
aihb.Util.loadmask();
window.onload=function(){
	var _headerStr="";
	
	for(var i=0;i<_header.length;i++){
		var header=_header[i];
		if(_headerStr.length>0){
			_headerStr+=",";
		}
		_headerStr+="\""+header.dataIndex.toLowerCase()+"\":\""+header.name+"\"";
	}
	_headerStr="{"+_headerStr+"}";
	
	document.forms[0].header.value=_headerStr;
}	
		</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									统计周期
								</td>
								<td class='dim_cell_content'>
									<select id="month" disabled="disabled" style="width: 70px">
										<option value="month">
											<%=yearMonth%>
										</option>
									</select>
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onClick="query()">
									&nbsp;
									<input type="button" class="form_button" value="下载" onclick="down()">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset">
				</td>
				</tr>
				</table>
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="grid" style="display: none;"></div>
				</fieldset>
			</div>
			<br>
		</form>
	</body>
</html>
<script>
function hideTitle(el,objId){
	var obj = document.getElementById(objId);
	if(el.flag ==0)
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
	}
	else
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}
</script>