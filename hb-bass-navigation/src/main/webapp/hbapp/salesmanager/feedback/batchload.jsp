<%@ page contentType="text/html; charset=utf-8"  %>
<%@ page import="com.asiainfo.common.Configure" %>
<jsp:useBean id="ReportBean" scope="page" class="bass.database.report.ReportBean"/>
<%@ page language="java" import="java.util.*,java.text.*,com.jspsmart.upload.*"%> 
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="FeedbackXls2DB" scope="page" class="bass.common.FeedbackXls2DB" />
<jsp:useBean id="QueryTools2" scope="page" class="bass.common.QueryTools2" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
<style type="text/css">
<!--
@import url(/hbbass/css/com.css);
-->
</style>
</head>
<%
  String loginname=(String)session.getAttribute("loginname");
  //根据登录名查询用户的信息 如用户所属的区域
 String area_id = (String)session.getAttribute("area_id");
 String area_code=QueryTools2.getAreaCode(area_id); // 根据11编码得到HB.WH 编码
  //将导入的.csv文件更名为 年月日时分秒.csv 存放在服务器上
  java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHmmss"); 
  java.util.Date currentTime_1 = new java.util.Date();
  
     mySmartUpload.initialize(pageContext);
   //设定最大上传文件大小  字节为单位  此处限制为10兆
    mySmartUpload.setTotalMaxFileSize(10*1024*1024);
   //设定上传文件的类型:  在前台提交的时候进行csv文件的校验。
   mySmartUpload.setAllowedFilesList("xls");
   mySmartUpload.upload();
   
     com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
     
     String filename = loginname+formatter.format(currentTime_1)+myFile.getFileName(); 

  if(!session.getAttribute("do").equals("yes"))
	{
		if (!myFile.isMissing())
	  {
		   try
		   {
		   		 myFile.saveAs("/hbbass/upload/feedback/" + filename );
	   		   FeedbackXls2DB.executeXls2DB(filename,loginname,area_code);
		   		
		    }
		    catch (Exception e)
		    {
		       out.println("<b>上传文件错误 : </b>" + e.toString());
		    } 
		 }
	 } 
	 	// 计算导入的总记录数
	String sqlnum="select count(*) num from COMPETE_OPPSTATE_batchmid where INSERTMAN='"+loginname+"' with ur";
	// 查询导入记录数
	ReportBean.execute(sqlnum);
	String insertNum=ReportBean.getStringValue("num",0)==null?"0":ReportBean.getStringValue("num",0);
	session.setAttribute("do","yes"); 
  //response.sendRedirect("batchdetail.jsp");
%>
<script>
		alert("成功导入数据<%=insertNum%>条，请先进行校验然后再进行导入");
		window.location="batchdetail.jsp";
	</script>