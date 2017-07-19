<%@page contentType="text/html; charset=utf-8"%>
<%@page import = "bass.database.report.ReportBeanHB,bass.common.DevidePageBeanHB" %>
<jsp:useBean id="UpdateBeanHB" scope="session" class="bass.common.UpdateBeanHB"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>特殊权限</title>
<style type=text/css>
@import url(/hbbass/css/com.css);
.t1
{width:60pt;}
.t2
{width:80pt;}
.css {
	font-family: "宋体";
	font-size: 12px;
	font-style: normal;
	line-height: 22px;
	color: #000000;
}
.css1 {
	font-family: "宋体";
	font-size: 12px;
	font-style: normal;
	line-height: 28px;
	color: #000000;
}
</style>
<script language="JavaScript">
	<!--
function moveOption(e1, e2)
{
    
	try{
        var e = e1.options[e1.selectedIndex];
        e2.options.add(new Option(e.text, e.value));
        e1.options.remove(e1.selectedIndex);
    }   
	catch(e)
	{
	   alert("请选择用户！");
	}
}
function moveAllOption(e1, e2)
{
    try{
	     var length=e1.options.length;
	    for(var i=0;i<length;)
		{
		  var e=e1.options[0];
		  e2.options.add(new Option(e.text, e.value));
          e1.options.remove(0);
		  length--;
		}
       
    }   
	catch(e)
	{
	}
}

function selvalue(e)
{
   var length=e.options.length;
	 if(length==0)
	 {
	    alert("已授权用户不能为空！");
		  return ;
	 }
	 var strname="";
	 var strsql="";
	for(var i=0;i<length;i++)
	{
     strsql=strsql.concat(e.options[i].value)+",'"+form1.modeCode.options[form1.modeCode.selectedIndex].value+"','"+form1.hidareaid.value+"','"+form1.modeCode.options[form1.modeCode.selectedIndex].text+"')";
     strname=strname.concat(e.options[i].value);
	   if(i<length-1)
	   {
		      strsql=strsql.concat(",(");
		      strname=strname.concat(",");
	   } 
	}
	form1.hidname.value="("+strname+")";
	form1.hidsql.value="("+strsql;
	if(confirm("确信要给这些用户赋予访问《"+form1.modeCode.options[form1.modeCode.selectedIndex].text+"》的权限吗？"))
	{
		form1.action="tsqx.jsp?doflag=update";
		form1.submit();
	}
  		
}

function selChange()
{
	form1.action="tsqx.jsp?doflag=fresh";
	form1.submit();
}

//-->
</script>
</head>
<%
String loginname="";
 if(session.getAttribute("loginname")==null)
{
    response.sendRedirect("/hbbass/error/loginerror.jsp");
 return;
}
 else
{
   loginname=(String)session.getAttribute("loginname");
}
int area_id = Integer.parseInt((String)session.getAttribute("area_id")); 
String area=request.getParameter("area")==null?(String)session.getAttribute("area_id"):request.getParameter("area");
String modeCode=request.getParameter("modeCode")==null?"kpiportal":request.getParameter("modeCode");

String doflag=request.getParameter("doflag")==null?"fresh":request.getParameter("doflag");
String name=request.getParameter("name")==null?"":request.getParameter("name");
name=new String(name.getBytes("ISO-8859-1"),"GBK");
if(doflag.equals("update"))
{
String hidname=request.getParameter("hidname");
String hidsql=request.getParameter("hidsql");
// 赋权限前先删除该地市具有访问改模块权限的用户
String delsql="delete from ESPECIAL_POWER where areaid='"+area+"' and visit_code='"+modeCode+"'";
UpdateBeanHB.aftUpdateSQL(delsql);
//插入新的具有特殊权限的用户
String addsql="insert into ESPECIAL_POWER values "+hidsql;
UpdateBeanHB.aftUpdateSQL(addsql);


//Begin:领导KPI修改刷新缓存
if("kpiportal".equalsIgnoreCase(modeCode))
{
	org.apache.commons.httpclient.HttpClient hc = new  org.apache.commons.httpclient.HttpClient();
	org.apache.commons.httpclient.methods.PostMethod 
	method = new org.apache.commons.httpclient.methods.PostMethod("http://10.25.124.45:8080/hbbass/common2/cacherefresh.jsp?who=bassCache");
	hc.executeMethod(method);
	method.releaseConnection();
	method=null;
	hc=null;
}
//End:Mei Kefu 2008-11-10

}

//根据模块和地市取出没有特殊权限的用户的工号和名称
ReportBeanHB rb1=new ReportBeanHB();
String sql1="select userid,username from FPF_USER_USER where cityid='"+area+"' and userid not in(select distinct loginname from  ESPECIAL_POWER where areaid='"+area+"' and visit_code='"+modeCode+"' ) and (userid like '%"+name+"%' or username  like '%"+name+"%')order by userid";
rb1.execute(sql1);
//out.println(sql1);
// 根据模块和地市取出已有特殊权限的用户的工号和名称
ReportBeanHB rb2=new ReportBeanHB();
String sql2="select userid,username from FPF_USER_USER where cityid='"+area+"' and userid in(select distinct loginname from  ESPECIAL_POWER where areaid='"+area+"' and visit_code='"+modeCode+"' ) order by userid";
rb2.execute(sql2);
%>
<body topmargin="0" leftmargin="0">
<form id="form1" name="form1" method="post" action="">
<table bgcolor="537EE7" border="0" cellpadding="0" cellspacing="1" style="border-collapse: collapse" width="100%" id="AutoNumber1">
  <tr class="css1" colspan='2'>
      <td width="200%" height="29" colspan="10" bgcolor="DCEBFC"> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="3%" height="29"><img src="/images/usernews.gif" height="16"></td>
          <td width="96%" class="css1"><strong>特殊权限维护</strong> 
          <td width="1%">&nbsp;</td>
        </tr>
      </table> 
      </td>
  </tr>
   <tr bgcolor="EFF5FB">
     <td width="200%" height="42" colspan="10" bgcolor="EFF5FB"> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td align="right" valign="middle" class="css1">
          	
         <a href="javascript:selvalue(form1.list2)"><img src="/images/button/bt2.gif" name="Image1" width="64" height="26" border="0"></a> 
          <a href="javascript:selChange()" ><img src="/images/button/bt9.gif" name="Image1" width="64" height="26" border="0"></a>  
        </td>
        </tr>
      </table>
      </td>
   </tr>   
 </table> 
 <table width="100%" border="0" align="center" cellspacing="1" cellpadding="1">
 	 <tr>
      <td width="30%" height=26 align="right" class="query_t">地市</td>
      <td colspan="3" class="query_v">
     <select name="area" onchange="selChange()">
         <%  
            DevidePageBeanHB cityInit=new DevidePageBeanHB();
            String citySQL="Select cityid,cityname from FPF_user_city where parentid='-1'"; 
        		if(area_id>0)
        		citySQL=citySQL+" and cityid='"+area_id+"'";
        		citySQL=citySQL+" order by cityid";
        		
        		cityInit.setQuerySQL(citySQL);
        		for(int i=1;i<=cityInit.getAllRowCount();i++){
        		
        %>
             <option value="<%=cityInit.getFieldValue("cityid",i)%>" <%if(cityInit.getFieldValue("cityid",i).equals(area)) out.print("selected");%>><%=cityInit.getFieldValue("cityname",i).equals("全省")?"省公司":cityInit.getFieldValue("cityname",i)%></option>
        <%}%>
    </select>
      </td>
    </tr>
     <tr>
      <td width="30%" height=26 align="right" class="query_t">用户</td>
      <td colspan="3" class="query_v">
          <input type="text" name="name" value="" size=10>&nbsp;<input type="button" id=button1 name=button1 value="按用户过滤" onclick="selChange()" >(根据用户帐号或姓名进行模糊匹配)
      </td>
    </tr>
    <tr>
      <td width="30%" height=26 align="right" class="query_t">功能模块</td>
      <td colspan="3" class="query_v">
        <select name="modeCode" onchange="selChange()">
         <!-- 	<option value="kpiportal"    <%if(modeCode.equals("kpiportal")) out.println("selected");%>>领导KPI</option>                 -->
          	<option value="PRED-YWRBB"    <%if(modeCode.equals("PRED-YWRBB")) out.println("selected");%>>业务日报表</option>                 
						<option value="reporting"     <%if(modeCode.equals("reporting")) out.println("selected");%>>经营分析报告</option>                
			  <!--		<option value="visitview"     <%if(modeCode.equals("visitview")) out.println("selected");%>>模块访问点击率</option>               -->
						<option value="TestCardCase"  <%if(modeCode.equals("TestCardCase")) out.println("selected");%>>测试卡情况统计表</option>         
						<option value="TestCardTrans" <%if(modeCode.equals("TestCardTrans")) out.println("selected");%>>全省测试卡调用情况合计表</option>
						<!-- <option value="dishijishi_ht" <%if(modeCode.equals("dishijishi_ht")) out.println("selected");%>>地市集市后台</option>
						<option value="dishijishi_qt" <%if(modeCode.equals("dishijishi_qt")) out.println("selected");%>>地市集市前台</option>
						-->
					<!--	<option value="KPI-COUNTY" <%if(modeCode.equals("KPI-COUNTY")) out.println("selected");%>>市场部－数据业务考核KPI报表</option> -->
						<option value="KeyKPI" <%if(modeCode.equals("KeyKPI")) out.println("selected");%>>重点指标</option>
				<!--		<option value="hcras" <%if(modeCode.equals("hcras")) out.println("selected");%>>有价值客户保有分析系统</option> -->
						<option value="reportdownsingle" <%if(modeCode.equals("reportdownsingle")) out.println("selected");%>>市场基础报表单个下载</option>
						<option value="reportdownbatch" <%if(modeCode.equals("reportdownbatch")) out.println("selected");%>>市场基础报表批量下载</option>
						
						<option value="group" <%if(modeCode.equals("group")) out.println("selected");%>>省内集团客户报表下载</option>
						<option value="MarketYX" <%if(modeCode.equals("MarketYX")) out.println("selected");%>>市场营销活动报表单个下载</option>
						<option value="MarketYXBatch" <%if(modeCode.equals("MarketYXBatch")) out.println("selected");%>>市场营销活动报表批量下载</option>
						<!-- <option value="deleteLog" <%if(modeCode.equals("deleteLog")) out.println("selected");%>>删除日志</option> -->
						<option value="answerQ" <%if(modeCode.equals("answerQ")) out.println("selected");%>>申告回复</option>
						<option value="checkLevelOne" <%if(modeCode.equals("checkLevelOne")) out.println("selected");%>>日志审计一级审核人</option>
						<option value="checkLevelTwo" <%if(modeCode.equals("checkLevelTwo")) out.println("selected");%>>日志审计二级审核人</option>
						<!-- <option value="reportHelp" <%if(modeCode.equals("reportHelp")) out.println("selected");%>>报表帮助</option> -->
						<option value="907" <%if(modeCode.equals("907")) out.println("selected");%>>热线营销策划人员</option>
        </select>     
        
         </td>
    </tr>
    <tr>
      <td height="350" rowspan="2" align="right" class="query_t">权限授予</td>
      <td width="12%" align="center" class="query_t">未授权用户(<font color=red><%=rb1.getRowCount()%></font>)</td>
      <td width="12%" class="query_t">&nbsp;</td>
      <td width="46%" align="left" class="query_t">&nbsp;已授权用户(<font color=red><%=rb2.getRowCount()%></font>)</td>
    </tr>
    <tr>
      <td align="center"  class="query_v">
	   <select name="list1" id="list1" size="20" class="t2" ondblclick="moveOption(this, this.form.list2)" style="width:160">
	   	<%
	   	  
	   	 for(int i=0;i<rb1.getRowCount();i++)
	   	 {
	   	%>
              <option value="'<%=rb1.getStringValue("userid",i)%>'"><%=rb1.getStringValue("username",i)%>【<%=rb1.getStringValue("userid",i)%>】</option>
       <%}%>       
      </select>	  </td>
      <td align="center"  class="query_t">
	      <input name="add" type="button" class="t1" value="添加" onclick="moveOption(this.form.list1, this.form.list2)"
 /><br><br>
            <input name="addall" type="button" class="t1" value="全部添加" onclick="moveAllOption(this.form.list1, this.form.list2)"
/><br><br>
            <input name="del" type="button" class="t1" value="删除" onclick="moveOption(this.form.list2, this.form.list1)"
/><br><br>
      <input name="delal" type="button" class="t1" onclick="moveAllOption(this.form.list2, this.form.list1)" value="全部删除" />      </td>
      <td align="left"  class="query_v">
      	<select name="list2" id="list2" size="20" class="t2"  ondblclick="moveOption(this, this.form.list1)"  style="width:160">
      		<%
	   	 
	   	 for(int i=0;i<rb2.getRowCount();i++)
	   	 {
	   	%>
              <option value="'<%=rb2.getStringValue("userid",i)%>'"><%=rb2.getStringValue("username",i)%>【<%=rb2.getStringValue("userid",i)%>】</option>
       <%}%>   
              </select>	  </td>
    </tr>
<!--    <tr>
      <td colspan="4" align="center" height="50">
        <input type="button" name="Submit" value="确定"  class="t1" onclick="selvalue(this.form.list2)" />&nbsp;     
        <input type="button" name="Submit2" value="取消"  class="t1" onclick="selChange()"/>      </td>
    </tr>
-->    
  </table>
  <input type=hidden name=hidname value="" size=120 >
  <input type=hidden name=hidsql value="" size=120 >
  <input type=hidden name=hidareaid value="<%=area%>">
</form>
</body>
</html>
