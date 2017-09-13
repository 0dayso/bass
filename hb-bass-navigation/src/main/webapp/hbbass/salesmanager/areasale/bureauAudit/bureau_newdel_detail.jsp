<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
String userid = (String)session.getAttribute("loginname");
String id = (String)request.getParameter("id");

Connection dwconn = null;
Connection webconn = null;
String region = null;
boolean isProvince = false;
String provinceOperatorCN = null;
String operatorCN = null;
boolean hasRight = false;
try{
	dwconn = ConnectionManage.getInstance().getDWConnection();
	
	String sql = "select b.site_id from BUREAU_CELL_NEWDEL_INFO a, dim_areacity b where a.AREA_ID = char(b.region) and a.NEWDELCELL_SEQ = "+id+"";
	PreparedStatement ps = dwconn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	String cityid = null;
	if(rs.next()){
		cityid = rs.getString(1);
		System.out.println("该记录的cityid："+cityid);
	}
	
	//如果cityid == 0 ，则是省公司用户，否则为地市用户
	if("0".equals(cityid)){
		isProvince = true;
	}else{
		isProvince = false;
	}
	
	webconn = ConnectionManage.getInstance().getWEBConnection();
	
	//求出省公司用户该谁审批
	sql = "select OPERATOR,b.username from FPF_AUDIT_FLOW a,FPF_USER_USER b  where a.cityid = '0' and a.operator = b.userid";
	ps = webconn.prepareStatement(sql);
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
	ps = webconn.prepareStatement(sql);
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
	if(dwconn!=null)
		dwconn.close();	
	if(webconn!=null)
		webconn.close();
}
%>	
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>基站新增、删除信息审核日志</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript"><!--

var _header=[
	{"name":"序列号","dataIndex":"c1"}
	,{"name":"审批类型","dataIndex":"c2"}
	,{"name":"审批结果","dataIndex":"c3"}
	,{"name":"审批时间","dataIndex":"c4"}
	,{"name":"审批人","dataIndex":"c5"}
];

function setId(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+str+"\">";
}



function genSQL(){
	var num = Math.random();	
	var	wherePiece = " where NEWDELCELL_SEQ = <%=id%>  and operate_type <> 'succ' ";
		
		var sql="select NEWDELCELL_SEQ c1, case when  operate_type='audit1' then '一级审核' when  operate_type='audit2' then '二级审核'  when  operate_type='audit3' then '三级审核' end c2, case  when  OPERATE_RESULT='succ' then '审核通过'  when  OPERATE_RESULT='fail' then '审核不通过'  end c3, substr(char(OPERATE_DATE),1,19) c4, (select username from FPF_USER_USER where userid=OPERATOR ) c5 from BUREAU_CELL_NEWDEL_AUDIT_LOG"
			+ wherePiece
			+ " and " + num + "=" + num	
			+ " order by c1 asc,c4 asc"
			+" with ur";
		//alert(sql);
		return sql;	
}

function query(){
	var grid = new aihb.SimpleGrid({
		header:_header
		,sql: genSQL()
		,pageSize : 10
	});
	grid.run();
	/*aihb.AjaxHelper.request({
		header:_header
		,url:"${mvcPath}/hbirs/action/jsondata?sql="+sql
	});*/
}

function down(){
	var _fileName=document.title;
	
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+genSQL()+"&fileName="+_fileName});
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
	--></script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<br>
			<div class="divinnerfieldset">
			<table><tr><td>此记录的审批流程：
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

