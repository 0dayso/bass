var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='container'></div>";
   
var initScript = "var datasource=[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}];     	\r\n"+ 
"var bulletinnormal = Widget.create('bulletinnormal',			 \r\n"+
"	{										                                 \r\n"+
"		titleText:'报表中心',	                                             \r\n"+
"       column:0,                                                           \r\n"+
"		titleColor:'#FFBD66',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){alert('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:datasource,			                                         \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"var bulletinnormal1 = Widget.create('bulletinnormal',			             \r\n"+
"	{										                                 \r\n"+
"       column:1,                                                            \r\n"+
"		titleText:'应用中心',	                                             \r\n"+
"		titleColor:'#50D8D0',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){alert('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:datasource,			                                         \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"var bulletinnormal2 = Widget.create('bulletinnormal',			             \r\n"+
"	{										                                 \r\n"+
"       column:2,                                                           \r\n"+
"		titleText:'我的收藏',	                                             \r\n"+
"		titleColor:'#F37276',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){alert('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:datasource,			\r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");	";

initScript+=" var layouter=Widget.create('defaultlayouter',{		\r\n"+
"		 //maxWidth:500,minWidth:500,												\r\n"+
"    	 applyTo: 'body',					        \r\n"+
"		items:[bulletinnormal,bulletinnormal1,bulletinnormal2],		\r\n"+
"		gridDefine:[[{width:'30%'},{width:'30%'},{width:'30%'}]]	"+
"});				\r\n"+
"//layouter.layout([bulletinnormal,bulletinnormal1,bulletinnormal2]) \r\n";

var resource = "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/Widgets/DateBoxUtil.js'></script>                        \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Notice/js/Notice.js'></script>            \r\n"; 
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Bulletin/js/BulletinImage.js'></script>   \r\n";
    resource+= "<script type='text/javascript' src='/widgets_v2.0.1/Bulletin/js/BulletinNormal.js'></script>   \r\n";
    resource+= "<script type='text/javascript' src='/widgets_v2.0.1/Bulletin/js/BulletinSimple.js'></script>   \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Panel/js/Panel.js'></script>              \r\n";	
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

