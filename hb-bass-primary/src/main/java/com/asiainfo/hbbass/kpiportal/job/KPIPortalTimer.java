package com.asiainfo.hbbass.kpiportal.job;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;

public class KPIPortalTimer {
	public void start(SchedulerFactory schedFact) {
		try {
			/*
			 * JobDetail job = new JobDetail("job1", "group1",
			 * DefaultJob.class); //job.setRequestsRecovery(true); CronTrigger
			 * trigger = new CronTrigger("trigger1", "group1", "job1",
			 * "group1","0 0 8 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 * 
			 * job = new JobDetail("job2", "group1", ChargeRefreshJob.class);
			 * //job.setRequestsRecovery(true); trigger = new
			 * CronTrigger("trigger2", "group1", "job2",
			 * "group1","0 30 9 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 * 
			 * job = new JobDetail("job3", "group1", GCDefaultJob.class);
			 * //job.setRequestsRecovery(true); trigger = new
			 * CronTrigger("trigger3", "group1", "job3",
			 * "group1","0 30 8 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 * 
			 * job = new JobDetail("job4", "group1", BureauDefaultJob.class);
			 * //job.setRequestsRecovery(true); trigger = new
			 * CronTrigger("trigger4", "group1", "job4",
			 * "group1","0 0 9 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 * 
			 * job = new JobDetail("job5", "group1", KpiSmsPushJob.class);
			 * //job.setRequestsRecovery(true); trigger = new
			 * CronTrigger("trigger5", "group1", "job5",
			 * "group1","0 20 8 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 * 
			 * job = new JobDetail("job6", "group1", CollegeDefaultJob.class);
			 * //job.setRequestsRecovery(true); trigger = new
			 * CronTrigger("trigger6", "group1", "job6",
			 * "group1","0 30 8 * * ?"); sched.addJob(job, true);
			 * sched.scheduleJob(trigger);
			 */

			Scheduler sched = schedFact.getScheduler();

			JobDetail job = null;
			CronTrigger trigger = null;

			try {
				job = new JobDetail("ChannelD", "KPI", DefaultJob.class);
				// job.setRequestsRecovery(true);
				//job.getJobDataMap().put("prognames", "'KPI_NEW_D'");
				job.getJobDataMap().put("prognames", "'A00009','A00017'");
				job.getJobDataMap().put("sleepTime", "5");
				// 每天8点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 8 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("ChannelM", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_NEW_2M','KPI_NEW_M'");
				job.getJobDataMap().put("prognames", "'M00003','M00004'");
				// 每月4-5号7点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 7 4-10 * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("BureauD", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_BureauCg_Day'");
				job.getJobDataMap().put("prognames", "'A00014'");
				job.getJobDataMap().put("sleepTime", "15");
				// 每天9点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 11 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("BureauM", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_Bureau_Month'");
				job.getJobDataMap().put("prognames", "'M00009','M00010'");
				// 每月4-5号10点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 10 4-10 * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("GroupcustD", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_NEW_JT'");
				job.getJobDataMap().put("prognames", "'A00007'");
				job.getJobDataMap().put("sleepTime", "15");
				// 每天10点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 10 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("GroupcustM", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI-NEW-ENT'");
				job.getJobDataMap().put("prognames", "'M00001'");
				// 每月4-5号10点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 10 4-10 * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("CollegeD", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_College_Day'");
				job.getJobDataMap().put("prognames", "'A00011'");
				job.getJobDataMap().put("sleepTime", "20");
				// 每天12点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 12 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("CollegeM", "KPI", DefaultJob.class);
				//job.getJobDataMap().put("prognames", "'KPI_College_Month'");
				job.getJobDataMap().put("prognames", "'M00005'");
				// 每月4-5号12点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 12 4-10 * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			/*
			try {
				job = new JobDetail("EntGridD", "KPI", DefaultJob.class);
				job.getJobDataMap().put("prognames", "'GridKpiDay'");
				job.getJobDataMap().put("sleepTime", "15");
				// 每天12点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 13 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}
			*/
			// 2011-12-05 helei 增加客服kpi 程序名称要根据实际的作修改，刷新时间也要修改
			try {
				job = new JobDetail("CsD", "KPI", DefaultJob.class);
				job.getJobDataMap().put("prognames", "'KPI_CS_DAY'");
				job.getJobDataMap().put("sleepTime", "15");
				// 每天16:30点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 30 16 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				job = new JobDetail("CsM", "KPI", DefaultJob.class);
				job.getJobDataMap().put("prognames", "'KPI_CS_Month'");
				// 每月6号14点开始
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 0 14 6-10 * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				// 定时刷新
				job = new JobDetail("Refresh", "KPI", DefaultRefreshJob.class);
				// 每日10-20点 2个小时一次
				trigger = new CronTrigger("Tri" + job.getName(), "TriG" + job.getGroup(), job.getName(), job.getGroup(), "0 30 9,10,11,13,15,17,19,21,23 * * ?");
				sched.addJob(job, true);
				sched.scheduleJob(trigger);
			} catch (Exception e) {
				e.printStackTrace();
			}

			sched.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void terminate() {

	}

	public static void main(String[] args) {

	}

}
