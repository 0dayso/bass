<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>页面访问量</title>
		<link rel="stylesheet" type="text/css" href="../resources/js/ext/resources/css/ext-all.css"/>
		<script type="text/javascript" src="../resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="../resources/js/jquery/jquery.js"></script>
		<script type="text/javascript" src="../resources/js/jquery/ui/jquery.ui.js"></script>
		<script type="text/javascript" src="../resources/js/des/des.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
	    <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
	    <script type="text/javascript" src="${mvcPath}/hbapp/resources/chart/FusionCharts.js"></script>
	    <script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/echarts.common.min.js"></script>
		
		<script type=""></script>
		<style type="text/css">
.porlet {
	width: 98%;
	height: 95%;
	margin-bottom: 3px;
	border: 1px solid #aabbf9;
}

.title2 {
	background-attachment: scroll;
	background-position: right center;
	color: darkblue;
	font-size: 14px;
	font-weight: bold;
	line-height: 30px;
}
.newsFont {
	font-size: 12px;
	color: darkblue;
}
#mainNav li{
	float:left;
	text-align:center;
	margin:3px 15px 0;
	color:dark; 
	font-size: 14px;
	font-weight:500; 
	height:25x; 
	line-height:25px;
	text-align:left; 
	cursor:pointer;
}
.grid-tab-blue{
	/**/background-color:#c3daf9;
}
.grid_title_blue {
	background:#ebf3fd url(../../image/default/grid3-hrow-over.gif) repeat-x left bottom;
}
.grid_title_cell {
	color: #000000;
	font-family: "����";
	font-size: 12px;
	line-height: 25px;
	height:25px;
	text-align: center;
	font-weight : normal;
	font-variant: normal;
}
.grid_row_blue {
	/**/background-color: #FFFFFF;
}
.grid_row_cell {
	font-family: "����";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	text-align: center;
	padding: 0 px 3 px 0px 3px;
}
</style>
<%
	Calendar cal1 = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	cal1.add(Calendar.YEAR, -1);//上1个月
	cal1.set(cal1.DATE,1);//上1个月1号
	String date1 = formater.format(cal1.getTime());
	String date2 = formater.format(cal2.getTime());//今天
%>
	</head>
	<body style="margin: 0px; padding-left: 5px; padding-top: 1px;">
	<div style="font-size: 12px; padding-left: 5px;"  align="center">
	统计周期：
	<input type="text" id="startDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" style="WIDTH: 100px; border-color: #aabbf9" value="<%=date1 %>"/>
	到
	<input type="text" id="endDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" style="WIDTH: 100px; border-color: #aabbf9" value="<%=date2 %>"/>
	<input id="queryByArea" type="button" class="form_button" style="width: 40px; display: ''" value="查询" onclick="query();"/>
	</div>
		<div>
			<div>
				&nbsp;
			</div>
			<div style="margin-top: 0px; margin-left: 10px; margin-right: 10px;">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr valign="top">
						<td>
							<div class="porlet">
								<div class="title2">
									全省菜单访问排行
								</div>
								<div style="margin: 3px; overflow: auto; height: 240px;width:99%">
									<div id="showChart1" align="center" style="height:99%;">
									</div>
								</div>
							</div>
						</td>					
						<td width="50%">
							<div class="porlet">
								<div class="title2">
									全省地市访问排行
								</div>
								<div style="margin: 3px; overflow: auto; height: 240px;width:99%">
									<div id="showChart2" align="center" style="height:99%;">
									</div>
								</div>
							</div>
						</td>
					</tr>
					<tr height="45%" valign="top">
						<td>
							<div class="porlet">
								<div class="title2">
									全省人员访问排行
								</div>
								<div style="margin: 3px; overflow: auto; height: 240px;width:99%">
									<div id="grid3" style="width: 100%; padding-top: 2px;">
									</div>
									<div id="showChart3" align="center" style="height:99%;">
									</div>
								</div>
							</div>
						</td>
						<td>
							<div class="porlet">
								<div class="title2">
								          月份访问排行
								</div>
								<div style="margin: 3px; overflow: auto; height: 240px;width:99%">
									<div id="grid4" style="width: 100%; padding-top: 2px;">
									</div>
									<div id="showChart4" align="center" style="height:99%;">
									</div>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="autoPlayDiv"></div>
		<div id="form1Div"></div>
		
	</body>
</html>
<script type="text/javascript">
function showchart(sql,id){
	sql = strEncode(sql);
	
	  Ext.Ajax.request({
		    cache:false,
			async:false,
			method : "POST",
		    url : '${mvcPath}/hbirs/action/chartdata?method=chartXml',
			params : {
				'sql' : sql
			},
			success : function(resp) {
				var result = eval("(" + resp.responseText + ")");
				test(result,id);
			}
		});
	}

function test(result,id){
	var pageview=[];
	var arr=[];
	var ty='';
	var myChart = echarts.init(document.getElementById(id));
	for(var i=0;i<result.length;i++){
	       pageview.push(result[i][0]);
	       arr.push(result[i][1]);
	     }
	if(id=='showChart1'){
		ty='bar';
	}else if (id=='showChart2'){
		ty='line';
	}else if(id=='showChart3'){
		ty='bar';
	}else if(id=='showChart4'){
		ty='bar';
	}
	Option = {
			   backgroundColor:'#f4f4f4',
			   tooltip : {
				show: true,
			    trigger: 'axis'
			  },
			  color:['rgba(58, 160, 218, 1)','rgba(255, 102, 102, 1)','rgba(179, 226, 149, 1)'],
			  calculable : false,
			  legend: {	
				    orient: 'horizontal',
				    x: 'right',
				    y:"top",
				    data:['访问率']
				  },
			  xAxis : [
			  {
			    type : 'category',
			    axisLabel :{
			    interval:0,
						    rotate: -20,// 60度角倾斜显示

			       },
			    data : arr 
			     }
			     ],
			     yAxis : [
			     {
			      type : 'value',
			    }
			    ],
			    series : [
			        {
			          name:'访问率',
			          type:ty,
			          barWidth:30,
			          data:pageview
			        }
			        ]
			  };
			  myChart.setOption(Option);
}


function query(){
	var date1 = $('#startDate').val();
	var date2 = $('#endDate').val();
	var whereContent = "";
	if(date1){
		whereContent += " and date(create_dt)>='"+date1+"'";
	}
	if(date2){
		whereContent += " and date(create_dt)<='"+date2+"'";
	}
	var sql = "";
	//块1
	sql = "select count(menuitemtitle),menuitemtitle from (select a.loginname,b.username,a.uri,(select menuitemtitle from st.FPF_SYS_MENU_ITEMS  where st.FPF_SYS_MENU_ITEMS.url =a.uri),a.create_dt,b.cityid,(select areaname from st.area where area_id=b.cityid) from ST.FPF_VISITLIST a left join st.fpf_user_user b on a.loginname=b.userid) where menuitemtitle is not null and create_dt is not null "+whereContent+" group by menuitemtitle order by 1 desc fetch first 16 rows only";
	showchart(sql,'showChart1');
	//块2
	sql = "select count(areaname),areaname from (select a.loginname,b.username,a.uri,(select menuitemtitle from st.FPF_SYS_MENU_ITEMS  where st.FPF_SYS_MENU_ITEMS.url =a.uri),a.create_dt,b.cityid,(select areaname from st.area where area_id=b.cityid) from  ST.FPF_VISITLIST a left join st.fpf_user_user b on a.loginname=b.userid) where menuitemtitle is not null and create_dt is not null "+whereContent+" group by areaname order by 1 desc";
	showchart(sql,'showChart2');
	//块3
	sql="select count(username) count,username from (select a.loginname,b.username,a.uri,(select menuitemtitle from st.FPF_SYS_MENU_ITEMS  where st.FPF_SYS_MENU_ITEMS.url =a.uri),a.create_dt,b.cityid,(select areaname from st.area where area_id=b.cityid) from  ST.FPF_VISITLIST a left join st.fpf_user_user b on a.loginname=b.userid) where menuitemtitle is not null and create_dt is not null "+whereContent+" and username not in ('系统管理员')  and  username is not null group by username order by 1 desc";
	showchart(sql,'showChart3');
	//块4
	sql="select count(create_dt),substr(int(date(create_dt)),1,6) from (select a.loginname,b.username,a.uri,(select menuitemtitle from st.FPF_SYS_MENU_ITEMS  where st.FPF_SYS_MENU_ITEMS.url =a.uri),a.create_dt,b.cityid,(select areaname from st.area where area_id=b.cityid) from ST.FPF_VISITLIST a left join st.fpf_user_user b on a.loginname=b.userid) where menuitemtitle is not null and create_dt is not null "+whereContent+" group by substr(int(date(create_dt)),1,6) ";
	showchart(sql,'showChart4');
}
query();

Ext.onReady(function() {
	Ext.QuickTips.init();
});// Ext.onReady结束
</script>