<%@ page contentType="text/html; charset=gb2312" %>
<body background="/hbbass/images/bg-1.gif" leftmargin="0" topmargin="00" marginwidth="0" marginheight="0">
<input type="hidden" name="nextPage2" value="<%=nextPage%>">
       
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="1" class="page">
    <tr> 
            
      <td width="33%"> 
        <div align="center">��<%=Divpage.getAllRowCount()%> �����г���<%=Divpage.getBeginRow()%>����<%=Divpage.getEndRow()%>��</div>
            </td>
    <td width="26%"> 
      <div align="center"> 
        <% if (Divpage.getMaxPage() <= 1){ %>
        ��ҳ
        <% } else { %>
        <a href='javascript:nextpage(0)'>��ҳ</a> 
        <% } %>
        <% if (Divpage.getNextPage() <= 1){ %>
        ��ҳ 
        <% } else { %>
        <a href='javascript:nextpage(<%=Divpage.getNextPage()-2%>)'>��ҳ</a> 
        <% } %>
        <% if (Divpage.getIfNext()){ %>
        <a href='javascript:nextpage(<%=Divpage.getNextPage() %>)'>��ҳ</a> 
        <%}else{%>
        ��ҳ 
        <%}%>
        <% if (Divpage.getMaxPage() <= 1){ %>
        βҳ 
        <% } else { %>
        <a href='javascript:nextpage(<%=Divpage.getMaxPage()-1%>)'>βҳ</a> 
        <%}%>
      </div>
            </td>
            
      <td width="18%"><div align="center">��<%=Divpage.getNextPage()%>/<%=Divpage.getMaxPage()%>ҳ</div></td>
            
      <td width="23%"> 
        <div align="center"><input type="button" class="button" name="Submit2" value="ת��" onclick="changepage(document.form1.FUNpage1.value)" style="border:1pt solid #636563;height:18px;background-color:#ffffff;filter:chroma(color=#ffffff);color:blue">
                <input type="text" name="FUNpage1" size="4" class="text_field">
          ҳ 
        </div>
            </td>
          </tr>
        </table>
     <!--/form-->
<script>

function changepage(page){
  if (page*1==page && page>0 && page<=<%=Divpage.getMaxPage()%>)
     {nextpage(page-1)}
  else {alert("��������ȷ��ҳ��!");}
}

function nextpage(page){

	document.form1.nextPage2.value=page;
	document.form1.action='';
	document.form1.target = "_self";  
	document.form1.submit();

//window.open("?nextPage="+page,"_self");
}
</script>