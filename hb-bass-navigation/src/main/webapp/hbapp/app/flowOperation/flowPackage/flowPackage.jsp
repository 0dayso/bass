<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>流量套餐</title>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/app/flowOperation/flowPackage/css/flowPackage.css" />
		<%
			String userid = (String) session.getAttribute("loginname");
		%>
		<script type="text/javascript">
		var flag="";
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"地市ID","dataIndex":"createorg","cellStyle":"grid_row_cell_text"}
	,{"name":"资费ID","dataIndex":"fee_id","cellStyle":"grid_row_cell_text"}
	,{"name":"政策ID","dataIndex":"plan_id","cellStyle":"grid_row_cell_text"}
	,{"name":"资费名称","dataIndex":"fee_name","cellStyle":"grid_row_cell_text"}
	,{"name":"基本/可选","dataIndex":"plan_kind","cellStyle":"grid_row_cell_text"}
	,{"name":"主流资费","dataIndex":"is_main","cellStyle":"grid_row_cell_text"}
	,{"name":"类型","dataIndex":"term_kind","cellStyle":"grid_row_cell_text"}
	,{"name":"费用档次","dataIndex":"fee","cellStyle":"grid_row_cell_number"}
	,{"name":"省内流量","dataIndex":"in_prov_flow","cellStyle":"grid_row_cell_number"}
	,{"name":"省际流量","dataIndex":"out_prov_flow","cellStyle":"grid_row_cell_number"}
	,{"name":"国内流量","dataIndex":"nation_flow","cellStyle":"grid_row_cell_number"}
	,{"name":"包内时长","dataIndex":"in_time","cellStyle":"grid_row_cell_number"}
	,{"name":"半月减半","dataIndex":"is_discount","cellStyle":"grid_row_cell_text"}
	,{"name":"当前状态","dataIndex":"status","cellStyle":"grid_row_cell_text"}
	,{"name":"资费说明","dataIndex":"remark","cellStyle":"grid_row_cell_text"}
];

function setTip(crtVal,options) {
 	var length = 10;
	if(!crtVal)return ""; //返回空字符串就是一种处理,如果return ;，页面上就是undefined
	var span = $C("span") ;
	crtVal = crtVal.trim();
	if(crtVal.length > length) {
		span.appendChild($CT(crtVal.substr(0,length) + "..."));
		span.onmouseover=function() {tooltip.show(crtVal);}
		span.onmouseout=tooltip.hide;
		return span;
	} else {
		span.appendChild($CT(crtVal)); //不加不行
	}
	return span;
}

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].fee_id;
	return "<input type='checkbox' name='cbox' id=\""+id+"\" >";
}

function genSQL(){
	var wherePart = " where 1 = 1 ";
	var city = $('cityId').value;
	var fee_name=$('fee_name').value;
	//alert(fee_name);
	var plan_kind=$('plan_kind').value;
	var is_main=$('is_main').value;
	var term_kind=$('term_kind').value;
	if(city!=-1){
		wherePart += "and createorg='"+city+"'";;
	}
	if(fee_name!=""){
		wherePart+="and fee_name like '%"+fee_name+"%'"
	}
	if(plan_kind!=-1){
		wherePart+= "and plan_kind='"+plan_kind+"'";
	}
	if(is_main!=-1){
		wherePart+="and is_main='"+is_main+"'";		
	}
	if(term_kind!=-1){
		wherePart+="and term_kind='"+term_kind+"'";
	}
	//alert(wherePart);	
	var  sql= "select '' c0,case when createorg='HB' then '全省' else b.value end as createorg ,fee_id,plan_id,fee_name,plan_kind,is_main,term_kind,fee,in_prov_flow,out_prov_flow,nation_flow,in_time,is_discount,case when status=1 then '是' else '否'end  as status ,value(remark,'无') as remark  from nwh.gprs_fee  a left join (select area_code key,area_name value from mk.bt_area)  b on a.createorg=b.key"
		+ wherePart
		+" order by fee_id,plan_id "
    aihb.AjaxHelper.parseCondition()
		+" with ur ";
	return sql;
}

function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,ds : 'dw'
		,isCached : false
	});
	grid.run();
}
	
		
	function check(){
		var fee_id = $('fee_id_v').value;
		Ext.Ajax.request({
			url:"${mvcPath}/hbirs/action/flowPagAction?method=getFeeInfo",
			params:{
				fee_id:$('fee_id_v').value
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				var feeInfo = ret.feeInfo;
				if(feeInfo==""){
					//$("checkerror").innerHTML="资费ID不存在";
					alert("资费ID不存在");
					$("fee_id_v").value="";
					$("fee_name_v").value="";
					$("status_v").value="是";
					$("createorg_v").value="";
					var plan_kind =$("plan_kind_v");
					for(var i=0;i<plan_kind.options.length;i++){
						if("基本"==plan_kind.options[i].value){
							plan_kind.options[i].selected=true;
						}
					}
				}else{
					var arr = feeInfo.split("|");
					$("fee_id_v").value=arr[0];
					$("fee_name_v").value=arr[1];
					$("status_v").value=arr[2]==1?'是':'否';
					$("createorg_v").value=arr[3];
					var plan_kind = $("plan_kind_v");
					for(var i=0;i<plan_kind.options.length;i++){
						if(arr[4]==plan_kind.options[i].value){
							plan_kind.options[i].selected=true;
						}
					}
				}
			}
		});
	}	
	function showDiv(){
		//展现div
        var mask = document.getElementById("mask");
        var view = document.getElementById("view");    
        
        var h_c =document.documentElement.scrollHeight;
        var w_c = document.documentElement.scrollWidth;        
        var h_b = document.body.scrollHeight;
        var w_b = document.body.scrollWidth ;        
        var height = h_c > h_b ? h_c : h_b;
        var width = w_c > w_b ? w_c : w_b;
        
        mask.style.width = width+"px";
        mask.style.height = height+"px";        
        mask.style.display = "block";
        
        view.style.left = (width-450)/2 + "px";
        view.style.top = document.documentElement.scrollTop+(document.body.clientHeight-450)/2 + "px";
        
        view.style.display="block";    
	}
	
	function maintain(flag){
		//alert(document.forms["form1"]);
        //获取当前是否选中某一套餐
        if(flag=="update"){
        var ids = "";
		var n = document.getElementsByName('cbox').length;
		for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
				var id = document.getElementsByName('cbox')[i].id;
				if(ids == ""){
					ids += id;
				}else{
					ids += "," + id;
				}
			}
		}
		var idArr = ids.split(",");	
		
		if(ids == ""){
		alert("请选择其中一项操作");
		
		}else  if(idArr.length==1){
		if(confirm("选中套餐，是否进行更新操作？")){
			showDiv();
			 //获取更新流量套餐的数据
        	Ext.Ajax.request({
			url:"${mvcPath}/hbirs/action/flowPagAction?method=flowPackageInfo",
			params:{
				fee_id:idArr[0]
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				var flowInfo = ret.flowInfo;
				flag=ret.flag;
				$('test').value=flag;
				if(flowInfo!=null){
					var arr = flowInfo.split(",");	
					$("createorg_v").value=arr[0];
					$("fee_id_v").value=arr[1];
					$("plan_id_v").value=arr[2];
					$("fee_name_v").value=arr[3];
					$("plan_kind_v").value=arr[4];
					$("is_main_v").value=arr[5];
					$("term_kind_v").value=arr[6];
					$("fee_v").value=arr[7];
					$("in_prov_flow_v").value=arr[8];
					$("out_prov_flow_v").value=arr[9];
					$("nation_flow_v").value=arr[10];
					$("in_time_v").value=arr[11];
					$("is_discount_v").value=arr[12];
					$("status_v").value=arr[13];
					$("remark_v").value=arr[14];
				}
			}
		});
		}
	}
	else if(idArr.length > 1){
		alert("只能选择一项进行修改");
		return ;
	}
        
    } else{
    	 $('test').value="";
    	 $("createorg_v").value="";
		 $("fee_id_v").value="";
		 $("plan_id_v").value="";
		 $("fee_name_v").value="";
		 $("fee_v").value="";
		 $("in_prov_flow_v").value="";
		 $("out_prov_flow_v").value="";
		 $("nation_flow_v").value="";
		 $("in_time_v").value="";
	     $("remark_v").value="";
   		 showDiv();
    }  
    }
		
    
    function hiddenDiv(){
        var view = document.getElementById("view"); 
        view.style.display = "none";
        var mask = document.getElementById("mask");    
        mask.style.display = "none";        
    }
    
    function save(){
		flag=$('test').value;
		if( $("term_kind_v").value!="WLAN"){
			var in_prov_flow_v = $("in_prov_flow_v").value;
			var out_prov_flow_v = $("out_prov_flow_v").value;
			var nation_flow_v = $("nation_flow_v").value;
			var in_time_v = $("in_time_v").value;
			if(in_prov_flow_v==null||in_prov_flow_v.trim()==""){
				alert("如果无省内流量，请填写0");
				return;
			}
			if(out_prov_flow_v==null||out_prov_flow_v.trim()==""){
				alert("如果无省际流量，请填写0");
				return;
			}
			if(nation_flow_v==null||nation_flow_v.trim()==""){
				alert("如果无国内流量，请填写0");
				return;
			}
			if(in_time_v==null||in_time_v.trim()==""){
				alert("如果无包内时长，请填写0");
				return;
			}
		}
		var fee_id=$("fee_id_v").value;
			if(flag=="update"){
				document.forms["form1"].action="${mvcPath}/hbirs/action/flowPagAction?method=flowPackageUpdate&fee_id="+fee_id;
				document.forms["form1"].submit();
			}else {
				Ext.Ajax.request({
					url:"${mvcPath}/hbirs/action/flowPagAction?method=flowPackageInsert",
					params:{
						 fee_id_v:fee_id
						,plan_id_v:encodeURIComponent($("plan_id_v").value)
						,createorg_v:encodeURIComponent($("createorg_v").value)
						,plan_kind_v:encodeURIComponent($("plan_kind_v").value)
						,fee_name_v:encodeURIComponent($("fee_name_v").value)
						,is_main_v:encodeURIComponent($("is_main_v").value)
						,term_kind_v:encodeURIComponent($("term_kind_v").value)
						,fee_v:encodeURIComponent($("fee_v").value)
						,in_prov_flow_v:encodeURIComponent($("in_prov_flow_v").value)
						,out_prov_flow_v:encodeURIComponent($("out_prov_flow_v").value)
						,nation_flow_v:encodeURIComponent($("nation_flow_v").value)
						,in_time_v:encodeURIComponent($("in_time_v").value)
						,is_discount_v:encodeURIComponent($("is_discount_v").value)
						,status_v:encodeURIComponent($("status_v").value)
						,remark_v:encodeURIComponent($("remark_v").value)
					},
					success:function(res){
						var ret = Ext.util.JSON.decode(res.responseText);
						var result = ret.result;
						if(result=="1"){
							alert("新增成功");
						}else if(result=="2"){
							alert("新增失败");
						}else if(result=="3"){
							alert("已经存在此资费ID");
						}
						location.reload();
					}
				});
			}
		}
	</script>
	</head>
	<body>
		<div id="flowPackage">
			<form method="post" action="">
				<input type="hidden" name="header" id="test">
				<div class="divinnerfieldset">
					<fieldset>
						<legend>
							<table>
								<tr>
									<td onclick="hideTitle(this.childNodes[0],'dim_div')"
										title="点击隐藏">
										<img flag='1'
											src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
										&nbsp;查询条件区域：
									</td>
								</tr>
							</table>
						</legend>
						<div id="dim_div">
							<table align='center' width='99%' class='grid-tab-blue'
								cellspacing='1' cellpadding='0' border='0' style="display: ''">
								<tr class='dim_row'>
									<td class=''>
										地市
									</td>
									<td class=''>
										<select id="cityId" name="cidyId" style="width: 100px">
											<option value="-1" selected='selected'>
												请选择
											</option>
										</select>
									</td>
									
									<td class=''>
										 资费名
									</td>
									<td class=''>
										<input type="text" id="fee_name" name="fee_name" style="width: 100px"></input>
									</td>
									<td class=''>
										基本可选
									</td>
									<td class=''>
										<select id="plan_kind" name="plan_kind" style="width: 100px">
											<option value="-1">
												请选择
											</option>
											<option value="基本">
												基本
											</option>
											<option value="可选">
												可选
											</option>
										</select>
									</td>
									<td class=''>
										是否主流
									</td>
									<td class=''>
										<select id="is_main" name="is_main" style="width: 100px">
											<option value="-1" selected='selected'>
												请选择
											</option>
											<option value="是">
												是
											</option>
											<option value="否">
												否
											</option>
										</select>
									</td>
									<td class=''>
										类型
									</td>
									<td class=''>
										<select id="term_kind" name="term_kind" style="width: 100px">
											<option value="-1" selected='selected'>
												请选择
											</option>
											<option value="手机">
												手机
											</option>
											<option value="数据卡">
												数据卡
											</option>
											<option value="行业应用卡">
												行业应用卡
											</option>
											<option value="WLAN">
												WLAN
											</option>
										</select>
									</td>
									<td>
										<input type="button" class="form_button" value="查询"
											onClick="query()">
									</td>
								</tr>
							</table>
						</div>
					</fieldset>
				</div>
				<br>
				<table id="updateShow" align="center" width="97%"
					style="display: 'none'">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="新增"
								onClick="maintain('insert');">
							<input type="button" class="form_button" value="维护"
								onClick="maintain('update');">
						</td>
					</tr>
				</table>
				<div class="divinnerfieldset">
					<fieldset>
						<legend>
							<table>
								<tr>
									<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
										<img flag='1'
											src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
			<div id="mask"></div>
			<div id="view">
			<form method="post" action="" name="form1">  
				<div class="content">
					<div id="grid" class="left">
						<table style="margin: 0 auto;">
							<tr class="">
								<td class="td_title" align="center" width="20%">
									地市
								</td>
								<td>
									<input type="text" id="createorg_v" name="createorg_v" readonly></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									资费ID
								</td>
								<td class="">
									<input type="text" id="fee_id_v" name="fee_id_v"
										onblur="check();"></input>
								</td>

							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									资费政策号
								</td>
								<td class="">
									<input type="text" id="plan_id_v" name="plan_id_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="30%">
									资费名称
								</td>
								<td class="">
									<input type="text" id="fee_name_v" name="fee_name_v" readonly></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" width="20%">
									基本/可选
								</td>
								<td class="">
									<select id="plan_kind_v" name="plan_kind_v"
										style="width: 152px">
										<option value="基本" selected='selected'>
											基本
										</option>
										<option value="可选">
											可选
										</option>
									</select>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									是否主流资费
								</td>
								<td class="">
									<select id="is_main_v" name="is_main_v" style="width: 152px">
										<option value="是" selected='selected'>
											是
										</option>
										<option value="否">
											否
										</option>
									</select>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									类型
								</td>
								<td class=" ">
									<select id="term_kind_v" name="term_kind_v"
										style="width: 152px">
										<option value="手机" selected='selected'>
											手机
										</option>
										<option value="数据卡">
											数据卡
										</option>
										<option value="行业应用卡">
											行业应用卡
										</option>
										<option value="WLAN">
											WLAN
										</option>
									</select>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									费用档次
								</td>
								<td class=" ">
									<input type="text" id="fee_v" name="fee_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									省内流量
								</td>
								<td class=" ">
									<input type="text" id="in_prov_flow_v" name="in_prov_flow_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									省际流量
								</td>
								<td class=" ">
									<input type="text" id="out_prov_flow_v" name="out_prov_flow_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									国内流量
								</td>
								<td class=" ">
									<input type="text" id="nation_flow_v" name="nation_flow_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									包内时长
								</td>
								<td class=" ">
									<input type="text" id="in_time_v" name="in_time_v"></input>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									当月减半优惠
								</td>
								<td class=" ">
									<select id="is_discount_v" name="is_discount_v"
										style="width: 152px">
										<option value="是" selected='selected'>
											是
										</option>
										<option value="否">
											否
										</option>
									</select>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									当前状态
								</td>
								<td class="">
									<select id="status_v" name="status_v"
										style="width: 152px">
										<option value="是" selected='selected'>
											是
										</option>
										<option value="否">
											否
										</option>
									</select>
								</td>
							</tr>
							<tr class="">
								<td class="td_title" align="center" width="20%">
									资费说明
								</td>
								<td class="">
									<textarea id="remark_v" name="remark_v" style="width: 152px"></textarea>
								</td>
							</tr>
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存"
										onClick="save();">
									<input type="button" class="form_button" value="返回"
										onclick="hiddenDiv();">
								</td>
							</tr>
						</table>
					</div>
					<br>
				</div>
			</div>
		</div>
	</body>
</html>
<script>
var win = null;
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


window.onload=function(){
	var result=<%=(String)request.getAttribute("result")%>;
	if(result == null || result=="" ){
	}else{	
		alert(result);
	}
	query();
	aihb.FormHelper.fillSelectWrapper({element:$('cityId'),isHoldFirst:true,sql:"  select area_code key,area_name value from mk.bt_area union select 'HB' key,'全省' value from sysibm.sysdummy1 with ur"});
	var userName = '<%=userid%>';
	if("yanhaitao" == userName || "mengxiaoli" == userName || "meikefu" == userName ||"zhangwei"==userName){
		document.getElementById('updateShow').style.display = '';
	}
};
</script>