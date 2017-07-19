<!DOCTYPE html>
<HTML>
<HEAD>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<meta name="keywords" content="">
<meta name="description" content="">
<link rel="stylesheet" href="${mvcPath}/hb-power/common/ztree/zTreeStyle.css" type="text/css">
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<!--<link href="${mvcPath}/hb-bass-frame/css/H-ui.min.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/H-ui.admin.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/style.css" rel="stylesheet" type="text/css" />-->
<link href="${mvcPath}/resources/lib/fullcalendar-2.9.1/fullcalendar.min.css" rel="stylesheet" type="text/css" />
<style>
.checkbox-inline {
  display: inline-block;
  padding-left: 20px;
  margin-bottom: 20;
  font-weight: 400;
  vertical-align: middle;
  cursor: pointer;
}

input[type='text']{
 width:100%;
}

.my_mar{
	margin-left: 5%;
    margin-right: 5%;
}

</style>
<!--[if IE 7]>
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
<script>DD_belatedPNG.fix('*');</script>
<![endif]-->
<!--[if lt IE 9]>
<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
<![endif]-->
<script type="text/javascript" src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/Validform_v5.3.2.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/fullcalendar-2.9.1/lib/moment.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/fullcalendar-2.9.1/fullcalendar.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/fullcalendar-2.9.1/lang/zh-cn.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/layer2.1/layer.min.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.doc.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
var zTreeMenuManage=null;
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
			//beforeDrag: beforeDrag,
			//beforeRename: beforeRename,
			//onRename: onRename,
			//onRemove: onRemove,
			onCheck:emptyuser
		},
		check:{
			chkStyle: "radio",
			enable: true,
			radioType: "all"
		}
	}
	return setting;
};


function emptyuser(){
	 $("#groupUser").html('');	
}

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
			$("#select").bind("click",selectUserByGroupId);
			$("#add").bind("click", addAllUser);
			$("#remove").bind("click", remove);
			$("#addusers").bind("click",addusers);
			$("#searchusers").bind("click",searchusers);
			
		});

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
             $.msg("加载用户组失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 }
	});

function selectUserByGroupId(){
	nodes = zTreeMenuManage.getCheckedNodes(true);
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	treeNode = nodes[0];
	var groupid = treeNode.id;
	getUserInfobyGroupId(groupid);
}


function searchusers(){
	var groupid=$("#selected_id").val();
	var userid = $("#user_id").val();
	var username =$("#user_name").val();
	var cityid = $("#city_id").val();
	if(groupid==''){
		$.alert("请选择用户组");
		return;
	}
	getUserInfo(groupid,userid,username,cityid);
}

function addAllUser(){
	
	nodes = zTreeMenuManage.getCheckedNodes(true);
	var groupid ='';
	if (nodes.length != 0) {
		treeNode = nodes[0];
		groupid = treeNode.id;
	}
	$("#selected_id").val(groupid);
	$("#alluser").html('');		
}

function getUserInfobyGroupId(groupid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/getUserInfobyGroupId"
		,data: {groupid:groupid}
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
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};


function getUserInfo(groupid,userid,username,cityid){
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userGroupMap/getUserInfo"
		,data: {groupid:groupid,userid:userid,username:username,cityid:cityid}
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
	    	 $("#alluser").html(html);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
};


function addusers(){
	var groupid = $("#selected_id").val();
	var userids = getuserids("alluser");
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
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("查询用户失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});

}

function remove(){
	nodes = zTreeMenuManage.getCheckedNodes(true);
	if (nodes.length == 0) {
		$.alert("请先选择一个用户组");
		return;
	}
	treeNode = nodes[0];
	var groupid = treeNode.id;
	var userids = getuserids("groupUser");
	if(userids==""){
	  $.alert("请选择一个用户组");
		return;
	}
	if(confirm("确定删除吗?")){
	  deleteUser(groupid,userids);
	}
	
	
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
		     	deleteUserlist(data.userids);
		     }
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	            $.msg("用户删除失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
	     }
	});
}

function getuserids(id){
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

function deleteUserlist(data){
	for(var i = 0;i<data.length;i++){
		$("#"+data[i]).remove();
	}
}

function init()
{
   
}


</SCRIPT>
</HEAD>

<BODY onload="init()" >
<br/>
<div class="container-fluid" style="height:100%;">
	<div class="row" style="height:10%;">
		<div class="col-md-12" style="margin-bottom: 27px;">
		 	<form class="form-horizontal" >
		     	 <div class="form-group checkbox-inline"  style='display: inline-block;width:33%;'>
        			<!-- Checkbox -->
          		</div>
          		
          		<div class="form-group checkbox-inline" style='display: inline-block;width:67%;'>
					
					
   					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-info" id="select" onclick="return false;" type="button">
     					 <span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询用户
     					 </button>
  					 </label>
   					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-info" id="add" onclick="return false;" type="button" data-toggle="modal" data-target="#myModal" >
     					 <span class="glyphicon glyphicon-plus" style="color: rgb(0, 0, 0);"></span> 添加用户
     					</button>
   					</label>
  					<label class="checkbox-inline my_mar">
     					  <button class="btn btn-info" id="remove" onclick="return false;" type="button">
     						 <span class="glyphicon glyphicon-trash" style="color: rgb(0, 0, 0);"></span> 删除用户
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
		<div class="col-md-6" style="width:70%;border-style: solid;border-color:#F3F1F1;border-width:0px;height:560px;overflow:auto;" id="menuDetail">	
            	<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="groupusertab">
					<thead>
						<tr  class="text-c" style="text-align:center;background-color:#F5FAFE;">
							<th width="10%" style="text-align:center;"><input type="checkbox"></th>
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
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
											<input id="searchusers" class="btn btn-info btn-sm"  type="button" value="查询">
										</div>
									</td>
									</tr>
									</table>
				</div>
				<div style="height:450px;overflow: auto;">
					<table class="table table-border table-bordered table-hover table-bg" style="text-align:center;" id="allxq">
					<thead>
						<tr class="text-c" style="text-align:center;background-color:#F5FAFE">
							<th width="10%" style="text-align:center;"><input type="checkbox"></th>
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
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭
				</button>
				<button type="button" class="btn btn-info" id="addusers" >
					提交
				</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>



<script type="text/javascript">
	
</script>
</BODY>
</HTML>