<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<% 
	User user = (User)request.getSession().getAttribute("user");
	String userName = user.getName();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<title>基站参数维护波动值设置</title>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/grid_common.js" charset=utf-8></script>		
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-primary/css/default/default.css" />
	
<script type="text/javascript"> 
var userName= '<%=userName%>';
var $j=jQuery.noConflict();
var _header= [
			          {"name":["地市编码"],"title":"","dataIndex":"region_code","cellFunc":"","cellStyle":"grid_row_cell"}               
               ,{"name":["地市名称"],"title":"","dataIndex":"region_name","cellFunc":"","cellStyle":"grid_row_cell"}
               
               ,{"name":["经分基站数量"],"title":"","dataIndex":"lastday_cnt","cellFunc":"","cellStyle":"grid_row_cell"}
               ,{"name":["网管基站数量"],"title":"","dataIndex":"today_cnt","cellFunc":"","cellStyle":"grid_row_cell"}
               
               ,{"name":["默认波动百分比(%)"],"title":"","dataIndex":"wave","cellFunc":"","cellStyle":"grid_row_cell"}
               ,{"name":["调整波动百分比(%)"],"title":"","dataIndex":"modify_value","cellFunc":"","cellStyle":"grid_row_cell"}
              
               ,{"name":["默认波动范围"],"title":"","dataIndex":"wave_scope","cellFunc":"","cellStyle":"grid_row_cell"}
               ,{"name":["调整波动范围"],"title":"","dataIndex":"modify_value_scope","cellFunc":"","cellStyle":"grid_row_cell"}
               ,{"name":["操作"],"title":"","dataIndex":"edit_id","cellFunc":"editBase","cellStyle":"grid_row_cell"}
               
              ];

var _corReport=[];
var grid=null;	
var now = new Date();
var new_date = now.getYear()+""+((now.getMonth()+1)<10?"0":"")+(now.getMonth()+1)+""+(now.getDate()<10?"0":"")+now.getDate();	

function genSQL(){	
	var sql=" select a.region_code,a.etl_cycle_id,(select b.area_name from mk.bt_area b where int(a.region_code) = b.new_code) region_name,a.lastday_cnt,a.today_cnt, "
       +" a.wave*100 wave,case when a.wave < 0 then TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.wave)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.wave))))) else TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.wave)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.wave))))) end wave_scope, "
       +" a.modify_value*100 modify_value,case when a.modify_value < 0 then TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.modify_value)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.modify_value))))) else TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.modify_value)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.modify_value))))) end modify_value_scope,  "
		   +" '修改' edit_id from nwh.bureau_cell_cnt_wave a where a.etl_cycle_id = (select max(b.etl_cycle_id) from nwh.bureau_cell_cnt_wave b) order by a.region_code "
	aihb.AjaxHelper.parseCondition()
		   +" with ur ";
	return sql;
}
 
function query(){
	grid=new aihb.SimpleGrid({
		header:_header
		,sql: genSQL()
		,isCached : "false"
		,ds : ""
		,callback:function(){}
	});
	grid.run();
}

var record = "";
function editBase(val,options){
	var _a=$C("a");
	_a.appendChild($CT(val));
	_a.title=val;
	_a.href="javascript:void(0)";
	_a.onclick=function(){
	updateBase(options.record);
	}
	return _a;
}

//测试DivAlert对象
var dc;
function updateBase(record){
	//创建提示框内容部分
	var d = document.createElement("div");
	d.style.width="380px";
	d.style.height="120px";
	d.style.backgroundColor="gray";
	d.style.padding="10px";
	//向提示框内容部分画需要显示的信息
	d.innerHTML="<table>"+
	"<tr><td colspan='4'><font color='#rrggcc'>注意：修改必须当天12点前完成，修改结果在当天15点前有效，程序运行完自动恢复成默认值。</font></td><tr>"+
	"<tr><td>地市名称：</td><td align='left'>"+record.region_name+"</td><td>当前波动百分比(%)：</td><td align='left'>"+record.wave+"</td><tr>"+
	"<tr><td colspan='2' nowrap='nowrap'>调整波动百分比(-100~100之间):</td><td colspan='2'><input id='baseValue' type='text' style='color:#cc4044' value=''/></td></tr>"+
	"<tr><td colspan='4' align='right'><input type='button'  value='确定' onclick='saveBase(\""+record.region_code+"\",\""+record.wave+"\",\""+record.etl_cycle_id+"\")'/><input type='button'  value='取消' onclick='cancel()'/></td></tr>"+
	"</table>";
	//实例化提示框
	dc = new DivAlert(d);
	//显示提示框
	dc.show();
}

//提示框里的Button按钮点击事件
function saveBase(region_code,wave,etl_cycle_id){
	//移除对话框
		var baseValue = $("baseValue").value;
		if(baseValue == null || baseValue == ''){
	  		alert("当前输入值不能为空，请重新输入！");
	  		return;			
		}else if(isNaN(baseValue)){
	  		alert("当前输入值非数值，请重新输入！");
	  		return;
		}else if(baseValue <= -100 || baseValue >=100){
	  		alert("当前输入值必须要在-100和100之间，请重新输入！");
	  		return;
	  }
    //取波动值绝对值保存
    if(baseValue < 0){
      baseValue = Math.abs(baseValue);
    }
	  document.forms(0).action='${mvcPath}/hbirs/action/baseSet?method=updateBaseSet&region_code='+region_code+'&wave='+baseValue+'&etl_cycle_id='+etl_cycle_id+'';
		document.forms(0).submit();
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

//移除对话框
function cancel(){
    dc.remove();
}

window.onload=query;
</script>
</head>
<body>
<form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend>
<!--  
	<table>  
	   <tr>
		<td nowrap="nowrap">当前日期：
			<script type="text/javascript">
				document.write(now.getYear()+"-"+((now.getMonth()+1)<10?"0":"")+(now.getMonth()+1)+"-"+(now.getDate()<10?"0":"")+now.getDate());
			</script>
		</td>
	   </tr>
	  </table>
-->    
	 </legend>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div>

</form>
</body>
</html>
