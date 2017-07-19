<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="java.io.*,java.util.*,struts.utility.*"%> 
<jsp:useBean id="sysmenulog" scope="application" class="com.hbmobile.hbbass.database.SysMenuItemDB"/>
<jsp:useBean id="VISITLISTFactory" scope="application" class="bass.database.VISITLISTFactoryDB"/>
<%@ page import="com.hbmobile.hbbass.SysMenuItem"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>经营分析报告</title>
<style type="text/css">
@import url("/hbbass/css/com.css");
</style>
</head>

<%
String loginname="";
//session.setAttribute("area_id","270");
if (session.getAttribute("loginname") != null) {
	 loginname = new String(((String) session.getAttribute("loginname")).getBytes("iso-8859-1"));
} else {
    response.sendRedirect("/hbbass/error/loginerror.jsp");
}

int area_id = Integer.parseInt((String)session.getAttribute("area_id"));

String path = application.getRealPath("/hbbass/menudown/handbook/down/");
System.out.println(path);
String[] filenames = new String[]{};

	File file = new File(path);
	filenames = file.list(this.new Filter());

System.out.println(filenames.length);

//增加写日志模块

    Calendar cal= GregorianCalendar.getInstance();
    int year=cal.get(Calendar.YEAR) ;              //年
    int month=cal.get(Calendar.MONTH)+1 ;          //月
    int date=cal.get(Calendar.DATE) ;              //日
    String time =cal.getTime().toLocaleString() ;
    int pos=time.indexOf(" ");
    time=time.substring(pos+1) ;                   //时刻
    
   String IP=request.getRemoteAddr();
   String url="/direct.jsp?url=/hbbass/menudown/handbook/handbook.jsp";
	 SysMenuItem sysmenu=sysmenulog.findSysMenuItem(url) ;
	 int menuitemid = sysmenu.getMenuitemid();
	 int parentid = sysmenu.getParentid();
	 String menuitemtitle = sysmenu.getMenuitemtitle();

   if(parentid!=0)
      {
           SysMenuItem sysmenu_top=sysmenulog.findSysMenuItem_top(url);
           int menuitemid_top = sysmenu_top.getMenuitemid();
           int parentid_top = sysmenu_top.getParentid();
           String menuitemtitle_top = sysmenu_top.getMenuitemtitle(); 
        //暂时屏蔽访问模块记录操作     
       // 	FPF_VISITLISTFactory.createVISITLIST(loginname, year, month, date, time, IP, area_id, String.valueOf(menuitemid_top), menuitemtitle_top, menuitemtitle);
      }

%><%!
private class Filter implements FilenameFilter {
	public boolean accept(File dir, String name) {
		if(name.endsWith(".doc")||name.endsWith(".rar")||name.endsWith(".xls")||name.endsWith(".ppt"))
		{
			return true;
		} else {
			return false;
		}
	}
}
%>
<body>
<form>
<table border=1 borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0 width="80%" align="center">
  <tr style='height:14.25pt' bgcolor="#e4e9ff">
    <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap align="center"><strong>系统操作手册</strong></td>
  </tr>
<%
	for (int i = 0; i < filenames.length; i++) {
%>  <tr style='height:14.25pt' bgcolor="#e4e9ff">
     <td align="center" class="row1"><a href="FileDown.jsp?filename=<%=filenames[i]%>"><%=filenames[i]%></a></td>
<!--    <td align="center" class="row1"><a href="<%=filenames[i]%>" target="_blank"><%=filenames[i]%></a></td> -->
  </tr>
<%
	}

%>

</table>
</form>
</body>
</html>
