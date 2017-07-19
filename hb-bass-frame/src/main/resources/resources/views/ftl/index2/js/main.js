var flag=1;
$(function(){
	var $w = $(document);
	var resize = function(){
		var bh = $w.height();
		$('iframe').height((parseFloat(bh))+'px');
		$('#l100').height((parseFloat(bh))+'px');
	};
	resize();
	$w.on('resize', function(){
		resize();
	});
   //导航展开
	$(".up").click(function(){
		$(".nav-left").css("width","15%");
		$(".pushoff").css("display","none");
		$(".l100").css("display","block");
		$(".l103").css("display","block");
		$(".l104").css("display","block");
		$("#main_index").css("width","80%").css("left","16%");
		$("#r100").css("width","85%");
	});
	//导航收起
	$(".off").click(function(){
		$(".nav-left").css("width","4%");
	    $(".pushoff").css("display","block");
	    $(".l100").css("display","none");
	    $(".l103").css("display","none");
	    $(".l104").css("display","none");
		$("#main_index").css("width","95%").css("left","5%");
		$("#r100").css("width","95%");		
	});
   
   //加号展开
   $("#r1033 ul li").find("p").click(function(){
    $(this).parent().find(".shows").slideToggle("slow");
    $(this).parent().siblings().find(".shows").slideUp("slow");
   });
   
  //点击字体变色
  $(".span1_right").click(function(){
	  var _text=$(this).text(); 
  	//$(this).addClass("span2").siblings().removeClass("span2");
  	$(".span2").animate({left:'40px'});
  	$(".span2").text(_text);
  });
  $(".span1_left").click(function(){
	  var _text=$(this).text();
	  	$(".span2").animate({left:'0px'});
		$(".span2").text(_text);
	  });
  $(".span3_right").click(function(){
	    var _text=$(this).text();
	  	$(".span3").animate({left:'50px'});
	  	$(".span3").text( _text);
	  });
	  $(".span3_left").click(function(){
		    var _text=$(this).text();
		  	$(".span3").animate({left:'0px'});
		  	$(".span3").text(_text);
		  });
		  $(".span5_right").click(function(){
			    var _text=$(this).text();
			  	$(".span5").animate({left:'72px'});
			  	$(".span5").text( _text);
			  });
			  $(".span5_left").click(function(){
				    var _text=$(this).text();
				  	$(".span5").animate({left:'0px'});
				  	$(".span5").text( _text);
				  });
			  $(".span6_right").click(function(){
				    var _text=$(this).text();
				  	$(".span6").animate({left:'40px'});
				  	$(".span6").text( _text);
				  });
				  $(".span6_left").click(function(){
					    var _text=$(this).text();
					  	$(".span6").animate({left:'0px'});
					  	$(".span6").text( _text);
					  });
  //轮播图
  var _index=0;
  setInterval(function(){
		_index++;//_index = _index-1
		if(_index>2){
			_index=0;
		}
		//auto(_index);
		$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
	},5000);
  

});

window.onload=function(){ 
	  //自适应
	 var a= $("#l101").height();
	 a+=18;
	 if(a<350){
		 a=350;
	 }
	  $(".sub-menu").css("height",a);
}

function roller(){ 
	  $(".icon ul li").click(function(){	 
	  	   _index=$(this).index();
	  	  auto(_index); 
	  //	$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
	  });	  

}
function openNewTab(){
	   $(".menu .sub-menu li").click(function(event){  
	        var _index=$(event.currentTarget).data("index");
	        var _text=$(event.currentTarget).find("a").find("span").text();
	        var _href = $(event.currentTarget).data("url");
	        $("#r101").show();
	 	    addTab(_index,_text,_href);
	 		$(".sub-menu").hide();
	 	   resize();
	   });
	 
}

function showChildrenMenus(){
	//侧菜单栏展开
	   $(".l102 ul li").mouseover(function(){
	     $(this).find(".sub-menu").show();
	   }).mouseout(function(){
	   $(this).find(".sub-menu").hide();
	   });
	/*$(".l102 ul li .play").mouseenter(function(){	    
		 $(this).parent().find(".sub-menu").show();			 
	  });
	   $(".l102 ul li").mouseleave(function(){
	      $(this).find(".sub-menu").hide();
	   });*/
	   
}

var _index=0;
function auto(_index){
	/*$(".con-top ul li").eq(_index).fadeIn().siblings().css("display","none");*/
	$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
}

var $w = $(window);
var resize = function(){
	var bh =$(document).height();
	//$("#r100 [id='myTabPanel']").height();
	$('iframe').height((parseFloat(bh))+'px');
	$('#l100').height((parseFloat(bh))+'px');
};

// 打开新的Tab页
function addTab(_index,_text,_href){
	/*var file = addMenuId(node.file,node.id);*/
	if(_text == '我的首页'){
		$("#r101").hide();
		$(".tab-pane").hide();
		return;
	}
	var ul = $("#r101 div >ul");
	ul.children('li').removeClass("active");
	//var tabs = $("#myTab ul").find('li a');
	var isExit = false;
	var _lnum = 0;
	$("#r101").show();
	ul.find('li').each(function() {
		_lnum++;
		if($(this).find('a').attr("id")== _index)
		{
			isExit = true;
			$(".show_iframe").hide();
			
			$("#frame_" +_index).show();	
			activeMenu($(this));
		}else{
			normalMenu($(this));
		}
	});
	if(!isExit){
		$("#r100 [id='r101']").show();
		//$("#r1010 ul").append("<li class=\"active\"><a data-toggle=\"tab\" onclick='changeTab(\"" + _index +"\");' href='#frame_" + _index + "'>" + _text+ "</a><span class=\"icon-error\" onclick='closeTab(\"" +_index+"\")'></span></li>");
		var _liclass = "menu-other";
		if(_lnum == 0){
			_liclass = "menu-first";
		}
		ul.append("<li class='" + _liclass + " active'><div style=\"width:100%; height:3px; background-color:#4BB901;\"></div><div style=\"margin: 0 8px;\"><a onclick='changeTab(\"" + _index +"\");' href='javascript:;' id='" + _index + "'>" + _text+ "</a><span class=\"icon-error\"  style='margin-right:0;' onclick='closeTab(\"" +_index+"\")'></span></div></li>");
        $(".show_iframe").hide();
		// 加载菜单内容到div
		var frame = '<div id="frame_'+_index+'" class="tab-pane active show_iframe" style="height:100%;"><div class="loading" style="display:none"></div><iframe frameborder="0" scrolling="yes"; overflow:auto; src="'+ _href+'"></iframe></div>';
		$("#myTabPanel").append(frame);
		if(_href != null &&　_href.length>0){
			insertLog(_index,_text,_href);
		}
		resize();
	}
}

function insertLog(rid, rname, rurl){
	$.ajax({
        url: '/hb-bass-navigation/visit/insertLog',
        type: "POST",
        dataType: 'json',
        data: {
            rid: rid,
            rname: rname,
            rurl: rurl
        }
    });
}
// 关闭Tab页
function closeTab(_index){
	$("a#" + _index).parent().parent().remove();
	$("a[href='#frame_" + _index + "']").parent().parent().remove();
	var tab = 0;
	$("a[href='#frame_" + _index + "']").parent().parent().remove();
	$("#frame_" + _index).remove();	
	var isExit = false;
	$("#r1010 ul li").each(function() {
		tab++;
		if($(this).hasClass("active"))
		{
			isExit = true;
		}
	});
	if(!isExit){
//		$('#r1010 a:last').tab('show');
		activeMenu($('#r1010 ul li:last'));
		$('.show_iframe:last').show();	
	}
	if(tab==0){
		$("#r101").hide();
	}
}
// 切换tab
function changeTab(_index){
	$(".show_iframe").hide();
	$("#frame_" + _index).show();
	$("#r1010 ul li").each(function() {
		if($(this).find('a').attr("id")== _index )
		{
			activeMenu($(this));
		}else{
			normalMenu($(this));
		}
	});
}

function activeMenu(obj){
	obj.children(":first").css("background-color","#4BB901");
	obj.css("border-bottom","1px solid #fff");
	obj.addClass("active");
}

function normalMenu(obj){
	obj.children(":first").css("background-color","#fff");
	obj.css("border-bottom","1px solid #D8D8D8");
	obj.removeClass("active");
}




