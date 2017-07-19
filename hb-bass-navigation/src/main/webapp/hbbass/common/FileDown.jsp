<%@ page language="java" errorPage="" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%

String filename = new String(request.getParameter("filename").getBytes("iso-8859-1"));
String filepath = request.getParameter("filepath")==null?"/down/":(String)request.getParameter("filepath");
String path = application.getRealPath(filepath);
//String path = application.getRealPath("/down/");

File file = new File(path + "\\" + filename);

filename = URLEncoder.encode(filename, "UTF-8");

//ÉèÖÃHTTPÍ·
response.reset();
response.setContentType("octet-stream; charset=utf-8");
response.addHeader("Content-Disposition","attachment; filename=" + filename);
response.setContentLength((int) file.length());

//Ð´»º³åÇø£º
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

out.clear();
out = pageContext.pushBody();
%>
</body>
</html>
