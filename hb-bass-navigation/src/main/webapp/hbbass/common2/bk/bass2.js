var hbbasscommonpath = '/hbbass/common2';
//var xmlDoc =createXMLDOM();
var xmlDoc = false;
var pagenum=10; //ÿҳ��ʾ������Ϣ 
var page=0;
var header="";
var maxNum =0;

function createXMLDOM()
{
	var xmlDoc = false;
	
	if (window.ActiveXObject)
    xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
	else if (document.implementation && document.implementation.createDocument)
    xmlDoc= document.implementation.createDocument("","",null);
	else
    alert('����������֧�ִ˽ű�');
	
	xmlDoc.async=false;
	return xmlDoc;
}
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

function fenye(responseXML)
{
	//xmlDoc.load("/hb-bass-navigation/hbbass/commonXml/"+fileName);
	parseXMLDOM(responseXML);//��xmlDoc��ʼ��
	//�����ļ�¼��
	maxNum = xmlDoc.getElementsByTagName("result").length;
	//ҳ��
	pagesNumber=Math.ceil(maxNum/pagenum)-1; 
	
	// ����һҳ��ȡ�ñ�ͷ��ͬʱ�滻������ı�ǩ�����ڸ���
	header=document.getElementById("tabTitle").innerHTML; 
	header=header.replace('resultTable','resultTableDown');
	header=header.replace('</TABLE>','');
	header=header.replace('<TBODY>','<THEAD id="resultHead">');
	header=header.replace('</TBODY>','</THEAD>');
	
}

function getContent()
{
  if (!page) 
  page=0;
  n=page*pagenum;
  endNum=(page+1)*pagenum;
  
  if (endNum>maxNum) endNum=maxNum;
  
  var results = xmlDoc.getElementsByTagName("result");
  
  var colNum=0;
  
  if(results.length >0)
  	colNum = results[0].childNodes.length;
  
  var tableColNum = document.getElementById('resultTable').childNodes[0].childNodes[0].childNodes.length;
  
  if(colNum > tableColNum)
  	colNum = tableColNum;
  var showResult1=document.getElementById("showResult");
  
  var BodyText = header;
 
  // �趨����ı�񲿷�
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for (;n<endNum;n++)
  {
  	if(n%2==0)
      BodyText=BodyText+"<TR class='result_v_1'  onMouseOver=\"this.className='result_v_3'\" onMouseOut=\"this.className='result_v_1'\">";
    else
  		BodyText=BodyText+"<TR class='result_v_2'  onMouseOver=\"this.className='result_v_3'\" onMouseOut=\"this.className='result_v_2'\">";
  		
  		
  	//BodyText+="<TD>"+results[n].getAttribute("id")+"</TD>";
    for(m=0;m<=colNum-1;m++)
    {
    	if(results[n].childNodes[m].childNodes.length==0)BodyText+="<TD></TD>";//�յ�Ԫ��
    	else BodyText+="<TD id='t"+m+"'>"+results[n].childNodes[m].childNodes[0].nodeValue+"</TD>";
    }
    
    BodyText=BodyText+"</TR>";
  }
 	showResult1.innerHTML=BodyText+"</TBODY></table><textarea name='downcontent'  cols='122' rows='12' style='display:none'></textarea>"+pageBar(page);
 	
}

//��ҳ
function FirstPage(page)
{
    thePage="��ҳ";
    if(page>0) thePage="<A HREF='#' onclick='Javascript:return FirstPageGo()'>��ҳ</A>";
    return thePage;
}
//��һ��ҳ��
function UpPage(page)
{
    thePage="ǰһҳ";
    if(page+1>1) thePage="<A HREF='#' onclick='Javascript:return UpPageGo()'>ǰһҳ</A>";
    return thePage;
}
function NextPage(page)
{
    thePage="��һҳ";
    if(page<pagesNumber) thePage="<A HREF='#' onclick='Javascript:return NextPageGo()'>��һҳ</A>";
    return thePage;
}

function LastPage(page)
{
    thePage="βҳ";
    if(page<pagesNumber) thePage="<A HREF='#' onclick='Javascript:return LastPageGo()'>βҳ</A>";
    return thePage;
}

function FirstPageGo()
{ 
	if(page>0) 
		page=0; 
	getContent(); 
} 

function UpPageGo()
{ 
	if(page>0) 
		page--; 
	getContent(); 							
} 

function NextPageGo()
{ 
	if (page<pagesNumber) 
		page++;
	getContent(); 
} 
function LastPageGo()
{ 
	if (page<pagesNumber) 
		page=pagesNumber;
	getContent(); 
} 

function PageInfo()
{
    var ap;
    
    ap='�� <font color=red>'+maxNum+' </font>����¼,&nbsp;ÿҳ <font color=red>'+pagenum+' </font>����¼,��ǰ��ʾ <font color=red>'+(page*pagenum+1)+' </font>�� <font color=red>'+endNum+' </font>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<font color=red> '+(page+1)+' </font>ҳ/�� <font color=red>'+(pagesNumber+1)+' </font>ҳ';
    return ap
}

//��ʾ��ҳ״̬��
function pageBar(page)
{
    var pb;
    pb="<table width='98%' border='0' align='center' cellpadding='0' cellspacing='1'><tr align='center'><td width='50%'>"
    pb+=PageInfo()+"</td><td width='50%'>"+FirstPage(page)+"    "+UpPage(page)+"    "+NextPage(page)+"    "+LastPage(page)+"    "+selectPage(page);
    pb+="</td></tr></table>"
    return pb;
}
function changePage(tpage)
{    
    page=tpage
    if(page>=0) page--; 
    if (page<pagesNumber) page++;
    getContent(); 
}
function selectPage(page)
{
    var sp;
    sp="<select name='toPage' onChange='javascript:changePage(this.options[this.selectedIndex].value)'>";
    for (t=0;t<=pagesNumber;t++)
    {   if(page==t)
    			sp=sp+"<option value='"+t+"' selected>"+(t+1)+"</option>";
    		else
        	sp=sp+"<option value='"+t+"'>"+(t+1)+"</option>";
    }
    sp=sp+"</select>"
    return sp;
}


// ҳ�津�������÷������˳��� 
function ajaxSubmit(sqlStatement)
{
	// ��ʾ��ѯ��ʾ���
	queryload.style.display="block";
	
	xmlHttp = createRequest();
	
	xmlHttp.onreadystatechange=toQueryCallBack; // ���ûص����� 
	xmlHttp.open("POST",hbbasscommonpath+"/db2xml.jsp",true);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.send("sql="+encodeURIComponent(sqlStatement));
}
//�ص�����
function toQueryCallBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			//���ص�XML����fenye
			fenye(xmlHttp.responseText);
			page=0;        // ���� getContent() ���뽫page�ó�0 ���򣬵�һ�β�ѯ������ҳ�󣬺����ѯ��ʾҳ�潫����
		  getContent();
		  // ���ر�ͷ��Ϣ
		  var t=document.getElementById("tabTitle");
		  t.style.display="none";
		  // ���ز�ѯ��ʾ���
		  queryload.style.display="none";
		}
	}
}

//��������
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

/**
	����sql��䷵��2ά����
	@param sqlStatement: sql���
	@param callback: �ص�����,���ҵ���?��list(2ά����)
*/
function ajaxGetArray(sqlStatement,callback)
{
	var xmlrequest = createRequest();
	var url = hbbasscommonpath+'/db2array.jsp';
	xmlrequest.onreadystatechange=function()
	{
		if(xmlrequest.readyState == 4)
		{
			if(xmlrequest.status == 200)
			{
				var data = xmlrequest.responseText.trim();
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
				//alert(list);
				callback(list);
			}
		}
	}
	xmlrequest.open("POST",url,true);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send("sql="+encodeURIComponent(sqlStatement));
}

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };//ΪString�������trim()����
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
		drawSyncDynamicHtmlSelect(sqls[i-1].replace("${value}",value),selects[i]);
	}
	
	if(i < sqls.length)
	{
		combolink(selects,sqls,i+1);
	}
}


function SaveAsExcel2(fname)
{ 
   var str="";
	 for(i=0;i<resultTableDown.rows.length;i++)
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
	var pagenum=document.forms[0].allPageNum.value;
 	if(pagenum==0)
 	{
 		 alert("û�в�ѯ��¼!");
 		 return;
 	}
 	else if(pagenum<=15)
 	{
 	   // bass 2.0 ��д�˴�ҳ��������ݵķ���
 	   SaveAsExcel2('����.csv');
 	}
 	else if(pagenum>15&&pagenum<20000)
	{
	 		document.forms[0].action = "/hb-bass-navigation/hbbass/common2/commonDown.jsp";
			document.forms[0].target = "_top";
			document.forms[0].submit();
	}
	else
	{
		  document.forms[0].action = "/hb-bass-navigation/hbbass/common2/commonDownFile1.jsp";
			document.forms[0].target = "_blank";
			document.forms[0].submit();	
		}
	document.forms[0].submit();
}

function areacombo(i)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		sqls.push("Select dm_county_id,cityname from FPF_user_city where dm_city_id='${value}'");
	}
	
	if(document.forms[0].office!= undefined)
	{
		selects.push(document.forms[0].office);
		sqls.push("select distinct site_id,site_name from nmk.staff_site where site_id  like '${value}%' order by site_id with ur");
	}
	
	if(document.forms[0].custmanager!= undefined)
	{
		selects.push(document.forms[0].custmanager);
		sqls.push("select staff_id,staff_name from nmk.staff_site where site_id like '${value}%'");
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