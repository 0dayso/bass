var hbbasscommonpath = '/hbbass/common2';

var xmlDoc = createXMLDOM();
var pagenum=10; //每页显示几条信息 
var page=0 ;
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
    alert('您的浏览器不支持此脚本');
	
	xmlDoc.async=false;
	return xmlDoc;
}

function fenye(fileName)
{
	xmlDoc.load("/hb-bass-navigation/hbbass/commonXml/"+fileName);
	//检索的记录数
	maxNum = xmlDoc.getElementsByTagName("result").length;
	//页数
	pagesNumber=Math.ceil(maxNum/pagenum)-1; 
	
	// 从上一页面取得表头，同时替换掉多余的标签，便于复用
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
  
  var showResult1=document.getElementById("showResult");
  
  var BodyText = header;
 
  // 设定排序的表格部分
	BodyText=BodyText+"<TBODY id='resultTbody'>";
  for (;n<endNum;n++)
  {
  	if(n%2==0)
      BodyText=BodyText+"<TR class='result_v_1'  onMouseOver=\"this.className='result_v_3'\" onMouseOut=\"this.className='result_v_1'\">";
    else
  		BodyText=BodyText+"<TR class='result_v_2'  onMouseOver=\"this.className='result_v_3'\" onMouseOut=\"this.className='result_v_2'\">";
  		
  	//BodyText+="<TD>"+results[n].getAttribute("id")+"</TD>";
    for(m=0;m<=colNum-1;m++)
    	BodyText+="<TD id='t"+m+"'>"+results[n].childNodes[m].childNodes[0].nodeValue+"</TD>";
    
    BodyText=BodyText+"</TR>";
  }
 	showResult1.innerHTML=BodyText+"</TBODY></table><textarea name='downcontent'  cols='122' rows='12' style='display:none'></textarea>"+pageBar(page);
 	
}

//首页
function FirstPage(page)
{
    thePage="首页";
    if(page>0) thePage="<A HREF='#' onclick='Javascript:return FirstPageGo()'>首页</A>";
    return thePage;
}
//上一个页面
function UpPage(page)
{
    thePage="前一页";
    if(page+1>1) thePage="<A HREF='#' onclick='Javascript:return UpPageGo()'>前一页</A>";
    return thePage;
}
function NextPage(page)
{
    thePage="后一页";
    if(page<pagesNumber) thePage="<A HREF='#' onclick='Javascript:return NextPageGo()'>后一页</A>";
    return thePage;
}

function LastPage(page)
{
    thePage="尾页";
    if(page<pagesNumber) thePage="<A HREF='#' onclick='Javascript:return LastPageGo()'>尾页</A>";
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
    
    ap='共 <font color=red>'+maxNum+' </font>条记录,&nbsp;每页 <font color=red>'+pagenum+' </font>条记录,当前显示 <font color=red>'+(page*pagenum+1)+' </font>到 <font color=red>'+endNum+' </font>条&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第<font color=red> '+(page+1)+' </font>页/共 <font color=red>'+(pagesNumber+1)+' </font>页';
    return ap
}

//显示分页状态栏
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


// 页面触发，调用服务器端程序 
function ajaxSubmit(sqlStatement)
{
	// 显示查询提示进度
	queryload.style.display="block";
	
	xmlHttp = createRequest();
	
	xmlHttp.onreadystatechange=toQueryCallBack; // 设置回掉函数 
	xmlHttp.open("POST",hbbasscommonpath+"/db2xml.jsp",true);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.send("sql="+encodeURIComponent(sqlStatement));
}
//回掉函数
function toQueryCallBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			fenye(xmlHttp.responseText);
			page=0;        // 调用 getContent() 必须将page置成0 否则，第一次查询多次完后翻页后，后续查询显示页面将错误。
		  getContent();
		  // 隐藏表头信息
		  var t=document.getElementById("tabTitle");
		  t.style.display="none";
		  // 隐藏查询提示进度
		  queryload.style.display="none";
		}
	}
}

//创建链接
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
	传入sql语句返回2维数组
	@param sqlStatement: sql语句
	@param callback: 回调函数,根据业务处理返回list(2维数组)
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
				//alert(list);
				callback(list);
			}
		}
	}
	xmlrequest.open("POST",url,true);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send("sql="+encodeURIComponent(sqlStatement));
}

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };//为String对象添加trim()方法
/**
	画HTML Select 标签
	使用ajax访问数据库,返回的数据形式为约定格式(列分隔符为'@,',行分隔符为'@|')

	@param sqlStatement : sql语句
	@param select: HTML select标签的name应用
	@param defaultName : HTML select标签默认选中OPTION
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
				
				//画
				drawStaticHtmlSelect(data,select,defaultName);
			}
		}
	}
	xmlrequest.open("POST",url,true);
	xmlrequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlrequest.send("sql="+encodeURIComponent(sqlStatement));
}

/**
同步调用
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
			
			//画
			drawStaticHtmlSelect(data,select,defaultName);
		}
	}
}

/**
	画HTML Select 标签
	画静态的标签,数据形式为约定格式(列分隔符为'@,',行分隔符为'@|')

	@param data : 静态的数据
	@param select: HTML select标签的name应用
	@param defaultName : HTML select标签默认选中OPTION
*/
function drawStaticHtmlSelect(data,select,defaultName)
{
		lines = data.split("@|");//分割行
		
		isHoldFirstOption = false;
		
		//如果没有defaultName就代表不删除第一个option
		if(defaultName == undefined || defaultName == '')
			isHoldFirstOption = true;
		
		if(isHoldFirstOption)//不删除第一个
		{
			select.length=1;
			select.disabled = false;
			for (i =0;i < lines.length; i++)
			{
				line = lines[i].split("@,");//分为列
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
	联动的通用方法
	@param selects: 所有参加联动的HTMLSelect标签的数组引用,顺序插入
	@param sqls: 所有参加联动的sql字符串数组,顺序插入(sql语句中的value通过字符串'${value}'代替)
	@param i: 联动的级别,顺序从1开始
*/
function combolink(selects,sqls,i)
{
	var value = selects[i-1].value;
	
	if(value==""||value=="0")
  {
  	// 如果传递的值为第一项“全省”或“全部” 下级级联选择框内容直接置为第一项“全部” ，不再提交数据库查询
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
  form1.downcontent.value=str;
	form1.action="/hb-bass-navigation/hbbass/common/saveCsv.jsp?fname="+fname;
	form1.target="_top";
	form1.submit();
}

/* 
执行下载 
*/
function toDown()
{
	var pagenum=form1.allPageNum.value;
 	if(pagenum==0)
 	{
 		 alert("没有查询记录!");
 		 return;
 	}
 	else if(pagenum<=15)
 	{
 	   // bass 2.0 改写了从页面下载数据的方法
 	   SaveAsExcel2('测试.csv');
 	}
 	else if(pagenum>15&&pagenum<20000)
	{
	 		document.form1.action = "/hb-bass-navigation/hbbass/common2/commonDown.jsp";
			document.form1.target = "_top";
			document.form1.submit();	
	}
	else
	{
		  document.form1.action = "/hb-bass-navigation/hbbass/common2/commonDownFile1.jsp";
			document.form1.target = "_blank";
			document.form1.submit();	
		}
	document.form1.submit();
}