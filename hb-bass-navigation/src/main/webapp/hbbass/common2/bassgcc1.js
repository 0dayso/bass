/**************************             
����2.0���ſͻ�;��������;�ͻ�����ר��js���
����  basscommon.js  
***************************/
var chartxmls=false;
var chartName = "";
var areagroup;

/************************************************************  ���߷�����    ************************************************************/
function channelcombo(i)
{
	selects = new Array();
	selects.push(document.forms[0].channelkind);
	sqls = new Array();
	
	if(document.forms[0].channeltype != undefined)
	{
		selects.push(document.forms[0].channeltype);
		sqls.push("channeltype");
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
		sqls.push("select device_name,device_name from nwh.imei_terminal_info where handset_brand='#{value}'");
	}
	//������������
	combolink(selects,sqls,i);
}

function kpiCompare(datas,options)
{
	var seq = options.seq;
	var columnoffset = 1;
	var textName=document.getElementById("selectcolumns_div").getElementsByTagName("input")[seq].parentNode.childNodes[1].nodeValue;
	return "<a href=kpichart.jsp?tablename="+tablescons+"&conditions="+encodeURIComponent(conditionscons)+"&column="+arrcolumns[seq-columnoffset]+"&name="+encodeURIComponent(mappingArea(datas,{seq:0})+" "+textName)+"&area_code="+datas[0]+" target=_blank>"+numberFormatDigit2(datas,{seq:seq})+"</a>";
}

function loseuser(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='loseuserdetail.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴������ϸ' target='_blank'>"+percentFormat(datas,options)+"</a>"
	}
	else
	{
		return percentFormat(datas,options);
	}
			
}

function incomedetail(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='incomedetail.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴������ϸ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
	}
	else
	{
		return numberFormatDigit2(datas,options);
	}
			
}

function memberdetailprodring(datas,options)
{
	return "<a href='memberdetailprodring.jsp?groupname="+datas[4]+"&grouplevel="+datas[5]+"&month="+document.forms[0].month.value+"&groupcode="+datas[3]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
}

function memberdetailprodvpmn(datas,options)
{
	return "<a href='memberdetailprodvpmn.jsp?groupname="+datas[4]+"&grouplevel="+datas[5]+"&month="+document.forms[0].month.value+"&groupcode="+datas[3]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
}

function memberdetailprodpushmail(datas,options)
{
	return "<a href='memberdetailprodpushmail.jsp?groupname="+datas[4]+"&grouplevel="+datas[5]+"&month="+document.forms[0].month.value+"&groupcode="+datas[3]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
}

function memberdetailreqring(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='memberdetailreqring.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
	}
	else
	{
		return numberFormatDigit2(datas,options);
	}	
}

function memberdetailreqsms(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='memberdetailreqsms.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
	}
	else
	{
		return numberFormatDigit2(datas,options);
	}	
}

function memberdetailreqmms(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='memberdetailreqmms.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
	}
	else
	{
		return numberFormatDigit2(datas,options);
	}	
}

function memberdetailreqgprs(datas,options)
{
	var value = datas[1].split(" ");
	if(value.length > 1)
	{
		return "<a href='memberdetailreqgprs.jsp?month="+document.forms[0].month.value+"&groupcode="+value[0]+"' title='�鿴��Ա��Ϣ' target='_blank'>"+numberFormatDigit2(datas,options)+"</a>"
	}
	else
	{
		return numberFormatDigit2(datas,options);
	}	
}

function intnubmercheck(el){if(!isNumber(el.value)){alert("����д��ȷ������");el.value=100;}el.value=parseInt(el.value,10);}


/************************************************************  �ύ��    ************************************************************/
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
			if(countSql!=undefined && maxNum>=fetchRows)ajaxGetListWrapper(countSql,showCount);
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
function renderBassTbody(BodyText,results)
{
	var colNum=0;
  if(results.length >0) colNum = results[0].childNodes.length;
	
	BodyText=BodyText+"<TBODY id='resultTbody'>";
	var rowcount = 0;
  for (n=0;n<=maxNum-1&&results[n].childNodes[0].childNodes.length!=0;n++)
  {
  	var datas = new Array();
  	for(var m=0;m<=colNum-1;m++)
  	{
  		if(results[n].childNodes[m].childNodes.length==0)datas[m]="";
  		else datas[m]=results[n].childNodes[m].childNodes[0].nodeValue;
  	}
  	
		var cityname=datas[0];
  	if(!areagroup.containsKey(cityname))areagroup.put(cityname,"false");
  	
  	if(n==0 || results[n-1].childNodes[0].childNodes[0].nodeValue!=cityname)//���ܵ���
  	{
  		rowcount++;
  		if(rowcount <= (page+1)*pagenum && rowcount > page*pagenum)
  		{
	  		BodyText=BodyText+"<TR class='grid_row_alt_blue' onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">";
	  		if(celldisplay.length==0 || celldisplay[0]==undefined)//���⴦���һ��
	  		{
	  			img = "/hb-bass-navigation/hbbass/common2/image/row-collapse.gif";
	  			if(areagroup.get(cityname)=="true")img = "/hb-bass-navigation/hbbass/common2/image/row-expand.gif";
	  			BodyText += "<TD class='grid_row_cell_tree'><img src='"+img+"' onclick='areaExpand(\""+cityname+"\");'></img>&nbsp;&nbsp;";
	  			if(cellfunc.length>0 && cellfunc[0]!=undefined)BodyText += cellfunc[0](datas,{seq:0});
	  			else BodyText += datas[0];
	  			BodyText += "</TD>";
	  		}
	  		else BodyText+="<TD style='display:none'></TD>";
	  		
	  		BodyText+=renderCell(datas,1,colNum)+"</TR>";
	  	}
  	}
  	else if(areagroup.get(cityname)=="true")//�ǻ��ܵ���
  	{
			rowcount++;
			if( rowcount > page*pagenum && rowcount <= (page+1)*pagenum)BodyText+="<TR class='grid_row_blue' onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">"+renderCell(datas,0,colNum)+"</TR>";
  	}
  }
 	pagesNumber=Math.ceil(rowcount/pagenum)-1; 
  BodyText = BodyText+"</TBODY></table><textarea name='downcontent' cols='122' rows='12' style='display:none'></textarea>"+footbar();
  return BodyText;
}

function areaExpand(cityname)
{
	if(areagroup.get(cityname)=="true")areagroup.set(cityname,"false");
	else areagroup.set(cityname,"true");
	renderGrid();
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

function groupcustRenderChart(spelltype,columns,tables,condition,group,postfix,chartcolumn)
{
	if(chartName=="")
	{
		var count = columns.split(",").length;
		if(chartcolumn!=undefined && chartcolumn!="null" && chartcolumn!="")count=parseInt(chartcolumn,10);
		var spans = document.getElementById("selectcolumns_div").getElementsByTagName("input");
		chartName=spans[spans.length-count].parentNode.childNodes[1].nodeValue;
		for(z=spans.length-count+1; z < spans.length; z++)chartName+=","+spans[z].parentNode.childNodes[1].nodeValue;
	}
	
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
			column = "value(substr(channel_code,1,8),'δ֪')";
		}
	}
	arr = groupcustBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
	renderChart("tagname="+encodeURIComponent(tag)+"&sql="+encodeURIComponent(arr[2].replace(/#{value}/gi,"value("+column+",'δ֪')"))+"&name="+encodeURIComponent(chartName));
}

function custservRenderChart(spelltype,columns,tables,condition,group,postfix,chartcolumn)
{
	if(chartName=="")
	{
		var count = columns.split(",").length;
		if(chartcolumn!=undefined && chartcolumn!="null" && chartcolumn!="")count=parseInt(chartcolumn,10);
		var spans = document.getElementById("selectcolumns_div").getElementsByTagName("input");
		chartName=spans[spans.length-count].parentNode.childNodes[1].nodeValue;
		for(z=spans.length-count+1; z < spans.length; z++)chartName+=","+spans[z].parentNode.childNodes[1].nodeValue;
	}
	
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
		}
	}
	arr = custservBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
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
	else ajaxSubmitWrapper(arr[0],arr[1]);
}

function channelSpellExtemporeSQL(columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} #{order} #{postfix} with ur";

	//���⴦�����
	if(document.forms[0].office!=undefined&&document.forms[0].office.value!="")
	{
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].office.parentNode.name + "='" + document.forms[0].office.value + "'";
		columnPlaceholder += "'"+mapping(document.forms[0].office.value,"office")+"'";
	}
	else if(document.forms[0].county!=undefined&&document.forms[0].county.value!="")
	{
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		channelplaceholder=document.forms[0].county.parentNode.name;
	}
	else if(document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(condition.length>0)condition += " and ";
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
				//&& attribute[i].childNodes[0].value != "0"
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
	if(group.length>0)group=group+",";
	
	//���⴦�����
	if(document.forms[0].office!=undefined && document.forms[0].office.value!="")
	{
		group += document.forms[0].office.parentNode.name;
		columnPlaceholder += "'"+mapping(document.forms[0].office.value,"office")+"'";
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].office.parentNode.name + "='" + document.forms[0].office.value + "'";
	}
	else if(document.forms[0].county!=undefined && document.forms[0].county.value!="")
	{
		group += document.forms[0].county.parentNode.name;
		columnPlaceholder += document.forms[0].county.parentNode.name;
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
	}
	else if(document.forms[0].city!=undefined && document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(document.forms[0].county!=undefined)a= document.forms[0].county.parentNode.name;
		else a = document.forms[0].city.parentNode.name;
		
		group += a;
		columnPlaceholder += a;
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
	}
	else if(document.forms[0].city!=undefined && document.forms[0].city.value!=undefined)
	{
		group += document.forms[0].city.parentNode.name;
		columnPlaceholder += document.forms[0].city.parentNode.name;
	}
	else if(document.forms[0].province!=undefined)
	{
		columnPlaceholder += "'"+ document.forms[0].province[0].text +"'";
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
			if(condition.length>0)condition = condition + " and " +"a.ch_id="+tables.split(",")[0]+".channel_id";
			else condition="a.ch_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id as ch_id,channel_name from nmk.RES_SITE_DS) a,"+tables;
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
			//cellfunc[2+areaOffset]=function(datas,options){return mapping(datas[options.seq],"channeltype");};
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
			selectColumns(2+areaOffset,false);
			selectColumns(3+areaOffset,false);
			//cellfunc[1+areaOffset]=function(datas,options){return mapping(datas[options.seq],"channelkind");};
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
			if(condition.length>0)condition = condition + " and " +"a.ch_id="+tables.split(",")[0]+".channel_id";
			else condition="a.ch_id="+tables.split(",")[0]+".channel_id";
			tables = "(select channel_id as ch_id,channel_name from nmk.RES_SITE_DS) a,"+tables;
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
				//cellfunc[1+areaOffset]=function(datas,options){return mapping(datas[options.seq],channelTagName);};	
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��','--'";
			}
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
				//cellfunc[2+areaOffset]=function(datas,options){return mapping(datas[options.seq],"channeltype");};
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
				//cellfunc[1+areaOffset]=function(datas,options){return mapping(datas[options.seq],"channelkind");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder +=",'ȫ��','--'";
			}
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
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ",case when grouping("+document.forms[0].channelkind.parentNode.name + ")=1 then '�ϼ�' else value("+document.forms[0].channelkind.parentNode.name + ",'δ֪') end";
				columnPlaceholder += ","+ document.forms[0].channelkind.parentNode.name;
				//cellfunc[1+areaOffset]=function(datas,options){return mapping(datas[options.seq],"channelkind");};
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
			columnPlaceholder += ",'"+mapping(channel1.value,channelTagName)+"'";
		}
		else
		{
			if(spelltype=="normal")
			{
				group += ","+ channel1.parentNode.name;
				columnPlaceholder += ",case when grouping("+channel1.parentNode.name + ")=1 then '�ϼ�' else value("+channel1.parentNode.name + ",'δ֪') end";
				//cellfunc[1+areaOffset]=function(datas,options){return mapping(datas[options.seq],channelTagName);};
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
			columnPlaceholder +=",'"+ mapping(document.forms[0].terminalbrand.value,"terminalbrand") +"','"+ term.value +"'";
			selectColumns(2+seq+areaOffset,true);
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
				cellfunc[1+seq+areaOffset]=function(datas,options){return mapping(datas[options.seq],"terminalbrand");};
			}
			else if (spelltype=="sort")
			{
				columnPlaceholder += ",'ȫ��','--'";
			}
			selectColumns(2+seq+areaOffset,false);
		}
	}
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	
	var optimeValue="";
	
	for(var i=0; i < attribute.length; i++)
	{
		if(attribute[i].childNodes[0].value!=undefined
			&&attribute[i].childNodes[0].value != "" 
				//&& attribute[i].childNodes[0].value != "0"
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
				columnPlaceholder += ",'"+ mapping(attribute[i].childNodes[0].value,tagName)+"'";
			}
			else
			{
				if (spelltype=="sort")columnPlaceholder += ",'ȫ��'";
				else if(spelltype=="normal")//Ŀǰ��û���ߵ�����ط�����ר��
				{
					if(group.length>0)group += ","+attribute[i].name;
					else group = attribute[i].name;
					columnPlaceholder += ","+attribute[i].name;
					//cellfunc[attribute[i].grouping]=function(datas,options){return mapping(datas[options.seq],tagName);};
				}
			}
		}
	}
	if(group.indexOf(",")==0)group=group.substring(1);
	if(columnPlaceholder.length>0)columns = columnPlaceholder + "," + columns;
	
	if (spelltype=="sort")columns = "rownumber() over(),'"+optimeValue+"'," + columns;
	
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
  if(spelltype=="sort" || fis < 0 ) arr[3] = ajaxSubmitWrapper;
  return arr;
}

/*************************************       ���ſͻ�          ************************************************************/
function groupcustBaseQuery(spelltype,funcSubmit,columns,tables,condition,group,postfix)
{
	arr = groupcustBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else funcSubmit(arr[0],arr[1]);
}

function groupcustBaseSpellSQL(spelltype,columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} group by #{group} #{order} #{postfix} with ur";
	
	var chartsql = "select #{value},#{columns} from #{tables} where #{condition} group by #{value} order by 1 with ur".replace("#{columns}",columns);
	
	columnPlaceholder="";
	if(group.length>0)group=group+",";
	
	var rollup = group;
	var orderby = group;
	//���⴦�����
	var divtitle = document.getElementById("resultTable");
	if(spelltype=="normal")
	{
		if(document.forms[0].county!=undefined && document.forms[0].county.value!="")
		{
			seqformat[0]="�ͻ�����";
			seqformat[1]="���ſͻ�";
			cellclass[1]="grid_row_cell_text";
			group += "STAFF_NAME,groupcode||' '||groupname";
			rollup = "STAFF_NAME,rollup(groupcode||' '||groupname)";
			orderby = "STAFF_NAME desc,groupcode||' '||groupname";
			columnPlaceholder += "value(STAFF_NAME,'δ֪'),case when grouping(groupcode||' '||groupname)=1 then '�ϼ�' else value(groupcode||' '||groupname,'δ֪') end";
			if(condition.length>0)condition +=" and ";
			condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!="" && document.forms[0].city.value!="0")
		{
			seqformat[0]="����";
			seqformat[1]="�ͻ�����";
			cellclass[1]=null;
			group += document.forms[0].county.parentNode.name+",STAFF_NAME";
			rollup = document.forms[0].county.parentNode.name+",rollup(STAFF_NAME)";
			orderby =document.forms[0].county.parentNode.name+" desc,STAFF_NAME";
			columnPlaceholder += document.forms[0].county.parentNode.name+",case when grouping(STAFF_NAME )=1 then '�ϼ�' else value(STAFF_NAME,'δ֪') end";
			if(condition.length>0)condition +=" and ";
			condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!=undefined)
		{
			seqformat[0]="����";
			seqformat[1]="����";
			cellclass[1]=null;
			group += document.forms[0].city.parentNode.name + ","+document.forms[0].county.parentNode.name;
			rollup = document.forms[0].city.parentNode.name + ",rollup("+document.forms[0].county.parentNode.name+")";
			orderby = group;
			columnPlaceholder += document.forms[0].city.parentNode.name+",case when grouping("+document.forms[0].county.parentNode.name+")=1 then '�ϼ�' else value("+document.forms[0].county.parentNode.name+",'δ֪') end";
		}
	}
	else if(spelltype=="kpi")
	{
		if(document.forms[0].county!=undefined && document.forms[0].county.value!="")
		{
			group += document.forms[0].county.parentNode.name;
			columnPlaceholder += document.forms[0].county.parentNode.name;
			if(condition.length>0)condition +=" and ";
			condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!="" && document.forms[0].city.value!="0")
		{
			group += document.forms[0].county.parentNode.name;
			columnPlaceholder += document.forms[0].county.parentNode.name;
			if(condition.length>0)condition +=" and ";
			condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!=undefined)
		{
			group += document.forms[0].city.parentNode.name ;
			columnPlaceholder += document.forms[0].city.parentNode.name;
		}
	}
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	
	var optimeValue="";
	
	for(var i=0; i < attribute.length; i++)
	{
		if(attribute[i].childNodes[0].value!=undefined
			&&attribute[i].childNodes[0].value != "" 
				//&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)condition += " and ";
			if(attribute[i].type=="between")	condition += attribute[i].name+ " between " + attribute[i].childNodes[0].value + " and " + attribute[i].childNodes[2].value;
			else if(attribute[i].type=="section")
			{
				var arrVals = attribute[i].childNodes[0].value.split("-");
				if(arrVals.length==2)condition += attribute[i].name + " between " + arrVals[0] + " and " + arrVals[1];
				else condition += attribute[i].name + " " + attribute[i].childNodes[0].value;
				
			}
			else if(attribute[i].type=="rank" && attribute[i].childNodes[2].value!="")//rank���ͱ��������һ��
			{
				if(condition.substring(condition.length-4,condition.length)=="and ")
				condition = condition.substring(0,condition.length-4);
				tables = "(select * from "+tables+" where " + condition+" order by "+attribute[i].name + " "+attribute[i].childNodes[0].value+" fetch first "+attribute[i].childNodes[2].value+" rows only ) as trank"
				condition = "1=1";
			}
			else if(attribute[i].type=="int")	condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
			else if(attribute[i].type=="like")condition += attribute[i].name+ " like '%" + attribute[i].childNodes[0].value + "%'";
			else if(attribute[i].type=="in")	condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
			else if(attribute[i].type=="varchar")condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			else condition = condition.substring(0,condition.length-4);
			
		}
		if(attribute[i].name=="op_time")optimeValue=attribute[i].childNodes[0].value;
		//�Ƿ�μӷ���
		if(attribute[i].grouping!=undefined)
		{	
			var tagName = attribute[i].childNodes[0].name;
			if(attribute[i].childNodes[0].value != "" )
			{
				columnPlaceholder += ",'"+ mapping(attribute[i].childNodes[0].value,tagName)+"'";
			}
			else if(spelltype=="normal")
			{
				if(group.length>0)group += ","+attribute[i].name;
				else group = attribute[i].name;
				columnPlaceholder += ","+attribute[i].name;
				//cellfunc[attribute[i].grouping]=function(datas,options){return mapping(datas[options.seq],tagName);};
			}
		}
	}
	if(group.indexOf(",")==0)group=group.substring(1);
	if(columnPlaceholder.length>0)columns = columnPlaceholder + "," + columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	chartsql = chartsql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	if(condition.length > 0)chartsql = chartsql.replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","").replace("#{order}","");//���ͳ������SQL
	
	sql = sql.replace("#{columns}",columns);
	
	document.getElementById("sql").value=sql.replace("#{postfix}","").replace("#{group}",group).replace("#{order}","");//���������SQL
	
	var fis = group.indexOf(",");
	if(spelltype=="normal")sql = sql.replace("#{order}","order by "+orderby + " desc , targetorder desc" ).replace("#{group}",rollup).replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
	else if (spelltype=="kpi")sql = sql.replace("#{order}","order by "+group).replace("#{group}",""+group+"").replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
	
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  arr[2] = chartsql;
  arr[3] = bassAjaxSubmit;
  if(spelltype=="kpi" || fis < 0 ) arr[3] = ajaxSubmitWrapper;
  return arr;
}

function groupcustExtemporeQuery(columns,tables,condition,group,postfix)
{
	arr = groupcustSpellExtemporeSQL(columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else ajaxSubmitWrapper(arr[0],arr[1]);
}

function groupcustSpellExtemporeSQL(columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} #{order} #{postfix} with ur";

	//���⴦�����
	if(document.forms[0].county!=undefined&&document.forms[0].county.value!="")
	{
		if(condition.length>0)condition +=" and ";
		condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		channelplaceholder=document.forms[0].county.parentNode.name;
	}
	else if(document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(condition.length>0)condition +=" and ";
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
				//&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county"
							&& attribute[i].name != "monthcons" )
		{
			if(condition.length>0)condition += " and ";
			if(attribute[i].type=="between")	condition += attribute[i].name+ " between " + attribute[i].childNodes[0].value + " and " + attribute[i].childNodes[2].value;
			else if(attribute[i].type=="section")
			{
				var arrVals = attribute[i].childNodes[0].value.split("-");
				if(arrVals.length==2)condition += attribute[i].name + " between " + arrVals[0] + " and " + arrVals[1];
				else condition += attribute[i].name + " " + attribute[i].childNodes[0].value;
			}
			else if(attribute[i].type=="ifflag")
			{
				var sPiece = attribute[i].name.split("@@");
				if(attribute[i].childNodes[0].value=="0")condition += sPiece[0];
				else if (attribute[i].childNodes[0].value=="1")condition += sPiece[1];
				else condition += "1=1"
			}
			else if(attribute[i].type=="int")	condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
			else if(attribute[i].type=="like")condition += attribute[i].name+ " like '%" + attribute[i].childNodes[0].value + "%'";
			else if(attribute[i].type=="in")	condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
			else if(attribute[i].type=="varchar")condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
		}
		if(attribute[i].grouping!=undefined)
		{
			if(attribute[i].name=="monthcons")channelplaceholder = "'"+attribute[i].childNodes[0].value+"',"+channelplaceholder;
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

/*************************************       �ͻ�����          ************************************************************/
function custservBaseQuery(spelltype,funcSubmit,columns,tables,condition,group,postfix)
{
	arr = custservBaseSpellSQL(spelltype,columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else funcSubmit(arr[0],arr[1]);
}

function custservBaseSpellSQL(spelltype,columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} group by #{group} #{order} #{postfix} with ur";
	
	var chartsql = "select #{value},#{columns} from #{tables} where #{condition} group by #{value} order by 1 with ur".replace("#{columns}",columns);
	
	columnPlaceholder="";
	if(group.length>0)group=group+",";
	
	var rollup = group;
	var orderby = group;
	//���⴦�����
	var divtitle = document.getElementById("resultTable");
	if(spelltype=="normal")
	{
		if(document.forms[0].county!=undefined && document.forms[0].county.value!="" )
		{
			group += document.forms[0].county.parentNode.name;
			columnPlaceholder += document.forms[0].county.parentNode.name;
			if(condition.length>0)condition += " and ";
			condition += document.forms[0].county.parentNode.name + "='" + document.forms[0].county.value + "'";
		}
		else if(document.forms[0].county!=undefined && document.forms[0].city.value!="0" )
		{
			group += document.forms[0].county.parentNode.name;
			columnPlaceholder += document.forms[0].county.parentNode.name;
			if(condition.length>0)condition += " and ";
			condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!="" && document.forms[0].city.value!="0")
		{
			group += document.forms[0].city.parentNode.name;
			columnPlaceholder += document.forms[0].city.parentNode.name;
			if(condition.length>0)condition += " and ";
			condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		}
		else if(document.forms[0].city!=undefined && document.forms[0].city.value!=undefined)
		{
			group += document.forms[0].city.parentNode.name ;
			columnPlaceholder += document.forms[0].city.parentNode.name;
		}
	}
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	
	var optimeValue="";
	
	for(var i=0; i < attribute.length; i++)
	{
		if(attribute[i].childNodes[0].value!=undefined
			&&attribute[i].childNodes[0].value != "" 
				//&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)condition += " and ";
			
			if(attribute[i].type=="int")			condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
			else if(attribute[i].type=="in")	condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
			else if(attribute[i].type=="rlike")	condition += attribute[i].name + " like '" + attribute[i].childNodes[0].value + "%'";
			else if(attribute[i].type=="between")	condition += attribute[i].name + " between " + attribute[i].childNodes[0].value ;
			else 								condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
		}
		if(attribute[i].name=="op_time")optimeValue=attribute[i].childNodes[0].value;
		//�Ƿ�μӷ���
		if(attribute[i].grouping!=undefined)
		{	
			var tagName = attribute[i].childNodes[0].name;
			if(attribute[i].childNodes[0].value != "" )
			{
				columnPlaceholder += ",'"+ mapping(attribute[i].childNodes[0].value,tagName)+"'";
			}
			else if(spelltype=="normal")
			{
				if(group.length>0)group += ","+attribute[i].name;
				else group = attribute[i].name;
				columnPlaceholder += ","+attribute[i].name;
				//cellfunc[attribute[i].grouping]=function(datas,options){return mapping(datas[options.seq],tagName);};
			}
		}
	}
	if(group.indexOf(",")==0)group=group.substring(1);
	if(columnPlaceholder.length>0)columns = columnPlaceholder + "," + columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	chartsql = chartsql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	if(condition.length > 0)chartsql = chartsql.replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","").replace("#{order}","");//���ͳ������SQL
	
	sql = sql.replace("#{columns}",columns);
	
	document.getElementById("sql").value=sql.replace("#{postfix}","").replace("#{group}",group).replace("#{order}","");//���������SQL
	
	var fis = group.indexOf(",");
	if (spelltype=="normal")sql = sql.replace("#{order}","order by "+group).replace("#{group}",""+group+"").replace("#{postfix}",postfix);//���Ͻ�ȡ��׺
	
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  arr[2] = chartsql;
  arr[3] = ajaxSubmitWrapper;
  return arr;
}



function custservExtemporeQuery(columns,tables,condition,group,postfix)
{
	arr = custservSpellExtemporeSQL(columns,tables,condition,group,postfix);
	if(arr[3] != undefined)arr[3](arr[0],arr[1]); //ִ�в�ѯ��ʾ
	else ajaxSubmitWrapper(arr[0],arr[1]);
}

function custservSpellExtemporeSQL(columns,tables,condition,group,postfix)
{
	var sql = "select #{columns} from #{tables} where #{condition} #{order} #{postfix} with ur";
	var channelplaceholder="";
	//���⴦�����
	if(document.forms[0].city!=undefined&&document.forms[0].city.value!="" && document.forms[0].city.value!="0")
	{
		if(condition.length>0)condition += " and ";
		condition += document.forms[0].city.parentNode.name + "='" + document.forms[0].city.value + "'";
		channelplaceholder=document.forms[0].city.parentNode.name;
	}
	else if(document.forms[0].city!=undefined)
	{
		channelplaceholder=document.forms[0].city.parentNode.name;
	}
	
	var attribute = document.getElementById("dim_div").getElementsByTagName("span");
	for(var i=0; i < attribute.length; i++)
	{
		if(attribute[i].childNodes[0].value != undefined
			&& attribute[i].childNodes[0].value != "" 
				//&& attribute[i].childNodes[0].value != "0"
					&& attribute[i].childNodes[0].name != "city"
						&& attribute[i].childNodes[0].name != "county")
		{
			if(condition.length>0)condition += " and ";
			if(attribute[i].type=="int")		condition += attribute[i].name + "=" + attribute[i].childNodes[0].value;
			else if(attribute[i].type=="in")condition += attribute[i].name + " in (" + attribute[i].childNodes[0].value + ")";
			else if(attribute[i].type=="rlike")	condition += attribute[i].name + " like '" + attribute[i].childNodes[0].value + "%'";
			else 								condition += attribute[i].name + "='" + attribute[i].childNodes[0].value + "'";
			
		}
		if(attribute[i].grouping!=undefined)
		{
			if(attribute[i].name=="op_time")channelplaceholder = "'"+attribute[i].childNodes[0].value+"',"+channelplaceholder;
			else channelplaceholder += channelplaceholder.length>0 ?",":"" +attribute[i].name;
		}
	}
	columns = channelplaceholder + "," +columns;
	
	sql=sql.replace("#{tables}",tables).replace("#{condition}",condition);
	
	var countSql= sql.replace("#{columns}","count(*)").replace("#{postfix}","").replace("group by #{group}","").replace("#{order}","");//���ͳ������SQL
	
	sql = sql.replace("#{columns}",columns);
	
	if(orderbycons)sql = sql.replace("#{order}",orderbycons);
	else sql = sql.replace("#{order}","");
	
	document.getElementById("sql").value=sql.replace("#{postfix}","");//���������SQL
	sql = sql.replace("#{postfix}",postfix);
  var arr = new Array();
  arr[0] = sql;
  arr[1] = countSql;
  return arr;
}



