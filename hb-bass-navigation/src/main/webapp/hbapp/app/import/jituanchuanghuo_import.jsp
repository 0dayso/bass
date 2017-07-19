<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-集团下发省际窜货明细导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	集团下发省际窜货明细导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
    <!-- <tr class='dim_row' style="padding:5px;">
			<td width="450" align="center" style="color:red;font:bold">*&nbsp;时间批次:
			<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" />
			</td>
			<td>
			&nbsp;
			</td>
	</tr>  -->
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
         <td valign="top"><a style="text-decoration: underline;" href="#" id="downModel"><font color="blue"><b>导入数据模板(csv)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
		<div style="color:red;font:bold">2.导入模版修改为CSV格式，请在文件删除标题行，详情参考数据模版</div>
		<div style="color:red;font:bold">3.IMEI为15位,且将IMEI设置成相应格式,避免插入数据类似为'1.23458E+13'格式</div>
		<div>4.一次只能导入一个月份的号码 </div>
		<div>5.每次导入会自动覆盖历史导入的同时间段的号码</div>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>

<div class="divinnerfieldset">

<fieldset>
	<legend><table>
	<tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div align="right">
		
			<input align="right" type="text" id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" />
			
			&nbsp;
			
			<input type="button" id="btnQuery" value="查询" />
		
	</div>
	<div id="show_div">
		<div id="showsum"></div>						
		<div title="选择数据栏中的操作处理按钮进行操作" id="showResult"></div>
	</div>
</fieldset>
</div><br>
<div id="title_div" style="display:none;">
	<table id="resultTable" align="center" width="100%"
		class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">						
			<td class="grid_title_cell" width="" id="0">省际窜入窜出时间</td>
			<td class="grid_title_cell" width="" id="1">终端imei</td>
			<td class="grid_title_cell" width="" id="2">品牌</td>
			<td class="grid_title_cell" width="" id="3">型号</td>
			<td class="grid_title_cell" width="" id="4">客户归属省</td>
			<td class="grid_title_cell" width="" id="5">终端销售省</td>
			<td class="grid_title_cell" width="" id="6">执行操作</td>
		</tr>
	</table>
</div>
</form>
<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/portal/portal_hb.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" defer=true>
	    var fetchRows=500;
	    pagenum=15; 
		+function(window,document,undefined){
		    cellfunc[6]=function(datas,options)
			{
				var tmpStr = datas[options.seq].split(";"); 
				//return "<input type='button' class='form_button_short' value='修改'	onclick=\"updateSingle(\'time_id="+datas[0].trim()+"&imei="+datas[1]+"&prod="+datas[2]+"&device_name="+datas[3]+"&use_locate="+datas[4]+"&sell_locate="+datas[5]+"')\">&nbsp<input type='button' class='form_button_short' value='删除'	onClick=\"deleteSingle('"+tmpStr+"')\">";
				//return "<input type='button' class='form_button_short' value='修改'	onclick=\"openhtml_p('singleadd','集团客户回流反馈单个数据录入','singleAdd_province.jsp?time_id="+datas[0].trim()+"&imei="+datas[1]+"&prod="+datas[2]+"&device_name="+datas[3]+"&use_locate="+datas[4]+"&sell_locate="+datas[5]+"')\">&nbsp<input type='button' class='form_button_short' value='删除'	onClick=\"deleteSingle('"+tmpStr+"')\">";
				return "<input type='button' class='form_button_short' value='修改'	onclick=\"window.location.href='jtchmodify.jsp?time_id="+datas[0].trim()+"&imei="+datas[1].trim()+"&prod="+datas[2].trim()+"&device_name="+datas[3].trim()+"&use_locate="+datas[4].trim()+"&sell_locate="+datas[5].trim()+"'\">&nbsp<input type='button' class='form_button_short' value='删除'	onClick=\"deleteSingle('"+tmpStr+"')\">";
				/* return "<input type='button' class='form_button_short' value='修改'	onclick=\"openhtml_pp('jtchmodify','集团下发省际串货数据修改','/hbapp/app/import/jtchmodify.jsp?time_id="+datas[0].trim()+"&imei="+datas[1]+"&prod="+datas[2]+"&device_name="+datas[3]+"&use_locate="+datas[4]+"&sell_locate="+datas[5]+"')\">&nbsp;<input type='button' class='form_button_short' value='删除'	onclick='deleteSingle("+datas[0]+","+datas[1]+")'>"; */
		 	}; 
			//var _params = aihb.Util.paramsObj();
			var tableName="TERMINAL_SJ_LOAD";
			var taskId = new Date().format("yyyymm");
			
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/csvmanage?method=csvLoadFile", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		};
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "csv") {
						alert("本应用只支持扩展名.csv,请重新上传.");
						return false;
					}
					
					/*  if($('cycle_id').value==""||$('cycle_id').value==null){
						alert('请选择要导入的时间批次 !');
						return false;
					}else{
						vault.setFormField("date", $('cycle_id').value);
					}  */
					// checkTable();
					vault.setFormField("tableName", "NWH."+tableName);
					return true;
				};						
				vault.setFormField("columns", "time_id,imei,prod,device_name,use_locate,sell_locate");
				vault.setFormField("ds","dw");
			//	vault.setFormField("date", taskId);
				
		    	vault.onUploadComplete = function(files) {
					//alert("数据正在后台导入,无需重复导入 ! \r\n请观察相关表进行确认 !");
					alert("数据已成功导入，请观察相关表!\r\n无需重复导入!");
					loadmask.style.display="none";
					//showPanel();
					window.location.href='jituanchuanghuo_import.jsp';
		    	}
			};
			
			var _header= [
			 {
				"cellStyle":"grid_row_cell_number",
				"dataIndex":"time_id",
				"name":["省际窜入窜出时间"],
				"title":"",
				"cellFunc":""
			}, 
			{
				"cellStyle":"grid_row_cell_number",
				"dataIndex":"imei",
				"name":["终端imei(15位)"],
				"title":"",
				"cellFunc":""
			},
			{
				"cellStyle":"grid_row_cell_number",
				"dataIndex":"prod",
				"name":["品牌"],
				"title":"",
				"cellFunc":""
			},
			{
				"cellStyle":"grid_row_cell_text",
				"dataIndex":"device_name",
				"name":["型号"],
				"title":"",
				"cellFunc":""
			},
			{
				"cellStyle":"grid_row_cell",
				"dataIndex":"use_locate",
				"name":["客户归属省"],
				"title":"",
				"cellFunc":""
			},
			{
				"cellStyle":"grid_row_cell_text",
				"dataIndex":"sell_locate",
				"name":["终端销售省"],
				"title":"",
				"cellFunc":""
			},
			{
				"cellStyle":"grid_row_cell_text",
				"dataIndex":"execute",
				"name":["执行操作"],
				"title":"",
				"cellFunc":""
			}
			];
			function down(){
				aihb.AjaxHelper.down({
					sql : "select time_id,imei,prod,device_name,use_locate,sell_locate from NWH.TERMINAL_SJ_LOAD where 1=2"
					,header : _header
					,isCached : false
					,url : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=csv"
					,form : document.tempForm
				});
			}
			
			function query(){
				if($('date2').value==""||$('date2').value==null){
						alert('请选择要查询的时间批次 !');
						$('date2').focus();
						return false;
				}
				var countSql ="";
		 		var sql = "select time_id,imei,prod,device_name,use_locate,sell_locate,imei from NWH.TERMINAL_SJ_LOAD where time_id="+$('date2').value;		
				sql +=  " fetch first "+fetchRows+" rows only with ur";
				
				var downSql = "select time_id,imei,prod,device_name,use_locate,sell_locate from NWH.TERMINAL_SJ_LOAD where time_id="+$('date2').value;
				// document.forms[0].sql.value = encodeURIComponent(downSql);
				countSql="select count(*) from NWH.TERMINAL_SJ_LOAD  where time_id="+$('date2').value;
				
				sql = encodeURIComponent(sql);
				ajaxSubmitWrapper(sql,countSql);
			}
			
			/*	function checkTable(){
				tableName='TERMINAL_SJ_LOAD';
				 var sql="select count(1) from sysibm.systables where name='"+tableName+"' and type='T'";
				alert(sql);
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/filemanage?method=checkForWxcs"
					,parameters : "sql="+sql+"&ds="+"web"
					,loadmask : false
					,callback : function(xmlrequest){	
							//alert(xmlrequest.responseText);
							var result=xmlrequest.responseText;
							alert("result="+result);
							if(result=="-1"){
								alert("缺少参数或sql执行异常,请联系开发人员 !");
								window.location.href='ict_business_service.jsp';
								return false;
							}
							var sql2="";
							if(result!="0"){
								sql2="drop table nmk."+tableName;
								sql2+=";"+"create table nmk."+tableName+" like NMK.ENT_ICT_CHARGE IN USERSPACE1 PARTITIONING KEY (CITY_ID) USING HASHING";
							}else{
								sql2="create table nmk."+tableName+" like NMK.ENT_ICT_CHARGE IN USERSPACE1 PARTITIONING KEY (CITY_ID) USING HASHING";
							}
							alert(sql2);
							
							new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs"
								,parameters : "sql="+sql2+"&ds=web"
								,loadmask : false
								,callback : function(xmlrequest){
									if(xmlrequest.responseText=="-1"){
										alert("缺少参数或sql执行异常,请联系开发人员 !");
										window.location.href='ict_business_service.jsp';
										return false;
									}
								}
							}).request();
					}
				});
				ajax.request(); 
			}*/
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				$("downModel").onclick = down;
				$("btnQuery").onclick=query;
			}
		}(window,document);
		
		
		function deleteSingle(number1)
		{
		  var imei = number1;
		  if(confirm("确认删除"+imei+"号码的反馈数据？"))
		  {
			  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
				xmlHttp.onreadystatechange=delBack; // 设置回掉函数
				xmlHttp.open("POST","${mvcPath}/hbapp/app/import/jtchDb.jsp",false);
				xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				var str="actiontype=singleDelete&imei="+imei;
				str = encodeURI(str,"utf-8");
				xmlHttp.send(str);
				alert(xmlHttp.responseText);
			}
		}
		
		function delBack()
		{
			if(xmlHttp.readyState == 4)
			{
				if(xmlHttp.status == 200)
				{
					window.location.href='jituanchuanghuo_import.jsp';
				}
			}
		}
		
	</script>
</body>
</html>