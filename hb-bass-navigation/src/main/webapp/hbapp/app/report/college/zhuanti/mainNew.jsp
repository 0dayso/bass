<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
<head>
  <title>高校开学营销季</title>
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
			<div id="content" style="visibility  : hidden ">
				<div id="MooFlow">
					<a href="pics/ad/1.jpg" rel="image"><img src="pics/ad/1.jpg" title="异地选号活动主形象海报" alt="点击看大图" /></a>
					<a href="pics/ad/2.jpg" rel="image"><img src="pics/ad/2.jpg" title="移动MM创业行动海报" alt="点击看大图"/></a>
					<a href="pics/ad/3.jpg" rel="image"><img src="pics/ad/3.jpg" title="新同学 老相识活动主形象海报" alt="点击看大图"/></a>
					<a href="pics/ad/4.jpg" rel="image"><img src="pics/ad/4.jpg" title="动感地带开学迎新主形象海报" alt="点击看大图"/></a>
					<a href="pics/ad/5.jpg" rel="image"><img src="pics/ad/5.jpg" title="WLAN宣传主形象海报" alt="点击看大图"/></a>
				</div>
			</div>
			<div id="titleDiv" style="width:100%; background:url('pics/banner3.png') no-repeat; margin : 0px 5px 0px 5px">
				
				<span style="position:absolute;z-index:1000;top:13px;left:120px;font-size:26px;color:#fff;font-weight:700;">高校营销之开学季</span>
				<span id="section1" class="offbanner" style="left:400px;  cursor : pointer" >前置营销<br>0801-0831</span>
				<span id="section2" disabled=true class="offbanner" style="left:550px; ">地面攻坚<br>0901-0930</span>
				<span id="section3" disabled=true class="crtOffBanner" style="left:700px; ">深耕巩固<br>1001-1031</span>
				
				<!-- <span class="offbanner" style="left:700px">深耕巩固<br>1001-1031</span>-->
				<span class="titleIcon" ></span>
			</div>
	<div id="scrollDiv1">
	<table>	
		<tr>
			<td width="1100px">
	<div id="scrollDiv" style="font-size:12px;padding:0px 8px;">
					<marquee onMouseOut="this.start()" onMouseOver="this.stop()" Direction="up" scrollamount="1" height="60">
					<!--  	
			<p>
				1、(2010-08-18) 高校是特殊形态的重要集团，各分公司各个部门应加强整体协作，形成合力。
			</p>
			<p>						
				2、(2010-08-18) 直送卡工作要做深入，做扎实，对于新生要进行100%夹寄，100%外呼，100%关怀，要千方百计鼓励用户续费，只要用户通话、续费了才会减轻地面攻坚战的压力和资源投入。
</p><p>3、(2010-08-18) 迎新现场，要做好新生、老生，以及直送卡与地面的区隔营销，把握好政策的平衡。
</p><p>4、(2010-08-18) WLAN要加快进场，进一家，建设一家，推广一家； CMMB要突出与厂家联合营销；MM创业行动既要造势，又要推动业务。
</p><p>5、(2010-08-18) 跟随学生足迹进行宣传，对各类接触点的传播要细分，要明确。
</p><p>6、(2010-08-18) 以班级飞信群、班级139圈子为立脚点开展的“新同学、老相识”活动是稳定用户的核心，能提前将用户关系沉淀到互联网上，做实前期的组建和后期的维护工作至关重要。做到发展一批，稳定一批。
</p><p>7、(2010-08-18) 模范遵守通管局高校通信市场 “十条禁令”，采取智慧竞争，避免恶性竞争。
</p>-->
					</marquee>
				
	</div>
		</td>
		<td height="40px" width="180px">
			<div width="180px" height="60px" id="imageDiv" style="font-size:12px;">
				<marquee onMouseOut="this.start()" onMouseOver="this.stop()" Direction="left" scrollamount="2" height="60">
					<span style="margin :0px 5px">异地选号</span><span style="margin :0px 5px">移动MM</span><span style="margin :0px 5px">新老相识</span><span style="margin :0px 5px">开学迎新</span><span style="margin :0px 5px">WLAN</span><br>
						<img src="pics/ad/1_thumbnail.jpg" title="浏览海报" style="cursor : pointer; margin : 0px 10px" onclick="picShow()"/>
						<img src="pics/ad/2_thumbnail.jpg" title="浏览海报" style="cursor : pointer; margin : 0px 10px" onclick="picShow()"/>
						<img src="pics/ad/3_thumbnail.jpg" title="浏览海报" style="cursor : pointer; margin : 0px 10px" onclick="picShow()"/>
						<img src="pics/ad/4_thumbnail.jpg" title="浏览海报" style="cursor : pointer; margin : 0px 10px" onclick="picShow()"/>
						<img src="pics/ad/5_thumbnail.jpg" title="浏览海报" style="cursor : pointer; margin : 0px 10px" onclick="picShow()"/>
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
			sectionId='';
		 for(var i = 1 ; i <= 3 ; i ++ ) {
			 sections.push($G("section" + i));
		 }
		 for(var i = 0 ; i < sections.length ; i ++) {
			sections[i].onclick = function(){
				window.location.href = window.location.href.replace(sectionPattern,"") + "&section=" + this.id;
			 };
			 sections[i].className = "offbanner";
		 }
		 var time = new Date();
		 if(time.getMonth()==7 ){
	 		 	sectionId = _params.section || "section1" ;
		 }else if(time.getMonth()==8 ){
		 		sectionId = _params.section || "section2" ;
		 		var section2 = document.getElementById("section2");
		 		section2.disabled = false;
		 	}else if(time.getMonth()>=9 ){
		 		sectionId = _params.section || "section3" ;
		 		var section2 = document.getElementById("section2");
		 		section2.disabled = false;
		 		var section3 = document.getElementById("section3");
		 		section3.disabled = false;
		 	}
		 if(sectionId!=null && sectionId.length>0){
			 $G(sectionId).className = "crtOffBanner";
		 }
		 initTabs(sectionId);
		 function initTabs(sectionId) {
			var items,_tabPanel,viewport;
			if("section1" == sectionId) {
				items= [{
					id:'index0',
					title: "直送卡综合信息",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/3931"></iframe>',       
					border:false
				},
				{
					id:'index1',
					title: "异地选号",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/3926"></iframe>',       
					border:false
				},
				{
					id:'index2',
					title: "WLAN进度",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/3925"></iframe>',       
					border:false
				},
				{
					id:'index3',
					title: "暑期漫游",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/hbapp/app/report/college/zhuanti/index_sqmy.html?"' + _params._oriUri + '></iframe>',       
					border:false
				},
				{
					id:'index4',
					title: "进场准备进度",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/3927"></iframe>',       
					border:false
				},
				{
					id:'index5',
					title: "直送卡、进场协议、WLAN工作情况",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/6578"></iframe>',       
					border:false
				}
				];
				var array = ['admin','meikefu','helei','jiangyun' ,'aixiaohong' ,'caiwenjuan' ,'vluokai' ,'tianyuping' ,'vzhouxiaoju' ,'wangting3' ,'vchenjia' ,'vchenaipeng' ,'lilin3' ,'lixiaoyun' ,'lishuiping1' ,'liujinbin' ,'yanghongyan' ,'liguogang' ,'quanhui' ,'guodan' ,'zhujianfeng' ,'wanjingjing' ,'shangshibo' ,'vyanyan' ,'biejunhong' ,'vpengliyun' ,'vlijun' ,'vchenyue' ,'huangchao','zhangzhifeng1','lvchunlai'];
				for(var i=0;i<array.length;i++){
					if(array[i] == '<%=user.getId()%>') {
						items.push({
							id:'index6',
							title: "数据导入",
							closable:false,
							autoScroll:false,
							html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/hbapp/app/report/college/zhuanti/import.jsp?' + _params._oriUri + '"></iframe>',       
							border:false
						});
						break;
					}	
				}
				//if("meikefu" == _params.loginname || "zhaozheng" == _params.loginname) {
				  
			}else if("section2" == sectionId) {
				items= [{
					id:'index0',
					title: "月累计通话市场占有率分析",
					closable:false,
					autoScroll:true,
					//html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="/hbbass/salesmanager/areasale/totalReport.jsp?queryType=1&' + _params._oriUri + '"></iframe>',       
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/1377"></iframe>',       
					border:false
				},
				{
					id:'index1',
					title: "月累计新增市场占有率分析",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/1378"></iframe>',       
					border:false
				},
				{
					id:'index2',
					title: "高校净增情况跟踪",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4201"></iframe>',       
					border:false
				}
				,
				{
					id:'index3',
					title: "高校新增用户质量",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4461"></iframe>',       
					border:false
				},
				{
					id:'index4',
					title: "高校新增用户长途话务分析",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4464"></iframe>',       
					border:false
				},
				{
					id:'index5',
					title: "高校通话用户长途话务分析",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4465"></iframe>',       
					border:false
				}
				];
					
			} else if("section3" == sectionId) {
				items= [{
					id:'index0',
					title: "高校净增情况跟踪",
					closable:false,
					autoScroll:true,      
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4201"></iframe>',       
					border:false
				},
				{
					id:'index1',
					title: "高校新增用户新业务发展",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4462"></iframe>',       
					border:false
				},
				{
					id:'index2',
					title: "高校通话用户新业务发展",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4463"></iframe>',       
					border:false
				}
				,
				{
					id:'index3',
					title: "WLAN校园优惠套餐发展",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/report/4564"></iframe>',       
					border:false
				},
				{
					id:'index6',
					title: "月累计通话市场占有率分析",
					closable:false,
					autoScroll:true,
					//html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="/hbbass/salesmanager/areasale/totalReport.jsp?queryType=1&' + _params._oriUri + '"></iframe>',       
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/hbbass/salesmanager/areasale/totalReport.jsp?queryType=1&' + _params._oriUri + '"></iframe>',       
					border:false
				},
				{
					id:'index7',
					title: "月累计新增市场占有率分析",
					closable:false,
					autoScroll:true,
					html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="98%" height="100%" src="${mvcPath}/hbbass/salesmanager/areasale/totalReport.jsp?queryType=2&' + _params._oriUri + '"></iframe>',       
					border:false
				}
				];
					
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