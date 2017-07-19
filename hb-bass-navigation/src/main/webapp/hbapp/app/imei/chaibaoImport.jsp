<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
	<head>
		<title>湖北移动经营分析系统-IMEI剔除拆包数据导入</title>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/des.js" charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	</head>
	<body>
		<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
			<legend>
				数据导入
			</legend>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="padding: 5px;">
					<td width="450"><div id="uploadDiv"></div>
						<input type="button" id="failNum" value="未导入成功号码查看"/>
						<input type="radio" name="model" value='1' checked="checked">原移动号段导入
						<input type="radio" name="model" value='2'>携转入号段导入 
					</td>
					
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=IMEI剔除拆包数据.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=拆包导入文件操作手册.doc"><font color="blue"><b>操作手册(Word)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font></div>
						<div>导入说明：</div>
						<div>1.请各分公司拆包负责人在每月倒数第二天零点前上传剔除拆包数据</div>
						<div>2.“处理方式”填写规则：有效期内每月剔除填<b>1</b>,当月剔除填<b>2</b></div>
						<div>3.请检查手机号为11位，IMEI为15位</div>
						<div>4.注意移动手机号以如下数字开头:134、135、136、137、138、139、150、151、152、157、158、159、147、182、183、184、187、188 </div>
						<div>5.导入模版修改为excel格式，请在文件中不要加入标题行，详情参考数据模版</div>
						<div>6.如果在导入过程中出现故障，请联系张韬(13986023266)</div>
					</td>
				</tr>
			</table>
		</fieldset>
		<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
					<%
						if(user.getId().equals("zhangtao2")){
							%>
							<td class='dim_cell_title'>导入月份</td>
						<td class='dim_cell_content'>
							<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" class="Wdate"/>
						</td>
							<% 
						}else{
							%>
							<td class='dim_cell_title'>导入日期</td>
						<td class='dim_cell_content'>
							<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
						</td>
							<%
						}
					%>
						
						<td class='dim_cell_title'>地市</td>
						<td class='dim_cell_content'>
							<select  id="cityTd" class='form_select'  style= 'WIDTH:65'>
								<option value="全省" selected>全省</option>
								<option value="武汉" >武汉</option>
								<option value="黄石" >黄石</option>
								<option value="鄂州" >鄂州</option>
								<option value="宜昌" >宜昌</option>
								<option value="恩施" >恩施</option>
								<option value="十堰" >十堰</option>
								<option value="襄阳" >襄阳</option>
								<option value="江汉" >江汉</option>
								<option value="咸宁" >咸宁</option>
								<option value="荆州" >荆州</option>
								<option value="荆门" >荆门</option>
								<option value="随州" >随州</option>
								<option value="黄冈" >黄冈</option>
								<option value="孝感" >孝感</option>
								<option value="天门" >天门</option>
							</select>
						</td>
						<td class='dim_cell_title'>操作</td>
						<td class='dim_cell_content'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="导入数据查询"/>&nbsp;
								<input type="button" id="downBtn" class="form_button" style="width: 100px" value="导入数据下载">&nbsp;
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend><table><tr>
					<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>&nbsp;数据展现区域：</td>
						<td></td>
					</tr></table>
				</legend>
				<div id="grid" style="display: none;"></div>
			</fieldset>
		</div><br>
	</form>
	<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/util.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript">
		var userId = '<%=user.getId()%>';
		+function(window,document,undefined){
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
			var day = new Date().format("yyyymmdd")-1;
			var today = new Date().format("yyyy-MM-dd")
			function showPanel() {
				var vault = new dhtmlXVaultObject();
				vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
				vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
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
					} else return true;
					};
					vault.setFormField("tableName", "NWH.IMEI_MBUSER_CS_UPLOAD");
					vault.setFormField("columns", "TASK_ID,SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE");
					vault.setFormField("date", taskId);
					vault.setFormField("ds", "web");
					vault.onUploadComplete = function(files) {
						alert("数据正在后台导入,无需重复导入 ! \r\n请半个小时后在此页面查询已导入数据，点击 未导入成功号码按钮查询未成功导入数据!");
						this.removeAllItems();
						loadmask.style.display="none";
						var radio = document.getElementsByName("model");
						var radioValue;
						for(var i=0;i<radio.length;i++) {
						     if(radio[i].checked)
						    	 radioValue=radio.item(i).getAttribute("value");  ;
						}
						var sql=encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag='成功' where task_id='" + taskId + "'");
						    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = '手机号位数不对' where task_id = '"+taskId+"' and length(acc_nbr) != 11 and length(IMEI)=15");
						    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = '处理方式不能为空' where task_id = '"+taskId+"' and deal_type is null");
						    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = 'IMEI位数不对' where task_id = '"+taskId+"' and length(IMEI) != 15 and length(acc_nbr)=11");
						    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = 'IMEI和手机号码位数不对' where task_id = '"+taskId+"' and length(IMEI) != 15 and length(acc_nbr)!=11");
						    if(radioValue=="2"){
								sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = '非移动号码' where task_id = '"+taskId+"' and acc_nbr not in (select telnum from NWH.CS_REC_CHGCARRIERTASK_"+day+" where tasktype in (0,1) and npresult ='120' and int(date(intime))>=20140920 )");
						    }else{
							    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = '非移动号码' where task_id = '"+taskId+"' and substr(acc_nbr,1,3) not in ('134','135','136','137','138','139','150','151','152','157','158','159','147','182','183','184','187','188')");
						    }
						    sql+="&sqls="+encodeURIComponent("update NWH.IMEI_MBUSER_CS_UPLOAD set flag = '已导入对应手机号码和IMEI' where task_id = '"+taskId+"' and acc_nbr||'&'||imei in (select acc_nbr||'&'||imei from NWH.IMEI_MBUSER_CS where import_date>char(date('"+today+"') -7 month) and deal_type=1)");
						    sql += "&sqls=" + encodeURIComponent("insert into NWH.IMEI_MBUSER_CS (SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE) select SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE from NWH.IMEI_MBUSER_CS_UPLOAD where task_id ='"+taskId+"' and flag = '成功'");
						    sql += "&sqls=" + encodeURIComponent("delete from NWH.IMEI_MBUSER_CS_UPLOAD where task_id='" + taskId + "' and flag='成功'");
							var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql+"&ds=web"
							,loadmask : false
							,callback : function(xmlrequest){
								//alert("导入完成,请查看未导入成功号码");
								//loadmask.style.display="none";
								//tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/imei/uploadinfo.jsp"});
								query();
							}
						});
						ajax.request();
						location.refresh();
					}
				};
				var _header= [
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"ser_no",
					"name":["序号"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_id",
					"name":["地市"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell",
					"dataIndex":"acc_nbr",
					"name":["号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"imei",
					"name":["捆绑IMEI"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"fee_name",
					"name":["捆绑优惠包"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"bind_date",
					"name":["捆绑日期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"reason",
					"name":["拆包返还优惠原因"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"deal_opinion",
					"name":["处理意见"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"import_date",
					"name":["导入日期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"deal_type",
					"name":["处理方式"],
					"title":"",
					"cellFunc":""
				}
				];
				function genSQL() {
					var sql = "";					
					if(userId == 'zhangtao2'){
						sql = "select SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE FROM NWH.IMEI_MBUSER_CS where 1=1 " + ($("date1").value ? " and substr(char(import_date),1,7)='" + $("date1").value + "'" : "");
					}else{
						sql = "select SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE FROM NWH.IMEI_MBUSER_CS where 1=1 " + ($("date1").value ? " and IMPORT_DATE='" + $("date1").value + "'" : "");	
					}
					if($("cityTd") && $("cityTd").value != "全省") {
						var cityName = $("cityTd").value;
						
						sql += " and area_id='" + cityName + "'";
					}
					//alert(sql);
					return sql;
				}
				function query(){
					var grid = new aihb.AjaxGrid({
						header:_header
						,ds:"web"
						,isCached : false
						,sql: genSQL()
					});
					grid.run();
				}
				function down(){
					aihb.AjaxHelper.down({
						sql : genSQL()
						,header : _header
						,ds:"web"
						,isCached : false
						,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
						,form : document.tempForm
					});
				}
				function getLastDay(year,month) { 
					var new_year = year; //取当前的年份 
					var new_month = month++;//取下一个月的第一天，方便计算（最后一天不固定） 
					if(month>12) { 
					new_month -=12; //月份减 
					new_year++; //年份增 
					} 
					var new_date = new Date(new_year,new_month,1); //取当年当月中的第一天 
					return (new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月最后一天日期 
				}
				window.onload=function(){
					var _d=new Date();
					var taday = getLastDay(_d.getYear(),_d.getMonth()+1);
					if(_d.getDate()!=taday){
						aihb.Util.loadmask();
						showPanel();
					}else{
						alert("每月最后一天不允许做导入操作！");
					}
					if(userId == 'zhangtao2'){
						$("date1").value=_d.format("yyyy-mm");
					}else{
						$("date1").value=_d.format("yyyy-mm-dd");
					}
					$("queryBtn").onclick = query;
					$("downBtn").onclick = down;
					$("failNum").onclick=function(){
			 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/imei/uploadinfo.jsp"})
			 		}
				}
			}(window,document);
		</script>
	</body>
</html>