package com.asiainfo.bass.apps.controllers;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.apps.models.Issue;
import com.asiainfo.bass.apps.models.IssueDao;
import com.asiainfo.bass.apps.models.IssueService;
import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.SendSmsWrapper;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.component.msg.mail.SendMailWrapper;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-24
 */
@SuppressWarnings("unused")
@Controller
@Transactional
@RequestMapping(value = "/issue")
@SessionAttributes({SessionKeyConstants.USER})
public class IssueController {
	
	private static Logger LOG = Logger.getLogger(IssueController.class);

	@Autowired
	private IssueDao issueDao;
	
	@Autowired
	private IssueService issueService;

	@RequestMapping(method = RequestMethod.POST)
	public String issueSearch(WebRequest request, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		return issue(request, model, user);
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(method = RequestMethod.GET)
	public String issue(WebRequest request, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {

		String page = request.getParameter("page");

		if (page == null || page.length() == 0 || !page.matches("[0-9]+")) {
			page = "1";
		}

		String pageSize = request.getParameter("pageSize");
		if (pageSize == null || pageSize.length() == 0 || !pageSize.matches("[0-9]+")) {
			pageSize = "10";
		}

		String kw = request.getParameter("kw");
		String issue_type = request.getParameter("issue_type");
		List list =issueDao.getIssues(Integer.valueOf(page), Integer.valueOf(pageSize), kw, issue_type, user.getName());
		model.addAttribute("twis", list);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("currentPage", page);
		model.addAttribute("twisCount", issueDao.getIssuesCount(kw, issue_type));
		model.addAttribute("actives", issueDao.getActiveUsers(user.getId()));
		model.addAttribute("userId", user.getId());
		model.addAttribute("issue_type", issue_type);
		model.addAttribute("typeList", issueDao.getTwitterType());
		return "/ftl/issue/issues";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "{issueId}", method = RequestMethod.GET)
	public String issue(@PathVariable("issueId") String issueId, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		model.addAttribute("twis", issueDao.getIssuesById(issueId));
		List<Issue> list = issueDao.getIssuesById(issueId);
		Issue issue = (Issue)list.get(0);
		model.addAttribute("sid",String.valueOf(issue.getId()));
		model.addAttribute("actives", issueDao.getActiveUsers(user.getId()));
		model.addAttribute("userId", user.getId());
		model.addAttribute("typeList", issueDao.getTwitterType());
		return "/ftl/issue/issue_reply";
	}

	@RequestMapping(value = "{issueId}", method = RequestMethod.POST)
	public @ResponseBody
	String issue(WebRequest request, @PathVariable("issueId") String issueId, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {

		String content = request.getParameter("content");
		String state = request.getParameter("state");
		String telephone = request.getParameter("telephone");
		String fileName = request.getParameter("fileName");

		Issue issue = new Issue();
		issue.setContent(content);
		issue.setTelephone(telephone);
		issue.setPid(Long.valueOf(issueId));
		issue.setUser(user);
		issue.setState(state);
		if(!"".equals(fileName) && fileName!=null){
			issue.setFileName(fileName);
		}
		long pid = issueDao.save(issue);

		String issueType = request.getParameter("issueType");

		issueDao.updateIssueType(String.valueOf(pid), issueType);
		issueDao.updateIssueType(request.getParameter("pid"), issueType);

		return "成功";
	}
	
	@RequestMapping(value = "add", method = RequestMethod.GET)
	public String add(Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		model.addAttribute("actives", issueDao.getActiveUsers(user.getId()));
		model.addAttribute("typeList", issueDao.getTwitterType());
		
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
		calendar.add(Calendar.DATE, 2);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String defTime = sdf.format(calendar.getTime());
		model.addAttribute("defTime", defTime);
		
		return "/ftl/issue/issue_insert";
	}

	@RequestMapping(value = "addSave")
	public @ResponseBody
	void addSave(WebRequest request, @ModelAttribute(SessionKeyConstants.USER) User user) throws UnsupportedEncodingException {
		EncodeFilter ef=new EncodeFilter();
		
		String content = ef.allCharacters(request.getParameter("content"));
		String telephone =ef.allCharacters( request.getParameter("telephone"));
		String replyId = request.getParameter("replyId");
		String reply = request.getParameter("reply");
		String state = request.getParameter("state");
		String issueType = request.getParameter("issueType");
		String fileName = request.getParameter("fileName").trim();
		String endTime = request.getParameter("endTime");
		
		state = URLDecoder.decode(state, "UTF-8");
		content = URLDecoder.decode(content, "UTF-8");
		fileName = URLDecoder.decode(fileName, "UTF-8");
		
		Issue issue = new Issue();
		issue.setContent(content);
		issue.setTelephone(telephone);
		issue.setReplyId(replyId);
		issue.setReply(reply);
		issue.setUser(user);
		issue.setState(state);
		issue.setType(issueType);
		issue.setEndTime(endTime);
		if(!"".equals(fileName) && fileName!=null){
			issue.setFileName(fileName);
		}
		Map<String, Object> typeInfo = issueDao.getTypeInfo(issueType);
		issue.setResponsibleId((String) typeInfo.get("userid"));
		issue.setResponsiblePhone((String) typeInfo.get("mobile"));
		issue.setResponsible((String) typeInfo.get("username"));
		long pid = issueDao.save(issue);
		
		issue.setId(pid);
		issueDao.updateIssueType(String.valueOf(pid), issueType);
		LOG.info("调用BOMC接口");
		try {
			Map<String, String> map = issueService.sendIssue("create", issue);
			//调用结果succflag为success成功
			if(!"success".equalsIgnoreCase(map.get("succflag"))){
				String[] to = new String[]{"15727078320@139.com","15971418800@139.com"};
				String mailCont = "问题申告接口调用异常，具体信息如下：<br>" 
						+ "申告ID：" + pid + "<br>"
						+ "用户：" + user.getId() + "<br>"
						+ "错误信息：" +map.get("errmsg") + "。<br>请核查。";
				SendMailWrapper.send(to, "问题申告接口调用异常通知", mailCont);
			}
		} catch (Exception e) {
			LOG.error("调用接口出现异常：\r\n" + LogUtil.getExceptionMessage(e));
		}
		LOG.info("BOMC接口调用结束");

	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(WebRequest request, Model model, @ModelAttribute(SessionKeyConstants.USER) User user) {
		String sid = request.getParameter("sid");
		sid = sid.replaceAll(",", "");
		List list = issueDao.getIssuesById(sid);
		if(list!=null && list.size()>0){
			Issue issue = (Issue)list.get(0);
			String content = issue.getContent();
			String telephone = "";
			if(!"".equals(issue.getTelephone()) && issue.getTelephone()!=null){
				telephone = issue.getTelephone();
			}
			Long issueId = issue.getId();
			Long pid = issue.getPid();
			String type = issue.getType();
			String title = "";
			int index = (content.substring(1, content.length())).indexOf("#");
			if(index>0){
				String[] contents = content.split("#");
				title = contents[1];
				content = contents[2];
			}
			String fileName = issue.getFileName();
			String endTime = "";
			if(!StringUtils.isEmpty(issue.getEndTime())){
				endTime = issue.getEndTime();
			}
			model.addAttribute("issueId", issueId);
			model.addAttribute("pid", pid);
			model.addAttribute("title", title);
			model.addAttribute("content", content);
			model.addAttribute("type", type);
			model.addAttribute("fileName", fileName);
			model.addAttribute("telephone", telephone);
			model.addAttribute("endTime", endTime);
			model.addAttribute("actives", issueDao.getActiveUsers(user.getId()));
			model.addAttribute("typeList", issueDao.getTwitterType());
		}
		return "/ftl/issue/issue_update";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public @ResponseBody
	String save(WebRequest request, @ModelAttribute(SessionKeyConstants.USER) User user) {

		String issueId = request.getParameter("issueId");
		issueId = issueId.replaceAll(",", "");
		String pid = request.getParameter("pid");
		pid = pid.replaceAll(",", "");
		String content = request.getParameter("content");
		String telephone = request.getParameter("telephone");
		String replyId = request.getParameter("replyId");
		String reply = request.getParameter("reply");
		String state = request.getParameter("state");
		String issueType = request.getParameter("issueType");
		String fileName = request.getParameter("fileName");
		String endTime = request.getParameter("endTime");
		Issue issue = new Issue();
		List list = issueDao.getIssuesById(issueId);
		if(list!=null && list.size()>0){
			issue = (Issue)list.get(0);
		}
		issue.setId(Long.parseLong(issueId));
		issue.setPid(Long.parseLong(pid));
		issue.setContent(content);
		issue.setTelephone(telephone);
		issue.setReplyId(replyId);
		issue.setReply(reply);
		issue.setState(state);
		issue.setType(issueType);
		issue.setEndTime(endTime);
		if(!"".equals(fileName) && fileName!=null){
			issue.setFileName(fileName);
		}
		
		Map<String, Object> typeInfo = issueDao.getTypeInfo(issueType);
		issue.setResponsibleId((String) typeInfo.get("userid"));
		issue.setResponsiblePhone((String) typeInfo.get("mobile"));
		issue.setResponsible((String) typeInfo.get("username"));
		
		long id = issueDao.save(issue);
		LOG.info("调用BOMC接口");
		try {
			Map<String, String> map = issueService.sendIssue("modify", issue);
			//调用结果succflag为success成功
			if(!"success".equalsIgnoreCase(map.get("succflag"))){
				String[] to = new String[]{"15727078320@139.com","15971418800@139.com"};
				String mailCont = "问题申告接口调用异常，具体信息如下：<br>" 
						+ "申告ID：" + issueId + "<br>"
						+ "用户：" + user.getId() + "<br>"
						+ "错误信息：" +map.get("errmsg") + "。<br>请核查。";
				SendMailWrapper.send(to, "问题申告接口调用异常通知", mailCont);
			}
		} catch (Exception e) {
			LOG.error("调用接口出现异常：\r\n" + LogUtil.getExceptionMessage(e));
		}
		LOG.info("调用BOMC接口结束");
		issueDao.updateIssueType(String.valueOf(id), issueType);

		return "成功";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	public @ResponseBody
	int delete(WebRequest request, @ModelAttribute(SessionKeyConstants.USER) User user) {
		int result = 0;
		String sid = request.getParameter("sid");
		sid = sid.replaceAll(",", "");
		Issue issue = new Issue();
		List list = issueDao.getIssuesById(sid);
		if(list!=null && list.size()>0){
			issue = (Issue)list.get(0);
			result = issueDao.delete(issue);
		}
		LOG.info("调用BOMC接口");
		try {
			Map<String, String> map = issueService.sendIssue("delete", issue);
			//调用结果succflag为success成功
			if(!"success".equalsIgnoreCase(map.get("succflag"))){
				String[] to = new String[]{"15727078320@139.com","15971418800@139.com"};
				String mailCont = "问题申告接口调用异常，具体信息如下：<br>" 
						+ "申告ID：" + sid + "<br>"
						+ "用户：" + user.getId() + "<br>"
						+ "错误信息：" +map.get("errmsg") + "。<br>请核查。";
				SendMailWrapper.send(to, "问题申告接口调用异常通知", mailCont);
			}
		} catch (Exception e) {
			LOG.error("调用接口出现异常：\r\n" + LogUtil.getExceptionMessage(e));
		}
		LOG.info("调用BOMC接口结束");
		return result;
	}

	/**
	 * 
	 * @param request
	 * @param user
	 * @return 1:短信发送失败,2:指派成功
	 */
	@RequestMapping(value = "assign", method = RequestMethod.POST)
	public @ResponseBody
	String assign(WebRequest request, @ModelAttribute(SessionKeyConstants.USER) User user) {
		String assignTo = request.getParameter("assignTo");
		String title = request.getParameter("title");
		String sid = request.getParameter("sid");
		String assignToName = issueDao.getName(assignTo);
		try {
			//给申告增加责任人
			issueDao.addResponsble(Integer.parseInt(sid), assignToName);
			SendSmsWrapper sendSms = (SendSmsWrapper) BeanFactoryA.getBean("sendSmsWrapper");
			sendSms.send(assignTo, "您好！经分系统有如下申告《" + title + "》等待您处理");
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
		return "2";
	}
	
	/**
	 * 
	 * @param request
	 * @param user
	 */
	@RequestMapping(value = "assignTo", method = RequestMethod.POST)
	public @ResponseBody
	String assignTo(WebRequest request, @ModelAttribute(SessionKeyConstants.USER) User user) {
		String assign = request.getParameter("telephone");
		String title = request.getParameter("title");
		String sid = request.getParameter("sid");
		try {
			issueDao.updateReplyTime(sid);
//			SendSmsWrapper sendSms = (SendSmsWrapper) BeanFactoryA.getBean("sendSmsWrapper");
//			sendSms.send(assign, "您好！经分系统有如下申告《" + title + "》已经得到回复，请到经分系统申告模块查看回复结果。");
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
		return "2";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "upload", method = RequestMethod.POST)
	public @ResponseBody
	String upload(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute(SessionKeyConstants.USER) User user) throws Exception {
		String textcomminute = ""; // 文本分隔符
		// 临时文件夹路径
		String path = System.getProperty("user.dir") + "/";
		String txtType = "utf-8"; // 文本读取,导出格式
		File file = new File(path); // 实例化文件夹
		if (file.exists()) {
			LOG.info("该文件目录已经存在不需要创建！！");
		} else {
			// 创建文件夹
			file.mkdirs();
		}
		request.setCharacterEncoding(txtType); // 设置request返回格式为utf-8
		RequestContext requestContext = new ServletRequestContext(request);

		if (FileUpload.isMultipartContent(requestContext)) {

			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(new File(path));
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setHeaderEncoding(txtType); // 设置传递文本数据格式为utf-8
			upload.setSizeMax(2000000);
			List items = new ArrayList();
			try {
				items = upload.parseRequest(request);
			} catch (FileUploadException e1) {
				LOG.info("文件上传发生错误" + e1.getMessage());
			}
			Iterator it = items.iterator();
			while (it.hasNext()) {
				FileItem fileItem = (FileItem) it.next();
				boolean flag = false;
				if(fileItem.getName().endsWith(".doc")){
					flag = true;
				} else if(fileItem.getName().endsWith(".docx")){
					flag = true;
				} else if(fileItem.getName().endsWith(".xls")){
					flag = true;
				} else if(fileItem.getName().endsWith(".xlsx")){
					flag = true;
				} else if(fileItem.getName().endsWith(".ppt")){
					flag = true;
				} else if(fileItem.getName().endsWith(".ppts")){
					flag = true;
				} else if(fileItem.getName().endsWith(".txt")){
					flag = true;
				} else if(fileItem.getName().endsWith(".png")){
					flag = true;
				} else if(fileItem.getName().endsWith(".bmp")){
					flag = true;
				} else if(fileItem.getName().endsWith(".jpg")){
					flag = true;
				} else if(fileItem.getName().endsWith(".jpeg")){
					flag = true;
				} else if(fileItem.getName().endsWith(".gif")){
					flag = true;
				}
				if(flag){
					String fileName = "";
					String uploadFileName = "";
					// 循环获取表单提交所有字段文本
					if ("textcomminute".equals(fileItem.getFieldName())) {
						
						// 如果文本分隔符id:textcomminute等于当前循环的文本id
						textcomminute = new String(fileItem.getString().getBytes(
								"iso8859-1"), "utf-8"); // 获取文本value
						LOG.info("文本分隔符:" + textcomminute + ";长度:"
								+ textcomminute.length());
						// 获取表单"文本分隔符"字段
					}
					if (fileItem.isFormField()) {
						LOG.info(fileItem.getFieldName()
								+ "   "
								+ fileItem.getName()
								+ "   "
								+ new String(fileItem.getString().getBytes(
										"iso8859-1"), "utf-8"));
						
					} else {
						LOG.info(fileItem.getFieldName() + "   "
								+ fileItem.getName() + "   "
								+ fileItem.isInMemory() + "    "
								+ fileItem.getContentType() + "   "
								+ fileItem.getSize());
						if (fileItem.getName() != null && fileItem.getSize() != 0) {
							fileName = fileItem.getName();
							fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
							uploadFileName = System.currentTimeMillis() + "_" + fileName; // 获取文件名
							uploadFileName = uploadFileName.replace(" ", "");
							try {
								// 在服务器端写入文件流,创建文件
								fileItem.write(new File(path + uploadFileName));
							} catch (Exception e) {
								e.printStackTrace();
								LOG.info(e.getMessage().toString());
							}
						} else {
							LOG.info("文件没有选择 或 文件内容为空");
						}
					}
					
//					FtpHelper ftp = new FtpHelper("file:file@10.25.124.115:21");
					FtpHelper ftp = new FtpHelper("jfftp:1Qaz#edc@10.25.125.87:21");
					try {
						ftp.connect();
						String filePath = "issue/";
						LOG.info("filePath=" + filePath);
						File tempFile = new File(uploadFileName);
						ftp.upload(filePath + uploadFileName , tempFile);
						tempFile.delete();
						response.getWriter().print("{\"success\":true,\"message\":'上传成功',\"newFileName\":'" + uploadFileName + "'}");
					} catch (Exception e) {
						e.printStackTrace();
						LOG.info(e.getMessage().toString());
						response.getWriter().print("{\"success\":false,\"message\":'上传失败'}");
					} finally {
						try {
							ftp.disconnect();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					LOG.info("上传FTP成功");
				}else{
					response.getWriter().print("{\"success\":false,\"message\":'上传失败,此类文件不允许上传'}");
				}
				
			}
		}
		return null;
	}
	
}
