package com.asiainfo.hbbass.app.action;

import java.io.*;
import java.sql.*;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.util.AIDateUtil;
import com.asiainfo.hbbass.irs.action.Action;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("unused")
public class GprsAssessmentAction extends Action {
	private static Logger LOG = Logger
			.getLogger(FlowPackageMaintainAction.class);

	public void getGprsOrderUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select time_id,sum(eff_user) from nmk.St_Flow_Gprs_Order_Ms where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by time_id order by time_id";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='GPRS订购用户数"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"' baseFontSize='11' showBorder='0'  numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"' ") ;
						buf.append("value='"+rs.getDouble(2)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}
	
	public void getGprsOrderNew(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select time_id,sum(new_user) from nmk.St_Flow_Gprs_Order_Ms where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by time_id order by time_id";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='GPRS新增用户数"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+" 'baseFontSize='11' showBorder='0' numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"' ") ;
						buf.append("value='"+rs.getDouble(2)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}
	
	public void getAvarageFlow(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select time_id,sum(gprs_flow)/sum(user_num)/1024/1024 from nmk.St_Flow_Gprs_charge_Ms where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by time_id order by time_id";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='GPRS人均流量"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11' showBorder='0'  numberScaleValue='1' numberScaleUnit='M'  anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000'  lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"' ") ;
						buf.append("value='"+rs.getDouble(2)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}
	
	
	public void getFlowCharge(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select time_id,float(sum(gprs_charge))/sum(gprs_flow)*1024*1024 from nmk.St_Flow_Gprs_charge_Ms where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by time_id order by time_id";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='流量单价"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11' showBorder='0' numberScaleUnit='元'  anchorBoderColor='000000' bgColor='ffffff'  yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40'  lineThickness='2' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"' ") ;
						buf.append("value='"+rs.getDouble(2)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}

	
	public void getFlowMou(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select time_id,float(sum(gprs_dura))/sum(user_num)/60 from nmk.St_Flow_Gprs_charge_Ms where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by time_id order by time_id";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='MOU"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11'  showBorder='0'  anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40' lineThickness='2' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"' ") ;
						buf.append("value='"+rs.getDouble(2)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}
	
	
	public void getFlowUse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String time_id = request.getParameter("time_id");
		String area_code=request.getParameter("area_code");
		String county_code=request.getParameter("county_code");
		String zone_code=request.getParameter("zone_code");
		String fee_id=request.getParameter("fee_id");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder buf = null;
		buf = new StringBuilder();
		
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select case when flow_rate>2 then '大于210' else trim(char(int(flow_rate*100)))||'' end, case when flow_rate>2 then 210 else flow_rate*100 end,sum(user_num) from nmk.St_Flow_Gprs_fee_Ms where 1=1 and time_id ="+time_id ;
				if(area_code!=""&& area_code!=null){
					sql+=" and area_code='"+area_code+"'";
				}
				if(county_code!=""&& county_code!=null){
					sql+=" and county_code='"+county_code+"'";
				}
				if(zone_code!=""&& zone_code!=null){
					sql+=" and zone_code='"+zone_code+"'";
				}
				if(fee_id!=""&& fee_id!=null){
					sql+=" and fee_id='"+fee_id+"'";
				}
				sql+=" group by case when flow_rate>2 then '大于210' else trim(char(int(flow_rate*100)))||'' end,";
				sql+=" case when flow_rate>2 then 210 else flow_rate*100 end ";
				sql+=" order by 	case when flow_rate>2 then 210 else flow_rate*100 end ";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
				buf.append("<chart caption='流量使用分布"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+" 'baseFontSize='11' showBorder='0'  xAxisName='使用百分比' numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' lineThickness='2' bgColor='ffffff' yAxisMinValue='0'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
				while(rs.next()){
						buf.append("<set label='"+rs.getString(1)+"'");
						buf.append(" value='"+rs.getDouble(3)+"'/>");
					}
					buf.append("</chart>");
					rs.close();
					ps.close();
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			System.out.println(buf);
			json.put("result",buf.toString());
			response.setCharacterEncoding("UTF-8"); 
			outs = response.getWriter();
			outs.print(json);
		}
}
