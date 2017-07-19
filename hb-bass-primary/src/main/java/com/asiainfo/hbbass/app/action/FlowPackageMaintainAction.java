package com.asiainfo.hbbass.app.action;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import org.apache.commons.lang.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import net.sf.json.JSONObject;
@SuppressWarnings("unused")
public class FlowPackageMaintainAction  extends Action{
	

	private static Logger LOG = Logger.getLogger(FlowPackageMaintainAction.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();

	public void flowPackageInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fee_id = request.getParameter("fee_id");
		System.out.print(fee_id);
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result="";
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select createorg,fee_id,plan_id,fee_name,plan_kind,is_main,term_kind,fee,in_prov_flow,out_prov_flow,nation_flow,in_time,is_discount," +
						"case when status=1  then '是' else '否' end as status,value(remark,'无') as remark from  nwh.gprs_fee where fee_id='"+fee_id+"'";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
					while(rs.next()){
						result+=rs.getString(1)+","+rs.getString(2)+","+rs.getString(3)+","+rs.getString(4)+","+rs.getString(5)+","+rs.getString(6)+","+rs.getString(7)+","+rs.getString(8)+","+rs.getString(9)+","+rs.getString(10)+","+rs.getString(11)+","+rs.getString(12)+","+rs.getString(13)+","+rs.getString(14)+","+rs.getString(15);	
					}
					System.out.println(result);
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
			json.put("flowInfo",result);
			json.put("flag", "update");
			outs = response.getWriter();
			outs.print(json);
		}
	
	

	public void flowPackageInsert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		String fee_id = request.getParameter("fee_id_v");
		String plan_id=request.getParameter("plan_id_v");
		String createorg = request.getParameter("createorg_v");
		String plan_kind = request.getParameter("plan_kind_v");
		String fee_name=request.getParameter("fee_name_v");
		String is_main = request.getParameter("is_main_v");
		String term_kind=request.getParameter("term_kind_v");
		String fee = request.getParameter("fee_v");
		String in_prov_flow = request.getParameter("in_prov_flow_v");
		String out_prov_flow = request.getParameter("out_prov_flow_v");
		String nation_flow = request.getParameter("nation_flow_v");
		String in_time = request.getParameter("in_time_v");
		String is_discount = request.getParameter("is_discount_v");
		String status = request.getParameter("status_v");
		String remark = request.getParameter("remark_v");
		String flagSql="select fee_id from nwh.gprs_fee where fee_id='"+fee_id+"'";
		String result = "2";
		double fee_v=0;
		double in_prov_v=0;
		double out_prov_v=0;
		double nation_v=0;
		int status_v;
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				ps = conn.prepareStatement(flagSql);
				rs=ps.executeQuery();
				boolean flag=true;
				if(rs.next()){
					flag=false;
					result = "3";
					//request.setAttribute("result","插入失败");
				}
					rs.close();
					ps.close();
				if(flag){
					if (StringUtils.isNotEmpty(fee)) {
						 fee_v=Double.parseDouble(fee);
					}
					
					if (StringUtils.isNotEmpty(in_prov_flow)) {
						 in_prov_v=Double.parseDouble(in_prov_flow);
					}
					
					if (StringUtils.isNotEmpty(out_prov_flow)) {
						 out_prov_v=Double.parseDouble(out_prov_flow);
					}
					
					if (StringUtils.isNotEmpty(nation_flow)) {
						 nation_v=Double.parseDouble(nation_flow);
					}
					
					if(status.equals("是")){
						status_v=1;
					}else {
						status_v=0;
					}
					
					java.util.Date date = new java.util.Date();
					
					String sql=("insert into nwh.gprs_fee(fee_id,createorg,plan_id,fee_name,plan_kind,is_main,term_kind,fee,in_prov_flow,out_prov_flow,nation_flow,in_time,is_discount,status,remark,create_time) values ('"+fee_id+"','"+createorg+"','"+plan_id+"','"+fee_name+"','"+plan_kind+"','"+is_main+"','"+term_kind+"',"+fee_v+","+in_prov_v+","+out_prov_v+","+nation_v+",'"+in_time+"','"+is_discount+"',"+status_v+",'"+remark+"','"+new Timestamp(date.getTime())+"')");
					System.out.println(sql);
					ps = conn.prepareStatement(sql);
					System.out.println(sql);
					ps.execute();
					ps.close();
					conn.commit();
					result = "1";
					//request.setAttribute("result","插入成功");
				}
			} catch (SQLException e) {
				try {
					conn.rollback();
					
				} catch (SQLException e1) {
					e1.printStackTrace();
					//request.setAttribute("result","插入失败");
				}
				e.printStackTrace();
				//request.setAttribute("result","插入失败");
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				//response.sendRedirect("/hbapp/app/flowOperation/flowPackage/flowPackage.jsp");
			}
			PrintWriter outs = null;
			JSONObject json = new JSONObject();
			json.put("result",result);
			outs = response.getWriter();
			outs.print(json);
		}
	
	public void flowPackageUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		String fee_id=request.getParameter("fee_id_v");
		String plan_id = request.getParameter("plan_id_v");
		String plan_kind = request.getParameter("plan_kind_v");
		String is_main = request.getParameter("is_main_v");
		String term_kind = request.getParameter("term_kind_v");
		String fee = request.getParameter("fee_v");
		String in_prov_flow = request.getParameter("in_prov_flow_v");
		String out_prov_flow = request.getParameter("out_prov_flow_v");
		String nation_flow = request.getParameter("nation_flow_v");
		String in_time = request.getParameter("in_time_v");
		String is_discount = request.getParameter("is_discount_v");
		String remark = request.getParameter("remark_v");
		double fee_v=0;
		double in_prov_v=0;
		double out_prov_v=0;
		double nation_v=0;
			Connection conn = null;
			PreparedStatement ps = null;
			try {
					conn = ConnectionManage.getInstance().getDWConnection();
					conn.setAutoCommit(false);
					if(fee!=null || fee==""){
						 fee_v=Double.parseDouble(fee);
					}
					
					if(in_prov_flow!=null ||in_prov_flow==""){
						 in_prov_v=Double.parseDouble(in_prov_flow);
					}
					
					if(out_prov_flow!=null ||out_prov_flow=="" ){
						 out_prov_v=Double.parseDouble(out_prov_flow);
					}
					
					if(nation_flow!=null ||nation_flow==""){
						 nation_v=Double.parseDouble(nation_flow);
					}
					java.util.Date date = new java.util.Date();
					String sql="update nwh.gprs_fee set plan_id='"+plan_id+"',plan_kind='"+plan_kind+"',is_main='"+is_main+"',term_kind='"+term_kind+"',fee="+fee_v+",in_prov_flow="+in_prov_v+",out_prov_flow="+out_prov_v+",nation_flow="+nation_v+",in_time='"+in_time+"',is_discount='"+is_discount+"',remark='"+remark+"',update_time='"+new Timestamp(date.getTime())+"' where fee_id= '"+fee_id+"'";
					System.out.println(sql);
					ps = conn.prepareStatement(sql);
					ps.execute();
					ps.close();
					conn.commit();
					//request.setAttribute("result","更新成功");
			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
					//request.setAttribute("result","更新失败");
				}
				e.printStackTrace();
				//request.setAttribute("result","更新失败");

			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				response.sendRedirect("/hb-bass-navigation/hbapp/app/flowOperation/flowPackage/flowPackage.jsp");
			}
		}
	
	
	public void getFeeInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fee_id = request.getParameter("fee_id");
		System.out.print(fee_id);
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result="";
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				String sql="select fee_id,fee_name,status,createorg from  nwh.fee where fee_id='"+fee_id+"'";
				System.out.println(sql);
				ps = conn.prepareStatement(sql);
				rs=ps.executeQuery();
					while(rs.next()){
						System.out.println(rs.getString(1));
						String plan_kind = "可选";
						//如果FEE_ID以B开头则PLAN_KIND为基本，否则为可选
						if(rs.getString(1).substring(0, 1).equals("B")){
							plan_kind = "基本";
						}
						result+=rs.getString(1)+"|"+rs.getString(2)+"|"+rs.getString(3)+"|"+rs.getString(4)+"|"+plan_kind;	
					}
					System.out.println(result);
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
			json.put("feeInfo",result);
			outs = response.getWriter();
			outs.print(json);
		}
}
