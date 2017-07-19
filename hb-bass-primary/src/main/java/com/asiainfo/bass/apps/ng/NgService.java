package com.asiainfo.bass.apps.ng;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NgService {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(NgService.class);
	
	@Autowired
	private NgDao ngDao;
	
	public void save(double ind1,double ind2,double ind3,double ind4,double ind5,double ind6,double ind7,double ind8,double ind9,double ind10){
		List<Map<String,Object>> list = ngDao.getInd();
		if(list!=null && list.size()>0){
			ngDao.update(ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9, ind10);
		}else{
			ngDao.insert(ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9, ind10);
		}
	}

}
