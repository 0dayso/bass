function getSpaceLevel(e){for(var t="",n=0;e>n;n++)t+="&nbsp;&nbsp;&nbsp;&nbsp;";return t}function checkDataBiz(e){return _.isEmpty(e)?e:(e=e.replace(/,/g,""),parseFloat(e)/1e4)}var _clickMenu="",adaptContentCtrl=function(e,t){e.menuData=null,!_.isEmpty(menu)&&!_.isEmpty(menu.children)&&0<menu.children.length&&($("#content #wid-id-1 header .widgetHeader").empty().append(menu.children[0].menuName),$("#content div header .widgetHeaderIcon").click(function(){$("#content article div content div[parentId][parentId!='0']").hide(),$("#content article div content").is(":hidden")?($("#content article div content").show(),$("#content div header .widgetHeaderIcon").children("i").removeClass("icon-double-angle-up"),$("#content div header .widgetHeaderIcon").children("i").addClass("icon-double-angle-down")):($("#content article div content").hide(),$("#content div header .widgetHeaderIcon").children("i").removeClass("icon-double-angle-down"),$("#content div header .widgetHeaderIcon").children("i").addClass("icon-double-angle-up"))}),_.isEmpty(menu.children[0].children)||(e.menuData=menu.children[0].children,$("#content #wid-id-1 content").empty().append(getMenusHtml(menu.children[0].children,0,0))),$("#content article div content div[menuId]").click(function(t){_clickMenu=$(this).attr("menuId"),e.$broadcast("changeMenuId",_clickMenu)}),$("#content article div content div[menuId] .content_row_icon").click(function(){var e=$(this).parent("[menuId]").attr("menuId");$(this).children("i").hasClass("icon-double-angle-down")?($("#content article div content div[parentId][parentId='"+e+"']").show(),$(this).children("i").removeClass("icon-double-angle-down"),$(this).children("i").addClass("icon-double-angle-up")):($("#content article div content div[parentId][parentId='"+e+"']").hide(),$(this).children("i").removeClass("icon-double-angle-up"),$(this).children("i").addClass("icon-double-angle-down"))}),$("#content article div content div[parentId][parentId!='0']").hide(),""==_clickMenu&&$("#content article div content div[parentId][parentId='0']:first").trigger("click"))};adaptContentCtrl.$inject=["$scope","$http"];var getMenusHtml=function(e,t,n){var i='<div menuId="<%=_menu.menuId%>" parentId="<%=parentId%>"><div class="content_row"><%=getSpaceLevel(level)%><%=_menu.menuName%></div><% if (!_.isEmpty(_menu.children)){%><div class="content_row_icon pull-right"><i class="icon-double-angle-down"></i></div><%}%></div>',c=_.template(i),a="";return _.isEmpty(e)||_.each(e,function(e){a+=c({_menu:e,parentId:t,level:n}),a+=getMenusHtml(e.children,e.menuId,n+1)},this),a},_selectTime="",adaptZbModule=angular.module("adaptZbModule",[],postParamFn),adaptZbSelectCtrl=function(e,t){e.selectQuery={},e.$on("changeMenuId",function(t,n){e.selectQuery.menuId!=n&&(e.selectQuery.menuId=n,e.selectZbTable())}),""===_selectTime&&t({url:basePath+"/roleAdapt/defaultTime",method:"POST"}).success(function(t){e.selectQuery.menuId=_clickMenu,e.selectQuery.time=t,e.selectQuery.timeType="yymmdd",e.selectQuery.dimType="Channle",e.selectQuery.regionId=regionId,e.selectZbTable()}).error(function(e,t,n,i){}),e.selectTime=function(){"yymm"==e.selectQuery.timeType&&$(".hasDatepicker .ui-datepicker-calendar").css("display","none"),$("article div content .zbSelect .timebox .caret").show()},$("article div content .zbSelect .timebox .caret").datepicker({changeMonth:!0,changeYear:!0,dateFormat:"yymmdd",showMonthAfterYear:!0,yearSuffix:"年",monthNames:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],monthNamesShort:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],dayNamesMin:["日","一","二","三","四","五","六"],onSelect:function(){if("yymmdd"==e.selectQuery.timeType){$("article div content .zbSelect .timebox .caret").hide();var t=$("article div content .zbSelect .timebox .caret").datepicker("getDate");t=$.datepicker.formatDate("yymmdd",t),$("article div content .zbSelect .zbTimeSelect").html(t),e.selectQuery.time=t,e.selectZbTable()}},onChangeMonthYear:function(t,n,i){if("yymm"==e.selectQuery.timeType){var c=new Date(t,n-1,1);$("article div content .zbSelect .timebox .caret").hide(),c=$.datepicker.formatDate("yymm",c),$("article div content .zbSelect .zbTimeSelect").html(c),e.selectQuery.time=c,e.selectZbTable()}}}).hide(),e.changeTimeType=function(t){e.selectQuery.timeType=t,e.selectZbTable()},e.changeDimType=function(t){e.selectQuery.dimType=t,e.selectZbTable()},$("article div content .zbSelect .cycleZb input,article div content .zbSelect .dimType input").iCheck({checkboxClass:"icheckbox_square-blue hover",radioClass:"iradio_square-blue hover"}),$("article div content .zbSelect .cycleZb input").on("ifChecked",function(t){this.value!=e.selectQuery.timeType&&e.changeTimeType(this.value)}),$("article div content .zbSelect .dimType input").on("ifChecked",function(t){this.value!=e.selectQuery.dimType&&e.changeDimType(this.value)}),e.selectZbTrendShow=function(){var e=$("article div content .zbSelect .showZbTrend").html();null!=e&&0<=e.indexOf("不")?($("article div content .zbSelect .showZbTrend").html("显示图标"),alert("隐藏图!")):($("article div content .zbSelect .showZbTrend").html("不显示图标"),alert("显示图!"))},e.selectZbTable=function(){t({url:"../getKpiData",data:e.selectQuery,method:"POST"}).success(function(t){console.log(t),e.showZbTable(t)}).error(function(e,t,n,i){alert(t)})},e.yymmddTempleTitle="<tr><th></th><th>日</th><th>较昨日</th><th>较上月同期</th><th>日累计</th><th>较去年同期</th><th>操作</th></tr>",e.yymmddTempleContent='<tr class="<%=index%2==0?"":"alter"%>"><td><%=(index!=0?"&nbsp;&nbsp;":"")%><%=data.menuName%></td><td><%=checkDataBiz(data.valueD.current)%></td><td><%=data.valueD.todayOnYesterday%></td><td><%=data.valueD.monthOnMonth%></td><td><%=checkDataBiz(data.valueAD.current)%></td><td><%=data.valueAD.yearOnYear%></td><td style="text-align: center;"><i class="icon-list-alt " style="color:#4ad486"></i>&nbsp;&nbsp;<i class="icon-star" style="color:#3ca2db"></i></td></tr>',e.yymmTempleTitle="<tr><th></th><th>月</th><th>较上月</th><th>较去年同期</th><th>月累计</th><th>较去年同期</th><th>操作</th></tr>",e.yymmTempleTitleContent='<tr class="<%=index%2==0?"":"alter"%>"><th></th><th>月</th><th>较上月</th><th>较去年同期</th><th>月累计</th><th>较去年同期</th><th style="text-align: center;">操作</th></tr>',e.showZbTable=function(t){var n=$("article div content .zbshowArea table"),i="yymm"==e.selectQuery.timeType?_.template(e.yymmTempleTitle):_.template(e.yymmddTempleTitle);n.empty().append(i());var c="yymm"==e.selectQuery.timeType?_.template(e.yymmTempleTitleContent):_.template(e.yymmddTempleContent);if(!_.isEmpty(t)&&(n.append(c({index:0,data:t})),!_.isEmpty(t.children)))for(var a=0;a<t.children.length;a++)n.append(c({index:a+1,data:t.children[a]}))}};adaptZbSelectCtrl.$inject=["$scope","$http"],$(function(){});