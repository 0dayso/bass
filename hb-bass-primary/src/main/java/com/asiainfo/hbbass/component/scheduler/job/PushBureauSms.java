/**
 * 
 */
package com.asiainfo.hbbass.component.scheduler.job;

import java.lang.reflect.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;

/**
 * @author zhangds
 *
 */
@SuppressWarnings("unused")
public class PushBureauSms implements Job{
	private static Logger LOG = Logger.getLogger(PushBureauSms.class);
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
//		PushBureauSms sms = new PushBureauSms();
//		try {
//			sms.execute(null);
//		} catch (JobExecutionException e) {
//			
//			e.printStackTrace();
//		}
	}

	@SuppressWarnings("resource")
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		System.out.println("检测任务开始******");
		ConnectionManage connManage = ConnectionManage.getInstance();
		Connection conn = connManage.getDWConnection();
		Connection connweb = connManage.getWEBConnection();
		PreparedStatement pstmt = null;
		PreparedStatement _pstmt = null;
		ResultSet rst = null ;
		ResultSet _rst = null ;
		
		try {
			String sql = "select A.CITYNAME,A.OPERATOR,B.AREA_CODE,c.username,c.mobilephone from FPF_AUDIT_FLOW A,mk.bt_area B,fpf_user_user c WHERE A.CITYNAME=B.AREA_NAME and A.OPERATOR=c.userid";
			pstmt = connweb.prepareStatement(sql);
			rst = pstmt.executeQuery();
			List<String[]> list = new ArrayList<String[]>(); 
			while(rst.next()){
				String[] string = new String[3];
				string[0] = rst.getString("AREA_CODE");
				string[1] = rst.getString("username");
				string[2] = rst.getString("mobilephone");
				list.add(string);
			}
		/*	if (list == null){
				return ;
			}*/
				
			sql = "select AREA_CODE,SMS_CONTENT,NEW_CNT,DEL_CNT,ETL_CYCLE_ID,CHANGE_CNT,REMARK from BUREAU_SMS_MESSAGE where REMARK IS NULL or REMARK='' ORDER BY AREA_CODE DESC";
			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();
			//SendSMSWrapper sms = new SendSMSWrapper();
			sql ="update BUREAU_SMS_MESSAGE set remark=? where AREA_CODE=? and SMS_CONTENT=? and NEW_CNT=? and DEL_CNT=? and CHANGE_CNT = ? and ETL_CYCLE_ID= ?" ;
			pstmt = conn.prepareStatement(sql);
			while (rst.next()){
				for (int i= 0 ;i<list.size();i++){
					String[] str = (String[])list.get(i);
					if (rst.getString("AREA_CODE").equalsIgnoreCase(str[0])){
						//发送短信
						if (str[2] != null && !str[2].trim().equalsIgnoreCase("")){
							String message = str[1]+":您有如下基站参数审核内容!"+rst.getString("SMS_CONTENT")
							        +":新增("+rst.getInt("NEW_CNT")+");删除("+rst.getInt("DEL_CNT")+");变化:("+
							        rst.getInt("CHANGE_CNT")+")";
							//SendSMSWrapper.oriSend(str[2], message);
							SendSMSWrapper.send(str[2], message);
							pstmt.setString(1, "已发送!");
							pstmt.setString(2, rst.getString("AREA_CODE"));
							pstmt.setString(3, rst.getString("SMS_CONTENT"));
							pstmt.setInt(4, rst.getInt("NEW_CNT"));
							pstmt.setInt(5, rst.getInt("DEL_CNT"));
							pstmt.setInt(6, rst.getInt("CHANGE_CNT"));
							pstmt.setInt(7, rst.getInt("ETL_CYCLE_ID"));
							pstmt.addBatch();
						}
						break ;
					}
				}
			}
			pstmt.executeBatch();
			connManage.releaseConnection(conn);
			connManage.releaseConnection(connweb);
		} catch (Exception e) {
			
			e.printStackTrace();
		}finally{
			try {
				if (rst != null) rst.close();
				if (_rst != null) _rst.close();
				if (pstmt != null) pstmt.close();
				if (_pstmt != null) _pstmt.close();
				if (conn != null) conn.close();
				if (connweb != null) connweb.close();
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}
		
		
		System.out.println("检测任务结束******");
	}

}
