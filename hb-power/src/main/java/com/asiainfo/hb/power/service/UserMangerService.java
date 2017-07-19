package com.asiainfo.hb.power.service;



import java.util.Date;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.UserManageDao;


@Service
public class UserMangerService {
	
	@Autowired
	UserManageDao dao;
	
	
	
	 public void delete(String userId){
		  dao.delete(userId);
	 }
	 
	 //批量删除
	 public void batchDeletes(String userids){
		 dao.batchDeletes(userids);
	 }
	 
	 
	 @SuppressWarnings("rawtypes")
	public Map findById(String id){
		 Map map = dao.findById(id);
		 if (map == null) return null;
		return map;
		 
	 }
	 
	 public void update(String userid,String username,String cityid,Integer status,String mobilephone,String email){
		 dao.update(userid,username,cityid,status,mobilephone,email);
	 }
	 
	 public List<Map<String,Object>> findAllUserId(){
		 List<Map<String,Object>> list = dao.findAllUserId();
		 return list;
	 }
	 
	 public void add(String userid,String cityid,String username,String pwd,Integer status,String mobilephone,String email,Date createtime,String visitArea){
		 dao.add(userid,cityid,username,pwd,status,mobilephone,email,createtime,visitArea);
	 }
	 
	 public List<Map<String,Object>> getUsers(String userid,String username,String cityid,int indexNum,int pageSize){
		 return dao.getUsers(userid, username, cityid, indexNum, pageSize);
	 }
	
	 public int getUserCount(String userid,String username,String cityid){
		return dao.getUserCount(userid, username, cityid);
	 }
	 
	 public List<Map<String,Object>> getvisitAreaList(){
		return dao.getvisitAreaList();
	}
	 
	 public boolean updateVisitArea(String visitAREA, String uID){
		 return dao.updateVisitArea(visitAREA, uID);
	 }
	 
	 public Map<String, Object> getAreaNameByAid(String areaId){
		 return dao.getAreaNameByAid(areaId);
	}
	 
	 public List<Map<String,Object>> getUserByUid(String userid){
		 return dao.getUserByUid(userid);
	}
	
	 
	
}
