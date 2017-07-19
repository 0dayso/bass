
/*
* @id ���򲿷�TBODY��id
* @col ����� 0 ��һ�У�1 �ڶ���
* @rev ��������
* @n  ����n�в������� 0 ���TBODY������1 ���һ�в�������ͨ�������һ��Ϊ�ϼ�ֵʱ���Բ������򣬵�ȻҲ���Խ�����ĺϼƲ��ַ���tbody����
* 20080418 �޸� wangbt
**/

function sortTable(id, col, rev,n) 
{

    // �������ı���ǽ��汨���ʽ���򲻽�������
	  if(form1.spanRowCount.value>0)
	  {
	  	alert("�Բ��𣡽��汨�?�ܽ�������");
	  	return;
	  }
	  


 //���id��ȡ��Ҫ����ı�����
 var tblEl = document.getElementById(id);

 if (tblEl.reverseSort == null) 
 {
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
		 for (j = i + 1; j < tblEl.rows.length-n; j++) 
		 {
				 testVal = getTextValue(tblEl.rows[j].cells[col]);
				 cmp = compareValues(minVal, testVal);
				
				 if (tblEl.reverseSort[col])
				 cmp = -cmp;
				 if (cmp == 0 && col != 1)
				 cmp = compareValues(getTextValue(tblEl.rows[minIdx].cells[1]),
				 getTextValue(tblEl.rows[j].cells[1]));
				 if (cmp > 0) 
				 {
					 minIdx = j;
					 minVal = testVal;
					}
 			}

		 if (minIdx > i) 
		 {
			 tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
			 tblEl.insertBefore(tmpEl, tblEl.rows[i]);
		 }
 }
 makePretty(tblEl, col,n);
 tblEl.style.display = oldDsply;
 setDimenseValue();
 return false;
}

if (document.ELEMENT_NODE == null) 
{
 document.ELEMENT_NODE = 1;
 document.TEXT_NODE = 3;
}

function getTextValue(el) 
{

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

function compareValues(v1, v2) 
{

	 var f1, f2;
	 f1 = parseFloat(v1);
	 f2 = parseFloat(v2);
	 if (!isNaN(f1) && !isNaN(f2)) 
	 {
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

function normalizeString(s) 
{

 s = s.replace(whtSpMult, " "); // Collapse any multiple whites space.
 s = s.replace(whtSpEnds, ""); // Remove leading or trailing white space.

 return s;
}

// ������ʽ������  result_v_1��result_v_2 Ϊ��˫�л�������ɫ,result_v_3Ϊ������������е���ɫ
var rowClsNm = "result_v_1";
var rowClsNm1 = "result_v_2";
var colClsNm = "result_v_3";

var rowTest = new RegExp(rowClsNm, "gi");
var rowTest1 = new RegExp(rowClsNm1, "gi");
var colTest = new RegExp(colClsNm, "gi");

function makePretty(tblEl, col,n) 
{

 var i, j;
 var rowEl, cellEl;
 for (i = 0; i < tblEl.rows.length-n; i++) 
 {
		 rowEl = tblEl.rows[i];
		 rowEl.className = rowEl.className.replace(rowTest, "");
		 if (i % 2 != 0)
		   rowEl.className= " " + rowClsNm;
		else
			rowEl.className= " " + rowClsNm1;


		 rowEl.className = normalizeString(rowEl.className);
		 for (j =1; j < tblEl.rows[i].cells.length; j++) 
		 {
				 cellEl = rowEl.cells[j];
				 cellEl.className = cellEl.className.replace(colTest, "");
				 if (j == col)
				 cellEl.className += " " + colClsNm;
				 cellEl.className = normalizeString(cellEl.className);
		 }
 }

		 // ������ʾ�������,����б�Ҫ���԰�i����ʼֵ����С��,
		 var el = tblEl.parentNode.tHead;
		 rowEl = el.rows[el.rows.length - 1];
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



// wangbt ��� �任�����еı���
function changeText(id)
{   
	  // �������ı���ǽ��汨���ʽ���򲻽�������
	  if(form1.spanRowCount.value>0)
	  {
	  	return;
	  }
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


/*  
 * ��ͷ�۵��ĺ��� �״���������Ӫ��ģ����
 * ����ʼ��չ����ʱ��,���ô˺����ڲ�ָ������
 */
function hideTitle(img,objId,msg)
{
	var obj = document.getElementById(objId);
	if(img.ShowFlag ==0)
	{
		img.src="/hb-bass-navigation/hbbass/images/search_show.gif";
		img.ShowFlag = 1;
		img.title="�������" + msg;
		obj.style.display = "";
	}
	else
	{
		img.src="/hb-bass-navigation/hbbass/images/search_hide.gif";
		img.ShowFlag = 0;
		img.title="�����ʾ" + msg;
		obj.style.display = "none";			
	}
}

/* ���ڲ�ѯ���С��200�еı�����Ϊcsv�ļ��ĺ���
 * �����fnameΪ��Ҫ������ļ���,���׺ ��: ͳ�Ʊ���.cv
 * ���ı�table��id����Ϊ resultTable
 * �״���������Ӫ��ģ����
 */
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
	form1.action="/hb-bass-navigation/hbbass/common/saveCsv.jsp?fname="+fname;
	form1.target="_top";
	form1.submit();
}


/*
*  ���������б� Ԫ�����һ���  ָ����ѡ������Ŀ������Ӻ�ɾ��
* @e1 Դ�б�
* @e2 Ŀ���б�
*/

function moveOption(e1, e2){
	try{
		for(var i=0;i<e1.options.length;i++){
			if(e1.options[i].selected){
				var e = e1.options[i];
				e2.options.add(new Option(e.text, e.value));
				e1.remove(i);
				i=i-1
			}
		}
		
	}
	catch(e){}
}

/*
*  ���������б� Ԫ�����һ�����һ���Բ���ȫ����Ӻ�ȫ��ɾ��
* @e1 Դ�б�
* @e2 Ŀ���б�
*/
function moveAllOption(e1, e2)
{
	try{
			for(var i=0;i<e1.options.length;i++)
			{ 
					var e = e1.options[i];
					e2.options.add(new Option(e.text, e.value));
					e1.remove(i);
					i=i-1
			}
  	}
	catch(e){}
}

/*
*  ���б��е�Ԫ�������ƶ�λ��
* @e �������б�
* 
*/
function moveDown(e)
{
	i = e.selectedIndex;
  if(i<0||i>=(e.options.length-1))
  	return;
  var o =	e.options[i];
  var o1=	e.options[i+1];
  e.options.remove(i);
  e.options.remove(i);
  e.add(o1,i);
  e.add(o,i+1);
}

/*
*  ���б��е�Ԫ�������ƶ�λ��
*  @e �������б�
* 
*/
function moveUp(e)
{
	i = e.selectedIndex;
  if(i<=0)
  	return;
  var o =	e.options[i];
	var o1=	e.options[i-1];
  e.options.remove(i);
  e.options.remove(i-1);
  e.add(o,i-1);
  e.add(o1,i);
}

// ȡ��ѡ���ά���б��ֵ
function getDimenseValue(geto)
{
	var allvalue = "";
	for(var i=0;i<geto.options.length;i++)
	{
		if(i==0)
		   allvalue += geto.options[i].value ;
		else
		   allvalue += ","+geto.options[i].value ;
	}
	return allvalue;
}
// ȡ��ѡ���ά���б�����
function getDimenseText(geto)
{
	var allvalue = "";
	for(var i=0;i<geto.options.length;i++)
	{
		if(i==0)
		   allvalue += geto.options[i].text ;
		else
		   allvalue += ","+geto.options[i].text ;
	}
	return allvalue;
}

// ȡ��ѡ���ָ���б��ֵ
function getValueValue(geto)
{
	var value_value="";
	var value_text="";	
	var p=0;
	for(var i=0;i<geto.length;i++)
	{
		if(geto[i].checked)
		{
			 if(p==0)
			 {
		    value_value+=geto[i].value;
		    value_text+=geto[i].value2;
		   }
		   else
		   {
		   	 value_value+=","+geto[i].value;
		   	 value_text+=","+geto[i].value2;
		   	}
		   p++;	
		}
		
	}
}

// ���� fieldset ��ʾ �ڲصĺ���
function tableVisibleOperation(imglist,tableList,urlmaxpic,urlminpic,istomaxstatus)
{
	if(null == imglist) return ;
	
	for (var i = 0; i < imglist.length; i++)
    {
		if(istomaxstatus){
			imglist[i].src = urlminpic;
			imglist[i].title="���𴰿�";

		}else{
			imglist[i].src = urlmaxpic;
			imglist[i].title="��չ����";
		}
    }


	for (var j = 0; j < tableList.length; j++)
    {
        if(istomaxstatus){
			tableList[j].style.display = "";
		}else{
			tableList[j].style.display = "none";
		}
    }
}
function tableOper(imgid,tableid){
	if(imgid == null || tableid == null) return ;

	picpath = '/hbbass/images/';
	urlmax='maximize.gif';
	uslmin='minimize.gif';
	
	var tableList2 = new Array();
	for (var i = 0; i < tableid.length; i++)
    {
		tableList2[i] = document.getElementById(tableid[i]);
	}

	var imglist = new Array();
	imglist[0] = document.getElementById(imgid);
	var img = imglist[0];
	if( img.src.indexOf(uslmin)  > -1 ){
		tableVisibleOperation(imglist,tableList2,picpath+urlmax,picpath+uslmin,false);
	}else if( img.src.indexOf(urlmax) > -1 ){
		tableVisibleOperation(imglist,tableList2,picpath+urlmax,picpath+uslmin,true);
	}else{
		alert("Error during window operation!");
	}

}

/*
*  �ϲ��еĺ��� �γɽ��汨��
* @objtab      �����ı����
* @startrow    �ϲ��Ŀ�ʼ��
* @rowlength   �ϲ����г���
* @startcol    �ϲ��Ŀ�ʼ��
* @collength   �ϲ����г���
*/

function spanRow(objtab,startrow,rowlength,startcol,collength)
{
	 var spanRowCount=0;  // ����ϲ��Ĵ���
   srcTab=objtab;
   var tabrow=srcTab.rows.length;
   var tabcol=srcTab.rows[0].cells.length;   
   rowlength=rowlength>tabrow?tabrow:rowlength;
   collength=collength>tabcol?tabcol:collength;
   var x,y;
   for(i=startcol;i<collength;i++)  // i �����ѭ��
   {
      cellvalue="" ;
 	 		for(j=startrow;j<rowlength;j++)  // j �����ѭ��
	 		{
	 			 flag=1;
	 			if(srcTab.rows[j].cells[i].innerText==cellvalue&&srcTab.rows[j].cells[i].innerText!="")
	 			{   
	 				if(i==startcol)
	 				{
	 				    srcTab.rows[x].cells[y].rowSpan=parseInt(srcTab.rows[x].cells[y].rowSpan)+1;
	 				    srcTab.rows[j].cells[i].style.display="none";
	 				    spanRowCount++;
	 			   }
	 			   else if(i>startcol)
	 			   	{
			 			   for(p=startcol;p<i;p++)
			 			   {
			 			   	if(srcTab.rows[j].cells[p].innerText==srcTab.rows[j-1].cells[p].innerText)
                     flag=flag*1;
			 			    else
			 			    	{
			 			    		flag=flag*0;
			 			    		cellvalue=srcTab.rows[j].cells[i].innerText;  
						 				x=j;
						 				y=i;
			 			    		break;
			 			    	}
			 			    }
			 			   if(flag=="1")
			 			   	{
			 			   		srcTab.rows[x].cells[y].rowSpan=parseInt(srcTab.rows[x].cells[y].rowSpan)+1;
			 				    srcTab.rows[j].cells[i].style.display="none";
			 				    spanRowCount++;
			 			  	}
	 			    }
	 			}
	 			else
	 			{
	 				cellvalue=srcTab.rows[j].cells[i].innerText;  
	 				x=j;
	 				y=i;
	 			}	
	 			
	 		}
   }
   form1.spanRowCount.value=spanRowCount;
} 


// 20080420 ��� wangbt
//  ��̬���ָ����ʾ���ã���ѡ���ά�ȸ���ͬʱ�������ÿ��checkbox��ֵ��һ��
function titlecon()
{
	document.form1.hid_dimense_id.value=getDimenseValue(document.form1.list2);    
  document.form1.hid_dimense_text.value=getDimenseText(document.form1.list2);
 
  var titleStr1=(document.form1.hid_dimense_text.value).split(",");
  var titleStr2=(document.form1.hid_dimense_text.value+","+document.form1.hid_value_text.value).split(",");
  var titleHtml="<table width='100%' border='0' cellspacing='2' cellpadding='0' id='result_view'>"
  for(i=titleStr1.length;i<titleStr2.length;i++)
  {
  	 titleHtml+="<tr><td><input type='checkbox' name='valueBox' value='"+i+"' onclick='changeHide(this.value)' checked/>"+titleStr2[i].toUpperCase().replace("<BR>","")+"</td></tr>";
   }
  titleHtml+="</table>";
  document.getElementById("value_view").innerHTML=titleHtml;
}
//  ���غ���ʾ ��ѯ����ָ����
function changeHide(hidid)
{ 
	s=eval("index"+hidid);
 for(i=0;i<s.length;i++)
 {
		 	 if(s[i].style.display == "none")
			{
				s[i].style.display ="";
			}
			else
			{
				s[i].style.display ="none";
			}
 	}
}	

//ȡ��ͼ��չʾ��ָ����
var value_value="";
function getViewValue(geto)
{
	value_value="";
	var p=0;
	for(var i=0;i<geto.length;i++)
	{
		if(geto[i].checked)
		{
			 if(p==0)
			 {
		    value_value="0,"+geto[i].value;
		   }
		   else
		   {
		   	 value_value+=","+geto[i].value;
		   	}
		   p++;	
		}
	}
	//alert(value_value);
}

//ȡ��ͼ��չʾ��ָ����
var dimense_value="";
function getViewDimense(geto)
{
	dimense_value="";
	var p=0;
	for(var i=0;i<geto.length;i++)
	{
		if(geto[i].checked)
		{
			 if(p==0)
			 {
		    dimense_value="0,"+geto[i].value;
		   }
		   else
		   {
		   	 dimense_value+=","+geto[i].value;
		   	}
		   p++;	
		}
	}
	//alert(dimense_value);
}
// ��ʱ����ά�ȷ���ʱ������ѯ������������У�����ͼ��չʾ
var stat_array= new Array() ;
function initData()
{
	stat_array = new Array();
	var s="";
	var resultTab=document.getElementById("resultTable");
	var len=resultTab.rows.length;
  if(len==1)
  {
      //alert("û�н��");
      return;	
  }	
	if(len>2)
	   len=len-1;  // �������һ���Ǻϼ��У�������ͼ��չʾ��

				for(var i=0;i<len;i++)
				{
						stat_array[i] = new Array();
						for(var j=0;j<resultTab.rows[i].cells.length;j++)
						{
							// �滻����ͷ�еĻس����� <br>
							s=resultTab.rows[i].cells[j].innerText.replace("\n","").replace("\r","");
							s=s.replace("(%)","");
							stat_array[i][j]=s;
						}
				}	
}

function setDimenseValue()
{
	var dimenseHtml="<table>";
	dimenseHtml+="<tr><td><input type='checkbox' name='chkall1' checked onclick='CheckAll1()' style='font-size: 9pt; color: #000000'><font color='blue'>ȫ��ѡ��/ȡ��</font></td></tr>";
	
	var resultTab=document.getElementById("resultTable");
	var len=resultTab.rows.length;
	
	if(len>2)
	   len=len-1;  // �������һ���Ǻϼ��У�������ͼ��չʾ��
	if(len>20)  
	   len=20;  //  ������ά�ȵ�ֵ̫�࣬ͼ�ο��������Σ��������ֻ��ʾǰ20��ά��ֵ 
		  if(form1.spanRowCount.value==0)
	  {
				for(var i=0;i<len;i++)
				{
					if(i>0)
					{
					 dimenseHtml+="<tr><td><input type='checkbox' name='viewDimenseBox' value="+i+"  onclick='getViewDimense(this.form.viewDimenseBox)'  checked/>"+resultTab.rows[i].cells[0].innerText.replace("\n","").replace("\r","")+"</td></tr>";
					}
				}
		}
	 dimenseHtml+="</table>";
	 document.getElementById("dimenseViewArea").innerHTML=dimenseHtml;
}

function CheckAll1()
{
 var len = form1.viewDimenseBox.length;
 if (typeof(len)!="undefined")//����ѡ���ж��ʱִ��
 {
   for(var i=0;i<len;i++)
   {
		 		  var e = form1.viewDimenseBox[i];
		    	e.checked = form1.chkall1.checked;
    }	
  }
  else 
  {
  	     form1.viewDimenseBox.checked=form1.chkall1.checked;
  }
}

function CheckAll2()
{
 var len = form1.viewValueBox.length;
 if (typeof(len)!="undefined")//����ѡ���ж��ʱִ��
 {
   for(var i=0;i<len;i++)
   {
		 		  var e = form1.viewValueBox[i];
		    	e.checked = form1.chkall2.checked;
    }	
  }
  else 
  {
  	     form1.viewValueBox.checked=form1.chkall2.checked;
  }
}

function getImageBody(imageType)
{
	var caption="";				// ��дͼ�δ���� ��Ϊ��
	var xAxisName="";						//��дX�� ��Ϊ��
	var yAxisName="";						// ��дY�� ��Ϊ��
	var subcaption="";   // ��дͼ���ӱ��� ��Ϊ��
	var numberPrefix="";           // ǰ׺ ��Ϊ�� 
	var numberSuffix="";           // ��׺ ��Ϊ�� 
	var imageHead="";    // ��ȡͼƬ��ͷ ͼƬ���ò���

    getViewValue(form1.viewValueBox);  // ȡ��ѡ��ķ���ָ���ֵ
    getViewDimense(form1.viewDimenseBox);  // ȡ��ѡ��ķ���ά�ȵ�ֵ
    
	  var imageBody="";   // ��ȡͼƬ���
	  var selectValueIndex=value_value.split(",");
	  var selectDimenseIndex=dimense_value.split(",");
	  var Color=new Array("ff00ff","ffA6A6","ff0000","ffaeff","0000ff","84aeff","00ffff","a6aeff","00ff00","b5ffb5","ffff00","ffffb5","C0C0C0","800000","808000","008000","008080","000080","800080")  ;
    var len=stat_array.length;

		 // ���ڵ����е�ͼ��ͼ����ʾ��һ��ѡ�е�ָ��
		 if(form1.direct.checked)
		 {
		 	   if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D"||imageType=="FCF_Column2D"||imageType=="FCF_Bar2D"||imageType=="FCF_Line")
			   	{ 
			   		// ��ͼ Բ��ͼ
							if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
							{
								imageHead="<graph showNames='1' caption='"+stat_array[selectDimenseIndex[1]][0]+"' decimalPrecision='2'  showPercentageValues='0'  baseFontSize='12' formatNumberScale='0' showPercentageInLabel='1' pieYScale='75' bgColor='ffffff' pieRadius='130' hoverCapSepChar=':' >";
							}
							else if(imageType=="FCF_Column2D")
							{
								imageHead="<graph caption='"+stat_array[selectDimenseIndex[1]][0]+"' xAxisName='' yAxisName='' decimalPrecision='0' formatNumberScale='0'  chartRightMargin='80'  baseFontSize='12' hoverCapSepChar=':' showAlternateHGridColor='1'  >";
							}
							else if(imageType=="FCF_Bar2D")
							{
								imageHead="<graph caption='"+stat_array[selectDimenseIndex[1]][0]+"'  xAxisName='"+stat_array[0][selectValueIndex[0]]+"' yAxisName='"+yAxisName+"' baseFontSize='12' showAlternateVGridColor='1' alternateVGridAlpha='10' alternateVGridColor='AFD8F8' numDivLines='6' decimalPrecision='0' canvasBorderThickness='1' canvasBorderColor='114B78' baseFontColor='114B78' hoverCapBorderColor='114B78' hoverCapBgColor='E7EFF6'>";
							}
							// ������ͼ
							else if(imageType=="FCF_Line")
							{
								imageHead="<graph  caption='"+stat_array[selectDimenseIndex[1]][0]+"'  xAxisName=''  baseFontSize='12' hoverCapSepChar=':'  decimalPrecision='0' formatNumberScale='0'  numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showNames='1' showValues='1' rotateNames='0'  showAlternateHGridColor='1' AlternateHGridColor='ff5904' divLineColor='ff5904' divLineAlpha='20' alternateHGridAlpha='5'>";
							}
							for(i=1;i<selectValueIndex.length;i++)
			        {
				   		imageBody+="<set name='"+stat_array[0][selectValueIndex[i]]+"' value='"+stat_array[selectDimenseIndex[1]][selectValueIndex[i]]+"' color='"+Color[i*2%19]+"'/>"  
				   	  }
			   	}
			   	else  if(imageType=="FCF_MSColumn2D"||imageType=="FCF_StackedColumn2D"||imageType=="FCF_MSBar2D"||imageType=="FCF_StackedBar2D"||imageType=="FCF_MSLine")
			   	{
			   		    // ��׳��״ͼ
			   		    if(imageType=="FCF_MSColumn2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"'  hovercapbg='DEDEBE' hovercapborder='889E6D' formatNumberScale='0' rotateNames='0'  numdivlines='9' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"'  baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// �ѻ���״ͼ
								else if(imageType=="FCF_StackedColumn2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' decimalPrecision='0' rotateNames='1' numDivLines='3' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showValues='1' formatNumberScale='0'  baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// ��׳����ͼ
								else if(imageType=="FCF_MSBar2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' hovercapbg='FFFFFF' divLineColor='999999' divLineAlpha='80' numdivlines='5' decimalPrecision='0' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' formatNumberScale='0'  baseFontSize='12'  hoverCapSepChar=':' showAlternateHGridColor='1'  >";
								}
								// �ѻ�����ͼ
								else if(imageType=="FCF_StackedBar2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' decimalPrecision='0' numDivLines='3' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showValues='1' baseFontSize='12' formatNumberScale='1'  hoverCapSepChar=':' showAlternateHGridColor='1'  >";
								}
								// ������ͼ
								else if(imageType=="FCF_MSLine")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' hovercapbg='FFECAA' hovercapborder='F47E00' formatNumberScale='0' decimalPrecision='0' showNames='1' showValues='1' numdivlines='3' numVdivlines='0' rotateNames='1'  baseFontSize='12'  hoverCapSepChar=':'  >";
								}
								imageBody+="<categories font='Arial' fontSize='12' fontColor='000000'>";
					   		for(i=1;i<selectDimenseIndex.length;i++)
				        {
					   		imageBody+="<category name='"+(stat_array[selectDimenseIndex[i]][0])+"'/>"  
					   	  }
					   	  imageBody+="</categories>";
					   	  
					   	   for(i=1;i<selectValueIndex.length;i++)
					   	  {
					   	  	imageBody+="<dataset seriesname='"+(stat_array[0][selectValueIndex[i]])+"' fontSize='12'  color='"+Color[i*2%19]+"'>";
					   	  	for(j=1;j<selectDimenseIndex.length;j++)
					        {
					        	imageBody+="<set value='"+stat_array[selectDimenseIndex[j]][selectValueIndex[i]]+"' />"  
					        }
					        imageBody+="</dataset>";
					   	  }
				   	  
			   	}	
		 	}
		 	else
		 {		
		   	  if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D"||imageType=="FCF_Column2D"||imageType=="FCF_Bar2D"||imageType=="FCF_Line")
			   	{ 
			   			// ��ͼ Բ��ͼ
							if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
							{
								imageHead="<graph showNames='1' caption='"+stat_array[0][selectValueIndex[1]]+"' decimalPrecision='2'  showPercentageValues='0'  baseFontSize='12' formatNumberScale='0' showPercentageInLabel='1' pieYScale='75' bgColor='ffffff' pieRadius='130' hoverCapSepChar=':' >";
							}
							else if(imageType=="FCF_Column2D")
							{
								imageHead="<graph caption='"+stat_array[0][selectValueIndex[1]]+"' xAxisName='"+stat_array[0][selectValueIndex[0]]+"' yAxisName='"+yAxisName+"' decimalPrecision='0' formatNumberScale='0'  chartRightMargin='80'  bgColor='ffffff' baseFontSize='12' hoverCapSepChar=':' showAlternateHGridColor='1'  >";
							}
							else if(imageType=="FCF_Bar2D")
							{
								imageHead="<graph caption='"+stat_array[0][selectValueIndex[1]]+"'  xAxisName='"+stat_array[0][selectValueIndex[0]]+"' yAxisName='"+yAxisName+"' baseFontSize='12' showAlternateVGridColor='1' alternateVGridAlpha='10' alternateVGridColor='AFD8F8' numDivLines='6' decimalPrecision='0' canvasBorderThickness='1' canvasBorderColor='114B78' baseFontColor='114B78' hoverCapBorderColor='114B78' hoverCapBgColor='E7EFF6'>";
							}
							// ������ͼ
							else if(imageType=="FCF_Line")
							{
								imageHead="<graph  caption='"+stat_array[0][selectValueIndex[1]]+"'   xAxisName='"+stat_array[0][selectValueIndex[0]]+"'  baseFontSize='12' hoverCapSepChar=':'  decimalPrecision='0' formatNumberScale='0'  numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showNames='1' showValues='1'  showAlternateHGridColor='1' AlternateHGridColor='ff5904' divLineColor='ff5904' divLineAlpha='20' alternateHGridAlpha='5'>";
							}
				   		for(i=1;i<selectDimenseIndex.length;i++)
			        {
				   		imageBody+="<set name='"+stat_array[selectDimenseIndex[i]][selectDimenseIndex[0]]+"' value='"+stat_array[selectDimenseIndex[i]][selectValueIndex[1]]+"'/>"  
				   	  }
				   	  
				   	  	
			    } 
			    else  if(imageType=="FCF_MSColumn2D"||imageType=="FCF_StackedColumn2D"||imageType=="FCF_MSBar2D"||imageType=="FCF_StackedBar2D"||imageType=="FCF_MSLine")
			   	{ 
								 // ��׳��״ͼ
							  if(imageType=="FCF_MSColumn2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"'  hovercapbg='DEDEBE' hovercapborder='889E6D' formatNumberScale='0' rotateNames='0'  numdivlines='9' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"'  baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// �ѻ���״ͼ
								else if(imageType=="FCF_StackedColumn2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' decimalPrecision='0' rotateNames='1' numDivLines='3' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showValues='1' formatNumberScale='0'  baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// ��׳����ͼ
								else if(imageType=="FCF_MSBar2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' hovercapbg='FFFFFF' divLineColor='999999' divLineAlpha='80' numdivlines='5' decimalPrecision='2' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' formatNumberScale='0'  baseFontSize='12'  hoverCapSepChar=':' showAlternateHGridColor='1'  >";
								}
								// �ѻ�����ͼ
								else if(imageType=="FCF_StackedBar2D")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"' xAxisName='"+xAxisName+"' yAxisName='"+yAxisName+"' decimalPrecision='1' numDivLines='3' numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showValues='1' baseFontSize='12' formatNumberScale='1'  hoverCapSepChar=':' showAlternateHGridColor='1'  >";
								}
								// ������ͼ
								else if(imageType=="FCF_MSLine")
								{
									imageHead="<graph caption='"+caption+"' subcaption='"+subcaption+"'  xAxisName='"+stat_array[0][selectValueIndex[0]]+"'  baseFontSize='12' hoverCapSepChar=':'  decimalPrecision='0' rotateNames='1' formatNumberScale='0'  numberPrefix='"+numberPrefix+"' numberSuffix='"+numberSuffix+"' showNames='1' showValues='1'  showAlternateHGridColor='1' AlternateHGridColor='ff5904' divLineColor='ff5904' divLineAlpha='20' alternateHGridAlpha='5'>";
									// imageHead="<graph hovercapbg='FFECAA' hovercapborder='F47E00'  numdivlines='3' numVdivlines='0'  >";
								}
								
			   		imageBody+="<categories font='Arial' fontSize='12' fontColor='000000'>";
			   		for(i=1;i<selectValueIndex.length;i++)
		        {
			   		imageBody+="<category name='"+(stat_array[0][selectValueIndex[i]])+"'/>"  
			   	  }
			   	  imageBody+="</categories>";
			   	 for(i=1;i<selectDimenseIndex.length;i++)
			   	  {
			   	  	imageBody+="<dataset seriesname='"+(stat_array[selectDimenseIndex[i]][0])+"' fontSize='12'  color='"+Color[i*2%19]+"'>";
			   	  	for(j=1;j<selectValueIndex.length;j++)
			        {
			        	imageBody+="<set value='"+stat_array[selectDimenseIndex[i]][selectValueIndex[j]]+"' />"  
			        }
			        imageBody+="</dataset>";
			   	  }
			    }	
	  }
	   return imageHead+imageBody;
}

// ���ͼ��ѡ���� ���Ƿ����Ƚ���ݡ���ͼ��ˢ�°�ť
function writeImageType()
{
  var html="ͼ�����ͣ�<select name='imageType' >"+
           "<option value='FCF_Pie3D'>��ͼ</option>"+
           "<option value='FCF_Doughnut2D'>Բ��ͼ</option> "+
           "<option value='FCF_Column2D'>��״ͼ</option>"+
           "<option value='FCF_Bar2D'>����ͼ</option>"+
           "<option value='FCF_Line'>������ͼ</option>"+
           "<option value='FCF_MSColumn2D'>��״��״ͼ</option>"+
           "<option value='FCF_StackedColumn2D'>�ѻ���״ͼ</option>"+
           "<option value='FCF_MSBar2D'>��״����ͼ</option>"+
           "<option value='FCF_StackedBar2D'>�ѻ�����ͼ</option>"+
           "<option value='FCF_MSLine'>������ͼ</option>"+
           "</select>"+
           " ����Ƚϣ�<input type='checkbox' name='direct'>"+
           "<input type='button' name='freshImage' value='ˢ��' onclick='drawImage()'>";
   document.write(html);
                  
}


function drawImage()
{
   initData();
    
	 var imageHtml="";
	 var imageType=document.form1.imageType.value;
	 if(document.form1.list2.length>1)
	 {
	     imageHtml="��ѡ��һ��ά�Ƚ��з�����"; 
	     document.getElementById("showImageArea").innerHTML=imageHtml;
	     return;	
	 }
	 if(stat_array.length==0)
	 {
	     imageHtml="û�з��Ҫ������"; 
	     document.getElementById("showImageArea").innerHTML=imageHtml;
	     return;	
	 }
	 if(stat_array.length==2)
	 {
	     imageHtml="������ͼ����ʾ"; 
	     document.getElementById("showImageArea").innerHTML=imageHtml;
	     return;	
	 }

	 	imageHtml=getImageBody(imageType)+"</graph>";
	 	
	 	var chart = new FusionCharts("/hb-bass-navigation/hbbass/common/flash/"+imageType+".swf", "ChartId", "600", "400");
		chart.setDataXML(imageHtml);		   
		chart.render("showImageArea");
	 
}

function callBackDo()
{
	var viewBody=document.getElementById("resultTable");
			
			// ����ϲ����г���
			var collen=document.form1.list2.length;
			spanRow(viewBody,0,1000,0,collen);
			
			document.getElementById("showImageArea").innerHTML="";
			if(collen==1&&viewBody.rows.length>2)
			{
			 document.getElementById("imageResultArea").style.display="block";
			 setDimenseValue();	
			 drawImage();	
			}
			else
			{
			document.getElementById("imageResultArea").style.display="none";
			drawImage();
			setDimenseValue();	
			}	
}

//  20080515 wangbt �ٴ����� �Զ��屨��
function spanHead(objtab,rowlength)
{
	 srcTab=objtab;
 
   var rowlength=rowlength;
   var collength=srcTab.rows[0].cells.length;
   
   var x,y;
   
   for(j=0;j<rowlength;j++)
   {
   	  cellvalue="" ;
 	 		for(i=0;i<collength;i++)
	 		{
	 				 	flag=1;
			 			if(srcTab.rows[j].cells[i].innerText==cellvalue&&srcTab.rows[j].cells[i].innerText!="")
			 			{ 
			 				  if(j==0)
				 				 {   
				 				    srcTab.rows[x].cells[y].colSpan=parseInt(srcTab.rows[x].cells[y].colSpan)+1;
				 				    srcTab.rows[j].cells[i].style.display="none";
				 			   }
				 			   else if(j>0)
				 			   {
				 			   	  for(p=0;p<j;p++) 
			 		          {
			 		          	
			 		          		if(srcTab.rows[p].cells[i].innerText==srcTab.rows[p].cells[i-1].innerText)
					                    flag=flag*1;
								 		    else
								 		    	{
								 		    		flag=flag*0;
								 		    		cellvalue=srcTab.rows[j].cells[i].innerText;  
										 				x=j;
										 				y=i;
								 		    		break;
								 		    	} 
			 		    	
			 		          	}
						 		   if(flag=="1")
						 		   	{
						 		   		srcTab.rows[x].cells[y].colSpan=parseInt(srcTab.rows[x].cells[y].colSpan)+1;
						 		   		srcTab.rows[j].cells[i].style.display="none";
						 		  	}
				 			   }
			 			}
			 			else
			 			{
			 				cellvalue=srcTab.rows[j].cells[i].innerText;  
			 				x=j;
			 				y=i;
			 				
			 			}	   
	 		}
   }
   // �ϲ���ͷ(��)
  for(i=0;i<collength;i++)  
  {

  	  cellvalue="" ;
 	 		for(j=0;j<rowlength;j++) 
	 		{
         
		 			if(srcTab.rows[j].cells[i].innerText==cellvalue&&srcTab.rows[j].cells[i].innerText!="")
		 			{   
		 				��
			 				srcTab.rows[x].cells[y].rowSpan=parseInt(srcTab.rows[x].cells[y].rowSpan)+1;
			 				srcTab.rows[x].cells[y].height=parseInt(srcTab.rows[x].cells[y].height)+parseInt(srcTab.rows[j].cells[i].height);
	 				    srcTab.rows[j].cells[i].style.display="none";
		 			   
		 			}
		 			else
		 			{
		 				cellvalue=srcTab.rows[j].cells[i].innerText;  
		 				x=j;
		 				y=i;
		 				
		 			}	
		 			
	 		}
  }
}