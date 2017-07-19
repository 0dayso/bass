<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<meta name="keywords" content="">
<meta name="description" content="">
<link rel="Shortcut Icon" type="images/x-icon"
	href="${mvcPath}/hb-bass-frame/images/he.ico" />
<LINK rel="Bookmark" href="images/x-icon"
	href="${mvcPath}/hb-bass-frame/images/favicon.ico">
<!--[if lt IE 9]>
<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
<![endif]-->
<link
	href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css"
	rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/H-ui.min.css" rel="stylesheet"
	type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/H-ui.admin.css"
	rel="stylesheet" type="text/css" />
<link href="${mvcPath}/hb-bass-frame/css/style.css" rel="stylesheet"
	type="text/css" />
<link
	href="${mvcPath}/resources/lib/fullcalendar-2.9.1/fullcalendar.min.css"
	rel="stylesheet" type="text/css" />
<!-- 
<link
	href="${mvcPath}/resources/lib/fullcalendar-2.9.1/fullcalendar.print.css"
	rel="stylesheet" type="text/css" />
 -->
<link href="${mvcPath}/resources/lib/iconfont/iconfont.css"
	rel="stylesheet" type="text/css" />
<link
	href="${mvcPath}/resources/lib/font-awesome/font-awesome.min.css"
	rel="stylesheet" type="text/css" />
<!--[if IE 7]>
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
<script>DD_belatedPNG.fix('*');</script>
<![endif]-->
<script src="${mvcPath}/resources/lib/underscore/underscore-min.js"
	type="text/javascript"></script>
<script src="${mvcPath}/resources/lib/angular/angular.js"></script>
</head>
<style type="text/css">
</style>
<title>${(appName)?default("空白页")}</title>
</head>
<body style="overflow: auto; background: url(${mvcPath}/resources/images/back.png) repeat  center center;">
	<div id="pageloading"></div>
	<div class="container-fluid" style="margin-left: 15px; margin-right: 15px;">
	  <div class="row">
	  	<div id="noticePlace" class=".col-xs-18 .col-md-12" style="width:1100px;height:500px"></div>
	  </div>
  	</div>
	
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/Validform_v5.3.2.js"></script>
		
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/fullcalendar-2.9.1/lib/moment.min.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/fullcalendar-2.9.1/fullcalendar.min.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/fullcalendar-2.9.1/lang/zh-cn.js"></script>
		
	<script type="text/javascript"
		src="${mvcPath}/resources/lib/layer2.1/layer.min.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script>
	<script type="text/javascript"
		src="${mvcPath}/hb-bass-frame/js/H-ui.admin.doc.js"></script>
	<script type="text/javascript">
	$('#noticePlace').fullCalendar({
		header: {
			left: '',//'prev,next today',
			center: 'title',
			right: ''//'month,basicWeek,basicDay'
		},
        lang: 'zh-cn',
		defaultDate: moment().format('YYYY-MM'),
		selectable: true,
		selectHelper: true,
		firstDay:0,
		/*
		select: function(start, end) {	
			var title = prompt('Event Title:');
			var eventData;
			if (title) {
				eventData = {
					title: title,
					start: start,
					end: end
				};
				$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
			}
			$('#calendar').fullCalendar('unselect');
		},*/
		editable: true,
		eventLimit: true, // allow "more" link when too many events
        eventClick: function(calEvent, jsEvent, view) {
        },
        eventMouseover:function(event, jsEvent, view ){
        	event.data = event.data ||'error!';
        	$.msg(event.title +"<br>"+event.data, {icon: 0 ,time : 5000});        	
        },
        eventMouseout:function( event, jsEvent, view ){
        },
		/*events: [
			{
				title: 'All Day Event',
				start: '2016-08-01',
				data:"sssss",
                color:'#336666'
			}
		]*/
		events: function(start, end, sss,callback) {
			$.ajax({
	            url: "./getMonthNotice",
	            dataType: 'json',
	            data: {
	            	monthStr : '2016-08'
	            },
	            success: function(data) {
	            	var events = [] ;
	            	_.each(data,function (_data){
	            		events.push({
	                        id: _data.noticeId,
	                        title: _data.noticetitle,
	        				start: _data.notice_start_dt,
	        				end:_data.notice_end_dt,
	        				data:_data.noticemsg,
	                        color:_data.extend_color
	                    });
	            	},this);
	            	callback(events);
	            },
	            error: function(){
	            	$.msg('获取通告错误！' +"<br>请联系系统管理员!", {icon: 0 ,time : 5000});
	            }
	        });
		}
	});
	$("#pageloading").hide();
	
	</script>
</body>
</html>