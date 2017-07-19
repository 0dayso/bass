package com.asiainfo.hbbass.component.scheduler;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;

import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 
 * 
 * @author Mei Kefu
 * @date 2009-11-26
 */
public class SchedulerService {

	private Scheduler scheduler = null;

	private static Logger LOG = Logger.getLogger(SchedulerService.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();

	@SuppressWarnings("rawtypes")
	public void add(Class cls, String jobName, String jobGroup, String triName, String triGroup, String cronExpress, String jsonStr) throws ParseException, SchedulerException {

		JobDetail job = new JobDetail(jobName, jobGroup, cls);
		if (jsonStr != null && jsonStr.length() > 0) {

			LOG.debug("json" + jsonStr);
			Object jsonObject = jsonHelper.read(jsonStr);
			LOG.debug("json:" + jsonStr + " " + jsonObject.getClass());
			job.getJobDataMap().put("jsonObject", jsonObject);
		}
		if (triGroup == null || triGroup.length() == 0) {
			triGroup = Scheduler.DEFAULT_GROUP;
		}

		if (jobGroup == null || jobGroup.length() == 0) {
			jobGroup = Scheduler.DEFAULT_GROUP;
		}

		// job.setRequestsRecovery(true);//集群中恢复

		CronTrigger trigger = new CronTrigger(triName, triGroup, jobName, jobGroup, cronExpress);

		scheduler.addJob(job, true);
		scheduler.scheduleJob(trigger);
	}

	public boolean isExist(String triName, String triGroup) throws SchedulerException {
		Trigger tri = scheduler.getTrigger(triName, triGroup);
		if (tri == null)
			throw new SchedulerException("Trigger name :" + triName + " and trigger group:" + triGroup + " is not exist");
		return true;
	}

	public void remove(String triName, String triGroup) throws SchedulerException {
		if (isExist(triName, triGroup))
			scheduler.unscheduleJob(triName, triGroup);
	}

	public void pause(String triName, String triGroup) throws SchedulerException {
		if (isExist(triName, triGroup))
			scheduler.pauseTrigger(triName, triGroup);
	}

	public void resume(String triName, String triGroup) throws SchedulerException {
		if (isExist(triName, triGroup))
			scheduler.resumeTrigger(triName, triGroup);
	}

	public void start() throws SchedulerException {
		scheduler.start();
	}

	public void shutdown() throws SchedulerException {
		scheduler.shutdown(true);
	}

	public Scheduler getscheduler() {
		return scheduler;
	}

	public void setscheduler(Scheduler scheduler) {
		this.scheduler = scheduler;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String show() throws SchedulerException {

		List list = new ArrayList();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			String[] triGroupNames = scheduler.getTriggerGroupNames();

			for (int i = 0; i < triGroupNames.length; i++) {

				// List group = new ArrayList();

				String[] TriNames = scheduler.getTriggerNames(triGroupNames[i]);

				for (int k = 0; k < TriNames.length; k++) {

					Map map = new HashMap();

					Trigger tri = scheduler.getTrigger(TriNames[k], triGroupNames[i]);

					JobDetail job = scheduler.getJobDetail(tri.getJobName(), tri.getJobGroup());
					map.put("triGroup", triGroupNames[i]);
					map.put("triName", tri.getName());
					map.put("jobName", tri.getJobName());
					map.put("jobClass", job.getJobClass().getName());

					if (tri instanceof CronTrigger) {
						map.put("cronExpress", ((CronTrigger) tri).getCronExpression());
					}
					map.put("StartTime", sdf.format(tri.getStartTime()));
					map.put("PreviousFireTime", tri.getPreviousFireTime() == null ? "" : sdf.format(tri.getPreviousFireTime()));
					map.put("NextFireTime", tri.getNextFireTime() == null ? "" : sdf.format(tri.getNextFireTime()));

					map.put("triState", scheduler.getTriggerState(tri.getName(), triGroupNames[i]));

					Object object = job.getJobDataMap().get("jsonObject");
					map.put("jsonObject", jsonHelper.write(object));

					list.add(map);
				}

			}
		} catch (SchedulerException e) {
			e.printStackTrace();
			throw e;
		}
		String result = jsonHelper.write(list);
		LOG.debug(result);
		return result;
	}

}
