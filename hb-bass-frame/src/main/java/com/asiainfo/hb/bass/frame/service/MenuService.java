/**
 * 
 */
package com.asiainfo.hb.bass.frame.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.frame.models.MenuBean;
import com.asiainfo.hb.bass.frame.models.MenuDao;
import com.asiainfo.hb.bass.frame.models.NoticeBean;

/**
 * @author zhangds
 * @date 2015年7月23日
 */
@Service
public class MenuService {
	
	@Autowired
	MenuDao menuDao;
	
	public List<MenuBean> getSysAllMenu(String userid){
		return menuDao.getSysMenu(userid);
	}
	
	public List<NoticeBean> getCurrentMonthNotices(String yyyyMM){
		return menuDao.getCurrentMonthNotices(yyyyMM);
	}
}
