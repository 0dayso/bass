<%@page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%!private static final Logger log = Logger.getLogger("server_tier for ng");%>
<% 
	log.debug("charset : " + request.getCharacterEncoding());
	String channel_code = request.getParameter("channel_code");
   	String o_channellevel = request.getParameter("o_channellevel");
   	String channel_level = request.getParameter("channel_level");
   	String change_staff = request.getParameter("change_staff");
   	String change_reason = request.getParameter("change_reason");
    log.debug("updatemodel in !");
    Connection conn = null;
    Statement st = null;
    //insert into "NMK"."AI_CHANNEL_SUM_HIST" (CHANNEL_CODE,"O_CHANNEL_LEVEL", "CHANNEL_LEVEL","CHANGE_REASON", "CHANGE_STAFF",eff_date)
	//values('HB.HS.03.02.16','2','1','for test only','testid','2009-12-29')

	Calendar temp = Calendar.getInstance();
   /*
   	modified 生效日期改成当时 
   	old one
   	temp.add(Calendar.MONTH,1);
    DateFormat format = new SimpleDateFormat("yyyy-MM");
    String effDate = format.format(temp.getTime()) + "-01";
    */
    
    DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String effDate = format.format(temp.getTime());
	String sql = "insert into NMK.AI_CHANNEL_SUM_HIST (CHANNEL_CODE,O_CHANNEL_LEVEL,CHANNEL_LEVEL,CHANGE_REASON,CHANGE_STAFF,EFF_DATE) values('" + channel_code + "'," + o_channellevel + "," + channel_level + ",'" + change_reason + "','" + change_staff + "','" +effDate + "')";
    log.debug("sql : " + sql);
    try { 
        conn = ConnectionManage.getInstance().getDWConnection();
        st = conn.createStatement();
        int count = 0;
        count = st.executeUpdate(sql);
        log.debug(count + " row(s) affect.");
        out.print("{success:true}");
        log.debug("done!");
    } catch (Exception e) {
        out.print("{success:false,errorInfo:'" + e.getMessage() + "'}");
        e.printStackTrace();
        log.error(e.getMessage(), e);
    	log.debug("not success!");
    } finally {
        ConnectionManage.getInstance().releaseConnection(conn);
    }
%>