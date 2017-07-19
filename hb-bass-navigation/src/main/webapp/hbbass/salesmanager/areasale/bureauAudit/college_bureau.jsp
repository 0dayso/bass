<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
String userid = (String)session.getAttribute("loginname");
Connection conn = null;
String region = null;
boolean isProvince = false;
String provinceOperatorCN = null;
String operatorCN = null;
boolean hasRight = false;
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
	sql = "select OPERATOR,b.username from FPF_AUDIT_FLOW a,FPF_USER_USER b  where a.cityid = '"+cityid+"' and a.operator = b.userid";
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
		}
	}
	
	
	//求出该用户的areaid
	sql = "select b.itemid from FPF_USER_USER a,mk.dim_areacity b where char(a.cityid) = char(b.site_id) and userid='"+userid+"'";
	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();
	
	if(rs.next()){
		region = rs.getString(1);
		System.out.println("该用户的区域："+region);
	}

	if(isProvince){
		System.out.println("省审批流程为："+provinceOperator);
	}else{
		System.out.println("地市审批流程为："+operatorCN +"-->"+provinceOperatorCN);
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
		<title>高校新增、删除基站审核</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">

var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId"}
	,{"name":"序列号","dataIndex":"c1"}
	,{"name":"地市","dataIndex":"c2"}
	,{"name":"县域","dataIndex":"c2_2"}
	,{"name":"区域营销中心","dataIndex":"c2_3"}
	,{"name":"区域营销中心代码","dataIndex":"c2_4"}
	,{"name":"镇","dataIndex":"c2_5"}
	,{"name":"基站扇区","dataIndex":"c3"}
	,{"name":"高校ID","dataIndex":"c4"}
	,{"name":"基站扇区","dataIndex":"c5"}
	,{"name":"归属乡镇","dataIndex":"c6"}
	,{"name":"导入人员","dataIndex":"c7"}
	,{"name":"创建时间","dataIndex":"c8"}
	,{"name":"操作类型","dataIndex":"c9"}
	,{"name":"状态","dataIndex":"c10"}		
	,{"name":"状态时间","dataIndex":"c11"}
	//,{"name":"生效类型","dataIndex":"c12"}
];

function setId(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+str+"\">";
}



function genSQL(){
	var selType = $('selType').value;
	
	var num = Math.random();
	
	if("toDo" == selType){
		var wherePiece = " where 1=1 ";
		if($('OPERATE_TYPE').value != null && $('OPERATE_TYPE').value != ""){
			wherePiece += " and OPERATE_TYPE='"+$('OPERATE_TYPE').value+"'";
		}
		<%
		if(isProvince){//省
		%>
			wherePiece += " and (STATE='waitaudit2') ";
			if($('areaSel').value != 0){
				wherePiece += " and area_code = '"+$('areaSel').value+"' ";
			}
		<%	
		}else{//地市
		%>
			wherePiece += " and (STATE='waitaudit1') ";
			wherePiece += " and area_code = '<%=region%>' ";
		<%
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
		
		var sql="select '' c0,COLLEGEBUREAU_SEQ c1,(select dim.itemname from mk.dim_areacity dim where dim.itemid=area_code) c2,value((select COUNTY_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_2 ,value((select ZONE_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_3,value((select ZONE_CODE from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_4,value((select TOWN_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_5,BUREAU_ID c3,COLLEGE_ID c4,substr(char(CREATE_DATE),1,19) c8,case when operate_type='new' then '新增' when operate_type='del' then '删除' end c9,case when state='waitaudit1' then '待一级审核' when state='waitaudit2' then '待二级审核' when state='succ' then '审核通过'  when state='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from COLLEGE_BUREAU_INFO info "
			+ wherePiece
			+ " and " + num + "=" + num
			+ " order by c2"
			+" with ur";
			
		return sql;		
	}
	if("hasDone" == selType){
		var wherePiece = " and 1=1 ";
		if($('OPERATE_TYPE').value != null && $('OPERATE_TYPE').value != ""){
			wherePiece += " and a.OPERATE_TYPE='"+$('OPERATE_TYPE').value+"'";
		}
		if($('STATE').value != null && $('STATE').value != ""){
			wherePiece += " and a.STATE='"+$('STATE').value+"'";
		}
		<%
		if(isProvince){//省
		%>
			if($('areaSel').value != 0){
				wherePiece += " and a.area_code = '"+$('areaSel').value+"' ";
			}
		<%	
		}
		%>		
		
		var sql="select '' c0,a.COLLEGEBUREAU_SEQ c1,(select dim.itemname from mk.dim_areacity dim where dim.itemid=area_code) c2,value((select COUNTY_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = a.BUREAU_ID),'') c2_2 ,value((select ZONE_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = a.BUREAU_ID),'') c2_3,value((select ZONE_CODE from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = a.BUREAU_ID),'') c2_4,value((select TOWN_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = a.BUREAU_ID),'') c2_5,BUREAU_ID c3,COLLEGE_ID c4,substr(char(CREATE_DATE),1,19) c8,case when a.operate_type='new' then '新增' when a.operate_type='del' then '删除' end c9,case when state='waitaudit1' then '待一级审核' when state='waitaudit2' then '待二级审核' when state='succ' then '审核通过'  when state='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from COLLEGE_BUREAU_INFO a,COLLEGE_BUREAU_AUDIT_LOG b where a.COLLEGEBUREAU_SEQ = b.COLLEGEBUREAU_SEQ and b.OPERATOR = '<%=userid%>' "
			+ wherePiece
			+ " and " + num + "=" + num
			+ " order by c2"
			+" with ur";
			
		return sql;		
	}
	if("allRec" == selType){
		var wherePiece = " where 1=1 ";
		if($('OPERATE_TYPE').value != null && $('OPERATE_TYPE').value != ""){
			wherePiece += " and OPERATE_TYPE='"+$('OPERATE_TYPE').value+"'";
		}
		if($('STATE').value != null && $('STATE').value != ""){
			wherePiece += " and STATE='"+$('STATE').value+"'";
		}
		<%
		if(isProvince){//省
			%>
			if($('areaSel').value != 0){
				wherePiece += " and area_code = '"+$('areaSel').value+"' ";
			}			
			<%	
		}else{//地市
		%>
			wherePiece += " and area_code = '<%=region%>' ";
		<%
		}
		%>
		
		var sql="select '' c0,COLLEGEBUREAU_SEQ c1,(select dim.itemname from mk.dim_areacity dim where dim.itemid=area_code) c2,value((select COUNTY_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_2 ,value((select ZONE_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_3,value((select ZONE_CODE from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_4,value((select TOWN_NAME from NWH.DIM_BUREAU_CFG cfg where cfg.BUREAU_ID = info.BUREAU_ID),'') c2_5,BUREAU_ID c3,COLLEGE_ID c4,substr(char(CREATE_DATE),1,19) c8,case when operate_type='new' then '新增' when operate_type='del' then '删除' end c9,case when state='waitaudit1' then '待一级审核' when state='waitaudit2' then '待二级审核' when state='succ' then '审核通过'  when state='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from COLLEGE_BUREAU_INFO info "
			+ wherePiece
			+ " and " + num + "=" + num
			+ " order by c2"
			+" with ur";
			
		return sql;	
	}		
}

function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		//,pageSize : 10
	});
	grid.run();
	/*aihb.AjaxHelper.request({
		header:_header
		,url:"${mvcPath}/hbirs/action/jsondata?sql="+sql
	});*/
}

function down(){
	var _fileName=document.title;
	
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+encodeURIComponent(genSQL())+"&fileName="+encodeURIComponent(_fileName)});
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
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
							<tr class='dim_row'>
								<td class='dim_cell_title'>操作类型</td>
								<td class='dim_cell_content'><select id="OPERATE_TYPE"><option value="">全部</option><option value="new">新增</option><option value="del">删除</option></select></td>
								
								<%
								if(isProvince){
									%>
									<td class='dim_cell_title' id="area_td1">地市</td>
									<td class='dim_cell_content' id="area_td2">
									<select id="areaSel">
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
									<%
								}
								%>
								<td class='dim_cell_title' id="status_td1" style="display: none">状态</td>
								<td class='dim_cell_content' id="status_td2" style="display: none"><select id="STATE"><option value="">全部</option><option value="waitaudit1">待一级审核</option><option value="waitaudit2">待二级审核</option><option value="waitaudit3">待三级审核</option><option value="succ">审核通过</option><option value="fail">审核不通过</option></select></td>
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
				</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset">
			<table><tr><td>本地区的审批流程：
			<%			
			if(isProvince){
				%>
				<%= provinceOperatorCN%>
				<%
			}else{
				%>
				<%= operatorCN%> --> <%= provinceOperatorCN%>
				<%
			}
			%>
			</td></tr>
			</table>
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
								<td>全选<input type="checkbox" name="checkAllBox" onclick="selAll();"></td>
							</tr>
						</table>
					</legend>
		    		<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;margin-left: 6px" border=1>
					<tr height="21px" valign="top" style="padding-bottom:0px;padding-top:3px;WIDTH: 10%; border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:81A3F5">
						<td  class="tab" background=${mvcPath}/hbapp/resources/image/default/tab1.png onclick='changetab("toDo");'>&nbsp;待我审核</TD>
						<td  class="tab" background=${mvcPath}/hbapp/resources/image/default/tab2.png onclick='changetab("hasDone");'>我已审核</TD>
						<td  class="tab" background=${mvcPath}/hbapp/resources/image/default/tab2.png onclick='changetab("allRec");'>全部记录</TD>
						<input type="hidden" id="selType" value="toDo">
					</tr>
					</table>					
					<div id="grid" style="display: none;"></div>
				</fieldset>
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
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=collegeBureauNewdel"
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
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=collegeBureauNewdel"
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
		var obj=event.srcElement;
		while(obj.tagName!="TD") obj=obj.parentElement;
		var cellindex=obj.cellIndex;
		while(obj.tagName!="TABLE") obj=obj.parentElement;
		if(obj.lastcell) {obj.rows[0].cells[obj.lastcell].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab2.png)";}
		else{obj.rows[0].cells[0].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab2.png)";}
		obj.lastcell=cellindex;
		obj.rows[0].cells[cellindex].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab1.png)";
		
		$('selType').value = id;
		
		if("toDo" == id){
			if($('passbtn')){
				$('passbtn').style.display = "";
				$('failbtn').style.display = "";	
				$('eff_td1').style.display = "";
				$('eff_td2').style.display = "";		
			}

		}else{
			if($('passbtn')){
				$('passbtn').style.display = "none";
				$('failbtn').style.display = "none";
				$('eff_td1').style.display = "none";
				$('eff_td2').style.display = "none";				
			}
		}
		if("allRec" == id){
			if($('status_td1')){
				$('status_td1').style.display = "";
				$('status_td2').style.display = "";			
			}
		}else{
			if($('status_td1')){
				$('status_td1').style.display = "none";
				$('status_td2').style.display = "none";				
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
		var _url = "${mvcPath}/hbbass/salesmanager/areasale/bureauAudit/college_bureau_detail.jsp?id="+ids;
		tabAdd({url:_url,title:'日志'});
	}	
			
</script>
