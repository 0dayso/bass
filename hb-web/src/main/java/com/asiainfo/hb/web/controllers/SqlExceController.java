
package com.asiainfo.hb.web.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.web.models.SqlDao;

@Controller
@RequestMapping(value="/doSql")
public class SqlExceController {
	private static Logger LOG = Logger.getLogger(SqlExceController.class);

	@Autowired
	private SqlDao sqlDao;
	
	@RequestMapping(value = "/sql")
	public String excute(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		return "ftl/sqlExec/sql";
	}
	
	@RequestMapping(value = "/excute")
	@ResponseBody
	public Map<String,Object> detail(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		LOG.debug("-------excutesql---------");
		Timestamp operTime = new Timestamp(System.currentTimeMillis());
		Map<String,Object> result =new HashMap<String,Object>();
		Map<String, Object> map =new  HashMap<String,Object>();
		String sqlStr=request.getParameter("sqlStr");
		char lastStr = sqlStr.charAt(sqlStr.length() - 1);
		if (sqlStr != null && ';' == lastStr) {
			sqlStr = sqlStr.substring(0, sqlStr.length() - 1);
		}
		String pageSize = request.getParameter("page");// 页码
		String rows = request.getParameter("rows");// 每页显示条数
		if(pageSize==null){
			pageSize="1";
		}
		if(rows==null){
			rows="10";
		}
		String status="";
		 String remark="";
		try{
		if(sqlStr.trim().length() > 7 && sqlStr.trim().substring(0, 6).equalsIgnoreCase("update")){
			LOG.debug("-------excute--update---sql---------");
			sqlDao.excuteSqlOper(sqlStr);
			result.put("oper","更新数据操作");
		}else if(sqlStr.trim().length() > 7 && sqlStr.trim().substring(0, 6).equalsIgnoreCase("delete")){
			LOG.debug("-------excute--delete---sql---------");
			sqlDao.excuteSqlOper(sqlStr);
			result.put("oper","删除数据操作");
		}else if(sqlStr.trim().length() > 7 && sqlStr.trim().substring(0, 6).equalsIgnoreCase("insert")){
			LOG.debug("-------excute--insert---sql---------");
			sqlDao.excuteSqlOper(sqlStr);
			result.put("oper","增加数据操作");
		}else if(sqlStr.trim().length() > 7 && sqlStr.trim().substring(0, 6).equalsIgnoreCase("select")){
			LOG.debug("-------excute--select---sql---------");
			String order=sqlDao.getColumns(sqlStr);
			map=sqlDao.sqlPaging(sqlStr,pageSize, rows,order);
			result.put("select", map);
			result.put("oper","查询操作");
		          }
		    status="成功";
		    remark="MISSION SUCCESS";
		  }catch(Exception e){
                   e.printStackTrace();
                   remark=e.getMessage();
                   result.put("oper","失败操作");
                   status="操作失败";
		  }
		result.put("status", status);
		result.put("remark", remark);
		result.put("user",(String)session.getAttribute("loginname"));
		result.put("time",operTime);
		return result;
	}
	
	
	@RequestMapping(value = "/query")
	@ResponseBody
	public Map<String,Object> query(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		LOG.debug("-------excutePagingQuery---------");
		Map<String, Object> map =new  HashMap<String,Object>();
		String sqlStr=request.getParameter("sqlStr");
		char lastStr = sqlStr.charAt(sqlStr.length() - 1);
		if (sqlStr != null && ';' == lastStr) {
			sqlStr = sqlStr.substring(0, sqlStr.length() - 1);
		}
		String pageSize = request.getParameter("page");// 页码
		String rows = request.getParameter("rows");// 每页显示条数
		if(pageSize==null){
			pageSize="1";
		}
		if(rows==null){
			rows="10";
		}
			String order=sqlDao.getColumns(sqlStr);
			map=sqlDao.sqlPaging(sqlStr,pageSize, rows,order);
		return map;
	}

	@RequestMapping(value = "/export")
	//@ResponseBody
	public void exportToCsv(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		String sqlStr=request.getParameter("sqlStr");
		String fileName = sqlDao.generateFilename();

		String fileDir = request.getSession().getServletContext().getRealPath("download");
		File file = new File(fileDir);
		if (!file.exists()) {
			file.mkdir();
		}

		String filePath = fileDir + "/" + fileName;
		LOG.debug("filePath:" + filePath);
	
		LOG.debug("-------ExportFile---------");
		
		try {
			sqlDao.genCsvFile(sqlStr, filePath);
			file = new File(filePath);
			response.reset();
			response.setContentType("octet-stream; charset=UTF-8");
			response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(file.getName(), "UTF-8"));
			response.setContentLength((int) file.length());
			byte[] buffer = new byte[10240];
			OutputStream out = response.getOutputStream();
			InputStream in = null;
			try {
				in = new FileInputStream(file);
				int r = 0;
				while ((r = in.read(buffer, 0, buffer.length)) != -1) {
					out.write(buffer, 0, r);
				}

				out.flush();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (in != null)
					in.close();
				if (out != null)
					out.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//return "SUCCESS" ;
	}
	
}
