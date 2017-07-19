function openNewPage(name, value){
	var sid = new Date().getTime();
	$("#position").find("ul").append("<li class='divide fl'>></li><li class=\"fl\"><a onclick=\"backto('" + sid + "')\" pageId='" + sid + "'>" + name + "</a></li>");
	if((new RegExp("^redirect:")).test(value)){
		value = mvcPath + "/accessOtherSys?redirectPath="+encodeURIComponent(value.substring("redirect:".length));
	}
	$("#page").parent().append("<div id=" + sid + "><iframe frameborder='0' src='" + value + "' style='height: 100%;width: 98%; position: absolute;'></iframe></div>");
	$("#page").parent().children("div").hide();
	$("#" + sid).show();
	$("#position").show();
}

function backto(pageId){
	$("#page").parent().children("div").hide();
	if(pageId == ("page")){
		$("#position").hide();
		$("a[pageId='page']").parent().nextAll().remove();
		$("#position li").each(function(){
			var _id = $(this).find('a').attr("pageId");
			if(_id != pageId){
				$("#" + _id).remove();
			}
		});
	}else{
		$("a[pageId='" + pageId +"']").parent().nextAll().remove();
		$("#position").show();
	}
	$("#" + pageId).show();
}