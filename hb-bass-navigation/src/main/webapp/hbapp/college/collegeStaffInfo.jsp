<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校教职工信息维护</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<style type="text/css">
.add {
	background-image: url(${mvcPath}/hbapp/resources/image/default/add.gif) !important
		;
}

.option {
	background-image: url(${mvcPath}/hbapp/resources/image/default/plugin.gif)
		!important;
}

.remove {
	background-image: url(${mvcPath}/resources/image/default/del.gif)
		!important;
}

</style>
		<%
			User user = (User) request.getSession().getAttribute("user");

			if (user == null) {
				user = new User();
			}

			Connection conn = null;

			try {
				//判断当前登陆人权限
				String auditSql = "SELECT VALUE(AREA_CODE,'') FROM mk.bt_area AREA WHERE TRIM(CHAR(AREA.AREA_ID)) = '"
						+ user.getCityId().trim() + "'";

				conn = ConnectionManage.getInstance().getDWConnection();
				PreparedStatement ps = conn.prepareStatement(auditSql);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					user.setRegionId(rs.getString(1));
				}

				rs.close();
				ps.close();

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (conn != null)
					ConnectionManage.getInstance().releaseConnection(conn);
			}
			String userCityId = user.getRegionId();
		%>
	</head>
	<body>
		<div id="addStaffFormDiv"></div>
		<div id="addStaffWinDiv"></div>
		<div id="updateStaffFormDiv"></div>
		<div id="updateStaffWinDiv"></div>
	</body>
</html>
<script type="text/javascript">
var itemsPerPage = 10;
var DW_DS = "jdbc/DWDB";
var WEB_DS = "jdbc/WEBDB";

var now = new Date();
var year = now.getYear();
var month = now.getMonth()+1;
if (month < 10) {
	month = "0" + month;
}
var currentYM = year.toString() + month.toString();// 当前年月字符串（YYYYMM）
var userCityId = '<%=userCityId%>';

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	//性别数据源
	var sexStore = new Ext.data.SimpleStore({
		fields:['code','name'],
		data:[['','请选择'],['1.','男'],['0.','女'],['Unknown','未知']]
	});
	
	//性别下拉列表
	var sexCombox = new Ext.form.ComboBox({
	 	id:'sex',
        fieldLabel: '性别',
        store: sexStore,
        valueField:'code',
        displayField:'name',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        selectOnFocus:true,
        emptyText:'请选择',
        width:200
    });
	
	//运营商归属及品牌数据源
	var brandStore = new Ext.data.SimpleStore({
		fields:['code','name'],
		data:[['','请选择'],['全球通','全球通'],['动感地带','动感地带']
				,['神州行','神州行'],['联通','联通'],['电信','电信']]
	});
	
	//运营商归属及品牌下拉列表
	var brandCombox = new Ext.form.ComboBox({
	 	id:'brand',
        fieldLabel: '运营商归属及品牌',
        store: brandStore,
        valueField:'code',
        displayField:'name',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        selectOnFocus:true,
        emptyText:'请选择',
        width:200
    });
    
	//操作类型数据源
	var operTypeStore = new Ext.data.SimpleStore({
		fields: ['code', 'name'],
        data : [['','请选择'],['INSERT','新增'],['UPDATE','修改'],['DELETE','删除']]
	});
	
	//操作类型下拉列表
    var operTypeCombox = new Ext.form.ComboBox({
	 	id:'operType',
        fieldLabel: '操作类型',
        store: operTypeStore,
        valueField:'code',
        displayField:'name',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        selectOnFocus:true,
        emptyText:'请选择',
        width:200
    });
    
	//状态数据源
	var statusStore = new Ext.data.SimpleStore({
	                            fields: ['code', 'name'],
	                            data : [['','请选择'],['SUC','已生效'],['IN_ADUIT_1','(新增)待一级审核'],
	                            		['IN_ADUIT_2','(新增)待二级审核'],['IN_ADUIT_3','(新增)待三级审核'],
	                            		['UPD_ADUIT_0','(修改)一级审批不通过'],['UPD_ADUIT_1','(修改)待一级审核'],
	                            		['UPD_ADUIT_2','(修改)待二级审核'],['UPD_ADUIT_3','(修改)待三级审核'],
	                            		['OUT_ADUIT_0','(删除)一级审批不通过'],['OUT_ADUIT_1','(删除)待一级审核'],
	                            		['OUT_ADUIT_2','(删除)待二级审核'],['OUT_ADUIT_3','(删除)待三级审核']]
	});
	
	//状态下拉列表
	var statusCombox = new Ext.form.ComboBox({
	   id:'status',
       fieldLabel: '审核状态',
       store: statusStore,
       valueField:'code',
       displayField:'name',
       typeAhead: true,
       mode: 'local',
       triggerAction: 'all',
       selectOnFocus:true,
       emptyText:'请选择',
       width:200
   });
   
	//地市数据源					
	var cityStore = new Ext.data.Store({
       	url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'area_code'
		}, {
			name : 'area_name'
		} ])
    });
    
    //地市下拉列表
	var cityComBox = new Ext.form.ComboBox({
		id:'cityId',
	    fieldLabel: '所属地市<A style=COLOR:red>*</A>',
	    store: cityStore,
	    valueField:'area_code',
	    displayField:'area_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText:'请选择',
	    width:200,
	    selectOnFocus:true,
	    listeners:{
	    	'select' : function(combo, record, index){
	    				var collegeSqlTemp = "select college_id,college_name from college_info_pt where state=1 and status <> 'FAL'";
	    				var cityValue = this.getValue();
	    				if(cityValue!="HB"){
	    					collegeSqlTemp += " and area_id = '"+cityValue+"'";
	    				}
	    				collegeSqlTemp = collegeSqlTemp + " order by college_id"
						collegeStore.baseParams['sql'] = collegeSqlTemp;
						collegeStore.baseParams['ds'] = DW_DS;
						collegeStore.baseParams['limit'] = 999999;
						collegeStore.baseParams['start'] = 0;
						collegeStore.reload();
	    	}
	    }
	});
	var citySql = "select area_code,area_name from mk.bt_area where 1=1 ";
	
	if(userCityId != 'HB' ){
		citySql += " and area_code = '"+userCityId+"'";
	}
	citySql += " order by area_id"
	cityStore.baseParams['sql'] = citySql;
	cityStore.baseParams['ds'] = WEB_DS;
	cityStore.baseParams['limit'] = 999999;
	cityStore.baseParams['start'] = 0;
	cityStore.reload();
	
	//高校数据源
	var collegeStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
       	reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'college_id'
		}, {
			name : 'college_name'
		} ])
	});
	
	//高校下拉列表
	var collegeCombox = new Ext.form.ComboBox({
		id:'college',
	    fieldLabel: '高校名称',
	    store: collegeStore,
	    valueField:'college_id',
	    displayField:'college_name',
	    typeAhead: true,
	    mode: 'remote',
	    triggerAction: 'all',
	    emptyText:'请选择',
	    width:200,
	    selectOnFocus:true
	});
	var collegeSql = "select college_id,college_name from college_info_pt where state=1 and status <> 'FAL'";
	
	if(userCityId != 'HB' ){
		collegeSql += " and area_id = '"+userCityId+"'";
	}
	collegeSql = collegeSql + " order by college_id"
	collegeStore.baseParams['sql'] = collegeSql;
	collegeStore.baseParams['ds'] = DW_DS;
	collegeStore.baseParams['limit'] = 999999;
	collegeStore.baseParams['start'] = 0;
	collegeStore.reload();
	
	//新增高校教职工表单
	var addStaffForm = new Ext.form.FormPanel({
		id : 'addStaffForm',
		width : 250,
		labelWidth:110,
		autoScroll:true,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "addStaffFormDiv",
		items : [{
			id : "addStaffName",
			xtype : "textfield",
			fieldLabel : "教职工姓名<A style=COLOR:red>*</A>",
			width : 200,
			allowBlank : false
		},{
			id : "addSex",
			xtype : "combo",
			fieldLabel : "性别<A style=COLOR:red>*</A>",
			store : sexStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			allowBlank : false
		},{
			id : "addAccNbr",
			xtype : "textfield",
			fieldLabel : "手机号码<A style=COLOR:red>*</A>",
			width : 200,
			allowBlank : false
		},{
			id : "addOperator",
			xtype : "combo",
			fieldLabel : "运营商归属及品牌<A style=COLOR:red>*</A>",
			store : brandStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			allowBlank : false
		},{
			id : "addCollegeId",
			xtype : "combo",
			fieldLabel : "学校名称<A style=COLOR:red>*</A>",
			store : collegeStore,
			valueField : 'college_id',
			displayField : 'college_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			allowBlank : false
		},{
			id : "addDepartment",
			xtype : "textfield",
			fieldLabel : "部门",
			width : 200,
			allowBlank : true
		},{
			id : "addPoss",
			xtype : "textfield",
			fieldLabel : "职位",
			width : 200,
			allowBlank : true
		},{
			id : "addOtherTelNum",
			xtype : "textfield",
			fieldLabel : "其它联系电话",
			width : 200,
			allowBlank : true
		},{
			id : "addEmilAddr",
			xtype : "textfield",
			fieldLabel : "邮箱地址",
			width : 200,
			allowBlank : true
		}]
	});
	
	//修改高校教职工表单
	var updateStaffForm = new Ext.form.FormPanel({
		id : 'updateStaffForm',
		width : 250,
		labelWidth:110,
		autoScroll:true,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "updateStaffFormDiv",
		items : [{
			id : "updateStaffName",
			xtype : "textfield",
			fieldLabel : "教职工姓名<A style=COLOR:red>*</A>",
			width : 200,
			readOnly : true,
			disabled :true,
			allowBlank : false
		},{
			id : "updateSex",
			xtype : "combo",
			fieldLabel : "性别<A style=COLOR:red>*</A>",
			store : sexStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			readOnly : true,
			disabled :true,
			allowBlank : false
		},{
			id : "updateAccNbr",
			xtype : "textfield",
			fieldLabel : "手机号码<A style=COLOR:red>*</A>",
			width : 200,
			readOnly : true,
			disabled :true,
			allowBlank : false
		},{
			id : "updateOperator",
			xtype : "combo",
			fieldLabel : "运营商归属及品牌<A style=COLOR:red>*</A>",
			store : brandStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			readOnly : true,
			disabled :true,
			allowBlank : false
		},{
			id : "updateCollegeId",
			xtype : "combo",
			fieldLabel : "学校名称<A style=COLOR:red>*</A>",
			store : collegeStore,
			valueField : 'college_id',
			displayField : 'college_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			readOnly : true,
			disabled :true,
			allowBlank : false
		},{
			id : "updateDepartment",
			xtype : "textfield",
			fieldLabel : "部门",
			width : 200,
			allowBlank : true
		},{
			id : "updatePoss",
			xtype : "textfield",
			fieldLabel : "职位",
			width : 200,
			allowBlank : true
		},{
			id : "updateOtherTelNum",
			xtype : "textfield",
			fieldLabel : "其他联系电话",
			width : 200,
			allowBlank : true
		},{
			id : "updateEmilAddr",
			xtype : "textfield",
			fieldLabel : "邮箱地址",
			width : 200,
			allowBlank : true
		}]
	});
	
	//高校教职工信息数据源
	var collegeStaffStore = new Ext.data.Store({ 
		url: "${mvcPath}/jsonData/query",
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [{
						name : 'college_id'
					},{
						name : 'college_name'
					},{
						name : 'name'
					},{
						name : 'sex_code'
					},{
						name : 'sex'
					},{
						name : 'department'
					},{
						name : 'poss'
					},{
						name : 'acc_nbr'
					},{
						name : 'operator'
					},{
						name : 'other_telnum'
					},{
						name : 'emil_addr'
					}
		])
	});
	
	var collegeStaffSm = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
		
	var collegeStaffCm = new Ext.grid.ColumnModel([collegeStaffSm
		,{header:"教职工姓名",dataIndex:"name",width:150}
		,{header:"学校名称",dataIndex:"college_name",width:300}
		,{header:"性别",dataIndex:"sex",width:100}
		,{header:"部门",dataIndex:"department",width:150}
		,{header:"职位",dataIndex:"poss",width:120}
		,{header:"手机号码",dataIndex:"acc_nbr",width:120}
		,{header:"运营商归属及品牌",dataIndex:"operator",width:150}
		,{header:"其他联系电话",dataIndex:"other_telnum",width:150}
		,{header:"电子邮件地址",dataIndex:"emil_addr",width:100}]);
		
	
	//操作工具栏
	var operToolBar = new Ext.Toolbar([
		{
			text:'新增',
			iconCls:'add',
			handler:function(){
				showAddStaffWin();
			}
		},
		'-',
		{
			text:'修改',
			iconCls:'option',
			handler:function(){
				showUpdateStaffWin();
			}
		},
		'-',
		{
			text:'删除',
			iconCls:'remove',
			handler:function(){
				deleteStaff();
			}
		}
	]);	
	
	var collegeStaffGrid = new Ext.grid.GridPanel({
		id:'collegeStaffGrid',
		store:collegeStaffStore,
		height:300,
		border:true,
		autoScroll: true,
		cm:collegeStaffCm,
		sm:collegeStaffSm,
		autoWidth : true,
		//autoExpandColumn:'col',
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		loadMask : new Ext.LoadMask(Ext.getBody(), {
			msg : '正在查询，请稍后...',
			removeMask : true
		}),
		tbar:operToolBar,
		bbar:new Ext.PagingToolbar({
			pageSize:itemsPerPage,
			store:collegeStaffStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayInfo : true,
			displayMsg : '显示第{0}条到{1}条记录，一共{2}条记录',
			emptyMsg : '无数据'
		})
	});
	//查询条件面板
	var qryConditionPanel = new Ext.form.FormPanel({
		id:'qryCondition',
		labelAlign:'right',
		labelWidth:110,
		frame:true,
		autoScroll:true,
		autoHeight:true,
		split:true,
		border:false,
		items:[{
			layout:'column',
			xtype:'fieldset',
			title:'查询条件',
			autoHeight:true,
			collapseMode: 'mini',
			collapsible: false,
			items:[
				{
					layout:'form',
					columnWidth:.30,
					items:[cityComBox,sexCombox]
				},
				{
					layout:'form',
					columnWidth:.30,
					items:[collegeCombox]
				},
				{
					layout:'form',
					columnWidth:.30,
					items:[brandCombox]
				},
				{
					layout:'form',
					columnWidth:.10,
					items:[{},{},new Ext.Button({text:'查询',handler:function(){queryStaffInfo()}})]
				}
			]}
		]
	});
	
	//页面视图
	var viewport = new Ext.Viewport({
		layout: 'border',
		items:[
			{
				region: 'center',
				//layout:"accordion",
				//layoutConfig: {animate: true},
				//split: true,
				items:[
					{
						//region: 'south',
						//title:'高校教职工信息维护',
						//split: true,
						//collapseMode: 'mini',
						//collapsible: true,
						//border:true,
						items:[qryConditionPanel,collegeStaffGrid]
					}
				]
			}
		]
	});
});

/**
 * 查询高校教职工信息
 */ 
function queryStaffInfo(){
	var collegeStaffStore = Ext.getCmp("collegeStaffGrid").store;
	var cityId = Ext.getCmp("cityId").getValue();
	var collegeId = Ext.getCmp("college").getValue();
	var brand = Ext.getCmp("brand").getValue();
	var sex = Ext.getCmp('sex').getValue();
	
	if(!cityId){
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择所属地市！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var sql = "select a.college_id,a.college_name,a.name,a.sex sex_code,(case a.sex when '1.' then '男' when '0.' then '女' else '未知' end) sex,a.department,a.poss,a.acc_nbr,a.operator,a.other_telnum,a.emil_addr";
	//sql += " from nwh.teacher_staff_info_"+currentYM+" a, college_info_pt b where 1=1";
	sql += " from nwh.teacher_staff_info_201301 a, college_info_pt b where 1=1";
	sql += " and a.college_id=b.college_id and b.state=1 and b.status <> 'FAL'";
	
	if(""!=collegeId){
		sql+=" and a.college_id = '"+collegeId+"'";
	}
	if(""!=brand){
		sql+=" and a.operator = '"+brand+"'";
	}
	if("HB"!=cityId){
		sql+=" and b.area_id = '"+cityId+"'";
	}
	if(""!=sex && "Unknown"!=sex){
		sql+=" and a.sex = '"+sex+"'";
	}else if(""!=sex && "Unknown"==sex){
		sql+=" and (a.sex is null or a.sex='9.')";
	}
	
	collegeStaffStore.baseParams['sql']=sql;
	collegeStaffStore.baseParams['ds']=DW_DS;
	collegeStaffStore.load({
	params : {
		start : 0,
		limit : itemsPerPage
		}
	});
}

/**
 * 显示新增高校教职工弹出框口
 */
function showAddStaffWin(){
	var addStaffForm = Ext.getCmp("addStaffForm");
	if(Ext.getCmp("addStaffWin")==null){
		var addStaffWin = new Ext.Window({
			id:'addStaffWin',
			el:'addStaffWinDiv',
	        title: '新增高校教职工信息',
	        closable:true,
	        width:500,
	        height:380,
	        autoScroll:true,
	        modal:true,
	        closeAction:'hide',
	        //border:false,
	        plain:true,
	        layout:'fit',
	        items: [addStaffForm.show()],
	        buttons : [ {
					text : '确定',
					handler : function() {
						saveStaffInfo();
					}
				},{
					text : '关闭',
					handler : function() {
						Ext.getCmp('addStaffWin').hide();
					}
				} ]
	    });
	    addStaffWin.show();
	}else{
		Ext.getCmp("addStaffWin").show();
	}
}

/**
 * 保存新增教职工信息
 */
function saveStaffInfo(){
	var addStaffName = Ext.getCmp("addStaffName").getValue().trim();
	var addSex = Ext.getCmp("addSex").getValue();
	var addAccNbr = Ext.getCmp("addAccNbr").getValue().trim();
	var addCollegeId = Ext.getCmp("addCollegeId").getValue();
	var addCollegeName = Ext.getCmp("addCollegeId").getRawValue();
	var addDepartment = Ext.getCmp("addDepartment").getValue();
	var addPoss = Ext.getCmp("addPoss").getValue().trim();
	var addOperator = Ext.getCmp("addOperator").getValue();
	var addOtherTelNum = Ext.getCmp("addOtherTelNum").getValue();
	var addEmilAddr = Ext.getCmp("addEmilAddr").getValue();

	//必填项校验
	if(!addStaffName){
		Ext.MessageBox.show({
			title:'信息',
			msg:'教职工名称为必填项，请输入！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
		});
		return;
	}
	if(!addSex){
		Ext.MessageBox.show({
			title:'信息',
			msg:'性别为必填项，请输入！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
		});
		return;
	}
	if(!addAccNbr){
		Ext.MessageBox.show({
			title:'信息',
			msg:'手机号码为必填项，请输入！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
		});
		return;
	}
	if(!addOperator){
		Ext.MessageBox.show({
			title:'信息',
			msg:'运营商归属及品牌为必填项，请输入！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
		});
		return;
	}
	if(!addCollegeName){
		Ext.MessageBox.show({
			title:'信息',
			msg:'高校名称为必填项，请输入！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
		});
		return;
	}
	//sql = "insert into nwh.teacher_staff_info_"+currentYM+" (COLLEGE_ID,COLLEGE_NAME,NAME,SEX,"
	sql = "insert into nwh.teacher_staff_info_201301 (COLLEGE_ID,COLLEGE_NAME,NAME,SEX,"
	sql += "DEPARTMENT,POSS,ACC_NBR,OPERATOR,OTHER_TELNUM,EMIL_ADDR)";
	sql += " values ("+"'"+addCollegeId+"',"+"'"+addCollegeName+"',"+"'"+addStaffName+"',";
	sql += "'"+addSex+"',"+"'"+addDepartment+"',"+"'"+addPoss+"',"+"'"+addAccNbr+"',"+"'"+addOperator+"',";
	sql += "'"+addOtherTelNum+"',"+"'"+addEmilAddr+"'";
	sql += ")";
	
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在处理数据，请稍候...',
		removeMask : true
	});
	mask.show();
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增高校教职工信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增高校教职工信息成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addStaffWin').hide();
				//queryStaffInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '新增高校教职工信息失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
		},
		params : {
			'sql' : sql,
			'ds'  : DW_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 修改高校教职工信息
 */
function showUpdateStaffWin(){
	var selections = Ext.getCmp('collegeStaffGrid').getSelectionModel().getSelections();
	if(selections.length!=1){
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择一条要修改数据！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var record = selections[0];
	Ext.getCmp("updateStaffName").setValue(record.get("name"));
	Ext.getCmp("updateSex").setValue(record.get("sex"));
	Ext.getCmp("updateAccNbr").setValue(record.get("acc_nbr"));
	Ext.getCmp("updateOperator").setValue(record.get("operator"));
	Ext.getCmp("updateCollegeId").setValue(record.get("college_id"));
	Ext.getCmp("updateDepartment").setValue(record.get("department"));
	Ext.getCmp("updatePoss").setValue(record.get("poss"));
	Ext.getCmp("updateOtherTelNum").setValue(record.get("other_telnum"));
	Ext.getCmp("updateEmilAddr").setValue(record.get("emil_addr"));
	
	//修改用户信息表单
	var updateStaffForm = Ext.getCmp('updateStaffForm');
	if (Ext.getCmp('updateStaffWin') == null) {
		var updateStaffWin = new Ext.Window({
			id : 'updateStaffWin',
			el : 'updateStaffWinDiv',
			title : '修改高校教职工信息',
			layout : 'fit',
			modal : true,
			width : 500,
			autoScroll : true,
			//autoHeight : true,
			height : 380,
			closeAction : 'hide',
			items : [ updateStaffForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					updateStaffInfo(record);
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('updateStaffWin').hide();
				}
			} ]
		});
		updateStaffWin.show();
	} else {
		Ext.getCmp('updateStaffWin').show();
	}
}

/**
 * 保存修改过后的高校教职工信息
 */
function updateStaffInfo(record){
	var updateStaffName = record.get("name");
	var updateSex = record.get("sex_code");
	var updateAccNbr = record.get("acc_nbr");
	var updateOperator = record.get("operator");
	var updateCollegeId = record.get("college_id");
	var updateCollegeName = record.get("college_name");
	var updateDepartment = Ext.getCmp("updateDepartment").getValue().trim();
	var updatePoss = Ext.getCmp("updatePoss").getValue().trim();
	var updateOtherTelNum = Ext.getCmp("updateOtherTelNum").getValue().trim();
	var updateEmilAddr = Ext.getCmp("updateEmilAddr").getValue().trim();
	
	//sql = "update nwh.teacher_staff_info_"+currentYM+" a set";
	sql = "update nwh.teacher_staff_info_201301 a set";
	sql += " a.department="+"'"+updateDepartment+"',"+" a.poss="+"'"+updatePoss+"',";
	sql += " a.other_telnum="+"'"+updateOtherTelNum+"',"+" a.emil_addr="+"'"+updateEmilAddr+"'";
	sql += " where a.name="+"'"+updateStaffName+"'";
	sql += " and a.sex="+"'"+updateSex+"'";
	sql += " and a.acc_nbr="+"'"+updateAccNbr+"'";
	sql += " and a.operator="+"'"+updateOperator+"'";
	sql += " and a.college_id="+"'"+updateCollegeId+"'";
	sql += " and a.college_name="+"'"+updateCollegeName+"'";
	
	var mask = new Ext.LoadMask(Ext.getBody(),{
		msg : '正在更新数据，请稍候...',
		removeMask : true
	});
	mask.show();
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj){
			result = obj.reponseText;
			if(result=="-1"){
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改高校教职工信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			}else{
				mask.hide();
				Ext.getCmp("cityId").setValue(userCityId);
				queryStaffInfo();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改高校教职工信息成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp("updateStaffWin").hide();
			}
		},
		failure : function(){
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改高校教职工信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
		},
		params : {
			'sql' : sql,
			'limit' : itemsPerPage,
			'ds'  : DW_DS,
			'start' : 0
		}
	});
}

/**
 * 删除高校教职工信息
 */
function deleteStaff(){
	var selections = Ext.getCmp('collegeStaffGrid').getSelectionModel().getSelections();
	if(selections.length==0){
		Ext.MessageBox.show({
			title : '信息',
			msg :  '请选择要删除的记录！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
	}else{
		var sql = "";
		for(var i=0; i<selections.length; i++){
				var record = selections[i];
				//sql += "delete from nwh.teacher_staff_info_"+currentYM;
				sql += "delete from nwh.teacher_staff_info_201301";
				sql += " where name="+"'"+record.get("name")+"'";
				sql += " and college_id="+"'"+record.get("college_id")+"'";
				sql += " and college_name="+"'"+record.get("college_name")+"'";
				sql += " and operator="+"'"+record.get("operator")+"'";
				sql += " and sex="+"'"+record.get("sex_code")+"'";
				if(i!=selections.length-1){
					sql += "~@~"	
				}
		}
		Ext.Msg.confirm('信息','确定要删除所选中的高校教职工信息吗？',function(btn){
			if(btn=='yes'){
				var mask = new Ext.LoadMask(Ext.getBody(),{
					msg : '正在删除数据，请稍候...',
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
								msg : '删除高校教职工信息失败！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}else{
							mask.hide();
							Ext.getCmp("cityId").setValue(userCityId);
							queryStaffInfo();
							Ext.MessageBox.show({
								title : '信息',
								msg : '删除高校教职工信息成功！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
						}
					},
					failure : function(){
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除高校教职工信息失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
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