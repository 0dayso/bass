<!DOCTYPE HTML>
<html ng-app>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<meta name="keywords" content="">
<meta name="description" content="">
<link rel="Shortcut Icon" type="images/x-icon" href="${mvcPath}/hb-bass-frame/images/he.ico" />
<LINK rel="Bookmark" href="images/x-icon" href="${mvcPath}/hb-bass-frame/images/favicon.ico" >
<!--[if lt IE 9]>
<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
<![endif]-->
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/H-ui.min.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/H-ui.admin.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/style.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/resources/lib/iconfont/iconfont.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome.min.css" rel="stylesheet" type="text/css" />
<!--[if IE 7]>
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
<script>DD_belatedPNG.fix('*');</script>
<![endif]-->
<script src="${mvcPath}/resources/lib/underscore/underscore-min.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/lib/angular/angular.js"></script>
</head>
<style type="text/css">
</style>
<title>${(appName)?default("空白页")}</title>
</head>
<body ng-controller="mainContentCtrl" style="overflow: auto; background: url(${mvcPath}/resources/images/back.png) repeat  center center;">
<!--<body style="overflow: auto;">-->
	<div id="pageloading"></div>
	<div id="mainTitel" class="navbar-fixed-top">
 <div id='topDetail' ng-controller="headerContentCtrl" >
 	<div id='topLine'><div class="logo-image"></div>
 	<div class='Quick_Navigation'><span>${(appName)?default("")}<!-- <a href="#">首页</a></span><span>|</span><span><a href="#">报表中心</a></span><span>|</span><span><a href="#">应用中心</a> --></span></div>
 	
 	<ul class="nav navbar-nav pull-right" style="margin-right: 20px;">
 	        
 			<li class="dropdown pull-right"><span href="#" class="dropdown-toggle" data-toggle="dropdown" style="padding-top: 12px; color:white; padding-bottom: 12px;padding-left:15px;">
 				<i class="icon-phone"></i> {{DataQualityLine}}</span></li>
 			<li class="dropdown pull-right"><span>|</span></li>
 			<li id='user_info' class="dropdown pull-right">
	           <a href="#" class="dropdown-toggle" data-toggle="dropdown" style="padding-top: 12px; padding-bottom: 12px;">
	              <i class="icon-user"></i> ${(user.name)!"空"} <b class="caret"></b>
	           </a>
	            <ul id="userinfo" class="dropdown-menu" style="background-color:#48A5E2;">
	              <li><a href="#" options="introduce" ><i class="fa fa-user"></i> 介绍</a></li>
	              <li><a href="#" options="setting" ><i class="fa fa-cogs"></i> 设置</a></li>
	              <li><a href="${mvcPath}/login.html" ><i class="fa fa-sign-out"></i> 注销</a></li>
	            </ul>
          </li>
 		  <li class="dropdown pull-right"><span>|</span></li>
 		  <li id='user_option' class="dropdown pull-right">
 		  	<a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown" style="padding-top: 12px; padding-bottom: 12px;">
              <i class="icon-cogs"></i> 管理中心 <b class="caret"></b>
            </a>
            <!-- Dropdown menu -->
            <ul id="useroption" class="dropdown-menu" style="background-color:#48A5E2;">
            </ul>
 		  </li>
          <li class="dropdown pull-right" style="margin-right: 30px;">
 	        <div class="isearch">
			 	<!-- <span class="searchTitle">i经分搜索:</span> --><input type="text" ng-model="searchValue" placeholder="输入检索内容..."  style="color:Gray;height: 30px;line-height: initial;">
			 	<i class="icon-search" ng-click="search()"></i>
			 </div>
 	       </li>
        </ul>
 	</div>
 </div>
	<div class="main_menu_title">
	</div>
	</div>
	
 	<aside class="Hui-aside">
 		<div class="menu_dropdown bk_2">
 			<!-- 
			<dl id="menu-user1">
				<dt>
					<i class="icon-user"></i> 用户中心<i
						class="iconfont menu_dropdown-arrow">&#xf02a9;</i>
				</dt>
				<dd>
					<ul>
						<li><a _href="${mvcPath}/hb-bass-frame/user-list.html"
							href="javascript:;">用户管理</a></li>
						<li><a _href="${mvcPath}/hb-bass-frame/user-list-del.html"
							href="javascript:;">删除的用户</a></li>
						<li><a _href="${mvcPath}/hb-bass-frame/user-list-black.html"
							href="javascript:;">黑名单</a></li>
						<li><a _href="${mvcPath}/hb-bass-frame/record-browse.html"
							href="javascript:void(0)">浏览记录</a></li>
						<li><a _href="${mvcPath}/hb-bass-frame/record-download.html"
							href="javascript:void(0)">下载记录</a></li>
						<li><a _href="${mvcPath}/hb-bass-frame/record-share.html"
							href="javascript:void(0)">分享记录</a></li>
					</ul>
				</dd>
			</dl>
			 -->
		</div>
	</aside>
	<div class="dislpayArrow"><a class="pngfix" href="javascript:void(0);" onClick="displaynavbar(this)"></a></div>
		<section class="Hui-article-box">
		<div id="Hui-tabNav" class="Hui-tabNav">
			<div class="Hui-tabNav-wp">
				<ul id="min_title_list" class="acrossTab cl">
					<li class="active"><span title="我的桌面" data-href="welcome.html">我的桌面</span><em></em></li>
				</ul>
			</div>
			<div class="Hui-tabNav-more btn-group">
				<a id="js-tabNav-prev" class="btn radius btn-default size-S"
					href="javascript:;"><i class="icon-step-backward"></i></a><a
					id="js-tabNav-next" class="btn radius btn-default size-S"
					href="javascript:;"><i class="icon-step-forward"></i></a>
			</div>
		</div>
		<div id="iframe_box" class="Hui-article">
			<div class="show_iframe">
				<div style="display: none" class="loading"></div>
				<iframe scrolling="yes" frameborder="0" src=""></iframe>
			</div>
		</div>
		</section>
		<script type="text/javascript">
	var menus = ${menus?default('')};
	//console.log(menus.length);
</script>
<script type="text/javascript" src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/Validform_v5.3.2.js"></script> 
<script type="text/javascript" src="${mvcPath}/resources/lib/layer1.8/layer.min.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.doc.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/index.js"></script>

</body>
</html>