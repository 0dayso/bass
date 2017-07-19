<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date,java.util.List,java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.Connection"%>
<%@page import="bass.common2.ConnectionManage,java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.math.BigDecimal"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<title>月度预存款余额平衡关系检查表</title>
			<link rel="stylesheet" type="text/css" href="../../css/bass21.css"/>
			<script type="text/javascript" src="../../common2/basscommon.js"></script>
			<link rel="stylesheet" type="text/css" href="../../js/ext3/resources/css/ext-all.css"/>
		 	<script type="text/javascript" src="../../js/ext3/adapter/ext/ext-base.js"></script>
		  	<script type="text/javascript" src="../../js/ext3/ext-all.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js" charset=utf-8></script>
			<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript">
		function doSubmit(){
		   //document.selectform.sdate.value);
		   document.selectform.action = 'financingListforMonth_01.jsp';
		   document.selectform.submit();
		}
		var show = true ;
		function showOneArea(obj,timeid){
		    //alert(obj);
		    if (show == true){
		        tabAdd({title:timeid,url:'${mvcPath}/hbbass/channel/caiwu/financingListAreaforMonth.jsp?area_id='+obj});
		    }else{
		       makeNewWindow('financingListAreaforMonth.jsp?area_id='+obj);
		    }
		    
		   //openhtml_p2(timeid,timeid,'/hbbass/channel/caiwu/financingListAreaforMonth.jsp?area_id='+obj);
		    //makeNewWindow('financingListAreaforMonth.jsp?area_id='+obj);
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
		   
		    document.checkaduit.action = 'financingListforMonth_01.jsp';
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
		   var url = 'downExcelFile.jsp?command=ListMonth&sdate=<%=request.getParameter("sdate")%>';
		   var s = '<%=request.getParameter("sdate")%>';
		   if (s== null){
		       alert('未选择数据!');
		       return ;
		   }
		   if (show == true){		     
		        tabAdd({title:'<%=request.getParameter("sdate")%>'+'(ListMonth)',url:'${mvcPath}/hbbass/channel/caiwu/'+url });   
		    }else{ 
		       makeNewWindow(url);     
		    }
		   }
		</script>
		<%
		        Connection conn = null ;
				PreparedStatement pstmt = null ;
				ResultSet  rst = null ;
				List list = null ;   
		        //加入审核功能
				try{
				if ( request.getParameter("check_bak") != null&& request.getParameter("area_id") != null && request.getParameter("selectData") != null && request.getParameter("pass_id") != null ){
				   
		            conn = ConnectionManage.getInstance().getDWConnection();
		            String sqlString = "select * from nmk.CWKXT_CHECK_LOG where time_id=? and check_area=? ";
		            pstmt = conn.prepareStatement(sqlString);
		            pstmt.setInt(1,Integer.parseInt(request.getParameter("selectData")));
		            pstmt.setString(2,request.getParameter("area_id"));
		            rst = pstmt.executeQuery();
		            //Calendar calendar_1 = Calendar.getInstance();
		             //   DateFormat formater1_1 = new SimpleDateFormat("yyyyMMddhhmmss");
		             //   String checkTime = formater1_1.format(calendar_1.getTime());
		             //   formater1_1.parse(checkTime);
		                Date cdate = new Date();
		                String checkBak = request.getParameter("check_bak") ;
		                checkBak = new String(checkBak.getBytes("iso-8859-1"),"gb2312");
		             
		            if (rst.next()){
		            
		                sqlString = "update nmk.CWKXT_CHECK_LOG set user_name=? ,check_date=? ,check_bak=?,check_result=? where time_id=? and check_area=?";
		                pstmt = conn.prepareStatement(sqlString);
		                pstmt.setString(1,(String)(request.getSession().getAttribute("loginname")));
		                pstmt.setTimestamp(2, new   java.sql.Timestamp(cdate.getTime()));
		                pstmt.setString(3,checkBak);
		                pstmt.setString(4,(request.getParameter("pass_id").equals("1")?"通过":"不通过")); 
		                pstmt.setInt(5,Integer.parseInt(request.getParameter("selectData")));
		                pstmt.setString(6,request.getParameter("area_id"));
   
		                pstmt.execute();
		                out.println("<script language='javascript'> alert('更新审核成功!'); </script>"); 
		                
		            }else{

		                sqlString = "insert into  nmk.CWKXT_CHECK_LOG(time_id,user_name,check_date,check_result,check_bak,check_area) values(?,?,?,?,?,?)";
		                pstmt = conn.prepareStatement(sqlString);
		                pstmt.setInt(1,Integer.parseInt(request.getParameter("selectData")));
		                pstmt.setString(2,(String)(request.getSession().getAttribute("loginname")));
		                pstmt.setTimestamp(3, new   java.sql.Timestamp(cdate.getTime()));
		                pstmt.setString(4,(request.getParameter("pass_id").equals("1")?"通过":"不通过")); 
		                pstmt.setString(5,checkBak);
		                pstmt.setString(6,request.getParameter("area_id"));
   
		                pstmt.execute();
		                out.println("<script language='javascript'> alert('审核保存成功!'); </script>"); 
		            }
		        }
		        }catch(Exception e){
		        	e.printStackTrace();
		            e.fillInStackTrace();
		        }finally{
		           if (rst != null)
		               rst.close();
		           if (conn != null)
		               conn.close();
		        }
		        
		   List titlelist = new ArrayList();
		   titlelist.add("0,全省");
		   titlelist.add("HB.WH,武汉");
		   titlelist.add("HB.HS,黄石");
		   titlelist.add("HB.EZ,鄂州");
		   titlelist.add("HB.YC,宜昌");
		   titlelist.add("HB.ES,恩施");
		   titlelist.add("HB.SY,十堰");
		   titlelist.add("HB.XF,襄樊");
		   titlelist.add("HB.JH,江汉");
		   titlelist.add("HB.XN,咸宁");
		   titlelist.add("HB.JZ,荆州");
		   titlelist.add("HB.JM,荆门");
		   titlelist.add("HB.SZ,随州");
		   titlelist.add("HB.HG,黄冈");
		   titlelist.add("HB.XG,孝感");
		  // StringBuffer sql = new StringBuffer();
		        
				String sDate = null ;
				String startDate = null ;
				String endDate = null ;
				Date cdate = new Date();
               DateFormat formater1 = new SimpleDateFormat("yyyyMM");
                String cString = formater1.format(cdate);
			try{
			
				 // if (request.getParameter("sdate") != null || request.getParameter("selectData") != null ){
				             
				             if (request.getParameter("sdate") != null)
				                    sDate = request.getParameter("sdate");
				             if  (request.getParameter("selectData") != null)
				                    sDate = request.getParameter("selectData"); 
				             if (sDate == null)
				                    sDate = cString;
				               startDate = sDate + "02" ;
				        //out.println("<script language='javascript'> alert('获取数据!sDate"+sDate+"***'); </script>");
				         if (sDate.substring(4,6).equals("12")){
				           endDate = String.valueOf(Integer.parseInt(sDate.substring(0,4)) + 1) + "0101" ;
				         }else{
				            int i = Integer.parseInt(sDate.substring(4,6)) + 1 ;
				            endDate = sDate.substring(0,4) + i +"01";
				         } 
				         // out.println("<script language='javascript'> alert('获取数据!startDate"+startDate+"&&&endDate"+endDate+"'); </script>");          
				        conn = ConnectionManage.getInstance().getDWConnection();
				        
				        StringBuffer sql = new StringBuffer();	
		                 sql.append(" select area_id,t8.boss,t8.balance_m,t8.balance_lm,t8.out_bookcharge,t9.check_result,t9.check_bak from ");
sql.append(" (select t6.area_id,t6.boss,t7.balance_m,t7.balance_lm,t7.out_bookcharge from ");
sql.append(" (select area_id,sum(boss1+boss2+boss3+boss4) as boss from ( ");
 //
sql.append(" select area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx, "); 
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz, "); 
				         sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf, "); 
				         sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan, "); 
				         sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei, "); 
				         sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun, "); 
				         sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng, "); 
				         sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, ");   
				         sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2,  sum(qt_tiaozhang3) as qt_tiaozhang3, sum(in_bookcharge) as in_bookcharge, sum(in_cash) as in_cash, sum(in_plyc) as in_plyc, sum(in_sky) as in_sky, sum(in_dfhq) as in_dfhq,");  
				         sql.append(" sum(Aczka) as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, sum(tiaozheng2) as tiaozheng2, sum(tiaozheng3) as tiaozheng3 ");
				         sql.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2 ");  
				         sql.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3  ");
				         sql.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2 ");  
				         sql.append(" from (  ");
                 sql.append(" select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx, "); 
				         sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,  ");
				         sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf, ");  
				         sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,  ");
				         sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");  
				         sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");  
				         sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");  
				         sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1, "); 
				         sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq, ");  
				         sql.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 "); 
				         sql.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2 "); 
				         sql.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3 "); 
				         sql.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2 "); 
				         sql.append(" from ( "); 
				         sql.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx, "); 
				         sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz, "); 
				         sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf, ");  
				         sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan, "); 
				         sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei, ");  
				         sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun, "); 
				         sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng, "); 
				         sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1, "); 
				         sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq, ");  
				         sql.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day ");  
				         sql.append(" where time_id>=? and time_id<=? group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka "); 
				         sql.append(" ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka ");   
				         sql.append(" ) as t3 group by area_id ");
						  
						 sql.append(" ) as t5 group by area_id) as t6,nmk.CWkxt_check_sum_Month as t7 ");
						 sql.append(" where t7.time_id="+ sDate+" and t6.area_id=t7.area_id ) as t8 left join (select CHECK_RESULT,check_area,check_bak from nmk.CWKXT_CHECK_LOG where time_id="+ sDate+" )as t9 ");
						  
						 sql.append(" on t8.area_id = t9.check_area ");
				         System.out.println(sql.toString());
				        //startDate = "20091102";
				        //endDate = "20091201";
				         pstmt = conn.prepareStatement(sql.toString());
				        pstmt.setInt(1,Integer.parseInt(startDate));
				        pstmt.setInt(2,Integer.parseInt(endDate));
				        
				        rst = pstmt.executeQuery();
				        
				        list = new ArrayList();
				        while (rst.next()){
				          
				          String[] string = new String[7];
				          string[0] = rst.getString("area_id");
				          string[1] = rst.getString("balance_lm");
				          string[2] = rst.getString("boss");
				          string[3] = rst.getString("out_bookcharge");
				          string[4] = rst.getString("balance_m");
				          string[5] = rst.getString("check_result");
				          string[6] = rst.getString("check_bak");
				          list.add(string);
				        }
				        //} 
			  }catch(Exception e){
				 e.printStackTrace();
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
	<% 
   %>
  <form action="" id="selectform" name="selectform" method="post" >
	<div class="divinnerfieldsetsee">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="数据查询区域">
							<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;数据查询区域:
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">	
				<table align="center" width="80%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" >   
					<tr class="dim_row">
					    
						<td class="dim_cell_title" align="right" colspan="2">月份:</td>
						<td class="dim_cell_content" align="left">					
							 <input type="text" value='<%=request.getParameter("sdate")==null?cString:request.getParameter("sdate") %>' id="sdate" name="sdate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
						</td>
						
					</tr>
					<tr class="dim_row">	    
						<td class="dim_cell_content" colspan="6" align="right"><input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;</td>	
				</tr>
				</table>			
			</div>
		</fieldset>
	</div>
	</form>
		<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div_month')"
									title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;数据展示区域： 
								</td>
							</tr>
						</table>  
					</legend>
					<div id="dim_div_month">
					<table border="0" cellspacing="0" cellpadding="0" width="80%" align="center">
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
								<td class="grid_title_blue_noimage" align="center" colspan="18" height="30">
								    <font size="3"><b>月度预存款余额平衡关系检查表</b><font size="2" >(<%=sDate %>)</font></font>				
							    </td>
							    </tr>
							    <tr class="grid-tab-blue">
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">地市</td>
							        <td class="grid_title_blue_noimage" colspan="6" align="center">平衡性检查公式（上期余额＋本月充值－本月划帐＝本期余额）</td>
							       
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">审核通过</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">审核不通过</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">批注</td>
							       <td class="grid_title_blue_noimage" rowspan="2" align="center">查看详情</td>
							    </tr>
							    <Tr class="grid-tab-blue">
							       <td class="grid_title_blue_noimage"  align="center">A、上期预存款余额</td>
							       <td class="grid_title_blue_noimage"  align="center">B、本期充值</td>
							       <td class="grid_title_blue_noimage"  align="center">C、本期划账</td>
							       <td class="grid_title_blue_noimage"  align="center">D、本期余额</td>
							       <td class="grid_title_blue_noimage"  align="center">差异(A+B-C-D)</td>
							       <td class="grid_title_blue_noimage"  align="center">差异率 (A+B-C)/D-1</td>
							    </Tr>
							     
							    <%
							 
							    try {
							    
							    if (titlelist.size()>0){
							       
							        boolean cssR = true ;
							        
							          for (Iterator it = titlelist.iterator();it.hasNext();){
							              cssR =(cssR == true ?  false : true );
							              String[] subTitle = ((String)it.next()).split(",");
							             if (list != null && list.size()>0){
							                //conn2 = ConnectionManage.getInstance().getDWConnection();
							                 //for (String[] str : list){
							                   for (int i=0; i<list.size();i++){
							                      String[] str = (String[]) list.get(i); 
							                     if (str[0].equalsIgnoreCase(subTitle[0])){
							     %>
							     <tr title="双击查看<%=subTitle[1] %>详细数据" class="<%=cssR==true?"grid_row_alt_blue":"grid_row_blue" %>" ondblclick="showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+sDate %>','<%=sDate%>')" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='<%=cssR==true?"grid_row_alt_blue":"grid_row_blue" %>'" >
							         <td class="grid_row_cell">
							            <input type="hidden" name="area_id" id="area_id" value="<%=subTitle[0] %>"><%=subTitle[1] %>
							         </td>
							         <td class="grid_row_cell_number">
							         <%=str[1] %>
							         </td>
							         <td class="grid_row_cell_number">
							         <%=str[2] %>
							         </td>
							         <td class="grid_row_cell_number">
							         <%=str[3] %>
							         </td>
							         <td class="grid_row_cell_number">
							         <%=str[4] %>
							         </td>
							         <td class="grid_row_cell_number">
							         <% 
							            BigDecimal chaiyi = new BigDecimal(str[1]);
							            chaiyi = chaiyi.add(new BigDecimal(str[2]));
							            chaiyi = chaiyi.add((new BigDecimal(str[3])).negate());
							            chaiyi = chaiyi.add((new BigDecimal(str[4])).negate());
							         %>
							         <%=chaiyi.toString() %><a href="javascript:showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+sDate %>','<%=sDate%>')"><img src="./images/<%=(Double.parseDouble(chaiyi.toString())>=0?(Double.parseDouble(chaiyi.toString())==0.00?"right.gif":"up.gif"):"down.gif" )%>" border="0" /></a>
							         </td>
							         <td class="grid_row_cell_number">
							         <% 
							            BigDecimal chaiyilu = new BigDecimal(str[1]);
							            chaiyilu = chaiyilu.add(new BigDecimal(str[2]));
							            chaiyilu = chaiyilu.add((new BigDecimal(str[3])).negate());
							            chaiyilu = chaiyilu.divide(new BigDecimal(str[4]),4);
							            //chaiyilu = chaiyilu.add((new BigDecimal("1")).negate());
							         %>
							         <%=chaiyilu.toString() %>
							         </td>
							         
							          <td class="grid_row_cell">
							      <%//out.println("<script language='javascript'> alert('获取数据!sDate"+sDate+"***'); </script>");
							        if (str[5] == null || str[5].equals("不通过")){
							           %>
							             <input type="button" class="form_button" value="通过" onclick="checkShowBak(check_Conent,'<%=subTitle[0] %>','<%=subTitle[1] %>','1');">
							              <%}else{
							               out.print("<font color='#33CC00'>已通过</font>");
							              }%>
							         </td>
							         <td class="grid_row_cell">
							            <%if (str[5] == null || str[5].equals("通过")){%>
							            <input type="button" class="form_button" value="不通过" onclick="checkShowBak(check_Conent,'<%=subTitle[0] %>','<%=subTitle[1] %>','2');">
							            <%}else{
							               out.print("<font color='#FF0000'>已不通过</font>");
							            } %>
							         </td>
							         <td class="grid_row_cell" title="<%=str[6]==null?"":str[6] %>"><%=str[6]==null?"":str[6] %>
							         </td>
							         <td class="grid_row_cell"><a href="#" ondblclick="showOneArea('<%=subTitle[0]+"&area_name="+subTitle[1]+"&time_id="+sDate %>','<%=sDate%>')" >查看详情</a>
							         </td>
							     </tr>
							    <%
							     
							    break ;
							    }
							    }
							    }
							    }
							    }
							    }catch(Exception e){
							                        e.fillInStackTrace();
							                     }finally{
							                     }
							          
							    
							    %>
							    	
						</table>
					
						<!--  </form>-->
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
							            <input id="selectData" readonly="readonly" name="selectData" type="text" value="<%=sDate%>"></td>
							            
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
							    </div>
				</fieldset>
			</div>
	</body>
</html>