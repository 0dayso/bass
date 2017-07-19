package com.asiainfo.hbbass.kpiportal.core;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;

/**
 * 
 * KPI定制类 需要表KPIPORTAL_CUSTOMIZE的支持
 * 
 * @author Mei Kefu
 */
public class KPICustomize {

	@SuppressWarnings("rawtypes")
	public static Map CUSTOMIZE_KPI = new HashMap();

	static {
		init();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void init() {

		CUSTOMIZE_KPI.clear();

		String sql = "select kpiapplication,userid,kpiid from KPIPORTAL_CUSTOMIZE order by kpiapplication,userid,kpiid with ur";

		SQLQuery sqlQery = SQLQueryContext.getInstance().getSQLQuery("list");

		List list = (List) sqlQery.query(sql);

		for (int i = 0; i < list.size(); i++) {
			String[] lines = (String[]) list.get(i);
			Map outterMap = null;
			if (CUSTOMIZE_KPI.containsKey(lines[0])) {
				outterMap = (Map) CUSTOMIZE_KPI.get(lines[0]);
			} else {
				outterMap = new HashMap();
				CUSTOMIZE_KPI.put(lines[0], outterMap);
			}

			List innerList = null;
			if (outterMap.containsKey(lines[1])) {
				innerList = (List) outterMap.get(lines[1]);
			} else {
				innerList = new ArrayList();
				outterMap.put(lines[1], innerList);
			}
			innerList.add(lines[2]);
		}
	}

	@SuppressWarnings("rawtypes")
	public static List getUserCustomizeKpi(String userid, String kpiapp) {
		Map map = (Map) CUSTOMIZE_KPI.get(kpiapp);

		List list = map != null ? (List) map.get(userid) : null;

		if ((list == null || list.size() == 0) && map != null) {
			list = (List) map.get("default");
		}
		return list;
	}

	@SuppressWarnings("rawtypes")
	public static String getUserCustomizeKpiToString(String userid, String kpiapp) {
		List list = getUserCustomizeKpi(userid, kpiapp);
		StringBuffer sb = new StringBuffer();

		for (int i = 0; list != null && i < list.size(); i++) {
			sb.append(list.get(i)).append(",");
		}

		if (sb.length() > 0) {
			sb.delete(sb.length() - 1, sb.length());
		}

		return sb.toString();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void updateUserCustomizeKpi(String userid, String kpiapp, String oper, String kpiid) {

		Map map = (Map) CUSTOMIZE_KPI.get(kpiapp);

		List list = (List) map.get(userid);
		boolean bl = false;
		if (list == null) {
			list = new ArrayList((List) map.get("default"));
			map.put(userid, list);
			bl = true;
		}
		if ("add".equalsIgnoreCase(oper)) {
			list.add(kpiid);
		} else if ("del".equalsIgnoreCase(oper)) {
			list.remove(kpiid);
		}
		if (bl)
			persistent(userid, kpiapp, oper, list);
		else
			persistent(userid, kpiapp, oper, kpiid);
	}

	public static void persistent(String userid, String kpiapp, String oper, String kpiid) {
		Connection conn = null;
		try {
			String sql = "";
			if ("add".equalsIgnoreCase(oper)) {
				sql = "insert into KPIPORTAL_CUSTOMIZE(kpiid,userid,kpiapplication) values(?,?,?)";
			} else if ("del".equalsIgnoreCase(oper)) {
				sql = "delete from KPIPORTAL_CUSTOMIZE where kpiid=? and userid=? and kpiapplication=?";
			}
			conn = ConnectionManage.getInstance().getDWConnection();

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, kpiid);
			ps.setString(2, userid);
			ps.setString(3, kpiapp);
			ps.execute();

			ps.close();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	@SuppressWarnings("rawtypes")
	public static void persistent(String userid, String kpiapp, String oper, List list) {
		Connection conn = null;
		try {
			String sql = "insert into KPIPORTAL_CUSTOMIZE(kpiid,userid,kpiapplication) values(?,?,?)";

			conn = ConnectionManage.getInstance().getDWConnection();

			PreparedStatement ps = conn.prepareStatement(sql);

			for (int i = 0; i < list.size(); i++) {
				ps.setString(1, (String) list.get(i));
				ps.setString(2, userid);
				ps.setString(3, kpiapp);
				ps.addBatch();
			}
			ps.executeBatch();

			ps.close();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
	}

}
