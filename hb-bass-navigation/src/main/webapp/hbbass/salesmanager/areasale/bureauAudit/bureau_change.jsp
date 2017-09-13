<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
String userid = (String)session.getAttribute("loginname");
Connection conn = null;
String region = null;
String cityName="";
boolean isProvince = false;
String provinceOperatorCN = null;
String operatorCN = null;
boolean hasRight = false;
boolean _aduitFlag = true ;
Date currentDate = new Date();
		String formatString = "yyyy-MM-dd";
		SimpleDateFormat df = new SimpleDateFormat(formatString);
		String defaultDate =  df.format(currentDate);
try{
	conn = ConnectionManage.getInstance().getWEBConnection();
	
	String sql = "select cityid from FPF_USER_USER where userid='"+userid+"'";
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	String cityid = null;
	if(rs.next()){
		cityid = rs.getString(1);
		System.out.println("用户的cityid："+cityid);
	}
	
	//如果cityid == 0 ，则是省公司用户，否则为地市用户
	if("0".equals(cityid)){
		isProvince = true;
	}else{
		isProvince = false;
	}
	
	//求出省公司用户该谁审批
	sql = "select OPERATOR,b.username from FPF_AUDIT_FLOW a,FPF_USER_USER b  where a.cityid = '0' and a.operator = b.userid";
	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();
	String provinceOperator = null;
	provinceOperatorCN = null;
	if(rs.next()){
		provinceOperator = rs.getString(1);
		provinceOperatorCN = rs.getString(2);
		System.out.println("省公司用户该谁审批："+provinceOperatorCN);
		if(userid.equals(provinceOperator)){
			hasRight = true;
		}
	}

	
	//求出地市用户该谁审批
	//sql = "select OPERATOR,b.username from FPF_AUDIT_FLOW a,FPF_USER_USER b  where a.cityid = '"+cityid+"' and a.operator = b.userid";
	sql = "select OPERATOR,b.username,OPERATOR2,c.username op2username from FPF_AUDIT_FLOW a,FPF_USER_USER b,FPF_USER_USER c  where a.cityid = '"+cityid+"' and a.operator = b.userid and a.operator2 = c.userid" ;
	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();
	String operator = null;
	operatorCN = null;
		if(rs.next()){
		operator = rs.getString(1);
		operatorCN = rs.getString(2);
		System.out.println("此地区由谁审批："+operatorCN);
		if(userid.equals(operator)){
			hasRight = true;
			provinceOperatorCN = rs.getString("op2username");
			provinceOperator = rs.getString("OPERATOR2");
		}
		if (userid.equalsIgnoreCase(rs.getString("OPERATOR2"))){
		   hasRight = true;
		    operator = rs.getString("OPERATOR2");
		    operatorCN = rs.getString("op2username");
		    _aduitFlag = false ;
		}
	}
	
	
	//求出该用户的areaid
	sql = "select b.region,b.itemname from FPF_USER_USER a, dim_areacity b where char(a.cityid) = char(b.site_id) and userid='"+userid+"'";
	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();
	
	if(rs.next()){
		region = rs.getString(1);
		cityName = rs.getString(2);
		System.out.println("该用户的区域："+region);
	}

	if(isProvince){
		System.out.println("省审批流程为："+provinceOperator);
	}else{
		if (_aduitFlag == true){
		  System.out.println("地市一级审批流程为："+operatorCN +"-->"+provinceOperatorCN);
		}else{
		  System.out.println("地市二级审批流程为："+operatorCN +"-->"+provinceOperatorCN);
		}
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
		<title>基站归属变更审核</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript">

var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"序列号","dataIndex":"c1"}
	,{"name":"地市","dataIndex":"c2"}
	,{"name":"区域营销中心","dataIndex":"c21"}
	,{"name":"区域营销中心代码","dataIndex":"c31"}
	,{"name":"镇","dataIndex":"c22"}
	,{"name":"基站","dataIndex":"c23"}
	,{"name":"lac码","dataIndex":"c3"}
	,{"name":"cell码","dataIndex":"c4"}
	,{"name":"基站扇区","dataIndex":"c5"}
	,{"name":"变更类型","dataIndex":"c6"}
	,{"name":"原(父节点)值","dataIndex":"c7"}
	,{"name":"新(父节点)值","dataIndex":"c8"}
	,{"name":"创建人","dataIndex":"c9"}
	,{"name":"创建时间","dataIndex":"c9_2"}
	,{"name":"状态","dataIndex":"c10"}		
	,{"name":"状态时间","dataIndex":"c11"}
	//,{"name":"生效类型","dataIndex":"c12"}
];

function setId(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+str+"\">";
}
function getwhere(datefield){
var s = $('sdate1').value;
var d = $('sdate2').value;
  if (s == d){
     return '';
  }else{
  	 return ' and ' +datefield +'>=timestamp(\''+ s + ' 00:00:00\') and ' +datefield +'<=timestamp(\'' + d + ' 23:59:59\') ';
  }
}
function getwhereDate(datefield,obj1,obj2){
	var s = $(obj1).value;
	var d = $(obj2).value;
	  if (s == d){
	     return '';
	  }else{
	  	 return ' and ' +datefield +'>=timestamp(\''+ s + ' 00:00:00\') and ' +datefield +'<=timestamp(\'' + d + ' 23:59:59\') ';
	  }
}

function genSQL(){
	var selType = $('selType').value;
	
	var num = Math.random();
	
	if("toDo" == selType){
		var wherePiece = " where 1=1 ";
		if($('CHANG_TYPE').value != null && $('CHANG_TYPE').value != ""){
			wherePiece += " and CHANG_TYPE='"+$('CHANG_TYPE').value+"'";
		}
		<%
		if(isProvince){//省
		%>
			wherePiece += " and (STATUS='waitaudit3') ";
			if($('areaSel').value != 0){
				wherePiece += " and area_id = '"+$('areaSel').value+"' ";
			}
		<%	
		}else{//地市
		if (_aduitFlag == true){
		%>
			wherePiece += " and (STATUS='waitaudit1') ";
			wherePiece += " and area_id = '<%=region%>' ";
		<%
		}else {
		%>
			wherePiece += " and (STATUS='waitaudit2') ";
			wherePiece += " and area_id = '<%=region%>' ";
		<%
		}
		}
		%>
		<%
		if(hasRight){//当前用户为审批人
		%>
		<%	
		}else{//当前用户不是审批人
		%>
			wherePiece += " and 1=2";
		<%
		}
		%>		
		
		var sql="select '' c0, CHANGECELL_SEQ c1, (select dim.itemname from  dim_areacity dim where char(dim.region)=area_id) c2, LAC_DEC c3, CELLID_DEC c4, BUREAU_ID c5, case when CHANG_TYPE='ChangeCellName' then '基站名称变更' when CHANG_TYPE='ChangeCellTown' then '基站归属乡镇变更' end c6, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = OLD_VALUE) else OLD_VALUE end c7, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = NEW_VALUE) else NEW_VALUE end  c8, CREATEUSER c9,substr(char(CREATE_DATE),1,19) c9_2,  case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='waitaudit3' then '待三级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10, substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from BUREAU_CELL_CHANGE_INFO "
			+ wherePiece
			+ " and " + num + "=" + num
			+ getwhere('STATE_DATE') 
			+ getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c2"
			+" with ur";
			
		return sql;		
	}
	if("hasDone" == selType){
		var wherePiece = " and 1=1 ";
		if($('CHANG_TYPE').value != null && $('CHANG_TYPE').value != ""){
			wherePiece += " and a.CHANG_TYPE='"+$('CHANG_TYPE').value+"'";
		}
		if($('STATUS').value != null && $('STATUS').value != ""){
			wherePiece += " and a.STATUS='"+$('STATUS').value+"'";
		}
		<%
		if(isProvince){//省
		%>
			if($('areaSel').value != 0){
				wherePiece += " and a.area_id = '"+$('areaSel').value+"' ";
			}
		<%	
		}
		%>		
		
		var sql="select '' c0, a.CHANGECELL_SEQ c1, (select dim.itemname from  dim_areacity dim where char(dim.region)=area_id) c2, LAC_DEC c3, CELLID_DEC c4, BUREAU_ID c5, case when CHANG_TYPE='ChangeCellName' then '基站名称变更' when CHANG_TYPE='ChangeCellTown' then '基站归属乡镇变更' end c6, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = OLD_VALUE) else OLD_VALUE end c7, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = NEW_VALUE) else NEW_VALUE end  c8, CREATEUSER c9,substr(char(CREATE_DATE),1,19) c9_2,  case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='waitaudit3' then '待三级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10, substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from BUREAU_CELL_CHANGE_INFO a,BUREAU_CELL_CHANGE_AUDIT_LOG b where a.CHANGECELL_SEQ = b.CHANGECELL_SEQ and b.OPERATOR = '<%=userid%>' "
			+ wherePiece
			+ " and " + num + "=" + num
			+ getwhere('STATE_DATE') 
			+ getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c2"
			+" with ur";
			
		return sql;		
	}
	if("allRec" == selType){
		var wherePiece = " where 1=1 ";
		if($('CHANG_TYPE').value != null && $('CHANG_TYPE').value != ""){
			wherePiece += " and CHANG_TYPE='"+$('CHANG_TYPE').value+"'";
		}
		if($('STATUS').value != null && $('STATUS').value != ""){
			wherePiece += " and STATUS='"+$('STATUS').value+"'";
		}
		<%
		if(isProvince){//省
			%>
			if($('areaSel').value != 0){
				wherePiece += " and area_id = '"+$('areaSel').value+"' ";
			}			
			<%	
		}else{//地市
		%>
			wherePiece += " and area_id = '<%=region%>' ";
		<%
		}
		%>
		
		var sql="select '' c0, CHANGECELL_SEQ c1, (select dim.itemname from  dim_areacity dim where char(dim.region)=area_id) c2, LAC_DEC c3, CELLID_DEC c4, BUREAU_ID c5, case when CHANG_TYPE='ChangeCellName' then '基站名称变更' when CHANG_TYPE='ChangeCellTown' then '基站归属乡镇变更' end c6, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = OLD_VALUE) else OLD_VALUE end c7, case when CHANG_TYPE='ChangeCellTown' then (select name from  bureau_tree c where c.id = NEW_VALUE) else NEW_VALUE end  c8, CREATEUSER c9,substr(char(CREATE_DATE),1,19) c9_2,  case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='waitaudit3' then '待三级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10, substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 ,zone_name c21,zone_code c31,town_name c22,cell_name c23 from (select a.* ,b.zone_name,b.zone_code,town_name,cell_name from BUREAU_CELL_CHANGE_INFO a left join  dim_bureau_cfg b on a.LAC_DEC = b.lac_dec and a.cellid_dec = b.cellid_dec) tt  "
			+ wherePiece
			+ " and " + num + "=" + num
			+ getwhere('STATE_DATE') 
			+ getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c2, c31,c21,c22,c23"
			+" with ur";
			
		return sql;	
	}		
}

function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,limit:400
		,pageSize : 15
	});
	grid.run();
	/*aihb.AjaxHelper.request({
		header:_header
		,url:"${mvcPath}/hbirs/action/jsondata?sql="+sql
	});*/
}

//function down(){
//	var _fileName=document.title;
	
//	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+genSQL()+"&fileName="+_fileName});
//}

function down(){
		aihb.AjaxHelper.down({
			sql : genSQL()
			,header : _header
			,ds:"dw"
			,isCached : false
			,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
		});
	};
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
	
};
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
			<div class="widget widget-nopad">
			         <div class="widget-header">
					  <span class="icon"><i class="icon-align-justify"></i></span>
					   <h3>查询条件列表</h3>
					 </div>
					 <div class="widget-content">
					<div id="dim_div" style="margin: 16px 16px 6px;">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
							<tr class='dim_row'>
								<td class='dim_cell_title' id="times_start" >状态时间:</td>
								<td class='dim_cell_content' > 
									<input type="text" value='<%=defaultDate%>' id="sdate1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" size="12"/>
									至
									<input type="text" value='<%=defaultDate%>' id="sdate2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" size="12"/>
								</td>
								<td class='dim_cell_title' id="times_end" >创建时间:</td>
								<td class='dim_cell_content' > 
									<input type="text" value='<%=defaultDate%>' id="date3" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" size="12"/>
									至
									<input type="text" value='<%=defaultDate%>' id="date4" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" size="12"/>
								</td>
								<td class='dim_cell_title' id="something" style="display:none"></td>
								<td class='dim_cell_content' id="something1" style="display:none"></td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>操作类型</td>
								<td class='dim_cell_content'><select id="CHANG_TYPE"><option value="">全部</option><option value="ChangeCellTown" selected="selected">基站归属乡镇变更</option></select></td>
								<td class='dim_cell_title' id="area_td1">地市</td>
								<td class='dim_cell_content' id="area_td2">
								<select id="areaSel">
								<%
								if(isProvince){
									%>
										<option value='0' selected='selected'>全省</option>
										<option value='270'>武汉</option>
										<option value='714'>黄石</option>
										<option value='711'>鄂州</option>
										<option value='717'>宜昌</option>
										<option value='718'>恩施</option>
										<option value='719'>十堰</option>
										<option value='710'>襄樊</option>
										<option value='728'>江汉</option>
										<option value='715'>咸宁</option>
										<option value='716'>荆州</option>
										<option value='724'>荆门</option>
										<option value='722'>随州</option>
										<option value='713'>黄冈</option>
										<option value='712'>孝感</option>
										<option value='728'>潜江</option>
										<option value='728'>天门</option>
									<%
								}else{
									%>
									<option><%=cityName %></option>
									<%
								}
								%>
								</select>
								</td>
								<td class='dim_cell_title' id="status_td1" style="display: none">状态</td>
								<td class='dim_cell_content' id="status_td2" style="display: none"><select id="STATUS"><option value="">全部</option><option value="waitaudit1">待一级审核</option><option value="waitaudit2">待二级审核</option><option value="waitaudit3">待三级审核</option><option value="succ">审核通过</option><option value="fail">审核不通过</option></select></td>
							</tr>
							<tr style="display: none">
								<td class='dim_cell_title_wide' id="eff_td1">审批生效类型(非查询条件，仅供审批使用)</td>
								<td class='dim_cell_content' id="eff_td2" colspan="5"><select id="eff_type"><option value="">不更改</option><option value="0" selected="selected">立即生效</option><option value="1">下月生效</option></select></td>	
							</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onClick="query()">
									<input type="button" class="form_button" value="下载" onclick="down()">
									<input type="button" class="form_button" value="查看日志" onClick="viewDetail()" id="viewDetaibtn">
									<%
									if(hasRight){
									%>
									<input type="button" class="form_button" value="审批通过" onClick="pass()" id="passbtn">
									<input type="button" class="form_button" value="审批不通过" onClick="fail()" id="failbtn">
									<%	
									}
									%>
								</td>
							</tr>
						</table>
					</div>
			   </div>
			</div>
			<div class="widget widget-nopad">
			         <div class="widget-header">
					  <span class="icon"><i class="icon-align-justify"></i></span>
					   <h3>审批流程列表</h3>
					 </div>
			<div class="widget-content">
			<table style=" margin: 5px 27px 4px;">
			<tr><td>本地区的审批流程：
			<span style="color:red;font-size: 14px;">
			<%			
			if(isProvince){
				%>
				<%= provinceOperatorCN%>
				<%
			}else{
				%>
				<%= operatorCN%> ~~~> <%= provinceOperatorCN%>
				<%
			}
			%>
			</span>
			</td></tr>
			</table>
			</div>
			</div>
			<div class="widget widget-nopad">
			<div class="widget-header">
			 <span class="icon"><i class="icon-align-justify"></i></span>
			 <h3>数据展示列表</h3>
			</div>
			<div class="widget-content">
			    <div style=" margin: 9px 25px -5px;width: 100%;height: 4%;">
			         <span id="toDo" style="color: #47cd2e;cursor:pointer;font-size: 14px;" onclick='changetab("toDo")' class="color1 like">待我审核</span>
				     <span id="hasDone" style="color: #999999;cursor:pointer;font-size: 14px;"  onclick='changetab("hasDone")' class="color1">|我已审核</span>
					 <span id="allRec" style="color: #999999;cursor:pointer;font-size: 14px;" onclick='changetab("allRec")' class="color1">|全部记录</span>
				     <input type="hidden" id="selType" value="toDo">
				</div>
				<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;margin-left: 6px" border=1>
			 </table>
			 <div id="grid" style="display: none;"></div>
			</div>
			<br>				
					<div id="grid" style="display: none;"></div>
			</div>
			<br>
		</form>
	</body>
</html>


<script type="text/javascript">
	function pass(){
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
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauChange"
			,parameters : "ids="+ids+"&result=succ&eff_type="+document.getElementById("eff_type").value
			,callback : function(xmlrequest){
				query();
				//alert(xmlrequest);
			}
		});
		_ajax.request();
	}
	
	function fail(){
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
		
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauChange"
			,parameters : "ids="+ids+"&result=fail&eff_type="+document.getElementById("eff_type").value
			,callback : function(xmlrequest){
				query();
				//alert(xmlrequest);
			}
		});
		_ajax.request();	
	}	

	/**  
	 * 全选
	 */	
	function selAll(){
		var sel = document.getElementsByName('checkAllBox')[0].checked;
		var n = document.getElementsByName('cbox').length;
		if(sel == true){
			for(var i = 0;i<n;i++){
				document.getElementsByName('cbox')[i].checked = true;
			}			
		}else{
			for(var i = 0;i<n;i++){
				document.getElementsByName('cbox')[i].checked = false;
			}			
		}
	}

	
	function changetab(id){
		if("toDo"==id){
			$('toDo').style.color="#47cd2e";
			$('hasDone').style.color="#999999";
			$('allRec').style.color="#999999";
		}else if("hasDone"==id){
			$('toDo').style.color="#999999";
			$('hasDone').style.color="#47cd2e";
			$('allRec').style.color="#999999";
		}else if("allRec" == id){
			$('toDo').style.color="#999999";
			$('hasDone').style.color="#999999";
			$('allRec').style.color="#47cd2e";
		}
		$('selType').value = id;
		
		if("toDo" == id){
			if($('passbtn')){
				$('passbtn').style.display = "";
				$('failbtn').style.display = "";
			}
			$('STATUS').disabled=true;
		}else{
			if($('passbtn')){
				$('passbtn').style.display = "none";
				$('failbtn').style.display = "none";
			}
		}
		if("allRec" == id){
			if($('status_td1')){
				$('status_td1').style.display = "";
				$('status_td2').style.display = "";	
				$('something').style.display="";
				$('something1').style.display="";
				$('something').style.display="";
				$('something1').style.display="";
			}
		}else{
			if($('status_td1')){
				$('status_td1').style.display = "none";
				$('status_td2').style.display = "none";				
				$('something').style.display="none";
				$('something1').style.display="none";
			}
		}
		query();
	}
	
	function viewDetail(id){
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
			alert("只能选择一项查看日志");
			return;
		}
		var _url = "${mvcPath}/hbbass/salesmanager/areasale/bureauAudit/bureau_change_detail.jsp?id="+ids;
		tabAdd({url:_url,title:'日志'});
	}	
			
</script>
