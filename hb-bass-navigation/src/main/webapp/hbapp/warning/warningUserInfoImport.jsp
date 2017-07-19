<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-预警阀值配置和人员配置导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	预警阀值配置和人员配置导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" id="modelDown"><font color="blue"><b>(各区县匹配数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击下载</font> 
		<div>导入说明：</div>
		<div>导入前请先下载文件附件，附件中有与你权限相关的所有渠道信息,（省公司请点击下边下边按钮下载全部信息配置）</div>
		<div>每次导入会覆盖之前的数据，请核实数据完整及正确性之后再提交</div>

	<div></div>
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
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_title'>地市</td>
			<td class='dim_cell_content'>
			<select name="city" class='form_select' id="city" onchange="changeCity()" >
					<option value="-1" selected='selected'>全省</option>
					<option value="武汉">武汉</option>
					<option value="黄石">黄石</option>
					<option value="鄂州">鄂州</option>
					<option value="宜昌">宜昌</option>
					<option value="恩施">恩施</option>
					<option value="十堰">十堰</option>
					<option value="襄阳">襄阳</option>
					<option value="江汉">江汉</option>
					<option value="咸宁">咸宁</option>
					<option value="荆州">荆州</option>
					<option value="荆门">荆门</option>
					<option value="随州">随州</option>
					<option value="黄冈">黄冈</option>
					<option value="孝感">孝感</option>
					<option value="天门">天门</option>
					<option value="潜江">潜江</option>
					</select>
			</td>
			<td class='dim_cell_title'>区县</td>
			<td class='dim_cell_content' >
				<select name='county'  id='county' style="width:200px" >
					<option value="-1" selected='selected'>请选择地市</option>
				</select>
			</td>
			
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center ; float:reight">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
				</div>
			</td>
		</tr>
	</table>
</div>


<div class="divinnerfieldset">
<fieldset>
	<legend><table>
	<tr>
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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/util.js" charset=utf-8></script>
	<script type="text/javascript">
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var userName='<%=user.getId()%>';
			//alert(user);
			var taskId = new Date().format("yyyymmddhhmiss") + "@" + userName;
			var currentDate = new Date().format("yyyymmhhmiss");
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
				
			   	vault.setFormField("tableName", "warning_userinfo_tmp");
		    	vault.setFormField("columns", "taskid, level,citycode,cityname,countycode,countyname,channelcode,channelname,redwarnval,redusername,reduserphone,orangewarnval ,orangeusername,orangeuserphone,bluewarnval,blueusername,blueuserphone");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
					
						//查询临时表有多少条合法记录待此次导入
						var _sql = "select count(*) cnt from warning_user_cfg where operator='<%=user.getId()%>' ";
						
						var _ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/jsondata?method=query"
							,parameters : "sql="+encodeURIComponent(_sql)+"&isCached=false"
							,loadmask : true
							,callback : function(xmlrequest){
								try{
									var result = xmlrequest.responseText;
									result = eval(result);
									//如果导入数为空，则导入失败
									if(!result || !result[0].cnt || result[0].cnt==0){
										alert("导入失败，你没有权限导入数据");
										return;
									}
									if(confirm("请再次确认数据正确性，您确定要将这批数据入库吗?")){
										//var sql="";
										if("helei" != userName){
										var sql=encodeURIComponent("update warning_userinfo_data as a  set(redWarnVal,orangeWarnVal,blueWarnVal)  =(select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and a.channelCode=b.channelCode) where exists (select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and a.channelCode=b.channelCode)");
										sql += "&sqls=" + encodeURIComponent("update warning_userinfo_data as a  set(redWarnVal,orangeWarnVal,blueWarnVal)  =(select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode  and  b.level='区县' and a.level='区县') where exists (select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and b.level='区县' and a.level='区县')");
										sql += "&sqls=" + encodeURIComponent("update warning_userinfo_data as a  set(redWarnVal,orangeWarnVal,blueWarnVal)  =(select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode   and a.level='地市' and b.level='地市') where exists (select redWarnVal,orangeWarnVal,blueWarnVal  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode  and a.level='地市' and b.level='地市')");
										//alert("1");
										}else {
										//alert("2");
										var sql=encodeURIComponent("update warning_userinfo_data as a  set(redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone)  = (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and a.channelCode=b.channelCode)where exists (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and a.channelCode=b.channelCode)" );
										sql += "&sqls=" + encodeURIComponent("update warning_userinfo_data as a  set(redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone)  = (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode  and b.level='区县' and a.level='区县' ) where exists (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode and a.countyCode=b.countyCode and b.level='区县' and a.level='区县' ) ");
										sql += "&sqls=" + encodeURIComponent("update warning_userinfo_data as a  set(redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone)  = (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode  and a.level='地市' and b.level='地市' )where exists (select redUserName,redUserPhone,orangeUserName,orangeUserPhone,blueUserName,blueUserPhone  from   warning_userinfo_tmp b  where a.cityCode=b.cityCode  and a.level='地市' and b.level='地市') ");
										}
										//var sql=encodeURIComponent("delete from warning_userinfo_data where cityName in ( select a.area_name from mk.bt_area a join fpf_user_user b on char(a.area_id)=b.cityid where b.userid='<%=user.getId()%>') ");
										//sql += "&sqls=" + encodeURIComponent("insert into warning_userinfo_data  select level,cityCode,cityName,countyCode,countyName,channelCode,channelName ,redWarnVal ,redUserName ,redUserPhone ,orangeWarnVal ,orangeUserName ,orangeUserPhone ,blueWarnVal ,blueUserName ,blueUserPhone from warning_userinfo_tmp  where taskid='" + taskId + "' and length(trim(redUserPhone))=11 and length(trim(orangeUserPhone))=11 and length(trim(blueUserPhone))=11 ");
										sql += "&sqls=" + encodeURIComponent("insert into warning_userinfo_log select level,cityCode,cityName,countyCode,countyName,channelCode,channelName ,redWarnVal ,redUserName ,redUserPhone ,orangeWarnVal ,orangeUserName ,orangeUserPhone ,blueWarnVal ,blueUserName ,blueUserPhone,'<%=user.getId()%>',substr(taskid,1,8) from warning_userinfo_tmp " );
										sql += "&sqls=" + encodeURIComponent("delete from warning_userinfo_tmp where taskid='" + taskId + "'");
										var ajaxAdd = new aihb.Ajax({
											url : "${mvcPath}/hbirs/action/sqlExec"
											,parameters : "sqls="+sql
											,loadmask : false
										})
										ajaxAdd.request();
									}
									alert("成功导入记录");
									//最后再查询最新数据
									aihb.Util.loadmask();
									query();
								}catch(e){
									alert("导入失败，请查询数据是否正确");
									return;
								}
							}
						})
						_ajax.request();		    	
		    	}
			};
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"level",
					"name":["级别"],
					"title":"",
					"cellFunc":""
				},{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"citycode",
					"name":["地市ID"],
					"title":"",
					"cellFunc":""
				},{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"cityname",
					"name":["地市"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"countycode",
					"name":["区县ID"],
					"title":"",
					"cellFunc":""
				},{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"countyname",
					"name":["区县"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"channelcode",
					"name":["渠道ID"],
					"title":"",
					"cellFunc":""
				},{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"channelname",
					"name":["渠道"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"redwarnval",
					"name":["红色预警阀值"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"redusername",
					"name":["联系人姓名"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"reduserphone",
					"name":["联系人电话"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"orangewarnval",
					"name":["橙色预警阀值"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"orangeusername",
					"name":["联系人姓名"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"orangeuserphone",
					"name":["联系人电话"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"bluewarnval",
					"name":[" 蓝色预警阀值"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"blueusername",
					"name":["联系人姓名"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_number",
					"dataIndex":"blueuserphone",
					"name":["联系人电话"],
					"title":"",
					"cellFunc":""
				}
				];
				
				
				
				
				function getSQL() {
					var sql = "";
					var condi = " where 1=1 ";
					var index1 = $("city").value;
					var index2= $("county").value;
					if(index1 !=-1){
					condi+=" and cityName like '%"+index1+"%' "
					}if (index2 !=-1){
					condi+=" and countyCode like '%"+index2+"%' ";
					}
					sql="select level,cityCode,cityName,countyCode,countyName,channelCode,channelName ,redWarnVal ,redUserName ,redUserPhone ,orangeWarnVal ,orangeUserName ,orangeUserPhone ,blueWarnVal ,blueUserName ,blueUserPhone  from warning_userinfo_data "+condi+"  order by cityName with ur"
					return sql;
				}
			function query(){
					var grid = new aihb.SimpleGrid({
					header:_header
					,sql : getSQL()
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
				}
			function down(){
				aihb.AjaxHelper.down({
						sql : getSQL()
						,header : _header
						,isCached : false
						,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
						,form : document.tempForm
					});
				}
				function downModel(){
				aihb.AjaxHelper.down({
					sql: "select level,cityCode,cityName,countyCode,countyName,channelCode,channelName,redWarnVal,redUserName ,redUserPhone,orangeWarnVal,orangeUserName ,orangeUserPhone  ,blueWarnVal,blueUserName ,blueUserPhone  from warning_userinfo_data  where cityName in ( select a.area_name from mk.bt_area a join fpf_user_user b on char(a.area_id)=b.cityid where b.userid='<%=user.getId()%>' )  with ur"
					,header : _header 
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				$("queryBtn").onclick = query;
				$("downBtn").onclick = down;
				$("modelDown").onclick=downModel;
			}
		}(window,document);
		function changeCity(){
				var cityName=$("city").value;
				if(cityName != -1){
				aihb.FormHelper.fillSelectWrapper({element:$('county'),isHoldFirst:true,sql:"select county_code key,county_name value from MK.BT_AREA_all where area_name like '%"+cityName+"%' with ur"});
				}else{
					$("county").options.length=1;
					$("county").value="请选择地市"
				}
		}
	</script>
</body>
</html>