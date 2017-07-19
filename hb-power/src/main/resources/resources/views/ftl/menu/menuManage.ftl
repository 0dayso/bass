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
<!--<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.doc.js"></script>-->
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript">
var zTreeMenuManage=null;
var tableName = "${tableType}";
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
			beforeRemove: beforeRemove,
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
           if(key=="menuitemid")
           {
                MENUITEMID=json[i][key];
           }else if(key=="menuitemtitle")
           {
               MENUITEMTITLE=json[i][key];
           }else if(key=="parentid")
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
	,url: "${mvcPath}/menuManage/tableMenu"
	,data: {tableName:tableName}
	,dataType : "json"
	,success: function(data){
	        if(data==null)return;
	        var zNodes=createMenuNodes(data);
            $(document).ready(function(){
			$.fn.zTree.init($("#treeDemoMenu"), setting, zNodes);
			zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
			$("#addNode").bind("click", add);
			$("#edit").bind("click", edit);
			$("#remove").bind("click", remove);
			$("#selectMenu").bind("click", select);
			
		});

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
          $.msg("加载菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
 }
	});

function beforeDrag(treeId, treeNodes) {
	return false;
}

function beforeRemove(treeId, treeNode) {
    if(!(treeNode.children==undefined||treeNode.children==0))
    {
      $.alert("请先删除子菜单");
      return false;
    }
}

function onRemove(e, treeId, treeNode) {
	delMenu(treeNode.id)
}

function beforeRename(treeId, treeNode, newName) {
	if (newName.length == 0) {
		$.alert("菜单名称不能为空.");
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
    
    createNewMenu(menuItemId,menuItemTitle,parentId);
}

function delMenu(menuItemId)
{
    $.ajax({
		type: "POST"
		,url: "${mvcPath}/menuManage/deleteMenu"
		,data: {menuItemId:menuItemId,tableName:tableName}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
		        setValues(tableName,'','',0,'','', '',1,0,'N','N','N','Y');
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	           $.msg("删除菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});

	     }
	});
}

function createNewMenu(menuItemId,menuItemTitle,parentId)
{	
    if(null==parentId)parentId=0;
   	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuManage/newMenuOrUpdateTitle"
		,data: {menuItemId:menuItemId,menuItemTitle:menuItemTitle,parentId:parentId,tableName:tableName}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
	     		$("#detailform").attr("action",data.action);
		        setValues(data.tableName,data.menuitemid,data.menuitemtitle,
	        data.parentid,data.sortnum,data.iconurl, data.url,data.state,
	        data.menutype,data.poweradd,data.powerdel,data.poweredi,data.powersel);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	         $.msg("添加菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});

	     }
	});
}
function createNewMenuId()
{
  var res;
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/menuManage/newTreeNodeId"
		,data: {tableName:tableName}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
		        res= eval(data);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	   $.msg("添加菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});

	     }
	});
	return res;
};

function add() {
    var newCount= createNewMenuId();
	nodes = zTreeMenuManage.getSelectedNodes();
	treeNode = nodes[0];
	var parentId=0;
	if (treeNode) {
		parentId=treeNode.id;
		treeNode = zTreeMenuManage.addNodes(treeNode, {id:newCount, pId:treeNode.id,  name:"node"+newCount});
	} else {
		treeNode = zTreeMenuManage.addNodes(null, {id:newCount, pId:0, name:"node"+newCount});
		parentId=0;
	}
	var menuItemId=newCount;
    var menuItemTitle="node"+newCount;
    createNewMenu(menuItemId,menuItemTitle,parentId);
};

function edit() {
	nodes = zTreeMenuManage.getSelectedNodes(),
	treeNode = nodes[0];
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	zTreeMenuManage.editName(treeNode);
};

function remove(e) {
	nodes = zTreeMenuManage.getSelectedNodes(),
	treeNode = nodes[0];
	if (nodes.length == 0) {
		$.alert("请先选择一个菜单");
		return;
	}
	
	 if(!(treeNode.children==undefined||treeNode.children==0))
    {
      $.alert("请先删除子菜单");
      return false;
    }
	
	$.confirm("确认删除 菜单  " + treeNode.name + "吗？",function(index){
		$.close(index);
		zTreeMenuManage.removeNode(treeNode, true);
	});
	
};

function onClickMenu(event, treeId, treeNode, clickFlag)
{
	$.ajax({
	type: "POST"
	,url: "${mvcPath}/menuManage/detailMenu?menuId="+treeNode.id+"&tableName="+tableName
	,data: {}
	,dataType : "json"
	,success: function(data){
	        if(data.menuitemid!='error')
	        setValues(data.tableName,data.menuitemid,data.menuitemtitle,
	        data.parentid,data.sortnum,data.iconurl, data.url,data.state,
	        data.menutype,data.poweradd,data.powerdel,data.poweredi,data.powersel);

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
        $.msg("加载菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});

 }
	});
}

function select(){
	tableName = $("#systemName").val();
	window.location.href="${mvcPath}/menuManage/treeManage?tableName="+tableName;
	
}
function init()
{
   
}

function setValues(tableName,menuId,menuItemTitle,
	parentId,sortNum,iconurl,url,state,menutype,poweradd,
	powerdel,poweredi,powersel){
	$("#tableName").val(tableName);
	$("#menuId").val(menuId);
	$("#menuItemTitle").val(menuItemTitle);
	$("#sortNum").val(sortNum);
	$("#iconurl").val(iconurl);
	$("#url").val(url);
	//removeMenuModify(state,menutype,parentId);
	initMenuModify(state,menutype,parentId);
	if(poweradd=='Y')
	{
		$("#poweradd").prop("checked",true);
	}else{
		$("#poweradd").removeAttr("checked");
	}
	if(powerdel=='Y')
	{
		$("#powerdel").prop("checked",true);
	}else{
		$("#powerdel").removeAttr("checked");
	}
	if(poweredi=='Y')
	{
		$("#poweredi").prop("checked",true);
	}else{
		$("#poweredi").removeAttr("checked");
	}
	if(powersel=='Y')
	{
		$("#powersel").prop("checked",true);
	}else{
		$("#powersel").removeAttr("checked");
	}
	
}
function removeMenuModify(state,menutype,parentId){
	$("#state option").removeAttr("selected");
    $("#menutype option").removeAttr("selected");
    $("#parentId option").removeAttr("selected");
};
function initMenuModify(state,menutype,parentId){
	obj1 = document.getElementById("state");
	obj2 = document.getElementById("menutype");
	obj3 = document.getElementById("parentId");
	fun(obj1,state);
	fun(obj2,menutype);
	fun(obj3,parentId);
//	$("#state").removeAttr("state");
  //  $("#menutype").removeAttr("menutype");
//    $("#parentId").removeAttr("parentId");
 //   $("[name='state']").find("[value='"+state+"']").attr("selected",true);
  //  $("[name='menutype']").find("[value='"+menutype+"']").attr("selected",true);
   // $("[name='parentId']").find("[value='"+parentId+"']").attr("selected",true);
};
function fun(obj,str){
	for(i=0;i<obj.length;i++){
		if(obj[i].value==str)
			obj[i].selected = true;
	}
}
</SCRIPT>
</HEAD>

<BODY onload="init()">
<br/>
<div class="container-fluid" style="height:100%;">
	<div class="row" style="height:10%;">
		<div class="col-md-12" style="margin-bottom: 33px;">
		 	<form class="form-horizontal" >
		     	 <div class="form-group checkbox-inline"  style='display: inline-block;width:33%;'>
        			<!-- Checkbox -->
         			<label class="col-sm-2 control-label" style="width: 120px;">菜单类型</label>
          			<div class="col-sm-5">
          				  <select name="menutype" id="systemName" class="form-control" style="width: 200px;">
                   			<option <#if tableType=='yh'>selected="selected"<#else></#if> value="yh">云化系统</option>
                   			<option <#if tableType=='jf'>selected="selected"<#else></#if> value="jf">经分系统</option>
			 			</select>
          			</div>
          		</div>
          		
          		<div class="form-group checkbox-inline" style='display: inline-block;width:67%;'>
					
					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-primary" id="selectMenu" onclick="return false;" type="button">
     					 <span class="glyphicon glyphicon-search" style="color: rgb(0, 0, 0);"></span> 查询菜单
     					 </button>
  					 </label>
   					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-success" id="addNode" onclick="return false;" type="button">
     					 <span class="glyphicon glyphicon-plus" style="color: rgb(0, 0, 0);"></span> 新建菜单
     					</button>
  					 </label>
   					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-warning" id="edit" onclick="return false;" type="button">
     						<span class="glyphicon glyphicon-edit" style="color: rgb(0, 0, 0);"></span> 编辑菜单
     					 </button>
   					</label>
  					<label class="checkbox-inline my_mar">
     					 <button class="btn btn-danger" id="remove" onclick="return false;" type="button">
     					 <span class="glyphicon glyphicon-trash" style="color: rgb(0, 0, 0);"></span> 删除菜单
     					 </button>
   					</label>
				</div>
			</form>
		</div>
	</div>

	
	<div class="row"  style="width:100%;height:86%;margin-left: 10px;">
		<div class="col-md-6" style="width:25%;border-style: solid;border-color:#F3F1F1;border-width:1px;margin-right: 1%;height:590px;overflow: auto;" id="menuList">
				<div style="width:100%; height:100%;" id="treeDemoMenu" class="ztree"></div>
		</div>
		<div class="col-md-6" style="width:70%;border-style: solid;border-color:#F3F1F1;border-width:1px;min-height:590px;" id="menuDetail">	
            	<form class="form-horizontal" action="modify" method="POST" id="detailform" role="form" >
      				<div id="legend" class="" >
       				 	<legend class="" style="padding-left: 256px;width: 70%;">菜单编辑</legend>
     			 	</div>
					
		
      				<div class="form-group" >
         				 <!-- Text input-->
          				<label class="col-sm-2 control-label">菜单编号</label>
          				<div class="col-sm-4">
          					<input name="tableName" id='tableName' type='hidden' value="">
            				<input placeholder="" name="menuId" id='menuId' value="" readonly=true class="form-control" type="text">
         				 </div>
      				</div>
      
       				<div class="form-group">
          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">菜单名称</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="menuItemTitle" id="menuItemTitle" value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
       				</div>
        
      				<div class="form-group">

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label">父菜单编号</label>
          				<div class="col-sm-4">
            				<select name="parentId" id='parentId' class="form-control" style="width:100%;" value="1">
            				<option value="0">0</option>
               				 <#if smsMenus?exists>
                     			<#list smsMenus as rowMenu>
                     			<option value="${rowMenu[0]!'0'}">${rowMenu[1]!'0'}</option>
                     			</#list>
               				 </#if>
			 				</select>
          				</div>
        			</div>

    				<div class="form-group">

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">显示顺序</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="sortNum" id='sortNum' value="" class="form-control" type="text">
            				<p class="help-block"></p>
         				</div>
        			</div>

    				<div class="form-group">

          				<!-- Text input-->
         	 			<label class="col-sm-2 control-label" for="input01">菜单图标</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="iconurl" id='iconurl' value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
        			</div>
      				<div class="form-group">

          				<!-- Text input-->
          				<label class="col-sm-2 control-label" for="input01">菜单URL</label>
          				<div class="col-sm-4">
            				<input placeholder="" name="url" id='url' value="" class="form-control" type="text">
            				<p class="help-block"></p>
          				</div>
        			</div>
        
      				<div class="form-group">

          				<!-- Select Basic -->
          				<label class="col-sm-2 control-label" id="urltype"><#if tableType=='yh'>菜单状态<#else>ACCESSTOKEN</#if></label>
          				<div class="col-sm-4">
            				<select name="state" id='state' class="form-control" style="width:100%;">
                   				<option value="1" id="urltype_1"><#if tableType=='yh'>启用<#else>1</#if></option>
                   				<option value="0" id="urltype_0"><#if tableType=='yh'>关闭<#else>0</#if></option>>
			 				</select>
          				</div>
        			</div>
        
          			<div class="form-group">

        				<!-- Checkbox -->
          				<label class="col-sm-2 control-label">菜单种类</label>
          				<div class="col-sm-4">
            				<select name="menutype" id='menutype' class="form-control" style="width:100%;">
                   				<option value="0">菜单</option>
                   				<option value="1">配置</option>
                   				<option value="2">资源包</option>
			 				</select>
          				</div>
        			</div>
        			<div class="form-group">
        				<label for="name" class="col-sm-2 control-label" >菜单权限</label>
						<div>
							<label class="checkbox-inline">
     					 		<input type="checkbox" id="poweradd" name='poweradd' value="Y"> 增加
  							</label>
   							<label class="checkbox-inline">
     					 		<input type="checkbox" id="powerdel" name='powerdel' value="Y"> 删除
  							</label>
   							<label class="checkbox-inline">
     					 		<input type="checkbox" id="poweredi" name="poweredi" value="Y"> 修改
   							</label>
  					 		<label class="checkbox-inline">
     					 		<input type="checkbox" id="powersel" name="powersel" value="Y"> 查询
   							</label>
						</div>
					</div>

    				<div class="form-group">
          				<label class="col-sm-2 control-label"></label>

          				<!-- Button -->
          				<div class="col-sm-4">
            				<input type="submit" class="btn btn-success" value="提交">
            				<input type="reset" class="btn btn-warning" value="重置">
          				</div>
        			</div>        
  				</form>
		</div>			
	</div>
</div>
<script type="text/javascript">
	
</script>
</BODY>
</HTML>