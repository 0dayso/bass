<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.asiainfo.database.*" %>
<%@ page import = "bass.common.QueryTools2,bass.common.QueryTools3"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<html>
<head>
	<title>分析主界面</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon_ngbass.js" charset=utf-8></script>
	<script src="/hbbass/ngbass/hbjs/calendar.js" type="text/javascript"></script>
	<script src="/hbbass/ngbass/hbjs/calendar2.js" type="text/javascript"></script>
	<script language="JavaScript" src="/hbbass/js/FusionCharts.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
	<style type="text/css">
<!--
/* 要求有下划线的链接样式 */
a.a2            { color: #0000FF; text-decoration: none }
a:link.a2       { text-decoration: underline; color: #0000FF; font-family: 宋体 }
a:visited.a2    { text-decoration: underline; color: #0000FF; font-family: 宋体 }
a:hover.a2      { text-decoration: underline; color: #FF0000 }
a:active.a2     { text-decoration: underline; color: #FF0000 }
-->
</style>
</head>
	<script type="text/javascript">
	pagenum=15;
	fetchRows=50;
	
String.prototype.replaceAll  = function(s1,s2){    
return this.replace(new RegExp(s1,"gm"),s2);    
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

function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();

	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		sqls.push("select country_id,org_name from NMK.DIM_ent_AREAORG where country_id like '#{value}%'  order by seq with ur");
	}
	
	if(document.forms[0].custmanager!= undefined)
	{
		selects.push(document.forms[0].custmanager);
		sqls.push("select distinct staff_id,staff_name from   NMK.STAFF where OWN_ORG_ID like '#{value}%' order by 1 with ur");
	}
	
	
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

function getListPre(list_t)
{
   var formlist=document.getElementById(list_t);	
   var listValue="";
   for(var i=0;i<formlist.length;i++)
   {
   	   if(formlist.options[i].selected)
   	   {
   	   	if(listValue=="")
   	   	   listValue=formlist.options[i].value.split("@")[0];
   	   	 else
   	   	 	 listValue+=","+formlist.options[i].value.split("@")[0];
   	   	}
   	}
   	return listValue;
}

function getListSuff(list_t)
{
   var formlist=document.getElementById(list_t);	
   var listValue="";
   for(var i=0;i<formlist.length;i++)
   {
   	   if(formlist.options[i].selected)
   	   {
    	   	if(listValue=="")
   	   	   listValue=formlist.options[i].value.split("@")[1];
   	   	 else
   	   	 	 listValue+=","+formlist.options[i].value.split("@")[1];
   	   	}
   	}
   	return listValue;
}

function getListText(list_t)
{
   var formlist=document.getElementById(list_t);	
   var listValue="";
   for(var i=0;i<formlist.length;i++)
   {
   	   if(formlist.options[i].selected)
   	   {
    	   	if(listValue=="")
   	   	   listValue=formlist.options[i].text;
   	   	 else
   	   	 	 listValue+=","+formlist.options[i].text;
   	   	}
   	}
   	return listValue;
}
function doSubmit()
{
	var sql_dim=getListPre("select1");  // 维度名称  参与组织sql
	var sql_value=getListPre("select2");  // 指标规则， 参与组织sql
	if(sql_dim=="")
	{
	  alert("请选择维度！");
	  return;	
	}
	if(sql_value=="")
	{
	  alert("请选择指标！");
	  return;	
	}
	var sql_dim_table=getListSuff("select1"); // 对应维度的维表
	var sql_value_name=getListSuff("select2");// 指标的名称，不是指标规则
	var table_title=getListText("select1")+","+getListText("select2");
	var reportanalyquery =document.getElementById("reportanalyquery").value;
	var sql="select "+sql_dim+","+sql_value+" "+reportanalyquery+" group by  rollup("+sql_dim+") order by 1 fetch first 100 rows only with ur ";
	
	// 获取到所有的表单 及 sql规则
	var formIdStr=document.getElementById("formIdStr").value;
	var formIdStrArray=new Array();   //
	var formIdStrArray2=new Array();  //
	var formIdStrArray3=new Array();  //
	
	var formid_t="";  //  表单id临时变量
	var formid_v="";  //  表单id的值
	
	var segreg_t="";  // sql规则临时变量
	formIdStrArray=formIdStr.split("|");
	for(var i=0;i<formIdStrArray.length;i++)
	{
		formid_t=formIdStrArray[i].split("@")[0];
		formid_v=document.getElementById(formid_t).value;
		segreg_t=formIdStrArray[i].split("@")[1];
		formIdStrArray2=segreg_t.split(";")
		
		if(formid_v!="")
		{
			  if(formid_v==0)
			  {
				  	// 对于地市需要特殊处理，当选择全省的时候，值为0，实际对应查询全部
				  	if(formid_t=="city")
				  	{
						  	for(var j=0;j<formIdStrArray2.length;j++)
								{
									sql=sql.replaceAll(formIdStrArray2[j]," 1=1 ");
								}
						
								/* 当查询全省时，需要按地市汇总，查询地市时，按县域汇总*/
								sql=sql.replaceAll("length\\(city\\)","5");  // 级联的地市
					 }
			  }
			  else
		  	{
		  		
			    sql=sql.replaceAll("#"+formid_t,formid_v);
			    if(formid_t=="city")
				  {
		         /* 当查询全省时，需要按地市汇总，查询地市时，按县域汇总*/
				   	  sql=sql.replaceAll("length\\(city\\)","8");  // 级联的地市
			    }
				}
		}
		else
		{
			for(var j=0;j<formIdStrArray2.length;j++)
			{
				sql=sql.replaceAll(formIdStrArray2[j]," 1=1 ");
			}
		
		}		

	}
	//document.getElementById("sqlview").innerHTML=sql;
	
	var pid=document.getElementById("hidid").value;
	document.getElementById("showImageArea").innerHTML="";
	xmlHttp = createRequest();
	xmlHttp.onreadystatechange=callbackAnaly
	xmlHttp.open("POST","analyMain_db.jsp",true);
 	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
 	var str="sql="+sql+"&pid="+pid+"&sql_dim_table="+sql_dim_table+"&sql_value_name="+sql_value_name+"&table_title="+table_title;
	str=encodeURI(str,"UTF-8");
	xmlHttp.send(str); 
}

function callbackAnaly()
{
      if(xmlHttp.readyState == 4)
			{
				if(xmlHttp.status == 200)
				{
					var responseText=xmlHttp.responseText;
		      document.getElementById("analyResultTable").innerHTML=responseText;
		      initData();
		      geneImage();
		    }
			}
}

function SaveAsExcel(fname)
{
   var str="";
	 for(i=0;i<resultTable.rows.length;i++)
	{
			for(j=0;j<resultTable.rows[0].cells.length;j++)
			{
				str+=(resultTable.rows[i].cells[j].innerText)+","; 
	     }
			str+="\n";
	}
	str=str.replace(/\r\n/g,"");
  form1.downcontent.value=str;
	form1.action="/hbbass/common/saveCsv.jsp?fname="+fname;
	form1.target="_top";
	form1.submit();
}

var stat_array= new Array() ;
function initData()
{
	stat_array = new Array();
	var s="";
	var resultTab=document.getElementById("resultTable");
	var len=resultTab.rows.length;
  if(len==1)
  {
      //alert("没有结果集");
      return;	
  }	
	if(len>2)
	   len=len-1;  // 由于最后一列是合计列，不进行图形展示。

				for(var i=0;i<len;i++)
				{
						stat_array[i] = new Array();
						for(var j=0;j<resultTab.rows[i].cells.length;j++)
						{
							// 替换掉表头中的回车换行 <br>
							s=resultTab.rows[i].cells[j].innerText.replace("\n","").replace("\r","");
							s=s.replace("(%)","");
							stat_array[i][j]=s;
						}
				}	
}

function geneImage()
{
	  var imageType=document.getElementById("imageType").value;
		var imageHead="";    // 获取图片表头 图片配置参数
		var imageBody="";   // 获取图片数据
		var Color=new Array("ff00ff","ffA6A6","ff0000","ffaeff","0000ff","84aeff","00ffff","a6aeff","00ff00","b5ffb5","ffff00","ffffb5","C0C0C0","800000","808000","008000","008080","000080","800080")  ;
		
		if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
	  { 
	  	imageHead="<graph showNames='1' caption='"+stat_array[0][1]+"' decimalPrecision='2'  showPercentageValues='0'  baseFontSize='12' formatNumberScale='0' showPercentageInLabel='1' pieYScale='75' bgColor='ffffff' pieRadius='130' hoverCapSepChar=':' >";
	  	for(i=1;i<stat_array.length;i++)
      {
   		imageBody+="<set name='"+stat_array[i][0]+"' value='"+stat_array[i][1]+"' color='"+Color[i*2%19]+"'/>"  
   	  }
	  }
	  else  if(imageType=="FCF_MSColumn2D"||imageType=="FCF_StackedColumn2D"||imageType=="FCF_MSLine")
   	{
				imageHead="<graph    hovercapbg='DEDEBE' hovercapborder='889E6D' formatNumberScale='0' rotateNames='0'  numdivlines='9' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC' baseFontSize='12' hoverCapSepChar=':'  >";
				imageBody+="<categories font='Arial' fontSize='12' fontColor='000000'>";
				for(i=1;i<stat_array.length;i++)
        {
	   		imageBody+="<category name='"+(stat_array[i][0])+"'/>"  
	   	  }
	   	  imageBody+="</categories>";
	   	   for(i=1;i<stat_array[0].length;i++)
	   	  {
	   	  	imageBody+="<dataset seriesname='"+(stat_array[0][i])+"' fontSize='12'  color='"+Color[i*2%19]+"'>";
	   	  	for(j=1;j<stat_array.length;j++)
	        {
	        	imageBody+="<set value='"+stat_array[j][i]+"' />"  
	        }
	        imageBody+="</dataset>";
	   	  }
   	}
	  
	  var imageHtml=imageHead+imageBody+"</graph>";
	 	//alert(imageHtml);
	 	var chart = new FusionCharts("/hbbass/common/flash/"+imageType+".swf", "ChartId", "600", "360");
		chart.setDataXML(imageHtml);		   
		chart.render("showImageArea");
}

//表格排序
function sortTable(id, col, rev,n) 
{
 // 取得表格排序的部分
 var tblEl = document.getElementById(id);
 if (tblEl.reverseSort == null) {
 tblEl.reverseSort = new Array();
 tblEl.lastColumn = 1;
 }

 if (tblEl.reverseSort[col] == null)
 tblEl.reverseSort[col] = rev;

 if (col == tblEl.lastColumn)
 tblEl.reverseSort[col] = !tblEl.reverseSort[col];
 tblEl.lastColumn = col;
 var oldDsply = tblEl.style.display;
 tblEl.style.display = "none";
 var tmpEl;
 var i, j;
 var minVal, minIdx;
 var testVal;
 var cmp;

 for (i = 0; i < tblEl.rows.length - 1-n; i++) 
 {
 minIdx = i;
 minVal = getTextValue(tblEl.rows[i].cells[col]);
 for (j = i + 1; j < tblEl.rows.length-n; j++) {
 testVal = getTextValue(tblEl.rows[j].cells[col]);
 cmp = compareValues(minVal, testVal);
 if (tblEl.reverseSort[col])
 cmp = -cmp;
 if (cmp == 0 && col != 1)
 cmp = compareValues(getTextValue(tblEl.rows[minIdx].cells[1]),
 getTextValue(tblEl.rows[j].cells[1]));
 if (cmp > 0) {
 minIdx = j;
 minVal = testVal;
 }
 }

 if (minIdx > i) {
 tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
 tblEl.insertBefore(tmpEl, tblEl.rows[i]);
 }
 }

 makePretty(tblEl, col,n);
 tblEl.style.display = oldDsply;
 return false;
}

if (document.ELEMENT_NODE == null) {
 document.ELEMENT_NODE = 1;
 document.TEXT_NODE = 3;
}

function getTextValue(el) {

 var i;
 var s;

 s = "";
 for (i = 0; i < el.childNodes.length; i++)
 if (el.childNodes[i].nodeType == document.TEXT_NODE)
 s += el.childNodes[i].nodeValue;
 else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
 el.childNodes[i].tagName == "BR")
 s += " ";
 else
 s += getTextValue(el.childNodes[i]);
 return normalizeString(s);
}

function compareValues(v1, v2) {

 var f1, f2;
 f1 = parseFloat(v1);
 f2 = parseFloat(v2);
 if (!isNaN(f1) && !isNaN(f2)) {
 v1 = f1;
 v2 = f2;
 }
 if (v1 == v2)
 return 0;
 if (v1 > v2)
 return 1
 return -1;
}

var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
var whtSpMult = new RegExp("\\s\\s+", "g");

function normalizeString(s) {
 s = s.replace(whtSpMult, " ");
 s = s.replace(whtSpEnds, ""); 
 return s;
}

var rowClsNm = "grid_row_blue";
var rowClsNm1 = "grid_row_blue";
var colClsNm = "grid_row_alt_blue";

// Regular expressions for setting class names.
var rowTest = new RegExp(rowClsNm, "gi");
var rowTest1 = new RegExp(rowClsNm1, "gi");
var colTest = new RegExp(colClsNm, "gi");

function makePretty(tblEl, col,n) {

 var i, j;
 var rowEl, cellEl;
 for (i = 0; i < tblEl.rows.length-n; i++) {
 rowEl = tblEl.rows[i];
 rowEl.className = rowEl.className.replace(rowTest, "");
 if (i % 2 != 0)
rowEl.className= " " + rowClsNm;
else
	rowEl.className= " " + rowClsNm1;


 rowEl.className = normalizeString(rowEl.className);
 for (j =1; j < tblEl.rows[i].cells.length; j++) {
 cellEl = rowEl.cells[j];
 cellEl.className = cellEl.className.replace(colTest, "");
 if (j == col)
 cellEl.className += " " + colClsNm;
 cellEl.className = normalizeString(cellEl.className);
 }
 }

 // 高亮显示排序的列,如果有必要可以把i的起始值设置小点,
 var el = tblEl.parentNode.tHead;
 rowEl = el.rows[el.rows.length - 1];
 // 设置上面每列的样式表
 for (i = 100; i < rowEl.cells.length; i++) 
 {
 cellEl = rowEl.cells[i];
 cellEl.className = cellEl.className.replace(colTest, "");
 // 高亮显示排序的列
 if (i == col)
 cellEl.className += " " + colClsNm;
 cellEl.className = normalizeString(cellEl.className);
 }
}

 // wangbt 添加 变换排序列的标题
function changeText(id)
{
    var thead=document.getElementById("resultHead"); 
    for(i=0;i<thead.children.length;i++)
    {
    	tr=thead.children.item(i);
    	for(j=0;j<tr.children.length;j++)
    	{
    		var idstr=tr.children.item(j).getAttribute("id");
    		if(id==idstr)
    		{
    			 if(tr.children.item(j).innerHTML.indexOf("↓")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="↑";
    			 }
    		else if(tr.children.item(j).innerHTML.indexOf("↑")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="↓";
    			 }
    		else
    			tr.children.item(j).innerHTML+="↓";
    		}
    		else
    		{
    			if(tr.children.item(j).innerHTML.indexOf("↓")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
     			 }
    		  else if(tr.children.item(j).innerHTML.indexOf("↑")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			 }
    			
    		}	
    	}

    }
}

function freshImage()
{
	  // 排序后刷新图形
    initData();
		geneImage();
}
</script>
<%

String pid=request.getParameter("pid");
Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx());
	 String sql2="select  * from NGBASS_REPORT where id="+pid+"   with ur";
	 String reportanalyquery="";
	 String report_name="";
	 sqlca.execute(sql2);
	 if(sqlca.next())
	 {
	    reportanalyquery=sqlca.getString("reportanalyquery");
	    report_name=sqlca.getString("report_name");
	 }

%>
<body>
<form action="" method="post" name="form1">
	<input type="hidden" name="hidid" value="<%=pid%>">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title">维度选择
		    	</div>
		    	<div id="dim" class="content">
         <table align="center" width="99%"  cellspacing="1" cellpadding="1" border="0">
					<%
					/*根据应用编号查询出所有的查询条件 */
					String sql1="select formtype,dataformat, formname, formid ,sqlreg from NGBASS_REPORT_INPUT where pid="+pid+" order by order with ur";
					sqlca.execute(sql1);
					int i=0;
					String formtype="";
					String dataformat="";
					String formname="";
					String formid="";
					String sqlreg="";
					
					 String formIdStr=""; // 表单id组成的串
					 
					 while(sqlca.next())
					 {
					   formtype=sqlca.getString("formtype");
					   dataformat=sqlca.getString("dataformat");
					   formname=sqlca.getString("formname");
					   formid=sqlca.getString("formid");
					   sqlreg=sqlca.getString("sqlreg");
					   
					   if(i%4==0)
					   {
					      out.print("<tr bgcolor='#FFFFFF'>");
					   }
					   if(formtype.equals("input"))
					   {
					      out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'><input type=text name="+formid+"  size=10 maxlength=12></td>");
					   }
					   else if(formtype.equals("time"))
					   {
			          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+NgbassTools.getQueryDate(formid,dataformat)+"</td>");
				     }
					   else
					   {	
				       if(formid.equals("city"))
					     {
					          /* 无级联关系的地市选择项 */
					          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools2.getAreaCodeHtml(formid,"0","areacombo(1)")+"</td>");
					     }
					     else if(formid.equals("county"))
					     {
					          /* 无级联关系的地市选择项 */
					          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools2.getCountyHtml(formid,"areacombo(2)")+"</td>");
					     }
					     else if(formid.equals("custmanager"))
					     {
					          /* 无级联关系的地市选择项 */
					          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools2.getCountyHtml(formid,"areacombo(3)")+"</td>");
					     }
					     else
					     out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools3.getStaticHTMLSelect(formid,"")+"</td>");
					   }
					  
					   if(i%4==3)
					   {
					      out.print("</tr>");
					   }
             i++;
             if(formIdStr.equals(""))
             {
                formIdStr=formid+"@"+sqlreg;
             }
             else
           	 {
           	    formIdStr+="|"+formid+"@"+sqlreg;
           	 }
					 }
            int k=4-i%4;
            if(k>0)
            {
              for(int j=k;j>0;j--)
              {
               out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>&nbsp;</td><td width='15%' align='left' bgcolor='#EFF5FB'>&nbsp;</td>");
              }
              out.print("</tr>");
            }
					%>
					</table>
					<table align="center" width="99%">
						<tr class="dim_row_submit" ><input type="hidden" name="formIdStr" id="formIdStr" value="<%=formIdStr%>">
							<td align="right">
							<input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onClick="SaveAsExcel('<%=report_name%>.csv')">&nbsp;
						</td>
					</tr>
					</table>
				 </div>
        	</div>
	    </td>
	  </tr>
	</table>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr align="center">
	    <td colspan="1" valign="top"><%=report_name%> 
	    <input type="hidden" name="reportanalyquery" id="reportanalyquery" value="<%=reportanalyquery%>" size=60>	
	    </td>
	</tr>
</table>
	<!-- 输出维度，指标控制列 及图形输出区-->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title">维度选择
		    	</div>
		    	<div id="dim" class="content">
          <table align="center" width="98%"  cellspacing="1" cellpadding="1" border="0">
         			 <tr>
							    <td width="14%" height="107" bgcolor="#D9ECF6" align="right">维度选择(单选)</td>
							    <td width="14%" bgcolor="#EFF5FB" align="left">
							    <select name="select1" size="6" id="select1" style="width:120">
							    	<%
							    	   String sqlDim="select  FIELDVALUE||'@'||value(dimtable,'') FIELDVALUE, FIELDNAME   from NGBASS_REPORT_OUT where  fieldtype='dim' and pid="+pid+"  order by ANALYSORDER  with ur";
					             i=0;
					             sqlca.execute(sqlDim);
					             while(sqlca.next())
					             {
							    	%>
							        <option value="<%=sqlca.getString("FIELDVALUE")%>" <%if(i==0) out.println("selected");%>><%=sqlca.getString("FIELDNAME")%></option>
							      <%
							         i++;
							         }
							      %>  
							      </select>	
							    </td>
							    <td width="72%" rowspan="3" align="left">
							    <div id="showImageArea" align="center">   <!-- 图形输出位置 -->
		              </div>	
							    </td>
							  </tr>
							  <tr>
							    <td height="118"  bgcolor="#D9ECF6" align="right">指标选择(多选)</td>
							    <td height="118" bgcolor="#EFF5FB" align="left">
							    <select name="select2" size="8" multiple="multiple" id="select2" style="width:120">
							    	<%
							    	   String sqlValue="select  VALUEREG||'@'||FIELDVALUE VALUEREG, FIELDNAME   from NGBASS_REPORT_OUT where  fieldtype='value' and pid="+pid+"  order by ANALYSORDER with ur";
					             i=0;
					             sqlca.execute(sqlValue);
					             while(sqlca.next())
					             {
							    	%>
							        <option value="<%=sqlca.getString("VALUEREG")%>" <%if(i==0) out.println("selected");%>><%=sqlca.getString("FIELDNAME")%></option>
							      <%
							         i++;
							        }
							      %>  
							      </select>	
							    </td>
							  </tr>
							  <tr>
							    <td height="21"  bgcolor="#D9ECF6" align="right">图形选择</td>
							    <td height="21"  bgcolor="#EFF5FB" align="left">
							     <select name="imageType" id="imageType" style="width:120" onchange="geneImage()">
							        	<option value="FCF_MSColumn2D">柱状图</option>
							     	   <option value="FCF_Pie3D">饼图</option>
							     	   <option value="FCF_Doughnut2D">圆环图</option>
							     	   <option value="FCF_MSLine">趋势图</option>
							     	   <option value="FCF_StackedColumn2D">堆积柱状图</option>
									</select>
							    </td>
							  </tr>
							  <tr>
							  </tr>
					</table>
 				 </div>
       	</div>
	    </td>
	  </tr>
	</table>        	
  
  	<!-- 表格展示区域 -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title">表格展示
		    	</div>
		    	<div id="analyResultTable" class="content">
 				 </div>
       	</div>
	    </td>
	  </tr>
	</table>   
	<textarea name="downcontent" cols="122" rows="12" style="display:none"></textarea>         	
	</form>
</body>
</html>

<div id="sqlview"></div>
<%
}
catch(Exception excep)
{

	 excep.printStackTrace();
	 System.out.println(excep.getMessage());
}
finally
{
	if(null != sqlca)
		sqlca.closeAll();
}
%>