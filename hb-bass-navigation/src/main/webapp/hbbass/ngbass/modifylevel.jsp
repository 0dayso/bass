<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.sql.*"%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%-- next step is to add history to another table and display it --%>
<% 
	log.debug("test.jsp in" + ";;; action : " + request.getParameter("action"));

	if("modify".equalsIgnoreCase(request.getParameter("action")))
	       modify(request,response,out);
	else { 
	    Connection conn = null;
	    log.debug("query in");
		//PreparedStatement ps = null;
		Statement st = null;
		ResultSet rs = null;
		String querySql = " select CHANNEL_LEVEL, CHANNEL_LNAME, MIN_VAL, MAX_VAL from NMK.DIM_CHANNEL_LEVEL ";
		StringBuilder resultJsonStr = new StringBuilder("{records:[");
		try { 
	        conn = ConnectionManage.getInstance().getDWConnection();
	        st = conn.createStatement();
	       // out.print("{success:true}");
	       	rs = st.executeQuery(querySql);
	       	//int index = 0;
	       	while(rs.next()) {
	          // index++;
	       	    resultJsonStr.append("{channel_level:'");
	           resultJsonStr.append(rs.getString(1) + "',channel_lname:'");
	           resultJsonStr.append(rs.getString(2) + "',min_val:'");
	           resultJsonStr.append(rs.getString(3) + "',max_val:'");
	           resultJsonStr.append(rs.getString(4) + "'}");
	           //if(index != 4)//比较笨的方法
	               resultJsonStr.append(",");
	       }
	       resultJsonStr.delete(resultJsonStr.length()-1,resultJsonStr.length());
	       resultJsonStr.append("]}");
	       log.debug("the json str : " + resultJsonStr.toString());
	       out.print(resultJsonStr.toString());
	       log.debug("done!");
	    } catch (Exception e) {
	        e.printStackTrace();
	        log.error(e.getMessage(), e);
	    	log.info("not success!");
	    } finally {
	        ConnectionManage.getInstance().releaseConnection(conn);
	    }
	}
%>
<%!
	private static final Logger log = Logger.getLogger("server_tier for ng");
	private void modify(HttpServletRequest request,HttpServletResponse response,JspWriter out) throws Exception{
    	String[] ids = request.getParameter("ids").split(",");
     	String[] mins = request.getParameter("mins").split(",");
     	String[] maxs = request.getParameter("maxs").split(",");
     	Connection conn = null;
     	PreparedStatement ps = null;
     	PreparedStatement psLog = null;
     	String loginname = (String)request.getSession(false).getAttribute("loginname");
     	Calendar temp = Calendar.getInstance();
     	temp.add(Calendar.MONTH,1);
     	DateFormat formater = new SimpleDateFormat("yyyy-MM");
     	String effDate = formater.format(temp.getTime()) + "-01";
     	log.debug("genarated effdate : " + effDate);
     	String modifyPsSql = " update NMK.DIM_channel_level set min_val=?, max_val=?,channel_lname=? where channel_level=?";//由于张莹觉得页面中的CHANNEL_LNAME没有跟着一起变，所以...加上channel_lname
     	String logSql = "insert into nmk.ai_channel_level_hist (channellevel, min_val, max_val, CHANGE_STAFF,EFF_DATE) values(?,?,?,'" + loginname +"','" + effDate + "')";
     	try{
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(modifyPsSql);
			psLog = conn.prepareStatement(logSql);
			log.debug("ids.length : " + ids.length);
			for(int i = 0; i<ids.length; i++) {
				ps.setString(1,mins[i]);
				ps.setString(2,maxs[i]);
				String descVal = mins[i] + "-" + maxs[i] + "分";
				ps.setString(3,descVal);
				ps.setString(4,ids[i]);//modified 原来是3
				ps.addBatch();
				psLog.setString(1,ids[i]);
				psLog.setString(2,mins[i]);
				psLog.setString(3,maxs[i]);
				psLog.addBatch();
     		}
     		log.debug("excuting : " + ps.executeBatch());
     		log.debug("loging hist : " + psLog.executeBatch());
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
