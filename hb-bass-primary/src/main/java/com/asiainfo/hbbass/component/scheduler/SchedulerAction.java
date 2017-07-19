package com.asiainfo.hbbass.component.scheduler;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.ee.servlet.QuartzInitializerServlet;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * @author Mei Kefu
 * @date 2009-11-27
 */
public class SchedulerAction extends Action {

	private static Logger LOG = Logger.getLogger(SchedulerAction.class);

	private SchedulerService schedService = new SchedulerService();

	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String method = request.getParameter("method");
		String msg = "操作失败";
		LOG.debug(method);
		try {
			SchedulerFactory factory = (SchedulerFactory) request.getSession().getServletContext().getAttribute(QuartzInitializerServlet.QUARTZ_FACTORY_KEY);
			// SchedulerFactory factory = new StdSchedulerFactory();//仅用于本机测试
			// 测试不成功!
			Scheduler scheduler = factory.getScheduler();
			schedService.setscheduler(scheduler);

			String triName = request.getParameter("triName");
			String triGroup = request.getParameter("triGroup");

			if ("add".equalsIgnoreCase(method)) {
				String randStr = "";
				if (triName == null || triName.length() == 0) {
					randStr = UUID.randomUUID().toString().replaceAll("-", "");
					triName = "tri_" + randStr;
				}

				if (triGroup == null || triGroup.length() == 0) {
					randStr = UUID.randomUUID().toString().replaceAll("-", "");
					triGroup = "triGrp_" + randStr;
				}

				String jobName = request.getParameter("jobName");

				if (jobName == null || jobName.length() == 0) {
					if (randStr.length() == 0) {
						randStr = UUID.randomUUID().toString().replaceAll("-", "");
					}
					jobName = "job_" + randStr;
				}

				String jobGroup = request.getParameter("jobGroup");

				if (jobGroup == null || jobGroup.length() == 0) {
					if (randStr.length() == 0) {
						randStr = UUID.randomUUID().toString().replaceAll("-", "");
					}
					jobGroup = "jobGrp_" + randStr;
				}

				String jsonStr = request.getParameter("json");

				String cronExpress = request.getParameter("cronExpress");
				// cronExpress 字符传为空是就是下一分钟，执行一次
				if (cronExpress == null || cronExpress.length() == 0) {
					SimpleDateFormat sdf = new SimpleDateFormat("ss m H d M ? yyyy");
					Calendar calendar = GregorianCalendar.getInstance();
					calendar.add(Calendar.MINUTE, 1);
					cronExpress = sdf.format(calendar.getTime());
				}

				// jsonStr=URLDecoder.decode(jsonStr, "UTF-8");

				String jobClassName = request.getParameter("jobClassName");
				Class<?> cls = Class.forName(jobClassName);
				LOG.debug("jobName:" + jobName + "jobGroup:" + jobGroup + " cronExpress:" + cronExpress + " jsonStr:" + jsonStr + " jobClassName:" + jobClassName);
				schedService.add(cls, jobName, jobGroup, triName, triGroup, cronExpress, jsonStr);
			} else if ("remove".equalsIgnoreCase(method)) {
				schedService.remove(triName, triGroup);
			} else if ("pause".equalsIgnoreCase(method)) {
				schedService.pause(triName, triGroup);
			} else if ("resume".equalsIgnoreCase(method)) {
				schedService.resume(triName, triGroup);
			} else if ("start".equalsIgnoreCase(method)) {
				schedService.start();
			} else if ("shutdown".equalsIgnoreCase(method)) {
				schedService.shutdown();
			} else if ("show".equalsIgnoreCase(method)) {
				response.getWriter().print(schedService.show());
				return;
			}
			msg = "操作成功";
		} catch (SchedulerException e) {
			e.printStackTrace();
			msg += " " + e.getMessage();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			msg += " " + e.getMessage();
		} catch (ParseException e) {
			e.printStackTrace();
			msg += " " + e.getMessage();
		}

		response.getWriter().print(msg);
	}

	public static void main(String[] args) {
		System.out.println("select 111 ".substring(0, 7));

		System.out.println(UUID.randomUUID());

		System.out.println();

		SimpleDateFormat sdf = new SimpleDateFormat("ss m H d M ? yyyy");
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.add(Calendar.MINUTE, 2);
		System.out.println(sdf.format(calendar.getTime()));

		System.out.println("kpiportal/kpiview/indexkpi.jsp?appName=ChannelD|funccode=966|menuitemid=967|loginname=wangbotao|cityId=0".replace('|', '&'));
	}
}
