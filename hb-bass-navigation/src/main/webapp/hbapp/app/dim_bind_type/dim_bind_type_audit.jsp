<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<% User user = (User)request.getSession().getAttribute("user");
String userName = user.getName();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<style>
.lightbox{width:300px;background:#FFFFFF;border:5px solid #ccc;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#f4f4f4;padding:5px;}
.lightbox dd{ padding:20px; margin:0;}
</style>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<title>捆绑标识审批</title>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/default_min.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/grid.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/rpt_common.js" charset=utf-8></script>	
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/chart/FusionCharts.js"></script>		
	
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-primary/css/default/default.css" />
	<script type="text/javascript"> 
var userName=	'<%=userName%>';
var $j=jQuery.noConflict();
var _header= [
			   {"name":["选择"],"title":"","dataIndex":"proc_tids","cellFunc":"setId","cellStyle":"grid_row_cell"}
			  ,{"name":["地市"],"title":"","dataIndex":"area_id","cellFunc":"","cellStyle":""}
              ,{"name":["优惠包ID"],"title":"","dataIndex":"proc_tid","cellFunc":"","cellStyle":"grid_row_cell_text"}
              ,{"name":["优惠包名称"],"title":"","dataIndex":"proc_name","cellFunc":"","cellStyle":"grid_row_cell_text"}
              ,{"name":["月返还金额（元）"],"title":"","dataIndex":"month_back","cellFunc":"","cellStyle":""}
              ,{"name":["月保底金额（元）"],"title":"","dataIndex":"month_mini","cellFunc":"","cellStyle":""}
              ,{"name":["捆绑周期（月数）"],"title":"","dataIndex":"bind_cycle","cellFunc":"","cellStyle":""}
              ,{"name":["类别"],"title":"","dataIndex":"bind_type","cellFunc":"","cellStyle":""}
              ,{"name":["捆绑强度"],"title":"","dataIndex":"bind_strength","cellFunc":"","cellStyle":""}
              ,{"name":["备注"],"title":"","dataIndex":"remark","cellFunc":"","cellStyle":""}
              ,{"name":["操作"],"title":"","dataIndex":"oper","cellFunc":"","cellStyle":""}
              ,{"name":["操作人"],"title":"","dataIndex":"userid","cellFunc":"","cellStyle":""}
              ,{"name":["通过"],"title":"","dataIndex":"pass","cellFunc":"_oper","cellStyle":""}
              ,{"name":["不通过"],"title":"","dataIndex":"refuse","cellFunc":"_oper","cellStyle":""}
             ];
var _corReport=[];
var grid=null;
/*
编程中重载的col与groupby，来生成SQL 等等操作
*/
function sqlInterceptor(sql){
	return genSqlPieces(sql);
}
/*
编程中重载条件生成，必须要sql之前条用
*/
function condiInterceptor(){
}
 
function genSQL(){
	condiInterceptor();
	var sql="select '' proc_tids,value ( ( select area_name from mk.bt_area where area_code =a.area_id ) , '省公司' ) area_id,proc_tid,proc_name,month_back,month_mini,bind_cycle,case when bind_type=1 then '话费' when bind_type=2 then '终端' when bind_type=3 then '礼品' else '其他' end bind_type,bind_strength,remark,oper_time,oper,userid,'通过' pass,'不通过' refuse from nmk.dim_bind_type_info a where state=1  order by oper_time with ur";
	sql=sqlInterceptor(sql);
	sql=sqlReplace(sql);
	return sql;
}
 
function query(){
	grid=new aihb.SimpleGrid({
		header:_header
		,sql: genSQL()
		,isCached : "false"
		,ds : ""
		,callback:function(){
		}
	});
	//grid.ajax.url="/mvc/report/5320/query"
	grid.run();
}

function setId(dataIndex,options){
	var proc_tid = options.data[options.rowIndex].proc_tid;
	var oper = options.data[options.rowIndex].oper;
	return "<input type='checkbox' name='cbox' value=\""+proc_tid+"|"+oper+"\">";
}

var record = "";
function _oper(val,options){
	var _a=$C("a");
	_a.appendChild($CT(val));
	_a.title=val;
	_a.href="javascript:void(0)";
	_a.onclick=function(){
		if(val=='通过'){
			//更新当前记录，并把记录插入正式表
			//var sql = encodeURIComponent("update  nmk.dim_bind_type_info set state=2,audit_flag=1,audit_time=current timestamp where state=1 and proc_tid='"+options.record.proc_tid+"'");
			var sql="";
			if(options.record.oper=='新增' )
				sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=2,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+options.record.proc_tid+"'");
			if(options.record.oper=='修改' ){
				sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_user='"+userName+"' where state=2 and proc_tid='"+options.record.proc_tid+"'");
				sql+="&sqls="+encodeURIComponent("update  nmk.dim_bind_type_info set state=2,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+options.record.proc_tid+"'");
			}
			if(options.record.oper=='删除'){
				sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_user='"+userName+"' where state=2 and proc_tid='"+options.record.proc_tid+"'");
				//删除成功以后state都=3
				sql+="&sqls="+encodeURIComponent("update  nmk.dim_bind_type_info set state=3 ,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+options.record.proc_tid+"'");
			}
				
			//防止下次操作会insert多条记录到正式表
			//sql+="&sqls=" +encodeURIComponent("update  nmk.dim_bind_type_info set state=2 where state=1 and proc_tid='"+options.record.proc_tid+"'");
			
			$j.ajax({
				type: "post"
				,url: "${mvcPath}/hbirs/action/sqlExec"
				,dataType : "json"
				,data:"sqls="+sql
				,async: false
				,success: function(data){
					alert("审批完成");
					query();
	   			}
			});
			
			//发短信
		}else if(val=='不通过'){
			//$("reason").style.display="";
			record = options.record;
			refuse(record);
		}
	}
	return _a;
}
function DivAlert(messageDiv){
	this.messageDIV=messageDiv;
	//创建提示框底层 
	    this.bottomDIV = document.createElement("div");
	//获取body中间点
	    var x=document.body.clientWidth/2,y=document.body.clientHeight/2;
	//配置样式
	    this.bottomDIV.style.opacity="0.50";
	this.bottomDIV.style.filter="Alpha(opacity=50);";
	this.bottomDIV.style.backgroundColor="#CCCCCC";
	this.bottomDIV.style.height=document.body.scrollHeight+"px";
	this.bottomDIV.style.width="100%";
	this.bottomDIV.style.marginTop="0px";
	this.bottomDIV.style.marginLeft="0px";
	this.bottomDIV.style.position="absolute";
	this.bottomDIV.style.top="0px";
	this.bottomDIV.style.left="0px";
	this.bottomDIV.style.zIndex=100;
	//显示提示框
	    this.show = function(){
	//显示提示框底层 
	          document.body.appendChild(this.bottomDIV);
	//显示messageDIV
	        document.body.appendChild(this.messageDIV);
	//把messageDIV定位到body中间
	        this.messageDIV.style.position="absolute";
	x=x-this.messageDIV.clientWidth/2;
	y=y-this.messageDIV.clientHeight/2;
	this.messageDIV.style.top=y+"px";
	this.messageDIV.style.left=x+"px";
	this.messageDIV.style.zIndex=101;
	}
	//移除提示框
	      this.remove = function(){
	document.body.removeChild(this.bottomDIV);
	document.body.removeChild(this.messageDIV);
	}
	}
	//测试DivAlert对象
	var dc;
	function refuse(){
	//创建提示框内容部分
	     var d = document.createElement("div");
	d.style.width="220px";
	d.style.height="100px";
	d.style.backgroundColor="gray";
	d.style.padding="10px";
	//向提示框内容部分画需要显示的信息
	     d.innerHTML="请填写理由:<br/><input id='reason' type='text' style='color:#cc4044' value=''/><br/><input type='button'  value='确定' onclick='save()'/><input type='button'  value='取消' onclick='cancel()'/>";
	//实例化提示框
	     dc = new DivAlert(d);
	//显示提示框
	     dc.show();
	}
	//提示框里的Button按钮点击事件
	function save(){
	//移除对话框
		var reason = $("reason").value;
	  //更新当前记录为失效状态，不插正式表
		var sql = encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_flag=2,audit_time=current timestamp,audit_result='"+reason+"' where state=1 and proc_tid='"+record.proc_tid+"'");
		//sql+="&sqls=" +encodeURIComponent("insert into nmk.dim_bind_type values()");
		
		$j.ajax({
			type: "post"
			,url: "${mvcPath}/hbirs/action/sqlExec"
			,dataType : "json"
			,data:"sqls="+sql
			,async: false
			,success: function(data){
				alert("审批完成");
				query();
   			}
		});
		//发短信
		dc.remove();
	}
	function cancel(){
		//移除对话框
	    dc.remove();
	}

window.onload=query;

//批量审核操作
function checkOper(flag){
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
		alert("请最少选择一项来做审核！");
		return;
	}		
	if(flag == 2 && idArr.length > 1){
		alert("审核不通过只能针对一条记录！");
		return;	
	}

	if(flag == 1){
	  for(var m = 0; m < idArr.length; m++){
		var id_s = idArr[m].split("|");
		passOper(id_s[0],id_s[1]);
	  }	
	  alert("批量审批通过完成！");
	  query();
	}else if(flag == 2){
	  var id_s = idArr[0].split("|");
	  refOper(id_s[0]);
	}
}
//批量审核通过
function passOper(proc_tid,option_val){
	//更新当前记录，并把记录插入正式表
	var sql="";
	if(option_val=='新增' ){
		sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=2,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+proc_tid+"'");
	}		
	if(option_val=='修改' ){
		sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_user='"+userName+"' where state=2 and proc_tid='"+proc_tid+"'");
		sql+="&sqls="+encodeURIComponent("update  nmk.dim_bind_type_info set state=2,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+proc_tid+"'");
	}
	if(option_val=='删除'){
		sql+=encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_user='"+userName+"' where state=2 and proc_tid='"+proc_tid+"'");
		//删除成功以后state都=3
		sql+="&sqls="+encodeURIComponent("update  nmk.dim_bind_type_info set state=3 ,audit_flag=1,audit_time=current timestamp,audit_user='"+userName+"' where state=1 and proc_tid='"+proc_tid+"'");
	}		
	$j.ajax({
		type: "post"
		,url: "${mvcPath}/hbirs/action/sqlExec"
		,dataType : "json"
		,data:"sqls="+sql
		,async: false
	});
}
//批量审核拒绝
function refOper(proc_tid){
	//创建提示框内容部分
	var d = document.createElement("div");
	d.style.width="220px";
	d.style.height="100px";
	d.style.backgroundColor="gray";
	d.style.padding="10px";
	//向提示框内容部分画需要显示的信息                                                                                                                                                                          
	d.innerHTML="请填写理由:<br/><input id='reason' type='text' style='color:#cc4044' value=''/><br/><input type='button'  value='确定' onclick='saveAll(\""+proc_tid+"\")'/><input type='button'  value='取消' onclick='cancel()'/>";
	//实例化提示框
	dc = new DivAlert(d);
	//显示提示框
	dc.show();
	}
//提示框里的Button按钮点击事件
function saveAll(proc_tid){
	//移除对话框
	var reason = $("reason").value;
	    //更新当前记录为失效状态，不插正式表
		var sql = encodeURIComponent("update  nmk.dim_bind_type_info set state=3,audit_flag=2,audit_time=current timestamp,audit_result='"+reason+"' where state=1 and proc_tid='"+proc_tid+"'");
		
		$j.ajax({
			type: "post"
			,url: "${mvcPath}/hbirs/action/sqlExec"
			,dataType : "json"
			,data:"sqls="+sql
			,async: false
			,success: function(data){
				alert("审批不通过完成！");
				query();
   			}
		});
		//发短信
		dc.remove();
	}

/**  
 * 全选
 */	
function selectAll(){
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
</script>
</head>
<body>
<form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend>
	<table>  
	   <tr>
	   
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏" nowrap="nowrap">
			<img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;待审批项：
		</td>
		<td nowrap="nowrap">全选<input type="checkbox" name="checkAllBox" onclick="selectAll();"></td>
		<td align="right" width="800%">
				<input type="button" class="form_button" value="审核通过" onclick="checkOper(1)">&nbsp;
				<input type="button" class="form_button" value="审核不通过" onClick="checkOper(2)">						
			</td>
	   </tr>
	  </table>
	 </legend>
	<div id="gridBtn" style="display:none;"></div>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div>

</form>
</body>
</html>
