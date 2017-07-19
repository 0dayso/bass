package com.asiainfo.hbbass.common.jdbc.wrapper.impl;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase;
import com.asiainfo.hbbass.component.cache.CacheServerCache;

/**
 * 
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public class SQLQueryListImpl extends SQLQueryBase {

	public static Logger LOG = Logger.getLogger(SQLQueryListImpl.class);

	public SQLQueryListImpl(CacheServerCache cache) {
		super(cache);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Object format(ResultSet rs) {
		LOG.debug("List数据格式化");
		List result = new ArrayList();
		try {
			int width = rs.getMetaData().getColumnCount();
			String[] data = null;
			while (rs.next()) {
				data = new String[width];
				for (int i = 0; i < width; i++) {
					data[i] = rs.getString(i + 1);
				}
				result.add(data);
			}
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return result;
	}
}
