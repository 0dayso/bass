<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>资费案信息管理</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"资费案代码","dataIndex":"c1"}
	,{"name":"资费案名称","dataIndex":"c2",cellFunc:"setLink",cellStyle:"grid_row_cell_text"}
	,{"name":"归属地市","dataIndex":"c3"}
	,{"name":"归属大品牌","dataIndex":"c4"}
	,{"name":"归属品牌","dataIndex":"c5",cellStyle:"grid_row_cell_text"}
	,{"name":"归属小品牌","dataIndex":"c6",cellStyle:"grid_row_cell_text"}
	//,{"name":"资费案详细说明","dataIndex":"c7"}
	,{"name":"资费案卖点描述","dataIndex":"c8",cellStyle:"grid_row_cell_text"}
	,{"name":"生效时间","dataIndex":"c9"}
	,{"name":"失效时间","dataIndex":"c10"}
	,{"name":"截止当前有效用户数","dataIndex":"c11"}
];

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}

function setLink(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	var feeName = options.data[options.rowIndex].c2;
	return "<a href='#' onclick=\"tabAdd({url:'/hbbass/fee/fee_info_detail.jsp?fee_id="+str+"',title:'资费明细'})\"><u>"+feeName+"</u></a>";
}

function genSQL(){
	var feeId = $('feeId').value;
	var feeName = $('feeName').value;
	var areaCode = $('areaCode').value;
	var prod = $('prod').value;
	var db = $('db').value;
	
	var wherePiece = " where 1=1 ";
	if(feeId){
		wherePiece += " and a.fee_id like '%"+feeId+"%'";
	}
	if(feeName){
		wherePiece += " and a.fee_name like '%"+feeName+"%'";
	}
	if(areaCode && areaCode != 0){
		wherePiece += " and a.area_code = '"+areaCode+"'";
	}
	if(prod){
		wherePiece += " and a.PROD_TNAME like '%"+prod+"%'";
	}
	if(db){
		wherePiece += " and a.DB_TNAME like '%"+db+"%'";
	}
	
	
	var sql="select '' c0,fee_id c1,fee_name c2,value(area_name,'湖北') c3, prod_tname c4,db_tname c5,tm_name c6,describle c7, fee_selling_desc c8,eff_date c9,exp_date c10,user_num c11 from NMK.FEE_INFO a left join nmk.rep_area_region b on a.area_code=b.area_code "+wherePiece+" order by fee_id asc "; 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	//alert(sql);
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
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0' style="display: ''">
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									资费案代码
								</td>
								<td class='dim_cell_content'>
									<input type="text" id="feeId">
								</td>
								<td class='dim_cell_title'>
									资费案名称
								</td>
								<td class='dim_cell_content'>
									<input type="text" id="feeName">
								</td>
								<td class='dim_cell_title'>
									归属地市
								</td>
								<td class='dim_cell_content'>
									<select id="areaCode">
										<option value='0' selected='selected'>全省</option>
										<option value='HB.WH'>武汉</option>
										<option value='HB.HS'>黄石</option>
										<option value='HB.EZ'>鄂州</option>
										<option value='HB.YC'>宜昌</option>
										<option value='HB.ES'>恩施</option>
										<option value='HB.SY'>十堰</option>
										<option value='HB.XF'>襄樊</option>
										<option value='HB.JH'>江汉</option>
										<option value='HB.XN'>咸宁</option>
										<option value='HB.JZ'>荆州</option>
										<option value='HB.JM'>荆门</option>
										<option value='HB.SZ'>随州</option>
										<option value='HB.HG'>黄冈</option>
										<option value='HB.XG'>孝感</option>
										<option value='HB.TM'>天门</option>
										<option value='HB.QJ'>潜江</option>
									</select>
								</td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									归属大品牌
								</td>
								<td class='dim_cell_content'>
									<select id="prod" style="width: 150px" onchange="brandCombo(1)">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									归属品牌
								</td>
								<td class='dim_cell_content'>
									<select id="db" style="width: 150px">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
								</td>
								<td class='dim_cell_content'>
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
			<table align="center" width="97%">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="修改" onClick="update()">
						&nbsp;
						<input type="button" class="form_button" value="分析" onClick="analyse()">
						&nbsp;
						<!--  input type="button" class="form_button" value="新增" onclick="add()">
						&nbsp;							
						<input type="button" class="form_button" value="删除" onclick="del()">
						&nbsp;-->
					</td>
				</tr>
			</table>
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
var win = null;
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

function del(){
	//window.location = '/hbbass/fee/fee_info_detail.jsp';
}

function add(){
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var id = document.getElementsByName('cbox')[i].value;
			if(ids == ""){
				ids += id;
			}else{
				ids += "," + id;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}		
	if(idArr.length > 1){
		alert("只能选择一项进行新增");
		return;
	}
	tabAdd({url:'/hbbass/fee/fee_info_add.jsp?fee_id='+ids,title:'新增资费'});
}

function update(){
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var id = document.getElementsByName('cbox')[i].value;
			if(ids == ""){
				ids += id;
			}else{
				ids += "," + id;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}		
	if(idArr.length > 1){
		alert("只能选择一项进行修改");
		return;
	}
	tabAdd({url:'/hbbass/fee/fee_info_update.jsp?fee_id='+ids,title:'fee_blank'});
}

function analyse(){
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var id = document.getElementsByName('cbox')[i].value;
			if(ids == ""){
				ids += id;
			}else{
				ids += "," + id;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}		
	if(idArr.length > 1){
		alert("只能选择一项进行分析");
		return;
	}
	tabAdd({url:'/hbbass/salesmanager/mainpostage.jsp?fee_id='+ids,title:'资费分析'});
}


function brandCombo( level , sync ) {
	
	var _elements = [];
	var sqls = [];
	
	_elements.push($('prod'));
	if($('db')){
		_elements.push($('db'));
		sqls.push("select distinct db_TNAME key,db_TNAME value from NMK.FEE_INFO where prod_tname='#{value}' with ur");
	}
	
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('prod'),isHoldFirst:true,sql:"select distinct PROD_TNAME key,PROD_TNAME value from NMK.FEE_INFO  with ur"})
}
query();
</script>