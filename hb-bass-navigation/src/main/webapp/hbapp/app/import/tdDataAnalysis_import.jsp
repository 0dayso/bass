<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-TD非定制终端经分数据分析</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	TD非定制终端经分数据分析
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
         <td valign="top"><a style="text-decoration: underline;" href="#" id="downModel"><font color="blue"><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
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
	<div id="grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>
<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	
		+function(window,document,undefined){
			
			//var _params = aihb.Util.paramsObj();
			var tableName="DIM_TERMINAL_FDZ";
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
				vault.setFormField("columns", "time_id,corp,prod,device_name,imei_8,flag_pt,flag_qw");
				vault.setFormField("ds","dw");
			//	vault.setFormField("date", taskId);
				
		    	vault.onUploadComplete = function(files) {
					//alert("数据正在后台导入,无需重复导入 ! \r\n请观察相关表进行确认 !");
					alert("数据已成功导入，请观察相关表!\r\n无需重复导入!");
					loadmask.style.display="none";
					//showPanel();
					window.location.href='tdDataAnalysis_import.jsp';
		    	}
			};
			
			var _header= [
 			 {
 				"cellStyle":"grid_row_cell_number",
 				"dataIndex":"time_id",
 				"name":["导入批次"],
 				"title":"",
 				"cellFunc":""
 			}, 
 			{
 				"cellStyle":"grid_row_cell_text",
 				"dataIndex":"corp",
 				"name":["合作厂家"],
 				"title":"",
 				"cellFunc":""
 			},
 			{
 				"cellStyle":"grid_row_cell_number",
 				"dataIndex":"prod",
 				"name":["终端品牌"],
 				"title":"",
 				"cellFunc":""
 			},
 			{
 				"cellStyle":"grid_row_cell_number",
 				"dataIndex":"device_name",
 				"name":["终端机型"],
 				"title":"",
 				"cellFunc":""
 			},
 			{
 				"cellStyle":"grid_row_cell_number",
 				"dataIndex":"imei_8",
 				"name":["终端imei前八位"],
 				"title":"",
 				"cellFunc":""
 			},
 			{
 				"cellStyle":"grid_row_cell_text",
 				"dataIndex":"flag_pt",
 				"name":["是否合作平台销售"],
 				"title":"",
 				"cellFunc":""
 			},
 			{
 				"cellStyle":"grid_row_cell",
 				"dataIndex":"flag_qw",
 				"name":["是否全网合作分省合作销售"],
 				"title":"",
 				"cellFunc":""
 			}
			];
			function down(){
				aihb.AjaxHelper.down({
					sql : "select time_id,corp,prod,device_name,imei_8,flag_pt,flag_qw from NWH.DIM_TERMINAL_FDZ where 1=2"
					,header : _header
					,isCached : false
					,url : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=csv"
					,form : document.tempForm
				});
			}
			
			function query(){
				if($('date2').value==""||$('date2').value==null){
						alert('请选择要查询的时间批次 !');
						return false;
				}
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select time_id,corp,prod,device_name,imei_8,flag_pt,flag_qw from NWH.DIM_TERMINAL_FDZ where time_id="+$('date2').value+"  with ur"
					,isCached : false
					,ds:'dw'
					,callback : function() {
						
					}
				});
				grid.run();
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
		
	</script>
</body>
</html>