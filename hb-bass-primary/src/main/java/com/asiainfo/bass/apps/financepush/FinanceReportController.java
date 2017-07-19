package com.asiainfo.bass.apps.financepush;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.apps.models.Report;
import com.asiainfo.bass.apps.models.ReportDao;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/financeReport")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class FinanceReportController {
	private static Logger LOG = Logger.getLogger(FinanceReportController.class);

	@Autowired
	private ReportDao reportDao;
	
	@Autowired
	private FinanceReportService financeReportService;
	
//	/**
//	 * 到报表页面
//	 * @param sid
//	 * @param user
//	 * @param model
//	 * @param to 接收人 如果是彩信则是电话号码的字符串数组，如过是邮件则是邮箱的字符串数组
//	 * @param flag=1彩信 flag=2邮件
//	 * @return
//	 */
//	@RequestMapping(value = "{sid}/sendReport/{type}/{to}", method = RequestMethod.GET)
//	public String sendEmail( @PathVariable("sid") String sid, @PathVariable("type") String type, @PathVariable("to") String to, @ModelAttribute("user") User user, Model model) {
//
//		Report rpt = reportDao.getReportById(Integer.valueOf(sid), user.getCityId(), user);
//		model.addAttribute("sid", String.valueOf(rpt.getId()));
//		model.addAttribute("header", rpt.getHeaderData());
//		model.addAttribute("title", rpt.getName());
//		model.addAttribute("dimension", rpt.getDimensionData());
//		model.addAttribute("grid", rpt.getGrid());
//		model.addAttribute("code", rpt.getCodeData());
//		model.addAttribute("cache", rpt.getIsCached());
//		model.addAttribute("ds", rpt.getDs());
//		model.addAttribute("useExcel", rpt.getUseExcel());
//		model.addAttribute("useChart", rpt.getUseChart());
//		model.addAttribute("groupId", user.getGroupId().equals("") ? "26020" : user.getGroupId());
//		model.addAttribute("timeline", JsonHelper.getInstance().write(reportDao.getTimeLine(rpt.getId())));
//		model.addAttribute("type", type);
//		model.addAttribute("to", to);
//		model.addAttribute("status", "error");
//		
//		String sql = rpt.getOriSQL().trim().replaceAll("\r\n", " ").replaceAll("\n", " ");
//		if (sql.endsWith(";")) {
//			sql = sql.substring(0, sql.length() - 1);
//		}
//
//		model.addAttribute("sql", sql.replaceAll("\\{condiPiece\\}", " \"+ aihb.AjaxHelper.parseCondition() +\" "));
//
//		model.addAttribute("corReport", JsonHelper.getInstance().write(reportDao.getCorrealtiveReport(rpt)));
//		return "ftl/report";
//	}
//	
//	/**
//	 * 到报表页面
//	 * @param sid
//	 * @param user
//	 * @param model
//	 * @param type=1彩信 type=2邮件
//	 * @param to 接收人 如果是彩信则是电话号码的字符串数组，如过是邮件则是邮箱的字符串数组
//	 * @param 
//	 * @return
//	 */
//	@RequestMapping(value = "/sendReport", method = RequestMethod.POST)
//	public void sendEmailOrMMS(HttpServletResponse response, WebRequest request,@ModelAttribute("mvcPath") String mvcPath) {
//
//		String sql = request.getParameter("sql");
//		String header = request.getParameter("header");
//		String fileName = request.getParameter("fileName");
//		String ds = request.getParameter("ds");
//		String type = request.getParameter("type");
//		String to = request.getParameter("to");
//		String result = "";
//		boolean flag = false;
//		if(!"".equals(type) && type.equals("Email")){
//			flag = financeReportService.sendEmailList(header, sql, to, fileName, ds);
//		}else if(!"".equals(type) && type.equals("MMS")){
//			flag = financeReportService.sendMMSList(header, sql, to, fileName, ds);
//		}
//		if(flag){
//			result = "ok";
//		} else {
//			result = "error";
//		}
//		response.setCharacterEncoding("UTF-8");
//		try {
//			PrintWriter out = response.getWriter();
//			LOG.info(result);
//			out.print(result);
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}
	
	/**
	 * 到报表页面
	 * @param sid
	 * @param user
	 * @param model
	 * @param to 接收人 如果是彩信则是电话号码的字符串数组，如过是邮件则是邮箱的字符串数组
	 * @param flag=1彩信 flag=2邮件
	 * @return
	 */
	@RequestMapping(value = "{sid}/sendReport/{type}/{group}/{monthId}", method = RequestMethod.GET)
	public void sendEmail(HttpServletResponse response, @PathVariable("sid") String sid, @PathVariable("type") String type, @PathVariable("group") String group, @PathVariable("monthId") Integer monthId, @ModelAttribute("user") User user) throws Exception {
		
		LOG.info("进入的URL为：/mvc/financeReport/" + sid + "/sendReport/" + type + "/" + group + "/" + monthId);
		Report rpt = reportDao.getReportById(Integer.valueOf(sid), user.getCityId(), user);
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");  
		java.util.Date date = format.parse(monthId.toString());
		calendar.setTime(date);  
		calendar.add(Calendar.MONTH,-1);         
        int month = calendar.get(Calendar.MONTH) + 1;
        String monthID = String.valueOf(month);
        String time = "";
        if(monthID.length()!=2){
        	time = String.valueOf(calendar.get(Calendar.YEAR)) + "0" + monthID;
        }else if(monthID.length()==2){
        	time = String.valueOf(calendar.get(Calendar.YEAR)) + monthID;
        }
		String fileName = rpt.getName();
		String ds = rpt.getDs();
		String sql = rpt.getOriSQL().trim().replaceAll("\r\n", " ")
						.replaceAll("\n", " ")
						.replace("$F{aihb.Util.calDate('{time}')[0].substring(0,6)}", time)
						.replace("{time}", String.valueOf(monthId));
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}
		sql = sql.replaceAll("\\{condiPiece\\}", " \"+ aihb.AjaxHelper.parseCondition() +\" ");
		LOG.info("sql======================"+sql);
		String _header = financeReportService.getHeader(sid);
		LOG.info("_header======================"+_header);
		String result = "";
		boolean flag = false;
		if(!"".equals(type) && type.equals("Email")){
			flag = financeReportService.sendEmailList(_header, sql, group, fileName, ds, monthId.toString());
		}else if(!"".equals(type) && type.equals("MMS")){
			flag = financeReportService.sendMMSList(_header, sql, group, fileName, ds, monthId.toString());
		}
		if(flag){
			result = "ok";
		} else {
			result = "error";
		}
		response.setCharacterEncoding("UTF-8");
		try {
			PrintWriter out = response.getWriter();
			LOG.info(result);
			out.print(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
