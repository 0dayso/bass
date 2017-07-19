String.prototype.replaceAll  = function(s1,s2){  
s1 = s1.replace(/\(/gi,"\\(").replace(/\)/gi,"\\)"); 
 
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

//��ѯ���ؽ���Ļص�����
function doCallBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			var responseText=xmlHttp.responseText;
      alert(responseText);
      form1.name.className="unselectCss";
      form1.dura.className="unselectCss";
      form1.alarm.className="unselectCss";
      document.getElementById("list2").className="unselectCss";
      history.go(0);
		}
	}
}

function setFormName(selectedIndex)
{
	var text1=form1.formList.options[selectedIndex].text;
	var text2="";
	var pos=text1.indexOf(":");
	if(pos>-1)
	{
		text2=text1.substring(pos+1);
	  text1=text1.substring(0,pos);  
	    	
	}
	form1.formName.value=text1;
	form1.dataformat.value=text2;
	form1.formTagName.value=form1.formList.options[selectedIndex].value;
	form1.formId.value=form1.formList.options[selectedIndex].value;
	form1.sqlreg.value="#"+form1.formList.options[selectedIndex].value;
}

function freshSelect(sleectValue,formName)
{
	var sql="select TAGNAME col1,NAME col2  from DIM_NGBASS_FORM_TYPE where 1=1 and formtype='"+sleectValue+"' order by order ";
  xmlHttp = createRequest();
	xmlHttp.onreadystatechange=function()
	{
			if(xmlHttp.readyState == 4)
			{
				if(xmlHttp.status == 200)
				{
					var responseText=xmlHttp.responseText;
		      freshSelectExecute(formName,responseText)  ;
		    }
			}
	} 
	xmlHttp.open("POST","freshSelect_db.jsp",true);
 	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
 	var str="sql="+sql;
	str=encodeURI(str,"UTF-8");
	xmlHttp.send(str); 
}

function  freshSelectExecute(formName,responseText)
{
  var formName=document.getElementById(formName);
  for(var i=formName.options.length;i>=1;i--)
	{
		formName.options.remove(i);
	}
	var str1=responseText;
	var arr1=str1.split("|");
	for(var i=0;i<arr1.length;i++)
	{
	 	var OptionTmp = document.createElement('OPTION');
    OptionTmp.value=arr1[i].split("@")[0];
  	OptionTmp.text=arr1[i].split("@")[1];
		formName.options.add(OptionTmp);
	}

}
/* ����һ����ѯ���� */
function addquery()
{
  
   if(form1.formName.value=="")
	 {
	 	alert("����д�?��ƣ�");
	 	form1.formName.focus();
	 	return;
	 	}
	 	if(form1.formId.value=="")
	 {
	 	alert("����д�?ID��ƣ�");
	 	form1.formId.focus();
	 	return;
	 	}
	 	/*
	 	if(form1.sqlreg.value=="")
	 {
	 	alert("����дsql����");
	 	form1.sqlreg.focus();
	 	return;
	 	}
	 	if(form1.sqlreg.value.indexOf("#")<1)
	 	{
	 	    alert("����sql�����﷨��");
			 	form1.sqlreg.focus();
			 	return;
	 	}
	 	*/
	 document.form1.addform.disabled=true;
	 document.form1.action="queryConfig.jsp?oper=addquery";
	 document.form1.submit(); 
}

function savequery()
{
	 if(form1.formTagName.value=="")
	 {
	 	alert("��ѡ��?���ͣ�");
	 	form1.formName.focus();
	 	return;
	 	}
	 if(form1.formName.value=="")
	 {
	 	alert("����д�?��ƣ�");
	 	form1.formName.focus();
	 	return;
	 	}
	 	if(form1.formId.value=="")
	 {
	 	alert("����д�?ID��ƣ�");
	 	form1.formId.focus();
	 	return;
	 	}
	 	/*
	 	if(form1.sqlreg.value=="")
	 {
	 	alert("����дsql����");
	 	form1.sqlreg.focus();
	 	return;
	 	}
	 	if(form1.sqlreg.value.indexOf("#")<1)
	 	{
	 	    alert("����sql�����﷨��");
			 	form1.sqlreg.focus();
			 	return;
	 	}
	 	*/
	 document.form1.modi2.disabled=true;
	 document.form1.action="queryConfig.jsp?oper=modiquery";
	 document.form1.submit(); 
}
/* ɾ��һ����ѯ���� */
function delquery(id)
{

	if(!confirm("ȷ��Ҫɾ��ò�ѯ������",""))
	{
		return;
	}if(!confirm("ɾ��ò�ѯ���������ָܻ���ȷ��ɾ����",""))
	{
		return;
	}

	 document.form1.btdel.disabled=true;
	 document.form1.action="queryConfig.jsp?oper=delquery&delid="+id;
	 document.form1.submit();
}
/*  �޸Ĳ�ѯ���� */
function modquery(id,formtype,dataformat,formname,formid,sqlreg,order,tag)
{
	// ��ݱ?���͸��¿�ѡ�ı?
	freshSelect(formtype,'formList');
	form1.modid.value=id;
	for(var i=0;i<form1.formType.length;i++)
	{
	   if(form1.formType.options[i].value==formtype)	
	   {
	   	form1.formType.options[i].selected=true;
	   	break;
	   	}
	}
 
	form1.formTagName.value=tag;
	form1.dataformat.value=dataformat;
	form1.formName.value=formname;
	form1.formId.value=formid;
	// ����ű������ת��������modquery�ᱨ��
	sqlreg=sqlreg.replaceAll("��","'");  
	form1.sqlreg.value=sqlreg;
	for(var i=0;i<form1.order.length;i++)
	{
	   if(form1.order.options[i].text==order)	
	   {
	   	form1.order.options[i].selected=true;
	   	break;
	   	}
	}
	
}

function modSql()
{
   // document.form1.report_sql.value=encodeURI(document.form1.report_sql.value,"UTF-8");
   document.form1.modresult.disabled=true;
	 document.form1.action="resultConfig.jsp?oper=modsql";
	 document.form1.submit();
}

function clearNotice()
{
	document.getElementById("modSqlNotic").innerHTML="";
}

function controlView(spanid,tabid)
{
   var span_t=document.getElementById(spanid);
   var tab_t=document.getElementById(tabid);
   if(span_t.innerText=="����")
   {
   	tab_t.style.display="none";
   	span_t.innerText="��ʾ";
   	}
   	else
   	{
   		tab_t.style.display="block";
   		span_t.innerText="����";
   	}	
}

function addAnlya()
{
	 	if(form1.fieldName.value=="")
	 {
	 	alert("��ѡ��ָ�꣡");
	 	form1.fieldName.focus();
	 	return;
	 	}

    if(form1.valueReg.value=="")
    {
       alert("����дָ��ͳ�ƹ���");
       form1.valueReg.focus()
       return
    }

   document.form1.addanaly.disabled=true;
	 document.form1.action="analyConfig.jsp?oper=addanaly";
	 document.form1.submit(); 
}

function modanaly(id,fieldName,  valueReg, analysOrder)
{
   form1.modid.value=id;
   form1.fieldName.value=fieldName;
   valueReg=valueReg.replaceAll("��","'"); 
	 form1.valueReg.value=valueReg;
	 
	for(var i=0;i<form1.analysOrder.length;i++)
	{
	   if(form1.analysOrder.options[i].text==analysOrder)	
	   {
	   	form1.analysOrder.options[i].selected=true;
	   	break;
	   	}
	}
}

/* ɾ��һ���������� */
function delanaly(id)
{
	if(!confirm("ȷ��Ҫɾ��÷���������",""))
	{
		return;
	}if(!confirm("ɾ��÷������������ָܻ���ȷ��ɾ����",""))
	{
		return;
	}
	 document.form1.btdelanaly.disabled=true;
	 document.form1.action="analyConfig.jsp?oper=delanaly&delid="+id;
	 document.form1.submit();
}	 


function saveanaly()
{
 	if(form1.fieldName.value=="")
	 {
	 	alert("��ѡ��ָ�꣡");
	 	form1.fieldName.focus();
	 	return;
	 	}
    if(form1.valueReg.value=="")
    {
       alert("����дָ��ͳ�ƹ���");
       form1.valueReg.focus()
       return
    }

   document.form1.addanaly.disabled=true;
	 document.form1.action="analyConfig.jsp?oper=modianaly";
	 document.form1.submit(); 
}

function modAnalyCon()
{
 if(form1.reportAnalyQuery.value=="")
	 {
	 	alert("����д��ѯ���壡");
	 	form1.reportAnalyQuery.focus();
	 	return;
	 	}
 	document.form1.modanalyCon.disabled=true;
	 document.form1.action="analyConfig.jsp?oper=modanalyCon";
	 document.form1.submit(); 
}
