package com.asiainfo.hbbass.component.cache;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
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
@SuppressWarnings("rawtypes")
public class CacheServerCacheImpl implements CacheServerCache {

	public static Logger LOG = Logger.getLogger(CacheServerCacheImpl.class);

	private String name = "";

	private String cacheURI = "";

	public CacheServerCacheImpl(String name) {
		super();
		this.name = name;

		cacheURI = Configuration.getInstance().getProperty("com.asiainfo.hbbass.component.cache.cacheURI");

		if (cacheURI == null || cacheURI.length() == 0) {
			LOG.error("cacheURI 不正确");
			throw new RuntimeException("cacheURI 不正确");
		}
		cacheURI += "/" + this.name;
	}

	public void put(String key, Object obj) {

		try {
			URL url = new URL(cacheURI + "/" + key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("Content-Type", "application/x-java-serialized-object");
			connection.setDoOutput(true);
			connection.setRequestMethod("PUT");
			connection.setConnectTimeout(500);
			connection.setReadTimeout(1000);
			connection.connect();

			ObjectOutputStream oos = new ObjectOutputStream(connection.getOutputStream());
			oos.writeObject(obj);
			oos.flush();

			LOG.info("creating entry: " + connection.getResponseCode() + " " + connection.getResponseMessage() + " 添加 " + cacheURI + "/" + key);
			if (connection != null)
				connection.disconnect();
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public Object get(String key, String subKey) {
		if (subKey != null && subKey.length() > 0) {
			return get(key + "/" + subKey);
		} else {
			return null;
		}
	}

	public Object get(String key) {

		Object obj = null;

		try {
			URL url = new URL(cacheURI + "/" + key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setConnectTimeout(500);
			connection.setReadTimeout(5000);
			connection.connect();
			InputStream is = null;
			try {
				is = connection.getInputStream();
				if (is != null) {
					ObjectInputStream ois = new ObjectInputStream(is);

					obj = ois.readObject();

					ois.close();
					LOG.info("reading entry: " + connection.getResponseCode() + " " + connection.getResponseMessage() + " 命中 " + cacheURI + "/" + key);
					if (connection != null)
						connection.disconnect();

				}
			} catch (FileNotFoundException e) {
				LOG.info(cacheURI + "/" + key + " 没有命中" + e.getMessage());
			}

		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		return obj;
	}

	public void remove(String key) {
		try {
			URL url = new URL(cacheURI + "/" + key);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("DELETE");
			connection.setConnectTimeout(500);
			connection.setReadTimeout(1000);
			connection.connect();
			LOG.info("reading entry: " + connection.getResponseCode() + " " + connection.getResponseMessage() + " 清除 " + cacheURI + "/" + key);
			if (connection != null)
				connection.disconnect();

		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public List getKeys() {
		List result = null;
		try {
			URL url = new URL(cacheURI);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setConnectTimeout(500);
			connection.setReadTimeout(1000);
			connection.connect();
			InputStream is = null;
			try {
				is = connection.getInputStream();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			if (is != null) {
				/*
				 * is = connection.getInputStream(); byte[] response2 = new
				 * byte[4096]; result = is.read(response2); while (result != -1)
				 * { System.out.write(response2, 0, result); result =
				 * is.read(response2); } if (is != null) try { is.close(); }
				 * catch (Exception ignore) { }
				 */
				/**/
				ObjectInputStream ois = new ObjectInputStream(is);

				result = (List) ois.readObject();

				ois.close();
				LOG.info("reading entry: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				if (connection != null)
					connection.disconnect();
			} else {
				System.out.println("缓存不存在");
			}
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		return result == null ? new ArrayList<Object>() : result;
	}

	public int getSize() {
		return getKeys().size();
	}

	public String getName() {
		return name;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		CacheServerCache cacheSql = new CacheServerCacheImpl("SQL");

		List list = cacheSql.getKeys();

		for (int i = 0; i < list.size(); i++) {
			String string = (String) list.get(i);

			cacheSql.remove(string);
		}
	}

}
