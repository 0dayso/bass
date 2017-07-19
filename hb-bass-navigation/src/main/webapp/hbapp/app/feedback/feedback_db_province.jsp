<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.HashMap,java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%
	out.clear();
	String actionType = request.getParameter("actiontype");
	StringBuffer returnValue = new StringBuffer();
	System.out.println("actiontype = "+actionType);
	HashMap cityCodeMap = new HashMap();
	cityCodeMap.put("0","0");
	cityCodeMap.put("11","HB.WH");
	cityCodeMap.put("12","HB.HS");
	cityCodeMap.put("13","HB.EZ");
	cityCodeMap.put("14","HB.YC");
	cityCodeMap.put("15","HB.ES");
	cityCodeMap.put("16","HB.SY");
	cityCodeMap.put("17","HB.XF");
	cityCodeMap.put("18","HB.JH");
	cityCodeMap.put("19","HB.XN");
	cityCodeMap.put("20","HB.JZ");
	cityCodeMap.put("23","HB.JM");
	cityCodeMap.put("24","HB.SZ");
	cityCodeMap.put("25","HB.HG");
	cityCodeMap.put("26","HB.XG");


	if ("singleadd".equals(actionType))
	{
		// request.setCharacterEncoding("UTF-8");
		String employee_num = request.getParameter("employee_num");
		
		String employee_part_name = request.getParameter("employee_part_name");
		
		String group_custname = request.getParameter("group_custname");
		
		String group_custid = request.getParameter("group_custid");
		
		String net_portin = request.getParameter("net_portin");
		
		String net_newacc_nbr = request.getParameter("net_newacc_nbr");
		
		String opbackdate = request.getParameter("opbackdate");
		
		String message="";
		//录入人登录名、地区代码
		String loginname=(String)session.getAttribute("loginname");
		String area_id=(String)session.getAttribute("area_id");
		Connection conn = null;
		
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/AiomniDB");
			conn.setAutoCommit(false);
			ResultSet rs = null;
			int count = 0;

			//Statement stat = conn.createStatement();
			//插入之前先查询出是否已经插入了数据
			String querySql = "select count(*) count from compete_oppstate_province where net_portin='"+net_portin+"' and net_newacc_nbr='"+net_newacc_nbr+"'";
			
			System.out.println("querySql = "+querySql);
			PreparedStatement psQuery = conn.prepareStatement(querySql);
			rs = psQuery.executeQuery();
			while(rs.next()){
				count = rs.getInt("count");
			}
			if(count > 0){
				psQuery.close();
				returnValue.append("数据已经录入，请勿重复录入！");
			}else{
				String sql = "insert into compete_oppstate_province(employee_part_name,employee_num,group_custname,group_custid,net_portin,net_newacc_nbr,opbackdate,city_id) values('"+
					employee_part_name+"','"+employee_num+"','"+group_custname+"','"+group_custid+"','"+net_portin+"','"+net_newacc_nbr+"',date('"+opbackdate+"'),"+cityCodeMap.get(area_id)+")";
				
				PreparedStatement ps = conn.prepareCall(sql);
				System.out.println("sql = "+sql);
				ps.execute();
				ps.close();
				conn.commit();
				returnValue.append("数据录入成功！请到“回流反馈号码查询页面”查询录入数据");
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
			//System.out.println(e.getStackTrace());
			returnValue.append("数据录入失败！");
		}
		finally
		{
			if (conn != null)
			{
				conn.setAutoCommit(true);
				conn.close();
			}
		}		
		out.print(returnValue.toString());
	}
%>
