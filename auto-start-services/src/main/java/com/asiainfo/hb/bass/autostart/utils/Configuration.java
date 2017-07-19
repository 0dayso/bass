package com.asiainfo.hb.bass.autostart.utils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;

/**
 *	读取配置文件
 *	@author xiaoh
 */
public class Configuration {

	private static Configuration conf = new Configuration();
	private Properties prop = null;
	
	private Configuration(){
		prop = new Properties();
		InputStream inStream = Configuration.class.getClassLoader().getResourceAsStream("conf/auto_start.properties");

		try {
			prop.load(new InputStreamReader(inStream,"utf-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static Configuration getInstance(){
		return conf;
	}
	
	public String getProperty(String key){
		return prop.getProperty(key);
	}
	
}
