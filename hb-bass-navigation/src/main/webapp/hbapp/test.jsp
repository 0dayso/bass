<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/json2.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<script>
Ext.Ajax.request({
	url : 'http://10.31.81.245:8086/mvc/report/7944',
	success : function(obj) {
		var result = obj.responseText;
		//alert(result);
		document.write(result);
	},
	failure : function() {
		Ext.MessageBox.show({
			title : 'info',
			msg : 'error！',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.ERROR
		});
	},
	params : {
	}
});
</script>



