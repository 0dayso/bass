<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.asiainfo.common.Configure" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="FeedbackXls2DB" scope="page" class="bass.common.FeedbackXls2DB" />
<%
String loginname="";
if(session.getAttribute("loginname")==null){
  response.sendRedirect("/hbbass/error/loginerror.jsp");
	return;
}
else{
	loginname=(String)session.getAttribute("loginname");
}	 


String HBLocalPath = Configure.getInstance().getProperty("HBLocalPath");
String downPath="";

  java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHmmss"); 
  java.util.Date currentTime_1 = new java.util.Date();
  // �޸���ǰ���ɵ�һexcel�ļ�,�ĳɰ����û��͵�ǰʱ������excel�ļ�
  String filename = "�ͻ�����"+loginname+formatter.format(currentTime_1)+".xls"; 


FeedbackXls2DB.wirteXls(loginname,filename);

downPath=HBLocalPath+"\\down\\feedback\\downExcel\\"+filename;
File file = new File(downPath);
String downfilename = URLEncoder.encode(filename, "UTF-8");

//����HTTPͷ
response.reset();
response.setContentType("octet-stream; charset=utf-8");
response.addHeader("Content-Disposition","attachment; filename=" + downfilename);
response.setContentLength((int) file.length());

//д��������
byte[] buffer = new byte[4096];
OutputStream output = null;
InputStream input = null;
try {
    output = response.getOutputStream();
    input = new FileInputStream(file);

    int r = 0;
	while((r = input.read(buffer, 0, buffer.length)) != -1) {
		output.write(buffer, 0, r);
	}
	response.flushBuffer();
} catch (Exception e) {
} // maybe user cancelled download
finally {
    if(input != null) input.close();
    if(output != null) output.close();
}
%>
