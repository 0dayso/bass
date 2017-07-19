<%@ page language="java" import="com.asiainfo.hb.web.models.User,java.util.*" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");
String areaId = user.getRegionId();
if(areaId.length()>5){
	areaId=areaId.substring(0,5);
}
System.out.println("loginname="+user.getId()+"   areaId="+areaId);
%>
<html xmlns:ai>
<HEAD>
<TITLE>湖北移动经营分析系统</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js" charset=utf-8></script>
<script type="text/javascript">
//	var _params = aihb.Util.paramsObj();
var task_id = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
	function showPanel() {
		var vault = new dhtmlXVaultObject();
	    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
	    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
	    vault.setFilesLimit(1);
	   	vault.create("uploadDiv");
	   	
	   	vault.setFormField("tableName", "COMPETE_OPPSTATE_UPLOAD");
    	vault.setFormField("columns", "task_id,OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE");
    	vault.setFormField("date", task_id);  
    	
    	vault.onFileUpload=function(){
    		loadmask.style.display="";
    		return true;
    	}
    	
    	vault.onUploadComplete = function(files) {
    		this.removeAllItems();
    		debugger
    		var sql=encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='成功' where task_id='" + task_id + "'");	
    	sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='策反号码相同' where task_id='" + task_id + "' and OPP_NBR in (select OPP_NBR from COMPETE_OPPSTATE )");
    	sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='导入策反号码相同' where opp_nbr in (select opp_nbr from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "' group by opp_nbr having count(*)>1)");
    	sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='导入移动号码相同' where ACC_NBR in (select ACC_NBR from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "' group by ACC_NBR having count(*)>1)");
			sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='移动号码相同' where task_id='" + task_id + "' and ACC_NBR in (select distinct ACC_NBR from COMPETE_OPPSTATE )");
			sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='移动号码位数不对' where task_id='" + task_id + "' and length(acc_nbr)!=11 ");
			sql += "&sqls="+encodeURIComponent("update COMPETE_OPPSTATE_UPLOAD set flag='策反号码位数不对' where task_id='" + task_id + "' and length(OPP_NBR)>11 ");
			
			sql += "&sqls=" + encodeURIComponent("insert into COMPETE_OPPSTATE (OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,STATE,INSERTMAN,city_id) select distinct OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,date(DATE),'1','<%=user.getId()%>','<%=areaId%>' from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "' and flag='成功'");
			sql += "&sqls=" + encodeURIComponent("delete from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "' and flag='成功'");
			
			var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/sqlExec"
			,parameters : "sqls="+sql
			,loadmask : false
			,callback : function(xmlrequest){
				alert("导入完成,请查看未导入成功号码");
				loadmask.style.display="none";
			}
		});
			ajax.request();
			location.refresh();
    	}
	}
	var _header= [
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"opp_nbr",
		          		"name":["策反号码"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"acc_nbr",
		          		"name":["移动号码"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"name",
		          		"name":["客户经理姓名"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"manager_id",
		          		"name":["客户经理ID"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"area",
		          		"name":["客户经理归属县域"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"police",
		          		"name":["回流政策"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"date",
		          		"name":["策反日期"],
		          		"title":"",
		          		"cellFunc":""
		          	},
		          	{
		          		"cellStyle":"grid_row_cell_text",
		          		"dataIndex":"flag",
		          		"name":["不成功原因"],
		          		"title":"",
		          		"cellFunc":""
		          	}
		          	];
		//aihb.Util.loadmask();
		function query(){
			var grid = new aihb.AjaxGrid({
				header:_header
				,sql: "select OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE,flag from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "'"
				,isCached : false
				,callback:function(){
					aihb.Util.watermark();
				}
			});
			grid.run();
		}

		function down(){
			aihb.AjaxHelper.down({
				sql : "select OPP_NBR,ACC_NBR,NAME,MANAGER_ID,AREA,POLICE,DATE from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "'"
				,header : _header
				,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
				,form : document.tempForm
			});
		}

		function _delete() {
			if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
				return;
			var _params = aihb.Util.paramsObj();
			var sql=encodeURIComponent("delete from COMPETE_OPPSTATE_UPLOAD where task_id='" + task_id + "'");
			var ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/sqlExec"
				,parameters : "sqls="+sql
				,loadmask : false
				,callback : function(xmlrequest){
					var result = eval("(" + xmlrequest.responseText + ")");
					alert(result.message);
					query();
				}
			});
			ajax.request();
		}
		window.onload=function(){
			aihb.Util.loadmask();
			showPanel();
			/*
			$("failNum").onclick=function(){
	 			tabAdd({title:'未导入成功号码',url:"uploadinfo.html?"})
	 		}
			*/
			//$("failNum").onclick=query;
		}
</script>
</head>                                                                                                                                                                                                                                                                                                             
<body>
<form name="tempForm" action=""></form>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
	</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div>
 		<input type="button" class="form_button" value="未导入成功" onclick="query()">&nbsp;
        <input type="button" class="form_button" value="下载数据" onclick="down()">&nbsp;
        <input type="button" class="form_button" value="删除非法数据" onClick="_delete()">&nbsp;
        </td>       
		<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbbass/common/FileDown.jsp?filename=sample.xls&filepath=${mvcPath}/hbbass/salesmanager/feedback/"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请右键点击“目标另存为”下载</font>
        	<div>导入说明：</div>
	<div>1.导入文件中不能有重复的记录(相同的策反号码和移动号码)；</div>
	<div>2.同一个移动号码不能对应多个策反号码；同一个策反号码也不能对应多个移动号码；</div>
	<div>3.导入的记录不能与已导入的历史记录相同（根据移动号码和策反号码校验）；</div>
	<div>4.导入的文件中不要留空白行和列；</div>
	<div>5.本程序将做基于上述规则的自动验证，只有符合要求的记录才能被导入。</div>
	<div style="color : red">6.上传之后自动跳转到展示“本次未成功导入的记录”的页面，如未显示任何记录，代表本次上传的所有记录均符合要求。</div>
        	<td> 
      </tr>
   </table>
</fieldset>
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
</body>
</html>
