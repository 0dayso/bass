var hbbasscommonpath = '/hb-bass-navigation/hbbass/common2';
var xmlDoc = false;
var pagenum=30; //每页显示几条信息 
var page=0;
var maxNum =0;
var pagesNumber=0;
var cellclass=new Array();//单元格的样式
var cellfunc=new Array();//单元格值处理方法
var celldisplay=new Array();//是否显示单元格
var maxgridwidth = 99;//表格的宽度
var rendertable = renderTbody;
var tableHead = defaultHeader;
var fetchRows=1000;
var seqformat = new Array();//格式化列#{0~n}
/************************************************************  基础方法区    ************************************************************/
//解析XML字符串成为XML对象
function parseXMLDOM(xml)
{
	if (window.ActiveXObject)
  {
  	xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
  	xmlDoc.loadXML(xml);
  }
  else xmlDoc = new DOMParser().parseFromString(xml, "text/xml");
}
function createRequest()
{
	var xmlrequest = false;
	if(window.ActiveXObject)
		try{
			xmlrequest = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e){
			try{xmlrequest = new ActiveXObject("Microsoft.XMLHTTP");}catch(e){}
		}
	else
		xmlrequest = new XMLHttpRequest();	
	return xmlrequest;
}

//Ajax类
if(typeof AIHBAjax == "undefined") var AIHBAjax = new Object();
AIHBAjax.Request = function(options){
	if(options.loadmask)loadmask.style.display="block";
  var xmlrequest = createRequest();
  if(options.sync)
  {
  	xmlrequest.open("POST",options.url,false);
  	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  	xmlrequest.send(options.param);
		if(xmlrequest.readyState == 4)
			if(xmlrequest.status == 200)
			{
				options.callback(xmlrequest);
				if(options.loadmask)loadmask.style.display="none";
			}
  }
  else
  {
	  xmlrequest.onreadystatechange=function()
		{
			if(xmlrequest.readyState == 4)
				if(xmlrequest.status == 200)
				{
					options.callback(xmlrequest);
					if(options.loadmask)loadmask.style.display="none";
				}
		}
		xmlrequest.open("POST",options.url,true);
		xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlrequest.send(options.param);
	}
};

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };//为String对象添加trim()方法


/************************************************************  工具方法区    ************************************************************/
/**
	ajax包装类,返回list(2维数组)给回调方法使用
	@param surl: 请求的url
	@param sparam: 请求的参数
	@param func: 回调函数
	@param sync: 是否是同步调用
*/
function ajaxGetList(surl,sparam,func,options,sync)
{
	bl=false;
	if(sync)bl=sync;
	var ajax = new AIHBAjax.Request({
		url:surl,
		param:sparam,
		sync:bl,
		callback:function(xmlHttp)
		{
			var data = xmlHttp.responseText.trim();
			var list =[];
			if(data!="null"&&data!=""){
				lines = data.split("@|");//分割行
				for (i =0;i < lines.length; i++)
				{
					line = lines[i].split("@,");//分为列
					var inner = new Array();
					for (j =0;j < line.length; j++)
					{
						inner.push(line[j]);
					}
					list.push(inner);
				}
			}
			if(func)func(list,options);
			else options.result=list;
			
		}
	});
}

function ajaxGetJson(surl,sparam,func,options,sync)
{
	bl=false;
	if(sync)bl=sync;
	var ajax = new AIHBAjax.Request({
		url:surl,
		param:sparam,
		sync:bl,
		callback:function(xmlHttp)
		{
			var data = eval(xmlHttp.responseText);
			if(func)func(data,options);
			else options.result=data;
		}
	});
}

function renderHtmlSelect(list,options)
{
		var select = options.select;
		var defaultName = options.defaultName;
		var isHoldFirstOption = false;
		
		//如果没有defaultName就代表不删除第一个option
		if(defaultName == undefined || defaultName == '')
			isHoldFirstOption = true;
		
		if(isHoldFirstOption)//不删除第一个
		{
			select.length=1;
			select.disabled = false;
			for (i =0;i < list.length; i++)select[i+1] = new Option(list[i][1],list[i][0]);
		}
		else
		{
			select.length=0;
			select.disabled = false;
			
			for (i =0;i < list.length; i++)
			{
				select[i] = new Option(list[i][1],list[i][0]);
				if(select[i].value==defaultName)select[i].selected = true;
			}
		}
}

function ajaxGetListWrapper(sqlStatement,func,options,sync,sParam){var param="";if(sParam)param=sParam;ajaxGetList(hbbasscommonpath+"/db2array.jsp","sql="+encodeURIComponent(sqlStatement)+param,func,options,sync);}

function renderSelect(tagName,name,selects,sdefaultName,sync)
{
	var surl ="";
	var sparam = "";
	if(tagName.substring(0,7)=="select ")
	{
		surl = hbbasscommonpath+"/db2array.jsp";
		sparam = "sql="+encodeURIComponent(tagName.replace("#{value}",name));
	}
	else
	{
		surl = hbbasscommonpath+"/bassDimCacheCombo.jsp";
		sparam = "tagname="+encodeURIComponent(tagName)+"Combo&name="+encodeURIComponent(name);
	}
	ajaxGetList(surl,sparam,renderHtmlSelect,{select:selects,defaultName:sdefaultName},sync);
}

/**
	联动的通用方法
	@param selects: 所有参加联动的HTMLSelect标签的数组引用,顺序插入
	@param sqls: 所有参加联动的sql字符串数组,顺序插入(sql语句中的value通过字符串'#{value}'代替)
	@param i: 联动的级别,顺序从1开始
*/
function combolink(selects,sqls,i,sync)
{
	if(i > sqls.length)return;
	
	var value = selects[i-1].value;
	if(value==""||value=="0")
  {
  	// 如果传递的值为第一项“全省”或“全部” 下级级联选择框内容直接置为第一项“全部” ，不再提交数据库查询
  	selects[i].length=1;
		selects[i].disabled = false;
  }
  else
  {
		renderSelect(sqls[i-1],value,selects[i],undefined,sync);
	}
	
	if(i < sqls.length)combolink(selects,sqls,i+1);
}
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		sqls.push("county");
	}
	
	if(document.forms[0].office!= undefined)
	{
		selects.push(document.forms[0].office);
		sqls.push("select channel_id,channel_name from nmk.RES_SITE_DS where county_id = '#{value}' order by channel_name with ur");
	}
	else if(document.forms[0].xpoffice!= undefined)
	{
		selects.push(document.forms[0].xpoffice);
		sqls.push("select channel_id,channel_name from NWH.Chl_XP_Channel where county_id = '#{value}' order by channel_name with ur");
	}
	
	if(document.forms[0].custmanager!= undefined)
	{
		selects.push(document.forms[0].custmanager);
		sqls.push("custmanager");
	}
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

function isEmail(strEmail) 
{
  var myReg = /^[_a-z0-9]+@([_a-z0-9]+\.)+[a-z0-9]{2,3}$/;
  if(myReg.test(strEmail)) return true;
  return false;
}

function isNumber(s)
{
	var patrn=/^(\+|-)?([0-9]\d*)(\.\d*[0-9])?$/;
  if (!patrn.exec(s)) return false;
	return true;
}

function numberFormat(foo,digit)
{
	var negative = false;
	if(foo.indexOf("-")==0){negative=true;foo=foo.substring(1,foo.length);}
	
	var ary = foo.split(".");
	var post="";
	if(ary.length==2)
  {
  	post = ary[1];
  	if(ary[1].length>digit)
  	{
	  	var nextnum = parseInt(ary[1].substring(digit,digit+1),10);
	  	var curnum = parseInt(ary[1].substring(0,digit),10);
	  	if(nextnum>=5)curnum = curnum+1;
	  	
	  	if(curnum<10)post="0"+curnum;
	  	else post = curnum + "";
	  	
	  	if(post.length> digit)
	  	{
	  		post=post.substring(1,digit+1);
	  		per = parseInt(ary[0],10)+1;
	  		ary[0]=per+"";
	  	}
	  }
	  else if (ary[1].length<digit)
	  {
	  	for(var a = 0; a < digit- ary[1].length;a++)post+="0";
	  }
  }
	
	i = ary[0].length;
	var abc = "";
	while(i > 3)
	{
		abc = ary[0].substring(i-3,i) + ","+abc;
		i-=3;
	}
	abc = ary[0].substring(0,i) + ","+abc;
	var result = abc.substring(0,abc.length-1);
  if(post.length>0)result += "."+ post;
  
	return negative?"-"+result:result;
}

function numberFormatDigit2()
{
	var sValue = "";
	if(arguments.length==1)sValue=arguments[0];
	else if(arguments.length==2)sValue=arguments[0][arguments[1].seq];
	return numberFormat(sValue,2);
}

function percentFormat()
{
	var formatDigit = [];
	formatDigit["100"]="%";
	formatDigit["1000"]="‰";
	var constant=100;
	var sValue = "";
	if(arguments.length==1)sValue=arguments[0];
	else if(arguments.length==2)sValue=arguments[0][arguments[1].seq];
	else if(arguments.length==3)
	{
		sValue=arguments[0][arguments[1].seq];
		if(arguments[2]==1000)constant=1000;	
	}
	if(sValue=="")return sValue;
	var digit=2;
	var ary = ((parseFloat(sValue)*constant)+"") .split(".");
	var post="";
  if(ary.length==2)
  {
  	post = ary[1];
  	if(ary[1].length>digit)
  	{
	  	var nextnum = parseInt(ary[1].substring(digit,digit+1),10);
	  	var curnum = parseInt(ary[1].substring(0,digit),10);
	  	if(nextnum>=5)curnum = curnum+1;
	  	
	  	if(curnum<10)post="0"+curnum;
	  	else post = curnum + "";
	  	
	  	if(post.length> digit)
	  	{
	  		post=post.substring(1,digit+1);
	  		per = parseInt(ary[0],10)+1;
	  		ary[0]=per+"";
	  	}
	  }
	  else if (ary[1].length<digit)
	  {
	  	for(var a = 0; a < digit- ary[1].length; a++ )post+="0";
	  }
  }
  result = ary[0];
  if(post.length>0)result += "."+ post;

	return result +formatDigit[""+constant] ;
}

/* added 20100916, to meet the request */

function fuzzFormat(){
		var value = "";
	if(arguments.length==1)value=arguments[0];
	else if(arguments.length==2)value=arguments[0][arguments[1].seq];
		
		var _res=String(value);
		if(/[0-9]{11}/.test(value)){//手机号码
			_res= value.substring(0,3)+"****"+value.substring(7,11);
		}else if(/\W{2,4}/.test(value)){
			_res= value.substring(0,1)+"**";
		}
		return _res;
}

function hideTitle(el,objId)
{
	var obj = document.getElementById(objId);
	if(el.flag ==0)
	{
		el.src="/hb-bass-navigation/hbbass/common2/image/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
	}
	else
	{
		el.src="/hb-bass-navigation/hbbass/common2/image/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}

function showArea(el)
{
	var foo = document.getElementById(el);
	
	if(foo.style.display=='none')
	{
		foo.style.top = event.clientY + document.body.scrollTop - document.body.clientTop 
		foo.style.display='block';
	}
	else if(foo.style.display=='block') foo.style.display='none';
}

function mappingArea()
{
	var foo = "";
	if(arguments.length==1)foo=arguments[0];
	else if(arguments.length==2)foo=arguments[0][arguments[1].seq];
	try{
		var nl = document.getElementsByName("city");
		for(var i=0;i< nl[0].length;i++)
		{
			if(nl[0].childNodes[i].value==foo)
			return nl[0].childNodes[i].text;
		}
		
		nl = document.getElementsByName("county");
		if(nl.length>0)
		{
			for(var i=0;i< nl[0].length;i++)
			{
				if(nl[0].childNodes[i].value==foo)
				return nl[0].childNodes[i].text;
			}
		}
		
		nl = document.getElementsByName("office");
		if(nl.length>0)
		{
			for(var i=0;i< nl[0].length;i++)
			{
				if(nl[0].childNodes[i].value==foo)
				return nl[0].childNodes[i].text;
			}
		}
	}
	catch(e){}
	return foo;
}

function mapping(foo,tagName)
{
	var nl = document.getElementsByName(tagName);
	try{
		for(var i=0;i< nl[0].length;i++)
		{
			if(nl[0].childNodes[i].value==foo)
			return nl[0].childNodes[i].text;
		}
	}
	catch(e){}
	return foo;
}

function selectColumns(seq,isShow)
{
	tabdiv = document.getElementById("title_div");
	
	nl = tabdiv.getElementsByTagName("span");
	a=0;
	for(var i=0; i < nl.length; i++)if(nl[i].childNodes[0].style.display!="none")a++;
	
	var gridwidth = tabdiv.childNodes[0].width.replace("%","");
	var tdwidthnl = nl[seq].childNodes[0].width.replace("%","");
	var numwidth=0;
	
	if(!isShow)
	{
		//if(a==1)return;//20090820修改去掉了最后一个隐藏的限制
		
		if(maxgridwidth > 99)
		{
			if(tdwidthnl !="") numwidth = parseInt(gridwidth,10)-parseInt(tdwidthnl,10);
			else numwidth = parseInt(gridwidth,10)-10;
			if(numwidth >=99)tabdiv.childNodes[0].width = numwidth+"%";
		}
		
		if(nl[seq].childNodes[0].style.display!="none")nl[seq].childNodes[0].style.display="none";
		if(celldisplay[nl[seq].id]==undefined)celldisplay[nl[seq].id]=true;
	}
	else
	{
		if(tdwidthnl !="") numwidth = parseInt(gridwidth,10)+parseInt(tdwidthnl,10);
		else numwidth = parseInt(gridwidth,10)+10;
		
		if(numwidth>maxgridwidth) numwidth = maxgridwidth;
		tabdiv.childNodes[0].width = numwidth+"%";
		if(nl[seq].childNodes[0].style.display!="block")nl[seq].childNodes[0].style.display="block";
		if(celldisplay[nl[seq].id])celldisplay[nl[seq].id]=undefined;
	}
}

function renderColumns(seq,isShow)
{
	selectColumns(seq,isShow);
	renderGrid();
}


/************************************************************  下载处理区    ************************************************************/
function SaveAsExcel2(fname)
{ 
	var str="";
	for(var i=0;i<resultTableDown.rows.length;i++)
	{
		for(j=0;j<resultTableDown.rows[0].cells.length;j++)str+=(resultTableDown.rows[i].cells[j].innerText)+",";
		str+="\n";
	}
	str=str.replace(/\r\n/g,"");
  document.forms[0].downcontent.value=str;
	document.forms[0].action="/hb-bass-navigation/hbbass/common/saveCsv.jsp?fname="+fname;
	document.forms[0].target="_top";
	document.forms[0].submit();
}

/* 
执行下载 
*/
function toDown()
{	
	var elpagenum=document.forms[0].allPageNum.value;
	document.forms[0].filename.value=document.title;
	var str="";
	var titlerows = arguments[0]||1;
	for(var k=0;k<titlerows;k++)
	{
		//加上异常处理，防止操作者在没有查询的情况下点击下载时抛异常
		try{
			var objCell=resultTableDown.rows[k];//当用户没有查询就点击下载时，此处抛异常
			if(str.length>0)str += "\r\n";
			for(var j=0;j<objCell.cells.length;j++)str+= objCell.cells[j].innerText.replace(/\r\n/gi,"")+",";
  		} catch(e) {
  		alert(e);
  			alert("没有查询，没有数据下载");
  			return;
  		}
  	}
	document.forms[0].title.value=str;
 	
 	//加上长度的判断更保险，防止操作者在没有查询的情况下直接点击下载
 	if(elpagenum==0 || elpagenum.length == 0)
 	{
 		 alert("没有查询记录!");
 		 return;
 	}
 	/*else if(elpagenum<=15)
 	{
 	   // bass 2.0 改写了从页面下载数据的方法
 	   SaveAsExcel2(document.forms[0].filename.value+".csv");
 	}*/
 	else if(elpagenum>0&&elpagenum<60000)
	{
 		document.forms[0].action = hbbasscommonpath+"/commonDown.jsp";
		document.forms[0].target = "_top";
		document.forms[0].submit();
	}
	else
	{
	  document.forms[0].action = hbbasscommonpath+"/commonDivisionDown.jsp";
		document.forms[0].target = "_blank";
		document.forms[0].submit();	
	}
}


/************************************************************  提交区    ************************************************************/
function ajaxSubmit(options)
{
	var ajax = new AIHBAjax.Request({
		url:options.url,
		param:options.param,
		sync: options.sync||false,
		loadmask: options.loadmask != undefined?options.loadmask:true,
		callback:function(xmlHttp)
		{
			parseXMLDOM(xmlHttp.responseText);//把xmlDoc初始化
			maxNum = xmlDoc.getElementsByTagName("result").length;//检索的记录数
			pagesNumber=Math.ceil(maxNum/pagenum)-1; //页数
			if(options.countSql!=undefined && maxNum==fetchRows){
				ajaxGetListWrapper(options.countSql,showCount,undefined,undefined,(options.param.indexOf("&ds")>0)?options.param.substring(options.param.indexOf("&ds")):undefined);//显示溢出提示信息
			}else {
		 		var elsum = document.getElementById("showsum");
		 		if(elsum!=null)elsum.style.display="none";
		 		var elpagenum = document.getElementById("allPageNum");
		 		if(elpagenum!=null)elpagenum.value=maxNum;
		 	}
			page=0;// 调用 renderGrid() 必须将page置成0 否则，第一次查询多次完后翻页后，后续查询显示页面将错误。
		  renderGrid();
		}
	});
}

function ajaxSubmitWrapper(sqlStatement,countSql,ds,sSync,sLoadmask,sParam){
	ajaxSubmit(
		{
			url:hbbasscommonpath+"/db2xml.jsp",
			param:"sql="+encodeURIComponent(sqlStatement)+(sParam==undefined?"":sParam)+(ds!=undefined?"&ds="+ds:""),
			countSql:countSql,
			sync:sSync||false,
			loadmask:sLoadmask==undefined?true:sLoadmask
		}
	);

}


/************************************************************  展现表格区    ************************************************************/
function renderTbody(BodyText,results)
{
	var colNum=0;
  if(results.length >0) colNum = results[0].childNodes.length;
	var endNum=(page+1)*pagenum;
  if (endNum>maxNum) endNum=maxNum;
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for ( n=(page*pagenum); n<endNum; n++)
  {
  	if(n%2==0)BodyText=BodyText+"<TR class='grid_row_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">";
    else BodyText=BodyText+"<TR class='grid_row_alt_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">";
  	var datas = new Array();
  	for(var m=0;m<=colNum-1;m++)
  	{
  		if(results[n].childNodes[m].childNodes.length==0)datas[m]="";
  		else datas[m]=results[n].childNodes[m].childNodes[0].nodeValue;
  	}
    BodyText+=renderCell(datas,0,colNum,n)+"</TR>";
  }
  
  BodyText += totalRow(datas);
  
  BodyText = BodyText+"</TBODY></table><textarea name='downcontent' cols='122' rows='12' style='display:none'></textarea>"+footbar();
  return BodyText;
}

function totalRow(datas){return "";}

function renderCell(datas,m,colNum,rows)
{
	var BodyText = ""
	for(;m<=colNum-1;m++)
  {
  	if(celldisplay.length==0 || celldisplay[m]==undefined)
  	{
    	//设置单元格的样式
    	if(cellclass.length==0 || cellclass[m]==undefined)BodyText+="<TD class='grid_row_cell'>";
    	else BodyText+="<TD class='"+cellclass[m]+"'>";
    	//单元格值的格式
    	if(cellfunc.length==0 || cellfunc[m]==undefined)BodyText+=datas[m];
    	else BodyText+=cellfunc[m](datas,{seq:m,rownum:rows});
    	BodyText+="</TD>";
  	}
  	else
  	{
  		BodyText+="<TD style='display:none'></TD>";
  	}
  }
  return BodyText;
}

function footbar()
{
  var pb="<table width='98%' border='0' align='center' cellpadding='0' cellspacing='1'><tr align='center'><td width='50%'>"
  
  pb+='共 <font color=red>'+maxNum+' </font>条记录,&nbsp;每页 <font color=red>'+pagenum+' </font>条记录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第<font color=red> '+(page+1)+' </font>页/共 <font color=red>'+(pagesNumber+1)+' </font>页';
  
  pb+="</td><td width='50%'>"+FirstPage(page)+"    "+UpPage(page)+"    "+NextPage(page)+"    "+LastPage(page)+"    "+selectPage(page);
  
  pb+="</td></tr></table>"
  return pb;
}

function FirstPage(page)
{
  thePage="首页";
  if(page>0) thePage="<A HREF='#' onclick='{if(page>0)page=0;renderGrid();}'>首页</A>";
  return thePage;
}
function UpPage(page)
{
  thePage="前一页";
  if(page+1>1) thePage="<A HREF='#' onclick='{if(page>0)page--;renderGrid(); 	}'>前一页</A>";
  return thePage;
}
function NextPage(page)
{
  thePage="后一页";
  if(page<pagesNumber) thePage="<A HREF='#' onclick='{if(page<pagesNumber)page++;renderGrid();}'>后一页</A>";
  return thePage;
}
function LastPage(page)
{
  thePage="尾页";
  if(page<pagesNumber) thePage="<A HREF='#' onclick='{if (page<pagesNumber)page=pagesNumber;renderGrid(); }'>尾页</A>";
  return thePage;
}
function changePage(tpage)
{    
  page=tpage
  if(page>=0) page--; 
  if (page<pagesNumber) page++;
  renderGrid(); 
}
function selectPage(page)
{
  var sp;
  sp="<select name='toPage' onChange='javascript:changePage(this.options[this.selectedIndex].value)'>";
  for (t=0;t<=pagesNumber;t++)
  {   
  	if(page==t)sp=sp+"<option value='"+t+"' selected>"+(t+1)+"</option>";
  	else sp=sp+"<option value='"+t+"'>"+(t+1)+"</option>";
  }
  sp=sp+"</select>"
  return sp;
}

function showCount(list)
{
	var showsum=document.getElementById("showsum");
	showsum.style.display="block";
	showsum.innerHTML="<center>符合条件的数据有<font color=red>" +list[0][0] +"</font>条,为了提高系统查询速度,目前只显示前"+fetchRows+"条</center>";
  document.getElementById("allPageNum").value=list[0][0];
}

//给页面覆盖,替换掉"title_div"
function defaultHeader(){return document.getElementById("title_div").innerHTML;}

function renderGrid()
{
	var header=tableHead();
	header=header.replace('resultTable','resultTableDown');
	header=header.replace('</TABLE>','');
	header=header.replace('</table>','');
	
	header=header.replace('<TBODY>','<THEAD id="resultHead">');
	header=header.replace('<tbody>','<thead id="resultHead">');
	
	header=header.replace('</TBODY>','</THEAD>');
	header=header.replace('</tbody>','</thead>');
	
	for(var i=0; i < seqformat.length;i++)header=header.replace("#{"+i+"}",seqformat[i]);
 	
  var results = xmlDoc.getElementsByTagName("result");
  
  document.getElementById("showResult").innerHTML= rendertable(header,results);
}

/**  记录运营监控报表和热点跟踪的日志 **/
function log(opertype,catacode,opername) {
	//使用下面的通用模块不使用该方法2010-3-9
	/*if (typeof opertype == "boolean"){
		if(opertype)opertype = 'down';
		else opertype = "query";
	}
	if(!catacode)catacode='运营监控报表';
	var title = opername || document.getElementsByTagName('title')[0].innerHTML;
	new AIHBAjax.Request({
		url: "/hb-bass-navigation/hbbass/common2/log.jsp",
		param: ("opername=" + title + "&opertype=" + opertype+"&catacode=" + catacode) ,
		sync: false,
		loadmask: false,
		callback:function(xmlHttp){}
	});*/
	
}

/* 2010-3-9 为所有的模块增加日志记录*/
function _addEventListener(target,method,advice){
	if(target.attachEvent){
		target.attachEvent("on"+method,advice);
	}else if(target.addEventListener){
		target.addEventListener(method,advice);
	}
}

_addEventListener(window,"load",function(){
	if(typeof doSubmit != "undefined"){
		doSubmit=_before(doSubmit,function(){
			_log("query");
		});
	}
	
	if(typeof toDown != "undefined"){
		toDown=_before(toDown,function(){
			_log("down");
		});
	}
});

function _log(opertype){
	
	var _params=_paramsObj();
	var _uri=_params._oriUri+"&opertype="+opertype;
	if(_uri.indexOf("sid")==-1){
		_uri+="&opername="+encodeURIComponent(document.getElementsByTagName('title')[0].innerHTML);
	}
	//debugger;
	if(_uri.match(/funccode/gi)){
		var ajax = new _Ajax({
			url : "/hb-bass-navigation/hbirs/action/log"
			,parameters : _uri
			,loadmask : false
			,callback : function(xmlrequest){}
		});
		ajax.request();
		/*
		new AIHBAjax.Request({
			url: "/hbirs/action/log",
			param: _uri,
			sync: false,
			loadmask: false,
			callback:function(xmlHttp){}
		});*/
	}
}

function _before(target,advice){
	var ori=target;
	target=function(){
		advice();
		ori.apply(this,arguments);
	}
	return target;
}

//added by higherzl 2010.05.25
function _after (target,advice){
	var ori=target;
	target=function(){
		ori.apply(this,arguments);
		advice();
	}
	return target;
}

function _paramsObj(){
	var _uri = window.location+"";
	var _paramStr = "";
	var _encoderOriUri="";
	if(_uri.indexOf("?")>0){
		_uri = _uri.substring(_uri.indexOf("?")+1,_uri.length);
		var _arr = _uri.split("&");
		for(var i=0;i<_arr.length;i++){
			var _arr2=_arr[i].split("=");
			if(_encoderOriUri.length>0)_encoderOriUri+="&";
			_encoderOriUri +=_arr2[0]+"="+encodeURIComponent(_arr2[1]);
			if(_paramStr.length>0)_paramStr+=",";
			_paramStr += '"'+_arr2[0]+'":"'+_arr2[1]+'"';
		}
	}else{
		_uri="";
	}
	var _objParams={};
	eval('_objParams={\"_oriUri\":\"'+_uri+'\",\"_encoderOriUri\":\"'+_encoderOriUri+'\"'+(_paramStr.length>0?','+_paramStr:'')+'}');
	return _objParams;
}
var _Ajax={};
_Ajax=function(){this.initialize.apply(this,arguments);}
_Ajax.prototype = {

	initialize : function (options) {
		this.options = {
			method : "post"
			,url : ""
			,parameters : ""
			,asynchronous : true
			,callback : function(xmlrequest){}
			,loadmask : false
			//,contentType:"application/x-www-form-urlencoded"
			//,encoding:"UTF-8"
		};
		for (var key in options || {}) {
			this.options[key] = options[key];
		}
		if (typeof this.options.parameters != "string") {
			var _parameters = "";
			for (var key in this.options.parameters || {}) {
				_parameters += "&" + key + "=" + encodeURIComponent(this.options.parameters[key]);
			}
			this.options.parameters = _parameters;
		}
		
		this.xmlrequest= this.create();
	},
	
	create : function() {
		var xmlrequest = false;
		if (window.ActiveXObject) {
			try {xmlrequest = new ActiveXObject("Msxml2.XMLHTTP");}
			catch (e) {
				try {xmlrequest = new ActiveXObject("Microsoft.XMLHTTP");}
				catch (e) {}
			}
		} else {xmlrequest = new XMLHttpRequest();}
		return xmlrequest;
	},
	
	request : function () {
		var xmlrequest = this.xmlrequest;
		var options = this.options;
		var respondToReadyState = this.respondToReadyState;
		if (options.loadmask && loadmask) loadmask.style.display = "block";
		
		try {
			xmlrequest.open(options.method.toUpperCase(), options.url, options.asynchronous);
			
			if (!options.asynchronous) {
				respondToReadyState(xmlrequest,options);
			} else {
				xmlrequest.onreadystatechange = function(){
						respondToReadyState(xmlrequest,options)
					};
			}
			xmlrequest.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
			xmlrequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			xmlrequest.setRequestHeader("Request-Type", "ajax");
			xmlrequest.send(this.options.parameters);
		}
		catch (e) {}
	},
	
	respondToReadyState : function(xmlrequest,options){
		var readyState = xmlrequest.readyState;
		if (readyState == 4) {
			if (xmlrequest.status == 200) {
				options.callback(xmlrequest);
				if (options.loadmask && loadmask) loadmask.style.display = "none";
			}
		}
	}
};