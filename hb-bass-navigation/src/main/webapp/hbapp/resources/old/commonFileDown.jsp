<%@ page language="java" errorPage="" %>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@page import="org.apache.log4j.Logger"%>
<%!
static Logger LOG = Logger.getLogger("com.asiainfo.commonFileDown.jsp");
%>
<%
String filepath = new String(request.getParameter("filepath"));
LOG.info("filepath==================="+filepath);
String filename = new String(request.getParameter("filename"));
String path = application.getRealPath(filepath);
LOG.info("filename==================="+filename);
LOG.info("path==================="+path);
File file = new File(path + "//" + filename);
filename = URLEncoder.encode(filename, "gbk");

//设置HTTP头
response.reset();
response.setContentType("octet-stream; charset=utf-8");
response.addHeader("Content-Disposition","attachment;filename=" + filename);
response.setContentLength((int) file.length());

//写缓冲区：
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
