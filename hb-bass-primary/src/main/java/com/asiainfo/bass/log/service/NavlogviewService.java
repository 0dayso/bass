package com.asiainfo.bass.log.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.asiainfo.bass.log.dao.NavlogviewDao;
import com.asiainfo.bass.log.dao.UtilDao;
import com.asiainfo.bass.log.model.NavlogviewModel;

@Service
public class NavlogviewService {
	@Autowired
	NavlogviewDao dao;
	@Autowired
	UtilDao utilDao;
	 public Map<String,Object> selectnavlogview(NavlogviewModel navlogviewModel){
		 return dao.selectNavlogview(navlogviewModel);
	 }
	public List<Map<String,Object>> selectCity(){
		return utilDao.selectCity();
	}
}
