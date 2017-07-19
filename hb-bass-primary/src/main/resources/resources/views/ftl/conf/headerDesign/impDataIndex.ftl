<html>
<head>
<title>format</title>
<meta http-equiv="Expires" content="-1"/>
<meta http-equiv="Cache-Control" content="NO-CACHE"/>
<meta http-equiv="Pragma" content="NO-CACHE"/>	  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js" charset="utf-8"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="utf-8"></script>
<script>
function ai() {
	var ow = window.parent;
	if (ow) {
		ow.impDataIndex($("aaa").value);
	}
}
</script>
<body>
<textarea id="aaa" cols=65 rows=6></textarea>
<br><input type="button" onClick="ai();" value="确定"/>
</body>
</html>