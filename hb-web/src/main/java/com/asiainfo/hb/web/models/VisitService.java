package com.asiainfo.hb.web.models;

import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface VisitService {

	public void saveLog(Visit log, long beginTime);
	
	public Map<String,String> getMenuTrace(String mid);
	
}
