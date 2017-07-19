<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费用户网龄构成(增量市场)</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
	<style>
.dim_cell_title {
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width:  auto;
	background-color: #D9ECF6;
}
/* 查询条件值  */
.dim_cell_content {
	font-family: "宋体";
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
 <body onload="{doSubmit();hidden(true);}">
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
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">日期</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">地市</td>
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_title">指标</td>
				<td class="dim_cell_content">
					<select name="indicator" class="form_select">
						<option value="debtcharge_users">用户数(户)</option>
						<option value="debtcharge_sum">欠费(万元)</option>
					</select>
				</td>
				<td class="dim_cell_content">细分县市<input type="checkbox" name="detailCounty"></td>
			</tr>
		</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit">
				<td align="right">
					<input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;
					<input type="button" class="form_button" value="下载" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</div><br>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="show_div"><div id="showSum"></div><div id="showResult"></div></div>
	
	<div id="title_div" style="display:none;">
    <table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <span id=0><td class="grid_title_blue_noimage">地市</td></span>
		   <span id=1><td class="grid_title_blue_noimage">县市</td></span>
		   <span id=2><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">合计#{1}<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">1月<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">2月<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">3月<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">4月<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">5月<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">6月<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">7月<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">8月<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">9月<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">10月<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">11月<ai:piece></ai:piece></a></td></span>
		   <span id=14><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">12月<ai:piece></ai:piece></a></td></span>
		   
		   <span id=15><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">1月占比<ai:piece></ai:piece></a></td></span>
		   <span id=16><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">2月占比<ai:piece></ai:piece></a></td></span>
		   <span id=17><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">3月占比<ai:piece></ai:piece></a></td></span>
		   <span id=18><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">4月占比<ai:piece></ai:piece></a></td></span>
		   <span id=19><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">5月占比<ai:piece></ai:piece></a></td></span>
		   <span id=20><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">6月占比<ai:piece></ai:piece></a></td></span>
		   <span id=21><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">7月占比<ai:piece></ai:piece></a></td></span>
		   <span id=22><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">8月占比<ai:piece></ai:piece></a></td></span>
		   <span id=23><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">9月占比<ai:piece></ai:piece></a></td></span>
		   <span id=24><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">10月占比<ai:piece></ai:piece></a></td></span>
		   <span id=25><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">11月占比<ai:piece></ai:piece></a></td></span>
		   <span id=26><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">12月占比<ai:piece></ai:piece></a></td></span>
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
	cellfunc[15]=percentFormat;
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
	
	function doSubmit()
	{
		var condition=" and etl_cycle_id="+document.forms[0].date.value;
		var group="area_id";
		var placeholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		if(!document.forms[0].detailCounty.checked){
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
				group += ",county_id"
				placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
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
			selectColumns(0,true);
			selectColumns(1,true);
		}
		if(arguments.length>0){
			var seq=arguments[0].parentNode.parentNode.id;
			var nodes = document.getElementsByTagName("piece");
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="↓";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		
		var sql=" select "+placeholder;
		
		if(document.forms[0].indicator.value=="debtcharge_sum"){
			sql +=" ,decimal(sum(%indicator%),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=1 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=2 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=3 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=4 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=5 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=6 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=7 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=8 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=9 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=10 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=11 then %indicator% end),16,2)/10000000"
			+" ,decimal(sum(case when innet_cycle=12 then %indicator% end),16,2)/10000000"
		}else{
			sql +=" ,sum(%indicator%)"
			+" ,sum(case when innet_cycle=1 then %indicator% end)"
			+" ,sum(case when innet_cycle=2 then %indicator% end)"
			+" ,sum(case when innet_cycle=3 then %indicator% end)"
			+" ,sum(case when innet_cycle=4 then %indicator% end)"
			+" ,sum(case when innet_cycle=5 then %indicator% end)"
			+" ,sum(case when innet_cycle=6 then %indicator% end)"
			+" ,sum(case when innet_cycle=7 then %indicator% end)"
			+" ,sum(case when innet_cycle=8 then %indicator% end)"
			+" ,sum(case when innet_cycle=9 then %indicator% end)"
			+" ,sum(case when innet_cycle=10 then %indicator% end)"
			+" ,sum(case when innet_cycle=11 then %indicator% end)"
			+" ,sum(case when innet_cycle=12 then %indicator% end)"
		}
		sql +=" ,decimal(sum(case when innet_cycle=1 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=2 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=3 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=4 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=5 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=6 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=7 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=8 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=9 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=10 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=11 then %indicator% end),16,2)/sum(%indicator%)"
			+" ,decimal(sum(case when innet_cycle=12 then %indicator% end),16,2)/sum(%indicator%)"
			+" from nmk.st_debt_netage_mm where new_flag=1"
			+condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%indicator%/gi,document.forms[0].indicator.value).replace(/%group%/gi,group);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
	
	seqformat[1]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='点击查看绝对值' onclick='hiddenColumns(false);'/>";
	
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
		
		selectColumns(15,isShow);
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
	}
	
	function hiddenColumns(isShow){
		if(!isShow)seqformat[1]="<img id='iopen' border=0 src='../kpiportal/img/right.gif' onmouseover=\"{this.src='../kpiportal/img/right_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/right.gif'}\" style='cursor: hand;' title='点击查看相对值(占比)' onclick='hiddenColumns(true);'/>";
		else seqformat[1]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='点击查看绝对值' onclick='hiddenColumns(false);'/>";
		hidden(isShow);
		renderGrid();
	}
</script>