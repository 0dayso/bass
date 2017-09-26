package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.bass.role.adaptation.service.CheckErrorUrlInfoService;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.web.models.CommonDao;

/**
 * 查看定时访问错误的url信息
 * @author chendb
 *
 */
@Repository
public class CheckErrorUrlInfoDao extends CommonDao implements CheckErrorUrlInfoService{

	@Override
	public Map<String, Object> getErrorUrlInfo(String menuItemTitle,String startDate,String endDate, int pageSize, int pageNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> list = new ArrayList<String>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper(jdbcTemplate);
		String condition = "";
		String sql = "SELECT ERRORPAGEID,MENUITEMID,MENUITEMTITLE,URL,ERRORCODE,ERRORMESSAGE,ERRORDATE FROM FPF_ERROR_PAGE_INFO WHERE 1=1";
		String countSql = "SELECT COUNT(1) FROM FPF_ERROR_PAGE_INFO WHERE 1=1 ";
			if (StringUtils.hasText(startDate)) {//查询的开始时间
				condition += " AND ERRORDATE > TO_DATE(?,'yyyy-MM-dd') ";
				list.add(startDate);
			}else if (StringUtils.hasText(endDate)) {//查询的结束时间
				condition += " AND ERRORDATE < TO_DATE(?,'yyyy-MM-dd') ";
				list.add(endDate);
			}else if (StringUtils.hasText(menuItemTitle)) {
				condition += " and MENUITEMTITLE like ? ";
				list.add("%" + menuItemTitle + "%");
			}
		sql += condition;
		countSql += condition;
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, (pageNum - 1) * pageSize, "ERRORDATE DESC");
		map.put("total", jdbcTemplate.queryForObject(countSql,Integer.class, list.toArray()));
		map.put("rows", jdbcTemplate.queryForList(sql, list.toArray()));
		return map;
	}

	@Override
	public void deleteInfo(String errorPageId) {
		String sql = "DELETE FROM FPF_ERROR_PAGE_INFO WHERE ERRORPAGEID IN (" + errorPageId + ")";
		jdbcTemplate.update(sql);
	}

}
