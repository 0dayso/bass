<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
<head>
  <title></title>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/mooflow/MooFlow.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/mooflow/MooFlowViewer.css" />
		<style type="text/css">
		.crtOffBanner {
			position:absolute;z-index:1001;top:1px;
			height: 45;
			width: 122;
			text-align:center;
			vertical-align:middle;
			padding-top:10px;
			FONT-SIZE: 14px;
			color:#ffffff;
			background:url("pics/step2.png")!important;  
			background:none;  
			filter:none!important;  
			filter:progid:DXImageTransform.Microsoft.AlphaImageLoader (src="pics/step2.png");  
		}
		.offbanner {
			position:absolute;z-index:1001;top:1px;
			height: 45;
			width: 122;
			text-align:center;
			vertical-align:middle;
			padding-top:10px;
			FONT-SIZE: 14px;
			color : #cccccc;
			background:url("pics/step_1.png")!important;  
			background:none;  
			filter:none!important;  
			filter:progid:DXImageTransform.Microsoft.AlphaImageLoader (src="pics/step_1.png");  
		}
		.titleIcon {
			position:absolute;z-index:1000;
			top:3px;right:5px;
			height: 46;
			width: 190;
			background:url("pics/aaa.png")!important;  
			filter:none!important;  
			filter:progid:DXImageTransform.Microsoft.AlphaImageLoader (src="pics/aaa.png");  
		}
	</style>
</head>

<body>
	<div id="scrollDiv1">
	<table>	
		<tr>
			<td width="1100px">
	<div id="scrollDiv" style="font-size:12px;padding:0px 8px;">
					<marquee onMouseOut="this.start()" onMouseOver="this.stop()" Direction="up" scrollamount="1" height="60">
					</marquee>
				
	</div>
		</td>
	</tr>
	</table>
	</div>
	
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
	
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/mootools/mootools-1.2-core.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/mootools/mootools-1.2-more.js"></script>

	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/mooflow/MooFlow.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/mooflow/MooFlowViewer.js"></script>
	<script type="text/javascript">
		Ext.BLANK_IMAGE_URL = '${mvcPath}/hbapp/resources/js/ext/resources/images/default/s.gif';
		var $G = function(id) {
			return document.getElementById(id);
		}
	 Ext.onReady(function(){
		var sections = [],
			_params = function(){
				var _uri = window.location.href,
					_paramStr = "",
					_encoderOriUri = "",
					obj = {};
				if(_uri.indexOf("?")>0){
					_uri = _uri.substring(_uri.indexOf("?")+1,_uri.length);
					var _arr = _uri.split("&");
					for(var i=0;i<_arr.length;i++){
						var _arr2=_arr[i].split("=");
						if(_encoderOriUri.length>0)
							_encoderOriUri+="&";
						_encoderOriUri +=_arr2[0]+"="+encodeURIComponent(_arr2[1]);
						obj[_arr2[0]] = _arr2[1];
					}
				}else{
					_uri="";
				}
				obj["_oriUri"] = _uri;
				obj["_encoderOriUri"] = _encoderOriUri;
				return obj;
			}(),
			
			sectionPattern = /&section=\w+/,
			sectionId;
		 for(var i = 1 ; i <= 3 ; i ++ ) {
			 sections.push($G("section" + i));
		 }
		 for(var i = 0 ; i < sections.length ; i ++) {
			sections[i].onclick = function(){
				window.location.href = window.location.href.replace(sectionPattern,"") + "&section=" + this.id;
			 };
			 sections[i].className = "offbanner";
		 }
		 sectionId = _params.section || "section1" ;
		 $G(sectionId).className = "crtOffBanner";
		 initTabs(sectionId);
		 function initTabs(sectionId) {
			var items,_tabPanel,viewport;
			if("section1" == sectionId) {
				items= [{
					id:'index0',
					title: "8月前",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="/mvc/report/5808"></iframe>',       
					border:false
				},
				{
					id:'index1',
					title: "8月后",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="/mvc/report/6662"></iframe>',       
					border:false
				}
				];
				var array = ['meikefu','helei','jiangyun' ,'aixiaohong' ,'caiwenjuan' ,'vluokai' ,'tianyuping' ,'vzhouxiaoju' ,'wangting3' ,'vchenjia' ,'vchenaipeng' ,'lilin3' ,'lixiaoyun' ,'lishuiping1' ,'liujinbin' ,'yanghongyan' ,'liguogang' ,'quanhui' ,'guodan' ,'zhujianfeng' ,'wanjingjing' ,'shangshibo' ,'vyanyan' ,'biejunhong' ,'vpengliyun' ,'vlijun' ,'vchenyue' ,'huangchao','zhangzhifeng1','lvchunlai'];
				for(var i=0;i<array.length;i++){
					if(array[i] == '<%=user.getId()%>') {
						items.push({
							id:'index6',
							title: "数据导入",
							closable:false,
							autoScroll:false,
							html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/hbapp/app/report/college/zhuanti/import.jsp?' + _params._oriUri + '"></iframe>',       
							border:false
						});
						break;
					}	
				}
				//if("meikefu" == _params.loginname || "zhaozheng" == _params.loginname) {
				  
			}else if("section2" == sectionId) {} else if("section3" == sectionId) {
			}
			_tabPanel =new Ext.TabPanel({
				//region:'center',
				deferredRender:true,
				border:false,
				enableTabScroll:true,
				activeTab:0,
				autoDestroy  : true,
				items:items
			});
			//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
			viewport = new Ext.Viewport({
				 layout:'border'
				 ,items:[
					new Ext.BoxComponent({ // raw
						region:'north',
						el: 'titleDiv',
						//split:true,
						height:50
					}),
					{
						region:'center',
						//title: '重点数据跟踪',
						collapsible: true,
						//split:true,
						//width: 1200,
						//minSize: 175,
						//maxSize: 400,
						layout:'fit',
						margins:'0 5',
						items: _tabPanel
					},
					{
						region:'south',
						contentEl: 'scrollDiv1',
						split:true,
						collapsible: true,
						//title:'焦点信息',
						margins:'0 5 1 5',
						height:60 //适当加长了
					}
				]
			 });
		 
		 } 
    });
	
			/*
			本框架使用注意事项:
				1. 图片不能重复
				2. 问题(all solved)： 全屏/普通; 提示; 全图
			*/
			function picShow(){
				var mf = new MooFlow($('MooFlow'), {
					startIndex: 0,
					useSlider: true,
					useAutoPlay: true,
					useCaption: true,
					useResize: true,
					//bgColor : "grey",
					useMouseWheel: true,
					useKeyInput: true,
					useViewer: false,
					reflection : 0.1,
					heightRatio : 0.42
				});
				mf.attachViewer();
			}
</script>
</body>
</html>