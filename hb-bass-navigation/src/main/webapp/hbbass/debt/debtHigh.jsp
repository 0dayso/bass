<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>�߶�Ƿ��(Ƿ��200Ԫ����)�û�����</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script language="javascript" src="debt.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
	<style>
.dim_cell_title {
	font-family: "����";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width:  auto;
	background-color: #D9ECF6;
}
/* ��ѯ����ֵ  */
.dim_cell_content {
	font-family: "����";
	font-size: 12px;
	line-height: 20px;
	color: #000000;
	width: auto;
	background-color:#EFF5FB;
}
.form_select{
	width:120px;
}
	</style>
</HEAD>
 <body onload="{doSubmit();}">
<form method="post" action="">
<div id="hidden_div">
	<input type="hidden" id="allPageNum" name="allPageNum" value="">
	<input type="hidden" id="sql" name="sql" value="">
	<input type="hidden" name="filename" value="">
	<input type="hidden" name="order"  value="channel_id">
	<input type="hidden" name="title" value="">
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="�������"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;��ѯ��������</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_content">ϸ������<input type="checkbox" name="detailCounty"></td>
			</tr>
		</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit">
				<td>ע������û������Բ鿴�嵥</td>
				<td align="right">
					<input type="button" class="form_button" value="��ѯ" onClick="doSubmit()">&nbsp;
					<input type="button" class="form_button" value="����" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</div><br>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="�������"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;����չ������</td>
		<td></td>
	</tr></table></legend>
	<div id="show_div"><div id="showSum"></div><div id="showResult"></div></div>
	
	<div id="title_div" style="display:none;">
    <table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <span id=0><td class="grid_title_cell">����</td></span>
		   <span id=1><td class="grid_title_cell">����</td></span>
		   <span id=2><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">�߶�Ƿ���û���(��)<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_cell" title="�߶�Ƿ���û�/��Ƿ���û�"><a href='#' onclick="doSubmit(this)">ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_cell" title="�߶�Ƿ���û�������ͬ�ڵ�����"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">�߶�Ƿ���û����(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_cell" title="�߶��û�Ƿ��/��Ƿ��"><a href='#' onclick="doSubmit(this)">ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_cell" title="�߶��û�Ƿ�ѽ�����ͬ�ڵ�����"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		  
		  </tr>
	</table>
</div>
</fieldset>
</div><br>
<div id="title_div" style="display:none;">
</div>
</form>
<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
<script type="text/javascript">
	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellclass[7]="grid_row_cell_number";
	var threshold = new Threshold();
	
	cellfunc[0]=_areaCode;
	cellfunc[1]=_areaCode;
	
	cellfunc[2]=function(datas,options){
		return "<a href='#' title='�߶�Ƿ���û��嵥' onclick=add('debtHighDetail','�߶�Ƿ���û��嵥','debtHighDetail.jsp')>"+numberFormatDigit2(datas,options)+"</a>"
	}
	
	cellfunc[3]=percentFormat;
	cellfunc[4]=percentFormat;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=percentFormat;
	cellfunc[7]=function(datas,options){
		return percentFormat(datas,options)+threshold.getHuanbiImg(
			{value:datas[options.seq]
			,tableName:"nmk.st_debt_high_mm"
			,date:date+"@"+date1
			,area:datas[1]=="--"?datas[0]:datas[1]
			,division:"10000000"
			,dtype:"m"
			,condition:"highowe_tid=1"
			,zbcode:"month_debtcharge"
			,zbname:"����Ƿ��(��Ԫ)"});
	};
	var date="";
	var date1="";
	function doSubmit()
	{
		date = document.forms[0].date.value;
		var condition="1=1 ";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-1);
		date1=ddd.getYear()*100+ddd.getMonth();
		ddd.setMonth(ddd.getMonth()-1);
		var date2=ddd.getYear()*100+ddd.getMonth();
		
		var group="area_id";
		var placeholder="(select value(dm_city_id,'')||'@'||cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		if(!document.forms[0].detailCounty.checked){
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
				group += ",county_id"
				placeholder+=",(select value(dm_county_id,'')||'@'||cityname from FPF_user_city where dm_county_id=county_id )";
				selectColumns(0,false);
				selectColumns(1,true);
			}else{
				placeholder+=",'--'";
				selectColumns(0,true);
				selectColumns(1,false);
			}
		}else{
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
			}
			group += ",county_id"
			placeholder+=",(select value(dm_county_id,'')||'@'||cityname from FPF_user_city where dm_county_id=county_id )";
			selectColumns(0,true);
			selectColumns(1,true);
		}
		if(arguments.length>0){
			var seq=arguments[0].parentNode.parentNode.id;
			var nodes = document.getElementsByTagName("piece");
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="��";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		
		var sql=" select "+placeholder
			+" ,sum(cur_totuser_h)"
			+" ,case when sum(cur_totuser)=0 then 0 else decimal(sum(cur_totuser_h),16,2)/sum(cur_totuser) end"
			+" ,case when sum(pre_totuser_h)=0 then 0 else decimal(sum(cur_totuser_h),16,2)/sum(pre_totuser_h)-1 end"
			+" ,decimal(sum(cur_totchg_h),16,2)/10000000"
			+" ,case when sum(cur_totchg)=0 then 0 else decimal(sum(cur_totchg_h),16,2)/sum(cur_totchg) end"
			+" ,case when sum(pre_totchg_h)=0 then 0 else decimal(sum(cur_totchg_h),16,2)/sum(pre_totchg_h)-1 end"
			+" from ("
			+" select AREA_ID,county_id"
			+" ,sum(case when etl_cycle_id=%date% and highowe_tid=1 then month_debtcharge_users end) cur_totuser_h"
			+" ,sum(case when etl_cycle_id=%date% and highowe_tid=1 then month_debtcharge end)  cur_totchg_h"
			+" ,sum(case when etl_cycle_id=%date% then month_debtcharge_users end) cur_totuser"
			+" ,sum(case when etl_cycle_id=%date% then month_debtcharge end)  cur_totchg"
			+" ,sum(case when etl_cycle_id=%date1% and highowe_tid=1 then month_debtcharge_users end) pre_totuser_h"
			+" ,sum(case when etl_cycle_id=%date1% and highowe_tid=1 then month_debtcharge end)  pre_totchg_h"
			+" ,sum(case when etl_cycle_id=%date1% then month_debtcharge_users end) pre_totuser"
			+" ,sum(case when etl_cycle_id=%date1% then month_debtcharge end)  pre_totchg"
			+" from nmk.st_debt_high_mm"
			+" where etl_cycle_id in (%date%,%date1%)"
			+" group by AREA_ID,county_id) t where "
			+ condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%group%/gi,group).replace(/%date%/gi,date).replace(/%date1%/gi,date1);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
</script>