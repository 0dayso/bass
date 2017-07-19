package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * 基站参数维护波动值设置
 * 
 * @author xieliangsong
 * @date 2012-06-01
 */
@SuppressWarnings("unused")
public class BaseSetEditAction extends Action {

	private static Logger log = Logger.getLogger(BaseSetEditAction.class);

	/**
	 * 新增和修改基站波动值
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void updateBaseSet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);

			String region_code = request.getParameter("region_code");
			String wave = request.getParameter("wave");
			String etl_cycle_id = request.getParameter("etl_cycle_id");
		
			//波动值保留为小数，保留小数点后四位
		  double wave_fomt = Double.parseDouble(wave)/100;
		  DecimalFormat df = new DecimalFormat("0.0000");
		  String wave_str = df.format(wave_fomt);
			
		  //波动值转变为整数
		  DecimalFormat df_i = new DecimalFormat("0000");
		  String wave_int = df_i.format(wave_fomt*10000);
		    
			//获取当前登录人信息
			String userName = (String) request.getSession().getAttribute("loginname");
			
			//获取当前日期
//		  Date da = new Date();
//		  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
//		  String now_date = sdf.format(da);
		  
		  //获取当前时间
		  //SimpleDateFormat sdf_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		  //Date now_time = sdf_time.parse(sdf.format(da));
		  
		  //获取明天时间
//		  GregorianCalendar calendar = new GregorianCalendar(); 
//		  calendar.add(Calendar.DAY_OF_YEAR, 1); 
//		  Date da_tom = calendar.getTime(); 
//		  String tom_date=sdf.format(da_tom);
		    
			//更新基站波动值表
			sql = "update nwh.bureau_cell_cnt_wave set modify_value = ? where region_code = ? ";
			ps = conn.prepareStatement(sql);
			ps.setBigDecimal(1,new BigDecimal(wave_str));
			ps.setString(2, region_code);
			log.debug(sql);
			ps.executeUpdate();
			if(rs != null){rs.close();}
			ps.close();
			
			//更新基站波动默认值表信息
			sql = "update nwh.bureau_default_wave set modify_value = ? where region_code = ? ";
			ps = conn.prepareStatement(sql);
			ps.setBigDecimal(1,new BigDecimal(wave_int));
			ps.setString(2, region_code);	
			log.debug(sql);
			ps.executeUpdate();
			if(rs != null){rs.close();}
			ps.close();
			
			
			//查询基站波动日志表信息
			sql = "select * from nwh.bureau_cell_cnt_wave_log where etl_cycle_id = ? ";
			ps = conn.prepareStatement(sql);
			ps.setBigDecimal(1,new BigDecimal(etl_cycle_id));
			log.debug(sql);
			rs = ps.executeQuery();
			//int count = 0;
			
			//更新基站波动日志表信息
			while (rs.next()) {
				//count = 1;
				if(region_code.equals(rs.getString(1))){
					sql = "update nwh.bureau_cell_cnt_wave_log set modify_value = ?,modify_autor = ?,modify_date = current timestamp where region_code = ? and etl_cycle_id = ? ";
					ps = conn.prepareStatement(sql);
					ps.setBigDecimal(1,new BigDecimal(wave_str));
					ps.setString(2, userName);
					ps.setString(3, region_code);
					ps.setBigDecimal(4,new BigDecimal(etl_cycle_id));	
					log.debug(sql);
					ps.executeUpdate();
				}
			}
			
			//新增基站波动日志表信息
//			if(count == 0){
//				//先查询波动日志表
//				sql = "select * from nwh.bureau_cell_cnt_wave where etl_cycle_id = ? ";
//				ps = conn.prepareStatement(sql);
//				ps.setBigDecimal(1,new BigDecimal(now_date));
//				log.debug(sql);
//				rs = ps.executeQuery();
//				
//				//批量更新波动日志表
//				sql = "insert into nwh.bureau_cell_cnt_wave_log(region_code,lastday_cnt,today_cnt,wave,abs_wave,etl_cycle_id,modify_value,modify_autor,modify_date) values(?,?,?,?,?,?,?,?,?)";
//				ps = conn.prepareStatement(sql);
//				while(rs.next()){
//					ps.setString(1, rs.getString(1));
//					ps.setBigDecimal(2, rs.getBigDecimal(2));
//					ps.setBigDecimal(3, rs.getBigDecimal(3));
//					ps.setBigDecimal(4, rs.getBigDecimal(4));
//					ps.setBigDecimal(5, rs.getBigDecimal(5));
//					ps.setBigDecimal(6, rs.getBigDecimal(6));
//					ps.setBigDecimal(7, rs.getBigDecimal(7));
//					if(rs.getBigDecimal(7) == null){
//					  ps.setString(8, null);
//					  ps.setTimestamp(9, null);
//					}else{
//					  Date dt = new Date();
//					  Timestamp timestamp = new Timestamp(dt.getTime());
//					  ps.setString(8, userName);
//					  ps.setTimestamp(9, timestamp);
//					}
//					log.debug(sql);
//					ps.execute();
//				}
//			}			
			if(rs != null){rs.close();}
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/salesmanager/areasale/baseSet/base_set_edit.jsp");
	}
}
