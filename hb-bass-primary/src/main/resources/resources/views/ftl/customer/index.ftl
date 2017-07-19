<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title>客户价值地市分公司预警人员配置</title>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	
</head>
<body>
  	<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title'>地市</td>
						<td class='dim_cell_content4'>
							<select id="city" name="city"  style="width: 100px">        
						</td>
						<td class='dim_cell_title'>预警类型</td>
						<td class='dim_cell_content4'>
							<select id="type" name="type"  style="width: 100px">  
								<option value="" selected>全部</option> 
								<option value="1">营销案(事中预警)</option> 
								<option value="2">营销案(绩效评估预警)</option> 
								<option value="3">渠道监控预警</option> 
								<option value="4">资费案</option>
							</select> 
						</td>
						<td class='dim_cell_title'>姓名</td>
						<td class='dim_cell_content4'>
							<input align="right" type="text" id="username" name="username"/>
						</td>
						<td class='dim_cell_title'>
							<input type="button" class="form_button_short" value="查询" onClick="query()">
							<input type="button" class="form_button_short" value="新增" onClick="add()">
						</td>
					</tr>
				</table>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend><table><tr>
					<td><img src="${mvcPath}/resources/image/default/ns-expand.gif" alt=""></img>&nbsp;数据展现区域：</td>
						<td></td>
					</tr></table>
				</legend>
				<div id="grid" style="display: none;"></div>
			</fieldset>
		</div><br>
	</form>
  </body>
<script type="text/javascript">
	window.onload=function(){
		getCityInit();
		query();
	}
	
	function query(){
		var cityId = "";
		if($("#city").val() != null){
			cityId = $("#city").val();
		}
		var userName = "";
		if($("#username").val() != null){
			userName = $("#username").val();
		}
		var type ="";
		if($("#type").val() != null){
			type = $("#type").val();
		}
		var grid = new aihb.CommonGrid({
			header:_header
			,data :{
				"cityId" : cityId,
				"userName" : userName,
				"type" : type
			}
			,url:"${mvcPath}/customer/getCustUserList"
		});
		grid.run();
	}
	
	var _header=[
		{"name":"ID","dataIndex":"id","cellStyle":"grid_row_cell_text"}
		,{"name":"地市","dataIndex":"area_name","cellStyle":"grid_row_cell_text"}
		,{"name":"预警类型","dataIndex":"type","cellStyle":"grid_row_cell_text"}
		,{"name":"姓名","dataIndex":"username","cellStyle":"grid_row_cell_text"}
		,{"name":"手机号码","dataIndex":"mobilephone","cellStyle":"grid_row_cell_text"}
		,{"name":"操作","dataIndex":"id","cellStyle":"grid_row_cell","cellFunc":"oper"}
	];
	
	function oper(val,options){
		var _obj=$C("div");
		_aEdit=$C("a");
		_aEdit.href="javascript:void(0)";
		_aEdit.appendChild($CT("删除"));
		_aEdit.record=options.record;
		_aEdit.onclick=function(){
			$.ajax({
				type: "post"
				,url: "${mvcPath}/customer/deleteConfig"
				,data: "id="+encodeURIComponent(this.record.id)
				,dataType : "json"
				,success: function(data){
		    		alert(data);
		    		if(data == "删除成功"){
		    			location.reload();
			   		}
		   		}
			});
		}
		_obj.appendChild(_aEdit);
		_obj.appendChild($CT(" "));
		
		return _obj;
	}
	window.oper=oper;
	
	function getCityInit(){
		var value = "${cityid}";
		var city = document.getElementById("city");
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/getCity"
			,dataType : "json"
			,success: function(data){
				city.length=0;
				city[0] = new Option("全部","");
				for(var i=0;i<data.length;i++){
					var ret = data[i];
					var cityId = ret.key;
					var cityName = ret.value;
		      		city[i+1]=new Option(cityName,cityId);
		   		}
			}
		})
	}
	
	function initCity(_iCityValue, city){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/getCity"
			,dataType : "json"
			,success: function(data){
				_iCityValue.length=0;//清空下拉框 只留下提示项
				for(var i=0;i<data.length;i++){
					var ret = data[i];
					var cityId = ret.key;
					var cityName = ret.value;
		      		_iCityValue[i]=new Option(cityName,cityId);
		      		if(cityId==city){
		      			_iCityValue[i].selected = true;
		      		}
		   		}
			}
		})
	}
	
var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});
function add(elements){
	elements=elements||{};
	_cont.innerHTML="";
	
	var _iCityValue=$C("select");
	_iCityValue.id="ipt_cityValue";
	initCity(_iCityValue,elements.city);

	var _iType=$C("select");
	_iType.id="ipt_typeValue";
	_iType.value=elements.type||"";
	_iType[0]=new Option("营销案(事中预警)","1");
	_iType[1]=new Option("营销案(绩效评估预警)","2");
	_iType[2]=new Option("渠道监控预警","3");
	_iType[3]=new Option("资费案","4");
	
	var _iUserName=$C("input");
	_iUserName.id="ipt_username";
	_iUserName.type="text";
	_iUserName.value=elements.username||"";
	
	var _iMobilephone=$C("input");
	_iMobilephone.id="ipt_mobilephone";
	_iMobilephone.type="text";
	_iMobilephone.value=elements.mobilephone||"";
	
	_cont.appendChild($CT("地市： "));
	_cont.appendChild(_iCityValue);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("预警类型： "));
	_cont.appendChild(_iType);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("姓名："));
	_cont.appendChild(_iUserName);
	_cont.appendChild($C("BR"));
	_cont.appendChild($CT("手机号码：  "));
	_cont.appendChild(_iMobilephone);
	_cont.appendChild($C("BR"));
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.value="保存";
	iBtn.id=elements.id;
	iBtn.onclick=function(){
		if($("#ipt_cityValue").val().trim()==""){
			alert("所属地市不能为空");
			return;
		}	
		if($("#ipt_username").val().trim()==""){
			alert("姓名不能为空");
			return;
		}
		if($("#ipt_mobilephone").val().trim()==""){
			alert("手机号码不能为空");
			return;
		}
		if($("#ipt_mobilephone").val().trim().length!=11){
			alert("手机号码不对");
			return;
		}
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/saveConfig"
			,data: "city="+encodeURIComponent($("#ipt_cityValue").val())+"&type="+encodeURIComponent($("#ipt_typeValue").val())+"&username="+encodeURIComponent($("#ipt_username").val())+"&mobilephone="+encodeURIComponent($("#ipt_mobilephone").val())
			,dataType : "json"
			,success: function(data){
     			alert(data);
     			if(data == "新增成功"){
     				location.reload();
	     		}
   			}
		});
	}
	_cont.appendChild(iBtn);
	
	_mask.show();
}
		
	</script>
</html>