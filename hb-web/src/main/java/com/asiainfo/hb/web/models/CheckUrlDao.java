package com.asiainfo.hb.web.models;

import java.util.List;

public interface CheckUrlDao{

	/**
	 * 查询URL菜单中所有不为空的URL
	 */
	public List<String> getAllUrl();
}
