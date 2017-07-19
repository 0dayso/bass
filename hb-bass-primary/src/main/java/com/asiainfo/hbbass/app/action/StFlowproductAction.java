package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.util.AIDateUtil;
import com.asiainfo.hbbass.irs.action.Action;

public class StFlowproductAction extends Action{
	@SuppressWarnings("unused")
	private static Logger LOG = Logger
	.getLogger(FlowPackageMaintainAction.class);
//订购用户数
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
		String sql="select time_id,sum(order_num) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='订购用户数"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"' baseFontSize='11' showBorder='0'  numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='82000000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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
//使用订购数
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
		String sql="select time_id,sum(use_num) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='使用订购数"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+" 'baseFontSize='11'showBorder='0' numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='61500000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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
//新增订购数
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
		String sql="select time_id,sum(new_num) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='新增订购数"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11' showBorder='0'  numberScaleValue='10000' numberScaleUnit='万'  anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='20500000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000'  lineThickness='2' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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

//业务收入
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
		String sql="select time_id,sum(busi_charge) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='业务收入"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11' showBorder='0' numberScaleValue='10000' numberScaleUnit='万元'  anchorBoderColor='000000' bgColor='ffffff'  yAxisMinValue='10900000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40'  lineThickness='2' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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

//业务流量
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
		String sql="select time_id,sum(sum_info_len) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='业务流量"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11'   numberScaleValue='10000' numberScaleUnit='M' showBorder='0'  anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='36200000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40' lineThickness='2' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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

//流量单价
public void getFlowSTCharge(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
		String sql="select time_id,float(sum(busi_charge))/sum(sum_info_len) from NMK.ST_flow_product where 1=1 and time_id between "+AIDateUtil.getMonth("yyyyMM",time_id,-5)+" and "+time_id ;
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by time_id order by time_id";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='流量单价"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+"'baseFontSize='11'  numberScaleValue='0.1' numberScaleUnit='元/M' showBorder='0'  anchorBoderColor='000000' bgColor='ffffff' yAxisMinValue='2'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40' lineThickness='2' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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
			sql+=" and busi_type='"+fee_id+"'";
		}
		sql+=" group by case when flow_rate>2 then '大于210' else trim(char(int(flow_rate*100)))||'' end,";
		sql+=" case when flow_rate>2 then 210 else flow_rate*100 end ";
		sql+=" order by 	case when flow_rate>2 then 210 else flow_rate*100 end ";
		System.out.println(sql);
		ps = conn.prepareStatement(sql);
		rs=ps.executeQuery();
		buf.append("<chart caption='流量使用分布"+AIDateUtil.getMonth("yyyyMM",time_id,-5)+"-"+time_id+" '  baseFontSize='11' showBorder='0'  xAxisName='使用百分比' yAxisMaxValue='1000000' numberScaleValue='10000' numberScaleUnit='万' anchorBoderColor='000000' lineThickness='2' bgColor='ffffff' yAxisMinValue='15000'  showValues='0' alternateHGridColor='#A1BDEA' alternateHGridAlpha='20' divLineColor='000000' divLineAlpha='40' canvasBorderColor='AAA7C1' baseFontColor='000000' lineColor='000000'>");
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
