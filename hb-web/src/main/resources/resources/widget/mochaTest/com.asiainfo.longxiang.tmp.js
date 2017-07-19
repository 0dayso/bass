var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='container'></div>";
  	//initHtml+="<label id='choice_date' class='dataChoice'>2016-03-09</label>";
var initScript=
"var dateChoice= Widget.create('datebox',{					\r\n"+
"	id:'choice_date',											\r\n"+
"	appendTo:'#container'											\r\n"+
"});         													\r\n"+
" DateBoxUtil.date({                             			\r\n"+
"        JqElement: $('#choice_date'),                       \r\n"+
"        format:'yyyy-mm-dd',                                \r\n"+
"        language: 'zh-CN',                                  \r\n"+
"        autoclose: true                                     \r\n"+
"});                                                         \r\n"+
"var radioBox1 = Widget.create('radiobox',                      \r\n"+
"   {                                                           \r\n"+
"       data:[{value:'day',text:'日'},                          \r\n"+
"             {value:'month',text:'月'}],                       \r\n"+
"       checked:function(){                                     \r\n"+
"               alert(this.value);                              \r\n"+
"           }                                                   \r\n"+
"   }                                                           \r\n"+
");radioBox1.setValue('day');                                   \r\n"+
"var radioBox2 = Widget.create('radiobox',                      \r\n"+
"   {                                                           \r\n"+
"       data:[{value:'point',text:'入网点'},                    \r\n"+
"             {value:'area',text:'区域'}],                      \r\n"+
"       checked:function(value){                                \r\n"+
"               alert(value);                                   \r\n"+
"           }                                                   \r\n"+
"   }                                                           \r\n"+
");radioBox2.setValue('point');                                 \r\n"+
"var combobox = Widget.create('combobox',           \r\n"+
" {                                                 \r\n"+
"   type:'label',                                   \r\n"+//label或者input
"   defaultValue:'JM',                              \r\n"+
"   isFlow:false,                                   \r\n"+//流式布局用true 默认false
"   contentWidth:'100px',                           \r\n"+//流式布局时使用
"   disabled:'',                                    \r\n"+
"   data:[{value:'JM',displayValue:'荆门'},         \r\n"+
"         {value:'WC',displayValue:'武昌'},         \r\n"+
"         {value:'XG',displayValue:'孝感'},         \r\n"+
"         {value:'JZ',displayValue:'荆州'},         \r\n"+
"         {value:'WH',displayValue:'武汉'},         \r\n"+
"         {value:'XY',displayValue:'襄阳'}],        \r\n"+
"   listener:{                                      \r\n"+
"     select:function(value){                       \r\n"+
"       alert(value);                               \r\n"+
"     }                                             \r\n"+
"   }                                               \r\n"+
" }                                                 \r\n"+
"); combobox.setValue('XG');                        \r\n"+
// "var lable_split1= Widget.create('selflabel',{title:'|',cls:'mark'});         \r\n"+
// "var lable_split2= Widget.create('selflabel',{title:'|',cls:'mark'});         \r\n"+
// "var lable_split3= Widget.create('selflabel',{title:'|',cls:'mark'});         \r\n"+
// "var lable_split4= Widget.create('selflabel',{title:'|',cls:'mark'});         \r\n"+
"var selfbutton= Widget.create('selfbutton',{                      \r\n"+
"    title:'显示图表'												\r\n"+
"});                                                               \r\n"+
"var toolbar= Widget.create('toolbar',{                             \r\n"+
"    items:[dateChoice,radioBox1,combobox,selfbutton,radioBox2]    \r\n"+
"});                                                                                                                                  \r\n"+

"var datasource=[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}];     	\r\n"+ 
"var datasource1=[{text:'这么',remark:'访问999次'},{text:'1',remark:'访问1次'},{text:'bbab',remark:'访问22次'},{text:'bbba',remark:'访问333次'},{text:'b1b1b',remark:'访问4444次',id:'112'}];       \r\n"+
"var bulletinnormal = Widget.create('bulletinnormal',			             \r\n"+
"	{										                                 \r\n"+
"		titleText:'报表中心',	                                             \r\n"+
"       column:0,                                                           \r\n"+
"		titleColor:'#FFBD66',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){alert('123'+text);},	                     \r\n"+
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
"		lineNum:'6',							                             \r\n"+
"		datas:datasource,			                                         \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");	                                                                         \r\n"+
"var bulletin1 = Widget.create('bulletinimage',{column:0,width:'100%',appendTo:'',date:'2016-03-08',href:'#',name:'高校统一视图审查',src:'../../sass/image/test/images1.jpg',nameClick:function(e){alert(e);},dateClick:function(e){alert(e);}});  \r\n"+
"var bulletin2 = Widget.create('bulletinimage',{column:1,width:'100%',appendTo:'',date:'2016-03-09',href:'#',name:'高校统一视图审查2',src:'../../sass/image/test/images2.jpg'});  \r\n"+
"var bulletin3 = Widget.create('bulletinimage',{column:2,width:'100%',appendTo:'',date:'2016-03-10',href:'#',name:'高校统一视图审查3',src:'../../sass/image/test/images3.jpg'});  \r\n"+
"var bulletin4 = Widget.create('bulletinimage',{column:3,width:'100%',appendTo:'',date:'2016-03-11',href:'#',name:'高校统一视图审查4',src:'../../sass/image/test/images4.jpg'});  \r\n"+
"var Panel1= Widget.create('panel',                                                          \r\n"+
"	{											                                            \r\n"+
"	column:0,											                                   \r\n"+
//"	interval:'22px',											                            \r\n"+
"	title:'相关指标' ,   							                                        \r\n"+ 
"   top:'18px',                                                                             \r\n"+ 
"	items:[toolbar]    							                                            \r\n"+ 
"	}										                     	                        \r\n"+
");                                                                                         \r\n"+
"var Panel2= Widget.create('panel',                                                         \r\n"+
"	{											                                            \r\n"+
"	column:0,																	\r\n"+
//"   layouter:{                                \r\n"+
"         type:'grid',       \r\n"+
"         interval:'9px',       \r\n"+
"         gridDefine:[[{width:'33%',interval:'6px'},{width:'33%',interval:'6px'},{width:'33%',interval:'6px'}]]   ,\r\n"+
//"	interval:'22px',											                            \r\n"+
"   type:'grid',                                                                            \r\n"+
"   top:'18px',                                                                             \r\n"+ 
"	title:'相关推荐',    							                                        \r\n"+ 
"	items:[bulletinnormal,bulletinnormal1,bulletinnormal2]    				                \r\n"+
	"	}										                     	                        \r\n"+
");                                                                                         \r\n"+
"var Panel3= Widget.create('panel',                                                         \r\n"+
"	{											                                            \r\n"+
"	column:0,											                                    \r\n"+
//"	interval:'22px',											                            \r\n"+
"	title:'最新上线',    							                                        \r\n"+
"	type:'grid',    							                                            \r\n"+
//"   gridDefine:[[{width:'32%'},{width:'32%'},{width:'32%'}]],                               \r\n"+ 
"	items:[bulletin1,bulletin2,bulletin3,bulletin4]    				                        \r\n"+  
"	}										                     	                        \r\n"+
");                                                                                         \r\n"+
"var testData=[{num:'1',text:'这么11111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',text:'bbb',remark:'访问1次'},{num:'3',text:'bbb',remark:'访问22次'},{num:'4',text:'bbb',remark:'访问333次'},{num:'5',text:'bbb',remark:'访问4444次'}];		         \r\n"+
"var bulsimp1 = Widget.create('bulletinsimple',			         \r\n"+
"	{										                     \r\n"+
"		column:1,										         \r\n"+
//"		interval:'12px 0 0 0',									 \r\n"+
"		titleText:'高校指标',	                                 \r\n"+
"		titleColor:'#ADDCFE',	                                 \r\n"+
"		funcTitle:'更多',				                         \r\n"+
"		funcClick:function(text){alert('123'+text);},	         \r\n"+
//"		width:'100%',								             \r\n"+
"		lineNum:'6',							                 \r\n"+
"		datas:testData,			                                 \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	              \r\n"+
"	}											                 \r\n"+
");											                     \r\n"+
"var bulsimp2 = Widget.create('bulletinsimple',			         \r\n"+
"	{										                     \r\n"+
"		column:1,										         \r\n"+
//"		interval:'12px 0 0 0',									 \r\n"+
"		titleText:'指标访问量TOPS',	                             \r\n"+
"		titleColor:'#ADDCFE',	                                 \r\n"+
"		funcTitle:'更多',				                         \r\n"+
"		funcClick:function(text){alert('123'+text);},	         \r\n"+
//"		width:'100%',								             \r\n"+
"		lineNum:'6',							                 \r\n"+
"		datas:testData,			                                 \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	              \r\n"+
"	}											                 \r\n"+
");											                     \r\n"+
"var bulsimp3 = Widget.create('bulletinsimple',			         \r\n"+
"	{										                     \r\n"+
"		column:1,										         \r\n"+
//"		interval:'12px 0 0 0',									 \r\n"+
"		titleText:'高校报表',	                                 \r\n"+
"		titleColor:'#ADDCFE',	                                 \r\n"+
"		funcTitle:'更多',				                         \r\n"+
"		funcClick:function(text){alert('123'+text);},	         \r\n"+
//"		width:'100%',								             \r\n"+
"		lineNum:'6',							                 \r\n"+
"		datas:testData,			                                 \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	             \r\n"+
"	}											                 \r\n"+
");											                     \r\n"+ 
"var bulsimp4 = Widget.create('bulletinsimple',			         \r\n"+
"	{										                     \r\n"+
"		column:1,										         \r\n"+
//"		interval:'12px 0 0 0',									 \r\n"+
"		titleText:'高校应用',	                                 \r\n"+
"		titleColor:'#ADDCFE',	                                 \r\n"+
"		funcTitle:'更多',				                         \r\n"+
"		funcClick:function(text){alert('123'+text);},	         \r\n"+
//"		width:'100%',								             \r\n"+
"		lineNum:'6',							                 \r\n"+
"		datas:testData,			                                 \r\n"+
"		rowClick:function(row){alert(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},\r\n"+
"	}											                    \r\n"+
");											                        \r\n"+ 
"var notice = Widget.create('notice',                               \r\n"+
"	{											                    \r\n"+
"	column:0,											            \r\n"+
"	interval:'12px 11px 11px 11px',									 	\r\n"+
"	moreTitle:'更多',   						                    \r\n"+
"	listener:{click:function(title,text){alert(title+' '+text)}},   \r\n"+	
"	title:'系统通知 :',    						                    \r\n"+
"	text:'2015-10-15日 系统公告，关于9日数据延迟发布问题，时间2016-03-10 12:00:00 由于昨晚数据割接导致接口报错,testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttest',   \r\n"+
"	}										                     	                                                \r\n"+
");                                                                                                                 \r\n"+ 
//"var left_layout=Widget.create('defaultlayouter',{items:[bulsimp1,bulsimp2,bulsimp3,bulsimp4],column:1});           \r\n"+
//"var right_box=Widget.create('defaultlayouter',{items:[notice,Panel,Panel2,Panel3],column:0});                      \r\n"+
//"right_box.setWidth('100%');                                                                                  \r\n"+
"var page= Widget.create('gridlayouter',{													                    \r\n"+
" 			minWidth:1186,	\r\n"+
" 			maxWidth:1325,	\r\n"+
//"			interval:'11px',	\r\n"+
"			applyTo:'#container',	\r\n"+
"			gridDefine:[[{width:'70%',interval:'11px'},{width:'30%',interval:'12px 0 0 0'}]],															\r\n"+
"			items:[notice,Panel1,Panel2,Panel3,bulsimp1,bulsimp2,bulsimp3,bulsimp4]							\r\n"+
"});";
var resource = "<script type='text/javascript' src='/widgets/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets/Layouter/js/DefaultLayouter.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/RadioBox.js'></script>            \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/ComboBox.js'></script>            \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfButton.js'></script>          \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfLabel.js'></script>           \r\n";
    resource += "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinImage.js'></script>   \r\n";
    resource+= "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinNormal.js'></script>   \r\n";
    resource+= "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinSimple.js'></script>   \r\n";
    resource += "<script type='text/javascript' src='/widgets/ToolBar/js/ToolBar.js'></script>          \r\n"; 
    resource += "<script type='text/javascript' src='/Widgets/DateBoxUtil.js'></script> 						\r\n";
    resource += "<script type='text/javascript' src='/widgets/DateBox/js/DateBox.js'></script>                        \r\n";
    resource += "<script type='text/javascript' src='/widgets/Notice/js/Notice.js'></script>            \r\n"; 
    resource += "<script type='text/javascript' src='/widgets/Panel/js/Panel.js'></script>              \r\n";	
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);