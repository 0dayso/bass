/*package com.asiainfo.quartz;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.sql.DataSource;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hb.bass.data.model.Kpi;
import com.asiainfo.hb.bass.data.service.KpiService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.JedisClusterUtil;
import com.asiainfo.hb.core.util.LogUtil;

import redis.clients.jedis.JedisCluster;

*//**
 * 刷新KPI数据到缓存的调度
 * 
 * @author 李志坚
 *
 *//*
@SuppressWarnings("unused")
@Component
public class KpiCalculateJob {

	private JdbcTemplate jdbcTemplate;

	private static Logger logger = Logger.getLogger(KpiCalculateJob.class);

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	@Autowired
	private KpiService kpiService;

	*//**
	 * 刷新KPI数据到缓存中，每天8:10,12:10各运行一次。
	 * 
	 *//*
	@Scheduled(cron = "0 10 8,12 * * ?")
	public void refreshYesterdayKpi() {
		logger.info("--------------------开始KPI指标数据调度任务--------------------");
		// 查询所有kpi指标对应的id
		String sql = "select id from boc_indicator_menu";
		List<Map<String, Object>> menuIdsList = jdbcTemplate.queryForList(sql);
		// 获取所需时间参数--昨天
		final SimpleDateFormat day = new SimpleDateFormat("yyyyMMdd");
		Calendar CalendarYesterday = Calendar.getInstance();
		CalendarYesterday.add(Calendar.DATE, -1);
		String yesterday = day.format(CalendarYesterday.getTime());

		try {
			// 先刷新ID拼接的
			String idsSQL = "SELECT PID||','||MENUID as IDS FROM (SELECT PID,LISTAGG(ID,',') WITHIN GROUP(ORDER BY ID) MENUID from BOC_INDICATOR_MENU menu group by PID)";
			List<Map<String, Object>> idsList = jdbcTemplate.queryForList(idsSQL);

			// 所有要刷新的KEY
			List<String> idList = new ArrayList<String>();

			for (Map<String, Object> map : idsList) {
				if (map.get("IDS") != null) {
					idList.add(map.get("IDS").toString());
				}
			}
			// logger.debug("有" + idList.size() + "个多指标查询结果需要刷新到缓存中");
			for (Map<String, Object> map : menuIdsList) {
				if (map.get("ID") != null) {
					// 暂时不刷新单指标到缓存
					// idList.add(map.get("ID").toString());
				}
			}
			logger.debug("总共有" + idList.size() + "个查询结果需要刷新到缓存中");
			
			for (String id : idList) {
				List<Kpi> kpiList = new ArrayList<Kpi>();
				// logger.debug("开始刷新KPI数据到redis:" + id);
				String[] indicatorMenuIds = id.split(",");
				// 并发查询，按每一个指标开一个线程来查询
				ExecutorService executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
				for (String menuId : indicatorMenuIds) {
					executorService.execute(new KpiRunnable(menuId, yesterday, "PROV_ID", "HB", kpiService, kpiList));
				}
				// 等待线程池中的线程全部执行完毕后再执行后面的程序
				executorService.shutdown();
				while (true) {
					if (executorService.isTerminated()) {
						break;
					}
				}
				if (kpiList == null) {
					kpiList = new ArrayList<Kpi>();
				}
				String key = id + "~" + yesterday + "~" + "PROV_ID" + "~" + "HB";
				JedisCluster jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();
				if (jedisCluster != null) {
					jedisCluster.set(key, JsonHelper.getInstance().write(kpiList));
					//FileUtils.writeStringToFile(new File("/Users/lzj/Downloads/kpilog2.txt"), key + "\r\n", "UTF-8", true);
				} else {
					logger.error("未获取到jedis连接");
				}
			}
			logger.info("--------------------结束KPI指标数据调度任务--------------------");
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
	}

	private class KpiRunnable implements Runnable {
		private String menuId;
		private String date;
		private String dimCode;
		private String dimVal;
		private KpiService kpiService;
		private List<Kpi> kpiList;

		@Override
		public void run() {
			try {
				List<Kpi> list = kpiService.getKpiByIndicatorMenuId(menuId, date, dimCode, dimVal);
				if (list != null && list.size() > 0) {
					kpiList.addAll(list);
				}
				if (list == null) {
					list = new ArrayList<Kpi>();
				}
				String key = menuId + "~" + date + "~" + dimCode + "~" + dimVal;
				JedisCluster jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();
				if (jedisCluster != null) {
					jedisCluster.set(key, JsonHelper.getInstance().write(list));
					//FileUtils.writeStringToFile(new File("/Users/lzj/Downloads/kpilog1.txt"), key + "\r\n", "UTF-8", true);
				} else {
					logger.error("未获取到jedis连接");
				}
			} catch (Exception e) {
				logger.error(LogUtil.getExceptionMessage(e));
			}
		}

		public KpiRunnable(String menuId, String date, String dimCode, String dimVal, KpiService kpiService, List<Kpi> kpiList) {
			this.menuId = menuId;
			this.date = date;
			this.dimCode = dimCode;
			this.dimVal = dimVal;
			this.kpiService = kpiService;
			this.kpiList = kpiList;
		}
	}

	*//**
	 * 城市列表
	 * 
	 * @return
	 *//*
	public static Map<String, List<String>> getCityMap() {
		Map<String, List<String>> city = new HashMap<String, List<String>>();
		List<String> list = new ArrayList<String>();
		list.add("HB.JZ");
		list.add("HB.JH");
		list.add("HB.JM");
		list.add("HB.XN");
		list.add("HB.SY");
		list.add("HB.XF");
		list.add("HB.HS");
		list.add("HB.HG");
		list.add("HB.TM");
		list.add("HB.XG");
		list.add("HB.QJ");
		list.add("HB.WH");
		list.add("HB.EZ");
		list.add("HB.ES");
		list.add("HB.SZ");
		list.add("HB.YC");
		city.put("CITY_ID", list);
		return city;
	}

	public static void main(String[] args) {

		ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
		int num = 10;
		final CountDownLatch latch = new CountDownLatch(num);
		for (int i = 0; i < num; i++) {
			scheduledThreadPool.schedule(new Runnable() {
				public void run() {
					latch.countDown();
				}
			}, 1, TimeUnit.SECONDS);
		}
		try {
			// latch.await();
			scheduledThreadPool.shutdown();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
*/