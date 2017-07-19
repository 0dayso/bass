<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>湖北经分</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js" charset="gbk"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
<script type="text/javascript">
(function($,window){

$(document).ready(function(){
	$("#save").click(function(){
		$.ajax({
   			type: "post"
			,url: "${mvcPath}/report/${sid}/code"
			,data: "_method=put&code="+encodeURIComponent($("#codeText").val())
			,dataType : "json"
			,success: function(data){
     			alert( data.status );
   			}
		});
	});
});

})(jQuery,window)
</script>
</head>
<body>
<div  style="text-align: right;padding-right:15px;"><input id="save" type="button" class="form_button_short" value="保存"></div>
<div style="padding: 5px 15px 5px 10px;">
<TABLE class=grid-tab-blue cellSpacing=1 cellPadding=0 width="97%" align=right border=0>
	<TR class=grid_title_blue>
		<TD class=grid_title_cell width="80">配置项</TD>
		<TD class=grid_title_cell>值</TD>
	</TR>
	
	<TR class=grid_row_blue>
		<TD class=grid_row_cell>Js代码</TD>
		<TD class="grid_row_cell_text" style="padding:5px;"><TEXTAREA id="codeText" name="codeData" rows=23 cols=130>${code}</TEXTAREA></TD>
	</TR>
</TABLE>
</div>
</body>
</html>