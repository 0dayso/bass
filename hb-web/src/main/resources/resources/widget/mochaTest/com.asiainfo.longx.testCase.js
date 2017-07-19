//  toolbar测试 ;widget
var browseEvirnoment = require("./mochaFrame/browseEvirnoment.js");
var initHtml="<div id='toolbar'></div>";
    initHtml+="<label id='choice_date' style='padding-left:5px;' class='RadioContent'>2016-03-09</label>";
    <!--选择日期-->
var initScript=" DateBoxUtil.date({                             \r\n"+
"        JqElement: $('#choice_date'),                          \r\n"+
"        format:'yyyy-mm-dd',                                   \r\n"+
"        language: 'zh-CN',                                     \r\n"+
"        autoclose: true,                                       \r\n"+
"});";
initScript+=
"var radioBox1 = Widget.create('radiobox',                      \r\n"+
"   {                                                           \r\n"+
"       data:[{value:'day',text:'日'},                          \r\n"+
"             {value:'month',text:'月'}],                       \r\n"+
"       checked:function(){                                     \r\n"+
"               alert(this.value);                              \r\n"+
"           }                                                   \r\n"+
"   }                                                           \r\n"+
");radioBox1.setValue('day');";
initScript+=
"var radioBox2 = Widget.create('radiobox',                      \r\n"+
"   {                                                           \r\n"+
"       data:[{value:'point',text:'入网点'},                    \r\n"+
"             {value:'area',text:'区域'}],                      \r\n"+
"       checked:function(value){                                \r\n"+
"               alert(value);                                   \r\n"+
"           }                                                   \r\n"+
"   }                                                           \r\n"+
");radioBox2.setValue('point');";
<!--combox选择地名-->
initScript+=
"var combobox = Widget.create('combobox',           \r\n"+
" {                                                 \r\n"+
"   type:'label',                                   \r\n"+//label或者input
"   defaultValue:'JM',                              \r\n"+
"   isFlow:false,                                   \r\n"+//流式布局用true 默认false
"   contentWidth:'100px',                           \r\n"+//流式布局时使用
"   disabled:'',                                    \r\n"+
"   data:[{value:'JM',displayValue:'荆门'},           \r\n"+
"         {value:'WC',displayValue:'武昌'},          \r\n"+
"         {value:'XG',displayValue:'孝感'},          \r\n"+
"         {value:'JZ',displayValue:'荆州'},          \r\n"+
"         {value:'WH',displayValue:'武汉'},         \r\n"+
"         {value:'XY',displayValue:'襄阳'}],          \r\n"+
"   listener:{                                      \r\n"+
"     select:function(value){                       \r\n"+
"       alert(value);                               \r\n"+
"     }                                             \r\n"+
"   }                                               \r\n"+
" }                                                 \r\n"+
"); combobox.setValue('XG'); ";
initScript+=
"var lable_split1= Widget.create('selflabel',{title:'|'});                                                          \r\n"+
"var lable_split2= Widget.create('selflabel',{title:'|'});                                                          \r\n"+
"var lable_split3= Widget.create('selflabel',{title:'|'});                                                          \r\n"+
"var lable_split4= Widget.create('selflabel',{title:'|'});                                                          \r\n"+
"var selfbutton= Widget.create('selfbutton',                                                                        \r\n"+
"           {                                                                                                       \r\n"+
"            title:'显示图表'                                                                                       \r\n"+
"});                                                                                                                \r\n"+
"var toolbar= Widget.create('toolbar',                                                                              \r\n"+
"           {                                                                                                       \r\n"+
"            applyTo:'toolbar',                                                                                     \r\n"+
"            items:[$('#choice_date'),lable_split1,radioBox1,lable_split2,combobox,lable_split3,selfbutton,lable_split4,radioBox2]    \r\n"+
"});";
var resource = "<script type='text/javascript' src='/widgets_v2.0.1/ToolBar/js/ToolBar.js'></script>                \r\n"; 
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Layouter/js/DefaultLayouter.js'></script>      \r\n";
    resource += "<script type='text/javascript' src='/Widgets/DateBoxUtil.js'></script>                             \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Form/js/SelfButton.js'></script>               \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Form/js/ComboBox.js'></script>                 \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Form/js/SelfLabel.js'></script>                \r\n";
    resource += "<script type='text/javascript' src='/widgets_v2.0.1/Form/js/RadioBox.js'></script>                 \r\n";
browseEvirnoment.setUpOrDown(initHtml,initScript,resource);