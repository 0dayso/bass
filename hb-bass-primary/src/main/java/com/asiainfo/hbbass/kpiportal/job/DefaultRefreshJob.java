package com.asiainfo.hbbass.kpiportal.job;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.dimension.BassDimCache;
import com.asiainfo.hbbass.kpiportal.core.KPIAppData;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.customize.KPIAuditJob;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * KPI的调度工作类,
 * 
 * 定时刷新缓存数据,从DefaultJob中独立出来的
 * 
 * @author Mei Kefu
 * @date 2010-5-31
 */
@SuppressWarnings({"rawtypes" })
public class DefaultRefreshJob implements Job {

	private static Logger LOG = Logger.getLogger(DefaultRefreshJob.class);

	public void execute(JobExecutionContext context) throws JobExecutionException {

		/**************************** 1.稽核规则告警 ******************************/
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);
		List list = (List) sqlQuery.query("select id from kpi_audit_job where fire_date=current_date and status!='成功' with ur");
		LOG.info("开始执行告警，length：" + list.size());
		for (int i = 0; i < list.size(); i++) {
			int nId = (Integer) ((Map) list.get(i)).get("id");
			LOG.info("稽核告警 id:" + nId);
			try {
				KPIAuditJob push = new KPIAuditJob(nId);
				push.push();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/**************************** 2.定时刷新缓存数据,只定时刷新日数据 ******************************/
		LOG.info("定时刷新BassDimCache缓存");
		BassDimCache.getInstance().initialize();

		Map map = KPIPortalContext.getKpiApp();
		Calendar c = GregorianCalendar.getInstance();
		Calendar d = GregorianCalendar.getInstance();
		c.add(Calendar.DATE, -1);
		d.add(Calendar.DATE, -2);
		String date = KPIPortalContext.DAILY_FORMAT.format(c.getTime());
		String preDate = KPIPortalContext.DAILY_FORMAT.format(c.getTime());
		/*
		 * 加入前一天的值  by zhangds
		*/
		String pdate = KPIPortalContext.DAILY_FORMAT.format(d.getTime());
		/*
		 * end
		 */
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();

			KPIAppData kpiAppDate = (KPIAppData) entry.getValue();
			if (date.equalsIgnoreCase(kpiAppDate.getCurrent())||pdate.equalsIgnoreCase(kpiAppDate.getCurrent())) {
				LOG.info("定时刷新缓存:" + kpiAppDate.getName());
				KPIPortalService.refreshKPIEntities(kpiAppDate.getName(), date);
			}
			LOG.info("KPI名字==============="+kpiAppDate.getName());
			if(kpiAppDate.getName().equals("CollegeD")){
				LOG.info("KPI时间==============="+kpiAppDate.getCurrent());
				if (preDate.equalsIgnoreCase(kpiAppDate.getCurrent())||pdate.equalsIgnoreCase(kpiAppDate.getCurrent())) {
					LOG.info("定时刷新缓存:" + kpiAppDate.getName());
					KPIPortalService.refreshKPIEntities(kpiAppDate.getName(), preDate);
				}
			}
		}
	}

	public static void main(String[] args) {
	}
}
