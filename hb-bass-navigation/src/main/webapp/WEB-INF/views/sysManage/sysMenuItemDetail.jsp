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
			src="${mvcPath}/resources/js/default/default_min.js" charset=utf-8></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/tabext.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/grid.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/resources/css/default/default.css" />
		<%@include file="../include.jsp"%>
		<script type="text/javascript">
		function paramsObj(){
			var _uri = window.location+"";
			var _paramStr = "";
			var _encoderOriUri="";
			if(_uri.indexOf("?")>0){
				_uri = _uri.substring(_uri.indexOf("?")+1,_uri.length);
				var _arr = _uri.split("&");
				for(var i=0;i<_arr.length;i++){
					var _arr2=_arr[i].split("=");
					if(_encoderOriUri.length>0)_encoderOriUri+="&";
					_encoderOriUri +=_arr2[0]+"="+encodeURIComponent(_arr2[1]);
					if(_paramStr.length>0)_paramStr+=",";
					_paramStr += '"'+_arr2[0]+'":"'+_arr2[1]+'"';
				}
			}else{
				_uri="";
			}
			var _objParams={};
			eval('_objParams={\"_oriUri\":\"'+_uri+'\",\"_encoderOriUri\":\"'+_encoderOriUri+'\"'+(_paramStr.length>0?','+_paramStr:'')+'}');
			return _objParams;
		}
		var paramsObj = paramsObj();
		var mid = paramsObj?paramsObj.id:0;
		</script>
	</head>
	<body style="margin: 0px;">
		<div
			style="margin-top: 20px; margin-left: 20px; margin-right: 0px; width: 100%;">
			<table align='center' width='97%' class='grid-tab-blue'
				cellspacing='1' cellpadding='0' border='0' style="display: ''">
				<tr class='dim_row'>
					<td class="dim_cell_title" align="right">
						&nbsp;角色名称：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="role_name" size="25">
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
			<table align="center" width="97%"
				style="margin-top: 2px; margin-right: 0px; margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="查询"
							onClick="queryRelateRole()">
						<input type="button" class="form_button" value="新增"
							onClick="showRoleDiv()">
						<input type="button" class="form_button" value="删除"
							onClick="delRoleFromMenu()">
					</td>
				</tr>
			</table>
		</div>
		<div id="relateRoleGrid"
			style="margin-left: 35px; margin-right: 0px; width: 100%;">
		</div>

		<div
			style="margin-top: 40px; margin-left: 20px; margin-right: 0px; width: 100%;">
			<table align='center' width='97%' class='grid-tab-blue'
				cellspacing='1' cellpadding='0' border='0' style="display: ''">
				<tr class='dim_row'>
					<td class="dim_cell_title" align="right" nowrap="nowrap">
						&nbsp;用户中文姓名：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="user_name" size="25">
						<input type="hidden" id="user_id">
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
			<table align="center" width="97%"
				style="margin-top: 2px; margin-right: 0px; margin-bottom: 3px">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="查询"
							onClick="queryRelateUser()">
						<input type="button" class="form_button" value="新增"
							onclick="showSysUserDiv();">
						<input type="button" class="form_button" value="删除"
							onClick="delUserFromMenu()">
					</td>
				</tr>
			</table>
		</div>
		<div id="relateUserGrid"
			style="margin-left: 35px; margin-right: 0px; width: 100%;">
		</div>

		<div id="sysUserWindowDiv"></div>
		<div id="sysUserGrid"></div>
		<div id="roleWindowDiv"></div>
	</body>
</html>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
var itemsPerPage = 10;
Ext.onReady(function() {
	Ext.QuickTips.init();
	
	var relateRoleStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'roleid'
		}, {
			name : 'rolename'
		},{
			name : 'cityname'
		}])
	});
	
	var relateRoleCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "角色ID",
		width : 350,
		sortable : true,
		dataIndex : 'roleid'
	}, {
		header : "角色名称",
		width : 350,
		sortable : true,
		dataIndex : 'rolename'
	},{
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	}]);
	
	var relateRoleGrid = new Ext.grid.GridPanel({
		id : 'relateRoleGrid',
		store : relateRoleStore,
		sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : relateRoleCm,
		loadMask : true,
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:98%',
		autoWidth : true,
		enableColumnResize : true,
		height : 200,
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : relateRoleStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '98%'
		}),
		renderTo : 'relateRoleGrid'
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
			name : 'groupname'
		},{
			name : 'cityname'
		}])
	});
	
	var relateUserCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户ID",
		width : 200,
		sortable : true,
		dataIndex : 'userid'
	}, {
		header : "用户名称",
		width : 200,
		sortable : true,
		dataIndex : 'username'
	},{
		header : "用户组",
		width : 300,
		sortable : true,
		dataIndex : 'groupname'
	},{
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	}]);
	
	var relateUserGrid = new Ext.grid.GridPanel({
		id : 'relateUserGrid',
		store : relateUserStore,
		sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : relateUserCm,
		loadMask : true,
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:98%',
		autoWidth : true,
		enableColumnResize : true,
		height : 200,
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : relateUserStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '98%'
		}),
		renderTo : 'relateUserGrid'
	});
	
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
			var userStore = Ext.getCmp('userPanel').getStore();
			//var sql = "select userid,username from FPF_USER_USER where 1=1 and userid not in (select user_id from FPF_SYS_MENUITEM_USER where menu_id="+mid+")";
			var sql = "select m.userid,m.username,m.createtime,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=m.cityid) cityname,t.group_name groupname from FPF_USER_USER m ";
			sql += " left join(select a.group_id,a.group_name,b.userid from FPF_USER_GROUP a,FPF_USER_GROUP_MAP b where a.group_id=b.group_id and a.parent_id is not null) t";
			sql += " on m.userid=t.userid";
			sql += " where 1=1 and m.userid not in (select n.user_id from FPF_SYS_MENUITEM_USER n where n.menu_id=353)";
			if(cityId != 0){
				sql += " and m.cityid = '"+cityId+"'";
			}
			if (userName) {
				sql += " and m.username like '%" + userName + "%'";
			}
			sql += " order by m.cityid";
			userStore.baseParams['sql'] = strEncode(sql);
			userStore.baseParams['ds'] = WEB_DS;
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
		},{
			name : 'groupname'
		},{
			name : 'cityname'
		},{
			name : 'createtime'
		} ])
	});
	
	var userCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户ID",
		width : 100,
		sortable : true,
		dataIndex : 'userid'
	}, {
		header : "用户姓名",
		width : 100,
		sortable : true,
		dataIndex : 'username'
	},{
		header : "用户组",
		width : 250,
		sortable : true,
		dataIndex : 'groupname'
	},{
		header : "所属地市",
		width : 100,
		sortable : true,
		dataIndex : 'cityname'
	},{
		header : "创建时间",
		width : 200,
		sortable : true,
		dataIndex : 'createtime'
	} ]);
	
	var userPanel = new Ext.grid.GridPanel({
		id : 'userPanel',
		store : userStore,
		sm : new Ext.grid.CheckboxSelectionModel(),
		cm : userCm,
		loadMask : new Ext.LoadMask(Ext.getBody(), {
			msg : '正在查询，请稍后...',
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : true
		},
		autoWidth : true,
		autoHeight : true,
		hidden : true,
		tbar : [ '用户姓名：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : 10,
			store : userStore,
			displayInfo : true,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据'
		}),
		renderTo : 'sysUserGrid'
	});
	
	queryRelateRole();
	queryRelateUser();
});// Ext.onReady结束

/**
 * 查询菜单关联的角色
 */
function queryRelateRole() {
	if(!mid){
		mid = -1;
	}
	
	var roleStore = Ext.getCmp('relateRoleGrid').getStore();
	var sql = "select a.operatorid roleid ,b.role_name rolename,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=b.create_group) cityname from FPF_SYS_MENUITEM_RIGHT a left join FPF_USER_ROLE b on a.operatorid=b.role_id where a.resourceid='"+mid+"'";
	if(cityId != 0){
		sql += " and b.create_group = '"+cityId+"'";
	}
	if($('#role_name').val()){
		sql += " and b.role_name like '%"+$('#role_name').val().trim()+"%'";
	}
	sql += "and b.create_group is not null with ur ";
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
 * 查询菜单关联的用户
 */
function queryRelateUser() {
	if(!mid){
		mid = -1;
	}
	var userStore = Ext.getCmp('relateUserGrid').getStore();
	var sql = "select a.user_id userid,b.username username,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=b.cityid) cityname,(select c.group_name from FPF_USER_GROUP c where c.group_id=(select p.group_id from FPF_USER_GROUP_MAP p where a.user_id=p.userid)) groupname from FPF_SYS_MENUITEM_USER a left join FPF_USER_USER b on a.user_id=b.userid where a.menu_id="+mid;
	if(cityId != 0){
		sql += " and b.cityid = '"+cityId+"'";
	}
	if($('#user_name').val()){
		sql += " and b.username like '%"+$('#user_name').val().trim()+"%'";
	}
	sql += " order by b.cityid with ur ";
	userStore.baseParams['ds'] = WEB_DS;
	userStore.baseParams['sql'] = strEncode(sql);
	userStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
}

/**
 * 打开选择用户的窗口
 */
function showSysUserDiv() {
	if(mid=='-1' || mid ==null){
		Ext.MessageBox.show({
			title : "信息",
			msg : "请先选中一个菜单！",
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var userPanel = Ext.getCmp('userPanel');
	var userStore = userPanel.getStore();
	var sql = "select m.userid,m.username,m.createtime,(select t.area_name from (select area_id,area_name from mk.bt_area union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=m.cityid) cityname,t.group_name groupname from FPF_USER_USER m ";
	sql += " left join(select a.group_id,a.group_name,b.userid from FPF_USER_GROUP a,FPF_USER_GROUP_MAP b where a.group_id=b.group_id and a.parent_id is not null) t";
	sql += " on m.userid=t.userid";
	sql += " where 1=1 and m.userid not in (select n.user_id from FPF_SYS_MENUITEM_USER n where n.menu_id=353)";
	if(cityId != 0){
		sql += " and m.cityid = '"+cityId+"'";
	}
	sql += " order by m.cityid";
	userStore.baseParams['sql'] = strEncode(sql);
	userStore.baseParams['ds'] = WEB_DS;
	userStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	if (Ext.getCmp('sysUserWin') == null) {
		var win = new Ext.Window({
			id : 'sysUserWin',
			el : 'sysUserWindowDiv',
			title : '选择人员',
			layout : 'fit',
			width : 650,
			autoHeight : true,
			closeAction : 'hide',
			items : [ userPanel.show() ],
			buttons : [ {
					text : '确定',
					handler : function() {
						var selections = Ext.getCmp('userPanel').getSelectionModel().getSelections();
						if(selections.length==0){
							Ext.MessageBox.show({
								title : '信息',
								msg : '请先选择要为菜单授权的人员！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}else{
							Ext.Msg.confirm('信息',"确定要为所选择的人员授权该菜单吗？",function(btn){
								if(btn=='yes'){
									for ( var i = 0; i < selections.length; i++) {
										var record = selections[i];
										//document.getElementById("user_name").value = record.get('username');
										document.getElementById("user_id").value = record.get('userid');
										addUserToMenu(mid,record.get('userid'));
									}
								}							
							});
						}
					}
				},{
					text : '关闭',
					handler : function(){
						Ext.getCmp('sysUserWin').hide();
					}
				}]
		});
		win.show();
	} else {
		Ext.getCmp('sysUserWin').show();
	}
}

/**
 * 为菜单关联用户
 */
function addUserToMenu(mid,userid){
	var sql = "insert into FPF_SYS_MENUITEM_USER(menu_id,user_id) values("+mid+",'"+userid+"')";
	
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候...',
		removeMask : true
	});
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给访问菜单的用户授权失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				insertMuneItemLog('14');
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给访问菜单的用户授权成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('sysUserWin').hide();
				document.getElementById("user_name").value="";
				queryRelateUser();
				insertMuneItemLog('13');
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '给访问菜单的用户授权失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
			insertMuneItemLog('14');
		},
		params : {
			'sql' : strEncode(sql),
			'ds' : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 删除菜单关联的用户
 */
function delUserFromMenu(){
	var userid="(";
	var selections = Ext.getCmp('relateUserGrid').getSelectionModel().getSelections();
	for ( var i = 0; i < selections.length; i++) {
		var record = selections[i];
		if(i==selections.length-1){
			userid += "'"+record.get('userid')+"')";
		}else{
			userid += "'"+record.get('userid')+"',";
		}
	}
	var sql = "delete from FPF_SYS_MENUITEM_USER where menu_id="+mid+" and user_id in "+userid;
	
	if (selections.length==0) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择要删除的用户！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍候...',
		removeMask : true
	});
	Ext.Msg.confirm("信息","确定要删除菜单关联的用户吗？",function(btn){
		if(btn=='yes'){
			Ext.Ajax.request({
				url : '/mvc/jsonData/query',
				success : function(obj) {
					var result = obj.responseText;
					if (result == "-1") {
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除访问菜单的用户失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						insertMuneItemLog('16');
						mask.hide();
					} else {
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除访问菜单的用户成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						document.getElementById("user_name").value="";
						queryRelateUser();
						insertMuneItemLog('15');
						mask.hide();
					}
				},
				failure : function() {
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除访问菜单的用户失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					insertMuneItemLog('16');
					mask.hide();
				},
				params : {
					'sql' : strEncode(sql),
					'ds' : WEB_DS,
					'start' : 0,
					'limit' : itemsPerPage
				}
			});
				}
			});
}

/**
 * 打开选择角色的窗口
 */
function showRoleDiv() {
	if(mid=='-1' || mid ==null){
		Ext.MessageBox.show({
			title : "信息",
			msg : "请先选中一个菜单！",
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var roleStore = new Ext.data.Store({
		url : '/mvc/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'roleid'
		}, {
			name : 'rolename'
		},{
			name : 'cityname'
		},{
			name : 'createtime'
		}])
	});
	
	var roleCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "角色ID",
		width : 250,
		sortable : true,
		dataIndex : 'roleid'
	}, {
		header : "角色名称",
		width : 250,
		sortable : true,
		dataIndex : 'rolename'
	},{
		header : "所属地市",
		width : 60,
		sortable : true,
		dataIndex : 'cityname'
	},{
		header : "创建时间",
		width : 180,
		sortable : true,
		dataIndex : 'createtime'
	}]);
	
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
			var sql = "select a.role_id roleid,a.role_name rolename,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) cityname,a.create_time createtime from FPF_USER_ROLE a where a.role_id not in (select b.operatorid from FPF_SYS_MENUITEM_RIGHT b where b.resourceid='"+mid+"')";
			if(cityId != 0){
				sql += " and a.create_group = '"+cityId+"'";
			}
			if (roleName) {
				sql += " and a.role_name like '%" + roleName + "%'";
			}
			sql += " and a.create_group is not null order by a.create_group";
			roleStore.baseParams['sql'] = strEncode(sql);
			roleStore.baseParams['ds'] = WEB_DS;
			roleStore.reload({
				params : {
					start : 0,
					limit : itemsPerPage
				}
			});
		}
	});
	
	var roleGridPanel = new Ext.grid.GridPanel({
		id : 'roleGridPanel',
		store : roleStore,
		sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : roleCm,
		loadMask : new Ext.LoadMask(Ext.getBody(), {
			msg : '正在查询，请稍候...',
			removeMask : true
		}),
		trackMouseOver : false,
		viewConfig : {
			forceFit : false
		},
		bodyStyle : 'width:98%',
		autoWidth : true,
		enableColumnResize : true,
		height : 200,
		tbar : [ '角色名称：', searchField ],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : roleStore,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '98%'
		})
	});
	var sql = "select a.role_id roleid,a.role_name rolename,a.create_time createtime,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) cityname from FPF_USER_ROLE a where a.role_id not in (select b.operatorid from FPF_SYS_MENUITEM_RIGHT b where b.resourceid='"+mid+"')";
	if(cityId != 0){
		sql += " and a.create_group = '"+cityId+"'";
	}
	sql += " and a.create_group is not null order by a.create_group";
	roleStore.baseParams['sql'] = strEncode(sql);
	roleStore.baseParams['ds'] = WEB_DS;
	roleStore.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	if (Ext.getCmp('roleWin') == null) {
		var roleWin = new Ext.Window({
			id : 'roleWin',
			el : 'roleWindowDiv',
			title : '选择角色',
			layout : 'fit',
			width : 700,
			//autoHeight : true,
			height : 370,
			closeAction : 'hide',
			items : [ roleGridPanel.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					var selections = Ext.getCmp('roleGridPanel').getSelectionModel().getSelections();
					if(selections.length==0){
						Ext.MessageBox.show({
							title : "信息",
							msg : "请先选择要为该菜单关联的角色！",
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
					}else{
						Ext.Msg.confirm("信息","确定要为该菜单关联所选的角色吗？",function(btn){
							if(btn=="yes"){
								addRoleToMenu(mid,selections);
							}
						});
					}
				}
			},{
				text : '关闭',
				handler : function(){
					Ext.getCmp('roleWin').hide();
				}
			} ]
		});
		roleWin.show();
	} else {
		Ext.getCmp('roleWin').remove("roleGridPanel");
		Ext.getCmp('roleWin').add(roleGridPanel.show());
		Ext.getCmp('roleWin').doLayout();
		Ext.getCmp('roleWin').show();
	}
}

/**
 * 为菜单关联角色
 */
function addRoleToMenu(mid,selections){
	var sql = "insert into FPF_SYS_MENUITEM_RIGHT(resourceid,operatorid) values('"+mid+"','";
	var totalSql="";
	for ( var i = 0; i < selections.length; i++) {
		var record = selections[i];
		totalSql+=sql+record.get('roleid')+"')~@~";
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍候！',
		removeMask : true
	});
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给菜单添加能访问的角色失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				insertMuneItemLog('10');
			} else {
				mask.hide();
				Ext.getCmp('roleWin').hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给菜单添加能访问的角色成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				addRoleUserToMenu(mid,selections);
				document.getElementById("role_name").value="";
				queryRelateRole();
				insertMuneItemLog('9');
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '给菜单添加能访问的角色失败！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
			insertMuneItemLog('10');
		},
		params : {
			'sql' : strEncode(totalSql),
			'ds' : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 为菜单关联角色成功后为有该角色的用户关联该菜单
 */
function addRoleUserToMenu(mid,selections){
	var roleIds = "(";
	for(var i=0; i<selections.length; i++){
		var record = selections[i];
		if(i==selections.length-1){
			roleIds += "'"+record.get('roleid')+"'";
		}else{
			roleIds += "'"+record.get('roleid')+"',"
		}
		roleIds += ")"; 
	}
	//一个用户可能存在多个角色（distinct的作用）
	var sql = "select distinct a.userid from FPF_USER_ROLE_MAP a where a.role_id in "+roleIds;
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(response) {
			var obj = Ext.util.JSON.decode(response.responseText);// 返回的JSON字符串
				var userIdArray = obj.root;
				for(var j=0; j<userIdArray.length; j++){
					var sql1 = "insert into FPF_SYS_MENUITEM_USER(menu_id,user_id) values(";
					sql1 += mid;
					sql1 += ",'"+userIdArray[j]["userid"]+"'";
					sql1 += ")";	
					Ext.Ajax.request({
						url : '/mvc/jsonData/query',
						success : function(response) {
							queryRelateUser();
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
		failure : function() {},
		params : {
			'sql' : strEncode(sql),
			'ds' : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 删除菜单对应的角色
 */
function delRoleFromMenu(){
	var roleIdTemp="(";
	var selections = Ext.getCmp('relateRoleGrid').getSelectionModel().getSelections();
	for ( var i = 0; i < selections.length; i++) {
		var record = selections[i];
		var roleId = record.get('roleid');
		if(i==selections.length-1){
			roleIdTemp +="'"+roleId+"')";
		}else{
			roleIdTemp +="'"+roleId+"',";
		}
	}
	var sql = "delete from FPF_SYS_MENUITEM_RIGHT where resourceid='"+mid+"' and operatorid in "+roleIdTemp;
	
	if (roleIdTemp=="(") {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择要删除的角色！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(),{
		msg : '正在删除数据，请稍候...',
		removeMask : true
	});
	Ext.Msg.confirm("信息","确定要删除该菜单对应的角色吗？",function(btn){
		if(btn=='yes'){
			Ext.Ajax.request({
				url : '/mvc/jsonData/query',
				success : function(obj) {
					var result = obj.responseText;
					if (result == "-1") {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除访问菜单的角色失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						insertMuneItemLog('12');
					} else {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '删除访问菜单的角色成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						delRoleUserFromMenu(mid,selections);
						document.getElementById("role_name").value="";
						queryRelateRole();
						insertMuneItemLog('11');
					}
				},
				failure : function() {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除访问菜单的角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					insertMuneItemLog('12');
				},
				params : {
					'sql' : strEncode(sql),
					'ds' : WEB_DS,
					'start' : 0,
					'limit' : itemsPerPage
				}
			});
		}
	})
}

/**
 * 删除菜单对应的角色成功之后删除该角色所关联的用户
 */
function delRoleUserFromMenu(mid,selections){
	var roleIds = "(";
	for(var i=0; i<selections.length; i++){
		var record = selections[i];
		if(i==selections.length-1){
			roleIds += "'"+record.get('roleid')+"'";
		}else{
			roleIds += "'"+record.get('roleid')+"',"
		}
		roleIds += ")"; 
	}
	//一个用户可能存在多个角色（distinct的作用）
	var sql = "select distinct a.userid from FPF_USER_ROLE_MAP a where a.role_id in "+roleIds;
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(response) {
			var obj = Ext.util.JSON.decode(response.responseText);// 返回的JSON字符串
				var userIdArray = obj.root;
				for(var j=0; j<userIdArray.length; j++){
					var sql1 = "delete from FPF_SYS_MENUITEM_USER a where a.menu_id=";
					sql1 += mid;
					sql1 += " and a.user_id='"+userIdArray[j]["userid"]+"'";
					Ext.Ajax.request({
						url : '/mvc/jsonData/query',
						success : function(response) {
							queryRelateUser();
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
		failure : function() {},
		params : {
			'sql' : strEncode(sql),
			'ds' : WEB_DS,
			'start' : 0,
			'limit' : itemsPerPage
		}
	});
}

/**
 * 插入菜单操作日志
 */
function insertMuneItemLog(result){
	var opertype = '5';//权限变更事件
	var app_code = '98090538';
	var app_name = '菜单管理';
	Ext.Ajax.request({
			url : '/mvc/logAction/insertLogAction',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					Ext.MessageBox.show({
						title : '信息',
						msg : '权限变更日志记录失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					mask.hide();
				} 
			},
			failure : function() {
				Ext.MessageBox.show({
					title : '信息',
					msg : '权限变更日志操作失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				mask.hide();
			},
			params : {
				'result' : result,
				'opertype' : opertype,
				'app_code' : app_code,
				'app_name' : app_name
			}
		});
}
</script>