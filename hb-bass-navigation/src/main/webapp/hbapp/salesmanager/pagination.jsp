<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.text.NumberFormat,java.util.*,bass.database.report.ReportBean"%>
<jsp:useBean id="Divpage" scope="page" class="bass.common.DevidePageBean" />
<jsp:useBean id="cppool" scope="application" class="bass.database.compete.CompetePool"/>
<jsp:useBean id="selectSum" scope="page" class="bass.database.report.ReportBean"/>
<jsp:useBean id="selectTop10" scope="session" class="bass.database.report.ReportBean"/>
<jsp:useBean id="cptool" scope="application" class="bass.database.compete.ExtreInc"/>
<%--��ҳ Script ������--%>
<SCRIPT language="JavaScript">
function help()                    
{                    
var userwindow=window.open('cp_pahelp.jsp' , "SelectUserWindow", "height=200, width=400, left=620, top=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no");
userwindow.focus();
}
function setTarget()
{
	top.frames['left'].document.all('d1').className='unnamed5';
	top.frames['left'].document.all('d2').className='target';
}
function down()
{
	document.form1.action = "pagenationDown.jsp";
	document.form1.target = "_parent";   
	document.form1.submit();
}
</SCRIPT>
<%
String loginname="";
if(session.getAttribute("loginname")==null){
    response.sendRedirect("/hbbass/error/loginerror.jsp");
	return;
}
else{
	loginname=(String)session.getAttribute("loginname");
}	 

//ȡArea_idֵ
int area_id = Integer.parseInt((String)session.getAttribute("area_id"));
String area_code = String.valueOf(area_id);
String scope = request.getParameter("radio");
String strSQL = request.getParameter("strSQL")==null?"":request.getParameter("strSQL");
String top10SQL = request.getParameter("top10SQL")==null?"":request.getParameter("top10SQL");
String wherecon="";
String areaname="";

int num=15000;

if(strSQL=="")
{    
    //ѡ�񵥸��������ֺ���
	if(scope.equals("single"))
	{
				String acc_nbr = request.getParameter("acc_nbr");
				
				strSQL = "select opp_nbr,time_id,call_times,zj_times,bj_times,sum_durs,zj_dura,bj_dura,dealer_code,com_mb_number,b.area_name as area_name from Opp_analys a,mk.bt_area b where a.area_id=b.area_code and  opp_nbr = '"+acc_nbr+"' order by time_id desc with ur";

	}
	//����ѡȡ�������ָ߶��û�
	else if(scope.equals("batch"))
	{
						wherecon = "and (dealer_code='"+request.getParameter("1calledtype")+"') and time_id="+request.getParameter("1abegintime1")+request.getParameter("1abegintime2");
						if(request.getParameter("area_high")!=null)
						{
							if(!request.getParameter("area_high").equals("0"))
								wherecon+=" and a.area_id = '"+request.getParameter("area_high")+"'";
						}
					    strSQL="select opp_nbr,time_id,call_times,zj_times,bj_times,sum_durs,zj_dura,bj_dura,dealer_code,com_mb_number,b.area_name as area_name from Opp_analys a,mk.bt_area b where a.area_id=b.area_code "+wherecon+" order by call_times desc fetch first "+num+" rows only";
				
					//	strSQL="select * from Opp_analys "+wherecon+" order by call_times desc fetch first 200 rows only";
					if(request.getParameter("area_high").equals("0"))
					{
				     areaname="ȫʡ";  
				    }     
				   else
				   {
				     ReportBean   citybean=new ReportBean();
				     String citysql="select area_name from mk.bt_area where area_code='"+request.getParameter("area_high")+"'";
				     citybean.execute(citysql);
				    
				     areaname = citybean.getStringValue("area_name",0);
				   }
	}
	else if(scope.equals("all"))
	{
					String areacon="";
					String callDuraCondition=" ";
					//��������
					String area=request.getParameter("area");
				    
					//SQL����е����where����
					if(!area.equals("0"))
						areacon=" and a.area_id='"+area+"'";
					//ͨ�����ڶ��ٷ���
					String sum_durs = request.getParameter("calldura");
					//ͨ���Զ�����(��ͨGSM,CDMA,С��ͨ)
					String dealer_code = request.getParameter("calledtype");
					//ͨ�����ڶ��ٴ���
					String call_times = request.getParameter("calltimes");
					//ͳ��ʱ��(�꣬��)
					String begintime = request.getParameter("abegintime1")+request.getParameter("abegintime2");
					//ͨ��ʱ����SQL����
					String callduratype=request.getParameter("callduratype");
				
					if(!(sum_durs==null || sum_durs.equals("")))
					  { 
				    	if(callduratype.equals("10"))
					      {
					       callDuraCondition="  and sum_durs >="+ (new Integer(sum_durs)).intValue()*60;
					      }
					    else if(callduratype.equals("1"))
					           {
					            callDuraCondition="  and ZJ_DURA >= "+ (new Integer(sum_durs)).intValue()*60;
					           } 
						     else if(callduratype.equals("0"))
						            {
								    callDuraCondition="  and BJ_DURA >= "+ (new Integer(sum_durs)).intValue()*60;
								    }
					    }
					//ͨ��������SQL����
					String calltimetype=request.getParameter("calltimetype");
					String callTimeCondition=" ";
					if(!(call_times==null || call_times.equals("")))
					  {
					   if(calltimetype.equals("10"))
					     {
					      callTimeCondition="  and  call_times >="+call_times;
					     }
					   else if(calltimetype.equals("1"))
					          {
							   callTimeCondition="  and ZJ_times >="+call_times;
							   }
						    else if(calltimetype.equals("0"))
						           {
								    callTimeCondition="  and BJ_times >="+call_times;
								   }
						}  
				    		     
					//ȡ��������¼
					String rowcount = request.getParameter("rowcount");
				
						
						strSQL = "select opp_nbr,time_id,call_times,zj_times,bj_times,sum_durs,zj_dura,bj_dura,dealer_code,com_mb_number,b.area_name as area_name from Opp_analys a,mk.bt_area b where a.area_id=b.area_code  "+callDuraCondition+" and (dealer_code='"+dealer_code+"')  "+callTimeCondition+" and time_id="+begintime+areacon+" order by call_times desc fetch first "+rowcount+" rows only with ur";
			        
					
					if(request.getParameter("area").equals("0"))
				      { areaname="ȫʡ";  }    
				   else
				      {
				       ReportBean   citybean=new ReportBean();
				       String citysql="select area_name from mk.bt_area where area_code='"+request.getParameter("area")+"'";
				       citybean.execute(citysql);
				    
				       areaname = citybean.getStringValue("area_name",0);
		              }
     }
}
int nextPage = 0;
try
  {
	nextPage = new Integer(request.getParameter("nextPage2")).intValue();
  }
catch (Exception e)
  {
  }
Divpage.setNextPage (nextPage);
Divpage.setPerPage (10);
Divpage.setQuerySQL (strSQL); 
System.out.println("------:"+strSQL);
%>

<%--����--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>�ͻ���ʧ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
@import url(/hbbass/css/com.css);
-->
</style>
<style type="text/css">
.result_v_2 {
	font-family: "����";
	font-size: 12px;
	line-height: 20px;
	color: #000000;
	background-color: #EBEBEB;
}
.style1 {color: #663399}
.style3 {
	color: #663399;
	font-size: 12px;
	font-weight: bold;
}
.style4 {font-family: "����"; font-size: 12px; line-height: 20px; color: #FF3300; background-color: #EBEBEB; }
</style>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<input type="hidden" name="strSQL" value="<%=strSQL%>">
<input type="hidden" name="radio" value="<%=scope%>">

  <table width="100%" border="0" cellpadding="0" cellspacing="0">
 <!-- 	<tr>
		<td>
		<font color="#003399">����λ�ã�<A class=submenu>�ڸ߷��������������û���ѯ����ѯ��� </A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:help();" >����<img src="/images/hot1.gif" width="17" height="11" border="0"></a></font> 
		</td>
	</tr>
-->	
     <tr>
      <td rowspan="2" valign="top" bgcolor="#FAFCFA"> <input type="hidden" name="scope" value="<%=scope%>">
<%if(!scope.equals("single"))
  {
	String showarea=request.getParameter("showarea")==null?"":request.getParameter("showarea");
	String dealer_code=request.getParameter("dealer_code")==null?"":request.getParameter("dealer_code");
	String topSQL="";
	if(request.getParameter("topSQL")==null)
	{
		String wherecon2="";
		if(scope.equals("batch"))
		{
			dealer_code=request.getParameter("1calledtype");
			wherecon2 = "where (dealer_code='"+dealer_code+"') and time_id="+request.getParameter("1abegintime1")+request.getParameter("1abegintime2");
			showarea = request.getParameter("area_high");
			if(request.getParameter("area_high")!=null)
			{
				if(!request.getParameter("area_high").equals("0"))
					wherecon2+=" and area_id = '"+request.getParameter("area_high")+"'";
			}
		}
		else
		{
			String areacon="";
			String area=request.getParameter("area");
			showarea=area;
			if(!area.equals("0"))
				areacon="and area_id='"+area+"'";
			dealer_code = request.getParameter("calledtype");
			String begintime = request.getParameter("abegintime1")+request.getParameter("abegintime2");
			wherecon2="where (dealer_code='"+dealer_code+"') and time_id="+begintime;
			//String endtime = request.getParameter("aendtime1")+request.getParameter("aendtime2");
			if(request.getParameter("area")!=null)
			{
				if(!request.getParameter("area").equals("0"))
					wherecon2+=" and area_id = '"+request.getParameter("area")+"'";
			}
			
		
		}
		topSQL="select count(1) as count,sum(com_mb_number) as com_mb_number,sum(call_times) as call_times,sum(sum_durs) as sum_durs from Opp_analys "+wherecon2+"  group by time_id with ur";
		top10SQL="select opp_nbr from Opp_analys "+wherecon2+" ";
	}
	else
	{
		topSQL=request.getParameter("topSQL");
		top10SQL=request.getParameter("top10SQL");
	}

	selectSum.execute(topSQL);
	String divisor = selectSum.getStringValue("count",0);
	/**2005-1-12 ����ʱ��ѡ�񲻶�����ת���쳣*/
	if(divisor.equals(""))
		divisor = "1";

	// 060228 portal ��ֲ�޸�
	String usertype="��ͨȫ��";
	
	if(dealer_code.equals("ug"))
	         usertype="��ͨGSM";
  else if(dealer_code.equals("uc"))
	         usertype="����C��";
	else if(dealer_code.equals("ph"))
	         usertype="С��ͨ";
  %>
  <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1">
                      <tr>
                        <td height="23" align="center" colspan="4" >
						<table width="100%"><tr><td width="55%" align="right"><%=areaname%>����<%=usertype%>�û�ͳ����Ϣ</td>
						  <td width="45%" align="right"><input type="button" name="ok" value="�� ��" onClick="down()" style="height:20px;"></td>
						</tr></table>
						</td>
                      </tr>
                      <tr><input type="hidden" name="top10SQL" value="<%=top10SQL%>"><input type="hidden" name="topSQL" value="<%=topSQL%>"><input type="hidden" name="dealer_code" value="<%=dealer_code%>"><input type="hidden" name="showarea" value="<%=showarea%>">
                        <td width="235" height="23"><div align="right"><span class="style3">�ϼ��û�</span>��</div></td>
                        <td width="208"class="style4"><%=selectSum.getStringValue("count",0).equals("")?"0":selectSum.getStringValue("count",0)%>��</td>
                        <td width="198"><div align="right"><span class="style1"><b>ƽ��ͨ��ʱ��</b></span>��</div></td>
                        <td width="338" class="style4"><%=cptool.devide(Double.parseDouble(selectSum.getStringValue("sum_durs",0).equals("")?"0":selectSum.getStringValue("sum_durs",0))/Double.parseDouble(divisor),60,0)%>��</td>
                      </tr>
                      <tr> 
                        <td width="235" ><div align="right"><span class="style1"><b>ƽ����ϵ�ƶ��û���</b></span>��</div></td>
                        <td width="208" class="style4"><%=cptool.devide(selectSum.getStringValue("com_mb_number",0).equals("0")?"0":selectSum.getStringValue("com_mb_number",0),divisor,0)%>��</td>
                        <td ><div align="right"><span class="style1"><b>ƽ��ͨ������</b></span>��</div></td>
                        <td class="style4"><%=cptool.devide(selectSum.getStringValue("call_times",0).equals("")?"0":selectSum.getStringValue("call_times",0),divisor,0)%>��</td>
                      </tr>
        </table>
<%
selectTop10.execute(top10SQL+"order by com_mb_number desc fetch first 8 rows only with ur");
ArrayList list1 = new ArrayList();
for(int i =0;i<selectTop10.getRowCount();i++)
{
	list1.add(selectTop10.getStringValue("opp_nbr",i));
}
/**2005-1-12�������������**/
if(selectTop10.getRowCount()==0)
	list1.add("��");
/*end*/
selectTop10.execute(top10SQL+"order by call_times desc fetch first 8 rows only with ur");
ArrayList list2 = new ArrayList();
for(int i =0;i<selectTop10.getRowCount();i++)
{
	list2.add(selectTop10.getStringValue("opp_nbr",i));
}
/**2005-1-12�������������**/
if(selectTop10.getRowCount()==0)
	list2.add("��");
/*end*/
selectTop10.execute(top10SQL+"order by sum_durs desc fetch first 8 rows only with ur");
ArrayList list3 = new ArrayList();
for(int i =0;i<selectTop10.getRowCount();i++)
{
	list3.add(selectTop10.getStringValue("opp_nbr",i));
}
/**2005-1-12�������������**/
if(selectTop10.getRowCount()==0)
	list3.add("��");
/*end*/
ArrayList list4 = cptool.getIn3List(list1,list2,list3);
%>
		<table width="100%" border="0" align="center" cellpadding="1" cellspacing="1">
                      <tr> 
                        <td width="18%" height="23"><div align="right" class="style1"><strong>��ϵ�ƶ��û������</strong>��</div></td>
                        <td width="82%" class="result_v_2"><%for(int i=0;i<list1.size();i++){%><!--a href="comcircle2.jsp?opp_nbr=<%--=(String)list1.get(i)--%>"--><font color="red"><%=(String)list1.get(i)%></font><!--/a-->&nbsp;&nbsp;&nbsp;<%}%></td>
					  </tr>
					   <tr> 
                        <td width="18%" height="23" ><div align="right" class="style1"><strong>ͨ���������</strong>��</div></td>
                        <td width="82%" class="result_v_2"><%for(int i=0;i<list2.size();i++){%><!--a href="comcircle2.jsp?opp_nbr=<%--=(String)list2.get(i)--%>"--><font color="red"><%=(String)list2.get(i)%></font><!--/a-->&nbsp;&nbsp;&nbsp;<%}%></td>
					  </tr>
					   <tr> 
                        <td width="18%" height="23"><div align="right" class="style1"><strong>ͨ��ʱ���</strong>��</div></td>
                        <td width="82%" class="result_v_2"><%for(int i=0;i<list3.size();i++){%><!--a href="comcircle2.jsp?opp_nbr=<%--=(String)list3.get(i)--%>"--><font color="red"><%=(String)list3.get(i)%></font><!--/a-->&nbsp;&nbsp;&nbsp;<%}%></td>
					  </tr>
					  <tr> 
                        <td width="18%" height="23" ><div align="right" class="style1"><strong>����ָ�������ǰ</strong>��</div></td>
                        <td width="82%" class="result_v_2"><%for(int i=0;i<list4.size();i++){%><!--a href="comcircle2.jsp?opp_nbr=<%--=(String)list4.get(i)--%>"--><font color="red"><%=(String)list4.get(i)%></font><!--/a-->&nbsp;&nbsp;&nbsp;<%}%></td>
					 </tr>
        </table>
<%}%>
        <table width="98%" height="104" border="0" align="center" cellpadding="3">
        <tr> 
          <td valign="top" height="96"> <div align="center"><%if(scope.equals("single")&&Divpage.getRowNum()==0) out.print("������ѯ�ĺ��벻�Ǹ߶��û�!");%> </div>
          <TABLE width="98%" border="1" align="center" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#e7e7e7">
                <tr class="result_t">
                  <td width="9%" align="center"><font color="#000066"><b>�ֻ�����</b></font></td> 
                  <td width="13%" align="center"><font color="#000066"><strong>��ϵ�ƶ��û���</strong>(��)</font></td>
				  <td width="9%" align="center"><font color="#000066"><strong>ͨ������</strong>(��)</font></td>
				  <td width="9%" align="center"><font color="#000066"><strong>���д���</strong>(��)</font></td>
				  <td width="9%" align="center"><font color="#000066"><strong>���д���</strong>(��)</font></td>
                  <td width="9%" align="center"><font color="#000066"><b>ͨ��ʱ��</b>(��)</font></td>
				  <td width="9%" align="center"><font color="#000066"><b>����ʱ��</b>(��)</font></td>
				  <td width="9%" align="center"><font color="#000066"><b>����ʱ��</b>(��)</font></td>
                  <td width="10%" align="center"><font color="#000066"><strong>��������Ʒ��</strong></font></td>
                  <td width="6%" align="center"><font color="#000066"><strong>����</strong></font></td>
                  <td width="7%" align="center"><font color="#000066"><strong>�·�</strong></font></td>
			    </tr>
                <%	
               String tr_class="";
				    String alert = "#000066";

	for(int i=1;i<=Divpage.getRowNum();i++)
	{
		String title = "";
		if(nextPage==0&&i<4)
		{
			alert = "red";
			title = "title='�澯�û������ƶ��û���ϵ������е�"+i+"λ'";
		}	
		else
			alert = "#000066";
	    if(i%2==0)
        tr_class="result_v_2";
     else
   	   tr_class ="result_v_1";
		
%>
                <tr class=<%=tr_class%>  onMouseOver="this.className='result_v_3'"  onMouseOut="this.className='<%=tr_class%>'">
                  <td align="center"><a href="comcircle2.jsp?opp_nbr=<%=Divpage.getFieldValue("opp_nbr",i)%>&com_mb_number=<%=Divpage.getFieldValue("com_mb_number",i)%>&time_id=<%=Divpage.getFieldValue("time_id",i)%>" <%=title%> onClick="setTarget()"><font color="<%=alert%>">&nbsp;<%=Divpage.getFieldValue("opp_nbr",i)%></font></a></td> 
                  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("com_mb_number",i)%></font></td>
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("call_times",i)%></font></td>
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("zj_times",i)%></font></td>
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("bj_times",i)%></font></td>
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("sum_durs",i).equals("")?"":cptool.getMinute(Divpage.getFieldValue("sum_durs",i))%></font></td>         
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("zj_dura",i).equals("")?"":cptool.getMinute(Divpage.getFieldValue("zj_dura",i))%></font></td>
				  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("bj_dura",i).equals("")?"":cptool.getMinute(Divpage.getFieldValue("bj_dura",i))%></font></td>
                  <td align="center"><font color="#000066">&nbsp;
                  <%
                   String 	dealer=Divpage.getFieldValue("dealer_code",i)	;	
			             String dealer1="";
                       if(dealer.equals("ug"))
                         dealer1="��ͨGSM";
                       else if(dealer.equals("uc"))
                         dealer1 ="����C��";
                       else if(dealer.equals("ph"))
                       	dealer1= "С��ͨ";
                       else
                          dealer1= "����";
                          out.print(dealer1);
                  %></font></td>
                  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("area_name",i)%></font></td>
                  <td align="center"><font color="#000066">&nbsp;<%=Divpage.getFieldValue("time_id",i)%></font></td>
                </tr>
     <%}%>
              </table>
	          <%@ include file="/hbbass/common/common_page.jsp" %>
            </td>
        </tr>
      </table></td>
  </tr>
</table>
</form>
</body>
</html>