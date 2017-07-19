<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>问题申告</title>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/bass_common.css" />
<script>
(function($){
$(document).ready(function(){
	
//	$("#commentBtn").click(function(){
//		var url = "${mvcPath}/issue/add";
//		alert("hfjkasldf");
//		location.href = "${mvcPath}/issue/add";
//	});

	

	$(".content_panel").append(
		aihb.Util.paging({
			currentPage:${currentPage}
			,totalEl:parseInt("${twisCount}".replace(/(,)/g,''))
			,pageSize:${pageSize}
			,createAElement :function(page,text){
				return $("<a>",{
					text:text
					,href :"${mvcPath}/issue?page="+ page
				});
			}
		})
	);
	
	$(".aTwi").click(function(){
		location.href=$(this).attr("url");
	})
	
});

function add(){
	location.href = "${mvcPath}/issue/add";
}

window.add=add;

})(jQuery)
</script>
</head>
<body>
<input type="button" onclick="add()" id="commentBtn" class="aBtn greenBtn" value="发申告" >
<#include "/ftl/issue/common.ftl">
</body>
</html>