<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	80 percent
  --%>
    <title>修改页面</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <%
 	String oper = request.getParameter("oper");
 	String o_channellevel = request.getParameter("o_channellevel");
 	String staff_id = (String)session.getAttribute("loginname");
 	String channel_code = request.getParameter("channel_code");
 	log.debug("oper : " + oper + ";;; o_channellevel : " + o_channellevel + ";;; staff_id : " + staff_id + ";;;channel_code : " + channel_code);
 %>
 <script type="text/javascript">
 	//cellclass[0]="grid_row_cell_text";
	//cellclass[1]="grid_row_cell_number";
	//cellclass[2]="grid_row_cell_number";
	//cellclass[3]="grid_row_cell_number";
	
	//cellfunc[1] = numberFormatDigit2;
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	cellfunc[4] = function(datas,options) {
		return datas[options.seq].substr(0,19);//done
	}
	function doSubmit()
	{	
		var condition = " where channel_code='<%=channel_code%>'";
		var tableName = "nmk.ai_channel_sum_hist";
		constantPart = "o_channel_level,channel_level,change_reason,change_staff,changes_date,eff_date ";
		sql = "select " + constantPart + " from " + tableName + condition;
	 	countSql = "select count(*) from " + tableName + condition;
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",countSql);
	} 

	function catchEvent(eventObj, event, eventHandler) {
		if (eventObj.addEventListener) {
			eventObj.addEventListener(event, eventHandler,false);
		}
		 else if (eventObj.attachEvent) {
			event = "on" + event;
			eventObj.attachEvent(event, eventHandler);
		}
	}
	function setupEvents() {
		doSubmit();
	}
	catchEvent(window,"load",setupEvents);
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
	function checkInput() {
		with(document.forms[0]) {
			if(change_reason.value.trim() && channel_level.value.trim())
				ajaxExtSubmit();
			else
				Ext.Msg.alert("提示","请输入完整的信息");
		}
	}
	function ajaxExtSubmit(){
		Ext.Ajax.request({
			url: 'updatemodel.jsp',
			params: {
				channel_code: document.forms[0].channel_code.value,
				o_channellevel: document.forms[0].o_channellevel.value,
				channel_level: document.forms[0].channel_level.value,
				change_staff: '<%=staff_id%>',
				change_reason: document.forms[0].change_reason.value
			},
			success: function(response, options) { 
	            //获取响应的json字符串 
	            var responseArray = Ext.util.JSON.decode(response.responseText); 
	            if (responseArray.success == true) {
	           		Ext.Msg.alert('成功','设置成功!'); 
	           		doSubmit();
	            } 
	                
	            else {
	            	 Ext.Msg.alert('失败', responseArray.errorInfo); 
	            	doSubmit();
	            }
	               
			},
			failure: function() {Ext.Msg.alert("提示","设置失败！请联系管理员.");}
		});
	}
	String.prototype.trim=function(){      
   	 	return this.replace(/(^\s*)|(\s*$)/g, '');   
	} 
  </script>
  <body>
  <form action="" method="post">
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;录入区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<%-- 
						insert into "NMK"."AI_CHANNEL_SUM_HIST" (CHANNEL_CODE,"O_CHANNEL_LEVEL", "CHANNEL_LEVEL","CHANGE_REASON", "CHANGE_STAFF",eff_date)
					values('HB.HS.03.02.16','2','1','for test only','testid','2009-12-29')
					--%>
						<tr class="dim_row">
						<td class="dim_cell_title">渠道编码</td>
						<td class="dim_cell_content" colspan="5">
							<input disabled="disabled" type="text" id="channel_code" name="channel_code" value="<%=channel_code %>"/>
						</td>
						<td class="dim_cell_title">渠道等级</td>
						<td class="dim_cell_content" colspan="5">
							<%-- 
								<input type="text" id=channel_level name="channel_level"/>
							--%>
							<select name="channel_level" id="channel_level">
								<option value="1">一星级</option>
								<option value="2">二星级</option>
								<option value="3">三星级</option>
								<option value="4">四星级</option>
							</select>
							<input type="hidden" id="o_channellevel" name="o_channellevel" value="<%=o_channellevel %>"/>
							<input type="hidden" id="change_staff" name="change_staff" value="<%=staff_id %>"/>
						</td>
						<td class="dim_cell_title">变更原因</td>
						<td class="dim_cell_content" colspan="5">
							<textarea rows="1" cols="20" id="change_reason" name="change_reason"></textarea>
						</td>
						</tr>
						<tr class="dim_row">
							
						</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="<%="add".equals(oper)?"增加":("modify".equals(oper)? "修改":"操作") %>" onclick="checkInput()">&nbsp;
							<%-- 
							<input type="button" class="form_button" value="下载" onclick="toDown(1)">&nbsp;
							--%>
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
	</form>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;操作历史记录：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>修改前渠道星级</td>
				 	<td class='grid_title_cell'>修改后渠道星级</td>
				 	<td class='grid_title_cell'>修改原因</td>
				 	<td class='grid_title_cell'>修改人员</td>
				 	<td class='grid_title_cell'>修改日期</td>
				 	<td class='grid_title_cell'>生效日期</td>
				 
				 </tr>
			</table>
		</div>			

  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
