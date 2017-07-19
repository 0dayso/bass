<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.HashMap,java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage,bass.database.report.ReportBean"%>
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
		manager_name=new String(manager_name.getBytes("ISO-8859-1"),"utf-8");
		
		String manager_id = request.getParameter("manager_id");
				
		String op_area = request.getParameter("op_area");
		op_area=new String(op_area.getBytes("ISO-8859-1"),"utf-8");
		
		String police = request.getParameter("police");
		police=new String(police.getBytes("ISO-8859-1"),"utf-8");
		
		String op_date = request.getParameter("op_date");
		
		String message="";
		//¼���˵�¼������������
		String loginname=(String)session.getAttribute("loginname");
		String area_id=(String)session.getAttribute("area_id");
		Connection conn = null;
		
		try
		{
			conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
			conn.setAutoCommit(false);

			//Statement stat = conn.createStatement();
			String sqlexit=" select opp_nbr from COMPETE_OPPSTATE where opp_nbr='"+opp_nbr+"' or acc_nbr='"+acc_nbr+"' with ur";
			//System.out.println("------------"+sqlexit);
			
			ReportBean rb = new ReportBean();
			rb.execute(sqlexit);
			int num = rb.getRowCount();			
			if(num > 0)
			{
				returnValue.append("�ú��������Ѿ�¼�����");				
			}
			else
			{
				String sql = "insert into COMPETE_OPPSTATE(opp_nbr,acc_nbr,name,manager_id,area,police,date,state,insertdate,insertman,city_id) values('"+
					opp_nbr+"','"+acc_nbr+"','"+manager_name+"','"+manager_id+"','"+op_area+"','"+police+"',date('"+op_date+"'),'1',current_timestamp,'"+loginname+"','"+cityCodeMap.get(area_id)+"');";
				PreparedStatement ps = conn.prepareCall(sql);
				System.out.println("sql = "+sql);
				ps.execute();
				ps.close();
				conn.commit();
				returnValue.append("����¼��ɹ����뵽���������������ѯҳ�桱��ѯ¼������");
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
			//System.out.println(e.getStackTrace());
			returnValue.append("����¼��ʧ�ܣ�");
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
		//¼���˵�¼������������
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
			String sql = "update COMPETE_OPPSTATE set opp_nbr='"+opp_nbr+"',acc_nbr='"+acc_nbr+"',name='"+manager_name+"',manager_id='"+manager_id+"',area='"+op_area+"',police='"+police+"',date=date('"+op_date+"'),insertdate=current_timestamp,insertman='"+loginname+"',city_id='"+cityCodeMap.get(area_id)+"' where opp_nbr='"+opp_nbr+"' and acc_nbr='"+acc_nbr+"'";
			PreparedStatement ps = conn.prepareCall(sql);
			System.out.println("sql = "+sql);
			ps.execute();
			ps.close();
			conn.commit();
			returnValue.append("���������޸ĳɹ����뵽���������������ѯҳ�桱��ѯ�޸ĺ����ݡ�");			
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.append("���������޸�ʧ�ܣ�");
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
			String sql = "delete from COMPETE_OPPSTATE where opp_nbr='"+opp_nbr+"' and acc_nbr='"+acc_nbr+"'";
			PreparedStatement ps = conn.prepareCall(sql);
			System.out.println("sql = "+sql);
			ps.execute();
			ps.close();
			conn.commit();
			returnValue.append(acc_nbr+" ��������ɾ���ɹ���");			
		}
		catch (SQLException e)
		{
			System.out.println(e.getStackTrace());
			returnValue.append(acc_nbr+"��������ɾ��ʧ�ܣ�");
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
