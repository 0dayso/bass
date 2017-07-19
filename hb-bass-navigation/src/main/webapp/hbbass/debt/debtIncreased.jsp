<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费增幅分析</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../common2/FusionCharts.js"></script>
	<script language="javascript" src="debt.js"></script>
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
					<select name="indicator" style="width:160px;">
						<option value="debtcharge_sum">累计欠费总额(万元)</option>
						<option value="debtcharge_m">当月欠费金额(万元)</option>
						<option value="debtcharge_users">累计欠费用户数(户)</option>
						<option value="debtcharge_users_m">当月欠费用户数(户)</option>
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
		   <span id=2><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">目前较去年<br>底增幅#{2}<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{3}<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{4}<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{5}<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{6}<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{7}<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{8}<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{9}增幅<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{10}增幅<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{11}增幅<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{12}增幅<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{13}增幅<ai:piece></ai:piece></a></td></span>
		   <span id=14><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">#{14}增幅<ai:piece></ai:piece></a></td></span>
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
		<td onclick="hideTitle(document.getElementById('chart_div_img'),'chart_div')" title="点击隐藏"><img id="chart_div_img" flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;图形展现区域：</td>
		<td><img title="选择图形展现的维度" onclick="showArea('chartselect_div')" src="/hbbass/common2/image/group-by.gif"></img></td>
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
	
	var threshold = new Threshold();
	
	cellfunc[0]=_areaCode;
	cellfunc[1]=_areaCode;
	
	function _arrow(datas,options){
		if(document.forms[0].indicator.value=="debtcharge_sum"){
			var strDate="";
			if(options.seq==2)strDate=date+"@"+date7;
			else if(options.seq==9)strDate=date+"@"+date1;
			else strDate=eval("date"+(options.seq-9))+"@"+eval("date"+(options.seq-8));
			return percentFormat(datas,options)+threshold.getHuanbiImg(
			{value:datas[options.seq]
			,tableName:"nmk.st_debt_all_MM"
			,date: strDate
			,area:datas[1]=="--"?datas[0]:datas[1]
			,division:"10000000"
			,dtype:"s"
			,condition:""
			,zbcode:"debtcharge_sum"
			,zbname:"累计欠费(万元)"});
		}else return percentFormat(datas,options);
	}
	cellfunc[2]=_arrow;
	cellfunc[3]=numberFormatDigit2;
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=numberFormatDigit2;
	cellfunc[7]=numberFormatDigit2;
	cellfunc[8]=numberFormatDigit2;
	cellfunc[9]=_arrow;
	cellfunc[10]=_arrow;
	cellfunc[11]=_arrow;
	cellfunc[12]=_arrow;
	cellfunc[13]=_arrow;
	cellfunc[14]=_arrow;
	
	var date="";
	var date1="";
	var date2="";
	var date3="";
	var date4="";
	var date5="";
	var date6="";
	var date7="";
	
	function doSubmit()
	{
		date = document.forms[0].date.value;
		var chartDate=date;
		var chartDate1=(parseInt(date.substring(0,4),10)-1)+"12";
		
		var condition="1=1 ";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-2);
		date1=ddd.getYear()*100+ddd.getMonth()+1;
		ddd.setMonth(ddd.getMonth()-1);
		date2=ddd.getYear()*100+ddd.getMonth()+1;
		ddd.setMonth(ddd.getMonth()-1);
		date3=ddd.getYear()*100+ddd.getMonth()+1;
		ddd.setMonth(ddd.getMonth()-1);
		date4=ddd.getYear()*100+ddd.getMonth()+1;
		ddd.setMonth(ddd.getMonth()-1);
		date5=ddd.getYear()*100+ddd.getMonth()+1;
		ddd.setMonth(ddd.getMonth()-1);
		date6=ddd.getYear()*100+ddd.getMonth()+1;
		
		date7=(parseInt(date.substring(0,4),10)-1)+"12";
		
		seqformat[3]=date;
		seqformat[9]=date;
		seqformat[4]=date1;
		seqformat[10]=date1;
		seqformat[5]=date2;
		seqformat[11]=date2;
		seqformat[6]=date3;
		seqformat[12]=date3;
		seqformat[7]=date4;
		seqformat[13]=date4;
		seqformat[8]=date5;
		seqformat[14]=date5;
		
		var group="area_id";
		var placeholder="(select value(dm_city_id,'')||'@'||cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var chartplaceholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		if(!document.forms[0].detailCounty.checked){
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
				group += ",county_id"
				placeholder+=",(select value(dm_county_id,'')||'@'||cityname from FPF_user_city where dm_county_id=county_id )";
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
			placeholder+=",(select value(dm_county_id,'')||'@'||cityname from FPF_user_city where dm_county_id=county_id )";
			chartplaceholder="(select cityname from FPF_user_city where dm_county_id=county_id )";
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
			if(seq==2){
				chartDate=date;
				chartDate1=(parseInt(date.substring(0,4),10)-1)+"12";
			}else{
				if(seq>=9)seq-=6;
				if(seq==3)chartDate=date;
				else chartDate=eval("date"+(seq-3))+"";
				chartDate1=eval("date"+(seq-2))+"";
			}
		}
		
		var sql=" select "+placeholder
			+" ,case when sum(m12)=0 then 0 else decimal(sum(m1),16,2)/sum(m12)-1 end";
			
		if(new RegExp("users", "gi").test(document.forms[0].indicator.value)){
			sql +=" ,sum(m1)"
				+" ,sum(m2)"
				+" ,sum(m3)"
				+" ,sum(m4)"
				+" ,sum(m5)"
				+" ,sum(m6)";
		}else{
			sql +=" ,decimal(sum(m1),16,2)/10000000"
				+" ,decimal(sum(m2),16,2)/10000000"
				+" ,decimal(sum(m3),16,2)/10000000"
				+" ,decimal(sum(m4),16,2)/10000000"
				+" ,decimal(sum(m5),16,2)/10000000"
				+" ,decimal(sum(m6),16,2)/10000000";
		}
		
		sql +=" ,case when sum(m2)=0 then 0 else decimal(sum(m1),16,2)/sum(m2)-1 end"
			+" ,case when sum(m3)=0 then 0 else decimal(sum(m2),16,2)/sum(m3)-1 end"
			+" ,case when sum(m4)=0 then 0 else decimal(sum(m3),16,2)/sum(m4)-1 end"
			+" ,case when sum(m5)=0 then 0 else decimal(sum(m4),16,2)/sum(m5)-1 end"
			+" ,case when sum(m6)=0 then 0 else decimal(sum(m5),16,2)/sum(m6)-1 end"
			+" ,case when sum(m7)=0 then 0 else decimal(sum(m6),16,2)/sum(m7)-1 end"
			+" from ("
			+" select area_id,county_id"
			+" ,sum(case when ETL_CYCLE_ID=%date% then %indicator% end) m1"
			+" ,sum(case when ETL_CYCLE_ID=%date1% then %indicator% end) m2"
			+" ,sum(case when ETL_CYCLE_ID=%date2% then %indicator% end) m3"
			+" ,sum(case when ETL_CYCLE_ID=%date3% then %indicator% end) m4"
			+" ,sum(case when ETL_CYCLE_ID=%date4% then %indicator% end) m5"
			+" ,sum(case when ETL_CYCLE_ID=%date5% then %indicator% end) m6"
			+" ,sum(case when ETL_CYCLE_ID=%date6% then %indicator% end) m7"
			+" ,sum(case when ETL_CYCLE_ID=%date7% then %indicator% end) m12"
			+" from nmk.st_debt_all_MM"
			+" where ETL_CYCLE_ID in (%date%,%date1%,%date2%,%date3%,%date4%,%date5%,%date6%,%date7%)"
			+" group by AREA_ID,county_id) t where "
			+condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%indicator%/gi,document.forms[0].indicator.value).replace(/%group%/gi,group)
			.replace(/%date%/gi,date)
			.replace(/%date1%/gi,date1)
			.replace(/%date2%/gi,date2)
			.replace(/%date3%/gi,date3)
			.replace(/%date4%/gi,date4)
			.replace(/%date5%/gi,date5)
			.replace(/%date6%/gi,date6)
			.replace(/%date7%/gi,date7);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
		var chartSQL="select "+chartplaceholder+",decimal(sum(case when etl_cycle_id=%date% then %indicator% end),16,2)/sum(case when etl_cycle_id=%date1% then %indicator% end)-1 from nmk.st_debt_all_MM where etl_cycle_id in (%date%,%date1%) and "+condition+" group by "+(group.split(",").length>1?group.split(",")[1]:group)+" order by 2 desc";
		chartSQL=chartSQL.replace(/%indicator%/gi,document.forms[0].indicator.value).replace(/%date%/gi,chartDate).replace(/%date1%/gi,chartDate1)
		renderChart("sql="+encodeURIComponent(chartSQL)+"&name="+((chartDate1.substring(4,6)=="12"&&chartDate.substring(4,6)!="01")?"较去年底":chartDate)+"欠费增幅排名"+"&valueType=percent");
	}
	
	seqformat[2]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='点击查看绝对值' onclick='hiddenColumns(false);'/>";
	
	function hidden(isShow){
		selectColumns(3,!isShow);
		selectColumns(4,!isShow);
		selectColumns(5,!isShow);
		selectColumns(6,!isShow);
		selectColumns(7,!isShow);
		selectColumns(8,!isShow);
		selectColumns(9,isShow);
		selectColumns(10,isShow);
		selectColumns(11,isShow);
		selectColumns(12,isShow);
		selectColumns(13,isShow);
		selectColumns(14,isShow);
	}
	
	function hiddenColumns(isShow){
		if(!isShow)seqformat[2]="<img id='iopen' border=0 src='../kpiportal/img/right.gif' onmouseover=\"{this.src='../kpiportal/img/right_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/right.gif'}\" style='cursor: hand;' title='点击查看相对值(占比)' onclick='hiddenColumns(true);'/>";
		else seqformat[2]="<img id='iclose' border=0 src='../kpiportal/img/left.gif' onmouseover=\"{this.src='../kpiportal/img/left_1.gif'}\" onmouseout=\"{this.src='../kpiportal/img/left.gif'}\" style='cursor: hand;' title='点击查看绝对值' onclick='hiddenColumns(false);'/>";
		hidden(isShow);
		renderGrid();
	}
</script>