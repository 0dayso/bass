package com.asiainfo.hb.ftp.models;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.util.DateUtil;

@Repository
public class FileMgrDao extends CommonDao {

	public Logger logger = LoggerFactory.getLogger(FileMgrDao.class);

	public Map<String, Object> queryAllfile(String filename, String reqid, String creator,String status,String userId,String page, String rows) {
		logger.debug("queryAllfile-------------------------------->");
		String totalRows = "select * from FPF_FILE f where 1=1";
		String totalPage = "select count(*) from fpf_file where 1=1";
		String condition = "";
		if(status.equals("待审核")){
			condition = " and status='" + status + "' and approver_id='" + userId + "' ";
		}else if(!StringUtils.isEmpty(status)){
			condition = " and status='" + status + "' ";
		}
		
		if(!userId.equals("admin")){
			condition += " and (creator_id ='" + userId + "' or approver_id='" + userId + "')";
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(" file_name like ", filename);
		map.put(" req_id like ", reqid);
		map.put(" creator like ", creator);
		return where(map, totalRows + condition, totalPage + condition, Integer.parseInt(rows), Integer.parseInt(page), " create_time desc");
	}

	public boolean delFiles(String fileids, String userId, String userName) {
		boolean flag = true;
		try {
			String sql = "delete from fpf_file where file_id in (%)";
			jdbcTemplate.update(sql.replace("%", fileids));
			
			String[] fileIdArr = fileids.split(",");
			for(String fileId : fileIdArr){
				this.insertLog(fileId, userId, userName, "删除");
			}
		} catch (DataAccessException e) {
			flag = false;
			e.printStackTrace();
		}
		return flag;
	}
	
	public List<Map<String, Object>> queryFilepathByIds(String ids){
		String sql = "select file_id,file_path from st.fpf_file where file_id in (" + ids +")";
		return this.jdbcTemplate.queryForList(sql);
	}

	public Map<String, Object> queryDetail(String fileId) {
		logger.debug("queryDetail-------------------------------->");
		Map<String, Object> map = null;
		String sql = "select * from FPF_FILE f WHERE f.FILE_ID=?";
		map = jdbcTemplate.queryForMap(sql, fileId);
		return map;
	}

	public void insertLog(String fileId, String userId, String userName, String operType) {
		logger.debug("insertLog-------------------------------->");
		Object[] objs = new Object[6];
		String sql = "insert into FPF_FILE_LOG (id,file_id,user_id , user_name, oper_type,oper_time) values(?,?,?,?,?,?)";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmSSS");
		String str = sdf.format(new Date());
		String logId = str + "_log";
		
		Timestamp operTime = new Timestamp(System.currentTimeMillis());
		objs[0] = logId;
		objs[1] = fileId;
		objs[2] = userId;
		objs[3] = userName;
		objs[4] = operType;
		objs[5] = operTime;
		try {
			jdbcTemplate.update(sql, objs);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}

	}

	public List<Map<String, Object>> queryLog(String fileId) {
		logger.debug("queryLogList-------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String sql = "select * from FPF_FILE_LOG l where l.FILE_ID=?";
		list = jdbcTemplate.queryForList(sql, fileId);
		return list;
	}
	
	public void insertUploadFile(String fileid, String filename, String filedesc, String filecode,String reqid,String path,
			String creator,String userName,String approver, String approverName) {
		logger.debug("insertupload-------------------------------->");
		Object[] objs = new Object[12];
		String sql = "insert into fpf_file (file_id,file_name,file_code,file_desc,status,file_path,CREATOR_ID,creator,create_time,APPROVER_ID,approver,req_id) values(?,?,?,?,?,?,?,?,?,?,?,?)";
		DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");

		objs[0] = fileid;
		objs[1] = filename;
		objs[2] = filecode;
		objs[3] = filedesc;
		objs[4] = "待审核 ";
		objs[5] = "/home/jfftp/safetyFile/"+filename;
		objs[6] = creator;
		objs[7] = userName;
		objs[8] = DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");
		objs[9] =  approver;
		objs[10] =  approverName;
		objs[11] = reqid;
		try {
			jdbcTemplate.update(sql, objs);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	public Map<String, Object> getAuditorByReqCode(String reqCode){
		logger.debug("getAuditorByReqCode----reqCode:" + reqCode);
		String sql = "select * from fpf_req where req_code='" + reqCode + "'";
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		if(list != null && list.size()>0){
			return list.get(0);
		}
		return new HashMap<String, Object>();
	}

}
