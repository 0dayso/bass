<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
	String oriChartset="iso-8859-1";
	String newChartset="gbk";
	String title= request.getParameter("title");
	if(title!=null)title= new String(title.getBytes(oriChartset),newChartset);
	String order= request.getParameter("order");
	if(order!=null && order.length()>0)order= new String(order.getBytes(oriChartset),newChartset);
	else order="1";
	
	String sql= request.getParameter("sql");
	if(sql!=null)sql= new String(request.getParameter("sql").getBytes(oriChartset),newChartset);	
	String filename= request.getParameter("filename");
	if(filename!=null)filename= new String(filename.getBytes(oriChartset),newChartset);
	
	int rownum=Integer.parseInt(request.getParameter("allPageNum"));
	
	int perCount=60000;//设置每个文件显示的行数
	int fileNums = rownum%perCount==0?rownum/perCount:rownum/perCount+1;  // 显示所有记录需要的文件数
	
	String ds = request.getParameter("ds");
	if(ds == null) ds = "";	
	StringBuffer orderSql = new StringBuffer(sql);
	
	orderSql.insert(orderSql.lastIndexOf("from"), ",rownumber() over(order by "+order+") as rownum ");
	if(orderSql.toString().endsWith("with ur"))orderSql.delete(orderSql.indexOf("with ur"),orderSql.length());
	orderSql.append(") innertable where innertable.rownum between ");
	orderSql.insert(0, "select * from (");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>数据下载</title>
<script type="text/javascript">
var baseSql = "<%=orderSql%>";
var baseFileName="<%=filename%>"
function downPerFile(page,perPage)
{
	//alert("in");
	document.forms[0].sql.value= baseSql + ((page-1)*perPage+1) + " and " + (page*perPage) + " with ur";
	document.forms[0].filename.value = baseFileName + page;
 	document.forms[0].action = "<%=request.getContextPath()%>/hbbass/common2/commonDown.jsp";
	document.forms[0].target = "_top";
	//alert("will submit");
	document.forms[0].submit();
	//alert("submited");
}
</script>
<style>
<!--
a            { color: #0000FF; text-decoration: none }
a:link       { text-decoration: none; color: #0000FF; font-family: 宋体 }
a:visited    { text-decoration: none; color: #0000FF; font-family: 宋体 }
a:hover      { text-decoration: underline; color: #FF0000 }
a:active     { text-decoration: underline; color: #FF0000 }
body         { font-size: 9pt }
table        { font-size: 9pt }
.bt { font-family: 宋体; font-size: 14px }
-->
</style>
</head>
<body>
<form action="" method="post">
	<input type=hidden name=title value="<%=title+"排序号,"%>">
	<input type=hidden name=sql value="">
	<input type=hidden name=filename value="">
	<input type=hidden name=ds value="<%=ds %>">
<table width="450" border=1 align="center" cellPadding=3 cellSpacing=0 bordercolor="#000066" borderColorLight=#74c0f7 borderColorDark=#ffffff >
	<tr bgcolor="#e4e9ff">
    <td style="font-size:10.8pt;color:white"><strong></strong><font size="3" color="#000000">&nbsp;</font>
   	 <!--<div align="left"><font color="#000000" size="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;您要下载的数据有<font color=red><%=rownum%></font>行,为了保证系统安全，我们将您要下载的数据分成了<font color=red><%=fileNums%></font>个文件，每个文件最多<font color=red>10000</font>行，请选择下载文件(右键-另存为*.csv文件)</strong></font></div> -->
     <div align="left"><font color="#000000" size="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;为了保证系统的安全，系统将数据量大的查询结果分成多个文件下载，每个文件<font color=red><%=perCount%></font>行，您要下载的数据有<font color=red><%=rownum%></font>行，系统将您要下载的数据分成了<font color=red><%=fileNums%></font>个文件，请选择下载文件(右键-另存为*.csv文件)</strong></font></div>
    </td>
  </tr>
<%
 int perRow = 5;
 int allRows = fileNums%perRow==0?fileNums/perRow:fileNums/perRow+1;
 for(int i=0;i<allRows;i++)
 {
 	String bgColor = "#ffffe8";
	if(i%2==1)
		bgColor = "#e4e9ff";
%>
  <tr>
    <td  height="20" bgColor="<%=bgColor%>" align="center">
	<%
	int realPerRow =( i == allRows-1)?(fileNums%perRow == 0 ? perRow:fileNums%perRow):perRow;
	for(int j=1;j<=realPerRow;j++){%>
		<a href="#" onclick=downPerFile(<%=(i*perRow+j)%>,<%=perCount%>)>文件<%=(i*perRow+j)%></a>&nbsp;&nbsp;
	<%}%>	
		</td>
  </tr>
  <%}
  %>
</table>
<table width="450" border=0 align="center">  
<tr>
    <td  height="50" align="center" > 
    <a href="javascript:window.close()">【关闭】</a>
	</td>
  </tr>     
</table>
</form>
</body>
</html>
