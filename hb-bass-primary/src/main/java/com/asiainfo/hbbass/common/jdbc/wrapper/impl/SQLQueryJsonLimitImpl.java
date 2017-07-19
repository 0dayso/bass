package com.asiainfo.hbbass.common.jdbc.wrapper.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase;
import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 
 * @author Mei Kefu
 * @date 2009-12-30
 */
public class SQLQueryJsonLimitImpl extends SQLQueryBase implements SQLQuery {

	public static Logger LOG = Logger.getLogger(SQLQueryJsonLimitImpl.class);

	public SQLQueryJsonLimitImpl(CacheServerCache cache) {
		super(cache);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Object query(String sql, int limit, int start) {
		String limitSQL = getLimitSQL(sql, limit, start);
		// 使用pieceSQL作为缓存的索引，放的是json对象
		Object obj = getObjectFromCache(limitSQL);// from Cache

		try {
			if (obj == null && connection != null && sql != null && sql.length() > 0) {

				Statement stat = connection.createStatement();
				// 1.先查询sql
				LOG.debug("real SQL:" + limitSQL);
				ResultSet rs = stat.executeQuery(limitSQL);
				List data = null;

				if (rs != null) {
					data = (List) super.format(rs);
					rs.close();
				}

				int count = data.size();// 计数器
				// 2.超过极限说明数据没有查询完整，需要countSQL一下
				int total = 0;// .返回值，总的元素数量
				if (limit == count) {
					total = getTotalCount(sql);
				}
				stat.close();

				Map result = new HashMap();

				LOG.debug("count:" + count + ",total:" + (count > total ? count + start - 1 : total));

				result.put("data", data);
				result.put("total", count > total ? count + start - 1 : total);
				result.put("start", start);
				obj = JsonHelper.getInstance().write(result);
				putObjectToCache(limitSQL, obj);
			}
		} catch (SQLException e) {
			LOG.error("执行失败SQL:" + limitSQL, e);
			e.printStackTrace();
		} finally {
			release();
		}
		return obj;
	}

	protected String getLimitSQL(String sql, int limit, int start) {
		StringBuffer limitSQL = new StringBuffer("select * from (select t.*,rownumber() over(order by 1) as row_num from (");
		limitSQL.append(sql.trim());

		if (limitSQL.indexOf(" with ur") > 0) {
			limitSQL.delete(limitSQL.indexOf("with ur"), limitSQL.length());
		}

		limitSQL.append(") t) t2 where row_num between ").append(start).append(" and ").append((start + limit) - 1).append(" with ur");
		// LOG.debug("SQL:"+pieceSQL);
		return limitSQL.toString();
	}

	protected Object format(ResultSet rs) {
		return null;
	}
}
