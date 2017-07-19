<%@page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="java.sql.ResultSet"%>
<%!private static final Logger log = Logger.getLogger("server_tier for ng");%>
<%
    //加这句话没有意义request.setCharacterEncoding("gb2312");
    //使用groupcode作为定位类似id的定位标识
    log.info("addremainmsg in !");
    String sql = "";
    String path = "";
    String  sqlSelect = "";
    String sqlUpdate = "";
    Connection conn = null;
    Statement st = null;
    try { 
        log.info("charset : " + request.getCharacterEncoding());
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
	    	log.info("request.getServletPath() : " + request.getServletPath());
	        //path = "/hbbass/appforng/preorder.jsp";//应该写得通用点
	        String app_name1 = request.getParameter("app_name1");
	       log.debug("temp : app_name1(before convert) : " + app_name1);
	        
	       /* ext3 不用这样
	       app_name1 = new String(app_name1.getBytes("iso-8859-1"),"utf-8");
	       log.debug("temp : app_name1(after convert) : " + app_name1);
	       */
	       String remain_type = request.getParameter("remain_type");
	       	String manager_id = request.getParameter("manager_id");
	       	if(manager_id == null)
	       	    manager_id = "12345test";
	       	sql = "insert into remain_config (app_name1 ,remain_type, manager_id) values('" + app_name1 +"'," + remain_type + ",'" + manager_id + "');";
	    	sqlSelect = "select id from remain_config where manager_id='" + manager_id + "' and app_name1 = '" + app_name1 + "'";
	       	sqlUpdate = "update remain_config set remain_type = " + remain_type + " where manager_id='" + manager_id + "' and app_name1 = '" + app_name1 + "'";
	    	log.info("\nsql : " + sql + "\nsqlSelect : " + sqlSelect + "\nsqlUpdate : " + sqlUpdate);
 				     	
        } else {
        	String grpcode = request.getParameter("groupcode");
	        String msg = request.getParameter("msg1");
	        msg = new String(msg.getBytes("iso-8859-1"), "gb2312");
	
	        String datetime = request.getParameter("datetime1");
	    	String tblName = request.getParameter("tablename");
	    	log.info("msg : " + msg + " ;;; datetime1 : " + datetime
	                + " groupcode : " + grpcode + " tableName : " + tblName);
	    	sql = "update " + tblName + " set reminders = '" + msg + "' , reminders_date = date('" + datetime + "') where groupcode = '" + grpcode + "'";
	       
	    	log.info("sql : " + sql);
	       	
	       	path = "/hbbass/ngbass/preorder.jsp";//应该写得通用点. 非常正确，像这次，改了目录名(appforng-> ngbass)...
    	}
    
        conn = ConnectionManage.getInstance().getDWConnection();
        st = conn.createStatement();
        int count = 0;
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
            //改变了业务逻辑，想要插入记录，应该先查记录，如果已经存在了记录则为更新记录
           log.debug("查询记录 ： " + sqlSelect);
            ResultSet rs = st.executeQuery(sqlSelect); 
            if(rs.next()) {
               log.debug("更新已有记录 : " + sqlUpdate);
               count = st.executeUpdate(sqlUpdate);//更新已有记录
           }
           else {
               log.debug("插入新纪录 : " + sql);
               count = st.executeUpdate(sql);//插入新纪录
           }
               
        } else
	        count = st.executeUpdate(sql);
        log.info(count + " row(s) affect.");
        //throw new Exception("some kind of reason");
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
           out.print("{success:true}");
       } else {
           	request.setAttribute("result","更新成功!");//这里不涉及业务逻辑更好
      		getServletContext().getRequestDispatcher(path).forward(request,response);
       }
        log.info("done!");
    } catch (Exception e) {
        e.printStackTrace();
        log.error(e.getMessage(), e);
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
            out.print("{success:false,errorInfo:'" + e.getMessage() + "'}");
        } else {
            request.setAttribute("result","更新失败!");
            getServletContext().getRequestDispatcher(path).forward(request,response);
        }
        
    	log.info("not success!");
    } finally {
        ConnectionManage.getInstance().releaseConnection(conn);
    }
%>