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
var chartxmls=false;
var areagroup;
var rendertable = renderTbody;
var chartName = "";
var fetchRows=1000;

/************************************************************  ������    ************************************************************/
//����XML�ַ��ΪXML����
function parseXMLDOM(xml)
{
	if (window.ActiveXObject)
  {
  	xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
  	xmlDoc.loadXML(xml);
  }
  else
  	xmlDoc = new DOMParser().parseFromString(xml, "text/xml");
}
function createRequest()
{
	var xmlrequest = false;
	if(window.ActiveXObject)
		try{
			xmlrequest = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e){
			try{
				xmlrequest = new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e){}
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
	����sql��䷵��2ά����
	@param sqlStatement: sql���
	@param callback: �ص�����,���ҵ���?��list(2ά����)
*/
function ajaxGetArray(sqlStatement,func,sync)
{
	bl=false;
	if(sync)bl=sync;
	var ajax = new AIHBAjax.Request({
		url:hbbasscommonpath+"/db2array.jsp",
		param:"sql="+encodeURIComponent(sqlStatement),
		sync:bl,
		callback:function(xmlHttp)
		{
			var data = xmlHttp.responseText.trim();
			var list = new Array();
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
			func(list);
		}
	});
}

/**
	��HTML Select ��ǩ
	ʹ��ajax������ݿ�,���ص������ʽΪԼ����ʽ(�зָ���Ϊ'@,',�зָ���Ϊ'@|')

	@param sqlStatement : sql���
	@param select: HTML select��ǩ��nameӦ��
	@param defaultName : HTML select��ǩĬ��ѡ��OPTION
*/
function drawDynamicHtmlSelect(sqlStatement,select,defaultName)
{
	var xmlrequest = createRequest();
	
	var url = hbbasscommonpath+'/db2array.jsp';
	select.disabled = true;
	
	xmlrequest.onreadystatechange=function()
	{
		if(xmlrequest.readyState == 4)
		{
			if(xmlrequest.status == 200)
			{
				var data = xmlrequest.responseText.trim();
				
				//��
				drawStaticHtmlSelect(data,select,defaultName);
			}
		}
	}
	xmlrequest.open("POST",url,true);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send("sql="+encodeURIComponent(sqlStatement));
}

/**
ͬ������
*/
function drawSyncDynamicHtmlSelect(sqlStatement,select,defaultName)
{
	var xmlrequest = createRequest();
	
	var url = hbbasscommonpath+'/db2array.jsp';
	select.disabled = true;
	
	xmlrequest.open("POST",url,false);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send("sql="+encodeURIComponent(sqlStatement));
	if(xmlrequest.readyState == 4)
	{
		if(xmlrequest.status == 200)
		{
			var data = xmlrequest.responseText.trim();
			
			//��
			drawStaticHtmlSelect(data,select,defaultName);
		}
	}
}

/**
	��HTML Select ��ǩ
	����̬�ı�ǩ,�����ʽΪԼ����ʽ(�зָ���Ϊ'@,',�зָ���Ϊ'@|')

	@param data : ��̬�����
	@param select: HTML select��ǩ��nameӦ��
	@param defaultName : HTML select��ǩĬ��ѡ��OPTION
*/
function drawStaticHtmlSelect(data,select,defaultName)
{
		lines = data.split("@|");//�ָ���
		
		isHoldFirstOption = false;
		
		//���û��defaultName�ʹ�?ɾ���һ��option
		if(defaultName == undefined || defaultName == '')
			isHoldFirstOption = true;
		
		if(isHoldFirstOption)//��ɾ���һ��
		{
			select.length=1;
			select.disabled = false;
			for (i =0;i < lines.length; i++)
			{
				line = lines[i].split("@,");//��Ϊ��
				op = new Option(line[1],line[0]);
				
				select[i+1] = op;
			}
		}
		else
		{
			select.length=0;
			select.disabled = false;
			
			for (i =0;i < lines.length; i++)
			{
				line = lines[i].split("@,");
				op = new Option(line[1],line[0]);
				
				select[i] = op;
				
				if(select[i].value==defaultName)
					select[i].selected = true;
			}
		}
}

/**
	������ͨ�÷���
	@param selects: ���вμ�������HTMLSelect��ǩ����������,˳�����
	@param sqls: ���вμ�������sql�ַ�����,˳�����(sql����е�valueͨ���ַ�'${value}'����)
	@param i: �����ļ���,˳���1��ʼ
*/
function combolink(selects,sqls,i)
{
	if(i > sqls.length)
		return;
	
	var value = selects[i-1].value;
	
	if(value==""||value=="0")
  {
  	// ���ݵ�ֵΪ��һ�ȫʡ����ȫ���� �¼�����ѡ�������ֱ����Ϊ��һ�ȫ���� �������ύ��ݿ��ѯ
  	selects[i].length=1;
		selects[i].disabled = false;
  }
  else
  {
  	//alert(sqls[i]);
		drawDynamicHtmlSelect(sqls[i-1].replace("${value}",value),selects[i]);
	}
	
	if(i < sqls.length)
	{
		combolink(selects,sqls,i+1);
	}
}
function areacombo(i)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		sqls.push("select dm_county_id,cityname from FPF_user_city where dm_city_id='${value}' and dm_county_id!=-1");
	}
	
	if(document.forms[0].office!= undefined)
	{
		selects.push(document.forms[0].office);
		sqls.push("select channel_id,channel_name from nmk.RES_SITE_DS where county_id = '${value}' with ur");
	}
	
	if(document.forms[0].custmanager!= undefined)
	{
		selects.push(document.forms[0].custmanager);
		sqls.push("select staff_id,staff_name from nmk.staff_site where site_id like '${value}%'");
	}
	
	//������������
	combolink(selects,sqls,i);
}

function channelcombo(i)
{
	selects = new Array();
	selects.push(document.forms[0].channelkind);
	sqls = new Array();
	
	if(document.forms[0].channeltype != undefined)
	{
		selects.push(document.forms[0].channeltype);
		sqls.push("select key,value from channel_type where parent='${value}'");
	}
	//������������
	combolink(selects,sqls,i);
}

function terminalcombo(i)
{
	selects = new Array();
	selects.push(document.forms[0].terminalbrand);
	sqls = new Array();
	
	if(document.forms[0].terminaltype != undefined)
	{
		selects.push(document.forms[0].terminaltype);
		sqls.push("select device_name,device_name from nwh.imei_terminal_info where handset_brand='${value}'");
	}
	//������������
	combolink(selects,sqls,i);
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
	var ary = foo.split(".");
	post="";
	if(ary.length==2)
  {
  	post = ary[1];
  	if(ary[1].length>digit)
  	{
	  	nextnum = parseInt(ary[1].substring(digit,digit+1),10);
	  	
	  	curnum = parseInt(ary[1].substring(0,digit),10);
	  	
	  	if(nextnum>=5)curnum = curnum+1;
	  	
	  	post = curnum + "";
  	
	  	if(post.length> digit)
	  	{
	  		post=post.substring(1,digit+1);
	  		per = parseInt(ary[0],10)+1;
	  		ary[0]=per+"";
	  	}
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
	return result;
}

function numberFormatDigit2(foo){return numberFormat(foo,2);}

function percentFormat(foo)
{
	digit=2;
	var ary = ((parseFloat(foo)*100)+"") .split(".");
	post="";
  if(ary.length==2)
  {
  	post = ary[1];
  	if(ary[1].length>digit)
  	{
	  	nextnum = parseInt(ary[1].substring(digit,digit+1),10);
	  	
	  	curnum = parseInt(ary[1].substring(0,digit),10);
	  	
	  	if(nextnum>=5)curnum = curnum+1;
	  	
	  	post = curnum + "";
	  	
	  	if(post.length> digit)
	  	{
	  		post=post.substring(1,digit+1);
	  		per = parseInt(ary[0],10)+1;
	  		ary[0]=per+"";
	  	}
	  }
  }
  result = ary[0];
  if(post.length>0)result += "."+ post;

	return result +"%" ;
}

function intnubmercheck(el){if(!isNumber(el.value)){alert("����д��ȷ������");el.value=100;}el.value=parseInt(el.value,10);}

function hideTitle(el,objId)
{
	var obj = document.getElementById(objId);
	if(el.flag ==0)
	{
		el.src="/hb-bass-navigation/hbbass/common2/image/ns-expand.gif";
		el.flag = 1;
		el.title="�������";
		obj.style.display = "";
	}
	else
	{
		el.src="/hb-bass-navigation/hbbass/common2/image/ns-collapse.gif";
		el.flag = 0;
		el.title="�����ʾ";
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

function mappingArea(foo)
{
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
		for(j=0;j<resultTableDown.rows[0].cells.length;j++)
		{
			str+=(resultTableDown.rows[i].cells[j].innerText)+","; 
    }
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
	for(j=0;j<resultTableDown.rows[0].cells.length;j++)
	{
		str+=(resultTableDown.rows[0].cells[j].innerText)+",";
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
 	else if(elpagenum>0&&elpagenum<20000)
	{
 		document.forms[0].action = "/hb-bass-navigation/hbbass/common2/commonDown.jsp";
		document.forms[0].target = "_top";
		document.forms[0].submit();
	}
	else
	{
	  document.forms[0].action = "/hb-bass-navigation/hbbass/common2/commonDivisionDown.jsp";
		document.forms[0].target = "_blank";
		document.forms[0].submit();	
	}
}


/************************************************************  ͼ��չ����    ************************************************************/
function channelRenderChart(spelltype,columns,tables,condition,group,postfix,chartcolumn)
{
	if(chartName=="")
	{
		var count = columns.split(",").length;
		if(chartcolumn!=undefined && chartcolumn!="null" && chartcolumn!="")count=parseInt(chartcolumn,10);
		var spans = document.getElementById("title_div").getElementsByTagName("span");
		chartName=spans[spans.length-count].childNodes[0].childNodes[0].nodeValue;
		for(z=spans.length-count+1; z < spans.length; z++)
			chartName+=","+spans[z].childNodes[0].childNodes[0].nodeValue;
	}
	
	arr = channelBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
	
	var nl = document.getElementsByName("inputchart");
	bl=true;
	for(var i=0;i<nl.length;i++)
	if(nl[i].checked){ bl=false;break;}
	
	if(bl){alert("û��ѡ��ά��");if(document.getElementById('chartselect_div').style.display=="none")showArea('chartselect_div');return;}
	
	tag = nl[i].tag;
	column = nl[i].column;
	//���⴦�����
	if(tag=="city")
	{
		if(document.forms[0].county!=undefined&&document.forms[0].city.value!="0")
		{
			tag="county"; 
			column = "county_id";
		}
	}
	//���⴦������
	else if(tag=="channelkind")
	{
		if(document.forms[0].channeltype!=undefined&&document.forms[0].channelkind.value!="")
		{
			tag="channeltype"; 
			column = "channel_type";
		}
	}
	//���⴦���ն�
	
	renderChart("tagname="+encodeURIComponent(tag)+"&sql="+encodeURIComponent(arr[2].replace(/#{value}/gi,column))+"&name="+encodeURIComponent(chartName));
}

function renderChart(sParam)
{
	var ajax = new AIHBAjax.Request({
		url:"/hb-bass-navigation/hbbass/common2/chartxml.jsp",
		param:sParam,
		loadmask:true,
		callback:function(foo)
		{
			var data = foo.responseText;
			if(data=="")alert("û�����");
			else
			{
				chartxmls = data.split("@,");
				
				var chartrender = document.getElementById("chartrender");
				if(chartrender.childNodes.length==0)
				{
					chartrender.innerHTML = "<div><span id='chartrender0'></span><br/><span seq=0><input type='button' value='��ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Pie3D.swf',this.parentNode.seq);\" class='form_button' />&nbsp;<input type='button' value='��״ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Column3D.swf',this.parentNode.seq);\" class='form_button' /></span></div><br/>" 
					for(k=1;k<chartxmls.length;k++)
						chartrender.innerHTML += "<div style=\"border-top:1px double #DDDDDD;\"></div><div><span id='chartrender"+k+"'></span><br><span seq="+k+"><input type='button' value='��ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Pie3D.swf',this.parentNode.seq);\" class='form_button' />&nbsp;<input type='button' value='��״ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Column3D.swf',this.parentNode.seq);\" class='form_button' /></span></div><br/>";
				}
				
				for(j=0;j<chartxmls.length;j++)chart("/hb-bass-navigation/hbbass/common2/Charts/FCF_Column3D.swf",j);
				if(chartrender.style.display=="none")hideTitle(document.getElementById('chart_div_img'),'chart_div');
			}
		}
	});
}

function chart(chartSWF,id)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "880", "250");
 	chart.setDataXML(chartxmls[id]);
 	chart.addParam("wmode","transparent");
 	chart.render("chartrender"+id);
}


/************************************************************  �ύ��    ************************************************************/
// ҳ�津�������÷������˳��� 
function ajaxSubmit(sqlStatement,countSql)
{
	var ajax = new AIHBAjax.Request({
		url:hbbasscommonpath+"/db2xml.jsp",
		param:"sql="+encodeURIComponent(sqlStatement),
		loadmask:true,
		callback:function(xmlHttp)
		{
			//����xml
			parseXMLDOM(xmlHttp.responseText);//��xmlDoc��ʼ��
			//�����ļ�¼��
			maxNum = xmlDoc.getElementsByTagName("result").length;
			//ҳ��
			pagesNumber=Math.ceil(maxNum/pagenum)-1; 
			// ����һҳ��ȡ�ñ�ͷ��ͬʱ�滻������ı�ǩ�����ڸ���
			
			//��ʾ�����ʾ��Ϣ
			if(countSql!=undefined && maxNum==fetchRows)
				ajaxGetArray(countSql,showCount);
		 	else 
		 	{
		 		var elsum = document.getElementById("showsum");
		 		if(elsum!=null)elsum.style.display="none";
		 		var elpagenum = document.getElementById("allPageNum");
		 		if(elpagenum!=null)elpagenum.value=maxNum;
		 	}
			page=0;// ���� renderGrid() ���뽫page�ó�0 ���򣬵�һ�β�ѯ������ҳ�󣬺����ѯ��ʾҳ�潫����
		  renderGrid();
		  // ���ر�ͷ��Ϣ
		  //document.getElementById("title_div").style.display="none";
		}
	});
}

function bassAjaxSubmit(sqlStatement,countSql)
{
	var ajax = new AIHBAjax.Request({
		url:hbbasscommonpath+"/db2xml.jsp",
		param:"sql="+encodeURIComponent(sqlStatement),
		loadmask:true,
		callback:function(xmlHttp)
		{
			//����xml
			parseXMLDOM(xmlHttp.responseText);//��xmlDoc��ʼ��
			//�����ļ�¼��
			maxNum = xmlDoc.getElementsByTagName("result").length;
			//if(maxNum<0)maxNum=0;
			//��ʾ�����ʾ��Ϣ
			if(countSql!=undefined && maxNum>=fetchRows)ajaxGetArray(countSql,showCount);
		 	else 
		 	{
		 		var elsum = document.getElementById("showsum");
		 		if(elsum!=null)elsum.style.display="none";
		 		var elpagenum = document.getElementById("allPageNum");
		 		if(elpagenum!=null)elpagenum.value=maxNum;
		 	} 
			page=0;// ���� getContent() ���뽫page�ó�0 ���򣬵�һ�β�ѯ������ҳ�󣬺����ѯ��ʾҳ�潫����
			rendertable = renderBassTbody;
		  renderGrid();
		}
	});
}


/************************************************************  չ�ֱ����    ************************************************************/
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
function getHeader()
{
	return document.getElementById("title_div").innerHTML;
}

function renderGrid()
{
	var header=getHeader();
	header=header.replace('resultTable','resultTableDown');
	header=header.replace('</TABLE>','');
	header=header.replace('<TBODY>','<THEAD id="resultHead">');
	header=header.replace('</TBODY>','</THEAD>');
 	
  var results = xmlDoc.getElementsByTagName("result");
  
  //var tableColNum = document.getElementById('resultTable').childNodes[0].childNodes[0].childNodes.length;
  
  //if(colNum > tableColNum) colNum = tableColNum;
  
  document.getElementById("showResult").innerHTML= rendertable(header,results);
}

function renderTbody(BodyText,results)
{
	var colNum=0;
  
  if(results.length >0) colNum = results[0].childNodes.length;
	
	var endNum=(page+1)*pagenum;
  
  if (endNum>maxNum) endNum=maxNum;
	
	// �趨����ı�񲿷�
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for (n=(page*pagenum); n<endNum ; n++)
  {
  	if(n%2==0)
      BodyText=BodyText+"<TR class='grid_row_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">";
    else
  		BodyText=BodyText+"<TR class='grid_row_alt_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">";
  	
    for(m=0;m<=colNum-1;m++)
    {   	
    	if(celldisplay.length==0 || celldisplay[m]==undefined)
    	{
    		if(results[n].childNodes[m].childNodes.length==0)BodyText+="<TD></TD>";//�յ�Ԫ��
	    	else
	    	{
		    	//���õ�Ԫ�����ʽ
		    	if(cellclass.length==0 || cellclass[m]==undefined)
		    		BodyText+="<TD class='grid_row_cell'>";
		    	else
		    		BodyText+="<TD class='"+cellclass[m]+"'>";
		    	//��Ԫ��ֵ�ĸ�ʽ
		    	if(cellfunc.length==0 || cellfunc[m]==undefined)	
		    		BodyText+=results[n].childNodes[m].childNodes[0].nodeValue;
		    	else
		    		BodyText+=cellfunc[m](results[n].childNodes[m].childNodes[0].nodeValue);
		    	BodyText+="</TD>";
	    	}
    	}
    	else
    	{
    		BodyText+="<TD style='display:none'></TD>";
    	}
    }
    
    BodyText=BodyText+"</TR>";
  }
  
  BodyText = BodyText+"</TBODY></table><textarea name='downcontent' cols='122' rows='12' style='display:none'></textarea>"+footbar();
  
  return BodyText;
}

function renderBassTbody(BodyText,results)
{
	var colNum=0;
  if(results.length >0) colNum = results[0].childNodes.length;
	
	BodyText=BodyText+"<TBODY id='resultTbody'>";
	rowcount = 0;
	cityname="";
  for (n=0;n<=maxNum-1;n++)
  {
  	//alert((n)+ "  "+ rowcount )
  	if(results[n].childNodes[0].childNodes.length!=0)
  	{
  		cityname=results[n].childNodes[0].childNodes[0].nodeValue;
  	
	  	if(!areagroup.containsKey(cityname))areagroup.put(cityname,"false");
	  	
	  	//if(page==1) alert(n+"n "+results[n+1].childNodes[0].childNodes[0].nodeValue +"  "+cityname+"  "+results[n].childNodes[0].childNodes[0].nodeValue)
	  	
	  	if(n==0 || results[n-1].childNodes[0].childNodes[0].nodeValue!=cityname)
	  	{
	  		//groupingText = "<tbody id='group_"+cityname+"' style=\"display:none;\">" + groupingText + "</tbody>";
	  		rowcount++;
	  		//alert(n+ "   zhen + 1");
	  		if(rowcount <= (page+1)*pagenum && rowcount > page*pagenum)
	  		{
	  			//alert(rowcount + "  "+ page*pagenum)
		  		BodyText=BodyText+"<TR class='grid_row_alt_blue' onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">";
		  		if(celldisplay.length==0 || celldisplay[0]==undefined)
		  		{
		  			img = "/hb-bass-navigation/hbbass/common2/image/row-collapse.gif";
		  			if(areagroup.get(cityname)=="true")img = "/hb-bass-navigation/hbbass/common2/image/row-expand.gif";
		  			BodyText += "<TD class='grid_row_cell1'><img src='"+img+"' onclick='areaExpand(\""+cityname+"\");'></img>&nbsp;&nbsp;" + mappingArea(cityname) + "</TD>";
		  		}
		  		else BodyText+="<TD style='display:none'></TD>";
		  		for(m=1;m<=colNum-1;m++)
			    {
			    	if(celldisplay.length==0 || celldisplay[m]==undefined)
			    	{
			    		if(results[n].childNodes[m].childNodes.length==0)BodyText+="<TD></TD>";//�յ�Ԫ��
				    	else
				    	{
					    	//���õ�Ԫ�����ʽ
					    	if(cellclass.length==0 || cellclass[m]==undefined)
					    		BodyText+="<TD class='grid_row_cell'>";
					    	else
					    		BodyText+="<TD class='"+cellclass[m]+"'>";
					    	//��Ԫ��ֵ�ĸ�ʽ
					    	if(cellfunc.length==0 || cellfunc[m]==undefined)	
					    		BodyText+=results[n].childNodes[m].childNodes[0].nodeValue;
					    	else
					    		BodyText+=cellfunc[m](results[n].childNodes[m].childNodes[0].nodeValue);
					    	BodyText+="</TD>";
				    	}
			    	}
			    	else
			    	{
			    		BodyText+="<TD style='display:none'></TD>";
			    	}
			    }
		  		BodyText=BodyText+"</TR>";
		  	}
	  	}
	  	else //if(n+1 < maxNum-1 && results[n+1].childNodes[0].childNodes[0].nodeValue==cityname)
	  	{
	  		//alert(cityname + "   " + areagroup.get(cityname) + "  " + (areagroup.get(cityname)=="true"))
	  		if(areagroup.get(cityname)=="true")
	  		{
	  			rowcount++;
	  			//alert(n+"  "+rowcount);
	  			//alert(n+ "   jia + 1");
	  			if( rowcount > page*pagenum && rowcount <= (page+1)*pagenum)
	  			{
			  		BodyText+="<TR class='grid_row_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">";
			  		
			  		for(m=0;m<=colNum-1;m++)
				    { 	
				    	if(celldisplay.length==0 || celldisplay[m]==undefined)
				    	{
				    		if(results[n].childNodes[m].childNodes.length==0)BodyText+="<TD></TD>";//�յ�Ԫ��
					    	else
					    	{
						    	//���õ�Ԫ�����ʽ
						    	if(cellclass.length==0 || cellclass[m]==undefined)
						    		BodyText+="<TD class='grid_row_cell'>";
						    	else
						    		BodyText+="<TD class='"+cellclass[m]+"'>";
						    	//��Ԫ��ֵ�ĸ�ʽ
						    	if(cellfunc.length==0 || cellfunc[m]==undefined)	
						    		BodyText+=results[n].childNodes[m].childNodes[0].nodeValue;
						    	else
						    		BodyText+=cellfunc[m](results[n].childNodes[m].childNodes[0].nodeValue);
						    	BodyText+="</TD>";
					    	}
				    	}
				    	else
				    	{
				    		BodyText+="<TD style='display:none'></TD>";
				    	}
				    }
			  		BodyText+="</TR>";
		  		}
		  	}
	  	}
  	}
  }
 	pagesNumber=Math.ceil(rowcount/pagenum)-1; 
 	
  BodyText = BodyText+"</TBODY></table><textarea name='downcontent' cols='122' rows='12' style='display:none'></textarea>"+footbar();
 	//alert(BodyText)
  return BodyText;
}

function areaExpand(cityname)
{
	if(areagroup.get(cityname)=="true")areagroup.set(cityname,"false");
	else areagroup.set(cityname,"true");
	renderGrid();
}

/************************************************************  ����ƴдSQL��    ************************************************************/
function channelBaseQuery(spelltype,funcSubmit,columns,tables,condition,group,postfix)
{
	arr = channelBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else funcSubmit(arr[0],arr[1]);
}

function channelExtemporeQuery(columns,tables,condition,group,postfix)
{
	arr = channelSpellExtemporeSQL(columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else ajaxSubmit(arr[0],arr[1]);
}

function channelSpellExtemporeSQL(columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} #{order} #{postfix} with ur";

	//���⴦�����
	if(document.forms[0].county!=undefined&&document.forms[0].county.value!="")
	{
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		channelplaceholder=document.forms[0].county.parentNode.name;
	}
	else if(document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		channelplaceholder=document.forms[0].city.parentNode.name;
	}
	else if(document.forms[0].city.value!=undefined)
	{
		channelplaceholder=document.forms[0].city.parentNode.name;
	}
	else if(document.forms[0].province!=undefined)
	{
		columns = "'"+ document.forms[0].province[0].text +"',"+columns;
	}
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	for(var i=0; i < attribute.length; i++)
	{
		if(attribute[i].childNodes[0].value != undefined
			&& attribute[i].childNodes[0].value != "" 
				&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)
			{
				if(attribute[i].type=="int")			condition += " and " + attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else if(attribute[i].type=="in")	condition += " and " + attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
				else 															condition += " and " + attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
			else
			{
				if(attribute[i].type=="int")		condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else if(attribute[i].type=="in")condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
				else 														condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
		}
		if(attribute[i].grouping!=undefined)
		{
			if(attribute[i].name=="op_time")channelplaceholder = "'"+attribute[i].childNodes[0].value+"',"+channelplaceholder;
			else channelplaceholder += ","+attribute[i].name;
		}
	}
	columns = channelplaceholder + "," +columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","").replace("#{order}","");//���ͳ������SQL
	
	sql = sql.replace("#{columns}",columns).replace("#{order}","");
	
	document.getElementById("sql").value=sql.replace("#{postfix}","");//���������SQL
	sql = sql.replace("#{postfix}",postfix);
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  return arr;
}


function channelBaseSpellSQL(spelltype,columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} group by #{group} #{order} #{postfix} with ur";
	
	var chartsql = "select #{value},#{columns} from #{tables} where #{condition} group by #{value} order by 1 with ur".replace("#{columns}",columns);
	
	columnPlaceholder="";
	//areaOffset = 0;
	if(group.length>0)group=group+",";
	
	//���⴦�����
	if(document.forms[0].county!=undefined && document.forms[0].county.value!="")
	{
		group += document.forms[0].county.parentNode.name;
		columnPlaceholder += document.forms[0].county.parentNode.name;
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		//cellfunc[0]=function(foo){return mapping(foo,"county");};
	}
	else if(document.forms[0].city!=undefined && document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(document.forms[0].county!=undefined)a= document.forms[0].county.parentNode.name;
		else a = document.forms[0].city.parentNode.name;
		
		group += a;
		columnPlaceholder += a;
		condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		//cellfunc[0]=function(foo){return mapping(foo,"county");};
	}
	else if(document.forms[0].city!=undefined && document.forms[0].city.value!=undefined)
	{
		group += document.forms[0].city.parentNode.name;
		columnPlaceholder += document.forms[0].city.parentNode.name;
		//cellfunc[0]=function(foo){return mapping(foo,"city");};
	}
	else if(document.forms[0].province!=undefined)
	{
		columnPlaceholder += "'"+ document.forms[0].province[0].text +"'";
		//columns = "'"+ document.forms[0].province[0].text +"',"+columns;
	}
	
	//���⴦����������
	collist = document.getElementById("resultTable").getElementsByTagName("span");
	var channelName = false;
	for(k=0;k < collist.length; k++)if(collist[k].childNodes[0].childNodes[0].nodeValue=="�������"){channelName=true;break;}
	
	//3��ṹ
	var seq=0;//��¼�������͵Ľṹ
	if(channelName && document.forms[0].channeltype!=undefined && document.forms[0].channelkind!=undefined)
	{
		seq=3;
		var channel3 = document.forms[0].channeltype;
		if(channel3.value!="")
		{
			if(condition.length>0)condition = condition + " and " +"a.channel_id="+tables.split(",")[0]+".channel_id";
			else condition="a.channel_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id,channel_name from nmk.RES_SITE_DS) a,"+tables;
			group += ",a.channel_name";
			columnPlaceholder += ",'"+mapping(document.forms[0].channelkind.value,"channelkind") + "','"+ mapping(channel3.value,"channeltype")+"',case when grouping(a.channel_name)=1 then '�ϼ�' else value(a.channel_name,'δ֪') end";
			selectColumns(2+areaOffset,true);
			selectColumns(3+areaOffset,true);
		}
		else if(document.forms[0].channelkind.value!="")
		{
			if(spelltype=="normal")
			{
				group += ","+ channel3.parentNode.name;
				columnPlaceholder += ",'"+mapping(document.forms[0].channelkind.value,"channelkind") + "',case when grouping("+ channel3.parentNode.name + ")=1 then '�ϼ�' else value("+ channel3.parentNode.name + ",'δ֪') end,'--'";
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder +=",'"+mapping(document.forms[0].channelkind.value,"channelkind")+"','ȫ��','--'";
			}
			selectColumns(2+areaOffset,true);
			selectColumns(3+areaOffset,false);
			cellfunc[2+areaOffset]=function(foo){return mapping(foo,"channeltype");};
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ","+ document.forms[0].channelkind.parentNode.name;
				columnPlaceholder += ",case when grouping("+ document.forms[0].channelkind.parentNode.name + ")=1 then '�ϼ�' else value("+ document.forms[0].channelkind.parentNode.name +  ",'δ֪') end,'--','--'";
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder +=",'ȫ��','--','--'";
			}
			//columns = "'--','--',"+columns;
			selectColumns(2+areaOffset,false);
			selectColumns(3+areaOffset,false);
			cellfunc[1+areaOffset]=function(foo){return mapping(foo,"channelkind");};
		}
	}
	//2��ṹ
	else if( channelName && (document.forms[0].channeltype!=undefined || document.forms[0].officetype!=undefined || document.forms[0].sochannel!=undefined || document.forms[0].echannel!=undefined ))
	{
		seq=2;
		channelTagName = "channeltype";
		var channel2 = document.forms[0].channeltype;
		if(document.forms[0].officetype!=undefined){channel2 = document.forms[0].officetype;channelTagName="officetype";}
		else if(document.forms[0].sochannel!=undefined){channel2 = document.forms[0].sochannel;channelTagName="sochannel";}
		else if(document.forms[0].echannel!=undefined){channel2 = document.forms[0].echannel;channelTagName="echannel";}
		
		if(channel2.value!="")
		{
			if(condition.length>0)condition = condition + " and " +"a.channel_id="+tables.split(",")[0]+".channel_id";
			else condition="a.channel_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id,channel_name from nwh.RES_SITE_DS) a,"+tables;
			group += "," + "a.channel_name";
			columnPlaceholder += ",'" + mapping(channel2.value,channelTagName) + "',case when grouping(a.channel_name)=1 then '�ϼ�' else value(a.channel_name,'δ֪') end";
			selectColumns(2+areaOffset,true);
		}
		else if(channel2.value=="")
		{
			if(spelltype=="normal")
			{
				group += ","+channel2.parentNode.name;
				columnPlaceholder += ",case when grouping("+channel2.parentNode.name + ")=1 then '�ϼ�' else value("+channel2.parentNode.name + ",'δ֪') end,'--'";
				cellfunc[1+areaOffset]=function(foo){return mapping(foo,channelTagName);};	
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��','--'";
			}
			//columns = "'--',"+columns;
			selectColumns(2+areaOffset,false);
		}
	}
	else if ((!channelName) && document.forms[0].channeltype!=undefined && document.forms[0].channelkind!=undefined)
	{
		seq=2;
		var channel3 = document.forms[0].channeltype;
		if(channel3.value!="")
		{
			columnPlaceholder += ",'"+mapping(document.forms[0].channelkind.value,"channelkind") + "','"+ mapping(channel3.value,"channeltype")+"'";
			selectColumns(2+areaOffset,true);
		}
		else if(document.forms[0].channelkind.value!="")
		{
			if(spelltype=="normal")
			{
				group += ","+ channel3.parentNode.name;
				columnPlaceholder += ",'"+mapping(document.forms[0].channelkind.value,"channelkind") + "',case when grouping("+ channel3.parentNode.name+ ")=1 then '�ϼ�' else value("+channel3.parentNode.name + ",'δ֪') end";;
				cellfunc[2+areaOffset]=function(foo){return mapping(foo,"channeltype");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder +=",'"+mapping(document.forms[0].channelkind.value,"channelkind")+"','ȫ��'";
			}
			selectColumns(2+areaOffset,true);
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ","+ document.forms[0].channelkind.parentNode.name;
				columnPlaceholder += ",case when grouping("+document.forms[0].channelkind.parentNode.name + ")=1 then '�ϼ�' else value("+document.forms[0].channelkind.parentNode.name + ",'δ֪') end,'--'";
				cellfunc[1+areaOffset]=function(foo){return mapping(foo,"channelkind");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder +=",'ȫ��','--'";
			}
			//columns = "'--','--',"+columns;
			selectColumns(2+areaOffset,false);
		}
	}
	//1��ṹ
	else if(document.forms[0].channelkind!=undefined)
	{
		seq=1;
		if(document.forms[0].channelkind.value!="")
		{
			columnPlaceholder += ",'"+mapping(document.forms[0].channelkind.value,"channelkind")+"'";
			//columns = "'"+document.forms[0].channelkind.value+"',"+columns;
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ",case when grouping("+document.forms[0].channelkind.parentNode.name + ")=1 then '�ϼ�' else value("+document.forms[0].channelkind.parentNode.name + ",'δ֪') end";
				columnPlaceholder += ","+ document.forms[0].channelkind.parentNode.name;
				cellfunc[1+areaOffset]=function(foo){return mapping(foo,"channelkind");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��'";
			}
		}
	}
	else if(document.forms[0].channeltype!=undefined || document.forms[0].officetype!=undefined || document.forms[0].sochannel!=undefined || document.forms[0].echannel!=undefined)
	{
		seq=1;
		channelTagName = "channeltype";
		var channel1 = document.forms[0].channeltype;
		if(document.forms[0].officetype!=undefined){channel1 = document.forms[0].officetype;channelTagName="officetype";}
		else if(document.forms[0].sochannel!=undefined){channel1 = document.forms[0].sochannel;channelTagName="sochannel";}
		else if(document.forms[0].echannel!=undefined){channel1 = document.forms[0].echannel;channelTagName="echannel";}
		if(channel1.value!="")
		{
			//columns = "'"+document.forms[0].channeltype.value+"',"+columns;
			columnPlaceholder += ",'"+mapping(channel1.value,channelTagName)+"'";
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ","+ channel1.parentNode.name;
				columnPlaceholder += ",case when grouping("+channel1.parentNode.name + ")=1 then '�ϼ�' else value("+channel1.parentNode.name + ",'δ֪') end";
				cellfunc[1+areaOffset]=function(foo){return mapping(foo,channelTagName);};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��'";
			}
		}
	}
	
	//���⴦���ն�
	if(document.forms[0].terminaltype!=undefined)
	{
		var term = document.forms[0].terminaltype;
		if(term.value!="")
		{
			//columns = "'"+ document.forms[0].terminalbrand.value +"','"+ term.value +"',"+columns;
			columnPlaceholder +=",'"+ mapping(document.forms[0].terminalbrand.value,"terminalbrand") +"','"+ term.value +"'";
			selectColumns(2+seq+areaOffset,true);
			//cellfunc[seq+2]=function(foo){return mapping(foo,"terminaltype");};
		}
		else if (document.forms[0].terminalbrand.value!="")
		{
			if(spelltype=="normal")
			{
				group += "," + term.parentNode.name;
				columnPlaceholder += ",'" + mapping(document.forms[0].terminalbrand.value,"terminalbrand") + "'," + term.parentNode.name;
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'"+ mapping(document.forms[0].terminalbrand.value,"terminalbrand") +"','ȫ��'";
			}
			selectColumns(2+seq+areaOffset,true);
		}
		else
		{
			if(spelltype=="normal")
			{
				group += "," + document.forms[0].terminalbrand.parentNode.name;
				columnPlaceholder += "," + document.forms[0].terminalbrand.parentNode.name + ",'--'";
				cellfunc[1+seq+areaOffset]=function(foo){return mapping(foo,"terminalbrand");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��','--'";
			}
			//columns = "'--',"+columns;
			selectColumns(2+seq+areaOffset,false);
		}
	}
	/*else if(document.forms[0].terminalbrand!=undefined)
	{
		var term = document.forms[0].terminalbrand;
		if(term.value!="") 
		{
			//columns = "'"+ term.value + "',"+columns;
			columnPlaceholder += ",'"+ term.value + "'";
		}
		else
		{
			if(spelltype=="normal")
			{
				group += "," + document.forms[0].terminalbrand.parentNode.name;
				columnPlaceholder += "," + document.forms[0].terminalbrand.parentNode.name;
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��'";
			}
		}
		cellfunc[1+seq+areaOffset]=function(foo){return mapping(foo,"terminalbrand");};
	}*/
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	
	var optimeValue="";
	
	for(var i=0; i < attribute.length; i++)
	{
		//alert(attribute[i].childNodes[0].name +"  "+ "exclusive"+"  "+ (attribute[i].childNodes[0].name=="exclusive"))
		if(attribute[i].childNodes[0].value!=undefined
			&&attribute[i].childNodes[0].value != "" 
				&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)
			{
				if(attribute[i].type=="int")			condition += " and " + attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else if(attribute[i].type=="in")	condition += " and " + attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
				else 															condition += " and " + attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
			else
			{
				if(attribute[i].type=="int")			condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else if(attribute[i].type=="in")	condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
				else 															condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
		}
		if(attribute[i].name=="op_time")optimeValue=attribute[i].childNodes[0].value;
		//�Ƿ�μӷ���
		if(attribute[i].grouping!=undefined)
		{	
			var tagName = attribute[i].childNodes[0].name;
			if(attribute[i].childNodes[0].value != "" )
			{
				//columns = "'"+ attribute[i].childNodes[0].value+"',"+columns;
				columnPlaceholder += ",'"+ mapping(attribute[i].childNodes[0].value,tagName)+"'";
			}
			else
			{
				if(spelltype=="normal")
				{
					if(group.length>0)group += ","+attribute[i].name;
					else group = attribute[i].name;
					columnPlaceholder += ","+attribute[i].name;
					cellfunc[attribute[i].grouping]=function(foo){return mapping(foo,tagName);};
				}
				else if (spelltype=="sort")
				{
					columnPlaceholder += ",'ȫ��'";
				}
			}
		}
	}
	if(group.indexOf(",")==0)group=group.substring(1);
	if(columnPlaceholder.length>0)columns = columnPlaceholder + "," + columns;
	
	if(spelltype=="normal"){}
	else if (spelltype=="sort")columns = "rownumber() over(),'"+optimeValue+"'," + columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	chartsql = chartsql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	if(condition.length > 0)chartsql = chartsql.replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","").replace("#{order}","");//���ͳ������SQL
	
	sql = sql.replace("#{columns}",columns);
	
	document.getElementById("sql").value=sql.replace("#{postfix}","").replace("#{group}",group).replace("#{order}","");//���������SQL
	
	var fis = group.indexOf(",");
	if(spelltype=="normal")
	{
		var rollup = group;
		var orderby = group;
		if(fis>0)
		{
			rollup = group.substring(0,fis)+",rollup("+group.substring(fis+1,group.length)+")";
			var sec = group.substring(fis+1,group.length).indexOf(",");
			if(sec>0)orderby = group.substring(0,fis+sec+1)+" desc,"+group.substring(fis+sec+2,group.length);
		}
		sql = sql.replace("#{order}","order by "+orderby + " desc , targetorder desc" ).replace("#{group}",rollup).replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
	}
	else if (spelltype=="sort")
	{
		sql = sql.replace("#{order}","order by "+document.forms[0].order.value + " " + document.forms[0].order_desc.value).replace("#{group}",""+group+"").replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
	}
	
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  arr[2] = chartsql;
  arr[3] = bassAjaxSubmit;
  if(spelltype=="sort" || fis < 0 ) arr[3] = ajaxSubmit;
  return arr;
}