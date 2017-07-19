<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	差部分维度，包括渠道名称模糊查询,
  	差第六种构成要素类型的实现
  --%>
    <title>社会渠道视图</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  	
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
 pagenum = 20;//更改每页显示的条数为20条
 	//cellclass[0]="grid_row_cell_text";
	//cellclass[1]="grid_row_cell_number";
	//cellclass[2]="grid_row_cell_number";
	//cellclass[3]="grid_row_cell_number";
	
	//cellfunc[1] = numberFormatDigit2;
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	
	function doSubmit()
	{	
		var condition = " where 1=1 ";
		var op_time,area_id,county_id,tableName,sql,_viewType,constantPart,titleDiv,_channel_type,_channel_state,_channel_name;
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;//中文,需注意
			op_time = date.value;
			tableName = "nmk.ai_channel_sum_" + op_time;  
			_viewType = viewType.value;
			_channel_type = channel_type.value;
			_channel_name = channel_name.value;
			_channel_state = channel_state.value;
		}
		condition += _channel_type ? " and channel_type ='" + _channel_type + "'" : "";
		condition += _channel_state ? " and channel_state ='" + _channel_state + "'" : "";
		condition += _channel_name && _channel_name!='支持模糊查询' ? " and channel_name like '%" + _channel_name + "%'" : "";
		switch(_viewType) {
			case '1':
				for(var i = 0; i< 17; i++) {
				 	cellfunc[i] =undefined;
				 	if(i == 16) cellfunc[i] = function(datas,options) {
				 		switch(datas[options.seq]) {
							case '1':return '一星级';break;
							case '2':return '二星级';break;
							case '3':return '三星级';break;
							case '4':return '四星级';break;
							default :return '其他';break;
						}
				 	}
				}
			constantPart = " (select area_name from mk.dim_social_channel where area_id=city_id),(select area_name from mk.dim_social_channel where area_id=country_id),market_org_id,bureau_type,channel_name,channel_code,channel_state, channel_type, case when hall_flag = 0 then '否' when hall_flag = 1 then '是' else '未知' end,channel_modle,case when operators_type='yd' then '移动' else operators_type end,Stra_Partners,exclusiveness_flag,sign_effdate,case when connect_flag=1 then '是'  when connect_flag=0 then '否' else '未知' end,sign_expdate," + 
			//ori one "case when channel_level=1 then '一星级' when channel_level=2 then '二星级' when channel_level=3 then '三星级' when channel_level=4 then '四星级' when channel_level=5 then '五星级' else '未知' end ";
			//modified one
			"case when (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=channel_code order by number desc fetch first 1 rows only) is null then channel_level else (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=channel_code order by number desc fetch first 1 rows only) end ";
			/*
			地市 县市 区域 区域类型 渠道名称 渠道编码 渠道状态 渠道类型 是否门口店 经营模式 运营商类型 战略合作伙伴 排他性 签约时间 联网性 合作结束时间 渠道星级
			*/
			titleDiv = "<table id='resultTable' align='center' width='150%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>地市</td>"
					+"<td class='grid_title_cell'>县市</td>"
					+"<td class='grid_title_cell'>区域</td>"
					+"<td class='grid_title_cell'>区域类型</td>"
					+"<td class='grid_title_cell'>渠道名称</td>"
					+"<td class='grid_title_cell'>渠道编码</td>"
					+"<td class='grid_title_cell'>渠道状态</td>"
					+"<td class='grid_title_cell'>渠道类型</td>"
					+"<td class='grid_title_cell'>是否门口店</td>"
					+"<td class='grid_title_cell'>经营模式</td>"
					+"<td class='grid_title_cell'>运营商类型</td>"
					+"<td class='grid_title_cell'>战略合作伙伴</td>"
					+"<td class='grid_title_cell'>排他性</td>"
					+"<td class='grid_title_cell'>签约时间</td>"
					+"<td class='grid_title_cell'>联网性</td>"
					+"<td class='grid_title_cell'>合作结束时间</td>"
					+"<td class='grid_title_cell'>渠道星级</td>"
					+"</tr></table>";
			break;
			case '2':
			for(var i = 0; i< 13; i++) {
				 if(i >=8 && i<=12)
				 	cellfunc[i] =numberFormatDigit2;
				 else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,xz_num,null_num,lw_num,crw_num,debt_num,n_fh_num,fh_arpu/1000.00,xz_arpu/1000.00,fh_bill_charge/1000.00,xz_bill_charge/1000.00,debt_charge/1000.00 ";
			titleDiv = "<table id='resultTable' align='center' width='150%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					
					+"<td class='grid_title_cell'>渠道名称</td>"//added
					+"<td class='grid_title_cell'>渠道编码</td>"//added
					+"<td class='grid_title_cell'>新增客户数</td>"
					+"<td class='grid_title_cell'>零次客户数</td>"
					+"<td class='grid_title_cell'>当月离网客户数</td>"
					+"<td class='grid_title_cell'>重入网客户数</td>"
					+"<td class='grid_title_cell'>当月累计欠费客户数</td>"
					+"<td class='grid_title_cell'>未放号量</td>"
					+"<td class='grid_title_cell'>放号客户ARPU值</td>"
					+"<td class='grid_title_cell'>新增客户当月ARPU值</td>"
					+"<td class='grid_title_cell'>放号客户当月总收入</td>"
					+"<td class='grid_title_cell'>新增客户当月总收入</td>"
					+"<td class='grid_title_cell'>当月欠费金额</td>"
					+"</tr></table>";
			break;
			case '3':
			for(var i = 0; i< 9; i++) {
				 cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,new_rec_times,new_rec_num,focus_rec_times,terminal_num,disbind_num,other_sales_times,other_sales_num ";
			titleDiv = "<table id='resultTable' align='center' width='120%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>渠道名称</td>"//added
					+"<td class='grid_title_cell'>渠道编码</td>"//added
					+"<td class='grid_title_cell'>新业务受理量</td>"
					+"<td class='grid_title_cell'>新业务发展客户数</td>"
					+"<td class='grid_title_cell'>重点业务受理量</td>"
					+"<td class='grid_title_cell'>定制终端销售数量</td>"
					+"<td class='grid_title_cell'>拆包用户数</td>"
					+"<td class='grid_title_cell'>其它销售业务受理量</td>"
					+"<td class='grid_title_cell'>其它销售业务受理客户数</td>"
					+"</tr></table>";
			break;
			case '4':
			for(var i = 0; i< 6; i++) {
				if(i == 4) {
					cellfunc[i] = numberFormatDigit2;
				}
				else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,rec_times,rec_num,Payment_charge/1000.00,Payment_times ";
			titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>渠道名称</td>"//added
					+"<td class='grid_title_cell'>渠道编码</td>"//added
					+"<td class='grid_title_cell'>业务量(除缴费.销售外)受理量</td>"
					+"<td class='grid_title_cell'>业务量(除缴费.销售外)受理客户数</td>"
					+"<td class='grid_title_cell'>渠道缴费金额</td>"
					+"<td class='grid_title_cell'>渠道缴费笔数</td>"
					+"</tr></table>";
			break;
			case '5':
			for(var i = 0; i< 6; i++) {
				if(i >= 2 && i<=5) {
					cellfunc[i] = numberFormatDigit2;
				}
				else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,fh_REWARD/1000.00,zz_rec_REWARD/1000.00,general_REWARD/1000.00,other_REWARD/1000.00 ";
			titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
	 				+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>渠道名称</td>"//added
					+"<td class='grid_title_cell'>渠道编码</td>"//added
					+"<td class='grid_title_cell'>放号酬金</td>"
					+"<td class='grid_title_cell'>新业务酬金</td>"
					+"<td class='grid_title_cell'>普通业务酬金</td>"
					+"<td class='grid_title_cell'>其它酬金</td>"
					+"</tr></table>";
			break;
			case '6':
			//必须用坐外连接
			//疑问: 两表关联时如何只取一条记录进行关联?如果一个channel_code在历史表中只有一条记录的话，这里的问题就解决了
			//done,需要嵌套查询子查询
			//参考sql(部分):select o_channel_level,change_reason,change_staff,eff_date from nmk.ai_channel_sum_hist where changes_date in (select max(changes_date) from nmk.ai_channel_sum_hist group by channel_code);
			
			/*
	091126: 社会渠道视图中的，扩展属性里面的原星级改成一星，二星，三星吧
	*/
	for(var i = 0; i< 11; i++) {
		if(i == 5) {
			cellfunc[i]= function(datas,options){
				switch(datas[options.seq]) {
					case '1':return '一星级';break;
					case '2':return '二星级';break;
					case '3':return '三星级';break;
					case '4':return '四星级';break;
					case '5':return '五星级';break;
					default :return '其他';break;
				}
			}
		}
		if(i == 8) {
			cellfunc[i]= function(datas,options){return datas[options.seq].substr(0,19);}
		}
		else cellfunc[i] =undefined;
	}
			//condition += " and a.channel_code in (select distinct channel_code from nmk.ai_channel_sum_hist ) ";//test//
			tableName = "nmk.ai_channel_sum_" + op_time + " a left outer join (select channel_code,o_channel_level,change_reason,change_staff,changes_date from nmk.ai_channel_sum_hist where changes_date in (select max(changes_date) from nmk.ai_channel_sum_hist group by channel_code)) h on a.channel_code=h.channel_code ";
			constantPart = "  a.channel_name,a.channel_code,khfz_score,xyw_score,khfw_score,h.o_channel_level,h.change_reason,h.change_staff,h.changes_date,Violation_type,Violation_date ";
			titleDiv = "<table id='resultTable' align='center' width='120%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>渠道名称</td>"//added
					+"<td class='grid_title_cell'>渠道编码</td>"//added
					+"<td class='grid_title_cell'>渠道客户发展得分</td>"
					+"<td class='grid_title_cell'>渠道新业务营销得分</td>"
					+"<td class='grid_title_cell'>渠道客户服务得分</td>"
					+"<td class='grid_title_cell'>原星级</td>"
					+"<td class='grid_title_cell'>星级变更原因</td>"
					+"<td class='grid_title_cell'>星级变更人员工号</td>"
					+"<td class='grid_title_cell'>星级变更日期</td>"
					+"<td class='grid_title_cell'>渠道违规类型</td>"
					+"<td class='grid_title_cell'>违规日期</td>"
					+"</tr></table>";
			break;
			default:constantPart = ""; break;
		}
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and city_id = '" + area_id + "'") : " and country_id = '" + county_id + "'");
		//alert("condition : " + condition);
		sql = "select " + constantPart + " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		document.getElementById("title_div").innerHTML=titleDiv;
		document.forms[0].sql.value = sql;
	 	//alert("sql : " + sql);
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
	}

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
		sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
	}
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

	function catchEvent(eventObj, event, eventHandler) {
		if (eventObj.addEventListener) {
			eventObj.addEventListener(event, eventHandler,false);
		}
		 else if (eventObj.attachEvent) {
			event = "on" + event;
			eventObj.attachEvent(event, eventHandler);
		}
	}
	
	function setupEvents() {
		catchEvent(document.getElementById("channel_name"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_name"),"focus",checkFocus);	
	}
	function checkBlur(evt) {
		var event = evt ? evt : window.event;
		var theSrc = event.target ? event.target : event.srcElement;
		if(theSrc.value == "") {
			theSrc.value="支持模糊查询";
			theSrc.style.color = "gray";
			theSrc.style.fontStyle = "italic";
		}
		//alert("checkblur");
	}
	function checkFocus(evt) {
		var event = evt ? evt : window.event;
		var theSrc = event.target ? event.target : event.srcElement;
		theSrc.value="";//清空文本
		theSrc.style.color = "black";
		theSrc.style.fontStyle = "normal";
	}
	catchEvent(window,"load",setupEvents);
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
						<td class="dim_cell_title">构成要素类型</td>
						<td class="dim_cell_content" colspan="5">
							<select id="viewType" name="viewType">
								<option value="1">渠道基本资料</option>
								<option value="2">渠道用户发展类</option>
								<option value="3">渠道销售业务类</option>
								<option value="4">渠道客户服务类</option>
								<option value="5">渠道酬金类</option>
								<option value="6">渠道扩展属性</option>
							</select>
						</td>
					</tr>
					<tr>
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
						<td class="dim_cell_title">渠道类型</td>
						<td class="dim_cell_content">
							<select id="channel_type" name="channel_type">
								<option value="">全部</option>
							</select>
								<script type="text/javascript" defer="defer">
									renderSelect("select distinct channel_type,channel_type from nmk.ai_channel_sum_200909",document.forms[0].channel_type.value,document.forms[0].channel_type,undefined,undefined);
								</script>
						</td>
						<td class="dim_cell_title">渠道状态</td>
						<td class="dim_cell_content">
							<select id="channel_state" name="channel_state">
								<option value="">全部</option>
							</select>
								<script type="text/javascript" defer="defer">
									renderSelect("select distinct channel_state,channel_state from nmk.ai_channel_sum_200909",document.forms[0].channel_state.value,document.forms[0].channel_state,undefined,undefined);
								</script>
						</td>
						<td class="dim_cell_title">
							渠道名称
						</td>
						<td class="dim_cell_content">
							<input type="text" id="channel_name" name="channel_name" value="支持模糊查询" style="color:gray; font-style: italic;"/>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="查询" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown(1)">&nbsp;
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
			<%--
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 </tr>
			</table>
			--%>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
