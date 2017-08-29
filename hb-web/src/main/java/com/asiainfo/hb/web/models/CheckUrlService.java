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
	
	/**
	 * 查询URL菜单中所有不为空的URL对象
	 */
	public List<ErrorPageInfoVO> getUrlVO(){
		return checkUrlDao.getUrlVO();
	}
	
	/**
	 * 新增访问错误的url记录
	 */
	public int[] insertErrorUrl(List<ErrorPageInfoVO> checkUrl){
		return checkUrlDao.insertErrorUrl(checkUrl);
	}
}
