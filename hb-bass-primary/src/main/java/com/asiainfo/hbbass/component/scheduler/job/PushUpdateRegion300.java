package com.asiainfo.hbbass.component.scheduler.job;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

/**
 * 更新热线接口表region字段全省值的调度
 * 
 * @author LiZhijian
 * 
 */
@SuppressWarnings("unused")
public class PushUpdateRegion300 implements Job {
	private static Logger LOG = Logger.getLogger(PushUpdateRegion300.class);

	public void execute(JobExecutionContext context) throws JobExecutionException {
		LOG.info("更新热线接口表region字段全省值的调度开始******");
		ConnectionManage connManage = ConnectionManage.getInstance();
		Connection connDW = connManage.getDWConnection();
		PreparedStatement pstmt = null;
		String sql = "";
		try {
			sql = "update db2mpm.cs_rec_advice_active set region=999 where region=300 ";
			pstmt = connDW.prepareStatement(sql);
			pstmt.executeUpdate();
			connDW.commit();
			connManage.releaseConnection(connDW);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.info("更新热线接口表region字段全省值的调度出错了：" + e.getMessage());
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (connDW != null)
					connDW.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		LOG.info("更新热线接口表region字段全省值的调度结束******");
	}
}
