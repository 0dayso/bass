<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>终端机型维护</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
		<%@include file="../include.jsp"%>
	</head>
	<body style="margin: 0px;">
		<div style="margin-top: 20px; margin-left: 10px; margin-right: 10px;">
			<table align='center' width='95%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0' style="display: ''">
				<tr class='dim_row'>
					<td class="dim_cell_title">
						&nbsp;设备号
					</td>
					<td class="dim_cell_content">
						<input type="text" id="deviceId" size="22">
					</td>
					<td class="dim_cell_title">
						&nbsp;生产厂家/品牌
					</td>
					<td class="dim_cell_content">
						<input type="text" id="prodQ">
					</td>
					<td class="dim_cell_title">
						&nbsp;机型
					</td>
					<td class="dim_cell_content">
						<input type="text" id="deviceName" size="22">
					</td>
				</tr>
				<tr class='dim_row'>
					<td class="dim_cell_title">
						&nbsp;状态
					</td>
					<td class="dim_cell_content">
						<select id="status" onchange="changeStatus()">
							<option value='1'>待维护</option>
							<option value='2'>待审批</option>
							<option value='3'>已维护</option>
							<option value='4'>已审批</option>
						</select>
					</td>
					<td class="dim_cell_title">
					</td>
					<td class="dim_cell_content">
					</td>
					<td class="dim_cell_title">
					</td>
					<td class="dim_cell_content">
					</td>
				</tr>
			</table>
			<table align="center" width="95%" style="margin-top:2px;margin-right:0px;margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="left">
						<span>
							<div style="DISPLAY: ''">
								【提示】：双击可进行维护
							</div> 
						</span>
					</td>
					<td align="right">
						<input type="button" class="form_button" id="query_btn" value="查询" onClick="query()">
						<input type="button" class="form_button" id="add_btn" value="新增" onClick="showImeiPanelForAdd()">
						<input type="button" class="form_button" id="update_btn" value="修改" onClick="showImeiPanelForUpdate()">
						<input type="button" class="form_button" id="audit_btn" value="审批" onClick="showImeiPanelForAudit()">
						<input type="button" class="form_button" id="log_btn" value="日志" onClick="showAuditLog()">
					</td>
				</tr>
			</table>
		</div>
		<div id="grid" style="margin-left: 35px; margin-right: 0px; width: 100%">
		</div>
		<div id="win1"></div>
		<div id="addImeiDiv"></div>
		<div id="win2"></div>
		<div id="updateImeiDiv"></div>
		<div id="auditImeiWin"></div>
		<div id="auditImeiDiv"></div>
		<div id="auditLogWin"></div>
		<div id="auditLogDiv"></div>
	</body>
</html>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
Ext.onReady(function() {
	Ext.QuickTips.init();
	<%
	List codeList = new ArrayList();
	codeList.add("imei");
	codeList.add("device_id");
	codeList.add("prod");
	codeList.add("device_name");
	codeList.add("tac_size");
	codeList.add("weigth");
	codeList.add("style");
	codeList.add("announced_date");
	codeList.add("custom_made");
	codeList.add("first_price");
	codeList.add("purchase_price");
	codeList.add("market_price");
	codeList.add("prod_state");
	codeList.add("term_type");
	codeList.add("flag_3g");
	codeList.add("type_3g");
	codeList.add("double_card");
	codeList.add("double_card_type");
	codeList.add("double_model");
	codeList.add("double_model_type");
	codeList.add("ussd");
	codeList.add("ota");
	codeList.add("longsms");
	codeList.add("mms");
	codeList.add("email");
	codeList.add("radio");
	codeList.add("gprs");
	codeList.add("wifi");
	codeList.add("gps");
	codeList.add("nfc");
	codeList.add("java");
	codeList.add("wap");
	codeList.add("wap_version");
	codeList.add("edge");
	codeList.add("wap_push");
	codeList.add("wlan");
	codeList.add("cmmb");
	codeList.add("bluetooth");
	codeList.add("infrared");
	codeList.add("usb");
	codeList.add("smartphone");
	codeList.add("operate_system");
	codeList.add("system_version");
	codeList.add("cpu_model");
	codeList.add("cpu_type");
	codeList.add("cpu_frequency");
	codeList.add("screen_num");
	codeList.add("screen_material");
	codeList.add("screen_size");
	codeList.add("pixel");
	codeList.add("resoution_ratio");
	codeList.add("line_width");
	codeList.add("touch_panel");
	codeList.add("touch_panel_type");
	codeList.add("battery_capacity");
	codeList.add("standby_time");
	codeList.add("call_time");
	codeList.add("keyboard_type");
	codeList.add("camera_num");
	codeList.add("camera_pixel");
	codeList.add("ram");
	codeList.add("rom");
	codeList.add("extended_card");
	codeList.add("extended_card_type");
	codeList.add("extended_max_memory");
	codeList.add("sim_card_type");
	codeList.add("self_business");
	codeList.add("other_business");
	codeList.add("flag");

	List nameList = new ArrayList();
	nameList.add("TAC号段");
	nameList.add("设备号");
	nameList.add("生产厂家/终端品牌");
	nameList.add("机型");
	nameList.add("尺寸");
	nameList.add("重量");
	nameList.add("外观");
	nameList.add("上市时间");
	nameList.add("是否定制机");
	nameList.add("首次上市价格");
	nameList.add("采购价");
	nameList.add("当前市场价");
	nameList.add("生产状态");
	nameList.add("终端类型");
	nameList.add("是否3G");
	nameList.add("3G手机制式");
	nameList.add("支持双卡");
	nameList.add("双卡类型");
	nameList.add("支持双模");
	nameList.add("双模类型");
	nameList.add("是否支持USSD");
	nameList.add("是否支持OTA");
	nameList.add("是否支持长短信");
	nameList.add("是否支持彩信");
	nameList.add("是否支持手机邮箱");
	nameList.add("是否支持收音机功能");
	nameList.add("是否支持GPRS");
	nameList.add("是否支持WIFI");
	nameList.add("是否支持GPS定位");
	nameList.add("是否支持NFC");
	nameList.add("是否支持Java");
	nameList.add("是否支持wappush");
	nameList.add("WAP版本");
	nameList.add("是否支持EDGE");
	nameList.add("是否支持WAP_PUSH");
	nameList.add("是否支持WLAN");
	nameList.add("是否支持CMMB");
	nameList.add("是否支持蓝牙");
	nameList.add("是否支持红外");
	nameList.add("是否支持USB传输");
	nameList.add("是否智能手机");
	nameList.add("操作系统");
	nameList.add("出厂系统版本");
	nameList.add("CPU型号");
	nameList.add("CPU类型");
	nameList.add("CPU主频");
	nameList.add("屏幕个数");
	nameList.add("主屏材质");
	nameList.add("主屏尺寸");
	nameList.add("主屏像素");
	nameList.add("主屏分辨率");
	nameList.add("行宽(中文字符数)");
	nameList.add("是否触摸屏");
	nameList.add("触摸屏类型");
	nameList.add("电池容量");
	nameList.add("待机时间(小时)");
	nameList.add("通话时间(分钟)");
	nameList.add("键盘类型");
	nameList.add("摄像头个数");
	nameList.add("前置摄像头像素");
	nameList.add("手机内存大小(RAM)");
	nameList.add("手机内存大小(ROM)");
	nameList.add("是否可扩展存储卡");
	nameList.add("扩展存储卡类型");
	nameList.add("扩展存储卡支持最大容量");
	nameList.add("SIM卡类型");
	nameList.add("自有业务");
	nameList.add("主流第三方业务");
	nameList.add("数据更新状态");
	%>
	
	//生成查询字段
	<%
	String columns = "";
	for(int i=0;i<codeList.size();i++){
		if(i==0){
			columns = (String)codeList.get(i);
		}else{
			columns += ","+(String)codeList.get(i);
		}
	}
	String columnsWithoutFlag = "";
	for(int i=0;i<codeList.size()-1;i++){
		if(i==0){
			columnsWithoutFlag = (String)codeList.get(i);
		}else{
			columnsWithoutFlag += ","+(String)codeList.get(i);
		}
	}
	%>
	
	// <!-------------------------------------结果列表_Begin------------------------------------->
	var store = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		},
		<%
		String storeArray = "[";
		for(int i=0;i<codeList.size();i++){
			if(i==0){
				storeArray += "{name:\""+(String)codeList.get(i)+"\"}";
			}else{
				storeArray += ",{name:\""+(String)codeList.get(i)+"\"}";
			}
		}
		storeArray += "]";
		out.print(storeArray);
		%>
		)
	});
	var cm = new Ext.grid.ColumnModel(// 表头
	[ new Ext.grid.CheckboxSelectionModel(), 
	   <%
		String columnModelArray = "";
		for(int i=0;i<codeList.size();i++){
			if(i==0){
				columnModelArray += "{header:\""+(String)nameList.get(i)+"\",width:150,sortable:true,dataIndex:\""+(String)codeList.get(i)+"\"}";
			}else{
				columnModelArray += ",{header:\""+(String)nameList.get(i)+"\",width:150,sortable:true,dataIndex:\""+(String)codeList.get(i)+"\"}";
			}
		}
		columnModelArray += "";
		out.print(columnModelArray);
		%>
	]);	
	var objTable = new Ext.grid.GridPanel({ // 表格内容
		id : 'objTable',
		store : store,
		sm : new Ext.grid.CheckboxSelectionModel(),
		cm : cm,
		loadMask : true,
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:97%',
		autoWidth : true,
		enableColumnResize : true,
		height : 340,
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : store,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '97%'
		}),
		renderTo : 'grid'
	});
	//双击事件
	objTable.addListener('rowdblclick', rowdblclickFn);        
	function rowdblclickFn(grid, rowindex, e){        
		grid.getSelectionModel().each(function(rec){
			//alert(rec.get(fieldName));
			var flag = rec.get("flag");
			if(flag == '待维护'){
				showImeiPanelForUpdate();
			}else if(flag == '待审批'){
				showImeiPanelForAudit();
			}
		});
	};
	// <!-------------------------------------结果列表_End--------------------------------------->
	
	//新增IMEI的form
	var form1 = new Ext.form.FormPanel({
		id : 'form1',
		width : 400,
		height : 400,
		autoScroll:true, 
		frame : true,// 圆角和浅蓝色背景
		hidden : true,
		renderTo : "addImeiDiv",// 呈现
		title : "",
		items : [
				<%
				String form1Array = "";
				for(int i=0;i<codeList.size();i++){
					if(i==0){
						form1Array += "{id:\""+(String)codeList.get(i)+"\",xtype:\"textfield\",fieldLabel:\""+(String)nameList.get(i)+"\",width:200}";
					}else{
						form1Array += ",{id:\""+(String)codeList.get(i)+"\",xtype:\"textfield\",fieldLabel:\""+(String)nameList.get(i)+"\",width:200}";
					}
				}
				form1Array += "";
				out.print(form1Array);
				%>
		        ]
	});
	Ext.get("device_id").on('change', function(e) {
		document.getElementById('device_id').value=document.getElementById('device_id').value.trim();
		getExistDevice();
	});
	
	//修改IMEI的form
	var form2 = new Ext.form.FormPanel({
		id : 'form2',
		width : 400,
		height : 400,
		autoScroll:true, 
		frame : true,// 圆角和浅蓝色背景
		hidden : true,
		renderTo : "updateImeiDiv",// 呈现
		title : "",
		items : [
				<%
				String form2Array = "";
				for(int i=0;i<codeList.size();i++){
					if(i==0){
						form2Array += "{id:\""+(String)codeList.get(i)+"2\",xtype:\"textfield\",fieldLabel:\""+(String)nameList.get(i)+"\",width:200}";
					}else{
						form2Array += ",{id:\""+(String)codeList.get(i)+"2\",xtype:\"textfield\",fieldLabel:\""+(String)nameList.get(i)+"\",width:200}";
					}
				}
				form2Array += "";
				out.print(form2Array);
				%>		         
		        ]
	});
	
//审批
	var form3 = new Ext.form.FormPanel({
		id : 'form3',
		width : 450,
		frame : true,// 圆角和浅蓝色背景
		hidden : true,
		renderTo : "auditImeiDiv",// 呈现
		title : "",
		items : [ {
			id : "auditResult",
			fieldLabel : "审批结果",
			xtype : "combo",
			store : new Ext.data.SimpleStore({
				fields : [ "auditResultId", "auditResultName" ],
				data : [ [ 1, "审批通过" ], [ 2, "审批不通过" ]]
			}),
			valueField : 'auditResultId',
			displayField : 'auditResultName',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183
		}]
	});
	
	
	//<!-----------------------------审批日志列表_Begin----------------------------->
	var auditLogStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'row_num'
		}, {
			name : 'type'
		}, {
			name : 'username'
		}, {
			name : 'create_time'
		}])
	});
	var auditLogCm = new Ext.grid.ColumnModel(// 表头
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "序号",
		width : 40,
		sortable : true,
		dataIndex : 'row_num'
	}, {
		header : "操作类型",
		width : 80,
		sortable : true,
		dataIndex : 'type'
	}, {
		header : "操作人",
		width : 80,
		sortable : true,
		dataIndex : 'username'
	}, {
		header : "操作时间",
		width : 150,
		sortable : true,
		dataIndex : 'create_time'
	}]);
	var auditLogPanel = new Ext.grid.GridPanel({ // 表格内容
		id : 'auditLogPanel',
		store : auditLogStore,
		cm : auditLogCm,
		hidden : true,
		loadMask : true,
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:97%',
		autoWidth : true,
		enableColumnResize : true,
		height : 325,
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : auditLogStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据'
		}),
		renderTo : 'auditLogDiv'
	});
	//<!-----------------------------审批日志列表_End------------------------------->	
});// Ext.onReady结束
/**
 * 查询结果
 */
function query() {
	var store = Ext.getCmp('objTable').getStore();
	var sql = "select <%=columns%>  from nmk.imei_config_all where 1=1 ";
	var status = document.getElementById("status").value;
	if(status == 1){
		sql += " and flag='待维护'";
	}else if(status == 2){
		sql += " and flag='待审批'";
		sql = "select b.* from ("+sql+") a join (select <%=columns%> from nmk.imei_config_all_log where 1=1 and type='新值') b on a.imei=b.imei";
	}else if(status == 3){
		sql = "select <%=columns%> from nmk.imei_config_all_log where 1=1 and creator='"+userId+"' and type='新值'";
	}else if(status == 4){
		sql = "select <%=columns%> from nmk.imei_config_all_log where 1=1 and creator='"+userId+"' and type like '审批%'";
	}
	if($('#prodQ').val()){
		sql += " and prod like '%"+$('#prodQ').val()+"%'";
	}
	if($('#deviceId').val()){
		sql += " and device_id like '%"+$('#deviceId').val()+"%'";
	}
	if($('#deviceName').val()){
		sql += " and device_name like '%"+$('#deviceName').val()+"%'";
	}
	//sql += " order by device_id";
	store.baseParams['ds'] = "jdbc/DWDB";
	store.baseParams['sql'] = sql;
	store.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
}



//打开新增IMEI的窗口
function showImeiPanelForAdd() {
	if(document.getElementById("device_id")) document.getElementById("device_id").readOnly=false;
	<%
	String clearImeiArray = "";
	for(int i=0;i<codeList.size();i++){
		clearImeiArray += "$('#"+(String)codeList.get(i)+"').val('');";
	}
	out.print(clearImeiArray);
	%>
	var mask;// 全局的mask
	var showMask = function(id) {
		mask = new Ext.LoadMask(id, {
			msg : "",
			removeMask : true
		});
		mask.show();
	};
	var hideMask = function() {
		mask.hide();
	};
	var form1 = Ext.getCmp('form1');
	if (!Ext.getCmp('win1')) {
		var win1 = new Ext.Window({
			id : 'win1',
			el : 'addImeiDiv',
			title : '新增imei',
			layout : 'fit',
			modal : true,
			width : 400,
			//autoHeight : true,
			//autoScroll:true,
			//height : 600,
			closeAction : 'hide',
			items : [ form1.show() ],
			buttons : [ {
				text : '确定',//提交form
				handler : function() {
					Ext.getCmp('win1').hide();
					addImei();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('win1').hide();
				}
			} ]
		});
		win1.show();
		if(document.getElementById("imei")) document.getElementById('imei').focus();
	} else {
		Ext.getCmp('win1').show();
		if(document.getElementById("imei")) document.getElementById('imei').focus();
	}
}

function addImei() {
	var imei = $('#imei').val();
	var device_id = $('#device_id').val();
	//判断必填项
	if (!imei) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先填imei！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (!device_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先填TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	
	var sql1 = "insert into nmk.imei_config_all(<%=columns%>) values(";
	<%
	String addImeiStr = "";
	//最后一个必须是flag
	for(int i=0;i<codeList.size()-1;i++){
		if(i==0){
			addImeiStr += "if($('#"+(String)codeList.get(i)+"').val()) sql1 +=\"'\"+$('#"+(String)codeList.get(i)+"').val()+\"'\";  else sql1 +=\"''\";";
		}else{
			addImeiStr += "if($('#"+(String)codeList.get(i)+"').val()) sql1 +=\",'\"+$('#"+(String)codeList.get(i)+"').val()+\"'\";  else sql1 +=\",''\";";
		}
	}
	out.print(addImeiStr);
	%>
	//flag单独给值
	sql1 += ",'待审批'";
	sql1 += ")";
	
	var sql2 = "insert into nmk.imei_config_all_log (<%=columns%>,create_time,creator,type) values(";
	<%
	String addImeiLogStr = "";
	//最后一个必须是flag
	for(int i=0;i<codeList.size()-1;i++){
		if(i==0){
			addImeiLogStr += "if($('#"+(String)codeList.get(i)+"').val()) sql2 +=\"'\"+$('#"+(String)codeList.get(i)+"').val()+\"'\";  else sql2 +=\"''\";";
		}else{
			addImeiLogStr += "if($('#"+(String)codeList.get(i)+"').val()) sql2 +=\",'\"+$('#"+(String)codeList.get(i)+"').val()+\"'\";  else sql2 +=\",''\";";
		}
	}
	out.print(addImeiLogStr);
	%>
	//flag单独给值
	sql2 += ",'待审批'";
	sql2 += ",current timestamp";
	sql2 += ",'"+userId+"'";
	sql2 += ",'新值'";
	sql2 += ")";
	
	//document.write(sql);
	var sql = sql1 + SEPERATOR + sql2;
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在加载数据，请稍候！',
		removeMask : true
	});
	mask.show();
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				Ext.MessageBox.show({
					title : '信息',
					msg : '终端机型新增失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			} else {
				Ext.MessageBox.show({
					title : '信息',
					msg : '终端机型新增成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				mask.hide();
				query();
			}
		},
		failure : function() {
			Ext.MessageBox.show({
				title : '信息',
				msg : '终端机型新增失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
			mask.hide();
		},
		params : {
			'sql' : sql,
			'ds'  : DW_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

function getExistDevice(){
	var device_id = $('#device_id').val();
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			eval("result = (" + obj.responseText + ")");
			if(result.root[0]){
				document.getElementById("device_id").readOnly=true;
				<%
				String getImeiStr = "";
				for(int i=1;i<codeList.size();i++){
					getImeiStr += "$('#"+(String)codeList.get(i)+"').val(result.root[0][\""+(String)codeList.get(i)+"\"]==null ? '':result.root[0][\""+(String)codeList.get(i)+"\"]);document.getElementById(\""+(String)codeList.get(i)+"\").readOnly=true;";
				}
				out.print(getImeiStr);
				%>
			}else{
				<%
				String canFillImeiStr = "";
				for(int i=0;i<codeList.size();i++){
					canFillImeiStr += "document.getElementById(\""+(String)codeList.get(i)+"\").readOnly=false;";
				}
				out.print(canFillImeiStr);
				%>
			}
		},
		failure : function() {
		},
		params : {
			'sql' : "select * from nmk.imei_config_all where flag='正常' and device_id='"+device_id+"' fetch first 1 rows only",
			'ds'  : DW_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

//<!-------------------------修改IMEI_Begin------------------------->
//打开修改IMEI的窗口
function showImeiPanelForUpdate() {
	var imei2 = getSelectedColumnValue(Ext.getCmp('objTable'),"imei");
	<%
	String getImeiForUpdateStr = "";
	for(int i=0;i<codeList.size();i++){
		getImeiForUpdateStr += "$('#"+(String)codeList.get(i)+"2').val(getSelectedColumnValue(Ext.getCmp('objTable'),\""+(String)codeList.get(i)+"\"));";
	}
	out.print(getImeiForUpdateStr);
	%>
	
	//判断必填项
	if (!imei2) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var mask;// 全局的mask
	var showMask = function(id) {
		mask = new Ext.LoadMask(id, {
			msg : "",
			removeMask : true
		});
		mask.show();
	};
	var hideMask = function() {
		mask.hide();
	};
	var form2 = Ext.getCmp('form2');
	if (!Ext.getCmp('win2')) {
		var win2 = new Ext.Window({
			id : 'win2',
			el : 'updateImeiDiv',
			title : '修改TAC号段',
			layout : 'fit',
			modal : true,
			width : 400,
			//autoHeight : true,
			//autoScroll:true,
			//height : 600,
			closeAction : 'hide',
			items : [ form2.show() ],
			buttons : [ {
				text : '确定',//提交form
				handler : function() {
					Ext.getCmp('win2').hide();
					updateImei();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('win2').hide();
				}
			} ]
		});
		win2.show();
		if(document.getElementById("imei2")) document.getElementById('imei2').focus();
	} else {
		Ext.getCmp('win2').show();
		if(document.getElementById("imei2")) document.getElementById('imei2').focus();
	}
}

function updateImei() {
	var imei2 = getSelectedColumnValue(Ext.getCmp('objTable'),"imei");
	//判断必填项
	if (!imei2) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	
	//原值LOG
	var sql = "insert into nmk.imei_config_all_log (<%=columns%>,create_time,creator,type)"	
	        + " select <%=columns%>,current timestamp,'"+userId+"','原值' from nmk.imei_config_all where imei='"+imei2+"'";
	//新值LOG
	var sql2 = "insert into nmk.imei_config_all_log (<%=columns%>,create_time,creator,type) values(";
	<%
	String insertNewLogStr = "";
	for(int i=0;i<codeList.size()-1;i++){
		if(i==0){
			insertNewLogStr += "if($('#"+(String)codeList.get(i)+"2').val()) sql2 +=\"'\"+$('#"+(String)codeList.get(i)+"2').val()+\"'\";  else sql2 +=\"''\";";
		}else{
			insertNewLogStr += "if($('#"+(String)codeList.get(i)+"2').val()) sql2 +=\",'\"+$('#"+(String)codeList.get(i)+"2').val()+\"'\";  else sql2 +=\",''\";";
		}
	}
	out.print(insertNewLogStr);
	%>
	sql2 += ",'待审批'";
	sql2 += ",current timestamp";
	sql2 += ",'"+userId+"'";
	sql2 += ",'新值'";
	sql2 += ")";
	
	var sql3 = "update nmk.imei_config_all ";
	sql3 += " set flag='待审批'";
	sql3 += " where imei='"+imei2+"'";
	//document.write(sql);
	sql += SEPERATOR + sql2 + SEPERATOR + sql3;
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在加载数据，请稍候！',
		removeMask : true
	});
	mask.show();
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				Ext.MessageBox.show({
					title : '信息',
					msg : 'TAC号段修改失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			} else {
				Ext.MessageBox.show({
					title : '信息',
					msg : 'TAC号段修改成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				mask.hide();
				query();
			}
		},
		failure : function() {
			Ext.MessageBox.show({
				title : '信息',
				msg : 'TAC号段修改失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
			mask.hide();
		},
		params : {
			'sql' : sql,
			'ds'  : DW_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}
//<!-------------------------修改IMEI_End  ------------------------->

//打开审批IMEI的窗口
function showImeiPanelForAudit() {
	var imei = getSelectedColumnValue(Ext.getCmp('objTable'),"imei");
	//判断必填项
	if (!imei) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var mask;// 全局的mask
	var showMask = function(id) {
		mask = new Ext.LoadMask(id, {
			msg : "",
			removeMask : true
		});
		mask.show();
	};
	var hideMask = function() {
		mask.hide();
	};
	var form3 = Ext.getCmp('form3');
	if (Ext.getCmp('win3') == null) {
		var win3 = new Ext.Window({
			id : 'win3',
			el : 'auditImeiWin',
			title : '审批',
			layout : 'fit',
			modal : true,
			width : 400,
			//autoHeight : true,
			height : 110,
			closeAction : 'hide',
			items : [ form3.show() ],
			buttons : [ {
				text : '确定',//提交form
				handler : function() {
					Ext.getCmp('win3').hide();
					auditImei();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('win3').hide();
				}
			} ]
		});
		win3.show();
	} else {
		Ext.getCmp('win3').show();
	}
}

function auditImei() {
	var imei = getSelectedColumnValue(Ext.getCmp('objTable'),"imei");
	//判断必填项
	if (!imei) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var auditResult = Ext.getCmp('auditResult').getValue();
	if (!auditResult) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择审批结果！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.ERROR
		});
		return;
	}
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	if(auditResult == 1){
		var sql2 = "insert into nmk.imei_config_all_log (<%=columns%>,create_time,creator,type) (";
		sql2 += "select <%=columnsWithoutFlag%>";
		sql2 += ",'已审批'";
		sql2 += ",current timestamp";
		sql2 += ",'"+userId+"'";
		sql2 += ",'审批通过'";
		sql2 += " from nmk.imei_config_all_log where imei='"+imei+"' and type='新值' order by create_time desc fetch first 1 rows only";
		sql2 += ")";
		
		var sql3 = "update nmk.imei_config_all set ";
		<%
		String updateRecStr = "";
		//最后修改flag
		for(int i=0;i<codeList.size()-1;i++){
			if(i==0){
				updateRecStr += "sql3 += \""+(String)codeList.get(i)+"=(select "+(String)codeList.get(i)+" from nmk.imei_config_all_log where imei='\"+imei+\"' and type='新值' order by create_time desc fetch first 1 rows only)\";";
			}else{
				updateRecStr += "sql3 += \","+(String)codeList.get(i)+"=(select "+(String)codeList.get(i)+" from nmk.imei_config_all_log where imei='\"+imei+\"' and type='新值' order by create_time desc fetch first 1 rows only)\";";
			}
		}
		out.print(updateRecStr);
		%>
		sql3 += ", flag='正常'";
		sql3 += " where imei='"+imei+"'";
		
		//document.write(sql);
		var sql = sql2 + SEPERATOR + sql3;
		var mask = new Ext.LoadMask(Ext.getBody(), {
			msg : '正在加载数据，请稍候！',
			removeMask : true
		});
		mask.show();
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'TAC号段审批失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					mask.hide();
				} else {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'TAC号段审批成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					mask.hide();
					query();
				}
			},
			failure : function() {
				Ext.MessageBox.show({
					title : '信息',
					msg : 'TAC号段审批失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'sql' : sql,
				'ds'  : DW_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}else if(auditResult == 2){
		var sql2 = "insert into nmk.imei_config_all_log (imei,create_time,creator,type) values(";
		sql2 += "'"+imei+"'";
		sql2 += ",current timestamp";
		sql2 += ",'"+userId+"'";
		sql2 += ",'审批不通过'";
		sql2 += ")";
		
		var sql3 = "update nmk.imei_config_all ";
		sql3 += " set flag='审批不通过'";
		sql3 += " where imei='"+imei+"'";
		//document.write(sql);
		var sql = sql2 + SEPERATOR + sql3;
		var mask = new Ext.LoadMask(Ext.getBody(), {
			msg : '正在加载数据，请稍候！',
			removeMask : true
		});
		mask.show();
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'TAC号段审批失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					mask.hide();
				} else {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'TAC号段审批成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					mask.hide();
					query();
				}
			},
			failure : function() {
				Ext.MessageBox.show({
					title : '信息',
					msg : 'TAC号段审批失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'sql' : sql,
				'ds'  : DW_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}

//打开审批日志的窗口
function showAuditLog() {
	var imei = getSelectedColumnValue(Ext.getCmp('objTable'),"imei");
	//判断必填项
	if (!imei) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择TAC号段！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var sql = "select type, username, create_time from nmk.imei_config_all_log,FPF_USER_USER where creator=userid and imei='"+imei+"' order by create_time";
	var auditLogPanel = Ext.getCmp('auditLogPanel');
	var auditLogStore = auditLogPanel.getStore();
	auditLogStore.baseParams['sql'] = sql;
	auditLogStore.baseParams['ds'] = DW_DS;
	auditLogStore.reload({
		params : {
			start : 0,
			limit : 10
		}
	});
	if (Ext.getCmp('auditLogWin') == null ) {
		var win = new Ext.Window({
			id : 'auditLogWin',
			el : 'auditLogDiv',
			title : '日志',
			layout : 'fit',
			width : 450,
			height : 250,
			//autoHeight : true,
			closeAction : 'hide',
			items : [ auditLogPanel.show() ],
			buttons : [ {
				text : '关闭',
				handler : function() {
					Ext.getCmp('auditLogWin').hide();
				}
			} ]
		});
		win.show();
	} else {
		Ext.getCmp('auditLogWin').show();
	}
}

function changeStatus(){
	var status = document.getElementById("status").value;
	if(status == 1){
	    document.getElementById("query_btn").style.display ="";
		document.getElementById("add_btn").style.display   ="";
		document.getElementById("update_btn").style.display="";
		document.getElementById("audit_btn").style.display ="none";
		document.getElementById("log_btn").style.display   ="none";
	}else if(status == 2){
	    document.getElementById("query_btn").style.display ="";
		document.getElementById("add_btn").style.display   ="none";
		document.getElementById("update_btn").style.display="none";
		document.getElementById("audit_btn").style.display ="";
		document.getElementById("log_btn").style.display   ="";
	}else if(status == 3){
	    document.getElementById("query_btn").style.display ="";
		document.getElementById("add_btn").style.display   ="none";
		document.getElementById("update_btn").style.display="none";
		document.getElementById("audit_btn").style.display ="none";
		document.getElementById("log_btn").style.display   ="";
	}else if(status == 4){
	    document.getElementById("query_btn").style.display ="";
		document.getElementById("add_btn").style.display   ="none";
		document.getElementById("update_btn").style.display="none";
		document.getElementById("audit_btn").style.display ="none";
		document.getElementById("log_btn").style.display   ="";
	}
}
changeStatus();
</script>