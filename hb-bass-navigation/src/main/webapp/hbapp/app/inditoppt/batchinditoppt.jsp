<%@page contentType="text/html; charset=utf-8"%>
<%%>
<html xmlns:ai>
	<head>
		<title>批量指标导出PPT</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
		<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="../../resources/js/default/default.js"></script>
		<script type="text/javascript" src="../../resources/js/default/tabext.js"></script>
		<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
		<style type="text/css">
			.dim_cell_title {
				font-family: "宋体";
				font-size: 12px;
				line-height: 20px;
				font-weight: normal;
				font-variant: normal;
				color: #000000;
				background-color: #D9ECF6;
			}		
			.dim_cell_content {
				font-family: "宋体";
				font-size: 12px;
				line-height: 20px;
				color: #000000;
				background-color:#EFF5FB;
			}
		</style>
	</head>
	<body>
		<input type="hidden" id="sid" name="sid" value="">
		<input type="hidden" id="pid" name="pid" value="">
		<div id="title" style="margin: 20 px; text-align: center; font-size: 22px; font-weight: bold; font-family: 黑体">
			批量指标导出PPT
		</div>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
								<img flag='1' src="../../../hbapp/resources/image/default/ns-expand.gif"></img>
								&nbsp;选择条件区域：
							</td>
						</tr>
					</table>
				</legend>
				<div id="dim_div">
					<form action="">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
							<tr class='dim_row'>
								<td class='dim_cell_title' >
									统计日期
								</td>
								<td class='dim_cell_content' >
									<ai:dim name='date' dbName="time_id" operType="int">
										<script type='text/javascript'>var calendar_date=new Calendar('calendar_date');document.write(calendar_date);</script>
										<table cellspacing='0' cellpadding='0' style='width: 120px; height: 22px; border: 1px solid #999999; background-color: #FFFFFF;'>
											<tr>
												<td>
													<input type='text' name='date' id='date' value='' onchange="if(calendar_date.callback)calendar_date.callback(this.value)" style='border: 0 none; padding: 1px 0 0 3px; width: 76px' />
												</td>
												<td align='right' style='padding-right: 2 px;'>
													<span class='calendarimage' onclick="calendar_date.showMoreDay = true;calendar_date.show($('date'),this)"></span>
												</td>
											</tr>
										</table>
									</ai:dim>
								</td>

								<td class='dim_cell_title' >
									指标
								</td>
								<!-- td class='dim_cell_content'>
									KPI种类：
									<select id="appName" name="appName" onchange="_indicatorDraw()">
										<option value="ChannelD">
											日KPI
										</option>
										<option value="ChannelM">
											月KPI
										</option>
										<option value="BureauD">
											区域化日KPI
										</option>
										<option value="BureauM">
											区域化月KPI
										</option>
										<option value="GroupcustD">
											集团日KPI
										</option>
										<option value="GroupcustM">
											集团月KPI
										</option>
										<option value="CollegeD">
											高校日KPI
										</option>
										<option value="CollegeM">
											高校月KPI
										</option>
									</select>
									<select name="list1" id="list1" multiple size="8" style="width: 220" ondblclick="moveOption(this.form.list1, this.form.list2)"></select>
									<input type="button" class="form_button_short" value="添加" onclick="moveOption(this.form.list1, this.form.list2)">
									<input type="button" class="form_button_short" value="删除" onclick="moveOption2(this.form.list2, this.form.list1)">
									<select name="list2" id="list2" multiple size="8" style="width: 220" ondblclick="moveOption2(this.form.list2, this.form.list1)"></select>
									指标类型：
									<select id="zbKind" name="zbKind" onchange="_indicatorDraw()">
										<option value="">
											全部
										</option>
										<option value="user">
											用户
										</option>
										<option value="income">
											收入
										</option>
										<option value="traffic">
											话务
										</option>
									</select>
								</td!-->
								<td class='dim_cell_content'>
									<select id="list2" name="list2" multiple size="5" style="width: 220">
										<option value="K10005">当月累计通话用户数</option>
										<option value="K11006">移动通话用户市场份额</option>
										<option value="KC0001">净增用户数</option>
										<option value="K10006">计费时长</option>
										<option value="K10002">出账收入</option>
									</select>
								</td>									
							</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="导出PPT" onclick="down()">
									&nbsp;
								</td>
							</tr>
						</table>
					</form>
				</div>
			</fieldset>
		</div>
		<br>
	</body>
</html>
<script>
function hideTitle(el,objId)
{
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

function _check(){
	if($("list2").length==0){
		alert("您必须选择一个以上的指标");
		return  false;
	}
	return true;
}
			
function down(){
	if(!_check())return;
	
	var elems = $("list2");
	var ids = "";
	var names = "";
	for(var i=0; i< elems.length;i++){
		if(elems[i] && elems[i].selected == false){
			continue;
		}
		if(ids.length>0)ids +=",";
		ids += elems[i].value;
		if(names.length>0)names +=",";
		names += elems[i].text;
	}
	//alert(ids);
	//alert(names);
	//alert("date="+$("date").value+"&ids="+ids);
	window.location="${mvcPath}/hbirs/action/indiToPpt?method=transfer&date="+$("date").value+"&ids="+ids;
	//document.forms[0].submit();
}

function _indicatorDraw(_callback,list){
	var _ajax = new aihb.Ajax({
	url : "${mvcPath}/hbirs/action/dynamicrpt?method=appIndicators"
	,parameters : "appName=ChannelD"+"&zbKind="+$("zbKind").value
	,callback : function(xmlrequest){
			var datas = eval(xmlrequest.responseText);
			//alert(xmlrequest.responseText);
			//alert(datas);
			var _container =document.forms[0].list1;
			_container.length=0;
			$("list2").length=0;
			for(var i=0; i< datas.length;i++){
				_container[i]=new Option(datas[i].name,datas[i].key);
			}
			if(_callback)_callback(list);
		}
	});
	_ajax.request();
}

/*
*  两个下拉列表 元素左右互换  指操作选择了项目进行添加和删除
* @e1 源列表
* @e2 目标列表
*/

function moveOption(e1, e2){
	try{
		for(var i=0;i<e1.options.length;i++){
			if(e1.options[i].selected){
				var e = e1.options[i];
				e2.options.add(new Option(e.text, e.value));
				e1.remove(i);
				i=i-1
			}
		}
		
	}
	catch(e){}
}

function moveOption2(e1, e2){
	try{
		for(var i=0;i<e1.options.length;i++){
			if(e1.options[i].selected){
				var e = e1.options[i];
				e2.options.add(new Option(e.text, e.value));
				e1.remove(i);
				i=i-1
			}
		}
		
	}
	catch(e){}
}
</script>