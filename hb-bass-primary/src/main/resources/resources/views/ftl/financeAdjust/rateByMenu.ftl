<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="gbk"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript">


</script>
  </head>
  <body>
  	<table>
  		<thead>
  			<tr class="grid_title_blue" height="26">
  				<td width="200" class="grid_title_cell">报表ID</td>
  				<td width="200" class="grid_title_cell">报表名称</td>
  				<td width="200" class="grid_title_cell">访问次数</td>
  			</tr>
  			<#list twis as myt>
  				<tr class="grid_row_alt_blue" height="26">
	  				<td width="200" class="grid_row_cell_text">${myt.resource_id}</td>
	  				<td width="200" class="grid_row_cell_text">${myt.name}</td>
	  				<td width="200" class="grid_row_cell_text">${myt.count}</td>
	  			</tr>
  			</#list>
  		</thead>
  	</table>
  	
  </body>
</html>
