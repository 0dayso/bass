/*****************************  Action Method       *********************************************/
var gridCurZbcode;
var chartCurZbcode;
var valuetype;
var appName="";
function renderMap(obj)
{
	var sdiv = document.getElementById("mapdiv");
	if(sdiv)sdiv.innerHTML='<object id="map1" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="350" height="230"><param name="movie" value="../localres/swf/'+(obj.length>1?obj.substring(3,5):obj).toLowerCase()+'.swf"/><param name="wmode" value="transparent"/>';
}

function kpiviewProcess(who)
{
	var sArea = getAreaCode();
	var sDate = document.forms[0].date.value;
	var brand = (document.forms[0].brands)?document.forms[0].brands.value:"";
	var kind = (document.forms[0].kind)?document.forms[0].kind.value:"";
	try{
		renderMap(document.forms[0].city.value);
	}
	catch(e){}
	if(arguments.length==0||who=="grid"||who=="loadmask")
	{
		ajaxSubmit({
			url: "../action.jsp?appName="+appName+"&method=kpiview&kind="+kind,
			loadmask : who=="loadmask"?true:false,
			param: "brand="+brand+"&area="+sArea+"&date="+sDate+"&zbcode="+(gridCurZbcode||"default")
		});
		var objTitle= document.getElementById("kpititle");
		if(objTitle)objTitle.innerHTML=sDate.substring(0,4)+"年"+sDate.substring(4,6)+"月"+(sDate.length==8?(sDate.substring(6,8)+"日"):"")+" "+mappingArea(sArea) + " KPI指标";
	}
	if(arguments.length==0||who=="chart"||who=="loadmask")renderChart({
		url: "../action.jsp?appName="+appName+"&method=chartkpiview",
		loadmask : who=="loadmask"?true:false,
		param: "brand="+brand+"&area="+sArea+"&date="+sDate+"&zbcode="+(chartCurZbcode||"default")+"&valuetype="+(valuetype||""),
		width : "540",
		height : "230",
		chartid:"chartrender",
		chartSWF : ChartSwf[chartswf]
	});
}

function getAreaCode(){
	var _sArea=null;
	var f=document.forms[0];
	if(f.town && f.town.value!=""){
		_sArea = f.town.value;
	}else if(f.marketing_center && f.marketing_center.value!=""){
		_sArea = f.marketing_center.value;
	}else if (f.county_bureau && f.county_bureau.value!=""){
		_sArea = f.county_bureau.value;	
	}else if (f.college && f.college.value!=""){
		_sArea = f.college.value;
	}else if (f.entCounty && f.entCounty.value!=""){
		_sArea = f.entCounty.value;
	}else if (f.county && f.county.value!=""){
		_sArea = f.county.value;
	}else if (f.node && f.node.value!=""){
		_sArea = f.node.value;
	}else{
		_sArea = (f.city.value=="0"?"HB":f.city.value);
	}
	
	return _sArea;
}

function kpiprogressProcess(who)
{
	var sArea = getAreaCode();
	var sDate = document.forms[0].date.value;
	var brand = (document.forms[0].brands)?document.forms[0].brands.value:"";
	if(arguments.length==0||who=="grid"||who=="loadmask")
	{
		var _extParam = "";
		try{
			if(detailoffice!=undefined)_extParam="&detailoffice="+detailoffice;
		}catch(e){}
		ajaxSubmit({
			url: "../action.jsp?appName="+appName+"&method=kpiprogress",
			loadmask : who=="loadmask"?true:false,
			param: "brand="+brand+"&area="+sArea+"&date="+sDate+"&zbcode="+chartCurZbcode+_extParam
		});
		//alert("kpi.js-->kpiprogressProcess-->brand="+brand+"&area="+sArea+"&date="+sDate+"&zbcode="+chartCurZbcode+_extParam);
		var objTitle= document.getElementById("kpititle");
		if(objTitle)objTitle.innerHTML=sDate.substring(0,4)+"年"+sDate.substring(4,6)+"月"+(sDate.length==8?(sDate.substring(6,8)+"日"):"")+" "+mappingArea(sArea) +" " +kpiname;
	}
	
	if(arguments.length==0||who=="chart"||who=="loadmask"){
		var _extParam = "";
		try{
			if(detailoffice!=undefined)_extParam="&detailoffice="+detailoffice;
		}catch(e){}
		renderChart({
			url: "../action.jsp?appName="+appName+"&method=chartkpiview",
			loadmask : who=="loadmask"?true:false,
			param: "brand="+brand+"&area="+sArea+"&date="+sDate+"&zbcode="+(chartCurZbcode||"default")+"&valuetype="+(valuetype||"")+ _extParam,
			width : _extParam==""?"540":"880",
			height : "230",
			chartid:"chartrender",
			chartSWF : ChartSwf[chartswf]
		});
	}
}
/*****************************  Util Method       *********************************************/
var chartswf = "1";
var ChartSwf=[];
ChartSwf["1"]="../../resources/chart/Charts/FCF_MSColumn3DLineDY.swf";
ChartSwf["2"]="../../resources/chart/Charts/FCF_Column3D.swf";
ChartSwf["3"]="../../resources/chart/Charts/FCF_MSColumn3D.swf";
ChartSwf["4"]="../../resources/chart/Charts/FCF_MSLine.swf";
ChartSwf["5"]="../../resources/chart/Charts/FCF_Pie2D.swf";

function renderChart(options)
{
	//alert(options.url);
	var ajax = new AIHBAjax.Request({
		url:options.url,
		loadmask : options.loadmask != undefined?options.loadmask:true,
		param:options.param,
		callback:function(foo)
		{
			fChartData = foo.responseText;
			//if(fChartData=="")//alert("5555=没有数据");
			//else 
			if(fChartData!="")
				chart(options);
		}
	});
}

function chart(options)
{
	var chart = new FusionCharts(options.chartSWF, "ChartId", options.width, options.height);
	chart.setDataXML(encodeURIComponent(fChartData.replace("%25","%")));
	chart.addParam("wmode","transparent");
	chart.render(options.chartid);
}

function mappingArea(foo)
{
	function innerMapText(val,elems){
		for(var i=0;i< elems.length;i++){
			if(elems.childNodes[i].value==val)
			return elems.childNodes[i].text;
		}
		return val;
	}
	if(foo=="HB"||foo=="0"){
		return "全省";
	}
	var res=foo;
	
	try{
		var nl = document.getElementsByName("marketing_center");
		if(nl.length>0){
			res=innerMapText(foo,nl[0]);
		}
		if(res==foo){
			if(document.getElementsByName("county").length>0){
				nl = document.getElementsByName("county")
			}else if(document.getElementsByName("county_bureau").length>0){
				nl=document.getElementsByName("county_bureau")
			}else if(document.getElementsByName("entCounty").length){
				nl=document.getElementsByName("entCounty");
			}else if(document.getElementsByName("college").length>0){
				nl=document.getElementsByName("college");
			}else{
				nl=[];
			}
			if(nl.length>0){
				res=innerMapText(foo,nl[0]);
			}
			
			if(res==foo){
				nl = document.getElementsByName("city");
				res=innerMapText(foo,nl[0]);
			}
		}
	}
	catch(e){debugger;}
	return res;
}

//******************************************
/*
function logger(sZbcode,oper){
	var ajax = new AIHBAjax.Request({
		url:"../action.jsp?appName="+appName+"&appName="+appName+"&method=logger",
		param:"&zbcode="+sZbcode+"&oper="+oper,
		sync:false,
		callback:function(xmlHttp){}
	});
}
*/

function progress(sZbname,sZbcode,sPercentType)
{
	//logger(sZbcode,"detail");
	//logger(sZbcode,"progress");
	var sArea = document.forms[0].city.value;
	var brand = (document.forms[0].brands)?document.forms[0].brands.value:"";
	//parent.parent.topFrame.theCreateTab.add("<b>"+sZbname+"</b> 进度监控,mainFrame,../kpiprogress/kpiprogress.jsp?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&area="+sArea+"&percentType="+sPercentType+"&brand="+document.forms[0].brands.value);
	//parent.parent.topFrame.theCreateTab.add("<b>"+sZbname+"</b>,mainFrame,kpiviewDetail.jsp?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&area="+sArea+"&percentType="+sPercentType+"&brand="+brand);
	tabAdd({title: sZbname+"进度监控" ,url: "/hb-bass-navigation/hbapp/kpiportal/kpiview/kpiviewDetail.jsp?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&area="+sArea+"&percentType="+sPercentType+"&brand="+brand})
}

function compare(sZbname,sZbcode,sPercentType)
{
	//logger(sZbcode,"compare");
	var brand = (document.forms[0].brands)?document.forms[0].brands.value:"";
	//parent.parent.topFrame.theCreateTab.add("<b>"+sZbname+"</b> 比较分析,mainFrame,../kpicompare/kpicompare.htm?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&percentType="+sPercentType+"&brand="+brand);
	tabAdd({title: sZbname+"比较分析" , url : "/hb-bass-navigation/hbapp/kpiportal/kpicompare/kpicompare.htm?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&percentType="+sPercentType+"&brand="+brand});
}

function fluctuating(sZbname,sZbcode,sPercentType,sValuetype,sArea)
{
	if(sArea.split("@")[0].length>8)
		alert("营业厅暂时不支持波动分析");
	else
	{
		//logger(sZbcode,"fluctuating");
		parent.parent.topFrame.theCreateTab.add("<b>"+sZbname+"</b> 波动分析,mainFrame,../kpiwave/kpiwave.jsp?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&area="+sArea+"&percentType="+sPercentType+"&valuetype="+sValuetype);
		tabAdd({title: sZbname+"波动分析" , url : "/hb-bass-navigation/hbapp/kpiportal/kpiwave/kpiwave.jsp?appName="+appName+"&zbcode="+sZbcode+"&date="+document.forms[0].date.value+"&zbname="+sZbname+"&area="+sArea+"&percentType="+sPercentType+"&valuetype="+sValuetype});
	}
}

function jindu(datas,options)
{
	if(isNumber(datas[options.seq]))
		return "<a href='#' onclick='{chartswf=\"2\";valuetype=\"progress\";kpiprogressProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>";
	else return "--";
}

function gap(datas,options)
{
	if(isNumber(datas[options.seq-1]))
		return "<a href='#' onclick='{chartswf=\"2\";valuetype=\"progress\";kpiprogressProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>";
	else return "--";
}

function targetValue(datas,options){
	var target=datas[options.seq].split("@")[0];
	var format=datas[options.seq].split("@")[1];
	if(isNumber(target)){
		var str=(format=="percent")?percentFormat(target):numberFormatDigit2(target);
		return str;
	}
	else return "--";
}

function mapClick(obj)
{
	if(obj.length>5){document.forms[0].county.value=obj;}
	else {document.forms[0].city.value=obj;areacombo(1);}
	kpiviewProcess();
}

function displaymore(el)
{
	var kind = $("kind").value;
	var obj = document.getElementById("showResult");
	if(el.flag ==0){
		el.src="../../resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="显示更多指标";
		gridCurZbcode=undefined;
		kpiviewProcess("grid");
		
		$("dpLabel").innerText=$("dpLabel").label;
		//obj.style.height="175 px";
	}else{
		
		$("dpLabel").innerText="全部指标";
		
		el.src="../../resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="隐藏指标";
		if(kind=='chlrec'){
			gridCurZbcode="ch";
		}else{
			gridCurZbcode="all";
		}
		kpiviewProcess("grid");
		//obj.style.height="200 px";
	}
}

function showArea(el)
{
	var foo = document.getElementById(el);
	
	if(foo.style.display=='none')
	{
		foo.style.top = event.clientY + document.body.scrollTop - document.body.clientTop;
		foo.style.left = event.clientX + document.body.scrollLeft - document.body.clientLeft; 
		foo.style.display='block';
	}
	else if(foo.style.display=='block') foo.style.display='none';
}

function Threshold()
{
	this.path="";
	this.tongbiUp=0.05;
	this.huanbiUp=0.05;
	this.tongbiDown=-0.05;
	this.huanbiDown=-0.05;
	this.getTongbiImg=function(value,zbcode,zbname,sValuetype,sArea){
		if(this.tongbiUp==undefined) return "";
		else
		{
			/*var areacode = document.forms[0].city.value;
			if(!sArea)sArea=areacode=="0"?"0":areacode+"@"+mappingArea([areacode],{seq:0});
			if(value>this.tongbiUp)return "<img src='images/up.gif' border='0' title='波动分析' style='cursor:hand;' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";
			else if(value<this.tongbiDown)return "<img src='images/down.gif' border='0' title='波动分析' style='cursor:hand;' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";
			else return "<img src='images/right.gif' border='0' title='波动分析' style='cursor:hand;' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";*/
			if(value>this.tongbiUp)return "<img src='"+this.path+"up.gif' border='0'></img>";
			else if(value<this.tongbiDown)return "<img src='"+this.path+"down.gif' border='0'></img>";
			else return "<img src='"+this.path+"right.gif' border='0'></img>";
		}
	}
	this.getHuanbiImg=function(value,zbcode,zbname,sValuetype,sArea){
		if(this.huanbiUp==undefined) return "";
		else
		{
			var areacode = document.forms[0].city.value;
			if(!sArea)sArea=areacode=="0"?"0":areacode+"@"+mappingArea([areacode],{seq:0});
			if(value>this.huanbiUp)return "<img src='"+this.path+"up.gif' border='0' style='cursor:hand;' title='波动分析' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";
			else if(value<this.huanbiDown)return "<img src='"+this.path+"down.gif' style='cursor:hand;' border='0' title='波动分析' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";			
			else return "<img src='"+this.path+"right.gif' border='0' title='波动分析' style='cursor:hand;' onclick='fluctuating(\""+zbname+"\",\""+zbcode+"\",\"\",\""+sValuetype+"\",\""+sArea+"\")'></img>";
		}
	}
}


function kpicustomeize(zbcode,isCustom)
{
	var sDate = document.forms[0].date.value;
	var ajax = new AIHBAjax.Request({
		url:"../action.jsp?appName="+appName+"&appName="+appName+"&method=customeize",
		loadmask : false, 
		param:"zbcode="+zbcode+"&date="+sDate+"&custom="+isCustom.checked,
		callback:function(obj){
			cur_custom=obj.responseText;
			kpiviewProcess("grid");
		}
	});
}

function chartLink(datas,options,zbcode,spercent,svaluetype)
{
	var sTitel = "";
	if(document.forms[0].date.value.length==6)
	{
		if(svaluetype=="pre")sTitel="上月数值";
		else if(svaluetype=="before")sTitel="去年数值";
		else sTitel="当月数值";
	}
	else
	{
		if(svaluetype=="pre")sTitel="前日数值";
		else if(svaluetype=="before")sTitel="上月数值";
		else if(svaluetype=="year")sTitel="去年数值";
		else sTitel="当日数值";
	}
	sTitel = "点击查看\""+sTitel+"\"图表";
	var str= "";
	if(zbcode=="K11009"||"K11010"==zbcode)str=numberFormat(datas[options.seq]);
	else str=(spercent=="percent")?percentFormat(datas,options):numberFormatDigit2(datas,options);
	return "<a href='#' title='"+sTitel+"' onclick='{chartswf=\"1\";chartCurZbcode=\""+zbcode+"\";valuetype=\""+svaluetype+"\";kpiviewProcess(\"chart\");}'>"+str+"</a>";
}

/****************   特殊Grid *******************/
function selectRow(obj)
{
	var nodes = document.getElementById("resultTbody").childNodes;
	for(var i=0;i<nodes.length;i++)
	{
		nodes[i].className="grid_row_blue";
	}
	obj.className="grid_row_alt_blue";
	chartCurZbcode=obj.id.split("_")[2];
	//kpiviewProcess("chart");
}

function renderSelbody(BodyText,results)
{
	var colNum=0;
  if(results.length >0) colNum = results[0].childNodes.length;
	var endNum=(page+1)*pagenum;
  if (endNum>maxNum) endNum=maxNum;
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for ( n=(page*pagenum); n<endNum; n++)
  {
  	var datas = new Array();
  	for(var m=0;m<=colNum-1;m++)
  	{
  		if(results[n].childNodes[m].childNodes.length==0)datas[m]="";
  		else datas[m]=results[n].childNodes[m].childNodes[0].nodeValue;
  	}
  	if(datas[datas.length-1]==chartCurZbcode)
  	BodyText+="<TR id=\"grid_row_"+datas[datas.length-1]+"\" class='grid_row_alt_blue' onMouseOver=\"this.style.cursor='hand';\" onMouseOut=\"this.style.cursor='default';\" onclick=\"selectRow(this)\">";
  	else
  	BodyText+="<TR id=\"grid_row_"+datas[datas.length-1]+"\" class='grid_row_blue' onMouseOver=\"this.style.cursor='hand';\" onMouseOut=\"this.style.cursor='default';\" onclick=\"selectRow(this)\">";
    BodyText+=renderCell(datas,0,colNum,n)+"</TR>";
  }
  
  BodyText += "</TBODY></table>";
  return BodyText;
}

function renderCompbody(BodyText,results)
{
	var colNum=0;
  if(results.length >0) colNum = results[0].childNodes.length;
	var endNum=(page+1)*pagenum;
  if (endNum>maxNum) endNum=maxNum;
	BodyText=BodyText+"<TBODY id='resultTbody'>";
	
	BodyText+='<tr class="grid_title_blue">';
	
	BodyText = BodyText.replace("#{width}",(colNum>10?10*(colNum-1):99)+"%")
	for(var m=0;m<=colNum-1;m++)
  	{
  		var str = "";
  		if(results[0].childNodes[m].childNodes.length!=0)str=results[0].childNodes[m].childNodes[0].nodeValue;
  		BodyText+='<td class="grid_title_cell">'+str+'</td>';
  	}
	BodyText+="</tr>"
	
	
  for ( n=(page*pagenum)+1; n<endNum; n++)
  {
  	if(n%2==0)BodyText=BodyText+"<TR class='grid_row_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">";
    else BodyText=BodyText+"<TR class='grid_row_alt_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">";
  	var datas = new Array();
  	for(var m=0;m<=colNum-1;m++)
  	{
  		if(results[n].childNodes[m].childNodes.length==0)datas[m]="";
  		else datas[m]=results[n].childNodes[m].childNodes[0].nodeValue;
  	}
    BodyText+=renderCompCell(datas,0,colNum)+"</TR>";
  }
  
  BodyText = BodyText+"</TBODY></table>";
  return BodyText;
}

function renderCompCell(datas,m,colNum)
{
	var BodyText = ""
	for(;m<=colNum-1;m++)
  {
  	if(celldisplay.length==0 || celldisplay[m]==undefined)
  	{
    	//设置单元格的样式 
   		if(m==0)BodyText+="<TD class='grid_row_cell'>";
   		else BodyText+="<TD class='grid_row_cell_number'>";
    	
    	//单元格值的格式
    	if(m==0)BodyText+=datas[m];
    	else BodyText+=comparecellfunc(datas,{seq:m});
    	BodyText+="</TD>";
  	}
  	else
  	{
  		BodyText+="<TD style='display:none'></TD>";
  	}
  }
  return BodyText;
}


function swichContent(tar,obj){
	if(tar.style.display=="none"){
		tar.style.display="";
		obj.src="../../resources/image/default/collapse.gif";
		$("showResult").style.height="195 px";
	}else {
		tar.style.display="none";
		obj.src="../../resources/image/default/expand.gif";
		$("showResult").style.height="360 px";
		var obj = $("divmore");
		obj.flag="1";
		displaymore(obj);
	}
}

function initialTrendDate(sDate){
	$('dura_to').value = sDate;
	
	if(sDate.length==8){
		var day = parseInt(sDate.substring(6,8),10)-10;
		if(day>0){
			sDate = sDate.substring(0,6);
		}
		else{
			day += 29;
			var month = parseInt(sDate.substring(4,6),10)-1;
			if(month>0)
				if(month>9)sDate = (sDate.substring(0,4)+month);
				else sDate = (sDate.substring(0,4)+"0"+month);
			else sDate = ((parseInt(sDate.substring(0,4),10)-1)+"12");
		}
		if(day<10&&day>0)sDate+="0"+day;
		else sDate+=day;
		
		$('dura_from').value=sDate;
	}
	else{
		$('dura_from').value=((parseInt(sDate.substring(0,4),10)-1)+"")+sDate.substring(4,6);
	}
 }
  	
	