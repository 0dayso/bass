<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.asiainfo.database.*" %>
<%@ page import = "bass.common.QueryTools2,bass.common.QueryTools3"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<html>
<head>
	<title>��ѯ������</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon_ngbass.js" charset=utf-8></script>
	
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
</head>
<style type="text/css">
<!--
.align_left {
	text-align: left;
}
.align_right {
	text-align: right;
}
.align_center {
	text-align: center;
}
/* Ҫ�����»��ߵ�������ʽ */
a.a2            { color: #0000FF; text-decoration: none }
a:link.a2       { text-decoration: underline; color: #0000FF; font-family: ���� }
a:visited.a2    { text-decoration: underline; color: #0000FF; font-family: ���� }
a:hover.a2      { text-decoration: underline; color: #FF0000 }
a:active.a2     { text-decoration: underline; color: #FF0000 }

.dragAble 
{ position:absolute;
	left:10%;top:30%;
	width:200px;
	padding: 10px,10 px;
	z-index:30;
	background-color: #EFF5FB;
	border:1px solid #c3daf9;
	filter:alpha(opacity=80);
	}  
	
#massage_box{ position:absolute;  left:expression((body.clientWidth-550)/2); top:expression((body.clientHeight-300)/2); width:550px; height:200px;filter:dropshadow(color=#B0D7EC,offx=2,offy=2,positive=2); z-index:2; visibility:hidden;filter:alpha(opacity=80)}
#massage_box2{ position:absolute;  left:expression(event.x); top:expression(event.y+5); width:150px; height:200px;filter:dropshadow(color=#B0D7EC,offx=2,offy=2,positive=2); z-index:2; visibility:hidden;filter:alpha(opacity=80)}
#mask{ position:absolute; top:0; left:0; width:expression(body.clientWidth); height:expression(body.clientHeight); background:#ccc; filter:ALPHA(opacity=30); z-index:1; visibility:hidden}
.massage{border:#D9ECF6 solid; border-width:1 1 2 1; width:95%; height:95%; background:#fff; color:#036; font-size:12px; line-height:150%}

.header{background:#A8D2EA; height:12%; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; padding:3 5 0 5; color:#000}

-->
</style>
<script type="text/javascript">
	pagenum=15;
	fetchRows=50;
	
String.prototype.replaceAll  = function(s1,s2){    
return this.replace(new RegExp(s1,"gm"),s2);    
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
	
	
	//������������
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

function doSubmit()
{
	var sql =document.getElementById("querySql").value;
	// ��ȡ�����еı� �� sql����
	var formIdStr=document.getElementById("formIdStr").value;
	var formIdStrArray=new Array();   //
	var formIdStrArray2=new Array();  //
	var formIdStrArray3=new Array();  //
	
	var formid_t="";  //  ��id��ʱ����
	var formid_v="";  //  ��id��ֵ
	
	var segreg_t="";  // sql������ʱ����
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
				  	// ���ڵ�����Ҫ���⴦����ѡ��ȫʡ��ʱ��ֵΪ0��ʵ�ʶ�Ӧ��ѯȫ��
				  	if(formid_t=="city")
				  	{
						  	for(var j=0;j<formIdStrArray2.length;j++)
								{
									sql=sql.replaceAll(formIdStrArray2[j]," 1=1 ");
								}
						
								/* ����ѯȫʡʱ����Ҫ�����л��ܣ���ѯ����ʱ�����������*/
								sql=sql.replaceAll("length\\(city\\)","5");  // �����ĵ���
					 }
			  }
			  else
		  	{
		  		
			    sql=sql.replaceAll("#"+formid_t,formid_v);
			    if(formid_t=="city")
				  {
		         /* ����ѯȫʡʱ����Ҫ�����л��ܣ���ѯ����ʱ�����������*/
				   	  sql=sql.replaceAll("length\\(city\\)","8");  // �����ĵ���
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
	
	var countSql ="select count(*) from ("+sql+") t with ur";
	document.forms[0].sql.value=sql+" with ur";
	document.getElementById("sqlview").innerHTML=sql;
	ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
}	

//�������
function sortTable(id, col, rev,n) 
{
 // ȡ�ñ������Ĳ���
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

function getTextValue(elbt) {

 var i;
 var s;

 s = "";
 for (i = 0; i < elbt.childNodes.length; i++)
 if (elbt.childNodes[i].nodeType == document.TEXT_NODE)
 s += elbt.childNodes[i].nodeValue;
 else if (elbt.childNodes[i].nodeType == document.ELEMENT_NODE &&
 elbt.childNodes[i].tagName == "BR")
 s += " ";
 else
 s += getTextValue(elbt.childNodes[i]);
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

 // ������ʾ�������,����б�Ҫ���԰�i����ʼֵ����С��,
 var elbt2 = tblEl.parentNode.tHead;
 rowEl = elbt2.rows[elbt2.rows.length - 1];
 // ��������ÿ�е���ʽ��
 for (i = 100; i < rowEl.cells.length; i++) 
 {
 cellEl = rowEl.cells[i];
 cellEl.className = cellEl.className.replace(colTest, "");
 // ������ʾ�������
 if (i == col)
 cellEl.className += " " + colClsNm;
 cellEl.className = normalizeString(cellEl.className);
 }
}

function align_fn()
{
   var resultTbody=document.getElementById("resultTbody");
   var strleft=document.getElementById("align_left").value;
   var strcenter=document.getElementById("align_center").value;
  
   var leftArray=new Array();
   var centerArray=new Array();
  
   if(strleft!='')
   {
	   leftArray=strleft.split(",");
	   for(j=0;j<leftArray.length;j++)
	   {
			   for(i=0;i<resultTbody.children.length;i++)
			   {
			   	   resultTbody.rows[i].cells[leftArray[j]-1].className="align_left"; 
			   }
	   }
   }

  if(strcenter!='')
  {
  	 centerArray=strcenter.split(",");
	    for(k=0;k<centerArray.length;k++)
	   {
		   for(i=0;i<resultTbody.children.length;i++)
		   {
		   	   resultTbody.rows[i].cells[centerArray[k]-1].className="align_center"; 
		   }
   }
 }

}
 // wangbt ��� �任�����еı���
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
    			 if(tr.children.item(j).innerHTML.indexOf("��")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="��";
    			 }
    		else if(tr.children.item(j).innerHTML.indexOf("��")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="��";
    			 }
    		else
    			tr.children.item(j).innerHTML+="��";
    		}
    		else
    		{
    			if(tr.children.item(j).innerHTML.indexOf("��")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
     			 }
    		  else if(tr.children.item(j).innerHTML.indexOf("��")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			 }
    			
    		}	
    	}

    }
}

function TitleControl()
{  // ��ͷ����
		 var resultHead=document.getElementById("resultHead");
		 
		 var collen=resultHead.rows[0].cells.length;
		 var tempHtml="<form name='form_col' topmargin='0'><table border=0 width='100%' cellspacing='0' cellpadding='0'>";
		 var j=0;
		 for(i=0;i<collen;i++)
		 {
		 	 if(resultHead.rows[0].cells[i].style.display=="block")
		 	 { 
		 	   tempHtml+="<tr><td><input type=checkbox name=selrow onclick=changeTitleView(this.value,'"+j+"') checked=checked value="+resultHead.rows[0].cells[i].innerText.replace("\r\n","")+" />"+resultHead.rows[0].cells[i].innerText+"</td></tr>";
		 	   j++;
		 	 }
		 }
		 tempHtml+="<tr><td align='center'><a href='#' onclick=\"javascript:document.getElementById('massage_box2').style.display='none'\">���رա�</a></td></tr>";
		 tempHtml+="</table></form>"
		 document.getElementById("colname").innerHTML=tempHtml

}

// ��ʾ�п���
function viewTitle()
{
	var div1=document.getElementById("coldiv");
	if(div1.style.display=='block')
	   div1.style.display='none';
	else
		 div1.style.display='block';
}

	
/*
�˲��ִ�����Щ���ӣ�ԭ�����ڱ���ģ�����漰����ͷ�ϲ�
�� �е���ʾ����
*/
function changeTitleView(coltext,colindex)
{   
 
 // ���Ʊ������ָ���չʾ���Ե�һ�и���ָ��Ϊ��λ
	var resultHead=document.getElementById("resultHead"); // ȡ�ı�ͷ
	var resultTbody=document.getElementById("resultTbody"); // ȡ�ı�ͷ
	var rowlen=resultHead.rows.length;       //ȡ��ԭʼ��ͷ������
	var collen=resultHead.rows[0].cells.length;// ȡ��ԭʼ��ͷ������	
	
	var idtemp="";
	var idtemptitle=",";
		  for(i=0;i<collen;i++)
		 {
		 	 // alert(resultHead.rows[0].cells[i].innerText.replace("��","").replace("��","").replace("\r\n","")==coltext);
		 	  if(resultHead.rows[0].cells[i].innerText.replace("��","").replace("��","").replace("\r\n","")==coltext)
		 	  {
		 	    idtemp+=resultTbody.rows[0].cells[i].id+",";

		 	    idtemptitle+=resultHead.rows[0].cells[i].id+",";
		 	  }
		 }
		 idtemp+=",";
		 idtemp=idtemp.replace(",,","");
		 var idtemp_2=idtemp.split(",");

		 // �������ݲ��ֵ����غ���ʾ����
		 for(j=0;j<idtemp_2.length;j++)
		 {   
		 	   for(k=0;k<eval(idtemp_2[j]).length;k++)
		 	   {
				 	   if(form_col.selrow[colindex].checked)
				 	   {
				 	     eval(eval("idtemp_2[j]")+"["+k+"]").style.display="block";
				 	    
					 	  } 	
				 	   else
				 	   {
				 	    eval(eval("idtemp_2[j]")+"["+k+"]").style.display="none";
		 	   		 }	
		 	   	}
		  }
		 //��ͷ�����غͱ�������ʵ�ַ�ʽ��һ����ͨ��������ͷ�����ҵ�Ԫ���������ַ������С�ԭ����ʾ����  
		 var celltemp="";
		  for(i=0;i<rowlen;i++)
		  {
		  	for(j=0;j<collen;j++)
			  {
			  	celltemp=","+resultHead.rows[i].cells[j].id+",";
			  	celltemp=celltemp.replace("��","").replace("��","").replace("\r\n","");
			  	if(idtemptitle.indexOf(celltemp)!=-1&&resultHead.rows[i].cells[j].flag=="0")
			  	{
			  		if(form_col.selrow[colindex].checked)
				 	   {
				 	     resultHead.rows[i].cells[j].style.display="block";
				 	    
					 	  } 	
				 	   else
				 	   {
				 	    resultHead.rows[i].cells[j].style.display="none";
		 	   		 }	
			  		
			  	}
			  }
		  }
		  //���б�ͷ�����غ���ʾ����
}
</script>
<%

String pid=request.getParameter("pid");
Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));

%>
<body>
<form action="" method="post" name="form1">
	<div id="hidden_div">
	<input type="hidden" id="allPageNum" name="allPageNum" value="">
	<input type="hidden" id="sql" name="sql" value="">
	<input type="hidden" name="filename" value="">
	<input type="hidden" name="order"  value="">
	<input type="hidden" name="title" value="">
	</div>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title">ά��ѡ��
		    	</div>
		    	<div id="dim" class="content">
         <table align="center" width="99%"  cellspacing="1" cellpadding="1" border="0">
					<%
					/*����Ӧ�ñ�Ų�ѯ�����еĲ�ѯ���� */
					String sql1="select formtype,dataformat, formname, formid ,sqlreg from NGBASS_REPORT_INPUT where pid="+pid+" order by order with ur";
					sqlca.execute(sql1);
					int i=0;
					String formtype="";
					String dataformat="";
					String formname="";
					String formid="";
					String sqlreg="";
					
					 String formIdStr=""; // ��id��ɵĴ�
					 
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
					          /* �޼�����ϵ�ĵ���ѡ���� */
					          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools2.getAreaCodeHtml(formid,"0","areacombo(1)")+"</td>");
					     }
					     else if(formid.equals("county"))
					     {
					          /* �޼�����ϵ�ĵ���ѡ���� */
					          out.print("<td width='10%' align='right' bgcolor='#D9ECF6'>"+formname+"</td><td width='15%' align='left' bgcolor='#EFF5FB'>"+QueryTools2.getCountyHtml(formid,"areacombo(2)")+"</td>");
					     }
					     else if(formid.equals("custmanager"))
					     {
					          /* �޼�����ϵ�ĵ���ѡ���� */
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
					<tr class="dim_row_submit" >
					<td align="right">
					<input type="button" class="form_button" value="��ѯ" onClick="doSubmit()">&nbsp;
					<input type="button" class="form_button" value="����" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
				 </div>
        	</div>
	    </td>
	  </tr>
	</table>
	<br>
			    		<div id="showSum"></div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title" >
		    		<table width="99%" border="0" cellspacing="0" cellpadding="0">
		    		<tr>
		    		<td valign="top">���չ��&nbsp;<img title="ѡ����ʾ/������" onclick="massage_box2.style.visibility='visible'" src="/hbbass/common2/image/columns.gif"></img>
		    		<img title="����˵��" onclick="mask.style.visibility='visible';massage_box.style.visibility='visible'"  src="/images/help/closeicon.gif"></img>
		    		</tr>
		    		</table>
		    	</div>
		    	<div id="grid" class="content"  style='width:100%;height:400;overflow:auto'>

		    		<div id="showResult"></div>
			    	<div id="title_div" style="display:none;" >
		          <table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
							<tr class="grid_title_blue">
							  <%
								   String[] reportStr=null;
								   String querySql="";
								   String report_name="";
								   String align_left="";
								   String align_center="";
								   String table_width="99";
								   String report_help="";
								   String sql2="select  * from NGBASS_REPORT where id="+pid+"   with ur";
					         sqlca.execute(sql2);
					         if(sqlca.next())
					         {
					            reportStr=sqlca.getString("REPORT_COLNAME").split(",");
					            querySql=sqlca.getString("REPORT_SQL");
					            align_left=sqlca.getString("align_left");
					            align_center=sqlca.getString("align_center");
					            report_name=sqlca.getString("report_name");
					            table_width=sqlca.getString("table_width");
					            report_help=sqlca.getString("report_help");
					         }
					         for(int m=0;m<reportStr.length;m++)   
					         { 
					             out.print("<td class=\"grid_title_cell\" id='colindex"+m+"' style='display:block'><A class='a2'  onclick=\"changeText('colindex"+m+"'); return sortTable('resultTbody',"+m+", true,0);\" href=\"#\" title='�����������'>"+reportStr[m]+"</a></td>");
					         }
								%>
							</tr>
						</table>
					</div>
	     </div>
	      	</div> 
	    </td>
	  </tr>
	</table>
	 <table width="80%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td  align="center">
			<input type="hidden" name="align_left" id="align_left" value="<%=align_left%>">
			<input type="hidden" name="align_center" id="align_center" value="<%=align_center%>">
			<input type="hidden" name="formIdStr" id="formIdStr" value="<%=formIdStr%>">
			<input type="hidden" name="querySql" id="querySql" value="<%=querySql%>">
			<input type="hidden" name="spanRowCount" size="40" value="0" />
		 </td>
	  </tr>
	</table>
	
</form>
 <%@ include file="/hbbass/common2/loadmask.htm"%>
</body>
</html>


<div id="massage_box2">
	<div class="massage">
		 <div class="header" onmousedown=MDown(massage_box2) style="cursor:move">
				<div style="display:inline; width:240px;position:absolute;">��ʾ�п���</div>
			  <span onClick="massage_box2.style.visibility='hidden'; mask.style.visibility='hidden'" style="float:right; display:inline; cursor:hand">��</span>
	   </div>
			<div id="colname"></div>
	</div>
</div>

<div id="massage_box">
	<div class="massage">
		 <div class="header" onmousedown=MDown(massage_box) style="cursor:move">
				<div style="display:inline; width:300px;position:absolute; ">&nbsp;<%=report_name%>����˵��</div>
			  <span onClick="massage_box.style.visibility='hidden'; mask.style.visibility='hidden'" style="float:right; display:inline; cursor:hand">��</span>
	   </div>
			<table width="96%" border="0" align="center" valign="middle">
	 		<tr>
	 			<td ><%=report_help%></td>
	 		</tr>
	 	</table>
	</div>
</div>
<div id="mask"></div>
<script>
	//  �޸�ҳ���title���Ա�����ʱ���ɲ�ͬ���ļ���
	document.title="<%=report_name%>";
	// �޸ı��Ŀ�ȣ�Ĭ�Ͽ��Ϊ99%����ѯ����϶�ʱ���������趨���
	document.getElementById("resultTable").width="<%=table_width%>%";
</script>


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
