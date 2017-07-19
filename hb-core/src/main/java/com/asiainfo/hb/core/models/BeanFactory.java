package com.asiainfo.hb.core.models;

import com.asiainfo.hb.core.util.Encryption;
import org.apache.log4j.Logger;
import org.springframework.beans.BeansException;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.beans.factory.support.GenericBeanDefinition;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.FileSystemXmlApplicationContext;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.XmlWebApplicationContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;



/**
 * 手工从spring托管的容器中取bean
 * @author Mei Kefu
 * @date 2011-6-2
 * @date 2012-2-13 修改可以动态加载数据源
 */
@Component
public class BeanFactory implements ApplicationContextAware{

	private static ApplicationContext applicationContext;
	
	private static Logger LOG = Logger.getLogger(BeanFactory.class);
	
	public static Object getBean(String name){
		return applicationContext.getBean(name);
	}
	
	public static <T> T getBean(Class<T> cls){
		return applicationContext.getBean(cls);
	}

	@SuppressWarnings("static-access")
	@Override
	public void setApplicationContext(ApplicationContext applicationContext1)throws BeansException {
		this.applicationContext=applicationContext1;
		
		//1.加载配置文件
		Configuration.getInstance().loadClasspathProperties(applicationContext1);

		//2.加载动态数据源
		@SuppressWarnings("unused")
		boolean isWebApp = false;
		ConfigurableListableBeanFactory beanFactory=null;
		if(applicationContext instanceof GenericApplicationContext){//架包中的配置文件
			beanFactory = ((GenericApplicationContext)applicationContext).getBeanFactory();
		}else if(applicationContext instanceof FileSystemXmlApplicationContext){//文件系统的配置文件
			beanFactory = ((FileSystemXmlApplicationContext)applicationContext).getBeanFactory();
		}else if(applicationContext instanceof XmlWebApplicationContext){//web的配置文件
			beanFactory=((XmlWebApplicationContext)applicationContext).getBeanFactory();
			isWebApp = true;
		}else{
			LOG.warn("applicationContext的类型没有识别成功,为："+applicationContext1.getClass().getName());
		}
		
		@SuppressWarnings("unused")
		DefaultListableBeanFactory defaultListableBeanFactory=null;
		if(beanFactory instanceof DefaultListableBeanFactory){
			defaultListableBeanFactory = (DefaultListableBeanFactory)beanFactory;
		}else{
			if (beanFactory != null){
				LOG.warn("beanFactory的类型没有识别成功，为："+beanFactory.getClass().getName());
			}
		}
		
//		if(defaultListableBeanFactory!=null){
//			initDynamicBeans(defaultListableBeanFactory,isWebApp);
//			/*if(applicationContext instanceof org.springframework.context.support.AbstractApplicationContext){
//				((org.springframework.context.support.AbstractApplicationContext)applicationContext).refresh();
//			}*/
//		}else{
//			LOG.warn("beanFactory的类型没有识别成功，为："+beanFactory.getClass().getName());
//		}
	}
	
	@SuppressWarnings("unused")
	private void initDynamicBeans(DefaultListableBeanFactory defaultListableBeanFactory,boolean isWebApp){
		List<DataSourceDef> defs = getDataSourceDefs();
		try{
			for (int i = 0; defs!=null && i < defs.size(); i++) {
				DataSourceDef def = defs.get(i);
				defaultListableBeanFactory.registerBeanDefinition(def.getId(),getBeanDefinition(def,isWebApp));
				for (int j = 0; j < def.getAlias().length; j++) {
					defaultListableBeanFactory.registerAlias(def.getId(),def.getAlias()[j]);
				}
				LOG.info("数据源：["+def.getId()+":"+def.getName()+"]注入成功");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	private GenericBeanDefinition getBeanDefinition(DataSourceDef def,boolean isWebApp){
		GenericBeanDefinition gbd = new GenericBeanDefinition();
		MutablePropertyValues mpv = new MutablePropertyValues();
		if(isWebApp){//web应用优先加载jndi
			mpv.add("jndiName", def.getJndiName());
			gbd.setBeanClass(JndiObjectFactoryBean.class);
		}else{
			mpv.add("driverClassName", def.getDriverClassName());
			mpv.add("url", def.getUrl());
			mpv.add("username", def.getUsername());
			mpv.add("password", def.getPassword());
			
			//先判断数据库有没有连接池 org.apache.commons.dbcp.BasicDataSource , org.springframework.jdbc.datasource.DriverManagerDataSource
			Class clz = null;
			try{
				clz = Class.forName("org.apache.commons.dbcp.BasicDataSource");
			}catch(Exception e){
				LOG.warn("容器没有加载到连接池类：org.apache.commons.dbcp.BasicDataSource，使用的是直连可能会导致性能下降");
				clz = DriverManagerDataSource.class;
			}
			gbd.setBeanClass(clz);
		}
		gbd.setPropertyValues(mpv);
		return gbd;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private List<DataSourceDef> getDataSourceDefs(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate();
		List<DataSourceDef> defs = null;
		try{
			defs =  jdbcTemplate.query("select * from MD.METADBCFG",new RowMapper(){
				@Override
				public Object mapRow(ResultSet rs, int arg1) throws SQLException {
					//DataSourceDef def = new DataSourceDef("DWDB","仓库","COM.ibm.db2.jdbc.app.DB2Driver","jdbc:db2:db2local","Mei Kefu","lyy1","java:comp/env/jdbc/AiomniDB","DWDB");
					String id = rs.getString("dbname");
					String name = rs.getString("cnname");
					String driverClassName = rs.getString("driverClassName");
					String url = rs.getString("url");
					String username = rs.getString("username");
					String password = rs.getString("password");
					String jndiName = rs.getString("jndiName");
					String alias = rs.getString("alias");
					return new DataSourceDef(id,name,driverClassName,url,username,password,jndiName,alias);
				}
			});
		}catch(Exception e){
			LOG.error("从数据库表[MD.METADBCFG]加载数据源配置不成功");
		}
		return defs;
	}
}

class DataSourceDef{
	private String id
		,name
		,driverClassName
		,url
		,username
		,password
		,jndiName;
	
	private String[] alias;

	public DataSourceDef(String id, String name, String driverClassName,
			String url, String username, String password, String jndiName,
			String aliasStr) {
		super();
		this.id = id;
		this.name = name;
		this.driverClassName = driverClassName;
		this.url = url;
		this.username = username==null?"":username;
		this.password = Encryption.decrypt(password==null?"":password);
		this.jndiName = jndiName;
		if(aliasStr!=null){
			this.alias = aliasStr.split(",");
		}else{
			this.alias =new String[0];
		}
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getDriverClassName() {
		return driverClassName;
	}

	public String getUrl() {
		return url;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public String getJndiName() {
		return jndiName;
	}

	public String[] getAlias() {
		return alias;
	}
}
