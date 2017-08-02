
package com.asiainfo.hb.web.controllers;

import java.io.IOException;
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
	@ResponseBody
	public String exportToCsv(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
		String sqlStr=request.getParameter("sqlStr");
		String fileName=sqlDao.generateFilename();
		String filePath="E:/"+fileName;
		LOG.debug("-------ExportFile---------");
		try {
			sqlDao.genCsvFile(sqlStr, filePath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "SUCCESS" ;
	}
	
}
