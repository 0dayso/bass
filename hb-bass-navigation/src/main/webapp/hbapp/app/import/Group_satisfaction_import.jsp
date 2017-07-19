<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-集团满意度导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<div id="importDiv">
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	集团满意度数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=集团满意度数据导入.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
	<div>
		<ul>
			<li>对于同一周期内的多次导入，系统会自动更新上一次数据</li>
			<li>查询条件的时间对应关系：如201101对应2011年第1期</li>
		</ul>
	</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div id="condi1" style="display:none">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn1" class="form_button"  style="width: 100px" value="查询本次导入"/>&nbsp;
					<!--  
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
					-->
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>期数</td>
			<td >
				<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" onchange="combo(1)"/>
				
			</td>
			<!-- 
			<td class='dim_cell_content'>
			第<select name="month"  id="month" onchange="combo(1)">
				<option value="0">全部</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					</select>期
			</td>
			 -->
			<td class='dim_cell_title' >
				一级指标
			</td>
			<td class='dim_cell_content' >
			<select name="county" class='form_select' id="index1"><option value='-1'>全部</option></select>
			</td>
			<td class='dim_cell_title'>
				二级指标
			</td>
			<td class='dim_cell_content'>
			<select name="county" class='form_select' id="index2"><option value='-1'>全部</option></select>
			</td>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
				</div>
			</td>
		</tr>
	</table>
</div>

</div>
<!--  
<div style="text-align:right;">
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看"/>&nbsp;
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看全部"/>&nbsp;
	<input type="button" id="downBtn" class="form_button" style="width : 120px" value="下载" onclick="down()">&nbsp;
</div>
-->
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>
<form name="tempForm" action=""></form>


	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	function combo(level){	
		var cycle_id = $("cycle_id").value;
		//var month = $("month").value;
		//var time = year+"年第"+month+"期";
		var year = cycle_id.substr(0,4);
		var month = cycle_id.substr(4,2);
		month = parseInt(month);
		var time = year+"年第"+month+"期";
		//if(cycle_id.substr(4,1)==0){
		//	month = cycle_id.substr(0,4)
		//}
		 
		var sql="select distinct index1 key,index1 value from Group_satisfaction_import where time='"+time+"' and index1!='' order by index1 with ur";
		//alert($("index1"));
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/jsondata"
			,parameters : "sql="+encodeURIComponent(sql)+"&isCached=false"
			,callback : function(xmlrequest){
				var list = eval(xmlrequest.responseText);
				aihb.FormHelper.fillElementSelect({
					data : list
					,isHoldFirst :true
					,element : $("index1")
				});
				
			}
		});
		
		ajax.request();
		
		sql="select distinct index2 key,index2 value from Group_satisfaction_import where time='"+time+"' and  index2!='' order by index2 with ur";
		//alert($("index1"));
		ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/jsondata"
			,parameters : "sql="+encodeURIComponent(sql)+"&isCached=false"
			,callback : function(xmlrequest){
				var list = eval(xmlrequest.responseText);
				aihb.FormHelper.fillElementSelect({
					data : list
					,isHoldFirst :true
					,element : $("index2")
				});
				
			}
		});
		
		ajax.request();
	}

		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymm") + "@" + '<%=user.getId()%>';
			var currentTime = new Date().format("yyyymm");
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		}
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					} else return true;
				};						
				
			   	vault.setFormField("tableName", "Group_satisfaction_import");
		    	vault.setFormField("columns", "taskid,Province,time,Index1,Index2,mb_Sort,mb_cnt,qqt_Sort,qqt_cnt,dgdd_Sort,dgdd_cnt,szx_Sort,szx_cnt,Td_Sort,Td_cnt,VIP_Sort,VIP_cnt,Lead_Sort,Lead_cnt,UN_Sort,UN_cnt,FIX_Sort,FIX_cnt");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		
		    		var sql = encodeURIComponent("update Group_satisfaction_import set ETL_CYCLE_ID="+currentTime+" where taskid='" + taskId + "' ");
		    		sql +="&sqls="+ encodeURIComponent("delete from  Group_satisfaction_import where time='时间' ");
		    		var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						alert("导入完成");
						loadmask.style.display="none";
						//query();
						//tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/report/college/uploadinfo.html?taskId=" + taskId + "&" + _params._oriUri});
					}
				});
					ajax.request();
		    	}
			};
			
			var _header= [
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"etl_cycle_id",
	"name":["导入时间"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"province",
	"name":["省份"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"time",
	"name":["时间"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"index1",
	"name":["一级综合指标/商业过程名称"],
	"title":"",
	"cellFunc":""
} ,
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"index2",
	"name":["二级综合指标/商业过程名称"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"mb_Sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"mb_cnt",
	"name":["移动整体"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"qqt_Sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"qqt_cnt",
	"name":["全球通"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"dgdd_Sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"dgdd_cnt",
	"name":["动感地带"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"szx_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"szx_cnt",
	"name":["神州行"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"td_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"td_cnt",
	"name":["TD客户"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"vip_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
} ,
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"vip_cnt",
	"name":["VIP"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"lead_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"lead_cnt",
	"name":["领先值"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"un_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"un_cnt",
	"name":["联通"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"fix_sort",
	"name":["排名"],
	"title":"",
	"cellFunc":""
},
{
	"cellStyle":"grid_row_cell_text",
	"dataIndex":"fix_cnt",
	"name":["电信"],
	"title":"",
	"cellFunc":""
} 
			              ];
	 			
			 		
			function query1(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select ETL_CYCLE_ID,Province,time,Index1,Index2,mb_Sort,mb_cnt,qqt_Sort,qqt_cnt,dgdd_Sort,dgdd_cnt,szx_Sort,szx_cnt,Td_Sort,Td_cnt,VIP_Sort,VIP_cnt,Lead_Sort,Lead_cnt,UN_Sort,UN_cnt,FIX_Sort,FIX_cnt from Group_satisfaction_import  where taskid='" + taskId + "' with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			function query(){
				var condi = " where 1=1 ";
				var cycle_id = $("cycle_id").value;
				//var month = $("month").value;
				//var time = year+"年第"+month+"期";
				var year = cycle_id.substr(0,4);
				var month = cycle_id.substr(4,2);
				month = parseInt(month);
				var time = year+"年第"+month+"期";
				condi+=" and time='"+time+"'";
				var index1 = $("index1").value;
				if(index1!=-1){
					condi+=" and index1='"+index1+"'";
				}
				var index2 = $("index2").value;
				if(index2!=-1){
					condi+=" and index2='"+index2+"'";
				}
				//var time = $("cycle_id").values+"年第"+$("num").value+"期";
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select ETL_CYCLE_ID,Province,time,Index1,Index2,mb_Sort,mb_cnt,qqt_Sort,qqt_cnt,dgdd_Sort,dgdd_cnt,szx_Sort,szx_cnt,Td_Sort,Td_cnt,VIP_Sort,VIP_cnt,Lead_Sort,Lead_cnt,UN_Sort,UN_cnt,FIX_Sort,FIX_cnt from Group_satisfaction_import "+condi+" with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			function down(){
				var condi = " where 1=1 ";
				var cycle_id = $("cycle_id").value;
				//var month = $("month").value;
				//var time = year+"年第"+month+"期";
				var year = cycle_id.substr(0,4);
				var month = cycle_id.substr(4,2);
				month = parseInt(month);
				var time = year+"年第"+month+"期";
				condi+=" and time='"+time+"'";
				var index1 = $("index1").value;
				if(index1!=-1){
					condi+=" and index1='"+index1+"'";
				}
				var index2 = $("index2").value;
				if(index2!=-1){
					condi+=" and index2='"+index2+"'";
				}
				aihb.AjaxHelper.down({
					sql : "select ETL_CYCLE_ID,Province,time,Index1,Index2,mb_Sort,mb_cnt,qqt_Sort,qqt_cnt,dgdd_Sort,dgdd_cnt,szx_Sort,szx_cnt,Td_Sort,Td_cnt,VIP_Sort,VIP_cnt,Lead_Sort,Lead_cnt,UN_Sort,UN_cnt,FIX_Sort,FIX_cnt from Group_satisfaction_import  "+condi+" with ur"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			
			//function _delete() {
			//	if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
			//		return;
			//	var sql=encodeURIComponent("delete from nwh.cost_use_load ");
			//	var ajax = new aihb.Ajax({
			//		url : "${mvcPath}/hbirs/action/sqlExec"
			//		,parameters : "sqls="+sql
			//		,loadmask : false
			//		,callback : function(xmlrequest){
			//			var result = eval("(" + xmlrequest.responseText + ")");
			//			alert(result.message);
			//		}
			//	});
			//	ajax.request();
			//}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				var _d=new Date();
				$("cycle_id").value=_d.format("yyyymm");
				//$("import_date").value=_d.format("yyyy-mm-dd");
				/*
				$("failNum").onclick=function(){
		 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/channel/uploadinfo.html?taskId=" + taskId + "&" +_params._oriUri})
				}
				*/
				//$("queryBtn1").onclick = query1;
				$("queryBtn").onclick = query;
				$("downBtn").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>