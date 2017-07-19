<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="bass.common.QueryTools3" %>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<title>复制卡疑似用户</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<script type="text/javascript" src="${mvcPath}/hbapp/resources/old/basscommon.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/bass21.css" /> 
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/com.css" />  

</head>
 <script type="text/javascript">
 	cellclass[0]="grid_row_cell_text";
 	cellclass[1]="grid_row_cell_number";
 	cellclass[2]="grid_row_cell_number";
 	cellclass[3]="grid_row_cell_number";

	pagenum=20;
 

function downListCountry()
{
  var querydate=document.forms[0].querydate.value;
  var querytype=document.forms[0].querytype.value;
  var queryTypeText = document.forms[0].querytype.options[document.forms[0].querytype.selectedIndex].text; //added by higherzl on 2010.06.18
  var city=document.forms[0].city.value;
  var cityname=document.forms[0].city.options[document.forms[0].city.selectedIndex].text;
  var querytypename=document.forms[0].querytype.options[document.forms[0].querytype.selectedIndex].text;
  var condition="";
  if(document.forms[0].city.value!="0")
		   condition+=" and CHANNEL_CODE like '"+document.forms[0].city.value+"%'";   
		   
	var sql="select acc_nbr,cust_name,b.itemname,c.new_site_name,eff_date,exp_date,mcust_tid,count,value(charge,0) "+
	         "  from nwh.mbuser_fzk a,mk.dim_areacity b,nwh.vdim_kpi_channel c where a.area_id=b.region and  a.channel_code=c.site_id  and time_id="+querydate+" and year(exp_date)*100+month(exp_date)="+querydate.substring(0,6)+" and flag="+querytype+condition+" with ur";
	         
	document.forms[0].sql.value=sql;
	document.getElementById("sqldiv").innerText=sql;
	document.forms[0].title.value="用户号码,用户名,地市,入网渠道,入网时间,停机时间,vip级别,"+querydate.substring(6,8)+"日的" + queryTypeText + "条数,	欠费金额（元）";
  document.forms[0].filename.value=querydate+cityname+querytypename+"复制卡疑似用户清单";
  document.forms[0].action="/hbbass/common/commonDown.jsp";
  document.forms[0].target="_self";
  document.forms[0].submit();
}

 function toPageDown()
{	
	
	 var sql=" ";
		var condition="";
		if(document.forms[0].city.value!="0")
		   condition+=" and CHANNEL_CODE like '"+document.forms[0].city.value+"%'";    
		
		var querydate=document.forms[0].querydate.value;
		var querytype=document.forms[0].querytype.value;
		
	
	sql="select value(b.itemname,'合计'),"+
		    " count( case when year(exp_date+2 day)*10000+month(exp_date+2 day)*100+day(exp_date+2 day)="+querydate+" then acc_nbr else null end), "+
		    " count( case when year(exp_date+3 day)*10000+month(exp_date+3 day)*100+day(exp_date+3 day)="+querydate+" then acc_nbr else null end), "+
		    " count( case when year(exp_date+3 day)*10000+month(exp_date+3 day)*100+day(exp_date+3 day)<"+querydate+ 
		    " and year(exp_date)*100+month(exp_date)="+querydate.substring(0,6)+" then acc_nbr else null end) "+
		    " from NWH.MBUSER_FZK  a,mk.dim_areacity b  where a.area_id=b.region  and flag="+querytype+"  and time_id="+querydate+condition+
		    " group by rollup(b.itemname) order by 2,3,4 with ur ";

    document.forms[0].sql.value = sql;
    
    var d1=new Date(querydate.substring(0,4), querydate.substring(4,6), querydate.substring(6,8));
     d1.setDate(d1.getDate()-2);
    var coltitle1=document.getElementsByName("coltitle1");
    for(var i=0;i<coltitle1.length;i++)
    {
    	coltitle1[i].innerHTML=d1.getDate();
    }
		
		d1.setDate(d1.getDate()-1);

		 var coltitle2=document.getElementsByName("coltitle2");
		 var coltitle3=document.getElementsByName("coltitle3");
		for(var i=0;i<coltitle2.length;i++)
    {
    	coltitle2[i].innerHTML=d1.getDate();
    	coltitle3[i].innerHTML=d1.getDate();
    }
		toDown();

}		
 
 
 function doSubmit()
{	
	
		var sql=" ";
		var condition="";
		if(document.forms[0].city.value!="0")
		   condition+=" and CHANNEL_CODE like '"+document.forms[0].city.value+"%'";    
		
		var querydate=document.forms[0].querydate.value;
		var querytype=document.forms[0].querytype.value;
		
	
		sql="select value(b.itemname,'合计'),"+
		    " count( case when year(exp_date+2 day)*10000+month(exp_date+2 day)*100+day(exp_date+2 day)="+querydate+" then acc_nbr else null end), "+
		    " count( case when year(exp_date+3 day)*10000+month(exp_date+3 day)*100+day(exp_date+3 day)="+querydate+" then acc_nbr else null end), "+
		    " count( case when year(exp_date+3 day)*10000+month(exp_date+3 day)*100+day(exp_date+3 day)<"+querydate+ 
		    " and year(exp_date)*100+month(exp_date)="+querydate.substring(0,6)+" then acc_nbr else null end) "+
		    " from NWH.MBUSER_FZK  a,mk.dim_areacity b  where a.area_id=b.region  and flag="+querytype+"  and time_id="+querydate+condition+
		    " group by rollup(b.itemname) order by 2,3,4 with ur ";

    document.forms[0].sql.value = sql;
		document.getElementById("sqldiv").innerText=sql;
		
		var d1=new Date(querydate.substring(0,4), querydate.substring(4,6), querydate.substring(6,8));
		//alert(d1);
		//alert(mDate(d1,2));

     d1.setDate(d1.getDate()-2);
    var coltitle1=document.getElementsByName("coltitle1");
    for(var i=0;i<coltitle1.length;i++)
    {
    	coltitle1[i].innerHTML=d1.getDate();
    }
		
		d1.setDate(d1.getDate()-1);

		 var coltitle2=document.getElementsByName("coltitle2");
		 var coltitle3=document.getElementsByName("coltitle3");
		for(var i=0;i<coltitle2.length;i++)
    {
    	coltitle2[i].innerHTML=d1.getDate();
    	coltitle3[i].innerHTML=d1.getDate();
    }
		
	  var countSql ="select count(*) from ("+sql+") as t with ur";
	  ajaxSubmitWrapper(sql,countSql);
		
}		
 
 function mDate(date,sum)
 {
    var ms = date.getTime();
    ms=ms-sum*24*60*60*1000;
    return new Date(ms).getDate();
  }



 </script>
 <%
 	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE,-1);//上一月
	DateFormat formater = new SimpleDateFormat("yyyyMMdd");
	String defaultDate = formater.format(cal.getTime());
	DateFormat formater2 = new SimpleDateFormat("yyyy-MM");
	String defaultDate2 = formater2.format(cal.getTime());
	
	// session.setAttribute("area_id","0");
 %>
 <body>
  <form action="" method="post">
	  <div id="hidden_div">
			<input type="hidden" id="allPageNum" name="allPageNum" value="">
			<input type="hidden" id="sql" name="sql" value="">
			<input type="hidden" name="filename" value="">
			<input type="hidden" name="order"  value="">
		
	<input type="hidden" name="title" value="地市,手机号,判定垃圾短信时间,欠费金额,入网时间,入网点名称,入网点编码,入网类型,月消费,品牌,资费,短彩信话单数,语音话单数,GPRS话单数">
				<input type="hidden" name="colnum" value="15">
			<input type="hidden" name="sortcol" value="ljdx_accnbr">
		</div>
		<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			<!-- 查询条件区域开始 -->
	    <div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title" align="right">统计时间</td>
						<td class="dim_cell_content">
						<!-- 
						<%=QueryTools3.getDateYMDHtml("querydate",1,false)%>
						 -->
						<input align="right" type="text" id="querydate" name="querydate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"
						value="<%=defaultDate%>" />
						</td>
						
						<td class="dim_cell_title" align="right">地市</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>
						</td>
						<td class="dim_cell_title" align="right">类型</td>
						<td class="dim_cell_content">	
							 <select name="querytype">
							    <option value="1">短信</option>	
							    <option value="2">彩信</option>	
							    <option value="3">语音</option>		
							 </select>
						</td>
						<td align="right" class="dim_cell_content" >
							<input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toPageDown()">&nbsp;
							<input type="button" class="form_button" value="清单下载" onclick="downListCountry()">&nbsp;
						</td>
				  </tr>
					
				</table>
			</div>
			<!-- 查询条件区域结束 -->
		</fieldset>
	</div>

	<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
				<%-- 此处有可能显示有可能隐藏，完全取决与fecth first n rows 中n的值 --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
		<br><div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				      <td class="grid_title_cell" width="10%">地市<br></td>
					    <td class="grid_title_cell"><span id="coltitle1">6</span>日停机用户数<br></td>
					    <td class="grid_title_cell"><span id="coltitle2">4</span>日停机用户数<br></td>
					    <td class="grid_title_cell">2<span id="coltitle3">4</span>之前停机用户数<br></td>
					  </tr>
			</table> 
		</div>	
		<div id="sqldiv" style="display:none"></div>		
	</form>
  </body>
</html>  
<script>
document.forms[0].querydate.style.width=80;
document.forms[0].city.style.width=80;
</script>