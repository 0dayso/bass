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
		<div class="divinnerfieldset">
				<fieldset>
					<legend><table><tr>
					<td><img src="${mvcPath}/resources/image/default/ns-expand.gif" alt=""></img>&nbsp;历史数据展现区域：</td>
						<td></td>
					</tr></table>
				</legend>
				<div style="overflow-y:auto; overflow-x:auto; width:1325px;">
				<div id="grid" style="display: none;"></div>
				</div>
			</fieldset>
		</div><br>
<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title' align="right">时间:&nbsp;&nbsp;&nbsp;</td>
						<td class='dim_cell_content' align="left">
							&nbsp;&nbsp;&nbsp;${time_id}
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title' align="right">地市:&nbsp;&nbsp;&nbsp;</td>
						<td class='dim_cell_content' align="left">
							&nbsp;&nbsp;&nbsp;${area_name}
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title' align="right">营销活动ID:&nbsp;&nbsp;&nbsp;</td>
						<td class='dim_cell_content' align="left">
							&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="view()"><span style="color:red;">${fee_id}</span></a>
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title' align="right">营销活动名称:&nbsp;&nbsp;&nbsp;</td>
						<td class='dim_cell_content' align="left">
							&nbsp;&nbsp;&nbsp;${fee_name}
						</td>
					</tr>
					<tr class='dim_row'>
						<td class='dim_cell_title' align="right">营销活动类型:&nbsp;&nbsp;&nbsp;</td>
						<td class='dim_cell_content' align="left">
							&nbsp;&nbsp;&nbsp;${act_type}
						</td>
					</tr>
					<#list replyList as list1>
						<tr class='dim_row'>
							<td class='dim_cell_title' align="right">回复内容:&nbsp;&nbsp;&nbsp;</td>
							<#if list1.reply_level=="0">
								<td class='dim_cell_content' align="left">
									&nbsp;&nbsp;&nbsp;${list1.reply_content}
								</td>
							<#else>
								<td class='dim_cell_content' align="left">
									<textarea id="replyContent" cols=65 rows=6></textarea>
								</td>
							</#if>
						</tr>
					</#list>
					<tr class='dim_row' align="center">
						<td class='dim_cell_title'  colspan='2'>
							<input type="button" id="button1" class="form_button_short" value="保存" onClick="save()">
						</td>
					</tr>
				</table>
			</div>
	</form>
</body>
</html>
<script type="text/javascript">
	window.onload=function(){
		query();
	}
	
	function view(){
		var time='${time_id}';
        var fee_id="fee_id$"+'${fee_id}';
		tabAdd({title:'客户价值营销案（事中预警）号码级清单明细',id: 16041, url:"${mvcPath}/report/16041?time="+time+"&condition="+fee_id});
	}
	
	function query(){
		var fee_id = '${fee_id}';
		var grid = new aihb.CommonGrid({
			header:_header
			,data :{
				"feeId" : fee_id
			}
			,url:"${mvcPath}/customer/getWariningReply"
		});
		grid.run();
	}
	
	var _header=[
		{"name":"时间","dataIndex":"time_id","cellStyle":"grid_row_cell_text"}
		,{"name":"地市","dataIndex":"area_name","cellStyle":"grid_row_cell_text"}
		,{"name":"活动ID","dataIndex":"fee_id","cellStyle":"grid_row_cell_text"}
		,{"name":"活动名称","dataIndex":"fee_name","cellStyle":"grid_row_cell_text"}
		,{"name":"营销类型","dataIndex":"act_type","cellStyle":"grid_row_cell_text"}
		,{"name":"负价值用户占比","dataIndex":"low_value_rate","cellStyle":"grid_row_cell_text"}
		,{"name":"客户收入","dataIndex":"income","cellStyle":"grid_row_cell_text"}
		,{"name":"客户成本","dataIndex":"cost","cellStyle":"grid_row_cell_text"}
		,{"name":"其中客户直接收入","dataIndex":"direct_income","cellStyle":"grid_row_cell_text"}
		,{"name":"其中客户直接成本","dataIndex":"direct_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"直接成本占收比","dataIndex":"direct_cost_rate","cellStyle":"grid_row_cell_text"}
		,{"name":"社会渠道酬金","dataIndex":"soc_chl_reward","cellStyle":"grid_row_cell_text"}
		,{"name":"终端促销成本","dataIndex":"term_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"礼品促销成本","dataIndex":"gift_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"积分兑换成本","dataIndex":"score_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"坏账准备","dataIndex":"bad_debt_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"其他","dataIndex":"other_cost","cellStyle":"grid_row_cell_text"}
		,{"name":"回复内容","dataIndex":"reply_content","cellStyle":"grid_row_cell_text"}
	];

	function save(){
		var time_id = '${time_id}';
		var area_code = '${area_code}';
		var fee_id = '${fee_id}';
		var fee_name = '${fee_name}';
		var reply_content = $("#replyContent").val();
		if(reply_content==''||reply_content==null){
			alert("请填写回复内容");
			return;
		}
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/addReply"
			,data: "time_id="+time_id+"&area_code="+area_code+"&fee_id="+fee_id+"&fee_name="+fee_name+"&type=1&reply="+reply_content
			,dataType : "json"
			,success: function(data){
	    		alert(data);
	    		if(data == "新增成功"){
	    			$("#button1").attr("disabled","disabled");
		    	}
	   		}
		});
	}
</script>