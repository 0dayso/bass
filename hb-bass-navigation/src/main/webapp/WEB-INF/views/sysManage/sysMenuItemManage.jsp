<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>湖北移动经营分析系统</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" 
			src="${mvcPath}/resources/js/default/des.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/ext/ext-exe.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
		<%@include file="../include.jsp"%>
		<style>
.tabs {
	background-image: url( ${mvcPath}/resources/image/default/tabs.gif )
		!important;
}

.x-panel-header {
	background-image: url(img/banner.png) ! important;
	background-repeat: repeat-x ! important;
	background-attachment: scroll ! important;
	background-position: right ! important;
}

.bannerTitle {
	position: relative;
	height: 15px;
	color: dark;
}

.bannerTitle a {
	color: dark
}

.x-border-layout-ct {
	background: #ffffff ! important;
}
</style>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = '${mvcPath}/resources/js/ext/resources/images/default/s.gif';
	var menuItemTree = undefined;
	Ext.onReady(function() {
		
		Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
		
		menuItemTree = new Ext.tree.TreePanel({
			el : 'menuItemDiv',
			border : false,
			loader : new Ext.tree.TreeLoader({
				dataUrl : '/mvc/sysManage/menuNodes',
				listeners : {
					load : function(t, node) {
						node.eachChild(function(_node) {
							_node.getUI().getIconEl().src = "${mvcPath}/resources/image/default/tabs.gif";
						});
					}
				}
			}),
			root : new Ext.tree.AsyncTreeNode({
				text : '湖北移动经分系统菜单',
				draggable : false,
				iconCls : 'tabs',
				expanded : true,
				id : '0'
			}),
			listeners : {
				click : function(node, event) {
					var accesstoken = node.attributes.accesstoken;
					if(accesstoken == 0){
						Ext.MessageBox.show({
							title : '信息',
							msg : '此菜单为共享菜单 ，如果需要授权请对其父级菜单进行授权！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
						document.getElementById("menuRight").src="";
					}else if(accesstoken == 1){
						document.getElementById("menuRight").src="sysMenuItemDetail.jsp?id="+node.id;
					}
				}
			}
		});
		menuItemTree.render();
		
		var viewport = new Ext.Viewport({
			layout : 'border',
			items : [ {
				region : 'west',
				//el:'west',
				title : '<div class="bannerTitle"><div style="position:absolute; bottom:-2;"><img src="${mvcPath}/resources/image/tabs/icon_home.gif" />菜单  <a href="javascript:void(0)" onclick="addMenu()"><img src="${mvcPath}/resources/image/default/add.gif" />新增</a>  <a href="javascript:void(0)" onclick="delMenu()"><img src="${mvcPath}/resources/image/default/del.gif" />删除</a> </div></div>',
				split : true,
				width : 400,
				minSize : 400,
				maxSize : 600,
				collapsible : true,
				collapseMode : 'mini',
				autoScroll : true,
				margins : '1 0 0 3',
				layoutConfig : {
					animate : true
				},
				items : [ menuItemTree ]
			}, {
				region : 'center',
				split : true,
				border : false,
				//title:'菜单所关联的角色和用户',
				margins : '1 1 0 0',
				items : [ new Ext.BoxComponent({
					region : 'center',
					el : 'menuRightDiv'
				}) ]
			} ]
		});
	});
	function refreshTree() {
		menuItemTree.root.reload();
	}
</script>
	</head>
	<body>
		<div id="menuItemDiv"></div>
		<div id="menuRightDiv">
			<IFRAME id="menuRight" name="menuRight" border=0 frameBorder=0
				width="100%" scrolling="auto" height="100%"
				src="sysMenuItemDetail.jsp"></IFRAME>
		</div>
		<div id="addMenuDiv"></div>
	</body>
</html>
<script type="text/javascript">
/**
 * 新增菜单
 */
function addMenu() {
	var node = menuItemTree.getSelectionModel().getSelectedNode();
	if (node != null) {
		var addMenuForm = new Ext.form.FormPanel({
			id : 'addMenuForm',
			width : 250,
			frame : true,// 圆角和浅蓝色背景
			hidden : true,
			//title : "",
			items : [{
				id : "addMenuParentName",
				xtype : "textfield",
				fieldLabel : "父级菜单名称",
				width : 200,
				readOnly : true
				//emptyText : node.text
			},{
				id : "addMenuName",
				xtype : "textfield",
				fieldLabel : "菜单名称<A style=COLOR:red>*</A>",
				allowBlank : false,
				width : 200
			},{
				id : "addMenuUrl",
				xtype : "textfield",
				fieldLabel : "菜单URL",
				width : 200
			},{
				id : "addMenuShare",
				xtype : "checkbox",
				fieldLabel : "是否共享",
				width : 15
			}]
		});
		var menuForm = Ext.getCmp('addMenuForm');
		Ext.getCmp('addMenuParentName').setValue(node.text);
		if (Ext.getCmp('addMenuWin') == null) {
			var addMenuWin = new Ext.Window({
				id : 'addMenuWin',
				el : 'addMenuDiv',
				title : '新增菜单',
				layout : 'fit',
				modal : true,
				width : 400,
				//height : 70,
				autoHeight : true,
				closeAction : 'hide',
				items : [ menuForm.show() ],
				buttons : [ {
					text : '确定',
					handler : function() {
						saveMenu(node);
					}
				},{
					text : '关闭',
					handler : function() {
						Ext.getCmp('addMenuWin').hide();
					}
				} ]
			});
			addMenuWin.show();
		} else {
			document.getElementById('addMenuParentName').value=node.text;
			Ext.getCmp('addMenuWin').show();
		}
	} else {
		//Ext.Msg.alert("信息","请选择一个菜单！");
		Ext.MessageBox.show({
			title : "信息",
			msg : "请先为要新增的菜单选择一个父级菜单！",
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
	}
}

/**
 * 保存新增菜单
 */
function saveMenu(node){
	var addMenuName = $("#addMenuName").val();
	var addMenuUrl = $("#addMenuUrl").val();

	var addMenuShare = Ext.getCmp('addMenuShare').getValue();
	if(addMenuShare == true){
		addMenuShare = 0;//选中为共享，值为0
	}else{
		addMenuShare = 1;
	}
	
	//判断必填项
	if (!addMenuName) {
		Ext.MessageBox.show({
			title : '信息',
			msg : '请输入菜单名称！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
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
	var userCityId = $('#cityId').val();
	var sql = "insert into FPF_SYS_MENU_ITEM (menuitemid,parentid,menuitemtitle,sortnum,accesstoken,url,menutype,restype) values(";
	sql += "(select max(menuitemid)+1 from FPF_SYS_MENU_ITEM)";
	sql += ","+node.id+"";
	sql += ",'"+addMenuName+"'";
	sql += ","+0+"";
	sql += ","+addMenuShare+"";
	sql += ",'"+addMenuUrl+"'";
	sql += ","+1+"";//菜单类型：1 URL菜单
	sql += ","+1+"";
	sql += ")";
	
	Ext.Ajax.request({
		url : '/mvc/jsonData/query',
		success : function(obj) {
			var result = obj.responseText;
			if (result == "-1") {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增菜单失败！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			} else {
				mask.hide();
				Ext.MessageBox.show({
					title : '信息',
					msg : '新增菜单成功！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
				Ext.getCmp('addMenuWin').hide();
				refreshTree();
			}
		},
		failure : function() {
			mask.hide();
			Ext.MessageBox.show({
				title : '信息',
				msg : '新增菜单失败！',
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
 * 删除菜单
 */
function delMenu(){
	var node = menuItemTree.getSelectionModel().getSelectedNode();
	if(node != null){
		if(node.expanded == false){
			Ext.MessageBox.show({
				title : '信息',
				msg : '请先展开选中要删除的菜单！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.WARNING
			});
			return;
		}else if(node.expanded == true && node != null && node.childNodes != null && node.childNodes.length > 0){
			Ext.MessageBox.show({
				title : '信息',
				msg : '请先删除选中菜单的子菜单！',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.WARNING
			});
			return;
		}
		if (node != null && node.id != null) {
			Ext.Msg.confirm('信息', '确定要删除此菜单吗？', function(btn) {
				if (btn == 'yes') {
					var mask = new Ext.LoadMask(Ext.getBody(), {
						msg : '正在删除数据，请稍候...',
						removeMask : true
					});
					mask.show();
	
					var sql = "delete from FPF_SYS_MENU_ITEM where menuitemid="+node.id;
					sql += SEPERATOR+"delete from FPF_SYS_MENUITEM_RIGHT where resourceid='"+node.id+"'";
					sql +=SEPERATOR+"delete from FPF_SYS_MENUITEM_USER where menu_id="+node.id;
	
					Ext.Ajax.request({
						url : '/mvc/jsonData/query',
						success : function(obj) {
							var result = obj.responseText;
							if (result == "-1") {
								mask.hide();
								Ext.MessageBox.show({
									title : '信息',
									msg : '删除菜单失败！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
							} else {
								mask.hide();
								Ext.MessageBox.show({
									title : '信息',
									msg : '删除菜单成功！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
								refreshTree();
								document.getElementById("menuRight").src="sysMenuItemDetail.jsp";
							}
						},
						failure : function() {
							mask.hide();
							Ext.MessageBox.show({
								title : '信息',
								msg : '删除菜单失败！',
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
			});
		}
	}else{
		Ext.MessageBox.show({
			title : '信息',
			msg : '请先选择一个要删除的菜单！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.WARNING
		});
		return;
	}
}
</script>