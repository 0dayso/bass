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
	</head>
	<body style="margin: 0px;">
		<div style="margin-top: 20px; margin-left: 10px; margin-right: 10px;">
			<table align='center' width='95%' class='grid-tab-blue'
				cellspacing='1' cellpadding='0' border='0' style="display: ''">
				<tr class='dim_row'>
					<td class="dim_cell_title" align="right">
						&nbsp;用户组ID：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="group_id" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;用户组名称：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="group_name" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;用户组创建人：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="citySel" size="25"
							onClick="clearValue('citySel')">
					</td>
				</tr>
				<tr class='dim_row' style="display: none">
					<td class="dim_cell_content"><a id="downA" href='<%=request.getContextPath()%>/download/'>下载</a> 
					</td>
				</tr>
			</table>
			<table align="center" width="95%"
				style="margin-top: 2px; margin-right: 0px; margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="查询"
							onClick="queryUserGroupInfo()">
						<input type="button" class="form_button" value="新增"
							onClick="showGroupPanelForAdd()">
					</td>
				</tr>
			</table>
		</div>
		<div id="grid"
			style="margin-left: 35px; margin-right: 0px; width: 100%">
		</div>
		<div id="addUserGroupDiv"></div>
		<div id="updateUserGroupDiv"></div>
		<div id="relateRoleWinDiv"></div>
		<div id="roleWinDiv"></div>
		<div id="relateUserWinDiv"></div>
		<div id="userWinDiv"></div>
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
	
	//地市下拉框列表
	cityComBox = new Ext.form.ComboBox({
		id : 'citySel',
		store : cityStore,
		valueField : 'area_id',
		displayField : 'area_name',
		typeAhead : true,
		mode : 'remote',
		triggerAction : 'all',
		emptyText : '用户组创建人',
		selectOnFocus : true,
		lazyInit : false,
		applyTo : 'citySel'
	});
	var sql = "select a.parent_id area_id,b.group_name area_name from FPF_USER_GROUP a inner join FPF_USER_GROUP b on a.parent_id=b.group_id ";
	if(cityId != 0 ){
		sql += " and parent_id = "+cityId+"";
	}
	sql = sql + " group by  a.parent_id,b.group_name order by area_id"
	cityStore.baseParams['sql'] = strEncode(sql);
	cityStore.baseParams['ds'] = WEB_DS;
	cityStore.baseParams['simpleResult'] = "true";
	cityStore.baseParams['limit'] = 999999;
	cityStore.baseParams['start'] = 0;
	cityStore.reload();
	
	//用户组数据源
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
	
	//用户组列模型
	var userGroupCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户组ID",
		width : 300,
		sortable : true,
		dataIndex : 'group_id'
	}, {
		header : "用户组名称",
		width : 350,
		sortable : true,
		dataIndex : 'group_name'
	}, {
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'city_name'
	},{
		header : "创建时间",
		width : 190,
		sortable : true,
		dataIndex : 'create_time' 
	}, {
		header : "操作 ",
		width : 350,
		sortable : true,
		dataIndex : 'operate',
		align : 'center',
		renderer:renderBtn
	} ]);
	
	function renderBtn(value, cellmeta, record, rowIndex, columnIndex, store) {
        var str = "<input type='button' class='form_button_short' value='修改' onclick='showGroupPanelForUpdate()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_short' value='删除' onclick='delGroup()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_mid' value='关联用户' onclick='relateUser(\""+record.get('group_id')+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_mid' value='关联角色' onclick='relateRole(\""+record.get('group_id')+"\")'>";
        return str;
    }
    
    //用户组表格
	var userGroupGrid = new Ext.grid.GridPanel({
		id : 'userGroupGrid',
		store : userGroupStore,
		// sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : userGroupCm,
		loadMask : new Ext.LoadMask(Ext.getBody(), {
			msg : '正在查询，请稍后...',
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
			store : userGroupStore,
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
								var totalCount = Ext.getCmp('userGroupGrid').getStore().getTotalCount();
								if(totalCount==0){
									Ext.MessageBox.show({
										title : "信息",
										msg : "请先查询出数据之后在下载查询的数据！",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
									return;
								}
								var sql = "select a.group_id, a.group_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) city_name, a.create_time from FPF_USER_GROUP a where 1=1 ";
								sql += " and (select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) is not null";
								if(cityId != 0){
									sql += " and a.parent_id = '"+cityId+"'";
								}
								if (cityComBox.getValue()) {
									sql += " and a.parent_id = '" + cityComBox.getValue() + "' ";
								}
								if($('#group_id').val()){
									sql += " and a.group_id like '%"+$('#group_id').val().trim()+"%'";
								}
								if($('#group_name').val()){
									sql += " and a.group_name like '%"+$('#group_name').val().trim()+"%'";
								}
								sql += " order by a.parent_id ";
								var time = getCurrentTimeStr();
								var spreadSheetHeader = "用户组ID,用户组名称,所属地市,创建时间";
								var fileName = "userGroupData_"+time;
								var fileType = "excel";
								var mask = new Ext.LoadMask(document.body, {
									msg : '正在下载，请稍候...',
									removeMask : true
								});
								mask.show();
								Ext.Ajax.request({
									url : '/mvc/fileMgr/downLoad',
									success : function(obj){
										document.getElementById("downA").href = "<%=request.getContextPath()%>"+"\\download\\"+"userGroupData_"+time+ ".xls";
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
	
	//新增用户组表单
	var addUserGroupForm = new Ext.form.FormPanel({
		id : 'addUserGroupForm',
		width : 250,
		frame : true,
		hidden : true,
		renderTo : "addUserGroupDiv",
		//title : "",
		items : [{
			id : "addUserGroup",
			xtype : "textfield",
			fieldLabel : "用户组名称<A style=COLOR:red>*</A>",
			width : 200
		} ]
	});
	
	//修改用户组表单
	var updateUserGroupForm = new Ext.form.FormPanel({
		id : 'updateUserGroupForm',
		width : 250,
		frame : true,
		hidden : true,
		renderTo : "updateUserGroupDiv",
		title : "",
		items : [{
			id : "updateUserGroup",
			xtype : "textfield",
			fieldLabel : "用户组名称<A style=COLOR:red>*</A>",
			width : 200
		} ]
	});
});// Ext.onReady结束

/**
 * 查询用户组信息
 */
function queryUserGroupInfo() {
	var userGroupStore = Ext.getCmp('userGroupGrid').getStore();
	var sql = "select a.group_id, a.group_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) city_name, a.create_time from FPF_USER_GROUP a where 1=1 ";
	sql += " and (select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.parent_id) is not null";
	if(cityId != 0){
		sql += " and a.parent_id = '"+cityId+"'";
	}
	if (cityComBox.getValue()) {
		sql += " and a.parent_id = '" + cityComBox.getValue() + "' ";
	}
	if($('#group_id').val()){
		sql += " and a.group_id like '%"+$('#group_id').val().trim()+"%'";
	}
	if($('#group_name').val()){
		sql += " and a.group_name like '%"+$('#group_name').val().trim()+"%'";
	}
	sql += " order by a.parent_id ";
	userGroupStore.baseParams['ds'] = WEB_DS;
	userGroupStore.baseParams['sql'] = strEncode(sql);
	userGroupStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
}

/**
 * 打开新增用户组的窗口
 */
function showGroupPanelForAdd() {
	$("#addUserGroup").val("");
	var addUserGroupForm = Ext.getCmp('addUserGroupForm');
	if (Ext.getCmp('addUserGroupWin') == null) {
		var addUserGroupWin = new Ext.Window({
			id : 'addUserGroupWin',
			el : 'addUserGroupDiv',
			title : '信息',
			layout : 'fit',
			modal : true,
			width : 400,
			autoHeight : true,
			closeAction : 'hide',
			items : [ addUserGroupForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					saveUserGroup();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('addUserGroupWin').hide();
				}
			} ]
		});
		addUserGroupWin.show();
	} else {
		Ext.getCmp('addUserGroupWin').show();
	}
}

/**
 * 打开修改用户组的窗口
 */
function showGroupPanelForUpdate() {
	//var group_id = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var group_name = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_name");
	$("#updateUserGroup").val(group_name);
	var updateUserGroupForm = Ext.getCmp('updateUserGroupForm');
	if (Ext.getCmp('updateUserGroupWin') == null) {
		var updateUserGroupWin = new Ext.Window({
			id : 'updateUserGroupWin',
			el : 'updateUserGroupDiv',
			title : '信息',
			layout : 'fit',
			modal : true,
			width : 400,
			autoHeight : true,
			closeAction : 'hide',
			items : [ updateUserGroupForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					updateUserGroup();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('updateUserGroupWin').hide();
				}
			} ]
		});
		updateUserGroupWin.show();
	} else {
		Ext.getCmp('updateUserGroupWin').show();
	}
}

/**
 * 保存新增用户组信息
 */
function saveUserGroup() {
	var groupName = $("#addUserGroup").val().trim();
	
	//判断必填项
	if (!groupName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户组名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	var userId = $('#userId').val();
	var userCityId = $('#cityId').val();;
	var sql = "insert into FPF_USER_GROUP (group_id, group_name, parent_id, status, create_time, user_limit, sortnum) values(";
	sql += "'"+currentTimeStr+"'";
	sql += ",'"+groupName+"'";
	if(cityId==0){
		sql += ",'"+1+"'";
	}else{
		sql += ",'"+cityId+"'";
	}
	sql += ","+0+"";
	sql += ",'"+currentTime+"'";
	sql += ","+0+"";
	sql += ","+999+"";
	sql += ")";
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '创建用户组失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '创建用户组成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addUserGroupWin').hide();
				queryUserGroupInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '用户组创建失败！',
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
 * 保存用户组修改信息
 */
function updateUserGroup() {
	var group_id = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var groupName = $("#updateUserGroup").val().trim();
	//判断必填项
	if (!groupName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户组名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在更新数据，请稍候！',
		removeMask : true
	});
	mask.show();
	var sql = "update FPF_USER_GROUP ";
	sql += " set group_name='"+groupName+"'";
	sql += " where group_id='"+group_id+"'";
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户组修改失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户组修改成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('updateUserGroupWin').hide();
				queryUserGroupInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '用户组修改失败！',
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
 * 删除用户组
 */
function delGroup() {
	var group_id = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	//判断必填项
	if (!group_id) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择用户组！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	Ext.Msg.confirm('信息', '确定要删除此用户组吗？', function(btn) {
		if (btn == 'yes') {
			var mask = new Ext.LoadMask(Ext.getBody(), {
				msg : '正在删除数据，请稍候...',
				removeMask : true
			});
			mask.show();
			var sql = "delete from FPF_USER_GROUP where group_id='"+group_id+"'";
			sql += SEPERATOR + "delete from FPF_USER_GROUP_MAP where group_id='"+group_id+"'";
			sql += SEPERATOR + "delete from FPF_GROUP_ROLE_MAP where group_id='"+group_id+"'";
			
			Ext.Ajax.request({
				url : '/mvc/jsonData/query',
				success : function(obj) {
					var result = obj.responseText;
					if (result == "-1") {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '用户组删除失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					} else {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '用户组删除成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						queryUserGroupInfo();
					}
				},
				failure : function() {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '用户组删除失败！',
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
 * 为用户组关联角色
 */
function relateRole(groupId){
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var roleName = searchField.getValue().trim();
			var roleStore = Ext.getCmp('roleGrid').getStore();
			var sql = "select r.role_id,r.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.create_group) city_name,r.create_time from FPF_GROUP_ROLE_MAP m ,FPF_USER_ROLE r where m.group_id='"+groupId+"' and m.role_id=r.role_id and r.create_group is not null";
			if(cityId != 0){
				sql += " and r.create_group = '"+cityId+"'";
			}
			if(userName){
				sql += " and r.role_name like '%"+roleName+"%'";
			}
			sql +=" order by r.create_group";
			roleStore.baseParams['ds'] = WEB_DS;
			roleStore.baseParams['sql'] = strEncode(sql);
			roleStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var roleStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'role_id'
		}, {
			name : 'role_name'
		}, {
			name : 'city_name'
		},{
			name : 'create_time'
		} ])
	});
	var roleCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "角色ID",
		width : 250,
		sortable : true,
		dataIndex : 'role_id'
	}, {
		header : "角色名称",
		width : 240,
		sortable : true,
		dataIndex : 'role_name'
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
	var roleGrid = new Ext.grid.GridPanel({
		id : 'roleGrid',
		store : roleStore,
		cm : roleCm,
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
		tbar : [ '角色名称：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : roleStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select r.role_id,r.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.create_group) city_name,r.create_time from FPF_GROUP_ROLE_MAP m ,FPF_USER_ROLE r where m.group_id='"+groupId+"' and m.role_id=r.role_id and r.create_group is not null";
	if(cityId != 0){
		sql += " and r.create_group = '"+cityId+"'";
	}
	roleStore.baseParams['ds'] = WEB_DS;
	roleStore.baseParams['sql'] = strEncode(sql);
	roleStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	
	var relateRoleWin = Ext.getCmp("relateRoleWin");
	if (relateRoleWin == null) {
			relateRoleWin = new Ext.Window({
				id : 'relateRoleWin',
				el : 'relateRoleWinDiv',
				title : '用户组关联的角色',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ roleGrid.show() ],
				buttons : [ /*{
					text : '添加角色',
					handler : function() {
						showRoleWin(getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id"));
					}
				},{
					text : '删除角色',
					handler : function() {
						var selections = Ext.getCmp('roleGrid').getSelectionModel().getSelections();
						var roleIds = "";
						for ( var i = 0; i < selections.length; i++) {
							var record = selections[i];
							if(roleIds == ""){
								roleIds = record.get('role_id');
							}else {
								roleIds += ","+record.get('role_id');
							}
						}
						if(!roleIds){
							Ext.MessageBox.show({
								title : "信息",
								msg : "请先选择要删除的角色！",
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}
						Ext.Msg.confirm("信息","确定要删除所选的角色吗？",function(btn){
							if(btn=='yes'){
								delRoleFromGroup(getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id"),roleIds);
							}
						});
					}
				},*/{
					text : '关闭',
					handler : function() {
						relateRoleWin.hide();
					}
				} ]
			});
			relateRoleWin.show();
	}else{
		relateRoleWin.remove("roleGrid");
		relateRoleWin.add(roleGrid.show());
		relateRoleWin.doLayout();
		relateRoleWin.show();
	}
}

/**
 * 打开选择角色的窗口
 */
function showRoleWin(groupId) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var searchField = new Ext.form.TwinTriggerField({
		width : 250,
		selectOnFocus : true,
		trigger1Class : 'x-form-clear-trigger',
		trigger2Class : 'x-form-search-trigger',
		onTrigger1Click : function() {
			searchField.setValue('');
		},
		onTrigger2Click : function() {
			var roleName = searchField.getValue().trim();
			var roleStore = Ext.getCmp('roleGridPanel').getStore();
			var sql = "select role_id,role_name,create_time from FPF_USER_ROLE where role_id not in (select role_id from FPF_GROUP_ROLE_MAP where group_id='"+groupId+"')";
			if(cityId != 0){
				sql += " and create_group = '"+cityId+"'";
			}
			if(roleName){
				sql += " and role_name like '%"+roleName+"%'";
			}
			roleStore.baseParams['ds'] = WEB_DS;
			roleStore.baseParams['sql'] = strEncode(sql);
			roleStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	var roleStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'role_id'
		}, {
			name : 'role_name'
		}, {
			name : 'create_time'
		} ])
	});
	var roleCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "角色ID",
		width : 250,
		sortable : true,
		dataIndex : 'role_id'
	}, {
		header : "角色名称",
		width : 240,
		sortable : true,
		dataIndex : 'role_name'
	}, {
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'create_time'
	}]);
	var roleGridPanel = new Ext.grid.GridPanel({
		id : 'roleGridPanel',
		store : roleStore,
		cm : roleCm,
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
		tbar : [ '角色名称：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : roleStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select role_id,role_name,create_time from FPF_USER_ROLE where role_id not in (select role_id from FPF_GROUP_ROLE_MAP where group_id='"+groupId+"')";
	if(cityId != 0){
		sql += " and create_group = '"+cityId+"'";
	}
	roleStore.baseParams['ds'] = WEB_DS;
	roleStore.baseParams['sql'] = strEncode(sql);
	roleStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	if (Ext.getCmp('roleWin') == null) {
		var roleWin = new Ext.Window({
			id : 'roleWin',
			el : 'roleWinDiv',
			title : '选择角色',
			layout : 'fit',
			width : 500,
			autoHeight : true,
			modal : true,
			closeAction : 'hide',
			items : [ roleGridPanel.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					var selections = Ext.getCmp('roleGridPanel').getSelectionModel().getSelections();
					var roleIds = "";
					for ( var i = 0; i < selections.length; i++) {
						var record = selections[i];
						if(roleIds == ""){
							roleIds = record.get('role_id');
						}else {
							roleIds += ","+record.get('role_id');
						}
					}
					if(!roleIds){
						Ext.MessageBox.show({
							title : "信息",
							msg : "请先选择要添加的角色！",
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
					}
					Ext.Msg.confirm("信息","确定要为此用户组关联所选的角色吗？",function(btn){
						if(btn=='yes'){
							groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
							addRoleToUserGroup(groupId,roleIds);
						}
					});
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('roleWin').hide();
				}
			} ]
		});
		Ext.getCmp('roleWin').show();
	} else {
		Ext.getCmp('roleWin').remove("roleGridPanel");
		Ext.getCmp('roleWin').add(roleGridPanel.show());
		Ext.getCmp('roleWin').doLayout();
		Ext.getCmp('roleWin').show();
	}
}
/**
 * 给用户组添加角色 
 */
function addRoleToUserGroup(groupId,roleIds) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var roles = roleIds.split(",");
	for(var i=0;i<roles.length;i++){
		var sql = "insert into FPF_GROUP_ROLE_MAP (group_id, role_id) values(";
		sql += "'"+groupId+"'";
		sql += ",'"+roles[i]+"'";
		sql += ")";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '为用户组添加角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					Ext.getCmp('roleWin').hide();
				} else {
					mask.hide();
					Ext.getCmp('roleWin').hide();
					//添加角色成功后刷新窗口
					relateRole(groupId);
					Ext.MessageBox.show({
						title : "",
						msg : "为用户组添加角色成功！",
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '为用户组添加角色失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				Ext.getCmp('roleWin').hide();
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
 * 删除组对应的角色 
 */
function delRoleFromGroup(groupId,roleIds) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var roles = roleIds.split(",");
	for(var i=0;i<roles.length;i++){
		var sql = "delete from FPF_GROUP_ROLE_MAP where group_id='"+groupId+"' and role_id='"+roles[i]+"'";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户组对应的角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//添加角色成功以后刷新窗口
					relateRole(groupId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户组对应的角色成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '删除用户组对应的角色失败！',
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
 * 用户组关联的用户
 */
function relateUser(groupId){
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
			var userStore = Ext.getCmp('userGrid').getStore();
			var sql = "select r.userid,r.username,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.cityid) cityname,r.createtime from FPF_USER_GROUP_MAP m ,FPF_USER_USER r where m.group_id='"+groupId+"' and m.userid=r.userid";
			if(cityId != 0){
				sql += " and r.cityid = '"+cityId+"'";
			}
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
			name : 'cityname'
		},{
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
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	},{
		header : "创建时间",
		width : 150,
		sortable : true,
		dataIndex : 'createtime'
	}]);
	var userGrid = new Ext.grid.GridPanel({
		id : 'userGrid',
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
	var sql = "select r.userid,r.username,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.cityid) cityname,r.createtime from FPF_USER_GROUP_MAP m ,FPF_USER_USER r where m.group_id='"+groupId+"' and m.userid=r.userid";
	if(cityId != 0){
		sql += " and r.cityid = '"+cityId+"'";
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
	
	var relateUserWin = Ext.getCmp("relateUserWin");
	if (relateUserWin == null) {
			relateUserWin = new Ext.Window({
				id : 'relateUserWin',
				el : 'relateUserWinDiv',
				title : '用户组关联的用户',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ userGrid.show() ],
				buttons : [ {
					text : '添加用户',
					handler : function() {
						showUserWin(getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id"));
					}
				},{
					text : '删除用户',
					handler : function() {
						var selections = Ext.getCmp('userGrid').getSelectionModel().getSelections();
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
							title : '信息',
							msg : '请先选择要删除的用户！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
						}
						Ext.Msg.confirm("信息","确定要删除所选的用户吗？",function(btn){
							if(btn=='yes'){
								delUserFromGroup(getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id"),userIds);
							}
						});
					}
				},{
					text : '关闭',
					handler : function() {
						relateUserWin.hide();
					}
				} ]
			});
			relateUserWin.show();
	}else{
		relateUserWin.remove("userGrid");
		relateUserWin.add(userGrid.show());
		relateUserWin.doLayout();
		relateUserWin.show();
	}
}

/**
 * 打开选择用户窗口
 */
function showUserWin(groupId) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
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
			var sql = "select b.userid,b.username,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=b.cityid) cityname,b.createtime from FPF_USER_USER b where b.userid not in (select c.userid from FPF_USER_GROUP_MAP c where c.group_id='"+groupId+"')";
			sql += " and not exists (select 1 from FPF_USER_GROUP_MAP a where a.userid=b.userid)";
			if(cityId != 0){
				sql += " and b.cityid = '"+cityId+"'";
			}
			if(userName){
				sql += " and b.username like '%"+userName+"%'";
			}
			sql += "order by b.cityid";
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
			name : 'cityname'
		},{
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
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	},{
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
	var sql = "select b.userid,b.username,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=b.cityid) cityname,b.createtime from FPF_USER_USER b where b.userid not in (select c.userid from FPF_USER_GROUP_MAP c where c.group_id='"+groupId+"')";
	sql += " and not exists (select 1 from FPF_USER_GROUP_MAP a where a.userid=b.userid)";
	if(cityId != 0){
		sql += " and b.cityid = '"+cityId+"'";
	}
	sql +=" order by b.cityid";
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
			width : 650,
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
							msg : "请先选择要为此用户组关联的用户！",
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
					}
					Ext.Msg.confirm("信息","确定要为此用户组关联所选的用户吗？",function(btn){
						if(btn=='yes'){
							groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
							addUserToGroup(groupId,userIds);
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
 * 给组添加用户 
 */
function addUserToGroup(groupId,userIds) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var users = userIds.split(",");
	for(var i=0;i<users.length;i++){
		var sql = "insert into FPF_USER_GROUP_MAP (group_id, userid) values(";
		sql += "'"+groupId+"'";
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
						msg : '为用户组添加用户失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//添加用户成功以刷新窗口
					relateUser(groupId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '为用户组添加用户成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					Ext.getCmp('userWin').hide();
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给组添加用户失败！',
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
 * 删除用户组对应的用户 
 */
function delUserFromGroup(groupId,userIds) {
	var groupId = getSelectedColumnValue(Ext.getCmp('userGroupGrid'),"group_id");
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍候...',
		removeMask : true
	});
	mask.show();
	var users = userIds.split(",");
	for(var i=0;i<users.length;i++){
		var sql = "delete from FPF_USER_GROUP_MAP where group_id='"+groupId+"' and userid='"+users[i]+"'";
		Ext.Ajax.request({
			url : '/mvc/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户组对应的用户失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//添加用户成功后刷新窗口
					relateUser(groupId);
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户组对应的用户成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '删除组对应的用户失败！',
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