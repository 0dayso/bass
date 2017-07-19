<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%
	String fee_id = request.getParameter("fee_id");
	String fee_rate_type = request.getParameter("fee_rate_type");
	Connection conn2 = null ;
	PreparedStatement ps = null ;
	ResultSet  rs = null ;
	String[] strArr = new String[9];
	int count = 0;
	String sql = "";
	Map map = new HashMap();
	List list = new ArrayList();
	try{
		conn2 = ConnectionManage.getInstance().getDWConnection();
		sql = "select fee_id,fee_rate_type,fee_rate_type_name,fee_rates,fee_discount_dura,fee_discount_charge,rent_charge,minimum_charge,maxmum_charge from nwh.fee_rate_discount_info where fee_id = '"+fee_id+"' and fee_rate_type='"+fee_rate_type+"' with ur ";
		ps = conn2.prepareStatement(sql);
		rs = ps.executeQuery();
		while(rs.next()){
			for(int i=0;i<9;i++){
				Object obj = rs.getObject(i+1);
				if(obj != null){
					strArr[i] = obj.toString();
				}else{
					strArr[i] = "";
				}
			}
		}
	}catch(Exception e){ 
		e.printStackTrace();
	}finally{
	   if (rs != null)
	       rs.close();
	   if (ps != null)
	       ps.close();
	   if (conn2 != null){
	       conn2.close();
	   } 
	}
        
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>资费档案修改</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	 {"name":"字段代码","dataIndex":"c1"}
	,{"name":"字段名称","dataIndex":"c2"}
	,{"name":"字段类型","dataIndex":"c3"}
	,{"name":"字段长度","dataIndex":"c4"}
	,{"name":"字段类别","dataIndex":"c5"}
	,{"name":"字段定义","dataIndex":"c6"}
	,{"name":"备注","dataIndex":"c7"}
];

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}

function genSQL(){
	var sql="select FIELD_CODE c1,FIELD_NAME c2,FIELD_TYPE c3,FIELD_LENGTH c4,FIELD_CATEGORY c5,FIELD_MEAN c6,FIELD_REMARK c7 from FEE_INFO_CONFIG order by FIELD_ID asc "; 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,ds : "web"
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
}	
		</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<br>
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
					<div id="grid" style="display: '';">
						<TABLE class=grid-tab-blue cellSpacing=1 cellPadding=0 width=99% align=center border=0>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费标识</TD>
								<TD class=grid_row_cell width="50%"><%=strArr[0] %><input type="hidden" name="f0" value=<%=strArr[0] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>							
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费费率类别</TD>
								<TD class=grid_row_cell width="30%"><%=strArr[1] %><input type="hidden" name="f1001" value=<%=strArr[1] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费费率类别名称</TD>
								<TD class=grid_row_cell width="30%"><%=strArr[2] %><input type="hidden" name="f1002" value=<%=strArr[2] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>	
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费费率值</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1003" value=<%=strArr[3] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>	

							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费优惠时长</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1004" value=<%=strArr[4] %>></TD>
								<TD class=grid_row_cell><input type="checkbox" name="f1008">资费优惠时长标识</TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">资费优惠金额</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1005" value=<%=strArr[5] %>></TD>
								<TD class=grid_row_cell><input type="checkbox" name="f1009">资费优惠金额标识</TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">月租费</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1006" value=<%=strArr[6] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">保底消费</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1007" value=<%=strArr[7] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">最高优惠</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60" name="f1010" value=<%=strArr[8] %>></TD>
								<TD class=grid_row_cell></TD>
							</TR>											
						</TABLE>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" onclick="save()">
									&nbsp;
								</td>
							</tr>
						</table>						
					</div>		
				</fieldset>
			</div>
			<br>
		</form>
	</body>
</html>
<script>
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
	document.forms(0).action='${mvcPath}/hbirs/action/feeInfo?method=saveFeeInfoType';
	document.forms(0).submit();
}
</script>