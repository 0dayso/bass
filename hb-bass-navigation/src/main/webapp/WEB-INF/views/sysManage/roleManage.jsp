<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>湖北移动经营分析系统</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/des.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/tabext.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/grid.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/resources/css/default/default.css" />
		<%@include file="../include.jsp"%>
		<style type="text/css">
.form_button_long {
	BORDER-RIGHT: #7b9ebd 1px solid;
	BORDER-TOP: #7b9ebd 1px solid;
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px, 2px;
	FONT-SIZE: 12px;
	FILTER: progid :         DXImageTransform .         Microsoft .    
		  Gradient(GradientType =         0, StartColorStr =         #ffffff,
		EndColorStr =    
		    #EFF5FB);
	CURSOR: hand;
	COLOR: black;
	width: 80px;
	height: 20px;
}
</style>
	</head>
	<body style="margin: 0px;">
		<div style="margin-top: 20px; margin-left: 10px; margin-right: 10px;">
			<table align='center' width='95%' class='grid-tab-blue'
				cellspacing='1' cellpadding='0' border='0' style="display: ''">
				<tr class='dim_row'>
					<td class="dim_cell_title" align="right">
						&nbsp;角色ID：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="role_id" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;角色名称：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="role_name" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;地市：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="citySel" size="25"
							onClick="clearValue('citySel')">
					</td>
				<tr class='dim_row' style="display: none">
					<td class="dim_cell_content">
						<a id="downA" href='<%=request.getContextPath()%>/download/'>下载</a>
					</td>
				</tr>
				</tr>
			</table>
			<table align="center" width="95%"
				style="margin-top: 2px; margin-right: 0px; margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="查询"
							onClick="queryRoleInfo()">
						<input type="button" class="form_button" value="新增"
							onClick="showRolePanelForAdd()">
					</td>
				</tr>
			</table>
		</div>
		<div id="grid"
			style="margin-left: 35px; margin-right: 0px; width: 100%">
		</div>
		<div id="addRoleWinDiv"></div>
		<div id="addRoleDiv"></div>
		<div id="modifyRoleDiv"></div>
		<div id="modifyRoleWinDiv"></div>
		<div id="relateUserGourpWinDiv"></div>
		<div id="relateMenuWinDiv"></div>
		<div id="relateUserWinDiv"></div>
		<div id="userWinDiv"></div>
		<div id="userGroupWinDiv"></div>
	</body>
</html>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
Ext.onReady(function() {
	Ext.QuickTips.init();
	
	//地市数据源
	var cityStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'area_id'
		}, {
			name : 'area_name'
		} ])
	});
	
	//地市列表下拉框
	cityComBox = new Ext.form.ComboBox({
		id : 'citySel',
		store : cityStore,
		valueField : 'area_id',
		displayField : 'area_name',
		typeAhead : true,
		mode : 'remote',
		triggerAction : 'all',
		emptyText : '请选择',
		selectOnFocus : true,
		lazyInit : false,
		applyTo : 'citySel'
	});
	
	var sql = "select area_id,area_name from MK.BT_AREA where 1=1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1";
	if(cityId != 0 ){
		sql += " and area_id = "+cityId+"";
	}
	sql = sql + " order by area_id"
	cityStore.baseParams['sql'] = strEncode(sql);
	cityStore.baseParams['ds'] = WEB_DS;
	//cityStore.baseParams['simpleResult'] = "true";
	cityStore.baseParams['limit'] = 999999;
	cityStore.baseParams['start'] = 0;
	cityStore.reload();
	
	//角色数据源
	var roleStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'role_id'
		}, {
			name : 'role_name'
		},{
			name : 'create_time'
		},{
			name : 'city_name'
		} ])
	});
	
	//角色列模型
	var cm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "角色ID",
		width : 280,
		sortable : true,
		dataIndex : 'role_id'
	}, {
		header : "角色名称",
		width : 300,
		sortable : true,
		dataIndex : 'role_name'
	}, {
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'city_name'
	}, {
		header : "创建时间",
		width : 160,
		sortable : true,
		dataIndex : 'create_time'
	}, {
		header : "操作",
		width : 450,
		sortable : true,
		dataIndex : 'operate',
		align : 'center',
		renderer:renderBtn
	} ]);
	
	function renderBtn(value, cellmeta, record, rowIndex, columnIndex, store) {
		var str = "<input type='button' class='form_button_short' value='修改' onclick='showRolePanelForUpdate()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_short' value='删除' onclick='delRole()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_long' value='关联用户组' onclick='relateUserGroup(\""+record.get('role_id')+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_mid' value='关联用户' onclick='relateUser(\""+record.get('role_id')+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_short' value='权限' onclick='relateRight(\""+record.get('role_id')+"\")'>";
    	return str;
    }
    
    //角色表格
	var roleGrid = new Ext.grid.GridPanel({
		id : 'roleGrid',
		store : roleStore,
		// sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : cm,
		loadMask : new Ext.LoadMask(Ext.getBody(),{
			msg : "正在查询，请稍后...",
			removeMask : true
		}),
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
			store : roleStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			items : ['-',{
							type : 'button',
							text : '导出数据',
							cls : 'x-btn-text-icon',
							icon : '${mvcPath}/resources/image/default/expexcel.gif',
							handler : function exportUser(button,event){
								var totalCount = Ext.getCmp('roleGrid').getStore().getTotalCount();
								if(totalCount==0){
									Ext.MessageBox.show({
										title : "信息",
										msg : "请先查询出数据之后在下载查询的数据！",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
									return;
								}
								var sql = "select a.role_id, a.role_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) city_name,a.create_time from FPF_USER_ROLE a where 1=1 ";
								if(cityId != 0){
									sql += " and a.create_group = '"+cityId+"'";
								}
								if (cityComBox.getValue()||cityComBox.getValue()==0) {
									sql += " and a.create_group = '" + cityComBox.getValue() + "' ";
								}
								if($('#role_id').val()){
									sql += " and a.role_id like '%"+$('#role_id').val().trim()+"%'";
								}
								if($('#role_name').val()){
									sql += " and a.role_name like '%"+$('#role_name').val().trim()+"%'";
								}
								sql += "and a.create_group is not null order by a.create_group ";
								var time = getCurrentTimeStr();
								var spreadSheetHeader = "角色ID,角色名称,所属地市,创建时间";
								var fileName = "roleData_"+time;
								var fileType = "excel";
								var mask = new Ext.LoadMask(document.body, {
									msg : '正在下载，请稍候...',
									removeMask : true
								});
								mask.show();
								Ext.Ajax.request({
									url : '/mvc/fileMgr/downLoad',
									success : function(obj){
										document.getElementById("downA").href = "<%=request.getContextPath()%>"+"\\download\\"+"roleData_"+time+ ".xls";
										document.getElementById("downA").click();
										mask.hide();
									},
									failure : function(){
										mask.hide();
										Ext.MessageBox.show({
											title : '信息',
											msg : '下载用户汇总数据失败！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
									},
									params : {
										'sql' : strEncode(sql),
										'ds'  : WEB_DS,
										'fileName' : fileName,
										'fileType' : fileType,
										'spreadSheetHeader' : spreadSheetHeader
									}
								});
								
							}
						}
					],
			width : '97%'
		}),
		renderTo : 'grid'
	});
	
	//新增角色表单
	var addRoleForm = new Ext.form.FormPanel({
		id : 'addRoleForm',
		width : 250,
		frame : true,
		hidden : true,
		renderTo : "addRoleDiv",
		title : "",
		items : [{
			id : "addRoleName",
			xtype : "textfield",
			fieldLabel : "用户角色名称<A style=COLOR:red>*</A>",
			width : 200
		} ]
	});

	//修改角色表单
	var modifyRoleForm = new Ext.form.FormPanel({
		id : 'modifyRoleForm',
		width : 250,
		frame : true,
		hidden : true,
		renderTo : "modifyRoleDiv",
		title : "",
		items : [{
			id : "modifyRoleName",
			xtype : "textfield",
			fieldLabel : "用户角色名称<A style=COLOR:red>*</A>",
			width : 200
		} ]
	});
});// Ext.onReady结束

/**
 * 查询结果
 */
function queryRoleInfo() {
	var roleStore = Ext.getCmp('roleGrid').getStore();
	var sql = "select a.role_id, a.role_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) city_name,a.create_time from FPF_USER_ROLE a where 1=1 ";
	if(cityId != 0){
		sql += " and a.create_group = '"+cityId+"'";
	}
	if (cityComBox.getValue()||cityComBox.getValue()==0) {
		sql += " and a.create_group = '" + cityComBox.getValue() + "' ";
	}
	if($('#role_id').val()){
		sql += " and a.role_id like '%"+$('#role_id').val().trim()+"%'";
	}
	if($('#role_name').val()){
		sql += " and a.role_name like '%"+$('#role_name').val().trim()+"%'";
	}
	sql += "and a.create_group is not null order by a.create_group ";
	roleStore.baseParams['ds'] = WEB_DS;
	roleStore.baseParams['sql'] = strEncode(sql);
	roleStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
}

/**
 * 打开新增角色窗口
 */
function showRolePanelForAdd() {
	$("#addRoleName").val("");
	var addRoleForm = Ext.getCmp('addRoleForm');
	if (Ext.getCmp('addRoleWin') == null) {
		var addRoleWin = new Ext.Window({
			id : 'addRoleWin',
			el : 'addRoleWinDiv',
			title : '信息',
			layout : 'fit',
			modal : true,
			width : 400,
			autoHeight : true,
			closeAction : 'hide',
			items : [ addRoleForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					saveRole();
				}
			} ]
		});
		addRoleWin.show();
	} else {
		Ext.getCmp('addRoleWin').show();
	}
}

/**
 * 打开修改角色窗口
 */
function showRolePanelForUpdate() {
	var role_id = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	var role_name = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_name");
	//判断必填项
	if (!role_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择要修改的用户角色！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	$("#modifyRoleName").val(role_name);
	var modifyRoleForm = Ext.getCmp('modifyRoleForm');
	if (Ext.getCmp('modifyRoleWin') == null) {
		var modifyRoleWin = new Ext.Window({
			id : 'modifyRoleWin',
			el : 'modifyRoleWinDiv',
			title : '信息',
			layout : 'fit',
			modal : true,
			width : 400,
			autoHeight : true,
			closeAction : 'hide',
			items : [ modifyRoleForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					modifyRole();
				}
			} ]
		});
		modifyRoleWin.show();
	} else {
		Ext.getCmp('modifyRoleWin').show();
	}
}

/**
 * 保存新增用户角色
 */
function saveRole() {
	var roleName = $("#addRoleName").val().trim();
	//判断必填项
	if (!roleName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户角色名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候！',
		removeMask : true
	});
	mask.show();
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	var userId = $('#userId').val();
	var userCityId = $('#cityId').val();;
	var sql = "insert into FPF_USER_ROLE (role_id, role_name, resourcetype,status,create_time,create_group) values(";
	sql += "'"+currentTimeStr+"'";
	sql += ",'"+roleName+"'";
	sql += ","+50+"";
	sql += ","+0+"";
	sql += ",'"+currentTime+"'";
	sql += ",'"+cityId+"'";
	sql += ")";
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户角色创建失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户角色创建成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addRoleWin').hide();
				queryRoleInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '用户角色创建失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
		},
		params : {
			'sql' : strEncode(sql),
			'ds'  : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 修改用户角色信息
 */
function modifyRole() {
	var role_id = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	var roleName = $("#modifyRoleName").val().trim();
	//判断必填项
	if (!roleName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户角色名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在更新数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var sql = "update FPF_USER_ROLE ";
	sql += " set role_name='"+roleName+"'";
	sql += " where role_id='"+role_id+"'";
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改用户角色信息失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '修改用户角色信息成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('modifyRoleWin').hide();
				queryRoleInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '修改用户角色信息失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
		},
		params : {
			'sql' : strEncode(sql),
			'ds'  : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 删除用户角色
 */
function delRole() {
	var role_id = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	//判断必填项
	if (!role_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择要删除的用户角色！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	Ext.Msg.confirm('信息', '确定要删除此角色吗？', function(btn) {
		if (btn == 'yes') {
			var mask = new Ext.LoadMask(Ext.getBody(), {
				msg : '正在删除数据，请稍候！',
				removeMask : true
			});
			mask.show();
			var sql = "delete from FPF_USER_ROLE where role_id='"+role_id+"'";
			sql += SEPERATOR + "delete from FPF_USER_ROLE_MAP where role_id='"+role_id+"'";
			sql += SEPERATOR + "delete from fpf_group_role_map where role_id='"+role_id+"'";
			sql += SEPERATOR + "delete from FPF_SYS_MENUITEM_RIGHT where operatorid='"+role_id+"'";
			
			Ext.Ajax.request({
				url : '/mvc/jsonData/query',
				success : function(obj) {
					var result = obj.responseText;
					if (result == "-1") {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除用户角色失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					} else {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除用户角色成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						queryRoleInfo();
					}
				},
				failure : function() {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				},
				params : {
					'sql' : strEncode(sql),
					'ds'  : WEB_DS,
					'start' : 0,
					'limit' : itemsPerPage
				}
			});
		}else{
			return;
		}
	});
}

/**
 * 为角色关联用户组
 */
function relateUserGroup(roleId){
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var userGroupName = searchField.getValue().trim();
			var userGroupStore = Ext.getCmp('relateUserGroupGrid').getStore();
			var sql = "select g.group_id,g.group_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=g.parent_id) city_name,g.create_time from fpf_group_role_map m ,FPF_USER_GROUP g where m.role_id='"+roleId+"' and m.group_id=g.group_id";
			sql += " and (select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=g.parent_id) is not null";
			if(cityId != 0){
				sql += " and g.parent_id = '"+cityId+"'";
			}
			if(userGroupName){
				sql += " and g.group_name like '%"+userGroupName+"%'";
			}
			sql += " order by g.parent_id";
			userGroupStore.baseParams['ds'] = WEB_DS;
			userGroupStore.baseParams['sql'] = strEncode(sql);
			userGroupStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var relateUserGroupStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'group_id'
		}, {
			name : 'group_name'
		}, {
			name : 'city_name'
		},{
			name : 'create_time'
		} ])
	});
	var relateUserGroupCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户组ID",
		width : 200,
		sortable : true,
		dataIndex : 'group_id'
	}, {
		header : "用户组名称",
		width : 240,
		sortable : true,
		dataIndex : 'group_name'
	}, {
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'city_name'
	},{
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'create_time' 
	}]);
	var relateUserGroupGrid = new Ext.grid.GridPanel({
		id : 'relateUserGroupGrid',
		store : relateUserGroupStore,
		sm : new Ext.grid.CheckboxSelectionModel(),
		cm : relateUserGroupCm,
		loadMask : new Ext.LoadMask(Ext.getBody(),{
			msg : "正在查询，请稍后...",
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:99%',
		autoWidth : true,
		enableColumnResize : true,
		height : 265,
		tbar : ["用户组名称：", searchField],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : relateUserGroupStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select g.group_id,g.group_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=g.parent_id) city_name,g.create_time from fpf_group_role_map m ,FPF_USER_GROUP g where m.role_id='"+roleId+"' and m.group_id=g.group_id";
	sql += " and (select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=g.parent_id) is not null";
	if(cityId != 0){
		sql += " and g.parent_id = '"+cityId+"'";
	}
	sql +=" order by g.parent_id";
	relateUserGroupStore.baseParams['ds'] = WEB_DS;
	relateUserGroupStore.baseParams['sql'] = strEncode(sql);
	relateUserGroupStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	var relateUserGourpWin = Ext.getCmp("relateUserGourpWin");
	if (relateUserGourpWin == null) {
			relateUserGourpWin = new Ext.Window({
				id : 'relateUserGourpWin',
				el : 'relateUserGourpWinDiv',
				title : '角色关联的用户组',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ relateUserGroupGrid.show() ],
				buttons : [ {
					text : "添加用户组",
					handler : function(){
						showUserGroupWin(getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id"))
					}
				},
				{
					text : "删除用户组",
					handler : function(){
						var selections = Ext.getCmp('relateUserGroupGrid').getSelectionModel().getSelections();
						var relateUserGroups = "";
						for ( var i = 0; i < selections.length; i++) {
							var record = selections[i];
							if(relateUserGroups == ""){
								relateUserGroups = record.get('group_id');
							}else {
								relateUserGroups += ","+record.get('group_id');
							}
						}
						if(!relateUserGroups){
							Ext.MessageBox.show({
								title : "信息",
								msg : '请先选择要删除的用户组！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}
						Ext.Msg.confirm("信息","确定要删除所选择的用户组吗？",function(btn){
							if(btn=='yes'){
								delUserGroupFromRole(getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id"),relateUserGroups);
							}
						});
					}
				},
				{
					text : '关闭',
					handler : function() {
						relateUserGourpWin.hide();
					}
				} ]
			});
			relateUserGourpWin.show();
	}else{
		relateUserGourpWin.remove("relateUserGroupGrid");
		relateUserGourpWin.add(relateUserGroupGrid.show());
		relateUserGourpWin.doLayout();
		relateUserGourpWin.show();
	}
}

/**
 * 打开添加用户组窗口
 */
function showUserGroupWin(roleId){
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var userGroupName = searchField.getValue().trim();
			var userGroupGridStore = Ext.getCmp('userGroupGrid').getStore();
			var sql = "select a.group_id,a.group_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) city_name,a.create_time from FPF_USER_GROUP a where a.group_id not in (select b.group_id from fpf_group_role_map b where b.role_id='"+roleId+"')";
			sql += " and (select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) is not null";
			if(cityId != 0){
				sql += " and a.parent_id = '"+cityId+"'";
			}
			if(userGroupName){
				sql += " and a.group_name like '%"+userGroupName+"%'";
			}
			sql +=" order by a.parent_id";
			userGroupStore.baseParams['ds'] = WEB_DS;
			userGroupStore.baseParams['sql'] = strEncode(sql);
			userGroupStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	
	var userGroupStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'group_id'
		}, {
			name : 'group_name'
		}, {
			name : 'city_name'
		},{
			name : 'create_time'
		} ])
	});
	
	var userGroupCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户组ID",
		width : 200,
		sortable : true,
		dataIndex : 'group_id'
	}, {
		header : "用户组名称",
		width : 240,
		sortable : true,
		dataIndex : 'group_name'
	}, {
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'city_name'
	},{
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'create_time'
	}]);
	
	var userGroupGrid = new Ext.grid.GridPanel({
		id : 'userGroupGrid',
		store : userGroupStore,
		cm : userGroupCm,
		sm : new Ext.grid.CheckboxSelectionModel(),
		loadMask : new Ext.LoadMask(Ext.getBody(), {
			msg : '正在查询，请稍后...',
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:100%',
		autoWidth : true,
		enableColumnResize : true,
		height : 265,
		tbar : [ '用户组名称：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : userGroupStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select a.group_id,a.group_name,(select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) city_name,a.create_time from FPF_USER_GROUP a where a.group_id not in (select b.group_id from fpf_group_role_map b where b.role_id='"+roleId+"')";
	sql += " and (select t.area_name from (select t1.area_id,t1.area_name from MK.BT_AREA t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) is not null";
	if(cityId != 0){
		sql += " and a.parent_id = '"+cityId+"'";
	}
	sql +=" order by a.parent_id";
	userGroupStore.baseParams['ds'] = WEB_DS;
	userGroupStore.baseParams['sql'] = strEncode(sql);
	userGroupStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	
	if (Ext.getCmp('userGroupWin') == null) {
		var userGroupWin = new Ext.Window({
			id : 'userGroupWin',
			el : 'userGroupWinDiv',
			title : '选择用户组',
			layout : 'fit',
			width : 650,
			autoHeight : true,
			modal : true,
			closeAction : 'hide',
			items : [ userGroupGrid.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					var selections = Ext.getCmp('userGroupGrid').getSelectionModel().getSelections();
					var groupIds = "";
					for ( var i = 0; i < selections.length; i++) {
						var record = selections[i];
						if(groupIds == ""){
							groupIds = record.get('group_id');
						}else {
							groupIds += ","+record.get('group_id');
						}
					}
					if (!groupIds) {
						Ext.MessageBox.show({
							title : '信息',
							msg : '请先选择要添加的用户组！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
					}
					Ext.Msg.confirm('信息', '确定要为此角色关联所选的用户组吗？', function(btn) {
						if (btn == 'yes') {
							addUserGroupToRole(getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id"),groupIds);
						}
					});
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('userGroupWin').hide();
				}
			} ]
		});
		Ext.getCmp('userGroupWin').show();
	} else {
		Ext.getCmp('userGroupWin').remove("userGroupGrid");
		Ext.getCmp('userGroupWin').add(userGroupGrid.show());
		Ext.getCmp('userGroupWin').doLayout();
		Ext.getCmp('userGroupWin').show();
	}
}

/**
 *	给指定角色添加用户组
 */
function addUserGroupToRole(roleId,groupIds){
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候！',
		removeMask : true
	});
	mask.show();
	var groups = groupIds.split(",");
	for(var i=0;i<groups.length;i++){
		var sql = "insert into fpf_group_role_map (group_id, role_id) values(";
		sql += "'"+groups[i]+"'";
		sql += ",'"+roleId+"'";
		sql += ")";
		
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '给角色关联用户组失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					Ext.getCmp('userGroupWin').hide();
					//添加用户组成功之后添加用户组内的用户到该角色
					relateUserToRole(groups,roleId);
					//添加用户组成功以后刷新窗口
					relateUserGroup(roleId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '给角色关联用户组成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给角色关联用户组失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			params : {
				'sql' : strEncode(sql),
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}

/**
 * 添加用户组成功之后添加用户组内的用户到该角色
 */
function relateUserToRole(groups,roleId){
	for(var i=0;i<groups.length;i++){
		var sql = "select userid from FPF_USER_GROUP_MAP where group_id='"+groups[i]+"'";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(response) {
				var obj = Ext.util.JSON.decode(response.responseText);// 返回的JSON字符串
				var userIdArray = obj.root;
				for(var j=0; j<userIdArray.length; j++){
					var sql1 = "insert into FPF_USER_ROLE_MAP(role_id,userid) values(";
					sql1 += "'"+roleId+"'";
					sql1 += ",'"+(obj.root)[j]["userid"]+"'";
					sql1 += ")";	
					Ext.Ajax.request({
						url : '/mvc/jsonData/query',
						success : function(response) {
						},
						failure : function() {},
						params : {
							'sql' : strEncode(sql1),
							'ds'  : WEB_DS,
							'start' : 0,
							'limit' : itemsPerPage
						}
					});
				}
			},
			failure : function() {
				Ext.MessageBox.show({
					title : '信息',
					msg : '添加该用户组对应的用户失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			params : {
				'sql' : strEncode(sql),
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage,
				'isCutPage' : 'false'
			}
		});
	}
}

/**
 *	删除角色所关联的用户组的同时删除该用户组所对应的用户
 */
function delUserFromUserGroup(userGroups,roleId){
	var userGroupsTemp="(";
	for(var i=0; i<userGroups.length; i++){
		if(i==userGroups.length-1){
			userGroupsTemp +="'"+userGroups[i]+"')";
		}else{
			userGroupsTemp +="'"+userGroups[i]+"',"
		}
	}
	var sql = "delete from FPF_USER_ROLE_MAP a where a.userid in (select userid from FPF_USER_GROUP_MAP b where b.group_id in "+userGroupsTemp+" ) and a.role_id='"+roleId+"'";
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(response){},
		failure : function() {
			Ext.MessageBox.show({
				title : '信息',
				msg : '删除该用户组对应的用户失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
		},
		params : {
			'sql' : strEncode(sql),
			'ds'  : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 删除角色所关联的用户组
 */
function delUserGroupFromRole(roleId,relateUserGroups){
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍候！',
		removeMask : true
	});
	mask.show();
	var userGroups = relateUserGroups.split(",");
	for(var i=0;i<userGroups.length;i++){
		var sql = "delete from fpf_group_role_map where role_id='"+roleId+"' and group_id='"+userGroups[i]+"'";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除角色对应的用户组失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//删除角色对应的用户组中所对应的所有用户
					delUserFromUserGroup(userGroups,roleId);
					//删除角色对应的用户组成功以后刷新窗口
					relateUserGroup(roleId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除角色对应的用户组成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '删除角色对应的用户组失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			params : {
				'sql' : strEncode(sql),
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}

/**
 * 角色关联的权限
 */
function relateRight(roleId){
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var menuName = searchField.getValue().trim();
			var menuStore = Ext.getCmp('relateMenuGrid').getStore();
			var sql = "select m.menuitemid,m.menuitemtitle from FPF_USER_ROLE r,FPF_SYS_MENU_ITEM m,FPF_SYS_MENUITEM_RIGHT c where r.role_id=c.operatorid and char(m.menuitemid)=c.resourceid and r.role_id='"+roleId+"'";
			if(menuName){
				sql += " and m.menuitemtitle like '%"+menuName+"%'";
			}
			sql +=" order by r.create_time asc,r.role_id asc,m.menuitemid asc with ur";
			menuStore.baseParams['ds'] = WEB_DS;
			menuStore.baseParams['sql'] = strEncode(sql);
			menuStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var relateMenuStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'menuitemid'
		}, {
			name : 'menuitemtitle'
		}])
	});
	var relateMenuCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "菜单ID",
		width : 300,
		sortable : true,
		dataIndex : 'menuitemid'
	}, {
		header : "菜单名称",
		width : 350,
		sortable : true,
		dataIndex : 'menuitemtitle'
	}]);
	var relateMenuGrid = new Ext.grid.GridPanel({
		id : 'relateMenuGrid',
		store : relateMenuStore,
		cm : relateMenuCm,
		loadMask : new Ext.LoadMask(Ext.getBody(),{
			msg : "正在查询，请稍后...",
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:99%',
		autoWidth : true,
		enableColumnResize : true,
		height : 265,
		tbar : ["菜单名称：",searchField],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage * 10,
			displayInfo : true,
			store : relateMenuStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	
	var sql = "select m.menuitemid,m.menuitemtitle from FPF_USER_ROLE r,FPF_SYS_MENU_ITEM m,FPF_SYS_MENUITEM_RIGHT c where r.role_id=c.operatorid and char(m.menuitemid)=c.resourceid and r.role_id='"+roleId+"' order by r.create_time asc,r.role_id asc,m.menuitemid asc with ur";
	relateMenuStore.baseParams['ds'] = WEB_DS;
	relateMenuStore.baseParams['sql'] = strEncode(sql);
	relateMenuStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage * 10
		}
	});
	var relateMenuWin = Ext.getCmp("relateMenuWin");
	if (relateMenuWin == null) {
			relateMenuWin = new Ext.Window({
				id : 'relateMenuWin',
				el : 'relateMenuWinDiv',
				title : '角色关联的权限',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ relateMenuGrid.show() ],
				buttons : [ {
					text : '关闭',
					handler : function() {
						relateMenuWin.hide();
					}
				} ]
			});
			relateMenuWin.show();
	}else{
		relateMenuWin.remove("relateMenuGrid");
		relateMenuWin.add(relateMenuGrid.show());
		relateMenuWin.doLayout();
		relateMenuWin.show();
	}
}	

/**
 * 角色关联的用户
 */
function relateUser(roleId){
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var userName = searchField.getValue().trim();
			var userStore = Ext.getCmp('relateUserGrid').getStore();
			var sql = "select r.userid,r.username,(select t.area_name from (select area_id,area_name from MK.BT_AREA union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.cityid) cityname,r.createtime,(case value(a.group_id,'0') when '0' then '否' else '是' end) groupflag,(select p.group_name from FPF_USER_GROUP p where p.group_id=a.group_id) groupname";
			sql +=" from FPF_USER_USER r left join FPF_USER_ROLE_MAP m on m.userid=r.userid";
			sql +=" left join FPF_USER_GROUP_MAP a on r.userid=a.userid";
			sql +=" where m.role_id='"+roleId+"'";
			if(userName){
				sql += " and r.username like '%"+userName+"%'";
			}
			sql += " order by r.cityid";
			userStore.baseParams['ds'] = WEB_DS;
			userStore.baseParams['sql'] = strEncode(sql);
			userStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var relateUserStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'userid'
		}, {
			name : 'username'
		},{
			name : 'cityname'
		},{
			name : 'groupname'
		}, {
			name : 'groupflag'
		},{
			name : 'createtime'
		} ])
	});
	var relateUserCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户ID",
		width : 100,
		sortable : true,
		dataIndex : 'userid'
	}, {
		header : "用户名称",
		width : 100,
		sortable : true,
		dataIndex : 'username'
	}, {
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	},{
		header : "用户组",
		width : 240,
		sortable : true,
		dataIndex : 'groupname'
	},{
		header : "是否是组用户",
		width : 100,
		sortable : true,
		hidden : true,
		dataIndex : 'groupflag'
	},{
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'createtime'
	}]);
	var relateUserGrid = new Ext.grid.GridPanel({
		id : 'relateUserGrid',
		store : relateUserStore,
		cm : relateUserCm,
		sm : new Ext.grid.CheckboxSelectionModel(),
		loadMask : new Ext.LoadMask(Ext.getBody(),{
			msg : "正在查询，请稍后...",
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:100%',
		autoWidth : true,
		enableColumnResize : true,
		height : 265,
		tbar : ["用户名：",searchField],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : relateUserStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	
	//var sql = "select r.userid,r.username,r.createtime from FPF_USER_ROLE_MAP m ,FPF_USER_USER r where m.role_id='"+roleId+"' and m.userid=r.userid";
	var sql = "select r.userid,r.username,(select t.area_name from (select area_id,area_name from MK.BT_AREA union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.cityid) cityname,r.createtime,(case value(a.group_id,'0') when '0' then '否' else '是' end) groupflag,(select p.group_name from FPF_USER_GROUP p where p.group_id=a.group_id) groupname";
	sql +=" from FPF_USER_USER r left join FPF_USER_ROLE_MAP m on m.userid=r.userid";
	sql +=" left join FPF_USER_GROUP_MAP a on r.userid=a.userid";
	sql +=" where m.role_id='"+roleId+"'";
	sql +=" order by r.cityid";
	relateUserStore.baseParams['ds'] = WEB_DS;
	relateUserStore.baseParams['sql'] = strEncode(sql);
	relateUserStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	
	var relateUserWin = Ext.getCmp("relateUserWin");
	if (relateUserWin == null) {
			relateUserWin = new Ext.Window({
				id : 'relateUserWin',
				el : 'relateUserWinDiv',
				title : '角色关联的用户',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ relateUserGrid.show() ],
				buttons : [ /*{
					text : '添加用户',
					handler : function() {
						showUserWin(getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id"));
					}
				},{
					text : '删除用户',
					handler : function() {
						var selections = Ext.getCmp('relateUserGrid').getSelectionModel().getSelections();
						var userIds = "";
						var groupFlag = "0";
						for ( var i = 0; i < selections.length; i++) {
							var record = selections[i];
							if(userIds == ""){
								userIds = record.get('userid');
							}else {
								userIds += ","+record.get('userid');
							}
							if(record.get('groupflag')=="是"){
								groupFlag="1";
							}
						}
						
						if(groupFlag=="1"){
							Ext.MessageBox.show({
								title : "信息",
								msg : "选中要删除的用户中存在组用户，请选择非组用户删除！",
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}
						
						if(!userIds){
							Ext.MessageBox.show({
								title : "信息",
								msg : "请先选择要删除的用户！",
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}
						
						Ext.Msg.confirm("信息","确定要删除该角色对应的用户吗？",function(btn){
							if(btn=='yes'){
								delUserFromRole(getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id"),userIds);
							}
						});
					}
				},*/{
					text : '关闭',
					handler : function() {
						relateUserWin.hide();
					}
				} ]
			});
			relateUserWin.show();
	}else{
		relateUserWin.remove("relateUserGrid");
		relateUserWin.add(relateUserGrid.show());
		relateUserWin.doLayout();
		relateUserWin.show();
	}
}

/**
 * 打开选择用户窗口
 */
function showUserWin(roleId) {
	var roleId = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var userName = searchField.getValue().trim();
			var userStore = Ext.getCmp('userGridPanel').getStore();
			var sql = "select a.userid,a.username,a.createtime from FPF_USER_USER a where a.userid not in (select b.userid from FPF_USER_ROLE_MAP b where b.role_id='"+roleId+"')";
			sql += " and not exists (select 1 from FPF_USER_GROUP_MAP c where c.userid=a.userid)";
			if(cityId != 0){
				sql += " and a.cityid = '"+cityId+"'";
			}
			if(userName){
				sql += " and a.username like '%"+userName+"%'";
			}
			sql +=" order by a.cityid";
			userStore.baseParams['ds'] = WEB_DS;
			userStore.baseParams['sql'] = strEncode(sql);
			userStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var userStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'userid'
		}, {
			name : 'username'
		}, {
			name : 'createtime'
		} ])
	});
	var userCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户ID",
		width : 250,
		sortable : true,
		dataIndex : 'userid'
	}, {
		header : "用户名称",
		width : 240,
		sortable : true,
		dataIndex : 'username'
	}, {
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'createtime'
	}]);
	var userGridPanel = new Ext.grid.GridPanel({
		id : 'userGridPanel',
		store : userStore,
		cm : userCm,
		sm : new Ext.grid.CheckboxSelectionModel(),
		loadMask : new Ext.LoadMask(Ext.getBody(),{
			msg : "正在查询，请稍后...",
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:100%',
		autoWidth : true,
		enableColumnResize : true,
		height : 265,
		tbar : [ '用户名称：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : userStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select a.userid,a.username,a.createtime from FPF_USER_USER a where a.userid not in (select b.userid from FPF_USER_ROLE_MAP b where b.role_id='"+roleId+"')";
	sql += "and not exists (select 1 from FPF_USER_GROUP_MAP c where c.userid=a.userid)";
	if(cityId != 0){
		sql += " and a.cityid = '"+cityId+"'";
	}
	sql +=" order by a.cityid";
	userStore.baseParams['ds'] = WEB_DS;
	userStore.baseParams['sql'] = strEncode(sql);
	userStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	if (Ext.getCmp('userWin') == null) {
		var userWin = new Ext.Window({
			id : 'userWin',
			el : 'userWinDiv',
			title : '选择用户',
			layout : 'fit',
			id : 'userWin',
			width : 500,
			autoHeight : true,
			modal : true,
			closeAction : 'hide',
			items : [ userGridPanel.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					var selections = Ext.getCmp('userGridPanel').getSelectionModel().getSelections();
					var userIds = "";
					for ( var i = 0; i < selections.length; i++) {
						var record = selections[i];
						if(userIds == ""){
							userIds = record.get('userid');
						}else {
							userIds += ","+record.get('userid');
						}
					}
					if(!userIds){
						Ext.MessageBox.show({
							title : "信息",
							msg : "请先选择要为此角色关联的用户！",
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING						
						});
						return;
					}
					Ext.Msg.confirm("信息","确定要为此用户关联所选的用户吗？",function(btn){
						if(btn=='yes'){
							roleId = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
							addUserToRole(roleId,userIds);
						}
					});
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('userWin').hide();
				}
			} ]
		});
		Ext.getCmp('userWin').show();
	} else {
		Ext.getCmp('userWin').remove("userGridPanel");
		Ext.getCmp('userWin').add(userGridPanel.show());
		Ext.getCmp('userWin').doLayout();
		Ext.getCmp('userWin').show();
	}
}

/**
 * 给角色添加用户 
 */
function addUserToRole(roleId,userIds) {
	var roleId = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var users = userIds.split(",");
	for(var i=0;i<users.length;i++){
		var sql = "insert into FPF_USER_ROLE_MAP (role_id, userid) values(";
		sql += "'"+roleId+"'";
		sql += ",'"+users[i]+"'";
		sql += ")";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '给角色添加用户失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					Ext.getCmp('userWin').hide();
					//添加用户成功以后刷新窗口
					relateUser(roleId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '给角色添加用户成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给角色添加用户失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'sql' : strEncode(sql),
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}

/**
 * 删除角色对应的用户 
 */
function delUserFromRole(roleId,userIds) {
	var roleId = getSelectedColumnValue(Ext.getCmp('roleGrid'),"role_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍候！',
		removeMask : true
	});
	mask.show();
	var users = userIds.split(",");
	for(var i=0;i<users.length;i++){
		var sql = "delete from FPF_USER_ROLE_MAP where role_id='"+roleId+"' and userid='"+users[i]+"'";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除角色关联的用户失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//删除角色对应的用户成功以后刷新窗口
					relateUser(roleId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除角色关联的用户成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '删除角色关联的用户失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			params : {
				'sql' : strEncode(sql),
				'ds'  : WEB_DS,
				'start' : 0,
				'limit' : itemsPerPage
			}
		});
	}
}
</script>