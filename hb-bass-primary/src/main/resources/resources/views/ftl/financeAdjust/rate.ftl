<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<style>
	.coolscrollbar{scrollbar-arrow-blue:yellow;scrollbar-base-color:#ebf3fd;}
	</style>
  </head>
  <body>
				<div id="grid" style="display: none;"></div>
  	</body>
  	<script type="text/javascript">
		window.onload=function(){
			query();
		}
	
		var _header=[
			{"name":"报表ID","dataIndex":"id","cellStyle":"grid_row_cell_text"}
			,{"name":"报表名称","dataIndex":"name","cellStyle":"grid_row_cell_text"}
			,{"name":"所属模块","dataIndex":"track","cellStyle":"grid_row_cell_text"}
			,{"name":"点击次数","dataIndex":"count","cellStyle":"grid_row_cell_text"}
		];
		
		function query(){
			var sql = "select id, name, track, count from fpf_ratejob";
			var grid = new aihb.AjaxGrid({
				header:_header
				,sql: sql
				,ds:"web"
				,isCached : false
			});
			grid.run();
		}
	</script>
</html>
