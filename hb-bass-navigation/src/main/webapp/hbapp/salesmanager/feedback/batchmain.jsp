<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%-- 
<%@ page import="com.asiainfo.common.Configure" %>
--%>
<script type="text/javascript" src="/hbbass/portal/portal_hb.js"></script>
<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>�����ƶ���Ӫ����ϵͳ</TITLE>
<script language="javascript">
<%--
	//�������κ�
	Calendar c = Calendar.getInstance();
	DateFormat formater = new SimpleDateFormat("yyyyMMddhhmmss");
	String taskId = formater.format(c.getTime()) + "@" + session.getAttribute("loginname");
	System.out.println("taskId : " + taskId);
--%>
function onClickUpload()
{
    var filename=document.form1.file.value ;
    if(filename!='')
    {
        if(filename.length<5||filename.substring(filename.length-4)!='.xls')
        {
            alert("�ļ���ʽ����,��ѡ��.xls�ļ�!");
            return false;
        }
        document.form1.action="batchload.jsp" ;
        document.form1.upload.disabled= true;
        document.form1.submit();
    }
    else 
    {
        alert("��ѡ���ļ�!");
    }
}

</script>
<style type="text/css">
<!--
@import url("/hbbass/css/com.css");
#queryload {
	position:absolute;
	width:200px;
	height:41px;
	z-index:2;
	left: 318px;
	top: 160px;
	background-color: #00FFCC;
}
-->
</style>
<%--��ҳ jsp ��ʼ�������--%>
<%
session.setAttribute("do","");

String loginname="";
if(session.getAttribute("loginname")==null){
  response.sendRedirect("/hbbass/error/loginerror.jsp");
	return;
}
else{
	loginname=(String)session.getAttribute("loginname");
}	 


%>
<body bgcolor="#EFF5FB" margin=0>
<form action="" method="post" enctype="multipart/form-data" name="form1">
<table border=0 align="center" width="100%">
<tr>
<td align="center">
<fieldset style="width:80%" align="center">
 <legend>
		<span class="headtitle">ģ���ļ�</span>
	</legend>
   <table width="84%"  border=0 align="center" cellpadding="0" cellspacing="0">
      <tr> 
        <td width="40%" align="left"><a style="text-decoration: underline;" href="/hbbass/common/FileDown.jsp?filename=sample.xls&filepath=/hbbass/salesmanager/feedback/"><font color=blue><b>excel��������ģ��</b></font></a>&nbsp;</td>
        <td width="60%"><font color="red">���Ҽ������Ŀ�����Ϊ������</font><td>  
      </tr>
      <tr> 
        <td colspan=2 align="left" valign="middle">
        <pre>
<p>        	
����˵����
	1.�����ļ��в������ظ��ļ�¼(��ͬ�Ĳ߷�������ƶ�����)��
	2.ͬһ���ƶ����벻�ܶ�Ӧ����߷����룻ͬһ���߷�����Ҳ���ܶ�Ӧ����ƶ����룻
	3.����ļ�¼�������ѵ������ʷ��¼��ͬ�������ƶ�����Ͳ߷�����У�飩��
	4.������ļ��в�Ҫ���հ��к��У�
	5.����������������������Զ���֤��ֻ�з���Ҫ��ļ�¼���ܱ����롣
	<span style="color : red">6.�ϴ�֮���Զ���ת��չʾ������δ�ɹ�����ļ�¼����ҳ�棬��δ��ʾ�κμ�¼���������ϴ������м�¼������Ҫ��</span>
    	<%-- 
	5.�����ļ�������Ҫ��������У�顢Ȼ����ܽ������ݵ��롣
     --%>
        </pre>	
        </td>
         
      </tr>
       
   </table>
   <br>
</fieldset>
</td>
</tr>
<tr>
<td>
	

<fieldset style="width:80%" align="center">
 <legend>
		<span class="headtitle">�ļ�����</span>
</legend>
<%-- 
<table width="84%"  border=0 align="center" cellpadding="0" cellspacing="0">
      <tr> 
        <td width="20%" height=30 align="right">�����ļ���</td>
        <td width="80%" height=30><input type="file" name="file" size="60" value=""><td>
      </tr>
      <tr> 
        <td colspan=2 align="center"><input class="form_button" type="button" name="upload" value="ȷ��" onClick="javascript:onClickUpload()" style="height:20px;">&nbsp;&nbsp;
        	<input class="form_button" type="reset" name="reset" value="ȡ��"></td>
      </tr>
   </table>
   --%>
   <br>
<div id="uploadDiv" style="padding-left: 20px"></div>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
		(function showPanel() {
		
			var vault = new dhtmlXVaultObject();
		   
		    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
		    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
		    vault.setFilesLimit(1);
		   	vault.create("uploadDiv");
		   	
		   	
		   	var _params = aihb.Util.paramsObj();
		   	
		   	//var taskId = new Date().toLocaleString() + "@" + _params.loginname + "@" + _params.areaid;
		   	//var taskId = new Date().toLocaleString() + "@" + _params.loginname;
		   	var taskId = new Date().format("yyyymmdd") + "@" + _params.loginname;
		   	
		   	vault.setFormField("tableName", "COMPETE_OPPSTATE_UPLOADTEMP");
	    	vault.setFormField("columns", "taskid,OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE");
	    	vault.setFormField("date", taskId);  
	    	
	    	vault.onUploadComplete = function(files) {
	    		this.removeAllItems();
	    		var sql=encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='�߷�������ͬ' where taskid='" + taskId + "' and OPP_NBR in (select distinct OPP_NBR from COMPETE_OPPSTATE )");
				sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='�ƶ�������ͬ' where taskid='" + taskId + "' and ACC_NBR in (select distinct ACC_NBR from COMPETE_OPPSTATE )");
				sql += "&sqls=" + encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='�ɹ�' where taskid='" + taskId + "' and value(flag,'') not in ('�߷�������ͬ','�ƶ�������ͬ')");
				sql += "&sqls=" + encodeURIComponent("insert into  COMPETE_OPPSTATE (OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,STATE,INSERTMAN) select OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,'1','" + _params.loginname + "' from COMPETE_OPPSTATE_UPLOADTEMP where taskid='" + taskId + "' and flag='�ɹ�'");
				sql += "&sqls=" + encodeURIComponent("delete from COMPETE_OPPSTATE_UPLOADTEMP where taskid='" + taskId + "' and flag='�ɹ�'");
				var ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/sqlExec"
				,parameters : "sqls="+sql
				,loadmask : false
				,callback : function(xmlrequest){
					window.location = "uploadinfo.html?taskId=" + taskId;
				}
			});
				ajax.request();
	    	}
		})();
	</script>
	<%-- 
		<div id="taskId" style="font-size: 14px;display : none">�ϴ���ɡ������ϴ����κ�Ϊ:<span style=" color :red"><%=taskId %></span>&nbsp;&nbsp;������μǣ��Ա�鿴��</div>
	--%>
</fieldset>
</td>
</tr>
<tr>
<td align="center"><a href="javascript:openhtml_p('feedbackmain','�������������ѯ','feedbackMain.jsp')">�������������ѯ</a>&nbsp;&nbsp;<%--  ��ѯ��ʽ������ --%>
<%-- 
<a href="javascript:openhtml_p('batchdetail','�������ݲ鿴','batchdetail2.jsp?taskId=<%=taskId %>')">�������ݲ鿴</a> 
--%>
</td>
</tr>
</table>
</form>
<form name="form2" action="" method="POST">
</form>
</body>
</html>