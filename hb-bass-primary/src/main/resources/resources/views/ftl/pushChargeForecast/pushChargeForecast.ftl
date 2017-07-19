<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/rpt_display.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<script type="text/javascript">
	function sender(){
		var time = document.getElementById("time_id").value;
		var sender = document.getElementById("sender").value;
		if(time==''){
			alert("请选择发送时间!");
			return;
		}
		if(sender==''){
			var r = confirm('不填写收件人邮件只会发送给默认人员');
			if(r==true){
				var _ajax = new aihb.Ajax({
					url : "${mvcPath}/PushChargeForecast/send"
					,parameters : "_method=put&time="+time+"&sender="+sender
					,loadmask : true
					,callback : function(xmlrequest){
						var result = xmlrequest.responseText
						result = eval('(' + result + ')');
						alert(result.status);
					}
				})
				_ajax.request();
			}
		}else{
			var _ajax = new aihb.Ajax({
				url : "${mvcPath}/PushChargeForecast/send"
				,parameters : "_method=put&time="+time+"&sender="+sender
				,loadmask : true
				,callback : function(xmlrequest){
					var result = xmlrequest.responseText
					result = eval('(' + result + ')');
					alert(result.status);
				}
			})
			_ajax.request();
		}
	}
	</script>
  </head>
  <body>
  	<div style="padding: 3px 0px 5px 6px;">
  	<font size="2">日期：</font>
    <input type="test" name="time_id" value="" id="time_id" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyyMM'})" />&nbsp;&nbsp;&nbsp;&nbsp;
    <font size="2">收件人：</font>
    <input type="test" name="sender" value="" id="sender"  />&nbsp;&nbsp;&nbsp;&nbsp;
  	<input type="button" class="form_button_short" value="发送" onClick="sender()"></div>
  </body>
</html>
