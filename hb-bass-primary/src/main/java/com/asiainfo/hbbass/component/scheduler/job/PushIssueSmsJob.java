package com.asiainfo.hbbass.component.scheduler.job;

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
 * @author zhangwei
 *
 */
@SuppressWarnings("unused")
public class PushIssueSmsJob implements Job{
	private static Logger LOG = Logger.getLogger(PushIssueSmsJob.class);
	/**
	 * @param args
	 */
	public static void main(String[] args) {

	}

	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		System.out.println("检测任务开始******");
		ConnectionManage connManage = ConnectionManage.getInstance();
		Connection connweb = connManage.getWEBConnection();
		PreparedStatement pstmt = null;
		ResultSet rst = null ;
		
		try {
			String sql = "select id,\n" +
						"       pid,\n" + 
						"       user_id,\n" + 
						"       user_name,\n" + 
						"       username,\n" + 
						"       mobilephone,\n" + 
						"       create_dt,\n" + 
						"       content,\n" + 
						"       value(responsible, '') responsible\n" + 
						"  from FPF_IRS_TWITTER a\n" + 
						"  left join FPF_IRS_TWITTER_EXT on id = tid\n" + 
						"                           and code = '申告类型'\n" + 
						"  left join (select distinct pid p_id, '已回复' reply_type\n" + 
						"               from FPF_IRS_TWITTER\n" + 
						"              where state = '申告'\n" + 
						"                and pid is not null) b on ID = p_id\n" + 
						" inner join FPF_USER_USER on responsible = username\n" + 
						" where state = '申告'\n" + 
						"   and pid is null\n" + 
						"   and reply_type is null\n" + 
						"   and substr(char(date(create_dt)), 1, 7) <=\n" + 
						"       substr(char(current_date - 3 days), 1, 7)";
			pstmt = connweb.prepareStatement(sql);
			rst = pstmt.executeQuery();
		//	List<Object> list = new ArrayList<Object>(); 
			while(rst.next()){
				String message = "截止到目前，您有申告《";
				String content = rst.getString("content");
				if(content.indexOf("#")>-1){
					String[] s = content.split("#");
					message = message + s[1]+"》未回复，请尽快回复。";
				}
				String mobilephone = rst.getString("mobilephone");
				SendSMSWrapper.send(mobilephone, message);
			}
			pstmt.executeBatch();
			connManage.releaseConnection(connweb);
		} catch (Exception e) {
			
			e.printStackTrace();
		}finally{
			try {
				if (rst != null) rst.close();
				if (pstmt != null) pstmt.close();
				if (connweb != null) connweb.close();
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}
		
		
		System.out.println("检测任务结束******");
	}

}

