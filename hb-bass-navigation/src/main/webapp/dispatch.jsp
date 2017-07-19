<%@ page language="java" import="java.util.*,java.io.File,java.io.IOException" pageEncoding="GBK"%>
<%@ page import="com.asiainfo.hbbass.component.util.Util,com.asiainfo.hb.web.models.User" %>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<%
String loginname=request.getParameter("loginname");
String url = request.getParameter("_url");
User user = (User)session.getAttribute("user");
System.out.println("user==="+user);
if(user==null){
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getWEBConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String sql = "select userid, username,pwd,cityid,value((select area_name from mk.bt_area where int(cityid)=area_id),'省公司') cityname,t.group_id,t.group_name,status,mobilephone,region_id,whiteblack from user_user left join (select userid uid,max(group_id) group_id,(select max(group_name) from user_group b where b.group_id=max(a.group_id)) group_name from user_group_map a group by userid) t on userid=uid where userid = '"+loginname+"'";
	list = (List)queryBase.query(sql);
	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  		user.setId(lines.get("userid").toString());
  		user.setName(lines.get("username").toString());
  		user.setCityId(lines.get("cityid").toString());
  		user.setAreaName(lines.get("cityname").toString());
	}
}catch(Exception e)
{
	e.printStackTrace();
}
finally
{
}	
session.setAttribute("user", user);
//与原有系统集成需要的session，以后去掉
session.setAttribute("loginname",loginname);
session.setAttribute("area_id",user.getCityId());
}
System.out.println(url);
System.out.println(url.replaceAll("|","&").replaceAll("@@","?"));
response.sendRedirect(url.replaceAll("|","&").replaceAll("@@","?"));
%>

