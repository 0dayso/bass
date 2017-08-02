package com.asiainfo.hb.ftp.controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.util.IdGen;
import com.asiainfo.hb.ftp.models.Audit;
import com.asiainfo.hb.ftp.models.AuditDao;
import com.asiainfo.hb.ftp.models.FileMgrDao;
import com.asiainfo.hb.ftp.util.FTPHelper;
import com.asiainfo.hb.ftp.util.FtpUtil;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 文件服务控制类
 * 
 * @author 李志坚
 * @since 2017-06-06
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping("/FileMgr")
public class FileMgrController {

	private static Logger log = Logger.getLogger(FileMgrController.class);

	@Autowired
	private FileMgrDao fileMgrDao;
	@Autowired
	private AuditDao auditDao;
	
	@RequestMapping("/index")
	public String index(){
		return "ftl/fileMgr";
	}
	
	@RequestMapping(value="/getCurrentUser")
	@ResponseBody
	public Map<String, Object> getCurrentUser(HttpSession session){
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user", user);
		return map;
	}

	@RequestMapping(value = "/detail", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> detail(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		String fileId=request.getParameter("fileId");
		Map<String,Object> result =new HashMap<String,Object>();
		Map<String,Object> detail =fileMgrDao.queryDetail(fileId);
		List<Map<String,Object>> logList =fileMgrDao.queryLog(fileId);
		result.put("detail", detail);
		result.put("logList", logList);
		result.put("urlBegin", "http://" + request.getLocalAddr() + ":" + request.getLocalPort() + session.getAttribute("mvcPath"));
		return result;
	}

	/**
	 * 从ftp服务器上面下载文件
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	@ResponseBody
	public String download(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) throws ServletException, IOException {
		String fileName = request.getParameter("fileName");
		String fileId = request.getParameter("fileId");
		
		String remotePath = "safetyFile";
		response.reset();
		response.setContentType("application/octet-stream; charset=UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "utf-8"));
		FTPHelper ftp = new FTPHelper();
		if (remotePath != null)
			ftp.setRemotePath(remotePath);
		OutputStream out = null;
		try {
			ftp.connect();
			out = response.getOutputStream();
			ftp.down(out, fileName);
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			if (out != null)
				out.close();
			ftp.disconnect();
		}
		try {
			User user =  (User) session.getAttribute(SessionKeyConstants.USER);
			fileMgrDao.insertLog(fileId, user.getId(), user.getName(), "下载");
		} catch (Exception e) {
		}
		return "";
	}

	@RequestMapping(value = "/toExamine", method = RequestMethod.GET)
	public String toExamine(Audit te,ModelMap map) {
		Map<String,Object> resuMap=new HashMap<String,Object>();
		resuMap=auditDao.select(te.getFile_id());
		if(resuMap==null){
			map.put("msg", 0);
			return "ftl/audit";
		}else{
			map.put("msg", 1);
			for(String key :resuMap.keySet() ){
				map.put(key,resuMap.get(key) );
			}
		}
		return "ftl/audit";
	}

	@RequestMapping(value = "/fileAudit", method = RequestMethod.GET)
	@ResponseBody
	public boolean fileAudit(Audit audit, HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		
		String approver = (String) session.getAttribute("loginname");
		User user =  (User) session.getAttribute(SessionKeyConstants.USER);
		audit.setApprover(user.getId());
		if (auditDao.update(audit)) {
			fileMgrDao.insertLog(audit.getFile_id(), user.getId(), user.getName(), "审核");
			return true;
		}
		return false;
	}

	@RequestMapping(value = "/fileSearch")
	@ResponseBody
	public Map<String, Object> fileSearch(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		String filename = request.getParameter("filename");
		String reqid = request.getParameter("reqid");
		String creator=request.getParameter("creator");
		String status=request.getParameter("status");
		String pageSize = request.getParameter("page");// 页码
		String rows = request.getParameter("rows");// 每页显示条数
		if (filename == null || filename.trim().length() == 0) {
			filename = "";
		}
		if (reqid == null || reqid.trim().length() == 0) {
			reqid = "";
		}
		if (creator == null || creator.trim().length() == 0) {
			creator = "";
		}
		if (status == null || status.trim().length() == 0) {
			status = "";
		}
		
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		return fileMgrDao.queryAllfile(filename, reqid,creator,status, user.getId(), pageSize, rows);

	}

	@RequestMapping(value = "/fileDel")
	@ResponseBody
	public void fileDel(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		String fileids = request.getParameter("fileids");
		List<Map<String, Object>> list = fileMgrDao.queryFilepathByIds(fileids);
		
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		FtpUtil ftpUtil = new FtpUtil();
		StringBuffer succIds = new StringBuffer();
		Map<String, Object> resMap = new HashMap<String, Object>();
		try {
			ftpUtil.connect();
			for(Map<String, Object> map : list){
				try {
					ftpUtil.delete((String) map.get("file_path"));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			fileMgrDao.delFiles(fileids, user.getId(), user.getName());
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try {
				ftpUtil.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/fileAdd")
	@ResponseBody
	public String fileAdd(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		String fileid = IdGen.genId();
		String filecode = request.getParameter("filecode");
		String filename = request.getParameter("filename");
		String filedesc = request.getParameter("filedesc");
		String approver = request.getParameter("approver");
		String approverName = request.getParameter("approverName");
		String reqid = request.getParameter("reqid");
		String filepath =request.getParameter("filepath");
		Timestamp operTime = new Timestamp(System.currentTimeMillis());
		String logId=String.valueOf(new Date().getTime())+"_log";
		fileMgrDao.insertLog(fileid, user.getId(), user.getName(), "新增");
		fileMgrDao.insertUploadFile(fileid,filename,filedesc,filecode,reqid,filepath,user.getId(), user.getName(),approver, approverName);
		return "success";
	}
	
	@RequestMapping(value = "/getAuditor")
	@ResponseBody
	public Map<String, Object> getAuditorByReqCode(HttpServletRequest req){
		String reqCode = req.getParameter("reqCode");
		return fileMgrDao.getAuditorByReqCode(reqCode);
	}
}
