
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
	window.onload=function(){
		query();
	}
	
	function query(){
		var time = "";
		if($("#date1").val()!=null){
			time = $("#date1").val();
		}
		var grid = new aihb.CommonGrid({
			header:_header
			,data:{
				"time" : time
			}
			,url:"${mvcPath}/customer/getAssessForWarningForQDKZ"
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
				tabAdd({title:"营销案（事中预警）评估",id: mid,url:"${mvcPath}/customer/warningForAssessForQDKZ?fee_id="+options.record.fee_id+"&time_id="+options.record.time_id+"&area_code="+options.record.area_code+"&type=3"});
			}
		}
		_obj.appendChild(_aEdit);
		_obj.appendChild($CT(" "));
		
		return _obj;
	}
	window.oper=oper;
	
	var _cont = $C("div");
	var _mask = aihb.Util.windowMask({content:_cont});
	function reply(elements){
		elements=elements||{};
		_cont.innerHTML="";
		
		var _iTimeId=$C("input");
		_iTimeId.id="ipt_timeId";
		_iTimeId.type="text";
		_iTimeId.disabled=true;
		_iTimeId.value=elements.time_id||"";
		
		var _iAreaName=$C("input");
		_iAreaName.id="ipt_AreaName";
		_iAreaName.type="text";
		_iAreaName.disabled=true;
		_iAreaName.value=elements.area_name||"";
		
		var _iUserName=$C("input");
		_iUserName.id="ipt_username";
		_iUserName.type="text";
		_iUserName.disabled=true;
		_iUserName.value=elements.username||"";
		
		var _iFeeId=$C("input");
		_iFeeId.id="ipt_feeId";
		_iFeeId.size=30;
		_iFeeId.type="text";
		_iFeeId.disabled=true;
		_iFeeId.value=elements.fee_id||"";
		
		var _iFeeName=$C("input");
		_iFeeName.id="ipt_feeName";
		_iFeeName.type="text";
		_iFeeName.size=30;
		_iFeeName.disabled=true;
		_iFeeName.value=elements.fee_name||"";
		
		var _iReply=$C("textarea");
		_iReply.id="ipt_replyContent";
		_iReply.cols=50;
		_iReply.rows=5;
		_iReply.disabled=true;
		_iReply.value=elements.reply_content||"";
		
		var _iReplyLevel=$C("select");
		_iReplyLevel.id="ipt_replyLevel";
		_iReplyLevel.value=elements.reply_level||"";
		_iReplyLevel[0]=new Option("通过","1");
		_iReplyLevel[1]=new Option("不通过","0");
		
		_cont.appendChild($CT("时     间：                  "));
		_cont.appendChild(_iTimeId);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("地     市：                   "));
		_cont.appendChild(_iAreaName);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("渠道负责人：      "));
		_cont.appendChild(_iUserName);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("营销活动ID：      "));
		_cont.appendChild(_iFeeId);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("营销活动名称：  "));
		_cont.appendChild(_iFeeName);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("预警原因：                "));
		_cont.appendChild(_iReply);
		_cont.appendChild($C("BR"));
		_cont.appendChild($CT("预警原因满意度："));
		_cont.appendChild(_iReplyLevel);
		_cont.appendChild($C("BR"));
		var iBtn=$C("input");
		iBtn.type="button";
		iBtn.className="form_button_short";
		iBtn.value="保存";
		iBtn.id=elements.id;
		iBtn.onclick=function(){
			$.ajax({
				type: "post"
				,url: "${mvcPath}/customer/replyLevel"
				,data: "id="+elements.id+"&reply_level="+$("#ipt_replyLevel").val()
				,dataType : "json"
				,success: function(data){
	     			alert(data);
	     			if(data == "评估成功"){
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