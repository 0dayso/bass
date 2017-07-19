/**
 * creater by zhangds
 * date 2015-11-15
 */
var _clickMenu = "";
var adaptContentCtrl = function ($scope , $http) {
	$scope.menuData = null ;
	if (!_.isEmpty(menu)&&!_.isEmpty(menu.children)&&0<menu.children.length){
		$("#content #wid-id-1 header .widgetHeader").empty().append(menu.children[0].menuName);
		//头部的收缩
		$("#content div header .widgetHeaderIcon").click(function(){
			$("#content article div content div[parentId][parentId!='0']").hide();
			if (!$("#content article div content").is(':hidden')){
				$("#content article div content").hide();
				$("#content div header .widgetHeaderIcon").children("i").removeClass("icon-double-angle-down");
				$("#content div header .widgetHeaderIcon").children("i").addClass("icon-double-angle-up");
			}else{
				$("#content article div content").show();
				$("#content div header .widgetHeaderIcon").children("i").removeClass("icon-double-angle-up");
				$("#content div header .widgetHeaderIcon").children("i").addClass("icon-double-angle-down");
			}
		});
		if (!_.isEmpty(menu.children[0].children)){
			$scope.menuData = menu.children[0].children ;
			$("#content #wid-id-1 content").empty().append(getMenusHtml(menu.children[0].children,0,0));
		}
		
		$("#content article div content div[menuId]").click(function(e){
			_clickMenu = $(this).attr("menuId");
			$scope.$broadcast("changeMenuId", _clickMenu);
		});
		$("#content article div content div[menuId] .content_row_icon").click(function(){
			var _mClick = $(this).parent("[menuId]").attr("menuId");
			if ($(this).children("i").hasClass("icon-double-angle-down")){
				$("#content article div content div[parentId][parentId='"+_mClick+"']").show();
				$(this).children("i").removeClass("icon-double-angle-down");
				$(this).children("i").addClass("icon-double-angle-up");
			}else{
				$("#content article div content div[parentId][parentId='"+_mClick+"']").hide();
				$(this).children("i").removeClass("icon-double-angle-up");
				$(this).children("i").addClass("icon-double-angle-down");
			}
			
		});
		
		$("#content article div content div[parentId][parentId!='0']").hide();
		//初始化值
		if (_clickMenu == ''){
			$("#content article div content div[parentId][parentId='0']:first").trigger("click");
		}
	}
};
adaptContentCtrl.$inject = ['$scope', '$http'];
var getMenusHtml = function (menus,parentId,level){
	var temple = '<div menuId="<%=_menu.menuId%>" parentId="<%=parentId%>"><div class="content_row"><%=getSpaceLevel(level)%><%=_menu.menuName%></div>'
				+'<% if (!_.isEmpty(_menu.children)){%><div class="content_row_icon pull-right">'
				+'<i class="icon-double-angle-down"></i></div><%}%>'
				+'</div>';
	var _temp = _.template(temple);
	var _result = "";
	if (!_.isEmpty(menus)){
		_.each(menus, function(_menu) {
			_result += _temp({"_menu":_menu,"parentId":parentId,"level":level});
			_result += getMenusHtml(_menu.children,_menu.menuId,level+1);
		},this);
	}
	return _result;
};
function getSpaceLevel(level){
	var _result = "";
	for (var i=0;i<level;i++){
		_result += "&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	return _result;
};
var _selectTime = "";/*判断是否需要初始化*/
//var _selectTimeType = "";
var adaptZbModule = angular.module('adaptZbModule', [], postParamFn);
var adaptZbSelectCtrl = function ($scope , $http){
	$scope.selectQuery = {};
	$scope.$on("changeMenuId",function (event, msg) {
		if ($scope.selectQuery.menuId==msg){
			return ;
		}else{
			$scope.selectQuery.menuId=msg;
			$scope.selectZbTable();
		}
	});
	if (_selectTime===""){
		$http({url:basePath+"/roleAdapt/defaultTime",method:"POST"}).success(function(data){
			/*data = data.replace(/([^\u0000-\u00FF])/g, function ($) { return "";});
			var _data = StringToDate(data);
			console.log(_data.DateAdd('d',-1).toLocaleDateString());*/
			$scope.selectQuery.menuId = _clickMenu;
			$scope.selectQuery.time = data ;
			$scope.selectQuery.timeType = 'yymmdd';
			$scope.selectQuery.dimType='Channle';
			$scope.selectQuery.regionId = regionId;
			$scope.selectZbTable();
		}).error(function(data,status,headers,config){
		});
	}
	$scope.selectTime = function (){
		if ($scope.selectQuery.timeType == 'yymm'){
			$('.hasDatepicker .ui-datepicker-calendar').css("display","none");
		}
		$('article div content .zbSelect .timebox .caret').show();
	};
	$('article div content .zbSelect .timebox .caret').datepicker({
		changeMonth: true,changeYear:true, dateFormat: 'yymmdd',//showButtonPanel:true,
		showMonthAfterYear:true,
		yearSuffix:"年",
		 monthNames: ['一月','二月','三月','四月','五月','六月', '七月','八月','九月','十月','十一月','十二月'],   
	     monthNamesShort: ['一月','二月','三月','四月','五月','六月', '七月','八月','九月','十月','十一月','十二月'],
        dayNamesMin:["日","一","二","三","四","五","六"],
        onSelect: function (){
        	if ($scope.selectQuery.timeType == 'yymmdd'){
        		$('article div content .zbSelect .timebox .caret').hide();
            	var _val = $('article div content .zbSelect .timebox .caret').datepicker('getDate');
        		_val = $.datepicker.formatDate('yymmdd', _val);
        		$('article div content .zbSelect .zbTimeSelect').html(_val);
            	$scope.selectQuery.time = _val;
            	$scope.selectZbTable();
        	}
        },
        onChangeMonthYear:function (year, month, inst){
        	if ($scope.selectQuery.timeType == 'yymm'){
        		var _date = new Date(year,month-1,1);
        		$('article div content .zbSelect .timebox .caret').hide();
        		_date = $.datepicker.formatDate('yymm', _date);
        		$('article div content .zbSelect .zbTimeSelect').html(_date);
            	$scope.selectQuery.time = _date;
            	$scope.selectZbTable();
        	}
        }
	}).hide();
	
	$scope.changeTimeType = function (type) {
		$scope.selectQuery.timeType = type ;
		//TODO选日后选月改值
		$scope.selectZbTable();
	};
	$scope.changeDimType = function (type) {
		$scope.selectQuery.dimType = type ;
		$scope.selectZbTable();
	};
	$("article div content .zbSelect .cycleZb input," +
			"article div content .zbSelect .dimType input").iCheck({
	    checkboxClass: 'icheckbox_square-blue hover',
	    radioClass: 'iradio_square-blue hover'
	  });
	$('article div content .zbSelect .cycleZb input').on('ifChecked', function(event){
		if (this.value != $scope.selectQuery.timeType){
			$scope.changeTimeType(this.value);
		}
	});
	$("article div content .zbSelect .dimType input").on('ifChecked', function(event){
		if (this.value != $scope.selectQuery.dimType){
			$scope.changeDimType(this.value);
		}
	});
	$scope.selectZbTrendShow = function (){
		var _zbTrendShowTxt = $("article div content .zbSelect .showZbTrend").html();
		if (null != _zbTrendShowTxt && 0<=_zbTrendShowTxt.indexOf("不")){
			$("article div content .zbSelect .showZbTrend").html("显示图标");
			alert("隐藏图!");
		}else{
			$("article div content .zbSelect .showZbTrend").html("不显示图标");
			alert("显示图!");
		}
	};
	//指标列表
	$scope.selectZbTable = function (){
		$http({url:"../getKpiData",data:$scope.selectQuery,method:"POST"}).success(function(data){
			console.log(data);
			$scope.showZbTable(data);
		}).error(function(data,status,headers,config){
	        alert(status);
	    });
	};
	$scope.yymmddTempleTitle = "<tr><th></th><th>日</th><th>较昨日</th><th>较上月同期</th><th>日累计</th><th>较去年同期</th><th>操作</th></tr>";
	$scope.yymmddTempleContent = "<tr class=\"<%=index%2==0?\"\":\"alter\"%>\"><td><%=(index!=0?\"&nbsp;&nbsp;\":\"\")%><%=data.menuName%></td><td><%=checkDataBiz(data.valueD.current)%></td><td><%=data.valueD.todayOnYesterday%></td><td><%=data.valueD.monthOnMonth%></td>" +
			"<td><%=checkDataBiz(data.valueAD.current)%></td><td><%=data.valueAD.yearOnYear%></td><td style=\"text-align: center;\"><i class=\"icon-list-alt \" style=\"color:#4ad486\"></i>&nbsp;&nbsp;<i class=\"icon-star\" style=\"color:#3ca2db\"></i></td></tr>";
	
	$scope.yymmTempleTitle = "<tr><th></th><th>月</th><th>较上月</th><th>较去年同期</th><th>月累计</th><th>较去年同期</th><th>操作</th></tr>";
	$scope.yymmTempleTitleContent = "<tr class=\"<%=index%2==0?\"\":\"alter\"%>\"><th></th><th>月</th><th>较上月</th><th>较去年同期</th><th>月累计</th><th>较去年同期</th><th style=\"text-align: center;\">操作</th></tr>";

	$scope.showZbTable = function (data){
		var _e = $("article div content .zbshowArea table");
		var _tempZbTable = $scope.selectQuery.timeType=='yymm'?_.template($scope.yymmTempleTitle):_.template($scope.yymmddTempleTitle);
		_e.empty().append(_tempZbTable());
		var _tempZbTableContent = $scope.selectQuery.timeType=='yymm'?_.template($scope.yymmTempleTitleContent):_.template($scope.yymmddTempleContent);
		if (!_.isEmpty(data)){
			_e.append(_tempZbTableContent({"index":0,"data":data}));
			if (!_.isEmpty(data.children)){
				for (var i=0;i<data.children.length;i++){
					_e.append(_tempZbTableContent({"index":i+1,"data":data.children[i]}));
				}
			}
		}
	}
};
adaptZbSelectCtrl.$inject = ['$scope', '$http'];
/*对数据的单位进行清洗*/
function checkDataBiz(dataValue){
	if (!_.isEmpty(dataValue)){
		dataValue = dataValue.replace(/,/g,"");
		return parseFloat(dataValue)/10000;
	}
	return dataValue;
};
$(function(){
	
});
