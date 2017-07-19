package com.asiainfo.bass.apps.log;

import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LogActionService {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(LogActionService.class);
	
	@Autowired
	private LogActionDao logActionDao;
	
	public int insertLogAction(String userid, String ip, String app_serv, String result, String opertype, String app_code, String app_name){
		String opername = "";
		String opercontent = "";
		if(opertype.equals("3")){
			opername = "帐号管理事件";
			opercontent = "帐号管理事件";
		}else if(opertype.equals("4")){
			opername = "口令管理事件";
			opercontent = "口令管理事件";
		}else if(opertype.equals("5")){
			opername = "权限变更事件";
			opercontent = "权限变更事件";
		}
		return logActionDao.inserLogAction(userid, ip, app_serv, opertype, opername, app_code, app_name, app_code, app_name, opercontent, result);
	}
	
	@SuppressWarnings("rawtypes")
	public String getNextLevel(String userid){
		String users = "";
		List list = logActionDao.getNextLevel(userid);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				String userId = map.get("parentuserid").toString();
				if(i==0){
					users = userId;
				}else{
					users = users + "@" + userId;
				}
			}
		}
		return users;
	}
	
	public void dele(String loginname, String date1, String date2){
		logActionDao.dele(loginname, date1, date2);
	}
}
