//初始化测试模块
var runner = require("./mochaFrame/testCaseRunner.js");
var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");

/*
date:'2015-09-28',type:'background',author:'liufz',widget:'widgetInput',detail:'新建widgetInput并测试'
*/
// runner.runCase("widgetInput.test");
/*
date:'2015-09-28',type:'browse',author:'liufz',widget:'widgetInput',detail:'新建widgetInput并测试'
*/

var initHtml = "<div id='testDiv'></div>";
var initScript= 
"var s = WidgetInput.createNew(					\r\n"+
"	{											\r\n"+
"		id:'inputtest',							\r\n"+
"		value:'input',							\r\n"+
"		name:'inp',								\r\n"+
"		style:'width:45px;height:45px',			\r\n"+
"		cls:'defaultCls',						\r\n"+
"		disabled:'',							\r\n"+
"		readOnly:'',							\r\n"+
"		referTo:'testDiv',						\r\n"+
"		listener:{								\r\n"+
"			click:function(){					\r\n"+
"				alert(s.getValue());			\r\n"+
"			}									\r\n"+
"		}										\r\n"+
"	}											\r\n"+
");												\r\n"+
"s.setValue('test');							\r\n"						
// "s.refer('testDiv')"	;	
var resource = "<script type='text/javascript' src='/Widgets/WidgetInput.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);


/*
date:'2015-09-28',type:'create',author:'liufz',widget:'widgetButton',detail:'新建widgetButton并测试'
date:'2015-10-02',type:'modify',author:'wanghf',widget:'widgetButton',detail:'新增事件模型机制并调优'
*/
// runner.runCase("widgetButton.test");
var initHtml = "<div id='testDiv'></div>";
var initScript= 
"var s = WidgetButton.createNew(				\r\n"+
"	{											\r\n"+
"		id:'button',							\r\n"+
"		btnType:'reset',							\r\n"+//reset,submit,默认button
"		text:'but',								\r\n"+
"		style:'width:45px;height:45px',			\r\n"+
"		cls:'',									\r\n"+
"		disabled:'',							\r\n"+
"		referTo:'testDiv',						\r\n"+
"		referType:'',							\r\n"+//after,wrap,replaceWith,默认append
"		listener:{								\r\n"+
"			click:function(){					\r\n"+
"				alert(this.getText());			\r\n"+
"				alert(this.setText('clik '));			\r\n"+
"			}									\r\n"+
"		}										\r\n"+
"	}											\r\n"+
");												\r\n"+
"s.setText('test');								\r\n";
var resource = "<script type='text/javascript' src='/Widgets/WidgetButton.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);
 
/*
date:'2015-09-28',type:'create',author:'liufz',widget:'widgetLabel',detail:'新建widgetLabel并测试'
date:'2015-10-02',type:'modify',author:'wanghf',widget:'widgetLabel',detail:'新增事件模型机制并调优'
*/
//runner.runCase("widgetLabel.test");
var initHtml = "<div id='testDiv'></div>";
var initScript= 
"var s = WidgetLabel.createNew(					\r\n"+
"	{											\r\n"+
"		id:'label',								\r\n"+
"		For:'label',							\r\n"+
"		text:'label',							\r\n"+
"		cls:'defaultCls',						\r\n"+
"		listener:{								\r\n"+
"			click:function(text){		\r\n"+
"				alert('当前text:'+text);		\r\n"+
"				this.setText('test');		\r\n"+
"			}									\r\n"+
"		},										\r\n"+
"		referTo:'testDiv'						\r\n"+
"	}											\r\n"+
");												\r\n";
// "s.refer('testDiv')";					
													
var resource = "<script type='text/javascript' src='/Widgets/WidgetLabel.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
date:'2015-08-31',type:'create',author:'liufz',widget:'widgetRadioBox',detail:'新建widgetRadioBox并测试'
date:'2015-10-02',type:'modify',author:'wanghf',widget:'widgetRadioBox',detail:'新增事件模型机制并调优'
*/
// runner.runCase("widgetRadioBox.test.getValue()");
var initHtml = "<div id='testDiv'></div>";
var initScript= 
"var radioBox = WidgetRadioBox.createNew(		\r\n"+
"	{											\r\n"+
"		id:'radio',								\r\n"+
"		name:'radioBox',						\r\n"+
"		disabled:'',						\r\n"+
"		value:'1',						\r\n"+
"		cls:'defaultCls',						\r\n"+
"		data:[{value:'1',displayValue:'1'},{value:'2',displayValue:'2'},{value:'3',displayValue:'3'}],	\r\n"+
"		referTo:'testDiv',						\r\n"+
"		listener:{								\r\n"+
"			check:function(checkedValue){	\r\n"+
"				alert(this.value);		\r\n"+
"			}									\r\n"+
"		}										\r\n"+
"	}											\r\n"+
");												\r\n"+
// "radioBox.referTo('testDiv');					\r\n"+
"radioBox.setValue('2')";
var resource = "<script type='text/javascript' src='/Widgets/WidgetRadioBox.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetInput.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetLabel.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
date:'2015-09-01',type:'create',author:'zhouy',widget:'widgetCombo',detail:'新建widgetCombo并测试'
date:'2015-10-04',type:'modify',author:'wanghf',widget:'widgetLabel',detail:'新增事件模型机制并调优'
*/
//runner.runCase("widgetCombo.test");
var initHtml = "<div id='testDiv'></div>";
var initScript= 
"var s = WidgetCombo.createNew(								\r\n"+
"	{														\r\n"+
"		id:'widgetCombo',									\r\n"+
"		value:'005',										\r\n"+
"		cls:'textCls',										\r\n"+
"		data:[{value:'001',displayValue:'option1'},			\r\n"+
"			  {value:'002',displayValue:'option2'},			\r\n"+
"			  {value:'003',displayValue:'option3'}],		\r\n"+
"		listener:{											\r\n"+
"			change:function(newValue,oldValue){				\r\n"+
"				alert(newValue+','+oldValue);				\r\n"+
"			}												\r\n"+
"		},													\r\n"+
"		referTo:'testDiv'									\r\n"+	
"		}													\r\n"+
");															\r\n"+
// "s.referTo('testDiv')									\r\n";
"//s.setValue('001');s.setValue('002');alert(s.getValue());";
var resource = "<script type='text/javascript' src='/Widgets/WidgetCombo.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
date:'2015-10-12',type:'create',author:'liufz',widget:'widgetPanel',detail:'新建widgetPanel并测试'
*/
var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='testDiv'></div>";
var initScript=
"var panel1 = WidgetPanel.createNew(				\r\n"+
"	{											\r\n"+
"		titleText:'相关指数111111111111111111111111'					\r\n"+
"	}											\r\n"+
");												\r\n"+	
"var panel2 = WidgetPanel.createNew(				\r\n"+
"	{											\r\n"+
"		titleText:'相关指数'					\r\n"+
"	}											\r\n"+
");												\r\n"+	
"var panel3 = WidgetPanel.createNew(				\r\n"+
"	{											\r\n"+
"		titleText:'相关指数'					\r\n"+
"	}											\r\n"+
");												\r\n"+		
"var panel4 = WidgetPanel.createNew(				\r\n"+
"	{											\r\n"+
"		titleText:'相关指数'					\r\n"+
"	}											\r\n"+
");												\r\n"+		
"var panel5 = WidgetPanel.createNew(				\r\n"+
"	{											\r\n"+
"		titleText:'相关指数'					\r\n"+
"	}											\r\n"+
");												\r\n"+	
"var btn = WidgetButton.createNew(					\r\n"+
"	{											\r\n"+
"		id:'button',							\r\n"+
"		btnType:'button',						\r\n"+//reset,submit,默认button
"		text:'but',								\r\n"+
"		cls:'',									\r\n"+
"		disabled:'',							\r\n"+
"		referType:'',							\r\n"+//after,wrap,replaceWith,默认append
"		listener:{								\r\n"+
"			click:function(){					\r\n"+
"				panel.setHeight(parseInt(panel.getHeight())+100);			\r\n"+
"				//alert(panel.getHeight());			\r\n"+
"			}									\r\n"+
"		}										\r\n"+
"	}											\r\n"+
");												\r\n"+		
"var panel = WidgetPanel.createNew(					\r\n"+
"	{											\r\n"+
"		width:'900',							\r\n"+
"		height:'10',							\r\n"+
"		panelCls:'',						\r\n"+
"		titleCls:'',						\r\n"+
"		contentCls:'',					\r\n"+
"		titleText:'相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数相关指数',					\r\n"+
"		panelStyle:'',			\r\n"+
"		titleStyle:'',	 \r\n"+
"		contentStyle:'',	 \r\n"+
"		items:[panel1,panel2,panel3,panel4,panel5,btn],\r\n"+
"		referTo:'testDiv'						\r\n"+
"	}											\r\n"+
");												\r\n"			
// "panel.refer('testDiv')"	;	
var resource = "<script type='text/javascript' src='/Widgets/WidgetPanel.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetButton.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

/*
date:'2015-10-10',type:'create',author:'liufz',widget:'WidgetNotice',detail:'新建WidgetNotice并测试'
date:'2015-10-02',type:'modify',author:'liufz',widget:'WidgetNotice',detail:'增加三种颜色'
*/
//初始化测试模块
var runner = require("./mochaFrame/testCaseRunner.js");
var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");

var initHtml = "<div id='testDiv'></div>";
var initScript=
"var notice = WidgetNotice.createNew(			\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		//noticeStyle:'',						\r\n"+
"		titleColor:'',							\r\n"+//type='normal'时 yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'更多》》》》',				\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		titleText:'报表中心报表中心报表中心报表中心',	\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'normal',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'Http://www.baidu.com'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}],			\r\n"+
"		referTo:'testDiv'						\r\n"+
"	}											\r\n"+
");												\r\n"			
// "notice.refer('testDiv')"	;	
var resource = "<script type='text/javascript' src='/Widgets/WidgetNotice.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);


/*widgetBulletinBoard 10-12
*modif by 10-15
*/ 
/*
date:'2015-10-12',type:'create',author:'liufz',widget:'widgetBulletinBoard',detail:'新建widgetBulletinBoard并测试'
date:'2015-10-15',type:'modify',author:'liufz',widget:'widgetBulletinBoard',detail:'调优'
*/
var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='testDiv'></div>";
var initScript=
"var bulletinBoard = WidgetBulletinBoard.createNew(		\r\n"+
"	{													\r\n"+
"		boardCls:'',									\r\n"+
"		//boardStyle:'',								\r\n"+
"		boardImgCls:'',									\r\n"+
"		//boardImgStyle:'',								\r\n"+
"		bulletinCls:'',									\r\n"+
"		//bulletinStyle:'',								\r\n"+
"		iconImgCls:'',									\r\n"+
"		//iconImgStyle:'',								\r\n"+
"		bulletinSrc:'../sass/image/bulletinBoard/image1.png',	\r\n"+
"		boardImgCls:'',									\r\n"+
"		//contentsStyle:'',								\r\n"+
"		contents:[{icon:'../sass/image/bulletinBoard/icon1.png',items:'高校统一视图审核11111111111111111111111111',listener:{click:function(){alert(notice.getWidth());}}},{icon:'../sass/image/bulletinBoard/icon2.png',items:'2015-05-05'}],			\r\n"+
"		listener:{										\r\n"+
"			click:function(){							\r\n"+
"				alert(1111);							\r\n"+
"			}											\r\n"+
"		},												\r\n"+
"		referTo:'testDiv'								\r\n"+
"	}													\r\n"+
");														\r\n"			
// "notice.refer('testDiv')"	;	
var resource = "<script type='text/javascript' src='/Widgets/WidgetBulletinBoard.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
// browseEvirnoment.setUpOrDown(initHtml,initScript,resource);



var initHtml = "<div id='testDiv'></div><div id='testDiv1'></div><div id='testDiv2'></div>";
var initScript=
"var bulletin = BulletinFactory.createNew(			\r\n"+
"	{											\r\n"+
"		bulletinType:'normal',					\r\n"+//normal或者simple或者icon
"		//noticeStyle:'',						\r\n"+
"		titleColor:'',							\r\n"+//type='normal'时 yellow blue red  
"		titleStyle:'',							\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'更多》》》》',				\r\n"+
"		bulletinSrc:'../sass/image/bulletinBoard/image1.png',				\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		listener:{								\r\n"+
"			rowClick:function(text,columnIndex){				\r\n"+
"	        	alert(text+columnIndex);      				\r\n"+
"			}   								\r\n"+
"		},   								\r\n"+
"		titleText:'报表中心报表中心报表中心报表中心',	\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'www.baidu.com',							\r\n"+
"		width:'',								\r\n"+
"		lineNum:'5',							\r\n"+
"		//numStyle:'',							\r\n"+
"		itemStyle:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			\r\n"+
"		applyTo:'testDiv'						\r\n"+
"	}											\r\n"+
");											\r\n"+
"var bulletin1 = BulletinFactory.createNew(			\r\n"+
"	{											\r\n"+
"		bulletinType:'simple',					\r\n"+//normal或者simple或者icon
"		//noticeStyle:'',						\r\n"+
"		titleColor:'',							\r\n"+//type='normal'时 yellow blue red  
"		titleStyle:'',							\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'更多》》》》',				\r\n"+
"		bulletinSrc:'../sass/image/bulletinBoard/image1.png',				\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		listener:{								\r\n"+
"			rowClick:function(text,columnIndex){				\r\n"+
"	        	alert(text+columnIndex);      				\r\n"+
"			}   								\r\n"+
"		},   								\r\n"+
"		titleText:'高校指标',	\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'www.baidu.com',							\r\n"+
"		width:'',								\r\n"+
"		lineNum:'5',							\r\n"+
"		//numStyle:'',							\r\n"+
"		itemStyle:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			\r\n"+
"		applyTo:'testDiv1'						\r\n"+
"	}											\r\n"+
");												\r\n"+
"var bulletin2 = BulletinFactory.createNew(			\r\n"+
"	{											\r\n"+
"		bulletinType:'icon',					\r\n"+//normal或者simple或者icon
"		//noticeStyle:'',						\r\n"+
"		titleColor:'',							\r\n"+//type='normal'时 yellow blue red  
"		titleStyle:'',							\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'更多》》》》',				\r\n"+
"		bulletinSrc:'../sass/image/bulletinBoard/image1.png',				\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		listener:{								\r\n"+
"			rowClick:function(text,columnIndex){				\r\n"+
"	        	alert(text+columnIndex);      				\r\n"+
"			}   								\r\n"+
"		},   								\r\n"+
"		titleText:'高校指标',	\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'www.baidu.com',							\r\n"+
"		width:'',								\r\n"+
"		lineNum:'5',							\r\n"+
"		//numStyle:'',							\r\n"+
"		itemStyle:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		datas:[{num:'1',icon:'../sass/image/bulletinBoard/icon1.png',text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:function(text){alert(text);}},{num:'2',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问1次'},{num:'3',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问22次'},{num:'4',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问333次'},{num:'5',icon:'../sass/image/bulletinBoard/icon1.png',text:'bbb',remark:'访问4444次'}],			\r\n"+
"		applyTo:'testDiv2'						\r\n"+
"	}											\r\n"+
");											\r\n"
// "notice.refer('testDiv')"	;	
var resource = "<script type='text/javascript' src='/widgets_v2/bulletin/js/Bulletin.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/bulletin/js/BulletinTitle.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/bulletin/js/BulletinImage.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/bulletin/js/BulletinContent.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/bulletin/js/BulletinRow.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/bulletin/bulletinFactory.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/gridNode/js/numNode.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/gridNode/js/iconNode.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/gridNode/js/remarkNode.js'></script>\r\n";
resource += "<script type='text/javascript' src='/widgets_v2/gridNode/js/textNode.js'></script>\r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);