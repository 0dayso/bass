<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript">
		function rescind(){
			if(confirm("是否解除金库模式?")){
				$.ajax({
					type: "post"
					,url: "${mvcPath}/jinku/rescind"
					,data: "_method=put"
					,dataType : "json"
					,success: function(data){
     					alert(data.status);
   					}
				});
			}else 
				return ;
		}
		
		function resume(){
			if(confirm("是否恢复金库模式?")){
 				$.ajax({
					type: "post"
					,url: "${mvcPath}/jinku/resume"
					,data: "_method=put"
					,dataType : "json"
					,success: function(data){
     					alert(data.status);
   					}
				});
			}else 
				return ;
		}
	</script>
  </head>
  <body>
  	<div style="text-align: left;padding: 3px 0px 5px 6px;">
  	<input type="button" class="form_button" value="解除金库模式" onClick="rescind()">
  	<input type="button" class="form_button" value="恢复金库模式" onClick="resume()"></div>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
