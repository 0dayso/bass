<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.Date,java.util.List,java.util.ArrayList"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE   html   PUBLIC   "-//W3C//DTD   XHTML   1.0   Strict//EN"   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html>
  <head>
 
    <title>�������</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="default.js" charset=utf-8></script>
		<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
		
		<script type="text/javascript" src="../../js/datepicker/WdatePicker.js"></script>
		
		
	<link rel="stylesheet" type="text/css" href="../../css/bass21.css" />
  </head>
 
  <script type="text/javascript">
 // �жϿ�ʼʱ���Ƿ���ڽ���ʱ��
    
	function doSubmit(){
	
	  var ss = document.forms[0].sdate.value;
	   
	  var dd =  document.forms[0].zdate.value;
	   
	  if (ss != "" && dd != ""){
	    var ss1 = ss.replace(/-/g,"/");
        var dd1 = dd.replace(/-/g,"/");
         
         if(Date.parse(ss1)-Date.parse(dd1)>0){ 
               alert("��ʼ����Ҫ�ڽ�������֮ǰ!"); 
               return ;
           }else{
               document.selectform.action = 'caiwujihe.jsp?startd='+ss+'&endd='+dd;
	           document.selectform.submit(); 
           }
      }else{
         alert("�������ѯʱ���");
         return ; 
      }
         
	}

  </script>

  <body >
  <% Date cdate = new Date();
     DateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
     String cString = formater1.format(cdate);
   %>
  <form action="" id="selectform" name="selectform" method="post" >
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="���ݲ�ѯ����">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;���ݲ�ѯ����:
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">	
				<table align="center" width="80%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" >   
					<tr class="dim_row">
					    
						<td class="dim_cell_title" align="right" colspan="2">��ʼʱ��:</td>
						<td class="dim_cell_content" align="left">					
							 <input type="text" value='<%=request.getParameter("sdate")==null?cString:request.getParameter("sdate") %>' id="sdate" name="sdate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
						</td>
						<td class="dim_cell_title" align="right" colspan="2">��ֹʱ��:</td>
						<td class="dim_cell_content" align="left" >				
							 <input type="text" value='<%=request.getParameter("zdate")==null?cString:request.getParameter("zdate") %>' id="zdate" name="zdate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>					
						</td>
					</tr>
					<tr class="dim_row">	    
						<td class="dim_cell_content" colspan="6" align="right"><input type="button" class="form_button" value="��ѯ" onClick="doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;</td>	
				</tr>
				</table>
								
			</div>
		</fieldset>
	</div>
	</form>
	<jsp:include page="basc.jsp"></jsp:include>
  </body>
</html>
