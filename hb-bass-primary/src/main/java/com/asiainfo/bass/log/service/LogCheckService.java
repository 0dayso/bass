package com.asiainfo.bass.log.service;


import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.asiainfo.bass.log.dao.LogCheckDao;
import com.asiainfo.bass.log.dao.UtilDao;
import com.asiainfo.bass.log.model.LogCheckModel;

@Service
public class LogCheckService {
	@Autowired
	LogCheckDao logCheckDao;
	@Autowired
	UtilDao utilDao;
	public Logger logger = LoggerFactory.getLogger(LogCheckService.class);
	public List<Map<String,Object>> selectCity(){
		return utilDao.selectCity();
	}
	public Map<String,Object> selectLogCheck(LogCheckModel logCheckModel){
		String totalRows="select distinct a.id,a.USER_ID loginname, b.username,c.cityname,c.cityid,CLIENT_IP ipaddress, date(LOCKED_TIME) visitdate,LOCKED_TIME visitdate2,time(LOCKED_TIME) visittime, CHECKDATE, CHECKMAN, CHECKED ,check_detail  from USER_LOCKED a,FPF_USER_USER b,FPF_user_city c   where a.user_Id=b.userId and b.cityid=c.cityid ";
		if(utilDao.isNull(logCheckModel.getCheckedtype())){
			
			if(logCheckModel.getCheckedtype().equals("3")){
				 // 密码试用5次后被锁定查询
				return logCheckDao.conditionLogCheck(logCheckModel,totalRows);
			}else if(logCheckModel.getCheckedtype().equals("2")){
				 // 同一用户IP超过5次登录查询
				 totalRows="select a.id, a.USERID loginname, b.username,c.cityname,c.cityid, a.CLIENTADDRESS ipaddress,date(a.LOGINTIME) visitdate,time(a.LOGINTIME) visittime,a.LOGINTIME visitdate2, CHECKDATE, CHECKMAN, CHECKED,check_detail   from FPF_USER_LOGIN_HISTORY a,FPF_USER_USER b,FPF_user_city c   where  a.userId=b.userId and b.cityid=c.cityid and a.userid in (select USERID   from FPF_USER_LOGIN_HISTORY where  (date(LOGINTIME) +6 day)>=date('"+logCheckModel.getQuerydate()+"') and (date(LOGINTIME))<=date('"+logCheckModel.getQuerydate()+"')  group by userid   having(count(distinct cLIENTADDRESS)>=5)) ";
				
				 return logCheckDao.conditionLogCheck(logCheckModel,totalRows);
			}else{
				// 时段异常登录查询
				 totalRows="select a.id, a.USERID loginname, b.username,c.cityname,c.cityid, a.CLIENTADDRESS ipaddress,date(a.LOGINTIME) "
						+ "visitdate,time(a.LOGINTIME) visittime,a.LOGINTIME visitdate2, CHECKDATE, CHECKMAN, CHECKED,check_detail  "
						+ "from FPF_USER_LOGIN_HISTORY a,FPF_USER_USER b,FPF_user_city c   where  a.userId=b.userId and b.cityid=c.cityid and (time(a.LOGINTIME)>'23:00:00' or time(a.LOGINTIME)<'06:00:00')";
				return logCheckDao.conditionLogCheck(logCheckModel,totalRows);
			}
		}else{
			return logCheckDao.conditionLogCheck(logCheckModel,totalRows);
		}
		
	}
}
