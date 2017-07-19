<!DOCTYPE html>
<HTML>
<HEAD>
<#include "../top.ftl">
<style>
.checkbox-inline {
  display: inline-block;
  padding-left: 0px;
  margin-bottom: 20;
  font-weight: 400;
  vertical-align: middle;
  cursor: pointer;
}

input[type='text']{
 width:100%;
}

.my_mar{
	margin-left: 3%;
    margin-right: 3%;
}

button{
	    padding: 4px 5px;
}
</style>
<script type="text/javascript">
var zTreeMenuManage=null;
var powerMap = ${power};
var allRightFlag ='${allRightFlag}';
function menuTreeConfig()
{
	var setting = {
		view: {
			selectedMulti: false //设置设置不允许同时选中多个节点
		},
		edit: {
			enable: true,//设置为编辑状态
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
			beforeDrag: beforeDrag,
			beforeRename: beforeRename,
			onRename: onRename,
			onRemove: onRemove,
			onClick: onClickMenu
		}
	}
	return setting;
};


function createMenuNodes(data)
{
  var zNodes=[];
  var json = eval(data);
     for (var i = 0; i < json.length; i++) {
        var MENUITEMID;
        var MENUITEMTITLE;
        var PARENTID;
        for (var key in json[i]) {
           if(key=="treenodeid")
           {
                MENUITEMID=json[i][key];
           }else if(key=="treenodename")
           {
               MENUITEMTITLE=json[i][key];
           }else if(key=="treenodepid")
           {
               PARENTID=json[i][key];
           }
         }
         zNodes.push({id:MENUITEMID, pId:PARENTID, name:MENUITEMTITLE,t:MENUITEMTITLE});
      }
      return zNodes;
}

var setting = menuTreeConfig();
$.ajax({
	type: "POST"
	,url: "${mvcPath}/userTreeManage/treeUser"
	,data: {}
	,dataType : "json"
	,success: function(data){
	        if(data==null)return;
	        var zNodes=createMenuNodes(data);
            $(document).ready(function(){
			$.fn.zTree.init($("#treeDemoMenu"), setting, zNodes);
			zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
			$("#addUser").bind("click",add);
			$("#edit").bind("click", edit);
			$("#remove").bind("click", remove);
		});

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
             $.msg("加载用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 }
	});

function beforeDrag(treeId, treeNodes) {
	return false;
}

function beforeRemove(treeId, treeNode) {
   if(!(treeNode.children==undefined||treeNode.children==0))
    {
      $.alert("请先删除子用户组");
      return false;
    }
	
}

function onRemove(e, treeId, treeNode) {
	delMenu(treeNode.id)
}

function beforeRename(treeId, treeNode, newName) {
	if (newName.length == 0) {
		$.alert("用户组名称不能为空.");
		setTimeout(function(){zTreeMenuManage.editName(treeNode)}, 10);
		return false;
	}
	return true;
};

function onRename(event, treeId, treeNode)
{ 
   	var menuItemId=treeNode.id;
    var menuItemTitle=treeNode.name;
    var parentId=treeNode.pId;
    
    updateNewMenu(menuItemId,menuItemTitle,parentId);
}

function delMenu(menuItemId)
{
    $.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/deleteMenu"
		,data: {treenodeid:menuItemId}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==false)return;
		        setValues('','',1,'0','','','','0','999');
		        $.alert('用户组删除成功');
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
           $.msg("删除用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function createNewMenu(menuItemId,menuItemTitle,parentId,ctreatime,action)
{	
    if(null==parentId) parentId=1;
   setValues(menuItemId,menuItemTitle,parentId,'0',ctreatime,'',
	'','0','999');
	$("#detailform").attr("action",action);
}
function createNewMenuId()
{
  var res;
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/newTreeNodeId"
		,data: {}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
		        res= eval(data);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	              $.msg("新增用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
	return res;
};

function add() {
	$("[power_code='ug_ug_add']").css("display","");
	nodes = zTreeMenuManage.getSelectedNodes();
	treeNode = nodes[0];
    var newCount= createNewMenuId();
	var parentId=1;
	if (treeNode) {
		parentId=treeNode.id;
		treeNode = zTreeMenuManage.addNodes(treeNode, {id:newCount, pId:treeNode.id,  name:"node"+newCount});
	} else {
		treeNode = zTreeMenuManage.addNodes(null, {id:newCount, pId:'1', name:"node"+newCount});
		parentId=1;
	}
	var menuItemId=newCount;
    var menuItemTitle="node"+newCount;
    var ctreatime = formatDate(new Date(),'yyyy-MM-dd');
    createNewMenu(menuItemId,menuItemTitle,parentId,ctreatime,'inserUserGroup');
};

function edit() {
	nodes = zTreeMenuManage.getSelectedNodes(),
	treeNode = nodes[0];
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		return;
	}
	zTreeMenuManage.editName(treeNode);
};

function remove(e) {
	nodes = zTreeMenuManage.getSelectedNodes(),
	treeNode = nodes[0];
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		return;
	}
	
	 if(!(treeNode.children==undefined||treeNode.children==0))
    {
      $.alert("请先删除子用户组");
      return false;
    }
	
	$.confirm("确认删除用户组 " + treeNode.name + "吗？",function(index){
		$.close(index);
		zTreeMenuManage.removeNode(treeNode, true);
	});
};

function onClickMenu(event, treeId, treeNode, clickFlag)
{	

	$.ajax({
	type: "POST"
	,url: "${mvcPath}/userTreeManage/detailMenuNode"
	,data: {menuId:treeNode.id}
	,dataType : "json"
	,success: function(data){
	        if(data.menuitemid!='error')
	        {
	        	setValues(data.group_id,data.group_name,data.parent_id,data.status,data.create_time,data.begin_date,
						data.end_date,data.user_limit,data.sortnum);
				$("#detailform").attr("action",'updateUserGroup');
			}
			var rightflag = true;
			for(var i=0;i<powerMap.length;i++){
				if(powerMap.power_code=='ug_ug_edit'){
					rightflag = false;
					break;
				}
			}
			if(allRightFlag!='YES'&&rightflag){
				$("[power_code='ug_ug_edit']").css("display","none");
			}
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           $.msg("加载用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 }
	});
}

function updateNewMenu(menuItemId,menuItemTitle,parentId){
	$.ajax({
	type: "POST"
	,url: "${mvcPath}/userTreeManage/updateNewMenu"
	,data: {menuId:menuItemId,menuname:menuItemTitle}
	,dataType : "json"
	,success: function(data){
	        if(data.flag==false) return;
	        $("#groupname").val(menuItemTitle);
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           $.msg("更新用户组名失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 }
	});
}


function init()
{
   
}

function setValues(groupid,groupname,parentid,status,createtime,begindate,
	enddate,userlimit,sortnum){
;	$("#groupid").val(groupid);
	$("#groupname").val(groupname);
	$("#createtime").val(createtime);
	$("#startdate").val(begindate);
	$("#enddate").val(enddate);
	$("#userlimit").val(userlimit);
	$("#sortnum").val(sortnum);
	initMenuModify(status,parentid);
	
	
}
function removeMenuModify(status,parentid){
	$("#status option").removeAttr("selected");
    $("#parentid option").removeAttr("selected");
};
function initMenuModify(status,parentid){
	obj1 = document.getElementById("status");
	obj3 = document.getElementById("parentid");
	fun(obj1,status);
	fun(obj3,parentid);
};
function fun(obj,str){
	for(i=0;i<obj.length;i++){
		if(obj[i].value==str)
			obj[i].selected = true;
	}
}

//格式化日期,
      function formatDate(date,format){
        var paddNum = function(num){
          num += "";
          return num.replace(/^(\d)$/,"0$1");
        }
        //指定格式字符
        var cfg = {
           yyyy : date.getFullYear() //年 : 4位
          ,yy : date.getFullYear().toString().substring(2)//年 : 2位
          ,M  : date.getMonth() + 1  //月 : 如果1位的时候不补0
          ,MM : paddNum(date.getMonth() + 1) //月 : 如果1位的时候补0
          ,d  : date.getDate()   //日 : 如果1位的时候不补0
          ,dd : paddNum(date.getDate())//日 : 如果1位的时候补0
          ,hh : date.getHours()  //时
          ,mm : date.getMinutes() //分
          ,ss : date.getSeconds() //秒
        }
        format || (format = "yyyy-MM-dd hh:mm:ss");
        return format.replace(/([a-z])(\1)*/ig,function(m){return cfg[m];});
      }

/**获得被选中的用户组**/
function selectUserByGroupId(){
	nodes = zTreeMenuManage.getSelectedNodes(),
	treeNode = nodes[0];
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		return;
	}
	var groupid = treeNode.id;
	$("#connectGroupId").val(groupid);
	$("#connectUserId").val("");
	$("#connectUserName").val("");
	$("#groupUser").empty();
	$("#connectUserModel").modal("show");  
	selectRoleUsers();
}

/**根据id，获得该Id下的所有复选框的值**/
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

/**查询该用户组下所有的用户**/
function selectRoleUsers(){
	var groupid=$("#connectGroupId").val();
	var userid=$("#connectUserId").val();
	var username=$("#connectUserName").val();
	var cityid=$("#c_city_id").val();
	getUserInfobyParam(groupid,userid,username,cityid);
}


function getUserInfobyParam(groupid,userid,username,cityid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/getUserInfobyGroupId"
		,data: {groupid:groupid,userid:userid,username:username,cityid:cityid}
		,async: false
		,dataType : "json"
		,success: function(data){
			$("#qryUserCb").attr("checked", false);
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
	    	 $("#groupUser").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/**根据条件查询用户**/
function searchusers(){
	var groupid=$("#connectGroupId").val();
	var userid = $("#user_id").val();
	var username =$("#user_name").val();
	var cityid = $("#city_id").val();
	if(groupid==''){
		$.alert("请选择用户组");
		return;
	}
	getUserInfo(groupid,userid,username,cityid);
}

function getUserInfo(groupid,userid,username,cityid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/getUserInfo"
		,data: {groupid:groupid,userid:userid,username:username,cityid:cityid}
		,async: false
		,dataType : "json"
		,success: function(data){
			$("#addUserCheck").attr("checked",false);
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
	    	 $("#alluser").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};

/**添加用户**/
function addusers(){
	var groupid = $("#connectGroupId").val();
	var userids = getAllIds("alluser");
	if(userids==''){
		$.alert("请勾选用户");
		return;
	}
	addUsersByids(groupid,userids);
}

function addUsersByids(groupid,userids){

	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/addUsers"
		,data: {groupid:groupid,userids:userids}
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
	    		 	  + "<td>"+cell.area_name+"</td>"
	    		 	  +	"</tr>";
	    	 }
	    	 $("#groupUser").html(html);
	    	 $.alert("添加完成！！");
	    	 $("#addGroupUserModel").modal("hide");  
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});

}


/**批量删除角色所关联的用户**/
function deleteConnectUser(){
	var groupid = $("#connectGroupId").val();
	var userids = getAllIds('groupUser');
	if(userids == ''){
		$.alert("请至少选择一个用户!");
		return;
	}
	$.confirm("确定删除所选用户吗?",function(index){
		deleteUser(groupid,userids);
	});
}


function deleteUser(groupid,userids){

	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/deleteUsers"
		,data: {groupid:groupid,userids:userids}
		,async: false
		,dataType : "json"
		,success: function(data){
		     if(data.flag==true){
		     	$.alert("删除成功!!");
		     	deleteUserlist(data.userids);
		     }
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("用户删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}
/**删除用户列表数据**/
function deleteUserlist(data){
	for(var i = 0;i<data.length;i++){
		$("#"+data[i]).remove();
	}
}

function validate(){
	var groupid = $('#groupid').val();
	if(!groupid){
		$.msg("用户组编号不能为空，<br>请先点击新增用户组按钮！", {
			icon : 0,
			time : 5000
		});
		return false;
	}
	
	var groupname = $('#groupname').val();
	if(!groupname){
		$.msg("请输入用户组名称！", {
			icon : 0,
			time : 5000
		});
		$("#groupname").focus();
		return false;
	}
}

function getConnectRole(type){
	var nodes = zTreeMenuManage.getSelectedNodes();
	if (nodes.length == 0) {
		$.alert("请先选择一个用户组");
		return;
	}
	
	if(type == '1'){
		$('#qryRoleName').val('');
		$('#roleSelectGroupId').val(nodes[0].id);
		$("#qryRoleModel").modal("show");
	}
	var roleName = $('#qryRoleName').val();
	var groupId = $('#roleSelectGroupId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/getConnectRole"
		,data: {
			groupId : nodes[0].id,
			roleName : roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#qryRoleSelectAll').attr("checked", false);
		     var roleStr = "";
		     for(var i=0; i<data.length; i++){
		     	roleStr += "<tr>";
		     	roleStr += "<td><input type='checkbox' id='conRolecheck_" + data[i].roleid + "' name='conRolecheck' value='" + data[i].roleid + "'></td>";
		     	roleStr += "<td>" + data[i].rolename + "</td>";
		     	roleStr += "<td>" + data[i].createtime + "</td>";
		     	roleStr += "</tr>";
		     }
		     $('#qryRoleList').html(roleStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getUnConnectRole(type){
	if(type == '1'){
		$("#addRoleName").val('');
		$("#addRoleModel").modal("show");
	}
	var roleName = $('#addRoleName').val();
	var groupId = $('#roleSelectGroupId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/getUnConnectRole"
		,data: {
			groupId : groupId,
			roleName : roleName
		}
		,async: false
		,dataType : "json"
		,success: function(data){
		     data = eval(data);
		     $('#addRoleSelectAll').attr("checked", false);
		     var roleStr = "";
		     for(var i=0; i<data.length; i++){
		     	roleStr += "<tr>";
		     	roleStr += "<td><input type='checkbox' id='uconRolecheck_" + data[i].roleid + "' name='uconRolecheck' value='" + data[i].roleid + "'></td>";
		     	roleStr += "<td>" + data[i].rolename + "</td>";
		     	roleStr += "<td>" + data[i].createtime + "</td>";
		     	roleStr += "</tr>";
		     }
		     $('#addRoleList').html(roleStr);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询角色失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function addRole(){
	var checkedRoles = $("input[name='uconRolecheck']:checked").length;
	if(checkedRoles == 0){
		$.alert("请至少选择一个角色");
		return;
	}
	var roles = new Array();
	$("input[name='uconRolecheck']:checked").each(function(){
		roles.push($(this).val());
	});
	var groupId = $('#roleSelectGroupId').val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userTreeManage/addRole"
		,data: {
			groupId : groupId,
			roles : roles.toString()
		}
		,async: false
		,dataType : "json"
		,success: function(data){
			$.alert("角色添加成功");
			getConnectRole("", "2")
		    $('#addRoleModel').modal("hide");
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("角色添加失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function delRole(){
	var checkedRoles = $("input[name='conRolecheck']:checked").length;
	if(checkedRoles == 0){
		$.alert("请至少选择一个角色");
		return;
	}
	$.confirm("确定删除所选角色吗？",function(index){
		var roles = new Array();
		$("input[name='conRolecheck']:checked").each(function(){
			roles.push($(this).val());
		});
		var groupId = $('#roleSelectGroupId').val();
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/userTreeManage/delRole"
			,data: {
				groupId : groupId,
				roles : roles.toString()
			}
			,async: false
			,dataType : "json"
			,success: function(data){
				$.alert("角色删除成功");
				getConnectRole("", "2")
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
		            $.msg("角色删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
		     }
		});
	});
}

</SCRIPT>
</HEAD>

<BODY onload="init()">
<br/>
<div class="container-fluid" style="height:100%;">
	<div class="row" style="height:10%;">
		<div class="col-md-12" style="margin-bottom: 27px;">
		 	<form class="form-horizontal" >
		     	 <div class="form-group checkbox-inline"  style='display: inline-block;width:30%;'>
        			<!-- Checkbox -->
          		</div>
          		
          		<div class="form-group checkbox-inline" style='display: inline-block;width:70%;'>
					
					
   					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-info btn-sm" id="addUser" onclick="return false;" type="button"  data-toggle="modal" data-target="#myModal" style="display:none;" power_code="ug_ug_add">
     					 <span class="glyphicon glyphicon-plus" style="color: rgb(0, 0, 0);"></span> 新增用户组
     					</button>
  					 </label>
   					<!--<label class="checkbox-inline my_mar">
     					 <button class="btn btn-info" id="edit" onclick="return false;" type="button">
     						<span class="glyphicon glyphicon-edit" style="color: rgb(0, 0, 0);"></span> 编辑用户组
     					 </button>
   					</label>-->
  					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-info btn-sm" id="remove" onclick="return false;" type="button" style="display:none;" power_code="ug_ug_del">
     					 <span class="glyphicon glyphicon-trash" style="color: rgb(0, 0, 0);"></span> 删除用户组
     					 </button>
   					</label>
   					<label class="checkbox-inline my_mar">
     					 <button title="关联用户" type="button" class="btn btn-info btn-sm" data-toggle="modal" data-backdrop="static" onclick="" id="connectUserModelBtn">
							<span class="glyphicon glyphicon-link" style="color: rgb(0, 0, 0);"></span>  关联用户
						</button>
   					</label>
   					<label class="checkbox-inline my_mar">
     					 <button title="关联角色" type="button" class="btn btn-info btn-sm" data-toggle="modal" data-backdrop="static" onclick="getConnectRole('1')" id="connectRoleBtn">
							<span class="glyphicon glyphicon-link" style="color: rgb(0, 0, 0);"></span>  关联角色
						</button>
   					</label>
				</div>
			</form>
		</div>
	</div>

	
	<div class="row"  style="width:100%;height:86%;margin-left: 10px;">
		<div class="col-md-6" style="width:25%;border-style: solid;border-color:#F3F1F1;border-width:1px;margin-right: 1%;height:560px;overflow: auto;" id="menuList">
				<div style="width:100%; height:100%;" id="treeDemoMenu" class="ztree"></div>
		</div>
		<div class="col-md-6" style="width:70%;border-style: solid;border-color:#F3F1F1;border-width:1px;min-height:560px;" id="menuDetail">	
            	<form class="form-horizontal" action="modify" method="POST" id="detailform" role="form" onsubmit="return validate()" style="margin-top: 15px;">
      				<div id="legend" class="" >
       				 	<legend class="" style="padding-left: 180px;width: 100%;">用户组编辑</legend>
       				 	<p class="help-block"></p>
     			 	</div>
					
		
      				<div class="form-group" >
         				 <!-- Text input-->
          				<label class="col-sm-2 control-label" id="groupidname">用户组编号</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="groupid" id='groupid' value="" readonly=true class="form-control" type="text">
         					 <p class="help-block"></p>
         				 </div>
      				</div>
      
       				<div class="form-group">
          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01" id="groupnamename" >用户组名称</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="groupname" id="groupname" value="" class="form-control" type="text">
          					<p class="help-block"></p>
          				</div>
       				</div>
        
      				<div class="form-group">

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label" id="parentidname">父用户组名称</label>
          				<div class="col-sm-4">
            				<select name="parentid" id='parentid' class="form-control" style="width:100%;" value="1">
            				<option value="0">0</option>
               				 <#if smsMenus?exists>
                     			<#list smsMenus as rowMenu>
                     			<option value="${rowMenu[0]!'0'}">${rowMenu[1]!'0'}</option>
                     			</#list>
               				 </#if>
			 				</select>
          					<p class="help-block"></p>
          				</div>
        			</div>

    				<div class="form-group" >

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">显示顺序</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="sortnum"  id='sortnum' value="999" class="form-control" type="text">
         					<p class="help-block"></p>
         				</div>
        			</div>

					<div class="form-group" >

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">创建时间</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="createtime" readonly=true  id='createtime'  class="form-control" type="text"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});">
         					<p class="help-block"></p>
         				</div>
        			</div>
        			
        			<div class="form-group" >

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">开始时间</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="startdate" readonly=true  id='startdate'  class="form-control" type="text"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});">
         					<p class="help-block"></p>
         				</div>
        			</div>
        			
        			<div class="form-group" >

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">结束时间</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="enddate" readonly=true  id='enddate'  class="form-control" type="text"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});">
         					<p class="help-block"></p>
         				</div>
        			</div>
					
      				<div class="form-group" style="display:none;">

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">用户限制数</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="userlimit"  id='userlimit' value="0" class="form-control" type="text">
          					<p class="help-block"></p>
          				</div>
        			</div>
        
      				<div class="form-group" >

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label"  id="urltype">用户组状态</label>
          				<div class="col-sm-4">
            				<select name="status" id='status' readonly=true class="form-control" style="width:100%;" value="0">
                   				<option value="0" id="urltype_1">启用</option>
                   				<option value="1" id="urltype_0">关闭</option>>
			 				</select>
          				</div>
        			</div>
        
          		

    				<div class="form-group">
          				<label class="col-sm-2 control-label"></label>

          				<!-- Button -->
          				<div class="col-sm-4">
            				<input type="submit" class="btn btn-info btn-sm" value="提交" power_code="ug_ug_edit">
            				<input type="reset" class="btn btn-info btn-sm" value="重置">
          				</div>
        			</div>        
  				</form>
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
											<input class="input-sm" type="text" name="connectUserId" id="connectUserId" placeholder="用户编号" value="">
											<input class="input-sm" type="hidden"  id="connectGroupId" value="">
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
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="groupusertab">
							<thead>
								<tr  class="text-c" style="text-align:center;background-color:#F5FAFE;">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="qryUserCb"></th>
									<th width="30%" style="text-align:center;">用户名</th>
									<th width="30%" style="text-align:center;">用户中文名</th>
									<th width="30%" style="text-align:center;">城市</th>
								</tr>							
							</thead>
							<tbody id="groupUser">
													
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" id="connectUserButton" class="btn btn-info btn-sm" style="display:none;" power_code="ug_user_add">添加用户</button>
					<button type="button" class="btn btn-info btn-sm" onclick="deleteConnectUser()" style="display:none;" power_code="ug_user_del">删除用户</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>

<!--用户添加start-->
<div class="modal fade" id="addGroupUserModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					用户信息
				</h4>
			</div>
			<div class="modal-body" >
				<div >
					<table >
									<tr>
									<td>
										<div class="form-group">
											<input class="input-sm" type="text" name="user_id" id="user_id" placeholder="用户编号" value="">
											<input class="input-sm" type="hidden"  id="selected_id" value="">
										</div>
									</td>
										
									<td style="padding-left: 3%; padding-right: 3%;">
										<div class="form-group">
											<input class="input-sm" type="text" name="user_name" id="user_name" value="" placeholder="用户中文名">										
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="city_id" id='city_id' class="input-sm" placeholder="城市" >
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
											<input id="searchusers" class="btn btn-info btn-sm" onclick="searchusers()"  type="button" value="查询">
										</div>
									</td>
									</tr>
									</table>
				</div>
				<div style="height:300px;overflow: auto;">
					<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addUserTable">
					<thead>
						<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
							<th width="10%" style="text-align:center;"><input type="checkbox" id="addUserCheck"></th>
							<th width="30%" style="text-align:center;">用户名</th>
							<th width="30%" style="text-align:center;">用户中文名</th>
							<th width="30%" style="text-align:center;">城市</th>
						</tr>								
					</thead>
					<tbody id="alluser" style="font-size: 12px;text-align:center;">
													
					</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-info btn-sm" onclick="addusers()" id="addusers">提交	</button>
				<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>
<!--用户添加end-->

<!--查询角色开始-->
	<div class="modal fade" id="qryRoleModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">关联角色</h4>
					<input id="roleSelectGroupId" type="hidden" value="">
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="qryGroupName" id="qryRoleName" placeholder="角色名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="searchRole" class="btn btn-info btn-sm" onclick="getConnectRole('2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="qryRoleTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="qryRoleSelectAll"></th>
									<th width="50%" style="text-align:center;">角色名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>
							</thead>
							<tbody id="qryRoleList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm " onclick="getUnConnectRole('1')" style="display:none;" power_code="ug_role_add">添加角色</button>
					<button type="button" class="btn btn-info btn-sm" onclick="delRole()" style="display:none;" power_code="ug_role_del">删除角色</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--查询关联角色-->
	
	<!--添加角色开始-->
	<div class="modal fade" id="addRoleModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">添加角色</h4>
				</div>
				<div class="modal-body" >
					<div>
						<table >
							<tr>
								<td>
									<div class="form-group">
										<input class="input-sm" type="text" name="addRoleName" id="addRoleName" placeholder="角色名称" value="">
									</div>
								</td>
								<td>
									<div class="form-group" style="margin-left: 30px">
										<input id="addGroup" class="btn btn-info btn-sm" onclick="getUnConnectRole('2')"  type="button" value="查询">
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div style="height:262px;overflow: auto;">
						<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="addRoleTable">
							<thead>
								<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
									<th width="10%" style="text-align:center;"><input type="checkbox" id="addRoleSelectAll"></th>
									<th width="50%" style="text-align:center;">角色名称</th>
									<th width="40%" style="text-align:center;">创建时间</th>
								</tr>
							</thead>
							<tbody id="addRoleList" style="font-size: 12px;text-align:center;">
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info btn-sm" onclick="addRole()">提交</button>
					<button type="button" class="btn btn-info btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
	</div>
	<!--添加角色结束-->

<script type="text/javascript">
 $(function(){  
       $("#connectUserModelBtn").click(function(){  
               selectUserByGroupId(); 
         });
       $("#connectUserButton").click(function(){
       			$("#user_id").val("");
				$("#user_name").val("");
				$("#city_id").val("");  
                $("#alluser").empty();
                $("#addGroupUserModel").modal("show");  
        });  
        
     /*添加角色全选*/
	$("#addRoleTable thead th input:checkbox").on("click" , function(){
		$("#addRoleTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#addRoleTable thead th input:checkbox").prop("checked"));
    });
    
    /*查询角色全选*/
	$("#qryRoleTable thead th input:checkbox").on("click" , function(){
		$("#qryRoleTable").closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("#qryRoleTable thead th input:checkbox").prop("checked"));
    });
    
     /*添加用户全选*/
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
</BODY>
</HTML>