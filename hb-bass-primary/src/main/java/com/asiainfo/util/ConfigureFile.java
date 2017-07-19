/**
 * <p>Title: 读取配置文件</p>
 * <p>Date: Feb 19, 2008 3:02:49 PM </p>
 * @author 李志坚
 * @version 1.0
 * @Description :读取配置文件。
 */
package com.asiainfo.util;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.io.Resource;


public class ConfigureFile {

	private static Properties properties = new Properties();
	private Resource config;
	private static final String defaultEncoding = "UTF-8";
	private String encode;
	private static ConfigureFile configurefile = new ConfigureFile();
	private static final Log log = LogFactory.getLog(ConfigureFile.class);
	private Resource dataBusiConfig;
	
	public static ConfigureFile getInstance()
	{
		if(configurefile!=null)
			return configurefile;
		else
		{
			ConfigureFile configFile = new ConfigureFile();
			configFile.init();
			return configFile;
		}
	}
	
	public void init(InputStream input)
	{
		try
		{
			if(input!=null)
			{
				properties.load(input);
			}
		}catch(Exception e)
		{
			e.printStackTrace();
			log.debug("Exception throwed by the init method",e);
		}
	}
	
	public void init()
	{
		try
		{
			InputStream input = config.getInputStream();
			init(input);
			if(dataBusiConfig.getInputStream() != null){
				//added by LiZhijian 加载数深迁移功能配置
				init(dataBusiConfig.getInputStream());
			}
		}catch(Exception e)
		{
			e.printStackTrace();
			log.debug("Exception throwed by the init method",e);
		}
	}
	
	public String getProperty(String key)
	{	
		String msg = properties.getProperty(key);
		if (null == msg || msg.length() < 1) {
			return "";
		}
		try {
			if(this.encode != null&&this.encode.length()>0)
			{
				return new String(msg.getBytes("ISO8859-1"), encode);
			}
			return new String(msg.getBytes("ISO8859-1"), defaultEncoding);
		} catch (UnsupportedEncodingException ex) {
			return null;
		}
		//return null;
	}

	public Resource getConfig() {
		return config;
	}

	public void setConfig(Resource config) {
		this.config = config;
	}

	public String getEncode() {
		return encode;
	}

	public void setEncode(String encode) {
		this.encode = encode;
	}

	public Resource getDataBusiConfig() {
		return dataBusiConfig;
	}

	public void setDataBusiConfig(Resource dataBusiConfig) {
		this.dataBusiConfig = dataBusiConfig;
	}
}
