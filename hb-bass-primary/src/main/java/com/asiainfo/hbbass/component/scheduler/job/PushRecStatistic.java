package com.asiainfo.hbbass.component.scheduler.job;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

/**
 * 热线营销统计调度
 * 
 * @author LiZhijian
 * 
 */
public class PushRecStatistic implements Job {
	private static Logger LOG = Logger.getLogger(PushRecStatistic.class);

	public void execute(JobExecutionContext context) throws JobExecutionException {
		LOG.info("热线营销统计调度开始******");
		ConnectionManage connManage = ConnectionManage.getInstance();
		Connection connDW = connManage.getDWConnection();
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		String sql = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String currDate = sdf.format(new java.util.Date());
		String year = currDate.substring(0, 4);
		String month = currDate.substring(4, 6);
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		//本月最后一天
		String lastDay = new SimpleDateFormat("dd").format(calendar.getTime());
		
		try {
			sql = "select tt1.area_name c1,char(tt1.actid) c2,tt1.actname c3,char(tt1.begindate) c4," + " char(tt1.targer_user_nums) c5,char(tt2.channleid) c6,char(tt2.tuijian) c7,char(tt3.banli) c8 ,char(current date) " + " from ( " + " select ( " + " select area_name " + " from mk.bt_area "
					+ " where new_code = a.region),a.actid,a.actname,a.begindate," + " b.targer_user_nums " + " from DB2MPM.cs_rec_advice_active a,db2mpm.Mtl_Camp_Seginfo b " + " where a.begindate >= '"
					+ year
					+ "-"
					+ month
					+ "-01' "
					+ " and a.begindate <='"
					+ year
					+ "-"
					+ month
					+ "-"+lastDay+"' "
					+ " and a.actid = b.campseg_id) tt1, ( "
					+ " select a1.actid,a1.channleid,count(distinct servnumber) as tuijian "
					+ " from ( "
					+ " select actid,channleid "
					+ " from ( "
					+ " select distinct actid "
					+ " from NWH.CS_REC_ADVICE_LOG_"
					+ year
					+ ""
					+ month
					+ " ) t1,( "
					+ " select * "
					+ " from ( "
					+ " values '10086' ,'12580' ,'KZYYT' ,'web') as t(channleid)) t2 ) "
					+ " a1 "
					+ " left join NWH.CS_REC_ADVICE_LOG_"
					+ year
					+ ""
					+ month
					+ " a2 "
					+ " on a1.actid=a2.actid "
					+ " and a1.channleid=a2.channleid "
					+ " group by a1.actid,a1.channleid) tt2, ( "
					+ " select a1.actid,a1.channleid,count(distinct servnumber) as banli "
					+ " from ( "
					+ " select actid,channleid "
					+ " from ( "
					+ " select distinct actid "
					+ " from NWH.CS_REC_ADVICE_LOG_"
					+ year
					+ ""
					+ month
					+ " ) t1,( "
					+ " select * "
					+ " from ( "
					+ " values '10086' ,'12580' ,'KZYYT' ,'web') as t(channleid)) t2 ) "
					+ " a1 "
					+ " left join ( "
					+ " select * "
					+ " from NWH.CS_REC_ADVICE_LOG_"
					+ year
					+ ""
					+ month
					+ " "
					+ " where servnumber in ( "
					+ " select distinct a.acc_nbr "
					+ " from nwh.mbuser a,nwh.serv_funcs b "
					+ " where a.mbuser_id = b.serv_id "
					+ " and date(b.eff_date) > '"
					+ year
					+ "-"
					+ month
					+ "-01')) a2 "
					+ " on a1.actid=a2.actid "
					+ " and a1.channleid=a2.channleid "
					+ " group by a1.actid,a1.channleid "
					+ " ) tt3 "
					+ " where tt1.actid = tt2.actid "
					+ " and tt2.actid = tt3.actid " + " and tt2.channleid = tt3.channleid " + " order by tt2.actid,tt2.channleid ";
			sql = "insert into DB2MPM.REC_STATISTIC_SCHEDULE (" + sql + ")";
			LOG.info("热线营销统计调度的sql是：" + sql);
			pstmt = connDW.prepareStatement(sql);
			pstmt.execute();
			connDW.commit();
			connManage.releaseConnection(connDW);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.info("热线营销统计调度出错了：" + e.getMessage());
		} finally {
			try {
				if (rst != null)
					rst.close();
				if (pstmt != null)
					pstmt.close();
				if (connDW != null)
					connDW.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		LOG.info("热线营销统计调度结束******");
	}
}
