var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
/*
bulletinnormal
*/
var initHtml = "<div id='container'></div>";  
var initScript = 
"var bulletinnormal = Widget.create('bulletinnormal',			 \r\n"+
"	{	applyTo:'#container',									                                 \r\n"+
"       row:0,                                                           \r\n"+
"       column:0,                                                           \r\n"+
"		titleText:'报表中心',	                                             \r\n"+
"		titleColor:'#FFBD66',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){console.log('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){console.log(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			                                         \r\n"+
"		rowClick:function(row){console.log(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"bulletinnormal.load([{num:'1',text:'loadtest1',remark:'访问a次'},{num:'2',text:'loadtest2',remark:'访问b次'},{num:'3',text:'loadtest3',remark:'访问c次'},{num:'4',text:'loadtest4',remark:'访问d次'},{num:'5',text:'loadtest5',remark:'访问e次'}]);											                                 \r\n";
var resource = "<script type='text/javascript' src='/widgets_v2.0.1/Bulletin/js/BulletinNormal.js'></script>   \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script>            \r\n";
//browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
bulletinsimple
*/
var initHtml = "<div id='container'></div>";  
var initScript = 
"var bulletinsimple = Widget.create('bulletinsimple',			             \r\n"+
"	{	applyTo:'#container',									                                 \r\n"+
"       row:0,                                                           \r\n"+
"       column:2,                                                            \r\n"+
"		titleText:'应用中心',	                                             \r\n"+
"		titleColor:'#50D8D0',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){console.log('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){console.log(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			                                         \r\n"+
"		rowClick:function(row){console.log(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"bulletinsimple.load([{num:'1',text:'loadtest1',remark:'访问a次'},{num:'2',text:'loadtest2',remark:'访问b次'},{num:'3',text:'loadtest3',remark:'访问c次'},{num:'4',text:'loadtest4',remark:'访问d次'},{num:'5',text:'loadtest5',remark:'访问e次'}]);											                                 \r\n";
var resource = "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script>            \r\n";
    resource+= "<script type='text/javascript' src='/widgets_v2.0.1/Bulletin/js/BulletinSimple.js'></script>   \r\n";
//browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
date:'2016-03-22',type:'radiobox',author:'zhanggm',widget:'widget',detail:'新建radiobox并测试'
*/
var initHtml = "<div id='container'></div>";  
var initScript = 
"var radioBox = Widget.create('radiobox',                      \r\n"+
"   {   applyTo:'#container',                                                       \r\n"+
"       row:0,                                                           \r\n"+
"       column:1,                                                            \r\n"+
"       data:[{value:'day',text:'日'},                          \r\n"+
"             {value:'month',text:'月'}],                       \r\n"+
"       checked:function(){                                     \r\n"+
"               console.log(this.value);                              \r\n"+
"           }                                                   \r\n"+
"   }                                                           \r\n"+
");radioBox.addOptions({value:'year',text:'年'});radioBox.setValue('day');                                   \r\n";
var resource = "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script>            \r\n";
    resource+= "<script type='text/javascript' src='/widgets_v2.0.1/Form/js/RadioBox.js'></script>   \r\n";
//browseEvirnoment.setUpOrDown(initHtml,initScript,resource);
/*
date:'2016-03-22',type:'gridlayouter',author:'zhanggm',widget:'widget',detail:'新建gridlayouter并测试'
*/
var initHtml = "<div id='container'></div>";  
var initScript = 
" var layouter=Widget.create('gridlayouter',{		\r\n"+
"		 type:'grid',maxWidth:1000,minWidth:500,												\r\n"+
"    	 appendTo: 'body',					        \r\n"+
"		//items:[[bulletinnormal,bulletinnormal1,bulletinnormal2]],		\r\n"+
"		gridDefine:[[{width:'40%'},{width:'20%'},{width:'40%'}]]	"+
"});				\r\n"+
"layouter.layout([1,2,3]) \r\n";

var resource = "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script>            \r\n";
//browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
mixin(container）
*/
var initHtml = "<div id='container'></div>";  
var initScript = 
"var bulletinnormal = Widget.create('bulletinnormal',			 \r\n"+
"	{										                                 \r\n"+
"       row:0,                                                           \r\n"+
"       column:1,                                                           \r\n"+
"		titleText:'报表中心',	                                             \r\n"+
"		titleColor:'#FFBD66',	                                             \r\n"+
"		funcTitle:'更多',				                                     \r\n"+
"		funcClick:function(text){console.log('loadbefore:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());combobox.load();console.log('loadover:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){console.log(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			                                         \r\n"+
"		rowClick:function(row){console.log(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);console.log('LoadBefore:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());combobox.load([{dimvalue:'HB',dimname:'全省',dimtype:'province_code'},{dimvalue:'HB1',dimname:'全省1',dimtype:'province_code'}]);console.log('loadover:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"bulletinnormal.load([{num:'1',text:'loadtest1',remark:'访问a次'},{num:'2',text:'loadtest2',remark:'访问b次'},{num:'3',text:'loadtest3',remark:'访问c次'},{num:'4',text:'loadtest4',remark:'访问d次'},{num:'5',text:'loadtest5',remark:'访问e次'}]);											                                 \r\n"+
"var combobox = Widget.create('combobox',           \r\n"+
" {                                                 \r\n"+
"   type:'normal',                                   \r\n"+//label或者input
"   defaultValue:'HB.JZ',                              \r\n"+
"   linenum:'4',                              \r\n"+
"   isFlow:false,                                   \r\n"+//流式布局用true 默认false
"   contentWidth:'100px',                           \r\n"+//流式布局时使用
"   disabled:'',                                    \r\n"+
"       data:[{dimname:'全部',dimvalue:'1'},{dimname:'应用',dimvalue:'2'},{dimname:'专题',dimvalue:'3'}],                                                         \r\n"+
"   getDimData:function(obj){console.log('getData:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());var expendDatas=[{dimtype:\"city_code\",dimvalue: \"HB\",dimname: \"湖北111\"},{dimtype:\"city_code\",dimvalue: \"HB.ES\",dimname: \"恩施2\"},{dimtype:\"city_code\",dimvalue: \"HB.EZ\",dimname: \"鄂州2\"},{dimtype:\"city_code\",dimvalue:\"HB.HG\",dimname: \"黄冈2\"},{dimtype:\"city_code\",dimvalue: \"HB.HS\",dimname: \"黄石2\"},{dimtype:\"city_code\",dimvalue: \"HB.JH\",dimname: \"江汉2\"},{dimtype:\"city_code\",dimvalue:\"HB.JM\",dimname: \"荆门2\"},{dimtype:\"city_code\",dimvalue: \"HB.JZ\",dimname: \"荆州2\"},{dimtype:\"city_code\",dimvalue: \"HB.SY\",dimname: \"十堰2\"},{dimtype:\"city_code\",dimvalue:\"HB.SZ\",dimname: \"随州2\"},{dimtype:\"city_code\",dimvalue: \"HB.WH\",dimname: \"武汉\"},{dimtype:\"city_code\",dimvalue: \"HB.XF\",dimname: \"襄樊\"},{dimtype:\"city_code\",dimvalue: \"HB.XG\",dimname: \"孝感\"},{dimtype:\"city_code\",dimvalue: \"HB.XN\",dimname: \"咸宁\"},{dimtype:\"city_code\",dimvalue: \"HB.YC\",dimname: \"宜昌\"}];return expendDatas;} ,                                     \r\n"+
"   dbclickFunc:function(obj){console.log('dbclick:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());},                      \r\n"+
"    clickFunc:function(obj){console.log('click:'+combobox.getDimname()+' '+combobox.getDimvalue()+' '+combobox.getDimtype());                               \r\n"+
"     }                                             \r\n"+
"                                               \r\n"+
" }                                                 \r\n"+
"); combobox.setValue('HB.XG');                 \r\n"+
" //console.log(combobox.getDimtype()) ;console.log(combobox.getDimvalue()) ;console.log(combobox.getDimname()) ;               \r\n"+
"var bulletinsimple = Widget.create('bulletinsimple',			             \r\n"+
"	{										                                 \r\n"+
"       row:0,  itemIcon:'icon-film',                                                         \r\n"+
"       column:2,                                                            \r\n"+
"		titleText:'应用中心',	                                             \r\n"+
"		titleColor:'#50D8D0', hasSubhead:'123',                                            \r\n"+
"		//funcTitle:'更多',				                                     \r\n"+
"		//funcClick:function(text){console.log('123'+text);},	                     \r\n"+
"		width:'100%',								                         \r\n"+
"		lineNum:'6',							                             \r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){console.log(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			                                         \r\n"+
"		rowClick:function(row){console.log(row.num+' '+row.icon+' '+row.text+' '+row.remark+' '+row.id);},	\r\n"+
"	}											                             \r\n"+
");											                                 \r\n"+
"bulletinsimple.load([{num:'1',text:'loadtest1111111111111111111111111111111111111111111111111111',remark:'访问a次'},{num:'2',text:'loadtest2',remark:'访问b次'},{num:'3',text:'loadtest3',remark:'访问c次'},{num:'4',text:'loadtest4',remark:'访问d次'},{num:'5',text:'loadtest5',remark:'访问e次'}]);											                                 \r\n"+
"var Panel= Widget.create('panel',                                                          \r\n"+
"	{appendTo:'body',											                                            \r\n"+
"   layouter:{                                \r\n"+
"         type:'grid',maxWidth:1000,minWidth:500,       \r\n"+
"         gridDefine:[[{width:'40%'},{width:'20%'},{width:'40%'}]]   },\r\n"+
"	title:'相关指标' ,   							                                        \r\n"+ 
"   top:'18px',                                                                             \r\n"+ 
"	items:[bulletinnormal,combobox,bulletinsimple]    							                                            \r\n"+ 
"	}										                     	                        \r\n"+
");   \r\n";
var resource = "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinNormal.js'></script>   \r\n";
    resource += "<script type='text/javascript' src='/widgets/Layouter/js/GridLayouter.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/ComboBox.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets/Panel/js/Panel.js'></script>              \r\n";
    resource+= "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinSimple.js'></script>   \r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

