<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<title>基站波动值查询</title>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/jquery/jquery.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/grid_common.js" charset=utf-8></script>		
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/datepicker/WdatePicker.js" charset=utf-8></script>		
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-primary/css/default/default.css" />

<script type="text/javascript"> 
var $j=jQuery.noConflict();
var _header= [
                {"name":["地市编码"],"title":"","dataIndex":"region_code","cellFunc":"","cellStyle":"grid_row_cell_text"}
               ,{"name":["地市名称"],"title":"","dataIndex":"region_name","cellFunc":"","cellStyle":"grid_row_cell_text"}
               
               ,{"name":["经分基站数量"],"title":"","dataIndex":"lastday_cnt","cellFunc":"","cellStyle":"grid_row_cell_text"}
               ,{"name":["网管基站数量"],"title":"","dataIndex":"today_cnt","cellFunc":"","cellStyle":"grid_row_cell_text"}
               
               ,{"name":["默认波动百分比(%)"],"title":"","dataIndex":"wave","cellFunc":"","cellStyle":"grid_row_cell_text"}
               ,{"name":["调整波动百分比(%)"],"title":"","dataIndex":"modify_value","cellFunc":"","cellStyle":"grid_row_cell_text"}
               
               ,{"name":["默认波动范围"],"title":"","dataIndex":"wave_scope","cellFunc":"","cellStyle":"grid_row_cell_text"}
               ,{"name":["调整波动范围"],"title":"","dataIndex":"modify_value_scope","cellFunc":"","cellStyle":"grid_row_cell_text"}
               
               ,{"name":["修改人"],"title":"","dataIndex":"modify_autor_name","cellFunc":"","cellStyle":"grid_row_cell_text"}
               ,{"name":["修改时间"],"title":"","dataIndex":"modify_date","cellFunc":"","cellStyle":"grid_row_cell_text"}
              ];

var grid=null;	
function genSQL(){
  var sql=" select a.region_code, b.area_name region_name, a.lastday_cnt,a.today_cnt, "
       +" a.wave*100 wave,case when a.wave < 0 then TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.wave)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.wave))))) else TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.wave)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.wave))))) end wave_scope, "
       +" a.modify_value*100 modify_value,case when a.modify_value < 0 then TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.modify_value)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.modify_value))))) else TRIM(CHAR(ABS(int(a.lastday_cnt*(1-a.modify_value)))))||'~'||TRIM(CHAR(ABS(int(a.lastday_cnt*(1+a.modify_value))))) end modify_value_scope,  "
       +" (select c.username from FPF_USER_USER c where a.modify_autor = c.userid) modify_autor_name,char(date(MODIFY_date))||' '||char(time(MODIFY_date)) modify_date from nwh.bureau_cell_cnt_wave_log a "
       + " left join mk.bt_area b on int(a.region_code) = b.new_code "
       + "where 1=1";
       
       if($('isWave').checked == true){
        sql+=" and a.modify_value is not null " ;
       }
            
       if($("areaSel").value != 0){
        sql+=" and a.region_code = '"+$("areaSel").value+"'";
       }

       if($('date_1').value == $('date_2').value){
        sql+=" and a.etl_cycle_id = "+$("date_1").value+"";
       }else{
        sql+=" and a.etl_cycle_id >= "+$('date_1').value+" and a.etl_cycle_id <= "+$('date_2').value+"";
       }
       
       sql+=" order by a.region_code " ;
       aihb.AjaxHelper.parseCondition()
		   sql+=" with ur ";
	return sql;
}
 
function query(){	
	grid=new aihb.SimpleGrid({
		header:_header
		,sql: genSQL()
		,isCached : "false"
		,ds : ""
		,callback:function(){}
	});
	grid.run();
}

//时间初始化
function defult_date(){
	var now = new Date();	
	var time = now.format("yyyymmdd");
	$('date_1').value = time;
	$('date_2').value = time;
}
//页面初始化
window.onload=function(){
	defult_date();
	query();
}
</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0' style="display: ''">
							<tr class='dim_row'>                
								<td class='dim_cell_title' id="times_start" >统计周期:</td>
                <td class='dim_cell_content'> 
                  <input type="text" id="date_1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate" size="12"/>
                     至
                  <input type="text" id="date_2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate" size="12"/>
                </td>

                <td class='dim_cell_title' id="area_td1">地市</td>
                <td class='dim_cell_content' id="area_td2">
                <select id="areaSel">
                    <option value='0' selected='selected'>全省</option>
                    <option value='270'>武汉</option>
                    <option value='714'>黄石</option>
                    <option value='711'>鄂州</option>
                    <option value='717'>宜昌</option>
                    <option value='718'>恩施</option>
                    <option value='719'>十堰</option>
                    <option value='710'>襄阳</option>
                    <option value='728'>江汉</option>
                    <option value='715'>咸宁</option>
                    <option value='716'>荆州</option>
                    <option value='724'>荆门</option>
                    <option value='722'>随州</option>
                    <option value='713'>黄冈</option>
                    <option value='712'>孝感</option>
                    <option value='728'>天门</option>
                    <option value='728'>潜江</option>
                </select>
                </td>
                
								<td class='dim_cell_title'>是否有修改</td>
								<td class='dim_cell_content'><input id='isWave' type='checkbox' ></td>
							</tr>	
						</table>
            
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onClick="query()">&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>			
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid" style="display: none;"></div>
				</fieldset>
			</div>
			<br>
		</form>
	</body>
</html>