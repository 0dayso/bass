package com.asiainfo.bass.apps.mmsreport;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/MMSReport")
@SessionAttributes({ "mvcPath", "contextPath", SessionKeyConstants.USER})
public class MMSReportController {
	
	private static Logger LOG = Logger.getLogger(MMSReportController.class);
	
	@Autowired
	private MMSReportDao mmsReportDao;
	
	@Autowired
	private MMSReportService mmsReportService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String MMSConfig(@ModelAttribute("user") User user) {
		return "ftl/mms/mmsConfig";
	}
	
	@RequestMapping(value = "/configTime", method = RequestMethod.GET)
	public String configTime(@ModelAttribute("user") User user) {
		return "ftl/mms/mmsConfigTime";
	}
	
	@RequestMapping(value = "/configManage", method = RequestMethod.GET)
	public String configManage(@ModelAttribute("user") User user) {
		return "ftl/mms/mmsConfigManage";
	}
	
	@RequestMapping(value = "/mailContent", method = RequestMethod.GET)
	public String mailContent(@ModelAttribute("user") User user) {
		return "ftl/mailContent/mailContent";
	}
	
	/**
	 * 新增
	 * @param title		标题
	 * @param time		时间
	 * @param content	内容
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/save", method = RequestMethod.PUT)
	public @ResponseBody
	Map save(@RequestParam String title, @RequestParam String time, @RequestParam String content, @RequestParam String sender){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.save(title, time, content, sender);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	/**
	 * 新增
	 * @param title		标题
	 * @param time		时间
	 * @param content	内容
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/saveMailContent", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveMailContent(@RequestParam String title, @RequestParam String mail, @RequestParam String content){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.saveMailContent(title, mail, content);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/createMailContent", method = RequestMethod.PUT)
	public @ResponseBody
	Map createMailContent(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String id = request.getParameter("id");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportService.createMailContent(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	/**
	 * 跳转预览页面
	 */
	@RequestMapping(value = "viewMailContent" ,method = RequestMethod.GET)
	public String viewMailContent(HttpServletResponse response, WebRequest request,
			@ModelAttribute("user") User user, Model model) {
		String id = request.getParameter("id");
		String content = mmsReportDao.getMailContent(id);
		if(null==content || "".equals(content)){
			content = "请生成模版，再预览。";
		}
		model.addAttribute("content",content);
		return "ftl/mailContent/viewMailContent";
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/updateMailContent", method = RequestMethod.PUT)
	public @ResponseBody
	Map updateMailContent(@RequestParam String id, @RequestParam String title, @RequestParam String mail, @RequestParam String content){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.updateMailContent(id,title, mail, content);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/createMail/{time}/{mid}", method = RequestMethod.GET)
	public @ResponseBody
	void createMail(HttpServletResponse response, @PathVariable("time") String time, @PathVariable("mid") String mid, @ModelAttribute("user") User user){
		boolean flag = false;
		HashMap map = mmsReportService.getMailContentInfo(mid, time);
		int result = mmsReportDao.insertSendMailJob(map);
		if(result==1){
			flag = true;
		}
		try {
			LOG.info(flag);
			PrintWriter out = response.getWriter();
			out.print(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/senderMMS/{time}/{mid}", method = RequestMethod.GET)
	public @ResponseBody
	void senderMMS(HttpServletResponse response, @PathVariable("time") String time, @PathVariable("mid") String mid, @ModelAttribute("user") User user){
		boolean flag = false;
		try{
			List list = mmsReportDao.getList(mid);
			//获得彩信标题
			String title = mmsReportService.getTitle(list);
			//获得发送人
			String sender = mmsReportService.getSender(list).replaceAll(";", "#");
			//拼彩信内容
			String content = mmsReportService.getContentByTime(list, time);
			//发送彩信
			flag = mmsReportService.sendMMS(title, content, sender, time);
			PrintWriter out = response.getWriter();
			out.print(flag);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/update", method = RequestMethod.PUT)
	public @ResponseBody
	Map update(@RequestParam String id, @RequestParam String title, @RequestParam String time, @RequestParam String content, @RequestParam String sender){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.update(id,title, time, content,sender);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/getPara" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map getPara(@RequestParam String id){
		Map result = new HashMap();
		List list = mmsReportDao.getParaList(id);
		if(list!=null && list.size()>0){
			result.put("flag", true);
			result.put("list", list);
		}else{
			result.put("flag", false);
		}
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/savePara" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map savePara(@RequestParam String id, @RequestParam String para, @RequestParam String sql){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.savePara(id,para,sql);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/saveMailContentPara" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map saveMailContentPara(@RequestParam String id, @RequestParam String para, @RequestParam String sql){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.saveMailContentPara(id,para,sql);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/getCompare" ,method=RequestMethod.GET)
	public @ResponseBody
	List getCompare() {
		List list = mmsReportDao.getCompare();
		return list;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="/saveCompare" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map saveCompare(@RequestParam String id, @RequestParam String compare, @RequestParam String compsqlvalue, @RequestParam String compsql, @RequestParam String comparesqlvalue){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.saveCompare(id,compare,compsqlvalue,compsql,comparesqlvalue);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/getCompares" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map getCompares(@RequestParam String id){
		Map result = new HashMap();
		List list = mmsReportDao.getCompareList(id);
		if(list!=null && list.size()>0){
			result.put("flag", true);
			result.put("list", list);
		}else{
			result.put("flag", false);
		}
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/auditing" ,method=RequestMethod.PUT)
	public @ResponseBody
	Map auditing(@RequestParam String id){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.auditing(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/complete" ,method=RequestMethod.PUT)
	public @ResponseBody
	Map complete(@RequestParam String id){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.complete(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/delete" ,method=RequestMethod.DELETE)
	public @ResponseBody
	Map delete(@RequestParam String id){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.delete(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/mailContentDelete" ,method=RequestMethod.DELETE)
	public @ResponseBody
	Map mailContentDelete(@RequestParam String id){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.mailContentDelete(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/send" ,method = RequestMethod.POST)
	public @ResponseBody
	Map MMSReport(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) throws Exception{
		String id = request.getParameter("id");
		String sender = request.getParameter("sender");
		Map msg = new HashMap();
		msg.put("status", "发送成功");
		//根据ID查询GLOBAL_VAL_TEXT_TEMP表中的记录
		try{
			List list = mmsReportDao.getList(id);
			//获得彩信标题
			String title = mmsReportService.getTitle(list);
			//获得发送日期
			String time = mmsReportService.getTime(list);
			//拼彩信内容
			String content = mmsReportService.getContent(list);
			//发送彩信
			mmsReportService.sendMMS(title, content, sender, time);
		}catch(Exception e){
			msg.put("status", "发送失败");
			e.printStackTrace();
		}
		return msg;
	} 
	
	/**
	 * 跳转预览页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "view" ,method = RequestMethod.GET)
	public String viewReport(HttpServletResponse response, WebRequest request,
			@ModelAttribute("user") User user, Model model) {
		String id = request.getParameter("id");
		// 根据ID查询GLOBAL_VAL_TEXT_TEMP表中的记录
		List list = mmsReportDao.getList(id);
		// 拼彩信内容
		String content = mmsReportService.getContent(list);
		model.addAttribute("content",content);
		return "ftl/mms/viewReport";
	}
	
	/**
	 * 跳转配置参数页面
	 */
	@RequestMapping(value = "/configPara", method = RequestMethod.GET)
	public String configPara(WebRequest request, Model model, @ModelAttribute("user") User user) {
		String id = request.getParameter("id");
		String content = mmsReportDao.getContent(id);
		model.addAttribute("id", id);
		model.addAttribute("content", content);
		return "ftl/mms/mmsConfigParas";
	}
	
	/**
	 * 跳转邮件配置参数页面
	 */
	@RequestMapping(value = "/mailConfigPara", method = RequestMethod.GET)
	public String mailConfigPara(WebRequest request, Model model, @ModelAttribute("user") User user) {
		String id = request.getParameter("id");
		String content = mmsReportDao.getmailContent(id);
		model.addAttribute("id", id);
		model.addAttribute("content", content);
		return "ftl/mailContent/mailConfigParas";
	}
	
	/**
	 * 跳转配置同比页面
	 */
	@RequestMapping(value = "/configCompare", method = RequestMethod.GET)
	public String configCompare(WebRequest request, Model model, @ModelAttribute("user") User user) {
		String id = request.getParameter("id");
		String content = mmsReportDao.getContent(id);
		model.addAttribute("id", id);
		model.addAttribute("content", content);
		return "ftl/mms/mmsConfigCompares";
	}
	
	/**
	 * 跳转配置发送彩信页面
	 */
	@RequestMapping(value = "/mmsSend", method = RequestMethod.GET)
	public String mmsSend(WebRequest request, Model model, @ModelAttribute("user") User user) {
		String id = request.getParameter("id");
		model.addAttribute("id", id);
		model.addAttribute("_cityid",user.getCityId());
		return "ftl/mms/mmsSend";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/getArea", method = RequestMethod.POST)
	public void getArea(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) throws Exception{
		String cityId = user.getCityId();
		List list = mmsReportDao.getArea(cityId);		
		String jsonStr = JsonHelper.getInstance().write(list);
		PrintWriter out = response.getWriter();
		out.print(jsonStr);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/timeSave" ,method = RequestMethod.PUT)
	public @ResponseBody
	Map timeSave(@RequestParam String id, @RequestParam String time){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			mmsReportDao.timeSave(id,time);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@RequestMapping(value = "/sendSms/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendSmsForStock(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		boolean flag = false;
		try{
			mmsReportService.sendSmsForStock(time);
			flag = true;	
		}catch(Exception e){
			e.printStackTrace();
		}
		try {
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	} 
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/sendEmailForAttachment/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendEmailForAttachment(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		//生成邮件内容
		HashMap map = mmsReportService.getMailContentForAttachment(time);
		//生成附件并插入发送邮件表
		boolean flag = false;
		flag = mmsReportService.sendEmailForAttachment(map);
		try {
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/sendMMSForDay/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendMMSForDay(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		//生成附件并插入发送邮件表
		boolean flag = false;
		flag = mmsReportService.sendMMSForDay(time);
		try {
			LOG.info(flag);
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/sendMMSForWeek/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendMMSForWeek(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		boolean flag = false;
		flag = mmsReportService.sendMMSForWeek(time);
		try {
			LOG.info(flag);
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/sendMMSForMonth/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendMMSForMonth(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		boolean flag = false;
		flag = mmsReportService.sendMMSForMonth(time);
		try {
			LOG.info(flag);
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/sendMailForTerminal/{time}", method = RequestMethod.GET)
	public @ResponseBody
	void sendMailForTerminal(HttpServletResponse response, @PathVariable("time") String time, @ModelAttribute("user") User user){
		boolean flag = false;
		flag = mmsReportService.sendMailForTerminal(time);
		try {
			LOG.info(flag);
			PrintWriter out = response.getWriter();
			out.print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
