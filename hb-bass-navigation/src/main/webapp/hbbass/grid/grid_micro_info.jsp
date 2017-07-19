<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%
String userid = (String)session.getAttribute("loginname");
Connection conn = null;
String cityId = null;
String cityName = null;
String dmCityId = null;
boolean isProvince = false;
boolean hasRight = false;
try{
	conn = ConnectionManage.getInstance().getWEBConnection();
	String sql = "select a.userid,a.username,a.cityid,b.cityname,b.dm_city_id from FPF_USER_USER a left join FPF_user_city b on a.cityid = b.cityid where userid ='"+userid+"'";
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		cityId = rs.getString(3);
		cityName = rs.getString(4);
		dmCityId = rs.getString(5);
	}
	//如果cityid == 0 ，则是省公司用户，否则为地市用户
	if("0".equals(cityId)){
		isProvince = true;
	}else{
		isProvince = false;
	}
	rs.close();
	ps.close();
}catch ( SQLException e){
	e.printStackTrace();
}finally{
	if(conn!=null)
		conn.close();
}
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>微网格维护</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
		 var _params = aihb.Util.paramsObj(); 
		 _params.loginname = '';
		 _params.cityId = '';
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"微网格编码","dataIndex":"c1"}
	,{"name":"微网格名称","dataIndex":"c2"}
	,{"name":"微网格类型","dataIndex":"c3"}
	,{"name":"归属子网格","dataIndex":"c4"}
	,{"name":"归属主网格","dataIndex":"c5"}
	//,{"name":"地市编码","dataIndex":"c6"}
	,{"name":"负责客户经理编码","dataIndex":"c7"}
	,{"name":"负责客户经理姓名","dataIndex":"c8",cellFunc:"setLink",cellStyle:"grid_row_cell_text"}
	//,{"name":"级别","dataIndex":"c9"}
];

function setTip(crtVal,options) {
 	var length = 10;
	if(!crtVal)return ""; //返回空字符串就是一种处理,如果return ;，页面上就是undefined
	var span = $C("span") ;
	crtVal = crtVal.trim();
	if(crtVal.length > length) {
		span.appendChild($CT(crtVal.substr(0,length) + "..."));
		span.onmouseover=function() {tooltip.show(crtVal);}
		span.onmouseout=tooltip.hide;
		return span;
	} else {
		span.appendChild($CT(crtVal)); //不加不行
	}
	return span;
}

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}

function setLink(dataIndex,options){
	var custmanager = options.data[options.rowIndex].c7
	var custName = options.data[options.rowIndex].c8;
	return "<a href='#' onclick=\"tabAdd({url:'/hbbass/groupcust/20/groupcustview.jsp?custmanager="+encodeURIComponent(custmanager)+"',title:'集团客户统一视图'})\"><u>"+custName+"</u></a>";
}

var treeOpened = false;
function genSQL(){
var wherePart = " where 1 = 1 ";

if($('ds').value != ""){
	wherePart +=	" and city_id = '"+$('ds').value+"'";
}
if($('f1005').value != ""){
	wherePart +=	" and maingrid_id = '"+$('f1005').value+"'";
}
if($('f1006').value != ""){
	wherePart +=	" and subgrid_id = '"+$('f1006').value+"'";
}
if($('wwg').value != ""){
	wherePart +=	" and microgrid_name like '%"+$('wwg').value+"%'";
}
if($('wglx').value != ""){
	wherePart +=	" and type = '"+$('wglx').value+"'";
}
<%
	String idPara = request.getParameter("microgrid_id");
%>
if(<%=idPara%> && <%=idPara%> != '' && treeOpened == false){
	wherePart +=	" and microgrid_id = <%= idPara%> ";
	treeOpened = true;
}
		
var sql= "select '' c0,microgrid_id c1 ,microgrid_name c2 ,case when type='ADMIN' then '物理微网格' when type='SPE' then '特征微网格' when type='SA' then 'SA' end c3 ,(select subgrid_name from nmk.grid_sub_info st where st.subgrid_id = mit.subgrid_id) c4 ,(select maingrid_name from nmk.grid_main_info mt where mt.maingrid_id = mit.maingrid_id) c5 ,city_id c6 ,staff_id c7 ,staff_name c8 ,level c9 from nmk.grid_micro_info mit"
		+ wherePart
		+" order by c1 "
		aihb.AjaxHelper.parseCondition()
		+" with ur ";
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
	aihb.AjaxHelper.down({
		sql : genSQL()
		,header : _header
	});
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
									地市
								</td>
								<td class='dim_cell_content'>
									<select id="ds"  style="width: 200px" >
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									主网格
								</td>
								<td class='dim_cell_content'>
									<select id="f1005" name="f1005" style="width: 200px" onchange="areaCombo(1)">
										<option value="">请选择</option>
									</select> 
								</td>
								<td class='dim_cell_title'>
									子网格
								</td>
								<td class='dim_cell_content'>
									<select id="f1006" name="f1006" style="width: 200px">
										<option value="">请选择</option>
									</select> 
								</td>
							</tr>	
							<tr class='dim_row'>	
								<td class='dim_cell_title'>
									微网格
								</td>
								<td class='dim_cell_content'>
									<input type="text" id="wwg" size="27"> 
								</td>		
								<td class='dim_cell_title'>
									网格类型
								</td>
								<td class='dim_cell_content'>
									<select id="wglx" style="width: 200px">
										<option value="">全部</option>
										<option value="SPE">特征微网格</option>
										<option value="ADMIN">物理微网格</option>
										<option value="SA">SA</option>
									</select>
								</td>
								<td class='dim_cell_title'></td><td class='dim_cell_content'></td>
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
			<%
			if(!isProvince){
				%>
				<table align="center" width="97%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="新增" onclick="add()">
							&nbsp;
							<input type="button" class="form_button" value="修改" onClick="update()">
							&nbsp;							
							<input type="button" class="form_button" value="删除" onclick="del()">
							&nbsp;
						</td>
					</tr>
				</table>					
				<%
			}
			%>		
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
		alert("只能选择一项进行删除");
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=deleteGridMicroInfo&microgrid_id='+ids;
	document.forms(0).submit();
}

function add(){
	window.location = '/hbbass/grid/grid_micro_info_add.jsp';
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
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=getGridMicroInfo&microgrid_id='+ids;
	document.forms(0).submit();
}

window.onload=function(){
	<%
	if(isProvince){
		%>
		aihb.FormHelper.fillSelectWrapper({element:$('ds'),isHoldFirst:true,sql:"select area_code key,name value from nwh.bureau_tree where level = 1 with ur"})	
		<%
	}else{
		%>
		aihb.FormHelper.fillSelectWrapper({element:$('ds'),isHoldFirst:false,sql:"select area_code key,name value from nwh.bureau_tree where level = 1 and area_code ='<%=dmCityId%>' with ur"})	
		<%
	}
	%>
	if('<%=dmCityId%>' == '0'){//全省
		aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:true,sql:"select maingrid_id key,maingrid_name value from nmk.grid_main_info  order by 1 with ur"})
	}else{
		aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:true,sql:"select maingrid_id key,maingrid_name value from nmk.grid_main_info where city_id = '<%=dmCityId%>' order by 1 with ur"})
	}	
}

function areaCombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	var id = $('f1005').value;
	_elements.push($('f1005'));
	if($('f1006')){
		_elements.push($('f1006'));
		sqls.push("select subgrid_id key,subgrid_name value from nmk.grid_sub_info where maingrid_id = '#{value}' order by 1 with ur");
	}
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

if(<%=idPara%> && <%=idPara%> != ''){
	query();
}
</script>