<!DOCTYPE html>
<HTML>
<HEAD>
<#include "../top.ftl">
<style>
#BeanTable button{
    padding: 3px 7px;
}
</style>
<script type="text/javascript">
var powerMap = ${power};
//获取查询输入框中的值
function query() {
	var roleName = $("#roleName").val();
	location.href = "manage?roleName=" + encodeURI(encodeURI(roleName));
}

//增加
function addSave() {
	var roleName = $("#roleName").val();
	$("#addForm").submit();
}

//将当前点击的属性填充到文本框里
function editRec(roleId,roleName) {
	$("#roleId_u").val(roleId).innerHTML;
	$("#roleName_u").val(roleName).innerHTML;
}

//修改
function editSave() {
	var roleName = $("#roleName_u").val();
	$("#editForm").submit();
}

//单个删除td
function deleteRec(id) {
	$.confirm("确定删除该角色吗？", function(index){
		location.href = "delete?roleId=" + id;
	});
}

//批量删除
function deleteAll() {
	//判断至少写了一项
	var checkedNum = $("input[name='subcheck']:checked").length;
	if (checkedNum == 0) {
		$.alert("请至少选择一项!");
		return false;
	}
	
	$.confirm("确定删除所选角色吗?",function(index){
		var checkedList = new Array();
		$("input[name='subcheck']:checked").each(function(){
			checkedList.push($(this).val());
		});
		$.ajax({
			type : "POST",
			url : "${mvcPath}/role/batchDelete",
			data : {
				"delitems" : checkedList.toString()
			},
			datatype : "html",
			success : function(data) {
				$(":checkbox").attr("checked", false);
				setTimeout("location.reload()", 50);//页面刷新
			},
			error : function(data) {
				$.alert("删除失败!");
			}
		});
	});

}

//判断角色是否存在
function checkExist(roleName) {
	var flag = true;
	$.ajax({
		type : "POST",
		url : "${mvcPath}/role/checkExist",
		data : {
			roleName : roleName
		},
		async : false,
		dataType : "json",
		success : function(data) {
			if (data.flag) {
				$.msg("角色名已存在请重新填写", {
					icon : 0,
					time : 5000
				});
				flag = false;
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("查询角色失败(errorCode:" + XMLHttpRequest.status + ")" + "<br>请联系系统管理员!", {
				icon : 0,
				time : 5000
			});
			flag = false;
		}
	});
	return flag;
}
//检验
function validate() {
	var roleName = $("#roleName_c").val();
	if (!roleName) {
		$.msg("请填写角色名称！", {
			icon : 0,
			time : 5000
		});
		$("#roleName_c").focus();
		return false;
	}
	return checkExist(roleName);
}
function validateEdit() {
	var roleName = $("#roleName_u").val();
	if (!roleName) {
		$.msg("请填写角色名称！", {
			icon : 0,
			time : 5000
		});
		$("#roleName_u").focus();
		return false;
	}
	return checkExist(roleName);
}

/**打开角色关联用户的模态框**/
function openConnectUserModel(roleid){
	$("#connectRoleId").val(roleid);
	$("#connectUserId").val("");
	$("#connectUserName").val("");
	$("#coonUserList").empty();
}


function selectRoleUsers(){
	var roleid=$("#connectRoleId").val();
	var userid=$("#connectUserId").val();
	var username=$("#connectUserName").val();
	var cityid=$("#c_city_id").val();
	getUserInfobyRoleid(roleid,userid,username,cityid);
}

/**查询该角色下所有的用户**/
function getUserInfobyRoleid(roleid,userid,username,cityid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/getRoleAndUserByParam"
		,data: {roleid:roleid,userid:userid,username:username,cityid:cityid}
		,async: false
		,dataType : "json"
		,success: function(data){
		     var html ='';
	    	 for(var i = 0;i<data.length;i++){
	    		 var cell = data[i];
	    		 html = html
	    		 	  + "<tr id='"+cell.userid+"' >"
	    		 	  + "<td><input type='checkbox' value='"+cell.userid+"' b_userid='"+cell.userid+"' b_username='"+cell.username+"' b_areaname='"+cell.area_name+"'></td>"													
	    		 	  + "<td>"+cell.userid+"</td>"
	    		 	  + "<td>"+cell.username+"</td>"
	    		 	  + "<td>"+cell.areaname+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#coonUserList").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

function selectUserList(){
	var roleid=$("#connectRoleId").val();
	var userid=$("#addUserId").val();
	var username=$("#addUserName").val();
	var cityid=$("#a_city_id").val();
	getUserInfo(roleid,userid,username,cityid);
}

function getUserInfo(roleid,userid,username,cityid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/getUserInfo"
		,data: {roleid:roleid,userid:userid,username:username,cityid:cityid}
		,async: false
		,dataType : "json"
		,success: function(data){
			$('#addUserCheck').attr("checked", false);
	         var html ='';
	    	 for(var i = 0;i<data.length;i++){
	    		 var cell = data[i];
	    		 html = html
	    		 	  + "<tr id='"+cell.userid+"' >"
	    		 	  + "<td><input type='checkbox' value='"+cell.userid+"' b_userid='"+cell.userid+"' b_username='"+cell.username+"' b_areaname='"+cell.area_name+"'></td>"													
	    		 	  + "<td>"+cell.userid+"</td>"
	    		 	  + "<td>"+cell.username+"</td>"
	    		 	  + "<td>"+cell.area_name+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#addUserList").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/**获得所有复选框的用户ID,组成字符串以逗号的方式隔开**/
function getAllIds(id){
	var eid='';
	$("#"+id+" tr :checked").each(function(){
		if(eid!=''){
			eid=eid+','+$(this).val();
		}else{
			eid=$(this).val();
		}
	});
	return eid;
}

function bachInsertRoleUsers(){
	var roleid = $("#connectRoleId").val();
	var userids = getAllIds('addUserList');
	if(userids == ''){
		$.alert("请先选择用户");
		return;
	}
	addUsersToRole(roleid,userids);
}

/**为角色添加用户**/
function addUsersToRole(roleid,userids){

	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/bachInsertRoleUsers"
		,data: {roleid:roleid,userids:userids}
		,async: false
		,dataType : "json"
		,success: function(data){
		     if(data.flag==true){
		     	$.alert("添加用户成功");
		     	$("#selectUserModel").modal("hide");
		     	selectRoleUsers();
		     }
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("添加用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});

}

function deleteConnectUser(){
	var roleid = $("#connectRoleId").val();
	var userids = getAllIds('coonUserList');
	if(userids == ''){
		$.alert("请先选择用户");
		return;
	}
	$.confirm("确定删除所选用户吗？",function(index){
		deleteUser(roleid,userids);
	});
}

/**批量删除角色所关联的用户**/
function deleteUser(roleid,userids){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/bachDeleteRoleUsers"
		,data: {roleid:roleid,userids:userids}
		,async: false
		,dataType : "json"
		,success: function(data){
		     if(data.flag==true){
		     	$.alert("删除用户成功");
		     	selectRoleUsers();
		     }
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("用户删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}


function goBack() {
	location.href = "role";
}

function getConnectMenuRight(selRoleId, type){
	if(type == '1'){
		$('#selectRoleId').val(selRoleId);
		$('#menuName').val('');
	}
	var menuName = $('#menuName').val();
	var roleId = $('#selectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/getMenuList"
		,data: {
			roleId : roleId,
			menuName : menuName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     var menuStr = "";
		     for(var i=0; i<data.length; i++){
		     	var powers = data[i].power;
		     	var allPower = "";
		     	for(var j=0; j<powers.length; j++){
		     		if(j==0){
		     			allPower=powers[j].power_name;
		     		}else{
		     			allPower=allPower+','+powers[j].power_name;
		     		}
		     	}
		     	menuStr += "<tr>";
		     	menuStr += "<td>" + data[i].menuid + "</td>";
		     	menuStr += "<td>" + data[i].menutitle + "</td>";
		     	menuStr += "<td>"+allPower+"</td>";
		     	menuStr += "</tr>";
		     }
		     $('#menuList').html(menuStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询权限失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getConnectGroup(selRoleId, type){
	if(type == '1'){
		$('#groupSelectRoleId').val(selRoleId);
		$('#qryGroupName').val('');
	}
	var groupName = $('#qryGroupName').val();
	var roleId = $('#groupSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/getConnectGroup"
		,data: {
			roleId : roleId,
			groupName : groupName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#qryGroupSelectAll').attr("checked", false);
		     var groupStr = "";
		     for(var i=0; i<data.length; i++){
		     	groupStr += "<tr>";
		     	groupStr += "<td><input type='checkbox' id='conGroupcheck_" + data[i].groupid + "' name='conGroupcheck' value='" + data[i].groupid + "'></td>";
		     	groupStr += "<td>" + data[i].groupname + "</td>";
		     	groupStr += "<td>" + data[i].createtime + "</td>";
		     	groupStr += "</tr>";
		     }
		     $('#qryGroupList').html(groupStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getUnConnectGroup(type){
	if(type == '1'){
		$("#addGroupName").val('');
		$("#addGroupModel").modal("show");
	}
	var groupName = $('#addGroupName').val();
	var roleId = $('#groupSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/getUnConnectGroup"
		,data: {
			roleId : roleId,
			groupName : groupName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#addGroupSelectAll').attr("checked", false);
		     var groupStr = "";
		     for(var i=0; i<data.length; i++){
		     	groupStr += "<tr>";
		     	groupStr += "<td><input type='checkbox' id='uconGroupcheck_" + data[i].groupid + "' name='uconGroupcheck' value='" + data[i].groupid + "'></td>";
		     	groupStr += "<td>" + data[i].groupname + "</td>";
		     	groupStr += "<td>" + data[i].createtime + "</td>";
		     	groupStr += "</tr>";
		     }
		     $('#addGroupList').html(groupStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function addGroup(){
	var checkedGroups = $("input[name='uconGroupcheck']:checked").length;
	if(checkedGroups == 0){
		$.alert("请至少选择一个用户组");
		return;
	}
	var groups = new Array();
	$("input[name='uconGroupcheck']:checked").each(function(){
		groups.push($(this).val());
	});
	var roleId = $('#groupSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/addGroup"
		,data: {
			roleId : roleId,
			groups : groups.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("用户组添加成功");
			getConnectGroup("", "2")
		    $('#addGroupModel').modal("hide");
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("用户组添加失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function delGroup(){
	var checkedGroups = $("input[name='conGroupcheck']:checked").length;
	if(checkedGroups == 0){
		$.alert("请至少选择一个用户组");
		return;
	}
	
	$.confirm("确定删除所选用户组吗？",function(index){
		var groups = new Array();
		$("input[name='conGroupcheck']:checked").each(function(){
			groups.push($(this).val());
		});
		var roleId = $('#groupSelectRoleId').val();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/role/delGroup"
			,data: {
				roleId : roleId,
				groups : groups.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("用户组删除成功");
				getConnectGroup("", "2")
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
		            $.msg("用户组删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
		     }
		});
	});
}

/**关联菜单部分 start**/

function getConnectMenu(selRoleId, type){
	if(type == '1'){
		$('#menuSelectRoleId').val(selRoleId);
		$('#selectMenuName').val('');
	}
	var menuName = $('#selectMenuName').val();
	var roleId = $('#menuSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/selectConnectMenu"
		,data: {
			roleId : roleId,
			menuName : menuName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#selectMenuSelectAll').attr("checked", false);
		     var groupStr = "";
		     for(var i=0; i<data.length; i++){
		     	groupStr += "<tr>";
		     	groupStr += "<td><input type='checkbox' id='conMenucheck_" + data[i].menuid + "' name='conMenucheck' value='" + data[i].menuid + "'></td>";
		     	groupStr += "<td>" + data[i].menuid + "</td>";
		     	groupStr += "<td>" + data[i].menuname + "</td>";
		     	groupStr += "</tr>";
		     }
		     $('#selectMenuList').html(groupStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getUnConnectMenu(type){
	if(type == '1'){
		$("#addMenuName").val('');
		$("#addMenuModel").modal("show");
	}
	var menuName = $('#addMenuName').val();
	var roleId = $('#menuSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/selectUnConnectMenu"
		,data: {
			roleId : roleId,
			menuName : menuName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#addMenuSelectAll').attr("checked", false);
		     var groupStr = "";
		     for(var i=0; i<data.length; i++){
		     	groupStr += "<tr>";
		     	groupStr += "<td><input type='checkbox' id='uconMenucheck_" + data[i].menuid + "' name='uconMenucheck' value='" + data[i].menuid + "'></td>";
		     	groupStr += "<td>" + data[i].menuid + "</td>";
		     	groupStr += "<td>" + data[i].menuname + "</td>";
		     	groupStr += "</tr>";
		     }
		     $('#addMenuList').html(groupStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function addMenus(){
	var checkedMenus = $("input[name='uconMenucheck']:checked").length;
	if(checkedMenus == 0){
		$.alert("请至少选择一个菜单");
		return;
	}
	var menus = new Array();
	$("input[name='uconMenucheck']:checked").each(function(){
		menus.push($(this).val());
	});
	var roleId = $('#menuSelectRoleId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/role/addMenus"
		,data: {
			roleId : roleId,
			menus : menus.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("菜单添加成功");
			getConnectMenu("", "2")
		    $('#addMenuModel').modal("hide");
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("菜单添加失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function delMenus(){
	var checkedMenus = $("input[name='conMenucheck']:checked").length;
	if(checkedMenus == 0){
		$.alert("请至少选择一个菜单");
		return;
	}
	
	$.confirm("确定删除所选菜单吗？",function(index){
		var menus = new Array();
		$("input[name='conMenucheck']:checked").each(function(){
			menus.push($(this).val());
		});
		var roleId = $('#menuSelectRoleId').val();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/role/delMenus"
			,data: {
				roleId : roleId,
				menus : menus.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("菜单删除成功");
				getConnectMenu("", "2")
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
		            $.msg("菜单删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
		     }
		});
	});
}

/**关联菜单部分 end**/
</script>
</HEAD>
<BODY>
	<div class="page-container">
		<div class="cl pd-5 bg-1 bk-gray" style="margin-top: 14px; margin-bottom: 14px;">
			<span class="1" style="margin-left: 30px">
				<input type="text" value='' class="input-text radius" style="width: 20%; height: 32px;" id="roleName" name="roleName" placeholder="角色名"> 
				<button type="button" onclick="query()" class="btn btn-info btn-sm" style=" margin-bottom: 2px;margin-left: 5px;">
					<span class="glyphicon glyphicon-search"></span>搜索
				</button> 
			</span>
			<span class="l" style="float: right; margin-right: 10%;"> 
				<button type="button" class="btn btn-info btn-sm" name="all" onclick="deleteAll()" power_code="role_role_bachdel" style="display:none;">
					<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>批量删除
				</button> 
				<button class="btn btn-info btn-sm " data-toggle="modal" data-target="#add" power_code="role_role_add" style="display:none;">
					<span class="glyphicon glyphicon-plus"></span>添加角色
				</button> 
			</span> 
		</div>
		<table class="table table-border table-bordered table-hover table-bg" id="BeanTable">
			<thead>
				<tr>
					<th scope="col" colspan="10">角色列表</th>
				</tr>
				<tr class="text-c">
					<th width="30"><input type="checkbox" id="SelectAl">
					</th>
					<th width="300">角色名</th>
					<th width="200">创建时间</th>
					<th width="300">操作</th>
				</tr>
			</thead>
			<tbody id="tby">
				<#list list as bean>
				<tr class="text-c">
					<td><input type="checkbox" id="subcheck_${bean.role_id!''}" name="subcheck" value="${bean.role_id!''}">
					</td>
					<td>${bean.role_name!''}</td>
					<td>${bean.create_time!''}</td>
					<td>
						<button title="修改" class="btn btn-sm size-S btn-info radius" data-toggle="modal" data-backdrop="static" id="editRec" onclick="editRec('${bean.role_id!''}','${bean.role_name!''}') " data-target="#update" power_code="role_role_edit" style="display:none;">
							<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
						</button>
						<button title="删除" type="button" class="btn btn-sm btn-info size-S radius" onclick="deleteRec('${bean.role_id!''}')" power_code="role_role_del" style="display:none;">
							<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
						</button>
						<button title="关联用户" type="button" class="btn btn-sm btn-info size-S radius" data-toggle="modal" data-backdrop="static" onclick="openConnectUserModel('${bean.role_id!}')" data-target="#connectUserModel">
							<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
						</button>
						<button title="关联用户组" type="button" class="btn btn-sm btn-info size-S radius" data-toggle="modal" data-backdrop="static" onclick="getConnectGroup('${bean.role_id!}','1')" data-target="#qryGroupModel">
							<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
							<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
						</button>
						<button title="关联菜单" type="button" class="btn btn-sm btn-info size-S radius" data-toggle="modal" data-backdrop="static" onclick="getConnectMenu('${bean.role_id!}','1')" data-target="#selectMenuModel">
							<span class="glyphicon glyphicon-th" aria-hidden="true"></span>
						</button>
						<button title="权限" type="button" class="btn btn-sm btn-info size-S radius" data-toggle="modal" data-backdrop="static" onclick="getConnectMenuRight('${bean.role_id!}','1')" data-target="#menuModel">
							<span class="glyphicon glyphicon-link" aria-hidden="true"></span>
						</button>
					</td>
				</tr>
				</#list>
			</tbody>
		</table>
	</div>
	<!-- 显示分页 -->
	<div class="changePage">
		<div class="snPages"><#assign parameterMap = {} /> <@pager pager = pageQueryParam baseUrl = "manage" parameterMap = parameterMap /></div>
	</div>
	
	<!--添加角色-->
	<div class="modal fade" id="add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加角色</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					<form class="form-horizontal" action="addSave" id="addForm" method="POST" onsubmit="return validate()" role="form">
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">角色名称：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" value="" class="form-control" type="text" name="roleName_c" id="roleName_c">
							</div>
						</div>
						<div class="form-group" style="">
							<label class="col-sm-4 col-xs-7 control-label"></label>
							<!-- Button -->
							<div class="col-xs-8 col-sm-7">
								<input type="submit" class="btn btn-info btn-sm" id="btn_sub1" onclick="addSave()" value="提交" /> 
								<input type="reset" class="btn btn-info btn-sm" data-dismiss="modal" value="关闭" />
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<!--修改-->
	<div class="modal fade" id="update" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">修改角色</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" action="editSave" id="editFrom" method="POST" role="form" onsubmit="return validateEdit()">
						<input type="hidden" id="roleId_u" name="roleId_u" value="">
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">角色中文名：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="roleName_u" id="roleName_u" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<label class="col-sm-4 col-xs-7 control-label"></label>
							<!-- Button -->
							<div class="col-xs-8 col-sm-7">
								<input type="submit" class="btn btn-info btn-sm" id="btn_sub1" onclick="editSave()" value="提交" /> <input type="reset" class="btn btn-info btn-sm" data-dismiss="modal" value="关闭" />
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<!--关联用户开始-->
	<div class="modal fade" id="connectUserModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">关联用户</h4>
				</div>
				<div class="modal-body" >
					<div >
						<table >
									<tr>
									<td>
										<div class="form-group">
											<input class="input-sm" type="text" name="connectUserId" id="connectUserId" placeholder="用户名" value="">
											<input class="input-sm" type="hidden"  id="connectRoleId" value="">
										</div>
									</td>
										
									<td style="padding-left: 3%; padding-right: 0px;">
										<div class="form-group">
											<input class="input-sm" type="text" name="connectUserName" id="connectUserName" value="" placeholder="用户中文名">										
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="c_city_id" id='c_city_id' class="input-sm" placeholder="城市" >
            									<option value="">选择城市</option>
            									<option value="0">湖北</option>
												<option value="11">	武汉</option>
												<option value="12">	黄石</option>
												<option value="13">	鄂州</option>
												<option value="14">	宜昌</option>
												<option value="15">	恩施</option>
												<option value="16">	十堰</option>
												<option value="17">	襄樊</option>
												<option value="18">	江汉</option>
												<option value="19">	咸宁</option>
												<option value="20">	荆州</option>
												<option value="23">	荆门</option>
												<option value="24">	随州</option>
												<option value="25">	黄冈</option>
												<option value="26">	孝感</option>
            									
			 								</select>
										</div>
									</td>
									
									<td>
										<div class="form-group" style="margin-left: 30px">
											<input id="coonSearchUsers" class="btn btn-info btn-sm" onclick="selectRoleUsers();"  type="button" value="查询">
										</div>
									</td>
								</tr>
							</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="allxq">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="20%" style="text-align:center;">勾选用户</th>
									<th width="30%" style="text-align:center;">用户名</th>
									<th width="25%" style="text-align:center;">用户中文名</th>
									<th width="25%" style="text-align:center;">城市</th>
								</tr>								
							</thead>
							<tbody id="coonUserList" style="font-size: 12px;text-align:center;">
													
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" id="connectUserButton" class="btn btn-info btn-sm" power_code="role_user_add" style="display:none;">添加用户</button>
					<button type="button" class="btn btn-info btn-sm" id="addusers" onclick="deleteConnectUser()" power_code="role_user_del" style="display:none;">删除用户</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	
	<!--关联用户结束-->
	
	<!--查询用户开始-->
	<div class="modal fade" id="selectUserModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加用户</h4>
				</div>
				<div class="modal-body" >
					<div >
						<table >
									<tr>
									<td>
										<div class="form-group">
											<input class="input-sm" type="text" name="addUserId" id="addUserId" placeholder="用户名" value="">
										</div>
									</td>
										
									<td style="padding-left: 3%; padding-right: 0px;">
										<div class="form-group">
											<input class="input-sm" type="text" name="addUserName" id="addUserName" value="" placeholder="用户中文名">										
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="a_city_id" id='a_city_id' class="input-sm" placeholder="城市" >
            									<option value="">选择城市</option>
            									<option value="0">湖北</option>
												<option value="11">	武汉</option>
												<option value="12">	黄石</option>
												<option value="13">	鄂州</option>
												<option value="14">	宜昌</option>
												<option value="15">	恩施</option>
												<option value="16">	十堰</option>
												<option value="17">	襄樊</option>
												<option value="18">	江汉</option>
												<option value="19">	咸宁</option>
												<option value="20">	荆州</option>
												<option value="23">	荆门</option>
												<option value="24">	随州</option>
												<option value="25">	黄冈</option>
												<option value="26">	孝感</option>
            									
			 								</select>
										</div>
									</td>
									
									<td>
										<div class="form-group" style="margin-left: 30px">
											<input id="addSearchUsers" class="btn btn-info btn-sm" onclick="selectUserList()"  type="button" value="查询">
										</div>
									</td>
								</tr>
							</table>
					</div>
					<div style="height:270px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addUserTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id='addUserCheck'></th>
									<th width="30%" style="text-align:center;">用户名</th>
									<th width="30%" style="text-align:center;">用户中文名</th>
									<th width="30%" style="text-align:center;">城市</th>
								</tr>								
							</thead>
							<tbody id="addUserList" style="font-size: 12px;text-align:center;">
													
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" id="addusers" onclick="bachInsertRoleUsers()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--查询用户结束-->
	
	<!--查询菜单权限开始-->
	<div class="modal fade" id="menuModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">权限查看</h4>
					<input id="selectRoleId" type="hidden" value="">
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="menuName" id="menuName" placeholder="菜单ID" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="searchMenu" class="btn btn-info btn-sm" onclick="getConnectMenu('','2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="allxq">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="25%" style="text-align:center;">菜单ID</th>
									<th width="35%" style="text-align:center;">菜单名称</th>
									<th width="40%" style="text-align:center;">权限</th>
								</tr>
							</thead>
							<tbody id="menuList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--查询菜单权限结束-->
	
	<!--查询用户组开始-->
	<div class="modal fade" id="qryGroupModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">关联用户组</h4>
					<input id="groupSelectRoleId" type="hidden" value="">
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="qryGroupName" id="qryGroupName" placeholder="用户组名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="searchGroup" class="btn btn-info btn-sm" onclick="getConnectGroup('','2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="qryGroupTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="qryGroupSelectAll"></th>
									<th width="50%" style="text-align:center;">用户组名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>
							</thead>
							<tbody id="qryGroupList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="getUnConnectGroup('1')" power_code="role_ug_add" style="display:none;">添加用户组</button>
					<button type="button" class="btn btn-info btn-sm" onclick="delGroup()" power_code="role_ug_del" style="display:none;">删除用户组</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--查询关联用户组-->
	
	<!--添加用户组开始-->
	<div class="modal fade" id="addGroupModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加用户组</h4>
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="addGroupName" id="addGroupName" placeholder="用户组名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="addGroup" class="btn btn-info btn-sm" onclick="getUnConnectGroup('2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addGroupTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="addGroupSelectAll"></th>
									<th width="50%" style="text-align:center;">用户组名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>
							</thead>
							<tbody id="addGroupList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="addGroup()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--添加用户组-->
		
	<!--查询菜单开始-->
	<div class="modal fade" id="selectMenuModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">关联菜单</h4>
					<input id="menuSelectRoleId" type="hidden" value="">
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="selectMenuName" id="selectMenuName" placeholder="菜单名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="searchMenuButton" class="btn btn-info btn-sm" onclick="getConnectMenu('','2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="selectMenuTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="selectMenuSelectAll"></th>
									<th width="50%" style="text-align:center;">菜单编号</th>
									<th width="40%" style="text-align:center;">菜单名称</th>
								</tr>
							</thead>
							<tbody id="selectMenuList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="getUnConnectMenu('1')" power_code="role_menu_add" style="display:none;">添加菜单</button>
					<button type="button" class="btn btn-info btn-sm" onclick="delMenus()" power_code="role_menu_del" style="display:none;">删除菜单</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--查询菜单用户组-->
	
	<!--添加菜单开始-->
	<div class="modal fade" id="addMenuModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myMenuLabel">添加菜单</h4>
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="addMenuName" id="addMenuName" placeholder="菜单名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="addMenuButton" class="btn btn-info btn-sm" onclick="getUnConnectMenu('2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addMenuTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="addMenuSelectAll"></th>
									<th width="50%" style="text-align:center;">菜单编号</th>
									<th width="40%" style="text-align:center;">菜单名称</th>
								</tr>
							</thead>
							<tbody id="addMenuList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="addMenus()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--添加菜单结束-->
	
</BODY>
<script type="text/javascript">  
$(function(){  
	   $("#connectUserButton").click(function(){  
	       $("#addUserList").empty();
	       $("#selectUserModel").modal("show");  
	   }); 
	       
	/*添加用户组全选*/
	$("#addGroupTable thead th input:checkbox").on("click" , function(){
		$("#addGroupTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#addGroupTable thead th input:checkbox").prop("checked"));
    });
    
    /*查询用户组全选*/
	$("#qryGroupTable thead th input:checkbox").on("click" , function(){
		$("#qryGroupTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#qryGroupTable thead th input:checkbox").prop("checked"));
    });
    
    	/*添加菜单全选*/
	$("#addMenuTable thead th input:checkbox").on("click" , function(){
		$("#addMenuTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#addMenuTable thead th input:checkbox").prop("checked"));
    });
    
    /*查询菜单全选*/
	$("#selectMenuTable thead th input:checkbox").on("click" , function(){
		$("#selectMenuTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#selectMenuTable thead th input:checkbox").prop("checked"));
    });
    
    $("#addUserTable thead th input:checkbox").on("click" , function(){
		$("#addUserTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#addUserTable thead th input:checkbox").prop("checked"));
    });
})  

<#if allRightFlag=='YES'>
	$("button").css("display","");
<#else>
	<#list powerList as powers>
	$("[power_code='${powers.power_code}']").css("display","");
	</#list>
</#if>
</script>  
</HTML>
<!--分页的宏-->
<#macro pager pager baseUrl parameterMap={} maxShowPageCount = 4> <#local pageNumber = pager.pageNumber /> <#local pageSize = pager.pageSize /> <#local pageCount = pager.pageCount /> <#local userid = pager.userid /> <#local username = pager.username /> <#local cityid = pager.cityid /> <#local parameter = "" /> <#local parameter = parameter + "?pageSize=" + pageSize+"&userid="+userid+"&username="+username+"&cityid="+cityid /> <#list parameterMap?keys as key> <#if parameterMap[key] != null && parameterMap[key] != ""> <#local parameter = parameter + "&" + key + "=" + parameterMap[key] /> </#if> </#list> <#local baseUrl = baseUrl + parameter /> <#if baseUrl?contains("?")> <#local baseUrl = baseUrl + "&" /> <#else>
<#local baseUrl = baseUrl + "?" /> </#if> <#local firstPageUrl = baseUrl + "pageNumber=1" /> <#local lastPageUrl = baseUrl + "pageNumber=" + pageCount /> <#local prePageUrl = baseUrl + "pageNumber=" + (pageNumber - 1) /> <#local nextPageUrl = baseUrl + "pageNumber=" + (pageNumber + 1) /> <#if maxShowPageCount <= 0> <#local maxShowPageCount = 4> </#if> <#local segment = ((pageNumber - 1) / maxShowPageCount)?int + 1 /> <#local startPageNumber = (segment - 1) * maxShowPageCount + 1 /> <#local endPageNumber = segment * maxShowPageCount /> <#if (startPageNumber < 1)> <#local startPageNumber = 1 /> </#if> <#if (endPageNumber > pageCount)> <#local endPageNumber = pageCount /> </#if> <#if (pageCount > 1)>
<div class="pager_area">
	<ul class="pager">
		<li class="pageInfo">共 ${pageCount} 页</li> <#-- 首页 --> <#if (pageNumber > 1)>
		<li class="firstPage"><a href="${firstPageUrl}">首页</a></li> <#else>
		<li class="firstPage"><span>首页</span></li> </#if> <#-- 上一页 --> <#if (pageNumber > 1)>
		<li class="prePage"><a href="${prePageUrl}">上一页</a></li> <#else>
		<li class="prePage"><span>上一页</span></li> </#if> <#if (startPageNumber > 1)>
		<li><a href="${baseUrl + " pageNumber=" + (pageNumber - 2) }">...</a></li> </#if> <#list startPageNumber .. endPageNumber as index> <#if pageNumber != index>
		<li><a href="${baseUrl + "pageNumber=" + index }">${index}</a></li> <#else>
		<li class="currentPage"><span style='background-color: #03FDFD;'>${index}</span></li> </#if> </#list> <#if (endPageNumber < pageCount)>
		<li><a href="${baseUrl + " pageNumber=" + (pageNumber + 2) }">...</a></li> </#if> <#-- 下一页 --> <#if (pageNumber < pageCount)>
		<li class="nextPage"><a href="${nextPageUrl}">下一页</a></li> <#else>
		<li class="nextPage"><span>下一页</span></li> </#if> <#-- 末页 --> <#if (pageNumber < pageCount)>
		<li class="lastPage"><a href="${lastPageUrl}">末页</a></li> <#else>
		<li class="lastPage"><span>末页</span></li> </#if>
	</ul>
</div>
</#if> 
</#macro>