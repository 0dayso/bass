<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>区域化高校审核人配置</title>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<%
			String userid = (String) session.getAttribute("loginname");
		%>
		<script type="text/javascript">
		function init(){
		}
		
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"地市","dataIndex":"c1"}
	,{"name":"地市ID","dataIndex":"c1_1"}
	,{"name":"一级审核人","dataIndex":"c2"}
	,{"name":"二级审核人","dataIndex":"c3"}
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
	var id = options.data[options.rowIndex].c1_2;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}


function genSQL(){
var wherePart = " where 1 = 1 ";
var city = $('f1001').value;
if(city){
	wherePart += "and cityid='"+city+"'";
}
		
var sql= sql= "select '' c0,value((select new_code from mk.bt_area where char(area_id)=cityid),0) c1_1,cityid c1_2, CITYNAME c1, value((select username||' ['||u.userid||']'||' ['||mobilephone||']' from fpf_user_user u where u.userid=OPERATOR),'') c2, value((select username||' ['||userid||']'||' ['||mobilephone||']' from fpf_user_user where userid=OPERATOR2),'') c3 from AUDIT_COLLEGE_CFG"
		+ wherePart
		+" order by c1,c2,c3 "
aihb.AjaxHelper.parseCondition()
		+" with ur ";
	//alert(sql);
	//document.write(sql);
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,ds : 'web'
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
								<td onclick="hideTitle(this.childNodes[0],'dim_div')"
									title="点击隐藏">
									<img flag='1'
										src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align='center' width='99%' class='grid-tab-blue'
							cellspacing='1' cellpadding='0' border='0' style="display: ''">
							<tr class='dim_row'>
								<td class=''>
									地市
								</td>
								<td class=''>
									<select id="f1001" name="f1001" style="width: 200px"
										onchange="selCity()">
										<option value="">
											请选择
										</option>
									</select>
								</td>
								<td>
									<input type="button" class="form_button" value="查询"
										onClick="query()">
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<table id="updateShow" align="center" width="97%" style="display: 'none'">
				<tr class="dim_row_submit">
					<td>
						<div style="color:red">
							如需修改，请联系毛文俊、苏胜!
						</div>
					</td>
				</tr>
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="修改"
							onClick="update()">
					</td>
				</tr>
			</table>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1'
										src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
	
	document.forms[0].action='${mvcPath}/hbapp/college/audit_college_cfg_update.jsp?city='+ids;
	document.forms[0].submit();
}


window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select area_id key,area_name value from mk.bt_area with ur"});
	var userName = '<%=userid%>';
	if("susheng" == userName || "maowenjun" == userName || "zhangwei" == userName || "wanchun" == userName || "zhangtao" == userName){
		document.getElementById('updateShow').style.display = '';
	}
};

function selCity(){
	
}
</script>