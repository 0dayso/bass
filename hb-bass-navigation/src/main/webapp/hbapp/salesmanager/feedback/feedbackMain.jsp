<%@ page contentType="text/html; charset=gb2312"%>
<%

	// �û���¼��ʱ�ж�
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	
%>
<html>
  <head>
    <title>Ӫ�������/����</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="dim_conf.js" charset=utf-8></script>
	<script type="text/javascript" src="/hcr/jscript/calendar/calendar.js"></script>
	<script type="text/javascript" src="/hbbass/portal/portal_hb.js"></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
	
  </head>
  <script type="text/javascript">
  	fetchRows=500;
  	pagenum=15;  	
  	cellclass[0]="grid_row_cell_text";
  	cellclass[1]="grid_row_cell_text";
		cellclass[2]="grid_row_cell_text";
		cellclass[3]="grid_row_cell_text";
		cellclass[4]="grid_row_cell_text";
		cellclass[5]="grid_row_cell_text";
		//cellclass[6]="grid_row_cell_number";
		//cellclass[6]="grid_row_cell_number";
  /*
  	cellclass[0]="grid_row_cell_text";
  */
  
 	
 	function doSubmit()
 	{
 		var condition = " where 1 = 1 ";
 	
 		if(document.forms[0].city.value!="0")
		{
			condition += " and city_id='"+document.forms[0].city.value+"'";
		}
		/**/		
		if(document.forms[0].querytime.value!="")
		{
			condition += " and substr(char(INSERTDATE),1,7) = '"+document.forms[0].querytime.value+"'";
		}
		
		if(document.forms[0].manager_id.value!="")
		{
			condition += " and ucase(manager_id) like ucase('%"+document.forms[0].manager_id.value+"%')";
		}
		if(document.forms[0].manager_name.value!="")
		{
			condition += " and name like '%"+document.forms[0].manager_name.value+"%'";
		}
		if(document.forms[0].opp_nbr.value!="")
		{			
			condition += " and opp_nbr like��'%"+document.forms[0].opp_nbr.value+"%'";
		}
		if(document.forms[0].acc_nbr.value!="")
		{			
			condition += " and acc_nbr like��'%"+document.forms[0].acc_nbr.value+"%'";
		}
 		
 		var countSql ="";
 		var sql = "select OPP_NBR,ACC_NBR,NAME,manager_id,AREA,POLICE,DATE,INSERTDATE,opp_nbr||';'||acc_nbr||';'||INSERTMAN from COMPETE_OPPSTATE ";		
		sql += condition + " order by INSERTDATE desc fetch first "+fetchRows+" rows only with ur";
		
		var downSql = "select OPP_NBR,ACC_NBR,NAME,manager_id,AREA,POLICE,DATE,INSERTDATE from COMPETE_OPPSTATE " + condition + " order by INSERTDATE desc with ur";
		document.forms[0].sql.value = encodeURIComponent(downSql);
		countSql="select count(*) from COMPETE_OPPSTATE "+condition+" with ur";

		ajaxSubmitWrapper(sql,countSql);		
 	}
 	function openhtml_pp(url_node,url_text,url_link)
 	{
   if(url_link!='')
   {
   	    var contentPanel=parent.parent.contentPanel;
		 	  n = contentPanel.getComponent(url_node);
		 	 if (!n) {
		 	 	    n = contentPanel.add({
		               'id':url_node,
		               'title':url_text,
		                closable:true,  //ͨ��html����Ŀ��ҳ
		                margins:'0 4 4 0',
		                autoScroll:true,   
		               'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
		            });
		  	}
		    contentPanel.setActiveTab(n);		
   }
 	}
	cellfunc[8]=function(datas,options)
	{
		var tmpStr = datas[options.seq].split(";");
		if(tmpStr[2] == '<%=loginname%>')
		{
			return "<input type='button' class='form_button_short' value='�޸�'	onClick=\"openhtml_pp('feedbackmodify','"+tmpStr[1].trim()+"-���������޸�','/hbbass/salesmanager/feedback/singleMod.jsp?opp_nbr="+tmpStr[0].trim()+"&acc_nbr="+tmpStr[1]+"')\">&nbsp;<input type='button' class='form_button_short' value='ɾ��'	onClick='deleteSingle("+tmpStr[0]+","+tmpStr[1]+")'>";
		}
		else return "";
 	}
/*
cellfunc[3]=function(datas,options){
 		if(datas[options.seq]=="50")return "Ӫ���ִ����";
 		else if(datas[options.seq]=="54") return "�����ɵ��ɹ�";
 		else if(datas[options.seq]=="90") return "�������";
 	}
 	

cellfunc[8]=function(datas,options){	
	var foo = datas[options.seq].split("@");
	return "<img src='topmenu_icon05.gif' style='cursor: hand;' title='Ӫ������ټ��'  onclick='openhtml_p(\""+foo[0]+"\",\""+datas[0]+"\",\"stat/taskStatResult.jsp?campname="+datas[0]+"&taskid="+foo[0]+"&campid="+foo[0]+"&objid="+foo[3]+"&objnums="+foo[2]+"&activenums="+datas[5]+"&startdate="+datas[6]+"&enddate="+datas[7]+"\");'></img>";
	//return "<img src='topmenu_icon05.gif' style='cursor: hand;' title='Ӫ������ټ��'  onclick='parent.parent.topFrame.theCreateTab.add(\""+datas[0]+",mainFrame,stat/taskStatResult.jsp?campname="+datas[0]+"&taskid="+foo[0]+"&campid="+foo[0]+"&objid="+foo[3]+"&objnums="+foo[2]+"&activenums="+datas[5]+"&startdate="+datas[6]+"&enddate="+datas[7]+"\");'></img>";
}
*/
function deleteSingle(number1,number2)
{
  var opp_nbr = number1;
  var acc_nbr = number2;
  if(confirm("ȷ��ɾ��"+acc_nbr+"����ķ������ݣ�"))
  {
	  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
		xmlHttp.onreadystatechange=delBack; // ���ûص�����
		xmlHttp.open("POST","/hbbass/salesmanager/feedback/feedback_db.jsp",false);
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var str="actiontype=singledel&opp_nbr="+opp_nbr+"&acc_nbr="+acc_nbr;
		//str = encodeURIComponent(str);
		str = encodeURI(str,"utf-8");
		//alert(str);
		xmlHttp.send(str);
		//alert(xmlHttp.responseText);
	}
}
function delBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			alert(xmlHttp.responseText);
			doSubmit();
		}
	}
}
function saveExcel()
{
	//var sql=document.form1.sql.value;
	//sql = encodeURIComponent(sql);
		if(document.forms[0].querytime.value=="")
		{
			alert("¼���·ݲ���Ϊ�գ�");
			return;
			}
	var condition = " where 1 = 1 ";
 	
 		if(document.forms[0].city.value!="0")
		{
			condition += " and city_id='"+document.forms[0].city.value+"'";
		}
		/**/		
		if(document.forms[0].querytime.value!="")
		{
			condition += " and substr(char(INSERTDATE),1,7) = '"+document.forms[0].querytime.value+"'";
		}
		
		if(document.forms[0].manager_id.value!="")
		{
			condition += " and ucase(manager_id) like ucase('%"+document.forms[0].manager_id.value+"%')";
		}
		if(document.forms[0].manager_name.value!="")
		{
			condition += " and name like '%"+document.forms[0].manager_name.value+"%'";
		}
		if(document.forms[0].opp_nbr.value!="")
		{			
			condition += " and opp_nbr like��'%"+document.forms[0].opp_nbr.value+"%'";
		}
		if(document.forms[0].acc_nbr.value!="")
		{			
			condition += " and acc_nbr like��'%"+document.forms[0].acc_nbr.value+"%'";
		}
 		
 		var countSql ="";
 		var sql = "select OPP_NBR,ACC_NBR,NAME,manager_id,AREA,POLICE,DATE,INSERTDATE,opp_nbr||';'||acc_nbr||';'||INSERTMAN from COMPETE_OPPSTATE ";		
		sql += condition + " order by INSERTDATE desc fetch first "+fetchRows+" rows only with ur";
		
		var downSql = "select OPP_NBR,ACC_NBR,NAME,manager_id,AREA,POLICE,DATE,INSERTDATE from COMPETE_OPPSTATE " + condition + " order by INSERTDATE desc with ur";
		document.forms[0].sql.value = encodeURIComponent(downSql);
	//	alert(downSql);
	document.forms[0].action="/hbbass/salesmanager/feedback/saveExcel.jsp";
	document.forms[0].target="_blank";	
	document.forms[0].submit();
}
  </script>
  <body>
  <form action="" method="post">
  <div id="hidden_div">
	<input type="hidden" id="allPageNum" name="allPageNum" value="">
	<input type="hidden" id="sql" name="sql" value="">
	<input type="hidden" name="filename" value="">
	<input type="hidden" name="order"  value="">
	<input type="hidden" name="title" value="">
</div>
<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div')"
									title="�������">
									<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;��ѯ��������
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
	         <table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
						<tr class="dim_row">
							<td class="dim_cell_title"  align="left">¼���·�</td>
							<td class="dim_cell_content">
								<input type="text" size="12" name="querytime" value="" />
									<SPAN title="��ѡ��������¼���·�" style="cursor:hand">
										<IMG src="/hbbass/images/icon_date.gif" align="absMiddle" style="cursor:hand" width="27" height="25" border="0" onclick="javascript: var t=document.all.item('querytime').value; var x=window.showModalDialog('/hbbass/channel/surrogateanalysis/monthCalendar.htm',null,'dialogLeft:'+window.event.screenX+'px;dialogTop:'+window.event.screenY+'px;dialogWidth:250px;dialogHeight:140px;resizable:no;status:no;scroll:no');if (x != null && x.length >0) document.all.item('querytime').value = x; if(x!=t&&x!=null) monthChanged();" width="20" align="absbottom" />
									</SPAN>
							</td>
							<td class="dim_cell_title"  align="left">����</td>
							<td class="dim_cell_content"><%=bass.common.QueryTools2.getAreaCodeHtml("city", (String)session.getAttribute("area_id"), "")%></td>
							<td class="dim_cell_title"  align="left">�ͻ�����ID</td>
							<td class="dim_cell_content"><input type="text" size="12" name="manager_id" value="" /></td>
						</tr>
						<tr>
							<td class="dim_cell_title"  align="left">�������ֺ���</td>
							<td class="dim_cell_content"><input type="text" size="12" name="opp_nbr" value="" /></td>
							<td class="dim_cell_title"  align="left">�ƶ�����</td>
							<td class="dim_cell_content"><input type="text" size="12" name="acc_nbr" value="" /></td>
							<td class="dim_cell_title"  align="left">�ͻ���������</td>
							<td class="dim_cell_content"><input type="text" size="12" name="manager_name" value="" /></td>
						</tr>
					</table>
					<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="��ѯ"	onClick="doSubmit()">&nbsp;
									<!--//-->
									<input type="button" class="form_button" value="����"	onclick="saveExcel()">
									&nbsp;
								</td>
							</tr>
						</table>
				 </div>
        	</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'show_div')"
									title="�������">
									<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;����չ������
								</td>
								<td></td>
							</tr>
						</table>
					</legend>
					<div id="show_div">
						<div id="showsum"></div>						
						<div title="ѡ���������еĲ�������ť���в���" id="showResult"></div>
					</div>
				</fieldset>
			</div>
			<br>
			<div id="title_div" style="display:none;">
				<table id="resultTable" align="center" width="100%"
					class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="grid_title_blue">						
						<td class="grid_title_cell" width="" id="0">�������ֺ���</td>
						<td class="grid_title_cell" width="" id="1">�ƶ�����</td>
						<td class="grid_title_cell" width="" id="2">�ͻ���������</td>
						<td class="grid_title_cell" width="" id="3">�ͻ�����ID</td>
						<td class="grid_title_cell" width="" id="4">�ͻ������������</td>
						<td class="grid_title_cell" width="30%" id="5">��������</td>
						<td class="grid_title_cell" width="" id="6">�߷�ʱ��</td>
						<td class="grid_title_cell" width="" id="7">¼��ʱ��</td>
						<td class="grid_title_cell" width="" id="8">��������</td>						    
					</tr>
				</table>
			</div>
		</form>
		<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
