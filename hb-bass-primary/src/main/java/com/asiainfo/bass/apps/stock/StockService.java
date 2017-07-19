package com.asiainfo.bass.apps.stock;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StockService {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(StockService.class);
	
	@Autowired
	private StockDao stockDao;
	
	public int getCountByRegionName(String region_name){
		return stockDao.getCountByRegionName(region_name);
	}
	
	public int getCountForPersonManager(String manager_name,String manager_accnbr){
		return stockDao.getCountForPersonManager(manager_name,manager_accnbr);
	}
	
	public void saveCounty(String region_name){
		stockDao.saveCounty(region_name);
	}
	
	public void savePersonManager(String region_name, String manager_name, String manager_accnbr, String manager_type, String region_level){
		stockDao.savePersonManager(region_name, manager_name, manager_accnbr, manager_type, region_level);
	}
	
	public void saveMarketing(String region_name, String parent_region_name){
		stockDao.saveMarketing(region_name, parent_region_name);
	}
	
	public void deleteCounty(String region_name){
		stockDao.deleteCounty(region_name);
	}
	
	public void deletePersonManager(String region_name, String manager_name){
		stockDao.deletePersonManager(region_name, manager_name);
	}
}
