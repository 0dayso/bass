package com.asiainfo.hb.ftp.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@SuppressWarnings("unused")
@Repository
public class AuditDao {
	@Autowired
	CommonDao commonDao;

	public Map<String, Object> select(String id) {
		Map<String, Object> map1 = new HashMap<String, Object>();
		String sql = "select * from  ST.FPF_FILE where 1=1";
		map1 = new HashMap<String, Object>();
		AuditDao td = new AuditDao();
		if (commonDao.isNull(id)) {
			map1.put("file_id ", id);
		}
		Map<String, Object> map=new HashMap<String, Object>();
		for (Map<String, Object> m : commonDao.select(map1, sql)) {
			map=m;
			String status = m.get("status").toString();
			if (status.equals("审核通过")) {
				return null;
			}
		}
		
		return map;
	}

	public boolean update(Audit te) {
		return commonDao.update(te.getStatus(), new Date(), te.getApprove_opinion(), te.getFile_id());
	}

}