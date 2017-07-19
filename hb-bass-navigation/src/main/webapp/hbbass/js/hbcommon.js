/*
 *   20070206 ��ʼ����
 */ 

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

