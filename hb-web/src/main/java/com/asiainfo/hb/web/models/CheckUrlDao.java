package com.asiainfo.hb.web.models;

import java.util.List;

public interface CheckUrlDao{

	/**
	 * 查询URL菜单中所有不为空并且启用的URL
	 */
	public List<String> getAllUrl();
	
	/**
	 * 查询URL菜单中所有不为空的URL对象
	 */
	public List<ErrorPageInfoVO> getUrlVO();
	
	/**
	 * 新增访问错误的url记录
	 */
	public int[] insertErrorUrl(List<ErrorPageInfoVO> checkUrl);
}
