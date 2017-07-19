<%@ page language="java" contentType="text/html; charset=utf-8"
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
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>财务稽核某天某地市数据</title>
			<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/css/bass21.css"/>
			<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js"></script>
			<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/js/ext3/resources/css/ext-all.css"/>
		 	<script type="text/javascript" src="${mvcPath}/hbbass/js/ext3/adapter/ext/ext-base.js"></script>
		  	<script type="text/javascript" src="${mvcPath}/hbbass/js/ext3/ext-all.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/js/datepicker/WdatePicker.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js" charset=utf-8></script>
			<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
			<%
			    //Calendar calendar = Calendar.getInstance();
				//DateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
				//String defaultDate = formater.format(calendar.getTime());
		        
		        DateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
				String defaultDate = null ;
				Calendar calendar = Calendar.getInstance();
		           defaultDate = formater.format(calendar.getTime());
		         String area_id = null ;  
		         //request.getParameter("time_id") = "20110701";
		           //System.out.println(defaultDate);
		        if (request.getParameter("time_id") != null && !request.getParameter("time_id").trim().equals("")){
		           defaultDate = request.getParameter("time_id") ;
		           DateFormat formater1 = new SimpleDateFormat("yyyyMMdd");
		           defaultDate = formater.format(formater1.parse(defaultDate));
		           
		       }    
		       if (request.getParameter("area_id") != null && !request.getParameter("area_id").trim().equals("")){
		           area_id = request.getParameter("area_id") ;
		       }      
		        String area_name = request.getParameter("area_name");
		        //System.out.println(area_name);
		        area_name = new String(area_name.getBytes("iso-8859-1"),"utf-8");
			 %>
		<script type="text/javascript">
		function showAll(){
		    document.selectform.adjust1_1.style.display = "none" ;
		    document.selectform.adjust1.style.display = "block" ;
		    document.selectform.adjust1_1_1.style.display = "none" ;
		    document.selectform.adjust1_2.style.display = "block" ;
		    
		    document.selectform.adjust2_2.style.display = "none" ;
		    document.selectform.adjust2.style.display = "block" ;
		    document.selectform.adjust2_2_1.style.display = "none" ;
		    document.selectform.adjust2_1.style.display = "block" ;
		    
		    document.selectform.adjust3_3.style.display = "none" ;
		    document.selectform.adjust3.style.display = "block" ;
		    document.selectform.adjust3_3_1.style.display = "none" ;
		    document.selectform.adjust3_1.style.display = "block" ;
		    
		    document.selectform.bdjust1_1.style.display = "none" ;
		    document.selectform.bdjust1.style.display = "block" ;
		    document.selectform.bdjust1_1_1.style.display = "none" ;
		    document.selectform.bdjust1_2.style.display = "block" ;
		    
		    document.selectform.bdjust2_2.style.display = "none" ;
		    document.selectform.bdjust2.style.display = "block" ;
		    document.selectform.bdjust2_2_1.style.display = "none" ;
		    document.selectform.bdjust2_1.style.display = "block" ;
		    
		    document.selectform.bdjust3_3.style.display = "none" ;
		    document.selectform.bdjust3.style.display = "block" ;
		    document.selectform.bdjust3_3_1.style.display = "none" ;
		    document.selectform.bdjust3_1.style.display = "block" ;
		    document.selectform.checkSave.style.display = "block" ;
		}
		
		function saveCheck(){
		    var bass1 = document.forms[0].adjust1.value ;
		    var bass1_1 = document.forms[0].adjust1_1.value ;
		    var bass1_1_1 = document.forms[0].adjust1_1_1.value;
		    var bass1_1_2 = document.forms[0].adjust1_2.value;
		    
		    var bass2 = document.forms[0].adjust2.value ;
		    var bass2_2 = document.forms[0].adjust2_2.value ;
		    var bass2_2_1 = document.forms[0].adjust2_2_1.value ;
		    var bass2_2_2 = document.forms[0].adjust2_1.value ;
		    
		    var bass3 = document.forms[0].adjust3.value ;
		    var bass3_3 = document.forms[0].adjust3_3.value ;
		    var bass3_3_1 = document.forms[0].adjust3_3_1.value ;
		    var bass3_3_2 = document.forms[0].adjust3_1.value ;
		    
		    var boss1 = document.forms[0].bdjust1.value ;
		    var boss1_1 = document.forms[0].bdjust1_1.value ;
		    var boss1_1_1 = document.forms[0].bdjust1_1_1.value ;
		    var boss1_1_2 = document.forms[0].bdjust1_2.value ;
		    
		     var boss2 =  document.forms[0].bdjust2_2.value ;
		    var boss2_1 = document.forms[0].bdjust2.value ;
		    var boss2_1_1 = document.forms[0].bdjust2_2_1.value ;
		    var boss2_1_1_1 = document.forms[0].bdjust2_1.value ;
		    
		    var boss3 = document.selectform.bdjust3_3.value ;
		    var boss3_1 = document.selectform.bdjust3.value ;
		    var boss3_1_1 = document.selectform.bdjust3_3_1.value ;
		    var boss3_1_1_1 =  document.selectform.bdjust3_1.value ;
		    
		   
		    if (bass1 != bass1_1 || bass2 != bass2_2 || bass3 != bass3_3 || boss1 != boss1_1 || boss2 != boss2_1 || boss3 != boss3_1  
		           ){   
		        if(confirm("确实是否调整!")){
		           
		           document.selectform.action = 'financingforAreaDay.jsp';
	               document.selectform.submit(); 
		        }    
		    }else{
		       alert("未更改数据!");
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
		        newWindow = window.open(url, "subWindx", windowFeatures);
		    } else {
		        // window is already open, so bring it to the front
		        newWindow.focus();
		    }
		}
		var openhtml = false ;
		 function checkdown(){
		   var url = 'downExcelFile.jsp?command=AreaByDay&time_id=<%=request.getParameter("time_id")%>&area_id=<%=request.getParameter("area_id")%>&area_name=<%=area_name %>';
		   
		   if (openhtml == false){
		       tabAdd({title:<%=request.getParameter("time_id")%>+'AreaByDay', url :'${mvcPath}/hbbass/channel/caiwu/'+url });
		    }else{
		       makeNewWindow(url);
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
						document.getElementById("iam").src="${mvcPath}/hbbass/common2/image/ns-expand.gif";
					}
				}
				else
				{			
					el.flag =0;
					if(objId=="dim_div"){
						document.getElementById("iam").src="${mvcPath}/hbbass/common2/image/ns-collapse.gif";
					}
					obj.style.display = "block";			
				}
			}
		</script>
		<%
		    
		        //String area_name1 = new String(area_name.getBytes("gb2312"),"iso-8859-1");
		        Connection conn = null ;
				PreparedStatement pstmt = null ;
				ResultSet  rst = null ;
				String[] string = null;
				Connection conn1 = null ;
				PreparedStatement pstmt1 = null ;
				//加入保存调整值
				try{
				   
				   
				if (request.getParameter("adjust1")!= null && request.getParameter("adjust2")!= null
				    && request.getParameter("adjust3")!= null && request.getParameter("bdjust1")!= null 
				    && request.getParameter("bdjust2")!= null && request.getParameter("bdjust3")!= null
				    && request.getParameter("time_id") != null && request.getParameter("area_id") != null){
				    //out.println("<script language='javascript'> alert('"+request.getParameter("adjust1")+"'); </script>"); 
				    //out.println("<script language='javascript'> alert('"+request.getParameter("adjust2")+"'); </script>"); 
				    //out.println("<script language='javascript'> alert('"+request.getParameter("adjust3")+"'); </script>"); 
				    //out.println("<script language='javascript'> alert('"+request.getParameter("bdjust1")+"'); </script>"); 
				        String updatesql = "update nmk.CWkxt_check_sum_Day set tiaozheng1=? , tiaozheng2=? ,"+
				         "tiaozheng3=? , qt_tiaozhang1=? ,qt_tiaozhang2=? ,qt_tiaozhang3=?,qt_tzbak1=?,"+
				         "qt_tzbak2=?,qt_tzbak3=?,tz_bak1=?,tz_bak2=?,tz_bak3=? where area_id=? and time_id=?";
				        conn1 = ConnectionManage.getInstance().getDWConnection();
				        pstmt1 = conn1.prepareStatement(updatesql);
				        pstmt1.setBigDecimal(1,new BigDecimal(request.getParameter("adjust1")));
				        pstmt1.setBigDecimal(2,new BigDecimal(request.getParameter("adjust2")));
				        pstmt1.setBigDecimal(3,new BigDecimal(request.getParameter("adjust3")));
				        pstmt1.setBigDecimal(4,new BigDecimal(request.getParameter("bdjust1")));
				        pstmt1.setBigDecimal(5,new BigDecimal(request.getParameter("bdjust2")));
				        pstmt1.setBigDecimal(6,new BigDecimal(request.getParameter("bdjust3")));
				        String str = request.getParameter("bdjust1_2") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(7,str);
				        str = request.getParameter("bdjust2_1") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(8,str);
				        str = request.getParameter("bdjust3_1") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(9,str);
				         str = request.getParameter("adjust1_2") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(10,str);
				         str = request.getParameter("adjust2_1") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(11,str);
				        str = request.getParameter("adjust3_1") ;
				        str =(str != null ? new String(str.getBytes("iso-8859-1"),"gb2312") : "");
				        pstmt1.setString(12,str);
				        
				        pstmt1.setString(13,request.getParameter("area_id"));
				        pstmt1.setInt(14,Integer.parseInt(request.getParameter("time_id")));
				        pstmt1.execute();
				        out.println("<script language='javascript'> alert('更新成功!'); </script>"); 
				       
				    }
				}catch(Exception e){
				    e.fillInStackTrace();
				}finally{
				    if(conn1 != null){
				          conn1.close();
				    }
				}
				
				
				try{
				  if (request.getParameter("time_id") != null && !request.getParameter("time_id").trim().equals("") 
				             && area_id != null ){
				        conn = ConnectionManage.getInstance().getDWConnection();
				        //StringBuffer sql = new StringBuffer();
				        String sql = "";
				        //查询当天某地市公司的数据
				        
				        
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
"      ,sum(SJZF) as SJZF\n" + 
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
"      ,IN_SKY\n" + 
"      ,in_dfhq\n" + 
"      ,Aczka\n" + 
"      ,sum(in_qt) in_qt\n" + 
"      ,sum(tiaozheng1) as tiaozheng1\n" + 
"      ,tz_bak1\n" + 
"      ,sum(tiaozheng2) as tiaozheng2\n" + 
"      ,tz_bak2\n" + 
"      ,sum(tiaozheng3) as tiaozheng3\n" + 
"      ,tz_bak3\n" + 
"      ,sum(balance_qqt + balance_dgdd + balance_szx + balance_qt + hs_qf + hs_dz + sn_yidisf) boss1\n" + 
"      ,sum(tuiyck) as boss2\n" + 
"      ,sum(ws_jiaofei + air_chongzhi + df_huiqun + yj_boss + jt_yewu + SJZF + czka) as boss3\n" + 
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
"              ,IN_SKY\n" + 
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
"           and area_id = ?\n" + 
"         group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,in_cash ,in_plyc ,IN_sky ,in_dfhq ,tz_bak1 ,tz_bak2 ,tz_bak3 ,czka) as t1\n" + 
" group by time_id ,area_id ,qt_tzbak1 ,qt_tzbak2 ,qt_tzbak3 ,tz_bak1 ,tz_bak2 ,tz_bak3 ,in_cash ,in_plyc,IN_SKY ,in_dfhq ,Aczka";
				        pstmt = conn.prepareStatement(sql.toString());
				        pstmt.setInt(1,Integer.parseInt(request.getParameter("time_id")));
				        pstmt.setString(2,area_id);
				        rst = pstmt.executeQuery();
				        if (rst.next()){
				            string = new String[62];
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
				        }
				        
				  }
				}catch(Exception e){
				  e.fillInStackTrace();
				  e.printStackTrace();
				}finally{
				   if (rst != null)
				       rst.close();
				   if (conn != null){
				       conn.close();
				   }    
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
									<img id="iam" flag='1' src="${mvcPath}/hbbass/common2/image/ns-collapse.gif"></img>
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
					<form action="" id="selectform" name="selectform" method="post"> 
					<% if (string.length >0){ %>
						<table align="center" width="99%" class="grid-tab-blue" id="resultTable"
							cellspacing="1" cellpadding="0" border="0">
								<tr class="grid_title_blue_noimage" >
									<td class="grid_title_blue_noimage" align="center" colspan="16" height="30">
									    <font size="3"><b>日平衡关系检查明细表</b></font>				
								    </td>
							    </tr>
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_title_cell" colspan="3" >地市:<%=area_name %></td>
							       <td class="grid_title_cell" colspan="2">时间:<%=defaultDate %></td>
							    </tr>
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;项目</td>
							       <td class="grid_row_cell" >BOSS系统</td>
							       <td class="grid_row_cell_text" >&nbsp;项目</td>
							       <td class="grid_row_cell" >BASS系统</td>
							       <td class="grid_row_cell" >差异</td>
							    </tr>
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;缴费总额</td>
							       <td class="grid_row_cell_number" align="center"><%=string[58]%></td>
							       <td class="grid_row_cell_text" >&nbsp;账本流入</td>
							       <td class="grid_row_cell_number" align="center" ><%=string[59] %></td>
							       <td class="grid_row_cell_number" align="center" ><%=string[60] %><a href="#"><img src="./kpiportal/localres/images/<%=(Double.parseDouble(string[60])>=0?(Double.parseDouble(string[60])==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;一、营业前台收费</td>
							       <td class="grid_row_cell_number" ><%=string[52] %></td>
							       <td class="grid_row_cell_text" >&nbsp;一、账本流入</td>
							       <td class="grid_row_cell_number" ><%=string[39] %></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;预存款~全球通</td>
							       <td class="grid_row_cell_number" ><%=string[2] %></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;现金</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[40] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;预存款~动感地带</td>
							       <td class="grid_row_cell_number" ><%=string[3] %></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;批量预存</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[41] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;预存款~神州行</td>
							       <td class="grid_row_cell_number" ><%=string[4] %></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;空中充值</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[42] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;预存款~其他</td>
							       <td class="grid_row_cell_number" ><%=string[5] %></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;东方惠群</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[43] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" >
							       <td class="grid_row_cell_number"  >&nbsp;收回欠费</td>
							       <td class="grid_row_cell_number" ><%=string[6] %></td>
							       <td class="grid_row_cell_number"><font color="bcbcbc">&nbsp;充值卡</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[44] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;收回呆帐</td>
							       <td class="grid_row_cell_number" ><%=string[7] %></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;其它</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[45] %></font></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;收回坏帐</td>
							       <td class="grid_row_cell_number" ><%=string[8] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;收取押金</td>
							       <td class="grid_row_cell_number" ><%=string[9] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" >
							       <td class="grid_row_cell_number"  >&nbsp;滞纳金</td>
							       <td class="grid_row_cell_number" ><%=string[10] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;减免滞纳金</td>
							       <td class="grid_row_cell_number" ><%=string[11] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" >
							       <td class="grid_row_cell_number"  >&nbsp;省内异地收费</td>
							       <td class="grid_row_cell_number" ><%=string[12] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"><font color="bcbcbc">&nbsp;省际异地收费</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[13] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" >
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;批量赠送</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[14] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  ><font color="bcbcbc">&nbsp;代理商预缴</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[15] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" >
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;票款</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[16] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;二、退费</td>
							       <td class="grid_row_cell_number" ><%=string[53] %></td>
							       <td class="grid_row_cell_text" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;退预存款</td>
							       <td class="grid_row_cell_number" ><%=string[17] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell"  ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"><font color="bcbcbc">&nbsp;退押金</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[18] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell"  ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;现金退费</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[19] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell"  ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;转预存退费</td>
							       <td class="grid_row_cell_number" ><%=string[20] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number" ><font color="bcbcbc">&nbsp;退卡费</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[21] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							   
							     <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;三、其它渠道缴费合计</td>
							       <td class="grid_row_cell_number" ><%=string[54] %></td>
							       <td class="grid_row_cell_text" >&nbsp;二、调整合计</td>
							       <td class="grid_row_cell_number" ><%=string[57] %></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number" >&nbsp;<font color="bcbcbc">银行托收</font></td>
							       <td class="grid_row_cell_number" ><font color="bcbcbc"><%=string[22] %></font></td>
							       <td class="grid_row_cell_number" >&nbsp;调整1</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" >
							       <input type="text"  name="adjust1_1" id="adjust1_1" value="<%=string[46] %>" disabled="disabled" style="display: block"><input  type="text" name="adjust1" id="adjust1" onkeyup="value=value.replace(/[^\d\.-]/g,'')" value="<%=string[46] %>" style="display: none">备注:<input type="text" name="adjust1_1_1" id="adjust1_1_1" value="<%=string[47] %>" disabled="disabled" style="display: block"><input type="text" name="adjust1_2" id="adjust1_2" value="<%=string[47]==null?"":string[47] %>" style="display: none">
							       </td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;网上缴费</td>
							       <td class="grid_row_cell_number" ><%=string[23] %></td>
							       <td class="grid_row_cell_number" >&nbsp;调整2</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" ><input type="text" name="adjust2_2" id="adjust2_2" value="<%=string[48] %>" disabled="disabled" style="display: block"><input type="text" name="adjust2" id="adjust2" value="<%=string[48] %>" onkeyup="value=value.replace(/[^\d\.-]/g,'')" style="display: none">备注:<input type="text" name="adjust2_2_1" id="adjust2_2_1" value="<%=string[49] %>" disabled="disabled" style="display: block"><input type="text" name="adjust2_1" id="adjust2_1" value="<%=string[49]==null?"":string[49] %>" style="display: none"></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;空中充值</td>
							       <td class="grid_row_cell_number" ><%=string[24] %></td>
							       <td class="grid_row_cell_number" >&nbsp;调整3</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" ><input type="text" name="adjust3_3" id="adjust3_3" value="<%=string[50] %>" disabled="disabled" style="display: block"><input type="text" name="adjust3" id="adjust3" value="<%=string[50] %>" onkeyup="value=value.replace(/[^\d\.-]/g,'')" style="display: none">备注:<input type="text" name="adjust3_3_1" id="adjust3_3_1" value="<%=string[51] %>" disabled="disabled" style="display: block"><input type="text" name="adjust3_1" id="adjust3_1" value="<%=string[51]==null?"":string[51] %>"  style="display: none"></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;东方惠群</td>
							       <td class="grid_row_cell_number" ><%=string[25] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;一级BOSS</td>
							       <td class="grid_row_cell_number" ><%=string[26] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;信用A+</td>
							       <td class="grid_row_cell_number" ><%=string[27] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;集团业务</td>
							       <td class="grid_row_cell_number" ><%=string[28] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;充值卡</td>
							       <td class="grid_row_cell_number" ><%=string[29] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;手机充值</td>
							       <td class="grid_row_cell_number" ><%=string[61] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_text"  >&nbsp;四、调整合计</td>
							       <td class="grid_row_cell_number" ><%=string[55] %></td>
							       <td class="grid_row_cell_text" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;省内异地收费结算</td>
							       <td class="grid_row_cell_number" ><%=string[30] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_alt_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_alt_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;营业前台调帐</td>
							       <td class="grid_row_cell_number" ><%=string[31] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							     <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;隔日回退(当日回退的以前费用)</td>
							       <td class="grid_row_cell_number" ><%=string[32] %></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;其它调整1</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" ><input type="text" name="bdjust1_1" id="bdjust1_1" value="<%=string[33] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust1" id="bdjust1" onkeyup="value=value.replace(/[^\d\.-]/g,'')" value="<%=string[33] %>" style="display: none">备注:<input type="text" name="bdjust1_1_1" id="bdjust1_1_1" value="<%=string[34] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust1_2" id="bdjust1_2" value="<%=string[34]==null?"":string[34] %>" style="display: none"></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;其它调整2</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" ><input type="text" name="bdjust2_2" id="bdjust2_2" value="<%=string[35] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust2" id="bdjust2" onkeyup="value=value.replace(/[^\d\.-]/g,'')" value="<%=string[35] %>" style="display: none">备注:<input type="text" name="bdjust2_2_1" id="bdjust2_2_1" value="<%=string[36] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust2_1" id="bdjust2_1" value="<%=string[36]==null?"":string[36] %>" style="display: none"></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_row_cell_number"  >&nbsp;其它调整3</td>
							       <td class="grid_row_cell_number" ondblclick="showAll()" ><input type="text" name="bdjust3_3" id="bdjust3_3" value="<%=string[37] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust3" id="bdjust3" onkeyup="value=value.replace(/[^\d\.-]/g,'')" value="<%=string[37] %>" style="display: none">备注:<input type="text" name="bdjust3_3_1" id="bdjust3_3_1" value="<%=string[38] %>" disabled="disabled" style="display: block"><input type="text" name="bdjust3_1" id="bdjust3_1" value="<%=string[38]==null?"":string[38] %>" style="display: none"></td>
							       <td class="grid_row_cell_number" >&nbsp;</td>
							       <td class="grid_row_cell" ></td>
							       <td class="grid_row_cell" ></td>
							    </tr >
							    <tr class="grid_row_blue"  onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'" align="center">
							      <td colspan="5" class="grid_row_cell" align="center" >
							        <input align="center" type="button" name="checkSave" id="checkSave" onclick="saveCheck()" value="保存" style="display: none" />&nbsp;&nbsp;&nbsp;&nbsp;
							        
							        <input type="hidden" name="time_id" id="time_id" value="<%=request.getParameter("time_id") %>" />
							        <input type="hidden" name="area_id" id="area_id" value="<%=request.getParameter("area_id") %>" />
							        <input type="hidden" name="area_name" id="area_name" value="<%=area_name %>" />
							      </td>
							    </tr>
						</table>
						<%} %>	    
						  </form>
					</div>
				</fieldset>
			</div>
	</body>
	
</html>