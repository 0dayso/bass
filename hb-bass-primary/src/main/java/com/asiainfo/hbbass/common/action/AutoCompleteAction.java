package com.asiainfo.hbbass.common.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

@SuppressWarnings("unused")
public class AutoCompleteAction extends Action {
	private static Logger log = Logger.getLogger(AjaxUpdateAction.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// debugger(request);

		/**/
		String tableName = request.getParameter("db_table");
		String keyword = request.getParameter("q_word");
		String pageNum = request.getParameter("page_num");
		String perPage = request.getParameter("per_page");
		String field = request.getParameter("field");
		String showField = request.getParameter("show_field");
		String hideField = request.getParameter("hide_field");
		String selectField = request.getParameter("select_field");
		String orderField = request.getParameter("order_field"); // id
		String primaryKey = request.getParameter("primary_key");
		String order = request.getParameter("order_by"); // asc ? desc ?

		int startNum = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(perPage);
		int endNum = startNum + Integer.parseInt(perPage);
		String[] showFieldArr = (showField != null) ? showField.split(",") : new String[] { "" }; // 原来是false
		String[] hideFieldArr = hideField.split(",");

		String[] selectFieldArr = selectField.split("@");

		String whereClouse;
		if (keyword != null && keyword.length() == 0)
			whereClouse = "";
		else {
			whereClouse = " where 1=1 and ";
			for (int i = 0; i < selectFieldArr.length; i++) {
				whereClouse += selectFieldArr[i] + " like '%" + keyword + "%'";
				if (i < selectFieldArr.length - 1)
					whereClouse += " or ";
			}
		}

		String selectClouse = "";
		for (int i = 0; i < selectFieldArr.length; i++) {
			selectClouse += selectFieldArr[i];
			if (i < selectFieldArr.length - 1)
				selectClouse += " || ' ' || ";
		}
		Connection conn = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		String sql = "SELECT " + selectClouse + " as col, rownumber() over () as rownum " + // 目前只支持查一个字段,因为用了别名col
				" FROM " + tableName + whereClouse +
				// " WHERE " + field + " LIKE '%" + keyword + "%' or " + field +
				// " LIKE '%" + keyword + "%'
				" ORDER BY (CASE WHEN " + orderField + " LIKE '" + keyword + "%' THEN 0 ELSE 1 END)," + orderField + " " + order;
		sql = " select a.col from (" + sql + ") a where a.rownum between " + (startNum + 1) + " and " + endNum;
		log.debug("sql : " + sql);
		Map result = new HashMap();
		try {
			conn = ConnectionManage.getInstance().getDWConnection(); // 后期扩展,现在写死
			ps1 = conn.prepareStatement(sql);
			rs = ps1.executeQuery();
			int totalCount = 0;
			int index = 0;
			while (rs.next()) {
				totalCount++;

				ResultSetMetaData rsmd = rs.getMetaData();
				int colCount = rsmd.getColumnCount();
				for (int i = 0; i < colCount; i++) {
					String value = rs.getString(i + 1);
					String label = rsmd.getColumnLabel(i + 1);
					log.debug("label : " + label);
					if (label.equalsIgnoreCase(primaryKey)) {
						List list = (List) result.get("primary_key");
						if (list == null) {
							list = new ArrayList();
							result.put("primary_key", list);
						}
						list.add(value);
					}
					List list = (List) result.get("candidate");
					if (list == null) {
						list = new ArrayList();
						result.put("candidate", list);
					}
					list.add(value);
					/*
					 * if(label.equalsIgnoreCase(field)){ List list =
					 * (List)result.get("candidate"); if(list == null) { list =
					 * new ArrayList(); result.put("candidate",list); }
					 * list.add(value); log.debug("now list : " + list);
					 * 
					 * } else { log.debug("没进来这里"); // 这里判断的对象不是数组，而是字符串
					 * if(!hideField.contains(label)) {
					 * if(!("".equals(showFieldArr[0])) &&
					 * !(showField.contains("*")) && !
					 * (showField.contains(label))) { continue; } Object[] obj =
					 * new Object[index + 1]; String[] temp = new
					 * String[]{label,value}; obj[index] = temp;
					 * result.put("attached", obj); } }
					 */

				}
				index++;
			}
			result.put("cnt_page", totalCount);

			rs.close();
			// countsql
			String countSql = " select count(*) from " + tableName + whereClouse;
			log.debug(" countsql : " + countSql);
			ps2 = conn.prepareStatement(countSql);
			rs = ps2.executeQuery();
			if (rs.next()) {
				result.put("cnt", rs.getInt(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		String jsonStr = JsonHelper.getInstance().write(result);
		log.info("jsonStr : " + jsonStr);
		PrintWriter out = response.getWriter();
		out.print(jsonStr);

	}

	@SuppressWarnings("rawtypes")
	public static void debugger(HttpServletRequest request) {
		Map map = request.getParameterMap();
		Set set = map.keySet();
		Iterator it = set.iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			String[] value = (String[]) map.get(key);
			String debugStr = "";
			for (int i = 0; i < value.length; i++)
				debugStr += value[i] + ",";
			log.debug(key + "\t" + debugStr);
		}
	}

	public static void main(String[] args) {
	}
}
