/**
 * creater by zhangds
 * date 2015-07-21
 */
function headerContentCtrl($scope , $http) {
	$scope.DataQualityLine = "数据质量专线:15827475854";
	$scope.UserOptions ="<li><a href=\"javascript:void(0)\" options=\"system_option\" ><i class=\"icon-heart\"></i> 系统管理</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"issue_option\" ><i class=\"icon-check\"></i> 问题申告</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"devreq_option\" ><i class=\"icon-repeat\"></i> 需求管理</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"jobNumner_option\" ><i class=\"icon-road\"></i> 工号管理</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"zb_option\" ><i class=\"icon-glass\"></i> 指标库</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"flow_option\" ><i class=\"icon-flag\"></i> 流量运营平台</a></li>"
				+"<li><a href=\"javascript:void(0)\" options=\"tariff_option\" ><i class=\"icon-rocket\"></i> 统一资费营销平台</a></li>"
	$("#topDetail li #useroption").append($scope.UserOptions);
	$scope.searchValue = null;
	$scope.search = function() {
		if ( $scope.searchValue != null && $scope.searchValue != "" ){
			alert($scope.searchValue);
		}
	};
};
headerContentCtrl.$inject = ['$scope', '$http'];

function mainContentCtrl($scope , $http){
	$scope.menus=menus;
	$scope.currentMainId = null;
	var _main_menu_title = $(".main_menu_title").empty();
	/*TOP模板*/
	var _template = "<%_.each(datas,function(data){%><span _id=\"<%=data.id%>\" _pid=\"<%=data.pid%>\" _sort=\"<%=data.sortnum%>\" class=\"btn btn-primary\"><i class=\"icon-1x icon-border\"><i class=\"<%= data.iconurl != null && data.iconurl != '' ? data.iconurl : 'icon-music'%>\">&nbsp;&nbsp;<%=data.name%></i></i></span><%},this)%>";
	var _tmpl=_.template(_template);
	_main_menu_title.append(_tmpl({datas:$scope.menus}));
	
	$(".main_menu_title span").click(function(e){
		//console.log($(this).attr('class'));
		$(".main_menu_title span").removeClass("active");
		$(this).addClass("active");
		if ($(this).attr("_id") != $scope.currentMainId){
			$scope.currentMainId = $(this).attr("_id");
			$scope.renderSubMenu();
		}
		checkMenuA();
	});
	
	/*Left模板*/
	var _left_template = "<%_.each(datas,function(data){%><dl id=\"<%=data.id%>\"><% if (data.children != null){%><dt><i class=\"icon-user\"></i> &nbsp;&nbsp;<%=data.name%><i class=\"iconfont menu_dropdown-arrow\">&#xf02a9;</i></dt><dd><ul><%_.each(data.children,function(_data){%><li><a _href=\"<%=_data.url%>\" title='<%=_data.name%>' href=\"javascript:;\">&nbsp;&nbsp;<%=_data.name%></a></li><%},this)%></ul></dd><%}else{%><dt><i class=\"icon-music\"></i> &nbsp;&nbsp;<a _href=\"<%=data.url%>\" title='<%=data.name%>' href=\"javascript:;\"><%=data.name%></a></dt><%}%></dl><%},this)%>";
	$scope.left_tmpl= _.template(_left_template);
	
	$scope.renderSubMenu = function (){
		var _menu = _.find($scope.menus, function(menu){
			return menu.id == $scope.currentMainId; 
			},this);
		if ( _menu.children != null && _menu.children.length > 0 ){
			//console.log(_menu.children);
			var _left_em = $(".Hui-aside .menu_dropdown").empty();
			_left_em.append($scope.left_tmpl({datas:_menu.children}));
		}
		$.Huifold(".menu_dropdown dl dt",".menu_dropdown dl dd","fast",1,"click");
	};
	$(".main_menu_title span:first").click();
	
};
mainContentCtrl.$inject = ['$scope', '$http'];

$(document).ready(function() {
    //隐藏等待
    $("#pageloading").hide();
    /*$(".dropdown-menu >li >a").hover(function (){
    	$(this).css("color","#333");
    },function (){
    	$(this).css("color","white");
    });*/
    $("#user_info").click(function(e){
    	var userOptions = $(this);
    	$("#user_option").removeClass("open");
    	if(userOptions.hasClass("open")){
	      userOptions.removeClass("open");
	    }
	    else{
	      userOptions.addClass("open");
	    }
    });
    $("#user_option").click(function(e){
    	var userOptions = $(this);
    	$("#user_info").removeClass("open");
    	if(userOptions.hasClass("open")){
	      userOptions.removeClass("open");
	    }
	    else{
	      userOptions.addClass("open");
	    }
    });

    $("#userinfo a[options]").click(function(e){
    	var _option_Object = $(this).attr("options");
    	switch (_option_Object){
	    	case "introduce" :
	    		alert("introduce");
		    	break;
		    case "setting" :
		    	alert("setting");
		    	break;
	    	default :
	    		alert(1);
    	}
    });
    //切换系统
    $("#useroption a[options]").click(function(e){
    	var _option_Object = $(this).attr("options");
    	switch (_option_Object){
	    	case "system_option" :
				alert("系统管理");
				$(".show-flow #content").empty().append(10);
				break;
			case "issue_option" :
				alert("问题申告");
				break;	
	    	case "devreq_option" :
	    		alert("需求管理");
		    	break;
		    case "jobNumner_option" :
		    	alert("工号管理");
		    	break;
			case "zb_option" :
		    	alert("指标库");
		    	break;
			case "flow_option" :
		    	alert("流量运营平台");
		    	break;
			case "tariff_option" :
		    	alert("统一资费营销平台");
		    	break;
	    	default :
	    		alert(1);
    	}
    });
    $("#user_option").hover(function() {
		$(this).addClass("open");
	}, function() {
		$(this).removeClass("open");
	});
    $('#user_info').hover(function() {
		$(this).addClass("open");
	}, function() {
		$(this).removeClass("open");
	});
});

function checkMenuA(){
	var topWindow=$(window.parent.document);
	/*$(".menu_dropdown dl").click(function(e){
	 	alert(1);
	 	//$(this).find("a:first").trigger("click");
	 	$(this).find("a:first").click();
 	});*/
	$(".Hui-aside .menu_dropdown dl").unbind("click");
	$(".Hui-aside .menu_dropdown dl").click(function(){
		var bStop=false;
		var bStopIndex=0;
		var _href=$(this).attr('_href');
		var _titleName=$(this).html();
		var show_navLi=topWindow.find("#min_title_list li");
		show_navLi.each(function() {
			if($(this).find('span').attr("data-href")==_href)
			{
				bStop=true;
				bStopIndex=show_navLi.index($(this));
				return false;	
			}
		});
		if(!bStop){
			creatIframe(_href,_titleName);
			min_titleList();	
		}
		else{
			show_navLi.removeClass("active").eq(bStopIndex).addClass("active");
			var iframe_box=topWindow.find("#iframe_box");
			iframe_box.find(".show_iframe").hide().eq(bStopIndex).show();	
		}
	});
	function min_titleList(){
		var show_nav=topWindow.find("#min_title_list");
		var aLi=show_nav.find("li");
	};
	function creatIframe(href,titleName){
		var show_nav=topWindow.find('#min_title_list');
		show_nav.find('li').removeClass("active")
		var iframe_box=topWindow.find('#iframe_box');
		show_nav.append('<li class="active"><span data-href="'+href+'">'+titleName+'</span><i></i><em></em></li>');
		tabNavallwidth();
		var iframeBox=iframe_box.find('.show_iframe')
		iframeBox.hide();
		iframe_box.append('<div class="show_iframe"><div class="loading"></div><iframe frameborder="0" src="'+href+'"></iframe></div>');
		var showBox=iframe_box.find('.show_iframe:visible')
		showBox.find('iframe').hide().load(function(){
			showBox.find('.loading').hide();	
			$(this).show()
		});
	}
}