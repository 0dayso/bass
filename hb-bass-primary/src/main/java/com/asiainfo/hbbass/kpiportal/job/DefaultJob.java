package com.asiainfo.hbbass.kpiportal.job;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;
import com.asiainfo.hbbass.kpiportal.core.KPIAppData;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.customize.KPIAuditJob;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * KPI的调度工作类 1.KPI的默认日期刷新 2.修改稽核规则的唤起时间
 * 
 * @author Mei Kefu
 * @date 2009-1-30
 * @date 2010-5-28 重构该类，整合所有的调度程序
 * @date 2010-5-31 重构，独立稽核告警与定时刷新，因为定时刷新会造成该线程一直在活动，中途重启就不会定时刷新了
 */
public class DefaultJob implements Job {

	private static Logger LOG = Logger.getLogger(DefaultJob.class);

	public void execute(JobExecutionContext context) throws JobExecutionException {

		/**************************** 1.KPI的默认日期刷新 ******************************/
		String appName = context.getJobDetail().getName();// 应用的名称
		String prognames = (String) context.getJobDetail().getJobDataMap().get("prognames");// 后台对应的程序
		String sleepTime = (String) context.getJobDetail().getJobDataMap().get("sleepTime");// 分钟单位
		LOG.info("开始加载:" + prognames);
		if (sleepTime == null || sleepTime.length() == 0)
			sleepTime = "15";
		int nSleep = Integer.parseInt(sleepTime);
		boolean succ = false;
		int hour = 10;
		while (!succ && (hour>4 && hour < 23)) {
			hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);// 23点以后就不更新了
			if (isDoneNew(appName, prognames)) {
				succ = true;
				LOG.info(prognames + "后台数据已经完成");
			} else {
				LOG.info(prognames + "后台没有完成,休眠" + nSleep + "分钟");
				try {
					Thread.sleep(nSleep * 60000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
		KPIPortalContext.updateDate(appName);// 更新日期

		String date = ((KPIAppData) KPIPortalContext.getKpiApp().get(appName)).getCurrent();

		// KPIEntityInitialize.updateIndex(appName);// 删除过期缓存
		// KPIEntityInitialize.initialize(appName);//初始化缓存 不能使用这个方法，有可能刷新不成功
		KPIPortalService.refreshKPIEntities(appName, date);

		/*
		 * String appName2 = "ChannelM";
		 * KPIPortalContext.updateDate(appName2);// 更新日期
		 * KPIEntityInitialize.updateIndex(appName2);
		 * 
		 * KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(
		 * appName2); Map map = KPIPortalService.getKPIMap(appName2,
		 * appData.getCurrent());
		 * 
		 * // 判断是否存在月的数据 if (map == null || map.size() > 0) {
		 * KPIEntityInitialize.initialize(appName2); }
		 */

		@SuppressWarnings("rawtypes")
		Map map = KPIPortalService.getKPIMap(appName, date);
		String msg = appName + "更新 " + date;
		if (map != null && map.size() > 0) {
			msg += " KPI成功,size为:" + map.size() + " ";
			// KPIEntity kpiEntry = (KPIEntity) map.get("K10001");
			// msg += kpiEntry.getName() + "的,size:" +
			// kpiEntry.getIndex().size();
		} else
			msg += "失败";

		LOG.debug(date + " " + msg);
		SendSMSWrapper.send("18207144852;13986101110", msg);

		/**************************** 2-1.变更稽核的状态 ******************************/
		Connection conn = null;
		List<Integer> ids = new ArrayList<Integer>();
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			String sql = "update kpi_audit_job set fire_date=current_date,status=? where app_name=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "待执行");
			ps.setString(2, appName);
			ps.execute();
			ps.close();
			conn.commit();

			/**************************** 2-2.稽核规则告警 ******************************/
			PreparedStatement ps1 = conn.prepareStatement("select id from kpi_audit_job where app_name=? and fire_date=current_date and status!='成功' with ur");
			ps1.setString(1, appName);
			ResultSet rs = ps1.executeQuery();

			while (rs.next()) {
				ids.add(rs.getInt(1));
			}
			rs.close();
			ps1.close();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		for (int i = 0; i < ids.size(); i++) {
			int nId = (Integer) ids.get(i);
			LOG.info("开始执行稽核告警 id:" + nId);
			KPIAuditJob push = new KPIAuditJob(nId);
			push.push();
		}
		/**************************** 3.定时刷新缓存数据 ******************************/
		// 定时一个小时刷新一次缓存
		/*
		 * int hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
		 * while (hour <= 21) { try { LOG.info("定时休眠1个小时,hour:" + hour);
		 * Thread.sleep(3600000); } catch (InterruptedException e) {
		 * e.printStackTrace(); } hour =
		 * GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
		 * 
		 * LOG.info("定时刷新BassDimCache缓存");
		 * BassDimCache.getInstance().initialize();
		 * 
		 * LOG.info("定时刷新缓存"); KPIEntityInitialize.initialize(appName); //
		 * KPIEntityInitialize.initialize("ChannelM"); }
		 */
	}

	
	protected boolean isDone(String appName, String progname) {
		String date = "";
		String today = (appName.endsWith("M") ? KPIPortalContext.MONTHLY_FORMAT : KPIPortalContext.DAILY_FORMAT).format(GregorianCalendar.getInstance().getTime());
		Connection conn = null;
		try {
			// String sql =
			// "select etl_cycle_id from nwh.dp_etl_com where etl_progname in ('KPI_NEW_D') group by etl_cycle_id order by etl_cycle_id with ur";
			String sql = "select etl_cycle_id from nwh.dp_etl_com where etl_progname in (" + progname + ") group by etl_cycle_id order by etl_cycle_id with ur";
			conn = ConnectionManage.getInstance().getDWConnection();
			ResultSet rs = conn.createStatement().executeQuery(sql);
			if (rs.next()) {
				date = rs.getString(1);
			}
			rs.close();
			LOG.info("程序：" + progname + "数据库完成的批次号为:" + date + " 当前日期为:" + today);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		return today.equalsIgnoreCase(date);
	}
	
	protected boolean isDoneNew(String groupName, String progname) {
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.add(Calendar.HOUR, -5);
		String currentTaskId="";
		if(groupName.endsWith("M")){
			calendar.add(Calendar.MONTH, -1);
			currentTaskId = KPIPortalContext.MONTHLY_FORMAT.format(calendar.getTime());
		}else{
			calendar.add(Calendar.DATE, -1);
			currentTaskId = KPIPortalContext.DAILY_FORMAT.format(calendar.getTime());
		}
		Connection conn = null;
		int totCnt = 0;
		int curCnt = 0;
		try {
			String sql = "select count(*) tot_cnt,count(case when webstate='加载成功' then 1 else 0 end) cur_cnt from DM.DATA_TRANS_LOG where INTERCODE IN ("+progname+") and datecycle = '"+currentTaskId+"' with ur";
			conn = ConnectionManage.getInstance().getDWConnection();
			ResultSet rs = conn.createStatement().executeQuery(sql);
			if (rs.next()) {
				totCnt = rs.getInt(1);
				curCnt = rs.getInt(2);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		LOG.info("程序："+progname+" totCnt:" + totCnt+" curCnt:"+curCnt + " 当前批次为:" + currentTaskId);
		return (totCnt>0 && totCnt==curCnt);
	}

	public static void main(String[] args) {
		/*
		 * int hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
		 * 
		 * System.out.println(hour);
		 * 
		 * try { SendSMSWrapper.oriSend("13697339119","aaa"); } catch (Exception
		 * e) { e.printStackTrace(); }
		 */

		List<Integer> list = new ArrayList<Integer>();

		list.add(1);

		System.out.println(((Integer) list.get(0)) == 1);
	}
}
