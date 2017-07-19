<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title>全景视图</title>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
<style type="text/css">
.box1{font-family:"微软雅黑";font-weight:bold}
#show1 {
	position:absolute;
	width:1100px;
	height:580px;
	z-index:1;
	top: 29px;
	left: 228px;
}
#apDiv2 {
	position:absolute;
	width:200px;
	height:580px;
	z-index:1;
	left: 8px;
	top: 42px;
}
<!--
a:link {  color: #0020FF; text-decoration: none;font-size: 9pt}
a:visited { color:#0020FF; text-decoration: none;font-size: 9pt}
a:hover {  color: #585858; text-decoration: underline;font-size: 9pt}
-->
</style>
<style>
<!--
#PCL {
 font-family:宋体 ;
 font-style: none;
 font-weight: normal;
 text-decoration: none;
 font-size: 9pt;
}
#PTT {
 font-family: 宋体;
 font-size: 9pt;
}
#PST {
 font-family:宋体;
 font-size: 9pt;
}
-->
</style>
<script type="text/javascript">
window.onload=function(){
		var _d=new Date();
		var date1 = '${start_time}';
		$("#date1").val(date1);
		var date2 = '${end_time}';
		$("#date2").val(date2);
		getCityInit();
		var sql = "${sql}";
		var header = ${header};
		var zb_code = '${zb_code}';
		var zb_name = '${zb_name}';
		var unit = '${unit}';
		var month_code = '${month_code}';
		var check = '${check}';
		query(sql, header, 1);
		var _table=jQuery("#t1");
		var res= ${res};
		naviTreeForCutomer(_table, res.elements);
	}
</script>	
</head>
<body>
<div id="show1">
  	<form method="post" action=""><br>
		<div>
			<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
				<tr class='dim_row'>
					<td class='dim_cell_title'>时间:</td>
					<td class='dim_cell_content'>
						<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
					</td>
					<td class='dim_cell_content'>
						<input align="right" type="text" id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
					</td>
					<td class='dim_cell_title'>地市</td>
					<td class='dim_cell_content4'>
						<select id="city" name="city" onchange="createImg()" style="width: 100px">        
					</td>
					<td class='dim_cell_title' align="center">
						<input type="button" class="form_button_short" value="查询" onClick="query1()">
					</td>
					<td class='dim_cell_title' align="center">
						<input type="button" class="form_button" value="批量导出" onClick="down()">
					</td>
					<td class='dim_cell_title' align="center">
						<input type="button" class="form_button" value="区间导出" onClick="down1()">
					</td>
				</tr>
			</table>
		</div>
	</form>
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td><img src="${mvcPath}/resources/image/default/ns-expand.gif" alt=""></img>${zb_name}|单位：${unit}</td>
						<#if month_code??>
						<td>|
							<#if check=='1'>
							<input type="radio" name="radio" value="1" checked onchange="checkCode(1)"/>当月
							<input type="radio" name="radio" value="2" onchange="checkCode(2)"/>年累计
							</#if>
						</td>
						</#if>
					</tr>
				</table>
			</legend>
			<div id="grid" style="display: none;"></div>
		</fieldset>
	</div><br>
	<div id="container" style="text-align:center;width:90%;height:300px;"></div>
</div>
<div ID="overDiv" style="position:absolute; visibility:hide; z-index: 1;"></div>
<div id="apDiv2">
	<table id="t1" align="center" width="96%" cellspacing="1" cellpadding="0" border="0" style="margin-bottom:5px;">
</div>
 </body>
<script type="text/javascript">
	
	function getCityInit(){
		var city = document.getElementById("city");
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/getCity"
			,dataType : "json"
			,success: function(data){
				city.length=0;//清空下拉框 只留下提示项
				for(var i=0;i<data.length;i++){
					var ret = data[i];
					var cityId = ret.area_code;
					var cityName = ret.value;
		      		city[i]=new Option(cityName,cityId);
		   		}
			}
		})
	}
	
	if (typeof fcolor == 'undefined') { var fcolor = "#FFFFFF";}
	if (typeof backcolor == 'undefined') { var backcolor = "#FFFFFF";}
	if (typeof textcolor == 'undefined') { var textcolor = "#000000";}
	if (typeof capcolor == 'undefined') { var capcolor = "#FFFFFF";}
	if (typeof closecolor == 'undefined') { var closecolor = "#000000";}
	if (typeof width == 'undefined') { var width = "150";}
	if (typeof border == 'undefined') { var border = "0";}
	if (typeof offsetx == 'undefined') { var offsetx = 10;}
	if (typeof offsety == 'undefined') { var offsety = 10;}
	ns4 = (document.layers)? true:false
	ie4 = (document.all)? true:false
	if (ie4) {
	if (navigator.userAgent.indexOf('MSIE 5')>0) {
	ie5 = true;
	} else {
	ie5 = false; }
	} else {
	ie5 = false;
	}
	var x = 0;
	var y = 0;
	var snow = 0;
	var sw = 0;
	var cnt = 0;
	var dir = 1;
	var tr = 1;
	if ( (ns4) || (ie4) ) {
	if (ns4) over = document.overDiv
	if (ie4) over = overDiv.style
	document.onmousemove = mouseMove
	if (ns4) document.captureEvents(Event.MOUSEMOVE)
	}
	function drs(text) {
	dts(1,text);
	}
	function drc(text, title) {
	dtc(1,text,title);
	}
	function src(text,title) {
	stc(1,text,title);
	}
	function dls(text) {
	dts(0,text);
	}
	function dlc(text, title) {
	dtc(0,text,title);
	}
	function slc(text,title) {
	stc(0,text,title);
	}
	function dcs(text) {
	dts(2,text);
	}
	function dcc(text, title) {
	dtc(2,text,title);
	}
	function scc(text,title) {
	stc(2,text,title);
	}
	function nd() {
	if ( cnt >= 1 ) { sw = 0 };
	if ( (ns4) || (ie4) ) {
	if ( sw == 0 ) {
	snow = 0;
	hideObject(over);
	} else {
	cnt++;
	}
	}
	}
	function dts(d,text) {
	txt = "<TABLE WIDTH="+width+" BORDER=0 CELLPADDING="+border+" CELLSPACING=0 BGCOLOR=\""+backcolor+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 BGCOLOR=\""+fcolor+"\"><TR><TD><FONT FACE=\"Arial,Helvetica\" COLOR=\""+textcolor+"\" SIZE=\"-2\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>"
	layerWrite(txt);
	dir = d;
	disp();
	}
	function dtc(d,text, title) {
	txt = "<TABLE WIDTH="+width+" BORDER=0 CELLPADDING="+border+" CELLSPACING=0 BGCOLOR=\""+backcolor+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><SPAN ID=\"PTT\"><B><FONT COLOR=\""+capcolor+"\">"+title+"</FONT></B></SPAN></TD></TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 BGCOLOR=\""+fcolor+"\"><TR><TD><SPAN ID=\"PST\"><FONT COLOR=\""+textcolor+"\">"+text+"</FONT><SPAN></TD></TR></TABLE></TD></TR></TABLE>"
	layerWrite(txt);
	dir = d;
	disp();
	}
	function stc(d,text, title) {
	sw = 1;
	cnt = 0;
	txt = "<TABLE WIDTH="+width+" BORDER=0 CELLPADDING="+border+" CELLSPACING=0 BGCOLOR=\""+backcolor+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><SPAN ID=\"PTT\"><B><FONT COLOR=\""+capcolor+"\">"+title+"</FONT></B></SPAN></TD><TD ALIGN=RIGHT><A HREF=\"/\" onMouseOver=\"cClick();\" ID=\"PCL\"><FONT COLOR=\""+closecolor+"\">Close</FONT></A></TD></TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 BGCOLOR=\""+fcolor+"\"><TR><TD><SPAN ID=\"PST\"><FONT COLOR=\""+textcolor+"\">"+text+"</FONT><SPAN></TD></TR></TABLE></TD></TR></TABLE>"
	layerWrite(txt);
	dir = d;
	disp();
	snow = 0;
	}
	function disp() {
	if ( (ns4) || (ie4) ) {
	if (snow == 0) {
	if (dir == 2) {
	moveTo(over,x+offsetx-(width/2),y+offsety);
	}
	if (dir == 1) {
	moveTo(over,x+offsetx,y+offsety);
	}
	if (dir == 0) {
	moveTo(over,x-offsetx-width,y+offsety);
	}
	showObject(over);
	snow = 1;
	}
	}
	}
	function mouseMove(e) {
	if (ns4) {x=e.pageX; y=e.pageY;}
	if (ie4) {x=event.x; y=event.y;}
	if (ie5) {x=event.x+document.body.scrollLeft; y=event.y+document.body.scrollTop;}
	if (snow) {
	if (dir == 2) {
	moveTo(over,x+offsetx-(width/2),y+offsety);
	}
	if (dir == 1) {
	moveTo(over,x+offsetx,y+offsety);
	}
	if (dir == 0) {
	moveTo(over,x-offsetx-width,y+offsety);
	}
	}
	}
	function cClick() {
	hideObject(over);
	sw=0;
	}
	function layerWrite(txt) {
	if (ns4) {
	var lyr = document.overDiv.document
	lyr.write(txt)
	lyr.close()
	}
	else if (ie4) document.all["overDiv"].innerHTML = txt
	if (tr) { trk(); }
	}
	function showObject(obj) {
	if (ns4) obj.visibility = "show"
	else if (ie4) obj.visibility = "visible"
	}
	function hideObject(obj) {
	if (ns4) obj.visibility = "hide"
	else if (ie4) obj.visibility = "hidden"
	}
	function moveTo(obj,xL,yL) {
	obj.left = xL
	obj.top = yL
	}
	function trk() {
	if ( (ns4) || (ie4) )
	tr = 0;
	}
	
	function naviTreeForCutomer(_table,datas){
		_table.empty();
		
		var _head=$("<thead/>");
		var _tr = $("<tr/>",{"class":"grid_title_blue",height:26});
		_table.append(_head);
		_head.append(_tr);
		
		var _td2 = $("<td/>",{width:"250","class":"grid_title_cell",text:"指标名称"});
		_tr.append(_td2);
		
		function genCell(options){
			var aData=options.row;
			var _tbody=options.container;
			_tr = $("<tr/>",{height:26});
			_td2 = $("<td/>",{"class":"grid_row_cell_text"});
			
			
			var _img=$("<img/>",{height:18,width:18,src:"${mvcPath}/resources/image/default/"+(options.isBottom?"joinbottom.gif":"join.gif")});
			_td2.append(_img);
			
			var name = aData.name;
			var code_type = aData.code_type;
			if(code_type=="0"){
				name = name + "(经分数据)";
			}else if(code_type=="1"){
				name = name + "(外导数据)";
			}
			var _a = $("<a/>",{
				href:"javascript:void(0)"
				,kind: aData.type
				,sid : aData.code
				,text : name
				,descript : aData.descript
				,click : function(){
					var _strUri="";
					if($(this).attr("parent_id")=="0"){
						_strUri=$(this).attr("sid");
					}else{
						_strUri="${mvcPath}/customer/panoramicView/"+$(this).attr("sid");
					}
					var url = _strUri;
					window.location.href = url;
					
				}
				,onmousemove : function(){
					drc(this.descript,this.name);
				}
				,onmouseout : function(){
					nd();
				}
			});
			
			_td2.append(_a);
			
			_tr.append(_td2);
			_tbody.append(_tr);
		}
		
		var _tbody = $("<tbody/>");
		for(var i=0; datas && i< datas.length;i++){
			if(datas[i].subjects){
				var _span=$("<span/>",{id:"list"+i});
				var packageObj=$("<td/>",{"class":"grid_row_cell_text",colSpan:1});
				
				var _icon = $("<img/>",{
					src : "${mvcPath}/resources/image/default/row-collapse.gif"
					,click: function(){
						var _this=this;
						$("#"+$(_this).attr("cid")).children("tr").slideToggle(100);
					}
					,cid:"list"+i
					}).toggle(
						function(){
							$(this).attr("src","${mvcPath}/resources/image/default/row-expand.gif")
						}
						,function(){
							$(this).attr("src","${mvcPath}/resources/image/default/row-collapse.gif")
						}
						
					).css("cursor","hand");
				
				packageObj.append(_icon).append($("<span/>",{text:" "+datas[i].name}).css("fontWeight","bold"));
				
				var _cSbjs=datas[i].subjects;
				
				for(var j=0;j<_cSbjs.length;j++){
					genCell({row : _cSbjs[j],container : _span, isBottom : (j+1==_cSbjs.length)});
				}
				if(datas[i].type=="下拉框"){
					_span.children("tr").hide();
					_icon.click();
				}
				var _tr=$("<tr/>",{height:26})
					.append(packageObj);
				_tbody.append(_tr);
				_tbody.append(_span);
				_span.children("tr").hide();
			}
		}
		
		_table.append(_tbody);
	}
	
	function createImg(){
		var radios = document.getElementsByName('radio');
		var str ;
		for (var i = 0; i < radios.length; i++) {
			if(radios[i].checked){
				str = radios[i].value;
			}
		}
		var zb_code;
		if(str=='1'){
			zb_code = '${zb_code}';
		}else if(str=='2'){
			zb_code = '${month_code}';
		}
		var cityid=$("#city").val();
		var start_time=$("#date1").val();
		var end_time=$("#date2").val();
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/createImg"
			,data: "city="+cityid+"&start_time="+start_time+"&end_time="+end_time+"&zb_code="+zb_code
			,dateType: "json"
			,success: function(data){
				var result = eval('(' + data + ')');
				var columns=result.columns;
				var date1=result.date1;
				var zb_name=result.zb_name;
				var unit=result.unit;
				chart = new Highcharts.Chart({
		          chart: {
		              renderTo: 'container',
		              defaultSeriesType: 'spline'
		          },
		         title: {
		             text: zb_name
		         },
		         xAxis: {
		             categories: columns, 
				     labels: { 
				     	rotation: 0,  //逆时针旋转45°，标签名称太长。 
				        align: 'center'  //设置右对齐 
				    } 
		         },
		         yAxis: {
		             labels: { 
				     	formatter: function() { //格式化标签名称 
				        	return this.value + unit; 
				   	    }, 
				        style: { 
				    		color: '#89A54E' //设置标签颜色 
				        } 
			        }, 
		            title: {text: ''}, //Y轴标题设为空 
		            opposite: true  //显示在Y轴右侧，通常为false时，左边显示Y轴，下边显示X轴 
		         },
		         series: [{
		             name: zb_name,
		             data: date1
		         }]
		     });    
			}
		})
	}
	
	
	var date1 = $("#date1").val();
	var date2 = $("#date2").val();
	
	function query(sql, _header, flag){
		if(flag==0){
			_header = eval('('+_header+')');
		}
		if(date1>date2){
			alert("开始月份不得大于结束月份");
			return;
		}
		var grid = new aihb.AjaxGrid({
			header:_header
			,sql: sql
			,ds:"web"
			,isCached : false
		});
		grid.run();
		createImg();
	}
	
	function query1(){
		var radios = document.getElementsByName('radio');
		var str ;
		for (var i = 0; i < radios.length; i++) {
			if(radios[i].checked){
				str = radios[i].value;
			}
		}
		var zb_code;
		if(str=='1'){
			zb_code = '${zb_code}';
		}else if(str=='2'){
			zb_code = '${month_code}';
		}
		var start_time = $("#date1").val();
		var end_time = $("#date2").val();
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/query"
			,data: "start_time="+start_time+"&end_time="+end_time+"&zb_code="+zb_code
			,dateType: "json"
			,success: function(data){
				var result =  eval('(' + data + ')');
				var sql = result.sql;
				var header = result.header;
				query(sql, header, 0);
			}
		})
	}
	
	function checkCode(str){
		var zb_code;
		if(str=='1'){
			zb_code = '${zb_code}';
		}else if(str=='2'){
			zb_code = '${month_code}';
		}
		var start_time = $("#date1").val();
		var end_time = $("#date2").val();
		$.ajax({
			type: "post"
			,url: "${mvcPath}/customer/query"
			,data: "start_time="+start_time+"&end_time="+end_time+"&zb_code="+zb_code
			,dateType: "json"
			,success: function(data){
				var result =  eval('(' + data + ')');
				var sql = result.sql;
				var header = result.header;
				query(sql, header, 0);
			}
		})
	}
	
	function down1(){
		
	}
		
	function down(){
		var _d=new Date();
		var time = _d.format("yyyymm")-1;
		var sql = "select b.area_name, code_name, code_value from nmk.market_all_view a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' ) order by area_id) b on a.city_code=b.area_code where time_id='"+time+"'";
		var _header = [
		{
			"cellStyle":"grid_row_cell_number",
			"dataIndex":"area_name",
			"name":["地市"],
			"title":"",
			"cellFunc":""
		},
		{
			"cellStyle":"grid_row_cell_text",
			"dataIndex":"code_name",
			"name":["指标名称"],
			"title":"",
			"cellFunc":""
		},
		{
			"cellStyle":"grid_row_cell",
			"dataIndex":"code_value",
			"name":["值"],
			"title":"",
			"cellFunc":""
		}];
		aihb.AjaxHelper.down({
			sql : sql
			,header : _header
			,ds:"web"
			,isCached : false
			,"url" : "/hbirs/action/jsondata?method=down&fileKind=csv"
		});
	}
	
	</script>
	<script src="${mvcPath}/resources/highcharts/highcharts.js"></script>
</html>