<%@page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>

<%
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>新增乡镇基本信息</title>
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
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="40%" align="center">地市</td>
								<td class="grid_row_cell" width="60%">
									<select id="f1001" name="f1001"  style="width: 300px" onchange="areaCombo(1)">
										<option value="">全部</option>
									</select>
								</td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">县市</td>
								<td class="grid_row_cell" >
									<select id="f1002" name="f1002" style="width: 300px" onchange="areaCombo(2)">
										<option value="">全部</option>
									</select>
								</td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">区域</td>
								<td class="grid_row_cell" >
									<select id="f1003" name="f1003" style="width: 300px" onchange="areaCombo(3)">
										<option value="">全部</option>
									</select>
								</td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">乡镇名称</td>
								<td class="grid_row_cell" >
									<select id="f1005" name="f1005" style="width: 300px" onchange="areaCombo(4)">
										<option value="">全部</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue" style="display: none">
								<td class="grid_title_blue" align="center">乡镇代码</td>
								<td class="grid_row_cell" >
									<input type="text" size="42" id="f1004" name="f1004">
								</td>
							</tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">是否属行政区    </td> <td class="grid_row_cell" > <input type="radio" size="42" name='f1006' value="1">是 <input type="radio" size="42" name='f1006' value="0">否</td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">总人口数        </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1007'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">农业人口数      </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1008'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">从业人口数      </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1009'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">外出务工人口数  </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1010'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">男性人口数      </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1011'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">总户数          </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1012'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">GDP           </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1013'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">宗教信仰        </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1014'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">重点支柱产业    </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1015'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">人均纯收入      </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1016'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">竞争对手渠道数量</td> <td class="grid_row_cell" > <input type="text" size="42" name='f1017'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">移动渠道数量    </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1018'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">移动手机普及率  </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1019'> </td> </tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">通信市场占有率  </td> <td class="grid_row_cell" > <input type="text" size="42" name='f1020'> </td> </tr>							
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
	if($('f1005').value == ""){
		alert('乡镇代码不能为空');
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/town?method=saveTownInfo';
	document.forms(0).submit();
}

function areaCombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	
	_elements.push($('f1001'));
	if($('f1002')){
		_elements.push($('f1002'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	if($('f1003')){
		_elements.push($('f1003'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	if($('f1005')){
		_elements.push($('f1005'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	if($('f1004')){
		$('f1004').value = $('f1005').value;
	}
	
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select id key,name value from nwh.bureau_tree where level = 1 with ur"})
}
</script>