<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校学生信息维护</title>
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
		<div id="addStudentFormDiv"></div>
		<div id="addStudentWinDiv"></div>
		<div id="updateStudentFormDiv"></div>
		<div id="updateStudentWinDiv"></div>
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
		id : 'sex',
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
    
    //学历数据源
	var degreeStore = new Ext.data.SimpleStore({
		fields:['code','name'],
		data:[['','请选择'],['Senior','高中'],['0','大专'],['Univercity','本科']
				,['4','硕士'],['5','博士'],['Unknown','未知']]
	});
	
	//学历下拉列表
	var degreeCombox = new Ext.form.ComboBox({
	 	id:'degree',
        fieldLabel: '学历',
        store: degreeStore,
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
	
	//新增高校学生表单
	var addStudentForm = new Ext.form.FormPanel({
		id : 'addStudentForm',
		width : 250,
		labelWidth:110,
		autoScroll:true,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "addStudentFormDiv",
		items : [{
			id : "addStudentName",
			xtype : "textfield",
			fieldLabel : "学生姓名<A style=COLOR:red>*</A>",
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
			id : "addBrandId",
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
			id : "addInstitute",
			xtype : "textfield",
			fieldLabel : "院系",
			width : 200,
			allowBlank : true
		},{
			id : "addClass",
			xtype : "textfield",
			fieldLabel : "班级",
			width : 200,
			allowBlank : true
		},{
			id : "addAdderss",
			xtype : "textfield",
			fieldLabel : "住址",
			width : 200,
			allowBlank : true
		},{
			id : "addCareCode",
			xtype : "textfield",
			fieldLabel : "身份证号",
			width : 200,
			allowBlank : true
		},{
			id : "addEdu",
			xtype : "combo",
			fieldLabel : "学历",
			store : degreeStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			allowBlank : true
		},{
			id : "addStartSchoolTime",
			xtype : "datefield",
			fieldLabel : "入学年份",
			format : 'Y',
			width : 200,
			allowBlank : true
		},{
			id : "addPoss",
			xtype : "textfield",
			fieldLabel : "职务",
			width : 200,
			allowBlank : true
		},{
			id : "addOperator",
			xtype : "textfield",
			fieldLabel : "办理产品",
			width : 200,
			allowBlank : true
		},{
			id : "addSway",
			xtype : "textfield",
			fieldLabel : "影响力",
			width : 200,
			allowBlank : true
		},{
			id : "addEmilAddr",
			xtype : "textfield",
			fieldLabel : "电子邮件地址",
			width : 200,
			allowBlank : true
		},{
			id : "addCollegeFlag",
			xtype : "checkbox",
			fieldLabel : "是否校园集团",
			width : 200,
			allowBlank : true
		},{
			id : "addFeixinFlag",
			xtype : "checkbox",
			fieldLabel : "是否开通飞信",
			width : 200,
			allowBlank : true
		}]
	});
	
	//修改高校学生表单
	var updateStudentForm = new Ext.form.FormPanel({
		id : 'updateStudentForm',
		width : 250,
		labelWidth:110,
		autoScroll:true,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "updateStudentFormDiv",
		items : [{
			id : "updateStudentName",
			xtype : "textfield",
			fieldLabel : "学生姓名<A style=COLOR:red>*</A>",
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
			id : "updateBrandId",
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
			id : "updateInstitute",
			xtype : "textfield",
			fieldLabel : "院系",
			width : 200,
			allowBlank : true
		},{
			id : "updateClass",
			xtype : "textfield",
			fieldLabel : "班级",
			width : 200,
			allowBlank : true
		},{
			id : "updateAdderss",
			xtype : "textfield",
			fieldLabel : "住址",
			width : 200,
			allowBlank : true
		},{
			id : "updateCareCode",
			xtype : "textfield",
			fieldLabel : "身份证号",
			width : 200,
			allowBlank : true
		},{
			id : "updateEdu",
			xtype : "combo",
			fieldLabel : "学历",
			store : degreeStore,
			valueField : 'code',
			displayField : 'name',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 200,
			allowBlank : true
		},{
			id : "updateStartSchoolTime",
			xtype : "datefield",
			fieldLabel : "入学年份",
			format : 'Y',
			width : 200,
			allowBlank : true
		},{
			id : "updatePoss",
			xtype : "textfield",
			fieldLabel : "职务",
			width : 200,
			allowBlank : true
		},{
			id : "updateOperator",
			xtype : "textfield",
			fieldLabel : "办理产品",
			width : 200,
			allowBlank : true
		},{
			id : "updateSway",
			xtype : "textfield",
			fieldLabel : "影响力",
			width : 200,
			allowBlank : true
		},{
			id : "updateEmilAddr",
			xtype : "textfield",
			fieldLabel : "电子邮件地址",
			width : 200,
			allowBlank : true
		},{
			id : "updateCollegeFlag",
			xtype : "checkbox",
			fieldLabel : "是否校园集团",
			width : 200,
			allowBlank : true
		},{
			id : "updateFeixinFlag",
			xtype : "checkbox",
			fieldLabel : "是否开通飞信",
			width : 200,
			allowBlank : true
		}]
	});
	
	//高校学生信息数据源
	var collegeStudentStore = new Ext.data.Store({ 
		url: "${mvcPath}/jsonData/query",
		reader: new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [{
						name : 'student_name'
					},{
						name : 'college_id'
					},{
						name : 'college_name'
					},{
						name : 'institute'
					},{
						name : 'class'
					},{
						name : 'adderss'
					},{
						name : 'care_code'
					},{
						name : 'edu_code'
					},{
						name : 'edu'
					},{
						name : 'start_school_time'
					},{
						name : 'sex_code'
					},{
						name : 'sex'
					},{
						name : 'poss'
					},{
						name : 'acc_nbr'
					},{
						name : 'brand_id'
					},{
						name : 'operator'
					},{
						name : 'sway'
					},{
						name : 'college_flag'
					},{
						name : 'feixin_flag'
					},{
						name : 'emil_addr'
					}
		])
	});
	
	var collegeStudentSm = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
		
	var collegeStudentCm = new Ext.grid.ColumnModel([collegeStudentSm
		,{header:"学生姓名",dataIndex:"student_name",width:70}
		,{header:"学校名称",dataIndex:"college_name",width:100}
		,{header:"院系",dataIndex:"institute",width:80}
		,{header:"班级",dataIndex:"class",width:80}
		,{header:"住址",dataIndex:"adderss",width:150}
		,{header:"身份证号",dataIndex:"care_code",width:110}
		,{header:"学历",dataIndex:"edu",width:40}
		,{header:"入学年份",dataIndex:"start_school_time",width:60}
		,{header:"性别",dataIndex:"sex",width:40}
		,{header:"职务",dataIndex:"poss",width:60}
		,{header:"手机号码",dataIndex:"acc_nbr",width:80}
		,{header:"运营商归属及品牌",dataIndex:"brand_id",width:120}
		,{header:"办理产品",dataIndex:"operator",width:60}
		,{header:"影响力",dataIndex:"sway",width:50}
		,{header:"是否校园集团",dataIndex:"college_flag",width:80}
		,{header:"是否开通飞信",dataIndex:"feixin_flag",width:80}
		,{header:"电子邮件地址",dataIndex:"emil_addr",width:80}]);
		
	
	//操作工具栏
	var operToolBar = new Ext.Toolbar([
		{
			text:'新增',
			iconCls:'add',
			handler:function(){
				showAddStudentWin();
			}
		},
		'-',
		{
			text:'修改',
			iconCls:'option',
			handler:function(){
				showUpdateStudentWin();
			}
		},
		'-',
		{
			text:'删除',
			iconCls:'remove',
			handler:function(){
				deleteStudent();
			}
		}
	]);	
	
	var collegeStudentGrid = new Ext.grid.GridPanel({
		id:'collegeStudentGrid',
		store:collegeStudentStore,
		height:300,
		border:true,
		autoScroll: true,
		cm:collegeStudentCm,
		sm:collegeStudentSm,
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
			store:collegeStudentStore,
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
					items:[cityComBox,degreeCombox]
				},
				{
					layout:'form',
					columnWidth:.30,
					items:[collegeCombox,sexCombox]
				},
				{
					layout:'form',
					columnWidth:.30,
					items:[brandCombox]
				},
				{
					layout:'form',
					columnWidth:.10,
					items:[{},{},new Ext.Button({text:'查询',handler:function(){queryStudentInfo()}})]
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
						//title:'高校学生信息维护',
						//split: true,
						//collapseMode: 'mini',
						//collapsible: true,
						//border:true,
						items:[qryConditionPanel,collegeStudentGrid]
					}
				]
			}
		]
	});
});

/**
 * 查询高校学生信息
 */ 
function queryStudentInfo(){
	var collegeStudentStore = Ext.getCmp("collegeStudentGrid").store;
	var cityId = Ext.getCmp("cityId").getValue();
	var collegeId = Ext.getCmp("college").getValue();
	var brand = Ext.getCmp("brand").getValue();
	var degree = Ext.getCmp('degree').getValue();
	var sex = Ext.getCmp("sex").getValue();
	
	if(!cityId){
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择所属地市！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var sql = "select a.student_name,a.college_id,a.college_name,a.institute,a.class,a.adderss,a.care_code,a.edu edu_code,(case a.edu when '0' then '大专' when '4' then '硕士' when '5' then '博士' when 'Senior' then '高中' when 'Univercity' then '本科' else '未知' end) edu,a.start_school_time,a.sex sex_code,(case a.sex when '1.' then '男' when '0.' then '女' else '未知' end) sex,a.poss,a.acc_nbr,a.brand_id,a.operator,a.sway,(case a.college_flag when '1' then '是' when '0' then '否' end) college_flag,(case a.feixin_flag when '1' then '是' when '0' then '否' end) feixin_flag,a.emil_addr";
	//sql += " from nwh.student_info_desc_"+currentYM+" a, college_info_pt b where 1=1";
	sql += " from nwh.student_info_desc_201301 a, college_info_pt b where 1=1";
	sql += " and a.college_id=b.college_id and b.state=1 and b.status <> 'FAL'";
	
	if(""!=collegeId){
		sql+=" and a.college_id = '"+collegeId+"'";
	}
	if(""!=brand){
		sql+=" and a.brand_id = '"+brand+"'";
	}
	if(""!=degree && "Unknown"!=degree){
		sql+=" and a.edu = '"+degree+"'";
	}else if(""!=degree && "Unknown"==degree){
		sql+=" and (a.edu is null or a.edu='Unknown')"
	}
	if("HB"!=cityId){
		sql+=" and b.area_id = '"+cityId+"'";
	}
	if(""!=sex && sex!='Unknown'){
		sql+=" and a.sex = '"+sex+"'";
	}else if(""!=sex && sex=='Unknown'){
		sql+=" and (a.sex is null or a.sex='9.')";
	}
	
	collegeStudentStore.baseParams['sql']=sql;
	collegeStudentStore.baseParams['ds']=DW_DS;
	collegeStudentStore.load({
	params : {
		start : 0,
		limit : itemsPerPage
		}
	});
}

/**
 * 显示新增高校学生弹出框口
 */
function showAddStudentWin(){
	var addStudentForm = Ext.getCmp("addStudentForm");
	if(Ext.getCmp("addStudentWin")==null){
		var addStudentWin = new Ext.Window({
			id:'addStudentWin',
			el:'addStudentWinDiv',
	        title: '新增高校学生信息',
	        closable:true,
	        width:500,
	        height:380,
	        autoScroll:true,
	        modal:true,
	        closeAction:'hide',
	        //border:false,
	        plain:true,
	        layout:'fit',
	        items: [addStudentForm.show()],
	        buttons : [ {
					text : '确定',
					handler : function() {
						saveStudentInfo();
					}
				},{
					text : '关闭',
					handler : function() {
						Ext.getCmp('addStudentWin').hide();
					}
				} ]
	    });
	    addStudentWin.show();
	}else{
		Ext.getCmp("addStudentWin").show();
	}
}

/**
 * 保存新增学生信息
 */
function saveStudentInfo(){
	var addStudentName = Ext.getCmp("addStudentName").getValue().trim();
	var addSex = Ext.getCmp("addSex").getValue();
	var addAccNbr = Ext.getCmp("addAccNbr").getValue().trim();
	var addBrandId = Ext.getCmp("addBrandId").getValue();
	var addCollegeId = Ext.getCmp("addCollegeId").getValue();
	var addCollegeName = Ext.getCmp("addCollegeId").getRawValue();
	var addInstitute = Ext.getCmp("addInstitute").getValue().trim();
	var addClass = Ext.getCmp("addClass").getValue().trim();
	var addAdderss = Ext.getCmp("addAdderss").getValue().trim();
	var addCareCode = Ext.getCmp("addCareCode").getValue().trim();
	var addEdu = Ext.getCmp("addEdu").getValue();
	var addStartSchoolTime = Ext.getCmp("addStartSchoolTime").getRawValue();
	var addPoss = Ext.getCmp("addPoss").getValue().trim();
	var addOperator = Ext.getCmp("addOperator").getValue().trim();
	var addSway = Ext.getCmp("addSway").getValue().trim();
	var addCollegeFlag = Ext.getCmp("addCollegeFlag").getValue();
	if(addCollegeFlag==true){
		addCollegeFlag='1';
	}else{
		addCollegeFlag='0';
	}
	var addFeixinFlag = Ext.getCmp("addFeixinFlag").getValue();
	if(addFeixinFlag==true){
		addFeixinFlag='1';
	}else{
		addFeixinFlag='0';
	}
	var addEmilAddr = Ext.getCmp("addEmilAddr").getValue();

	//必填项校验
	if(!addStudentName){
		Ext.MessageBox.show({
			title:'信息',
			msg:'学生名称为必填项，请输入！',
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
	if(!addBrandId){
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
	//sql = "insert into nwh.student_info_desc_"+currentYM+" (STUDENT_NAME,COLLEGE_ID,COLLEGE_NAME,INSTITUTE,"
	sql = "insert into nwh.student_info_desc_201301 (STUDENT_NAME,COLLEGE_ID,COLLEGE_NAME,INSTITUTE,"
	sql += "CLASS,ADDERSS,CARE_CODE,EDU,START_SCHOOL_TIME,SEX,POSS,ACC_NBR,BRAND_ID,OPERATOR,SWAY,COLLEGE_FLAG,FEIXIN_FLAG,EMIL_ADDR)";
	sql += " values ("+"'"+addStudentName+"',"+"'"+addCollegeId+"',"+"'"+addCollegeName+"',"+"'"+addInstitute+"',";
	sql += "'"+addClass+"',"+"'"+addAdderss+"',"+"'"+addCareCode+"',"+"'"+addEdu+"',"+"'"+addStartSchoolTime+"',";
	sql += "'"+addSex+"',"+"'"+addPoss+"',"+"'"+addAccNbr+"',"+"'"+addBrandId+"',"+"'"+addOperator+"',";
	sql += "'"+addSway+"',"+"'"+addCollegeFlag+"',"+"'"+addFeixinFlag+"',"+"'"+addEmilAddr+"'";
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
					msg : '新增高校学生信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增高校学生信息成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addStudentWin').hide();
				//queryStudentInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '新增高校学生信息失败！',
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
 * 修改高校学生信息
 */
function showUpdateStudentWin(){
	var selections = Ext.getCmp('collegeStudentGrid').getSelectionModel().getSelections();
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
	Ext.getCmp("updateStudentName").setValue(record.get("student_name"));
	Ext.getCmp("updateSex").setValue(record.get("sex"));
	Ext.getCmp("updateAccNbr").setValue(record.get("acc_nbr"));
	Ext.getCmp("updateBrandId").setValue(record.get("brand_id"));
	Ext.getCmp("updateCollegeId").setValue(record.get("college_id"));
	Ext.getCmp("updateInstitute").setValue(record.get("institute"));
	Ext.getCmp("updateClass").setValue(record.get("class"));
	Ext.getCmp("updateAdderss").setValue(record.get("adderss"));
	Ext.getCmp("updateCareCode").setValue(record.get("care_code"));
	Ext.getCmp("updateEdu").setValue(record.get("edu_code"));
	Ext.getCmp("updateStartSchoolTime").setValue(record.get("start_school_time"));
	Ext.getCmp("updatePoss").setValue(record.get("poss"));
	Ext.getCmp("updateOperator").setValue(record.get("operator"));
	Ext.getCmp("updateSway").setValue(record.get("sway"));
	Ext.getCmp("updateEmilAddr").setValue(record.get("emil_addr"));
	
	if(record.get("college_flag")=='是'){
		Ext.getCmp("updateCollegeFlag").setValue(true);
	}else{
		Ext.getCmp("updateCollegeFlag").setValue(false);
	}
	if(record.get("feixin_flag")=='是'){
		Ext.getCmp("updateFeixinFlag").setValue(true);
	}else{
		Ext.getCmp("updateFeixinFlag").setValue(false);
	}
	
	//修改用户信息表单
	var updateStudentForm = Ext.getCmp('updateStudentForm');
	if (Ext.getCmp('updateStudentWin') == null) {
		var updateStudentWin = new Ext.Window({
			id : 'updateStudentWin',
			el : 'updateStudentWinDiv',
			title : '修改高校学生信息',
			layout : 'fit',
			modal : true,
			width : 500,
			autoScroll : true,
			//autoHeight : true,
			height : 380,
			closeAction : 'hide',
			items : [ updateStudentForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					updateStudentInfo(record);
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('updateStudentWin').hide();
				}
			} ]
		});
		updateStudentWin.show();
	} else {
		Ext.getCmp('updateStudentWin').show();
	}
}

/**
 * 保存修改过后的高校学生信息
 */
function updateStudentInfo(record){
	var updateStudentName = record.get("student_name");
	var updateSex = record.get("sex_code");
	var updateAccNbr = record.get("acc_nbr");
	var updateBrandId = record.get("brand_id");
	var updateCollegeId = record.get("college_id");
	var updateCollegeName = record.get("college_name");
	var updateInstitute = Ext.getCmp("updateInstitute").getValue().trim();
	var updateClass = Ext.getCmp("updateClass").getValue().trim();
	var updateAdderss = Ext.getCmp("updateAdderss").getValue().trim();
	var updateCareCode = Ext.getCmp("updateCareCode").getValue().trim();
	var updateEdu = Ext.getCmp("updateEdu").getValue();
	var updateStartSchoolTime = Ext.getCmp("updateStartSchoolTime").getRawValue();
	var updatePoss = Ext.getCmp("updatePoss").getValue().trim();
	var updateOperator = Ext.getCmp("updateOperator").getValue().trim();
	var updateSway = Ext.getCmp("updateSway").getValue().trim();
	var updateEmilAddr = Ext.getCmp("updateEmilAddr").getValue().trim();
	var updateCollegeFlag = Ext.getCmp("updateCollegeFlag").getValue();
	var updateFeixinFlag = Ext.getCmp("updateFeixinFlag").getValue();
	
	if(updateCollegeFlag==true){
		updateCollegeFlag="1";
	}else{
		updateCollegeFlag="0";
	}
	if(updateFeixinFlag==true){
		updateFeixinFlag="1";
	}else{
		updateFeixinFlag="0";
	}
	
	//sql = "update nwh.student_info_desc_"+currentYM+" a set";
	sql = "update nwh.student_info_desc_201301 a set";
	sql += " a.institute="+"'"+updateInstitute+"',";
	sql += " a.class="+"'"+updateClass+"',"+" a.adderss="+"'"+updateAdderss+"',"+" a.care_code="+"'"+updateCareCode+"',";
	sql += " a.edu="+"'"+updateEdu+"',"+" a.start_school_time="+"'"+updateStartSchoolTime+"',"+" a.poss="+"'"+updatePoss+"',";
	sql += " a.operator="+"'"+updateOperator+"',"+" a.sway="+"'"+updateSway+"',"+" a.emil_addr="+"'"+updateEmilAddr+"',";
	sql += " a.college_flag="+"'"+updateCollegeFlag+"',"+" a.feixin_flag="+"'"+updateFeixinFlag+"'";
	if(updateStudentName==null||updateStudentName==""){
		sql += " where a.student_name is null";
	}else{
		sql += " where a.student_name="+"'"+updateStudentName+"'";
	}
	if(updateSex==null||updateSex==""){
		sql += " and a.sex is null";
	}else{
		sql += " and a.sex="+"'"+updateSex+"'";
	}
	if(updateAccNbr==null||updateAccNbr==""){
		sql += " and a.acc_nbr is null";
	}else{
		sql += " and a.acc_nbr="+"'"+updateAccNbr+"'";
	}
	if(updateBrandId==null||updateBrandId==""){
		sql += " and a.brand_id is null";
	}else{
		sql += " and a.brand_id="+"'"+updateBrandId+"'";
	}
	if(updateCollegeId==null||updateCollegeId==""){
		sql += " and a.college_id is null";
	}else{
		sql += " and a.college_id="+"'"+updateCollegeId+"'";
	}
	if(updateCollegeName==null||updateCollegeName==""){
		sql += " and a.college_name is null";
	}else{
		sql += " and a.college_name="+"'"+updateCollegeName+"'";
	}
	
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
					msg : '修改高校学生信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			}else{
				mask.hide();
				Ext.getCmp("cityId").setValue(userCityId);
				queryStudentInfo();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改高校学生信息成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp("updateStudentWin").hide();
			}
		},
		failure : function(){
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改高校学生信息失败！',
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
 * 删除高校学生信息
 */
function deleteStudent(){
	var selections = Ext.getCmp('collegeStudentGrid').getSelectionModel().getSelections();
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
				//sql += "delete from nwh.student_info_desc_"+currentYM;
				sql += "delete from nwh.student_info_desc_201301";
				if(record.get("student_name")==null||record.get("student_name")==""){
					sql += " where student_name is null";
				}else{
					sql += " where student_name="+"'"+record.get("student_name")+"'";
				}
				if(record.get("college_id")==null||record.get("college_id")==""){
					sql += " and college_id is null";
				}else{
					sql += " and college_id="+"'"+record.get("college_id")+"'";
				}
				if(record.get("brand_id")==null||record.get("brand_id")==""){
					sql += " and brand_id is null";
				}else{
					sql += " and brand_id="+"'"+record.get("brand_id")+"'";
				}
				if(record.get("sex_code")==null||record.get("sex_code")==""){
					sql += " and sex is null";
				}else{
					sql += " and sex="+"'"+record.get("sex_code")+"'";
				}
				
				if(i!=selections.length-1){
					sql += "~@~"	
				}
		}
		Ext.Msg.confirm('信息','确定要删除所选中的高校学生信息吗？',function(btn){
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
								msg : '删除高校学生信息失败！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}else{
							mask.hide();
							Ext.getCmp("cityId").setValue(userCityId);
							queryStudentInfo();
							Ext.MessageBox.show({
								title : '信息',
								msg : '删除高校学生信息成功！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
						}
					},
					failure : function(){
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除高校学生信息失败！',
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