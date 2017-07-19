package com.asiainfo.bass.log.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.bass.log.model.JournalModel;
@SuppressWarnings("unused")
@Repository
public class JournalDao {
	@Autowired
	UtilDao utilDao;
	public Map<String,Object> selectjournal(JournalModel journalModel){
		String totalRows = "select * from FPF_VISITLIST t where 1=1";
		String totalPage="select count(*) from FPF_VISITLIST where 1=1";
		Map<String,Object> map1=new HashMap<String, Object>();
		if(utilDao.isNull(journalModel.getLoginname())){
			map1.put("loginname like", journalModel.getLoginname().trim());
		}
		if(utilDao.isNull(journalModel.getUri())){
			map1.put("uri like",journalModel.getUri().trim());
		}
		return utilDao.where(map1,totalRows, totalPage, journalModel.getRows(), journalModel.getPage(), journalModel.getSort());
	}
	
}
