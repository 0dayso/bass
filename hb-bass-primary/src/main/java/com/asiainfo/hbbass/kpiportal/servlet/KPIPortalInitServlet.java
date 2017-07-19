package com.asiainfo.hbbass.kpiportal.servlet;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;
import org.quartz.SchedulerFactory;
import org.quartz.ee.servlet.QuartzInitializerServlet;

import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;
import com.asiainfo.hbbass.kpiportal.job.KPIPortalTimer;

public class KPIPortalInitServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 7306399367224332379L;

	private static Logger log = Logger.getLogger(KPIPortalInitServlet.class);

	public void init(ServletConfig context) throws ServletException {
		log.info("服务器启动加载KPI门户");
		KPIEntityInitialize.initialize();
		log.info("KpiEntryContainer放入application中");

		SchedulerFactory factory = (SchedulerFactory) context.getServletContext().getAttribute(QuartzInitializerServlet.QUARTZ_FACTORY_KEY);
		KPIPortalTimer timer = new KPIPortalTimer();
		timer.start(factory);
		context.getServletContext().setAttribute("KpiPortalTimer", timer);
		log.info("KpiPortalTimer定时器已启动,放入application中");

	}
}
