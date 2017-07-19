package com.asiainfo.hb.core.models;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.Properties;

/**
 *
 * @author Mei Kefu
 * @date 2010-4-19
 */
public class Configuration {

	private static Configuration conf = new Configuration();
	private Properties prop = null;
	
	private static Logger LOG = Logger.getLogger(Configuration.class);
	
	private String propsPattern = "classpath*:conf/pst_*.properties";
	
	private String[] builtinProperties = new String[]{"pst.properties","pst_web.properties","pst_kpi.properties","pst_kpi_data.server.properties","hbapp.properties"};
	
	private Configuration(){
		prop = new Properties();
		try {
			for (int i = 0; i < builtinProperties.length; i++) {
				String propName = builtinProperties[i];
				InputStream in = Configuration.class.getClassLoader().getResourceAsStream("conf/"+propName);
				if(in!=null){
					prop.load(new InputStreamReader(in,"utf-8"));
				}
			}
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
	@SuppressWarnings("rawtypes")
	public String getPropFromDB(String key){
		String result = null;
	    JdbcTemplate jdbcTemplate=new JdbcTemplate();
	    String schema = this.getProperty("jdbc.datasource.shcema");
	    if(null == schema || schema.equalsIgnoreCase("")) schema = "MD";
		Map paraMap =jdbcTemplate.queryForMap("select  VAL1  from "+schema+".METASYSCFG where PARANAME='"+key+"'");
		if(paraMap!=null) result=(String) paraMap.get("val1"); 
		return result;
	}
	
	private boolean isBuildInProp(String propFilename){
		for (int i = 0; i < builtinProperties.length; i++) {
			String buildInFilename = builtinProperties[i];
			if(buildInFilename.equalsIgnoreCase(propFilename)){
				return true;
			}
		}
		return false;
	}
	
	void loadClasspathProperties(ApplicationContext applicationContext){
		LOG.info("加载"+propsPattern+"配置文件");
		try {
			Resource[] resources = applicationContext.getResources(Configuration.getInstance().propsPattern);
			
			for (Resource resource : resources) {
				if(resource!=null  && resource.isReadable() && !isBuildInProp(resource.getFilename())){
					try {
						prop.load(new InputStreamReader(resource.getInputStream(),"utf-8"));
						LOG.info(resource.getFilename()+"加载成功");
					} catch (IOException e) {
						e.printStackTrace();
						LOG.warn(resource.getFilename()+"加载失败");
					}
				}
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
}
