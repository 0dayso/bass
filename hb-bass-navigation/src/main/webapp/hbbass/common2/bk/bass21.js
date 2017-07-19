var hbbasscommonpath = '/hbbass/common2';
var xmlDoc = false;
var pagenum=30; //ÿҳ��ʾ������Ϣ 
var page=0;
var header="";
var maxNum =0;
var cellclass=new Array();//��Ԫ�����ʽ
var cellfunc=new Array();//��Ԫ��ֵ���?��
var celldisplay=new Array();//�Ƿ���ʾ��Ԫ��
var maxgridwidth = 99;//���Ŀ��

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
	parseXMLDOM(responseXML);//��xmlDoc��ʼ��
	//�����ļ�¼��
	maxNum = xmlDoc.getElementsByTagName("result").length;
	//ҳ��
	pagesNumber=Math.ceil(maxNum/pagenum)-1; 
	// ����һҳ��ȡ�ñ�ͷ��ͬʱ�滻������ı�ǩ�����ڸ���
}

//��ҳ�渲��,�滻��"tabTitle"
function getHeader()
{
	return document.getElementById("tabTitle").innerHTML;
}

function getContent()
{
	header=getHeader();
	header=header.replace('resultTable','resultTableDown');
	header=header.replace('</TABLE>','');
	header=header.replace('<TBODY>','<THEAD id="resultHead">');
	header=header.replace('</TBODY>','</THEAD>');
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
  
  //if(colNum > tableColNum) colNum = tableColNum;
  
  var showResult1=document.getElementById("showResult");
  
  showResult1.innerHTML= tableFormat(header,results,colNum,endNum);
}

function tableFormat(BodyText,results,colNum,endNum)
{
	// �趨����ı�񲿷�
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for (;n<endNum;n++)
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

function footbar()
{
	return pageBar(page);
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
function ajaxSubmit(sqlStatement,countSql)
{
	// ��ʾ��ѯ��ʾ���
	loadmask.style.display="block";
	
	xmlHttp = createRequest();
	
	xmlHttp.onreadystatechange=function(){toQueryCallBack(countSql);}; // ���ûص����� 
	xmlHttp.open("POST",hbbasscommonpath+"/db2xml.jsp",true);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.send("sql="+encodeURIComponent(sqlStatement));

}
		
//�ص�����
function toQueryCallBack(countSql)
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			//���ص�XML����fenye
			fenye(xmlHttp.responseText);
			
			//��ʾ�����ʾ��Ϣ
			if(countSql!=undefined && maxNum==200)
				ajaxGetArray(countSql,showCount);
		 	else 
		 	{
		 		var elsum = document.getElementById("showsum");
		 		if(elsum!=null)elsum.style.display="none";
		 		var elpagenum = document.getElementById("allPageNum");
		 		if(elpagenum!=null)elpagenum.value=maxNum;
		 	}
		  
			page=0;// ���� getContent() ���뽫page�ó�0 ���򣬵�һ�β�ѯ������ҳ�󣬺����ѯ��ʾҳ�潫����
		  getContent();
		 	
		  // ���ر�ͷ��Ϣ
		  var t=document.getElementById("tabTitle");
		  t.style.display="none";
		  // ���ز�ѯ��ʾ���
		  loadmask.style.display="none";
		}
	}
}

function showCount(list)
{
	var showsum=document.getElementById("showsum");
	showsum.style.display="block";
	showsum.innerHTML="<center>��������������<font color=red>" +list[0][0] +"</font>��,Ϊ�����ϵͳ��ѯ�ٶ�,Ŀǰֻ��ʾǰ200��</center>";
  document.getElementById("allPageNum").value=list[0][0];
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

if(typeof AIHBAjax == "undefined") var AIHBAjax = new Object();

AIHBAjax.Request = function(options){
  var xmlrequest = createRequest();
  xmlrequest.onreadystatechange=function()
	{
		if(xmlrequest.readyState == 4)
			if(xmlrequest.status == 200)
				options.callback(xmlrequest);
	}
	xmlrequest.open("POST",options.url,true);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send(options.param);
};

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
		drawDynamicHtmlSelect(sqls[i-1].replace("${value}",value),selects[i]);
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
	document.forms[0].filename.value=document.title;
	
	var str="";
	for(j=0;j<resultTableDown.rows[0].cells.length;j++)
	{
		str+=(resultTableDown.rows[0].cells[j].innerText)+",";
  }
	document.forms[0].title.value=str;
	
 	if(pagenum==0)
 	{
 		 alert("û�в�ѯ��¼!");
 		 return;
 	}
 	else if(pagenum<=15)
 	{
 	   // bass 2.0 ��д�˴�ҳ��������ݵķ���
 	   SaveAsExcel2(document.forms[0].filename.value+".csv");
 	}
 	else if(pagenum>15&&pagenum<20000)
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
	var result = foo;
	
	var ary = foo.split(".");
	
  if(ary.length==2 && ary[1].length>digit)
  {
  	nextnum = parseInt(ary[1].substring(digit,digit+1),10);
  	
  	curnum = parseInt(ary[1].substring(0,digit),10);
  	
  	if(nextnum>=5)curnum = curnum+1;
  	
  	result = ary[0]+"."+ curnum;
  }
	return result;
}

function hideTitle(img,objId,msg)
{
	var obj = document.getElementById(objId);
	if(img.ShowFlag ==0)
	{
		img.src="/hb-bass-navigation/hbbass/common2/image/ns-expand.gif";
		img.ShowFlag = 1;
		img.title="�������" + msg;
		obj.style.display = "";
	}
	else
	{
		img.src="/hb-bass-navigation/hbbass/common2/image/ns-collapse.gif";
		img.ShowFlag = 0;
		img.title="�����ʾ" + msg;
		obj.style.display = "none";			
	}
}

function selectColumnsArea()
{
	var foo = document.getElementById("selectColumns");
	if(foo.style.display=='none')foo.style.display='block';
	else if(foo.style.display=='block')foo.style.display='none';
}

function selectColumns(seq,isHidden)
{
	tabdiv = document.getElementById("tabTitle");
	
	nl = tabdiv.getElementsByTagName("span");
	a=0;
	for(i=0; i < nl.length; i++)if(nl[i].childNodes[0].style.display!="none")a++;
	
	var gridwidth = tabdiv.childNodes[0].width.replace("%","");
	var tdwidthnl = nl[seq].childNodes[0].width.replace("%","");
	var numwidth=0;
	
	if(isHidden)
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
function renderColumns(seq,isHidden)
{
	selectColumns(seq,isHidden);
	getContent();
}

function channelSpeelSQL(columns,tables,condition,group,postfix)
{
	//=============  ƴдsql��  ============
	var sql = "select #{columns} from #{tables} where #{condition} group by #{group} #{postfix} with ur";
	
	var chartsql = "select #{value},#{columns} from #{tables} where #{condition} group by #{value} with ur".replace("#{columns}",columns);
	
	//���⴦�����
	if(document.forms[0].county!=undefined&&document.forms[0].county.value!="")
	{
		if(group.length>0)group = document.forms[0].county.parentNode.name + ","+group;
		else group = document.forms[0].county.parentNode.name;
		
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		
		cellfunc[0]=function(foo){return mapping(foo,"county");};
	}
	else if(document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(document.forms[0].county!=undefined)a= document.forms[0].county.parentNode.name;
		else a = document.forms[0].city.parentNode.name;
		
		if(group.length>0)group =  a+ ","+group;
		else group = a;
		
		condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		cellfunc[0]=function(foo){return mapping(foo,"county");};
	}
	else if(document.forms[0].city.value!=undefined)
	{
		if(group.length>0)group = document.forms[0].city.parentNode.name + ","+group;
		else group = document.forms[0].city.parentNode.name;
		cellfunc[0]=function(foo){return mapping(foo,"city");};
	}
	else if(document.forms[0].province!=undefined)
	{
		columns = "'"+ document.forms[0].province[0].text +"',"+columns;
	}
	
	//���⴦����������
	//3��ṹ
	var seq=1;//��¼�������͵Ľṹ
	if(document.forms[0].channeltype!=undefined)
	{
		seq=3;
		var channel3 = document.forms[0].channeltype;
		if(channel3.value!="")
		{
			if(condition.length>0)condition = condition + " and " +"a.channel_id="+tables.split(",")[0]+".channel_id";
			else condition="a.channel_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id,channel_name from nwh.RES_SITE_DS) a,"+tables;
			group = group+","+document.forms[0].channelkind.parentNode.name + ","+ channel3.parentNode.name + ","+ "channel_name";
			selectColumns(2,false);
			selectColumns(3,false);
			cellfunc[1]=function(foo){return mapping(foo,"channelkind");};
			cellfunc[2]=function(foo){return mapping(foo,"channeltype");};
			//cellfunc[3]=function(foo){return mapping(foo,"channeltype");};
		}
		else if(document.forms[0].channelkind.value!="")
		{
			group = group+","+document.forms[0].channelkind.parentNode.name + ","+ channel3.parentNode.name;
			columns = "'--',"+columns;
			selectColumns(2,false);
			selectColumns(3,true);
			cellfunc[1]=function(foo){return mapping(foo,"channelkind");};
			cellfunc[2]=function(foo){return mapping(foo,"channeltype");};
		}
		else
		{
			group = group + ","+ document.forms[0].channelkind.parentNode.name;
			columns = "'--','--',"+columns;
			selectColumns(2,true);
			selectColumns(3,true);
			cellfunc[1]=function(foo){return mapping(foo,"channelkind");};
		}
	}
	//2��ṹ
	else if(document.forms[0].selfchannel!=undefined || document.forms[0].sochannel!=undefined || document.forms[0].echannel!=undefined )
	{
		seq=2;
		var channel2 = document.forms[0].selfchannel;
		if(document.forms[0].sochannel!=undefined)channel2 = document.forms[0].sochannel;
		else if (document.forms[0].echannel!=undefined) channel2 = document.forms[0].echannel;
		
		if(channel2.value!="")
		{
			if(condition.length>0)condition = condition + " and " +"a.channel_id="+tables.split(",")[0]+".channel_id";
			else condition="a.channel_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id,channel_name from nwh.RES_SITE_DS) a,"+tables;
			group = group+"," + channel2.parentNode.name + ","+ "channel_name";
			selectColumns(2,false);
			cellfunc[1]=function(foo){return mapping(foo,"selfchannel");};
		}
		else if(channel2.value=="")
		{
			group = group+","+channel2.parentNode.name;
			columns = "'--',"+columns;
			selectColumns(2,true);
			cellfunc[1]=function(foo){return mapping(foo,"selfchannel");};
		}
	}
	//1��ṹ
	else if(document.forms[0].channelkind!=undefined)
	{
		if(document.forms[0].channelkind.value!="")
		{
			columns = "'"+document.forms[0].channelkind.value+"',"+columns;
			//selectColumns(2,false);
			cellfunc[1]=function(foo){return mapping(foo,"channelkind");};
		}
		else
		{
			group = group + ","+ document.forms[0].channelkind.parentNode.name;
			//selectColumns(2,true);
			cellfunc[1]=function(foo){return mapping(foo,"channelkind");};
		}
	}
	
	//���⴦���ն�
	if(document.forms[0].terminaltype!=undefined)
	{
		var term = document.forms[0].terminaltype;
		if(term.value!="")
		{
			columns = "'"+ document.forms[0].terminalbrand.value +"','"+ term.value +"',"+columns;
			selectColumns(seq+2,false);
			//cellfunc[seq+2]=function(foo){return mapping(foo,"terminaltype");};
		}
		else if (document.forms[0].terminalbrand.value!="")
		{
			group = group + "," + document.forms[0].terminalbrand.parentNode.name + "," + term.parentNode.name;
			selectColumns(seq+2,false);
		}
		else
		{
			group = group + "," + document.forms[0].terminalbrand.parentNode.name;
			columns = "'--',"+columns;
			selectColumns(seq+2,true);
		}
		cellfunc[seq+1]=function(foo){return mapping(foo,"terminalbrand");};
	}
	else if(document.forms[0].terminalbrand!=undefined)
	{
		var term = document.forms[0].terminalbrand;
		if(term.value!="") columns = "'"+ term.value + "',"+columns;
		else group = group + "," + document.forms[0].terminalbrand.parentNode.name;
		cellfunc[seq+1]=function(foo){return mapping(foo,"terminalbrand");};
	}
	
	var dimdiv = document.getElementById("dimdiv");
	
	var attribute = dimdiv.getElementsByTagName("span");
	for(i=0; i < attribute.length; i++)
	{
		//alert(attribute[i].childNodes[0].name +"  "+ "exclusive"+"  "+ (attribute[i].childNodes[0].name=="exclusive"))
		if(attribute[i].childNodes[0].value != "" 
				&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)
			{
				if(attribute[i].type=="int")condition += " and " + attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else condition += " and " + attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
			else
			{
				if(attribute[i].type=="int")condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
				else condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			}
		}
		//�Ƿ�μӷ���
		if(attribute[i].grouping!=undefined)
		{
			var tagName = attribute[i].childNodes[0].name;
			if(attribute[i].childNodes[0].value != "" )columns = "'"+ attribute[i].childNodes[0].value+"',"+columns;
			else group = group + ","+attribute[i].name;
			
			cellfunc[attribute[i].grouping]=function(foo){return mapping(foo,tagName);};
		}
	}
	columns = group + "," + columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	chartsql = chartsql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	if(condition.length > 0)chartsql = chartsql.replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","");//���ͳ������SQL
	
	sql = sql.replace("#{group}",group).replace("#{columns}",columns);
	
	document.getElementById("sql").value=sql.replace("#{postfix}","");//���������SQL
	
	sql = sql.replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
  
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  arr[2] = chartsql;
  
  return arr;
}

function channelBaseQuery(columns,tables,condition,group,postfix)
{
	arr = channelSpeelSQL(columns,tables,condition,group,postfix);
	ajaxSubmit(arr[0],arr[1]); //ִ�в�ѯ��ʾ
}

function mappingArea(foo)
{
	var nl = document.getElementsByName("city");
	for(i=0;i< nl[0].length;i++)
	{
		if(nl[0].childNodes[i].value==foo)
		return nl[0].childNodes[i].text;
	}
	
	nl = document.getElementsByName("county");
	if(nl.length>0)
	{
		for(i=0;i< nl[0].length;i++)
		{
			if(nl[0].childNodes[i].value==foo)
			return nl[0].childNodes[i].text;
		}
	}
	
	nl = document.getElementsByName("office");
	if(nl.length>0)
	{
		for(i=0;i< nl[0].length;i++)
		{
			if(nl[0].childNodes[i].value==foo)
			return nl[0].childNodes[i].text;
		}
	}
	return foo;
}

function mapping(foo,tagName)
{
	var nl = document.getElementsByName(tagName);
	for(i=0;i< nl[0].length;i++)
	{
		if(nl[0].childNodes[i].value==foo)
		return nl[0].childNodes[i].text;
	}
	return foo;
}