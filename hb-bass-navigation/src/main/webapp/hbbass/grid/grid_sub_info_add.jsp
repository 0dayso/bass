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
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>新增子网格</title>
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
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">归属主网格                 </td><td class="grid_row_cell" >
								<select id="f1005" name="f1005" style="width: 306px" onchange="setSubId();">
									<option value="">请选择</option>
								</select> </td> 
							</tr> 							
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">子网格编码                     </td><td class="grid_row_cell" ><input type="text" size="42" name='f1001' readonly="readonly"></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">子网格名称                     </td><td class="grid_row_cell" ><input type="text" size="42" name='f1002'></td></tr>
							<tr class="grid_row_blue"> <td class="grid_title_blue" align="center">子网格类型</td> <td class="grid_row_cell" > 
								<select id="f1003" name="f1003" style="width: 306px">
									<option value="SPE">特征子网格</option>
									<option value="ADMIN">物理子网格</option>
									<option value="SA">SA</option>
								</select> </td> </tr>  
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">划分方式                       </td><td class="grid_row_cell" >
								<select id="f1004" name="f1004" style="width: 306px">
									<option value="REGION">区域营销中心划分</option>
									<option value="STREET">街道划分</option>
									<option value="OTHER">其它</option>
								</select> </td> </tr>  
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">地市编码                       </td><td class="grid_row_cell" ><input type="text" size="42" name='f1006'  value="<%=dmCityId %>" readonly="readonly"></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">网格特征描述                   </td><td class="grid_row_cell" ><input type="text" size="42" name='f1007'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖营业厅1（区域营销中心）编码</td><td class="grid_row_cell" ><input type="text" size="42" name='f1008'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">地址1                          </td><td class="grid_row_cell" ><input type="text" size="42" name='f1009'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖营业厅2（区域营销中心）编码</td><td class="grid_row_cell" ><input type="text" size="42" name='f1010'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">地址2                          </td><td class="grid_row_cell" ><input type="text" size="42" name='f1011'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖营业厅3（区域营销中心）编码</td><td class="grid_row_cell" ><input type="text" size="42" name='f1012'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">地址3                          </td><td class="grid_row_cell" ><input type="text" size="42" name='f1013'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖的街道                     </td><td class="grid_row_cell" ><input type="text" size="42" name='f1014'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖的街道路段                 </td><td class="grid_row_cell" ><input type="text" size="42" name='f1015'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">覆盖面积                       </td><td class="grid_row_cell" ><input type="text" size="42" name='f1016'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">子网格负责人姓名               </td><td class="grid_row_cell" ><input type="text" size="42" name='f1017'></td></tr>
							<tr class="grid_row_blue"><td class="grid_title_blue" align="center" width="40%">子网格负责人电话               </td><td class="grid_row_cell" ><input type="text" size="42" name='f1018'></td></tr>
							<tr class="grid_row_blue" style="display: none"><td class="grid_title_blue" align="center" width="40%">级别                           </td><td class="grid_row_cell" ><input type="text" size="42" name='f1019' value="4" readonly='readlonly'></td></tr>						
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" id="saveBtn" onclick="save()">
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
	if(el.flag == 0){
		el.src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
	}
	else{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}

function save(){
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=saveGridSubInfo';
	if(!$('f1005').value){
		alert("请先选择主网格");
		return
	}
	document.forms(0).submit();
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:true,sql:"select maingrid_id key,maingrid_name value from nmk.grid_main_info where city_id = '<%=dmCityId%>' order by 1 with ur"})
	
}

function setSubId(){
	var nextId = -1;
	var append ;
	//求出该类子网格序号最大的一条记录
	var sql = "select  int(substr(max(subgrid_id),10,12)) as nid  from nmk.grid_sub_info where maingrid_id = '"+$('f1005').value+"' order by 1 desc with ur";
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
					//根据所选的主网格编码设置子网码最新的一个编码	
					$('f1001').value = $('f1005').value + "." + append;
					if(!append || append == undefined){
						$('saveBtn').disabled = true;
					}
				}
			}
		});
		ajax.request();
}

</script>