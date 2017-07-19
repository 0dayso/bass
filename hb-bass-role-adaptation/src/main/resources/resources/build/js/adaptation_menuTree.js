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