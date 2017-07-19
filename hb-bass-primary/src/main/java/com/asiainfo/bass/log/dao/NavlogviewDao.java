package com.asiainfo.bass.log.dao;


import java.util.HashMap;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


import com.asiainfo.bass.log.model.NavlogviewModel;


@SuppressWarnings("unused")
@Repository
public class NavlogviewDao {
	@Autowired
	UtilDao utilDao;
	public Map<String,Object> selectNavlogview(NavlogviewModel navlogviewModel){
		Map<String,Object> map=new HashMap<String, Object>();
		String totalRows="select LOGINNAME, char(date(LOGTIME))||' '||char(time(LOGTIME)) LOGTIME, NAVNAME ,b.username,c.cityname  from"
				+ " FPF_BROWSER_LOG a,FPF_USER_USER b,FPF_user_city c where a.loginname=b.userid and b.cityid=c.cityid";
		String totalPage="select count(*) from FPF_BROWSER_LOG a,FPF_USER_USER b,FPF_user_city c where a.loginname=b.userid and b.cityid=c.cityid ";
		if(utilDao.isNull(navlogviewModel.getDate())){
			String str=navlogviewModel.getDate();
			String[] strArray = null;   
	        strArray = str.split("-");
	        for(int i=0;i<strArray.length;i++){
	        	if(i==0){
	        		map.put("year(logtime)", strArray[0]);
	        	}
	        	if(i==1){
	        		map.put("month(logtime) ", strArray[1]);
	        	}   
	        }
		}
		if(utilDao.isNull(navlogviewModel.getCityid())){
			map.put("b.cityid", navlogviewModel.getCityid().trim());
		}
		return utilDao.where(map,totalRows, totalPage, navlogviewModel.getRows(), navlogviewModel.getPage(), navlogviewModel.getSort());
		
	}
}
