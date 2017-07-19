<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>湖北经分</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
<script type="text/javascript">
(function($,window){

$(document).ready(function(){
	$("#gridText").val("${grid}"||"");
	$("#cache").val("${cache}"||"");
	$("#ds").val("${ds}"||"");
	$("#excel").val("${excel}"||"");
	$("#chart").val("${chart}"||"");
	$("#areaAll").val("${areaAll}"||"");
			
	$("#save").click(function(){
		if($("#sqlText").val().length>0){
			$.ajax({
	   			type: "post"
				,url: "${mvcPath}/report/${sid}/sql"
				,data: "_method=put"
						+"&sql="+encodeURIComponent($("#sqlText").val())
						+"&grid="+encodeURIComponent($("#gridText").val())
						+"&maxTime="+encodeURIComponent($("#maxTime").val())
						+"&ds="+encodeURIComponent($("#ds").val())
						+"&cache="+encodeURIComponent($("#cache").val())
						+"&excel="+encodeURIComponent($("#excel").val())
						+"&chart="+encodeURIComponent($("#chart").val())
						+"&areaAll="+encodeURIComponent($("#areaAll").val())
				,dataType : "json"
				,success: function(data){
	     			alert( data.status );
	   			}
			});
		}else{
			alert("请填入SQL");
		}
	});
});

})(jQuery,window)

</script>
</head>
<body>
<div style="text-align: right;padding-right:15px;">使用Excel下载：<select id=excel><option value="true">是</option><option value="">否</option></select> 开启图形：<select id=chart><option value="true">是</option><option value="">否</option></select> 全省权限：<select id=areaAll><option value="true">是</option><option value="">否</option></select> 使用缓存(强烈建议开启)：<select id=cache><option value="">是</option><option value="false">否</option></select> 数据源：<select id=ds><option value="">仓库</option><option value="web">web库</option><option value="nl">近线库</option></select> 数据量：<select id=gridText><option value="SimpleGrid">很小(小于1k条)</option><option value="AjaxGrid">普通(小于6w条)</option><option value="PieceGrid">很大(大于6w条)</option></select>(必填重要)  <input id="save" type="button" class="form_button_short" value="保存"></div>
<div style="padding: 5px 15px 5px 10px;">
<TABLE class=grid-tab-blue cellSpacing=1 cellPadding=0 width="97%" align=right border=0>
	<TR class=grid_title_blue>
		<TD class=grid_title_cell width="80">配置项</TD>
		<TD class=grid_title_cell>值</TD>
	</TR>
	<TR class=grid_row_blue>
		<TD class=grid_row_cell>默认时间</TD>
		<TD class="grid_row_cell_text" style="padding:5px;"><TEXTAREA id="maxTime" rows=3 cols=120>${maxTime}</TEXTAREA></TD>
	</TR>
	<TR class=grid_row_blue>
		<TD class=grid_row_cell>SQL</TD>
		<TD class="grid_row_cell_text" style="padding:5px;"><TEXTAREA id="sqlText" rows=23 cols=120>${sql}</TEXTAREA></TD>
	</TR>
</TABLE>
</div>
</body>
</html>