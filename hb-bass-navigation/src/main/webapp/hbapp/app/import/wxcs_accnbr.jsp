<%@ page language="java" pageEncoding="utf-8"%>

<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-无线城市号码导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	无线城市号码导入
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
        <td valign="top"><a style="text-decoration: underline;" href="#" id="downModel"><font color="blue"><b>数据模板(CSV)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
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
	
		+function(window,document,undefined){
			
			//var _params = aihb.Util.paramsObj();
			var tableName="";
			
			function showPanel() {
				
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importForWxcs", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		}
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "csv") {
						alert("本应用只支持扩展名.csv,请重新上传.");
						return false;
					}
					
					if($('cycle_id').value==""||$('cycle_id').value==null){
						alert('请选择要导入的时间批次 !');
						return false;
					}
					checkTable();
					vault.setFormField("tableName", "nmk."+tableName);
		    		vault.setFormField("columns", "acc_nbr");
					return true;
				};						
				
			   	
	    	
		    	vault.onUploadComplete = function(files) {
					//alert("数据正在后台导入,无需重复导入 ! \r\n请观察相关表进行确认 !");
					alert("数据已成功导入，请观察相关表!\r\n无需重复导入!");
					loadmask.style.display="none";
					//showPanel();
					window.location.href='wxcs_accnbr.jsp';
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"acc_nbr",
					"name":["号码"],
					"title":"",
					"cellFunc":""
				}];
			function down(){
				aihb.AjaxHelper.down({
					sql : "select acc_nbr from nmk.wxcs_accnbr where 1=2"
					,header : _header
					,isCached : false
					,url : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=csv"
					,form : document.tempForm
				});
			}
			/**		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select id, time_id, channel, dep, city,acc_nbr,brand,arup,name,complain_type,complain_content,handle,satisfac,is_pre_complain,up_complain_time from up_complain where taskid='" + taskId + "' order by 1 with ur"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			*/
			
			function checkTable(){
				tableName='WXCS_ACCNBR_'+$("cycle_id").value;
				var sql="select count(1) from sysibm.systables where name='"+tableName+"' and type='T'";
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/filemanage?method=checkForWxcs"
					,parameters : "sql="+sql+"&ds="+"dw"
					,loadmask : false
					,callback : function(xmlrequest){	
							//alert(xmlrequest.responseText);
							var result=xmlrequest.responseText;
							if(result=="-1"){
								alert("缺少参数或sql执行异常,请联系开发人员 !");
								window.location.href='wxcs_accnbr.jsp';
								return false;
							}
							var sql2="";
							if(result!="0"){
								sql2="drop table nmk."+tableName;
								sql2+=";"+"create table nmk."+tableName+" like NMK.WXCS_ACCNBR IN BAS_CDR2 PARTITIONING KEY (ACC_NBR) USING HASHING";
							}else{
								sql2="create table nmk."+tableName+" like NMK.WXCS_ACCNBR IN BAS_CDR2 PARTITIONING KEY (ACC_NBR) USING HASHING";
							}
							//alert(sql2);
							
							new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs"
								,parameters : "sql="+sql2+"&ds=dw"
								,loadmask : false
								,callback : function(xmlrequest){
									if(xmlrequest.responseText=="-1"){
										alert("缺少参数或sql执行异常,请联系开发人员 !");
										window.location.href='wxcs_accnbr.jsp';
										return false;
									}
								}
							}).request();
					}
				});
				ajax.request();
			}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				$("downModel").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>