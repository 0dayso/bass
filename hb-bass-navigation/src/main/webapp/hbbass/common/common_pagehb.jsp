<%@ page contentType="text/html; charset=gb2312" %>
<body background="/hbbass/images/bg-1.gif" leftmargin="0" topmargin="00" marginwidth="0" marginheight="0">
<input type="hidden" name="nextPage2" value="<%=nextPage%>">
       
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="1" class="page">
    <tr> 
            
      <td width="33%"> 
        <div align="center">共<%=DivpageHB.getAllRowCount()%> 条，列出第<%=DivpageHB.getBeginRow()%>到第<%=DivpageHB.getEndRow()%>条</div>
            </td>
    <td width="26%"> 
      <div align="center"> 
        <% if (DivpageHB.getMaxPage() <= 1){ %>
        首页
        <% } else { %>
        <a href='javascript:nextpage(0)'>首页</a> 
        <% } %>
        <% if (DivpageHB.getNextPage() <= 1){ %>
        上页 
        <% } else { %>
        <a href='javascript:nextpage(<%=DivpageHB.getNextPage()-2%>)'>上页</a> 
        <% } %>
        <% if (DivpageHB.getIfNext()){ %>
        <a href='javascript:nextpage(<%=DivpageHB.getNextPage() %>)'>下页</a> 
        <%}else{%>
        下页 
        <%}%>
        <% if (DivpageHB.getMaxPage() <= 1){ %>
        尾页 
        <% } else { %>
        <a href='javascript:nextpage(<%=DivpageHB.getMaxPage()-1%>)'>尾页</a> 
        <%}%>
      </div>
            </td>
            
      <td width="18%"><div align="center">第<%=DivpageHB.getNextPage()%>/<%=DivpageHB.getMaxPage()%>页</div></td>
            
      <td width="23%"> 
        <div align="center"><input type="button" class="button" name="Submit2" value="转到" onclick="changepage(document.form1.FUNpage1.value)" style="border:1pt solid #636563;height:18px;background-color:#ffffff;filter:chroma(color=#ffffff);color:blue">
                <input type="text" name="FUNpage1" size="4" class="text_field">
          页 
        </div>
            </td>
          </tr>
        </table>
     <!--/form-->
<script>

function changepage(page){
  if (page*1==page && page>0 && page<=<%=DivpageHB.getMaxPage()%>)
     {nextpage(page-1)}
  else {alert("请输入正确的页数!");}
}

function nextpage(page){

	document.form1.nextPage2.value=page;
	document.form1.action='';
	document.form1.target = "_self";  
	document.form1.submit();

//window.open("?nextPage="+page,"_self");
}
</script>