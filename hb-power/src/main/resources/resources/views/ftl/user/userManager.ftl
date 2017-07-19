<!DOCTYPE html>
<HTML>
<HEAD>
<#include "../top.ftl">
<style>
button {padding: 4px 5px;}
#UserTable tbody tr td button{padding: 2px 5px;}
</style>
<script type="text/javascript">
var powerMap = ${power};
//单个删除td
function delUser(userid) {
	$.confirm("确定删除该用户吗？",function(index){
		location.href = "deleteUser?userid=" + userid;
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
	$.confirm("确定删除所选用户吗？",function(index){
		var checkedList = new Array();
		$("input[name='subcheck']:checked").each(function() {
			checkedList.push($(this).val());
		});
		$.ajax({
			type : "POST",
			url : "${mvcPath}/userManager/batchDeletes",
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

//修改
function btn_update() {
	var userid = $("#d_userid").val();
	var username = $("#d_username").val();
	var cityid = document.getElementById('d_cityid').options[document.getElementById('d_cityid').selectedIndex].text
	var status = $("#d_status").val();
	var email = $("#d_email").val();
	var phone = $("#d_mobilephone").val();
	var user = {
		userid : userid,
		username : username,
		cityid : cityid,
		status : status,
		email : email,
		mobilephone : phone
	};
	document.getByElementById("from1").submit();
}

//判断用户是否存在
function checkUserid(userId) {
	var flag = true;
	$.ajax({
		type : "POST",
		url : "${mvcPath}/userManager/checkUser",
		data : {
			c_userid : userId
		},
		async : false,
		dataType : "json",
		success : function(data) {
			if (data.flag) {
				$.msg("用户名已存在请重新填写", {
					icon : 0,
					time : 5000
				});
				flag = false;
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("查询用户失败(errorCode:" + XMLHttpRequest.status + ")" + "<br>请联系系统管理员!", {
				icon : 0,
				time : 5000
			});
			flag = false;
		}
	});
	return flag;
}

function validate() {
	var userid = $("#c_userid").val();
	if (userid == null || userid.replace(/\s/g, "") == "") {
		$.msg("请填写用户编号！！", {
			icon : 0,
			time : 5000
		});
		$("#c_userid").focus();
		return false;
	}
	return checkUserid(userid);
}

function checkedArea(userid) {
	var areas = $("#" + userid + "_vistarea").text().replace(/\s/g, "");
	var visitArea = areas.split(",");
	$("input[name='areaNamech']").removeAttr("checked");
	$("#visitAreaUserId").val(userid);
	for ( var i = 0; i < visitArea.length; i++) {
		$("input[name='areaNamech']").each(function() {
			if ($(this).val() == visitArea[i]) {
				$(this).prop("checked", true);
			}
		});
	}

}

/**获得被勾选的地市信息**/
function getCheckedVal() {
	var areaNames = '';
	$("#areaBody tr :checked").each(function() {
		if (areaNames != '') {
			areaNames = areaNames + ',' + $(this).val();
		} else {
			areaNames = $(this).val();
		}
	});
	return areaNames;
}

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

//将当前点击的属性填充到文本框里
function update_(userid, username, cityid, status, mobilephone, email) {
	$("#d_userid").val(userid).innerHTML;
	$("#d_username").val(username).innerHTML;
	$("#d_mobilephone").val(mobilephone).innerHTML;
	$("#d_email").val(email).innerHTML;
}

//生成当前系统时间格式化
function save_() {
	var date = new Date();
	var seperator1 = "-";
	var seperator2 = ":";
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate + " " + date.getHours() + seperator2 + date.getMinutes() + seperator2 + date.getSeconds();
	$("#c_createtime").val(currentdate).innerHTML;
}

//增加
function btn_save() {
	var userid = $("#c_userid").val();
	var cityid = document.getElementById('c_cityid').options[document.getElementById('c_cityid').selectedIndex].text
	var username = $("#c_username").val();
	var pwd = $("#c_pwd").val();
	var status = $("#c_status").val();
	var email = $("#c_email").val();
	var mobilephone = $("#c_mobilephone").val();
	var createtime = $("#c_createtime").val();
	var user = {
		userid : userid,
		cityid : cityid,
		username : username,
		pwd : pwd,
		status : status,
		email : email,
		mobilephone : mobilephone,
		createtime : createtime
	};
	document.getByElementByIdx_x("from2").submit();
}

//获取查询输入框中的值
function findBy_(userid, username, cityid) {
	var userid = $("#userid").val();
	var username = $("#username").val();
	var cityid = $("#cityid").val();
	location.href = "userManage?userid=" + userid + "&username=" + username + "&cityid=" + cityid;
}

function updateVisitarea() {
	var uID = $("#visitAreaUserId").val();
	var areas = getCheckedVal();
	$.ajax({
		type : "POST",
		url : "${mvcPath}/userManager/updateVisit",
		data : {
			uID : uID,
			areas : areas
		},
		async : false,
		dataType : "json",
		success : function(data) {
			if (data.flag) {
				$("#" + uID + "_vistarea").text(areas);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("修改可视地市失败(errorCode:" + XMLHttpRequest.status + ")" + "<br>请联系系统管理员!", {
				icon : 0,
				time : 5000
			});
		}
	});
}

/*打开添加用户组模态框*/

function openAddUgroupModel(userid){
	 var groupName = $("#"+userid+"_groupname").text();
	 var groupid = $("#"+userid+"_groupname").attr("g_groupid");
	$("#model_groupName").val(groupName);
	$("#model_user_id").val(userid);
	$("#model_old_groupid").val(groupid);
	if(groupName != ''){
		var html = "<tr id='"+groupid+"' >"
	     	 	+ "<td><input type='radio' name='mGroupName' value='"+groupName+"' b_groupid='"+groupid+"' b_groupName='"+groupName+"'></td>"													
	      		+ "<td>"+groupName+"</td>"
	      		+ "</tr>";
		$("#userGroupList").html(html);
	}else{
		getUserGroupByName();
	}
}

/*根据用户组名查询用户组信息*/
function getUserGroupByName(){
	var groupName = $("#model_groupName").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/getUserGroupByName"
		,data: {groupName:groupName}
		,async: false
		,dataType : "json"
		,success: function(data){
			$("#userGroupList").empty();
		        var html ='';
	    	 for(var i = 0;i<data.length;i++){
	    		 var cell = data[i];
	    		 html = html
	    		 	  + "<tr id='"+cell.treenodeid+"' >"
	    		 	  + "<td><input type='radio' name='mGroupName' value='"+cell.treenodename+"' b_groupid='"+cell.treenodeid+"' b_groupName='"+cell.treenodename+"'></td>"													
	    		 	  + "<td>"+cell.treenodename+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#userGroupList").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/*根据条件查询角色信息*/
function getRoleGroupByParam(){
	var roleName = $("#selectRoleName").val();
	var userId = $('#addRoleGroupUid').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/getUserRoles"
		,data: {roleName:roleName,roleId:"", userId: userId}
		,async: false
		,dataType : "json"
		,success: function(data){
			$('#selectRoleCb').attr("checked", false);
			$("#selectRoleGroupList").empty();
		     var html ='';
	    	 for(var i = 0;i<data.length;i++){
	    		 var cell = data[i];
	    		 html = html
	    		 	  + "<tr id='"+cell.roleid+"' >"
	    		 	  + "<td><input type='checkbox' name='"+cell.roleid+"' id='"+cell.roleid+"' value='"+cell.roleid+"' b_roleid='"+cell.roleid+"' b_roleName='"+cell.rolename+"'></td>"													
	    		 	  + "<td>"+cell.rolename+"</td>"
	    		 	  + "<td>"+cell.createtime+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#selectRoleGroupList").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/*查询用户添加的的角色信息*/
function getRolesByUserId(userid){
    $("#addRoleGroupUid").val(userid);
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/getUserAndRole"
		,data: {userid:userid}
		,async: false
		,dataType : "json"
		,success: function(data){
			$('#mGroupName').attr("checked", false);
			$("#roleGroupList").empty();
		        var html ='';
	    	 for(var i = 0;i<data.length;i++){
	    		 var cell = data[i];
	    		 html = html
	    		 	  + "<tr id='"+cell.roleid+"' >"
	    		 	  + "<td><input type='checkbox' name='"+cell.roleid+"' id='"+cell.roleid+"' value='"+cell.roleid+"' b_roleid='"+cell.roleid+"' b_roleName='"+cell.rolename+"'></td>"
	    		 	  + "<td>"+cell.userid+"</td>"													
	    		 	  + "<td>"+cell.rolename+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#roleGroupList").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/**批量删除角色**/

function deleteRoleGroups(){
	var userid = $("#addRoleGroupUid").val();
	var roleids = getAllIds('roleGroupList');
	if(roleids == ''){
		$.alert("请至少选择一个角色");
		return;
	}
	$.confirm("确定删除所选角色吗？",function(index){
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/userRoleMapManager/bachDelete"
			,data: {userid:userid,roleids:roleids}
			,async: false
			,dataType : "json"
			,success: function(data){
				if(data.flag){
					$.alert("角色删除成功");
					getRolesByUserId(userid);
				}
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
		            $.msg("删除角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
		     }
		});
	});
}

/**批量添加角色**/
function bachAddRoleGroup(){
	var userid = $("#addRoleGroupUid").val();
	var roleids = getAllIds('selectRoleGroupList');
	if(roleids == ''){
		$.alert("请先选择需要添加的角色");
		return;
	}
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userRoleMapManager/bachInsert"
		,data: {userid:userid,roleids:roleids}
		,async: false
		,dataType : "json"
		,success: function(data){
			if(data.flag){
				$.alert("角色添加成功");
				$('#selectRoleGroup').modal('hide');
				getRolesByUserId(userid);
			}
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("添加角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

/**修改用户组信息**/
function updateUserGroup(){
	if($("input[name=mGroupName]:checked").length == 0){
		$.alert("请先选择用户组");
		return;
	}
	var oldGroupId = $("#model_old_groupid").val();
	var userid = $("#model_user_id").val();
	var newGroupName= $("input[name=mGroupName]:checked").val();
	var newGroupId= $("input[name=mGroupName]:checked").attr("b_groupid");
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userManager/updateUserGroup"
		,data: {oldGroupId:oldGroupId,newGroupId:newGroupId,userid:userid}
		,async: false
		,dataType : "json"
		,success: function(data){
			if(data.flag){
				$("#" + userid + "_groupname").text(newGroupName);
				$("#"+userid+"_groupname").attr("g_groupid",newGroupId);
				$.alert("用户组编辑成功");
				$('#addUserGroup').modal('hide');
			}
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("编辑用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});

}


function goBack() {
	location.href = "userManage";
}

function getConnectUserGroup(userid, type){
	if(type == "1"){
		$("#add_model_user_id").val(userid);
		$("#add_model_group_name").val("");
	}
	var userId = $("#add_model_user_id").val();
	var groupName = $("#add_model_group_name").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userManager/getConnectUserGroup"
		,data: {
			userId:userId,
			groupName : groupName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			var groupHtml = "";
			for(var i=0; i<data.length; i++){
				groupHtml += "<tr>";
				groupHtml += "<td><input type='checkbox' id='conGroupcheck_" + data[i].groupid + "' name='conGroupcheck' value='" + data[i].groupid + "'></td>";
		     	groupHtml += "<td>" + data[i].groupname + "</td>";
		     	groupHtml += "<td>" + data[i].createtime + "</td>";
		     	groupHtml += "</tr>";
			}
			$("#userGroupList").html(groupHtml);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getUnconnectUserGroup(type){
	if(type == "1"){
		$("#editUserGroup").modal("show");
		$("#edit_model_group_name").val("");
	}
	var groupName = $("#edit_model_group_name").val();
	var userId = $("#add_model_user_id").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userManager/getUnconnectUserGroup"
		,data: {
			userId:userId,
			groupName : groupName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			var groupHtml = "";
			for(var i=0; i<data.length; i++){
				groupHtml += "<tr>";
				groupHtml += "<td><input type='checkbox' id='unconGroupcheck_" + data[i].groupid + "' name='unconGroupcheck' value='" + data[i].groupid + "'></td>";
		     	groupHtml += "<td>" + data[i].groupname + "</td>";
		     	groupHtml += "<td>" + data[i].createtime + "</td>";
		     	groupHtml += "</tr>";
			}
			$("#editUserGroupList").html(groupHtml);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("查询用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function delUserGroup(){
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
		var userId = $("#add_model_user_id").val();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/userManager/delUserGroup"
			,data: {
				userId:userId,
				groups : groups.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("用户组删除成功");
				getConnectUserGroup('','2');
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.msg("删除用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
		     }
		});
	});
}

function addGroup(){
	var checkedGroups = $("input[name='unconGroupcheck']:checked").length;
	if(checkedGroups == 0){
		$.alert("请至少选择一个用户组");
		return;
	}
	var groups = new Array();
	$("input[name='unconGroupcheck']:checked").each(function(){
		groups.push($(this).val());
	});
	var userId = $("#add_model_user_id").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userManager/addUserGroup"
		,data: {
			userId:userId,
			groups : groups.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("用户组添加成功");
			getConnectUserGroup('','2');
			$("#editUserGroup").modal("hide");
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
			$.msg("添加用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}
</script>
</HEAD>
<BODY>
	<div class="page-container">
		<!--begin search , add ,batchDelete  -->
		<div class="cl pd-5 bg-1 bk-gray" style="margin-top: 14px; margin-bottom: 14px;">
			<span class="1" style="margin-left:10px; ">
				<input type="text" value='${parameterMap.userid}' class="input-text radius" style="width: 130px; height: 32px;" id="userid" name="userid" placeholder="用户ID">
				<input type="text" value='${parameterMap.username}' class="input-text radius" style="width: 130px; height: 32px;" id="username" name="username" placeholder="用户名">
				
				<select name="cityid" id='cityid' class="input-sm" placeholder="城市" style="height: 32px;line-height:32px;">
					<option value="">选择城市</option> 
					<#list arealist as city>
						<option value="${city.area_id}">${city.area_name}</option> 
					</#list>
				</select>
				<button type="button" onclick="findBy_()" class="btn btn-info radius btn-sm" style="margin-bottom: 5px;">
					<span class="glyphicon glyphicon-search"></span>搜索
				</button>
			</span>
			<span class="l" style="float: right;margin-right: 40px;"> 
					<button type="button" class="btn btn-info btn-sm" name="all" onclick="deleteAll()" style="display:none;" power_code="user_user_bachdel">
						<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>批量删除
					</button>
					<button class="btn btn-info btn-sm" data-toggle="modal" data-target="#createUser" onclick="save_()" style="display:none;" power_code="user_user_add">
						<span class="glyphicon glyphicon-plus"></span>添加用户
					</button>
			</span> 
			
		</div>
		<!--end search , add ,batchDelete -->
		<script type="text/javascript">
	  		$("[name='cityid']").find("[value='${parameterMap.cityid}']").attr("selected",true);
	 	</script>
		<!-- start list userinfo -->
		<table class="table table-border table-bordered table-hover table-bg" id="UserTable">
			<thead>
				<tr>
					<th scope="col" colspan="10">用户列表</th>
				</tr>
				<tr class="text-c">
					<th width="4%"><input type="checkbox" id="SelectAl"></th>
					<th width="11%">用户ID</th>
					<th width="10%">用户名</th>
					<th width="5%">地市</th>
					<!--th width="130">状态</th-->
					<th width="10%">电话</th>
					<th width="20%">邮箱</th>
					<th width="20%">可视地市</th>
					<th width="20%" style="min-width: 146px;">操作</th>
				</tr>
			</thead>
			<tbody id="tby">
				<#list list as UserBean>
				<tr class="text-c">
					<td><input type="checkbox" id="subcheck_${UserBean.userid!''}" name="subcheck" value="${UserBean.userid!''}">
					</td>
					<td>${UserBean.userid!''}</td>
					<td>${UserBean.username!''}</td>
					<td>${UserBean.area_name!''}</td>
					<!--td> ${UserBean.status!''}</td-->
					<td>${UserBean.mobilephone!''}</td>
					<td>${UserBean.email!''}</td>
					<td id="${UserBean.userid!''}_vistarea">${UserBean.visit_area!''}</td>
					<td>
						<button title="修改" class="btn btn-sm size-S btn-info radius" data-toggle="modal" data-backdrop="static" id="_update" onclick="update_('${UserBean.userid!''}','${UserBean.username!''}','${UserBean.cityid!''}','${UserBean.status!''}','${UserBean.mobilephone!''}','${UserBean.email!''}','${UserBean.createtime!''}') " data-target="#update" style="display:none;" power_code="user_user_edit">
							<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
						</button>
						<button title="删除" type="button" class="btn btn-sm btn-info size-S radius" onclick="delUser('${UserBean.userid}')" style="display:none;" power_code="user_user_del">
							<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
						</button>
						<button title="修改可视地市" data-toggle="modal" type="button" class="btn btn-sm btn-info size-S radius" onclick="checkedArea('${UserBean.userid}')" data-target="#visit_area" id="${UserBean.userid}_areas" style="display:none;" power_code="user_vistcity_edit">
							<span class="glyphicon glyphicon-list" aria-hidden="true"></span>
						</button>
						<button title="编辑用户角色" data-toggle="modal" type="button" class="btn btn-sm btn-info size-S radius" onclick="getRolesByUserId('${UserBean.userid}')" data-target="#addRoleGroup" id="">
							<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
						</button>
						<button title="编辑用户组" data-toggle="modal" type="button" class="btn btn-sm btn-info size-S radius" onclick="getConnectUserGroup('${UserBean.userid}', '1')" data-target="#addUserGroup" id="">
							<span class="glyphicon glyphicon-user"><span class="glyphicon glyphicon-user"></span></span>
						</button>
					</td>
				</tr>
				</#list>
			</tbody>
		</table>
	</div>
	<!-- 显示分页 -->
	<div class="changePage">
		<div class="snPages"><#assign parameterMap = {} /> <@pager pager = param baseUrl = "userManage" parameterMap = parameterMap /></div>
	</div>
	<!--修改-->
	<div class="modal fade" id="update" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">修改用户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" action="save" id="from2" method="POST" role="form">
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">用户编号：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="d_userid" id="d_userid" value="" class="form-control" type="text" readonly="true">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">用户中文名：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="d_username" id="d_username" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">地市：</label>
							<div class="col-xs-8 col-sm-7">
								<select name="d_cityid" id="d_cityid" class="form-control" style="width: 100%;"> <#list arealist as city>
									<option value="${city.area_id}">${city.area_name}</option> </#list>
								</select>
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">状态：</label>
							<div class="col-xs-8 col-sm-7">
								<select name="d_status" id="d_status" class="form-control" style="width: 100%;">
									<option value="0">关闭</option>
									<option value="1">启用</option>
								</select>
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">电话：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="d_mobilephone" id="d_mobilephone" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">邮箱：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="d_email" id="d_email" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<!--
          				<label class="col-sm-4 col-xs-7 control-label" for="input01">创建时间：</label>
          				-->
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_createtime" id="c_createtime" value="" class="form-control" type="hidden" readonly="true">
							</div>
						</div>
						<div class="form-group" style="">
							<label class="col-sm-4 col-xs-7 control-label"></label>
							<!-- Button -->
							<div class="col-xs-8 col-sm-7">
								<input type="submit" class="btn btn-info btn-sm" id="btn_sub1" onclick="btn_save()" value="提交" /> <input type="reset" class="btn btn-default btn-sm" data-dismiss="modal" value="关闭" />
							</div>
						</div>
					</form>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--添加用户b-->
	<div class="modal fade" id="createUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加用户</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					<form class="form-horizontal" action="addUser" id="from2" method="POST" onsubmit="return validate()" role="form">
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">用户编号：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_userid" id="c_userid" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">用户中文名：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_username" id="c_username" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">地市：</label>
							<div class="col-xs-8 col-sm-7">
								<select name="c_cityid" id="c_cityid" class="form-control" style="width: 100%;"> <#list arealist as city>
									<option value="${city.area_id}">${city.area_name}</option> </#list>
								</select>
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">状态：</label>
							<div class="col-xs-8 col-sm-7">
								<select name="c_status" id="c_status" class="form-control" style="width: 100%;">
									<option value="0">关闭</option>
									<option value="1">启用</option>
								</select>
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">电话：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_mobilephone" id="c_mobilephone" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="">
							<!-- Text input-->
							<label class="col-sm-4 col-xs-7 control-label" for="input01">邮箱：</label>
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_email" id="c_email" value="" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group" style="width: 60%">
							<!-- Text input-->
							<!--
          				<label class="col-sm-4 col-xs-7 control-label" for="input01">创建时间：</label>
          				-->
							<div class="col-xs-8 col-sm-7">
								<input placeholder="" name="c_createtime" id="c_createtime" value="" class="form-control" type="hidden" readonly="true">
							</div>
						</div>
						<div class="form-group" style="">
							<label class="col-sm-4 col-xs-7 control-label"></label>
							<!-- Button -->
							<div class="col-xs-8 col-sm-7">
								<input type="submit" class="btn btn-info btn-sm" id="btn_sub1" onclick="btn_save()" value="提交" /> <input type="reset" class="btn btn-info btn-sm" data-dismiss="modal" value="关闭" />
							</div>
						</div>
					</form>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--修改visit_area-->
	<div class="modal fade" id="visit_area" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加可视地市</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					<div style="height: 300px; overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align: center;" id="areaTable">
							<thead>
								<tr class="text-c" style="text-align: center; background-color: #F5FAFE">
									<th width="20%" style="text-align: center;"><input type="hidden" id="visitAreaUserId">勾选地市</th>
									<th width="40%" style="text-align: center;">地市编号</th>
									<th width="40%" style="text-align: center;">地市名称</th>
								</tr>
							</thead>
							<tbody style="font-size: 12px; text-align: center;" id="areaBody">
								<#list arealist as city>
								<tr class="text-c">
									<td><input type="checkbox" id="" name="areaNamech" value="${city.area_name}">
									</td>
									<td>${city.area_id}</td>
									<td>${city.area_name}</td>
								</tr>
								</#list>
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" id="addVisitArea" onclick="updateVisitarea()" data-dismiss="modal">提交</button>
					<button type="button" class="btn btn-default btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div> 
	
	<!--addRoleGroup begin-->
	<div class="modal fade" id="addRoleGroup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">编辑角色</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					
					<div style="height:307px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="editRoleTab">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input id="mGroupName" name='mGroupName'  type="checkbox"><input id='addRoleGroupUid'  type="hidden"></th>
									<th width="30%" style="text-align:center;">用户ID</th>
									<th width="30%" style="text-align:center;">角色名称</th>
								</tr>								
							</thead>
							<tbody id="roleGroupList" style="font-size: 12px;text-align:center;">
								
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" id="optenRoleModel" class="btn btn-info btn-sm" data-target="#selectRoleGroup" style="display:none;" power_code="user_role_add">添加角色</button>
					<button type="button" class="btn btn-info btn-sm" id="deleteUserRole" onclick="deleteRoleGroups()" style="display:none;" power_code="user_role_del">删除角色</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--addRoleGroup end-->
	
	
	<!--selectRoleGroup begin-->
	<div class="modal fade" id="selectRoleGroup" tabindex="1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加角色</h4>
				</div>
				<div class="modal-body" style="width: 95%">
					<div >
						<table>
							<tr>
								<td style="padding-left: 6%; padding-right: 4%;">
									<div class="form-group">
										<input class="input-sm" type="text" name="selectRoleName" id="selectRoleName" value="" placeholder="请输入角色名称">										
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="selectRoleGroupInp" class="btn btn-info btn-sm" onclick="getRoleGroupByParam()" type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:300px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addRoleTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="selectRoleCb"></th>
									<th width="30%" style="text-align:center;">角色名称</th>
									<th width="30%" style="text-align:center;">创建时间</th>
								</tr>								
							</thead>
							<tbody id="selectRoleGroupList" style="font-size: 12px;text-align:center;">
								
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="bachAddRoleGroup()">提交</button>
					<button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--selectRoleGroup end-->
	
	<!--addUserGroup begin-->
	<div class="modal fade" id="addUserGroup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">编辑用户组</h4>
				</div>
				<div class="modal-body">
					<div >
						<table>
							<tr>
								<td style="padding-left: 3%; padding-right: 6%;">
									<div class="form-group">
										<input  type="hidden" name="add_model_user_id" id="add_model_user_id" value="">
										<input class="input-sm" type="text" name="add_model_group_name" id="add_model_group_name" value="" placeholder="请输入用户组名称">										
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="searchUserGroup" class="btn btn-info btn-sm" onclick="getConnectUserGroup('','2')" type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:270px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="allxq">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"></th>
									<th width="50%" style="text-align:center;">用户组名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>								
							</thead>
							<tbody id="userGroupList" style="font-size: 12px;text-align:center;">
								
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button"  class="btn btn-info btn-sm" id="addUserGroupButton" onclick="getUnconnectUserGroup('1')" style="display:none;" power_code="user_ug_add">添加用户组</button>
					<button type="button" class="btn btn-info btn-sm" id="delUserGroupButton" onclick="delUserGroup()" style="display:none;" power_code="user_ug_del">删除用户组</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!--addUserGroup end-->
	
	<!--添加用户组开始-->
	<div class="modal fade" id="editUserGroup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
										<input class="input-sm" type="text" name="edit_model_group_name" id="edit_model_group_name" placeholder="用户组名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="addGroup" class="btn btn-info btn-sm" onclick="getUnconnectUserGroup('2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addGroupTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"></th>
									<th width="50%" style="text-align:center;">用户组名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>
							</thead>
							<tbody id="editUserGroupList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="addGroup()">提交</button>
					<button type="button" class="btn btn-default btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--添加用户组-->
	
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
			<li><a href="${baseUrl + " pageNumber=" + (pageNumber - 2) }">...</a></li> </#if> 
			<#list startPageNumber .. endPageNumber as index> <#if pageNumber != index> <li> <a  href="${baseUrl + "pageNumber=" + index }" >${index}</a> </li> <#else> <li class="currentPage"> <span style='background-color: #03FDFD;'>${index}</span> </li> </#if> </#list> 
			<#if (endPageNumber < pageCount)>
			<li><a href="${baseUrl + " pageNumber=" + (pageNumber + 2) }">...</a></li> </#if> <#-- 下一页 --> <#if (pageNumber < pageCount)>
			<li class="nextPage"><a href="${nextPageUrl}">下一页</a></li> <#else>
			<li class="nextPage"><span>下一页</span></li> </#if> <#-- 末页 --> <#if (pageNumber < pageCount)>
			<li class="lastPage"><a href="${lastPageUrl}">末页</a></li> <#else>
			<li class="lastPage"><span>末页</span></li> </#if>
		</ul>
	</div>
	</#if> </#macro>
</BODY>

<script type="text/javascript">
$(function(){
	$("#optenRoleModel").click(function(){
		$("#selectRoleName").val('');
		$("#selectRoleGroup").modal("show");
		getRoleGroupByParam();
	});

	$("#editRoleTab thead th input:checkbox").on("click" , function(){
		$("#editRoleTab").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#editRoleTab thead th input:checkbox").prop("checked"));
    });
    $("#addRoleTable thead th input:checkbox").on("click" , function(){
		$("#addRoleTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#addRoleTable thead th input:checkbox").prop("checked"));
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
