<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!-- 3.30号修改：发现user_user表的region_id是不准的，不能用这个字段，改成用area_id,而且全省的工号能够修改地市的资费 -->
<%
HashMap areaMap = new HashMap();
areaMap.put("0","HB");
try{
	Connection cityConn=ConnectionManage.getInstance().getWEBConnection();
	PreparedStatement pst=cityConn.prepareStatement("select area_id,area_code from mk.bt_area");
	ResultSet cityRs=pst.executeQuery();
	while(cityRs.next()){
		areaMap.put(cityRs.getString(1),cityRs.getString(2));
	}
	
	cityRs.close();
	pst.close();
	cityConn.close();
}catch(Exception ex){ex.printStackTrace();}

User user = (User)request.getSession().getAttribute("user");
String action = "update";
//新增的时候是取不到area_id的
String area_id = request.getParameter("area_id");
if(area_id==null){//说明是新增
	area_id = areaMap.get(user.getCityId()).toString();
}
//if(area_id.length()>5) area_id = area_id.substring(0,5);
String proc_tid = request.getParameter("proc_tid");
if(proc_tid==null){
	action="add";
}
List list = null;
if(action.equals("update")){
	Connection conn=null;
	
	try{	
	    conn = ConnectionManage.getInstance().getDWConnection();
		SQLQueryBase queryBase = new SQLQueryBase();
		queryBase.setConnection(conn);
		String condition =" and proc_tid ='" + proc_tid+"'";
		//String sql = "select area_id,proc_tid,proc_name,month_back,case when month_mini is null then 0 else month_mini end month_mini,bind_cycle,bind_type,bind_strength,case when remark is null then '' else remark end remark,oper_time,state from nmk.dim_bind_type_info where 1=1 "+condition +" and state=2 with ur";
		String sql = "select area_id,proc_tid,proc_name,month_back,  month_mini,bind_cycle,bind_type,bind_strength,case when remark is null then '' else remark end remark,oper_time,state from nmk.dim_bind_type_info where 1=1 "+condition +" and state=2 with ur";
		list = (List)queryBase.query(sql);
	}catch(Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		//连接已经在query方法释放过了，这里不用再释放了。
	}	
}
HashMap cityMap = new HashMap();
	cityMap.put("HB","全省");

try{
	Connection cityConn=ConnectionManage.getInstance().getWEBConnection();
	PreparedStatement pst=cityConn.prepareStatement("select area_code,area_name from mk.bt_area");
	ResultSet cityRs=pst.executeQuery();
	while(cityRs.next()){
		cityMap.put(cityRs.getString(1),cityRs.getString(2));
	}
	
	cityRs.close();
	pst.close();
	cityConn.close();
}catch(Exception ex){ex.printStackTrace();}

HashMap bindTypeMap = new HashMap();
bindTypeMap.put("1","话费");
bindTypeMap.put("2","终端");
bindTypeMap.put("3","礼品");
bindTypeMap.put("4","其他");
//HashMap bindStrengthMap = new HashMap();
//bindStrengthMap.put("","请选择");
//bindStrengthMap.put("极弱","极弱");
//bindStrengthMap.put("弱","弱");
//bindStrengthMap.put("中","中");
//bindStrengthMap.put("强","强");

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript">
	var action = '<%=action%>';
	var area_id='<%=area_id%>';
	var proc_tid='<%=proc_tid%>';
	var loginname="<%=user.getName()%>";
	var cityId="<%=user.getCityId()%>";
	//if(action=='add'){//area_id要转一下
	//	area_id = aihb.Constants.getArea(area_id).cityCode;
	//}
	window.onload=function(){
		if(action=='update'){
			$("btn_add").style.display="none";
			$("btn_save").style.display="none";
		}
		if(action=='update'){
			$("btn_upd").onclick=function(){
				if(confirm("确定要修改吗？")){
					if(check()){//校验通过
						//插入日志表
						var sql = encodeURIComponent("insert into nmk.dim_bind_type_info(area_id,proc_tid,proc_name,month_back,month_mini,bind_cycle,bind_type,bind_strength,remark,oper_time,oper,state,audit_flag,userid)values('"+$("area_id").value+"','"+$("proc_tid").value+"','"+$("proc_name").value+"',"+$("month_back").value+","+$("month_mini").value+","+$("bind_cycle").value+","+$("bind_type").value+",'"+$("bind_strength").value+"','"+$("remark").value+"',current timestamp,'修改',1,0,'"+loginname+"') ");
						var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
						});
						ajax.request();
						alert("修改成功等待审批");
					}
					$("btn_upd").disabled=true;
					$("btn_del").disabled=true;
				}
			};
			$("btn_del").onclick=function(){
				if(confirm("确定要删除吗？")){
					//插入日志表
					var sql = encodeURIComponent("insert into nmk.dim_bind_type_info(area_id,proc_tid,proc_name,month_back,month_mini,bind_cycle,bind_type,bind_strength,remark,oper_time,oper,state,audit_flag,userid)values('"+$("area_id").value+"','"+$("proc_tid").value+"','"+$("proc_name").value+"',"+$("month_back").value+","+$("month_mini").value+","+$("bind_cycle").value+","+$("bind_type").value+",'"+$("bind_strength").value+"','"+$("remark").value+"',current timestamp,'删除',1,0,'"+loginname+"') ");
					var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql
						,loadmask : false
					});
					ajax.request();
					alert("删除成功等待审批");
				}
				
				$("btn_upd").disabled=true;
				$("btn_del").disabled=true;
			};
		}else{
			$("btn_save").onclick=function(){
				if(confirm("确定要保存吗？")){
					if(check()){//校验通过
						var area_id=$N("area_id");
						var proc_tid = $N("proc_tid");
						var proc_name=$N("proc_name");
						var month_back=$N("month_back");
						var month_mini=$N("month_mini");
						var bind_cycle=$N("bind_cycle");
						var bind_type=$N("bind_type");
						var remark=$N("remark");
						var bind_strength=$N("bind_strength");
						var sql = encodeURIComponent("insert into nmk.dim_bind_type_info(area_id,proc_tid,proc_name,month_back,month_mini,bind_cycle,bind_type,bind_strength,remark,oper_time,oper,state,audit_flag,userid)values('"+area_id[0].value+"','"+proc_tid[0].value+"','"+proc_name[0].value+"',"+month_back[0].value+","+month_mini[0].value+","+bind_cycle[0].value+","+bind_type[0].value+",'"+bind_strength[0].value+"','"+remark[0].value+"',current timestamp,'新增',1,0,'"+loginname+"') ");
						for(i=1;i<proc_tid.length;i++){
							sql+="&sqls=" +encodeURIComponent("insert into nmk.dim_bind_type_info(area_id,proc_tid,proc_name,month_back,month_mini,bind_cycle,bind_type,bind_strength,remark,oper_time,oper,state,audit_flag,userid)values('"+area_id[i].value+"','"+proc_tid[i].value+"','"+proc_name[i].value+"',"+month_back[i].value+","+month_mini[i].value+","+bind_cycle[i].value+","+bind_type[i].value+",'"+bind_strength[i].value+"','"+remark[i].value+"',current timestamp,'新增',1,0,'"+loginname+"') ");
						}
						var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
						});
						ajax.request();
						alert("保存成功下一审批人：省公司市场部朱峰");
						$("btn_save").disabled=true;
					}
					
				}
			};
		}
		
	}
	function check(){
		var proc_tid = $N("proc_tid");
		var proc_name=$N("proc_name");
		var month_back=$N("month_back");
		var month_mini=$N("month_mini");
		var bind_cycle=$N("bind_cycle");
		var bind_type=$N("bind_type");
		var bind_strength=$N("bind_strength");
		var back="";
		var cycle="";
		for(i=0;i<proc_tid.length;i++){
			if(proc_tid[i].value==""){
				alert("请填写优惠包ID");
				proc_tid[i].focus();
				return false;
			}
			if(proc_name[i].value==""){
				alert("请填写优惠包名称");
				proc_name[i].focus();
				return false;
			}
//			对增加的月返还金额、月保底金额、捆绑周期数，一定是必填项
			if(month_back[i].value==""){
				alert("请填写月返还金额");
				month_back[i].focus();
				return false;
			}
			if(month_mini.value==""){
				alert("请填写月保底金额");
				month_mini[i].focus();
				return false;
			}
			if(bind_cycle[i].value==""){
				alert("请填写捆绑周期");
				bind_cycle[i].focus();
				return false;
			}
			if(bind_type[i].value==""){
				alert("请选择捆绑类型");
				bind_type[i].focus();
				return false;
			}
			//输入校验完成后生成捆绑强度
			//强:50元及以上&12个月及以上 ;
			//中	:30-50元（含30元，不含50元)&12个月及以上/50元及以上	&6-12个月（含6个月，不含12个月）
			//弱	:30元以下&12个月及以上/50元及以上&6个月以下 ;
			//极弱:50元以下&12个月以下
			back=month_back[i].value;
			cycle=bind_cycle[i].value;
			if(back>=50&&cycle>=12){
				bind_strength[i].value="强";
			}else if((back>=30 && back<50 && cycle>=12) || (back>=50 && cycle>=6 && cycle<12)){
				bind_strength[i].value="中";
			}else if((back<30&&cycle>=12) || (back>=50&&cycle<6)){
				bind_strength[i].value="弱";
			}else if(back<50&&cycle<12){
				bind_strength[i].value="极弱";
			}
		}
		
		return true;
	}
	function autoCom(obj){
		var proc_tid = $N("proc_tid");
		var n=0;
		for(i=0;i<proc_tid.length;i++){
			if(proc_tid[i].value==obj.value){
				n=i; 
				break;
			}
		}
		var proc_name=$N("proc_name");
		if(obj.value!=""){
			var _sql = "select fee_name,createorg from nwh.fee where fee_id='"+obj.value+"' with ur ";
			var _ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/jsondata?method=query"
				,parameters : "sql="+encodeURIComponent(_sql)+"&isCached=false"
				,loadmask : true
				,callback : function(xmlrequest){
					try{
						var result = xmlrequest.responseText;
						result = eval(result);
						if(result.length>0){
							if($("area_id").value==result[0].createorg){//只要选的是武汉就能新增武汉的资费
								proc_name[n].value=result[0].fee_name;
							}else{
								alert("您所在的地市没有优惠包ID："+obj.value+",请修改");
								obj.focus();
								return;
							}
							
						}else{
							alert("优惠包ID："+obj.value+"不存在，请修改");
							obj.focus();
							return;
						}
					}catch(e){
						alert("录入失败，请检查数据是否正确");
						return;
					}
				}
			})
			_ajax.request();
		}else{
			//$("proc_name").value="";
		}
	}
	//处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外  
	function banBackSpace(e){     
	    var ev = e || window.event;//获取event对象     
	    var obj = ev.target || ev.srcElement;//获取事件源     
	      
	    var t = obj.type || obj.getAttribute('type');//获取事件源类型    
	    //获取作为判断条件的事件类型  
	    var vReadOnly = obj.getAttribute('readonly');  
	    var vEnabled = obj.getAttribute('enabled');  
	    //处理null值情况  
	    vReadOnly = (vReadOnly == null) ? false : vReadOnly;  
	    vEnabled = (vEnabled == null) ? true : vEnabled;  
	      
	    //当敲Backspace键时，事件源类型为密码或单行、多行文本的，  
	    //并且readonly属性为true或enabled属性为false的，则退格键失效  
	    var flag1=(ev.keyCode == 8 && (t=="password" || t=="text" || t=="textarea")   
	                && (vReadOnly==true || vEnabled!=true))?true:false;  
	     
	    //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效  
	    var flag2=(ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea")  
	                ?true:false;          
	      
	    //判断  
	    if(flag2){  
	        return false;  
	    }  
	    if(flag1){     
	        return false;     
	    }     
	}  
	  
	//禁止后退键 作用于Firefox、Opera  
	//document.onkeypress=banBackSpace;  
	//禁止后退键  作用于IE、Chrome  
	document.onkeydown=banBackSpace;  
	
	function createTr()   
	{   //debugger;
		var area_id = '<%=area_id%>';
		var tmpStr="";
	    var tab = document.getElementById("tab");   
	    var tr = tab.insertRow();//create tr   
	    //create td   
	    var td1 = tr.insertCell(0);   
	    td1.style.textAlign = "center";   
	    td1.innerHTML = '<input type="button" value="删除" class="form_button" width="50" onclick="DelRow();" alt="删除"/>';   
	    var td2 = tr.insertCell(1);   
	    td2.style.textAlign = "center"; 
	    tmpStr = "<select name='area_id' class='form_select'  id='area_id' style= 'WIDTH:65'>";
		if(area_id=='HB')tmpStr+="<option value='HB' selected>全省</option>";else tmpStr+="<option value='HB'>全省</option>";
		if(area_id=='HB.WH')tmpStr+="<option value='HB.WH' selected>武汉</option>";else tmpStr+="<option value='HB.WH'>武汉</option>";
		if(area_id=='HB.HS')tmpStr+="<option value='HB.HS' selected>黄石</option>";else tmpStr+="<option value='HB.HS'>黄石</option>";
		if(area_id=='HB.EZ')tmpStr+="<option value='HB.EZ' selected>鄂州</option>";else tmpStr+="<option value='HB.EZ'>鄂州</option>";
		if(area_id=='HB.YC')tmpStr+="<option value='HB.YC' selected>宜昌</option>";else tmpStr+="<option value='HB.YC'>宜昌</option>";
		if(area_id=='HB.ES')tmpStr+="<option value='HB.ES' selected>恩施</option>";else tmpStr+="<option value='HB.ES'>恩施</option>";
		if(area_id=='HB.SY')tmpStr+="<option value='HB.SY' selected>十堰</option>";else tmpStr+="<option value='HB.SY'>十堰</option>";
		if(area_id=='HB.XF')tmpStr+="<option value='HB.XF' selected>襄阳</option>";else tmpStr+="<option value='HB.XF'>襄阳</option>";
		if(area_id=='HB.JH')tmpStr+="<option value='HB.JH' selected>江汉</option>";else tmpStr+="<option value='HB.JH'>江汉</option>";
		if(area_id=='HB.XN')tmpStr+="<option value='HB.XN' selected>咸宁</option>";else tmpStr+="<option value='HB.XN'>咸宁</option>";
		if(area_id=='HB.JZ')tmpStr+="<option value='HB.JZ' selected>荆州</option>";else tmpStr+="<option value='HB.JZ'>荆州</option>";
		if(area_id=='HB.JM')tmpStr+="<option value='HB.JM' selected>荆门</option>";else tmpStr+="<option value='HB.JM'>荆门</option>";
		if(area_id=='HB.SZ')tmpStr+="<option value='HB.SZ' selected>随州</option>";else tmpStr+="<option value='HB.SZ'>随州</option>";
		if(area_id=='HB.HG')tmpStr+="<option value='HB.HG' selected>黄冈</option>";else tmpStr+="<option value='HB.HG'>黄冈</option>";
		if(area_id=='HB.XG')tmpStr+="<option value='HB.XG' selected>孝感</option>";else tmpStr+="<option value='HB.XG'>孝感</option>";
		if(area_id=='HB.TM')tmpStr+="<option value='HB.TM' selected>天门</option>";else tmpStr+="<option value='HB.TM'>天门</option>";
		if(area_id=='HB.QJ')tmpStr+="<option value='HB.QJ' selected>潜江</option>";else tmpStr+="<option value='HB.QJ'>潜江</option>";
	    tmpStr+="</select>";
	    td2.innerHTML = tmpStr;   
	    var td3 = tr.insertCell(2);   
	    td3.style.textAlign = "center";   
	    td3.innerHTML = '<input type="text" id="proc_tid" onBlur="autoCom(this)"/>';   
	    var td4 = tr.insertCell(3);   
	    td4.style.textAlign = "center";   
	    td4.innerHTML = '<input type="text" id="proc_name" style= "WIDTH:400" readonly/>';   
	    var td5 = tr.insertCell(4);   
	    td5.style.textAlign = "center";   
	    td5.innerHTML = "<input type='text' style= 'WIDTH:50' id='month_back' onblur='if(isNaN(value)){alert('请输入数字');execCommand('undo');}' onafterpaste='if(isNaN(value))execCommand('undo')'/>";   
	    var td5 = tr.insertCell(5);   
	    td5.style.textAlign = "center";   
	    td5.innerHTML = "<input type='text' style= 'WIDTH:50' id='month_mini' onblur='if(isNaN(value)){alert('请输入数字');execCommand('undo');}' onafterpaste='if(isNaN(value))execCommand('undo')'/>";  
	    var td5 = tr.insertCell(6);   
	    td5.style.textAlign = "center";   
	    td5.innerHTML = "<input type='text' style= 'WIDTH:50' id='bind_cycle' onblur='if(isNaN(value)){alert('请输入数字');execCommand('undo');}' onafterpaste='if(isNaN(value))execCommand('undo')'/>";  
	    var td5 = tr.insertCell(7);   
	    td5.style.textAlign = "center";   
	    tmpStr='<select name="bind_type" class="form_select"  id="bind_type" style= "WIDTH:65">';
	    tmpStr+="<option value='' selected>请选择</option>";
	    tmpStr+="<option value='1' >话费</option>";
	    tmpStr+="<option value='2' >终端</option>";
	    tmpStr+="<option value='3' >礼品</option>";
	    tmpStr+="<option value='4' >其他</option>";
	    td5.innerHTML = tmpStr;  
	    var td5 = tr.insertCell(8);   
	    td5.style.textAlign = "center";   
	    td5.innerHTML = '<input type="text" style= "WIDTH:290"  id="remark"/>';  
	    var td5 = tr.insertCell(9);   
	    td5.style.textAlign = "center";   
	    td5.innerHTML = '<input type="hidden" style= "WIDTH:0"  name="bind_strength"/>';
	                     
	}  
	function DelRow()   
	{   
	    var iIndex = window.event.srcElement.parentElement.parentElement.rowIndex;   
	    var tab = document.getElementById("tab");   
	    if(iIndex==-99999)   
	      alert("系统提示：没有选中行号!");   
	    else{   
	         tab.deleteRow(iIndex);   
	    }   
	        
	}
	function doclose(){
		tabClose(self);
	}
	</script>
  </head>
  <body>
  	<div id="grid" style="display:none;"></div>
  	<table id="tab" class=grid-tab-blue border=0 cellSpacing=1 cellPadding=0  width=99% align=left>
<thead>
<tr class=grid_title_blue>
<TD class=grid_title_cell width="20"></TD>
<TD class=grid_title_cell width="50">地市</TD>
<TD class=grid_title_cell width="100" align=left>优惠包ID</TD>
<TD class=grid_title_cell width="250">优惠包名称</TD>
<TD class=grid_title_cell width="">月返还金额（元）</TD>
<TD class=grid_title_cell width="">月保底金额（元）</TD>
<TD class=grid_title_cell width="">捆绑周期（月数）</TD>
<TD class=grid_title_cell width="50">捆绑类别</TD>
<!-- 
<TD class=grid_title_cell width="50">捆绑强度</TD>
 -->
<TD class=grid_title_cell style="word-wrap:break-word;"  width="300">备注</TD>
</tr>
</thead>
<tbody id="tbody">
<div id="save"><input id="btn_add" type="button" class="form_button" value="添加一行" onclick="createTr()"><input id="btn_save" type="button" class="form_button" value="保存" ></div>
<%if(action.equals("update")){
  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  %>
<TR class="grid_row_blue grid_row_over_blue" width="99%">
<TD></TD>
<TD  class=grid_title_cell style="text-align:left" width="30">
<select name="area_id" class='form_select'  id="area_id" style= "WIDTH:65">
		<%
		for (Iterator iterator = cityMap.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			String area = entry.getKey().toString();
			String areacn = entry.getValue().toString();
			
			if(area.equals(lines.get("area_id").toString())){
				%>
				<option value="<%=area %>" selected><%=areacn %></option>
				<%
			}else{%>
				<option value="<%=area %>"><%=areacn %></option>
			<%}
		}
		%>
	</select>
	
</TD>
<TD  class=grid_title_cell style="text-align:left" width="100"><input type="text" id="proc_tid" name="proc_tid" value="<%=lines.get("proc_tid") %>" readonly/></TD>
<TD  class=grid_title_cell style="text-align:left" width="400"><input type="text" id="proc_name" name="proc_name" value="<%=lines.get("proc_name") %>" style= "WIDTH:400" readonly/></TD>
<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" id="month_back" name="month_back"style= "WIDTH:50" value="<%=lines.get("month_back")%>" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" id="month_mini" name="month_mini" style= "WIDTH:50" value="<%=lines.get("month_mini")==null?"":lines.get("month_mini")%>" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" id="bind_cycle" name="bind_cycle" style= "WIDTH:50" value="<%=lines.get("bind_cycle")%>" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
<TD  class=grid_title_cell style="text-align:left" width="50">
<select name="bind_type" class='form_select'  id="bind_type" style= "WIDTH:50">
		<%
		for (Iterator iterator = bindTypeMap.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			String key = entry.getKey().toString();
			String value = entry.getValue().toString();
			if(key.equals(lines.get("bind_type").toString())){
				%>
				<option value="<%=key %>" selected><%=value %></option>
				<%
			}else{%>
				<option value="<%=key %>"><%=value %></option>
			<%}
		}
		%>
	</select>
</TD>

<TD  class=grid_title_cell style="word-wrap:break-word;text-align:left" width="300"><input type="text" id="remark" name="remark" style= "WIDTH:290" value="<%=lines.get("remark")%>"/></TD>
<TD  class=grid_title_cell style="word-wrap:break-word;text-align:left" width="0"><input type="text" type="hidden" style= "WIDTH:0"  id="bind_strength" name="bind_strength" value=""/></TD>
</TR>
	<%  	
		}
  	%>
  	
  	<tr class="dim_row_submit">
  		<td></td>
  		<td></td>
  		<td></td>
  		<td></td>
  		<td></td>
  		<td></td>
  		<td></td>
  		<td></td>
		<td align="right">
			<span>
			<input id="btn_upd" type="button"  value="修改" class="form_button">
			<input id="btn_del" type="button"  value="删除" class="form_button">
			</span>
		</td>
	</tr>
  	<%}else{
  		
  	%>
  		<TR class="grid_row_blue grid_row_over_blue" width="99%">
  		<TD></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="60">
  		<select name="area_id" class='form_select'  id="area_id" style= "WIDTH:65">
			<%
			for (Iterator iterator = cityMap.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				String area = entry.getKey().toString();
				String areacn = entry.getValue().toString();
				if(area_id.equals(area)){
					%>
					<option value="<%=area %>" selected><%=areacn %></option>
					<%
				}else{%>
					<option value="<%=area %>"><%=areacn %></option>
				<%}
			}
			%>
		</select>
  		</TD>
  		<TD  class=grid_title_cell style="text-align:left" width="100"><input type="text" id="proc_tid" name="proc_tid" onBlur="autoCom(this)"/></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="400"><input type="text" id="proc_name" name="proc_name" style= "WIDTH:400" readonly/></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" style= "WIDTH:50" id="month_back" name="month_back" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" style= "WIDTH:50" id="month_mini" name="month_mini" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="20"><input type="text" style= "WIDTH:50" id="bind_cycle" name="bind_cycle" onblur="if(isNaN(value)){alert('请输入数字');execCommand('undo');}" onafterpaste="if(isNaN(value))execCommand('undo')"/></TD>
  		<TD  class=grid_title_cell style="text-align:left" width="65">
  		<select name="bind_type" class='form_select'  id="bind_type" name="bind_type" style= "WIDTH:65">
			<option value="">请选择</option>
			<option value="1">话费</option>
			<option value="2">终端</option>
			<option value="3">礼品</option>
			<option value="4">其他</option>
		</select>
  		</TD>
  		
  		<TD  class=grid_title_cell style="word-wrap:break-word;text-align:left" width="300"><input type="text" style= "WIDTH:290"  id="remark" name="remark" /></TD>
  		<TD  class=grid_title_cell style="word-wrap:break-word;text-align:left" width="0">ps<input type="text" type="hidden" style= "WIDTH:0"  name="bind_strength" /></TD>
  		</TR>  
  				
  	<%}
 %>	
 </tbody>
 </table>
  </body>
</html>
