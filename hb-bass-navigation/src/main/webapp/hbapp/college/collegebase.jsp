<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="bass.common.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 欲增加到回复和查看论坛的链接，在用户在服务器端状态的问题上出了问题
  090902:在用户提交修改记录后，欲在_hist表中增加操作类型：如，修改或新增
  在用户提交修改记录时，在nwh.bureau_cfg_base和nwh.bureau_cfg中加入相关信息。
  090903:修改查询sql
  090904:修改sql,仅修改state_date>to_date为state_date>=to_date；另修正了state_date的一个bug
   --%>
    <title>高校基础信息统一视图</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js" charset="utf-8"></script>
	<script type="text/javascript" src="default.js" charset="utf-8"></script>
	<script type="text/javascript" src="${mvcPath}/hbbass/ngbass/js/common.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/salesmanager/feedback/dim_conf.js" charset="utf-8"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
  	<style type="text/css">
  		#maskScreen {
		    position:absolute;
		    z-index: 9998;
		    top: 0px;
		    left: 0px;
		    background: #000000;
		    display: none;
		    filter: alpha(Opacity=30);
		    -moz-opacity:0.30; 
		}
		#maskMessage {
		    position: absolute;
		    z-index: 9999;
		    display: none;
		}
		
		input[disabled],input:disabled{
			color: #a0a0a0;
		}
  	</style>
  </head>
  <script type="text/javascript">
<% 
  	if(request.getAttribute("message") != null) {
		//不是第一次进入了
		if("success".equals((String)request.getAttribute("message")))
			out.print("alert('添加成功!');");
		else
			out.print("alert('添加失败!');");
  	}
%>
 	//改居中了cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_text";
	//全局变量的作用真是不小
	queryTime = "";
	cellfunc[0] = function(datas,options) {
		return "<input type='checkbox' onchange='setDisable(this)'>";
	}
	cellfunc[1] = function(datas,options) {
		return citycode[datas[options.seq]];
	}
	//详细
	cellfunc[4]=function(datas,options)
	{	
		var returnVal = "<a href='#' onclick='add(\"" + datas[2] + "\",\"" + datas[2] +"\",\"detailmain.htm?queryTime=" + queryTime + "&college_id=" + datas[3] + "\")'><img src='${mvcPath}/hbapp/resources/image/default/more.gif' border=0>详细</a>";
		return returnVal;
	};
	//修改
	cellfunc[5]=function(datas,options)
	{	
		//加修改二字，主要是和上面的详细保持不一样，这样不会有同时打开时的冲突.
		//090902新增area_name,以便后台操作数据库
		//20100729 取消所有人修改权限,待确定一些能够修改的id 
		//return "<a href='#' onclick='add(\"" + datas[2] + "修改\",\"" + datas[2] +"\",\"modifymain.htm?area_name=" + citycode[datas[1]] + "&queryTime=" + queryTime + "&college_id=" + datas[3] + "\")'>修改</a>";
		return "";
	};

	function doSubmit2() {
		var queryDate = "";
		if(document.forms[0].dateType.checked) {
			//按月查
			queryTime = document.forms[0].month.value;
			var year = queryTime.substr(0,4);
			var month = queryTime.substr(4,2);
			queryDate = year + "" + month;//没有-,也没有to_date()函数
			condition = " where collegemonthparam0 <= " + queryDate + " and (state=1  or (state =0 and collegemonthparam1 >=" + queryDate + "))";
		} else {
			queryTime = document.forms[0].date.value;
			var year = queryTime.substr(0,4);
			var month = queryTime.substr(4,2);
			var day = queryTime.substr(6,2);
			//alert("year : " + year + " :::   month " + month + " ;;; day " + day);
			queryDate=year + "-" +month + "-" + day ;
			//alert("queryDate :" + queryDate);
			condition = " where eff_date<= '" + queryDate + " 23:59:59" + "' and (state=1  or (state =0 and state_date>='" + queryDate + " 00:00:00" + "'))";
		}
		
		/*TO_DATE('2006-08-18 00:00:00','yyyy-mm-dd hh24:mi:ss')*/
		
		if(document.forms[0].city.value !="0")	condition += " and area_id='" + document.forms[0].city.value + "'";
		if(document.forms[0].college_name_given.value != "支持模糊查询") condition += " and college_name like'%" + document.forms[0].college_name_given.value + "%'";
		//alert(condition);
		//var sql = "select area_id,college_name ,college_id,'','' from NWH.COLLEGE_INFO " + condition;
		/* new sql(by dongyong)
		select * from nwh.college_info where eff_date<= &TASK_ID and (state=1  or (state =0 and state_date>&TASK_ID))
		*/
		var sql = "select '',area_id,college_name ,college_id,'','' from NWH.COLLEGE_INFO " + condition;
		
		document.forms[0].sql.value = sql;
		ajaxSubmitWrapper(sql+ " with ur");
	}
	
	function setDateType(checkBoxObj) {
		var monthDiv = document.getElementById("monthDiv");
		var dateDiv = document.getElementById("dateDiv");
		if(checkBoxObj.checked) {
			dateDiv.style.display = "none";
			monthDiv.style.display = "block";
		}
		else {
			dateDiv.style.display = "block";
			monthDiv.style.display = "none";
		}
	}

function areacombo(i,sync)
{
	//alert("areacombo in");
	selects = new Array();
	//数组的进出栈操作
	selects.push(document.forms[0].city);
	sqls = new Array();
	
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

  </script>
  <script type="text/javascript" defer="defer">
	function checkBlur() {
		var oInput = document.getElementById("college_name_given");
		if(oInput.value == "") {
			oInput.value="支持模糊查询";
			oInput.style.color = "gray";
			oInput.style.fontStyle = "italic";
		}
	}
	function checkFocus(sId) {
		var oInput = document.getElementById(sId);
		//有一点小问题，对于网址，不应该每次onfocus的时候都清空
		oInput.value="";//清空文本
		oInput.style.color = "black";
		oInput.style.fontStyle = "normal";
		
	}
	function showForumReply() {
	
	var url = "http://localhost:8889/bbscs8/post.bbscs?action=re&bid=46&parentID=8a99157a2373badd0123749f4b370013&mainID=8a99157a2373badd0123749f4b370013&fcpage=1&totalnum=1&tagId=0";
		var newPage = window.open(url,"reply","toolbar=no");//不要工具栏
		if(!newPage) {
			//被浏览器阻拦
			alert("系统无法打开窗口，请检查浏览器设置。");
			return;
		}
	}
	function showForumView() {
	//问题，如果用户还没登录过，怎么办？
		var url = "http://localhost:8889/bbscs8/read.bbscs?action=topic&id=8a99157a2373badd0123749f4b370013&bid=46&fcpage=1&fcaction=index&tagId=0";
		var url_new = "http://localhost:8889/bbscs8/main.bbscs?action=read&bid=46&postID=8a99157a2373badd0123749f4b370013";
		var newPage = window.open(url_new,"view","toolbar=no");//不要工具栏
		if(!newPage) {
			//被浏览器阻拦
			alert("系统无法打开窗口，请检查浏览器设置。");
		}
	}
	//moved
	function areaChanged() {
		/* debugger; */
		var theSrc;
		if(window.event)
			theSrc = window.event.srcElement;
		//刚加载是selectObj的value为undefined
		if(theSrc && theSrc.value && theSrc.value != '0') {
		//从db2array.jsp中找到，这里的ds应该是am,不对，am代表的数据库并不是jdbc/JDBC_HB,传null试试
		//感觉这个方法有问题！
			var sql = "select max(college_id) from nwh.college_info where area_id='" + theSrc.value + "'";
			//alert(sql  + "\n感觉有点问题" );
			ajaxGetListWrapper(sql,callback,undefined,undefined,null);
		}
	}
	function callback(list) {
		//取到最后一个字符
		var str = String(list[0]);//不知道为什么，不是String对象
		//取最后的数字部分，四位小数
		var patten = /[0-9]{4}$/;
		var nums = str.match(patten);
		nums = Number(nums);//转数字
		nums = nums + 1;
		nums = doNums(nums);
		//alert("generated nums : " + nums);
		str = str.replace(patten,nums);
		//alert("generated str : " + str);
		//document.getElementById("college_id").value = str;
		document.getElementById("collegeId").value = str;
	}
	function doNums(nums){
		nums = String(nums);//先转成字符串
		switch(nums.length) {
			case 1:nums = "000" + nums;return nums;break;
			case 2:nums = "00" + nums;return nums;break;
			case 3:nums = "0" + nums;return nums;break;
			case 4:return nums;break;// 这里是不是写错了? 应该是case 4才对
			default:return nums;break;
		}
	}
	//提交前验证
	function check() {
		if(confirm("确认要提交吗？")) {
		} else return;
		//第二个条件防止undefined
		if(document.getElementById("collegeId").value=="请先选择地市" || !document.getElementById("collegeId").value) {
			alert("没有生成高校编码，无法提交。请选择地市。");
			return;
		}
		if(document.getElementById("collegeName").value=="" ||document.getElementById("collegeName").value.trim().length == 0) {
			alert("高校名称不能为空,请修改。");
			return ;
		}
		document.forms[1].submit();
	}
	
	function init(){
		var now=new Date();
		now.setMonth(now.getMonth()-1);
		var month = now.format("yyyymm");
		document.getElementById("month").value=month;
		
		var nowd=new Date();
		nowd.setDate(nowd.getDate()-1);
		var date = nowd.format("yyyymmdd");
		document.getElementById("date").value=date;
		
		doSubmit2();
	}
  </script>
  <body onload="init()">
  <div id="maskScreen"></div>
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
					<td class="dim_cell_title">统计日期
					<input name="dateType" id="dateType" type="checkbox" onchange="setDateType(this)">按月查
					</td>
						<td class="dim_cell_content">
						<div id="dateDiv">
							<input align="right" type="text" id="date" name="date" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
						</div>
						<div id="monthDiv" style="display:none">
							<input align="right" type="text" id="month" name="month" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
						</div>
						</td>
						
						<td class="dim_cell_title">地市</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),null)%>
						</td>
						<td class="dim_cell_title">高校名称</td>
						<td class="dim_cell_content" colspan="5"><input type="text" name="college_name_given" id="college_name_given" value="支持模糊查询" style="color:gray; font-style: italic;" onblur="checkBlur()" onfocus="checkFocus(this.id)"></td>
				</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
					<td align="left">
						<input type="button" class="form_button" value="新增" onclick="document.getElementById('feedback_div').style.display='';">&nbsp;
						<input type="button" id="fillBox" class="form_button" title="批量录入功能" value="附属信息录入" disabled="disabled" onclick="fillBoxFunc()">&nbsp;
					</td>
						<td align="right">
						<%-- 
							<input type="button" class="form_button" value="浏览论坛" onclick="showForumView()"/>&nbsp;
							<input type="button" class="form_button" value="用户反馈" onclick="showForumReply()"/>&nbsp;
							--%>
							<input type="button" class="form_button" value="查询" onclick="doSubmit2()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown()"/>&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
	</form><%-- 因为下面的原因，这里的form提前了 --%>
	
	<%-- 新增功能 --%>
	<div id="feedback_div" style="display:none;">
	<div style="width:100%;height:200%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='${mvcPath}/hbbass/common2/image/tab-close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
		<form action="updatecollege.jsp" method="get" enctype="multipart/form-data">
		<input type="hidden" value="insert" name="type"/>
		<center>
		<span style="text-align :center;font-size : 16pt">高校信息录入</span>
		</center>
	
		<table width="99%">
			<tr>
				<td>高校编码</td>
				<td><input type="text" id="collegeId" name="collegeId" title="编码由系统生成，不可修改。" style="color:gray; font-style: italic;" value="请先选择地市" readonly="readonly"></td>
				<td><span style="color:red">*</span>高校名称</td>
				<td><input type="text" name="collegeName" id="collegeName" value=""></td>
			</tr>
			<tr>
				<td>网址</td>
				<td><input type="text" id="web_add" name="webAdd" value="eg:http://www.sust.edu.cn" style="color:gray; font-style: italic;" onfocus="checkFocus(this.id)"></td>
					<td>高校类型</td>
				<td><input type="text" name="collegeType" id="college_type" value="eg:研究型" style="color:gray; font-style: italic;" onfocus="checkFocus(this.id)" ></td>
			</tr>
				
			<tr>
				<td>高效地址</td>
				<td><input type="text" name="collegeAdd" value="" ></td>
					<td>V网短号码</td>
				<td><input type="text" name="shortNum" value="" ></td>
			</tr>
				<tr>
				<td>
					<span style="color:red">*</span>
					所属地市
				</td>
				<td>
					<%=bass.common.QueryTools2.getAreaCodeHtml("areaId",(String)session.getAttribute("area_id"),"areaChanged()")%>
				</td>
				<td>高校片区经理</td>
				<td><input type="text" name="manager" value="" ></td>
			</tr>
			<tr>
				<td>学生人数</td>
				<td><input type="text" name="studentsNnum" value="" ></td>
					<td>本年度招生人数</td>
				<td><input type="text" name="newStudents" value="" ></td>
			</tr>
			<tr>
				<td colspan="4" align="right"><span style="color: red">*</span>为必填项</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="提交" onclick="check()" name="from2_submit"/>
				<input type="reset" value="重置" />
				</td>
			</tr>
	 	</table>
	 	</form>
	</div>
	</div>  
		<%-- /新增功能 --%>
		
		<%-- 新增功能2 --%>
		<%-- 
			<div id="feedback_div2" style="display:none;">
				<div id="loading">
					
				</div>
				<div style="width: 800; height: 480; padding: 10px 10px 10px 30px">
					<iframe id="fillframe" frameborder="0" src="" width="800" height="480"></iframe>
				</div>
			</div>
		--%>
		
		<div id="maskMessage" style="text-align: center;border:#00BFFF solid 1px; background:#D9ECF6; width:400px; height:100px">
			<img style="vertical-align: middle;margin-top: 20px;margin-bottom: 10px" src="${mvcPath}/hbbass/images/loading.gif"/><br>
			<span>处理中,请稍后......</span>
		</div>
			<div id="frameDiv1" style="display: none;width: 800; height: 480; padding: 10px 10px 10px 30px">
				<iframe id="fillframe" frameborder="0" src="" width="800" height="480"></iframe>
			</div>
		
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
				<%-- 此处有可能显示有可能隐藏，完全取决与fecth first n rows 中n的值 --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 <%-- 表头变化部分 --%>
					<td width="" class="grid_title_cell"><input type="button" onclick="funcTest(this)" value="全选" /></td>
				  	<td width="" class="grid_title_cell">地市</td>
				  	<td width="" class="grid_title_cell">高校名称</td>
				 	<td width="" class="grid_title_cell">高校编码</td>
				 	<td width="" class="grid_title_cell">详细</td>
				 	<td width="" class="grid_title_cell">基本信息修改</td>
				 
				 </tr>
			</table>
		</div>			
		<script type="text/javascript">
			var needChecked = true;
			function funcTest(obj){
				while(obj.tagName != 'TABLE')
					obj = obj.parentNode;
				
				for(var j=0; j<obj.childNodes.length; j++){
					if(obj.childNodes[j].nodeName== '#text'){
						obj.removeChild(obj.childNodes[j]);
					}
				}
				
				var tBody = obj.childNodes[1];
				for(var i = 0 ; i < tBody.childNodes.length; i ++) {
					var ckBox = tBody.childNodes[i].firstChild.firstChild;
					ckBox.checked = needChecked;
				}
				needChecked = !needChecked;
				if(needChecked)
					document.getElementById("fillBox").disabled = true;
				else
					document.getElementById("fillBox").disabled = false;
			}
			function setDisable(obj) {
				var needDisabled = true;
				while(obj.tagName != 'TABLE')
					obj = obj.parentNode;
				
				for(var j=0; j<obj.childNodes.length; j++){
					if(obj.childNodes[j].nodeName== '#text'){
						obj.removeChild(obj.childNodes[j]);
					}
				}
				
				var trows = obj.childNodes[1].childNodes;
				/* debugger; */
				for(var i = 0 ; i < trows.length; i ++) {
					
					var ckBox = trows[i].firstChild.firstChild;
					if(ckBox.checked)
						needDisabled = false;	
				}
				if(needDisabled)document.getElementById("fillBox").disabled = true;
				else document.getElementById("fillBox").disabled = false;
			}
			function fillBoxFunc() {
				var src = "fillBox.jsp";
				var ids = "";
				var obj = document.getElementById('resultTableDown');
				var trows = obj.childNodes[1].childNodes;
				
				for(var i = 0 ; i < trows.length; i ++) {
					var ckBox = trows[i].firstChild.firstChild;
					//debugger;
					if(ckBox.checked) {
						ids += trows[i].childNodes[3].innerText + ",";
						/* debugger; */
					}
				}
				src += "?ids=" + ids;
				var fillframe = document.getElementById("fillframe");
				fillframe.src = src;
				//document.getElementById('feedback_div2').style.display='';
				maskScreen();
				
				if (fillframe.attachEvent){
					fillframe.attachEvent("onload", function(){
						var frmDiv = document.getElementById("frameDiv1");
						if(frmDiv.style.display=="none") {
							unMaskScreen();
							frmDiv.style.display = "block";
						} else if(frmDiv.style.display == "" || frmDiv.style.display == "block") {
							unMaskScreen();
							frmDiv.style.display = "none";
						}
					});
				} else {
					fillframe.onload = function(){
						var frmDiv = document.getElementById("frameDiv1");
						if(frmDiv.style.display=="none") {
							unMaskScreen();
							frmDiv.style.display = "block";
						} else if(frmDiv.style.display == "" || frmDiv.style.display == "block") {
							unMaskScreen();
							frmDiv.style.display = "none";
						}
					};
				} 
				
			}
		</script>
	
				<%-- 	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div class="portlet">
		    	<div class="title" >
		    		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    		<tr>
		    		<td>表格展现</td>
		    		</tr>
		    		</table>
		    	</div>
		    	<div id="grid" class="content">
		    		<div id="showSum"></div>
		    		<div id="showResult"></div>
			    	
			    	<div id="title_div" style="display:none;">
		            	<table id="resultTable" align="center" width="97%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
							<tr class="grid_title_blue">
							   <td class="grid_title_cell">营业网点编码</td>
							   <td class="grid_title_cell">营业网点名称</td>
							   <td class="grid_title_cell">归属地市</td>
							   <td class="grid_title_cell">归属县市</td>
							   <td class="grid_title_cell">区域营销中心</td>
							   <td class="grid_title_cell">渠道状态</td>
							   <td class="grid_title_cell">渠道星级</td>
							   <td class="grid_title_cell">详细</td>
							</tr>
						</table>
					</div>
	        	</div>
        	</div> 
	    </td>
	  </tr>
	</table>
	--%>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  
  </body>
</html>
