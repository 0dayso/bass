
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title>客户价值评审预警信息</title>
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
						<td class='dim_cell_title'>
							<input type="button" class="form_button_short" value="查询" onClick="query()">
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
	var user = '${username}';
	window.onload=function(){
		query();
	}
	
	
	function query(){
		var time = "";
		if($("#date1").val() != null){
			time = $("#date1").val();
		}
		var grid = new aihb.CommonGrid({
			header:_header
			,data :{
				"time" : time
			}
			,url:"${mvcPath}/customer/getAssessForWarningForZFA"
		});
		grid.run();
	}
	
	var _header=[
		{"name":"时间","dataIndex":"time_id","cellStyle":"grid_row_cell_text"}
		,{"name":"地市","dataIndex":"area_name","cellStyle":"grid_row_cell_text"}
		,{"name":"渠道负责人","dataIndex":"username","cellStyle":"grid_row_cell_text"}
		,{"name":"营销活动ID","dataIndex":"fee_id","cellStyle":"grid_row_cell_text"}
		,{"name":"营销活动名称","dataIndex":"fee_name","cellStyle":"grid_row_cell_text"}
		,{"name":"预警原因满意度","dataIndex":"reply_level","cellStyle":"grid_row_cell_text"}
		,{"name":"操作","dataIndex":"id","cellStyle":"grid_row_cell","cellFunc":"oper"}
	];
	
	function oper(val,options){
		var _obj=$C("div");
		_aEdit=$C("a");
		_aEdit.href="javascript:void(0)";
		_aEdit.appendChild($CT("评估"));
		_aEdit.record=options.record;
		if (options.record.reply_level=='通过' || options.record.reply_level=='不通过'){
			_aEdit.disabled=true;
		}else{
			_aEdit.onclick=function(){
				var mid = options.record.fee_id;
				mid = mid.replace(/(^\s*)|(\s*$)|(\.)/g, "");
				tabAdd({title:"营销案（事中预警）评估",id: mid,url:"${mvcPath}/customer/warningForAssessForZFA?fee_id="+options.record.fee_id+"&time_id="+options.record.time_id+"&area_code="+options.record.area_code+"&type=4"});
			}
		}
		_obj.appendChild(_aEdit);
		_obj.appendChild($CT(" "));
		
		return _obj;
	}
	window.oper=oper;
	</script>
</html>