<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>Ƿ���û����ڹ���</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../common2/FusionCharts.js"></script>
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
 <body onload="{hidden(true);doSubmit();}">
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
		   <span id=0><td class="grid_title_blue_noimage">����</td></span>
		   <span id=1><td class="grid_title_blue_noimage">����</td></span>
		   <span id=2><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">�ϼ�#{2}<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{3}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{4}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{5}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{6}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{7}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{8}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{9}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{10}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{11}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{12}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{13}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=14><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{14}<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=15><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">12��������<br>Ƿ��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   
		   <span id=16><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{16}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=17><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{17}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=18><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{18}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=19><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{19}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=20><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{20}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=21><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{21}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=22><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{22}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=23><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{23}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=24><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{24}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=25><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{25}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=26><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{26}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=27><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{27}<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=28><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">12��������<br>Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		  
		  </tr>
	</table>
</div>
</fieldset>
</div><br>
<div id="title_div" style="display:none;">
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(document.getElementById('chart_div_img'),'chart_div')" title="�������"><img id="chart_div_img" flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;ͼ��չ������</td>
		<td><img title="ѡ��ͼ��չ�ֵ�ά��" onclick="showArea('chartselect_div')" src="/hbbass/common2/image/group-by.gif"></img></td>
	</tr></table></legend>
	<div id="chart_div">
	<div id="chartrender" style="text-align: center;"></div>
	</div>
</fieldset>
</div><br>
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
	cellclass[8]="grid_row_cell_number";
	cellclass[9]="grid_row_cell_number";
	cellclass[10]="grid_row_cell_number";
	cellclass[11]="grid_row_cell_number";
	cellclass[12]="grid_row_cell_number";
	cellclass[13]="grid_row_cell_number";
	cellclass[14]="grid_row_cell_number";
	cellclass[15]="grid_row_cell_number";
	cellclass[16]="grid_row_cell_number";
	cellclass[17]="grid_row_cell_number";
	cellclass[18]="grid_row_cell_number";
	cellclass[19]="grid_row_cell_number";
	cellclass[20]="grid_row_cell_number";
	cellclass[21]="grid_row_cell_number";
	cellclass[22]="grid_row_cell_number";
	cellclass[23]="grid_row_cell_number";
	cellclass[24]="grid_row_cell_number";
	cellclass[25]="grid_row_cell_number";
	cellclass[26]="grid_row_cell_number";
	cellclass[27]="grid_row_cell_number";
	cellclass[28]="grid_row_cell_number";
	
	cellfunc[2]=numberFormatDigit2;
	cellfunc[3]=numberFormatDigit2;
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=numberFormatDigit2;
	cellfunc[7]=numberFormatDigit2;
	cellfunc[8]=numberFormatDigit2;
	cellfunc[9]=numberFormatDigit2;
	cellfunc[10]=numberFormatDigit2;
	cellfunc[11]=numberFormatDigit2;
	cellfunc[12]=numberFormatDigit2;
	cellfunc[13]=numberFormatDigit2;
	cellfunc[14]=numberFormatDigit2;
	cellfunc[15]=numberFormatDigit2;
	cellfunc[16]=percentFormat;
	cellfunc[17]=percentFormat;
	cellfunc[18]=percentFormat;
	cellfunc[19]=percentFormat;
	cellfunc[20]=percentFormat;
	cellfunc[21]=percentFormat;
	cellfunc[22]=percentFormat;
	cellfunc[23]=percentFormat;
	cellfunc[24]=percentFormat;
	cellfunc[25]=percentFormat;
	cellfunc[26]=percentFormat;
	cellfunc[27]=percentFormat;
	cellfunc[28]=percentFormat;
	
	function doSubmit()
	{
		var ddd = new Date(parseInt(document.forms[0].date.value.substring(0,4),10), parseInt(document.forms[0].date.value.substring(4,6),10) ,01);
		for(var a=0;a<12;a++){
			ddd.setMonth(ddd.getMonth()-1);
			seqformat[a+3]=(ddd.getYear()*100+ddd.getMonth()+1)+"";
			seqformat[a+3+13]=(ddd.getYear()*100+ddd.getMonth()+1)+"";
		}
		var chartIndicator="DEBTCHARGE_M1";
		var chartName=document.forms[0].date.value;
		var condition=" etl_cycle_id="+document.forms[0].date.value;
		var group="area_id";
		var placeholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var chartplaceholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		if(!document.forms[0].detailCounty.checked){
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
				group += ",county_id"
				placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
				chartplaceholder="(select cityname from FPF_user_city where dm_county_id=county_id )";
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
			placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
			chartplaceholder="(select cityname from FPF_user_city where dm_county_id=county_id )";
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
			if(seq==2){
				chartIndicator="DEBTCHARGE_M1";
				chartName=document.forms[0].date.value;
			}
			else{
				chartIndicator="DEBTCHARGE_M"+((seq>15)?seq-15:seq-2);
				if(seqformat[seq])chartName=seqformat[seq];
				else chartName="12��������";
			}
		}
		
		var sql=" select "+placeholder
			+" ,decimal(sum(total),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M1),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M2),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M3),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M4),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M5),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M6),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M7),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M8),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M9),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M10),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M11),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M12),16,2)/10000000"
			+" ,decimal(sum(DEBTCHARGE_M13),16,2)/10000000"
			
			+" ,decimal(sum(DEBTCHARGE_M1),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M2),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M3),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M4),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M5),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M6),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M7),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M8),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M9),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M10),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M11),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M12),16,2)/sum(total)"
			+" ,decimal(sum(DEBTCHARGE_M13),16,2)/sum(total)"
			+" from (select ti.*,(DEBTCHARGE_M1+DEBTCHARGE_M2+DEBTCHARGE_M3+DEBTCHARGE_M4+DEBTCHARGE_M5+DEBTCHARGE_M6+DEBTCHARGE_M7+DEBTCHARGE_M8+DEBTCHARGE_M9+DEBTCHARGE_M10+DEBTCHARGE_M11+DEBTCHARGE_M12+DEBTCHARGE_M13) total from nmk.st_debt_billcycle_mm ti) t where "
			+condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%group%/gi,group);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
		
		var chartSQL="select "+chartplaceholder+",decimal(sum("+chartIndicator+"),16,2)/sum(total) from (select ti.*,(DEBTCHARGE_M1+DEBTCHARGE_M2+DEBTCHARGE_M3+DEBTCHARGE_M4+DEBTCHARGE_M5+DEBTCHARGE_M6+DEBTCHARGE_M7+DEBTCHARGE_M8+DEBTCHARGE_M9+DEBTCHARGE_M10+DEBTCHARGE_M11+DEBTCHARGE_M12+DEBTCHARGE_M13) total from nmk.st_debt_billcycle_mm ti) t where "+condition+" group by "+(group.split(",").length>1?group.split(",")[1]:group)+" order by 2 desc";
		renderChart("sql="+encodeURIComponent(chartSQL)+"&name="+chartName+"Ƿ��ռ��&valueType=percent" );
	}
	
	seqformat[2]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='����鿴����ֵ' onclick='hiddenColumns(false);'/>";
	
	function hidden(isShow){
		selectColumns(3,!isShow);
		selectColumns(4,!isShow);
		selectColumns(5,!isShow);
		selectColumns(6,!isShow);
		selectColumns(7,!isShow);
		selectColumns(8,!isShow);
		selectColumns(9,!isShow);
		selectColumns(10,!isShow);
		selectColumns(11,!isShow);
		selectColumns(12,!isShow);
		selectColumns(13,!isShow);
		selectColumns(14,!isShow);
		selectColumns(15,!isShow);
		
		selectColumns(16,isShow);
		selectColumns(17,isShow);
		selectColumns(18,isShow);
		selectColumns(19,isShow);
		selectColumns(20,isShow);
		selectColumns(21,isShow);
		selectColumns(22,isShow);
		selectColumns(23,isShow);
		selectColumns(24,isShow);
		selectColumns(25,isShow);
		selectColumns(26,isShow);
		selectColumns(27,isShow);
		selectColumns(28,isShow);
	}
	
	function hiddenColumns(isShow){
		if(!isShow)seqformat[2]="<img id='iopen' border=0 src='../kpiportal/img/right.gif' onmouseover=\"{this.src='../kpiportal/img/right_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/right.gif'}\" style='cursor: hand;' title='����鿴���ֵ(ռ��)' onclick='hiddenColumns(true);'/>";
		else seqformat[2]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='����鿴����ֵ' onclick='hiddenColumns(false);'/>";
		hidden(isShow);
		renderGrid();
	}
</script>