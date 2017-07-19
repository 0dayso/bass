package com.asiainfo.hb.web.util;

import javax.servlet.http.HttpServletRequest;

import com.asiainfo.hb.core.models.Configuration;

public class WebUtil {
	public static String getRemoteAddr(HttpServletRequest request){
		String ip=request.getHeader("X-Forwarded-For");
		if(ip==null){
			ip=request.getRemoteAddr();
		}
		return ip;
	}
	
	private static String FILE_SERVER_ADDR="";
	
	public static String getFileServerAddr(){
		
		if(FILE_SERVER_ADDR.length()==0){
			String fileServerAddr = Configuration.getInstance().getProperty("com.asiainfo.pst.fileServerAddr");
			if(fileServerAddr==null || fileServerAddr.length()==0){
				fileServerAddr="localhost";
			}
			FILE_SERVER_ADDR = "http://"+fileServerAddr+"/";
		}
		return FILE_SERVER_ADDR;
	}
}
