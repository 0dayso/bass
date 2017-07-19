<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
  </head>
  <script type="text/javascript">
  var _header = [{"name":["地市"],"title":"","dataIndex":"dim1","cellFunc":"","cellStyle":""}];
  var headerPiece={"name":["WLAN用户数"],"title":"","dataIndex":"ind1","cellFunc":"","cellStyle":""};
  //var headerPiece={"name":["其中高校WLAN用户数"],"title":"","dataIndex":"ind2","cellFunc":"","cellStyle":""};
  var _sql = "";
  
  function condiPiece(){
	  
  }
  function query(){
		//loadmask.style.display="";
		var time=$("time").value;
		if($("time_during").style.display=="none"){
			_sql="select dim1,ind1,ind2 from REPORT_TOTAL where REPORT_CODE='WLAN_USER' and time_id="+time;
		}else{
			var time_from=$("time_from").value;
			if(time<=time_from){alert("请选择正确的时间跨度");return;}
			if(time-time_from>6){alert("时间跨度不能超过6个月");return;}
		}
		_header[1]=headerPiece1;
		_header[2]=headerPiece2;
		alert(_header);
		//return;
		var grid = new aihb.SimpleGrid({
			header:_header
			,sql: _sql
			,isCached : true
			,callback : function() {
				//alert("导入成功!") 
				//loadmask.style.display="none";
			}
		});
		grid.run();
	}

	function down(){
		aihb.AjaxHelper.down({
			sql : "select area_name,key_num,time_id,area_code from nmk.ent_key_num where time_id="+_date
			,header : _header
			,isCached : false
			,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
			,form : document.tempForm
		});
	}
  window.onload=function(){
		aihb.Util.loadmask();
		$("queryBtn").onclick = query;
		$("downBtn").onclick = down;
	}
</script> 

  </script>
  <body>
 <form method="post" action="">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
					<table align='center' width='99%' class='grid-tab-blue'
						cellspacing='1' cellpadding='0' border='0'>
						<tr class='dim_row'>
							<td class='dim_cell_title'>
								<span onclick='swichDate()' title='点击切换时间类型'
									style='cursor: hand;'>统计周期</span>
								<span style='display: none;'><input id='timeDetail'
										type='checkbox' checked='checked'>细分 </span>
							</td>
							<td class='dim_cell_content'>
								<dim id='aidim_time' name='time' dbName="time_id" operType="int">
								<span id="time_during" style="display: none;"><input
										type="text" style="width: 78px;" value="201102" class="Wdate"
										id="time_from"
										onFocus="WdatePicker({dateFmt:'yyyyMM',maxDate:'#F{$dp.$D(\'time\',{d:-1});}'})" />
									到 </span>
								<input type="text" style="width: 160px;" value="201105"
									class="Wdate" id="time" name="time"
									onfocus="WdatePicker({dateFmt:'yyyyMM'})" />
								</dim>
							</td>
							<td class='dim_cell_title'>
								地市
							</td>
							<td class='dim_cell_content'>
								<dim id='aidim_city' name='city' dbName="substr(t0.dim1,1,5)"
									operType="varchar">
								<select name="city" class='form_select' id="city">
									<option value="0" selected='selected'>
										全省
									</option>
									<option value="HB.WH">
										武汉
									</option>
									<option value="HB.HS">
										黄石
									</option>
									<option value="HB.EZ">
										鄂州
									</option>
									<option value="HB.YC">
										宜昌
									</option>
									<option value="HB.ES">
										恩施
									</option>
									<option value="HB.SY">
										十堰
									</option>
									<option value="HB.XF">
										襄樊
									</option>
									<option value="HB.JH">
										江汉
									</option>
									<option value="HB.XN">
										咸宁
									</option>
									<option value="HB.JZ">
										荆州
									</option>
									<option value="HB.JM">
										荆门
									</option>
									<option value="HB.SZ">
										随州
									</option>
									<option value="HB.HG">
										黄冈
									</option>
									<option value="HB.XG">
										孝感
									</option>
									<option value='HB.TM'>天门</option>
									<option value='HB.QJ'>潜江</option>
								</select>
								</dim>
							</td>
							<td class='dim_cell_title'></td>
							<td class='dim_cell_content'></td>
						</tr>
					</table>
					<table align="center" width="99%" border=0>
		<tr class="dim_row_submit">
			<td><span id="tipDiv"></span></td>
			<td align="right">
				<div id="Btn">
				<input id="queryBtn" type="button" class="form_button" value="查询" >
				<input id="downBtn" type="button" class="form_button" value="下载" >
				</div>
			</td>
		</tr>
	</table>
	</div>
</fieldset>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="gridBtn" style="display:none;"></div>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div>
</form>
</body>
</html>

