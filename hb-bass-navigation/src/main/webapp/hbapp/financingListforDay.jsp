<%@ page language="java" contentType="text/html; charset=utf=-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date,java.util.List,java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.asiainfo.bass.components.models.ConnectionManage,java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>财务某天全省数据</title>
			<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/css/bass21.css"/>
			<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js"></script>
			<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/js/ext3/resources/css/ext-all.css"/>
		 	<script type="text/javascript" src="${mvcPath}/hbbass/js/ext3/adapter/ext/ext-base.js"></script>
		  	<script type="text/javascript" src="${mvcPath}/hbbass/js/ext3/ext-all.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/js/datepicker/WdatePicker.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js" charset=utf-8></script>
			<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
		<script type="text/javascript">
		
		var openhtml = false ;
		function showOneArea(obj){
		    //alert(obj);
		    var url = 'financingforAreaDay.jsp?area_id='+obj;
		    //makeNewWindow(url);
		    //alert(url);
		    if (openhtml == false){
		       makeNewWindow(url);
		    }else{
		       tabAdd({title:'<%=request.getParameter("selectData")%>', url : '/hbbass/channel/caiwu/'+url  });
		   }
		}
		
		var newWindow;//定义一个窗口，有利于窗口间的通讯
		
		function makeNewWindow(url) {
		   if (!newWindow || newWindow.closed) {
		        var width = 600;
		        var height = 800;
		        var left = parseInt((screen.availWidth/2) - (width/2));//屏幕居中
		        var top = parseInt((screen.availHeight/2) - (height/2));
		        var windowFeatures = "width=" + width + ",height=" + height + ",scrollbars=yes,toolbar=no,menubar=no,status,resizable,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top;
		        newWindow = window.open(url, "subWind", windowFeatures);
		    } else {
		        // window is already open, so bring it to the front
		        newWindow.focus();
		    }
		}
		function checkPass(){
		   
		    document.checkaduit.action = 'financingListforDay.jsp';
		    document.checkaduit.submit();
		    
		}
		function countChar(textareaName,spanName)
		{  
		 document.getElementById(spanName).innerHTML = 100 - document.getElementById(textareaName).value.length;
		} 
		
		function checkShowBak(divname,areaId,areaName,passId){
		   if (divname.style.display=='none'){
		       document.checkaduit.area_id.value = areaId ;
		       document.checkaduit.area_Name.value = areaName ;
		       document.checkaduit.pass_id.value = passId ;
		       divname.style.display='block';
		    }else{
		       divname.style.display='none';
		    }
		}
        function checkdown(){
		   var url = 'downExcelFile.jsp?command=ListForDay&selectData=<%=request.getParameter("selectData")%>'
		   //alert(url);
		   //makeNewWindow(url);
		   if (openhtml == true){
		       makeNewWindow(url);
		    }else{
		       tabAdd({title: <%=request.getParameter("selectData")%>+'ListForDay', url : '${mvcPath}/hbbass/channel/caiwu/'+url  });
		   }
		    
		}
        
        function hideTitle(el,objId){
			var obj = document.getElementById(objId);
			if(el.flag ==0)
			{
				el.flag =1;
				el.title="点击隐藏";
				obj.style.display="";
				if(objId=="dim_div"){
					obj.style.display="none";
					document.getElementById("imgs").src="${mvcPath}/hbbass/common2/image/ns-expand.gif";
				}
			}
			else
			{			
				el.flag =0;
				if(objId=="dim_div"){
					document.getElementById("imgs").src="${mvcPath}/hbbass/common2/image/ns-collapse.gif";
				}
				obj.style.display = "block";			
			}
		}
		</script>
		<%
		        Connection conn1 = null ;
				PreparedStatement pstmt1 = null ;
				ResultSet  rst1 = null ;
		        //加入审核功能
				try{
				if ( request.getParameter("check_bak") != null&& request.getParameter("area_id") != null && request.getParameter("selectData") != null && request.getParameter("pass_id") != null ){
				   
		            conn1 = ConnectionManage.getInstance().getDWConnection();
		            String sqlString = "select * from nmk.CWKXT_CHECK_LOG where time_id=? and check_area=? ";
		            pstmt1 = conn1.prepareStatement(sqlString);
		            pstmt1.setInt(1,Integer.parseInt(request.getParameter("selectData")));
		            pstmt1.setString(2,request.getParameter("area_id"));
		            rst1 = pstmt1.executeQuery();
		            //Calendar calendar_1 = Calendar.getInstance();
		             //   DateFormat formater1_1 = new SimpleDateFormat("yyyyMMddhhmmss");
		             //   String checkTime = formater1_1.format(calendar_1.getTime());
		             //   formater1_1.parse(checkTime);
		                Date cdate = new Date();
		                String checkBak = request.getParameter("check_bak") ;
		                checkBak = new String(checkBak.getBytes("iso-8859-1"),"gb2312");
		             
		            if (rst1.next()){
		            
		                sqlString = "update nmk.CWKXT_CHECK_LOG set user_name=? ,check_date=? ,check_bak=?,check_result=? where time_id=? and check_area=?";
		                pstmt1 = conn1.prepareStatement(sqlString);
		                pstmt1.setString(1,(String)(request.getSession().getAttribute("loginname")));
		                pstmt1.setTimestamp(2, new   java.sql.Timestamp(cdate.getTime()));
		                pstmt1.setString(3,checkBak);
		                pstmt1.setString(4,(request.getParameter("pass_id").equals("1")?"通过":"不通过")); 
		                pstmt1.setInt(5,Integer.parseInt(request.getParameter("selectData")));
		                pstmt1.setString(6,request.getParameter("area_id"));
   
		                pstmt1.execute();
		                out.println("<script language='javascript'> alert('更新审核成功!'); </script>"); 
		                
		            }else{

		                sqlString = "insert into  nmk.CWKXT_CHECK_LOG(time_id,user_name,check_date,check_result,check_bak,check_area) values(?,?,?,?,?,?)";
		                pstmt1 = conn1.prepareStatement(sqlString);
		                pstmt1.setInt(1,Integer.parseInt(request.getParameter("selectData")));
		                pstmt1.setString(2,(String)(request.getSession().getAttribute("loginname")));
		                pstmt1.setTimestamp(3, new   java.sql.Timestamp(cdate.getTime()));
		                pstmt1.setString(4,(request.getParameter("pass_id").equals("1")?"通过":"不通过")); 
		                pstmt1.setString(5,checkBak);
		                pstmt1.setString(6,request.getParameter("area_id"));
   
		                pstmt1.execute();
		                out.println("<script language='javascript'> alert('审核保存成功!'); </script>"); 
		            }
		        }
		        }catch(Exception e){
		            e.fillInStackTrace();
		        }finally{
		           if (rst1 != null)
		               rst1.close();
		           if (conn1 != null)
		               conn1.close();
		        }
				//
				DateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
				String defaultDate = null ;
		        if (request.getParameter("selectData") != null || !request.getParameter("selectData").trim().equals("")){
		           defaultDate = request.getParameter("selectData") ;
		           DateFormat formater1 = new SimpleDateFormat("yyyyMMdd");
		           defaultDate = formater.format(formater1.parse(defaultDate));
		        }else{
		           Calendar calendar = Calendar.getInstance();
		           defaultDate = formater.format(calendar.getTime());
		        }
		        
		   List titlelist = new ArrayList();
		   //titlelist.add("0,全省");
		   try{
				Connection cityConn=ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement pst=cityConn.prepareStatement("select area_code,area_name from mk.bt_area");
				ResultSet cityRs=pst.executeQuery();
				while(cityRs.next()){
					titlelist.add(cityRs.getString(1)+","+cityRs.getString(2));
				}
				
				cityRs.close();
				pst.close();
				cityConn.close();
			}catch(Exception ex){ex.printStackTrace();}
		   
		   //StringBuffer sql = new StringBuffer();
		   String sql="";
		        Connection conn = null ;
				PreparedStatement pstmt = null ;
				ResultSet  rst = null ;
				List list = null;
				
				try{
		   if (request.getParameter("selectData") != null || !request.getParameter("selectData").trim().equals("")){

			   sql="select time_id\n" +
			   "      ,area_id\n" + 
			   "      ,sum(balance_qqt) as balance_qqt\n" + 
			   "      ,sum(balance_dgdd) as balance_dgdd\n" + 
			   "      ,sum(balance_szx) as balance_szx\n" + 
			   "      ,sum(balance_qt) as balance_qt\n" + 
			   "      ,sum(hs_qf) as hs_qf\n" + 
			   "      ,sum(hs_dz) as hs_dz\n" + 
			   "      ,sum(hs_hz) as hs_hz\n" + 
			   "      ,sum(sq_yajin) as sq_yajin\n" + 
			   "      ,sum(zhinajin) as zhinajin\n" + 
			   "      ,sum(jm_zhinajin) as jm_zhinajin\n" + 
			   "      ,sum(sn_yidisf) as sn_yidisf\n" + 
			   "      ,sum(sj_yidisf) as sj_yidisf\n" + 
			   "      ,sum(pl_zengsong) as pl_zengsong\n" + 
			   "      ,sum(agent_yujiao) as agent_yujiao\n" + 
			   "      ,sum(piaokuan) as piaokuan\n" + 
			   "      ,sum(tuiyck) as tuiyck\n" + 
			   "      ,sum(tuiyajin) as tuiyajin\n" + 
			   "      ,sum(xjtuifei) as xjtuifei\n" + 
			   "      ,sum(zycktuifei) as zycktuifei\n" + 
			   "      ,sum(tuikafei) as tuikafei\n" + 
			   "      ,sum(yh_tuoshou) as yh_tuoshou\n" + 
			   "      ,sum(ws_jiaofei) as ws_jiaofei\n" + 
			   "      ,sum(air_chongzhi) as air_chongzhi\n" + 
			   "      ,sum(df_huiqun) as df_huiqun\n" + 
			   "      ,sum(yj_boss) as yj_boss\n" + 
			   "      ,sum(xy_Ajia) as xy_Ajia\n" + 
			   "      ,sum(jt_yewu) as jt_yewu\n" + 
			   "      ,sum(SJZF) as SJZF  \n" + 
			   "      ,sum(czka) czka\n" + 
			   "      ,sum(snydsf_js) as snydsf_js\n" + 
			   "      ,sum(yyqt_tiaozheng) as yyqt_tiaozheng\n" + 
			   "      ,sum(geri_huitui) as geri_huitui\n" + 
			   "      ,sum(qt_tiaozhang1) as qt_tiaozhang1\n" + 
			   "      ,qt_tzbak1\n" + 
			   "      ,sum(qt_tiaozhang2) as qt_tiaozhang2\n" + 
			   "      ,qt_tzbak2\n" + 
			   "      ,sum(qt_tiaozhang3) as qt_tiaozhang3\n" + 
			   "      ,qt_tzbak3\n" + 
			   "      ,sum(in_bookcharge) as in_bookcharge\n" + 
			   "      ,in_cash\n" + 
			   "      ,in_plyc\n" + 
			   "      ,in_sky\n" + 
			   "      ,in_dfhq\n" + 
			   "      ,Aczka\n" + 
			   "      ,sum(in_qt) in_qt\n" + 
			   "      ,sum(tiaozheng1) as tiaozheng1\n" + 
			   "      ,tz_bak1\n" + 
			   "      ,sum(tiaozheng2) as tiaozheng2\n" + 
			   "      ,tz_bak2\n" + 
			   "      ,sum(tiaozheng3) as tiaozheng3\n" + 
			   "      ,tz_bak3\n" + 
			   "              ,sum(balance_qqt + balance_dgdd + balance_szx + balance_qt + hs_qf + hs_dz + sn_yidisf) boss1\n" + 
			   "              ,sum(tuiyck) as boss2\n" + 
			   "              ,sum(ws_jiaofei + air_chongzhi + df_huiqun + yj_boss + jt_yewu + SJZF + czka) as boss3\n" + 
			   "      ,sum(snydsf_js + yyqt_tiaozheng + geri_huitui + qt_tiaozhang1 + qt_tiaozhang2 + qt_tiaozhang3) as boss4\n" + 
			   "      ,sum(in_bookcharge) as bass1\n" + 
			   "      ,sum(tiaozheng1 + tiaozheng2 + tiaozheng3) as bass2\n" + 
			   "  from (select time_id\n" + 
			   "              ,area_id\n" + 
			   "              ,sum(balance_qqt) as balance_qqt\n" + 
			   "              ,sum(balance_dgdd) as balance_dgdd\n" + 
			   "              ,sum(balance_szx) as balance_szx\n" + 
			   "              ,sum(balance_qt) as balance_qt\n" + 
			   "              ,sum(hs_qf) as hs_qf\n" + 
			   "              ,sum(hs_dz) as hs_dz\n" + 
			   "              ,sum(hs_hz) as hs_hz\n" + 
			   "              ,sum(sq_yajin) as sq_yajin\n" + 
			   "              ,sum(zhinajin) as zhinajin\n" + 
			   "              ,sum(jm_zhinajin) as jm_zhinajin\n" + 
			   "              ,sum(sn_yidisf) as sn_yidisf\n" + 
			   "              ,sum(sj_yidisf) as sj_yidisf\n" + 
			   "              ,sum(pl_zengsong) as pl_zengsong\n" + 
			   "              ,sum(agent_yujiao) as agent_yujiao\n" + 
			   "              ,sum(piaokuan) as piaokuan\n" + 
			   "              ,sum(tuiyck) as tuiyck\n" + 
			   "              ,sum(tuiyajin) as tuiyajin\n" + 
			   "              ,sum(xjtuifei) as xjtuifei\n" + 
			   "              ,sum(zycktuifei) as zycktuifei\n" + 
			   "              ,sum(tuikafei) as tuikafei\n" + 
			   "              ,sum(yh_tuoshou) as yh_tuoshou\n" + 
			   "              ,sum(ws_jiaofei) as ws_jiaofei\n" + 
			   "              ,sum(air_chongzhi) as air_chongzhi\n" + 
			   "              ,sum(df_huiqun) as df_huiqun\n" + 
			   "              ,sum(yj_boss) as yj_boss\n" + 
			   "              ,sum(xy_Ajia) as xy_Ajia\n" + 
			   "              ,sum(jt_yewu) as jt_yewu\n" + 
			   "              ,sum(SJZF) as SJZF\n" + 
			   "              ,sum(czka) czka\n" + 
			   "              ,sum(snydsf_js) as snydsf_js\n" + 
			   "              ,sum(yyqt_tiaozheng) as yyqt_tiaozheng\n" + 
			   "              ,sum(geri_huitui) as geri_huitui\n" + 
			   "              ,sum(qt_tiaozhang1) as qt_tiaozhang1\n" + 
			   "              ,qt_tzbak1\n" + 
			   "              ,sum(qt_tiaozhang2) as qt_tiaozhang2\n" + 
			   "              ,qt_tzbak2\n" + 
			   "              ,sum(qt_tiaozhang3) as qt_tiaozhang3\n" + 
			   "              ,qt_tzbak3\n" + 
			   "              ,sum(in_bookcharge) as in_bookcharge\n" + 
			   "              ,in_cash\n" + 
			   "              ,in_plyc\n" + 
			   "              ,in_sky\n" + 
			   "              ,in_dfhq\n" + 
			   "              ,czka as Aczka\n" + 
			   "              ,sum(in_qt) in_qt\n" + 
			   "              ,sum(tiaozheng1) as tiaozheng1\n" + 
			   "              ,tz_bak1\n" + 
			   "              ,sum(tiaozheng2) as tiaozheng2\n" + 
			   "              ,tz_bak2\n" + 
			   "              ,sum(tiaozheng3) as tiaozheng3\n" + 
			   "              ,tz_bak3\n" + 
			   "          from nmk.CWkxt_check_sum_Day\n" + 
			   "         where time_id = ?\n" + 
			   "         group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,tz_bak1 ,tz_bak2 ,tz_bak3 ,czka) as t1\n" + 
			   " group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,tz_bak1 ,tz_bak2 ,tz_bak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,Aczka";

			   
			   conn = ConnectionManage.getInstance().getDWConnection();
			   pstmt = conn.prepareStatement(sql.toString());
			   pstmt.setInt(1,Integer.parseInt(request.getParameter("selectData")));
			   rst = pstmt.executeQuery() ;
			   list = new ArrayList();
			   while (rst.next()){
			      String[] string = new String[62];
				            string[0] = rst.getString("time_id");
				            string[1] = rst.getString("area_id");
				            string[2] = rst.getString("balance_qqt");
				            string[3] = rst.getString("balance_dgdd");
				            string[4] = rst.getString("balance_szx");
				            string[5] = rst.getString("balance_qt");
				            string[6] = rst.getString("hs_qf");
				            string[7] = rst.getString("hs_dz");
				            string[8] = rst.getString("hs_hz");
				            string[9] = rst.getString("sq_yajin");
				            string[10] = rst.getString("zhinajin");
				            
				            string[11] = rst.getString("jm_zhinajin");
				            string[12] = rst.getString("sn_yidisf");
				            string[13] = rst.getString("sj_yidisf");
				            string[14] = rst.getString("pl_zengsong");
				            string[15] = rst.getString("agent_yujiao");
				            string[16] = rst.getString("piaokuan");
				            string[17] = rst.getString("tuiyck");
				            string[18] = rst.getString("tuiyajin");
				            string[19] = rst.getString("xjtuifei");
				            string[20] = rst.getString("zycktuifei");
				            
				            string[21] = rst.getString("tuikafei");
				            string[22] = rst.getString("yh_tuoshou");
				            string[23] = rst.getString("ws_jiaofei");
				            string[24] = rst.getString("air_chongzhi");
				            string[25] = rst.getString("df_huiqun");
				            string[26] = rst.getString("yj_boss");
				            string[27] = rst.getString("xy_Ajia");
				            string[28] = rst.getString("jt_yewu");
				            string[29] = rst.getString("czka");
				            string[30] = rst.getString("snydsf_js");
				            
				            string[31] = rst.getString("yyqt_tiaozheng");
				            string[32] = rst.getString("geri_huitui");
				            string[33] = rst.getString("qt_tiaozhang1");
				            string[34] = rst.getString("qt_tzbak1");
				            string[35] = rst.getString("qt_tiaozhang2");
				            string[36] = rst.getString("qt_tzbak2");
				            string[37] = rst.getString("qt_tiaozhang3");
				            string[38] = rst.getString("qt_tzbak3");
				            string[39] = rst.getString("in_bookcharge");
				            string[40] = rst.getString("in_cash");
				            
				            string[41] = rst.getString("in_plyc");
				            string[42] = rst.getString("in_sky");
				            string[43] = rst.getString("in_dfhq");
				            string[44] = rst.getString("Aczka");
				            string[45] = rst.getString("in_qt");
				            string[46] = rst.getString("tiaozheng1");
				            string[47] = rst.getString("tz_bak1");
				            string[48] = rst.getString("tiaozheng2");
				            string[49] = rst.getString("tz_bak2");
				            string[50] = rst.getString("tiaozheng3");
				            
				            string[51] = rst.getString("tz_bak3");
				            string[52] = rst.getString("boss1");
				            string[53] = rst.getString("boss2");
				            string[54] = rst.getString("boss3");  
				            string[55] = rst.getString("boss4");
				            string[56] = rst.getString("bass1");
				            string[57] = rst.getString("bass2");
				            
				            BigDecimal bosssum = new BigDecimal(string[52]);
				            bosssum = bosssum.add(new BigDecimal(string[53]));
				            bosssum = bosssum.add(new BigDecimal(string[54]));
				            bosssum = bosssum.add(new BigDecimal(string[55]));
				            string[58] = bosssum.toString();
				            BigDecimal bosssumbass = new BigDecimal(string[56]);
				            bosssumbass = bosssumbass.add(new BigDecimal(string[57]));
				            string[59] = bosssumbass.toString();
				            bosssumbass = bosssumbass.negate();
				            string[60] = bosssum.add(bosssumbass).toString(); 
				            
				            string[61] = rst.getString("SJZF");
				            
			                         list.add(string);
			   }
		   }
		   }catch(Exception e){
             e.fillInStackTrace();
           }finally{
				 if (rst != null)
					 rst.close();
					 if (conn != null)
				          conn.close();
				}
			
		 %>
	</head>
	<body>
		<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div')"
									title="点击隐藏">
									<img id="imgs" flag='1' src="${mvcPath}/hbbass/common2/image/ns-collapse.gif"></img>
									&nbsp;数据展示区域： 
								</td>
							</tr>
						</table>  
					</legend>
					<div id="dim_div">
					    <table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
   <tr>
     <td  align="right">
        <input type="button" value="下载" id="downLoad" onclick="checkdown()"/>
     </td>
   </tr>
</table>
					<!--  <form action="" id="selectform" name="selectform" method="post" Target="context_set"> -->
						<table align="center" width="99%" class="grid-tab-blue" id="resultTable"
							cellspacing="1" cellpadding="0" border="0">
							    
								<tr class="grid_title_blue_noimage" >
								<td class="grid_title_blue_noimage" align="center" colspan="20" height="30">
								    <font size="3"><b>日平衡关系检查汇总表</b><font size="2" >(<%=defaultDate %>)</font></font>				
							    </td>
							    </tr>
							    <tr class="grid-tab-blue">
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">省份</td>
							       <td class="grid_title_blue_noimage" colspan="10" align="center">1、BOSS系统</td>
							       <td class="grid_title_blue_noimage" colspan="3" align="center">2、BASS系统</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">差异(1减2)</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">月累计差异</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">审核通过</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">审核不通过</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">批注</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">查看详情</td>
							    </tr>
							     <tr class=grid-tab-blue>
							       <td class="grid_title_blue_noimage" align="center">合计</td>
							       <td class="grid_title_blue_noimage" align="center">营业前台收费</td>
							       <td class="grid_title_blue_noimage" align="center">空中充值</td>
							       <td class="grid_title_blue_noimage" align="center">网上缴费</td>
							       <td class="grid_title_blue_noimage" align="center">银行托收</td>
							       <td class="grid_title_blue_noimage" align="center">东方惠群</td>
							       <td class="grid_title_blue_noimage" align="center">手机支付</td>
							       <td class="grid_title_blue_noimage" align="center">一级BOSS</td>
							       <td class="grid_title_blue_noimage" align="center">其它</td>
							       <td class="grid_title_blue_noimage" align="center">调整</td>
							       <td class="grid_title_blue_noimage" align="center">合计</td>
							       <td class="grid_title_blue_noimage" align="center">账本流入</td>
							       <td class="grid_title_blue_noimage" align="center">调整</td>
							    </tr>
							    <%
							    Connection conn2 = null ;
				                PreparedStatement pstmt2 = null ;
				                ResultSet  rst2 = null ;
				                //StringBuffer yueSQL = null ;
				                String curretDate = request.getParameter("selectData");
				                String stratCDate = curretDate.substring(0,6) +"01" ;
				                String yueChayi = null;
							    try {
							    conn2 = ConnectionManage.getInstance().getDWConnection();
							    if (!titlelist.isEmpty()){
							        boolean cssR = true ;
							          for (Iterator it = titlelist.iterator();it.hasNext();){
							              cssR =(cssR == true ?  false : true );
							              String[] subTitle = ((String)it.next()).split(",");
							              if (list != null) {
							              //for (String[] string :list){
							              for (int i=0 ;i<list.size();i++){
							                 String[] string = (String[])list.get(i);
							                 if (subTitle[0].equals(string[1])){
							     %>
							     <tr title="双击查看<%=subTitle[1]%>当天数据" class="<%=cssR==true?"grid_row_alt_blue":"grid_row_blue" %>" ondblclick="showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+request.getParameter("selectData") %>')" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='<%=cssR==true?"grid_row_alt_blue":"grid_row_blue" %>'" >
							         <td class="grid_row_cell">
							            <input type="hidden" name="area_id" id="area_id" value="<%=subTitle[0] %>"><%=subTitle[1] %>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[58]%>
							         </td>
							         <td class="grid_row_cell_number"><%=string[52]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[24]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[23]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[22]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[25]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[61]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[26]%>
							         </td>
							         <% 
							         BigDecimal bossOthersum = new BigDecimal(string[27]);
				                                //bossOthersum = bossOthersum.add(new BigDecimal(string[27]));
				                                bossOthersum = bossOthersum.add(new BigDecimal(string[28]));
				                                bossOthersum = bossOthersum.add(new BigDecimal(string[29]));
							         %>
							         <td class="grid_row_cell_number"><%=bossOthersum.toString()%>
							         </td>
							         <%
							                bossOthersum = new BigDecimal(string[53]);
							                bossOthersum = bossOthersum.add(new BigDecimal(string[55]));
							          %>
							         <td class="grid_row_cell_number" ><%=bossOthersum.toString()%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[59]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[56]%>
							         </td>
							         
							         <td class="grid_row_cell_number" ><%=string[57]%>
							         </td>
							         <td class="grid_row_cell_number" ><%=string[60]%><a href="javascript:showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+request.getParameter("selectData") %>')"><img src="./kpiportal/localres/images/<%=(Double.parseDouble(string[60])>=0?(Double.parseDouble(string[60])==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a>
							         </td>
							         <% 
							            //yueSQL = new StringBuffer();
							         String yueSQL = "";

							         yueSQL="select sum(chayi) as chayiforM\n" +
							         "  from (select time_id ,sum(boss1 + boss2 + boss3 + boss4 - bass1 - bass2) as chayi\n" + 
							         "          from (select time_id\n" + 
							         "                      ,area_id\n" + 
							         "                      ,sum(balance_qqt) as balance_qqt\n" + 
							         "                      ,sum(balance_dgdd) as balance_dgdd\n" + 
							         "                      ,sum(balance_szx) as balance_szx\n" + 
							         "                      ,sum(balance_qt) as balance_qt\n" + 
							         "                      ,sum(hs_qf) as hs_qf\n" + 
							         "                      ,sum(hs_dz) as hs_dz\n" + 
							         "                      ,sum(hs_hz) as hs_hz\n" + 
							         "                      ,sum(sq_yajin) as sq_yajin\n" + 
							         "                      ,sum(zhinajin) as zhinajin\n" + 
							         "                      ,sum(jm_zhinajin) as jm_zhinajin\n" + 
							         "                      ,sum(sn_yidisf) as sn_yidisf\n" + 
							         "                      ,sum(sj_yidisf) as sj_yidisf\n" + 
							         "                      ,sum(pl_zengsong) as pl_zengsong\n" + 
							         "                      ,sum(agent_yujiao) as agent_yujiao\n" + 
							         "                      ,sum(piaokuan) as piaokuan\n" + 
							         "                      ,sum(tuiyck) as tuiyck\n" + 
							         "                      ,sum(tuiyajin) as tuiyajin\n" + 
							         "                      ,sum(xjtuifei) as xjtuifei\n" + 
							         "                      ,sum(zycktuifei) as zycktuifei\n" + 
							         "                      ,sum(tuikafei) as tuikafei\n" + 
							         "                      ,sum(yh_tuoshou) as yh_tuoshou\n" + 
							         "                      ,sum(ws_jiaofei) as ws_jiaofei\n" + 
							         "                      ,sum(air_chongzhi) as air_chongzhi\n" + 
							         "                      ,sum(df_huiqun) as df_huiqun\n" + 
							         "                      ,sum(yj_boss) as yj_boss\n" + 
							         "                      ,sum(xy_Ajia) as xy_Ajia\n" + 
							         "                      ,sum(jt_yewu) as jt_yewu\n" + 
							         "                      ,sum(SJZF) as SJZF\n" + 
							         "                      ,sum(czka) czka\n" + 
							         "                      ,sum(snydsf_js) as snydsf_js\n" + 
							         "                      ,sum(yyqt_tiaozheng) as yyqt_tiaozheng\n" + 
							         "                      ,sum(geri_huitui) as geri_huitui\n" + 
							         "                      ,sum(qt_tiaozhang1) as qt_tiaozhang1\n" + 
							         "                      ,qt_tzbak1\n" + 
							         "                      ,sum(qt_tiaozhang2) as qt_tiaozhang2\n" + 
							         "                      ,qt_tzbak2\n" + 
							         "                      ,sum(qt_tiaozhang3) as qt_tiaozhang3\n" + 
							         "                      ,qt_tzbak3\n" + 
							         "                      ,sum(in_bookcharge) as in_bookcharge\n" + 
							         "                      ,in_cash\n" + 
							         "                      ,in_plyc\n" + 
							         "                      ,in_sky\n" + 
							         "                      ,in_dfhq\n" + 
							         "                      ,Aczka\n" + 
							         "                      ,sum(in_qt) in_qt\n" + 
							         "                      ,sum(tiaozheng1) as tiaozheng1\n" + 
							         "                      ,tz_bak1\n" + 
							         "                      ,sum(tiaozheng2) as tiaozheng2\n" + 
							         "                      ,tz_bak2\n" + 
							         "                      ,sum(tiaozheng3) as tiaozheng3\n" + 
							         "                      ,tz_bak3\n" + 
							         "              ,sum(balance_qqt + balance_dgdd + balance_szx + balance_qt + hs_qf + hs_dz + sn_yidisf) boss1\n" + 
							         "              ,sum(tuiyck) as boss2\n" + 
							         "              ,sum(ws_jiaofei + air_chongzhi + df_huiqun + yj_boss + jt_yewu + SJZF + czka) as boss3\n" + 
							         "                      ,sum(snydsf_js + yyqt_tiaozheng + geri_huitui + qt_tiaozhang1 + qt_tiaozhang2 + qt_tiaozhang3) as boss4\n" + 
							         "                      ,sum(in_bookcharge) as bass1\n" + 
							         "                      ,sum(tiaozheng1 + tiaozheng2 + tiaozheng3) as bass2\n" + 
							         "                  from (select time_id\n" + 
							         "                              ,area_id\n" + 
							         "                              ,sum(balance_qqt) as balance_qqt\n" + 
							         "                              ,sum(balance_dgdd) as balance_dgdd\n" + 
							         "                              ,sum(balance_szx) as balance_szx\n" + 
							         "                              ,sum(balance_qt) as balance_qt\n" + 
							         "                              ,sum(hs_qf) as hs_qf\n" + 
							         "                              ,sum(hs_dz) as hs_dz\n" + 
							         "                              ,sum(hs_hz) as hs_hz\n" + 
							         "                              ,sum(sq_yajin) as sq_yajin\n" + 
							         "                              ,sum(zhinajin) as zhinajin\n" + 
							         "                              ,sum(jm_zhinajin) as jm_zhinajin\n" + 
							         "                              ,sum(sn_yidisf) as sn_yidisf\n" + 
							         "                              ,sum(sj_yidisf) as sj_yidisf\n" + 
							         "                              ,sum(pl_zengsong) as pl_zengsong\n" + 
							         "                              ,sum(agent_yujiao) as agent_yujiao\n" + 
							         "                              ,sum(piaokuan) as piaokuan\n" + 
							         "                              ,sum(tuiyck) as tuiyck\n" + 
							         "                              ,sum(tuiyajin) as tuiyajin\n" + 
							         "                              ,sum(xjtuifei) as xjtuifei\n" + 
							         "                              ,sum(zycktuifei) as zycktuifei\n" + 
							         "                              ,sum(tuikafei) as tuikafei\n" + 
							         "                              ,sum(yh_tuoshou) as yh_tuoshou\n" + 
							         "                              ,sum(ws_jiaofei) as ws_jiaofei\n" + 
							         "                              ,sum(air_chongzhi) as air_chongzhi\n" + 
							         "                              ,sum(df_huiqun) as df_huiqun\n" + 
							         "                              ,sum(yj_boss) as yj_boss\n" + 
							         "                              ,sum(xy_Ajia) as xy_Ajia\n" + 
							         "                              ,sum(jt_yewu) as jt_yewu\n" + 
							         "                              ,sum(SJZF) as SJZF\n" + 
							         "                              ,sum(czka) czka\n" + 
							         "                              ,sum(snydsf_js) as snydsf_js\n" + 
							         "                              ,sum(yyqt_tiaozheng) as yyqt_tiaozheng\n" + 
							         "                              ,sum(geri_huitui) as geri_huitui\n" + 
							         "                              ,sum(qt_tiaozhang1) as qt_tiaozhang1\n" + 
							         "                              ,qt_tzbak1\n" + 
							         "                              ,sum(qt_tiaozhang2) as qt_tiaozhang2\n" + 
							         "                              ,qt_tzbak2\n" + 
							         "                              ,sum(qt_tiaozhang3) as qt_tiaozhang3\n" + 
							         "                              ,qt_tzbak3\n" + 
							         "                              ,sum(in_bookcharge) as in_bookcharge\n" + 
							         "                              ,in_cash\n" + 
							         "                              ,in_plyc\n" + 
							         "                              ,in_sky\n" + 
							         "                              ,in_dfhq\n" + 
							         "                              ,czka as Aczka\n" + 
							         "                              ,sum(in_qt) in_qt\n" + 
							         "                              ,sum(tiaozheng1) as tiaozheng1\n" + 
							         "                              ,tz_bak1\n" + 
							         "                              ,sum(tiaozheng2) as tiaozheng2\n" + 
							         "                              ,tz_bak2\n" + 
							         "                              ,sum(tiaozheng3) as tiaozheng3\n" + 
							         "                              ,tz_bak3\n" + 
							         "                          from nmk.CWkxt_check_sum_Day\n" + 
							         "                         where time_id >= ?\n" + 
							         "                           and time_id <= ?\n" + 
							         "                           and area_id = ?\n" + 
							         "                         group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,tz_bak1 ,tz_bak2 ,tz_bak3 ,czka) as t1\n" + 
							         "                 group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,tz_bak1 ,tz_bak2 ,tz_bak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,Aczka) as t3\n" + 
							         "         group by time_id) as t4";

							            
							            pstmt2 = conn2.prepareStatement(yueSQL);
							            pstmt2.setInt(1,Integer.parseInt(stratCDate));
							            pstmt2.setInt(2,Integer.parseInt(curretDate));
							            pstmt2.setString(3,subTitle[0]);
							            rst2 = pstmt2.executeQuery();
							            
							            if (rst2.next()){
							                yueChayi = rst2.getString("chayiforM");
							                
							            }
							         %>
							         <td class="grid_row_cell_number" ><%= yueChayi== null ? "--" : yueChayi %><a href="javascript:showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+request.getParameter("selectData") %>')"><img src="./kpiportal/localres/images/<%=(Double.parseDouble(yueChayi)>=0?(Double.parseDouble(yueChayi)==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a>
							         </td>
							         <td class="grid_row_cell">
							             <%
							             String passSQL = "select check_result,check_bak from nmk.CWKXT_CHECK_LOG where time_id=? and check_area=?";
							             pstmt2 = conn2.prepareStatement(passSQL);
							             pstmt2.setInt(1,Integer.parseInt(curretDate));
							             pstmt2.setString(2,subTitle[0]);
							             //out.println("<script language='javascript'> alert('"+1+"'); </script>"); 
							             rst2 = pstmt2.executeQuery();
							             String passId = null ;
							             String bak = null;
							             if (rst2.next()){
							                passId = rst2.getString("check_result");
							                bak = rst2.getString("check_bak");
							             }
							             
							             if (passId == null || passId.equals("不通过")){ %>
							             <input type="button" class="form_button" value="通过" onclick="checkShowBak(check_Conent,'<%=subTitle[0] %>','<%=subTitle[1] %>','1');">
							              <%}else{
							                out.print("<font color='#33CC00'>已通过</font>");
							              } %>
							         </td>
							         <td class="grid_row_cell">
							            <%if (passId == null || passId.equals("通过")){ %>
							            <input type="button" class="form_button" value="不通过" onclick="checkShowBak(check_Conent,'<%=subTitle[0] %>','<%=subTitle[1] %>','2');">
							            <%}else{
							                out.print("<font color='#FF0000'>已不通过</font>");
							              } %>
							         </td>
							         <%
							              if (bak == null || bak.trim().equals(""))
							                  bak = "";
							        
							             %>
							         <td class="grid_row_cell" title="<%=bak %>">
							            <%=bak %>
							         </td>
							         <td class="grid_row_cell"><a href="#" onclick="showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+request.getParameter("selectData") %>')">查看详情</a>
							         </td>
							     </tr>
							    <%
							      break;
							    }
							    }
							    }
							          } 
							    } 
							    }catch(Exception e){
							       e.fillInStackTrace();
							    }finally{
							     if (rst2 != null)
							         rst2.close();
							      if (conn2 != null)
							         conn2.close();   
							    }
							    %>
							   	
						</table>
					
						<!--  </form>
					</div>
					            <div id="check_Conent" style="display:none;">-->
					            <div id="check_Conent" style="display:none;">
	<div style="width:100%;height:200%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='${mvcPath}/hbbass/js/ext202/resources/images/default/qtip/close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
					            <form name="checkaduit" id="checkaduit" action="" method="post">
					            <table align="center" width="99%" class="grid-tab-blue" id="resultTable"
							              cellspacing="1" cellpadding="0" border="0">
							        <tr class="grid_row_blue" >
							            <td class="grid_row_cell">地市:<input id="area_id" name="area_id" readonly="readonly" type="hidden" value="">
							            <input id="area_Name" name="area_Name" readonly="readonly" type="text" value=""></td>
							         </tr>
							         <tr class="grid_row_blue" >  
							            <td class="grid_row_cell">时间:<input type="hidden" name="pass_id" id="pass_id" value="" />
							            <input id="selectData" readonly="readonly" name="selectData" type="text" value="<%=request.getParameter("selectData")%>"></td>
							            
							        </tr> 
							         <tr class="grid_row_blue" >
							            <td class="grid_row_cell" >审核人:<input id="check_name" name="check_name" readonly="readonly" type="text" value="<%=request.getSession().getAttribute("loginname") %>"></td>
							            
							        </tr>    
							        <tr class="grid_row_blue" >
								       <td colspan="17" class="grid_row_cell" align="center"  >
								              意见或备注:<textarea id="check_bak"  name="check_bak" rows="6" cols="40" onkeydown='countChar("check_bak","counter");' onkeyup='countChar("check_bak","counter");'></textarea>
								       </td>
							        </tr>
								    <tr class="grid_row_blue" >
								       <td colspan="17" class="grid_row_cell" align="center"  >
								              可以输入<span id="counter">100</span>字<br/>
								       </td>
								    </tr>
								    <tr class="grid_row_blue" >
								       <td colspan="17" class="grid_row_cell" align="center"  >
								             <input type="button" class="form_button" value="确定" onclick="checkPass();"/>
								       </td>
								    </tr>
								    </table>
								    </form>
							   <!--   </div>-->
							   </div>
	</div>
				</fieldset>
			</div>
		
	</body>
</html>