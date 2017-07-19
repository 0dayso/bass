package com.asiainfo.hb.web.models;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CheckUrlService {

	@Autowired
	CheckUrlDao checkUrlDao;
	
	/**
	 * 查询URL菜单中所有不为空的URL
	 */
	public List<String> getAllUrl(){
		return checkUrlDao.getAllUrl();
	}
}
