<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
Calendar cal = GregorianCalendar.getInstance();
cal.add(Calendar.MONTH,-2);
String curDate= new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

String month = curDate.substring(0,6);
String date = curDate.substring(6,8);
%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>Ƿ�Ѹſ�����</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../common2/FusionCharts.js"></script>
	<script language="javascript" src="debt.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
</HEAD>
<style>
	span{
	 color: red;
	}
</style>
<body onload="{doSubmit();}">
<form method="post" action="">
<div style="padding: 3 px;display: block;">ͳ�����ڣ�<%
if(Integer.parseInt(date)>8)out.print(QueryTools2.getDateYMHtml("date",12,"doSubmit()",null));
else out.print(QueryTools2.getDateYMHtml("date",12,"doSubmit()",month));
%></div>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
    <td colspan="1" valign="top">
    	 <div  class="portlet">
	    	<div class="title">
	    		<ai:piece id="m0"></ai:piece>�ۼ�Ƿ�ѽ�ȥ���������
	    	</div>
	    	<div id="dim" class="content">
	    	<table >
	    		<tr>
	    		<td width="220" valign="top">
	    			<fieldset>
	<legend></legend>
	<div id="text0">
	</div>
</fieldset>
	    		</td>
	    		<td>
	    		<div id="chartrender0" ></div>
	    		</td>
	    		</tr>
	    	</table>

	    	</div>
			</div>
       </div>
    </td>
     </tr>
      <tr>
    <td  colspan="1" valign="top">
    	 <div  class="portlet">
	    	<div class="title">
	    		<ai:piece id="m1"></ai:piece>�ۼ�Ƿ�ѽ���������
	    	</div>
	    	<div id="dim" class="content">
	    	<table >
	    		<tr>
	    		<td width="220" valign="top">
	    			<fieldset>
	<legend></legend>
	<div id="text1">
	</div>
</fieldset>
	    		</td>
	    		<td><div id="chartrender1"></div></td>
	    		</tr>
	    	</table>
	    	
	    	</div>
			</div>
       </div>
    </td>
    
     <tr>
    <td colspan="1" valign="top">
    	 <div  class="portlet">
	    	<div class="title">
	    		<ai:piece id="m2"></ai:piece>�ۺϻ����������Ƿ������
	    	</div>
	    	<div id="dim" class="content">
	    	<table >
	    		<tr>
	    		<td width="220" valign="top">
	    			<fieldset>
	<legend></legend>
	<div id="text2">
	</div>
</fieldset>
ע����״ͼΪ�ۺϻ����ʣ�����ͼΪ����Ƿ�ѽ����������������ͼ�ɲ鿴�����ֵ
	    		</td>
	    		<td><div id="chartrender2"></div></td>
	    		</tr>
	    	</table>
	    	
	    	</div>
			</div>
       </div>
    </td>
  </tr>
    
  </tr>
</table>
</form>
<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
<script type="text/javascript">
	function _$(id){return document.getElementById(id);}
	
	function _1(list){
		var str = "";
		for (var i =0; i < list.length; i++){
			if(list[i][0]!="ȫʡ")str += list[i][0]+"<span>"+percentFormat(list[i][1])+"</span> "; 
			else break;
		
		
		_$("text0").innerHTML="����ȫʡ��ȥ����׵��ۼ�Ƿ������Ϊ��<span>"+percentFormat(list[i][1])
		+"</span> ���и���ȫʡƽ��ֵ�ĵ����У�"+str;
		
		var chartSQL="select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) group by area_id order by 2 desc";
		chartSQL=chartSQL.replace(/%date%/gi,chartDate).replace(/%date1%/gi,(parseInt(chartDate.substring(0,4),10)-1)+"12")
		renderChart("chartrender0","numDivLines=2&trendlinesValue=" + numberFormatDigit2((parseFloat(list[i][1])*100)+"") + "&trendlinesDisplayValue=ȫʡ&sql="+encodeURIComponent(chartSQL)+"&valueType=percent");
	}}
	
	function _2(list){
		
		var str = "";
		for (var i =0; i < list.length; i++){
			if(list[i][0]!="ȫʡ")str += list[i][0]+"<span>"+percentFormat(list[i][1])+"</span> "; 
			else break;
		
		
		_$("text1").innerHTML="����ȫʡ�������ۼ�Ƿ������Ϊ��<span>"+percentFormat(list[i][1])
		+"</span> ���и���ȫʡƽ��ֵ�ĵ����У�"+str;
		
		
		var chartSQL="select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) group by area_id order by 2 desc";
		chartSQL=chartSQL.replace(/%date%/gi,chartDate).replace(/%date1%/gi,chartDate1)
		renderChart("chartrender1","numDivLines=2&trendlinesValue=" + numberFormatDigit2((parseFloat(list[i][1])*100)+"") + "&trendlinesDisplayValue=ȫʡ&sql="+encodeURIComponent(chartSQL)+"&valueType=percent");
	}}
	
	function _3(list){
	
		var str = "";
		for (var i =list.length-1; i >=0; i--){
			if(list[i][0]!="ȫʡ")str += list[i][0]+"<span>"+percentFormat(list[i][1])+"</span> "; 
			else break;
		
		
		_$("text2").innerHTML="����ȫʡǷ���ۺϻ�����Ϊ��<span>"+percentFormat(list[i][1])
		+"</span> ���е���ȫʡƽ��ֵ�ĵ����У�"+str;
		
		//_$("text2").innerText="ȫʡ���»���Ƿ������Ϊ��"+numberFormatDigit2((parseFloat(list[0][0])*100)+"") + "%";
		var chartSQL="select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date% then p1_bill_charge end),decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date1% then callback_charge+callback_charge_r end)-1 from nmk.st_debt_callback_mm where etl_cycle_id in (%date%,%date1%) group by area_id union all select 'ȫʡ',decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date% then p1_bill_charge end),decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date1% then callback_charge+callback_charge_r end)-1 from nmk.st_debt_callback_mm where etl_cycle_id in (%date%,%date1%) order by 2 desc with ur";
		chartSQL=chartSQL.replace(/%date%/gi,chartDate).replace(/%date1%/gi,chartDate1)
		renderChart("chartrender2","chartType=dy&numDivLines=2&dySeriesName=����������&sql="+encodeURIComponent(chartSQL)+"&valueType=percent");
	}}
	var chartDate = "";
	var chartDate1= "";
	
	function doSubmit()
	{
		chartDate = document.forms[0].date.value;		
		var ddd = new Date(parseInt(chartDate.substring(0,4),10), parseInt(chartDate.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-2);
		chartDate1=(ddd.getYear()*100+ddd.getMonth()+1 )+"";
		
		var sumSql = "select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) group by area_id union all select 'ȫʡ',decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) order by 2 desc with ur";
		sumSql=sumSql.replace(/%date%/gi,chartDate).replace(/%date1%/gi,(parseInt(chartDate.substring(0,4),10)-1)+"12")
		ajaxGetListWrapper(sumSql,_1);
		
		sumSql = "select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) group by area_id union all select 'ȫʡ',decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) order by 2 desc with ur";
		sumSql=sumSql.replace(/%date%/gi,chartDate).replace(/%date1%/gi,chartDate1)
		ajaxGetListWrapper(sumSql,_2);
		
		sumSql = "select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date% then p1_bill_charge end) from nmk.st_debt_callback_mm where etl_cycle_id in (%date%,%date1%) group by area_id union all select 'ȫʡ',decimal(sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end),16,2)/sum(case when etl_cycle_id=%date% then p1_bill_charge end) from nmk.st_debt_callback_mm where etl_cycle_id in (%date%,%date1%)  order by 2 desc with ur";
		sumSql=sumSql.replace(/%date%/gi,chartDate).replace(/%date1%/gi,chartDate1)
		ajaxGetListWrapper(sumSql,_3);
		_$("m0").innerText=chartDate;
		_$("m1").innerText=chartDate;
		_$("m2").innerText=chartDate;
	}
	
function renderChart(chartrender,sParam)
{
	var ajax = new AIHBAjax.Request({
		url:"/hbbass/common2/fusionchartwrapper.jsp",
		param:sParam,
		loadmask:true,
		callback:function(foo){
			var data = foo.responseText;
			if(data=="")alert("û������");
			else{
				if(chartrender=="chartrender2")chart(chartrender,"/hbbass/common2/Charts/FCF_MSColumn3DLineDY.swf",data);
				else chart(chartrender,"/hbbass/common2/Charts/FCF_Column3D.swf",data);
			}
			if(loadmask)loadmask.style.display="none";
		}
	});
}

function chart(chartrender,chartSWF,chartxmls)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "580", "250");
 	chart.setDataXML(encodeURIComponent(chartxmls.replace("%25","%")));
 	chart.addParam("wmode","transparent");
 	chart.render(chartrender);
}

</script>