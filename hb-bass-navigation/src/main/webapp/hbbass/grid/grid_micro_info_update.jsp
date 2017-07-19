<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
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

<%
	String[] gridMicroInfo = (String[])request.getAttribute("gridMicroInfo");
	if(gridMicroInfo == null){
		gridMicroInfo = new String[]{"","","","","","","","","","","","","","","","","","","",""};
	}
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>修改微网格</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
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
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									归属主网格
								</td>
								<td class="dim_cell_content">
									<select id="f1005" name="f1005" style="width: 306px" onchange="areaCombo(1);">
										<option value="">
											请选择
										</option>
									</select>
								</td>
								<td class="dim_cell_title" align="left">
									归属子网格
								</td>
								<td class="dim_cell_content">
									<select id="f1004" name="f1004" style="width: 306px" onchange="setSubId();">
										<option value="">
											请选择
										</option>
									</select>
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									微网格编码
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1001' value='<%=gridMicroInfo[0]%>'>
								</td>
								<td class="dim_cell_title" align="left">
									微网格名称
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1002' value='<%=gridMicroInfo[1]%>'>
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									微网格类型
								</td>
								<td class="dim_cell_content">
									<select id="f1003" name="f1003" style="width: 306px">
										<option value="SPE">
											特征微网格
										</option>
										<option value="ADMIN">
											物理微网格
										</option>
										<option value="SA">
											SA
										</option>
									</select>
								</td>
								<td class="dim_cell_title" align="left">
									地市编码
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1006' value='<%=gridMicroInfo[5]%>'>
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									负责客户经理编码
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1007' value='<%=gridMicroInfo[6]%>'>
								</td>
								<td class="dim_cell_title" align="left">
									负责客户经理姓名
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1008' value='<%=gridMicroInfo[7]%>'>
								</td>
							</tr>
							<tr class="dim_row" style="display: none">
								<td class="dim_cell_title" align="left">
									级别
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1009' value='<%=gridMicroInfo[8]%>' readonly='readlonly'>
								</td>
								<td class="dim_cell_title" align="left"></td>
								<td class="dim_cell_content"></td>
							</tr>
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
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=updateGridMicroInfo';
	document.forms(0).submit();
}

function renderSelect(sel,value){
	var obj = sel;
	var n = obj.options.length;
	for( var i = 0;i < n;i++){
		if(obj.options[i].value == value){
			obj.options[i].selected = true;
		}
	} 
}

function areaCombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	var id = $('f1005').value;
	_elements.push($('f1005'));
	if($('f1004')){
		_elements.push($('f1004'));
		sqls.push("select subgrid_id key,subgrid_name value from nmk.grid_sub_info where maingrid_id = '#{value}' order by 1 with ur");
	}
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

function setSubId(){
	var nextId = -1;
	var append ;
	//求出该类微网格序号最大的一条记录
	var sql = "select  int(substr(max(microgrid_id),14,16)) as nid  from nmk.grid_micro_info where maingrid_id = '"+$('f1005').value+ "' and subgrid_id = '"+$('f1004').value+"' order by 1 desc with ur";
	var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/jsondata"
			,parameters : "sql="+encodeURIComponent(sql)
			,loadmask : false
			,callback : function(xmlrequest){
				var list = eval(xmlrequest.responseText);
				if(list && list[0] && list[0].nid){
					nextId = list[0].nid;
					if(nextId != -1){
						append = (nextId + 1);
						//补足末尾为三位数字
						if(append < 10){
							append =  "00" + append;
						}else if(append < 100){
							append =  "0" + append;
						}else{
							append =  "" + append;
						}		
					}
					//根据所选的主网格、子网格编码设置微网码最新的一个编码	
					$('f1001').value = $('f1004').value + "." + append;
					if(!append || append == undefined){
						$('saveBtn').disabled = true;
					}
				}
			}
		});
		ajax.request();
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:true,sql:"select maingrid_id key,maingrid_name value from nmk.grid_main_info where city_id = '<%=dmCityId%>' order by 1 with ur"
		,callback:function(){
				aihb.FormHelper.fillSelectWrapper({element:$('f1004'),isHoldFirst:true,sql:"select subgrid_id key,subgrid_name value from nmk.grid_sub_info where maingrid_id = '<%=gridMicroInfo[4]%>' order by 1 with ur"
					,callback:function(){
						renderSelect($('f1003'),'<%=gridMicroInfo[2]%>');	
						renderSelect($('f1004'),'<%=gridMicroInfo[3]%>');	
						renderSelect($('f1005'),'<%=gridMicroInfo[4]%>');	
					}
				});
		}
	})
}
</script>