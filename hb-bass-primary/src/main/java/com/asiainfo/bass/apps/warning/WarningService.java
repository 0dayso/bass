package com.asiainfo.bass.apps.warning;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@SuppressWarnings("unused")
@Repository
public class WarningService {
	
	@Autowired
	private WarningDao warningDao;
	
	@SuppressWarnings("rawtypes")
	public void updateWarning(String ds,String type, String userid){
		//得到临时表中的数据
		List list = warningDao.getTempList(ds, type);
		if(list!=null && list.size()>0){
			warningDao.update(list, ds, type, userid);
		}
	}
}
