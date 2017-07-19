<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Date,java.util.List,java.util.ArrayList"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common2.ConnectionManage,java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.math.BigDecimal,java.util.Iterator"%>
<%@page import="jxl.write.WritableFont,jxl.write.WritableFont,jxl.write.WritableCellFormat"%>
<%@page import="java.io.IOException,java.io.OutputStream,jxl.Workbook,jxl.write.Label,jxl.write.WritableSheet"%>
<%@page import="jxl.write.WritableWorkbook,jxl.write.WriteException,jxl.write.biff.RowsExceededException"%>
<%@page import="jxl.format.Colour"%>
<%-- <%@page import="java.util.Iterator;"%> --%>
<!DOCTYPE   html   PUBLIC   "-//W3C//DTD   XHTML   1.0   Strict//EN"   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>

<title>财务</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<script type="text/javascript" src="../../common2/basscommon.js"
	charset=utf-8></script>
<script type="text/javascript" src="default.js" charset=utf-8></script>
<script type="text/javascript"
	src="${mvcPath}/hbbass/report/financing/dim_conf.js" charset=utf-8></script>

<script type="text/javascript" src="../../js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="../../css/bass21.css" />
</head>

<body>
	<%
        String command = request.getParameter("command");
              Connection conn = null ;
		      PreparedStatement pstmt = null ;
		      ResultSet  rst = null ;
		      StringBuffer sql = null;
		  //格式
		      //title1主标题格式
		      WritableFont font1 = new WritableFont(WritableFont.TIMES, 20,
						WritableFont.BOLD);
				WritableCellFormat title1 = new WritableCellFormat(font1);
				title1.setAlignment(jxl.format.Alignment.CENTRE); // 水平对齐
				title1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				//副标题
				// 表格头栏目的格式
				WritableFont font2 = new WritableFont(WritableFont.TIMES, 12,
						WritableFont.NO_BOLD);
				WritableCellFormat title2 = new WritableCellFormat(font2);
				title2.setAlignment(jxl.format.Alignment.CENTRE); // 水平对齐
				title2.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title2.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title2.setWrap(true);
				//title2.setBackground(jxl.format.Colour.ORANGE); 
				//设置内容格式--居中
				WritableFont font3 = new WritableFont(WritableFont.TIMES, 10,
						WritableFont.NO_BOLD);
				WritableCellFormat title3 = new WritableCellFormat(font3);
				title3.setAlignment(jxl.format.Alignment.CENTRE); // 水平对齐
				title3.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title3.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title3.setWrap(true);
				//设置内容格式--居右
				WritableFont font3_R = new WritableFont(WritableFont.TIMES, 10,
						WritableFont.NO_BOLD);
				WritableCellFormat title3_R = new WritableCellFormat(font3_R);
				title3_R.setAlignment(jxl.format.Alignment.RIGHT); // 水平对齐
				title3_R.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title3_R.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title3_R.setWrap(true);
				//设置内容格式--居右(字体变灰)
				WritableFont font3_RR = new WritableFont(WritableFont.TIMES, 10,
						WritableFont.NO_BOLD);
						font3_RR.setColour(jxl.format.Colour.GRAY_80);
				WritableCellFormat title3_RR = new WritableCellFormat(font3_RR);
				title3_RR.setAlignment(jxl.format.Alignment.RIGHT); // 水平对齐
				title3_RR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title3_RR.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title3_RR.setWrap(true);
				//设置内容格式--居左
				WritableFont font3_L = new WritableFont(WritableFont.TIMES, 10,
						WritableFont.NO_BOLD);
				WritableCellFormat title3_L = new WritableCellFormat(font3_L);
				title3_L.setAlignment(jxl.format.Alignment.LEFT); // 水平对齐
				title3_L.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title3_L.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title3_L.setWrap(true);
				//设置内容格式--居左(字体变灰)
				WritableFont font3_LL = new WritableFont(WritableFont.TIMES, 10,
						WritableFont.NO_BOLD);
						font3_LL.setColour(jxl.format.Colour.GRAY_80);
				WritableCellFormat title3_LL = new WritableCellFormat(font3_LL);
				title3_LL.setAlignment(jxl.format.Alignment.LEFT); // 水平对齐
				title3_LL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 垂直对齐
				title3_LL.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				title3_LL.setWrap(true);
				//title3.setBackground(jxl.format.Colour.ORANGE); 
				//设置数字格式
				jxl.write.NumberFormat fontNum = new jxl.write.NumberFormat("###,###,##0.00");
                jxl.write.WritableCellFormat titleNum = new jxl.write.WritableCellFormat(fontNum);
                titleNum.setBorder(jxl.format.Border.ALL,
								jxl.format.BorderLineStyle.THIN); // 设置边框
				titleNum.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);				
				titleNum.setWrap(true);
				
				
        if (command != null){
           response.setContentType("application/vnd.ms-excel");
           OutputStream os = null;//response.getOutputStream();
		   WritableWorkbook wwb = null;//Workbook.createWorkbook(os);
		      
		      List list = null ;
		      List newlist = null ;
		      conn = ConnectionManage.getInstance().getDWConnection();
		   try {
            if ("ListDay".equalsIgnoreCase(command) && request.getParameter("startd")!= null && request.getParameter("endd")!= null){
                String title = "营收日平衡性检查" ;
                title = new String(title.getBytes("gb2312"),"iso-8859-1");
                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");
                 
					os = response.getOutputStream();
					wwb = Workbook.createWorkbook(os);
					String startd = request.getParameter("startd");
					startd = new String(startd.getBytes("iso-8859-1"),"gb2312");
					String endd = request.getParameter("endd");
					endd = new String(endd.getBytes("iso-8859-1"),"gb2312");
					startd = startd.replace("-","");
				    endd = endd.replace("-","");
					 WritableSheet wsheet = wwb.createSheet("第一页("+ startd +"~" + endd+")",0);
					 wsheet.mergeCells(0,0,8,0);
					 //wsheet.setRowView(0,25);
					 jxl.write.Number numberCell = null;
					 Label label = new Label(0,0,"营收日平衡性检查("+ startd +"~" + endd+")",title1);					  
					    wsheet.addCell(label);
					    for (int i = 0; i < 9; i++) {
					      wsheet.setColumnView(i, 18); // 设置列宽
				      }
					    label = new Label(0,1,"时间",title2);
					    wsheet.addCell(label);
					    label = new Label(1,1,"地区",title2);
					    wsheet.addCell(label);
					    label = new Label(2,1,"内容",title2);
					    wsheet.addCell(label);
					    label = new Label(3,1,"差异",title2);
					    wsheet.addCell(label);
					    label = new Label(4,1,"月累计差异",title2);
					    wsheet.addCell(label);
					    label = new Label(5,1,"审核状态",title2);
					    wsheet.addCell(label);
					    label = new Label(6,1,"审核人",title2);
					    wsheet.addCell(label);
                        label = new Label(7,1,"审核时间",title2);
					    wsheet.addCell(label);
					    label = new Label(8,1,"批注",title2);
					    wsheet.addCell(label);
                      
                      //加载数据
					    startd = startd.replace("-","");
				        endd = endd.replace("-","");
				        //conn = ConnectionManage.getInstance().getDWConnection();
				        String startid = startd.substring(0,6) + "01";
				        sql = new StringBuffer();
					     sql.append("select time_id,sum(boss1+boss2+boss3+boss4-bass1-bass2) as chayi from ( ");
							            
			            ///
			            sql.append("select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3");
				        sql.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2");
				        sql.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3");
				        sql.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2");
				        sql.append(" from (");
				        sql.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day");
				        sql.append(" where time_id>=? and time_id<=?  group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka");
				        sql.append(" ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka");
				        
                        //
				         sql.append(" ) as t3 group by time_id order by time_id ");
				       System.out.println(sql.toString());
				       pstmt = conn.prepareStatement(sql.toString());
				       pstmt.setInt(1,Integer.parseInt(startid));
				       pstmt.setInt(2,Integer.parseInt(endd));
				       rst = pstmt.executeQuery();
				       System.out.println("ss");
				       list = new ArrayList();
				   
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
				         
				        // System.out.println("ss");
				     }
				     
				     //加入查看审核
				     newlist = new ArrayList(); 
				     if ( list != null ){
				         
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
				            newlist.add(str) ;
				         }
				     }
                      //数据加载完毕
                      int rowNum = 1 ;
                      //int colNum = 0 ; 
					 if ( newlist != null ) {
					    for (int i=0;i<newlist.size();i++){
                             String[] string = ( String[] )newlist.get(i);
                                rowNum++;
                                
					            label = new Label(0,rowNum," "+string[0],title3);
					            wsheet.addCell(label);
					            label = new Label(1,rowNum,"湖北全省",title3);
					            wsheet.addCell(label);
					            label = new Label(2,rowNum,"财务稽核日表",title3);
					            wsheet.addCell(label);
					            numberCell = new jxl.write.Number(3,rowNum,Double.parseDouble(string[1]),titleNum);
					            wsheet.addCell(numberCell);
					            numberCell = new jxl.write.Number(4,rowNum,Double.parseDouble(string[2]),titleNum);
					            wsheet.addCell(numberCell);
					            label = new Label(5,rowNum,(string[7]!=null?(Integer.parseInt(string[7])>0?"不通过":(14 == Integer.parseInt(string[8])?"通过":"部分通过")):"--"),title3);
					            wsheet.addCell(label);
					            label = new Label(6,rowNum,(string[3] != null ?(string[3].trim().equals("")?"--":string[3]):"--"),title3);
					            wsheet.addCell(label);
					            label = new Label(7,rowNum,(string[4] != null ?(string[4].trim().equals("")?"--":string[4].substring(0,10)):"--"),title3);
					            wsheet.addCell(label);
					            label = new Label(8,rowNum,(string[6] != null ?(string[6].trim().equals("")?"--":string[6]):"--"),title3);
					            wsheet.addCell(label);
					             
                        }     
					 }
                     rst.close();
                     conn.close();
                     wwb.write();
					 if(wwb != null){
						 wwb.close();
						 wwb = null;
					 }
					 os.close();
					 response.flushBuffer();
					 }
					 
					if ("ListForDay".equalsIgnoreCase(command) && request.getParameter("selectData")!= null){
					   //数据加载
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
						 	   if (request.getParameter("selectData") != null || !request.getParameter("selectData").trim().equals("")){
						 	   sql= new StringBuffer();
		                sql.append("select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3");
				        sql.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2");
				        sql.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3");
				        sql.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2");
				        sql.append(" from (");
				        sql.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day");
				        sql.append(" where time_id=? group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka");
				        sql.append("  ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka");
				        
			   
			   //conn = ConnectionManage.getInstance().getDWConnection();
			   pstmt = conn.prepareStatement(sql.toString());
			   pstmt.setInt(1,Integer.parseInt(request.getParameter("selectData")));
			   rst = pstmt.executeQuery() ;
			   list = new ArrayList();
			   while (rst.next()){
			      String[] string = new String[61];
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
				            
			                         list.add(string);
			   }
			   
		   }  
			//数据加载完毕	
			     String title = "日平衡关系检查汇总表" ;
                title = new String(title.getBytes("gb2312"),"iso-8859-1");
                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");
                 
					os = response.getOutputStream();
					wwb = Workbook.createWorkbook(os);
			        String selectData = request.getParameter("selectData");
					selectData = new String(selectData.getBytes("iso-8859-1"),"utf-8");
			    	 WritableSheet wsheet = wwb.createSheet("第一页("+ selectData +")",0);
					 wsheet.mergeCells(0,0,17,0);
					 //wsheet.setRowView(0,25);
					 jxl.write.Number numberCell = null;
					 Label label = new Label(0,0,"日平衡关系检查汇总表("+ selectData +")",title1);					  
					    wsheet.addCell(label);
					    for (int i = 0; i < 17; i++) {
					      wsheet.setColumnView(i, 12); // 设置列宽
				      }
				        wsheet.mergeCells(0,1,0,2);
				         label = new Label(0,1,"省份",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(1,1,8,1);
					    label = new Label(1,1,"1、BOSS系统",title2);
					    wsheet.addCell(label);
					    label = new Label(1,2,"合计",title2);
					    wsheet.addCell(label);       
					    label = new Label(2,2,"营业前台收费",title2);
					    wsheet.addCell(label);
					    label = new Label(3,2,"空中充值",title2);
					    wsheet.addCell(label);
					    label = new Label(4,2,"网上缴费",title2);
					    wsheet.addCell(label);
					    label = new Label(5,2,"银行托收",title2);
					    wsheet.addCell(label);
					    label = new Label(6,2,"东方惠群",title2);
					    wsheet.addCell(label);
					    label = new Label(7,2,"其它",title2);
					    wsheet.addCell(label);
					    label = new Label(8,2,"调整",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(9,1,11,1);
					    label = new Label(9,1,"2、BASS系统",title2);
					    wsheet.addCell(label);   
					    label = new Label(9,2,"合计",title2);
					    wsheet.addCell(label);
					    label = new Label(10,2,"账本流入",title2);
					    wsheet.addCell(label);
					    label = new Label(11,2,"调整",title2);
					    wsheet.addCell(label); 
					    wsheet.mergeCells(12,1,12,2);
					    label = new Label(12,1,"差异(1减2)",title2);
					    wsheet.addCell(label); 
					    wsheet.mergeCells(13,1,13,2);
					    label = new Label(13,1,"月累计差异",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(14,1,14,2);
					    label = new Label(14,1,"审核通过",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(15,1,15,2);
					    label = new Label(15,1,"审核不通过",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(16,1,16,2);
					    label = new Label(16,1,"批注",title2);
					    wsheet.addCell(label);
					    wsheet.mergeCells(17,1,17,2);
					    label = new Label(17,1,"查看详情",title2);
					    wsheet.addCell(label);
					    int rowNum = 2 ;
					      
					    if (!titlelist.isEmpty()){
					       for (Iterator it = titlelist.iterator();it.hasNext();){
					          String[] subTitle = ((String)it.next()).split(",");
					          if (list != null) {
					              for (int i=0 ;i<list.size();i++){
					                 String[] string = (String[])list.get(i);
							                 if (subTitle[0].equals(string[1])){
							                     rowNum++;
							                     label = new Label(0,rowNum,subTitle[1],title3);
					                             wsheet.addCell(label);
					                             numberCell = new jxl.write.Number(1,rowNum,Double.parseDouble(string[58]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(2,rowNum,Double.parseDouble(string[52]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(3,rowNum,Double.parseDouble(string[24]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(4,rowNum,Double.parseDouble(string[23]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(5,rowNum,Double.parseDouble(string[22]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(6,rowNum,Double.parseDouble(string[25]),titleNum);
					                             wsheet.addCell(numberCell);
					                             BigDecimal bossOthersum = new BigDecimal(string[26]);
				                                bossOthersum = bossOthersum.add(new BigDecimal(string[27]));
				                                bossOthersum = bossOthersum.add(new BigDecimal(string[28]));
				                                bossOthersum = bossOthersum.add(new BigDecimal(string[29]));
					                             numberCell = new jxl.write.Number(7,rowNum,Double.parseDouble(bossOthersum.toString()),titleNum);
					                             wsheet.addCell(numberCell);
					                             bossOthersum = new BigDecimal(string[53]);
							                    bossOthersum = bossOthersum.add(new BigDecimal(string[55]));
							                    numberCell = new jxl.write.Number(8,rowNum,Double.parseDouble(bossOthersum.toString()),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(9,rowNum,Double.parseDouble(string[59]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(10,rowNum,Double.parseDouble(string[56]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(11,rowNum,Double.parseDouble(string[57]),titleNum);
					                             wsheet.addCell(numberCell);
					                             numberCell = new jxl.write.Number(12,rowNum,Double.parseDouble(string[60]),titleNum);
					                             wsheet.addCell(numberCell);
					                             //
					                          StringBuffer   yueSQL = new StringBuffer();
							            yueSQL.append("select sum(chayi) as chayiforM from (");
							            yueSQL.append(" select time_id,sum(boss1+boss2+boss3+boss4-bass1-bass2) as chayi from ( ");
							            
							            ///
							            yueSQL.append("select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
								        yueSQL.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
								        yueSQL.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
								        yueSQL.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
								        yueSQL.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
								        yueSQL.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
								        yueSQL.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
								        yueSQL.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
								        yueSQL.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
								        yueSQL.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3");
								        yueSQL.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2");
								        yueSQL.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3");
								        yueSQL.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2");
								        yueSQL.append(" from (");
								        yueSQL.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
								        yueSQL.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
								        yueSQL.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
								        yueSQL.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
								        yueSQL.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
								        yueSQL.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
								        yueSQL.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
								        yueSQL.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
								        yueSQL.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
								        yueSQL.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day");
								        yueSQL.append(" where time_id>=? and time_id<=? and area_id=? group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka");
								        yueSQL.append("  ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka");
				                        //
				                        yueSQL.append(" ) as t3 group by time_id  ) as t4");
							            
							            pstmt = conn.prepareStatement(yueSQL.toString());
							            String curretDate = request.getParameter("selectData");
				                        String stratCDate = curretDate.substring(0,6) +"01" ;
							            pstmt.setInt(1,Integer.parseInt(stratCDate));
							            pstmt.setInt(2,Integer.parseInt(curretDate));
							            pstmt.setString(3,subTitle[0]);
							            rst = pstmt.executeQuery();
							            String yueChayi = null ;
							            if (rst.next()){
							                yueChayi = rst.getString("chayiforM");
							                
							            }
					                             //
					                             numberCell = new jxl.write.Number(13,rowNum,Double.parseDouble(yueChayi),titleNum);
					                             wsheet.addCell(numberCell);
					                          //
					                          String passSQL = "select check_result,check_bak from nmk.CWKXT_CHECK_LOG where time_id=? and check_area=?";
							             pstmt = conn.prepareStatement(passSQL);
							             pstmt.setInt(1,Integer.parseInt(curretDate));
							             pstmt.setString(2,subTitle[0]);
							             //out.println("<script language='javascript'> alert('"+1+"'); </script>"); 
							             rst = pstmt.executeQuery();
							             String passId = null ;
							             String bak = null;
							             if (rst.next()){
							                passId = rst.getString("check_result");
							                bak = rst.getString("check_bak");
							             }
					                          //
					                          label = new Label(14,rowNum,passId==null?"--":passId,title3);
					                             wsheet.addCell(label);
					                             label = new Label(15,rowNum,passId==null?"--":passId,title3);
					                             wsheet.addCell(label);
					                             label = new Label(16,rowNum,bak==null?"":bak,title3);
					                             wsheet.addCell(label);
					                             label = new Label(17,rowNum,"查看详情",title3);
					                             wsheet.addCell(label);   
							                 }
					              }
					          }
					       }
					    } 
					    rst.close();
					    conn.close();
					    wwb.write();
					    if(wwb != null){
							 wwb.close();
							 wwb = null;
						 }
					 os.close();
					 response.flushBuffer();	   
					 }
					 
					 if ("AreaByDay".equalsIgnoreCase(command) && request.getParameter("time_id")!= null){
					 //提取数据start
					 DateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
				     String defaultDate = null ;
				     Calendar calendar = Calendar.getInstance();
		             defaultDate = formater.format(calendar.getTime());
		             String area_id = null ;  
		           
		             if (request.getParameter("time_id") != null && !request.getParameter("time_id").trim().equals("")){
		                    defaultDate = request.getParameter("time_id") ;
		                    DateFormat formater1 = new SimpleDateFormat("yyyyMMdd");
		                    defaultDate = formater.format(formater1.parse(defaultDate)); 
		             }    
				       if (request.getParameter("area_id") != null && !request.getParameter("area_id").trim().equals("")){
				           area_id = request.getParameter("area_id") ;
				       }      
		             String area_name = request.getParameter("area_name");
		             area_name = new String(area_name.getBytes("iso-8859-1"),"utf-8");
		             String[] string = null;
		             
				  if (request.getParameter("time_id") != null && !request.getParameter("time_id").trim().equals("") 
				             && area_id != null ){
				        //conn = ConnectionManage.getInstance().getDWConnection();
				         sql = new StringBuffer();
				        //查询当天某地市公司的数据
				        
				        sql.append("select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3");
				        sql.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2");
				        sql.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3");
				        sql.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2");
				        sql.append(" from (");
				        sql.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				        sql.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				        sql.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				        sql.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				        sql.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				        sql.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				        sql.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				        sql.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				        sql.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				        sql.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day");
				        sql.append(" where time_id=? and area_id=? group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka");
				        sql.append("  ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka");
				        
				        pstmt = conn.prepareStatement(sql.toString());
				        pstmt.setInt(1,Integer.parseInt(request.getParameter("time_id")));
				        pstmt.setString(2,area_id);
				        rst = pstmt.executeQuery();
				        if (rst.next()){
				            string = new String[61];
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
				        }
				  }
				     
					 //提取数据end
					 String title = "日平衡关系检查明细表" ;
					  String time_id = request.getParameter("time_id");
					time_id = new String(time_id.getBytes("iso-8859-1"),"gb2312");
                title = new String(title.getBytes("gb2312"),"iso-8859-1");
                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");   
					os = response.getOutputStream();
					wwb = Workbook.createWorkbook(os);
					
			    	 WritableSheet wsheet = wwb.createSheet("第一页("+ time_id+"-"+area_name +")",0);
					 wsheet.mergeCells(0,0,4,0);
					 jxl.write.Number numberCell = null;
					 Label label = new Label(0,0,"日平衡关系检查明细表",title1);					  
					    wsheet.addCell(label);
					    for (int i = 0; i < 5; i++) {
					      wsheet.setColumnView(i, 20); // 设置列宽
				      }
				         wsheet.mergeCells(0,1,2,1);
				         label = new Label(0,1,"地市:"+area_name,title2);
				         wsheet.addCell(label);
				         wsheet.mergeCells(3,1,4,1);
				         label = new Label(3,1,"时间:"+defaultDate,title2);
				         wsheet.addCell(label);
				         label = new Label(0,2,"项目",title2); 
				         wsheet.addCell(label);
				         label = new Label(1,2,"BOSS系统",title2);
				         wsheet.addCell(label);
				         label = new Label(2,2,"项目",title2);
				         wsheet.addCell(label);
				         label = new Label(3,2,"BASS系统",title2);
				         wsheet.addCell(label);
				         label = new Label(4,2,"差异",title2);
				         wsheet.addCell(label);  
				         label = new Label(0,3," 缴费总额",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,3,Double.parseDouble(string[58]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,3," 账本流入",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,3,Double.parseDouble(string[59]),titleNum);
					     wsheet.addCell(numberCell);
					     numberCell = new jxl.write.Number(4,3,Double.parseDouble(string[60]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(0,4," 一、营业前台收费",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,4,Double.parseDouble(string[52]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,4," 一、账本流入",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,4,Double.parseDouble(string[39]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,4," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,5," 预存款~全球通",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,5,Double.parseDouble(string[2]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,5,"  现金",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,5,Double.parseDouble(string[40]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,5," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,6," 预存款~动感地带",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,6,Double.parseDouble(string[3]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,6," 批量预存",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,6,Double.parseDouble(string[41]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,6," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,7," 预存款~神州行",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,7,Double.parseDouble(string[4]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,7," 空中充值",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,7,Double.parseDouble(string[42]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,7," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,8," 预存款~其他",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,8,Double.parseDouble(string[5]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,8," 东方惠群",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,8,Double.parseDouble(string[43]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,8," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,9," 收回欠费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,9,Double.parseDouble(string[6]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,9," 充值卡",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,9,Double.parseDouble(string[44]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,9," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,10," 收回呆帐",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,10,Double.parseDouble(string[7]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,10," 其它",title3_RR);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,10,Double.parseDouble(string[45]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,10," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,11," 收回坏帐",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,11,Double.parseDouble(string[8]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,11," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,11," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,11," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,12," 收取押金",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,12,Double.parseDouble(string[9]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,12," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,12," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,12," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,13," 滞纳金",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,13,Double.parseDouble(string[10]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,13," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,13," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,13," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,14," 减免滞纳金",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,14,Double.parseDouble(string[11]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,14," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,14," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,14," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,15," 省内异地收费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,15,Double.parseDouble(string[12]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,15," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,15," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,15," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,16," 省际异地收费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,16,Double.parseDouble(string[13]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,16," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,16," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,16," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,17," 批量赠送",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,17,Double.parseDouble(string[14]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,17," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,17," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,17," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,18," 代理商预缴",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,18,Double.parseDouble(string[15]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,18," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,18," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,18," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,19," 票款",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,19,Double.parseDouble(string[16]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,19," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,19," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,19," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,20," 二、退费",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,20,Double.parseDouble(string[53]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,20," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,20," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,20," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,21," 退预存款",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,21,Double.parseDouble(string[17]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,21," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,21," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,21," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,22," 退押金",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,22,Double.parseDouble(string[18]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,22," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,22," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,22," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,23," 现金退费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,23,Double.parseDouble(string[19]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,23," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,23," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,23," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,24," 转预存退费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,24,Double.parseDouble(string[20]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,24," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,24," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,24," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,25," 退卡费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,25,Double.parseDouble(string[21]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,25," ",title3_RR);
				         wsheet.addCell(label);
				         label = new Label(3,25," ",title3_RR);
					     wsheet.addCell(label);
					     label = new Label(4,25," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,26," 三、其它渠道缴费合计",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,26,Double.parseDouble(string[54]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,26," 二、调整合计",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,26,Double.parseDouble(string[57]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(4,26," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,27," 银行托收",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,27,Double.parseDouble(string[22]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,27,"调整1",title3_RR);
					     wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,27,Double.parseDouble(string[46]),titleNum);
					     wsheet.addCell(numberCell); 
					     label = new Label(4,27," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,28," 网上缴费",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,28,Double.parseDouble(string[23]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,28,"调整2",title3_RR);
					     wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,28,Double.parseDouble(string[48]),titleNum);
					     wsheet.addCell(numberCell); 
					     label = new Label(4,28," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,29," 空中充值",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,29,Double.parseDouble(string[24]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,29,"调整3",title3_RR);
					     wsheet.addCell(label);
				         numberCell = new jxl.write.Number(3,29,Double.parseDouble(string[50]),titleNum);
					     wsheet.addCell(numberCell); 
					     label = new Label(4,29," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,30," 东方惠群",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,30,Double.parseDouble(string[25]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,30," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,30," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,30," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,31," 一级BOSS",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,31,Double.parseDouble(string[26]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,31," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,31," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,31," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,32," 信用A+",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,32,Double.parseDouble(string[27]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,32," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,32," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,32," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,33," 集团业务+",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,33,Double.parseDouble(string[28]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,33," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,33," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,33," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,34," 充值卡",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,34,Double.parseDouble(string[29]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,34," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,34," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,34," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,35," 四、调整合计",title3_L);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,35,Double.parseDouble(string[55]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,35," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,35," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,35," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,34+2," 省内异地收费结算",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,34+2,Double.parseDouble(string[30]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,34+2," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,34+2," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,34+2," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,34+3," 营业前台调帐",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,34+3,Double.parseDouble(string[31]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,34+3," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,34+3," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,34+3," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,38," 隔日回退(当日回退的以前费用)",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,38,Double.parseDouble(string[32]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,38," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,38," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,38," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,39," 其它调整1",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,39,Double.parseDouble(string[33]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,39," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,39," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,39," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,39+1," 其它调整2",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,39+1,Double.parseDouble(string[35]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,39+1," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,39+1," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,39+1," ",title3);
				         wsheet.addCell(label);
				         label = new Label(0,41," 其它调整3",title3_R);
				         wsheet.addCell(label);
				         numberCell = new jxl.write.Number(1,41,Double.parseDouble(string[37]),titleNum);
					     wsheet.addCell(numberCell);
					     label = new Label(2,41," ",title3_RR);
					     wsheet.addCell(label);
				         label = new Label(3,41," ",title3_RR);
					     wsheet.addCell(label); 
					     label = new Label(4,41," ",title3);
				         wsheet.addCell(label);
					 //endone
					 wwb.write();
					 if(wwb != null){
						 wwb.close();
						 wwb = null;
					 }
					 os.close();
					 response.flushBuffer();
					 }
					 
					 if ("AreaDayInter".equalsIgnoreCase(command) && request.getParameter("sdate")!= null){
					        //提取数据start
					        Date cdate = new Date();
					        DateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					        String cString = formater1.format(cdate);
					        String sdate = null ;
					     String area_id = null;
					     String area_name = null ;
					     List titlelist = new ArrayList();
							   titlelist.add("0,全省");
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
						
					     if (request.getParameter("sdate") != null ){
					          //System.out.println("sssxxx");
					           sdate = request.getParameter("sdate");
					           sdate = sdate.replace("-","");
					           area_id = request.getParameter("city_ids");
					           if (area_id == null){
					               area_id = "0";
					           }
					           //for (String string :titlelist){
					           for (int i=0;i<titlelist.size();i++){
					               String string = (String)titlelist.get(i);
					               String[] str = string.split(",");
					               if (str[0].equalsIgnoreCase(area_id)){
					                   area_name = str[1];
					                   break ; 
					               }
					               
					           }
								String[] string = null;
								try{
								    sql = new StringBuffer();
								    if (request.getParameter("city_ids") != null&& !request.getParameter("city_ids").equals("0") ){
								    sql.append("select time_id, area_id, chargetype, balance_qqt, balance_dgdd, balance_szx, balance_qt, hs_qf,");
								    sql.append(" hs_dz, hs_hz, sq_yajin, zhinajin, jm_zhinajin, sn_yidisf, sj_yidisf, pl_zengsong, agent_yujiao,"); 
								    sql.append(" piaokuan , YJK_FEE, SJ_FEE , SIM_FEE , TIYAN_FEE, QTHP_FEE, tuiyck, tuiyajin, xjtuifei, zycktuifei, tuikafei from nmk.CWkx_income_sum where area_id=? and time_id=?"); 
								    
								    //conn = ConnectionManage.getInstance().getDWConnection();
								    pstmt = conn.prepareStatement(sql.toString());
								    pstmt.setString(1,area_id);
								    pstmt.setInt(2,Integer.parseInt(sdate));
								    rst = pstmt.executeQuery();
								    }else{
								       //StringBuffer sql = new StringBuffer();
								    sql.append("select time_id,chargetype, sum(balance_qqt) as balance_qqt, sum(balance_dgdd) as balance_dgdd, sum(balance_szx) as balance_szx");
								    sql.append(" , sum(balance_qt) as balance_qt, sum(hs_qf) as hs_qf,"); 
								    sql.append(" sum(hs_dz) as hs_dz, sum(hs_hz) as hs_hz, sum(sq_yajin) as sq_yajin, sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin,"); 
								    sql.append(" sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf, sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, ");
								    sql.append(" sum(piaokuan) as piaokuan , sum(YJK_FEE) as YJK_FEE, sum(SJ_FEE) as SJ_FEE, sum(SIM_FEE) as SIM_FEE , ");
								    sql.append(" sum(TIYAN_FEE) as TIYAN_FEE, sum(QTHP_FEE) as QTHP_FEE, sum(tuiyck) as tuiyck, sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei,");
								    sql.append(" sum(zycktuifei) as zycktuifei, sum(tuikafei) as tuikafei ");
								    sql.append("  from nmk.CWkx_income_sum where  time_id=? group by chargetype,time_id");
								        
								    //conn = ConnectionManage.getInstance().getDWConnection();
								    pstmt = conn.prepareStatement(sql.toString());
								    //pstmt.setString(1,area_id);
								    System.out.println(sql.toString());
								    pstmt.setInt(1,Integer.parseInt(sdate));
								     System.out.println(sdate);
								    rst = pstmt.executeQuery();
								    }
								    list = new ArrayList(); 
								    while (rst.next()){
								       string = new String[26];

                                       string[0]= rst.getString("chargetype");
                                       string[1]= rst.getString("balance_qqt");
                                       string[2]= rst.getString("balance_dgdd");
                                       string[3]= rst.getString("balance_szx");
                                       string[4]= rst.getString("balance_qt");
                                       string[5]= rst.getString("hs_qf");
                                       string[6]= rst.getString("hs_dz");
                                       string[7]= rst.getString("hs_hz");
                                       string[8]= rst.getString("sq_yajin");
                                       string[9]= rst.getString("zhinajin");
                                       string[10]= rst.getString("jm_zhinajin");
                                       string[11]= rst.getString("sn_yidisf");
                                       string[12]= rst.getString("sj_yidisf");
                                       string[13]= rst.getString("pl_zengsong");
                                       string[14]= rst.getString("agent_yujiao");
                                       string[15]= rst.getString("piaokuan");
                                       string[16]= rst.getString("YJK_FEE");
                                       string[17]= rst.getString("SJ_FEE");
                                       string[18]= rst.getString("SIM_FEE");
                                       string[19]= rst.getString("TIYAN_FEE");
                                       string[20]= rst.getString("QTHP_FEE");
                                       string[21]= rst.getString("tuiyck");
                                       string[22]= rst.getString("tuiyajin");
                                       string[23]= rst.getString("xjtuifei");
                                       string[24]= rst.getString("zycktuifei");
                                       string[25]= rst.getString("tuikafei"); 
                                       list.add(string) ; 
								    }
								}catch(Exception e){
								e.fillInStackTrace();
								}finally{
								   if (rst != null)
								         rst.close();
								   if (conn != null)
								         conn.close();      
								} 
					     }
					        String[] str1 = null;
					        String[] str2 = null;     
				        	String[] str3 = null;
				        	String systitle = "0.00";
					     if (list != null && list.size()==3){
					        
				        	//for (String[] strTemp : list){
				        	for (int i=0;i<list.size();i++){
				        	    String[] strTemp =(String[])list.get(i);
				        	     if ("Derate".equalsIgnoreCase(strTemp[0]))
				        	          str2 = strTemp ;
				        	     if ("Income".equalsIgnoreCase(strTemp[0]))
				        	          str1 = strTemp ; 
				        	     if ("Present".equalsIgnoreCase(strTemp[0]))
				        	          str3 = strTemp ;         
				        	}		   
					       
					       }
					        //提取数据end
					        if (str1 != null && str2 != null && str3 != null){
					             String title = "营收系统日报接口展示表" ;
					             
                                 title = new String(title.getBytes("gb2312"),"iso-8859-1");
                                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");   
					             os = response.getOutputStream();
					             wwb = Workbook.createWorkbook(os);
			    	             WritableSheet wsheet = wwb.createSheet("第一页("+ sdate+"-"+area_id +")",0);
					             wsheet.mergeCells(0,0,5,0);
					             jxl.write.Number numberCell = null;
					             Label label = new Label(0,0,"营收系统日报接口展示表("+area_name+")",title1);					  
					             wsheet.addCell(label);
							    for (int i = 0; i < 6; i++) {
							      wsheet.setColumnView(i, 20); // 设置列宽
						        }
						         wsheet.mergeCells(0,1,1,2);
						         label = new Label(0,1,"费用大项",title2);
						         wsheet.addCell(label);
						         wsheet.mergeCells(2,1,3,1);
						         label = new Label(2,1,"实收金额",title2);
						         wsheet.addCell(label);
						         wsheet.mergeCells(4,1,5,1);
						         label = new Label(4,1,"优惠金额",title2);
						         wsheet.addCell(label);
						         label = new Label(2,2,"系统",title2);
						         wsheet.addCell(label);
						         label = new Label(3,2,"调帐",title2);
						         wsheet.addCell(label);
						         label = new Label(4,2,"前台减免",title2);
						         wsheet.addCell(label);
						         label = new Label(5,2,"前台赠送",title2);
						         wsheet.addCell(label);
						         wsheet.mergeCells(0,3,0,17);
						         label = new Label(0,3,"前台收费",title3);
						         wsheet.addCell(label);
						         label = new Label(1,3,"预存款~全球通",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,3,Double.parseDouble(str1[1]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,3,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,3,Double.parseDouble(str2[1]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,3,Double.parseDouble(str3[1]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,4,"预存款~动感地带",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,4,Double.parseDouble(str1[2]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,4,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,4,Double.parseDouble(str2[2]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,4,Double.parseDouble(str3[2]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,5,"预存款~神州行",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,5,Double.parseDouble(str1[3]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,5,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,5,Double.parseDouble(str2[3]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,5,Double.parseDouble(str3[3]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,6,"预存款~其他",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,6,Double.parseDouble(str1[4]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,6,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,6,Double.parseDouble(str2[4]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,6,Double.parseDouble(str3[4]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,7,"收回欠费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,7,Double.parseDouble(str1[5]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,7,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,7,Double.parseDouble(str2[5]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,7,Double.parseDouble(str3[5]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,8,"收回呆帐",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,8,Double.parseDouble(str1[6]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,8,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,8,Double.parseDouble(str2[6]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,8,Double.parseDouble(str3[6]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,9,"收回坏帐",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,9,Double.parseDouble(str1[7]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,9,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,9,Double.parseDouble(str2[7]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,9,Double.parseDouble(str3[7]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,10,"收取押金",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,10,Double.parseDouble(str1[8]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,10,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,10,Double.parseDouble(str2[8]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,10,Double.parseDouble(str3[8]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,11,"滞纳金",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,11,Double.parseDouble(str1[9]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,11,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,11,Double.parseDouble(str2[9]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,11,Double.parseDouble(str3[9]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,12,"减免滞纳金",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,12,Double.parseDouble(str1[10]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,12,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,12,Double.parseDouble(str2[10]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,12,Double.parseDouble(str3[10]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,13,"省内异地收费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,13,Double.parseDouble(str1[11]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,13,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,13,Double.parseDouble(str2[11]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,13,Double.parseDouble(str3[11]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,14,"省际异地收费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,14,Double.parseDouble(str1[12]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,14,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,14,Double.parseDouble(str2[12]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,14,Double.parseDouble(str3[12]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,15,"批量赠送",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,15,Double.parseDouble(str1[13]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,15,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,15,Double.parseDouble(str2[13]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,15,Double.parseDouble(str3[13]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,16,"代理商预缴",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,16,Double.parseDouble(str1[14]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,16,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,16,Double.parseDouble(str2[14]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,16,Double.parseDouble(str3[14]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,17,"票款",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,17,Double.parseDouble(str1[15]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,17,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,17,Double.parseDouble(str2[15]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,17,Double.parseDouble(str3[15]),titleNum);
					             wsheet.addCell(numberCell);
					             wsheet.mergeCells(0,18,0,22);
					             label = new Label(0,18,"货品费",title3);
						         wsheet.addCell(label);
						         label = new Label(1,18,"有价卡费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,18,Double.parseDouble(str1[16]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,18,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,18,Double.parseDouble(str2[16]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,18,Double.parseDouble(str3[16]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,19,"手机费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,19,Double.parseDouble(str1[17]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,19,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,19,Double.parseDouble(str2[17]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,19,Double.parseDouble(str3[17]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,20,"SIM卡费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,20,Double.parseDouble(str1[18]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,20,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,20,Double.parseDouble(str2[18]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,20,Double.parseDouble(str3[18]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,21,"体验卡",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,21,Double.parseDouble(str1[19]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,21,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,21,Double.parseDouble(str2[19]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,21,Double.parseDouble(str3[19]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,22,"其他货品费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,22,Double.parseDouble(str1[20]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,22,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,22,Double.parseDouble(str2[20]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,22,Double.parseDouble(str3[20]),titleNum);
					             wsheet.addCell(numberCell);
					             wsheet.mergeCells(0,23,0,27);
					             label = new Label(0,23,"退费",title3);
						         wsheet.addCell(label);
						         label = new Label(1,23,"退预存款",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,23,Double.parseDouble(str1[21]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,23,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,23,Double.parseDouble(str2[21]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,23,Double.parseDouble(str3[21]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,24,"退押金",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,24,Double.parseDouble(str1[22]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,24,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,24,Double.parseDouble(str2[22]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,24,Double.parseDouble(str3[22]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,25,"现金退费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,25,Double.parseDouble(str1[23]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,25,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,25,Double.parseDouble(str2[23]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,25,Double.parseDouble(str3[23]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,26,"转预存退费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,26,Double.parseDouble(str1[24]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,26,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,26,Double.parseDouble(str2[24]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,26,Double.parseDouble(str3[24]),titleNum);
					             wsheet.addCell(numberCell);
					             label = new Label(1,27,"退卡费",title3);
						         wsheet.addCell(label);
						         numberCell = new jxl.write.Number(2,27,Double.parseDouble(str1[25]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(3,27,Double.parseDouble(systitle),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(4,27,Double.parseDouble(str2[25]),titleNum);
					             wsheet.addCell(numberCell);
					             numberCell = new jxl.write.Number(5,27,Double.parseDouble(str3[25]),titleNum);
					             wsheet.addCell(numberCell);
						             wwb.write();
						             if(wwb != null){
										 wwb.close();
										 wwb = null;
									 }
									 os.close();
									 response.flushBuffer();
					        }
					        
					 }
					if ("AreaBooks".equalsIgnoreCase(command) && request.getParameter("sdate")!= null && request.getParameter("city_ids")!= null){
					//提取数据start
					     String sdate = null ;
					     String area_id = null ;
					     String area_name = null ;
					     List titlelist = new ArrayList(); 
							   titlelist.add("0,全省");
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
					     if (request.getParameter("sdate") != null ){
					           
					           sdate = request.getParameter("sdate");
					           sdate = sdate.replace("-","");
					           area_id = request.getParameter("city_ids");
					           
					            for (int i=0;i<titlelist.size();i++){
					                String string = (String)titlelist.get(i);
					               String[] str = string.split(",");
					               if (str[0].equalsIgnoreCase(area_id)){
					                   area_name = str[1];
					                   break ; 
					               }
					           } 
					          String[] string = null; 
								   sql = new StringBuffer();
								    if ( request.getParameter("city_ids") != null &&  !request.getParameter("city_ids").equals("0")){
								    sql.append("select time_id,area_id,subjectid,subjectname,flow_charge,flow_times");
								    sql.append(" from NMK.ACCTBOOK_CHG_SUBJECT_SUM where time_id=? and area_id=?"); 
								    
								    //conn = ConnectionManage.getInstance().getDWConnection();
								    pstmt = conn.prepareStatement(sql.toString());
								    
								    pstmt.setInt(1,Integer.parseInt(sdate));
								    pstmt.setString(2,area_id);
								    rst = pstmt.executeQuery();
								    }else{
								       sql.append("select time_id,area_id,subjectid,subjectname,flow_charge,flow_times");
								       sql.append(" from NMK.ACCTBOOK_CHG_SUBJECT_SUM where time_id=?  order by area_id");
								        //conn = ConnectionManage.getInstance().getDWConnection();
								        pstmt = conn.prepareStatement(sql.toString());
								        pstmt.setInt(1,Integer.parseInt(sdate));
								        rst = pstmt.executeQuery();
								    }
								    list = new ArrayList(); 
								    while (rst.next()){
								       string = new String[7];
                                       string[0]= rst.getString("time_id");                                       
                                       string[1]= area_name;
                                       string[2]= rst.getString("subjectid");
                                       string[3]= rst.getString("subjectname");
                                       string[4]= rst.getString("flow_charge");
                                       string[5]= rst.getString("flow_times");
                                       string[6]= rst.getString("area_id");
                                        
                                       list.add(string) ; 
								    }
								    //System.out.println(list.size());					     
					     }
					//提取数据end
					 if (list != null ){
					             String title = "地市账本科目流入明细展示表" ;     
                                 title = new String(title.getBytes("gb2312"),"iso-8859-1");
                                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");   
					             os = response.getOutputStream();
					             wwb = Workbook.createWorkbook(os);
			    	             WritableSheet wsheet = wwb.createSheet("第一页("+ sdate+"-"+area_name +")",0);
					             wsheet.mergeCells(0,0,4,0);
					             jxl.write.Number numberCell = null;
					             Label label = new Label(0,0,"地市账本科目流入明细展示表("+sdate+")",title1);					  
					             wsheet.addCell(label);
					              wsheet.setColumnView(0, 10);
							      wsheet.setColumnView(1, 24);
							      wsheet.setColumnView(2, 24); // 设置列宽
						          wsheet.setColumnView(3, 16);
						          wsheet.setColumnView(4, 16);
						         label = new Label(0,1,"地市",title2);
						         wsheet.addCell(label);
						         label = new Label(1,1,"科目",title2);
						         wsheet.addCell(label);
						         label = new Label(2,1,"科目名称",title2);
						         wsheet.addCell(label);
						         label = new Label(3,1,"流入金额",title2);
						         wsheet.addCell(label);
						         label = new Label(4,1,"流入笔数",title2);
						         wsheet.addCell(label);
						         int rowNum = 1 ;
						         for (int i=0;i<list.size();i++){
						           String[] string = (String[])list.get(i);
						           rowNum++;
						             label = new Label(0,rowNum,string[1],title3);
							         wsheet.addCell(label);
							         label = new Label(1,rowNum,string[2],title3);
							         wsheet.addCell(label);
							         label = new Label(2,rowNum,string[3],title3);
							         wsheet.addCell(label);
							         numberCell = new jxl.write.Number(3,rowNum,Double.parseDouble(string[4]),titleNum);
					                 wsheet.addCell(numberCell);
							         numberCell = new jxl.write.Number(4,rowNum,Double.parseDouble(string[5]),titleNum);
					                 wsheet.addCell(numberCell);
						         }
						             wwb.write();
						             if(wwb != null){
										 wwb.close();
										 wwb = null;
									 }
									 os.close();
									 response.flushBuffer();
						         }
					 }
					 if ("ListMonth".equalsIgnoreCase(command) && request.getParameter("sdate")!= null){
					 //提取数据start
					 List titlelist = new ArrayList();
					   titlelist.add("0,全省");
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
				String sDate = null ;
				String startDate = null ;
				String endDate = null ;
				Date cdate = new Date();
               DateFormat formater1 = new SimpleDateFormat("yyyyMM");
                String cString = formater1.format(cdate);
                             if (request.getParameter("sdate") != null)
				                    sDate = request.getParameter("sdate");
				             if  (request.getParameter("selectData") != null)
				                    sDate = request.getParameter("selectData"); 
				             if (sDate == null)
				                    sDate = cString;
				               startDate = sDate + "02" ;
				         if (sDate.substring(4,6).equals("12")){
				           endDate = String.valueOf(Integer.parseInt(sDate.substring(0,4)) + 1) + "0101" ;
				         }else{
				            int i = Integer.parseInt(sDate.substring(4,6)) + 1 ;
				            endDate = sDate.substring(0,4) + i +"01";
				         } 
				        //conn = ConnectionManage.getInstance().getDWConnection();
				        
				        sql = new StringBuffer();	
		                 sql.append(" select area_id,t8.boss,t8.balance_m,t8.balance_lm,t8.out_bookcharge,t9.check_result,t9.check_bak from ");
						sql.append(" (select t6.area_id,t6.boss,t7.balance_m,t7.balance_lm,t7.out_bookcharge from ");
						sql.append(" (select area_id,sum(boss1+boss2+boss3+boss4) as boss from ( ");
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
						 sql.append(" where t7.time_id="+ sDate+" and t6.area_id=t7.area_id ) as t8 left join (select CHECK_RESULT,check_area,check_bak  from nmk.CWKXT_CHECK_LOG where time_id="+ sDate+" )as t9 ");
						  
						 sql.append(" on t8.area_id = t9.check_area ");
				         System.out.println(sql.toString());
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
					 //提取数据end
					   if (list != null){
					        String title = "月度预存款余额平衡关系检查表" ;     
                                 title = new String(title.getBytes("gb2312"),"iso-8859-1");
                                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");   
					             os = response.getOutputStream();
					             wwb = Workbook.createWorkbook(os);
			    	             WritableSheet wsheet = wwb.createSheet("第一页("+ sDate +")",0);
					             wsheet.mergeCells(0,0,10,0);
					             jxl.write.Number numberCell = null;
					             Label label = new Label(0,0,"地市账本科目流入明细展示表("+sDate+")",title1);					  
					             wsheet.addCell(label);
					              wsheet.setColumnView(0, 6);
							      for (int i=1;i<11;i++){
							        wsheet.setColumnView(i, 18);
							      }
							      wsheet.mergeCells(0,1,0,2);
							      label = new Label(0,1,"地市",title2);					  
					              wsheet.addCell(label);
					              wsheet.mergeCells(1,1,6,1);
							      label = new Label(1,1,"平衡性检查公式（上期余额＋本月充值－本月划帐＝本期余额）",title2);					  
					              wsheet.addCell(label);
					              label = new Label(1,2,"A、上期预存款余额",title2);					  
					              wsheet.addCell(label);
					              label = new Label(2,2,"B、本期充值",title2);					  
					              wsheet.addCell(label);
					              label = new Label(3,2,"C、本期划账",title2);					  
					              wsheet.addCell(label);
					              label = new Label(4,2,"D、本期余额",title2);					  
					              wsheet.addCell(label); 
					              label = new Label(5,2,"差异(A+B-C-D)",title2);					  
					              wsheet.addCell(label);
					              label = new Label(6,2,"差异率 (A+B-C)/D-1",title2);					  
					              wsheet.addCell(label);
					              wsheet.mergeCells(7,1,7,2);
					              label = new Label(7,1,"审核通过",title2);					  
					              wsheet.addCell(label);
					              wsheet.mergeCells(8,1,8,2);
					              label = new Label(8,1,"审核不通过",title2);					  
					              wsheet.addCell(label);
					              wsheet.mergeCells(9,1,9,2);
					              label = new Label(9,1,"批注",title2);					  
					              wsheet.addCell(label);
					              wsheet.mergeCells(10,1,10,2);
					              label = new Label(10,1,"查看详情",title2);					  
					              wsheet.addCell(label);
					              int rowNum = 2 ;
					              if (list != null){
					                  for (Iterator it = titlelist.iterator();it.hasNext();){
					                     String[] subTitle = ((String)it.next()).split(",");
					                     for (int i=0; i<list.size();i++){
							                      String[] str = (String[]) list.get(i);
							                      if (str[0].equalsIgnoreCase(subTitle[0])){
							                        rowNum ++;
							                        label = new Label(0,rowNum,subTitle[1],title3);					  
					                                wsheet.addCell(label);
					                                numberCell = new jxl.write.Number(1,rowNum,Double.parseDouble(str[1]),titleNum);
					                                wsheet.addCell(numberCell);
					                                numberCell = new jxl.write.Number(2,rowNum,Double.parseDouble(str[2]),titleNum);
					                                wsheet.addCell(numberCell);
					                                numberCell = new jxl.write.Number(3,rowNum,Double.parseDouble(str[3]),titleNum);
					                                wsheet.addCell(numberCell);
					                                numberCell = new jxl.write.Number(4,rowNum,Double.parseDouble(str[4]),titleNum);
					                                wsheet.addCell(numberCell);
					                                BigDecimal chaiyi = new BigDecimal(str[1]);
							                        chaiyi = chaiyi.add(new BigDecimal(str[2]));
							                        chaiyi = chaiyi.add((new BigDecimal(str[3])).negate());
							                        chaiyi = chaiyi.add((new BigDecimal(str[4])).negate());
					                                numberCell = new jxl.write.Number(5,rowNum,Double.parseDouble(chaiyi.toString()),titleNum);
					                                wsheet.addCell(numberCell);
					                                BigDecimal chaiyilu = new BigDecimal(str[1]);
										            chaiyilu = chaiyilu.add(new BigDecimal(str[2]));
										            chaiyilu = chaiyilu.add((new BigDecimal(str[3])).negate());
										            chaiyilu = chaiyilu.divide(new BigDecimal(str[4]),4);
										            numberCell = new jxl.write.Number(6,rowNum,Double.parseDouble(chaiyilu.toString()),titleNum);
					                                wsheet.addCell(numberCell);
					                                //(str[5] == null || str[5].equals("不通过"))
					                                label = new Label(7,rowNum,(str[5] == null || str[5].equals("不通过"))?"":"已通过",title3);
					                                wsheet.addCell(label);
					                                label = new Label(8,rowNum,(str[5] == null || str[5].equals("通过"))?"":"已不通过",title3);
					                                wsheet.addCell(label);
					                                label = new Label(9,rowNum,str[6]==null?"":str[6],title3);					  
					                                wsheet.addCell(label);
					                                label = new Label(10,rowNum,"查看详情",title3);					  
					                                wsheet.addCell(label);
							                        break;
							                      }
							             }         
					                  }
					              }
							         wwb.write();
							         if(wwb != null){
										 wwb.close();
										 wwb = null;
									 }
									 os.close();
									 response.flushBuffer();  
					   } 
					 }
					
					 if ("AreaMonth".equalsIgnoreCase(command) && request.getParameter("time_id")!= null){
					 //提取数据start
					 			List titlelist = new ArrayList();
			titlelist.add("0,全省");
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

			String defaultStartS = null;
			String defaultStartZ = null;
			String areaId = request.getParameter("area_id");
			String areaName = request.getParameter("area_name");
			areaName = new String(areaName.getBytes("iso-8859-1"), "utf-8");
			String defaultMonth = request.getParameter("time_id");
			if (request.getParameter("sdate") != null && !"null".equalsIgnoreCase(request.getParameter("sdate"))
					&& request.getParameter("zdate") != null && !"null".equalsIgnoreCase(request.getParameter("zdate"))
					&& request.getParameter("time_id") != null) {
				defaultStartS = request.getParameter("sdate");
				defaultStartZ = request.getParameter("zdate");
				defaultMonth = request.getParameter("time_id");
			}

			if (request.getParameter("sdate") == null || "null".equalsIgnoreCase(request.getParameter("sdate"))
					&& request.getParameter("zdate") == null || "null".equalsIgnoreCase(request.getParameter("zdate"))) {
				defaultStartS = defaultMonth + "02";
				if (defaultMonth.substring(4, 6).equals("12")) {
					defaultStartZ = String.valueOf(Integer
							.parseInt(defaultMonth.substring(0, 4)) + 1)
							+ "0101";
				} else {
					int i = Integer.parseInt(defaultMonth.substring(4, 6)) + 1;
					defaultStartZ = defaultMonth.substring(0, 4) + i + "01";
				}
			} else {
				defaultStartS = request.getParameter("sdate");
				defaultStartZ = request.getParameter("zdate");
			}
			String[] string = null;
			String[] mstring = null;
			//conn = ConnectionManage.getInstance().getDWConnection();
				sql = new StringBuffer();
				//查询

				sql
						.append("select area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				sql
						.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz, ");
				sql
						.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				sql
						.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				sql
						.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				sql
						.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				sql
						.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				sql
						.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1,");
				sql
						.append(" sum(qt_tiaozhang2) as qt_tiaozhang2,  sum(qt_tiaozhang3) as qt_tiaozhang3, sum(in_bookcharge) as in_bookcharge, sum(in_cash) as in_cash, sum(in_plyc) as in_plyc, sum(in_sky) as in_sky, sum(in_dfhq) as in_dfhq,");
				sql
						.append(" sum(Aczka) as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, sum(tiaozheng2) as tiaozheng2, sum(tiaozheng3) as tiaozheng3");
				sql
						.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2 ");
				sql
						.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3");
				sql
						.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2");
				sql.append(" from (");
				sql
						.append(" select time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx,");
				sql
						.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz,");
				sql
						.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf,");
				sql
						.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				sql
						.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				sql
						.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				sql
						.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				sql
						.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1, ");
				sql
						.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				sql
						.append(" Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 ");
				sql
						.append(" ,sum(balance_qqt+balance_dgdd+balance_szx+balance_qt+hs_qf+hs_dz+hs_hz+sq_yajin+zhinajin+jm_zhinajin+sn_yidisf) boss1,sum(tuiyck+zycktuifei) as boss2 ");
				sql
						.append(" ,sum(ws_jiaofei+air_chongzhi+df_huiqun+yj_boss+xy_Ajia+jt_yewu+czka) as boss3 ");
				sql
						.append(" ,sum(snydsf_js+yyqt_tiaozheng+geri_huitui+qt_tiaozhang1+qt_tiaozhang2+qt_tiaozhang3) as boss4,sum(in_bookcharge) as bass1,sum(tiaozheng1+tiaozheng2+tiaozheng3) as bass2 ");
				sql.append(" from ( ");
				sql
						.append(" select  time_id,area_id,sum(balance_qqt) as balance_qqt,sum(balance_dgdd) as balance_dgdd,sum(balance_szx) as balance_szx, ");
				sql
						.append(" sum(balance_qt) as balance_qt,sum(hs_qf) as hs_qf,sum(hs_dz) as hs_dz,sum(hs_hz) as hs_hz, ");
				sql
						.append(" sum(sq_yajin) as sq_yajin,sum(zhinajin) as zhinajin, sum(jm_zhinajin) as jm_zhinajin, sum(sn_yidisf) as sn_yidisf, sum(sj_yidisf) as sj_yidisf, ");
				sql
						.append(" sum(pl_zengsong) as pl_zengsong, sum(agent_yujiao) as agent_yujiao, sum(piaokuan) as piaokuan,");
				sql
						.append(" sum(tuiyck) as tuiyck , sum(tuiyajin) as tuiyajin, sum(xjtuifei) as xjtuifei, sum(zycktuifei) as zycktuifei,");
				sql
						.append(" sum(tuikafei) as tuikafei, sum(yh_tuoshou) as yh_tuoshou, sum(ws_jiaofei) as ws_jiaofei, sum(air_chongzhi) as air_chongzhi, sum(df_huiqun) as df_huiqun,");
				sql
						.append(" sum(yj_boss) as yj_boss, sum(xy_Ajia) as xy_Ajia, sum(jt_yewu) as jt_yewu , sum(czka) czka, sum(snydsf_js) as snydsf_js, sum(yyqt_tiaozheng) as yyqt_tiaozheng,");
				sql
						.append(" sum(geri_huitui) as geri_huitui , sum(qt_tiaozhang1) as qt_tiaozhang1, qt_tzbak1,");
				sql
						.append(" sum(qt_tiaozhang2) as qt_tiaozhang2, qt_tzbak2, sum(qt_tiaozhang3) as qt_tiaozhang3, qt_tzbak3, sum(in_bookcharge) as in_bookcharge, in_cash, in_plyc, in_sky, in_dfhq,");
				sql
						.append(" czka as Aczka, sum(in_qt) in_qt, sum(tiaozheng1) as tiaozheng1, tz_bak1, sum(tiaozheng2) as tiaozheng2, tz_bak2, sum(tiaozheng3) as tiaozheng3, tz_bak3 from nmk.CWkxt_check_sum_Day ");
				sql
						.append(" where time_id>=? and time_id<=? and area_id=? group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,in_cash, in_plyc, in_sky, in_dfhq,tz_bak1,tz_bak2,tz_bak3,czka ");
				sql
						.append(" ) as t1 group by time_id,area_id,qt_tzbak1,qt_tzbak2,qt_tzbak3,tz_bak1,tz_bak2,tz_bak3,in_cash, in_plyc, in_sky, in_dfhq,Aczka ");
				sql.append(" ) as t3 group by area_id");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setInt(1, Integer.parseInt(defaultStartS));
				pstmt.setInt(2, Integer.parseInt(defaultStartZ));
				pstmt.setString(3, areaId);
				rst = pstmt.executeQuery();

				if (rst.next()) {
					string = new String[61];
					//string[0] = rst.getString("time_id");
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
					//string[34] = rst.getString("qt_tzbak1");
					string[35] = rst.getString("qt_tiaozhang2");
					//string[36] = rst.getString("qt_tzbak2");
					string[37] = rst.getString("qt_tiaozhang3");
					//string[38] = rst.getString("qt_tzbak3");
					string[39] = rst.getString("in_bookcharge");
					string[40] = rst.getString("in_cash");

					string[41] = rst.getString("in_plyc");
					string[42] = rst.getString("in_sky");
					string[43] = rst.getString("in_dfhq");
					string[44] = rst.getString("Aczka");
					string[45] = rst.getString("in_qt");
					string[46] = rst.getString("tiaozheng1");
					// string[47] = rst.getString("tz_bak1");
					string[48] = rst.getString("tiaozheng2");
					//string[49] = rst.getString("tz_bak2");
					string[50] = rst.getString("tiaozheng3");

					//string[51] = rst.getString("tz_bak3");
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
				}
				String Msql = "select time_id,area_id,balance_m,balance_lm,out_bookcharge,out_tiaozhang1,out_tiaozhang2,tiaozheng1,tz_bak1,tiaozheng2,tz_bak2 from nmk.CWkxt_check_sum_Month where time_id=? and area_id=?";
				//conn = ConnectionManage.getInstance().getDWConnection();
				pstmt = conn.prepareStatement(Msql.toString());
				pstmt.setInt(1, Integer.parseInt(defaultMonth));
				pstmt.setString(2, areaId);
				rst = pstmt.executeQuery();
				if (rst.next()) {
					mstring = new String[17];
					mstring[0] = rst.getString("time_id");
					mstring[1] = rst.getString("area_id");
					mstring[2] = rst.getString("balance_m");
					mstring[3] = rst.getString("balance_lm");
					mstring[4] = rst.getString("out_bookcharge");
					mstring[5] = rst.getString("out_tiaozhang1");
					mstring[6] = rst.getString("out_tiaozhang2");
					mstring[7] = rst.getString("tiaozheng1");
					mstring[8] = rst.getString("tz_bak1");
					mstring[9] = rst.getString("tiaozheng2");
					mstring[10] = rst.getString("tz_bak2");
					BigDecimal bossdata = new BigDecimal(mstring[4]);
					//bossdata = bossdata.add(new BigDecimal(mstring[7]));
					if (mstring[7] == null)
						mstring[7] = "0.00";
					if (mstring[9] == null)
						mstring[9] = "0.00";
					if (mstring[8] == null)
						mstring[8] = "";
					if (mstring[10] == null)
						mstring[10] = "";
					mstring[11] = bossdata.add(new BigDecimal(mstring[7]))
							.toString();
					mstring[12] = bossdata.add(new BigDecimal(mstring[9]))
							.toString();
					if (string != null) {
						BigDecimal boss = new BigDecimal(mstring[3]);
						boss = boss.add(new BigDecimal(string[58]));
						boss = boss.add((new BigDecimal(mstring[11])).negate());
						mstring[13] = boss.toString();
						BigDecimal bass = new BigDecimal(mstring[3]);
						bass = bass.add(new BigDecimal(string[59]));
						bass = bass.add((new BigDecimal(mstring[12])).negate());
						mstring[14] = bass.toString();
						boss = new BigDecimal(mstring[13]);
						boss = boss.add((new BigDecimal(mstring[14])).negate());
						mstring[15] = boss.toString();

						boss = boss.divide(new BigDecimal(mstring[13]), 4)
								.scaleByPowerOfTen(2);
						mstring[16] = boss.toString();
					}
				}
					 //提取数据end 
					       String title = "月平衡关系检查明细表" ;     
                                 title = new String(title.getBytes("gb2312"),"iso-8859-1");
                                 response.addHeader("Content-Disposition","attachment;   filename="   + title +".xls");   
					             os = response.getOutputStream();
					             wwb = Workbook.createWorkbook(os);
			    	             WritableSheet wsheet = wwb.createSheet("第一页("+ areaName +")",0);
					             wsheet.mergeCells(0,0,7,0);
					             jxl.write.Number numberCell = null;
					             Label label = new Label(0,0,"月平衡关系检查明细表",title1);					  
					             wsheet.addCell(label);
					              wsheet.setColumnView(0, 28);
					              wsheet.setColumnView(1, 18);
					              wsheet.setColumnView(2, 18);
					              wsheet.setColumnView(3, 28);
					              wsheet.setColumnView(4, 18);
					              wsheet.setColumnView(5, 18);
					              wsheet.setColumnView(6, 14);
					              wsheet.setColumnView(7, 14);
							      wsheet.mergeCells(0,1,3,1);
							      label = new Label(0,1,"地市:"+areaName,title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(4,1,7,1);
							      label = new Label(4,1,"时间:"+defaultStartS + "-" + defaultStartZ,title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(0,2,0,3);
							      label = new Label(0,2,"项目",title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(1,2,2,2);
							      label = new Label(1,2,"BOSS系统",title2);
							      wsheet.addCell(label);
							      label = new Label(1,3,"数值",title2);
							      wsheet.addCell(label);
							      label = new Label(2,3,"备注",title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(3,2,3,3);
							      label = new Label(3,2,"项目",title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(4,2,5,2);
							      label = new Label(4,2,"BASS系统",title2);
							      wsheet.addCell(label);
							      label = new Label(4,3,"数值",title2);
							      wsheet.addCell(label);
							      label = new Label(5,3,"备注",title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(6,2,6,3);
							      label = new Label(6,2,"差异",title2);
							      wsheet.addCell(label);
							      wsheet.mergeCells(7,2,7,3);
							      label = new Label(7,2,"差异率",title2);
							      wsheet.addCell(label);
							      label = new Label(0,4,"本期预存款余额(一＋二－三）",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,4,Double.parseDouble(mstring[13]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,4,"公式计算",title3);
							      wsheet.addCell(label);
							      label = new Label(3,4,"本期预存款余额(一＋二－三）",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,4,Double.parseDouble(mstring[14]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,4,"公式计算",title3);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(6,4,Double.parseDouble(mstring[15]),titleNum);
					              wsheet.addCell(numberCell);
					              numberCell = new jxl.write.Number(7,4,Double.parseDouble(mstring[16]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(0,5,"一、上期预存款余额",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,5,Double.parseDouble(mstring[3]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,5,"一、上期预存款余额",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,5,Double.parseDouble(mstring[3]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,6,"二、本期充值数",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,6,Double.parseDouble(string[58]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,6,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,6,"二、本期充值数",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,6,Double.parseDouble(string[59]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,6,"统计账本的流入",title3);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(6,6,Double.parseDouble(string[60]),titleNum);
					              wsheet.addCell(numberCell);
							      label = new Label(7,6,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,7,"1.营业前台收费",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,7,Double.parseDouble(string[52]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,7,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,7,"1.账本流入",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,7,Double.parseDouble(string[39]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,7,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,7,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,7,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,8,"预存款~全球通",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,8,Double.parseDouble(string[2]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,8,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,8,"现金",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,8,Double.parseDouble(string[40]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,8,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,8,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,8,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,9,"预存款~动感地带",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,9,Double.parseDouble(string[3]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,9,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,9,"批量预存",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,9,Double.parseDouble(string[41]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,9,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,9,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,9,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,10,"预存款~神州行",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,10,Double.parseDouble(string[4]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,10,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,10,"空中充值",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,10,Double.parseDouble(string[42]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,10,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,10,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,10,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,11,"预存款~其他",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,11,Double.parseDouble(string[5]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,11,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,11,"东方惠群",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,11,Double.parseDouble(string[43]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,11,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,11,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,11,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,12,"收回欠费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,12,Double.parseDouble(string[6]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,12,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,12,"充值卡",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,12,Double.parseDouble(string[44]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,12,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,12,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,12,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,13,"收回呆帐",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,13,Double.parseDouble(string[7]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,13,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,13,"其它",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,13,Double.parseDouble(string[45]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,13,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,13,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,13,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,14,"收回坏帐",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,14,Double.parseDouble(string[8]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,14,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,14,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,14,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,14,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,14,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,14,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,15,"收取押金",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,15,Double.parseDouble(string[9]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,15,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,15,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,15,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,15,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,15,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,15,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,16,"滞纳金",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,16,Double.parseDouble(string[10]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,16,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,16,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,16,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,16,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,16,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,16,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,17,"减免滞纳金",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,17,Double.parseDouble(string[11]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,17,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,17,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,17,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,17,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,17,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,17,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,18,"省内异地收费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,18,Double.parseDouble(string[12]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,18,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,18,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,18,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,18,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,18,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,18,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,19,"省际异地收费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,19,Double.parseDouble(string[13]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,19,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,19,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,19,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,19,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,19,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,19,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,20,"批量赠送",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,20,Double.parseDouble(string[14]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,20,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,20,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,20,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,20,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,20,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,20,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,21,"代理商预缴",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,21,Double.parseDouble(string[15]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,21,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,21,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,21,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,21,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,21,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,21,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,22,"票款",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,22,Double.parseDouble(string[16]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,22,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,22,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,22,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,22,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,22,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,22,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,23,"2.退费",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,23,Double.parseDouble(string[53]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,23,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,23,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,23,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,23,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,23,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,23,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,24,"退预存款",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,24,Double.parseDouble(string[17]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,24,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,24,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,24,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,24,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,24,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,24,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25,"退押金",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25,Double.parseDouble(string[18]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,25,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,25,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25+1,"现金退费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25+1,Double.parseDouble(string[19]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25+1,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,25+1,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,25+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25+2,"转预存退费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25+2,Double.parseDouble(string[20]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25+2,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,25+2,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,25+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25+3,"退卡费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25+3,Double.parseDouble(string[21]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25+3,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,25+3,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,25+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25+4,"3.其它渠道缴费合计",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25+4,Double.parseDouble(string[54]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25+4,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25+4,"二、调整合计",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,25+4,Double.parseDouble(string[57]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,25+4,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25+4,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25+4,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,25+5,"银行托收",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,25+5,Double.parseDouble(string[22]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,25+5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,25+5,"调整1",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,25+5,Double.parseDouble(string[46]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,25+5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,25+5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,25+5,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,31,"网上缴费",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,31,Double.parseDouble(string[23]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,31,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,31,"调整2",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,31,Double.parseDouble(string[48]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,31,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,31,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,31,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,32,"空中充值",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,32,Double.parseDouble(string[24]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,32,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,32,"调整3",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,32,Double.parseDouble(string[50]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,32,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,32,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,32,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,32+1,"东方惠群",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,32+1,Double.parseDouble(string[25]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,32+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,32+1,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,32+1,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,32+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,32+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,32+1,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,32+2,"一级BOSS",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,32+2,Double.parseDouble(string[26]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,32+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,32+2,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,32+2,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,32+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,32+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,32+2,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,32+3,"信用A+",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,32+3,Double.parseDouble(string[27]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,32+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,32+3,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,32+3,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,32+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,32+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,32+3,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,36,"集团业务",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,36,Double.parseDouble(string[28]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,36,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,36,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,36,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,36,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,36,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,36,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,37,"充值卡",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,37,Double.parseDouble(string[29]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,37,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,37,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,37,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,37,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,37,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,37,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,38,"4.调整合计",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,38,Double.parseDouble(string[55]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,38,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,38,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,38,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,38,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,38,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,38,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,39,"省内异地收费结算",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,39,Double.parseDouble(string[30]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,39,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,39,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,39,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,39,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,39,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,39,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,40,"营业前台调帐",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,40,Double.parseDouble(string[31]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,40,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,40,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,40,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,40,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,40,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,40,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,41,"隔日回退(当日回退的以前费用)",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,41,Double.parseDouble(string[32]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,41,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,41,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,41,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,41,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,41,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,41,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,42,"其它调整1",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,42,Double.parseDouble(string[33]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,42,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,42,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,42,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,42,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,42,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,42,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,43,"其它调整2",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,43,Double.parseDouble(string[35]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,43,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,43,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,43,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,43,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,43,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,43,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,44,"其它调整3",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,44,Double.parseDouble(string[37]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,44,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,44,"",title3_R);
							      wsheet.addCell(label);
							      label = new Label(4,44,"",title3_R);
							      wsheet.addCell(label);
					              label = new Label(5,44,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,44,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,44,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,45,"三、本期划账数",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,45,Double.parseDouble(mstring[11]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,45,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,45,"三、本期划账数",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,45,Double.parseDouble(mstring[12]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,45,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,45,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,45,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,46,"本期划账金额",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,46,Double.parseDouble(mstring[4]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,46,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,46,"本期划账金额",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,46,Double.parseDouble(mstring[4]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,46,"统计账本 的流出",title3);
							      wsheet.addCell(label);
							      label = new Label(6,46,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,46,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,47,"其它调整",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,47,Double.parseDouble(mstring[7]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,47,mstring[8]==null?"":mstring[8],title3);
							      wsheet.addCell(label);
							      label = new Label(3,47,"其它调整",title3_R);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,47,Double.parseDouble(mstring[9]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,47,mstring[10]==null?"":mstring[10],title3);
							      wsheet.addCell(label);
							      label = new Label(6,47,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,47,"",title3);
							      wsheet.addCell(label);
							      label = new Label(0,48,"四、本期 预存款余额",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(1,48,Double.parseDouble(mstring[2]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(2,48,"",title3);
							      wsheet.addCell(label);
							      label = new Label(3,48,"四、本期 预存款余额",title3_L);
							      wsheet.addCell(label);
							      numberCell = new jxl.write.Number(4,48,Double.parseDouble(mstring[2]),titleNum);
					              wsheet.addCell(numberCell);
					              label = new Label(5,48,"",title3);
							      wsheet.addCell(label);
							      label = new Label(6,48,"",title3);
							      wsheet.addCell(label);
							      label = new Label(7,48,"",title3);
							      wsheet.addCell(label);
							      //label = new Label(0,49,"",title3);
							      //wsheet.addCell(label);
							      //label = new Label(1,49,"",title3);
							      //wsheet.addCell(label);
					              //label = new Label(2,49,"",title3);
							      //wsheet.addCell(label);
							      //label = new Label(3,49,"",title3_L);
							      //wsheet.addCell(label);
							      //label = new Label(4,49,"",title3_L);
							      //wsheet.addCell(label);
					              //label = new Label(5,49,"",title3);
							      //wsheet.addCell(label);
							      //label = new Label(6,49,"",title3);
							      //wsheet.addCell(label);
							      //label = new Label(7,49,"",title3);
							      //wsheet.addCell(label);
							      wwb.write();
							      if(wwb != null){
										 wwb.close();
										 wwb = null;
									 }
									 os.close();
									 response.flushBuffer();
					 }
					 out.clear();
					 out = pageContext.pushBody();
					 
            } catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally{
					try{
				  if (wwb != null)
				     wwb.close();
					}catch (Exception e){
						e.printStackTrace();
					}
					try{
				  if (os != null)
				     os.close();
					}catch (Exception e){
						e.printStackTrace();
					}
					try{
				  if (rst!= null)
				      rst.close();
					}catch (Exception e){
						e.printStackTrace();
					}
					try{
				  if (conn != null)
				      conn.close();          
					}catch (Exception e){
						e.printStackTrace();
					}
				
              } 
     }
      %>
</body>
</html>
