<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
Calendar cal = Calendar.getInstance();
cal.add(Calendar.DAY_OF_MONTH,-1);//前一天
DateFormat formater = new SimpleDateFormat("yyyyMMdd");
String defaultDate = formater.format(cal.getTime());
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>流向监控</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript"><!--
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"地市","dataIndex":"c1"}
	,{"name":"县域","dataIndex":"c2"}
	,{"name":"营销中心","dataIndex":"c3"}
	,{"name":"乡镇","dataIndex":"c4"}
	,{"name":"归属省","dataIndex":"c5"}
	,{"name":"归属地市","dataIndex":"c6"}
	,{"name":"来访用户数","dataIndex":"c7"}
	,{"name":"来访通话时长","dataIndex":"c8"}
	,{"name":"来访通话次数","dataIndex":"c9"}
	,{"name":"来访通话结算收入","dataIndex":"c10"}
	,{"name":"出访用户数","dataIndex":"c11"}
	,{"name":"出访通话时长","dataIndex":"c12"}
	,{"name":"出访通话次数","dataIndex":"c13"}
	,{"name":"出访通话结算收入","dataIndex":"c14"}
];
function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}

function setType(obj,isChecked){
	if(obj == 'ck5'){
		if(isChecked == true){
			$('ck1').checked = true;
			$('ck2').checked = true;
			$('ck3').checked = true;
			$('ck4').checked = true;
			$('ck5').checked = true;
		}else{
		}
	}
	if(obj == 'ck4'){
		if(isChecked == true){
			$('ck1').checked = true;
			$('ck2').checked = true;
			$('ck3').checked = true;
			$('ck4').checked = true;
		}else{
			$('ck5').checked = false;
		}
	}
	if(obj == 'ck3'){
		if(isChecked == true){
			$('ck1').checked = true;
			$('ck2').checked = true;
			$('ck3').checked = true;
		}else{
			$('ck5').checked = false;
			$('ck4').checked = false;
		}
	}
	if(obj == 'ck2'){
		if(isChecked == true){
			$('ck1').checked = true;
			$('ck2').checked = true;
		}else{
			$('ck5').checked = false;
			$('ck4').checked = false;
			$('ck3').checked = false;
		}
	}
	if(obj == 'ck1'){
		if(isChecked == true){
			$('ck1').checked = true;
		}else{
			$('ck5').checked = false;
			$('ck4').checked = false;
			$('ck3').checked = false;
			$('ck2').checked = false;
		}
	}			
}
function genSQL(){
	var wherePart = " where 1 = 1 ";
	var date = $('date').value;
	if(date){
		wherePart += " and a.etl_cycle_id = " + date + " ";
	}
	if($('f001').value){
		wherePart += " and a.area_code = '" + $('f001').value + "' ";
	}
	if($('f002').value){
		wherePart += " and a.county_code = '" + $('f002').value + "' ";
	}
	if($('f003').value){
		wherePart += " and a.zone_code = '" + $('f003').value + "' ";
	}
	var colPart = " c1 ";
	var groupByPart = " group by c1 ";
	var orderByPart = " order by c1 ";
	var col = "";
	if($('ck5').checked){
		col = ",c2,c3,c4,c5,c6";
	}else if($('ck4').checked){
		col = ",c2,c3,c4,c5";
	}else if($('ck3').checked){
		col = ",c2,c3,c4";
	}else if($('ck2').checked){
		col = ",c2,c3";
	}else if($('ck1').checked){
		col = ",c2";
	}
	colPart += col;
	groupByPart += col;
	orderByPart += col;
	var sql = "select "+colPart+",sum(c7) c7,sum(c8) c8,sum(c9) c9,sum(c10) c10,sum(c11) c11,sum(c12) c12,sum(c13) c13,sum(c14) c14 from (select b.name c1,(select distinct g.name from nwh.bureau_tree g where g.id=county_code) c2,(select distinct g.name from nwh.bureau_tree g where g.id=zone_code) c3,(select distinct g.name from nwh.bureau_tree g where g.id=town_code) c4,other_provid c5,other_region c6,roamin_usernum c7,roamin_calldura c8,roamin_calltimes c9,roamin_settle_charge c10,roamout_usernum c11,roamout_calldura c12,roamout_calltimes c13,roamout_settle_charge c14 from NMK.ST_Roam_All_Analyse a left join nwh.bureau_tree b on a.area_code = b.id "+ wherePart +") t "
			+ groupByPart
			+ orderByPart
			+ " with ur ";
		//alert(sql);
		return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,isCached : false
	});
	grid.run();
}
function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+encodeURIComponent(genSQL())+"&fileName="+_fileName});
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
		--></script>
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
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0' style="display: ''">
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									地市
								</td>
								<td class='dim_cell_content'>
									<select id="f001" name="f001"  style="width: 200px" onchange="areaCombo(1)">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									县市
								</td>
								<td class='dim_cell_content'>
									<select id="f002" name="f002" style="width: 200px" onchange="areaCombo(2)">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									营销中心
								</td>
								<td class='dim_cell_content'>
									<select id="f003" name="f003" style="width: 200px" >
										<option value="">全部</option>
									</select>
								</td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									统计周期
								</td>
								<td class='dim_cell_content'>
									<input type="text" value='<%=defaultDate %>' id="date" name="date" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
								</td>
								<td class='dim_cell_title'>
									细分至
								</td>
								<td class='dim_cell_content' colspan="3">
									      <input type="checkbox" name="ck1" onclick="setType(this.name,this.checked);">县域
									&nbsp;<input type="checkbox" name="ck2" onclick="setType(this.name,this.checked);">营销中心
									&nbsp;<input type="checkbox" name="ck3" onclick="setType(this.name,this.checked);">乡镇
									&nbsp;<input type="checkbox" name="ck4" onclick="setType(this.name,this.checked);">出/来访省
									&nbsp;<input type="checkbox" name="ck5" onclick="setType(this.name,this.checked);">出/来访市
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
			<div class="divinnerfieldset">
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
function areaCombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	
	_elements.push($('f001'));
	if($('f002')){
		_elements.push($('f002'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' order by name with ur");
	}
	if($('f003')){
		_elements.push($('f003'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' order by name with ur");
	}
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f001'),isHoldFirst:true,sql:"select id key,name value from nwh.bureau_tree where level = 1 order by name with ur"})
}
</script>