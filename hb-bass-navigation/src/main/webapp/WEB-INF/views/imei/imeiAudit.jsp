<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>IMEI审批</title>
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
						&nbsp;TAC号段
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
			</table>
			<table align="center" width="95%" style="margin-top:2px;margin-right:0px;margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="left">
						<span>
							<div style="DISPLAY: ''">
								【提示】：双击可进行审批
							</div> 
						</span>
					</td>
					<td align="right">
						<input type="button" class="form_button" value="查询" onClick="query()">
						<input type="button" class="form_button" value="审批" onClick="showImeiPanelForAudit()">
					</td>
				</tr>
			</table>
		</div>
		<div id="grid" style="margin-left: 35px; margin-right: 0px; width: 100%">
		</div>
		<div id="win1"></div>
		<div id="updateImeiDiv"></div>
	</body>
</html>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
Ext.onReady(function() {
	Ext.QuickTips.init();
	// <!-------------------------------------结果列表_Begin------------------------------------->
	var store = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ 
		    {name:"device_id"}
		    ,{name:"prod"}
		    ,{name:"device_name"}
		    ,{name:"tac_size"}
		    ,{name:"weigth"}
		    ,{name:"style"}
		    ,{name:"announced_date"}
		    ,{name:"custom_made"}
		    ,{name:"first_price"}
		    ,{name:"purchase_price"}
		    ,{name:"market_price"}
		    ,{name:"prod_state"}
		    ,{name:"term_type"}
		    ,{name:"double_card"}
		    ,{name:"double_model"}
		    ,{name:"wcdma_net"}
		    ,{name:"gsm_net"}
		    ,{name:"cdma2000_net"}
		    ,{name:"td_net"}
		    ,{name:"ussd"}
		    ,{name:"ota"}
		    ,{name:"longsms"}
		    ,{name:"mms"}
		    ,{name:"email"}
		    ,{name:"radio"}
		    ,{name:"gprs"}
		    ,{name:"wifi"}
		    ,{name:"gps"}
		    ,{name:"nfc"}
		    ,{name:"java"}
		    ,{name:"wap"}
		    ,{name:"cmmb"}
		    ,{name:"bluetooth"}
		    ,{name:"infrared"}
		    ,{name:"usb"}
		    ,{name:"smartphone"}
		    ,{name:"operate_system"}
		    ,{name:"system_version"}
		    ,{name:"cpu_model"}
		    ,{name:"cpu_type"}
		    ,{name:"cpu_frequency"}
		    ,{name:"screen_num"}
		    ,{name:"screen_material"}
		    ,{name:"screen_size"}
		    ,{name:"pixel"}
		    ,{name:"resoution_ratio"}
		    ,{name:"line_width"}
		    ,{name:"battery_capacity"}
		    ,{name:"standby_time"}
		    ,{name:"call_time"}
		    ,{name:"keyboard_type"}
		    ,{name:"camera_num"}
		    ,{name:"camera_pixel"}
		    ,{name:"ram"}
		    ,{name:"rom"}
		    ,{name:"extended_card"}
		    ,{name:"extended_card_type"}
		    ,{name:"extended_max_memory"}
		    ,{name:"sim_card_type"}             
		   ])
	});
	var cm = new Ext.grid.ColumnModel(// 表头
	[ new Ext.grid.CheckboxSelectionModel(), 
	  {header:"TAC号段",width:150,sortable:true,dataIndex:"device_id"}
	,{header:"生产厂家/品牌",width:150,sortable:true,dataIndex:"prod"}
	,{header:"机型",width:150,sortable:true,dataIndex:"device_name"}
	,{header:"尺寸",width:150,sortable:true,dataIndex:"tac_size"}
	,{header:"重量",width:150,sortable:true,dataIndex:"weigth"}
	,{header:"外观",width:150,sortable:true,dataIndex:"style"}
	,{header:"上市时间",width:150,sortable:true,dataIndex:"announced_date"}
	,{header:"是否定制机",width:150,sortable:true,dataIndex:"custom_made"}
	,{header:"首次上市价格",width:150,sortable:true,dataIndex:"first_price"}
	,{header:"采购价",width:150,sortable:true,dataIndex:"purchase_price"}
	,{header:"当前市场价",width:150,sortable:true,dataIndex:"market_price"}
	,{header:"生产状态",width:150,sortable:true,dataIndex:"prod_state"}
	,{header:"终端类型",width:150,sortable:true,dataIndex:"term_type"}
	,{header:"支持双卡",width:150,sortable:true,dataIndex:"double_card"}
	,{header:"支持双模",width:150,sortable:true,dataIndex:"double_model"}
	,{header:"支持WCDMA网络",width:150,sortable:true,dataIndex:"wcdma_net"}
	,{header:"支持GSM网络",width:150,sortable:true,dataIndex:"gsm_net"}
	,{header:"支持CDMA2000网络",width:150,sortable:true,dataIndex:"cdma2000_net"}
	,{header:"支持TD网络",width:150,sortable:true,dataIndex:"td_net"}
	,{header:"是否支持USSD",width:150,sortable:true,dataIndex:"ussd"}
	,{header:"是否支持OTA",width:150,sortable:true,dataIndex:"ota"}
	,{header:"是否支持长短信",width:150,sortable:true,dataIndex:"longsms"}
	,{header:"是否支持彩信",width:150,sortable:true,dataIndex:"mms"}
	,{header:"是否支持手机邮箱",width:150,sortable:true,dataIndex:"email"}
	,{header:"是否支持收音机功能",width:150,sortable:true,dataIndex:"radio"}
	,{header:"是否支持GPRS",width:150,sortable:true,dataIndex:"gprs"}
	,{header:"是否支持WIFI",width:150,sortable:true,dataIndex:"wifi"}
	,{header:"是否支持GPS定位",width:150,sortable:true,dataIndex:"gps"}
	,{header:"是否支持NFC",width:150,sortable:true,dataIndex:"nfc"}
	,{header:"是否支持Java",width:150,sortable:true,dataIndex:"java"}
	,{header:"是否支持wappush",width:150,sortable:true,dataIndex:"wap"}
	,{header:"是否支持CMMB",width:150,sortable:true,dataIndex:"cmmb"}
	,{header:"是否支持蓝牙",width:150,sortable:true,dataIndex:"bluetooth"}
	,{header:"是否支持红外",width:150,sortable:true,dataIndex:"infrared"}
	,{header:"是否支持USB传输",width:150,sortable:true,dataIndex:"usb"}
	,{header:"是否智能手机",width:150,sortable:true,dataIndex:"smartphone"}
	,{header:"操作系统",width:150,sortable:true,dataIndex:"operate_system"}
	,{header:"出厂系统版本",width:150,sortable:true,dataIndex:"system_version"}
	,{header:"CPU型号",width:150,sortable:true,dataIndex:"cpu_model"}
	,{header:"CPU类型",width:150,sortable:true,dataIndex:"cpu_type"}
	,{header:"CPU主频",width:150,sortable:true,dataIndex:"cpu_frequency"}
	,{header:"屏幕个数",width:150,sortable:true,dataIndex:"screen_num"}
	,{header:"主屏材质",width:150,sortable:true,dataIndex:"screen_material"}
	,{header:"主屏尺寸",width:150,sortable:true,dataIndex:"screen_size"}
	,{header:"主屏像素",width:150,sortable:true,dataIndex:"pixel"}
	,{header:"主屏分辨率",width:150,sortable:true,dataIndex:"resoution_ratio"}
	,{header:"行宽(中文字符数)",width:150,sortable:true,dataIndex:"line_width"}
	,{header:"电池容量",width:150,sortable:true,dataIndex:"battery_capacity"}
	,{header:"待机时间(小时)",width:150,sortable:true,dataIndex:"standby_time"}
	,{header:"通话时间(分钟)",width:150,sortable:true,dataIndex:"call_time"}
	,{header:"键盘类型",width:150,sortable:true,dataIndex:"keyboard_type"}
	,{header:"摄像头个数",width:150,sortable:true,dataIndex:"camera_num"}
	,{header:"前置摄像头像素",width:150,sortable:true,dataIndex:"camera_pixel"}
	,{header:"手机内存大小（RAM）",width:150,sortable:true,dataIndex:"ram"}
	,{header:"手机内存大小（ROM）",width:150,sortable:true,dataIndex:"rom"}
	,{header:"是否可扩展存储卡",width:150,sortable:true,dataIndex:"extended_card"}
	,{header:"扩展存储卡类型",width:150,sortable:true,dataIndex:"extended_card_type"}
	,{header:"扩展存储卡支持最大容量",width:150,sortable:true,dataIndex:"extended_max_memory"}
	,{header:"SIM卡类型",width:150,sortable:true,dataIndex:"sim_card_type"}
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
			showImeiPanelForAudit();
		});
	};
	// <!-------------------------------------结果列表_End--------------------------------------->
	
	var form1 = new Ext.form.FormPanel({
		id : 'form1',
		width : 450,
		frame : true,// 圆角和浅蓝色背景
		hidden : true,
		renderTo : "updateImeiDiv",// 呈现
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

});// Ext.onReady结束
/**
 * 查询结果
 */
function query() {
	var store = Ext.getCmp('objTable').getStore();
	var sql = "select distinct device_id, prod, device_name, tac_size, weigth, style, announced_date, custom_made, first_price, purchase_price, market_price, prod_state, term_type, double_card, double_model, wcdma_net, gsm_net, cdma2000_net, td_net, ussd, ota, longsms , mms, email, radio, gprs, wifi, gps, nfc, java, wap, cmmb, bluetooth, infrared, usb, smartphone, operate_system, system_version, cpu_model, cpu_type, cpu_frequency, screen_num, screen_material, screen_size, pixel, resoution_ratio, line_width , battery_capacity, standby_time, call_time, keyboard_type, camera_num, camera_pixel, ram, rom, extended_card, extended_card_type, extended_max_memory, sim_card_type  from nmk.imei_config_all where 1=1 ";
	sql += " and flag='待审批'";
	if($('#prodQ').val()){
		sql += " and prod like '%"+$('#prodQ').val()+"%'";
	}
	if($('#deviceId').val()){
		sql += " and device_id like '%"+$('#deviceId').val()+"%'";
	}
	if($('#deviceName').val()){
		sql += " and device_name like '%"+$('#deviceName').val()+"%'";
	}
	sql = "select b.* from ("+sql+") a join (select distinct device_id, prod, device_name, tac_size, weigth, style, announced_date, custom_made, first_price, purchase_price, market_price, prod_state, term_type, double_card, double_model, wcdma_net, gsm_net, cdma2000_net, td_net, ussd, ota, longsms , mms, email, radio, gprs, wifi, gps, nfc, java, wap, cmmb, bluetooth, infrared, usb, smartphone, operate_system, system_version, cpu_model, cpu_type, cpu_frequency, screen_num, screen_material, screen_size, pixel, resoution_ratio, line_width , battery_capacity, standby_time, call_time, keyboard_type, camera_num, camera_pixel, ram, rom, extended_card, extended_card_type, extended_max_memory, sim_card_type  from nmk.imei_config_all_log where 1=1 and type='新值') b on a.device_id=b.device_id";
	store.baseParams['ds'] = "jdbc/DWDB";
	store.baseParams['sql'] = sql;
	store.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
}

//打开修改IMEI的窗口
function showImeiPanelForAudit() {
	var device_id = getSelectedColumnValue(Ext.getCmp('objTable'),"device_id");
	//判断必填项
	if (!device_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择imei！',
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
	var form1 = Ext.getCmp('form1');
	if (Ext.getCmp('win1') == null) {
		var win1 = new Ext.Window({
			id : 'win1',
			el : 'updateImeiDiv',
			title : '审批',
			layout : 'fit',
			modal : true,
			width : 400,
			//autoHeight : true,
			height : 110,
			closeAction : 'hide',
			items : [ form1.show() ],
			buttons : [ {
				text : '确定',//提交form
				handler : function() {
					Ext.getCmp('win1').hide();
					auditImei();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('win1').hide();
				}
			} ]
		});
		win1.show();
	} else {
		Ext.getCmp('win1').show();
	}
}

function auditImei() {
	var device_id = getSelectedColumnValue(Ext.getCmp('objTable'),"device_id");
	//判断必填项
	if (!device_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择imei！',
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
		var sql2 = "insert into nmk.imei_config_all_log (device_id,create_time,creator,type) values(";
		sql2 += "'"+device_id+"'";
		sql2 += ",current timestamp";
		sql2 += ",'"+userId+"'";
		sql2 += ",'审批通过'";
		sql2 += ")";
		
		var sql3 = "update nmk.imei_config_all ";
		sql3 += "set prod               =(select prod                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", device_name        =(select device_name         from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", tac_size           =(select tac_size            from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", weigth             =(select weigth              from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", style              =(select style               from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", announced_date     =(select announced_date      from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", custom_made        =(select custom_made         from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", first_price        =(select first_price         from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", purchase_price     =(select purchase_price      from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", market_price       =(select market_price        from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", prod_state         =(select prod_state          from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", term_type          =(select term_type           from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", double_card        =(select double_card         from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", double_model       =(select double_model        from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", wcdma_net          =(select wcdma_net           from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", gsm_net            =(select gsm_net             from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", cdma2000_net       =(select cdma2000_net        from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", td_net             =(select td_net              from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", ussd               =(select ussd                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", ota                =(select ota                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", longsms            =(select longsms             from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", mms                =(select mms                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", email              =(select email               from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", radio              =(select radio               from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", gprs               =(select gprs                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", wifi               =(select wifi                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", gps                =(select gps                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", nfc                =(select nfc                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", java               =(select java                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", wap                =(select wap                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", cmmb               =(select cmmb                from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", bluetooth          =(select bluetooth           from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", infrared           =(select infrared            from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", usb                =(select usb                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", smartphone         =(select smartphone          from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", operate_system     =(select operate_system      from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", system_version     =(select system_version      from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", cpu_model          =(select cpu_model           from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", cpu_type           =(select cpu_type            from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", cpu_frequency      =(select cpu_frequency       from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", screen_num         =(select screen_num          from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", screen_material    =(select screen_material     from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", screen_size        =(select screen_size         from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", pixel              =(select pixel               from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", resoution_ratio    =(select resoution_ratio     from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", line_width         =(select line_width          from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", battery_capacity   =(select battery_capacity    from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", standby_time       =(select standby_time        from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", call_time          =(select call_time           from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", keyboard_type      =(select keyboard_type       from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", camera_num         =(select camera_num          from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", camera_pixel       =(select camera_pixel        from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", ram                =(select ram                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", rom                =(select rom                 from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", extended_card      =(select extended_card       from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", extended_card_type =(select extended_card_type  from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", extended_max_memory=(select extended_max_memory from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", sim_card_type      =(select sim_card_type       from nmk.imei_config_all_log where device_id='"+device_id+"' and type='新值' order by create_time desc fetch first 1 rows only)";
		sql3 += ", flag='正常'";
		sql3 += " where device_id='"+device_id+"'";
		
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
						msg : 'imei审批失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					mask.hide();
				} else {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'imei审批成功！',
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
					msg : 'imei审批失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'sql' : sql,
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}else if(auditResult == 2){
		var sql2 = "insert into nmk.imei_config_all_log (device_id,create_time,creator,type) values(";
		sql2 += "'"+device_id+"'";
		sql2 += ",current timestamp";
		sql2 += ",'"+userId+"'";
		sql2 += ",'审批不通过'";
		sql2 += ")";
		
		var sql3 = "update nmk.imei_config_all ";
		sql3 += " set flag='审批不通过'";
		sql3 += " where device_id='"+device_id+"'";
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
						msg : 'imei审批失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					mask.hide();
				} else {
					Ext.MessageBox.show({
						title : '信息',
						msg : 'imei审批成功！',
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
					msg : 'imei审批失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'sql' : sql,
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}
</script>