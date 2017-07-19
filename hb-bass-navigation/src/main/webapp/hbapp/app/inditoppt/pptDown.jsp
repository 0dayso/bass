<%@ page autoFlush="true" contentType="application/octet-stream; charset=utf-8"%>
<%@page import="java.util.List"%>
<%@page import="java.io.*,java.net.*"%>
<%
	String path = (String)request.getSession().getAttribute("path");
	String fileName = (String)request.getSession().getAttribute("fileName");
	
	File file = new File(path + "/" + fileName);
	response.reset();
	response.setContentType("octet-stream; charset=UTF-8");
	response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
	response.setContentLength((int) file.length());

	byte[] buffer = new byte[10240];
	OutputStream outputStream = null;
	InputStream in = null;
	try {
		outputStream = response.getOutputStream();
		in = new FileInputStream(file);
		int r = 0;
		while ((r = in.read(buffer, 0, buffer.length)) != -1) {
			outputStream.write(buffer, 0, r);
		}

		response.flushBuffer();
	} catch (IOException e) {
		//e.printStackTrace();
	} finally {
		if (in != null)
			in.close();
		if (outputStream != null)
			outputStream.close();

	}
	
%>