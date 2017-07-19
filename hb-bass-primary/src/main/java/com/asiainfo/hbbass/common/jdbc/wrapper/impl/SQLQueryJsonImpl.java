package com.asiainfo.hbbass.common.jdbc.wrapper.impl;

import java.sql.ResultSet;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase;
import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 2010-3-5修改成Map<key,<list>value>模式
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public class SQLQueryJsonImpl extends SQLQueryBase {

	public static Logger LOG = Logger.getLogger(SQLQueryJsonImpl.class);

	public SQLQueryJsonImpl(CacheServerCache cache) {
		super(cache);
	}

	protected Object format(ResultSet rs) {
		return JsonHelper.getInstance().write(super.format(rs));
	}
}
