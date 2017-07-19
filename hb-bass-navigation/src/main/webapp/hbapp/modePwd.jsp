<%@ page language="java" import="com.asiainfo.hb.web.models.User,com.asiainfo.bass.components.models.DES" pageEncoding="utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<%User user = (User)session.getAttribute("user");
String newpwd = request.getParameter("newPwd");
if(null != newpwd){
	//改密码
	String newPwd = DES.encrypt(newpwd);
	String sql = "update FPF_USER_USER set pwd="+newPwd+" where userid="+user.getId();
	Connection conn=null;
	List list = null;
	Connection conn = null;
 	PreparedStatement ps = null;
 	PreparedStatement psLog = null;
 	  
 	String modifyPsSql = "update FPF_USER_USER set pwd="+newPwd+" where userid="+user.getId();
 	
 	String logSql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
 	try{
		conn = ConnectionManage.getInstance().getDWConnection();
		conn.setAutoCommit(false);
		psLog = conn.prepareStatement(logSql);
		ps = conn.prepareStatement(modifyPsSql);
		ps.setString(1, user.getId());
			ps.setInt(2, 0);
			ps.setString(3, "修改密码");
			ps.setString(4, "修改密码");
			ps.setString(5, "修改密码");
			
			ps.execute();
			ps.close();
		for(int i = 0; i<ids.length; i++) {
			if(firsts[i].equalsIgnoreCase(""))
				firsts[i]= null;
			if(seconds[i].equalsIgnoreCase(""))
				seconds[i]= null;
			if(thirds[i].equalsIgnoreCase(""))
				thirds[i]= null;
			psLog.setString(1,firsts[i]);
			psLog.setString(2,seconds[i]);
			psLog.setString(3,thirds[i]);
			psLog.setString(4,ids[i]);
			
			psLog.addBatch();
			ps.setString(1,firsts[i]);
			ps.setString(2,seconds[i]);
			ps.setString(3,thirds[i]);
			ps.setString(4,ids[i]);
			ps.addBatch();
 		}
 		out.print("{success:true}");
 		conn.commit();
 	} catch(Exception e) {
 	    conn.rollback();
 	   	out.print("{success:false,errorInfo:'" + e.getMessage() + "'}");
 	    e.printStackTrace();
 	    log.error(e.getMessage());
 	}finally {
        ConnectionManage.getInstance().releaseConnection(conn);
    }
}
%>
<html>
<head>
 	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script language="javascript"> 
 function sub(){
	 //输入判断
	 var pwd1 = $("newPwd").value;
	 var pwd2 = $("repeatNewPwd").value;
	 if(pwd1!=pwd2){
		 alert("两次输入密码不一致");
		 return;
	 }else{
		 document.forms[0].submit;
	 }
 }
 
</script>
 
<title>用户属性设置</title>
</head>
<body topmargin="0" leftmargin="0">
 
</body>
</html>
 
<html>
<head>
<title>用户密码修改</title>
<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
</head>
 
	
<body topmargin="0" leftmargin="0">
<form name="userForm" method="post" action="modePwd.jsp">
	<table border="0" cellpadding="1" cellspacing="1" style="border-collapse: collapse" width="100%" id="AutoNumber1" bgcolor='537EE7'>
		<tr bgcolor='DCEBFC'>
			<td colspan="3" height="21">
				<font size =2><b>修改密码</b></font>
			</td>
		</tr>
	  
		<tr bgcolor='DCEBFC' width="100%">
			<td>
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" width="98%" id="AutoNumber1">
				  <tr> 
				    <td width="40%" align="right" height="25">
				    	<font size="2">新密码:</font>
				    </td>
				    <td width="60%" height="25">
				    	<input type="password" name="newPwd" id="newPwd" size="12" value=""  style="ime-mode:disabled">
				      <font size="2" color="#FF0000">*</font>
				    </td>
				  </tr>
				  <tr> 
				    <td align="right" height="25">
				    	<font size="2">确认新密码:</font>
				    </td>
				    <td  height="25">
				    	<input type="password" name="repeatNewPwd" id="repeatNewPwd" size="12" value=""  style="ime-mode:disabled">
				      <font size="2" color="#FF0000">*</font> 
				    </td>
				  </tr>
				</table>
			</td>
		</tr>
		<tr bgcolor='DCEBFC' width="100%">
			<td>
			<input type="button" onclick="sub()" value="提交"/>
			</td>
		</tr>
	</table>
 
	<input type="hidden" name="loginUserid" value="meikefu" />
</form>

<script language="javascript">
	// 本地增加用户新增和修改的日志记录
	/**
	function saveUser()
	{  var st1=document.forms[0].loginUserid.value;
		 var st2=document.forms[0].newPwd.value;
		 SysLog("修改用户密码","用户梅珂夫修改密码。");
     onSave();
	}
	*/
</script>	
</body>
</html>

