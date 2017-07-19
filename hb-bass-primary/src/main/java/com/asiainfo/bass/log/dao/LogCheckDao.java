package com.asiainfo.bass.log.dao;


import java.util.HashMap;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.log.model.LogCheckModel;



@Repository
public class LogCheckDao{
	@Autowired
	UtilDao utilDao;
	String totalRows="";
	String totalPage="";
	public Map<String,Object> conditionLogCheck(LogCheckModel logCheckModel,String totalRows){
		Map<String,Object> map=new HashMap<String, Object>();
		String totalPage="select count(*) from USER_LOCKED a,FPF_USER_USER b, FPF_user_city c   where a.user_Id=b.userId and b.cityid=c.cityid";
		if(utilDao.isNull(logCheckModel.getLoginname())){
			map.put("b.userId like", logCheckModel.getLoginname().trim());
		}
		if(utilDao.isNull(logCheckModel.getChecked())){
			if(!logCheckModel.getChecked().equals("-1")){
				map.put("checked",logCheckModel.getChecked());
			}
		}
		if(utilDao.isNull(logCheckModel.getQuerydate())){
			if(logCheckModel.getCheckedtype().equals("1")){
				totalRows=totalRows+" and (date(a.LOGINTIME) +6 day)>=date( '"+logCheckModel.getQuerydate()+"' )  and (date(a.LOGINTIME))<=date( '"+logCheckModel.getQuerydate()+"' ) ";
				
			}else if(logCheckModel.getCheckedtype().equals("2")){
				totalRows=totalRows+" and (date(a.LOGINTIME) +6 day)>=date( '"+logCheckModel.getQuerydate()+"' )  and (date(a.LOGINTIME))<=date( '"+logCheckModel.getQuerydate()+"' ) ";
			}else{
				totalRows=totalRows+" and (date(LOCKED_TIME) +6 day)>=date( '"+logCheckModel.getQuerydate()+"' )  and (date(LOCKED_TIME))<=date( '"+logCheckModel.getQuerydate()+"' ) ";
			}
			totalPage=totalPage+" and (date(LOCKED_TIME) +6 day)>=date( '"+logCheckModel.getQuerydate()+"' )  and (date(LOCKED_TIME))<=date( '"+logCheckModel.getQuerydate()+"' ) ";
		}
		if(utilDao.isNull(logCheckModel.getCityid())){
			if(!logCheckModel.getCityid().equals("-1")){
				map.put("b.cityid",logCheckModel.getCityid());
			}
		}
		return utilDao.where(map,totalRows, totalPage, logCheckModel.getRows(), logCheckModel.getPage(), logCheckModel.getSort());
	}
}
