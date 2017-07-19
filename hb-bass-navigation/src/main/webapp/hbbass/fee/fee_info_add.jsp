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
	//fee_id = "B1124";
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
		
		sql = "select field_code,field_name,field_remark,field_type,field_length from fee_info_config order by field_id asc with ur";
		ps = conn1.prepareStatement(sql);
		rs = ps.executeQuery();
		int i = 0;
		while(rs.next()){
			strArr = new String[6];
			strArr[0] = rs.getString("field_code");
			strArr[1] = rs.getString("field_name");
			strArr[3] = rs.getString("field_remark");
			strArr[4] = rs.getString("field_type");
			strArr[5] = rs.getString("field_length");
			map.put(strArr[0],strArr);
			list.add(strArr[0]);
			i++;
		}
		
		conn2 = ConnectionManage.getInstance().getDWConnection();
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
		<title>新增修改资费案信息</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[];

function genSQL(){
	var sql="select FEE_ID c1 ,FEE_NAME c2 ,a.REGION c3 ,a.AREA_CODE c4 ,PROD_TID c5 ,PROD_TNAME c6 ,DB_TID c7 ,DB_TNAME c8 ,TM_TID c9 ,TM_NAME c10,FEE_TYPE c11,EFF_DATE c12,EXP_DATE c13,NBILLING_TID c14,DESCRIBLE c15,TARGET_USER_DESC c16,FEE_SELLING_DESC c17,SEGMENT_RESTRICTIONS c18,CHANGE_NET_RESTRICTIONS c19,RENT_CHARGE c20,RENT_CHARGE_DESC c21,LDXS_CHARGE c22,LOCAL_AVG_RATES c23,LOCAL_ZJ_RATES c24,LOCAL_BJ_RATES c25,LOCAL_BUSY_RATES c26,LOCAL_SPARE_RATES c27,LONG_AVG_RATES c28,LONG_SN_RATES c29,LONG_SJ_RATES c30,LONG_GAT_RATES c31,LONG_GJ_RATES c32,ROAM_AVG_RATES c33,ROAM_SN_RATES c34,ROAM_SJ_RATES c35,ROAM_GAT_RATES c36,ROAM_GJ_RATES c37,IP_AVG_RATES c38,IP_SN_RATES c39,IP_SJ_RATES c40,IP_GAT_RATES c41,IP_GJ_RATES c42,SMS_RATES c43,SMM_RATES c44,GPRS_RATES c45,LOCAL_DURA c46,LONG_SN_DURA c47,LONG_SJ_DURA c48,LONG_GAT_DURA c49,LONG_GJ_DURA c50,ROAM_SN_DURA c51,ROAM_SJ_DURA c52,ROAM_GAT_DURA c53,ROAM_GJ_DURA c54,IP_SN_DURA c55,IP_SJ_DURA c56,IP_GAT_DURA c57,IP_GJ_DURA c58,SMS_COUNTS c59,MMS_COUNTS c60,GPRS_DURA c61,CANDIDATES_FLAG c62,RECOMMEND_FLAG c63,FEE_STATE c64,ETL_CYCLE_ID c65 from NMK.FEE_INFO a left join nmk.rep_area_region b on a.area_code=b.area_code where fee_id = '<%=fee_id%>' fetch first 1 rows only"; 
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
							<tr class="grid_title_blue">
								<td class="grid_title_cell">属性</td>
								<td class="grid_title_cell">值</td>
								<td class="grid_title_cell">备注</td>
								<!--  td class="grid_title_cell">字段类型</td-->
								<!--  td class="grid_title_cell">字段长度</td-->
							</tr>				
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
								<tr class="grid_row_blue">
									<td class="grid_title_blue" width="30%" align="center"><%=arr[1] %></td>
									<td class="grid_row_cell" width="30%"><%=arr[2] %></td>
									<input type="hidden" name="f<%=i %>" value="<%=arr[2] %>">
									<td class="grid_row_cell" width="20%"><%=arr[3] %></td>
									<!--td class="grid_row_cell" width="10%"><%=arr[4] %></td-->
									<!--td class="grid_row_cell" width="10%"><%=arr[5] %></td-->
								</tr>
								<%
							}
							%>
						</table>
						<table class="grid-tab-blue" cellspacing="1" cellpadding="0" width="99%" align="center" border="0">
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center" rowspan="2">资费费率类别名称</td>
								<td class="grid_title_blue" width="10%" align="center">源类型</td>
								<td class="grid_title_blue" width="10%" align="center">漫游类型</td>
								<td class="grid_title_blue" width="10%" align="center">呼叫类型</td>
								<td class="grid_title_blue" width="10%" align="center">IP标示</td>
								<td class="grid_title_blue" width="10%" align="center">网内外标示</td>
								<td class="grid_title_blue" width="10%" align="center">忙闲时标示</td>
								<td class="grid_title_blue" width="10%" align="center">话单类型</td>
							</tr>
							<tr class="grid_row_blue">
									<td align="center">
									<select id="t1" multiple="multiple" style="border: 0" onchange="changeType()">
										<option value='1'>语音    </option>
										<option value='7'>VPMN    </option>
										<option value='2'>短信    </option>
										<option value='3'>GPRS    </option>
										<option value='4'>移动梦网</option>
										<option value='5'>彩信    </option>
										<option value='6'>WLAN    </option>
									</select>
									</td>
									<td align="center">
									<select id="t2" multiple="multiple">
										<option value='0'> 本地       </option>
										<option value='1'> 省内漫游   </option>
										<option value='2'> 省际漫游   </option>
										<option value='3'> 港澳台漫游 </option>
										<option value='4'> 国际漫游   </option>
									</select>
									</td>
									<td align="center">
									<select id="t3" multiple="multiple">
										<option value='0'>  市话      </option>
										<option value='1'>  省内长途  </option>
										<option value='2'>  省际长途  </option>
										<option value='3'>  港澳台长途</option>
										<option value='4'>  国际长途  </option>
									</select>																		
									</td>
									<td align="center">
									<select id="t4" multiple="multiple">
										<option value='0'> 非IP</option>
										<option value='1'> IP17951  </option>
										<option value='2'> IP12593  </option>
									</select>
									</td>
									<td align="center">
									<select id="t5" multiple="multiple">
										<option value='0'> 网内</option>
										<option value='1'> 网外</option>
									</select>
									</td>
									<td align="center">
									<select id="t6" multiple="multiple">
										<option value='0'> 闲时  </option>
										<option value='1'> 忙时  </option>
									</select>
									</td>
									<td align="center">
									<select id="t7" multiple="multiple">
										<option value='0'> 主叫</option>
										<option value='T'> 被叫</option>
									</select>
									</td>
							</tr>
						</table>
						<table class="grid-tab-blue" cellspacing="1" cellpadding="0" width="99%" align="center" border="0">
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">资费费率类别编码</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1001"></td>
								<td class="grid_row_cell" width="20%"></td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>	
							<input type="hidden" name="f1002" />
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">资费费率值</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1003"></td>
								<td class="grid_row_cell" width="20%"></td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">资费优惠时长</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1004"></td>
								<td class="grid_row_cell" width="20%"><input type="checkbox" name="f1008">资费优惠时长标识</td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">资费优惠金额</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1005"></td>
								<td class="grid_row_cell" width="20%"><input type="checkbox" name="f1009">资费优惠金额标识</td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">月租费</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1006"></td>
								<td class="grid_row_cell" width="20%"></td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>	
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">保底消费</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1007"></td>
								<td class="grid_row_cell" width="20%"></td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="30%" align="center">最高优惠</td>
								<td class="grid_row_cell" width="30%"><input type="text" size="60" name="f1010"></td>
								<td class="grid_row_cell" width="20%"></td>
								<td class="grid_row_cell" width="10%"></td>
								<td class="grid_row_cell" width="10%"></td>
							</tr>	
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" onclick="save()">
									&nbsp;
									<input type="reset" class="form_button" value="清空" onclick="form1.reset();">
									&nbsp;
									<input type="reset" class="form_button" value="返回" onclick="history.back();">
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
	document.forms(0).action='${mvcPath}/hbirs/action/feeInfo?method=saveFeeInfoType';
	
	var v1 = "_";
	var v2 = "_";
	var v3 = "_";
	var v4 = "_";
	var v5 = "_";
	var v6 = "_";
	var v7 = "_";	
	
	if(document.getElementById('t1').value){v1 = document.getElementById('t1').value;};
	if(document.getElementById('t2').value){v2 = document.getElementById('t2').value;};
	if(document.getElementById('t3').value){v3 = document.getElementById('t3').value;};
	if(document.getElementById('t4').value){v4 = document.getElementById('t4').value;};
	if(document.getElementById('t5').value){v5 = document.getElementById('t5').value;};
	if(document.getElementById('t6').value){v6 = document.getElementById('t6').value;};
	if(document.getElementById('t7').value){v7 = document.getElementById('t7').value;};	
	
	var c1 = "";if(document.getElementById('t1').selectedIndex >= 0){c1 = document.getElementById('t1')[document.getElementById('t1').selectedIndex].innerText;};
	var c2 = "";if(document.getElementById('t2').selectedIndex >= 0){c2 = document.getElementById('t2')[document.getElementById('t2').selectedIndex].innerText;};
	var c3 = "";if(document.getElementById('t3').selectedIndex >= 0){c3 = document.getElementById('t3')[document.getElementById('t3').selectedIndex].innerText;};
	var c4 = "";if(document.getElementById('t4').selectedIndex >= 0){c4 = document.getElementById('t4')[document.getElementById('t4').selectedIndex].innerText;};
	var c5 = "";if(document.getElementById('t5').selectedIndex >= 0){c5 = document.getElementById('t5')[document.getElementById('t5').selectedIndex].innerText;};
	var c6 = "";if(document.getElementById('t6').selectedIndex >= 0){c6 = document.getElementById('t6')[document.getElementById('t6').selectedIndex].innerText;};
	var c7 = "";if(document.getElementById('t7').selectedIndex >= 0){c7 = document.getElementById('t7')[document.getElementById('t7').selectedIndex].innerText;};

	var code = v1+v2+v3+v4+v5+v6+v7;
	var name = c1+c2+c3+c4+c5+c6+c7;
	var type = $('t1').value;
	if(type == '3'){
		code = code.substr(0,1);
	}else if(type == '2' || type == '5'){
		code = code.substr(0,2);
	}else{
	}
	
	document.getElementsByName('f1001')[0].value = code;
	document.getElementsByName('f1002')[0].value = name;
	//alert(code);
	document.forms(0).submit();
}

function changeType(){
	var v = $('t1').value;
	if(v == '2'){
		clearSelect($('t2'));
		$('t2').options[0] = new Option('发往国际','1');
		$('t2').options[1] = new Option('发往国内','0');	
		clearLast5();
	}else if (v == '5'){
		clearSelect($('t2'));
		$('t2').options[0] = new Option('发往网内','0');
		$('t2').options[1] = new Option('发往网间','1');
		$('t2').options[2] = new Option('发往国际','2');		
		clearLast5();
	}else if (v == '3'){
		clearSelect($('t2'));
		clearLast5();
	}else{
		clearSelect($('t2'));
		$('t2').options[0] = new Option('本地','0');
		$('t2').options[1] = new Option('省内漫游','1');
		$('t2').options[2] = new Option('省际漫游','2');
		$('t2').options[3] = new Option('港澳台漫游','3');
		$('t2').options[4] = new Option('国际漫游','4');	
		
		restoreLast5();	
	}
}

function clearSelect(obj){
	var len = obj.options.length;
	for(var i = len; i>0; i--){
		obj.options[i-1] = null;
	}
}

function clearLast5(){
	clearSelect($('t3'));
	clearSelect($('t4'));
	clearSelect($('t5'));
	clearSelect($('t6'));
	clearSelect($('t7'));
}

function restoreLast5(){
	clearLast5();
	$('t3').options[0] = new Option('市话','0');
	$('t3').options[1] = new Option('省内长途','1');
	$('t3').options[2] = new Option('省际长途','2');
	$('t3').options[3] = new Option('港澳台长途','3');
	$('t3').options[4] = new Option('国际长途','4');	
	
	$('t4').options[0] = new Option('非IP','0');
	$('t4').options[1] = new Option('IP17951','1');
	$('t4').options[2] = new Option('IP12593','2');
	
	$('t5').options[0] = new Option('网内','0');
	$('t5').options[1] = new Option('网外','1');
	
	$('t6').options[0] = new Option('闲时','0');
	$('t6').options[1] = new Option('忙时','1');
	
	$('t7').options[0] = new Option('主叫','0');
	$('t7').options[1] = new Option('被叫','T');			
}
</script>