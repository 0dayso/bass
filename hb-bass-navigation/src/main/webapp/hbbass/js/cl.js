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



// ���� fieldset ��ʾ �ڲصĺ���
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

//*************************  �������ʼ��**********************

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
 if(tblEl.childNodes.length>50)
 {
 	alert("�Բ�����Ҫ����ļ�¼���ܳ��������");
 	return;
 	}
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
 // ���������������ά���б���
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


//*************************������������**********************

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
   if(tabrow>200)
   {
   	alert("��ѯ����󣬲����ڽ��汨����ʾ!");
   	return;
   	}
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

// �ص�����
function callBackDo()
{
	����var viewBody=document.getElementById("resultTable");
			
			// ����ϲ����г���
			var collen=document.form1.list2.length;
			spanRow(viewBody,0,1000,0,collen);
			
			document.getElementById("showImageArea").innerHTML="";
			if(collen==1)
			{
			 document.getElementById("imageResultArea").style.display="block";
			 setDimenseValue();	
			 setValueValue();
			 drawImage();
			}
			else
			{
				document.getElementById("imageResultArea").style.display="none";
			setDimenseValue();	
			setValueValue();
			//drawImage();
			}	
			
			var s=getViewDimense(form1.viewDimenseBox);
			
}

//��װ��ѡ���ֵ
// ����?���硡form1.viewDimenseBox
function getViewDimense(geto)
{
	dimense_value="";
	var p=0;
	var len=geto.length;
	if (typeof(len)!="undefined")//����ѡ���ж��ʱִ��
	 {
			for(var i=0;i<len;i++)
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
	 }
		else 
		{
			     dimense_value="0,"+geto.value;
		}
		return dimense_value;
}
// �������ı�񡡶�̬���ǰ������ά��ֵ���з��� Ҳ���Ǳ��ĵ�һ�е�ǰ�����е�ֵ
function setDimenseValue()
{
	var dimenseHtml="<table>";
	dimenseHtml+="<tr><td><input type='checkbox' name='chkall1' checked onclick='CheckAll(this.form.viewDimenseBox,this.form.chkall1)' style='font-size: 9pt; color: #000000'><font color='blue'>ȫ��ѡ��/ȡ��</font></td></tr>";
	
	var resultTab=document.getElementById("resultTable");
	var len=resultTab.rows.length;
��	if(len>20)  
		{ 
			alert("���ά��ֵ��ֻ࣬�ܶ�ǰ������ά��ֵ���з�����");
	   	len=20;  //  ������ά�ȵ�ֵ̫�࣬ͼ�ο��������Σ��������ֻ��ʾǰ20��ά��ֵ 
	 	}
		 if(form1.spanRowCount.value==0)
	  {
				for(var i=1;i<len;i++)
				{
					 dimenseHtml+="<tr><td><input type='checkbox' name='viewDimenseBox' value="+i+"  checked/>"+resultTab.rows[i].cells[0].innerText.replace("\n","").replace("\r","")+"</td></tr>";
				}
		}
	 dimenseHtml+="</table>";
	 document.getElementById("dimenseViewArea").innerHTML=dimenseHtml;
	 
	 initData();// �����ά��ֵ�󡡽����������ݴ���������У���ʵ���Կ�ʼ�ʹ���������У����ά�Ⱥ�ָ��ֵʱ�ٴ�������������������ܻ��Щ
}

// �������ı�񡡶�̬���ǰ������ά��ֵ���з��� Ҳ���Ǳ��ĵ�һ�е�ǰ�����е�ֵ
function setValueValue()
{
	var dimenseHtml="<table>";
	dimenseHtml+="<tr><td><input type='checkbox' name='chkall2' checked onclick='CheckAll(this.form.viewValueBox,this.form.chkall2)' style='font-size: 9pt; color: #000000'><font color='blue'>ȫ��ѡ��/ȡ��</font></td></tr>";
	
	var resultTab=document.getElementById("resultTable");
	var len1=form1.list2.length;
	var len2=resultTab.rows[0].cells.length;
��	if(len1>31)  
		{ 
			alert("����ָ���࣬Ϊ�˲�Ӱ�������������Ӧ��һ�η�����ָ�겻����31����");
	   	len1=31;  //  ������ά�ȵ�ֵ̫�࣬ͼ�ο��������Σ��������ֻ��ʾǰ20��ά��ֵ 
	 	}
		 if(form1.spanRowCount.value==0)
	  {
				for(var i=len1;i<len2;i++)
				{
					 dimenseHtml+="<tr><td><input type='checkbox' name='viewValueBox' value="+i+"  checked/>"+resultTab.rows[0].cells[i].innerText.replace("\n","").replace("\r","")+"</td></tr>";
				}
		}
	 dimenseHtml+="</table>"; 
	 document.getElementById("valueViewArea").innerHTML=dimenseHtml;
}
// ��formname����ѡ�����óɺ͡�chbox��һ�£�
function CheckAll(formname,chbox)
{
 var len = formname.length;
 if (typeof(len)!="undefined")//����ѡ���ж��ʱִ��
 {
   for(var i=0;i<len;i++)
   {
		 		  var e = formname[i];
		    	e.checked = chbox.checked;
    }	
  }
  else 
  {
  	     formname.checked=chbox.checked;
  }
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
      return;	
  }	

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

//�����л�ͼ
function drawImage()
{
   
    
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

	 	imageHtml=getImageBody()+"</graph>";
	 	
	 	var chart = new FusionCharts("/hb-bass-navigation/hbbass/common/flash/"+imageType+".swf", "ChartId", "600", "400");
		chart.setDataXML(imageHtml);		   
		chart.render("showImageArea");
	 
}


function getImageBody()
{
	var imageType=document.form1.imageType.value;
  var caption="";				// ��дͼ�δ���� ��Ϊ��
	var xAxisName="";						//��дX�� ��Ϊ��
	var imageHead="";    // ��ȡͼƬ��ͷ ͼƬ���ò���

    var value_value=getViewDimense(form1.viewValueBox);  
    var dimense_value=getViewDimense(form1.viewDimenseBox);

    var imageBody="";   // ��ȡͼƬ���
	  var selectValueIndex=value_value.split(",");
	  var selectDimenseIndex=dimense_value.split(",");
	  var Color=new Array("ff00ff","ffA6A6","ff0000","ffaeff","0000ff","84aeff","00ffff","a6aeff","00ff00","b5ffb5","ffff00","ffffb5","C0C0C0","800000","808000","008000","008080","000080","800080")  ;
    var len=stat_array.length;
    
	   // ���ڵ����е�ͼ��ͼ����ʾ��һ��ѡ�е�ָ��
		 if(form1.direct.checked)
		 {
		 	   if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
			   	{ 
			   		// ��ͼ Բ��ͼ
							if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
							{
								imageHead="<graph showNames='1' caption='"+stat_array[selectDimenseIndex[1]][0]+"' decimalPrecision='2'  showPercentageValues='0'  baseFontSize='12' formatNumberScale='0' showPercentageInLabel='1' pieYScale='75' bgColor='ffffff' pieRadius='130' hoverCapSepChar=':' >";
							}
							
							for(i=1;i<selectValueIndex.length;i++)
			        {
				   		imageBody+="<set name='"+stat_array[0][selectValueIndex[i]]+"' value='"+stat_array[selectDimenseIndex[1]][selectValueIndex[i]]+"' color='"+Color[i*2%19]+"'/>"  
				   	  }
			   	}
			   	else  if(imageType=="FCF_MSColumn2D"||imageType=="FCF_MSLine")
			   	{
			   		    // ��׳��״ͼ
			   		    if(imageType=="FCF_MSColumn2D")
								{
									imageHead="<graph caption='"+caption+"'     hovercapbg='DEDEBE' hovercapborder='889E6D' formatNumberScale='0' rotateNames='0'  numdivlines='9' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC'    baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// ������ͼ
								else if(imageType=="FCF_MSLine")
								{
									imageHead="<graph caption='"+caption+"'  hovercapbg='FFECAA' hovercapborder='F47E00' formatNumberScale='0' decimalPrecision='0' showNames='1' showValues='1' numdivlines='3' numVdivlines='0' rotateNames='1'  baseFontSize='12'  hoverCapSepChar=':'  >";
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
		   	  if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
			   	{ 
			   			// ��ͼ Բ��ͼ
							if(imageType=="FCF_Pie3D"||imageType=="FCF_Doughnut2D")
							{
								imageHead="<graph showNames='1' caption='"+stat_array[0][selectValueIndex[1]]+"' decimalPrecision='2'  showPercentageValues='0'  baseFontSize='12' formatNumberScale='0' showPercentageInLabel='1' pieYScale='75' bgColor='ffffff' pieRadius='130' hoverCapSepChar=':' >";
							}
				   		for(i=1;i<selectDimenseIndex.length;i++)
			        {
				   		imageBody+="<set name='"+stat_array[selectDimenseIndex[i]][selectDimenseIndex[0]]+"' value='"+stat_array[selectDimenseIndex[i]][selectValueIndex[1]]+"'/>"  
				   	  }
			    } 
			    else  if(imageType=="FCF_MSColumn2D"||imageType=="FCF_MSLine")
			   	{ 
								 // ��׳��״ͼ
							  if(imageType=="FCF_MSColumn2D")
								{
									imageHead="<graph caption='"+caption+"'     hovercapbg='DEDEBE' hovercapborder='889E6D' formatNumberScale='0' rotateNames='0'  numdivlines='9' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC'    baseFontSize='12' hoverCapSepChar=':'  >";
								}
								// ������ͼ
								else if(imageType=="FCF_MSLine")
								{
									imageHead="<graph caption='"+caption+"'   xAxisName='"+stat_array[0][selectValueIndex[0]]+"'  baseFontSize='12' hoverCapSepChar=':'  decimalPrecision='0' rotateNames='1' formatNumberScale='0'    showNames='1' showValues='1'  showAlternateHGridColor='1' AlternateHGridColor='ff5904' divLineColor='ff5904' divLineAlpha='20' alternateHGridAlpha='5'>";
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