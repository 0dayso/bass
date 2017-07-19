package com.asiainfo.hb.core.cache;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.asiainfo.hb.core.models.Configuration;


/**
 * CacheServer的缓存的实现类
 * 
 * 使用JDK自带的HttpURLConnection，相对与apache httpClient的性能?
 * 
 * @author Mei Kefu
 * @date 2010-4-15
 */
public class CacheServerImpl implements CacheServer {
	
	public static Logger LOG = Logger.getLogger(CacheServerImpl.class);
	
	private String name="";
	
	public String cacheURI="";
	
	public CacheServerImpl(String name) throws CacheServerException{
		super();
		this.name = name;
		
		cacheURI=Configuration.getInstance().getProperty("com.asiainfo.pst.cache.cacheURI");
		//cacheURI="http://localhost:8082/ehcache/rest";
		if(cacheURI==null || cacheURI.length()==0){
			LOG.error("cacheURI 不正确");
			throw new RuntimeException("cacheURI 不正确");
		}
		
		cacheURI += "/"+this.name;
		
		try {
			URL url = new URL(cacheURI+"/");
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			if (connection != null){
				connection.setConnectTimeout(500);
				connection.connect();
				connection.disconnect();
			}
		} catch (Exception e) {
			LOG.error("缓存服务器["+getName()+"]建立错误，"+e.getMessage());
			throw new CacheServerException("缓存服务器["+getName()+"]建立错误，"+e.getMessage(),e);
		}
	}

	public void put(String key,Object obj){
		
		try {
			URL url = new URL(cacheURI+"/"+key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			if (connection != null){
				connection.setRequestProperty("Content-Type","application/x-java-serialized-object");
				connection.setDoOutput(true);
				connection.setRequestMethod("PUT");
				connection.setConnectTimeout(500);
		        connection.setReadTimeout(5000);
				connection.connect();
				
				ObjectOutputStream oos = new ObjectOutputStream(connection.getOutputStream());
				oos.writeObject(obj);
				oos.flush();
				
				int respCode = connection.getResponseCode();
				LOG.info("creating entry: "
						+ respCode + " "
						 + connection.getResponseMessage() 
						 + " 添加 " + cacheURI+"/"+key);
				connection.disconnect();
			}
		} catch (Exception e) {
			LOG.error("key为："+key+"，value为："+obj+"对象放入缓存服务器["+cacheURI+"/"+key+"]错误"+e.getMessage());
		}
	}
	
	public Object get(String key,String subKey){
		if(subKey!=null && subKey.length()>0){
			return get(key+"/"+subKey);
		}else{
			return null;
		}
	}
	
	public Object get(String key){
		Object obj = null;
		try {
			URL url = new URL(cacheURI+"/"+key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			if(connection!=null){
		        connection.setRequestMethod("GET");
		        connection.setConnectTimeout(500);
		        connection.setReadTimeout(5000);
		        connection.connect();
		        InputStream is = null;
		        try{
		        	is = connection.getInputStream();
		        	if(is!=null){
			            ObjectInputStream ois = new ObjectInputStream(is);
			            obj = ois.readObject();
			            ois.close();
			            
			            LOG.debug("reading entry: " + connection.getResponseCode()
			                    + " " + connection.getResponseMessage()+" 命中 "+cacheURI+"/"+key);
			            connection.disconnect();
			            
			        }
		        }catch(FileNotFoundException e){
		        	LOG.info(cacheURI+"/"+key+" 没有命中"+e.getMessage());
		        }
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			LOG.error("取出缓存服务器["+cacheURI+"/"+key+"]对象的类型不正确错误"+e.getMessage());
		} catch (Exception e) {
			LOG.error("取出缓存服务器["+cacheURI+"/"+key+"]对象错误"+e.getMessage());
		}
		return obj;
	}
	
	public void remove(String key){
		try {
			URL url = new URL(cacheURI+"/"+key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			if(connection!=null){
		        connection.setRequestMethod("DELETE");
		        connection.setConnectTimeout(500);
		        connection.setReadTimeout(5000);
		        connection.connect();
		        LOG.info("reading entry: " 
		        		+ connection.getResponseCode()
	                    + " " + connection.getResponseMessage() + " 清除 "+cacheURI+"/"+key);
	            connection.disconnect();
			}
		} catch (Exception e) {
			LOG.error("删除缓存服务器["+cacheURI+"/"+key+"]对象错误"+e.getMessage());
		}
	}

	@SuppressWarnings("rawtypes")
	public List getKeys(){
		List result = null;
		try {
			URL url = new URL(cacheURI);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			if(connection!=null){
				connection.setRequestMethod("POST");
				connection.setConnectTimeout(500);
		        connection.setReadTimeout(5000);
				connection.connect();
				InputStream is = null;
				try {
					is = connection.getInputStream();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
				if (is != null) {
					/*
					is = connection.getInputStream();
					byte[] response2 = new byte[4096];
					result = is.read(response2);
					while (result != -1) {
					    System.out.write(response2, 0, result);
					    result = is.read(response2);
					}
					if (is != null) try {
					    is.close();
					} catch (Exception ignore) {
					}
					 */
					/**/
					ObjectInputStream ois = new ObjectInputStream(is);
	
					result = (List) ois.readObject();
	
					ois.close();
					LOG.info("reading entry: "
							+ connection.getResponseCode() + " "
							+ connection.getResponseMessage());
					connection.disconnect();
				} else {
					LOG.info("缓存不存在");
				}
			}
		} catch (Exception e) {
			LOG.error("得到缓存服务器["+getName()+"]对象列表错误"+e.getMessage());
		}
		return result==null?new ArrayList():result;
	}
	
	public int getSize(){
		return getKeys().size();
	}

	public String getName() {
		return cacheURI;
	}

}
