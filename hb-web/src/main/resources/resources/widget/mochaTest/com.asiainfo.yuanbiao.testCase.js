var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml = "<div id='test'></div>";
var initScript=
"var testData = [{ 'menuName': '菜单1',       \r\n"+
"  'hasChild':'Y',            \r\n"+
"  'menuId':'1',            \r\n"+
"  'children': [              \r\n"+
"  {'menuName': '菜单1-1',                 \r\n"+
"  'menuId':'11',            \r\n"+
"  'hasChild':'Y',            \r\n"+
"  'children':[         \r\n"+
"  {'menuName': '菜单1-1-1',                 \r\n"+
"  'menuId':'111',            \r\n"+
"  'hasChild':'N',            \r\n"+
"  'children':null            \r\n"+
"}]}] \r\n"+
"}];  \r\n"+
"var fnDblClick = function(data){  \r\n"+
"	console.log(data);   \r\n"+
"}  \r\n"+
"var bulsimp1 = Widget.create('bulletinmenu',			         \r\n"+
"	{										                     \r\n"+
"		column:1,										         \r\n"+
"       appendTo:'#test',										 \r\n"+
"       titleColor:'#ADDCFE',								     \r\n"+
"		titleText:'高校指标',	                                 \r\n"+
"		lineNum:'6',											 \r\n"+
"		funcTitle:'更多',				                         \r\n"+
"		dataList:testData,			                             \r\n"+
"		fnDblClick:fnDblClick	                                     \r\n"+
"	});											                 \r\n"+
// "var fields = [{'fieldName':'a1','title':'第一列','fnClick':function(){aler");";	
// t('1111')}},{'fieldName':'a2','title':'第二列'},{'fieldName':'a3','title':'第三列'}];\r\n"+
// // "var opts = {};opts.dataList = dataList;opts.fields = fields;opts.appendTo = '#test';\r\n"+
 "var widgetstable = Widget.create('bulletinmenu',bulsimp1);  \r\n";

;
var resource = "<script type='text/javascript' src='/widgets/Layouter/js/GridLayouter.js'></script>\r\n";
    resource += "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinImage.js'></script>   \r\n";
    resource += "<script type='text/javascript' src='/widgets/Layouter/js/DefaultLayouter.js'></script> \r\n";
    resource+= "<script type='text/javascript' src='/widgets/Bulletin/js/BulletinMenu.js'></script>   \r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);





