<!DOCTYPE html>
<HTML>
<HEAD>
<#include "../top.ftl">
<link rel="stylesheet" href="${mvcPath}/hb-power/common/jquery/jqpagination.css" type="text/css">
<script type="text/javascript" src="${mvcPath}/hb-power/common/jquery/jquery.jqpagination.min.js"></script>
<style type="text/css">
.boxBorder{
	border-style: solid;
	border-color:#F3F1F1;
	border-width:1px;
}

.menuTitle{
	border-bottom: 1px solid #F3F1F1;
	padding: 5px;
}

.menuTitle button{
    padding: 3px 7px;
}

.menuListBox{
	width:25%;
	margin : 10px 0 10px 10px;
}

.fl{
	float: left;
}

.tbMar{
	margin: 0 5px;
	width:98%;
}

.mb0{
	margin-bottom: 0px;
}

.qryTitle{
	line-height:34px;
	float:left;
	margin-left:8px;
}

.titWid{
	width:30%;
}

.conWid{
	width:50%;
}

</style>
<script type="text/javascript">
var menus = ${menuList};
var powerMap = ${power};
var zTreeMenuManage=null;
//标记分页控件是否已被初始化过
var initBrPage = false;
var initBuPage = false;
var initUrPage = false;
var initUuPgge = false;
$(function(){
	createMenuTree();
	
	//除第一个table可实现全选外，其他全选都需要单独绑定
	/*绑定用户全选*/
	$("#buTable thead th input:checkbox").on("click" , function(){
		$("#buTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#buTable thead th input:checkbox").prop("checked"));
    });
    
    /*未绑定角色全选*/
	$("#urTable thead th input:checkbox").on("click" , function(){
		$("#urTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#urTable thead th input:checkbox").prop("checked"));
    });
    
    /*未绑定用户全选*/
	$("#uuTable thead th input:checkbox").on("click" , function(){
		$("#uuTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#uuTable thead th input:checkbox").prop("checked"));
    });
});

//生成左侧菜单树
function createMenuTree(){
	var menuList = eval(menus);
	var treeNodes = [];
	var menuItemTitle;
	var menuItemId;
	var parentId;
	for(var i=0; i < menuList.length; i++){
		menuItemId = menuList[i].menuitemid;
		menuItemTitle = menuList[i].menuitemtitle;
		parentId = menuList[i].parentid;
		treeNodes.push({id:menuItemId, pId:parentId, name:menuItemTitle,t:menuItemTitle});
	}
	
	var setting = {
		view: {
			selectedMulti: false //设置不允许同时选中多个节点
		},
		edit: {
			enable: false,//设置为编辑状态
			showRemoveBtn: false,
			showRenameBtn: false
		},
		data: {
		 	key: {
		 		title:"t"
		    },
			simpleData: {
				enable: true
			}
		},
		callback: {
			onClick: onClickMenu
		}
	}
	
	$.fn.zTree.init($("#menuTree"), setting, treeNodes);
	zTreeMenuManage = $.fn.zTree.getZTreeObj("menuTree");
	
}

//菜单树点击事件
function onClickMenu(event, treeId, treeNode, clickFlag){
	$('#bindRoleName').val("");
	queryBindRoleCount();
	$('#bindUserName').val("");
	queryBindUserCount();
}

//查询已绑定角色数量
function queryBindRoleCount(){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	var roleName = $('#bindRoleName').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryBindRoleCount"
		,data: {
			menuId: nodes[0].id,
			roleName: roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var pageCount = data.pageCount;
			var roleCount = data.totalCount;
			$('#bindRoleCount').html(roleCount);
			$('#bindRolePageCount').html(pageCount);
			$('#brSelectAll').attr("checked", false);
			if(initBrPage){
				$('#bindRolePagination').jqPagination('destroy');
			}
			$("#bindRolePagination").closest("div").find("input").data('current-page', '1');
			$('#bindRolePagination').jqPagination({
				page_string:'{current_page}',
				max_page : pageCount,
			    paged: function(page) {
			    	$('#brSelectAll').attr("checked", false);
			    	getbindRoleTab(page, nodes[0].id,roleName);
			    }
			});
			initBrPage = true;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
	getbindRoleTab(1, nodes[0].id,roleName);
}

//已绑定菜单角色分页查询
function getbindRoleTab(pageNow, menuId, roleName){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryBindRole"
		,data: {
			menuId: menuId,
			currentPage: pageNow,
			roleName: roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var roleStr = "";
			for(var i=0; i<data.length; i++){
				var iroleid = data[i].roleid;
				roleStr += "<tr class='text-c'>";
				roleStr += "<td><input type='checkbox' id='bRolecheck_" + data[i].roleid + "' name='bRolecheck' value='" + data[i].roleid + "'></td>";
				roleStr += "<td>" + data[i].rolename+ "</td>";
				roleStr += "<td>" + data[i].areaname+ "</td>";
				roleStr += "<td><button title='权限配置' class='btn btn-info btn-sm size-S radius' data-toggle='modal' data-backdrop='static' data-target='#addPowerToRole' onclick='getRolePower(\""+menuId+"\",\""+iroleid+"\")'><span class='glyphicon glyphicon-wrench' aria-hidden='true'></span></button></td>";
				roleStr += "</tr>";
			}
			$('#bindRoleTab').html(roleStr);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

//提交角色绑定
function bindRole(){
	var checkedRoles = $("input[name='uRolecheck']:checked").length;
	if(checkedRoles == 0){
		$.alert("请至少选择一个角色");
		return;
	}
	var roles = new Array();
	$("input[name='uRolecheck']:checked").each(function(){
		roles.push($(this).val());
	});
	
	var nodes = zTreeMenuManage.getSelectedNodes();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/bindRole"
		,data: {
			menuId: nodes[0].id,
			roles: roles.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("角色绑定成功");
			queryBindRoleCount();
			$('#addRole').modal('hide');
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("关联角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

function removeRole(){
	var checkedRoles = $("input[name='bRolecheck']:checked").length;
	if(checkedRoles == 0){
		$.alert("请至少选择一个角色");
		return;
	}
	$.confirm("确定删除所选角色吗？",function(index){
		var roles = new Array();
		$("input[name='bRolecheck']:checked").each(function(){
			roles.push($(this).val());
		});
		
		var nodes = zTreeMenuManage.getSelectedNodes();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/unBindRole"
			,data: {
				menuId: nodes[0].id,
				roles: roles.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("角色删除成功");
				queryBindRoleCount();
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("删除关联角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
	});
	
}
//新增菜单角色 查询未绑定角色数量
function queryUnbRole(type){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	
	var roleName = "";
	if(type == '2'){
		roleName = $('#ubRoleName').val();
	}
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryUnbRoleCount"
		,data: {
			menuId: nodes[0].id,
			roleName: roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			if(type == '1'){
				$('#ubRoleName').val("");
				$('#addRole').modal('show');
			}
			var pageCount = data.pageCount;
			var roleCount = data.totalCount;
			$('#unbRoleCount').html(roleCount);
			$('#unbRolePageCount').html(pageCount);
			$('#urSelectAll').attr("checked", false);
			
			if(initUrPage){
				$('#unbRolePagination').jqPagination('destroy');
			}
			$("#unbRolePagination").closest("div").find("input").data('current-page', '1');
			$('#unbRolePagination').jqPagination({
				page_string:'{current_page}',
				max_page : pageCount,
			    paged: function(page) {
			    	$('#urSelectAll').attr("checked", false);
			    	getUnbRoleTab(page, nodes[0].id, roleName);
			    }
			});
			initUrPage = true;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
	getUnbRoleTab(1, nodes[0].id, roleName);
}

//未绑定菜单角色分页查询
function getUnbRoleTab(pageNow, menuId, roleName){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryUnbRole"
		,data: {
			menuId: menuId,
			currentPage: pageNow,
			roleName: roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var roleStr = "";
			for(var i=0; i<data.length; i++){
				roleStr += "<tr class='text-c'>";
				roleStr += "<td><input type='checkbox' id='uRolecheck_" + data[i].roleid + "' name='uRolecheck' value='" + data[i].roleid + "'></td>";
				roleStr += "<td>" + data[i].rolename+ "</td>";
				roleStr += "<td>" + data[i].areaname+ "</td>";
				roleStr += "<td>" + data[i].createtime+ "</td>";
				roleStr += "</tr>";
			}
			$('#unbRoleTab').html(roleStr);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

//查询已绑定用户数量
function queryBindUserCount(){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	var userName = $('#bindUserName').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryBindUserCount"
		,data: {
			menuId: nodes[0].id,
			userName: userName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var pageCount = data.pageCount;
			var userCount = data.totalCount;
			$('#bindUserCount').html(userCount);
			$('#bindUserPageCount').html(pageCount);
			$('#buSelectAll').attr("checked", false);
			
			if(initBuPage){
				$('#bindUserPagination').jqPagination('destroy');
			}
			$("#bindUserPagination").closest("div").find("input").data('current-page', '1');
			$('#bindUserPagination').jqPagination({
				page_string:'{current_page}',
				max_page : pageCount,
			    paged: function(page) {
			    	$('#buSelectAll').attr("checked", false);
			    	getbindUserTab(page, nodes[0].id, userName);
			    }
			});
			initBuPage = true;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载用户败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
	getbindUserTab(1, nodes[0].id,userName);
}

//已绑定菜单用户分页查询
function getbindUserTab(pageNow, menuId, userName){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryBindUser"
		,data: {
			menuId: menuId,
			currentPage: pageNow,
			userName: userName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var userStr = "";
			for(var i=0; i<data.length; i++){
				userStr += "<tr class='text-c'>";
				userStr += "<td><input type='checkbox' id='bUsercheck_" + data[i].userid + "' name='bUsercheck' value='" + data[i].userid + "'></td>";
				userStr += "<td>" + data[i].userid+ "</td>";
				userStr += "<td>" + data[i].username+ "</td>";
				userStr += "<td>" + data[i].areaname+ "</td>";
				userStr += "</tr>";
			}
			$('#bindUserTab').html(userStr);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

//提交用户绑定
function bindUser(){
	var checkedUsers = $("input[name='uUsercheck']:checked").length;
	if(checkedUsers == 0){
		$.alert("请至少选择一个用户");
		return;
	}
	var users = new Array();
	$("input[name='uUsercheck']:checked").each(function(){
		users.push($(this).val());
	});
	
	var nodes = zTreeMenuManage.getSelectedNodes();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/bindUser"
		,data: {
			menuId: nodes[0].id,
			users: users.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("用户绑定成功");
			queryBindUserCount();
			$('#addUser').modal('hide');
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("关联用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

function removeUser(){
	var checkedUsers = $("input[name='bUsercheck']:checked").length;
	if(checkedUsers == 0){
		$.alert("请至少选择一个用户");
		return;
	}
	$.confirm("确定删除所选用户吗？",function(index){
		var users = new Array();
		$("input[name='bUsercheck']:checked").each(function(){
			users.push($(this).val());
		});
		
		var nodes = zTreeMenuManage.getSelectedNodes();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/unBindUser"
			,data: {
				menuId: nodes[0].id,
				users: users.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("用户删除成功");
				queryBindUserCount();
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("删除关联用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
	});
	
}
//新增菜单用户 查询未绑定角色数量
function queryUnbUser(type){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	
	var userName = "";
	if(type == '2'){
		userName = $('#ubUserName').val();
	}
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryUnbUserCount"
		,data: {
			menuId: nodes[0].id,
			userName: userName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			if(type == '1'){
				$('#ubUserName').val("");
				$('#addUser').modal('show');
			}
			var pageCount = data.pageCount;
			var userCount = data.totalCount;
			$('#unbUserCount').html(userCount);
			$('#unbUserPageCount').html(pageCount);
			$('#uuSelectAll').attr("checked", false);
			if(initUuPgge){
				$('#unbUserPagination').jqPagination("destroy");
			}
			$("#unbUserPagination").closest("div").find("input").data('current-page', '1');
			$('#unbUserPagination').jqPagination({
				page_string:'{current_page}',
				max_page : pageCount,
			    paged: function(page) {
			    	$('#uuSelectAll').attr("checked", false);
			    	getUnbUserTab(page, nodes[0].id, userName);
			    }
			});
			initUuPgge = true;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
	getUnbUserTab(1, nodes[0].id, userName);
}

//未绑定菜单用户分页查询
function getUnbUserTab(pageNow, menuId, userName){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/queryUnbUser"
		,data: {
			menuId: menuId,
			currentPage: pageNow,
			userName: userName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			data = eval(data);
			var userStr = "";
			for(var i=0; i<data.length; i++){
				userStr += "<tr class='text-c'>";
				userStr += "<td><input type='checkbox' id='uUsercheck_" + data[i].userid + "' name='uUsercheck' value='" + data[i].userid + "'></td>";
				userStr += "<td>" + data[i].userid+ "</td>";
				userStr += "<td>" + data[i].username+ "</td>";
				userStr += "<td>" + data[i].areaname+ "</td>";
				userStr += "<td>" + data[i].createtime+ "</td>";
				userStr += "</tr>";
			}
			$('#unbUserTab').html(userStr);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

//获取菜单ID
function getNextMenuId(){
	$("#myMenuManaLabel").html("添加菜单");
	clearInp();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuRightMana/getNextMenuId"
		,data: {}
		,async: false
		,dataType : "json"
		,success: function(data){
			$('#menuId').val(data);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("获取菜单编号失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 		}
	});
}

//验证输入信息
function validate(){
	var menuId = $('#menuId').val();
	if(!menuId){
		$.msg("菜单编号不能为空！", {
			icon : 0,
			time : 5000
		});
		return false;
	}
	
	var menuItemtitle = $('#menuItemTitle').val();
	if(!menuItemtitle){
		$.msg("请填写菜单名称！", {
			icon : 0,
			time : 5000
		});
		$("#menuItemTitle").focus();
		return false;
	}
	
	var parentId = $('#parentId').val();
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length != 0) {
		var menuId = nodes[0].id;
		if(parentId == menuId){
			$.msg("请不要选择当前菜单作为父级菜单！", {
			icon : 0,
			time : 5000
		});
		$("#parentId").focus();
		return false;
		}
	}
	
	var url = $('#url').val();
	
	/*if(!url){
		$.msg("请填写菜单URL！", {
			icon : 0,
			time : 5000
		});
		$("#url").focus();
		return false;
	}*/
	
}

function saveMenu(){
	$("#menuForm").submit();
}

function delMenu(){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	
	if(nodes[0].isParent){
		$.alert("请先删除子菜单");
		return;
	}
	$.confirm("确定要删除选中菜单吗？",function(index){
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/delMenu"
			,data: {menuId: nodes[0].id}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("菜单删除成功");
				window.location.reload();
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("删除菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
	});
}

function editMenu(){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	clearInp();
	$("#myMenuManaLabel").html("修改菜单");
	$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/getMenuDetail"
			,data: {menuId: nodes[0].id}
			,async: false
			,dataType : "json"
			,success: function(data){
				$('#menuId').val(data.menuitemid);
				$('#menuItemTitle').val(data.menuitemtitle);
				$("#parentId option[value='" + data.parentid + "']").attr('selected','selected');
				$('#sortNum').val(data.sortnum);
				$('#iconUrl').val(data.iconurl);
				$('#url').val(data.url);
				$("#state option[value='" + data.state + "']").attr('selected','selected');
				$("#menuType option[value='" + data.menutype + "']").attr('selected','selected');
				
				if(data.poweradd=='Y'){
					$("#powerAdd").prop("checked",true);
				}
				
				if(data.powerdel=='Y'){
					$("#powerDel").prop("checked",true);
				}
				
				if(data.poweredit=='Y'){
					$("#powerEdi").prop("checked",true);
				}
				
				if(data.powerqry=='Y'){
					$("#powerSel").prop("checked",true);
				}
				
				var allpower = data.powers;
				detailAddPowerList(allpower);
				$('#addMenu').modal('show');
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("获取菜单信息失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
}

function clearInp(){
	$('#menuId').val("");
	$('#menuItemTitle').val("");
	$('#parentId option:first').attr('selected','selected');
	$('#sortNum').val("");
	$('#iconUrl').val("");
	$('#url').val("");
	$('#state option:first').attr('selected','selected');
	$('#menuType option:first').attr('selected','selected');
	$("#powerAdd").removeAttr("checked");
	$("#powerDel").removeAttr("checked");
	$("#powerEdi").removeAttr("checked");
	$("#powerSel").removeAttr("checked");
	$("#powerList").html("<li style='margin-top:10px;'><input type='hidden' name='munu_power_id' id='munu_power_id_1' value=''>名称-描述<input type='text' name='munu_power_name' valie='' id='munu_power_1'/></li>");
}

/**添加功能输入框**/
function addPowerList(){
	var i = $("#powerSort").val();
	i++;
	var id = 'munu_power_'+i;
	var iDid = 'munu_power_id_'+i;
	$("#powerList").append("<li style='margin-top:10px;'><input type='hidden' name='munu_power_id' id='"+iDid+"' value=''>名称-描述<input type='text' name='munu_power_name' valie='' id='"+id+"'/></li>");
	$("#powerSort").val(i);
	
}

function detailAddPowerList(allpower){
	if(allpower.length==0||allpower==null||allpower[0]==null) return;
	$("#munu_power_id_1").val(allpower[0].powerid);
	$("#munu_power_1").val(allpower[0].powername);
	var j = 1;
	for(var i=1;i<allpower.length;i++){
		j++;
		var id = 'munu_power_'+j;
		var iDid = 'munu_power_id_'+j;
		var pid = allpower[i].powerid;
		var pname = allpower[i].powername;
		$("#powerList").append("<li style='margin-top:10px;'><input type='hidden' name='munu_power_id' id='"+iDid+"' value='"+pid+"'>名称-描述<input type='text' name='munu_power_name' value='"+pname+"' id='"+id+"'/></li>");
	}
	$("#powerSort").val(j);
}

/**查询角色权限**/

function getRolePower(menuId,roleId){
	$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/getAllPowerAndCheck"
			,data: {menuId:menuId,roleId:roleId}
			,async: false
			,dataType : "json"
			,success: function(data){
				$("#addPowerModermenuId").val(menuId);
				$("#addPowerModerroleId").val(roleId);
				$('#powerCheckList').empty();
				data = eval(data);
				var userStr = "";
				for(var i=0; i<data.length; i++){
					var checked = '';
					if((data[i].checked!=null)&&data[i].checked.length!=0&&data[i].checked!=''){
						checked = 'checked'
					}
					userStr += "<label class='checkbox-inline' style=''> <input type='checkbox' "+checked+" id='rolePower"+i+"' name='role' value='"+data[i].powerid+"'>"+data[i].powername+" </label>";
					
				}
				$('#powerCheckList').html(userStr);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("查询权限失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
}


/**为菜单添加权限**/
function addPowerMethod(){
	var menuId = $("#addPowerModermenuId").val();
	var roleId =$("#addPowerModerroleId").val();
	var powerIds = getAllPowerIds('powerCheckList');
	addPower(menuId,roleId,powerIds);
}

function addPower(menuId,roleId,powerIds){
	$.ajax({
			type: "POST"
			,url: "${mvcPath}/menuRightMana/addPowerToRole"
			,data: {menuId:menuId,roleId:roleId,powerIds:powerIds}
			,async: false
			,dataType : "json"
			,success: function(data){
				if(data.flag==true){
					$.alert("配置权限成功");
				}else{
					$.alert("配置权限失败");
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
	          $.msg("配置权限失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	 		}
		});
}

function getAllPowerIds(id){
			var eid='';
			$("#"+id+" label :checked").each(function(){
				if(eid!=''){
					eid=eid+','+$(this).val();
				}else{
					eid=$(this).val();
				}
			});
			return eid;
}


</script>
</HEAD>
<BODY>
<div class="page-container">
	<div class='boxBorder menuListBox fl'>
		<div class="menuTitle">
			<label>菜单管理</label>
			<button title="新增" class="btn btn-info btn-sm size-S radius" data-toggle="modal" data-backdrop="static" id="_addMenu" onclick="getNextMenuId();" data-target="#addMenu" style="display:none;" power_code="menu_menu_add">
				<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
			</button>
			<button title="修改" class="btn btn-info btn-sm size-S radius" data-toggle="modal" data-backdrop="static" id="_editMenu" onclick="editMenu()"power_code="menu_menu_edit" style="display:none;">
				<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
			</button>
			<button title="删除" class="btn btn-info btn-sm size-S radius" data-toggle="modal" data-backdrop="static" id="_delMenu" onclick="delMenu()" power_code="menu_menu_del" style="display:none;">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
			</button>
		</div>
		<div style="width:100%; height:460px;overflow: auto;" id="menuTree" class="ztree"></div>
	</div>
	<div class='fl' style='width:72%' >
		<!--菜单角色开始-->
		<div id='menuRole' class='boxBorder' style='width:100%; margin: 10px 0 10px 10px;'>
			<div class="cl pd-5 bg-1 bk-gray" style="margin-top: 14px; margin-bottom: 14px;">
				<label class="qryTitle control-label">角色名称</label>
  				<div class="col-sm-4">
    				<input placeholder="" name="bindRoleName" id='bindRoleName' value=""  class="form-control" type="text">
 				 </div>
 				 <label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" id="queryRole" onclick="queryBindRoleCount()" type="button" power_code="menu_role_serach">
 					 <span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询
 					 </button>
				 </label>
				 <label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" data-toggle="modal" onclick="queryUnbRole(1)" type="button" power_code="menu_role_add" style="display:none;">
 					 <span class="glyphicon glyphicon-plus" style="color: rgb(0, 0, 0);"></span> 添加
 					</button>
				 </label>
				<label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" id="removeRole" type="button" onclick="removeRole();" power_code="menu_role_del" style="display:none;">
 					 <span class="glyphicon glyphicon-trash" style="color: rgb(0, 0, 0);"></span> 删除
 					 </button>
				</label>
			</div>
			<div>
				<table id='brTable' class="table table-border table-striped table-bordered table-hover table-bg table-sort tbMar">
					<thead>
						<tr class="text-c">
							<th width="8%"><input type="checkbox" id='brSelectAll'>
							</th>
							<th width="42%">角色名称</th>
							<th width="20%">所属地市</th>
							<th width="20%">权限配置</th>
						</tr>
					</thead>
					<tbody id='bindRoleTab'>
					</tbody>
				</table>
			</div>
			<div>
				<div id='bindRolePagination' class="gigantic jpagination">
				  <a href="#" class="first disabled" data-action="first"></a> 
				  <a href="#" class="previous disabled mar_r7" data-action="previous"></a>
				  <div class="textinput"><span class="pd_r7">第</span><input type="text" class="pagenum mar_r7" value='1'/><span class="pd_r14">页</span><span>共<span id='bindRolePageCount'>1</span>页</span></div>
				  <a href="#" class="next disabled" data-action="next"></a> 
				  <a href="#" class="last disabled" data-action="last"></a>
			  </div>
	          <div class="sertext">共 <span id='bindRoleCount'>0</span> 条记录</div>
			</div>
		</div>
		<!--菜单角色结束-->
		<!--菜单用户开始-->
		<div id='menuUser' class='boxBorder' style='width:100%; margin: 30px 0 10px 10px;'>
			<div class="cl pd-5 bg-1 bk-gray" style="margin-top: 14px; margin-bottom: 14px;">
				<label class="qryTitle control-label">用户名称</label>
  				<div class="col-sm-4">
    				<input placeholder="" name="bindUserName" id='bindUserName' value=""  class="form-control" type="text">
 				 </div>
 				 <label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" id="queryUser" onclick="queryBindUserCount();" type="button" power_code="menu_user_serach">
 					 <span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询
 					 </button>
				 </label>
				 <label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" data-toggle="modal" onclick="queryUnbUser(1)" type="button" power_code="menu_user_add" style="display:none;">
 					 <span class="glyphicon glyphicon-plus" style="color: rgb(0, 0, 0);"></span> 新增
 					</button>
				 </label>
				<label class="checkbox-inline my_mar">
 					 <button class="btn btn-info btn-sm" id="removeUser" onclick="removeUser()" type="button" power_code="menu_user_del" style="display:none;">
 					 <span class="glyphicon glyphicon-trash" style="color: rgb(0, 0, 0);"></span> 删除
 					 </button>
				</label>
			</div>
			<div>
				<table id="buTable" class="table table-border table-striped table-bordered table-hover table-bg table-sort tbMar">
					<thead>
						<tr class="text-c">
							<th width="18%"><input type="checkbox" id='buSelectAll'>
							</th>
							<th width="27%">用户ID</th>
							<th width="25%">用户名称</th>
							<th width="30%">所属地市</th>
						</tr>
					</thead>
					<tbody id='bindUserTab'>
					</tbody>
				</table>
			</div>
			<div>
				<div id='bindUserPagination' class="gigantic jpagination">
				  <a href="#" class="first disabled" data-action="first"></a> 
				  <a href="#" class="previous disabled mar_r7" data-action="previous"></a>
				  <div class="textinput"><span class="pd_r7">第</span><input type="text" class="pagenum mar_r7" value='1'/><span class="pd_r14">页</span><span>共<span id='bindUserPageCount'>1</span>页</span></div>
				  <a href="#" class="next disabled" data-action="next"></a> 
				  <a href="#" class="last disabled" data-action="last"></a>
			  </div>
	          <div class="sertext">共 <span id='bindUserCount'>0</span> 条记录</div>
			</div>
		</div>
		<!--菜单用户结束-->
	</div>
</div>
	<!--新增角色-->
	<div class="modal fade" id="addRole" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style='width:800px;'>
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myAddRoleLabel">添加角色</h4>
				</div>
				<div class="modal-body" style="width: 100%">
					<div>
						<label class="qryTitle control-label">角色名称</label>
  						<div class="col-sm-4">
    						<input placeholder="" name="ubRoleName" id='ubRoleName' value=""  class="form-control" type="text">
 				 		</div>
 				 		<label class="checkbox-inline my_mar">
 					 		<button class="btn btn-info btn-sm" id="qryUbRole" type="button" onClick="queryUnbRole(2)">
 					 		<span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询
 					 	</button>
				 </label>
					</div>
					<div>
						<table id="urTable" class="table table-border table-striped table-bordered table-hover table-bg table-sort mb0">
							<thead>
								<tr class="text-c">
									<th width="8%"><input type="checkbox" id='urSelectAll'>
									</th>
									<th width="42%">角色名称</th>
									<th width="20%">所属地市</th>
									<th width="30%">创建时间</th>
								</tr>
							</thead>
							<tbody id='unbRoleTab'>
							</tbody>
						</table>
					</div>
					<div>
						<div id='unbRolePagination' class="gigantic jpagination">
							  <a href="#" class="first disabled" data-action="first"></a> 
							  <a href="#" class="previous disabled mar_r7" data-action="previous"></a>
							  <div class="textinput"><span class="pd_r7">第</span><input type="text" readonly="readonly" class="pagenum mar_r7" /><span class="pd_r14">页</span><span>共<span id='unbRolePageCount'></span>页</span></div>
							  <a href="#" class="next disabled" data-action="next"></a> 
							  <a href="#" class="last disabled" data-action="last"></a>
						  </div>
                          <div class="sertext">共 <span id='unbRoleCount'></span> 条记录</div>
					</div>
				</div>
				<div class="modal-footer" style="clear:both;">
					<button type="button" class="btn btn-info btn-sm" onclick="bindRole()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- 新增菜单角色结束-->
	
	<!--新增用户-->
	<div class="modal fade" id="addUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style='width:800px;'>
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myAddUserLabel">添加用户</h4>
				</div>
				<div class="modal-body" style="width: 100%">
					<div>
						<label class="qryTitle control-label">用户名称</label>
  						<div class="col-sm-4">
    						<input placeholder="" name="ubUserName" id='ubUserName' value=""  class="form-control" type="text">
 				 		</div>
 				 		<label class="checkbox-inline my_mar">
 					 		<button class="btn btn-info btn-sm" id="qryUbUser" type="button" onClick="queryUnbUser(2)">
 					 		<span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询
 					 	</button>
				 </label>
					</div>
						<table id="uuTable" class="table table-border table-striped table-bordered table-hover table-bg table-sort mb0">
							<thead>
								<tr class="text-c">
									<th width="5%"><input type="checkbox" id='uuSelectAll'>
									</th>
									<th width="15%">用户ID</th>
									<th width="12%">用户名称</th>
									<th width="10%">所属地市</th>
									<th width="27%">创建时间</th>
								</tr>
							</thead>
							<tbody id='unbUserTab'>
							</tbody>
						</table>
					<div>
						<div id='unbUserPagination' class="gigantic jpagination">
							  <a href="#" class="first disabled" data-action="first"></a> 
							  <a href="#" class="previous disabled mar_r7" data-action="previous"></a>
							  <div class="textinput"><span class="pd_r7">第</span><input type="text" class="pagenum mar_r7" /><span class="pd_r14">页</span><span>共<span id='unbUserPageCount'></span>页</span></div>
							  <a href="#" class="next disabled" data-action="next"></a> 
							  <a href="#" class="last disabled" data-action="last"></a>
						  </div>
	                      <div class="sertext">共 <span id='unbUserCount'></span> 条记录</div>
					</div>
				</div>
				<div class="modal-footer" style="clear:both;">
					<button type="button" class="btn btn-info btn-sm" onclick="bindUser()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- 新增菜单用户结束-->
	
	<!--菜单新增、编辑开始-->
	<div class="modal fade" id="addMenu" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style='width:650px;'>
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myMenuManaLabel"></h4>
				</div>
					
				<form class="form-horizontal" action="saveMenu" method="POST" id="menuForm" role="form" onsubmit="return validate()">
				<div class="modal-body" style="width: 100%; height:355px; overflow-y:auto;">
      				
      				<div class="form-group" >
         				 <!-- Text input-->
          				<label class="col-sm-2 control-label titWid"><span style='color:red;'>*</span>菜单编号</label>
          				<div class="col-sm-4 conWid">
            				<input placeholder="" name="menuId" id='menuId' value="" readonly=true class="form-control" type="text">
         				 </div>
      				</div>
      
       				<div class="form-group">
          				<!-- Text input-->
          				<label class="col-sm-2 control-label titWid" for="input01"><span style='color:red;'>*</span>菜单名称</label>
          				<div class="col-sm-4 conWid">
            				<input placeholder="" name="menuItemTitle" id="menuItemTitle" value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
       				</div>
        
      				<div class="form-group">

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label titWid"><span style='color:red;'>*</span>父菜单</label>
          				<div class="col-sm-4 conWid">
            				<select name="parentId" id='parentId' class="form-control" style="width:100%;" value="1">
            				<option value="0">0</option>
            				<#if sysMenus?exists>
	                 			<#list sysMenus as rowMenu>
	                 				<option value="${rowMenu.menuitemid}">${rowMenu.menuitemtitle}</option>
	                 			</#list>
                 			</#if>
			 				</select>
          				</div>
        			</div>

    				<div class="form-group">

          				<!-- Text input-->
          				<label class="col-sm-2 control-label titWid" for="input01">显示顺序</label>
          				<div class="col-sm-4 conWid">
            				<input placeholder="只能输入数字" onkeyup="this.value=this.value.replace(/\D/g,'')" 
            				 onafterpaste="this.value=this.value.replace(/\D/g,'')"  name="sortNum" id='sortNum'
            				  value="" class="form-control" type="text">
            				<p class="help-block"></p>
         				</div>
        			</div>

    				<div class="form-group">

          				<!-- Text input-->
         	 			<label class="col-sm-2 control-label titWid" for="input01">菜单图标</label>
          				<div class="col-sm-4 conWid">
            				<input placeholder="" name="iconUrl" id='iconUrl' value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
        			</div>
      				<div class="form-group">

          				<!-- Text input-->
          				<label class="col-sm-2 control-label titWid" for="input01"><span style='color:red;'>*</span>菜单URL</label>
          				<div class="col-sm-4 conWid">
            				<input placeholder="" name="url" id='url' value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
        			</div>
        
      				<div class="form-group">

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label titWid" id="urltype"><span style='color:red;'>*</span>菜单状态</label>
          				<div class="col-sm-4 conWid">
            				<select name="state" id='state' class="form-control" style="width:100%;">
                   				<option value="1" id="urltype_1">启用</option>
                   				<option value="0" id="urltype_0">关闭</option>>
			 				</select>
          				</div>
        			</div>
        
          			<div class="form-group">

        				<!-- Checkbox -->
          				<label class="col-sm-2 control-label titWid"><span style='color:red;'>*</span>菜单类型</label>
          				<div class="col-sm-4 conWid">
            				<select name="menuType" id='menuType' class="form-control" style="width:100%;">
                   				<option value="0">菜单</option>
                   				<option value="1">配置</option>
                   				<option value="2">资源包</option>
			 				</select>
          				</div>
        			</div>
        			<div class="form-group">
        				<label for="name" class="col-sm-2 control-label titWid" >菜单权限</label>
						<div class="col-sm-4 conWid">
            				<input type="button" value="添加功能" id='addPowerBtn' onclick='addPowerList()'/>
            				<input type="hidden" id='powerSort' value='1'/>
          					<ul style=" list-style:none;padding-left: 0px;margin-top: 15px;" id="powerList">
								<li><input type="hidden" name='munu_power_id'id='munu_power_id_1' value=''>名称-描述-CODE<input type="text" name='munu_power_name'id='munu_power_1'>(-分隔)</li>
							</ul>
          				</div>
					</div>      
				</div>
				<div class="modal-footer" style="clear:both;">
					<button type="button" class="btn btn-info btn-sm" onclick="saveMenu()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
				</form>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- 菜单新增、编辑结束-->
	
	
	<!--角色对应菜单功能配置开始-->
	<div class="modal fade" id="addPowerToRole" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style='width:650px;'>
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myMenuManaLabel">权限配置</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					<div class="checkbox-inline">
						<input type="hidden" id="addPowerModerroleId">
						<input type="hidden" id="addPowerModermenuId">
						<div style='display: inline-block;'>
						权限配置：
						</div>
						<div style='display: inline-block;' id="powerCheckList">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="addPowerMethod()" data-dismiss="modal" power_code="menu_role_right" style='display:none;'>提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">取消</button>
				</div>	
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--角色对应菜单功能配置开始结束-->
	
<script type="text/javascript">
<#if allRightFlag=='YES'>
	$("button").css("display","");
<#else>
	<#list powerList as powers>
	$("[power_code='${powers.power_code}']").css("display","");
	</#list>
</#if>
</script>
<BODY>
</HTML>