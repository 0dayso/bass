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
<TITLE>湖北移动经营分析系统</TITLE>
<script language="javascript">
<%--
	//计算批次号
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
            alert("文件格式不对,请选择.xls文件!");
            return false;
        }
        document.form1.action="batchload.jsp" ;
        document.form1.upload.disabled= true;
        document.form1.submit();
    }
    else 
    {
        alert("请选择文件!");
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
<%--本页 jsp 初始化程序段--%>
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
		<span class="headtitle">模板文件</span>
	</legend>
   <table width="84%"  border=0 align="center" cellpadding="0" cellspacing="0">
      <tr> 
        <td width="40%" align="left"><a style="text-decoration: underline;" href="/hbbass/common/FileDown.jsp?filename=sample.xls&filepath=/hbbass/salesmanager/feedback/"><font color=blue><b>excel导入数据模板</b></font></a>&nbsp;</td>
        <td width="60%"><font color="red">请右键点击“目标另存为”下载</font><td>  
      </tr>
      <tr> 
        <td colspan=2 align="left" valign="middle">
        <pre>
<p>        	
导入说明：
	1.导入文件中不能有重复的记录(相同的策反号码和移动号码)；
	2.同一个移动号码不能对应多个策反号码；同一个策反号码也不能对应多个移动号码；
	3.导入的记录不能与已导入的历史记录相同（根据移动号码和策反号码校验）；
	4.导入的文件中不要留空白行和列；
	5.本程序将做基于上述规则的自动验证，只有符合要求的记录才能被导入。
	<span style="color : red">6.上传之后自动跳转到展示“本次未成功导入的记录”的页面，如未显示任何记录，代表本次上传的所有记录均符合要求。</span>
    	<%-- 
	5.导入文件后首先要进行数据校验、然后才能进行数据导入。
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
		<span class="headtitle">文件导入</span>
</legend>
<%-- 
<table width="84%"  border=0 align="center" cellpadding="0" cellspacing="0">
      <tr> 
        <td width="20%" height=30 align="right">导入文件：</td>
        <td width="80%" height=30><input type="file" name="file" size="60" value=""><td>
      </tr>
      <tr> 
        <td colspan=2 align="center"><input class="form_button" type="button" name="upload" value="确定" onClick="javascript:onClickUpload()" style="height:20px;">&nbsp;&nbsp;
        	<input class="form_button" type="reset" name="reset" value="取消"></td>
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
	    		var sql=encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='策反号码相同' where taskid='" + taskId + "' and OPP_NBR in (select distinct OPP_NBR from COMPETE_OPPSTATE )");
				sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='移动号码相同' where taskid='" + taskId + "' and ACC_NBR in (select distinct ACC_NBR from COMPETE_OPPSTATE )");
				sql += "&sqls=" + encodeURIComponent("update COMPETE_OPPSTATE_UPLOADTEMP set flag='成功' where taskid='" + taskId + "' and value(flag,'') not in ('策反号码相同','移动号码相同')");
				sql += "&sqls=" + encodeURIComponent("insert into  COMPETE_OPPSTATE (OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,STATE,INSERTMAN) select OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,'1','" + _params.loginname + "' from COMPETE_OPPSTATE_UPLOADTEMP where taskid='" + taskId + "' and flag='成功'");
				sql += "&sqls=" + encodeURIComponent("delete from COMPETE_OPPSTATE_UPLOADTEMP where taskid='" + taskId + "' and flag='成功'");
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
		<div id="taskId" style="font-size: 14px;display : none">上传完成。本次上传批次号为:<span style=" color :red"><%=taskId %></span>&nbsp;&nbsp;请务必牢记，以便查看。</div>
	--%>
</fieldset>
</td>
</tr>
<tr>
<td align="center"><a href="javascript:openhtml_p('feedbackmain','回流反馈号码查询','feedbackMain.jsp')">回流反馈号码查询</a>&nbsp;&nbsp;<%--  查询正式表，不改 --%>
<%-- 
<a href="javascript:openhtml_p('batchdetail','导入数据查看','batchdetail2.jsp?taskId=<%=taskId %>')">导入数据查看</a> 
--%>
</td>
</tr>
</table>
</form>
<form name="form2" action="" method="POST">
</form>
</body>
</html>