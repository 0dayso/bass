<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-十项业务导入</TITLE>
<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/datepicker/WdatePicker.js" charset=utf-8></script>  
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />

</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>数据导入</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top">
          <a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=import&fileName=十项业务导入.xls">
            <font color=blue><b>导入数据模板(Excel)</b></font>
          </a>&nbsp;
          <font color="red">请单击或右键点击“目标另存为”下载</font> &nbsp;&nbsp;&nbsp;
        	<div>导入说明：</div>
	        <div>1.前台开发一张报表，能够按月份查询数据, 按月，可选项为201206、201207，以此类推；</div>
	        <div>2.前台开发导入功能，导入功能有时间限制，允许在每月1~10号进行导入，导入数据量将近1万条数据；</div>
	        <div>3.前台提供导入按钮说明，每次全量导入，在导入过程中自动删除当月前一次导入数据；</div>
	        <div>4.业务类型对应关系：A1001：手机阅读  A1002：手机游戏  A1003：手机视频  A1004：手机导航  A1005：MDO卓望  A1006：手机报  </div>
	        <div>&nbsp;&nbsp;A1007：无线音乐  A1008：手机电视  A1009：手机彩铃</div>
        <td>
      </tr>
   </table>
</fieldset>

<!--
<form method="post" action=""><br>

<div id="condi2">
  <table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
    <tr class='dim_row'>
      <td class='dim_cell_title' id="times_start" >统计周期:</td>
      <td class='dim_cell_content'> 
         <input type="text" id="date" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" size="12"/>
      </td>
       
      <td class='dim_cell_title'>业务类型</td>
      <td class='dim_cell_content'>
      <select name="type_id" class='form_select' id="type_id">
        <option value="">全部</option>
        <option value="A1001">手机阅读</option><option value="A1002">手机游戏</option>
        <option value="A1003">手机视频</option><option value="A1004">手机导航</option>
        <option value="A1005">MDO卓望</option><option value="A1006">手机报</option>
        <option value="A1007">无线音乐</option><option value="A1008">手机电视</option>
        <option value="A1009">手机炫铃</option>
      </select> 
      </td>
      
      <td class='dim_cell_title'>操作</td>
      <td class='dim_cell_content'>
        <div style="text-align: right; text-align: center">
          <input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
        </div>
      </td>
    </tr>
  </table>
</div>

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
--> 
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
      
      var tempDate = new Date();
      tempDate.setMonth(tempDate.getMonth() - 1);//上个月的
      var _date = tempDate.format("yyyymm");
      
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
				
				vault.enableAddButton(function(time){
					/*
					if(time.getHours() >  9 &&
					   ((time.getMonth()+1) >= 7 && time.getDate() >= 15) &&
					   ((time.getMonth()+1) <= 9 && time.getDate() <= 30)
					)
					*/
					if(time.getDate() <= 10){
						return true;
          }else {
						alert("当前时间禁止导入，导入时间必须为每月1号到10号之间");
						//$("delTodayBtn").disabled=true;
						return false;
					}
					
				}(new Date()));
			   	vault.setFormField("tableName", "nwh.user_deca_operation");
		    	vault.setFormField("columns", "time_id,acc_nbr,type_id");
		    	vault.setFormField("date", _date);  
	    	
		    	vault.onUploadComplete = function(files) {
            alert("导入完成,请查询本次导入结果!");
            loadmask.style.display="none";
            //query();
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"time_id",
					"name":["统计周期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjyd",
					"name":["手机阅读"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjyx",
					"name":["手机游戏"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjsp",
					"name":["手机视频"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjdh",
					"name":["手机导航"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"mdo",
					"name":["MDO卓望"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjb",
					"name":["手机报"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"wxyy",
					"name":["无线音乐"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjds",
					"name":["手机电视"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"sjcl",
					"name":["手机彩铃"],
					"title":"",
					"cellFunc":""
				}
			];
		
      function getSQL() {
        var sql = "";
        var condi = " where 1=1 ";
        var date_value = $("date").value;
        if(date_value != ''){
          condi+=" and time_id = '"+date_value+"' "
        }
        sql=" select time_id,sjyd,sjyx,sjsp,sjdh,mdo,sjb,wxyy,sjds,sjcl from nwh.user_deca_operation_result  "+condi+" ";
        return sql;
      }
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: getSQL()
					,isCached : false
				});
				grid.run();
			}
			function down(){
				aihb.AjaxHelper.down({
					sql : "select  acc_nbr, area_id, college_id from college_jiajika_import_temp where taskid='" + taskId + "'"
					,header : _header
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
		
      //时间初始化
      function defult_date(){
        var now = new Date(); 
        $('date').value = now.getYear()+""+((now.getMonth())<10?"0":"")+(now.getMonth());
      }     
      
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
        //defult_date();
				$("queryBtn").onclick = query;
				//$("delBtn").onclick = _delete;
				//$("downBtn").onclick = down;
				//$("delTodayBtn").onclick = _deleteToday;
			}
		
		}(window,document);
		
	</script>
</body>
</html>