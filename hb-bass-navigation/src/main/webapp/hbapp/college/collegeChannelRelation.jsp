<%@ page contentType="text/html; charset=utf-8"%>
<html>
	<head>
		<title>高校渠道信息维护</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<style type="text/css">
.add {
	background-image: url(${mvcPath}/hbapp/resources/image/default/add.gif) !important
		;
}

.remove {
	background-image: url(${mvcPath}/resources/image/default/del.gif)
		!important;
}
</style>
	</head>
	<body>
	</body>
</html>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";

var itemsPerPage = 10;
var DW_DS = "jdbc/DWDB";
var WEB_DS = "jdbc/WEBDB";

var channelTemp = '';
var collegeCodeTemp = '';
var collegeNameTemp = '';
var collegeLeafFlag = '';

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	//地市数据源					
	var cityStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'city_code'
		}, {
			name : 'city_name'
		} ])
    });
    
    //地市下拉列表
	var cityComBox = new Ext.form.ComboBox({
		id:'qryCityId',
	    fieldLabel: '所属地市',
	    store: cityStore,
	    valueField:'city_code',
	    displayField:'city_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText:'请选择',
	    width:200,
	    selectOnFocus:true,
	    listeners:{
	    	'select' : function(combo, record, index){
	    				var countySqlTemp = "select distinct country_id county_code,country_id county_name from nmk.channel_info";
	    				var cityValue = this.getValue();
	    				if(cityValue){
	    					countySqlTemp += " where city_id = '"+cityValue+"'";
	    				}
						countyStore.baseParams['sql'] = countySqlTemp;
						countyStore.baseParams['ds'] = DW_DS;
						countyStore.baseParams['limit'] = 999999;
						countyStore.baseParams['start'] = 0;
						countyStore.reload();
						Ext.getCmp("qryCountyId").setDisabled(false);
	    	}
	    }
	});
	var citySql = "select distinct city_id city_code,city_id city_name from nmk.channel_info";
	
	cityStore.baseParams['sql'] = citySql;
	cityStore.baseParams['ds'] = DW_DS;
	cityStore.baseParams['limit'] = 999999;
	cityStore.baseParams['start'] = 0;
	cityStore.reload();
	
	//县市数据源					
	var countyStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'county_code'
		}, {
			name : 'county_name'
		} ])
    });
    
    //县市下拉列表
	var countyComBox = new Ext.form.ComboBox({
		id:'qryCountyId',
	    fieldLabel: '所属县市',
	    store: countyStore,
	    valueField:'county_code',
	    displayField:'county_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText:'请选择',
	    width:200,
	    selectOnFocus:true,
	    disabled: true,
	    listeners:{
	    	'select' : function(combo, record, index){
	    				var marketOrgSqlTemp = "select distinct market_org_id marketorg_code,market_org_id marketorg_name from nmk.channel_info";
	    				var countyValue = this.getValue();
	    				var cityValue = Ext.getCmp("qryCityId").getValue();
	    				
	    				if(cityValue){
	    					marketOrgSqlTemp += " where city_id = '"+cityValue+"'";
	    				}
	    				if(countyValue){
	    					marketOrgSqlTemp += " and country_id = '"+countyValue+"'";
	    				}
						marketOrgStore.baseParams['sql'] = marketOrgSqlTemp;
						marketOrgStore.baseParams['ds'] = DW_DS;
						marketOrgStore.baseParams['limit'] = 999999;
						marketOrgStore.baseParams['start'] = 0;
						marketOrgStore.reload();
						Ext.getCmp("qryMarketOrgId").setDisabled(false);
	    	}
	    }
	});
	var countySql = "select distinct country_id county_code,country_id county_name from nmk.channel_info";
	
	countyStore.baseParams['sql'] = countySql;
	countyStore.baseParams['ds'] = DW_DS;
	countyStore.baseParams['limit'] = 999999;
	countyStore.baseParams['start'] = 0;
	countyStore.reload();
	
	//区营销中心数据源					
	var marketOrgStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'marketorg_code'
		}, {
			name : 'marketorg_name'
		} ])
    });
    
	//区营销中心下拉列表
	var marketOrgComBox = new Ext.form.ComboBox({
		id: 'qryMarketOrgId',
	    fieldLabel: '区营销中心',
	    store: marketOrgStore,
	    valueField: 'marketorg_code',
	    displayField: 'marketorg_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText: '请选择',
	    width: 200,
	    selectOnFocus: true,
	    disabled: true,
	    listeners: {
	    	'select' : function(combo, record, index){
	    				var townSqlTemp = "select distinct town town_code,town town_name from nmk.channel_info";
	    				var marketOrgValue = this.getValue();
	    				var cityValue = Ext.getCmp("qryCityId").getValue();
	    				var countyValue = Ext.getCmp("qryCountyId").getValue();
	    				
	    				if(cityValue){
	    					townSqlTemp += " where city_id = '"+cityValue+"'";
	    				}
	    				if(countyValue){
	    					townSqlTemp += " and country_id = '"+countyValue+"'";
	    				}
	    				if(marketOrgValue){
	    					townSqlTemp += " and market_org_id = '"+marketOrgValue+"'";
	    				}
						townStore.baseParams['sql'] = townSqlTemp;
						townStore.baseParams['ds'] = DW_DS;
						townStore.baseParams['limit'] = 999999;
						townStore.baseParams['start'] = 0;
						townStore.reload();
						Ext.getCmp("qryTownId").setDisabled(false);
	    	}
	    }
	});
	var marketOrgSql = "select distinct market_org_id marketorg_code,market_org_id marketorg_name from nmk.channel_info";
	
	marketOrgStore.baseParams['sql'] = marketOrgSql;
	marketOrgStore.baseParams['ds'] = DW_DS;
	marketOrgStore.baseParams['limit'] = 999999;
	marketOrgStore.baseParams['start'] = 0;
	marketOrgStore.reload();
	
	//镇数据源					
	var townStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'town_code'
		}, {
			name : 'town_name'
		} ])
    });
    
	//镇下拉列表
	var townComBox = new Ext.form.ComboBox({
		id:'qryTownId',
	    fieldLabel: '所属城镇',
	    store: townStore,
	    valueField:'town_code',
	    displayField:'town_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText:'请选择',
	    width:200,
	    selectOnFocus:true,
	    disabled: true
	});
	var townSql = "select distinct town town_code,town town_name from nmk.channel_info";
	
	townStore.baseParams['sql'] = townSql;
	townStore.baseParams['ds'] = DW_DS;
	townStore.baseParams['limit'] = 999999;
	townStore.baseParams['start'] = 0;
	townStore.reload();
	
	//渠道数据源
	var channelStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'channel_code'
		}, {
			name : 'channel_name'
		}, {
			name : 'city_id'
		}, {
			name : 'country_id'
		}, {
			name : 'market_org_id'
		}, {
			name : 'town'
		}, {
			name : 'village'
		}, {
			name : 'bureau_type'
		}, {
			name : 'channel_type'
		}, {
			name : 'address'
		}, {
			name : 'reponse_name'
		}, {
			name : 'reponse_phone'
		} ])
    });
	
	//高校渠道信息数据源
	var relationStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'area_code'
		}, {
			name : 'county_code'
		}, {
			name : 'college_id'
		}, {
			name : 'college_name'
		}, {
			name : 'channel_code'
		}, {
			name : 'channel_name'
		}, {
			name : 'channel_type'
		} ])
    });

	//全省高校树
	var collegeTreePanel = new Ext.tree.TreePanel({
		id:  "collegeTreePanel",
		title:  "全省高校树",
		region:  'west',
		width: 230,
		split: true,
		containerScroll: true,
		collapseMode: 'mini',
		collapsible: true,
		autoScroll: true,
		useArrows: true,
		animate: true,
		border: true,
		rootVisible: false,
		root: new Ext.tree.AsyncTreeNode({
			text: '湖北 [双击查看明细]',
	        draggable: false,
	        iconCls: 'x-tree-node-icon3',
	        id: '-1'
		}),
		loader: new Ext.tree.TreeLoader({
			dataUrl: '/hbirs/action/areaSaleManage?method=AreanodesByRegionId'
		}),
		listeners: {
			click: function(node, e) {
				var collegeCode = node.attributes.url;
				collegeCodeTemp = collegeCode;
				collegeLeafFlag = node.attributes.leaf;
				collegeNameTemp = node.attributes.text;
				if(collegeLeafFlag){
					var relationSql = "select a.area_code,a.county_code,a.college_id,";
					relationSql += "(select d.college_name from college_info_pt d where d.college_id=a.college_id) college_name,a.channel_code,(select channel_name from nmk.channel_info c where c.channel_code=a.channel_code) channel_name,channel_type from nwh.college_channel_rela_NG a";
					relationSql += " where a.college_id='"+collegeCode+"' order by area_code,county_code,college_id,channel_code";
					relationStore.baseParams['sql'] = relationSql;
					relationStore.baseParams['ds'] = DW_DS;
					relationStore.load({
						params: {
							start: 0,
							limit: 999999
						}
					});
				}
			}
		}
	});
	
	//全省渠道树
	/*var channelTreePanel = new Ext.tree.TreePanel({
		id: "channelTreePanel",
		title: "全省基站树",
		region: 'east',
		width: 200,
		split: true,
		collapseMode: 'mini',
		collapsible: true,
		containerScroll: true,
		autoScroll: true,
		useArrows: true,
		animate: true,
		border: true,
		rootVisible: false,
		enableDD: true,
		root: new Ext.tree.AsyncTreeNode({
			text: '湖北 [双击查看明细]',
	        draggable: false,
	        iconCls: 'x-tree-node-icon3',
	        id: '-1'
		}),
		loader: new Ext.tree.TreeLoader({
			dataUrl: '/hbirs/action/areaSaleManage?method=nodesByRegionId'
		}),
		listeners: {
			click: function(node, e) {
				channelTemp = node.attributes.url;
				var channelId = node.attributes.id;
				if(!channelTemp){
					var channelSql = "";
					channelSql += "";
					channelStore.baseParams['sql'] = channelSql;
					channelStore.baseParams['ds'] = DW_DS;
					channelStore.load({
						params: {
							start: 0,
							limit: 999999
						}
					});
				}
			}
		}
	});*/
	
	var relationSm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
	var channelSm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
	
	var relationCm = new Ext.grid.ColumnModel([
			relationSm,
			{header: '地市名称',dataIndex: 'area_code',width: 150},
			{header: '区县名称',dataIndex: 'county_code',width: 100},
			{header: '高校代码',dataIndex: 'college_id',width: 100},
			{header: '高校名称',dataIndex: 'college_name',width: 150},
			{header: '渠道代码',dataIndex: 'channel_code',width: 150},
			{header: '渠道名称',dataIndex: 'channel_name',width: 150},
			{header: '渠道类型',dataIndex: 'channel_type',width: 100}
		]);
		
	var channelCm = new Ext.grid.ColumnModel([
			channelSm,
			{header: "渠道代码",dataIndex: "channel_code",width: 100},
			{header: "渠道名称",dataIndex: "channel_name",width: 120},
			{header: "地市",dataIndex: "city_id",width: 60},
			{header: "县市",dataIndex: "country_id",width: 60},
			{header: "营销中心",dataIndex: "market_org_id",width: 140},
			{header: "镇",dataIndex: "town",width: 60},
			{header: "村",dataIndex: "village",width: 70},
			{header: "基站类型",dataIndex: "bureau_type",width: 60},
			{header: "渠道类型",dataIndex: "channel_type",width: 80},
			{header: "地址",dataIndex: "address",width: 200},
			{header: "责任人",dataIndex: "reponse_name",width: 80},
			{header: "责任电话",dataIndex: "reponse_name",width: 80}]);
	
	//删除工具栏	
	var delToolBar = new Ext.Toolbar([{
		text: '删除关联关系',
		iconCls: 'remove',
		handler: function(){deleteRelations();}
	}]);
	
	//新增工具栏
	var addToolBar = new Ext.Toolbar([{
		text: '关联高校',
		iconCls: 'add',
		handler: function(){reflectToCollege(collegeLeafFlag,collegeNameTemp,collegeCodeTemp);}
	}]);
	
	//高校渠道信息表格		
	var relationGrid = new Ext.grid.GridPanel({
		id: 'relationGrid',
		store: relationStore,
		height: 315,
		border: true,
		cm: relationCm,
		sm: relationSm,
		loadMask: Ext.LoadMask(Ext.getBody(),{
			msg : '正在查询数据，请稍候...',
			removeMask : true
		}),
		tbar: delToolBar,
		bbar: new Ext.PagingToolbar({
			pageSize: itemsPerPage,
			store: relationStore,
			displayInfo: true,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg: '显示第{0}条到{1}条记录，一共{2}条记录',
			emptyMsg: '无数据'
		})
	});
	
	//渠道表格	
	var channelGrid = new Ext.grid.GridPanel({
		id: 'channelGrid',
		store: channelStore,
		cm: channelCm,
		sm: channelSm,
		border: true,
		height: 255,
		autoScroll: true,
		autoWidth : true,
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		loadMask: Ext.LoadMask(Ext.getBody(),{
			msg : '正在查询数据，请稍候...',
			removeMask : true
		}),
		tbar: addToolBar,
		bbar: new Ext.PagingToolbar({
			pageSize: itemsPerPage,
			store: channelStore,
			displayInfo: true,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg: '显示第{0}条到{1}条记录，一共{2}条记录',
			emptyMsg: '无数据'
		})
	 });
	
	
	//查询条件面板
	var formQuery = new Ext.form.FormPanel({
		id: 'qryCondition',
		labelAlign: 'right',
		labelWidth: 70,
		frame: true,
		border: false,
		items: [{
			layout: 'column',
			xtype: 'fieldset',
			title: '查询条件',
			//collapseMode: 'mini',
			//collapsible: true,
			items: [{
				layout: 'form',
				columnWidth: .30,
				items: [
					cityComBox,
					townComBox
				]},
				{
				layout: 'form',
				columnWidth: .30,
				items: [countyComBox,new Ext.form.TextField({fieldLabel:'渠道名称',id:'qryChannelName',width: 200})]
				},
				{
				layout: 'form',
				columnWidth: .30,
				items: [marketOrgComBox]
				},
				{
				layout: 'form',
				columnWidth: .10,
				items: [{},{},new Ext.Button({text: '查询',handler: function(){queryChannelInfo();}})]}
			]}
		]
	});
	//页面视图
	var viewport = new Ext.Viewport({
		layout: 'border',
		items: [
			collegeTreePanel,
			{
				region: 'center',
				layout: "accordion",
				layoutConfig: {animate: true},
				split: true,
				items: [{
						region: 'north',
						//iconCls: 'option',
						title: '<B style="color:#15428b">高校渠道关系信息</B>',
						id: 'relationShow',
						split: true,
						collapseMode: 'mini',
						collapsible: true,
						collapsed: true,
						items: [relationGrid]
					},
					{
						region: 'south',
						//iconCls: 'option',
						title: '<B style="color:#15428b">待关联渠道信息</B>',
						id: 'channelShow',
						split:  true,
						collapseMode: 'mini',
						collapsible: true,
						collapsed: false,
						items: [formQuery,channelGrid]
					}]
			}/*,
			channelTreePanel*/
		]
	});
});

//关联高校渠道信息
function reflectToCollege(collegeLeafFlag,collegeNameTemp,collegeCodeTemp){
	if(!collegeLeafFlag){
		Ext.MessageBox.show({
			title: '信息',
			msg: '请先选中全省高校树中的高校！',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	var selections = Ext.getCmp('channelGrid').getSelectionModel().getSelections();
	if(selections.length == 0){
		Ext.MessageBox.show({
			title: '信息',
			msg: '在为<b>'+collegeNameTemp+'</b>关联渠道之前，请先选中要关联的渠道记录！',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}else{
		Ext.Msg.confirm('信息','确定要为<b>'+collegeNameTemp+'</b>关联所选中的渠道吗？',function(btn){
			if(btn=='yes'){
				var sql = "";
				for(var i=0; i<selections.length;i++){
					var record = selections[i];
					sql += "insert into nwh.college_channel_rela_ng(area_code,county_code,college_id,channel_code,channel_type)";
					sql += " values("+"'"+record.get("city_id")+"',"+"'"+record.get("country_id")+"',"+"'"+collegeCodeTemp+"',";
					sql += "'"+record.get("channel_code")+"',"+"'"+record.get("channel_type")+"'"+")";
					if(i!=selections.length-1){
						sql += "~@~";
					}
				}
				var mask = new Ext.LoadMask(Ext.getBody(),{
					msg : '正在处理数据，请稍候...',
					removeMask : true
				});
				mask.show();
				Ext.Ajax.request({
					url : '/mvc/jsonData/query',
					success : function(obj){
						var result = obj.responseText;
						if(result=='-1'){
							mask.hide();
							Ext.MessageBox.show({
								title : '信息',
								msg : '关联高校渠道信息失败！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}else{
							mask.hide();
							Ext.MessageBox.show({
								title : '信息',
								msg : '关联高校渠道信息成功！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
							queryChannelInfo();
						}
					},
					failure : function(){
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '关联高校渠道信息失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						queryChannelInfo();
					},
					params : {
						'sql' : sql,
						'ds'  : DW_DS,
						'start' : 0,
						'limit' : itemsPerPage
					}
				});
			}
		});
	}
}

//查询渠道信息
function queryChannelInfo(){
	var qryCityId = Ext.getCmp("qryCityId").getValue();
	var qryCountyId = Ext.getCmp("qryCountyId").getValue();
	var qryMarketOrgId = Ext.getCmp("qryMarketOrgId").getValue();
	var qryTownId = Ext.getCmp("qryTownId").getValue();
	var qryChannelName = Ext.get("qryChannelName").getValue().trim();
	
	var sql = "select a.channel_code,a.channel_name,a.city_id,a.country_id,a.town,a.village,a.market_org_id,a.bureau_type,a.channel_type,a.reward_accountid,a.reward_accountname,a.address,a.response_name,a.response_phone from nmk.channel_info a where 1=1";
	
	if(qryCityId){
		sql += " and a.city_id='"+qryCityId+"'";
	}
	if(qryCountyId){
		sql += " and a.country_id='"+qryCountyId+"'";
	}
	if(qryMarketOrgId){
		sql += " and a.market_org_id='"+qryMarketOrgId+"'";
	}
	if(qryTownId){
		sql += " and a.town='"+qryTownId+"'";
	}
	if(qryChannelName){
		sql += " and a.channel_name like '%"+qryChannelName+"%'";
	}
	sql += " and not exists (select 1 from nwh.college_channel_rela_ng b where a.channel_code=b.channel_code)";
	sql += " order by a.city_id";
	var channelStore = Ext.getCmp("channelGrid").store;
	channelStore.baseParams['sql'] = sql;
	channelStore.baseParams['ds'] = DW_DS;
	channelStore.load({
		params: {
			start: 0,
			limit: itemsPerPage
		}
	});
}


//删除高校渠道信息关联关系
function deleteRelations(){
	var selections = Ext.getCmp('relationGrid').getSelectionModel().getSelections();
	if(selections.length == 0){
		Ext.MessageBox.show({
			title: '信息',
			msg: '请先选中要删除的记录！',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}else{
		Ext.Msg.confirm('信息','确定要删除所选择的记录吗？',function(btn){
			if(btn=='yes'){
				var sql = "";
				for(var i=0; i<selections.length;i++){
					var record = selections[i];
					sql += "delete from nwh.college_channel_rela_ng a";
					sql += " where a.area_code="+"'"+record.get("area_code")+"'";
					sql += " and a.county_code="+"'"+record.get("county_code")+"'";
					sql += " and a.college_id="+"'"+record.get("college_id")+"'";
					sql += " and a.channel_code="+"'"+record.get("channel_code")+"'";
					sql += " and a.channel_type="+"'"+record.get("channel_type")+"'";
					if(i!=selections.length-1){
						sql += "~@~";
					}
				}
				var mask = new Ext.LoadMask(Ext.getBody(),{
					msg : '正在处理数据，请稍候...',
					removeMask : true
				});
				mask.show();
				Ext.Ajax.request({
					url : '/mvc/jsonData/query',
					success : function(obj){
						var result = obj.responseText;
						if(result=='-1'){
							mask.hide();
							Ext.MessageBox.show({
								title : '信息',
								msg : '关联高校渠道信息失败！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}else{
							mask.hide();
							Ext.MessageBox.show({
								title : '信息',
								msg : '关联高校渠道信息成功！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
							var relationStore = Ext.getCmp("relationGrid").store;
							var relationSql = "select a.area_code,a.county_code,a.college_id,";
							relationSql += "(select d.college_name from college_info_pt d where d.college_id=a.college_id) college_name,a.channel_code,(select channel_name from nmk.channel_info c where c.channel_code=a.channel_code) channel_name,channel_type from nwh.college_channel_rela_NG a";
							relationSql += " where a.college_id='"+collegeCodeTemp+"' order by area_code,county_code,college_id,channel_code";
							relationStore.baseParams['sql'] = relationSql;
							relationStore.baseParams['ds'] = DW_DS;
							relationStore.load({
								params: {
									start: 0,
									limit: 999999
								}
							});
						}
					},
					failure : function(){
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '关联高校渠道信息失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						queryChannelInfo();
					},
					params : {
						'sql' : sql,
						'ds'  : DW_DS,
						'start' : 0,
						'limit' : itemsPerPage
					}
				});
			}
		});
	}
}

</script>