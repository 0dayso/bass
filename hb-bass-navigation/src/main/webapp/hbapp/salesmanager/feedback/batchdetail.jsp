<%@ page contentType="text/html; charset=utf-8"  %>
<%@ page import="com.asiainfo.common.Configure,bass.common.UpdateBean" %>
<jsp:useBean id="ReportBean" scope="page" class="bass.database.report.ReportBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="FeedbackXls2DB" scope="page" class="bass.common.FeedbackXls2DB" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
<title>无标题文档</title>
<style type="text/css">
<!--
.form_button_long{
	BORDER-RIGHT: #7b9ebd 1px solid; 
	BORDER-TOP: #7b9ebd 1px solid; 
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px ,2px; 
	FONT-SIZE: 12px; 
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); 
	CURSOR: hand; 
	COLOR: black;
 	width:120px;
 	height:20px;
}
@import url(/hbbass/css/com.css);
-->
</style>
<script language=javascript>
function checkBureau(flag)
{
	  document.form1.action="batchdetail.jsp?flag="+flag ;
    document.form1.submit();
}

function goBack()
{
    document.form1.action="batchmain.jsp" ;
    document.form1.submit();
}

function downExcel()
{
form2.action="downExcel.jsp";
form2.target="_self";
form2.submit();	
}


</script>
<%
  String loginname=(String)session.getAttribute("loginname");
	String flag=request.getParameter("flag")==null?"":request.getParameter("flag");
	
	String loadresult=request.getParameter("loadresult")==null?"":request.getParameter("loadresult");
	loadresult=new String(loadresult.getBytes("ISO-8859-1"),"gb2312");
	String checkflag=request.getParameter("checkflag")==null?"disabled":request.getParameter("checkflag");
	String loadmessage="";
	if(flag.equals("1"))
	{ 
	    checkflag="";
	    UpdateBean ub=new UpdateBean();

      FeedbackXls2DB.checkData(loginname,"0");   //校验通过的状态
	    FeedbackXls2DB.checkData(loginname,"1");   // 导入文件自身移动手机号重复
	    FeedbackXls2DB.checkData(loginname,"2");   //导入文件自身策反号码重复
	    FeedbackXls2DB.checkData(loginname,"3");   // 与历史数据移动手机号重复
	    FeedbackXls2DB.checkData(loginname,"4");   // 与历史数据策反号码号重复
	    
	// 计算导入的总记录数
	String sqlnum="select count(*) allnum,count(case when flag='0' then flag end) innum,count(case when flag<>'0' then flag end) outnum from COMPETE_OPPSTATE_batchmid  where INSERTMAN='"+loginname+"' with ur";
	// 查询导入记录数
	ReportBean.execute(sqlnum);
	 loadmessage="文件记录"+ReportBean.getStringValue("allnum",0)+"条，合法记录"+ReportBean.getStringValue("innum",0)+"条，非法记录"+ReportBean.getStringValue("outnum",0)+"条";	 
		  out.print("<script>alert('"+loadmessage+"')</script>");
	}
  else if(flag.equals("3"))
  {    // 执行批量处理

	  	boolean doflag=false;
			doflag=FeedbackXls2DB.addData(loginname);
			if(doflag)
			{
	%>
	  <script language=javascript>
	  if(confirm("批量操作结束!,需要返回到批量维护首页吗?"))
	  window.location="batchmain.jsp" ;
    </script>
	<%		
			}
		else
			out.println("<script>alert('批量操作失败!');</script>");
  }

	// 提取出不规范的数据展示到前台共用户下载,修正后重新导入
  String sql="select OPP_NBR,ACC_NBR,NAME,MANAGER_ID, "+
	           "case  when FLAG='-1' then '没有进行校验'   when FLAG='1' then '导入文件自身移动手机号重复' when FLAG='2' then '导入文件自身策反号码重复' "+
	           "when FLAG='3' then '与历史数据移动手机号重复'  when FLAG='4' then '与历史数据策反号码号重复'  end flag2,flag  from COMPETE_OPPSTATE_batchmid where INSERTMAN='"+loginname+"' and flag<>'0' order by flag,OPP_NBR,ACC_NBR with ur";

	// 查询不规范数据
  ReportBean.execute(sql);
%>
<form id="form1" name="form1" method="post" action="">
<input type="hidden" name="checkflag" value="<%=checkflag%>">
<table id="resultTable2" border='1' cellpadding='0' cellspacing='0' style='TABLE-LAYOUT: fixed; WORD-BREAK: break-all; border-collapse: collapse' bordercolor='#537EE7' width='100%'>
<tr>
<td bgcolor='#EFF5FB' valign='top' width="100%">
<div style='width:100%;height:470;overflow:auto'>
		<table id="resultTable" border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#537EE7' width='98%'>
		<tr bgcolor='#80ACDC' height='20'>
		  <td align='center'>策反号码</td>
		 	<td align='center'>移动号码</td>
		  <td align='center'>客户经理姓名</td>
			<td align='center'>客户经理ID</td>
			<td align='center'>状态</td>
		</tr>
		<div style="width:100%">
		<%
		String bgcolor="#FFFFFF";
		String flagValue="";
		 for(int i=0;i<ReportBean.getRowCount();i++)
    {   
		     flagValue=ReportBean.getStringValue("flag",i);
		     if(flagValue.equals("0"))
		     {
		      	bgcolor="#A9C9FA";
		     }
		     else if(flagValue.equals("1"))
		     {
		      	bgcolor="#EDA5CC";
		     }
		   	 else if(flagValue.equals("2"))
		  	 {
		  	 		bgcolor="#BCFCBC";
		  	 }
		     else if(flagValue.equals("3"))
		  	 {
		  			 bgcolor="#FAF3A0";
		  	 }
		     else if(flagValue.equals("4"))
		  	 {
		  			 bgcolor="#CB97FF";
		  	 }
		  	 else if(flagValue.equals("-1"))
		  	 {
		  			 bgcolor="#FFFFFF"; 
		  	 }
	
				%>
				<tr bgcolor="<%=bgcolor%>">
				   <td align="left" ><%=ReportBean.getStringValue("OPP_NBR",i)%></td>   
				   <td align="left" ><%=ReportBean.getStringValue("ACC_NBR",i)%></td>   
					 <td align="left" ><%=ReportBean.getStringValue("name",i)%></td> 
				   <td align="left" ><%=ReportBean.getStringValue("MANAGER_ID",i)%></td>                         
				   <td align="left" ><%=ReportBean.getStringValue("flag2",i)%></td>                         
				</tr>
				<%
				
		}
		%>
		</div>
		</table>
		</div>
</td>
</tr>
</table>
<table width="100%">
<tr>
<td align="right"><%=loadmessage%>&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="form_button"  style="width:90" name="btcheck" value="信息校验" onclick="checkBureau('1');">&nbsp;&nbsp;
<input type="button" class="form_button" name="checkexist" value="返回" onclick="goBack()">&nbsp;&nbsp;
<input type="button" class="form_button" name="checkdown" value="下载" onclick="downExcel()">&nbsp;&nbsp;
<input type="button" class="form_button" name="btconfirm" value="导入" onclick="checkBureau('3')" <%=checkflag%>>&nbsp;&nbsp;
</td>
</tr>
</table>
</form>
<form id="form2" name="form2" method="post" action="">
	</form>
</body>
</html>