<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.sql.*"%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%--copied from modifylevel.jsp
	
 --%>
<% 
	log.debug("modifyalert.jsp in" + ";;; action : " + request.getParameter("action"));

	if("modify".equalsIgnoreCase(request.getParameter("action")))
	       modify(request,response,out);
	else { 
	    //查询
	    Connection conn = null;
	    log.debug("query in");
		//PreparedStatement ps = null;
		Statement st = null;
		ResultSet rs = null;
		String querySql = " select zb_code, zb_name, max_value, min_value,alert_level from nmk.ai_channel_kpi_threshold ";
		StringBuilder resultJsonStr = new StringBuilder("{records:[");
		try { 
	        conn = ConnectionManage.getInstance().getDWConnection();
	        st = conn.createStatement();
	       // out.print("{success:true}");
	       	rs = st.executeQuery(querySql);
	       	//int index = 0;
	       	while(rs.next()) {
	          // index++;
	       	    resultJsonStr.append("{zb_code:'");
	           resultJsonStr.append(rs.getString(1) + "',zb_name:'");
	           resultJsonStr.append(rs.getString(2) + "',max_value:'");
	           resultJsonStr.append(rs.getString(3) + "',min_value:'");
	           resultJsonStr.append(rs.getString(4) + "',alert_level:'");
	           resultJsonStr.append(rs.getString(5) + "'}");
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
     	String[] ids2 = request.getParameter("ids2").split(",");
     	log.debug("ids : " + ids);
     	log.debug("mins : " + mins);
     	log.debug("maxs : " + maxs);
     	log.debug("ids2 : " + ids2);
     	Connection conn = null;
     	PreparedStatement ps = null;
     	String modifyPsSql = " update nmk.ai_channel_kpi_threshold set min_value=?, max_value=? where zb_code=? and alert_level=?";
     	// no log any more. String logSql = "insert into nmk.ai_channel_level_hist (channellevel, min_val, max_val, CHANGE_STAFF,EFF_DATE) values(?,?,?,'" + loginname +"','" + effDate + "')";
     	try{
			conn = ConnectionManage.getInstance().getDWConnection();
			ps = conn.prepareStatement(modifyPsSql);
			log.debug("ids.length : " + ids.length);
			for(int i = 0; i<ids.length; i++) {
				ps.setString(1,mins[i]);
				ps.setString(2,maxs[i]);
				ps.setString(3,ids[i]);
				ps.setString(4,ids2[i]);
				ps.addBatch();
     		}
     		log.debug("excuting : " + ps.executeBatch());
     		out.print("{success:true}");
     	} catch(Exception e) {
     	   	out.print("{success:false,errorInfo:'" + e.getMessage() + "'}");
     	    e.printStackTrace();
     	    log.error(e.getMessage());
     	}finally {
	        ConnectionManage.getInstance().releaseConnection(conn);
	    }
}
%>
