<%@page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="java.sql.ResultSet"%>
<%!private static final Logger log = Logger.getLogger("server_tier for ng");%>
<%
    //����仰û������request.setCharacterEncoding("gb2312");
    //ʹ��groupcode��Ϊ��λ����id�Ķ�λ��ʶ
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
	        //path = "/hbbass/appforng/preorder.jsp";//Ӧ��д��ͨ�õ�
	        String app_name1 = request.getParameter("app_name1");
	       log.debug("temp : app_name1(before convert) : " + app_name1);
	        
	       /* ext3 ��������
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
	       	
	       	path = "/hbbass/ngbass/preorder.jsp";//Ӧ��д��ͨ�õ�. �ǳ���ȷ������Σ�����Ŀ¼��(appforng-> ngbass)...
    	}
    
        conn = ConnectionManage.getInstance().getDWConnection();
        st = conn.createStatement();
        int count = 0;
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
            //�ı���ҵ���߼�����Ҫ�����¼��Ӧ���Ȳ��¼������Ѿ������˼�¼��Ϊ���¼�¼
           log.debug("��ѯ��¼ �� " + sqlSelect);
            ResultSet rs = st.executeQuery(sqlSelect); 
            if(rs.next()) {
               log.debug("�������м�¼ : " + sqlUpdate);
               count = st.executeUpdate(sqlUpdate);//�������м�¼
           }
           else {
               log.debug("�����¼�¼ : " + sql);
               count = st.executeUpdate(sql);//�����¼�¼
           }
               
        } else
	        count = st.executeUpdate(sql);
        log.info(count + " row(s) affect.");
        //throw new Exception("some kind of reason");
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
           out.print("{success:true}");
       } else {
           	request.setAttribute("result","���³ɹ�!");//���ﲻ�漰ҵ���߼�����
      		getServletContext().getRequestDispatcher(path).forward(request,response);
       }
        log.info("done!");
    } catch (Exception e) {
        e.printStackTrace();
        log.error(e.getMessage(), e);
        if("insert".equalsIgnoreCase(request.getParameter("opertype"))) {
            out.print("{success:false,errorInfo:'" + e.getMessage() + "'}");
        } else {
            request.setAttribute("result","����ʧ��!");
            getServletContext().getRequestDispatcher(path).forward(request,response);
        }
        
    	log.info("not success!");
    } finally {
        ConnectionManage.getInstance().releaseConnection(conn);
    }
%>