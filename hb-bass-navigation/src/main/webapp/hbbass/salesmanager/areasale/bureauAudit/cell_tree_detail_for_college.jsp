<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page  import="java.util.ArrayList,java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
	String whereContent = (String) request.getParameter("whereContent");

%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>基站信息明细</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<style type="text/css">
			.aw1{
				width:10px;
				aligh:center
			}
			.aw2{
				width:50px
			}
		</style>
		<script type="text/javascript">

var _header=[
    
	{"name":"选择","dataIndex":"c0",cellFunc:"setId"}
	,{"name":"地市","dataIndex":"c1"}
	,{"name":"县域","dataIndex":"c2"}
	,{"name":"区域营销中心","dataIndex":"c3"}
	,{"name":"区域中心代码","dataIndex":"c23"}
	,{"name":"镇","dataIndex":"c4"}
	,{"name":"镇唯一码","dataIndex":"c4_1"}
	,{"name":"基站名称","dataIndex":"c0_2"}
	,{"name":"基站编码","dataIndex":"c0_1"}
	,{"name":"配置高校","dataIndex":"c17"}
	//,{"name":"lac码十进制","dataIndex":"c5"}
	//,{"name":"cell码十进制","dataIndex":"c6"}
	,{"name":"生效日期","dataIndex":"c7"}
	//,{"name":"覆盖类别","dataIndex":"c8"}
	//,{"name":"村村通小区","dataIndex":"c9"}
	//,{"name":"商业区","dataIndex":"c10"}
	//,{"name":"星级酒店","dataIndex":"c11"}
	//,{"name":"高级写字楼","dataIndex":"c12"}
	//,{"name":"居民小区","dataIndex":"c13"}
	//,{"name":"地形","dataIndex":"c14"}
	,{"name":"营业厅名称","dataIndex":"c15"}
	//,{"name":"创建日期","dataIndex":"c16"}
];
		
function setId(dataIndex,options){
	var str = options.data[options.rowIndex].c0_1;
	var checkstr = options.data[options.rowIndex].c17;
	if(checkstr == " 未配置"){
		return "<input type='checkbox' name='cbox' onclick='checkId()' value=\""+str+"\">";
	}else{
		return "";
	}
}
function checkId(){
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
	return ids;
}
function genSQL(){
  var sql = "";
  var s_area_id = document.getElementById("s_area_id").value;
	var s_zone_id = document.getElementById("s_zone_id").value;
	var s_town_id = document.getElementById("s_town_id").value;
	/**if (s_area_id == "" && s_zone_id =="" && s_town_id == ""){
	 sql="select '' c0,area_name c1,county_name c2,zone_name c3,zone_code c23,town_name c4,town_code c4_1,bureau_id c0_1,bureau_name c0_2,lac_dec c5 , cellid_dec c6 ,eff_date c7 ,case when cover_type = '1' then '城市' when cover_type = '2' then '县城' when cover_type = '3' then '市辖农村' when cover_type = '4' then '县辖农村'  end c8 ,case when village_connect_flag = '0' then '非村村通小区' else '村村通小区' end c9 ,case when cover_business = 1 then '是' else '否' end c10 , case when cover_hotel = 1 then '是' else '否' end c11 , case when cover_office = 1 then '是' else '否' end c12 , case when cover_resident = 1 then '是' else '否' end c13 , case when terrain = 0 then '平原' when terrain = 1 then '山区' when terrain = 2 then '丘陵' end c14 ,business_hall_name c15 ,bass_create_date c16  from NWH.DIM_BUREAU_CFG "
		+ " where 1=1 "
		+ " and " + "<%=whereContent%>"
		+ " and " + num + "=" + num
		+ " order by c1,c2,c3,c4,c6"
		+" with ur";
	}else{**/
		sql="select '' c0,area_name c1,county_name c2,zone_name c3,zone_code c23,town_name c4,town_code c4_1,a.bureau_id c0_1,bureau_name c0_2,value(b.college_name,' 未配置') c17 ,lac_dec c5 , cellid_dec c6 , business_hall_name c15 ,bass_create_date c16 from nwh.dim_bureau_cfg a left join ( select n.bureau_id,m.college_id, m.college_name from nwh.college_info m,COLLEGE_BUREAU_INFO n where m.college_id=n.college_id) b on a.bureau_id = b.bureau_id where 1=1 ";
		sql += " and " + "<%=whereContent%>";		
		if (s_area_id!=''){
			 sql += (" and ucase(county_name) like '%"+s_area_id.toUpperCase()+"%' ");
		   }
			if (s_zone_id!=''){
				 sql += (" and ucase(zone_name) like '%"+s_zone_id.toUpperCase()+"%' ");
			}
			if (s_town_id!=''){
				 sql += (" and ucase(town_name) like '%"+s_town_id.toUpperCase()+"%' ");
			}
	   sql += " order by c1,c2,c3,c4,c6 with ur" ;
	//}
	return sql;	
}

function query(){
		
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,limit:400
		,pageSize : 200
		,isCached : false
	});
	grid.run();
	/*aihb.AjaxHelper.request({
		header:_header
		,url:"${mvcPath}/hbirs/action/jsondata?sql="+sql
	});*/
	//document.getElementById("grid").child[0].width='99%';
}

function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+genSQL()+"&fileKind=excel&fileName="+_fileName});
}

aihb.Util.loadmask();

window.onload=function(){
	var _d=new Date();
	_d.setDate(_d.getDate()-1);
	
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
	
	query();
}
</script>
		<style>
.dim_cell_title_wide {
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width: 20%;
	background-color: #D9ECF6;
}
</style>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<div class="divinnerfieldset" style="width: 99%">
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
								<td class='dim_cell_title'>县(模糊)</td>
								<td class='dim_cell_content'><input type="text" id="s_area_id" name="s_area_id"></td>
								<td class='dim_cell_title' id="zone_td1">区中心(模糊)</td>
								<td class='dim_cell_content' id="zone_td2">
									<input type="text" id="s_zone_id" name="s_zone_id">
								</td>
								<td class='dim_cell_title' id="status_td1" >镇(模糊)</td>
								<td class='dim_cell_content' id="status_td2" ><input type="text" name="s_town_id" id="s_town_id"></td>
								</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onClick="query()">
									<input type="hidden" value="111" id="myid">
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset" style="width: 99%">
					<div id="grid" style=" width='99%';display: none;"></div>
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
</script>
