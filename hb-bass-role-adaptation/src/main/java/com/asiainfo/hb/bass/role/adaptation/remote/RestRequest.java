package com.asiainfo.hb.bass.role.adaptation.remote;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.asiainfo.hb.core.models.Configuration;

public class RestRequest {
	
	public static <T> T getObjectFromRest(String request_url,Map<String,Object> params,Class<T> t){
		String urlBase = Configuration.getInstance().getProperty("com.asiainfo.pst.call.data.server.rest.baseurl");
		String url = urlBase+request_url;
		if(params != null && params.size()>0){
			url += "?";
			Iterator<Entry<String,Object>> entryIt = params.entrySet().iterator();
			while(entryIt.hasNext()){
				Entry<String,Object> entry =(Entry<String,Object>)entryIt.next();
				String param_Name = String.valueOf(entry.getKey());
				String param_value = String.valueOf(entry.getValue());
				url += param_Name+"="+param_value;
				if(entryIt.hasNext()){
					url += "&";
				}
			}
		}
		ResponseEntity<T> obj = (ResponseEntity<T>) new RestTemplate().getForEntity(url, t);
		return obj.getBody();
	}

}
