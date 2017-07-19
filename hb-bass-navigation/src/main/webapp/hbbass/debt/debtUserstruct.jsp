<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费用户结构分析</TITLE>
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
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">日期</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">地市</td>
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_title">指标选择</td>
				<td class="dim_cell_content">
					<select name="indicator" style="width:160px;">
						<option value="debtcharge_users_m">当月欠费用户数(户)</option>
						<option value="debtcharge_users">累计欠费用户数(户)</option>
						<option value="debtcharge_m">当月欠费金额(万元)</option>
						<option value="debtcharge_sum">累计欠费总额(万元)</option>
					</select>
				</td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_content">细分县市<input type="checkbox" name="detailCounty"></td>
				<td class="dim_cell_content" colspan="5">
				集团成员<input type="checkbox" name="gc" checked="checked" onclick="_renderHidden()">
				拍照中高端<input type="checkbox" name="snap" checked="checked" onclick="_renderHidden()">
				拍照集团<input type="checkbox" name="gsnap" checked="checked" onclick="_renderHidden()">
				捆绑用户<input type="checkbox" name="bind" checked="checked" onclick="_renderHidden()">
				钻金银<input type="checkbox" name="vip" checked="checked" onclick="_renderHidden()">
				OCS<input type="checkbox" name="ocs" checked="checked" onclick="_renderHidden()">
				</td>
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
		   <span id=2><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">集团成员<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">拍照中高端<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">拍照集团<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">捆绑用户<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">钻金银<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">OCS<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
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
	
	cellfunc[2]=numberFormatDigit2;
	cellfunc[3]=percentFormat;
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=percentFormat;
	cellfunc[6]=numberFormatDigit2;
	cellfunc[7]=percentFormat;
	cellfunc[8]=numberFormatDigit2;
	cellfunc[9]=percentFormat;
	cellfunc[10]=numberFormatDigit2;
	cellfunc[11]=percentFormat;
	cellfunc[12]=numberFormatDigit2;
	cellfunc[13]=percentFormat;
	
	function doSubmit()
	{
		var condition=" 1=1";
		var date = document.forms[0].date.value;
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
		
		_hiddenUserType();
		
		var sql=" select "+placeholder;
		
		if(new RegExp("users", "gi").test(document.forms[0].indicator.value)){
			sql +=" ,sum(gc)"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(gc),16,2)/sum(tot) end"
				+" ,sum(snap)"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(snap),16,2)/sum(tot) end"
				+" ,sum(gsnap)"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(gsnap),16,2)/sum(tot) end"
				+" ,sum(bind)"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(bind),16,2)/sum(tot) end"
				+" ,sum(vip)"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(vip),16,2)/sum(tot) end"
				+" ,sum(ocs)";
		}else{
			sql +=" ,decimal(sum(gc),16,2)/10000000"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(gc),16,2)/sum(tot) end"
				+" ,decimal(sum(snap),16,2)/10000000"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(snap),16,2)/sum(tot) end"
				+" ,decimal(sum(gsnap),16,2)/10000000"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(gsnap),16,2)/sum(tot) end"
				+" ,decimal(sum(bind),16,2)/10000000"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(bind),16,2)/sum(tot) end"
				+" ,decimal(sum(vip),16,2)/10000000"
				+" ,case when sum(tot)=0 then 0 else decimal(sum(vip),16,2)/sum(tot) end"
				+" ,decimal(sum(ocs),16,2)/10000000";
		}
		
		sql +=" ,case when sum(tot)=0 then 0 else decimal(sum(ocs),16,2)/sum(tot) end"
			+" from ("
			+" select area_id,county_id"
			+" ,sum(case when group_flag='1' then %indicator%  end) gc"
			+" ,sum(case when snapshot_tid=1 then %indicator%  end) snap"
			+" ,sum(case when groupsnap_tid=1 then %indicator%  end) gsnap"
			+" ,sum(case when bind_tid=1 then %indicator%  end) bind"
			+" ,sum(case when ocs_tid=1 then %indicator%  end) ocs"
			+" ,sum(case when mcust_lid!='0' then %indicator%  end) vip"
			+" ,sum(%indicator% ) tot"
			+" from nmk.st_debt_userstruct_MM"
			+" where etl_cycle_id=%date%"
			+" group by area_id,county_id )t where"
			+ condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%group%/gi,group).replace(/%date%/gi,date).replace(/%indicator%/gi,document.forms[0].indicator.value);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
	
	function _renderHidden(){
		_hiddenUserType();
		renderGrid();
	}
	
	function _hiddenUserType(){
		var options=[
			{ids:[2,3],isShow :document.forms[0].gc.checked}
			,{ids:[4,5],isShow :document.forms[0].snap.checked}
			,{ids:[6,7],isShow :document.forms[0].gsnap.checked}
			,{ids:[8,9],isShow :document.forms[0].bind.checked}
			,{ids:[10,11],isShow :document.forms[0].vip.checked}
			,{ids:[12,13],isShow :document.forms[0].ocs.checked}
		];
		
		for(var i=0; i < options.length; i++){
			var obj=options[i];
			for(var j=0; j < obj.ids.length; j++){
				selectColumns(obj.ids[j],obj.isShow);
			}
		}
	}
</script>