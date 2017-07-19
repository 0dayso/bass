var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='appCenter'></div>";
var initScript= 
"var data = [{'rowid':1,'timerows':1,'count':2,'resource_id':'app110','resource_uri':'http://10.25.124.29/mvc/finance/1000000/rate','resource_name':'报表点击率1111111111111111111111111','menu_id':1000000,'lastupdate':1428668483742,'resource_desc':'报表点击率1111111111111111111111111111111111111111111111111111111111111111111','creater_id':'zhangwei','resource_img':null,'num':0,'ismycollect':1,'hotflag':'hot','newflag':'new'},{'rowid':2,'timerows':2,'count':2,'resource_id':'app100','resource_uri':'http://10.25.124.115:8084/mmp/page/campFeedback/businesshallCampFeedback.jsp','resource_name':'营销反馈汇总','menu_id':1000000,'lastupdate':1427194204506,'resource_desc':'营销反馈汇总','creater_id':'wanghaifu','resource_img':null,'num':0,'ismycollect':0,'hotflag':'hot','newflag':'old'},{'rowid':1,'timerows':1,'count':2,'resource_id':'app110','resource_uri':'http://10.25.124.29/mvc/finance/1000000/rate','resource_name':'报表点击率1111111111111111111111111','menu_id':1000000,'lastupdate':1428668483742,'resource_desc':'报表点击率','creater_id':'zhangwei','resource_img':null,'num':0,'ismycollect':1,'hotflag':'nohot','newflag':'new'},{'rowid':2,'timerows':2,'count':2,'resource_id':'app100','resource_uri':'http://10.25.124.115:8084/mmp/page/campFeedback/businesshallCampFeedback.jsp','resource_name':'营销反馈汇总','menu_id':1000000,'lastupdate':1427194204506,'resource_desc':'营销反馈汇总','creater_id':'wanghaifu','resource_img':null,'num':0,'ismycollect':0,'hotflag':'nohot','newflag':'old'},{'rowid':1,'timerows':1,'count':2,'resource_id':'app110','resource_uri':'http://10.25.124.29/mvc/finance/1000000/rate','resource_name':'报表点击率1111111111111111111111111','menu_id':1000000,'lastupdate':1428668483742,'resource_desc':'报表点击率','creater_id':'zhangwei','resource_img':null,'num':0,'ismycollect':1,'hotflag':'hot','newflag':'new'},{'rowid':2,'timerows':2,'count':2,'resource_id':'app100','resource_uri':'http://10.25.124.115:8084/mmp/page/campFeedback/businesshallCampFeedback.jsp','resource_name':'营销反馈汇总','menu_id':1000000,'lastupdate':1427194204506,'resource_desc':'营销反馈汇总','creater_id':'wanghaifu','resource_img':null,'num':0,'ismycollect':0,'hotflag':'hot','newflag':'new'},{'rowid':1,'timerows':1,'count':2,'resource_id':'app110','resource_uri':'http://10.25.124.29/mvc/finance/1000000/rate','resource_name':'报表点击率1111111111111111111111111','menu_id':1000000,'lastupdate':1428668483742,'resource_desc':'报表点击率','creater_id':'zhangwei','resource_img':null,'num':0,'ismycollect':1,'hotflag':'hot','newflag':'new'},{'rowid':2,'timerows':2,'count':2,'resource_id':'app100','resource_uri':'http://10.25.124.115:8084/mmp/page/campFeedback/businesshallCampFeedback.jsp','resource_name':'营销反馈汇总','menu_id':1000000,'lastupdate':1427194204506,'resource_desc':'营销反馈汇总','creater_id':'wanghaifu','resource_img':null,'num':0,'ismycollect':0,'hotflag':'hot','newflag':'new'}]\r\n"+
"var data1 = [{'rowid':1,'timerows':1,'count':2,'resource_id':'app110','resource_uri':'http://10.25.124.29/mvc/finance/1000000/rate','resource_name':'报表点击率1111111111111111111111111','menu_id':1000000,'lastupdate':1428668483742,'resource_desc':'报表点击率1111111111111111111111111111111111111111111111111111111111111111111','creater_id':'zhangwei','resource_img':null,'num':0,'ismycollect':1,'hotflag':'hot','newflag':'new'}]\r\n"+
"var bulletinleftimage = Widget.create('bulletinleftimage',{  \r\n"+
"	 column:0,  							 			\r\n"+
"    datas:data,										\r\n"+
"    src:'../../sass/image/applist/application.png',		\r\n"+
"    nameClick:function(e){alert(e);}				\r\n"+
"	 });  \r\n"+

"var Panel1= Widget.create('panel',                                                          \r\n"+
"	{											                                            \r\n"+
"	column:0,											                                   \r\n"+
//"	interval:'22px',											                            \r\n"+
"	title:'热门推荐' ,   							                                        \r\n"+ 
"   top:'18px',                                                                             \r\n"+
"	items:[bulletinleftimage]    							                                 \r\n"+ 
"	});                                                                                         \r\n"+

"	var  app_name=Widget.create('selfinput',{ \r\n"+
"	 	placeholder:'',\r\n"+
"	 	name:'应用名称'\r\n"+
"	}); 								\r\n"+

"	var  querybtn=Widget.create('selfbutton',{ \r\n"+
"    	title:'查询',\r\n"+
" 	 	click:function(){alert(app_name.getValue());pageHead.setNowpage(3);}\r\n"+
"	}); 											\r\n"+

"	var querybar= Widget.create('toolbar',{      \r\n"+
"		column:0,									 \r\n"+
"		row:0,										 \r\n"+
"		items:[app_name,querybtn]   				\r\n"+
"	});            \r\n"+ 

"   var groupBtnSort=Widget.create('selfbuttongroup',{\r\n"+
"		title:'排序',	\r\n"+
"		issplit:true,		\r\n"+
"		click:function(val){alert(val)},		\r\n"+
"		datas:[{name:\"相关性\",value:\"num\",isdefault:true},{name:\"最多浏览\",value:\"num\"},{name:\"最新上线\",value:\"create_dt\"}]		\r\n"+
" 	});			\r\n"+

"	var pageHead=Widget.create('page',{\r\n"+
"	float:'right',\r\n"+
"	lineperpage:8,\r\n"+
"	totalnum:data.length,\r\n"+
"	click:function(num){pageFoot.setNowpage(num);}\r\n"+
"	});\r\n"+

"	var pageFoot=Widget.create('page',{\r\n"+
"	float:'right',\r\n"+
"	lineperpage:8,\r\n"+
"	totalnum:data.length,\r\n"+
"	click:function(num){pageHead.setNowpage(num);}\r\n"+
"	});\r\n"+
"var Typeselect = Widget.create('selfselect',           \r\n"+
" {                                                 \r\n"+
"   name:'类型',                              \r\n"+
"   datas:[{key:'123',value:'haha1'},{key:'213',value:'haha2'},{key:'231',value:'haha3'}],                                    \r\n"+
"   clickFunc:function(value){alert(value);                               \r\n"+
"    alert(Typeselect.getValue()); }                                             \r\n"+
"                                               \r\n"+
" }                                                 \r\n"+
");\r\n"+

"	var menubar= Widget.create('toolbar',{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              \r\n"+
"	    items:[Typeselect,groupBtnSort]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        \r\n"+
"	});			\r\n"+

"var bulletintopimage = Widget.create('bulletintopimage',{  \r\n"+
"	 column:0,  							 			\r\n"+
"    datas:data,										\r\n"+
"    src:'../../sass/image/applist/app.png',		\r\n"+
"    nameClick:function(name,value){alert(name+' '+value);},				\r\n"+
"    collectClick:function(e){alert(e);}										\r\n"+
"	 });  \r\n"+
" bulletintopimage.load(data1);\r\n"+
"var pagepanel= Widget.create('pagepanel',                                                  \r\n"+
"	{											                                            \r\n"+
"	column:0,											                                    \r\n"+
"	row:1,											                                    \r\n"+
//"	interval:'22px',											                            \r\n"+
"	title:'相关指标' ,   							                                        \r\n"+ 
"   top:'18px',                                                                             \r\n"+ 
"	headLeftItems:[menubar],											                        \r\n"+
"	headRightItems:[pageHead],											                        \r\n"+
"	bodyItems:[bulletintopimage],    							                                    \r\n"+ 
"	footItems:[pageFoot]    							                                    \r\n"+ 
"	}										                     	                        \r\n"+
");                                                                                         \r\n"+

"var Panel2= Widget.create('panel',{											            \r\n"+
"	column:1,											                                   \r\n"+
//"	interval:'22px',											                            \r\n"+
"	title:'营销活动评估' ,   							                                        \r\n"+ 
"   top:'18px',                                                                             \r\n"+ 
"	layouter:{                                                                           \r\n"+
"		type:'grid',                                                                 \r\n"+
"		gridDefine:[[{width:'100%'}],[{width:'100%'}]],     \r\n"+
"		items:[querybar,pagepanel]                                    \r\n"+
"	}   							                                                \r\n"+
"});                                                                                         \r\n"+
	
"var applicationCenter= Widget.create('gridlayouter',{	\r\n"+
" 			minWidth:1186,								\r\n"+
" 			maxWidth:1325,								\r\n"+
//"			interval:'11px',	\r\n"+
"			applyTo:'#appCenter',	\r\n"+
"			gridDefine:[[{width:'19%',interval:'11px'},{width:'77%',interval:'12px 0 0 0'}]],		\r\n"+
"			items:[Panel1,Panel2]							\r\n"+
"});";					
var resource = "<script type='text/javascript' src='/widgets/Layouter/js/GridLayouter.js'></script>\r\n";
    resource += "<script type='text/javascript' src='/widgets/Layouter/js/DefaultLayouter.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/Panel/js/Panel.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/Panel/js/PagePanel.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinLeftImage.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinTopImage.js'></script> \r\n";
    resource += "<script type='text/javascript' src='/widgets/ToolBar/js/ToolBar.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets/ToolBar/js/Page.js'></script>     \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfInput.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfSelect.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfButton.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/SelfButtonGroup.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Table/js/ReportTable.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Table/js/ReportList.js'></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/es5-sham.min.js' ></script>             \r\n";
    resource += "<script type='text/javascript' src='/widgets/es5-shim.min.js' ></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/PIE_IE678.js' ></script>              \r\n";
    resource += "<script type='text/javascript' src='/widgets/Form/js/ComboBox.js'></script>     \r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);

