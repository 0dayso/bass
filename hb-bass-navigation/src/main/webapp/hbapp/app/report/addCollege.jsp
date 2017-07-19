<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%
String area_id = request.getParameter("area_id");
String area_name = request.getParameter("area_name");
if(area_name.equals("全省")){
	area_name="武汉";
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<script type="text/javascript">
window.onload=function(){
	//genaCollegeId()
}
function genaCollegeId(){
	var area_id=$("city").value;
	alert(area_id);
	if(area_id==0){
		alert("请先 选择地市");
		return;
	}
	var sql = "select max(college_id) id from nwh.college_info where area_id='"+area_id+"'";
	var collegeId = {};
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/jsondata?method=query"
		,parameters : "sql="+encodeURIComponent(sql) + "&isCached=false"
		,loadmask : false
		,asynchronous:false
		,callback : function(xmlrequest){
			eval("collegeId="+xmlrequest.responseText);
			
		}
	});
	ajax.request();
	alert(collegeId[0]);
	$("collegeId").value=collegeId[0];
}
function checkFocus(sId) {
	var oInput = document.getElementById(sId);
	//有一点小问题，对于网址，不应该每次onfocus的时候都清空
	oInput.value="";//清空文本
	oInput.style.color = "black";
	oInput.style.fontStyle = "normal";
	
}
//提交前验证
function check() {
	if(confirm("确认要提交吗？")) {
	} else return;
	//第二个条件防止undefined
	if(document.getElementById("collegeId").value=="请先选择地市" || !document.getElementById("collegeId").value) {
		alert("没有生成高校编码，无法提交。请选择地市。");
		return;
	}
	if(document.getElementById("collegeName").value=="" ||document.getElementById("collegeName").value.trim().length == 0) {
		alert("高校名称不能为空,请修改。");
		return ;
	}
	var _sql=encodeURIComponent("insert into nwh.college_info values('"+$("collegeId").value+"','"+$("collegeName").value+"','"+$("web_add").value+"','"+$("college_type").value+"','"+$("collegeAdd").value+"',"+$("shortNum").value+",'"+$("city").value+"','"+$("manager").value+"',"+$("studentsNnum").value+","+$("newStudents").value+",0,current timestamp,0,,'')");
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/sqlExec"
		,parameters : "sqls="+_sql
		,callback : function(xmlrequest){
			alert(xmlrequest.responseText);
			location.reload();
		}
	});
	ajax.request();
}
	</script>
  </head>
  <body>
  	<div class="feedback">
		<form action="" method="get" >
		<center>
		<span style="text-align :center;font-size : 16pt">高校信息录入</span>
		</center>
	
		<table width="99%">
			<tr>
				<td>高校编码</td>
				<td><input type="text" id="collegeId" name="collegeId" title="编码由系统生成，不可修改。" style="color:gray; font-style: italic;" value="请先选择地市" readonly="readonly"></td>
				<td><span style="color:red">*</span>高校名称</td>
				<td><input type="text" name="collegeName" id="collegeName" value=""></td>
			</tr>
			<tr>
				<td>网址</td>
				<td><input type="text" id="web_add" name="webAdd" value="eg:http://www.sust.edu.cn" style="color:gray; font-style: italic;" onfocus="checkFocus(this.id)"></td>
					<td>高校类型</td>
				<td><input type="text" name="collegeType" id="college_type" value="eg:研究型" style="color:gray; font-style: italic;" onfocus="checkFocus(this.id)" ></td>
			</tr>
				
			<tr>
				<td>高效地址</td>
				<td><input type="text" name="collegeAdd" id="collegeAdd" value="" ></td>
					<td>V网短号码</td>
				<td><input type="text" name="shortNum" id="shortNum" value="" ></td>
			</tr>
				<tr>
				<td><span style="color:red">*</span>地市</td>
					<td class='dim_cell_content'>
					<select name="city" class='form_select' id="city" onchange="genaCollegeId()">
					<option value="0" selected='selected'>全省</option>
					<option value="HB.WH">武汉</option>
					<option value="HB.HS">黄石</option>
					<option value="HB.EZ">鄂州</option>
					<option value="HB.YC">宜昌</option>
					<option value="HB.ES">恩施</option>
					<option value="HB.SY">十堰</option>
					<option value="HB.XF">襄樊</option>
					<option value="HB.JH">江汉</option>
					<option value="HB.XN">咸宁</option>
					<option value="HB.JZ">荆州</option>
					<option value="HB.JM">荆门</option>
					<option value="HB.SZ">随州</option>
					<option value="HB.HG">黄冈</option>
					<option value="HB.XG">孝感</option>
					<option value='HB.TM'>天门</option>
					<option value='HB.QJ'>潜江</option>
					</select>
					</td>
				
				<td>高校片区经理
				</td>
				<td>
				<input type="text" name="manager" id="manager" value="" ></td>
			</tr>
			<tr>
				<td>学生人数</td>
				<td><input type="text" name="studentsNnum" id="studentsNnum" value="" ></td>
					<td>本年度招生人数</td>
				<td><input type="text" name="newStudents" id="newStudents" value="" ></td>
			</tr>
			<tr>
				<td colspan="4" align="right"><span style="color: red">*</span>为必填项</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="提交" onclick="check()" name="from2_submit"/>
				<input type="reset" value="重置" />
				</td>
			</tr>
	 	</table>
	 	</form>
	</div>
  </body>
</html>
