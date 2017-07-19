<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html>
	<head>
		<title>湖北移动经营分析系统-NG3.5报表</title>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	</head>
	<body>
		<table align='center' width='99%' cellspacing='1' cellpadding='0' border='0' style="margin: 0px 10px 0px 10px;">
				<tr class='dim_row'>
					<td class='dim_cell_title'>报表名称</td>
					<td class='dim_cell_content'>
						<select name="subjectid" id="subjectid">
							<option value="12917" selected>NG3.5个人客户统一视图</option>
							<option value="12918">NG3.5家庭客户统一视图</option>
							<option value="12919">NG3.5他网客户统一视图</option>
							<option value="12920">NG3.5个人客户重入网识别模型</option>
							<option value="12921">NG3.5个人客户资费推荐模型</option>
							<option value="12922">NG3.5个人客户消费异常监控模型</option>
							<option value="12924">NG3.5个人客户投诉信用分级</option>
							<option value="12926">NG3.5竞争客户细分识别模型</option>
						</select>			
					</td>
				</tr>
			</table>
			<br/>
		<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
			<legend>
				数据导入
			</legend>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="padding: 5px;">
					<td width="450"><div id="uploadDiv"></div>
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=NG3.5报表.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=拆包导入文件操作手册.doc"><font color="blue"><b>操作手册(Word)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font></div>
						<div>导入说明：</div>
						<div>1.查询或者下载之前请先选择报表；</div>
						<div>2.查询或者下载多个手机号，请先上传手机号再做查询；</div>
					</td>
				</tr>
			</table>
		</fieldset>
		<form method="post" action=""><br>
			<div>
				<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
					<tr class='dim_row'>
						<td class='dim_cell_title'>地市</td>
						<td class='dim_cell_content'>
							<select name="channel_code" id="channel_code">
								<option value="" selected>全省</option>
								<option value="HB.WH">武汉</option>
								<option value="HB.TM">天门</option>
								<option value="HB.SY">十堰</option>
								<option value="HB.SZ">随州</option>
								<option value="HB.HG">黄冈</option>
								<option value="HB.ES">恩施</option>
								<option value="HB.XN">咸宁</option>
								<option value="HB.QJ">潜江</option>
								<option value="HB.EZ">鄂州</option>
								<option value="HB.JM">荆门</option>
								<option value="HB.XG">孝感</option>
								<option value="HB.JZ">荆州</option>
								<option value="HB.JH">江汉</option>
								<option value="HB.XF">襄阳</option>
								<option value="HB.HS">黄石</option>
								<option value="HB.YC">宜昌</option>
							</select>							
						</td>
						<td class='dim_cell_title'>手机号</td>
						<td class='dim_cell_content'>
							<input align="right" type="text" id="acc_nbr" name="acc_nbr"/>
							<input type="hidden" id="count" name="count" value="0" />
						</td>
						<td class='dim_cell_title'>操作</td>
						<td class='dim_cell_content'>
							<div style="text-align: right; text-align: center">
								<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
								<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载"/>&nbsp;
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
			var taskId = "<%=user.getId()%>";
			var subjectId;
			function showPanel() {
				var vault = new dhtmlXVaultObject();
				vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
				vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcelForSubject", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
				vault.setFilesLimit(1);
				vault.create("uploadDiv");
				vault.onFileUpload=function(){
					loadmask.style.display="";
					return true;
				};
				vault.onAddFile = function(fileName) {
					subjectId = $("subjectid").value;
					if(subjectId=='' || subjectId==null){
						alert("请先选择报表再上传！");
						return false;
					};
					$("count").value='0';
					vault.setFormField("subjectId", subjectId);
					var ext = this.getFileExtension(fileName);
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					} else return true;
				};
				vault.setFormField("tableName", "NMK.SUBJECT_ACC_NBR");
				vault.setFormField("columns", "USER_ID,SUBJECT_ID,ACC_NBR");
				vault.setFormField("date", taskId);
				vault.setFormField("subjectId", subjectId);
				vault.setFormField("ds", "nl");
				vault.onUploadComplete = function(files) {
					var _sql = "select count(*) cnt from NMK.SUBJECT_ACC_NBR";
					var _ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/jsondata?method=query"
						,parameters : "sql="+encodeURIComponent(_sql)+"&isCached=false"+"&ds=nl"
						,loadmask : true
						,callback : function(xmlrequest){
							try{
								var result = xmlrequest.responseText;
								result = eval(result);
								$("count").value=result[0].cnt;
								//最后再查询最新数据
								aihb.Util.loadmask();
							}catch(e){
								alert("导入失败，请查询数据是否正确");
								return;
							}
						}
					})
					_ajax.request();
				}
			};
				var _header1= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["姓名"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["用户编码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["手机号"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["性别"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["证件类别"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["证件号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["年龄"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_7",
									"name":["生日"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_8",
									"name":["联系电话"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_9",
									"name":["邮政编码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_10",
									"name":["通信地址"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_11",
									"name":["联系人"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_12",
									"name":["联系人电话"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header2= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["户主ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["成员ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["成员号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["所属运营商"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["成员类型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["成员名称"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["成员间通话次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["成员间通话时长"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header3= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["用户号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["所属地区"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["所属县域"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["最近一次通信时间"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["通信次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["主叫时长"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["被叫时长"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["通话时长"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header4= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["重入网前的客户号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["资费套餐"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["入网渠道"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["重入网后的客户号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["资费套餐"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["入网渠道"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header5= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["用户ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["用户类型"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["推荐套餐ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["推荐套餐名称"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header6= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["通话收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["本地通话收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["长途通话收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["漫游通话收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["流量收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["WLAN收入监控"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["用户ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["总收入监控"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header7= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["用户ID"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["用户号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["投诉信用等级"],
									"title":"",
									"cellFunc":""
								}
				];
				var _header8= [
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"'col_alias_0'",
									"name":["竞争对手号码"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_1",
									"name":["主叫通话时长"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell",
									"dataIndex":"col_alias_2",
									"name":["被叫通话时长"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_number",
									"dataIndex":"col_alias_3",
									"name":["主叫通话次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_4",
									"name":["被叫通话次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_5",
									"name":["短信次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["工作时间通话次数"],
									"title":"",
									"cellFunc":""
								},
								{
									"cellStyle":"grid_row_cell_text",
									"dataIndex":"col_alias_6",
									"name":["休息时间通话次数"],
									"title":"",
									"cellFunc":""
								}
				];
								function genSQL() {
									var count = $("count").value;
									var sql = "";			
									var subjectid = $("subjectid").value;
									if(subjectid=='12917'){
										sql = 
											"select substr(CUST_NAME,1,2)||'xx' as col_alias_0,\n" +
											"MBUSER_ID as col_alias_1,\n" + 
											"substr(a.ACC_NBR,1,3)||'xxxxxxx' as col_alias_2,\n" + 
											"case when SEX_ID = 1 then '男' when SEX_ID = 0 then '女' else '未知' end as col_alias_3,\n" + 
											"CERT_TID2 as col_alias_4,\n" + 
											"substr(CERT_NO,1,3)||'xxxxxxx' as col_alias_5,\n" + 
											"AGE as col_alias_6,\n" + 
											"BIRTH_DATE as col_alias_7,\n" + 
											"CONN_NBR2 as col_alias_8,\n" + 
											"POST_CODE as col_alias_9,\n" + 
											"HOUSEADDR as col_alias_10,\n" + 
											"CONN_NAME as col_alias_11,\n" + 
											"CONN_NBR as col_alias_12\n" + 
											"from NWH.NG_PERSON_UNIFY_VIEW_201405 a \n";
									}else if(subjectid=='12918'){
										sql = "select MASTER_MBUSER_ID as col_alias_0,\n" +
											"MBUSER_ID as col_alias_1,\n" + 
											"a.ACC_NBR as col_alias_2,\n" + 
											"case when ISP_ID = 'CMCC' then '移动'\n" + 
											"when ISP_ID = 'Unicom' then '联通'\n" + 
											"else '电信' end as col_alias_3,\n" + 
											"case when MEMBER_TYPE = 'HouseMaterA' then '户主'\n" + 
											"when MEMBER_TYPE = 'HouseMaterB' then '次要户主'\n" + 
											"else '普通成员' end as col_alias_4,\n" + 
											"FEE_ID, DATA_SOURCE, FAMILY_FLAG,\n" + 
											"CUST_NAME as col_alias_5,\n" + 
											"value(JT_SUM_CALL_TIMES,0) as col_alias_6,\n" + 
											"value(decimal(JT_SUM_CALL_DURA/60,16,2),0) as col_alias_7\n" + 
											"  from NMK.DW_FAMILY_MBUSER_201406 a \n" ;
									}else if(subjectid=='12919'){
										sql = 
											"select substr(a.ACC_NBR,1,3)||'xxxxxxx' as col_alias_0,\n" +
											"UP_DATE as col_alias_3,\n" + 
											"SUM_TIMES_M as col_alias_4,\n" + 
											"SELL_DISTRICT as col_alias_1,\n" + 
											"SELL_COUNTY as col_alias_2,\n" + 
											"decimal(ZJ_DURA_M/60,16,2) as col_alias_5,\n" + 
											"decimal(BJ_DURA_M,16,2) as col_alias_6,\n" + 
											"decimal(DURA1_M,16,2) as col_alias_7\n" + 
											"from NMK.RVUSER_201405 aa \n";
									}else if(subjectid=='12920'){
										sql = "select substr(acc_nbr,1,3)||'xxxxxxx' as col_alias_3, substr(HIS_USER_NUMBER,1,3)||'xxxxxxx' as col_alias_0,\n" +
											"    d.county_name as col_alias_5,\n" + 
											"    e.county_name as col_alias_2,\n" + 
											"b.fee_name as col_alias_1,\n" + 
											"c.fee_name as col_alias_4\n" + 
											"from (select RN_USER_NUMBER as acc_nbr, HIS_USER_NUMBER,\n" + 
											"HIS_BEFORE_PLAN_ID,RN_BASE_PLAN_ID,RN_BASE_COUNTY_CODE,HIS_BASE_COUNTY_CODE\n" + 
											"from NMK.DMRN_USER_201405) a\n" + 
											"left join nwh.fee b\n" + 
											"on a.HIS_BEFORE_PLAN_ID = b.fee_id\n" + 
											"left join nwh.fee c\n" + 
											"on a.RN_BASE_PLAN_ID = c.fee_id\n" + 
											"left join MK.BT_AREA_all d\n" + 
											"on a.RN_BASE_COUNTY_CODE = d.county_code\n" + 
											"left join MK.BT_AREA_all e\n" + 
											"on a.HIS_BASE_COUNTY_CODE = e.county_code \n";
									}else if(subjectid=='12921'){
										sql = "select MBUSER_ID as col_alias_0, a.ACC_NBR, CHANNEL_CODE, USER_TYPE as col_alias_1, PLAN_FEE_ID as col_alias_2, PLAN_FEE_NAME as col_alias_3 from NMK.DW_GPRS_FEE_RES_ALL_201405 a ";
									}else if(subjectid=='12922'){
										sql = 
											"select mbuser_id,\n" +
											"case when bill_charge_rate >= 1.5 then '↑50%'\n" + 
											"when bill_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_1,\n" + 
											"case when call_charge_rate >= 1.5 then '↑50%'\n" + 
											"when call_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_2,\n" + 
											"case when local_call_charge_rate >= 1.5 then '↑50%'\n" + 
											"when local_call_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_3,\n" + 
											"case when toll_charge_rate >= 1.5 then '↑50%'\n" + 
											"when toll_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_4,\n" + 
											"case when gprs_charge_rate >= 1.5 then '↑50%'\n" + 
											"when gprs_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_5,\n" + 
											"case when wlan_charge_rate >= 1.5 then '↑50%'\n" + 
											"when wlan_charge_rate < 0.5 then '↓50%'\n" + 
											"else '正常' end as col_alias_6\n" + 
											"from\n" + 
											"(select\n" + 
											"mbuser_id, channel_code,\n" + 
											"case when bill_charge_avg = 0 then 0 else double(bill_charge)/bill_charge_avg end as bill_charge_rate,\n" + 
											"case when call_charge_avg = 0 then 0 else double(call_charge)/call_charge_avg end as call_charge_rate,\n" + 
											"case when local_call_charge_avg = 0 then 0 else double(local_call_charge)/local_call_charge_avg end as local_call_charge_rate,\n" + 
											"case when toll_charge_avg = 0 then 0 else double(toll_charge)/toll_charge_avg end as toll_charge_rate,\n" + 
											"case when roam_charge_avg = 0 then 0 else double(roam_charge)/roam_charge_avg end as roam_charge_rate,\n" + 
											"case when gprs_charge_avg = 0 then 0 else double(gprs_charge)/gprs_charge_avg end as gprs_charge_rate,\n" + 
											"case when wlan_charge_avg = 0 then 0 else double(wlan_charge)/wlan_charge_avg end as wlan_charge_rate\n" + 
											"from Nmk.mbuser_acctitem_threemonth_201405 a \n";
									}else if(subjectid=='12924'){
										sql = "select MBUSER_ID, substr(ACC_NBR,1,3)||'xxxxxxx' as ACC_NBR, MCUST_LID, MCUST_FLAG, BRAND_ID, CREDIT_CHARGE,\n" +
											"    PROMOTE_COMPLAIN_NUM, AGAIN_COMPLAIN_NUM, BASIC_COMP, INFO_COMP, BUSI_COMP\n" + 
											"    , BILL_COMP, MNET_COMP, OWN_BUSI_COMP, MARKET_COMP, SERVICE_COMP, ENT_COMP\n" + 
											"    , V_12580_COMP, TERM_COMP, CREDIT_LEVE\n" + 
											"  from NWH.NG3_MBUSER_CREDIT_LEVE_201405 a \n";
									}else if(subjectid=='12926'){
										sql = 
											"select substr(ACC_NBR,1,3)||'xxxxxxx' as col_alias_0,\n" +
											"decimal(CALL_DURA/60,16,2) as col_alias_1,\n" + 
											"decimal(CALLED_DURA/60,16,2) as col_alias_2,\n" + 
											"CALL_TIMES as col_alias_3,\n" + 
											"CALLED_TIMES as col_alias_4,\n" + 
											"SMS_TIMES as col_alias_5,\n" + 
											"CALL_WORKTIME_TIMES as col_alias_6,\n" + 
											"CALL_NIGHTTIME_TIMES as col_alias_7,\n" + 
											"RUSER_CHARGE, IS_CALL, IS_SMS,\n" + 
											"IS_WORK\n" + 
											"  from NWH.NG_RUSER_SUB_INFO_201302 a \n";											
									}
									if(count!='0'){
										sql += " inner join NMK.SUBJECT_ACC_NBR b on a.acc_nbr = b.acc_nbr ";
									}
									if(subjectid=='12926'){
											"where CALL_DURA > 0 or CALLED_DURA > 0 \n";
									}else{
											sql += " where 1=1";
									}									
									if($("channel_code").value != null && $("channel_code").value != "") {
										sql += " and subStr(channel_code,1,5) = '"+$("channel_code").value+"'";
									}
									if($("acc_nbr").value != null && $("acc_nbr").value != "") {
										sql += " a.and acc_nbr = '"+$("acc_nbr").value+"'";
									}
									return sql;
								};
								function query(){
									var _header;
									var subjectid = $("subjectid").value;
									if(subjectid=='' || subjectid==null){
										alert("请先选择报表再查询！");
										return;
									}else if(subjectid=='12917'){
										_header = _header1;
									}else if(subjectid=='12918'){
										_header = _header2;
									}else if(subjectid=='12919'){
										_header = _header3;
									}else if(subjectid=='12920'){
										_header = _header4;
									}else if(subjectid=='12921'){
										_header = _header5;
									}else if(subjectid=='12922'){
										_header = _header6;
									}else if(subjectid=='12924'){
										_header = _header7;
									}else if(subjectid=='12926'){
										_header = _header8;
									}
									var grid = new aihb.AjaxGrid({
										header:_header
										,ds:"nl"
										,isCached : false
										,sql: genSQL()
									});
									grid.run();
								};
								function down(){
									var _header;
									var subjectid = $("subjectid").value;
									if(subjectid=='' || subjectid==null){
										alert("请先选择报表再下载！");
										return;
									}else if(subjectid=='12917'){
										_header = _header1;
									}else if(subjectid=='12918'){
										_header = _header2;
									}else if(subjectid=='12919'){
										_header = _header3;
									}else if(subjectid=='12920'){
										_header = _header4;
									}else if(subjectid=='12921'){
										_header = _header5;
									}else if(subjectid=='12922'){
										_header = _header6;
									}else if(subjectid=='12924'){
										_header = _header7;
									}else if(subjectid=='12926'){
										_header = _header8;
									}
									aihb.AjaxHelper.down({
										sql : genSQL()
										,header : _header
										,ds:"nl"
										,isCached : false
										,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
										,form : document.tempForm
									});
								};
								window.onload=function(){
									aihb.Util.loadmask();
									showPanel();
									$("queryBtn").onclick = query;
									$("downBtn").onclick = down;
								};								
			}(window,document);
		</script>
	</body>
</html>