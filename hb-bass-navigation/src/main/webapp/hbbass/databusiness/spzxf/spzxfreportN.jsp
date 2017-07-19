<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%-- 这是一个深渊!
20100907 : no need to import any class anymore, cause the authority will be control by the menu , not the jsp page anymore.
<jsp:useBean id="sysmenulog" scope="application" class="com.hbmobile.hbbass.database.SysMenuItemDB"/>

<%@page import="java.sql.Connection,java.sql.Statement,java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="struts.utility.StaticSelectHB"%>
--%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>集团客户省内报表</title>
<style type="text/css">
@import url("/hbbass/css/com.css");
</style>
</head>
<%
String auth_sql = "select 1 from ESPECIAL_POWER where visit_code='reporting' and LOGINNAME='"+session.getAttribute("loginname")+"' with ur";
List auth_list = StaticSelectHB.searchResults(auth_sql);
boolean hasRight = false;
if(auth_list.size()!=0) hasRight = true;
%>

<body>
<form>
			<table id="tablezxf" border=1 borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0 width="35%" align="center">
			  <tr style='height:14.25pt' bgcolor="#e4e9ff">
			    <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap align="center"><strong>SP自消费清单下载</strong></td>
			  </tr>
			</table>
			<br>
			<table id="tabledebt" border=1 borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0 width="35%" align="center">
			  <tr style='height:14.25pt' bgcolor="#e4e9ff">
			    <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap align="center"><strong>SP欠费清单下载</strong></td>
			  </tr>
			</table>
			<br>
			<table id="tablesp" border=1 borderColorDark=#ffffff borderColorLight=#000066 cellPadding=1 cellSpacing=0 width="30%" align="center">
			  <tr style='height:14.25pt' bgcolor="#e4e9ff">
			    <td bgcolor=#ffffff style="font-size:10.8pt;color:#ff6622" nowrap align="center"><strong>SP清单下载</strong></td>
			  </tr>
			</table>
		</td>
	</tr>
</table>
</form>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript">
<%
	if(hasRight) {
%>
	+function(window,document,undefined) {
		var remotePaths = ["sp/spzxf","sp/spdebt","sp"]; //目前来说一共三个远程目录
		var ajax ;
		for(var i = 0 ; i < remotePaths.length ; i++) {
			var remotePath = remotePaths[i];
			ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/filemanage?method=listRemoteFiles" //这个action只会list 文件类型，并且只有一级，这正合我意
					,parameters : "remotePath=" + remotePath
					,callback : function(r){
						return function(xmlrequest){
							try{
								var files = eval("(" + xmlrequest.responseText + ")");
								listFiles(r,files); 
							} catch(e) {
								debugger;
							}
							
					    };
					}(remotePath)//不同于callback 方法，这个匿名方法立即执行,这也许是唯一能解决变量在循环中被替换的方法
					
			});
			ajax.request();
		}
		
		function listFiles(remotePath, files) {
			//alert(remotePath);
			var tableId =""; 
			if("sp/spzxf" == remotePath)
				tableId = "tablezxf";
			else if("sp/spdebt" == remotePath)
				tableId = "tabledebt";
			else if("sp" == remotePath)
				tableId = "tablesp";
			var tbl = $(tableId);
			for(var j = 0 ; j < files.length ; j++) {
				var _row = tbl.insertRow();
				_row.style.height="14.25pt";
				_row.style.backgroundColor ="#e4e9ff";
				var _cell = _row.insertCell();
				_cell.align="center";
				_cell.className="row1";
				var _link = $C("a");
				var _params = aihb.Util.paramsObj();
				_link.href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=" + remotePath+ "&fileName=" + files[j];
				_link.onclick = function() {
					aihb.AjaxHelper.log({params: encodeURI(_params._oriUri)+ "&opertype=down&opername="+encodeURIComponent(files[j])}); //加日志
				}
				_link.appendChild($CT(files[j]));
				_cell.appendChild(_link);
				//str += '<tr style="height:14.25pt" bgcolor="#e4e9ff"><td align="center" class="row1">' + files[j] + '</td></tr>';
			}
		}
	}(window,document);


<%
	} else out.print("alert('对不起,您没有权限!')");
%>
	
</script>
</body>
</html>
