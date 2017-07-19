<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date,java.util.List,java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.Connection"%>
<%@page import="bass.common2.ConnectionManage,java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="bass.common.QueryTools2"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>地市账本科目流入明细展示表</title>
			<link rel="stylesheet" type="text/css" href="../../css/bass21.css"/>
			<script type="text/javascript" src="../../common2/basscommon.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbbass/common2/alertsms.js"></script>
			<link rel="stylesheet" type="text/css" href="../../js/ext3/resources/css/ext-all.css"/>
		 	<script type="text/javascript" src="../../js/ext3/adapter/ext/ext-base.js"></script>
		  	<script type="text/javascript" src="../../js/ext3/ext-all.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
			<script type="text/javascript" src="${mvcPath}/hbbass/portal/portal_hb.js" charset=utf-8></script>
			<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript">
		function doSubmit(){
		      document.selectform.action = 'financingforAreaBooks.jsp?city_ids=' + document.selectform.city_ids.value +'&sdate='+document.selectform.sdate.value;
	          document.selectform.submit();
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
		var openhtml = true ;
		 function checkdown(){
		   var url = 'downExcelFile.jsp?command=AreaBooks&sdate=<%=request.getParameter("sdate")%>&city_ids=<%=request.getParameter("city_ids")%>';
		   //var url = 'financingforAreaBooks.jsp?command=AreaBooks&sdate=<%=request.getParameter("sdate")%>&city_ids=<%=request.getParameter("city_ids")%>';
		   //alert(url);
		   var s = '<%=request.getParameter("sdate")%>';
		   if (openhtml == false){
		       if (s == 'null'){
		         alert('无下载数据!');
		       }else{
		          makeNewWindow(url);
		       }
		    }else{
		      if (s == 'null'){
		         alert('无下载数据!');
		      }else{
		       tabAdd({title:<%=request.getParameter("sdate")%>+'(AreaBooks)', url :'${mvcPath}/hbbass/channel/caiwu/'+url });
		      }
		   }
		}
		</script>
		<%
		        //Calendar calendar = Calendar.getInstance();
				//DateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
				//String defaultDate = formater.format(calendar.getTime());
		                    Date cdate = new Date();
					        DateFormat formater1 = new SimpleDateFormat("yyyy-MM-dd");
					        String cString = formater1.format(cdate);
		         
		 %>
	</head>
	<body>
	    
	<div class="divinnerfieldset">
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
			   	<form action="" id="selectform" name="selectform" method="post" >
				<table align="center" width="80%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" >   
					<tr class="dim_row">
					    
						<td class="dim_cell_title" align="right" >时间:</td>
						<td class="dim_cell_content" align="left">					
							 <input type="text" value='<%=request.getParameter("sdate")==null?cString:request.getParameter("sdate") %>' id="sdate" name="sdate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"/>
						</td>
						<td class="dim_cell_title" align="right" >地市:</td>
						<td class="dim_cell_content" align="left">					
							 <%=QueryTools2.getAreaCodeHtml("city_ids", (String)session.getAttribute("area_id"), "")%>
						</td>
					</tr>
					<tr class="dim_row">	    
						<td class="dim_cell_content" colspan="4" align="right"><input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;</td>	
				</tr>
				</table>
				</form>				
			</div>
		</fieldset>
	</div>

		<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div_s')"
									title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;数据展示区域： 
								</td>
							</tr>
						</table>  
					</legend>
					<div id="dim_div_s">
					
					<%
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
						List list = null;
							   
					     if (request.getParameter("sdate") != null ){
					           
					           sdate = request.getParameter("sdate");
					           sdate = sdate.replace("-","");
					           area_id = request.getParameter("city_ids");
					           
					           //for (String string :titlelist){
					            for (int i=0;i<titlelist.size();i++){
					                String string = (String)titlelist.get(i);
					               String[] str = string.split(",");
					               if (str[0].equalsIgnoreCase(area_id)){
					                   area_name = str[1];
					                   break ; 
					               }
					           } 
					           
					           Connection conn = null ;
								PreparedStatement pstmt = null ;
								ResultSet  rst = null ;
								String[] string = null; 
								
								
								try{
								    StringBuffer sql = new StringBuffer();
								    if ( request.getParameter("city_ids") != null &&  !request.getParameter("city_ids").equals("0")){
								    sql.append("select time_id,area_id,subjectid,subjectname,flow_charge,flow_times");
								    sql.append(" from NMK.ACCTBOOK_CHG_SUBJECT_SUM where time_id=? and area_id=?"); 
								    
								    conn = ConnectionManage.getInstance().getDWConnection();
								    pstmt = conn.prepareStatement(sql.toString());
								    
								    pstmt.setInt(1,Integer.parseInt(sdate));
								    pstmt.setString(2,area_id);
								    rst = pstmt.executeQuery();
								    }else{
								      
								       sql.append("select time_id,area_id,subjectid,subjectname,flow_charge,flow_times");
								       sql.append(" from NMK.ACCTBOOK_CHG_SUBJECT_SUM where time_id=?  order by area_id");
								        conn = ConnectionManage.getInstance().getDWConnection();
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
								}catch(Exception e){
									e.printStackTrace();
									e.fillInStackTrace();
								}finally{
								   if (rst != null)
								         rst.close();
								   if (conn != null)
								         conn.close();      
								} 
					     }
					         
					        
					%>
							<table border="0" cellspacing="0" cellpadding="0" width="80%" align="center">
   <tr>
     <td  align="right">
        <input type="button" value="下载" id="downLoad" onclick="checkdown()"/>
     </td>
   </tr>
</table>
						<table align="center" width="80%" class="grid-tab-blue" id="resultTable"
							cellspacing="1" cellpadding="0" border="0">
								<tr class="grid_title_blue_noimage" >
									<td class="grid_title_blue_noimage" align="center" colspan="16" height="30">
									    <font size="3"><b>地市账本科目流入明细展示表</b></font>				
								    </td>
							    </tr>
   
							    <tr class="grid_title_blue_noimage" onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className='grid_row_blue'">
							       <td class="grid_title_cell" >地市</td>
							       <td class="grid_title_cell" >科目</td>
							       <td class="grid_title_cell" >科目名称</td>
							       <td class="grid_title_cell" >流入金额</td>
							       <td class="grid_title_cell" >流入笔数</td>
							    </tr>
							      <%if (list != null ){
							      System.out.println(list.size()); 
							          boolean cCss = true ;
							          //for (String[] string : list){
							          for(int i=0;i<list.size();i++){
							             String[] string = (String[])list.get(i);
							             cCss=(cCss==true? false : true );
							    %>
							    
							    <tr class=<%=cCss==true?"'grid_row_alt_blue'":"'grid_row_blue'" %> onmouseover="this.className='grid_row_over_blue'" onmouseout="this.className=<%=cCss==true?"'grid_row_alt_blue'":"'grid_row_blue'" %>" >
							       <td class="grid_row_cell" ><%=string[1] %></td>
							       <td class="grid_row_cell_text" ><%=string[2] %></td>
							       <td class="grid_row_cell_text" ><%=string[3] %></td>
							       <td class="grid_row_cell_number" ><%=string[4] %></td>
							       <td class="grid_row_cell_number" ><%=string[5] %></td>
							    
							    </tr>
							   <%
							   }
						           } 
						       %> 
							    
						</table>
							    
						 
					</div>
				</fieldset>
			</div>
		
	</body>
</html>