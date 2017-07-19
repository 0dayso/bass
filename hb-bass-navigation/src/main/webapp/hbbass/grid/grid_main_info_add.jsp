<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%
String userid = (String)session.getAttribute("loginname");
Connection conn = null;
Connection conn2 = null;
String cityId = null;
String cityName = null;
String dmCityId = null;
boolean isProvince = false;
String newCode = null;
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
	
	conn2 = ConnectionManage.getInstance().getDWConnection();
	sql = "select  int(substr(max(maingrid_id),7,8))  from nmk.grid_main_info where city_id = '"+dmCityId+"'order by 1 desc with ur";
	ps = conn2.prepareStatement(sql);
	rs = ps.executeQuery();
	if(rs.next()){
		newCode = rs.getString(1);
		if(newCode == null){
			newCode = "0";
		}
		int append = (Integer.valueOf(newCode).intValue() + 1);
		//补足末尾为两位数字
		if(append < 10){
			newCode = dmCityId + ".0" + append;
		}else{
			newCode = dmCityId + "." + append;
		}
	}
	rs.close();
	ps.close();
}catch ( SQLException e){
	e.printStackTrace();
}finally{
	if(conn!=null)
		conn.close();
	if(conn2!=null)
		conn2.close();
}
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>新增主网格</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[];

function genSQL(){
	var sql="" 
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
	
	//query();
}	
		</script>
	</head>
	<body>
		<form method="post" action="" name="form1">
			<input type="hidden" name="header">
			<div class="divinnerfieldset" style="display: none">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>
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
										</option>
									</select>
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onclick="query()">
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
				<td></td>
				<tr></tr>
				<table></table>
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>
									&nbsp;数据展现区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="grid" style="display: '';">
						<table class="grid-tab-blue" cellspacing="1" cellpadding="0" width="99%" align="center" border="0">
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center" width="40%">主网格编码</td> <td class="grid_row_cell" > <input type="text" size="42" name='f1001' value="<%=newCode %>" readonly="readonly"> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">主网格名称</td> <td class="grid_row_cell" > <input type="text" size="42" name='f1002'> </td> </tr>                                                                    
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">主网格类型</td> <td class="grid_row_cell" > 
								<select id="f1003" name="f1003" style="width: 306px" ">
										<option value="">全部</option>
										<option value="SPE">特征主网格</option>
										<option value="ADMIN">物理主网格</option>
								</select> </td> </tr>                                                                    
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">地市编码  </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1004' value="<%=dmCityId %>" readonly="readonly"> </td> </tr>                                                                    
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">地市      </td> 
								<td class="grid_row_cell" > 
									<input type="text" size="42" name='f1005' value="<%=cityName %>" readonly="readonly">
									<!-- select id="f1005"  style="width: 306px" onchange="setCityCode(this)">
										<option value="">全部</option>
									</select --> 
								</td> 
							</tr>                                                                    
							<tr class="grid_row_blue" style="display: none"> <td class="grid_title_blue" align="center">级别      </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1006' value="3" readonly="readonly" > </td> </tr>                                                                    
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">网格描述  </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1007'> </td> </tr>                                                                    
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" onclick="save()">
									&nbsp;
									<input type="button" class="form_button" value="返回" onclick="history.back();">
									&nbsp;
								</td>
							</tr>
						</table>						
					</div>				
				</fieldset>
				<br>
			</div>
			<br>
		</form>
	</body>
</html>
<script type="text/javascript">
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

function save(){
	if($('f1001').value == ""){
		alert('主网格编码不能为空');
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=saveGridMainInfo';
	document.forms(0).submit();
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:true,sql:"select area_code key,name value from nwh.bureau_tree where level = 1 with ur"})
}

function setCityCode(el){
	//alert(el.value);
	$('f1004').value = el.value;
}
</script>