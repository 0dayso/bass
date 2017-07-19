<%@ page contentType="text/html; charset=utf-8"%>
<%

	// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	
%>
<html>
  <head>
    <title>营销活动跟踪/评估</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="dim_conf.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar2.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
	
  </head>
  <script type="text/javascript">
  	fetchRows=500;
  	pagenum=15;  	
  	cellclass[0]="grid_row_cell_text";
  	cellclass[1]="grid_row_cell_text";
		cellclass[2]="grid_row_cell_text";
		cellclass[3]="grid_row_cell_text";
		cellclass[4]="grid_row_cell_text";
		cellclass[5]="grid_row_cell_text";
		//cellclass[6]="grid_row_cell_number";
		//cellclass[6]="grid_row_cell_number";
  /*
  	cellclass[0]="grid_row_cell_text";
  */
  
 	
 	function doSubmit()
 	{
 		var condition = " where 1 = 1 ";
 	
 		if(document.forms[0].city.value!="0")
		{
			condition += " and city_id='"+document.forms[0].city.value+"'";
		}
		/**/		
		if(document.forms[0].querytime.value!="")
		{
			condition += " and substr(char(OPBACKDATE),1,4)||substr(char(OPBACKDATE),6,2) = '"+document.forms[0].querytime.value+"'";
		}
		
		if(document.forms[0].employee_num.value!="")
		{
			condition += " and ucase(employee_num) like ucase('%"+document.forms[0].employee_num.value+"%')";
		}
		if(document.forms[0].employee_part_name.value!="")
		{
			condition += " and employee_part_name like '%"+document.forms[0].employee_part_name.value+"%'";
		}
		if(document.forms[0].net_portin.value!="")
		{			
			condition += " and net_portin like　'%"+document.forms[0].net_portin.value+"%'";
		}
		if(document.forms[0].net_newacc_nbr.value!="")
		{			
			condition += " and net_newacc_nbr like　'%"+document.forms[0].net_newacc_nbr.value+"%'";
		}
 		
 		var countSql ="";
 		var sql = "select EMPLOYEE_PART_NAME,EMPLOYEE_NUM,CITY_ID,OPBACKDATE,GROUP_CUSTID,GROUP_CUSTNAME,NET_PORTIN,NET_NEWACC_NBR from COMPETE_OPPSTATE_PROVINCE ";		
		sql += condition + " order by INSERTDATE desc fetch first "+fetchRows+" rows only with ur";
		
		var downSql = "select EMPLOYEE_PART_NAME,EMPLOYEE_NUM,CITY_ID,OPBACKDATE,GROUP_CUSTID,GROUP_CUSTNAME,NET_PORTIN,NET_NEWACC_NBR from COMPETE_OPPSTATE_PROVINCE " + condition + " order by INSERTDATE desc with ur";
		document.forms[0].sql.value = encodeURIComponent(downSql);
		countSql="select count(*) from COMPETE_OPPSTATE_PROVINCE "+condition+" with ur";
		var ds = "web";
		
		sql = encodeURIComponent(sql);
		ajaxSubmitWrapper(sql,countSql,ds);		
 	}
 	function openhtml_pp(url_node,url_text,url_link)
 	{
   if(url_link!='')
   {
   	    var contentPanel=parent.parent.contentPanel;
		 	  n = contentPanel.getComponent(url_node);
		 	 if (!n) {
		 	 	    n = contentPanel.add({
		               'id':url_node,
		               'title':url_text,
		                closable:true,  //通过html载入目标页
		                margins:'0 4 4 0',
		                autoScroll:true,   
		               'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
		            });
		  	}
		    contentPanel.setActiveTab(n);		
   }
 	}
	cellfunc[8]=function(datas,options)
	{
		var tmpStr = datas[options.seq].split(";");
		if(tmpStr[2] == '<%=loginname%>')
		{
			// return "<input type='button' class='form_button_short' value='修改'	onClick=\"openhtml_pp('feedbackmodify','"+tmpStr[1].trim()+"-反馈数据修改','/hbbass/salesmanager/feedback/singleMod.jsp?opp_nbr="+tmpStr[0].trim()+"&acc_nbr="+tmpStr[1]+"')\">&nbsp;<input type='button' class='form_button_short' value='删除'	onClick='deleteSingle("+tmpStr[0]+","+tmpStr[1]+")'>";
			return "";
		}
		else return "";
 	}
/*
cellfunc[3]=function(datas,options){
 		if(datas[options.seq]=="50")return "营销活动执行中";
 		else if(datas[options.seq]=="54") return "导出派单成功";
 		else if(datas[options.seq]=="90") return "任务完成";
 	}
 	

cellfunc[8]=function(datas,options){	
	var foo = datas[options.seq].split("@");
	return "<img src='topmenu_icon05.gif' style='cursor: hand;' title='营销活动跟踪监控'  onclick='openhtml_p(\""+foo[0]+"\",\""+datas[0]+"\",\"stat/taskStatResult.jsp?campname="+datas[0]+"&taskid="+foo[0]+"&campid="+foo[0]+"&objid="+foo[3]+"&objnums="+foo[2]+"&activenums="+datas[5]+"&startdate="+datas[6]+"&enddate="+datas[7]+"\");'></img>";
	//return "<img src='topmenu_icon05.gif' style='cursor: hand;' title='营销活动跟踪监控'  onclick='parent.parent.topFrame.theCreateTab.add(\""+datas[0]+",mainFrame,stat/taskStatResult.jsp?campname="+datas[0]+"&taskid="+foo[0]+"&campid="+foo[0]+"&objid="+foo[3]+"&objnums="+foo[2]+"&activenums="+datas[5]+"&startdate="+datas[6]+"&enddate="+datas[7]+"\");'></img>";
}
*/
function deleteSingle(number1,number2)
{
  var opp_nbr = number1;
  var acc_nbr = number2;
  if(confirm("确认删除"+acc_nbr+"号码的反馈数据？"))
  {
	  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
		xmlHttp.onreadystatechange=delBack; // 设置回掉函数
		xmlHttp.open("POST","${mvcPath}/hbbass/salesmanager/feedback/feedback_db.jsp",false);
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var str="actiontype=singledel&opp_nbr="+opp_nbr+"&acc_nbr="+acc_nbr;
		//str = encodeURIComponent(str);
		str = encodeURI(str,"utf-8");
		//alert(str);
		xmlHttp.send(str);
		//alert(xmlHttp.responseText);
	}
}
function delBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			alert(xmlHttp.responseText);
			doSubmit();
		}
	}
}
function saveExcel()
{
	//var sql=document.form1.sql.value;
	//sql = encodeURIComponent(sql);
		var condition = " where 1 = 1 ";
	 	
 		if(document.forms[0].city.value!="0")
		{
			condition += " and city_id='"+document.forms[0].city.value+"'";
		}
		/**/		
		if(document.forms[0].querytime.value!="")
		{
			condition += " and substr(char(OPBACKDATE),1,4)||substr(char(OPBACKDATE),6,2) = '"+document.forms[0].querytime.value+"'";
		}
		
		if(document.forms[0].employee_num.value!="")
		{
			condition += " and ucase(employee_num) like ucase('%"+document.forms[0].employee_num.value+"%')";
		}
		if(document.forms[0].employee_part_name.value!="")
		{
			condition += " and employee_part_name like '%"+document.forms[0].employee_part_name.value+"%'";
		}
		if(document.forms[0].net_portin.value!="")
		{			
			condition += " and net_portin like　'%"+document.forms[0].net_portin.value+"%'";
		}
		if(document.forms[0].net_newacc_nbr.value!="")
		{			
			condition += " and net_newacc_nbr like　'%"+document.forms[0].net_newacc_nbr.value+"%'";
		}
 		
 		var sql = "select EMPLOYEE_PART_NAME,EMPLOYEE_NUM,CITY_ID,OPBACKDATE,GROUP_CUSTID,GROUP_CUSTNAME,NET_PORTIN,NET_NEWACC_NBR from COMPETE_OPPSTATE_PROVINCE ";		
		sql += condition + " order by INSERTDATE desc";
		
		return sql;
}

var _header= [
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"EMPLOYEE_PART_NAME",
	"name":["参与员工姓名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"EMPLOYEE_NUM",
	"name":["员工编号"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_text",
	"dataIndex":"CITY_ID",
	"name":["地市"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"OPBACKDATE",
	"name":["回流月份"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"GROUP_CUSTID",
	"name":["回流集团ID"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"GROUP_CUSTNAME",
	"name":["回流集团名称"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"NET_PORTIN",
	"name":["回流异网号码"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"NET_NEWACC_NBR",
	"name":["新发展本网号码"],
	"title":"",
	"cellFunc":""
}
];

function down(){
	aihb.AjaxHelper.down({
		sql : saveExcel()
		,header : _header
		,isCached : false
		,fileName : "集团反馈数据"
		,ds: "web"
		,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
		,form : document.tempForm
	});
}
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
								<td onClick="hideTitle(this.childNodes[0],'dim_div')"
									title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
	         <table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
						<tr class="dim_row">
							<td class="dim_cell_title"  align="left">录入月份</td>
							<td class="dim_cell_content">
								<input align="right" type="text" size="12"  name="querytime" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" />
								<!-- <input type="text" size="12" name="querytime" value="" />
									<SPAN title="请选择反馈数据录入月份" style="cursor:hand">
										 <IMG src="/hbbass/images/icon_date.gif" align="absMiddle" style="cursor:hand" width="27" height="25" border="0" onclick="calendar(document.forms[0].querytime)" width="20" align="absbottom" />
									</SPAN> -->
							</td>
							<td class="dim_cell_title"  align="left">地市</td>
							<td class="dim_cell_content"><%=bass.common.QueryTools2.getAreaCodeHtml("city", (String)session.getAttribute("area_id"), "")%></td>
							<td class="dim_cell_title"  align="left">员工编号</td>
							<td class="dim_cell_content"><input type="text" size="12" name="employee_num" value="" /></td>
						</tr>
						<tr class="dim_row">
							<td class="dim_cell_title"  align="left">参与员工姓名</td>
							<td class="dim_cell_content"><input type="text" size="12" name="employee_part_name" value="" /></td>
							<td class="dim_cell_title"  align="left">回流异网号码</td>
							<td class="dim_cell_content"><input type="text" size="12" name="net_portin" value="" /></td>
							<td class="dim_cell_title"  align="left">新发展本网号码</td>
							<td class="dim_cell_content"><input type="text" size="12" name="net_newacc_nbr" value="" /></td>
						</tr>
					</table>
					<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询"	onClick="doSubmit()">&nbsp;
									
									<input type="button" class="form_button" value="下载"	onclick="down()"> 
									&nbsp;
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
								<td onClick="hideTitle(this.childNodes[0],'show_div')"
									title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
								<td></td>
							</tr>
						</table>
					</legend>
					<div id="show_div">
						<div id="showsum"></div>						
						<div title="选择数据栏中的操作处理按钮进行操作" id="showResult"></div>
					</div>
				</fieldset>
			</div>
			<br>
			<div id="title_div" style="display:none;">
				<table id="resultTable" align="center" width="100%"
					class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="grid_title_blue">						
						<td class="grid_title_cell" width="" id="0">参与员工姓名</td>
						<td class="grid_title_cell" width="" id="1">员工编号</td>
						<td class="grid_title_cell" width="" id="2">地市</td>
						<td class="grid_title_cell" width="" id="3">回流月份</td>
						<td class="grid_title_cell" width="" id="4">回流集团ID</td>
						<td class="grid_title_cell" width="" id="5">回流集团名称</td>
						<td class="grid_title_cell" width="" id="6">回流异网号码</td>
						<td class="grid_title_cell" width="" id="7">新发展本网号码</td>
						<td class="grid_title_cell" width="" id="8">操作处理</td>						    
					</tr>
				</table>
			</div>
		</form>
		<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
