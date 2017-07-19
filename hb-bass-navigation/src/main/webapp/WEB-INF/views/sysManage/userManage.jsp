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
		<script type="text/javascript"
			src="${mvcPath}/resources/js/default/des.js"></script>
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
						&nbsp;用户ID：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="_userId" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;用户姓名：
					</td>
					<td class="dim_cell_content">
						<input type="text" id="_userName" size="25">
					</td>
					<td class="dim_cell_title" align="right">
						&nbsp;地市：
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
							onClick="queryUserInfo()">
						<input type="button" class="form_button" value="新增"
							onClick="showAddUserWin()">
					</td>
				</tr>
			</table>
		</div>
		<div id="grid"
			style="margin-left: 35px; margin-right: 0px; width: 100%">
		</div>
		<div id="roleWinDiv"></div>
		<div id="addUserDiv"></div>
		<div id="addUserWinDiv"></div>
		<div id="modifyUserDiv"></div>
		<div id="modifyUserWinDiv"></div>
	</body>
</html>
<script type="text/javascript">

Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
Ext.onReady(function() {
	Ext.QuickTips.init();
	
	//地市数据源
	var cityStore = new Ext.data.Store({
		url : '${mvcPath}/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'area_id'
		}, {
			name : 'area_name'
		} ])
	});
	
	//地市下拉列表
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
	var sql = "select * from (select area_id,area_name from mk.bt_area where  1=1 union all select * from (values (0,'湖北')) c(area_id,area_name) ) as tem where 1=1 ";
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
	
	//表格数据源
	var userStore = new Ext.data.Store({
		url : '${mvcPath}/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'userid'
		}, {
			name : 'username'
		},{
			name : 'cityname'
		}, {
			name : 'cityid'
		},{
			name : 'departmentname'
		}, {
			name : 'departmentid'
		},{
			name : 'user_group_name'
		}, {
			name : 'user_group'
		}, {
			name : 'mobilephone'
		}, {
			name : 'email'
		}, {
			name : 'notes'
		}, {
			name : 'address'
		}, {
			name : 'jishi_user'
		}, {
			name : 'hcras_user'
		} ])
	});
	
	//表格列模型
	var userCm = new Ext.grid.ColumnModel(
	[ new Ext.grid.CheckboxSelectionModel(), {
		header : "用户ID",
		width : 150,
		sortable : true,
		dataIndex : 'userid'
	}, {
		header : "用户名称",
		width : 150,
		sortable : true,
		dataIndex : 'username'
	}, {
		header : "地市",
		width : 150,
		sortable : true,
		dataIndex : 'cityname' 
	}, {
		header : "地市代码",
		width : 150,
		sortable : true,
		hidden : true,
		dataIndex : 'cityid'
	}, {
		header : "部门",
		width : 150,
		sortable : true,
		dataIndex : 'departmentname'
	},{
		header : "部门代码",
		width : 150,
		sortable : true,
		hidden : true,
		dataIndex : 'departmentid'
	}, {
		header : "手机",
		width : 150,
		sortable : true,
		dataIndex : 'mobilephone'
	}, {
		header : "用户组",
		width : 300,
		sortable : true,
		dataIndex : 'user_group_name'
	},{
		header : "用户组代码",
		width : 300,
		sortable : true,
		hidden : true,
		dataIndex : 'user_group'
	}, {
		header : "操作 ",
		width : 200,
		sortable : true,
		align : 'center',
		dataIndex : 'operate',
		renderer:renderBtn
	} ]);
	
	function renderBtn(value, cellmeta, record, rowIndex, columnIndex, store) {
        var str = "<input type='button' class='form_button_short' value='修改' onclick='showUserPanelForUpdate()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_short' value='删除' onclick='deleteUserInfo()'>&nbsp;&nbsp;&nbsp;&nbsp;"
                + "<input type='button' class='form_button_mid' value='关联角色' onclick='relateRole(\""+record.get('userid')+"\")'>";
        return str;
    }
    
    // 表格内容
	var userGrid = new Ext.grid.GridPanel({
		id : 'userGrid',
		store : userStore,
		// sm : new Ext.grid.CheckboxSelectionModel(),//取消即为单选
		cm : userCm,
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
		align : 'left',
		enableColumnResize : true,
		height : 340,
		stripeRows : true,
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : userStore,
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
								var totalCount = Ext.getCmp('userGrid').getStore().getTotalCount();
								if(totalCount==0){
									Ext.MessageBox.show({
										title : "信息",
										msg : "请先查询出数据之后在下载查询的数据！",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
									return;
								}
								var sql = "select userid,username,value(( select area_name from mk.bt_area where char(area_id)=cityid),'湖北') cityname,(select title from FPF_USER_COMPANY where deptid=departmentid) departmentname,mobilephone,(select max(g.group_name) from FPF_USER_GROUP g,FPF_USER_GROUP_MAP gm where gm.userid=u.userid and g.group_id=gm.group_id) user_group_name from FPF_USER_USER u where 1=1 ";
								if(cityId != 0){
									sql += " and cityid = '"+cityId+"'";
								}
								if($('#_userId').val()){
									sql += " and userid like '%"+$('#_userId').val().trim()+"%'";
								}
								if($('#_userName').val()){
									sql += " and username like '%"+$('#_userName').val().trim()+"%'";
								}
								if (cityComBox.getValue()) {
									sql += " and cityid = '" + cityComBox.getValue() + "' ";
								}
								sql += " order by user_group_name asc";
								var time = getCurrentTimeStr();
								var spreadSheetHeader = "用户ID,用户名称,地市,部门,手机号码,用户组";
								var fileName = "userData_"+time;
								var fileType = "excel";
								var mask = new Ext.LoadMask(document.body, {
									msg : '正在下载，请稍后...',
									removeMask : true
								});
								mask.show();
								Ext.Ajax.request({
									url : '/mvc/fileMgr/downLoad',
									success : function(obj){
										document.getElementById("downA").href = "<%=request.getContextPath()%>"+"\\download\\"+"userData_"+time+ ".xls";
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
	
	//部门数据源
	var deptStore = new Ext.data.Store({
		url : '${mvcPath}/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'deptid'
		}, {
			name : 'deptname'
		} ])
	});
	var sql = "select deptid, parentid, title deptname from FPF_USER_COMPANY ";
	sql = sql + " order by substr(char(deptid),1,2),parentid,deptid";
	deptStore.baseParams['sql'] = strEncode(sql);
	deptStore.baseParams['ds'] = WEB_DS;
	//deptStore.baseParams['simpleResult'] = "true";
	deptStore.baseParams['limit'] = 999999;
	deptStore.baseParams['start'] = 0;
	deptStore.reload();
	
	//用户组数据源
	var userGroupStore = new Ext.data.Store({
		url : '${mvcPath}/jsonData/query',
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'root'
		}, [ {
			name : 'group_id'
		}, {
			name : 'group_name'
		} ])
	});
	var sql = "select group_id, group_name from FPF_USER_GROUP order by group_name";
	userGroupStore.baseParams['sql'] = strEncode(sql);
	userGroupStore.baseParams['ds'] = WEB_DS;
	//userGroupStore.baseParams['simpleResult'] = "true";
	userGroupStore.baseParams['limit'] = 999999;
	userGroupStore.baseParams['start'] = 0;
	userGroupStore.reload();
	
	//新增用户表单
	var addUserInfoForm = new Ext.form.FormPanel({
		id : 'addUserInfoForm',
		width : 250,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "addUserDiv",
		//title : "",
		items : [{
			id : "addUserId",
			xtype : "textfield",
			fieldLabel : "用户ID<A style=COLOR:red>*</A>",
			width : 200,
			allowBlank : false
		},{
			id : "addUserName",
			xtype : "textfield",
			fieldLabel : "用户名称<A style=COLOR:red>*</A>",
			width : 200,
			allowBlank : false
		},{
			id : "addPwd",
			xtype : "textfield",
			//inputType: "password",//密文方式
			fieldLabel : "密码<A style=COLOR:red>*</A>",
			emptyText : 'Jfqt2011',
			readOnly : true,
			width : 200
			//allowBlank : false
		},{
			id : "addCityId",
			xtype : "combo",
			fieldLabel : "地市<A style=COLOR:red>*</A>",
			store : cityStore,
			valueField : 'area_id',
			displayField : 'area_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183,
			allowBlank : false,
			listeners: { 
      	  	'select' : function(combo, record, index) { 
						var sql = "select deptid, parentid, title deptname from FPF_USER_COMPANY ";
						var groupSql = "select a.group_id, a.group_name from FPF_USER_GROUP a inner join FPF_USER_GROUP_MAP b on a.group_id=b.group_id inner join FPF_USER_USER c on c.userid=b.userid where 1=1 ";
						var cityValue = this.getValue();
						if(cityValue!=""){
							sql = sql + " where deptid="+cityValue+" or parentid="+cityValue+" ";
							groupSql = groupSql + " and c.cityid='"+cityValue+"' "
						}
						sql = sql + " order by substr(char(deptid),1,2),parentid,deptid ";
						groupSql = groupSql + " group by a.group_id, a.group_name order by a.group_id "
						deptStore.baseParams['sql'] = strEncode(sql);
						deptStore.baseParams['ds'] = WEB_DS;
						deptStore.reload({
							params : {
								start : 0,
								limit : 999999
							}
						});
						userGroupStore.baseParams['sql'] = strEncode(groupSql);
						userGroupStore.baseParams['ds'] = WEB_DS;
						userGroupStore.reload({
							params : {
								start : 0,
								limit : 999999
							}
						});
      	} 
      }
		},{
			id : "addDeptId",
			xtype : "combo",
			fieldLabel : "部门<A style=COLOR:red>*</A>",
			store : deptStore,
			valueField : 'deptid',
			displayField : 'deptname',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183,
			allowBlank : false
		},{
			id : "addGroupId",
			xtype : "combo",
			fieldLabel : "用户组",
			store : userGroupStore,
			valueField : 'group_id',
			displayField : 'group_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183
		},{
			id : "addPhone",
			xtype : "textfield",
			fieldLabel : "用户手机",
			width : 200
		},{
			id : "addEmail",
			xtype : "textfield",
			fieldLabel : "电子邮箱",
			width : 200
		},{
			id : "addNotes",
			xtype : "textfield",
			fieldLabel : "备注",
			width : 200
		},{
			id : "addIP",
			xtype : "textfield",
			fieldLabel : "IP",
			width : 200
		},{
			id : "addIsJishi",
			xtype : "checkbox",
			fieldLabel : "是否集市用户",
			width : 200
		},{
			id : "addIsHcras",
			xtype : "checkbox",
			fieldLabel : "是否有价值用户",
			width : 200
		} ]
	});

	//修改用户表单
	var modifyUserForm = new Ext.form.FormPanel({
		id : 'modifyUserForm',
		width : 250,
		frame : true,//圆角和浅蓝色背景
		hidden : true,
		renderTo : "modifyUserDiv",//呈现
		title : "",
		items : [{
			id : "updateUserId",
			xtype : "textfield",
			fieldLabel : "用户ID<A style=COLOR:red>*</A>",
			width : 200,
			readOnly : true,
			allowBlank : false
		},{
			id : "updateUserName",
			xtype : "textfield",
			fieldLabel : "用户名称<A style=COLOR:red>*</A>",
			width : 200,
			allowBlank : false
		},{
			id : "updatePwd",
			xtype : "textfield",
			//inputType: "password",
			fieldLabel : "密码<A style=COLOR:red>*</A>",
			emptyText : 'Jfqt2011',
			width : 200,
			readOnly : true
			//allowBlank : false
		},{
			id : "updateCityId",
			xtype : "combo",
			fieldLabel : "地市<A style=COLOR:red>*</A>",
			store : cityStore,
			valueField : 'area_id',
			displayField : 'area_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183,
			allowBlank : false,
			listeners: { 
				      	  'select' : function(combo, record, index) { 
										var sql = "select deptid, parentid, title deptname from FPF_USER_COMPANY ";
										var groupSql = "select a.group_id, a.group_name from FPF_USER_GROUP a inner join FPF_USER_GROUP_MAP b on a.group_id=b.group_id inner join FPF_USER_USER c on c.userid=b.userid where 1=1 order by group_name asc ";
										var cityValue = this.getValue();
										if(cityValue!=""){
											sql = sql + " where deptid="+cityValue+" or parentid="+cityValue+" ";
											groupSql = groupSql + " and c.cityid='"+cityValue+"' "
										}
										sql = sql + " order by substr(char(deptid),1,2),parentid,deptid ";
										groupSql = groupSql + " group by a.group_id, a.group_name order by a.group_id "
										deptStore.baseParams['sql'] = strEncode(sql);
										deptStore.baseParams['ds'] = WEB_DS;
										deptStore.reload({
											params : {
												start : 0,
												limit : 999999
											}
										});
										userGroupStore.baseParams['sql'] = strEncode(groupSql);
										userGroupStore.baseParams['ds'] = WEB_DS;
										userGroupStore.reload({
											params : {
												start : 0,
												limit : 999999
											}
										});
				      	} 
				      }
		},{
			id : "updateDeptId",
			xtype : "combo",
			fieldLabel : "部门<A style=COLOR:red>*</A>",
			store : deptStore,
			valueField : 'deptid',
			displayField : 'deptname',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183,
			allowBlank : false
		},{
			id : "updateGroupId",
			xtype : "combo",
			fieldLabel : "用户组",
			store : userGroupStore,
			valueField : 'group_id',
			displayField : 'group_name',
			typeAhead : true,
			mode : 'remote',
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			lazyInit : false,
			width : 183
		},{
			id : "updatePhone",
			xtype : "textfield",
			fieldLabel : "用户手机",
			width : 200
		},{
			id : "updateEmail",
			xtype : "textfield",
			fieldLabel : "电子邮箱",
			width : 200
		},{
			id : "updateIP",
			xtype : "textfield",
			fieldLabel : "IP",
			width : 200
		},{
			id : "updateNotes",
			xtype : "textfield",
			fieldLabel : "备注",
			width : 200
		},{
			id : "updateIsJishi",
			xtype : "checkbox",
			fieldLabel : "是否集市用户",
			width : 200
		},{
			id : "updateIsHcras",
			xtype : "checkbox",
			fieldLabel : "是否有价值用户",
			width : 200
		} ]
	});
	
});// Ext.onReady结束

/**
 * 查询用户信息
 */
function queryUserInfo() {
	var userStore = Ext.getCmp('userGrid').getStore();
	var sql = "select userid,username,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=u.cityid) cityname, cityid,email,notes,address,jishi_user,hcras_user,(select title from FPF_USER_COMPANY where deptid=departmentid) departmentname, departmentid,mobilephone,(select max(g.group_name) from FPF_USER_GROUP g,FPF_USER_GROUP_MAP gm where gm.userid=u.userid and g.group_id=gm.group_id) user_group_name,(select max(c.group_id) from FPF_USER_GROUP_MAP c where c.userid=u.userid) FPF_USER_GROUP from FPF_USER_USER u where 1=1 ";
	
	if(cityId != 0){
		sql += " and cityid = '"+cityId+"'";
	}
	if($('#_userId').val()){
		if($('#_userId').val().indexOf('%')>0){
			alert("无效的用户ID");
			return;
		}
		sql += " and userid like '%"+$('#_userId').val().trim()+"%'";
	}
	if($('#_userName').val()){
		if($('#_userName').val().indexOf('%')>0){
			alert("无效的用户名称");
			return;
		}
		sql += " and username like '%"+$('#_userName').val().trim()+"%'";
	}
	if (cityComBox.getValue()) {
		sql += " and cityid = '" + cityComBox.getValue() + "' ";
	}
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
 * 删除用户
 */
function deleteUserInfo() {
	var userid = getSelectedColumnValue(Ext.getCmp('userGrid'),"userid");
	//判断必填项
	if (!userid) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择要删除的用户！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	Ext.Msg.confirm('信息', '确定要删除此用户吗？', function(btn) {
		if (btn == 'yes') {
			var mask = new Ext.LoadMask(Ext.getBody(), {
				msg : '正在删除数据，请稍后...',
				removeMask : true
			});
			mask.show();
			var sql = "delete from FPF_USER_USER where userid='"+userid+"'";
			sql += SEPERATOR + "delete from FPF_USER_GROUP_MAP where userid='"+userid+"'";
			sql += SEPERATOR + "delete from FPF_USER_ROLE_MAP where userid='"+userid+"'";
			sql += SEPERATOR + "delete from FPF_SYS_MENUITEM_USER where user_id='"+userid+"'";
			
			Ext.Ajax.request({
				url : '${mvcPath}/jsonData/query',
				success : function(obj) {
					var result = obj.responseText;
					if (result == "-1") {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '用户删除失败！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					} else {
						mask.hide();
						Ext.MessageBox.show({
							title : '信息',
							msg : '用户删除成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						queryUserInfo();
					}
				},
				failure : function() {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '用户删除失败！',
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
 * 关联角色
 */
function relateRole(userid){
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
			var sql = "select r.role_id,r.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.create_group) city_name,r.create_time from FPF_USER_ROLE_MAP m ,FPF_USER_ROLE r where m.userid='"+userid+"' and m.role_id=r.role_id and r.create_group is not null";
			if(roleName){
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
	//角色数据源
	var roleStroe = new Ext.data.Store({
		url : '${mvcPath}/jsonData/query',
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
	//角色列模型
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
	//角色表格
	var roleGrid = new Ext.grid.GridPanel({
		id : 'roleGrid',
		store : roleStroe,
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
		tbar : ["角色名称：",searchField],
		bbar : new Ext.PagingToolbar({
			pageSize : itemsPerPage,
			displayInfo : true,
			store : roleStroe,
			beforePageText : '第',
			afterPageText : '页，共 {0}页',
			displayMsg : '显示第 {0} 到 {1} 条记录，共 {2}条',
			emptyMsg : '无数据',
			width : '100%'
		})
	});
	var sql = "select r.role_id,r.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=r.create_group) city_name,r.create_time from FPF_USER_ROLE_MAP m ,FPF_USER_ROLE r where m.userid='"+userid+"' and m.role_id=r.role_id and r.create_group is not null order by r.create_group";
	roleStroe.baseParams['ds'] = WEB_DS;
	roleStroe.baseParams['sql'] = strEncode(sql);
	roleStroe.reload({
		params : {
			start : 0,
			limit : itemsPerPage
		}
	});
	
	var  roleWin = Ext.getCmp(" roleWin");
	if ( roleWin == null) {
			 roleWin = new Ext.Window({
				id : ' roleWin',
				//el : ' roleWin',
				title : '用户关联的角色',
				layout : 'fit',
				buttonAlign : 'right', 
				modal : true,
				width : 700,
				autoHeight : true,
				closeAction : 'hide',
				items : [ roleGrid.show() ],
				buttons : [ {
					text : '添加角色',
					handler : function() {
						showRoleWin(getSelectedColumnValue(Ext.getCmp('userGrid'),"userid"));
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
								msg : '请先选择要删除的角色！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
						}
						Ext.Msg.confirm("信息","确定要删除所选择的角色吗？",function(btn){
							if(btn=='yes'){
								delRoleFromUser(getSelectedColumnValue(Ext.getCmp('userGrid'),"userid"),roleIds);
							}
						});
					}
				},{
					text : '关闭',
					handler : function() {
						 roleWin.hide();
					}
				} ]
			});
			 roleWin.show();
	}else{
		 roleWin.remove("roleGrid");
		 roleWin.add(roleGrid.show());
		 roleWin.doLayout();
		 roleWin.show();
	}
}

/**
 * 打开选择角色的窗口
 */
function showRoleWin(userid) {
	var userid = getSelectedColumnValue(Ext.getCmp('userGrid'),"userid");
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
			var sql = "select a.role_id,a.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) city_name,a.create_time from FPF_USER_ROLE a where a.role_id not in (select b.role_id from FPF_USER_ROLE_MAP b where b.userid='"+userid+"') and a.create_group is not null";
			if(cityId != 0){
				sql += " and a.create_group = '"+cityId+"'";
			}
			if(roleName){
				sql += " and a.role_name like '%"+roleName+"%'";
			}
			sql += " order by a.create_group";
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
		url : '${mvcPath}/jsonData/query',
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
	var roleGridPanel = new Ext.grid.GridPanel({
		id : 'roleGridPanel',
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
	var sql = "select a.role_id,a.role_name,(select t.area_name from (select t1.area_id,t1.area_name from mk.bt_area t1 union all select 1 area_id,'湖北' area_name from sysibm.sysdummy1 union all select 0 area_id,'湖北' area_name from sysibm.sysdummy1) t where char(t.area_id)=a.create_group) city_name,a.create_time from FPF_USER_ROLE a where a.role_id not in (select b.role_id from FPF_USER_ROLE_MAP b where b.userid='"+userid+"') and a.create_group is not null";
	if(cityId != 0){
		sql += " and a.create_group = '"+cityId+"'";
	}
	sql +=" order by a.create_group";
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
			width : 650,
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
					if (!roleIds) {
						Ext.MessageBox.show({
							title : '信息',
							msg : '请先选择要添加的角色！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						return;
					}
					Ext.Msg.confirm('信息', '确定要为此用户关联所选的角色吗？', function(btn) {
						if (btn == 'yes') {
							addRoleToUser(getSelectedColumnValue(Ext.getCmp('userGrid'),"userid"),roleIds);
							Ext.getCmp('roleWin').hide();
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
 * 给用户关联角色 
 */
function addRoleToUser(userid,roleIds) {
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍后...',
		removeMask : true
	});
	mask.show();
	var roles = roleIds.split(",");
	for(var i=0;i<roles.length;i++){
		var sql = "insert into FPF_USER_ROLE_MAP (userid, role_id) values(";
		sql += "'"+userid+"'";
		sql += ",'"+roles[i]+"'";
		sql += ")";
		Ext.Ajax.request({
			url : '${mvcPath}/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '给用户关联角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//添加角色成功以后刷新窗口
					relateRole(userid);
					Ext.MessageBox.show({
						title : '信息',
						msg : '给用户关联角色成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '给用户关联角色失败！',
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
 * 删除用户对应的角色 
 */
function delRoleFromUser(userid,roleIds) {
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在删除数据，请稍后...',
		removeMask : true
	});
	mask.show();
	var roles = roleIds.split(",");
	for(var i=0;i<roles.length;i++){
		var sql = "delete from FPF_USER_ROLE_MAP where userid='"+userid+"' and role_id='"+roles[i]+"'";
		Ext.Ajax.request({
			url : '${mvcPath}/jsonData/query',
			success : function(obj) {
				var result = obj.responseText;
				if (result == "-1") {
					mask.hide();
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户对应的角色失败！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				} else {
					mask.hide();
					//添加角色成功以后刷新窗口
					relateRole(userid);
					Ext.MessageBox.show({
						title : '信息',
						msg : '删除用户对应的角色成功！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			},
			failure : function() {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '删除用户对应的角色失败！',
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
 * 打开新增用户窗口
 */
function showAddUserWin() {
	var addUserInfoForm = Ext.getCmp('addUserInfoForm');
	if (Ext.getCmp('addUserWin') == null) {
		var addUserWin = new Ext.Window({
			id : 'addUserWin',
			el : 'addUserWinDiv',
			title : '新增用户',
			layout : 'fit',
			modal : true,
			width : 400,
			height : 400,
			//autoHeight : true,
			closeAction : 'hide',
			items : [ addUserInfoForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					saveUser();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('addUserWin').hide();
				}
			} ]
		});
		addUserWin.show();
	} else {
		Ext.getCmp('addUserWin').show();
	}
}

/**
 * 保存新增用户
 */
function saveUser(){
	var addUserId = $("#addUserId").val();
	var addUserName = $("#addUserName").val();
	var addPwd = $("#addPwd").val();
	var addCityId = Ext.getCmp('addCityId').getValue();
	var addDeptId = Ext.getCmp('addDeptId').getValue();
	var addPhone = $("#addPhone").val();
	var addEmail = $("#addEmail").val();
	var addIsJishi = Ext.getCmp('addIsJishi').getValue();
	if(addIsJishi == true){
		addIsJishi = 1;
	}else{
		addIsJishi = 0;
	}
	var addIsHcras = Ext.getCmp('addIsHcras').getValue();
	if(addIsHcras == true){
		addIsHcras = 1;
	}else{
		addIsHcras = 0;
	}
	var addNotes = $("#addNotes").val();
	var addIP = $("#addIP").val();
	
	//判断必填项
	if (!addUserId) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户ID！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (!addUserName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (!addPwd) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入密码！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (addCityId == "" && addCityId !="0") {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择地市！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (addDeptId == "") {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择部门！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在添加数据，请稍后...',
		removeMask : true
	});
	mask.show();
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	var userId = $('#userId').val();
	var userCityId = $('#cityId').val();
	var sql = "insert into FPF_USER_USER (userid,username,pwd,cityid,departmentid,mobilephone,email,jishi_user,hcras_user,notes,address,createtime) values(";
	sql += "'"+addUserId+"'";
	sql += ",'"+addUserName+"'";
	sql += ",'61D86B8E64050AB0D8AF9B27947F5CC8'";//Jfqt2011
	sql += ",'"+addCityId+"'";
	sql += ","+addDeptId+"";
	sql += ",'"+addPhone+"'";
	sql += ",'"+addEmail+"'";
	sql += ","+addIsJishi+"";
	sql += ","+addIsHcras+"";
	sql += ",'"+addNotes+"'";
	sql += ",'"+addIP+"'";
	sql += ",'"+currentTime+"'";
	sql += ")";
	
	var addGroupId = Ext.getCmp('addGroupId').getValue();
	var sql2 = "insert into FPF_USER_GROUP_MAP(userid,group_id) values(";
	sql2 += "'"+addUserId+"'";
	sql2 += ",'"+addGroupId+"'";
	sql2 += ")";
	
	if(addGroupId){
		sql += SEPERATOR + sql2;
	}
	Ext.Ajax.request({
		url : '${mvcPath}/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增用户失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增用户成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addUserWin').hide();
				queryUserInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '新增用户失败！',
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
 * 显示修改用户信息窗口
 */
function showUserPanelForUpdate() {
	var userid = getSelectedColumnValue(Ext.getCmp('userGrid'),"userid");
	var username = getSelectedColumnValue(Ext.getCmp('userGrid'),"username");
	var cityid = getSelectedColumnValue(Ext.getCmp('userGrid'),"cityid");
	var departmentid = getSelectedColumnValue(Ext.getCmp('userGrid'),"departmentid");
	var FPF_USER_GROUP = getSelectedColumnValue(Ext.getCmp('userGrid'),"FPF_USER_GROUP");
	var mobilephone = getSelectedColumnValue(Ext.getCmp('userGrid'),"mobilephone");
	var email = getSelectedColumnValue(Ext.getCmp('userGrid'),"email");
	var notes = getSelectedColumnValue(Ext.getCmp('userGrid'),"notes");
	var address = getSelectedColumnValue(Ext.getCmp('userGrid'),"address");
	var jishiUser = getSelectedColumnValue(Ext.getCmp('userGrid'),"jishi_user");
	var hcrasUser = getSelectedColumnValue(Ext.getCmp('userGrid'),"hcras_user");
	
	$('#updateUserId').val(userid);
	$('#updateUserName').val(username);
	Ext.getCmp('updateCityId').setValue(cityid);
	Ext.getCmp('updateDeptId').setValue(departmentid);
	Ext.getCmp('updateGroupId').setValue(FPF_USER_GROUP);
	$('#updatePhone').val(mobilephone);
	$('#updateEmail').val(email);
	$('#updateNotes').val(notes);
	$('#updateIP').val(address);
	if(jishiUser=="1"){
		Ext.getCmp("updateIsJishi").setValue(true);
	}else if(jishiUser=="0"){
		Ext.getCmp("updateIsJishi").setValue(false);
	}else{
		Ext.getCmp("updateIsJishi").setValue(false);
	}
	if(hcrasUser=="1"){
		Ext.getCmp("updateIsHcras").setValue(true);
	}else if(hcrasUser=="0"){
		Ext.getCmp("updateIsHcras").setValue(false);
	}else{
		Ext.getCmp("updateIsHcras").setValue(false);
	}
	
	//修改用户信息表单
	var modifyUserForm = Ext.getCmp('modifyUserForm');
	if (Ext.getCmp('modifyUserWin') == null) {
		var modifyUserWin = new Ext.Window({
			id : 'modifyUserWin',
			el : 'modifyUserWinDiv',
			title : '修改用户',
			layout : 'fit',
			modal : true,
			width : 400,
			//autoHeight : true,
			height : 400,
			closeAction : 'hide',
			items : [ modifyUserForm.show() ],
			buttons : [ {
				text : '确定',
				handler : function() {
					modifyUserInfo();
				}
			},{
				text : '关闭',
				handler : function() {
					Ext.getCmp('modifyUserWin').hide();
				}
			} ]
		});
		modifyUserWin.show();
	} else {
		Ext.getCmp('modifyUserWin').show();
	}

}
/**
 * 修改用户信息
 */
function modifyUserInfo() {
	var userGroup = getSelectedColumnValue(Ext.getCmp('userGrid'),"FPF_USER_GROUP");
	var updateUserId = $("#updateUserId").val();
	var updateUserName = $("#updateUserName").val();
	var updatePwd = $("#updatePwd").val();
	var updateCityId = Ext.getCmp('updateCityId').getValue();
	var updateDeptId = Ext.getCmp('updateDeptId').getValue();
	var updatePhone = $("#updatePhone").val();
	var updateEmail = $("#updateEmail").val();
	var updateIsJishi = Ext.getCmp('updateIsJishi').getValue();
	if(updateIsJishi == true){
		updateIsJishi = 1;
	}else{
		updateIsJishi = 0;
	}
	var updateIsHcras = Ext.getCmp('updateIsHcras').getValue();
	if(updateIsHcras == true){
		updateIsHcras = 1;
	}else{
		updateIsHcras = 0;
	}
	var updateNotes = $("#updateNotes").val();
	var updateIP = $("#updateIP").val();
	
	var updateGroupId = "";
	var updateGroupName = document.getElementById("updateGroupId").value;
	
	if(updateGroupName != '请选择'){
		updateGroupId = Ext.getCmp('updateGroupId').getValue();
	}
	
	//校验必填项
	if (!updateUserId) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户ID！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (!updateUserName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入用户名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (updateCityId == "" && updateCityId !="0") {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择地市！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	if (updateDeptId == "") {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请选择部门！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
		});
		return;
	}
	
	var currentTimeStr = getCurrentTimeStr();
	var currentTime = getCurrentTime(currentTimeStr);
	var userId = $('#userId').val();
	var userCityId = $('#cityId').val();
	
	var sql = "update FPF_USER_USER ";
	sql += " set username='"+updateUserName+"'";
	sql += ",cityid='"+updateCityId+"'";
	sql += ",departmentid="+updateDeptId+"";
	sql += ",mobilephone='"+updatePhone+"'";
	sql += ",email='"+updateEmail+"'";
	sql += ",jishi_user="+updateIsJishi+"";
	sql += ",hcras_user="+updateIsHcras+"";
	sql += ",notes='"+updateNotes+"'";
	sql += ",address='"+updateIP+"'";
	sql += ",createtime='"+currentTime+"'";
	sql += " where userid='"+updateUserId+"'";
	
	if(updateGroupId != "" && userGroup  != ''){
		var sql2 = "update FPF_USER_GROUP_MAP ";
		sql2 += " set group_id='"+updateGroupId+"'";
		sql2 += " where userid='"+updateUserId+"'";
		sql += SEPERATOR + sql2;
	}else if (updateGroupId != "" && userGroup  == ''){
		var sql5 = "insert into FPF_USER_GROUP_MAP(userid,group_id) values(";
		sql5 += "'"+updateUserId+"'";
		sql5 += ",'"+updateGroupId+"'";
		sql5 += ")";
		sql += SEPERATOR + sql5;
	}else{
		var sql3 = "delete from FPF_USER_GROUP_MAP a where a.userid='"+updateUserId+"'";
		sql += SEPERATOR + sql3;
	}
	var mask = new Ext.LoadMask(Ext.getBody(), {
		msg : '正在更新数据，请稍后...',
		removeMask : true
	});
	mask.show();
	Ext.Ajax.request({
		url : '${mvcPath}/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户信息修改失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '用户信息修改成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('modifyUserWin').hide();
				queryUserInfo();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '用户信息修改失败！',
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
</script>
