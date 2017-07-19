/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;

/**
 * @author zhangds
 * @date 2015年11月13日
 * @category 目录服务
 */
@Service
public interface AdapMenuService {

	/**
	 * 获取当前menuId的所有结构数据
	 */
	public AdapMenu getOneMenus(String menuId);
	/**
	 * 
	 * 获取获取报表中心左侧菜单数据
	 */
	public List<Map<String,Object>>  getRepCenter(String name);
	
	/**
	 * 获取获取报表中心标题数据数据
	 * 
	 */
	public  String  getTitle(int menuId);
	/**
	 * 获取当前menuId及下一级的结构
	 */
	public AdapMenu getCurrentMenu(String menuId);
	
	/**
	 * 根据指定的AdapMenu获取kpi数据
	 */
	//public AdapMenu getAdapMenuAndKpiDate(AdapMenu menu,String regionId,String date,String viewType,String timeType);
	public AdapMenu getAdapMenuAndKpiDate(AdapMenu menu,String timeType,String time,String dimType,String dimValue);
}
