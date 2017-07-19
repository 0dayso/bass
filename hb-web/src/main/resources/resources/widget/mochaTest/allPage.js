var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = 	"<div id='left_box' class='left_box'>"+
				  "</div>"+
				"<div id='part' class='part'>"+
					"<div id='box1' class=''></div>"+
					"<div id='box2' class=''></div>"+
					"<div id='box3' class=''></div>"+
					"<div id='box4' class=''></div>"+
				  "</div>";			  
var initScript=
"var bulletin = WidgetBulletin.createNew(			        \r\n"+//公告
"	{	     									    \r\n"+
"	id:'WidgetBulletin',    					    \r\n"+
"	referTo:'box1',    							    \r\n"+
"	cls:'Bulletin',    								\r\n"+
"	iconSrc:'http://localhost/test4/icon.png',      \r\n"+
"	iconCls:'IconCls',    					        \r\n"+
"	funcTitle:'更多123',   						    \r\n"+
"	funcTitleCls:'FuncTitle',    			    	\r\n"+
"	funcListener:{click:function(funcTitle){alert(this.funcTitle)}} , \r\n"+	
"	title:'系统公告:',    						    \r\n"+
"	titleCls:'TitleCls',    						\r\n"+
"	content:'2015-10-15日 关于数据延迟发布原因进行说明eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',     \r\n"+
"	contentCls:'ContentCls'    						\r\n"+
"	}											    \r\n"+
");\r\n"+

"var radio1 = WidgetRadio.createNew(         \r\n"+
"   {                                           \r\n"+
"       spanCls:'',                 \r\n"+
//"     spanStyle:'opacity:0;cursor:pointer;filter:alpha(opacity=0)',   \r\n"+
"       name:'1',                               \r\n"+
"       inputCls:'',                    \r\n"+
//"     inputStyle:'width: 24px;height: 18px;float: left;padding-top:3px;cursor:pointer;text-align: center;margin-right: 10px;background-image:url(../sass/image/iconOff.png);background-repeat: no-repeat;background-position: -24px 0px',                 \r\n"+
"       disabled:'',                            \r\n"+
"       data:[{value:'day',displayValue:'日'},{value:'month',displayValue:'月'}],   \r\n"+
"       listener:{                              \r\n"+
"           check:function(radio){              \r\n"+
"               alert(this.value);              \r\n"+
"           }                                   \r\n"+
"       }                                       \r\n"+
"   }                                           \r\n"+
");                                             \r\n"+
" radio1.setValue('day');                       \r\n"+
"var carList = WidgetCarList.createNew(               	\r\n"+
" {                                             	\r\n"+
"   id:'nav',                                   	\r\n"+
"   type:'label',                                   \r\n"+//label或者input
"   defaultValue:'apple4',                          \r\n"+
"   CLCls:'',                             			\r\n"+
"   headCls:'',                             		\r\n"+
"   textCls:'',                             		\r\n"+
"   imgStyle:'padding:7px',                     	\r\n"+
"   width:'',                        				\r\n"+
"   //isFlow:false,                               	\r\n"+//流式布局用true 默认false
"   contentWidth:'',                        		\r\n"+//流式布局时使用
"   optionCls:'',                         			\r\n"+
"   contentCls:'',                              	\r\n"+
"   imgCls:'',                            			\r\n"+
"   src:'../sass/image/list.jpg',               	\r\n"+
"   labelcls:'labelCls',                        	\r\n"+
"   referTo:'menu',                             	\r\n"+
"   disabled:'',                                	\r\n"+
"   data:[{value:'apple',displayValue:'苹果'},    	\r\n"+
"         {value:'apple1',displayValue:'苹果1'},  	\r\n"+
"         {value:'apple2',displayValue:'苹果2'},  	\r\n"+
"         {value:'apple3',displayValue:'苹果3'},  	\r\n"+
"         {value:'apple4',displayValue:'苹果44444444444444444'},  \r\n"+
"         {value:'apple5',displayValue:'苹果5'},  	\r\n"+
"         {value:'apple6',displayValue:'苹果6'},  	\r\n"+
"         {value:'apple7',displayValue:'苹果7'},  	\r\n"+
"         {value:'pears',displayValue:'凤梨'}],   	\r\n"+
"   listener:{                                    	\r\n"+
"     select:function(){                           	\r\n"+
"       alert(this.value);                        	\r\n"+
"     }                                           	\r\n"+
"   }                                             	\r\n"+
" }                                               	\r\n"+
");//alert(carList.getValue())                       \r\n"+ 
"var label = WidgetLabel.createNew(				\r\n"+
"	{											\r\n"+
"		id:'',									\r\n"+
"		For:'',									\r\n"+
"		text:'显示图标',						\r\n"+
"		color:'#94a2b2',						\r\n"+
"		cls:'labelCls',							\r\n"+
"		listener:{								\r\n"+
"			click:function(text){				\r\n"+
"				alert('当前text:'+text);		\r\n"+
"				this.setText('test');			\r\n"+
"			}									\r\n"+
"		}										\r\n"+
"	}											\r\n"+
");												\r\n"+
"var radio2 = WidgetRadio.createNew(         		\r\n"+
"   {                                           \r\n"+
"       spanCls:'',                 			\r\n"+
//"     spanStyle:'opacity:0;cursor:pointer;filter:alpha(opacity=0)',   \r\n"+
"       name:'1',                               \r\n"+
"       inputCls:'',                    		\r\n"+
//"     inputStyle:'width: 24px;height: 18px;float: left;padding-top:3px;cursor:pointer;text-align: center;margin-right: 10px;background-image:url(../sass/image/iconOff.png);background-repeat: no-repeat;background-position: -24px 0px',                 \r\n"+
"       disabled:'',                            \r\n"+
"       data:[{value:'entryPoint',displayValue:'入网点'},{value:'area',displayValue:'区域'}],   \r\n"+
"       listener:{                              \r\n"+
"           check:function(radio){              \r\n"+
"               alert(this.value);              \r\n"+
"           }                                   \r\n"+
"       }                                       \r\n"+
"   }                                           \r\n"+
");                                             \r\n"+
" radio2.setValue('entryPoint');                \r\n"+

"var toolbar = WidgetToolBar.createNew(               \r\n"+
"   {                                           \r\n"+
"       LabelText:'',                           \r\n"+
"       labelCls:'TLabelCls',                   \r\n"+
"       items:[radio1,carList,label,radio2],            \r\n"+
"       referTo:'test'                          \r\n"+
"   }                                           \r\n"+
");												\r\n"+

 "var table=WidgetTable.createNew({\r\n"+
"		referTo:'test',\r\n"+
"		id:'treeTable1',\r\n"+
"		cls:'tableCls',\r\n"+
"		tbodyCls:'tbodyCls',\r\n"+
"		thCls:'theadCls',\r\n"+
"		theadCls:'theadCls',\r\n"+
"		tdCls:'tbodyTrCls',\r\n"+
"		columnsTrCls:'ColumnsTrCls',\r\n"+
"		showHead:true,\r\n"+
"		isSort:true,\r\n"+
"		columns:[\r\n"+
"					{title:'收入类',nameIndex:'item',type:'str'},\r\n"+
"					{title:'日',nameIndex:'day',type:'int'},\r\n"+
"					{title:'较昨日',nameIndex:'yesterDay',width:32,type:'date'},\r\n"+
"					{title:'较上月同期',nameIndex:'yesterMonth',width:50},\r\n"+
"					{title:'较上月',nameIndex:'daySum',width:50},\r\n"+
"					{title:'较去年同期',nameIndex:'lastYear',width:50},  \r\n"+
"					{title:'操作',nameIndex:'deal',width:50}  \r\n"+

"],				\r\n"+
"		store:[\r\n"+
"					{item:'月租[无]',day:'234234',yesterDay:'2015/08/09',lastMonth:'105.12',daySum:'8,744.31',lastYear:'26.01%',yesterMonth:'45%',deal:'',stores:[{item:'月租实时',day:'234',yesterDay:'1.4%',lastMonth:'20.12',daySum:'4,782',yesterMonth:'13%',lastYear:'5.2%',deal:''}]},\r\n"+
"					{item:'语音收入',day:'123',yesterDay:'2015/08/06',lastMonth:'无',daySum:'无',lastYear:'-',yesterMonth:'-',deal:''},\r\n"+
"					{item:'短彩信收入',day:'456',yesterDay:'2015/01/3',stores:[{item:'0_1',stores:[{item:'0_1_1',stores:[{item:'0_1_2',stores:[{item:'0_1_3',stores:[]}]}]}]}]},\r\n"+
"					{item:'无线上网业务收入(元)',day:'789',yesterDay:'2015/03/02',lastMonth:'无',daySum:'无',lastYear:'502,342',yesterMonth:'-',deal:''},\r\n"+
"					{item:'语音增值业务收入',day:'564'},\r\n"+
"					{item:'数据业务收入',day:'342',stores:[{item:'1_1',stores:[{item:'1_1_1',stores:[{item:'1_1_1_1'},{item:'1_1_1_2'}]},{item:'1_1_2'}]},{item:'1_2级'}]},\r\n"+
"					{item:'各地市收入',day:'0',stores:[{item:'武汉市',day:'342',stores:[{item:'武昌'},{item:'汉口'},{item:'汉阳'}]},{item:'十堰市'},{item:'襄樊市'},{item:'随州市'},{item:'荆门市'},{item:'孝感市'},{item:'宜昌市'},{item:'黄冈市'},{item:'鄂州市'},{item:'荆州市'},{item:'黄石市'},{item:'咸宁市'}]}\r\n"+
"]				\r\n"+
"});table.setColumnWidth(2,100);\r\n"+
"var panel1 = WidgetPanel.createNew(					\r\n"+
"	{												\r\n"+
"		width:'',									\r\n"+
"		height:'',									\r\n"+
"		panelCls:'',								\r\n"+
"		titleCls:'',								\r\n"+
"		contentCls:'',								\r\n"+
"		titleText:'相关指数',						\r\n"+
"		panelStyle:'',								\r\n"+
"		titleStyle:'',								\r\n"+
"		contentStyle:'',	 						\r\n"+
"		items:[toolbar,table],									\r\n"+
"		referTo:'box2'								\r\n"+
"	}												\r\n"+
");													\r\n"+
"		panel1.setHeight(100);								\r\n"+

//panel
"var notice1 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		//noticeStyle:'',						\r\n"+
"		titleColor:'yellow',					\r\n"+//yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		fucTarget:'',							\r\n"+//_blank或者_self 默认_self
"		titleText:'报表中心',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'normal',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		itemTarget:'_self',						\r\n"+//_blank或者_self 默认_self
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}]			\r\n"+

"	}											\r\n"+
");												\r\n"+
"var notice2 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		noticeStyle:'',							\r\n"+
"		titleColor:'blue',						\r\n"+//yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		fucTarget:'',							\r\n"+//_blank或者_self 默认_self
"		titleText:'应用中心',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'normal',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		itemTarget:'_self',						\r\n"+//_blank或者_self 默认_self
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}]			\r\n"+

"	}											\r\n"+
");												\r\n"+	
"var notice3 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		noticeStyle:'',							\r\n"+
"		titleColor:'red',						\r\n"+//yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		fucTarget:'',							\r\n"+//_blank或者_self 默认_self
"		titleText:'我的收藏',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'normal',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		itemTarget:'_self',						\r\n"+//_blank或者_self 默认_self
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}]			\r\n"+
"	}											\r\n"+
");												\r\n"+				
"var panel2 = WidgetPanel.createNew(					\r\n"+
"	{											\r\n"+
"		width:'',								\r\n"+
"		height:'',								\r\n"+
"		panelCls:'',							\r\n"+
"		titleCls:'',							\r\n"+
"		contentCls:'',							\r\n"+
"		titleText:'相关推荐',					\r\n"+
"		panelStyle:'',							\r\n"+
"		titleStyle:'',				 			\r\n"+
"		contentStyle:'',	 					\r\n"+
"		items:[notice1,notice2,notice3],		\r\n"+
"		referTo:'box3'							\r\n"+
"	}											\r\n"+
");												\r\n"+			
// "panel.refer('testDiv')"	;	
//公告牌
"var bulletinBoard1 = WidgetBulletinBoard.createNew(		\r\n"+
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
"		}												\r\n"+
"	}													\r\n"+
");														\r\n"+
"var bulletinBoard2 = WidgetBulletinBoard.createNew(		\r\n"+
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
"		}												\r\n"+
"	}													\r\n"+
");														\r\n"+
"var bulletinBoard3 = WidgetBulletinBoard.createNew(		\r\n"+
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
"		}												\r\n"+
"	}													\r\n"+
");														\r\n"+
"var bulletinBoard4 = WidgetBulletinBoard.createNew(		\r\n"+
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
"		}												\r\n"+
"	}													\r\n"+
");														\r\n"+
"var panel3 = WidgetPanel.createNew(					\r\n"+
"	{											\r\n"+
"		width:'',								\r\n"+
"		height:'',								\r\n"+
"		panelCls:'',							\r\n"+
"		titleCls:'',							\r\n"+
"		contentCls:'',							\r\n"+
"		titleText:'相关推荐',					\r\n"+
"		panelStyle:'',							\r\n"+
"		titleStyle:'',				 			\r\n"+
"		contentStyle:'',	 					\r\n"+
"		items:[bulletinBoard1,bulletinBoard2,bulletinBoard3,bulletinBoard4],		\r\n"+
"		referTo:'box4'							\r\n"+
"	}											\r\n"+
");												\r\n"+	
//simple公告牌
"var notice4 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		noticeStyle:'',							\r\n"+
"		titleColor:'',							\r\n"+//yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		titleText:'高校指标',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'simple',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}],	\r\n"+
"		referTo:'left_box'						\r\n"+
"	}											\r\n"+
");												\r\n"+
"var notice5 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		noticeStyle:'',							\r\n"+
"		titleColor:'',							\r\n"+//type='normal'时 yellow blue red   
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		titleText:'高校指标',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'simple',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}],	\r\n"+
"		referTo:'left_box'						\r\n"+
"	}											\r\n"+
");												\r\n"+
"var notice6 = WidgetNotice.createNew(				\r\n"+
"	{											\r\n"+
"		noticeCls:'',							\r\n"+
"		noticeStyle:'',							\r\n"+
"		titleColor:'',							\r\n"+//yellow blue red  
"		titleCls:'',							\r\n"+
"		titleStyle:'',							\r\n"+
"		funcCls:'',								\r\n"+
"		//funcStyle:'',							\r\n"+
"		funcTitle:'',							\r\n"+
"		funcClick:function(text){alert(text);},	\r\n"+
"		titleText:'高校指标',					\r\n"+
"		titleSrc:'',							\r\n"+
"		funcHref:'',							\r\n"+
"		width:'',								\r\n"+
"		type:'simple',							\r\n"+//normal或者simple
"		lineNum:'5',							\r\n"+
"		numCls:'',								\r\n"+
"		//numStyle:'',							\r\n"+
"		itemCls:'',								\r\n"+
"		//itemStyle:'',							\r\n"+
"		remarkCls:'',							\r\n"+
"		//remarkStyle:'',						\r\n"+
"		contents:[{text:'这么11111111111111111111111111111111',remark:'访问999111次',listener:{click:function(text){alert(text);}},itemHref:'#'},{text:'bbb',remark:'访问1次'},{text:'bbb',remark:'访问22次'},{text:'bbb',remark:'访问333次'},{text:'bbb',remark:'访问4444次'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'},{text:'bbb',remark:'bbb'}],	\r\n"+
"		referTo:'left_box'						\r\n"+
"	}											\r\n"+
");												\r\n"	
	
var resource = "<script type='text/javascript' src='/Widgets/WidgetPanel.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetNotice.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetBulletin.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetBulletinBoard.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetTable.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetRadio.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetLabel.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetCarList.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/WidgetToolBar.js'></script>\r\n";
resource += "<script type='text/javascript' src='/Widgets/Widget.js'></script>\r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);


