package com.asiainfo.bass.components.models;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;

import com.asiainfo.hb.core.cache.CacheServer;
import com.asiainfo.hb.core.cache.CacheServerFactory;

/**
 * 
 * @author Mei Kefu
 * @date 2011-3-13
 */
// ���ﲻ����@Compnonet
public class JdbcTemplate extends org.springframework.jdbc.core.JdbcTemplate {

	private Logger LOG = Logger.getLogger(JdbcTemplate.class);

	protected CacheServer cache = null;

	protected void putObjectToCache(String sql, Object obj) {
		if (cache != null) {
			LOG.debug("cache SQL query:" + sql);
			cache.put(md5(sql), obj);
		}
	}

	protected Object getObjectFromCache(String sql) {
		Object obj = null;
		if (cache != null) {
			obj = cache.get(md5(sql));
			if (obj != null)
				LOG.info("hit by cache SQL=" + sql);
		}
		return obj;
	}

	public JdbcTemplate(DataSource dataSource) {
		this(dataSource, true);
	}

	public JdbcTemplate(DataSource dataSource, boolean isCached) {
		super(dataSource);
		if (isCached)
			cache = CacheServerFactory.getInstance().getCache("SQL");
	}

	@Override
	public <T> T query(String sql, ResultSetExtractor<T> rse) throws DataAccessException {
		@SuppressWarnings("unchecked")
		T obj = (T) getObjectFromCache(sql);

		if (obj == null) {
			obj = super.query(sql, rse);
			putObjectToCache(sql, obj);
		}

		return obj;
	}

	@Override
	protected RowMapper<Map<String, Object>> getColumnMapRowMapper() {
		return new ColumnMapRowMapper() {
			@Override
			protected String getColumnKey(String columnName) {
				return columnName.toLowerCase();
			}
		};
	}

	static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	public static String md5(String string) {
		try {
			MessageDigest digest = MessageDigest.getInstance("MD5");
			byte[] md = digest.digest(string.getBytes());
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return String.valueOf(str);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}
}
