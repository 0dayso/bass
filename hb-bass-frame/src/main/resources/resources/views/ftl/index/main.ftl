<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-CN">
<head>
<meta charset="utf-8" />
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noodp">
<title>湖北省移动经营分析系统</title>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery-1.11.3.min.js"></script>

<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/bootstrap.js"></script>

<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/dashicons.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/sys.base.css">

<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/zTreeStyle.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/zTreeStyle/zTreeStyle.css">
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery.ztree.all.min.js"></script>

<link rel="stylesheet" type="text/css" href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<script type="text/javascript" src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>

<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/main.js"></script>



<style type="text/css" id="myStyle">
* {
	-webkit-box-sizing: inherit;
	-moz-box-sizing: inherit;
	box-sizing: inherit;
}

html, body {
	height: 120%;
}

body {
	height: 110%;
}
.show_iframe iframe {
	position: absolute;
	height: 100%;
	min-width: 780px;
}
@media (min-width: 2000px) {
 iframe {
	width: 91.5%;
}
}
@media (max-width: 2000px) {
iframe {
	width: 91%;
}
@media (max-width: 1920px) {
 iframe {
	width: 90.5%;
}
}
}
@media (max-width: 1400px) {
 iframe {
	width: 86%;
}
}
@media (max-width: 1280px) {
 iframe {
	width: 84.5%;
}
}

.ztree2 * {
	font-size: 10pt;
	font-family: "Microsoft Yahei", Verdana, Simsun, "Segoe UI Web Light",
		"Segoe UI Light", "Segoe UI Web Regular", "Segoe UI",
		"Segoe UI Symbol", "Helvetica Neue", Arial
}

.ztree2 li {
	border-bottom: 1px solid #e5e5e5;
	line-height: 30px;
}

.ztree2 li ul {
	margin: 0;
	padding: 0
}

.ztree2 li {
	line-height: 30px;
}

.ztree2 li a {
	width: 100%;
	height: 30px;
	padding-top: 0px;
}

.ztree2 li a:hover {
	text-decoration: none;
	background-color: #E7E7E7;
}

.ztree2 li a span.button.switch {
	visibility: hidden
}

.ztree2.showIcon li a span.button.switch {
	visibility: visible
}

.ztree2 li a.curSelectedNode {
	background-color: #D4D4D4;
	border: 0;
	height: 30px;
}

.ztree2 li span {
	line-height: 30px;
}

.ztree2 li span.button {
	margin-top: -7px;
}

.ztree2 li span.button.switch {
	width: 16px;
	height: 16px;
}

.ztree2 li a.level0 span {
	font-size: 110%;
	font-weight: bold;
}

.ztree2 li span.button {
	background-image:
		url("${mvcPath}/hb-bass-frame/views/ftl/index/images/left_menuForOutLook.png");
	*background-image:
		url("${mvcPath}/hb-bass-frame/views/ftl/index/images/left_menuForOutLook.gif")
}

.loading {
    background: url(${mvcPath}/hb-bass-frame/images/loading_072.gif) no-repeat center;
    height: 100px;
}

.ztree2 li span.button.switch.level0 {
	width: 20px;
	height: 20px
}

.ztree2 li span.button.switch.level1 {
	width: 20px;
	height: 20px
}

.ztree2 li span.button.noline_open {
	background-position: 0 0;
}

.ztree2 li span.button.noline_close {
	background-position: -18px 0;
}

.ztree2 li span.button.noline_open.level0 {
	background-position: 0 -18px;
}

.ztree2 li span.button.noline_close.level0 {
	background-position: -18px -18px;
}

.Modal-bdy-ul {
	list-style-type: none;
	padding-left: 0px;
	padding-top: 3px;
}

.Modal-bdy-ul .Modal-bdy-ul-item {
	padding-bottom: 3px;
	padding-top: 6px;
}

.Modal-bdy-ul .Modal-bdy-ul-item .Modal-bdy-ul-item-title {
	font-weight: bold;
}

.Modal-bdy-ul .Modal-bdy-ul-item .Modal-bdy-ul-item-context {
	background-color: #B9DEF1;
	padding: 6px;
	margin-top: 6px;
	margin-bottom: 6px;
}

.dropdown-submenu {
    position: relative;
}
.dropdown-submenu > .dropdown-menu {
    top: 0;
    left: 100%;
    margin-top: -6px;
    margin-left: -1px;
    -webkit-border-radius: 0 6px 6px 6px;
    -moz-border-radius: 0 6px 6px;
    border-radius: 0 6px 6px 6px;
}
.dropdown-submenu:hover > .dropdown-menu {
    display: block;
}
.dropdown-submenu > a:after {
    display: block;
    content: " ";
    float: right;
    width: 0;
    height: 0;
    border-color: transparent;
    border-style: solid;
    border-width: 5px 0 5px 5px;
    border-left-color: #ccc;
    margin-top: 5px;
    margin-right: -10px;
}
.dropdown-submenu:hover > a:after {
    border-left-color: #fff;
}
.dropdown-submenu.pull-left {
    float: none;
}
.dropdown-submenu.pull-left > .dropdown-menu {
    left: -100%;
    margin-left: 10px;
    -webkit-border-radius: 6px 0 6px 6px;
    -moz-border-radius: 6px 0 6px 6px;
    border-radius: 6px 0 6px 6px;
}
</style>
<!--[if IE 7]>
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
<script>DD_belatedPNG.fix('*');</script>
<![endif]-->
<!--[if IE 8]>
<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 9]>
<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
<![endif]-->
<!--[if lt IE 9]>
<script type="text/javascript">

	function changeIframeWidth(winWidth){
				if(winWidth>2000){
                    $("body").prepend('<style type="text/css" ><iframe { width:91.5%;}</style>');
                }else if((1920<winWidth)&&(winWidth<=2000)){
               	 	$("body").prepend('<style type="text/css" >iframe {width:91%;}</style>');
                  //  $("iframe").css("width","91%");
                }else if((1400<winWidth)&&(winWidth<=1920)){
                	$("body").prepend('<style type="text/css" >iframe {width:90.5%;}</style>');
                   // $("iframe").css("width","90.5%");
                }else if((1280<winWidth)&&(winWidth<=1400)){
                	$("body").prepend('<style type="text/css" >iframe {width:86%;}</style>');
                   // $("iframe").css("width","86%");
                }else if(winWidth<=1280){
                    $("body").prepend('<style type="text/css" >iframe {width:84.5%;}</style>');
                    //$("iframe").css("width","84.5%");
                }
	}
  $(document).ready(function(){
  		 var windowWidth=$(window).width();
  		changeIframeWidth(windowWidth);
        $(window).resize(function() {
            windowWidth=$(window).width();
            changeIframeWidth(windowWidth);
        });
    });
 </script>
<![endif]-->
<script type="text/javascript">
//菜单树
var curMenu = null, zTree_Menu = null;
var setting = {
		view: {
			showLine: false,
			showIcon: false,
			selectedMulti: false,
			dblClickExpand: false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,
			beforeClick: this.beforeClick,
			onClick: this.onClick
		}
};
var zNodes =${menus?default('')};
function beforeClick(treeId, node) {
	if (node.isParent) {
		if (node.level === 0) {
			var pNode = curMenu;
			while (pNode && pNode.level !==0) {
				pNode = pNode.getParentNode();
			}
			if (pNode !== node) {
				var a = $("#" + pNode.tId + "_a");
				a.removeClass("cur");
				a.parent("li").attr("style","");
				a.parent("li").prev("li").attr("style","");
				zTree_Menu.expandNode(pNode, false);
			}
			a = $("#" + node.tId + "_a");
			a.addClass("cur");
			a.parent("li").attr("style","background:none");
			a.parent("li").prev("li").attr("style","background:none");
			var isOpen = false;
			for (var i=0,l=node.children.length; i<l; i++) {
				if(node.children[i].open) {
					isOpen = true;
					break;
				}
			}
			if (isOpen) {
				zTree_Menu.expandNode(node, true);
				curMenu = node;
			} else {
				zTree_Menu.expandNode(node.children[0].isParent?node.children[0]:node, true);
				curMenu = node.children[0];
			}
		} else {
			a = $("#" + node.tId);
			a.attr("style","height:auto");
			zTree_Menu.expandNode(node);
		}
	}
	return !node.isParent;
}
function onClick(e, treeId, node) {
	addTab(node);
}

//条件参数
function addMenuId(url,menuid){
	if(url!=null&&url!=''){
		var file = url.replace(/(^\s+)|(\s+$)/g, "");
		if(url.length>0){
			if(url.indexOf('.jsp')>0||url.indexOf('.html')>0||url.indexOf('.htm')>0){
				return url;
			}
			if(url.indexOf('?')<0){
				file = url+'?menuid='+menuid;
			}else{
				file = url+'&menuid='+menuid;
			}
		}
		return file;
	}else{
		return url;
	}
	
}
// 打开新的Tab页
function addTab(node){
	var file = addMenuId(node.file,node.id);
	$("#myTab").find('li').removeClass("active");
	var tabs = $("#myTab").find('li a');
	var isExit = false;
	$("#myTab li").each(function() {
		if($(this).find('a').attr("href")== "#frame_" + node.id)
		{
			isExit = true;
			$(this).addClass("active");
			$(".show_iframe").hide();
			//$(".sys-copyright").hide();
			$("#frame_" +node.id).show();
		//	$("#buttom" +node.id).show();
			return false;	
		}
	});
	if(!isExit){
		$("#myTab").append("<li class=\"active\"><a data-toggle=\"tab\" onclick='changeTab(\"" + node.id +"\");' href='#frame_" + node.id + "'>" + node.name + "</a><div class=\"dashicons dashicons-close\" onclick='closeTab(\"" + node.id +"\")'></div></li>");
		$(".show_iframe").hide();
		//$(".sys-copyright").hide();
		// 加载菜单内容到div
		var frame = '<div id="frame_'+node.id+'" class="tab-pane active show_iframe" style="height:100%;"><div class="loading" style="display:none"></div><iframe frameborder="0" src="'+file+'"></iframe></div>';
		$("#myTabPanel").append(frame);
	}
}
// 关闭Tab页
function closeTab(tabId){
	$("a[href='#frame_" + tabId + "']").parent().remove();
	$("#frame_" + tabId).remove();
	//$("#buttom" + tabId).remove();
	var isExit = false;
	$("#myTab li").each(function() {
		if($(this).hasClass("active"))
		{
			isExit = true;
		}
	});
	if(!isExit){
		$('#myTab a:last').tab('show');
		$('.show_iframe:last').show();
	//	$('.sys-copyright:last').show();
	}
}
// 切换tab
function changeTab(tabId){
	$(".show_iframe").hide();
	$("#frame_" + tabId).show();
	//$(".sys-copyright").hide();
	//$("#buttom" + tabId).show();
}
// 系统公告
var TopThreeNews = ${TopThreeNews};
$(document).ready(function(){
	// 系统公告
	$("#system_notice").text("系统公告："+TopThreeNews[0].newsmsg.substring(0,80)+"...");
	html='';
	for(var i =0;i<TopThreeNews.length;i++){
		html= html+'<li class="Modal-bdy-ul-item"> <span class="Modal-bdy-ul-item-title">'+TopThreeNews[i].newstitle+'</span> <span class="Modal-bdy-ul-item-title">时间:'+TopThreeNews[i].newsdate+'</span> <div class="Modal-bdy-ul-item-context">'+TopThreeNews[i].newsmsg+'</div> </li>';
	}
	$(".Modal-bdy-ul").html(html);
});
$(function(){
	var wHeight = $(window).height();
	var leftBannerHeight = $(".sys-banner").height();
	var dHeight = $(document).height();
	if(leftBannerHeight > wHeight){
		$(".sys-banner").css("position","absolute");
	}else{
		var ssleftBannerHeight = wHeight - 50;
		$(".sys-banner").css("height",ssleftBannerHeight);
	};
	// 左侧菜单高于窗口高度时，左侧滚动；子菜单切换改变菜单高度时，需在ztree 中进行判断；
	$(window).scroll(function(){
		var offsetTop = $("body").scrollTop();
		var newHeight = leftBannerHeight - wHeight;
		if(leftBannerHeight > wHeight){
			if(newHeight > 0 && offsetTop >= newHeight + 50){
				$(".sys-banner").css({"position":"fixed","top":"inherit","bottom":"0"});
			}else{
				$(".sys-banner").css({"position":"absolute","top":"50px","bottom":"inherit"});
			}
		}
	})
})
$(document).ready(function(){
	// 构建菜单树
	$.fn.zTree.init($("#sys-zTree"), setting, zNodes);
	zTree_Menu = $.fn.zTree.getZTreeObj("sys-zTree");
	curMenu = zTree_Menu.getNodes()[0].children[0];//默认打开第一级的第一个子菜单
	zTree_Menu.selectNode(curMenu);
	var a = $("#" + zTree_Menu.getNodes()[0].tId + "_a");
	a.addClass("cur");
	a.parent("li").attr("style","background:none");
	a.parent("li").prev("li").attr("style","background:none");
});	


</script>
</head>
<body>
     <div class="sys-header">
          <div class="sys-logo">
               <a href="#">湖北省移动经营分析系统</a>
          </div>
          <div class="sys-search">
               <input type="text" class="sys-search-input" placeholder="DOU 4G OPPO" />
               <div class="dashicons dashicons-search"></div>
          </div>
          <div class="sys-links">
               <ul>
                    <li>
                         <a href="../outlogin">注销</a>
                    </li>
                    <li class="sys-links-line"></li>
                    <li>
                         <a href="#">${user.name} <img src="${mvcPath}/hb-bass-frame/views/ftl/index/images/avatar.png" /></a>
                    </li>
               </ul>
          </div>
     </div>
     <div class="sys-banner">
          <ul id="sys-zTree" class="ztree"></ul>
     </div>
     <div class="sys-content" style="height: 100%;">
          <div class="sys-ntitle bs">
               <div class="sys-nbg"></div>
               <div id="system_notice" class="sys-ntext"></div>
               <a href="" class="sys-m" data-target="#systemNoticeModel" data-toggle="modal">更多公告</a>
          </div>
          <div class="sys-tab mt15">
               <ul id="myTab" class="sys-tab-ul">
                    <li class="active">
                         <a data-toggle="tab" href="#tab1" onclick="changeTab('tab1')">首页</a>
                         <div class="dashicons dashicons-close"></div>
                    </li>
               </ul>
          </div>
          <div id="myTabPanel" class="tab-content mt15" style="height: 80%;">
               <div id="frame_tab1" class="show_iframe" style="height: 100%;">
               		<iframe frameborder="0" src="${mvcPath}/roleAdapt/index/2000000?menuid=98091183"></iframe><!--默认打开的页面-->
               </div>
          </div>
          <div class="sys-clearfix"></div>
          <div class="sys-copyright">湖北省移动经营分析系统  北京亚信智慧数据科技有限公司  版权所有</div>
     </div>
     </div>
     <div class="sys-control">
          <ul class="sys-control-box">
               <li class="sys-c-line"></li>
               <li class="sys-c-icon" title="搜索">
                    <div class="dashicons dashicons-searchbig"></div>
               </li>
               <li class="sys-c-line"></li>
               <li class="sys-c-icon" title="问题">
                    <div class="dashicons dashicons-question"></div>
               </li>
               <li class="sys-c-line"></li>
               <li class="sys-c-icon" title="客服">
                    <div class="dashicons dashicons-talking"></div>
               </li>
               <li class="sys-c-line"></li>
               <li class="sys-c-icon" title="返回顶部">
                    <div class="dashicons dashicons-return"></div>
               </li>
               <li class="sys-c-line"></li>
          </ul>
     </div>
     <!--系统公告开始-->
     <div class="modal fade" id="systemNoticeModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
          <div class="modal-dialog" style='width: 650px;'>
               <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                         <h2 class="modal-title" id="myMenuManaLabel">系统公告</h2>
                    </div>
                    <div class="modal-body" style="width: 95%; font-size: 14px;">
                         <div style="height: 262px; overflow: auto;">
                              <ul class='Modal-bdy-ul'>
                              </ul>
                         </div>
                    </div>
                    <div class="modal-footer">
                         <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
                    </div>
               </div>
          </div>
     </div>
     <!--系统公告结束-->
</body>
</html>
