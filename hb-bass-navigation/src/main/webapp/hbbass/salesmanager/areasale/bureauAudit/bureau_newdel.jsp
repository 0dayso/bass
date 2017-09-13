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
	//sql = "select OPERATOR,b.username,OPERATOR2,(SELECT C.USERNAME FORM FPF_USER_USER C WHERE A.OPERATOR2=C.USERID ) from FPF_AUDIT_FLOW a,FPF_USER_USER b  where a.cityid = '"+cityid+"' and a.operator = b.userid";
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
	sql = "select b.region_new,b.itemname from FPF_USER_USER a,dim_areacity b where char(a.cityid) = char(b.site_id) and userid='"+userid+"'";
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
		<title>基站新增、删除审核</title>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
		<!--  <link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/xtheme-slate.css" />  -->
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
        <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
        <link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/xtheme-gray.css" />
    <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript">

var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"流水号","dataIndex":"c1"}
	,{"name":"地市码","dataIndex":"c2_1"}
	,{"name":"地市","dataIndex":"c2"}
	,{"name":"区域营销中心","dataIndex":"c21"}
	,{"name":"区域营销中心代码","dataIndex":"c31"}
	//,{"name":"镇","dataIndex":"c22"}
	//,{"name":"基站","dataIndex":"c23"}
	,{"name":"县/营业部编码","dataIndex":"c6_1_1"}
	,{"name":"县/营业部名称","dataIndex":"c6_1_2"}
	,{"name":"营销中心编码","dataIndex":"c6_1_3"}
	,{"name":"营销中心名称","dataIndex":"c6_1_4"}
	,{"name":"乡镇/街道名","dataIndex":"c6_1"}
	,{"name":"乡镇/街道唯一码","dataIndex":"c6"}
	,{"name":"lac码","dataIndex":"c3"}
	,{"name":"cell码","dataIndex":"c4"}
	,{"name":"基站码","dataIndex":"c5"}
	,{"name":"基站名称","dataIndex":"c5_1"}
	,{"name":"导入人员","dataIndex":"c7"}
	,{"name":"创建时间","dataIndex":"c8"}
	//,{"name":"是否为高校","dataIndex":"c0_1",cellFunc:"setUniversity",cellStyle:"grid_row_cell"}
	,{"name":"归属高校名称","dataIndex":"c12_1",cellFunc:"setNullValue",cellStyle:"grid_row_cell"}
	,{"name":"操作类型","dataIndex":"c9"}
	,{"name":"状态","dataIndex":"c10"}		
	,{"name":"状态时间","dataIndex":"c11"}
	//,{"name":"生效类型","dataIndex":"c12"}
];
var _select_id ='';
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
function selcetUniversity(strID){
    //alert(strID);
    var n = document.getElementsByName('cbox').length;
    for (var i=0;i<n;i++){
            if (document.getElementsByName('cbox')[i].value == strID ){
                document.getElementsByName('cbox')[i].checked = true ;
                break ;
            }
        }
    
    if (document.getElementsByName('U_'+strID)[0].checked){
         if(_select_id == ""){
					_select_id += strID;
				}else{
					_select_id += "," + strID;
				}
    }else{
        _select_id = _select_id.replace(','+strID,'');
        _select_id = _select_id.replace(strID,'');
    }
   // alert(_select_id);
}
function setUniversity(dataIndex,options){
	var str = "U_" + options.data[options.rowIndex].c1 ;
	//return "<input type='checkbox' name='cbox' value=\""+str+"\">";
	
	//var _ipt=$C("input");
	//_ipt.type="radio";
	//_ipt.name= "'"+str+"'";
	//_ipt.id = "'"+str+"'";
	//_ipt.value="'YES'";
	var _ipt = "<input type='radio' id='"+str+"' name='"+str+"' onclick=\"selcetUniversity('"+options.data[options.rowIndex].c1+"')\" value='是'>是</input>";
	_ipt +=("<input type='radio' id='"+str+"' onclick=\"selcetUniversity('"+options.data[options.rowIndex].c1+"')\" name='"+str+"' value='否' checked  >否</input>");
	if (options.data[options.rowIndex].c9=='删除'){
	   return '';
	}
	
	return _ipt;
}
function setNullValue(dataIndex,options){
	var str = options.data[options.rowIndex].c12_1;
	if (str == null)
	   str = '';
	return str;

}
function setId(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+str+"\">";
	
	//var _ipt=$C("input");
	//_ipt.type="checkbox";
	//_ipt.name="cbox";
	//_ipt.value=str;
	
	//_ipt.onclick=function(){
	//	var record = options.record;
		
	//}
	
	//return _ipt;
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
			//wherePiece += " and 1=2";
			wherePiece += " and 1=2";
		<%
		}
		%>		
		
		//var sql="select '' c0,'' c0_1,newdelcell_seq c1,area_id c2_1,(select dim.itemname from  dim_areacity dim where char(dim.region)=area_id) c2,LAC_DEC c3,CELLID_DEC c4,Bureau_ID c5,bureau_name c5_1,(select A.name from  bureau_tree A where A.ID=town_code) c6_1,(select B.county_code  from  vdim_bureau_tree B where B.town_code=F.town_code) c6_1_1,(select B.COUNTY_NAME  from  vdim_bureau_tree B where B.town_code=F.town_code) c6_1_2,(select B.ZONE_CODE  from  vdim_bureau_tree B where B.town_code=F.town_code) c6_1_3,(select B.ZONE_NAME  from  vdim_bureau_tree B where B.town_code=F.town_code) c6_1_4,town_code c6,createuser c7,substr(char(CREATE_DATE),1,19) c8,case when operate_type='new' then '新增' when operate_type='del' then '删除' end c9,case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='waitaudit3' then '待三级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from BUREAU_CELL_NEWDEL_INFO F "
		var sql="select '' c0,'' c0_1,newdelcell_seq c1,area_id c2_1,(select dim.itemname from dim_areacity dim where char(dim.region_new)=area_id) c2,LAC_DEC c3,CELLID_DEC c4,Bureau_ID c5,bureau_name c5_1,(select A.name from bureau_tree A where A.ID=town_code) c6_1,(select B.county_code  from  vdim_bureau_tree B where B.town_code=F.town_code) c6_1_1,(select B.COUNTY_NAME  from vdim_bureau_tree B where B.town_code=F.town_code) c6_1_2,(select B.ZONE_CODE  from vdim_bureau_tree B where B.town_code=F.town_code) c6_1_3,(select B.zone_name  from vdim_bureau_tree B where B.town_code=F.town_code) c6_1_4,town_code c6,createuser c7,substr(char(CREATE_DATE),1,19) c8,case when operate_type='new' then '新增' when operate_type='del' then '删除' end c9,case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='waitaudit3' then '待三级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12,(select A.college_name from BUREAU_COLLEGE_ORINFO A where A.newdelcell_seq=F.newdelcell_seq  and A.state_time = (select max(B.state_time) from BUREAU_COLLEGE_ORINFO B where B.newdelcell_seq=F.newdelcell_seq)) C12_1 from BUREAU_CELL_NEWDEL_INFO F "
			+ wherePiece
		  + getwhere('STATE_DATE')
		  + getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c6_1,c6_1_4,c6_1_2 "
			+" with ur";
		return sql;		
	}
	if("hasDone" == selType){
		var wherePiece = " and 1=1 ";
		if($('OPERATE_TYPE').value != null && $('OPERATE_TYPE').value != ""){
			wherePiece += " and a.OPERATE_TYPE='"+$('OPERATE_TYPE').value+"'";
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
		
		var sql="select '' c0,'' c0_1,a.newdelcell_seq c1,area_id c2_1,(select dim.itemname from dim_areacity dim where char(dim.region_new)=area_id) c2,LAC_DEC c3,CELLID_DEC c4,Bureau_ID c5,(select A.name from bureau_tree A where A.ID=town_code) c6_1,town_code c6,createuser c7,substr(char(CREATE_DATE),1,19) c8,case when a.operate_type='new' then '新增' when a.operate_type='del' then '删除' end c9,case when a.STATUS='waitaudit1' then '待一级审核' when a.STATUS='waitaudit2' then '待二级审核' when a.STATUS='waitaudit3' then '待三级审核' when a.STATUS='succ' then '审核通过'  when a.STATUS='fail' then '审核不通过'  end c10,substr(char(a.STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 from BUREAU_CELL_NEWDEL_INFO a,BUREAU_CELL_NEWDEL_AUDIT_LOG b where a.NEWDELCELL_SEQ = b.NEWDELCELL_SEQ and b.OPERATOR = '<%=userid%>' "
			+ wherePiece
			+ getwhere('STATE_DATE')
			+ getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c2"
			+" with ur";
			
		return sql;		
	}
	if("allRec" == selType){
		var wherePiece = " where 1=1 ";
		if($('OPERATE_TYPE').value != null && $('OPERATE_TYPE').value != ""){
			wherePiece += " and OPERATE_TYPE='"+$('OPERATE_TYPE').value+"'";
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
		
		var sql="select '' c0,'' c0_1,newdelcell_seq c1,area_id c2_1,(select dim.itemname from  dim_areacity dim where char(dim.region_new)=area_id) c2,LAC_DEC c3,CELLID_DEC c4,Bureau_ID c5,bureau_name c5_1,(select A.name from  bureau_tree A where A.ID=town_code) c6_1,town_code c6,createuser c7,substr(char(CREATE_DATE),1,19) c8,case when operate_type='new' then '新增' when operate_type='del' then '删除' end c9,case when STATUS='waitaudit1' then '待一级审核' when STATUS='waitaudit2' then '待二级审核' when STATUS='succ' then '审核通过'  when STATUS='fail' then '审核不通过'  end c10,substr(char(STATE_DATE),1,19) c11,case when eff_type='0' then '立即生效' when eff_type='1' then '下月生效' end c12 ,zone_name c21,zone_code c31,town_name c22,cell_name c23 from (select a.* ,b.zone_name,zone_code,town_name,bureau_name cell_name from BUREAU_CELL_NEWDEL_INFO a left join  vdim_bureau_tree b on a.town_code=b.town_code) tt "
			+ wherePiece
			+ getwhere('STATE_DATE')
			+ getwhereDate('CREATE_DATE','date3','date4')	
			+ " order by c2,c21,c22,c23"
			+" with ur";
		//alert(sql);	
		return sql;	
	}		
}

function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,isCached : false
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
//	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+strEncode(genSQL())+"&fileName="+_fileName});
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
								<td class='dim_cell_title' id="something" style="display: none"></td>
								<td class='dim_cell_content' id="something1" style="display: none"></td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>操作类型</td>
								<td class='dim_cell_content'><select id="OPERATE_TYPE"><option value="">全部</option><option value="new">新增</option><option value="del">删除</option></select></td>
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
										<option value='728'>天门</option>
										<option value='728'>潜江</option>
									
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
								<td class='dim_cell_content' id="status_td2" style="display: none"><select id="STATUS" ><option value="">全部</option><option value="waitaudit1">待一级审核</option><option value="waitaudit2">待二级审核</option><option value="waitaudit3">待三级审核</option><option value="succ">审核通过</option><option value="fail">审核不通过</option></select></td>
							</tr>
							<tr id="eff" style="display: none"><!-- 默认全为立即生效 -->
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
        Ext.onReady(function(){
	  	Ext.QuickTips.init();
	  	Ext.BLANK_IMAGE_URL = '${mvcPath}/hbapp/resources/js/ext/resources/images/default/s.gif';
      Ext.form.Field.prototype.msgTarget = 'side';
      contextPath = window.location['pathname'].split('/')[1];
          
      });



function getGridPanel(){

     if (_select_id.trim() != ''){
          var strNewId = _select_id.trim().split(",");
          //alert('长度:'+strNewId.length);
          var selectd = "";
          for (var i=0;i<strNewId.length;i++){
              if(selectd == ""){
					selectd += strNewId[i];
				}else{
					selectd += "," + strNewId[i];
				}
          }
         //alert(selectd);
         var _Uselect = "select A.NEWDELCELL_SEQ,A.bureau_name,A.BUREAU_ID,B.COLLEGE_ID,COLLEGE_NAME,B.OPERATOR,(select C.county_code  from  vdim_bureau_tree C where C.town_code=A.town_code) county_code,(select C.COUNTY_NAME  from  vdim_bureau_tree C where C.town_code=A.town_code) COUNTY_NAME,(select C.ZONE_CODE  from  vdim_bureau_tree C where C.town_code=A.town_code) ZONE_CODE,(select C.ZONE_NAME  from  vdim_bureau_tree C where C.town_code=A.town_code) ZONE_NAME from (select * from BUREAU_CELL_NEWDEL_INFO  where NEWDELCELL_SEQ IN ("+selectd+")) A left join (select * from BUREAU_COLLEGE_ORINFO  C where state_time= (select MAX(state_time) from BUREAU_COLLEGE_ORINFO D WHERE C.NEWDELCELL_SEQ= D.NEWDELCELL_SEQ) ) B on A.NEWDELCELL_SEQ=B.NEWDELCELL_SEQ";
             var ds=new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({url:"${mvcPath}/hbirs/action/jsondata?method=query&sql="+_Uselect+"&isCached=false&qType=limit&start=1&limit=510"}),
                    reader: new Ext.data.JsonReader({
                        root: 'data',
                        totalProperty:'total'
                   },[ 'newdelcell_seq','bureau_name','bureau_id','college_id','college_name','operator','county_code','county_name','zone_code','zone_name']
            ) 
    });
    ds.load({
   params : {//这两个参数是分页的关键，当你点击 下一页 时，这里的值会传到后台,也就是会重新运行：store.load
    start : 0,   
    limit : 30
      }
   });
   var _Uselect = "select distinct college_id id,college_name value from  COLLEGE_INFO where state=1 and area_id in (select itemid from  dim_areacity where  region_new=<%=region%>) order by college_name asc ";
             var ds_1=new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({url:"${mvcPath}/hbirs/action/jsondata?method=query&sql="+_Uselect+"&qType=limit&start=1&limit=510"}),
                    reader: new Ext.data.JsonReader({
                        root: 'data',
                        totalProperty:'total'
                   },[ 'id','value']
            ) 
    });
    ds_1.load();
    
    var fd_University_edit = new Ext.form.ComboBox({
	  fieldLabel:'fd_University_edit',
	  id:'fd_University_edit',
	  mode: 'remote',
      triggerAction:'all',
      store:ds_1,
      ds:ds,
      editable: false,
      blankText:'请选择...',
      	valueField: 'id',displayField: 'value',
      	forceSelection: true,
      allowBlank:false//,
//      listeners:{
//         select:{
//            fn:function(combo,record,index){
//               alert(record.get('id'));
//               alert(index);
//               combo.get1();
               // alert(fd_University_edit.lastSelectionText);
                //Ext.get("'UName_"+record.get('newdelcell_seq')+"'").setValue=fd_University_edit.lastSelectionText ;
//            }
//         }
//      }
 }); 
    fd_University_edit.on('select',function(){
         //alert(fd_University_edit.lastSelectionText);
        //var record = ds.data;
        
        fd_University_edit.setValue(fd_University_edit.getValue()+':'+fd_University_edit.lastSelectionText);
        //.set('college_name',fd_University_edit.lastSelectionText);
        //Ext.getCmp()
        
    }); 
    
    function renderDefault(value, cellmeta, record, rowIndex, columnIndex, store){
        var editName= '';
        if (value == null){
             editName= "<font color='red'>双击进行编辑</font>";
         }else{
             editName = value ;
         }    
        return editName;
    };
   var gd_4 = new Ext.grid.EditorGridPanel({
         //region:'center',
	     ds: ds, 	     
	     columns:[
	     new Ext.grid.CheckboxSelectionModel(),
	     {header: "编号", width:60,sortable:true,dataIndex: 'newdelcell_seq'},
	     {header: "基站编号", width:80,sortable:true, dataIndex: 'bureau_id'},
	     {header: "基站名称", width:80,sortable:true, dataIndex: 'bureau_name'},
	     {header: "校园编号", width:280,sortable:true, dataIndex: 'college_id',editor:fd_University_edit,renderer:renderDefault},
	     {header: "区编码", width:60,sortable:true, dataIndex: 'county_code'},
	     {header: "区名称", width:60,sortable:true, dataIndex: 'county_name'},
	     {header: "营销中心编码", width:100,sortable:true, dataIndex: 'zone_code'},
	     {header: "营销中心名称", width:100,sortable:true, dataIndex: 'zone_name'},
	     //{header: "校园名称", width:170,sortable:true,dataIndex: 'college_name',renderer:renderEditName},
	     {header: "操作者", width:80,sortable:true,dataIndex: 'operator'}
	     ],
	     layoutConfig:{
                    animate:true
                }, 
	     bbar : ['->',//new Ext.PagingToolbar({ pageSize: 20, store: ds})
	     new Ext.PagingToolbar({id:'pagingtoolbar',pageSize: 30, store: ds,displayInfo: true,loadMask: true,
displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
emptyMsg: "没有记录",width:480 })
	     ],
	     loadMask: true,		     
	     border:false
	     });
   
         //Ext.MessageBox.confirm('选择框', resultDate, function(btn) { alert('你刚刚点击了 ' + btn); });
     }

      var win = new Ext.Window({   
        title: "设置高校基站归属",    
        width: 600,
        height:400,
        id:'university_win',
        minWidth: 300,
        minHeight: 200,
        layout: 'fit',
        plain:true,
        modal: true,
        bodyStyle:'padding:1px;',
        buttonAlign:'center',
             items: [gd_4],   
             buttons: [{   
                text: "确定", 
                handler: onOKSave,   
                scope: this  
            }, {   
                text: "退出",   
                handler: closeWin,   
                scope: this  
            }]   
  });
  Ext.MessageBox.yes = "确定";
  Ext.MessageBox.no = "取消";
function onOKSave(){
//	if(!fmproc.isValid()){alert('程序信息不完整,请检查');return;};
  //alert (ds.getCount());
  var ids = "";
		var n = document.getElementsByName('cbox').length;
		//alert(n);
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
  
  var _sqls = '';
  for (var i=0;i<ds.getCount();i++){
       var record = ds.getAt(i);
      // alert(record.get('college_id'));
       if (record.get('college_id') == null ){
          Ext.MessageBox.alert('提示信息!', '未选择对应的高校,请检查数据!', function(btn) { return; });
       }else{
          var subUni = record.get('college_id').split(":");
          var _onesql = encodeURIComponent("insert into BUREAU_COLLEGE_ORINFO(NEWDELCELL_SEQ,COLLEGE_ID,COLLEGE_NAME,Bureau_ID,operator) values("+record.get('newdelcell_seq')+",'"+subUni[0]+"','"+subUni[1]+"','"+record.get('bureau_id')+"','<%=userid%>')");
          _sqls += ((_sqls==''?'':'&') + ("sqls="+_onesql));
          
       }     
  }
  //Ext.MessageBox.alert('提示信息!', _sqls, function(btn) { return; });
  
     var ajax = new aihb.Ajax({
											url : "${mvcPath}/hbirs/action/sqlExec?"+_sqls
											,loadmask : false
											,callback : function(xmlrequest){
												//alert(xmlrequest.responseText);
												var _ajax = new aihb.Ajax({
													url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauNewdel"
													,parameters : "ids="+ids+"&result=succ&eff_type="+document.getElementById("eff_type").value
													,callback : function(xmlrequest){
													    _select_id = '';
														query();
														//alert(xmlrequest);
													}
		                                           });
		                                            _ajax.request();
											}
										});
										ajax.request();      
  Ext.getCmp('university_win').hide(); 
  Ext.getCmp('university_win').destroy();     
};    
function closeWin(){
          Ext.getCmp('university_win').hide();
          Ext.getCmp('university_win').destroy();   
}; 
}  ;    
function setUniversityOr(){
     //alert("_select_id:"+_select_id);
     if (_select_id.trim()==''){
        
	     
         return false ;
     }else{
         //alert(_select_id);
         getGridPanel();
         Ext.getCmp('university_win').show();
         return true;
     }
     return false;
};      
var showMask = function(id) {
	mask = new Ext.LoadMask(id, {
		msg : "正在处理，请稍候...",
		removeMask : true
	});
	mask.show();
};
var hideMask = function() {
	mask.hide();
};
	function pass(){
	    
		var ids = "";
		var n = document.getElementsByName('cbox').length;
		//alert(n);
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
		
		//加入检查条件
		if (ids.trim()== "" ){
		    Ext.MessageBox.alert('提示信息!', "未选择需要审核通过的基站,请先选择!", function(btn) { return; });
		    return ;
		}
		//加入关联高校的函数
	    var _flag = setUniversityOr();
	    //alert(_flag);
	    //return ;
	   
	    if (_select_id.trim() == ''){
		    /**
		    Ext.MessageBox.confirm('信息提示:', '新增基站审核为非高校基站,请确认！', function(btn) { 
		     if (btn == 'yes'){
		    	 
			});
		    showMask(Ext.getBody());
	        //alert('开始更新数据！');
	        var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauNewdel"
			,parameters : "ids="+ids+"&result=succ&eff_type="+document.getElementById("eff_type").value
			,callback : function(xmlrequest){
			    _select_id = '';
				query();
				hideMask();
				//alert(xmlrequest);
			};
		    _ajax.request();
			}else{return false;} 
		     //alert(btn);
		     });
		    	**/
	    	showMask(Ext.getBody());
			var _ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauNewdel"
				,parameters : "ids="+ids+"&result=succ&eff_type="+document.getElementById("eff_type").value
				,callback : function(xmlrequest){
					_select_id = '';
					query();
					hideMask();
					//alert(xmlrequest);
				}
			});
			_ajax.request();		
		}
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
		showMask(Ext.getBody());
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=bureauNewdel"
			,parameters : "ids="+ids+"&result=fail&eff_type="+document.getElementById("eff_type").value
			,callback : function(xmlrequest){
				query();
				hideMask();
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
		var _url = "${mvcPath}/hbbass/salesmanager/areasale/bureauAudit/bureau_newdel_detail.jsp?id="+ids;
		tabAdd({url:_url,title:'日志'});
	}	
			
</script>
