<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.component.json.JsonHelper"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String action = request.getParameter("action");
	if("query".equalsIgnoreCase(action)) {
		String sql = request.getParameter("sql");
		Object result = SQLQueryContext.getInstance().getSQLQuery("json","JDBC_HB",false).query(sql);
		System.out.print("{records:" + result + "}");
		out.print("{records:" + result + "}");
		/*
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		String sql = request.getParameter("sql");
		try {
			StringBuilder resultJsonStr = new StringBuilder("{records:[");
			conn = ConnectionManage.getInstance().getDWConnection();	
			st = conn.createStatement();
			rs = st.executeQuery(sql);
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
	       //System.out.print("the json str : " + resultJsonStr.toString());
	       out.print(resultJsonStr.toString());
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		*/
		
	} else if("modify".equalsIgnoreCase(action)) {
		modify(request,response,out);
	}

%>

<%!
	private static Logger log = Logger.getLogger("coreCustAction");
	private void modify(HttpServletRequest request,HttpServletResponse response,JspWriter out) throws Exception{
    	String[] ids = request.getParameter("ids").split(",");
     	String[] firsts = request.getParameter("firsts").split(",");
     	String[] seconds = request.getParameter("seconds").split(",");
     	String[] thirds = request.getParameter("thirds").split(",");
     	Connection conn = null;
     	PreparedStatement ps = null;
     	PreparedStatement psLog = null;
     	String loginname = (String)request.getSession(false).getAttribute("loginname");
     	  
     	String modifyPsSql = " update NMK.DIM_CTT_WARNRULE set first_warn_value=?,sec_warn_value=?,third_warn_value=? where WARN_TYPE_ID  =?";
     	
     	String logSql = "insert into NMK.DIM_CTT_WARNRULE_HIST (WARN_TYPE_ID, first_warn_value,sec_warn_value, third_warn_value, ORI_first_warn_value,ORI_sec_warn_value,ORI_third_warn_value , modify_user)" +
     	" select WARN_TYPE_ID,?+0,?+0,?+0, first_warn_value,sec_warn_value,third_warn_value,'" + loginname + "' from NMK.DIM_CTT_WARNRULE where warn_type_id=?";
     	try{
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			psLog = conn.prepareStatement(logSql);
			ps = conn.prepareStatement(modifyPsSql);
			log.debug("ids.length : " + ids.length);
			for(int i = 0; i<ids.length; i++) {
				log.debug("firsts[i] : " + firsts[i] + " ; " + "seconds[i] : " + seconds[i] + " ; " + "thirds[i] : " + thirds[i]);
				if(firsts[i].equalsIgnoreCase(""))
					firsts[i]= null;
				if(seconds[i].equalsIgnoreCase(""))
					seconds[i]= null;
				if(thirds[i].equalsIgnoreCase(""))
					thirds[i]= null;
				psLog.setString(1,firsts[i]);
				psLog.setString(2,seconds[i]);
				psLog.setString(3,thirds[i]);
				psLog.setString(4,ids[i]);
				
				psLog.addBatch();
				ps.setString(1,firsts[i]);
				ps.setString(2,seconds[i]);
				ps.setString(3,thirds[i]);
				ps.setString(4,ids[i]);
				ps.addBatch();
     		}
     		log.debug("loging hist : " + psLog.executeBatch());
     		log.debug("excuting : " + ps.executeBatch());
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