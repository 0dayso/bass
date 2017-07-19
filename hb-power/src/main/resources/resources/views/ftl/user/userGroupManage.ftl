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
.ztree li a {padding:1px 3px 0 0; margin:0; cursor:pointer; height:17px; color:#333; background-color: transparent;
	text-decoration:none; vertical-align:top; display: inline-block}
.ztree li a:hover {text-decoration:underline}
.ztree li a.curSelectedNode {padding-top:0px; background-color:#FFE6B0; color:black; height:25px; line-height:20px;border:1px #FFB951 solid; opacity:0.8;font-size:16px;}
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
var powerMap = new Map();
//生成用户组树数据
function createUserMenuNodes(data)
{
  var zUserNodes=[];
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
         zUserNodes.push({id:MENUITEMID, pId:PARENTID, name:MENUITEMTITLE});
      }
      return zUserNodes;
};

//加载菜单节点（展示菜单名字，及其子菜单信息）
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

//用户组tree
var zTreeUserMenuManage=null;
function userTreeConfig()
{
	var settings = {
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
			onCheck: onCheckUserMenu//打勾获取信息
		},
		//添加按钮选择的属性
		check: {
				enable: true,
				chkStyle: "radio",//设置选择框属性  radio：单选  
				radioType: "all"//设置radio分组范围  level：同一级内； all：整棵树内
			}
		
	}
	return settings;
};


var settings = userTreeConfig();
$.ajax({
	type: "POST"
	,url: "${mvcPath}/userItmesManage/treeUser"
	,data: {}
	,dataType : "json"
	,success: function(data){
	        if(data==null)return;
	        var zUserNodes=createUserMenuNodes(data);
            $(document).ready(function(){
			$.fn.zTree.init($("#usertreeDemoMenu"), settings, zUserNodes);
			zTreeUserMenuManage = $.fn.zTree.getZTreeObj("usertreeDemoMenu");
		});

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("加载菜单错误,错误code:"+XMLHttpRequest.status);
 }
});

//菜单tree
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
			onClick: onClickMenu,//选中点击 加载事件，展示出该菜单的详细信息
			onCheck: onCheckMenu//添加或删除
			//change: onCheckMenu
		},
		//添加按钮选择的属性
		check: {
				enable: true,
				
				//勾选时：父关联子
				//取消勾选时：子不关联父
				chkStyle: "checkbox",
				chkboxType: { "Y" : "p", "N" : "s" }  
			},
			data: {
				simpleData: {
					enable: true
				}
			}
	}
	return setting;
};

var setting = menuTreeConfig();
$.ajax({
	type: "POST"
	,url: "${mvcPath}/userItmesManage/tableMenu"
	,data: {tableName:tableName}
	,dataType : "json"
	,success: function(data){
	        if(data==null)return;
	        var zNodes=createMenuNodes(data);
            $(document).ready(function(){
			$.fn.zTree.init($("#treeDemoMenu"), setting, zNodes);
			zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
			
		});

	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("加载菜单错误,错误code:"+XMLHttpRequest.status);
 }
	});

function beforeDrag(treeId, treeNodes) {
	return false;
}


function createNewMenu(menuItemId,menuItemTitle,parentId)
{	
    if(null==parentId)parentId=0;
   	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userItmesManage/newMenuOrUpdateTitle"
		,data: {menuItemId:menuItemId,menuItemTitle:menuItemTitle,parentId:parentId,tableName:tableName}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
	     		$("#detailform").attr("action",data.action);
		        setValues(data.tableName,data.menuitemid,data.menuitemtitle,
	        data.parentid,data.sortnum,data.iconurl, data.url,data.state,
	        data.menutype,data.powerdel,data.poweredi,data.powersel);
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	           alert("createNewMenu创建菜单错误,错误code:"+XMLHttpRequest.status);
	     }
	});
}
function createNewMenuId()
{
  var res;
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userItmesManage/newTreeNodeId"
		,data: {tableName:tableName}
		,async: false
		,dataType : "json"
		,success: function(data){
		        if(data==null)return;
		        res= eval(data);		
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	           alert("createNewMenuId查询菜单ID错误,错误code:"+XMLHttpRequest.status);
	           alert(errorThrown);
	     }
	});
	return res;
};

function init()
{
   
}


function removeMenuModify(state,menutype,parentId)
{
	$("#state option").removeAttr("selected");
    $("#menutype option").removeAttr("selected");
    $("#parentId option").removeAttr("selected");
};
function initMenuModify(state,menutype,parentId)
{
	obj1 = document.getElementById("state");
	obj2 = document.getElementById("menutype");
	obj3 = document.getElementById("parentId");
	fun(obj1,state);
	fun(obj2,menutype);
	fun(obj3,parentId);
};
function fun(obj,str){
	for(i=0;i<obj.length;i++){
		if(obj[i].value==str)
			obj[i].selected = true;
	}
}

//操作一、
//获取选中用户组tree节点  进行菜单tree 选择框设置操作
function onCheckUserMenu(event, treeId, treeNode, clickFlag)
{
	//alert(treeNode.id+"radio");
	
	var oldpid = treeNode.pId;
	var zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
	zTreeMenuManage.selectNode(treeNode);
	zTreeMenuManage.checkAllNodes(false);
	//zTreeMenuManage.checkNode(false);
	var node = zTreeUserMenuManage.getNodeByParam("id",treeNode.id,null);
	zTreeUserMenuManage.selectNode(node); //设置节点名选中 
	setCheckbox();
	$.ajax({
	type: "POST"
	,url: "${mvcPath}/userItmesManage/getMenuManageNode?groupId="+treeNode.id
	,data: {}
	,dataType : "json"
	,success: function(data){
				if(data.length<0){
					var zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
					zTreeMenuManage.checkAllNodes(false);
					 return null;
	    		 	}
		 		for(var i = 0;i<data.length;i++){
		    		 	var cell = data[i];
	    		 		//alert(cell.menuid+"checkbox");
	    		 		//设置节点选择状态
	    		 		setCheckedNode(cell.menuid);
	    		 		}
			return null;
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("加载用户组信息错误,错误code:"+XMLHttpRequest.status);
 }
});	
	
}



//设置菜单tree节点的勾选状态
function setCheckedNode(menuId)
{
	var zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
	var node = zTreeMenuManage.getNodeByParam("id",menuId,null);
	checkeNodeByNode(node,true);//设置节点打勾
}

//勾选node
function checkeNodeByNode(node,flag){
	zTreeMenuManage.checkNode(node,flag,true);
}

function getNodesByPid(pid){
	var nodes = zTreeMenuManage.getNodesByParam("pId",pid,null);
	return nodes;
}
//勾选/去所有菜单
function setAllChildChecked(pid,roleId,flag){
	var nodes = getNodesByPid(pid);
	for(var i=0;i<nodes.length;i++){
		var node = nodes[i];
		var menuid = node.id
		checkeNodeByNode(node,flag);
		if(flag){
			addItems(roleId,menuid,'no');
		}else {
			delItems(roleId,menuid);
		}
		setAllChildChecked(menuid,roleId,flag);
	}
}


function selected(){
	//判断是否选中用户组信息
	var nodes = zTreeUserMenuManage.getSelectedNodes();
	var treeNode1 = nodes[0];
	//alert("用户组ID="+treeNode1.id);
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		setCheckbox();
		return;
	}
}
//操作二、
//对userDemoMenu节点的勾选状态进行操作 
//1、勾选时		新增该菜单节点的权限  并进行权限编辑  然后保存当前节点
//2、取消勾选时 	删除该菜单节点的权限

function onCheckMenu(event, treeId, treeNode, clickFlag)
{	
	var nodes = zTreeUserMenuManage.getSelectedNodes();//选择被选择的用户组
	var userNode = nodes[0];
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		setCheckbox();
		return;
	}
	var flag=treeNode.checked;//获得节点的选中状态
	if(flag==true){//如果为勾选操作
		addItems(userNode.id,treeNode.id,'yes');
	}else{
		delItems(userNode.id,treeNode.id);
	}
	setAllChildChecked(treeNode.id,userNode.id,flag);
}
function getChildNodes(treeNode) {
     var childNodes = zTreeMenuManage.transformToArray(treeNode);
     var nodes = new Array();
     for(i = 0; i < childNodes.length; i++) {
          nodes[i] = childNodes[i].id;
     }
     return nodes.join(",");
}
//删除方法
function delItems(roleId,menuId)
{
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userItmesManage/deleteTreeUser?roleId="+roleId+"&&menuId="+menuId
		,data: {}
		,dataType : "json"
		,success: function(data){
		        if(data.flag=="true")
		        //setValues(data.roleid,data.menuid,data.poweradd,data.powerdel,data.poweredi,data.powersel);
		        alert("删除成功！")
				return  ;
			},
			 error: function(XMLHttpRequest, textStatus, errorThrown) {
		           alert("删除菜单错误,错误code:"+XMLHttpRequest.status);
			 }
		}); 
}

//新增方法，勾选菜单复选框
function addItems(roleId,menuId,firstNode)
{
	var res;
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/userItmesManage/addUserItems?roleId="+roleId+"&&menuId="+menuId+"&&firstNode="+firstNode
		,data: {}
		,async: false
		,dataType : "json"
		,success: function(data){
		 		if(data.flag=="true")
		 		return  ;
		},
		 error: function(XMLHttpRequest, textStatus, errorThrown) {
	           alert("createNewMenuId新建菜单权限错误,错误code:"+XMLHttpRequest.status);
	           alert(errorThrown);
	     }
	});
	return res;
}

//操作三、
//获取选中的菜单userDemoMenu节点  进行菜单权限的编辑操作
function onClickMenu(event, treeId, treeNode, clickFlag)
{
	zTreeUserMenuManage = $.fn.zTree.getZTreeObj("usertreeDemoMenu");
	var nodes = zTreeUserMenuManage.getSelectedNodes();
	var treeNode1 = nodes[0];
	if (nodes.length == 0) {
		layer.alert("请先选择一个用户组");
		setCheckbox();
		return;
	}
	$.ajax({
	type: "POST"
	,url: "${mvcPath}/userItmesManage/detailMenu?menuId="+treeNode.id+"&&roleId="+treeNode1.id
	,data: {}
	,dataType : "json"
	,success: function(data){
	        if(data.menuitemid!='error')
	        setValues(data.roleid,data.menuId,data.poweradd,data.powerdel,data.poweredi,data.powersel);
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("无菜单权限,错误code:"+XMLHttpRequest.status);
 }
	});
}
//修改数据
function btn_update(){
		zTreeUserMenuManage = $.fn.zTree.getZTreeObj("usertreeDemoMenu");
		var nodes = zTreeUserMenuManage.getSelectedNodes();
		var treeNode1 = nodes[0];
		zTreeMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
		var node = zTreeMenuManage.getSelectedNodes();
		var treeNode = node[0];
		var roleId= $("#roleId");
		var menuId=$("#menuId");
		var a = document.getElementById("poweradd");
		var b = a.checked;
		if(document.getElementById("poweradd").checked==true){
			var poweradd='Y';
		}else{
			var poweradd='N';
		}
		if(document.getElementById("powerdel").checked==true){
			var powerdel='Y';
		}else{
			var powerdel='N';
		}
		if(document.getElementById("poweredi").checked==true){
			var poweredi='Y';
		}else{
			var poweredi='N';
		}
		if(document.getElementById("powersel").checked==true){
			var powersel='Y';
		}else{
			var powersel='N';
		}
		$.ajax({
			type: "POST"
			,url: "${mvcPath}/userItmesManage/updateByMenuId?menuId="+treeNode.id+"&&roleId="+treeNode1.id+"&&poweradd="+poweradd+"&&powerdel="+powerdel+"&&poweredi="+poweredi+"&&powersel="+powersel
			,data: {}
			,dataType : "json"
			,success: function(data){
	       		 if(data.menuitemid!='error')
	       		 
	selMap(treeNode.id,treeNode1.id);
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("无菜单权限,错误code:"+XMLHttpRequest.status);
 }
	});
}
function selMap(menuId,roleId){
	$.ajax({
	type: "POST"
	,url: "${mvcPath}/userItmesManage/detailMenu?menuId="+menuId+"&&roleId="+roleId
	,data: {}
	,dataType : "json"
	,success: function(data){
	        if(data.menuitemid!='error')
	        setValues(data.roleid,data.menuId,data.poweradd,data.powerdel,data.poweredi,data.powersel);
	},
	 error: function(XMLHttpRequest, textStatus, errorThrown) {
           alert("无菜单权限,错误code:"+XMLHttpRequest.status);
 }
	});
}
//表单数据加载初始值
function setValues(roleId,menuId,poweradd,powerdel,poweredi,powersel)
{
	zTreeUserMenuManage = $.fn.zTree.getZTreeObj("usertreeDemoMenu");
	var nodes = zTreeUserMenuManage.getSelectedNodes();
	var treeNode1 = nodes[0];
	zTreeUserMenuManage = $.fn.zTree.getZTreeObj("treeDemoMenu");
	var nodes = zTreeUserMenuManage.getSelectedNodes();
	var treeNode = nodes[0];
	$("#roleId").val(roleId);
	$("#rolename").val(treeNode1.name);
	$("#menuId").val(menuId);
	$("#menuname").val(treeNode.name);
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
//表单checkbx默认值
function setCheckbox(){
	$("#rolename").val("");
	$("#menuname").val("");
	$("#poweradd").checked="true";
	$("#powerdel").checked="true";
	$("#poweredi").checked="true";
	$("#powersel").checked="true";
}
$('#treeDemoMenu').scrollspy();
</SCRIPT>
</HEAD>

<BODY onload="init()">
<br/>
<div class="container-fluid" style="height:100%;">

	
	<div class="row"  style="width:100%;height:86%;margin-left: 10px;">
		<div class="col-md-6" style="width:25%;border-style: solid;border-color:#F3F1F1;border-width:1px;margin-right: 1%;min-height:580px;overflow: auto;" id="menuList">
				<div id="legend" class="" >
       				 	<legend class="" style="padding-left: 90px;padding-top:10px;width: 90%;">用户组选择</legend>
 			 	</div>
				<div style="width:100%; height:90%;" id="usertreeDemoMenu" class="ztree"></div>
		</div>
		<div class="col-md-6" style="width:25%;border-style: solid;border-color:#F3F1F1;border-width:1px;margin-right: 1%;height: 580px; min-height:580px;overflow: auto;" id="menuList">
				<div id="legend" class="" >
       				 	<legend class="" style="padding-left: 90px;padding-top:10px;width: 90%;">菜单选择</legend>
 			 	</div>
				<div style="width:100%; height:90%;" id="treeDemoMenu" class="ztree"></div>
		</div>
		<div class="col-md-6" style="width:40%;border-style: solid;border-color:#F3F1F1;border-width:0px;margin-right: 1%;min-height:580px;overflow: auto;" id="">
				<div class="col-md-6" style="width:100%;border-style: solid;border-color:#F3F1F1;border-width:1px;min-height:580px;" id="menuDetail">	
            	<form class="form-horizontal" action="" method="POST" id="detailform" role="form">
      				<div id="legend" class="" >
       				 	<legend class="" style="padding-left: 100px;padding-top:10px;width: 90%;">菜单权限</legend>
     			 	</div>
     			 	
        			<div class="form-group" style="padding-left: 15px;">
						<input type="text" id="roleId" value="" name="roleId" style="display: none;">
						<input type="text" id="menuId" value="" name="menuId" style="display: none;">
						<div class="form-group" style="width:80%">
							<label class="col-sm-5 col-xs-6 control-label" for="input01">用户组名称：</label>
							<div class="col-xs-8 col-sm-7">
	        					<input  name="name0" id="rolename" value="" disabled= "true "  class="form-control" type="text">
	        				</div>
        				</div>
        				<div class="form-group" style="width:80%">
	        				<label class="col-sm-5 col-xs-6 control-label" for="input01">菜单名称：</label>
	        				<div class="col-xs-8 col-sm-7">
	        					<input  name="name" id="menuname" value="" disabled= "true "  class="form-control" type="text">
							</div>
							<input  id="roleId" type="hidden" />
							<input  id="menuId" type="hidden" />
						</div>
						<div class="form-group"  style="padding-left: 30px;width:80%">
							<label class="checkbox-inline">
					 			<input type="checkbox" checked="true" id="poweradd" name="poweradd" value=""> 新增
				 			</label>
							<label class="checkbox-inline">
	 					 		<input type="checkbox" checked="true" id="powerdel" name="powerdel" value=""> 删除
							</label>
							<label class="checkbox-inline">
	 					 		<input type="checkbox" checked="true" id="poweredi" name="poweredi" value=""> 修改
							</label>
					 		<label class="checkbox-inline">
	 					 		<input type="checkbox" checked="true" id="powersel" name="powersel" value=""> 查询
							</label>
						</div>
					</div>

    				<div class="form-group">
          				<label class="col-sm-2 control-label"></label>

          				<!-- Button -->
          				<div class="col-sm-5">
            				<input type="button" class="btn btn-success" onclick="btn_update()" value="提交">
            				<input type="reset" style="padding-left:15px" class="btn btn-warning" onclick="setCheckbox()" value="重置">
          				</div>
        			</div>        
  				</form>
		</div>	
		</div>		
	</div>
</div>
<script type="text/javascript">
	var menuDetail = document.getElementById("menuDetail");
	var height =menuDetail.offsetHeight;
	$("#menuList").css("height",height);
	
	<#list powerList as powers>
		$("[power_id='${powers.power_id}']").css("display","");
		powerMap.set('${powers.power_id}','${powers.power_id}');
	</#list>
</script>
</BODY>
</HTML>