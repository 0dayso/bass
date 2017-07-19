<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/rpt_display.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<style>
	.selectarea {
	position:absolute;
	width:130px;
	padding: 3 px;
	z-index:30;background-color: #FFFFB5;
	border:1px solid #B3A894;
}
	</style>
	<script type="text/javascript">
window.onload=function(){
	var res =${res};
	$("#title").text(res.packageName);
	naviTree($("#t1"),res.elements);
	logStat();
}

function logStat(){
	var datas = ${data};
			for(var i=0;i<datas.length;i++){
				if(!$("#te_"+datas[i].id))
					continue;
				var _td4=$("#td_"+datas[i].id);
				$("#te_"+datas[i].id).text(datas[i].qu);
				
				var _table=$("<table>",{width:"99%"});
				var _thead=$("<thead>");
				_table.append(_thead);
				var _tr=$("<tr>",{align:"center"});
				_thead.append(_tr);
				
				var _td1=$("<td>");
				_tr.append(_td1);
				
				var _td2=$("<td>");
				_tr.append(_td2);
				_td2.text("本月");
				
				var _td3=$("<td>");
				_tr.append(_td3);
				_td3.text("累计");
				
				var _tbody=$("<tbody>");
				_table.append(_tbody);
				
				var _tr1=$("<tr>",{align:"center"});
				_tbody.append(_tr1);
				
				var _tr2=$("<tr>",{align:"center"});
				_tbody.append(_tr2);
				
				var _tr3=$("<tr>",{align:"center"});
				_tbody.append(_tr3);
				
				var _td11=$("<td>",{text:"访问次数"});
				_tr1.append(_td11);
				
				var _td12=$("<td>",{text:datas[i].qum});
				_tr1.append(_td12);
				
				var _td13=$("<td>",{text:datas[i].qu});
				_tr1.append(_td13);
				
				var _td21=$("<td>",{text:"下载次数"});
				_tr2.append(_td21);
				
				var _td22=$("<td>",{text:datas[i].dwm});
				_tr2.append(_td22);
				
				var _td23=$("<td>",{text:datas[i].dw});
				_tr2.append(_td23);
				
				var _td31=$("<td>",{text:"访问人次"});
				_tr3.append(_td31);
				
				var _td32=$("<td>",{text:datas[i].lgm});
				_tr3.append(_td32);
				
				var _td33=$("<td>",{text:datas[i].lg});
				_tr3.append(_td33);
				
				var _hiddenDiv=$("#hd_"+datas[i].id);
				
				_hiddenDiv.append(_table);
				
				_hiddenDiv
					.mouseover(function(){$(this).fadeIn(100)})
					.mouseout(function(){$(this).fadeOut(100)})
				
				_td4.mouseover(function(){
					var _hiddenDiv=$("#"+this.id.replace("t","h"));
					if(_hiddenDiv.css("display")=="none"){
						_hiddenDiv.css("left",event.clientX+document.body.scrollLeft- document.body.clientLeft - 130);
						
						var _newtop=event.clientY+document.body.scrollTop- document.body.clientTop;
						if(_newtop+200>document.body.scrollHeight)_newtop-=60;
						_hiddenDiv.css("top", _newtop);
						_hiddenDiv.fadeIn(100);
					}
				}).mouseout(function(){
					$("#"+this.id.replace("t","h")).fadeOut(100);
				})
			}
}
	</script>
  </head>
  <body>
  <form action="" method="post">
  	<div id="title" style="margin: 10px;text-align: center;font-size: 22px;font-weight: bold;font-family: 黑体"></div> 
  	<table id="t1" align="center" width="96%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="margin-bottom:5px;"></table>
  </form>
  </body>
</html>