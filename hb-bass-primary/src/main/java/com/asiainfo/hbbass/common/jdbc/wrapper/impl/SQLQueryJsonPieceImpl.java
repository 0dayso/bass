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
 * 计算只取出前多少条的数据
 * 
 * @author Mei Kefu
 * @date 2010-9-16
 */
public class SQLQueryJsonPieceImpl extends SQLQueryBase implements SQLQuery {

	public static Logger LOG = Logger.getLogger(SQLQueryJsonPieceImpl.class);

	public SQLQueryJsonPieceImpl(CacheServerCache cache) {
		super(cache);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Object query(String sql, int rows) {
		String pieceSQL = getPieceSQL(sql, rows);
		// 使用pieceSQL作为缓存的索引，放的是json对象
		Object obj = getObjectFromCache(pieceSQL);// from Cache

		try {
			if (obj == null && connection != null && sql != null && sql.length() > 0) {

				Statement stat = connection.createStatement();
				// 1.先查询sql
				LOG.debug("real SQL:" + pieceSQL);
				ResultSet rs = stat.executeQuery(pieceSQL);

				List data = null;

				if (rs != null) {
					data = (List) super.format(rs);
					rs.close();
				}

				int count = data.size();// 计数器
				// 2.超过极限说明数据没有查询完整，需要countSQL一下
				Integer total = count;// .返回值，总的元素数量
				if (rows == count) {
					total = getTotalCount(sql);
				}
				stat.close();

				Map result = new HashMap();

				LOG.debug("count:" + count + ",total:" + total);

				result.put("data", data);
				result.put("total", total);
				obj = JsonHelper.getInstance().write(result);
				putObjectToCache(pieceSQL, obj);
			}
		} catch (SQLException e) {
			LOG.error("执行失败SQL:" + pieceSQL, e);
			e.printStackTrace();
		} finally {
			release();
		}
		return obj;
	}

	protected Object format(ResultSet rs) {
		return null;
	}
}
