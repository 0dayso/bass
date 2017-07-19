<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%User user = (User)session.getAttribute("user");%>
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
   	<tr style="padding:5px;">
		<td width="100" align="right" >导入月份:</td>
		<td width="100">
			<input align="left" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
		</td>
	</tr>
    <tr style="padding:5px;"> 
    	<td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=无线城市导入.csv"><font color="blue"><b>数据模板(CSV)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
		<div>本导入为全省导入</div>
		<div>导入内容按照第一列地市编码，第二列手机号码</div>
		<div>每次导入会自动覆盖正式表</div>
    	<div>每次导入的内容都会进入历史表</div>
		<div></div>
		</td>
      </tr>
   </table>
</fieldset>

<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	var importDate = $("date1").value;
	var tempDate = new Date();
	var year = tempDate.getYear();
	var month = tempDate.getMonth();
	tempDate = new Date(year,month);
	tempDate.setMonth(tempDate.getMonth() - 1);//上月
	//上月
	var _date = tempDate.format("yyyymm");
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			var taskId = new Date().format("yyyymmdd") + "@" + '<%=user.getId()%>';
			var currentDate = new Date().format("yyyymm");
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			  vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			  vault.setServerHandlers("${mvcPath}/hbirs/action/csvmanage?method=importCSV", "${mvcPath}/hbirs/action/csvmanage?method=getInfoHandler", "${mvcPath}/hbirs/action/csvmanage?method=getIdHandler");
			  vault.setFilesLimit(1);
			  vault.create("uploadDiv");
	   	  vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	      }
		   	
				vault.onAddFile = function(fileName) {					
					var ext = this.getFileExtension(fileName);
					if (ext != "csv") {
						alert("本应用只支持扩展名.csv,请重新上传!");
						return false;
					}else{
            return true;
          } 
				};						
				
			   	vault.setFormField("tableName", "nmk.wxcs_accnbr_temp");
		    	vault.setFormField("columns", "taskid ,acc_nbr");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
		    		//查询临时表有多少条合法记录待此次导入
						var _sql = "select count(*) cnt from NMK.WXCS_ACCNBR_TEMP where taskid='" + taskId + "' ";
						var _ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/jsondata?method=query"
							,parameters : "sql="+encodeURIComponent(_sql)+"&isCached=false"
							,loadmask : true
							,callback : function(xmlrequest){
								try{
									var result = xmlrequest.responseText;
									result = eval(result);
									//如果导入数为空，则导入失败
									if(!result || !result[0].cnt){
										alert("导入失败，请查询数据是否正确");
										return;
									}else{
										alert("有"+result[0].cnt+"条记录将导入正式表");
									}
									if(confirm("您确定要将这批数据入库吗?")){
                    //删除正式表对应地市数据
                    var sql = encodeURIComponent(" drop table nmk.wxcs_accnbr_"+importDate);
                    sql +="&sqls="+ encodeURIComponent("CREATE TABLE NMK.WXCS_ACCNBR_"+importDate+"(ACC_NBR  VARCHAR(32)) IN BAS_CDR PARTITIONING KEY (ACC_NBR) USING HASHING");
                    //插入对应地市数据
                    sql +="&sqls="+ encodeURIComponent("insert into nmk.wxcs_accnbr_"+importDate+"(acc_nbr) select acc_nbr from nmk.wxcs_accnbr_temp where taskid ='" + taskId + "'");
                    var ajaxAdd = new aihb.Ajax({
											url : "${mvcPath}/hbirs/action/sqlExec"
											,parameters : "sqls="+sql+"&ds=dw"
											,loadmask : false
										})
										ajaxAdd.request();
									}
									alert("成功导入"+result[0].cnt+"条记录");
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
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				var _d=new Date();
				$("date1").value=_d.format("yyyymm");
			}		
		}(window,document);
		
	</script>
</body>
</html>