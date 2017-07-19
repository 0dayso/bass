var hbbasscommonpath = '/hbbass/common2';
var xmlDoc = false;
var pagenum=30; //ÿҳ��ʾ������Ϣ 
var page=0;
var maxNum =0;
var pagesNumber=0;
var cellclass=new Array();//��Ԫ�����ʽ
var cellfunc=new Array();//��Ԫ��ֵ���?��
var celldisplay=new Array();//�Ƿ���ʾ��Ԫ��
var maxgridwidth = 99;//���Ŀ��
var rendertable = renderTbody;
var tableHead = defaultHeader;
var fetchRows=1000;
var seqformat = new Array();//��ʽ����#{0~n}
/************************************************************  ������    ************************************************************/
//����XML�ַ��ΪXML����
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

//Ajax��
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

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };//ΪString�������trim()����


/************************************************************  ���߷�����    ************************************************************/
/**
	ajax��װ��,����list(2ά����)��ص�����ʹ��
	@param surl: �����url
	@param sparam: ����Ĳ���
	@param func: �ص�����
	@param sync: �Ƿ���ͬ������
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
				lines = data.split("@|");//�ָ���
				for (i =0;i < lines.length; i++)
				{
					line = lines[i].split("@,");//��Ϊ��
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

function renderHtmlSelect(list,options)
{
		var select = options.select;
		var defaultName = options.defaultName;
		var isHoldFirstOption = false;
		
		//���û��defaultName�ʹ�?ɾ���һ��option
		if(defaultName == undefined || defaultName == '')
			isHoldFirstOption = true;
		
		if(isHoldFirstOption)//��ɾ���һ��
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
		surl = hbbasscommonpath+"/bassDimCache.jsp";
		sparam = "tagname="+encodeURIComponent(tagName)+"&name="+encodeURIComponent(name);
	}
	ajaxGetList(surl,sparam,renderHtmlSelect,{select:selects,defaultName:sdefaultName},sync);
}

/**
	������ͨ�÷���
	@param selects: ���вμ�������HTMLSelect��ǩ����������,˳�����
	@param sqls: ���вμ�������sql�ַ�����,˳�����(sql����е�valueͨ���ַ�'#{value}'����)
	@param i: �����ļ���,˳���1��ʼ
*/
function combolink(selects,sqls,i,sync)
{
	if(i > sqls.length)return;
	
	var value = selects[i-1].value;
	if(value==""||value=="0")
  {
  	// ���ݵ�ֵΪ��һ�ȫʡ����ȫ���� �¼�����ѡ�������ֱ����Ϊ��һ�ȫ���� �������ύ��ݿ��ѯ
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
	//������������
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
	formatDigit["1000"]="��";
	var constant=100;
	var sValue = "";
	if(arguments.length==1)sValue=arguments[0];
	else if(arguments.length==2)sValue=arguments[0][arguments[1].seq];
	else if(arguments.length==3)
	{
		sValue=arguments[0][arguments[1].seq];
		if(arguments[2]==1000)constant=1000;	
	}
	
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

function hideTitle(el3,objId)
{
	var obj = document.getElementById(objId);
	if(el3.flag ==0)
	{
		el3.src="/hb-bass-navigation/hbbass/common2/image/ns-expand.gif";
		el3.flag = 1;
		el3.title="�������";
		obj.style.display = "";
	}
	else
	{
		el3.src="/hb-bass-navigation/hbbass/common2/image/ns-collapse.gif";
		el3.flag = 0;
		el3.title="�����ʾ";
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
		if(a==1)return;
		
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


/************************************************************  ���ش�����    ************************************************************/
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
ִ������ 
*/
function toDown()
{
	var elpagenum=document.forms[0].allPageNum.value;
	document.forms[0].filename.value=document.title;
	
	var str="";
	var titlerows = arguments[0]||1;
	for(var k=0;k<titlerows;k++)
	{
		var objCell=resultTableDown.rows[k];
		if(str.length>0)str += "\r\n";
		for(var j=0;j<objCell.cells.length;j++)str+= objCell.cells[j].innerText.replace(/\r\n/gi,"")+",";
  	}
	document.forms[0].title.value=str;
	
 	if(elpagenum==0)
 	{
 		 alert("û�в�ѯ��¼!");
 		 return;
 	}
 	/*else if(elpagenum<=15)
 	{
 	   // bass 2.0 ��д�˴�ҳ��������ݵķ���
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


/************************************************************  �ύ��    ************************************************************/
function ajaxSubmit(options)
{
	var ajax = new AIHBAjax.Request({
		url:options.url,
		param:options.param,
		sync: options.sync||false,
		loadmask: options.loadmask != undefined?options.loadmask:true,
		callback:function(xmlHttp)
		{
			parseXMLDOM(xmlHttp.responseText);//��xmlDoc��ʼ��
			maxNum = xmlDoc.getElementsByTagName("result").length;//�����ļ�¼��
			pagesNumber=Math.ceil(maxNum/pagenum)-1; //ҳ��
			if(options.countSql!=undefined && maxNum==fetchRows)ajaxGetListWrapper(options.countSql,showCount);//��ʾ�����ʾ��Ϣ
		 	else 
		 	{
		 		var elsum = document.getElementById("showsum");
		 		if(elsum!=null)elsum.style.display="none";
		 		var elpagenum = document.getElementById("allPageNum");
		 		if(elpagenum!=null)elpagenum.value=maxNum;
		 	}
			page=0;// ���� renderGrid() ���뽫page�ó�0 ���򣬵�һ�β�ѯ������ҳ�󣬺����ѯ��ʾҳ�潫����
		  renderGrid();
		}
	});
}

function ajaxSubmitWrapper(sqlStatement,countSql,sSync,sLoadmask,sParam){ajaxSubmit({url:hbbasscommonpath+"/db2xml.jsp",param:"sql="+encodeURIComponent(sqlStatement)+(sParam==undefined?"":sParam),countSql:countSql,sync:sSync||false,loadmask:sLoadmask==undefined?true:sLoadmask});}


/************************************************************  չ�ֱ����    ************************************************************/
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
    	//���õ�Ԫ�����ʽ
    	if(cellclass.length==0 || cellclass[m]==undefined)BodyText+="<TD class='grid_row_cell_number' id='colindex"+m+"' style='display:block'>";
    	else BodyText+="<TD class='"+cellclass[m]+"' id='colindex"+m+"' style='display:block'>";
    	//��Ԫ��ֵ�ĸ�ʽ
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
  
  pb+='�� <font color=red>'+maxNum+' </font>����¼,&nbsp;ÿҳ <font color=red>'+pagenum+' </font>����¼&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<font color=red> '+(page+1)+' </font>ҳ/�� <font color=red>'+(pagesNumber+1)+' </font>ҳ';
  
  pb+="</td><td width='50%'>"+FirstPage(page)+"    "+UpPage(page)+"    "+NextPage(page)+"    "+LastPage(page)+"    "+selectPage(page);
  
  pb+="</td></tr></table>"
  return pb;
}

function FirstPage(page)
{
  thePage="��ҳ";
  if(page>0) thePage="<A HREF='#' onclick='{if(page>0)page=0;renderGrid();}'>��ҳ</A>";
  return thePage;
}
function UpPage(page)
{
  thePage="ǰһҳ";
  if(page+1>1) thePage="<A HREF='#' onclick='{if(page>0)page--;renderGrid(); 	}'>ǰһҳ</A>";
  return thePage;
}
function NextPage(page)
{
  thePage="��һҳ";
  if(page<pagesNumber) thePage="<A HREF='#' onclick='{if(page<pagesNumber)page++;renderGrid();}'>��һҳ</A>";
  return thePage;
}
function LastPage(page)
{
  thePage="βҳ";
  if(page<pagesNumber) thePage="<A HREF='#' onclick='{if (page<pagesNumber)page=pagesNumber;renderGrid(); }'>βҳ</A>";
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
	showsum.innerHTML="<center>��������������<font color=red>" +list[0][0] +"</font>��,Ϊ�����ϵͳ��ѯ�ٶ�,Ŀǰֻ��ʾǰ"+fetchRows+"��</center>";
  document.getElementById("allPageNum").value=list[0][0];
}

//��ҳ�渲��,�滻��"title_div"
function defaultHeader(){return document.getElementById("title_div").innerHTML;}

function renderGrid()
{
	var header=tableHead();
	header=header.replace('resultTable','resultTableDown');
	header=header.replace('</TABLE>','');
	header=header.replace('<TBODY>','<THEAD id="resultHead">');
	header=header.replace('</TBODY>','</THEAD>');
	
	for(var i=0; i < seqformat.length;i++)header=header.replace("#{"+i+"}",seqformat[i]);
 	
  var results = xmlDoc.getElementsByTagName("result");
  
  document.getElementById("showResult").innerHTML= rendertable(header,results);
 // alert(rendertable(header,results))
  align_fn(); // ���ж��������
  TitleControl() ; // �����ͷ����
}


/* 2010-3-9 Ϊ���е�ģ��������־��¼*/
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