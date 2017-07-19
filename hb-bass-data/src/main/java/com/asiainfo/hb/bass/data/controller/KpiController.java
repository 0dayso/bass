package com.asiainfo.hb.bass.data.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.bass.data.model.Kpi;
import com.asiainfo.hb.bass.data.model.KpiDef;
import com.asiainfo.hb.bass.data.service.KpiService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.DateUtil;
import com.asiainfo.hb.core.util.JedisClusterUtil;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

import redis.clients.jedis.JedisCluster;

/**
 * KPI操作控制类
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping(value = "/kpi")
@SessionAttributes({ SessionKeyConstants.USER })
public class KpiController {

	public Logger logger = LoggerFactory.getLogger(KpiController.class);

	@Autowired
	KpiService kpiService;

	/**
	 * 查询KPI数据
	 * 
	 * @param id
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "{indicatorMenuId}")
	public @ResponseBody Object kpi(@PathVariable String indicatorMenuId, WebRequest request, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("queryDB", request.getParameter("queryDB"));
		map.put("date", request.getParameter("date"));
		map.put("dimCode", request.getParameter("dimCode"));
		map.put("dimVal", request.getParameter("dimVal"));
		// 去掉最后一个多余的逗号
		char lastStr = indicatorMenuId.charAt(indicatorMenuId.length() - 1);
		if (indicatorMenuId != null && ',' == lastStr) {
			indicatorMenuId = indicatorMenuId.substring(0, indicatorMenuId.length() - 1);
		}
		map.put("indicatorMenuId", indicatorMenuId);
		map.put("userName", user.getName());
		return kpiQuery(map);
	}


	public Object kpiQuery(Map<String, Object> map) {
		try {
			String date = map.get("date").toString();
			String dimCode = map.get("dimCode").toString();
			String dimVal = map.get("dimVal").toString();
			String queryDB = map.get("queryDB").toString();
			String indicatorMenuId = map.get("indicatorMenuId").toString();
			String userName = map.get("userName") != null ? map.get("userName").toString() : null;
			if (!StringUtils.isEmpty(date)) {
				date = date.replaceAll("-", "");
				date = date.replaceAll("_", "");
				date = date.replaceAll("/", "");
			}
			logger.debug("进入data-server，查询indicatorMenuId:" + indicatorMenuId + "，日期：" + date + "，维度类型：" + dimCode + "，维度值：" + dimVal);

			JedisCluster jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();

			// MENU_ID,OP_TIME,DIM_CODE,DIM_VAL
			String key = indicatorMenuId + "~" + date + "~" + dimCode + "~" + dimVal;

			if (jedisCluster == null) {
				logger.error("未获取到jedis连接");
			}
			if (jedisCluster != null) {
				if (jedisCluster.exists(key)) {
					// 如果不是实时查询数据库，则直接返回redis中的数据
					if (!StringUtils.isEmpty(queryDB) && "0".equals(queryDB)) {
						return jedisCluster.get(key);
					}
				}
			}

			String time = DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");

			List<Kpi> kpiList = new ArrayList<Kpi>();
			if (!indicatorMenuId.contains(",")) {// 取单个指标的值
				if (null != date && null != dimCode && null != dimVal) {
					kpiList = kpiService.getKpiByIndicatorMenuId(indicatorMenuId, date, dimCode, dimVal);
				}
				if (kpiList == null) {
					kpiList = new ArrayList<Kpi>();
				}
				if (jedisCluster != null) {
					jedisCluster.set(key, JsonHelper.getInstance().write(kpiList));
				}
				return kpiList;
			} else {// 取多个指标的值
				String[] indicatorMenuIds = indicatorMenuId.split(",");
				// 并发查询，按每一个指标开一个线程来查询
				ExecutorService executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
				for (String menuId : indicatorMenuIds) {
					executorService.execute(new KpiRunnable(menuId, date, dimCode, dimVal, kpiService, kpiList));
				}
				// 等待线程池中的线程全部执行完毕后再执行后面的程序
				executorService.shutdown();
				while (true) {
					if (executorService.isTerminated()) {
						break;
					}
					// Thread.sleep(500);
				}
				if (kpiList == null) {
					kpiList = new ArrayList<Kpi>();
				}
				if (jedisCluster != null) {
					jedisCluster.set(key, JsonHelper.getInstance().write(kpiList));
				}
				return kpiList;
			}
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return new ArrayList<Kpi>();
		}
	}

	/**
	 * 按时间段查询KPI数据
	 * 
	 * @param id
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "query/{indicatorMenuId}")
	public @ResponseBody Object queryKpiByDuring(@PathVariable String indicatorMenuId, WebRequest request, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		String startTime = request.getParameter("startTime");
		String dimCode = request.getParameter("dimCode");
		String dimVal = request.getParameter("dimVal");
		String endTime = request.getParameter("endTime");
		String queryDB = request.getParameter("queryDB");
		JedisCluster jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();
		logger.debug("进入data-server，查询indicatorMenuId:" + indicatorMenuId + "，日期：" + startTime + ", 结束日期" + endTime + "，维度类型：" + dimCode + "，维度值：" + dimVal);

		String key = indicatorMenuId + "~" + startTime + "--" + endTime + "~" + dimCode + "~" + dimVal;
		try {
			if (jedisCluster == null) {
				logger.error("未获取到jedis连接");
			}
			if (jedisCluster != null) {
				if (jedisCluster.exists(key)) {
					// 如果不是实时查询数据库，则直接返回redis中的数据
					if (!StringUtils.isEmpty(queryDB) && "0".equals(queryDB)) {
						return jedisCluster.get(key);
					}
				}
			}
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}

		List<Kpi> kpiList = new ArrayList<Kpi>();
		try {
			if (null != startTime && endTime != null && null != dimCode && null != dimVal) {
				kpiList = kpiService.getKpiByTime(indicatorMenuId, startTime, endTime, dimCode, dimVal);
			}

			if (kpiList == null) {
				kpiList = new ArrayList<Kpi>();
			}
			if (jedisCluster != null) {
				jedisCluster.set(key, JsonHelper.getInstance().write(kpiList));
			}
			return kpiList;
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return null;
	}

	/**
	 * 查询所有指标定义
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "def")
	@ResponseBody
	public Object defKpi(WebRequest request, Model model) {
		List<KpiDef> kpiDefList = null;
		try {
			kpiDefList = kpiService.getDefAll();
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return kpiDefList;
	}

	/**
	 * 查询指定的指标定义
	 * 
	 * @param kpiId
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "def/{kpiId}")
	@ResponseBody
	public Object defKpi(@PathVariable String kpiId, WebRequest request, Model model) {
		try {
			if (!kpiId.contains(",")) {
				KpiDef kpiDef = kpiService.getKpiDefById(kpiId);
				return kpiDef;
			} else {
				String[] ids = kpiId.split(",");
				List<KpiDef> list = new ArrayList<KpiDef>();
				for (String id : ids) {
					KpiDef kpiDef = kpiService.getKpiDefById(id);
					if (kpiDef != null) {
						list.add(kpiDef);
					}
				}
				return list;
			}
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return null;
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
}
