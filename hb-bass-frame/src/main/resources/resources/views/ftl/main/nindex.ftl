<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<title>湖北移动经营分析系统</title>
</head>
<body> 
<header class="Hui-header cl" ng-controller="headerContentCtrl">
	<div class="Hui-logo l logo-image"></div>
	<a class="Hui-logo l" style="margin-left: 0px;" title="经分前台" href="#">湖北移动经营分析系统</a>
	<span class="Hui-subtitle l">V1.0</span>
	<!--
	<a class="Hui-logo-m l" href="/" title="H-ui.admin">H-ui</a> 
	<span class="Hui-userbox"><span class="c-white">超级管理员：admin</span>
	<a class="btn btn-danger radius ml-10" href="#" title="退出"><i class="icon-off"></i> 退出</a></span>
	-->
	<!-- <a aria-hidden="false" class="Hui-nav-toggle" href="#"></a> -->
	<div class="Hui-logo-m l collapse navbar-collapse bs-example-js-navbar-collapse c-white">
          <ul class="nav navbar-nav">
            <li class="dropdown">
              <a aria-expanded="false" aria-haspopup="true" role="button" data-toggle="dropdown" class="dropdown-toggle" href="#" id="drop1">
                Dropdown
                <span class="caret"></span>
              </a>
              <ul aria-labelledby="drop1" class="dropdown-menu">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li class="divider" role="separator"></li>
                <li><a href="#">Separated link</a></li>
              </ul>
            </li>
        </div>
</header>
<aside class="Hui-aside">
</aside>
<!--<aside class="Hui-aside">
  <input runat="server" id="divScrollValue" type="hidden" value="" />
  <div class="menu_dropdown bk_2">
    <dl id="menu-user">
      <dt><i class="icon-user"></i> 用户中心<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="${mvcPath}/hb-bass-frame/user-list.html" href="javascript:;">用户管理</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/user-list-del.html" href="javascript:;">删除的用户</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/user-list-black.html" href="javascript:;">黑名单</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/record-browse.html" href="javascript:void(0)">浏览记录</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/record-download.html" href="javascript:void(0)">下载记录</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/record-share.html" href="javascript:void(0)">分享记录</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-comments">
      <dt><i class="icon-comments"></i> 评论管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="http://h-ui.duoshuo.com/admin/" href="javascript:;">评论列表</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/feedback-list.html" href="javascript:void(0)">意见反馈</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-article">
      <dt><i class="icon-edit"></i> 资讯管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="${mvcPath}/hb-bass-frame/article-class.html" href="javascript:void(0)">分类管理</a></li>
          <li><a _href="${mvcPath}/hb-bass-frame/article-list.html" href="javascript:void(0)">资讯管理</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-picture">
      <dt><i class="icon-picture"></i> 图片库<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="article-class.html" href="javascript:void(0)">分类管理</a></li>
          <li><a _href="picture-list.html" href="javascript:void(0)">图片管理</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-product">
      <dt><i class="icon-beaker"></i> 产品库<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="product-brand.html" href="javascript:void(0)">品牌管理</a></li>
          <li><a _href="article-class.html" href="javascript:void(0)">分类管理</a></li>
          <li><a _href="codeing.html" href="javascript:void(0)">产品管理</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-page">
      <dt><i class="icon-paste"></i> 页面管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="codeing.html" href="javascript:void(0)">首页管理</a></li>
          <li><a _href="codeing.html" href="javascript:void(0)">友情链接</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-order">
      <dt><i class="icon-credit-card"></i> 财务管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="codeing.html" href="javascript:void(0)">订单列表</a></li>
          <li><a _href="codeing.html" href="javascript:void(0)">充值管理</a></li>
          <li><a _href="codeing.html" href="javascript:void(0)">发票管理</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-tongji">
      <dt><i class="icon-bar-chart"></i> 系统统计<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="codeing.html" href="javascript:void(0)">统计列表</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-admin">
      <dt><i class="icon-key"></i> 管理员管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="admin-role.html" href="javascript:void(0)">角色管理</a></li>
          <li><a _href="admin-permission.html" href="javascript:void(0)">权限管理</a></li>
          <li><a _href="admin-list.html" href="javascript:void(0)">管理员列表</a></li>
        </ul>
      </dd>
    </dl>
    <dl id="menu-system">
      <dt><i class="icon-cogs"></i> 系统管理<i class="iconfont menu_dropdown-arrow">&#xf02a9;</i></dt>
      <dd>
        <ul>
          <li><a _href="system-base.html" href="javascript:void(0)">基本设置</a></li>
          <li><a _href="system-lanmu.html" href="javascript:void(0)">栏目设置</a></li>
          <li><a _href="system-data.html" href="javascript:void(0)">数据字典</a></li>
          <li><a _href="system-shielding.html" href="javascript:void(0)">屏蔽词</a></li>
          <li><a _href="system-log.html" href="javascript:void(0)">系统日志</a></li>
        </ul>
      </dd>
    </dl>
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
    <div class="Hui-tabNav-more btn-group"><a id="js-tabNav-prev" class="btn radius btn-default size-S" href="javascript:;"><i class="icon-step-backward"></i></a><a id="js-tabNav-next" class="btn radius btn-default size-S" href="javascript:;"><i class="icon-step-forward"></i></a></div>
  </div>
  <div id="iframe_box" class="Hui-article">
    <div class="show_iframe">
      <div style="display:none" class="loading"></div>
      <iframe scrolling="yes" frameborder="0" src="welcome.html"></iframe>
    </div>
  </div>
</section>-->
<script type="text/javascript" src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/Validform_v5.3.2.js"></script> 
<script type="text/javascript" src="${mvcPath}/resources/lib/layer1.8/layer.min.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script> 
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.doc.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/index.js"></script> 
<script>
</script>
</body>
</html>