<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	copied from channelInfo.jsp
  	貌似后台表结构有修改，country_id由中文改成英文了
  --%>
    <title>社会渠道价值评估模型</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<script type="text/javascript" src="js/common.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  	<%-- added--%>
  	<style type="text/css">
 		#massage_box{ position:absolute;  left:expression((body.clientWidth-550)/2); top:expression((body.clientHeight-300)/2); width:550px; height:550px;filter:dropshadow(color=#B0D7EC,offx=2,offy=2,positive=2); z-index:2; visibility:hidden;filter:alpha(opacity=80)}
 		#mask{ position:absolute; top:0; left:0; width:expression(body.clientWidth); height:expression(body.clientHeight); background:#ccc; filter:ALPHA(opacity=30); z-index:1; visibility:hidden}
 		.massage{border:#D9ECF6 solid; border-width:1 1 2 1; width:95%; height:95%; background:#fff; color:#036; font-size:12px; line-height:150%}
		.header{background:#A8D2EA; height:20px; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; padding:3 5 0 5; color:#000}
 	</style>
  </head>  
  
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
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
	//cellclass[16]="grid_row_cell_text";
	//16 当
	cellfunc[3] = percentFormat;
	cellfunc[4] = percentFormat;
	cellfunc[5] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[7] = percentFormat;
	cellfunc[8] = percentFormat;
	cellfunc[11] = numberFormatDigit2;//定制终端屏蔽 12 改 11
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	cellfunc[16]= function(datas,options){
	//加入case when的功能
		switch(datas[options.seq]) {
			case '1':return '一星级';break;
			case '2':return '二星级';break;
			case '3':return '三星级';break;
			case '4':return '四星级';break;
			//case '5':return '五星级';break;
			default :return '其他';break;
		}
	}
	cellfunc[17]= function(datas,options){//18改17,因为屏蔽一列
	//疑问，o_channel_level应该是我从表中ai_sum中读到的'当月星级'(a.channel_level)还是从我的历史表中读到的修改前的值
	//疑问，生效日期处理问题
		//added for beauty
		if(datas[options.seq]) {
			//前提是有记录,也就是说星级已经评定过,这里只是美化下
			switch(datas[options.seq]) {
			case '1':datas[options.seq]='一星级';break;
			case '2':datas[options.seq]='二星级';break;
			case '3':datas[options.seq]='三星级';break;
			case '4':datas[options.seq]='四星级';break;
			default :datas[options.seq]='其他';break;
			}
		}
			
		///added for beauty
		return datas[options.seq] ? "<a title='点击修改' href='#' onclick=window.open('modelmodify.jsp?oper=modify&channel_code=" + datas[0] + "&o_channellevel=" +datas[options.seq - 1] + "','modelmodify','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>" + datas[options.seq] + "</a>" : "<a href='#' title='点击新增评定' onclick=window.open('modelmodify.jsp?oper=add&channel_code=" + datas[0] + "&o_channellevel=" +datas[options.seq - 1] + "','modelmodify','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>未评定</a>";
		//return datas[options.seq] ? "<a title='点击修改' href='#' onclick='window.open(\'modelmodify.jsp?\',\'test page\',\'width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no\')'>" + datas[options.seq] + "</a>" : "<a href='#' title='点击新增评定' onclick='window.open(\'modelmodify.jsp\',\'test add page\',\'width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no\')'>评定</a>";
	}; 
	function doSubmit()
	{	
		var condition = " where a.channel_code = o.channel_code ";
		var op_time,area_id,county_id,tableName,sql,_viewType,constantPart,titleDiv;
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;//中文,需注意
			op_time = date.value;
			tableName = "nmk.ai_channel_sum_" + op_time + " a , " + "nmk.channel_sum_" + op_time + " o ";  
			condition += (channel_name.value && channel_name.value != '支持模糊查询') ? " and a.channel_name like '%" + channel_name.value + "%'" : "";
		}
		constantPart = " a.channel_code,a.channel_name," + 
		"a.fh_num, case when o.dd_num=0 then 0 else o.harup_num/o.dd_num end ," + 
		"case when o.dd_num=0 then 0 else o.larup_num/o.dd_num end," + 
		" case when o.xz_num=0 then 0 else o.xz_lw_num/o.xz_num end," + 
		"case when o.dd_num=0 then 0 else o.crw_num/o.dd_num end," + 
		"case when o.bill_charge=0 then 0 else (o.zz_charge + o.data_charge)/o.bill_charge end," + 
		" case when o.dd_num=0 then 0 else o.debt_num/o.dd_num end ," + 
		//" a.terminal_num,case when o.disbind_times=0 then 0 else a.terminal_num/o.disbind_times end," + 
		" a.terminal_num," + //屏蔽定制终端拆包率
		" a.rec_times, a.Payment_charge/1000.00, a.khfz_score, a.xyw_score," + 
		//" a.zd_score, a.khfw_score, a.score, a.channel_level ";//before moving
	    " a.zd_score, a.khfw_score, " + 
	    //不能这样，如果这样，点击链接之后传过去的原渠道星级就是汉字！！！ "case when a.channel_level=1 then '一星级' when a.channel_level=2 then '二星级' when a.channel_level=3 then '三星级' when a.channel_level=4 then '四星级' when a.channel_level=5 then '五星级' else '其他' end,(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	   /*before modified because :
	   当修改日志表中没有这条记录的是很，就取channel_sum表的。如果有，就取日志表中，number最大的，登记 by 张莹
	   "a.channel_level,(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	    */
	    /*after modified
	    修改之后立刻生效就是应该这样写,这样做的代价还是蛮大的，我修改了channel_sum_hist的channel_level的类型
	    */
	    // modify for the n th th time : 这一次又要改回去，只读视图表，不读历史表，因为是当月星级 "case when (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) is null then a.channel_level else (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) end," + 
	   	//after modify
	   	"a.channel_level," +
	    "(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and a.city_id = '" + area_id + "'") : " and a.country_id = '" + county_id + "'");
		//condition += " and a.channel_code = 'HB.HS.01.16.01.03'";//test
		//condition += " and a.channel_name like '%铁山丹%'";//test
		//alert("condition : " + condition);
		//test
		
		sql = "select " + constantPart + " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		document.forms[0].sql.value = sql;
	 	//alert("sql : " + sql);
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
	}
	function setupEvents() {
		catchEvent(document.getElementById("channel_name"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_name"),"focus",checkFocus);	
	}
	catchEvent(window,"load",setupEvents);

//ng版级联函数，主要是sql不同，也就是表名不同
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		//#和配置工具无关以及配置工具中的变量无关
		//sql使用的是波涛工具中的，所以表名也是如此，这里的表明并非dongyong给我的维表mk.dim_areacity/county
	 // sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
		sqls.push("select AREA_NAME, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
	}
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

	
	function dimDisplay() {
		window.open("levelmodify.jsp","级别分数档次划分","width=800,height=600,status=yes,resizable=yes,menubar=yes,toolbar=yes");
	}
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
  </script>
  <body>
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title">时间</td>
						<td class="dim_cell_content">
							<%=NgbassTools.getQueryDate("date","yyyyMM")%>
						</td>
						
						<td class="dim_cell_title">归属地市</td>
						<td class="dim_cell_content"> 
						<%-- 默认值是0,从波涛工具中看到 --%>
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">归属县市<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%>
						</td>
					</tr>
					<tr class="dim_row">
						<td class="dim_cell_title">渠道名称</td>
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="channel_name" name="channel_name" value="支持模糊查询" style="color:gray; font-style: italic;"/>
						</td>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="级别分档查询" onclick="dimDisplay()">&nbsp;
							<input type="button" class="form_button" value="查询" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown(2)">&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="125%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				<%-- 
				 <tr class="grid_title_blue">
				 		<td class='grid_title_cell' colspan="11">输入要素</td>
				 		<td class='grid_title_cell' colspan="7">输出要素</td>
				 </tr>
				 --%>
				 <tr class="grid_title_blue">
				 <td class='grid_title_cell' rowspan="2">渠道ID</td>
				 <td class='grid_title_cell' rowspan="2">渠道名称</td>
				 		
				 		<td class='grid_title_cell' colspan="8">业务发展</td><%-- 屏蔽定制终端后将 9 改成8 --%>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">业务发展</td>
				 		<td class='grid_title_cell' colspan="2" >客户服务类</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="2" >客户服务类</td>
				 		 
				 	 <td class='grid_title_cell' colspan="4">功能性评分</td>
				 	  <td style="display:none;" class='grid_title_cell' colspan="4">功能性评分</td>
				 	   <td style="display:none;" class='grid_title_cell' colspan="4">功能性评分</td>
				 	    <td style="display:none;" class='grid_title_cell' colspan="4">功能性评分</td>
				 	  <td class='grid_title_cell'>渠道当月分级结果</td>
				 	   <td class='grid_title_cell'>渠道已评定的分级结果</td>
				 	   <%-- 
				 	    <td class='grid_title_cell' rowspan="2">渠道类型与级别修改</td>
				 		--%>
				 </tr>
				  <tr class="grid_title_blue">
				  		<!-- 输入部分 -->
				  		<!-- 
	a.fh_num,
	o.harup_num/o.dd_num,	o.larup_num/o.dd_num,	o.xz_lw_num/o.xz_num,
	o.crw_num/o.dd_num,	(o.zz_charge + o.data_charge)/o.bill_charge,	o.debt_num/o.dd_num,	
	a.terminal_num,	a.terminal_num/o.disbind_times
	a.rec_times,	a.Payment_charge,	a.khfz_score,	
	a.xyw_score,	a.zd_score	a.khfw_score,
	a.score,	a.channel_level
	
				  		 -->
				  		 <td style="display:none;" class='grid_title_cell' rowspan="2">渠道ID</td>
				 		<td style="display:none;" class='grid_title_cell' rowspan="2">渠道名称</td>
				 		<td class='grid_title_cell'>新增客户数</td>
				 		<td class='grid_title_cell'>高ARPU客户占比</td>
				 		<td class='grid_title_cell'>低ARPU客户占比</td>
				 		<td class='grid_title_cell'>新增客户离网率</td>
				 		<td class='grid_title_cell'>重入网客户占比</td>
				 		<td class='grid_title_cell'>新业务收入占比</td>
				 		<td class='grid_title_cell'>欠费客户占比</td>
				 		<td class='grid_title_cell'>定制终端销售数量</td>
				 		<%-- 
				 		<td class='grid_title_cell'>定制终端拆包率</td>
				 		--%>
				 		<td class='grid_title_cell'>业务受理量</td>
				 		<td class='grid_title_cell' width="6%">渠道缴费金额</td>
						<!-- 输出部分 -->
						 <td class='grid_title_cell'>渠道客户发展得分</td>
						 <td class='grid_title_cell'>渠道新业务营销得分</td>
						 <td class='grid_title_cell'>渠道定制终端销售得分</td>
						 <td class='grid_title_cell'>渠道客户服务得分</td>
						  <td class='grid_title_cell'>当月星级</td>
						 <td class='grid_title_cell'>评定后星级</td><%-- testtemp --%>
						
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>



