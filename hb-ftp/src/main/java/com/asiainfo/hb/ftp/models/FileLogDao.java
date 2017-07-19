package com.asiainfo.hb.ftp.models;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

@Repository
public class FileLogDao extends CommonDao{

	public Logger logger = LoggerFactory.getLogger(FileLogDao.class);
	
	public Map<String, Object> getFileLog(String userId,String fileName, String userName, String operType, String startTime, String endTime, String page, String rows){
		logger.debug("getFileLog-------------------------------->");
		String totalRows = "select l.file_id, file_name, user_name, oper_type, to_char(oper_time,'YYYY-MM-DD HH24:MI:SS') oper_time from fpf_file_log l " +
				" left join fpf_file f on f.file_id=l.file_id where 1=1 ";
		String totalPage = "select count(*) from fpf_file_log l left join fpf_file f on f.file_id=l.file_id where 1=1 ";
		String condition = "";
		
		if(!StringUtils.isEmpty(startTime) || !StringUtils.isEmpty(endTime)){
			if(!StringUtils.isEmpty(startTime)){
				condition += " and date(oper_time) >='" + startTime + "' ";
			}
			if(!StringUtils.isEmpty(endTime)){
				condition += " and date(oper_time) <='" + endTime + "' ";
			}
		}
		
		if(!userId.equals("admin")){
			condition += " and user_id = '" + userId + "' ";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_name like", userName);
		params.put("oper_type", operType);
		params.put("file_name like ", fileName);
		String orderStr = " oper_type, oper_time desc";
		return where(params, totalRows + condition, totalPage + condition, Integer.parseInt(rows), Integer.parseInt(page), orderStr);
	}
	
}
