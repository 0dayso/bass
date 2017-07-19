<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title>客户价值预警信息</title>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	
</head>
<body>
  	<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title'>时间</td>
						<td class='dim_cell_content'>
							<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:false,dateFmt:'yyyyMM'})" class="Wdate"/>
						</td>
						<td class='dim_cell_title'>营销类型</td>
						<td class='dim_cell_content4'>
							<select id="channel" name="channel"  style="width: 100px">    
						</td>
						<td class='dim_cell_title'>回复状态</td>
						<td class='dim_cell_content4'>
							<select id="status" name="status"  style="width: 100px">
								<option value=''>全部</option>
								<option value='未回复'>未回复</option>
								<option value='待评估'>待评估</option>
								<option value='已驳回'>已驳回</option>
								<option value='已归档'>已归档</option>
							</select> 
						</td>
						<td class='dim_cell_title'>
							<input type="button" class="form_button_short" value="查询" onClick="query()">
						</td>
					</tr>
				</table>
			</div>
			<br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
				预警规则：半年以放号在1000户以上用户
				</table>
			</div>
			<br>
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
	
	var user =  '${username}';
	window.onload=function(){
		getChannelInit();
		query();
	}
	
	function query(){
		var time = "";
		if($("#date1").val()!=null){
			time = $("#date1").val();
		}
		var channel = "";
		if($("#channel").val()!=null){
			channel = $("#channel").val();
		}
		var status = "";
		if($("#status").val()!=null){
			status = $("#status").val();
		}
		var grid = new aihb.CommonGrid({
			header:_header
			,data :{
				"time" : time,
				"channel" : channel,
				"status" : status
			}
			,url:"${mvcPath}/customer/getWarningListForQDKZ"
		});
		grid.run();
	}
	
	function getChannelInit(){
		var channel = document.getElementById("channel");
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/getChannel"
			,dataType : "json"
			,success: function(data){
				channel.length=0;//清空下拉框 只留下提示项
				channel[0] = new Option("全部","");
				for(var i=0;i<data.length;i++){
					var ret = data[i];
					var channelCode = ret.key;
		      		channel[i+1]=new Option(channelCode,channelCode);
		   		}
			}
		})
	}
	
	var _header=[
		{"name":"时间","dataIndex":"time_id","cellStyle":"grid_row_cell_text"}
		,{"name":"地市","dataIndex":"area_name","cellStyle":"grid_row_cell_text"}
		,{"name":"营销类型","dataIndex":"act_type","cellStyle":"grid_row_cell_text"}
		,{"name":"活动ID","dataIndex":"fee_id","cellStyle":"grid_row_cell_text"}
		,{"name":"活动名称","dataIndex":"fee_name","cellStyle":"grid_row_cell_text"}
		,{"name":"姓名","dataIndex":"username","cellStyle":"grid_row_cell_text"}
		,{"name":"手机号码","dataIndex":"mobilephone","cellStyle":"grid_row_cell_text"}
		,{"name":"状态","dataIndex":"status","cellStyle":"grid_row_cell_text"}
		,{"name":"操作","dataIndex":"time_id","cellStyle":"grid_row_cell","cellFunc":"oper"}
	];
	
	function oper(val,options){
		var _obj=$C("div");
		_aEdit=$C("a");
		_aEdit.href="javascript:void(0)";
		_aEdit.appendChild($CT("回复"));
		_aEdit.record=options.record;
		if (options.record.status=='已归档' || options.record.status=='待评估'){
				_aEdit.disabled=true;
		}else{
			_aEdit.onclick=function(){
				var mid = options.record.fee_id;
				mid = mid.replace(/(^\s*)|(\s*$)|(\.)/g, "");
				tabAdd({title:"渠道监控", id: mid,url:"${mvcPath}/customer/replyForWarningForQDKZ?fee_id="+options.record.fee_id+"&time_id="+options.record.time_id+"&area_code="+options.record.area_code+"&type=3"});
			};
		}
		_obj.appendChild(_aEdit);
		_obj.appendChild($CT(" "));
		
		return _obj;
	}
	window.oper=oper;
		
	</script>
</html>