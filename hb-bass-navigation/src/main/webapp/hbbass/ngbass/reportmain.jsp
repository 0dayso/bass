<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*"%>
<%@ page import="bass.common.UpdateBean" %>
<%@ page import="java.util.*,java.text.*"%>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean"/> 
<jsp:useBean id="cp" scope="page" class="bass.database.compete.CompetePool"/> 
<%@ page import = "bass.common.NgbassTools"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=gb2312" />
	<TITLE>NGBASS����</TITLE>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
  <style>	
	.form_button{
	BORDER-RIGHT: #7b9ebd 1px solid; 
	BORDER-TOP: #7b9ebd 1px solid; 
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px ,2px; 
	FONT-SIZE: 12px; 
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); 
	CURSOR: hand; 
	COLOR: black;
 	width:40px;
 	height:20px;
}
.form_button2{
	BORDER-RIGHT: #7b9ebd 1px solid; 
	BORDER-TOP: #7b9ebd 1px solid; 
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px ,2px; 
	FONT-SIZE: 12px; 
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); 
	CURSOR: hand; 
	COLOR: black;
 	width:60px;
 	height:20px;
}
/* Ҫ�����»��ߵ�������ʽ */
a.a2            { color: #0000FF; text-decoration: none }
a:link.a2       { text-decoration: underline; color: #0000FF; font-family: ���� }
a:visited.a2    { text-decoration: underline; color: #0000FF; font-family: ���� }
a:hover.a2      { text-decoration: underline; color: #FF0000 }
a:active.a2     { text-decoration: underline; color: #FF0000 }
</style>
<script language=javascript>
function clickSubmit()
{
	document.form1.nextPage2.value=0;
  document.form1.confirm.disabled=true;
  document.form1.action="reportmain.jsp";
	document.form1.submit(); 
}

function opennew(reportid,reportname)
{
	 // var leftsize=(window.screen.availWidth-1000)/2;
	 // var topsize=(window.screen.availHeight-640)/2;
	 var width=window.screen.availWidth-100;
	 var height=window.screen.availHeight-100;
   //window.open('Config.jsp?reportid='+reportid+"&reportname="+reportname+"&time="+new Date().getMilliseconds(),'','height=620, width=1000,left='+leftsize+',top='+topsize+',toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no') ;
   window.open('configMain.jsp?reportid='+reportid+"&reportname="+reportname ,'','height='+height+', width='+width+',left=50,top=20,toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=yes') ;
}

function freahCache()
{
  var leftsize=(window.screen.availWidth-320)/2;
	var topsize=(window.screen.availHeight-260)/2;
	 window.open('freshcache.jsp' ,'','height=60, width=320,left='+leftsize+',top='+topsize+',toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no') ;
}
function add()
{
	var urlstr ="addreport.jsp";
	var leftsize=(window.screen.availWidth-460)/2;
	var topsize=(window.screen.availHeight-360)/2;
	window.open(urlstr,'','height=160, width=460,left='+leftsize+',top='+topsize+', toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no'); 
}

function copyinfo(reportid,reportname)
{
	var urlstr ="copyreport.jsp?reportid="+reportid+"&reportname="+reportname;
	var leftsize=(window.screen.availWidth-460)/2;
	var topsize=(window.screen.availHeight-360)/2;
	window.open(urlstr,'','height=180, width=460,left='+leftsize+',top='+topsize+', toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no'); 

}

function backupdate()
{
	var urlstr ="backupdate.jsp";
	var leftsize=(window.screen.availWidth-460)/2;
	var topsize=(window.screen.availHeight-360)/2;
	window.open(urlstr,'','height=180, width=460,left='+leftsize+',top='+topsize+', toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no'); 

}

function delinfo(id)
{
	if(!confirm("ȷ��Ҫɾ����Ӧ����",""))
	{
		return;
	}
	if(!confirm("ɾ����Ӧ�ý����ָܻ���ȷ��ɾ����",""))
	{
		return;
	}
	
	document.form1.nextPage2.value=0;
  document.form1.action="reportmain.jsp?id="+id;
	document.form1.submit(); 
}
</script>	
</head>

<%
// ���ò���ʱ����session ���������ʽ����������֤
session.setAttribute("loginname","wangbotao");

String reportname=request.getParameter("reportname")==null?"":request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");

String userid=request.getParameter("userid")==null?"":request.getParameter("userid");
String id=request.getParameter("id")==null?"":request.getParameter("id");
if(!id.equals(""))
{
  UpdateBean ub=new UpdateBean();
  ub.aftUpdateSQL("delete from ngbass_report where id="+id);
  ub.aftUpdateSQL("delete  from ngbass_report_output where pid="+id);
  ub.aftUpdateSQL("delete  from ngbass_report_input where pid="+id);
  
}
String sql="select * from ngbass_report where 1=1 ";
if(!reportname.equals(""))                                                                 
{
 sql+=" and report_name like '%"+reportname+"%'";
}
sql+=" order by id desc";
int perPage=15;
int nextPage=0;
try
  {
     	nextPage = Integer.parseInt(request.getParameter("nextPage2"));
  }
catch (Exception e)
  {
  }
Divpage.setNextPage(nextPage);
Divpage.setPerPage(perPage);
Divpage.setQuerySQL(sql);
%>
<body topmargin="5">
<br>
<form name="form1" method="post" action="" >
	<input type="hidden" name="hidDel" value="n">
	 <table width="90%" align="center" border="0" cellspacing="1" cellpadding="1" bgcolor="#c3daf9">
		<tr bgcolor="#FFFFFF">
	    <td align="center" width="30%">Ӧ�����ƣ�<input type="text" name="reportname" value="<%=reportname%>"/></td>
	    <td align="left" width="70%">&nbsp;&nbsp;&nbsp;<input type=button name="confirm" class="form_button" value="�� ѯ"  onclick="clickSubmit()"> &nbsp;&nbsp;
	    &nbsp;&nbsp;&nbsp;<input type=button name="addbt" class="form_button" value="�� ��"  onclick="add()"> &nbsp;&nbsp;
	    &nbsp;&nbsp;&nbsp;<input type=button name="addbt" class="form_button2" value="ˢ�»���"  onclick="freahCache()"> &nbsp;&nbsp;
	    &nbsp;&nbsp;&nbsp;<input type=button name="addbt" class="form_button2" value="���ݱ���"  onclick="backupdate()"> &nbsp;&nbsp;
	    </td>
		</tr>
	</table>
	<br>
	<table id="resultTable" align="center" width="90%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
			<td width="5%"  class="grid_title_cell">Ӧ��id</td>
	    <td width="30%"  class="grid_title_cell">Ӧ������</td> 
	    <td width="50%"  class="grid_title_cell">����</td> 
      <td width="15%" class="grid_title_cell">����</td> 
     </tr>
      <%
        String tr_class="";
        for(int i=1;i<=Divpage.getRowNum();i++)
         {
		  	    if(i%2==0)
			        tr_class="grid_row_blue";
			     else
			   	   tr_class ="grid_row_alt_blue";
      %>		
       <tr height="25" class=<%=tr_class%>  onMouseOver="this.className='grid_row_over_blue'"  onMouseOut="this.className='<%=tr_class%>'">
  	        <td align="left"><%=Divpage.getFieldValue("id",i)%></td>
		        <td align="left"><a class="a2" href="javascript:opennew('<%=Divpage.getFieldValue("id",i)%>','<%=Divpage.getFieldValue("report_name",i)%>')" title="����鿴��ϸ��Ϣ"><%=Divpage.getFieldValue("report_name",i)%></a></td> 
		        <td align="left"><%=Divpage.getFieldValue("REPORT_DESC",i)%></td>
		        <td align="center"> 
		        	<%
		        	  if(userid.equals("admin"))
		        	  {
		        	%>
		        	<input class="form_button" type="button" name="del" value="ɾ��" onClick="delinfo('<%=Divpage.getFieldValue("id",i)%>')">&nbsp;&nbsp;
		         <% 
		           }
		         %>
		          <input class="form_button" type="button" name="del" value="����" onClick="copyinfo('<%=Divpage.getFieldValue("id",i)%>','<%=Divpage.getFieldValue("report_name",i)%>')"></td>
	      </tr>
	      <%  
	       } 
	      %>  
  </table>   
  <%@ include file="/hbbass/common/common_page.jsp"%> 
</form>
 
</body>
</html>
