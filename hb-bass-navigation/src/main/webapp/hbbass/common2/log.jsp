<%@page contentType="text/html; charset=GB2312" %><%-- 有中文字符 --%>
<%@page import="bass.common2.ConnectionManage"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%!static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JspAddCountAction");%>
<%
	Connection conn = null;
	try {
		log.debug("adding count");
		String opertype = request.getParameter("opertype");
		String opername = request.getParameter("opername");
		String catacode = request.getParameter("catacode");
		if(opername !=null)
			opername = new String(opername.getBytes("iso-8859-1"),"UTF-8" );
		if(catacode !=null)
			catacode = new String(catacode.getBytes("iso-8859-1"),"UTF-8" );
		
		String loginName = (String)session.getAttribute("loginname");
		String ipAddr = request.getRemoteAddr();
		String area_id = (String)session.getAttribute("area_id");
		
		log.debug("loginName : " + loginName + "; area_id : " + area_id + "; ipAddr : " + ipAddr + "; opername : " + opername + "; opertype : " + opertype);
		
		String sql = "insert into FPF_VISITLIST (LOGINNAME,VISITYEAR,VISITMONTH,VISITDATE,VISITTIME,IPADDR,AREA_ID,FUNCCODE,THEMECODE,CATACODE,menuitemid,OPERname,OPERTYPE) "
		+" values(?,year(current_date),month(current_date),day(current_date),replace(char(current_time),'.',':'),?,?,'966','运营监控报表',?,?,?,?)";
		
		log.debug("SQL:"+sql);
		conn = ConnectionManage.getInstance().getWEBConnection();
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1,loginName);
		ps.setString(2,ipAddr);
		ps.setInt(3,Integer.parseInt(area_id));
		ps.setString(4,catacode);
		ps.setInt(5,"运营监控报表".equalsIgnoreCase(catacode)?1068:1022);
		ps.setString(6,opername);
		ps.setString(7,opertype);
		ps.execute();
		ps.close();
		
	} catch (Exception e) {
		e.printStackTrace();
		log.error(e.getMessage(),e);
	} finally {
		ConnectionManage.getInstance().releaseConnection(conn);
	}
%>