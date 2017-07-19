<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = System.getProperty("user.dir") + "/";
%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-ICT业务集成服务收入导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	ICT业务集成服务收入导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
   <tr class='dim_row' style="padding:5px;">
			<td width="450" align="center" style="color:red;font:bold">*&nbsp;时间批次:
			<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" />
			</td>
			<td>
			&nbsp;
			</td>
	</tr>
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="#" id="downModel"><font color="blue"><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
		<div>导入前请先选择导入时间</div>
		<div style="color:red;font:bold">*&nbsp;导入文件应该删除第一行中文标识</div>
		<div>一次只能导入一个月份的号码</div>
		<div>每次导入会自动覆盖历史导入的同时间段的号码</div>
	<div></div>
		</td>
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
			
			var tableName="";
			var taskId = new Date().format("yyyymmdd");
			
			function showPanel() {
				
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcelAny", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		};
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					}
					
					if($('cycle_id').value==""||$('cycle_id').value==null){
						alert('请选择要导入的时间批次 !');
						return false;
					}
					checkTable();
					vault.setFormField("tableName", "NMK."+tableName);
					return true;
				};						
				vault.setFormField("columns", "time_id,city_id,bill_charge");
				vault.setFormField("ds","dw");
				vault.setFormField("date", taskId);
				
		    	vault.onUploadComplete = function(files) {
					//alert("数据正在后台导入,无需重复导入 ! \r\n请观察相关表进行确认 !");
					alert("数据已成功导入，请观察相关表!\r\n无需重复导入!");
					loadmask.style.display="none";
					//showPanel();
					window.location.href='ict_business_service.jsp';
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"time_id",
					"name":["时间批次"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"city_id",
					"name":["地市"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"bill_charge",
					"name":["ICT业务集成费（元）"],
					"title":"",
					"cellFunc":""
				}
			];
			function down(){
				aihb.AjaxHelper.down({
					sql : "select time_id,city_id,bill_charge from nmk.ent_ict_charge where 1=2"
					,header : _header
					,isCached : false
					,url : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
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
					,sql: "select city_id,bill_charge from nmk.ent_ict_charge where time_id='"+$('date2').value+"'  with ur"
					,isCached : false
					,ds:'dw'
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			
			function checkTable(){
				var time = $("cycle_id").value;
				tableName = 'ENT_ICT_CHARGE';
				var sql="select count(*) from NMK."+tableName+" where time_id = '"+time+"'";
				alert("正在查询数据，请稍后收到'请上传excel文档！'提示之后上传excel文档！");
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/filemanage?method=checkForWxcs"
					,parameters : "sql="+sql+"&ds="+"dw"
					,loadmask : false
					,callback : function(xmlrequest){	
							//alert(xmlrequest.responseText);
							var result=xmlrequest.responseText;
							if(result=="-1"){
								alert("缺少参数或sql执行异常,请联系开发人员 !");
								window.location.href='ict_business_service.jsp';
								return false;
							}
							var sql2="";
							if(result != "0"){
								sql2 = "delete from nmk."+tableName+" where time_id='"+time+"'";
							}
							
							if(sql2 != ""){
								alert("正在删除数据，请稍后收到'请上传excel文档！'提示之后上传excel文档！");
								new aihb.Ajax({
									url : "${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs"
									,parameters : "sql="+sql2+"&ds=dw"
									,loadmask : false
									,callback : function(xmlrequest){
										if(xmlrequest.responseText=="-1"){
											alert("缺少参数或sql执行异常,请联系开发人员 !");
											window.location.href='ict_business_service.jsp';
											return false;
										}else{
											alert("请上传excel文档！");
										}
									}
								}).request();
							}else{
								alert("<%=path%>请上传excel文档！");
							}
					}
				});
				ajax.request();
			}
			
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