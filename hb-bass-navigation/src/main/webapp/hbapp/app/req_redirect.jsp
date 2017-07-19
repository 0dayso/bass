<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.asiainfo.util.Des" %>
<%
String method = request.getParameter("method");
String url = "http://10.25.124.46/ldc_new/devreq/";
String url1 = "http://10.25.124.46/ldc_new/devmgr/";
String url2 = "http://10.25.124.46/ldc_new/forum/forum.html";
String url5 ="http://10.25.124.46/ldc_new/forum/dqitemList.html";
String url3 = "http://10.25.124.46/ldc_new/forum/reply.html";
String url4 = "http://10.25.124.46/ldc_new/meta/zbInfolist.html";
String url6 = "http://10.25.124.46/ldc_new/mkreq/";
String url7 = "http://10.25.124.46/ldc_new/cp/cpInfoUpload.html";
User user = (User)session.getAttribute("user");
String userName = user.getName();
String userId = user.getId();
String cityId = user.getCityId();
String cityName = "省公司";
String key1 = "D";
String key2 = "E";
String key3 = "S";
System.out.println(userId);
String userId4=Des.strEnc(userId,key1,key2,key3);
String userName4=Des.strEnc(userName,key1,key2,key3);
String params="?token=B6E2FB95277EEF13&USERNAME="+userId4+"&USERCNNAME="+userName4;
String cityId7=Des.strEnc(cityId,key1,key2,key3);
String params0 = "?token=B6E2FB95277EEF13&USERNAME="+userId4+"&USERCNNAME="+userId4+"&CITYID="+cityId7;
if (method.endsWith("mkreq") || method.startsWith("new") || method.endsWith("Stf") || method.equals("forum")|| method.equals("meta")|| method.equals("zbInfolistFrame")||method.equals("reply")||method.equals("dqitemList")||method.equals("cpInfoUpload")){
    params="?token=B6E2FB95277EEF13&USERNAME="+userId+"&USERCNNAME="+userName;
	String groupName ="";
	SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list","AiomniDB");
	List list = (List)sqlQuery.query("select name,seq from (select 1 seq,group_name as name from FPF_USER_GROUP_MAP a ,FPF_USER_GROUP b where USERID='"+userId+"' and a.GROUP_ID=b.GROUP_ID union all select 2 seq,cityname name from FPF_user_city where cityid='"+cityId+"') t order by seq with ur");
	if(list.size()>0){
		groupName = ((String[])list.get(0))[0];
		if(!"0".equalsIgnoreCase(cityId))
			cityName=((String[])list.get(1))[0];
	}
	params +="&USERTYPE="+groupName+"&CITY="+cityName+"&cityId="+cityId;
	if(userId.equals("mengxiaoli")||userId.equals("meikefu")){
		params+="&OwnGroup=SysMgr";
	}
	url2+=params;
	url3+=params;
	String indicatorId4=request.getParameter("indicator_id");
	String  appName4=request.getParameter("appName");
	if(indicatorId4==null){
		indicatorId4="undefined"; 
	}
	indicatorId4=Des.strEnc(indicatorId4,key1,key2,key3);
	if(appName4==null){
		appName4="undefined";
	}
	appName4=Des.strEnc(appName4,key1,key2,key3);
	String text1="?token=B6E2FB95277EEF13&USERNAME="+userId4+"&USERCNNAME="+userName4+"&indicator_id="+indicatorId4+"&appName="+appName4;
	url4+=text1;
	url5+=params+"&TOPICCODE=T0803038&indicator_id="+request.getParameter("indicator_id")+"&appName="+request.getParameter("appName");
	url7+=params0;
}

//url+=map.get(method)+params;
if(method.endsWith("_mkreq")){
	url = url6 + map.get(method)+params;
}
if (method.endsWith("Stf")){
	if (method.startsWith("new")||method.startsWith("daiban")||method.startsWith("query")||method.startsWith("daibancheck")){
	   url = url1 + map.get(method)+params ;
	}
}
if (method.endsWith("_ldc")){
if (method.startsWith("list")||method.startsWith("new")||method.startsWith("daiban")||method.startsWith("query")||method.startsWith("daibancheck")){
   url = url + map.get(method)+params ;
}

if (method.startsWith("MYREQ")||method.startsWith("DUITYREQ")||method.startsWith("PARTAKEREQ")){
   url = url + map.get(method)+"&"+params.substring(1,params.length());
}
}else if(method.equals("forum")){
	url=url2;
}else if(method.equals("zbInfolistFrame")){
	url=url4+"&isCloud=yes";
}else if(method.equals("meta")){
	url=url4+"&isCloud=yes";
}else if(method.equals("reply")){
	String ITEMID=request.getParameter("ITEMID");
	url=url3+"&ITEMID="+ITEMID;
}else if(method.equals("dqitemList")){
	url=url5;
}else if(method.equals("cpInfoUpload")){
	url=url7;
}

%>
<%!
private static Map map = new HashMap();
static{
	map.put("new","ReqNewRegister.html");
	map.put("daiban","DevReqNew.html");
	map.put("query","DevReqQuery.html");
	map.put("newStf","StaffAdd.html");
	map.put("daibanStf","StaffWait.html");
	map.put("queryStf","StaffQuery.html");
	
	//加入新需求管理页面，以后将合并到上面
	map.put("new_ldc","ReqRegister_selectDept.html");
	map.put("list_ldc","DevReqOnlineList.html");
	map.put("daiban_ldc","DevReqNew.html");
	map.put("daibancheck_ldc","DevReqNewByCheck.html");
	map.put("query_ldc","DevReqQuery.html");
	map.put("MYREQ_ldc","DevReqQueryLook.html?TYPE=MYREQ");
	map.put("DUITYREQ_ldc","DevReqQueryLook.html?TYPE=DUITYREQ");
	map.put("PARTAKEREQ_ldc","DevReqQueryLook.html?TYPE=PARTAKEREQ");
	
	//运行监控
	map.put("ReqAdd_mkreq","ReqAdd.html");
	map.put("ReqQuery_mkreq","ReqQuery.html");
	map.put("daibai_mkreq","ReqQuery_daibai.html");
	map.put("info_mkreq","infoAppear.html");
	map.put("userFlow_mkreq","userFlow.html");
	
	map.put("DATA_INFO_mkreq","DATA_INFO.html");
	map.put("CHARGES_INFO_mkreq","CHARGES_INFO.html");
	map.put("Mk_ACT_mkreq","Mk_ACT.html");
	map.put("CHANNEL_PC_mkreq","CHANNEL_PC.html");
	map.put("OTHERS_mkreq","OTHERS.html");
}
%>
<script>
//window.location.href="<%=url%>";
window.open("<%=url%>");
</script>
