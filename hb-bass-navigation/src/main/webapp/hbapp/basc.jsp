<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.asiainfo.bass.components.models.ConnectionManage,java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date,java.util.ArrayList,java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<html>
<%
		Connection conn = null ;
		ResultSet  rst = null ;
		Date cdate = new Date();
        DateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
       String cString = formater1.format(cdate);
            try{   
                //String sql = null;
				//Connection conn = null ;
				PreparedStatement pstmt = null ;
				String startd = request.getParameter("startd") ;
				String endd = request.getParameter("endd") ;
				//ResultSet  rst = null ;
				if (startd==null && endd==null){
				   startd = cString;
				   endd= cString; 
				}
				 //StringBuffer sql = new StringBuffer();
				 String sql = "";
				 List list = null;
				 List newlist = null ;
				if ( startd != null  || !startd.trim().equals("")){
				//System.out.println(1);
				    startd = startd.replace("-","");
				    endd = endd.replace("-","");
				    conn = ConnectionManage.getInstance().getDWConnection();
				    String startid = startd.substring(0,6) + "01";
				   
				       startd = startd.replace("-","");
				       

				      sql= "select time_id, sum(boss1 + boss2 + boss3 + boss4 - bass1 - bass2) as chayi\n" +
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
				       "              ,sum(SJZF) AS SJZF\n" + 
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
				       "              ,Aczka\n" + 
				       "              ,sum(in_qt) in_qt\n" + 
				       "              ,sum(tiaozheng1) as tiaozheng1\n" + 
				       "              ,tz_bak1\n" + 
				       "              ,sum(tiaozheng2) as tiaozheng2\n" + 
				       "              ,tz_bak2\n" + 
				       "              ,sum(tiaozheng3) as tiaozheng3\n" + 
				       "              ,tz_bak3\n" + 
				       "              ,sum(balance_qqt + balance_dgdd + balance_szx + balance_qt + hs_qf + hs_dz + sn_yidisf) boss1\n" + 
				       "              ,sum(tuiyck) as boss2\n" + 
				       "              ,sum(ws_jiaofei + air_chongzhi + df_huiqun + yj_boss + jt_yewu + SJZF + czka) as boss3\n" + 
				       "              ,sum(snydsf_js + yyqt_tiaozheng + geri_huitui + qt_tiaozhang1 + qt_tiaozhang2 + qt_tiaozhang3) as boss4\n" + 
				       "              ,sum(in_bookcharge) as bass1\n" + 
				       "              ,sum(tiaozheng1 + tiaozheng2 + tiaozheng3) as bass2\n" + 
				       "          from (select time_id\n" + 
				       "                      ,area_id\n" + 
				       "                      ,sum(balance_qqt) as balance_qqt                                      /*预存款~全球通 前台收费*/\n" + 
				       "                      ,sum(balance_dgdd) as balance_dgdd                                    /*预存款~动感地带 前台收费*/\n" + 
				       "                      ,sum(balance_szx) as balance_szx                                      /*预存款~神州行 前台收费*/\n" + 
				       "                      ,sum(balance_qt) as balance_qt                                        /*预存款~其他 前台收费*/\n" + 
				       "                      ,sum(hs_qf) as hs_qf                                                  /*收回欠费 前台收费*/\n" + 
				       "                      ,sum(hs_dz) as hs_dz                                                  /*收回呆帐 前台收费*/\n" + 
				       "                      ,sum(hs_hz) as hs_hz                                                  /*收回坏帐 前台收费*/\n" + 
				       "                      ,sum(sq_yajin) as sq_yajin                                            /*收取押金 前台收费*/\n" + 
				       "                      ,sum(zhinajin) as zhinajin                                            /*滞纳金 前台收费*/\n" + 
				       "                      ,sum(jm_zhinajin) as jm_zhinajin                                      /*减免滞纳金 前台收费*/\n" + 
				       "                      ,sum(sn_yidisf) as sn_yidisf                                          /*省内异地收费 前台收费*/\n" + 
				       "                      ,sum(sj_yidisf) as sj_yidisf                                          /*省际异地收费 前台收费*/\n" + 
				       "                      ,sum(pl_zengsong) as pl_zengsong                                      /*批量赠送 前台收费*/\n" + 
				       "                      ,sum(agent_yujiao) as agent_yujiao                                    /*代理商预缴 前台收费*/\n" + 
				       "                      ,sum(piaokuan) as piaokuan                                            /*票款 前台收费*/\n" + 
				       "                      ,sum(tuiyck) as tuiyck                                                /*退预存款 退费*/\n" + 
				       "                      ,sum(tuiyajin) as tuiyajin                                            /*退押金 退费*/\n" + 
				       "                      ,sum(xjtuifei) as xjtuifei                                            /*现金退费 退费*/\n" + 
				       "                      ,sum(zycktuifei) as zycktuifei                                        /*转预存退费 退费*/\n" + 
				       "                      ,sum(tuikafei) as tuikafei                                            /**/\n" + 
				       "                      ,sum(yh_tuoshou) as yh_tuoshou                                        /*银行托收*/\n" + 
				       "                      ,sum(ws_jiaofei) as ws_jiaofei                                        /*网上营业厅*/\n" + 
				       "                      ,sum(air_chongzhi) as air_chongzhi                                    /*空中充值受理(短信方式)*/\n" + 
				       "                      ,sum(df_huiqun) as df_huiqun                                          /*移动e站－东方惠群*/\n" + 
				       "                      ,sum(yj_boss) as yj_boss                                              /*CRM一级BOSS*/\n" + 
				       "                      ,sum(xy_Ajia) as xy_Ajia                                              /*A+业务*/\n" + 
				       "                      ,sum(jt_yewu) as jt_yewu                                              /*集团受理*/\n" + 
				       "                      ,sum(SJZF) as SJZF                                                    /*手机支付*/\n" + 
				       "                      ,sum(czka) czka                                                       /*充值卡*/\n" + 
				       "                      ,sum(snydsf_js) as snydsf_js                                          /*异地收费结算*/\n" + 
				       "                      ,sum(yyqt_tiaozheng) as yyqt_tiaozheng\n" + 
				       "                      ,sum(geri_huitui) as geri_huitui\n" + 
				       "                      ,sum(qt_tiaozhang1) as qt_tiaozhang1\n" + 
				       "                      ,qt_tzbak1\n" + 
				       "                      ,sum(qt_tiaozhang2) as qt_tiaozhang2\n" + 
				       "                      ,qt_tzbak2\n" + 
				       "                      ,sum(qt_tiaozhang3) as qt_tiaozhang3\n" + 
				       "                      ,qt_tzbak3\n" + 
				       "                      ,sum(in_bookcharge) as in_bookcharge\n" + 
				       "                      ,in_cash                                                              /*预付款*/\n" + 
				       "                      ,in_plyc                                                              /*批量预存*/\n" + 
				       "                      ,in_sky                                                               /*代理商空中充值*/\n" + 
				       "                      ,in_dfhq                                                              /*M商充值科目*/\n" + 
				       "                      ,czka as Aczka\n" + 
				       "                      ,sum(in_qt) in_qt\n" + 
				       "                      ,sum(tiaozheng1) as tiaozheng1\n" + 
				       "                      ,tz_bak1\n" + 
				       "                      ,sum(tiaozheng2) as tiaozheng2\n" + 
				       "                      ,tz_bak2\n" + 
				       "                      ,sum(tiaozheng3) as tiaozheng3\n" + 
				       "                      ,tz_bak3\n" + 
				       "                  from nmk.CWkxt_check_sum_Day\n" + 
				       "                 where time_id >= ?\n" + 
				       "                   and time_id <= ?\n" + 
				       "                 group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,tz_bak1 ,tz_bak2 ,tz_bak3 ,czka) as t1\n" + 
				       "         group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,tz_bak1 ,tz_bak2 ,tz_bak3 ,in_cash ,in_plyc ,in_sky ,in_dfhq ,Aczka) as t3\n" + 
				       " group by time_id\n" + 
				       " order by time_id";

				       
				       pstmt = conn.prepareStatement(sql.toString());
				       
				       pstmt.setInt(1,Integer.parseInt(startid));
				       pstmt.setInt(2,Integer.parseInt(endd));
				       rst = pstmt.executeQuery();
				       //System.err.println(rst);
				       list = new ArrayList();
				        //System.out.println(startd);
				       // System.out.println(endd);
				      // if (rst.next()){
				     //  String chay = rst.getString("chayi");
				       //System.out.println(chay);
				     //  double sd = Double.parseDouble(chay);
				     //  System.out.println(sd);
				     // }
				     BigDecimal yuechayi = new BigDecimal(0) ;
				     
				     while (rst.next()){
				         BigDecimal chay = rst.getBigDecimal("chayi");
				         //double sd = Double.parseDouble(chay) * 100;
				            //yuechayi += sd ;
				           yuechayi = yuechayi.add(chay);
				         if (rst.getString("time_id").trim().equals(startd)){
				             String[] strChayi = new String[3] ;
				             strChayi[0] = rst.getString("time_id");
				             strChayi[1] = rst.getBigDecimal("chayi").toString();
				             //BigDecimal   bd   =   new   BigDecimal(yuechayi / 100.00);   
				             strChayi[2] = yuechayi.toString();
				    
				             list.add(strChayi);
				             while (rst.next()){
				                 String[] strChayi1 = new String[3] ;
				                 strChayi1[0] = rst.getString("time_id");
				                 strChayi1[1] = rst.getBigDecimal("chayi").toString();
				                 //double sd1 = Double.parseDouble(rst.getString("chayi")) * 100;
				                 chay = rst.getBigDecimal("chayi");
				                yuechayi = yuechayi.add(chay);
				                    //BigDecimal   bd_1   =   new   BigDecimal( (yuechayi+sd1)/100 );  
				                    strChayi1[2] = yuechayi.toString();
				                 list.add(strChayi1);
				             }
				             break ;
				         }
				     }
				     
				     //加入查看审核
				     newlist = new ArrayList(); 
				     if ( list != null ){
				         //for (String[] string : list){
				         for (int i=0;i<list.size();i++){
				            String[] string = (String[])list.get(i);
				            String[] str = new String[9];
				            str[0] = string[0];
				            str[1] = string[1];
				            str[2] = string[2];
				            StringBuffer selectSQL = new StringBuffer();
				            selectSQL.append("select t3.time_id,t3.user_name,t3.check_date,t3.check_result,t3.check_bak,t1.nopass,t2.pass from ");
				            selectSQL.append(" (select time_id,user_name,check_date,check_result,check_bak from nmk.CWKXT_CHECK_LOG where time_id=? order by check_date desc) as t3,");
				            selectSQL.append(" (select count(*) as nopass from nmk.CWKXT_CHECK_LOG where time_id=? and check_result='不通过') as t1,");
				            selectSQL.append(" (select count(*) as pass from nmk.CWKXT_CHECK_LOG where time_id=? and check_result='通过') as t2");
				            
				            pstmt = conn.prepareStatement(selectSQL.toString());
				            pstmt.setInt(1,Integer.parseInt(string[0]));
				            pstmt.setInt(2,Integer.parseInt(string[0]));
				            pstmt.setInt(3,Integer.parseInt(string[0]));
				            rst = pstmt.executeQuery();
				            if (rst.next()){
				               str[3] = rst.getString("user_name");
				               str[4] = rst.getString("check_date");
				               str[5] = rst.getString("check_result");
				               str[6] = rst.getString("check_bak");
				               str[7] = rst.getString("nopass");
				               str[8] = rst.getString("pass");
				              
				            }
				            if (pstmt != null)
				       		 pstmt.close();
				            newlist.add(str) ;
				            System.out.println(selectSQL.toString());
				         }
				     }
				        
				       //sql = "select * from nmk.CWkxt_check_sum where time_id="+startd;
				  
				}
	
	StringBuffer subx = new StringBuffer();	
	StringBuffer suby = new StringBuffer();
	StringBuffer subxy = new StringBuffer();
		
	if (newlist != null )	{
	    //for (String[] strings : list){
	    for (int  i=0;i<list.size();i++){
	        String[] strings = (String[])list.get(i);
	        subx.append("<category name='"+strings[0]+"' />");
	        suby.append("<set value='"+strings[2]+"' />");
	        subxy.append("<set value='"+strings[1]+"' />");
	    }		
    }else{
         subx.append("<category name='"+0+"' />");
	        suby.append("<set value='"+0+"' />");
	        subxy.append("<set value='"+0+"' />");
    }
 
    StringBuffer sub = new StringBuffer();
    if (subx.length()>0){
   //sub.append("<graph caption='日差异图' PYAxisName='金额' SYAxisName='Quantity' numberPrefix='$' showvalues='0'  numDivLines='4' formatNumberScale='0' decimalPrecision='0' anchorSides='10' anchorRadius='3' anchorBorderColor='009900'>");
 //  sub.append("<graph caption='日差异图' PYAxisName='金额' numberPrefix='￥' showvalues='0'  numDivLines='4' formatNumberScale='0' decimalPrecision='0' anchorSides='10' anchorRadius='3' anchorBorderColor='009900'>");
 //  sub.append("<categories><category name='March' /><category name='April' /><category name='May' /><category name='June' /><category name='July' /></categories>");
 //  sub.append("<dataset seriesName='月累计差异' color='AFD8F8' showValues='0'><set value='25601.34' /><set value='20148.82' /><set value='17372.76' /><set value='35407.15' /><set value='38105.68' /></dataset>");
 //  sub.append("<dataset seriesName='差异' color='F6BD0F' showValues='0' ><set value='57401.85' /><set value='41941.19' /><set value='45263.37' /><set value='117320.16' /><set value='114845.27' /></dataset>");
   //sub.append("<dataset seriesName='Total Quantity' color='8BBA00' showValues='0' parentYAxis='S' ><set value='45000' /><set value='44835' /><set value='42835' /><set value='77557' /><set value='92633' /></dataset>");
   sub.append("<graph baseFontSize='12' caption='日平衡差异图' rotateNames='1' PYAxisName='金额' numberPrefix='￥' showvalues='0'  numDivLines='4' formatNumberScale='0' decimalPrecision='0' anchorSides='10' anchorRadius='3' anchorBorderColor='009900'>");
   sub.append("<categories>"+subx.toString()+"</categories>");
   sub.append("<dataset seriesName='月累计差异' color='AFD8F8' showValues='0'>"+suby.toString()+"</dataset>");
   sub.append("<dataset seriesName='差异' color='F6BD0F' showValues='0' >"+subxy.toString()+"</dataset>");
   
   sub.append("</graph>");
   }else{
      sub.append(" ");
   }
   
 %>
<head>
<title>无滚动测试</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title></title>
<link rel="stylesheet" href="./conf/headerDesign/style.css" type="text/css" />
<script language="JavaScript" src="${mvcPath}/hbapp/resources/chart/FusionCharts.js"></script>
<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
<script type="text/javascript">
		
		var openhtml = true ;
		function showOneArea(obj,timeid){
		    //alert(obj);
		    if (openhtml == false){
		    	console.log("143eee");
		    	makeNewWindow(obj);
		    }else{
		    	tabAdd({title:timeid, url:'${mvcPath}/hbapp/'+obj});
		   }
		}
		
		var newWindow;//定义一个窗口，有利于窗口间的通讯
		
		function makeNewWindow(url) {
		   if (!newWindow || newWindow.closed) {
		        var width = 500;
		        var height = 800;
		        var left = parseInt((screen.availWidth/2) - (width/2));//屏幕居中
		        var top = parseInt((screen.availHeight/2) - (height/2));
		        var windowFeatures = "width=" + width + ",height=" + height + ",scrollbars=yes,toolbar=no,menubar=no,status,resizable,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top;
		        newWindow = window.open(url, "subWindx", windowFeatures);
		    } else {
		        // window is already open, so bring it to the front
		        newWindow.focus();
		    }
		}
		
		function checkdown(){
		   //var url = 'downExcelFile.jsp?command=ListDay&startd=&endd=endd';
		   <%-- var url = 'downExcelFile.jsp?command=ListDay&startd=<%=request.getParameter("startd")+"&endd="+request.getParameter("endd")%>'; --%>
		   var url = 'downExcelFile.jsp?command=ListDay&startd=<%=startd+"&endd="+endd%>';
		   //makeNewWindow(url);
		   if (openhtml == false){
		       makeNewWindow(url);
		    }else{
		    	<%-- openhtml_p2(<%=request.getParameter("startd")%>+'(ListDay)',<%=request.getParameter("startd")%>+'(ListDay)','${mvcPath}/hbbass/channel/caiwu/'+url); --%>
		       tabAdd({title: <%=request.getParameter("startd")%>+'(ListDay)', url: '${mvcPath}/hbbass/channel/caiwu/'+url});
		   }
		    
		}
		function hideTitle(el,objId){
			var obj = document.getElementById(objId);
			if(el.flag ==0)
			{
				el.flag =1;
				el.title="点击隐藏";
				obj.style.display="";
				if(objId=="show_div"){
					obj.style.display="none";
					document.getElementById("picShow").src="${mvcPath}/hbbass/common2/image/ns-expand.gif";
				}
				if(objId=="tableContainer1"){
					obj.style.display="none";
					document.getElementById("datashow").src="${mvcPath}/hbbass/common2/image/ns-expand.gif";
				
				}
			}
			else
			{			
				el.flag =0;
				if(objId=="show_div"){
					document.getElementById("picShow").src="${mvcPath}/hbbass/common2/image/ns-collapse.gif";
				}
				if(objId=="tableContainer1"){				
					document.getElementById("datashow").src="${mvcPath}/hbbass/common2/image/ns-collapse.gif";
				}
				obj.style.display = "block";			
			}
		}
		</script>
<style type="text/css">
<!--
/* 定义页面的基本样式 */
body { background: #FFF; color: #c3daf9;
font: normal normal 12px Verdana, Geneva, Arial, Helvetica, sans-serif;
margin: 10px; padding: 0;}
table, td, a { color: #000; font: normal normal 12px Verdana, Geneva, Arial, Helvetica, sans-serif;}
h1 { font: normal normal 18px Verdana, Geneva, Arial, Helvetica, sans-serif; margin: 0 0 5px 0}
h2 { font: normal normal 16px Verdana, Geneva, Arial, Helvetica, sans-serif; margin: 0 0 5px 0}
h3 { font: normal normal 13px Verdana, Geneva, Arial, Helvetica, sans-serif; color: #008000; margin: 0 0 15px 0}

/* 美化TH元素 */
thead.fixedHeader th {background: #c3daf9; border-left: 1px solid #c3daf9;
border-right: 1px solid #c3daf9; border-top: 1px solid #c3daf9; font-weight: normal;
padding: 4px 3px; text-align: center;}

/* 美化A元素，使表头能够点击 */
thead.fixedHeader a, thead.fixedHeader a:link, thead.fixedHeader a:visited
{ color: #000000; display: block; text-decoration: none; width: 100%;}

/* 美化A元素，使表头能够点击 */
/* 警告: 在WinIE 6.x 下使用hover来切换背景可能会有问题 */
thead.fixedHeader a:hover
{ color: #000000; display: block; text-decoration: underline; width: 100%;}

/* 美化TD元素，使表格行可以间隔显示 */
/* http://www.alistapart.com/articles/zebratables/ */
tbody.scrollContent td, tbody.scrollContent tr.normalRow td
{ background: #FFF; border-bottom: none; border-left: none;
border-right: 1px solid #c3daf9; border-top: 1px solid #DDD; padding: 2px 3px 3px 4px;}
tbody.scrollContent tr.alternateRow td
{ background: #EEE; border-bottom: none; border-left: none;
border-right: 1px solid #c3daf9; border-top: 1px solid #DDD; padding: 2px 3px 3px 4px;}
-->

<!-- 为遵守标准的浏览器实现卷动表格 -->

<!--
/* 创建一个有边的盒子（事实上是为了IE才需要这么做） */
div.tableContainer { clear: both; overflow: hidden;
width: 100%; height: 263px; border: 1px solid #c3daf9;}

/* 定义表格宽度，应该填满外面的容器 */
div.tableContainer table { width: 100%;}

/* 使THEAD元素有block级别的属性，对所有非IE浏览器 */
/* 使TBODY元素的overflow有用，对所有非IE、非Mozilla浏览器 */
thead.fixedHeader { display: block;}

/* 使表格内容可以卷动的定义 */
/* 使TBODY元素有block级别的属性，对所有非IE浏览器 */
/* 使TBODY元素的overflow有用，对所有非IE、非Mozilla浏览器 */
/* 导致的副作用是子节点的TD元素的width: auto属性不再有用了 ,重要对于firefox 单元格收缩了，但是tbody,thead没有收缩！ */
tbody.scrollContent { display: block; height: 260px; overflow: auto; width: 100%;}

/* 分别定义第一、二、三个TH元素的宽度 */
/* 给最后一个TH加16px来填充滚动条的宽度，对所有非IE浏览器 */
/* http://www.w3.org/TR/REC-CSS2/selector.html#adjacent-selectors" target="_new">http://www.w3.org/TR/REC-CSS2/selector.html#adjacent-selectors */
thead.fixedHeader th { width: 5%}
thead.fixedHeader th + th { width: 15%}
thead.fixedHeader th + th + th { width: 15%}
thead.fixedHeader th + th + th + th { width: 15%}
thead.fixedHeader th + th + th + th + th { width: 10%} 
thead.fixedHeader th + th + th + th + th + th { width: 10%}
thead.fixedHeader th + th + th + th + th + th + th { width: 10%}
thead.fixedHeader th + th + th + th + th + th + th + th { width: 10%}
thead.fixedHeader th + th + th + th + th + th + th + th + th { width: 10%}

/* 分别定义第一、二、三个TD元素的宽度 */
/* 对所有非IE浏览器 */
/* http://www.w3.org/TR/REC-CSS2/selector.html#adjacent-selectors" target="_new">http://www.w3.org/TR/REC-CSS2/selector.html#adjacent-selectors */
tbody.scrollContent td { width: 5%}
tbody.scrollContent td + td { width: 15%}
tbody.scrollContent td + td + td { width: 15%}
tbody.scrollContent td + td + td + td { width: 15%}
tbody.scrollContent td + td + td + td + td { width: 15%}
tbody.scrollContent td + td + td + td + td + td { width: 10%}
tbody.scrollContent td + td + td + td + td + td + td { width: 10%}
tbody.scrollContent td + td + td + td + td + td + td + td { width: 10%}
tbody.scrollContent td + td + td + td + td + td + td + td + td { width: 9%}


-->
</style>
<!-- 用表格外围容器的卷动来模拟在IE下的卷动效果 -->
<!--[if IE]>
<style type="text/css">

/* define height and width of scrollable area. Add 16px to width for scrollbar */
div.tableContainer {
clear: both;
height: 285px;
overflow: auto;
/*add by yiminghe ，禁止水平滚动条出现*/
overflow-x:hidden;
}

/* Fit the table inside the container. Width = table width + 16px scrollbar */
div.tableContainer table {
float: left;
width: 100%
}

/* Kill border on right side of table to prevent IE7 sidescrolling */
thead.fixedHeader, tbody.scrollContent {
border-right: none;
}

/* set table header to a fixed position. */
/* In WinIE 6.x, any element with a position property set to relative and is a child of */
/* an element that has an overflow property set, the relative value translates into fixed. */
/* Ex: parent element DIV with a class of tableContainer has an overflow property set to auto 
很神奇，第一次知道overflow + relative == fix 
*/
thead.fixedHeader tr {
position: relative
}

/* Make the table rows the correct height. */
/* Without this, they inherit the TABLE'S height, which is not what we want. 
每个数据行会变得和table一样高
*/
tbody.scrollContent {
height: auto;
}
</style>

<![endif]-->
</head>
<body>
<div class="divinnerfieldset" id="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="图形展示区域">
								<img id="picShow" flag='1' src="${mvcPath}/hbbass/common2/image/ns-collapse.gif"></img>
								&nbsp;图形展示区域:
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
			
				<div class="show_div" id="show_div">
<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
  <tr> 
    <td valign="top" class="text" align="center"> <div id="chartdiv" align="center"> 
        FusionCharts. </div>
      <script type="text/javascript">
		   var chart = new FusionCharts("${mvcPath}/hbbass/common2/Charts/FCF_MSColumn3DLineDY.swf", "ChartId", "900", "350");
		     var strXML = "<%=sub.toString()%>";
		   chart.setDataXML(strXML);	   
		   chart.render("chartdiv");
		</script> </td>
  </tr>
  <tr>
    <td valign="top" class="text" align="center">&nbsp;</td>
  </tr>
  
</table>
</div>
</fieldset>
</div>	
<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'tableContainer1')" title="数据展示区域">
								<img id="datashow" flag='1' src="${mvcPath}/hbbass/common2/image/ns-collapse.gif"></img>
								&nbsp;数据展示区域:
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
		
				
<div id="tableContainer1" class="tableContainer1">
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
   <tr>
     <td  align="right">
        <input type="button" value="下载" id="downLoad" onclick="checkdown()"/>
     </td>
   </tr>
</table>
<div id="tableContainer" class="tableContainer">
<table class="scrollTable" border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<thead class="fixedHeader" align="center">
<tr >
<th><a href="#">时间</a></th>
<th><a href="#">地区</a></th>
<th><a href="#">内容</a></th>
<th><a href="#">差异</a></th>
<th><a href="#">月累计差异</a></th>
<th><a href="#">审核状态</a></th>
<th><a href="#">审核人员</a></th>
<th><a href="#">审核时间</a></th>
<th><a href="#">批注</a></th>
</tr>
</thead>
<%if ( newlist != null ) {
%>
 <tbody class="scrollContent"> 
  
  <% //for (String[] string :newlist){
  for (int i=0;i<newlist.size();i++){
     String[] string = ( String[] )newlist.get(i);
%>

<tr title="双击查看<%=string[0] %>信息" align="center" ondblclick="showOneArea('financingListforDay.jsp?selectData=<%=string[0] %>','<%=string[0] %>');">
<td align="right"><%=string[0] %></td>
<td align="left">湖北全省</td>
<td align="left">财务稽核日表</td>
<td align="right"><%=string[1] %><a href="javascript:showOneArea('financingListforDay.jsp?selectData=<%=string[0] %>','<%=string[0] %>');"><img src="./kpiportal/localres/images/<%=(Double.parseDouble(string[1])>=0?(Double.parseDouble(string[1])==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a></td>
<td align="right"><%=string[2] %><a href="javascript:showOneArea('financingListforDay.jsp?selectData=<%=string[0] %>','<%=string[0] %>');"><img src="./kpiportal/localres/images/<%=(Double.parseDouble(string[2])>=0?(Double.parseDouble(string[2])==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a></td>
<%
   if (string[7] != null){
       if ( 0 < Integer.parseInt(string[7])){
          out.print("<td>不通过</td>");
       }else{
          if ( 14 == Integer.parseInt(string[8])){
             out.print("<td>通过</td>"); 
          }else{
             out.print("<td>部分通过</td>"); 
          }
       }
   }else{
        out.print("<td>未审核</td>"); 
   }
 %>

<td align="left"><%=(string[3] != null ?(string[3].trim().equals("")?"--":string[3]):"--") %></td>
<td align="right"><%=(string[4] != null ?(string[4].trim().equals("")?"--":string[4].substring(0,10)):"--") %></td>
<td align="left"><%=(string[6] != null ?(string[6].trim().equals("")?"--":string[6]):"--") %></td>
</tr>


<%} %>
</tbody>
<% 
}
%>
</table>

</div>
</div>
			</fieldset>
		
</body>
</html>
<%}catch(Exception e){
	e.printStackTrace();
    e.fillInStackTrace();
}finally{
 if (rst != null)
	 rst.close();
	 if (conn != null)
          conn.close();
}
 %>
