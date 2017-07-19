<%@page contentType="text/html; charset=utf-8" %>
<%@page import="bass.common.SQLSelect"%>
<%@page import="java.util.List"%>
<%@page import="java.util.regex.Pattern"%>
<html>
<%--
	如果不用java对象，这个问题比较困难。
	完全面向数据库
	js删除的和数据库删除的有可能对不上号...
	2010.01.27 : 一个bug,点击新增之后删除，count却没有--
	2010.01.28 : 客户端验证加了，一些详细的没加，比如开学时间的逻辑上的先后顺序。其实应该加上服务器端验证更好,比如名称不能和数据库中已有的相同
--%>
<head><title>高校信息录入</title>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
		<script type="text/javascript" src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbbass/ngbass/js/common.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<%-- css --%>
		<style type="text/css"> 
/* CSS Document */ 

	body { 
	    font: normal 11px auto "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif; 
	    color: #4f6b72; 
	    background: #E6EAE9; 
	} 
	
	a { 
	    color: #c75f3e; 
	} 
	
	#mytable { 
	    width: 700px; 
	    padding: 0; 
	    margin: 0; 
	} 
	
	caption { 
	    padding: 0 0 5px 0; 
	    width: 700px;      
	    font: italic 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif; 
	    text-align: right; 
	} 
	
	th,td { 
	    font: bold 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif; 
	    color: #4f6b72; 
	    border-right: 1px solid #C1DAD7; 
	    border-bottom: 1px solid #C1DAD7; 
	    border-top: 1px solid #C1DAD7; 
	    letter-spacing: 2px; 
	    text-transform: uppercase; 
	    text-align: left; 
	    padding: 6px 6px 6px 12px; 
	    background: #CAE8EA; 
	} 
	
	th.nobg { 
	    border-top: 0; 
	    border-left: 0; 
	    border-right: 1px solid #C1DAD7; 
	    background: none; 
	} 
	
	/*
	td { 
	    border-right: 1px solid #C1DAD7; 
	    border-bottom: 1px solid #C1DAD7; 
	    background: #fff; 
	    font-size:11px; 
	    padding: 6px 6px 6px 12px; 
	    color: #4f6b72; 
	} 
	*/
	
	td.alt { 
	    background: #F5FAFA; 
	    color: #797268; 
	} 
	
	th.spec { 
	    border-left: 1px solid #C1DAD7; 
	    border-top: 0; 
	    background: #fff; 
	    font: bold 10px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif; 
	} 
	
	th.specalt { 
	    border-left: 1px solid #C1DAD7; 
	    border-top: 0; 
	    background: #f5fafa; 
	    font: bold 10px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif; 
	    color: #797268; 
	} 
	/*---------for IE 5.x bug*/ 
	html>body td{ font-size:11px;} 
</style>
	
	<script type="text/javascript">

	//只适用于本报表本程序的方法，得到collegeId
	function getCollegeId(event) {
		//先得到相应的table
		var theSrc = event.srcElement||event.target;
	
		if(!theSrc)return "";
	
		while(theSrc.tagName != "TABLE")
			theSrc = theSrc.parentNode;
			
		//先得到隐藏的input
		while(theSrc.tagName != "INPUT"){
			$theSrc=$(theSrc); 
			theSrc = $theSrc.children()[0];
		}
			
		return theSrc.value;
	}
	var keyManCount = 0;
	function addKeyManInfo(event) {
		
		if(keyManCount++ >= 5) {
			alert("由于服务器负荷，每个高校每次最多添加5个。");
			keyManCount--;
			return;
		}
		var collegeId = getCollegeId(event);
		
		dynamicAdd({
			targetEl : document.getElementById("keyMan" + collegeId),
			insertType : "0",
			cellInfos : [
				{
					cellText : "关键人姓名",
					cellType : "input",
					cellName : "keyManName" + collegeId + "_" + keyManCount
				},
				{
					cellText : "职位",
					cellType : "input",
					cellName : "keyManPosition" + collegeId + "_" + keyManCount
				},
				{
					cellText : "归属部门",
					cellType : "input",
					cellName : "keyManDept" + collegeId + "_" + keyManCount
				},
				{
					cellText : "联系电话",
					cellType : "input",
					cellName : "keyManLinkNbr" + collegeId + "_" + keyManCount
				},
				{
					cellText : "办公电话",
					cellType : "input",
					cellName : "keyManOfficeNbr" + collegeId + "_" + keyManCount
				},
				{
					cellText : "备注",
					cellType : "input",
					cellName : "keyManNote" + collegeId + "_" + keyManCount
				}
			]
		});
	}
	var startDateCount = 0;
	function addDateInfo(event) {
		if(startDateCount++ >= 5) {
			alert("由于服务器负荷，每个高校每次最多添加5个。");
			startDateCount--;
			return;
		}
		var collegeId = getCollegeId(event);
		//startDateCount++;
		dynamicAdd({
			targetEl : document.getElementById("beginDate" + collegeId),
			insertType : "0",
			cellInfos : [
				{
					cellText : "学年",
					html : "<input type='text' name='beginDateYear" + collegeId + "_" + startDateCount + "' onfocus='WdatePicker({readOnly:true,dateFmt:\"yyyy\"})' class='Wdate' />"
				},
				{
					cellText : "春季开学时间",
					html : "<input type='text' name='beginDateSpringDate" + collegeId + "_" + startDateCount + "' onfocus='WdatePicker({readOnly:true,dateFmt:\"yyyy-MM-dd\"})' class='Wdate' />"
				},
				{
					cellText : "秋季开学时间",
					html : "<input type='text' name='beginDateAutumnDate" + collegeId + "_" + startDateCount + "' onfocus='WdatePicker({readOnly:true,dateFmt:\"yyyy-MM-dd\"})' class='Wdate' />"
				}
			]
		});
	}
	var saleManCount = 0;
	function addSaleManInfo(event) {
		if(saleManCount++ >= 5) {
			alert("由于服务器负荷，每个高校每次最多添加5个。");
			saleManCount--;
			return;
		}
		var collegeId = getCollegeId(event);
		//saleManCount++;
		dynamicAdd({
			targetEl : document.getElementById("saleMan" + collegeId),
			insertType : "0",
			cellInfos : [
				{
					cellText : "直销队编码",
					cellType : "input",
					cellName : "saleManTeamCode" + collegeId + "_" + saleManCount
				},
				{
					cellText : "直销队名称",
					cellType : "input",
					cellName : "saleManTeamName" + collegeId + "_" + saleManCount
				}, 
				{
					cellText : "直销队类型",
					html : "<select name='saleManTeamType" + collegeId + "_"  + saleManCount + "'><option value=''>请选择</option><option value='优'>优</option><option value='良'>良</option><option value='中'>中</option><option value='差'>差</option></select>"
				},
				{
					cellText : "使用的BOSS工号",
					cellType : "input",
					cellName : "saleManBossstaffId" + collegeId + "_" + saleManCount
				},
				{
					cellText : "归属渠道编码",
					cellType : "input",
					cellName : "saleManChannelId" + collegeId + "_" + saleManCount
				},
				{
					cellText : "队长姓名",
					cellType : "input",
					cellName : "saleManLeaderName" + collegeId + "_" + saleManCount
				},
				{
					cellText : "队长联系电话",
					cellType : "input",
					cellName : "saleManLeaderNbr" + collegeId + "_" + saleManCount
				},
				{
					cellText : "队长邮件",
					cellType : "input",
					cellName : "saleManLeaderEmail" + collegeId + "_" + saleManCount
				},
				{
					cellText : "备注",
					cellType : "input",
					cellName : "saleManNote" + collegeId + "_" + saleManCount
				}
			]
		});
	}
	
	function deleteSaleManInfo(event) {
		var collegeId = getCollegeId(event);
    	var _refEl = document.getElementById("saleMan" +  collegeId);
    	//先找到是否之前有记录 update@
    	if(preDelete("saleMan",collegeId))
    		return;
		dynamicDelete({
    		refEl : _refEl,
    		//trCounts : 3,
    		unitCounts : 9,
    		telFunc : function() {
    			//这里的this值的是外层的{}对象而不是function
    			
    			
    			var targetTr = this.refEl.nextSibling;
    			try{
    				while(targetTr.tagName != "TR") {
    					targetTr = targetTr.nextSibling;
    				}
	    			//找到距离参考节点最近的一个TR之后
	    			if(targetTr.firstChild.firstChild.nodeValue == "直销队编码" || targetTr.firstChild.firstChild.nodeValue=="使用的BOSS工号" || targetTr.firstChild.firstChild.nodeValue=="队长联系电话")
	    				return true;
	    			else return false;
    			} catch(e) {
    				return false;
    			}
    		},
    		alertFunc : function() {
    			alert("没有可供删除的行。");
	    		return;
    		}
    	});
	}
	function deleteDateInfo(event) {
		var collegeId = getCollegeId(event);
    	var _refEl = document.getElementById("beginDate" +  collegeId);
    	//先找到是否之前有记录 update@
    	if(preDelete("beginDate",collegeId))
    		return;
		dynamicDelete({
    		refEl : _refEl,
    		telFunc : function() {
    			//这里的this值的是外层的{}对象而不是function
    			var targetTr = this.refEl.nextSibling;
    			try{
    				while(targetTr.tagName != "TR") {
    					targetTr = targetTr.nextSibling;
    				}
	    			//找到距离参考节点最近的一个TR之后
	    			if(targetTr.firstChild.firstChild.nodeValue == "学年")
	    				return true;
	    			else return false;
    			} catch(e) {
    				return false;
    			}
    		},
    		alertFunc : function() {
    			alert("没有可供删除的行。");
	    		return;
    		}
    	});
	}
	//false 可以删,没有update
	function preDelete(refId,collegeId) {
		var refEl = document.getElementById(refId + collegeId);
		var val;
		try{
			do{
				refEl = refEl.nextSibling;
			} while(refEl.tagName != "TR");
			val = refEl.firstChild.nextSibling.firstChild.name;
	   	} catch(e) {
	   		return false;
	   	}
	   	if(val.indexOf("@")!=-1) {
	   		var choice = confirm("确定要删除已有记录?");
	   		if(choice) {
	   		//删除代码
	   			var sql,params;
	   			if("beginDate" == refId) {
	   				sql = " delete from NWH.COLLEGE_TERM_BEGINDATE where college_id=? and year=? ";
	   				//逗号分隔
	   				params = collegeId + "," + refEl.firstChild.nextSibling.firstChild.value;
	   			} else if("keyMan" == refId) {
	   				sql = " delete from NWH.COLLEGE_KEYMAN where college_id=? and KEY_NAME=? ";
	   				params = collegeId + "," + refEl.firstChild.nextSibling.firstChild.value;
	   			} else if("saleMan" == refId) {
	   				sql = " delete from NWH.COLLEGE_SALESMAN where college_id=? and direct_team=? ";
	   				params = collegeId + "," + refEl.firstChild.nextSibling.firstChild.value;
	   			}
	   			var result = deleteRecord(sql,params);
	   			if(result)
	   				return false;
	   			else
	   				return true;//虽然有记录，虽然用户要求删除，可是没有删除成功。
	   		} else return true;
	   	}else return false;
	}
	//删除一条记录,服务器端代码college_db.jsp
	//true 删除成功
	function deleteRecord(sql,params) {
		var xhr = createXhrObject();
		var url = "college_db.jsp?oper=delete";
		params = params.split(",");
		var paramStr = "";
		for(var indx in params)
			paramStr += "&params=" + encodeURI(encodeURI(params[indx]));
		url += "&delSql=" + sql + paramStr;
		var result;
		xhr.onreadystatechange = function() {
	        if (xhr.readyState == 4) {
	            if (xhr.status == 200) {
	                //alert(xhr.responseText);
	            	var respObj = eval("(" + xhr.responseText + ")");
	            	if(true == respObj.success) {
	            		debugger;
	            		alert(respObj.msg);
	            		result = true;
	            	} else if( false == respObj.success ){
	            		alert(respObj.msg);
	            		result = false;
	            	}
	            }
	        }		
    }
		xhr.open("GET",url,false);//同步请求，不是异步请求
		xhr.send(null);
		return result;
	}
    function deleteKeyManInfo(event) {
    	var collegeId = getCollegeId(event);
    	var _refEl = document.getElementById("keyMan" +  collegeId);
    	//先找到是否之前有记录 update@
    	if(preDelete("keyMan",collegeId))
    		return;
    	dynamicDelete({
    		refEl : _refEl,
    		//trCounts : 2,
    		unitCounts : 6,
    		telFunc : function() {
    			//这里的this值的是外层的{}对象而不是function
    			//这个function硬编码，非常不好
    			debugger;
    			var targetTr = this.refEl.nextSibling;
    			try{
    				while(targetTr.tagName != "TR") {
    					targetTr = targetTr.nextSibling;
    				}
	    			//找到距离参考节点最近的一个TR之后
	    			if(targetTr.firstChild.firstChild.nodeValue == "关键人姓名" || targetTr.firstChild.firstChild.nodeValue=="联系电话")
	    				return true;
	    			else return false;
    			} catch(e) {
    				return false;
    			}
    			/*旧版方法
    			if(this.refEl.nextSibling &&
    				this.refEl.nextSibling.tagName=="TR" && 
    				(this.refEl.nextSibling.firstChild.firstChild.nodeValue=="关键人姓名" || this.refEl.nextSibling.firstChild.firstChild.nodeValue=="联系电话")
    			) 
    				return true;
    			else return false;
    			*/
    		},
    		alertFunc : function() {
    			alert("没有可供删除的行。");
	    		return;
    		}
    	});
    }
    /*
    
    function clearStyle(_style) {
    	event.srcElement.style._style = "";
    }
    */
    function check() {
    	var phonePatten = /^((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$/;
    	var emailPatten = /^[a-z]([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\.][a-z]{2,3}([\.][a-z]{2})?$/i;
    	var msg = "";
    	with(document.forms[0]) {
    		for(var i = 0 ; i < elements.length; i++) {
    			if(elements[i].name.indexOf("keyManName")==0) {
    				if(!elements[i].value) {
    					msg+=appendLi("关键人不能为空");
    					/*
    					elements[i].style.borderColor="#FF6217";
    					elements[i].onfocus = clearStyle("");
    					*/
    				}
    					
    			}  else if(elements[i].name.indexOf("keyManLinkNbr")==0) {
    				if(!elements[i].value.match(phonePatten))
    					msg+=appendLi("联系电话输入有误");
    			}  else if(elements[i].name.indexOf("keyManOfficeNbr")==0) {
    				if(!elements[i].value.match(phonePatten))
    					msg+=appendLi("办公电话输入有误");
    				//alert(elements[i].value);//办公电话
    			}  else if(elements[i].name.indexOf("saleManTeamType")==0) {
    				if(!elements[i].value)
    					msg+=appendLi("请选择直销队类型");
    				//直销队类型
    			}  else if(elements[i].name.indexOf("saleManTeamCode")==0) {
    				if(!elements[i].value)
    					msg+=appendLi("直销队编码不能为空");
    			}  else if(elements[i].name.indexOf("saleManLeaderEmail")==0) {
    				//队长邮件
    				if(!elements[i].value.match(emailPatten))
    					 msg+= appendLi("队长电子邮件格式不正确");
    			}  else if(elements[i].name.indexOf("saleManLeaderNbr")==0) {
    				if(!elements[i].value.match(phonePatten))
    					msg+=appendLi("队长联系电话输入有误");//队长联系电话
    			}  else if(elements[i].name.indexOf("managerNbr")==0) {
    				if(!elements[i].value.match(phonePatten))
    					msg+=appendLi("责任人电话电话输入有误");//责任人电话
    			}  else if(elements[i].name.indexOf("beginDateYear")==0) {
    				if(!elements[i].value)
    					msg+=appendLi("学年不能为空");
    				if(!elements[i].value.match(/\d{4}/))
    					msg+=appendLi("请选择四位数字学年，如2009");
    				//学年
    			}  else if(elements[i].name.indexOf("beginDateSpringDate")==0) {
    				if(!elements[i].value)
    					msg+=appendLi("春季开学时间不能为空");
    				//春季开学时间
    			}  else if(elements[i].name.indexOf("beginDateAutumnDate")==0) {
    				if(!elements[i].value)
    					msg+=appendLi("秋季开学时间不能为空");
    			}  
			}
   		}
    		/*
    		for(var i = 0 ; i < collegeId.length; i ++) {
    		}
    		*/
    	if(msg) {
    		document.getElementById("errorMsg").firstChild.innerHTML = msg;
    		return false;
    	} else return true;
    }
    function appendLi(str) {
    	return "<li>" + str + "</li>";
    }
    function preCheck() {
    	//假设检查通过
    	//parent.document.getElementById('frameDiv1').style.display = 'none';
    	if(!check()) {
    		alert("输入错误，请检查后提交");
    		return;
    	}
    	maskScreen({
    		scope : parent.document,
    		layout : {
    			width : "1499",
    			height : "1499"
    		}
    	});
    	document.forms[0].submit();
    	//window.parent.document.getElementById("loading").style.display = "block";
    }
    /* 此方法没用
    function hiddenDiv() {
    	//alert("heddening");
    	//parent.frameDiv1.style.display = 'none'
    }
    */
	
</script>
	
</head>
<%
	String[] ids = request.getParameter("ids").split(",");
	String param1 = "";
	int count = 0;
	for(int i = 0 ; i < ids.length; i ++) {
	    if(ids[i].length() > 0) {
	        count++;
	    }
	        param1 += "'" + ids[i] + "',";
	}
	if(count > 0)
	    param1 = param1.replaceAll("\\,$","");
SQLSelect select = new SQLSelect();
String sql = "select college_id,college_name,MANAGER,MANAGER_NBR from nwh.college_info where college_id in (" + param1 + ")";	
List list = select.getTotalList(sql);
%> 
<body>
	<div align="center">
		<form action="college_db.jsp?oper=update" method="post">
		<h4 align="right"><span style="cursor:pointer" onclick="parent.document.getElementById('frameDiv1').style.display = 'none'">关闭</span></h4>
		<h2 align="center">高校信息录入界面</h2>
<%
	for(int i = 0 ; i < list.size(); i ++) {
		String[] college = (String[])list.get(i);
		String collegeId = college[0];
		String collegeName = college[1];
		String manager = college[2];
		String managerNbr = college[3];
%>
		<table id="fillTable">
			<input type="hidden" id="collegeId" name="collegeId" value="<%=collegeId %>"/>
			<tr>
			<th>高校名称</th>
			<td class="alt"><%= collegeName%></td>
				<th>高校编码</th>
			<td class="alt"><%=collegeId %></td>
			<th>责任人</th>
			<td class="alt"><input type="text" name="manager<%=collegeId %>" value="<%=manager %>"/></td>
			</tr>
			<tr>
				<th>责任人电话</th>
				<td class="alt" colspan="6"><input type="text" name="managerNbr<%=collegeId %>" value="<%=managerNbr %>"/></td>
			</tr>
			<tr id="keyMan<%=collegeId %>"><td colspan="6"><label >高校关键人信息</label> 
				<img style="cursor: pointer;" onclick=addKeyManInfo(event) src="${mvcPath}/hbbass/common2/image/add.gif" title="点击新增关键人信息" alt="点击新增关键人信息"/>
				<img style="cursor: pointer;" onclick=deleteKeyManInfo(event) src="${mvcPath}/hbbass/common2/image/delete.gif" title="点击删除关键人信息" alt="点击删除关键人信息"/>
			</td>
			</tr>
<%-- added --%>
<%
	String subSql1 = " select KEY_NAME,position,department,link_nbr,office_nbr,note from NWH.COLLEGE_KEYMAN where college_id='" + collegeId + "'";
	List subList1 = select.getTotalList(subSql1);
%>
				<input type="hidden" name="<%=collegeId %>keyManSize" value="<%=subList1.size()%>"/>
<%
				for(int j = 0 ; j < subList1.size(); j ++) {
			    	String[] keyManInfo = (String[])subList1.get(j);
%>
			<tr><td>关键人姓名</td><td>
				<%-- 名字不能改 --%>
				<input type="text" readonly="readonly" name="update@keyManName<%=collegeId +"_" + (j+1)%>" value="<%= keyManInfo[0]%>"/>
				</td> 
				<td>职位</td><td>
				<input type="text" name="update@keyManPosition<%=collegeId +"_" + (j+1)%>" value="<%= keyManInfo[1]%>"/>
				</td> 
				<td>归属部门</td><td>
				<input type="text" name="update@keyManDept<%=collegeId +"_" + (j+1) %>" value="<%= keyManInfo[2]%>"/>
				</td>
			</tr>
			<tr><td>联系电话</td><td>
			<input type="text" name="update@keyManLinkNbr<%=collegeId +"_" + (j+1)%>" value="<%= keyManInfo[3]%>"/>
			</td> <td>办公电话</td><td>
			<input type="text" name="update@keyManOfficeNbr<%=collegeId +"_" + (j+1)%>" value="<%= keyManInfo[4]%>"/>
			</td> <td>备注</td><td>
			<input type="text" name="update@keyManNote<%=collegeId +"_" + (j+1) %>" value="<%= keyManInfo[5]%>"/>
			</td></tr>
<%
				}
%>
<%-- / added --%>
			<tr id="beginDate<%=collegeId %>">
				<td colspan="6"><label>高校开学日期信息</label> 
					<img style="cursor: pointer;" onclick=addDateInfo(event) src="${mvcPath}/hbbass/common2/image/add.gif" title="点击新增开学日期信息" alt="点击新增开学日期信息"/>
					<img style="cursor: pointer;" onclick=deleteDateInfo(event) src="${mvcPath}/hbbass/common2/image/delete.gif" title="点击删除开学日期信息" alt="点击删除开学日期信息"/>
				</td>
			</tr>

<%-- added --%>
<%
	String subSql2 = " select year,spring_term_begin,autumn_term_begin from NWH.COLLEGE_TERM_BEGINDATE where college_id='" + collegeId + "'";
	List subList2 = select.getTotalList(subSql2);
%>
	<input type="hidden" name="<%=collegeId %>beginDateSize" value="<%=subList2.size()%>"/>
<%
		for(int j = 0 ; j < subList2.size(); j ++) {
			    	String[] beginDateInfo = (String[])subList2.get(j);
%>
			<tr><td>学年</td><td class="alt">
				<%-- 学年不能改 --%>
				<input type="text" readonly="readonly" name="update@beginDateYear<%=collegeId +"_" + (j+1)%>" class="Wdate" value="<%= beginDateInfo[0]%>" />
				</td> 
				<td>春季开学时间</td><td class="alt">
				<input type="text" name="update@beginDateSpringDate<%=collegeId +"_" + (j+1)%>" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" value="<%= beginDateInfo[1]%>" value="<%= beginDateInfo[1]%>"/>
				</td> 
				<td>秋季开学时间</td><td class="alt">
				<input type="text" name="update@beginDateAutumnDate<%=collegeId +"_" + (j+1)%>" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate" value="<%= beginDateInfo[2]%>" value="<%= beginDateInfo[2]%>"/>
				</td>
			</tr>
<%
				}
%>
<%-- / added --%>

			<tr id="saleMan<%=collegeId %>">
				<td colspan="6"><label>高校直销队信息</label> 
					<img style="cursor: pointer;" onclick=addSaleManInfo(event) src="${mvcPath}/hbbass/common2/image/add.gif" title="点击新增开学日期信息" alt="点击新增开学日期信息"/>
					<img style="cursor: pointer;" onclick=deleteSaleManInfo(event) src="${mvcPath}/hbbass/common2/image/delete.gif" title="点击删除开学日期信息" alt="点击删除开学日期信息"/>
				</td>
			</tr>
			
<%-- added --%>
<%
	String subSql3 = " select direct_team, direct_team_name, team_type, bossstaff_id, college_id, leader_name, leader_nbr, leader_mail, note  from NWH.COLLEGE_SALESMAN where college_id='" + collegeId + "'";
	List subList3 = select.getTotalList(subSql3);
%>
	<input type="hidden" name="<%=collegeId %>saleManSize" value="<%=subList3.size()%>"/>
<%
		for(int j = 0 ; j < subList3.size(); j ++) {
	    	String[] saleManInfo = (String[])subList3.get(j);
%>
			<tr>
			<%-- 编码不能改 --%>
			
			<td>直销队编码</td><td class="alt">
				<input readonly="readonly" type="text" name="update@saleManTeamCode<%=collegeId +"_" + (j+1) %>" value="<%= saleManInfo[0]%>"/>
				</td> 
				<td>直销队名称</td><td class="alt">
				<input type="text" name="update@saleManTeamName<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[1]%>"/>
				</td> 
				<td>直销队类型</td><td class="alt">
				<select name="update@saleManTeamType<%=collegeId +"_" + (j+1)%>">
				<%-- 没有JSTL EL，太难看了 --%>
					<option value='优' 
					<%
						if("优".equalsIgnoreCase(saleManInfo[2])) {
					%>
					 	selected="selected"  
					<%
					}
					 %>
					 >优</option>
					<option value='良'
					<%
						if("良".equalsIgnoreCase(saleManInfo[2])) {
					%>
					 	selected="selected"  
					<%
					}
					 %>
					>良</option>
					<option value='中'
					<%
						if("中".equalsIgnoreCase(saleManInfo[2])) {
					%>
					 	selected="selected"  
					<%
					}
					 %>
					>中</option>
					<option value='差'
					<%
						if("差".equalsIgnoreCase(saleManInfo[2])) {
					%>
					 	selected="selected"  
					<%
					}
					 %>
					>差</option>
				</select>
				</td>
			</tr>
			
			<tr><td>使用的BOSS工号</td><td class="alt">
				<input type="text" name="update@saleManBossstaffId<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[3]%>"/>
				</td> 
				<td>归属渠道编码</td><td class="alt">
				<input type="text" name="update@saleManChannelId<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[4]%>"/>
				</td> 
				<td>队长姓名</td><td class="alt">
				<input type="text" name="update@saleManLeaderName<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[5]%>"/>
				</td>
			</tr>
			
			<tr><td>队长联系电话</td><td class="alt">
				<input type="text" name="update@saleManLeaderNbr<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[6]%>"/>
				</td> 
				<td>队长邮件</td><td class="alt">
				<input type="text" name="update@saleManLeaderEmail<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[7]%>"/>
				</td> 
				<td>备注</td><td class="alt">
				<input type="text" name="update@saleManNote<%=collegeId +"_" + (j+1)%>" value="<%= saleManInfo[8]%>"/>
				</td>
			</tr>
<%
			}
%>
<%-- / added --%>
		</table>
		<br/>
<%
	}
%>
	<style type="text/css"> 
		/*
		ul {
			float : left
			color: red;
			text-align: left
		}
		li {
			float: left
		}
		*/
	</style>
	<div id="errorMsg">
		<ul style="color :red;text-align: left">
		</ul>
	</div>
	<input type="button" value="提交" onclick="preCheck()"> <input type="reset" value="重置">
	</form>	
	</div>
</body>
</html>