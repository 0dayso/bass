package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface CheckErrorUrlInfoService {

	/**
	 * 带参数查询定时访问错误的url信息
	 * @param params
	 * @param perPage
	 * @param currentPage
	 * @return
	 */
	public Map<String, Object> getErrorUrlInfo(String menuItemTitle,String startDate,String endDate, int pageSize, int pageNum);
	
	/**
	 * 删除不需要的错误信息
	 * @param menuItemId
	 */
	public void deleteInfo(String errorPageId);
}
