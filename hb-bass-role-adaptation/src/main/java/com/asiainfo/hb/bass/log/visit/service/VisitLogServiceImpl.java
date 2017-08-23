package com.asiainfo.hb.bass.log.visit.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.log.visit.dao.VisitLogDao;

@Service
public class VisitLogServiceImpl implements VisitLogService {

	
	@Autowired
	private VisitLogDao visitLogDao;
	@Override
	public Map<String, Object> getPageList(Integer page, Integer rows, Map<String, Object> params) {
		return visitLogDao.getPageList(page, rows, params);
	}

	@Override
	public List<Map<String, Object>> getCityList() {
		return visitLogDao.getCityList();
	}

}
