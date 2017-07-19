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
	<style type="text/css">
	.tstyle{
		width: 272px; 
		padding-left:15px;
		border-left: #C3DAF9 1px solid;
		border-bottom: #C3DAF9 1px solid;
	}
	.thsty{
		height:22px;
		line-height:22px;
		background:#ebf3fd url(../hbbass/common2/image/grid3-hrow-over.gif) repeat-x left bottom;
	}
	.bodyTr{
		background-color: #EFF5FB;
		font-size:12px;
		height:23px;
		line-height:18px
	}
	</style>
  </head>
  <body>
  	<div style="margin-top: 10px;">
		<table align="center" cellspacing="0" cellpadding="0" border="0" style="font-size:12px;height:26px;line-height:18px">
				<tr class="thsty">
					<td class="tstyle" style="border-top: #C3DAF9 1px solid;">应用名称</td>
					<td class="tstyle" style="border-top: #C3DAF9 1px solid;">责任人</td>
					<td class="tstyle" style="border-top: #C3DAF9 1px solid;border-right: #C3DAF9 1px solid;">电话</td>
				</tr>
			<tbody id="liability">
					<#list applyAbiList as alist>
					<tr class="bodyTr">
						<td class="tstyle">${alist.TYPE}</td>
						<td class="tstyle">${alist.USERNAME}</td>
						<td class="tstyle" style="border-right: #C3DAF9 1px solid;">${alist.MOBILE}</td>
					</tr>
					</#list>
			</tbody>
		</table>
	</div>
  </body>
</html>
