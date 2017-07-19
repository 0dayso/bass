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
	String forUpdate = request.getParameter("forUpdate");
	String describle = request.getParameter("describle");
	Connection conn1 = null ;
	Connection conn2 = null ;
	PreparedStatement ps = null ;
	ResultSet  rs = null ;
	String[] strArr = null;
	int count = 0;
	String sql = "";
	Map map = new HashMap();
	List list = new ArrayList();
	try{
		conn1 = ConnectionManage.getInstance().getWEBConnection();
		sql = "select count(1) from fee_info_config with ur";
		ps = conn1.prepareStatement(sql);
		rs = ps.executeQuery();
		while(rs.next()){
			count = rs.getInt(1);
		}
		
		sql = "select field_code,field_name,field_remark from fee_info_config order by field_id asc with ur";
		ps = conn1.prepareStatement(sql);
		rs = ps.executeQuery();
		int i = 0;
		while(rs.next()){
			strArr = new String[4];
			strArr[0] = rs.getString("field_code");
			strArr[1] = rs.getString("field_name");
			strArr[3] = rs.getString("field_remark");
			map.put(strArr[0],strArr);
			list.add(strArr[0]);
			i++;
		}
		
		conn2 = ConnectionManage.getInstance().getDWConnection();
		if("true".equals(forUpdate)){
			sql = "update nmk.fee_info set describle = '" + describle + "' where fee_id = '"+fee_id+"'";
			ps = conn2.prepareStatement(sql);
			ps.execute();
		}
		
		sql = "select * from nmk.fee_info where fee_id = '"+fee_id+"' fetch first 1 rows only";
		ps = conn2.prepareStatement(sql);
		rs = ps.executeQuery();
		if(rs.next()){
			for(Iterator it = map.keySet().iterator();it.hasNext();){
				String key = (String)it.next();
				String[] arr = (String[])map.get(key);
				Object obj = rs.getObject(key);
				if(obj != null){
					arr[2] = obj.toString();
				}
				//map.put(strArr[0],arr);
			}
		}
	}catch(Exception e){ 
		e.printStackTrace();
	}finally{
	   if (rs != null)
	       rs.close();
	   if (ps != null)
	       ps.close();
	   if (conn1 != null){
	       conn1.close();
	   } 
	   if (conn2 != null){
	       conn2.close();
	   } 
	}
        
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>修改资费案信息</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
{"name":"资费标识","dataIndex":"c1"}
//,{"name":"资费费率类别","dataIndex":"c2"}
,{"name":"资费费率类别名称","dataIndex":"c3"}
,{"name":"资费费率值","dataIndex":"c4"}
,{"name":"资费优惠时长","dataIndex":"c5"}
,{"name":"资费优惠时长标识","dataIndex":"c10"}
,{"name":"资费优惠金额","dataIndex":"c6"}
,{"name":"资费优惠金额标识","dataIndex":"c11"}
,{"name":"月租费","dataIndex":"c7"}
,{"name":"保底消费","dataIndex":"c8"}
,{"name":"最高优惠","dataIndex":"c12"}
,{"name":"操作","dataIndex":"c9",cellFunc:"setId",cellStyle:"grid_row_cell"}
];

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	var code = options.data[options.rowIndex].c2;
	return "<input type='button' class='form_button_short' align='center' value='修改' onClick=update('"+id+"','"+code+"')>&nbsp;<input type='button' class='form_button_short' align='center' value='删除' onClick=del('"+id+"','"+code+"')>";
}

function genSQL(){
	var sql="select FEE_ID c1 ,FEE_RATE_TYPE c2 ,FEE_RATE_TYPE_NAME c3 ,FEE_RATES c4 ,FEE_DISCOUNT_DURA c5 ,FEE_DISCOUNT_CHARGE c6 ,RENT_CHARGE c7 ,MINIMUM_CHARGE c8,'' c9,case when dura_flag=1 then '包含在优惠中' else '不包含在优惠中' end c10,case when charge_flag=1 then '包含在优惠中' else '不包含在优惠中' end c11,maxmum_charge c12 from NWH.FEE_RATE_DISCOUNT_INFO where fee_id = '<%=fee_id%>' "; 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,isCached : false
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
	
	query();
}	

		</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<div class="divinnerfieldset" style="display: none">
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
									<input type="button" class="form_button" value="查询" onClick="query()">
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
				</td>
				</tr>
				</table>
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
					<div id="grid2" style="display: '';">
						<TABLE class=grid-tab-blue cellSpacing=1 cellPadding=0 width=99% align=center border=0>
							<TR class=grid_title_blue>
								<TD class=grid_title_cell>属性</TD>
								<TD class=grid_title_cell>值</TD>
								<TD class=grid_title_cell>备注</TD>
							</TR>				
							<%
							for(int i = 0 ;i<list.size();i++){
								String key = (String)list.get(i);
								String[] arr = (String[])map.get(key);
								if(arr[2] == null || "null".equals(arr[2])){
									arr[2] = "";
								}
								if(arr[3] == null || "null".equals(arr[3])){
									arr[3] = "";
								}
								%>
								<TR class=grid_row_blue>
									<TD class=grid_title_blue width="30%" align="center"><%=arr[1] %></TD>
									<TD class=grid_row_cell width="40%">
									<%
									if("资费描述".equals(arr[1])){
										%>
											<textarea rows="3" cols="80" id="fee_desc"><%=arr[2] %></textarea>
										<%
									}else{
										%>
											<%=arr[2] %>
										<%
									}
									%>
									</TD>
									<TD class=grid_row_cell width="30%"><%=arr[3] %></TD>
								</TR>						
								<%
							}
							%>
						</TABLE>
					</div>
					<div id="grid" style="display: '';">
					</div>				
				</fieldset>
				<br>
				<table align="center" width="97%">
					<tr class="dim_row_submit">
						<td align="center">
							<input type="button" class="form_button" value="新增费率" onclick="add()">
							&nbsp;
							<input type="button" class="form_button" value="保存" onclick="save()">
							&nbsp;	
						</td>
					</tr>
				</table>				
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

function add(){
	tabAdd({url:"/hbbass/fee/fee_info_add.jsp?fee_id=<%=fee_id%>",title:"新增资费"});
}

function update(feeId,typeCode){
	document.forms(0).action='/hbbass/fee/fee_info_type_add.jsp?fee_id='+feeId+'&fee_rate_type='+typeCode;
	document.forms(0).submit();
}

function del(feeId,typeCode){
	document.forms(0).action='${mvcPath}/hbirs/action/feeInfo?method=deleteFeeInfoType&fee_id='+feeId+'&fee_rate_type='+typeCode;
	document.forms(0).submit();
}

function save(){
	//alert($('fee_desc').value);
	document.forms(0).action="/hbbass/fee/fee_info_update.jsp?fee_id=<%=fee_id%>&forUpdate=true&describle="+$('fee_desc').value;
	document.forms(0).submit();
}
</script>