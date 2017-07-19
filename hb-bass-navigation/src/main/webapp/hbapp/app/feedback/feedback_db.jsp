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
		String opp_nbr = request.getParameter("opp_nbr");
		String acc_nbr = request.getParameter("acc_nbr");
		String manager_name = request.getParameter("manager_name");
		
		String manager_id = request.getParameter("manager_id");
				
		String op_area = request.getParameter("op_area");
		
		String police = request.getParameter("police");
		
		String op_date = request.getParameter("op_date");
		
		String message="";
		//录入人登录名、地区代码
		String loginname=(String)session.getAttribute("loginname");
		String area_id=(String)session.getAttribute("area_id");
		Connection conn = null;
		
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
			conn.setAutoCommit(false);
			ResultSet rs = null;
			int count = 0;

			//Statement stat = conn.createStatement();
			String sqlexit=" select count(*) count from compete_oppstate where opp_nbr='"+opp_nbr+"' or acc_nbr='"+acc_nbr+"' with ur";
			//System.out.println("------------"+sqlexit);
			
			PreparedStatement psQuery = conn.prepareStatement(sqlexit);
			rs = psQuery.executeQuery();
			while(rs.next()){
				count = rs.getInt("count");
			}if(count > 0){
				psQuery.close();
				returnValue.append("数据已经录入，请勿重复录入！");
			}
			else
			{
				String sql = "insert into compete_oppstate(opp_nbr,acc_nbr,name,manager_id,area,police,date,state,insertdate,insertman,city_id) values('"+
					opp_nbr+"','"+acc_nbr+"','"+manager_name+"','"+manager_id+"','"+op_area+"','"+police+"',date('"+op_date+"'),'1',current_timestamp,'"+loginname+"','"+cityCodeMap.get(area_id)+"')";
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
else if ("singlemod".equals(actionType))
	{
		String opp_nbr = request.getParameter("opp_nbr");
		String acc_nbr = request.getParameter("acc_nbr");
		String manager_name = request.getParameter("manager_name");
		manager_name=new String(manager_name.getBytes("ISO-8859-1"),"utf-8");
		
		String manager_id = request.getParameter("manager_id");
				
		String op_area = request.getParameter("op_area");
		op_area=new String(op_area.getBytes("ISO-8859-1"),"utf-8");
		
		String police = request.getParameter("police");
		police=new String(police.getBytes("ISO-8859-1"),"utf-8");
		
		String op_date = request.getParameter("op_date");
		
		String message="";
		//录入人登录名、地区代码
		String loginname=(String)session.getAttribute("loginname");
		String area_id=(String)session.getAttribute("area_id");
		Connection conn = null;
		
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
			conn.setAutoCommit(false);
			/*
			String sql = "insert into COMPETE_OPPSTATE(opp_nbr,acc_nbr,name,manager_id,area,police,date,state,insertdate,insertman,city_id) values('"+
					opp_nbr+"','"+acc_nbr+"','"+manager_name+"','"+manager_id+"','"+op_area+"','"+police+"',date('"+op_date+"'),'1',current_timestamp,'"+loginname+"','"+cityCodeMap.get(area_id)+"');";
			*/
			String sql = "update compete_oppstate set opp_nbr='"+opp_nbr+"',acc_nbr='"+acc_nbr+"',name='"+manager_name+"',manager_id='"+manager_id+"',area='"+op_area+"',police='"+police+"',date=date('"+op_date+"'),insertdate=current_timestamp,insertman='"+loginname+"',city_id='"+cityCodeMap.get(area_id)+"' where opp_nbr='"+opp_nbr+"' and acc_nbr='"+acc_nbr+"'";
			PreparedStatement ps = conn.prepareCall(sql);
			System.out.println("sql = "+sql);
			ps.execute();
			ps.close();
			conn.commit();
			returnValue.append("反馈数据修改成功！请到“回流反馈号码查询页面”查询修改后数据。");			
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.append("反馈数据修改失败！");
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
	else if ("singledel".equals(actionType))
	{
		String opp_nbr = request.getParameter("opp_nbr");
		String acc_nbr = request.getParameter("acc_nbr");
		
		Connection conn = null;
		
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
			conn.setAutoCommit(false);
			String sql = "delete from compete_oppstate where opp_nbr='"+opp_nbr+"' and acc_nbr='"+acc_nbr+"'";
			PreparedStatement ps = conn.prepareCall(sql);
			System.out.println("sql = "+sql);
			ps.execute();
			ps.close();
			conn.commit();
			returnValue.append(acc_nbr+" 反馈数据删除成功！");			
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.append(acc_nbr+"反馈数据删除失败！");
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
