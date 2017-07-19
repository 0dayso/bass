package com.asiainfo.hbbass.common.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

public class AjaxUpdateAction extends Action {
	private static Logger log = Logger.getLogger(AjaxUpdateAction.class);

	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String oper = request.getParameter("oper");
		log.debug("oper : " + oper);
		if ("update".equalsIgnoreCase(oper)) {
			update(request, response);
		} else if ("insert".equalsIgnoreCase(oper)) {
			insert(request, response);
		} else if ("updateJson".equalsIgnoreCase(oper)) {
			updateJson(request, response);
		}
	}

	public void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String table = request.getParameter("table");
		String cols = request.getParameter("cols");
		String pkCol = request.getParameter("pkcol");
		String ids = request.getParameter("ids"); // 主键字段，逗号分隔
		String[] vals = request.getParameterValues("vals");

		// String[] colsArr = cols.split(",");
		// String[] idsArr = ids.split(",");
		String ds = request.getParameter("ds");
		log.debug("table : " + table + " ; cols : " + cols + " ; pkCol : " + pkCol + " ; ids : " + ids);
		Connection conn = (ds != null && "web".equalsIgnoreCase(ds)) ? ConnectionManage.getInstance().getWEBConnection() : ConnectionManage.getInstance().getDWConnection();
		try {
			execUpdate(conn, table, cols, ids, vals, pkCol);
			request.setAttribute("result", "执行成功");

		} catch (Exception e) {
			request.setAttribute("result", "操作失败,原因 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		result(request, response);

	}

	@SuppressWarnings("rawtypes")
	private String[] objectToArray(Object o) {
		String[] arr = null;
		if (o instanceof String[]) {
			arr = (String[]) o;
		} else if (o instanceof List) {
			List l = (List) o;
			// arr = l.toString().replace("[", "").replace("]", "").split(",");
			Object[] temp = l.toArray(); // [[val1,val2,val3],[val1,val2,val3]]
											// or ["","",""]
			if (temp[0] instanceof String) {
				arr = new String[temp.length];
				for (int i = 0; i < temp.length; i++) {
					arr[i] = (String) temp[i];
				}
			} else if (temp[0] instanceof List) {
				arr = new String[temp.length];
				for (int i = 0; i < temp.length; i++) {
					List ll = (List) temp[i];
					arr[i] = ll.toString().replace("[", "").replace("]", "");
				}
			}
		} else if (o instanceof String) {
			arr = ((String) o).split(",");
		} else if (o instanceof Long) {
			arr = (o.toString()).split(",");
		}
		return arr;
	}

	/*
	 * 接口版本
	 */
	private void execUpdate(Connection conn, Object table, Object cols, Object ids, Object vals, Object pkCol) throws Exception {
		this.execUpdate(conn, (String) table, objectToArray(cols), objectToArray(ids), objectToArray(vals), (String) pkCol);
	}

	/*
	 * 数组版本,最终执行版本
	 */
	private void execUpdate(Connection conn, String table, String[] colsArr, String[] idsArr, String[] vals, String pkCol) throws Exception {

		PreparedStatement ps = null;
		String sqlCols = "";
		for (int i = 0; i < colsArr.length; i++) {
			sqlCols += colsArr[i] + "=?,";
		}
		if (idsArr.length != vals.length)
			throw new RuntimeException("直接或间接提供的参数中idsArr与vals的length不相同,idsArr.length : " + idsArr.length + ", vals.length : " + vals.length + " ,数据库操作取消");
		String sql = " update " + table + " set " + sqlCols.substring(0, sqlCols.length() - 1) + " where " + pkCol + "=?";
		log.debug("sql : " + sql);
		ps = conn.prepareStatement(sql);
		for (int i = 0; i < vals.length; i++) {
			String[] valArr = null;
			/*
			 * if(vals[i] instanceof String[]) // it is impossible for now
			 * valArr= (String[])vals[i]; else
			 */
			if (vals[i] instanceof String) {
				valArr = ((String) vals[i]).split(",");
			}
			for (int j = 0; j < valArr.length; j++) {
				String v = valArr[j];
				v = StringUtils.trim(v);
				if (null != v && "null".equals(v)) {
					v = null;
				}
				ps.setString(j + 1, v);
				log.debug("ps.setString : " + (j + 1) + "为" + StringUtils.trim(valArr[j]));
			}

			ps.setString(valArr.length + 1, (String) idsArr[i]);
			log.debug("ps.setString : " + (valArr.length + 1) + "为" + (String) idsArr[i]);
			ps.addBatch();
		}

		ps.executeBatch();// 不管返回值

	}

	public void result(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.print(request.getAttribute("result"));
	}

	/* 唯一版本的insert : json 版本 */
	@SuppressWarnings("rawtypes")
	public void insert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AutoCompleteAction.debugger(request);
		String jsonStr = request.getParameter("json");
		System.out.println(jsonStr);
		if (jsonStr != null) {
			Map map = (Map) JsonHelper.getInstance().read(jsonStr);
			Set keys = map.keySet();

			/*  */
			Iterator keysIt = keys.iterator();
			String tableName = null, cols = null, ds = null;
			List vals = null;
			while (keysIt.hasNext()) {
				String key = (String) keysIt.next();
				if ("tableName".equalsIgnoreCase(key)) {
					tableName = (String) map.get(key);
					continue;
				} else if ("cols".equalsIgnoreCase(key)) {
					Object val = map.get(key);
					if (val instanceof List) {
						String tempStr = ((List) map.get(key)).toString();
						cols = tempStr.replace("[", "").replace("]", "");
						continue;
					} else if (val instanceof String) {
						cols = (String) val;
						continue;
					}

				} else if ("vals".equalsIgnoreCase(key)) {
					vals = (List) map.get(key);
					log.debug("vals : " + vals);
					continue;
				} else if ("ds".equalsIgnoreCase(key)) {
					ds = (String) map.get(key);
					continue;
				}
			}
			if (tableName == null || cols == null)
				return;
			else {
				String placeHolder = "";
				for (int i = 0; i < cols.split(",").length; i++) {
					placeHolder += "?,";
				}
				placeHolder = placeHolder.substring(0, placeHolder.length() - 1);
				String sql = " insert into " + tableName + " ( " + cols + " ) values ( " + placeHolder + " ) ";
				log.debug("PHsql : " + sql);
				Connection conn = null;
				PreparedStatement ps = null;
				try {
					conn = (ds != null && "web".equalsIgnoreCase(ds)) ? ConnectionManage.getInstance().getWEBConnection() : ConnectionManage.getInstance().getDWConnection();
					ps = conn.prepareStatement(sql);
					Iterator valsIt = vals.iterator();
					while (valsIt.hasNext()) {
						List val = (List) valsIt.next();
						Iterator valIt = val.iterator();
						int indx = 0;
						while (valIt.hasNext()) {
							indx++;
							ps.setString(indx, (String) valIt.next());
						}
						ps.addBatch();
					}
					ps.executeBatch();
					request.setAttribute("result", "执行成功");

				} catch (Exception e) {
					request.setAttribute("result", "操作失败,原因 : " + e.getMessage());
					e.printStackTrace();
					log.error(e.getMessage());
				} finally {
					ConnectionManage.getInstance().releaseConnection(conn);
				}
				result(request, response);
			}

		}

	}

	@SuppressWarnings("rawtypes")
	public void updateJson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AutoCompleteAction.debugger(request);
		String jsonStr = request.getParameter("json");
		System.out.println(jsonStr);
		if (jsonStr != null) {
			Map map = (Map) JsonHelper.getInstance().read(jsonStr);
			Set keys = map.keySet();
			Iterator keysIt = keys.iterator();
			Object vals = null, ids = null, tableName = null, cols = null, ds = null, pkCol = null;
			;
			while (keysIt.hasNext()) {
				String key = (String) keysIt.next();
				if ("tableName".equalsIgnoreCase(key)) {
					tableName = map.get(key);
					continue;
				} else if ("pkCol".equalsIgnoreCase(key)) {
					pkCol = map.get(key);
					continue;
				} else if ("ids".equalsIgnoreCase(key)) {
					ids = map.get(key); // may change to the same type as cols
					continue;
				} else if ("cols".equalsIgnoreCase(key)) {
					cols = map.get(key);
					continue;
				} else if ("vals".equalsIgnoreCase(key)) {
					vals = (List) map.get(key);
					continue;
				} else if ("ds".equalsIgnoreCase(key)) {
					ds = (String) map.get(key);
					continue;
				}
			}
			if (tableName == null || cols == null)
				return;
			else {
				Connection conn = (ds != null && "web".equalsIgnoreCase((String) ds)) ? ConnectionManage.getInstance().getWEBConnection() : ConnectionManage.getInstance().getDWConnection();
				try {
					log.debug("conn : " + conn + " ; tableName : " + tableName + " ; cols : " + cols + " ; ids : " + ids + " ; vals : " + vals + " ; pkCol : " + pkCol);
					this.execUpdate(conn, tableName, cols, ids, vals, pkCol);
					request.setAttribute("result", "执行成功");
				} catch (Exception e) {
					request.setAttribute("result", "操作失败,原因 : " + e.getMessage());
					e.printStackTrace();
					log.error(e.getMessage());
				} finally {
					ConnectionManage.getInstance().releaseConnection(conn);
				}
				result(request, response);
			}
		}
	}

	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	public static void main(String[] args) throws Exception {
		/*
		 * String[] strs = "abc".split("d"); System.out.println(strs);
		 * System.out.println(strs.length);
		 */
		/**/
		Object[] b = new Object[] { "a", "b", new Object() };
		Object[] c = { "a", "b", new Object() };
		String[] a = new String[] { "a", "b" };
		System.out.println(a instanceof String[]);
		System.out.println(b instanceof String[]);

		/*
		 * 测试null String a = null; System.out.println(a + "a");
		 */
		/*
		 * 测试 list 和 array 的 toString List l = new ArrayList(); l.add("a");
		 * l.add(4); System.out.println(l); Object[] o = {"a",4};
		 * System.out.println(o);
		 */
		/*
		 * 测试unicode String s = "\u4e2daa\u4e2d"; System.out.println(s);
		 */
		/*
		 * 测试 JSONReader 的 bug 不成功 , JSPNReader 所包装的类库本身没有bug String jsonStr =
		 * "[\"val1\",\"val2\",3,\"a中文a\",\"\u4e2d\u4e2d\",\"\u4e2daa\"]";
		 * String jsonStr2 =
		 * "{\"tableName\":\"NWH.CTT_MANAGER\",\"oper\":\"insert\",\"cols\":[\"MANAGER_ID\",\"MANAGER_NAME\",\"LOGIN_NAME\",\"AREA_ID\",\"MOBILEPHONE\",\"VIP_MANAGER_ID\"],\"vals\":[[\"\u4e2d\u6587\",\"\u4e2d\u6587\",\"\u4e2d\u6587\",\"  \",null,null]]}"
		 * ; System.out.println(jsonStr);//["val1","val2",3,"a中文a","中中","中aa"]
		 * System.out.println(JsonHelper.getInstance().read(jsonStr));//[val1,
		 * val2, 3, a中文a, 中中, 中aa] 正常
		 * System.out.println(jsonStr2);//{"tableName"
		 * :"NWH.CTT_MANAGER","oper":"insert"
		 * ,"cols":["MANAGER_ID","MANAGER_NAME"
		 * ,"LOGIN_NAME","AREA_ID","MOBILEPHONE"
		 * ,"VIP_MANAGER_ID"],"vals":[["中文","中文","中文","  ",null,null]]}
		 * System.out
		 * .println(JsonHelper.getInstance().read(jsonStr2));//{cols=[MANAGER_ID
		 * , MANAGER_NAME, LOGIN_NAME, AREA_ID, MOBILEPHONE, VIP_MANAGER_ID],
		 * oper=insert, tableName=NWH.CTT_MANAGER, vals=[[中文, 中文, 中文, , null,
		 * null]]} //以上正常 Map map =
		 * (Map)JsonHelper.getInstance().read(jsonStr2);
		 * System.out.println(map); //仍然正常
		 */
		/* test JSONReader bug */
		String teststr1 = "{\"tableName\":\"NWH.CTT_MANAGER\",\"oper\":\"insert\",\"cols\":[\"MANAGER_ID\",\"MANAGER_NAME\",\"LOGIN_NAME\",\"AREA_ID\",\"MOBILEPHONE\",\"VIP_MANAGER_ID\"],\"vals\":[[\"\u4e2d\u6587\",\"\u4e2d\u6587\",\"\u4e2d\u6587\",\"  \",null,null]]}";
		String teststr2 = "{\"tableName\":\"NWH.CTT_MANAGER\",\"oper\":\"insert\",\"cols\":[\"MANAGER_ID\",\"MANAGER_NAME\",\"LOGIN_NAME\",\"AREA_ID\",\"MOBILEPHONE\",\"VIP_MANAGER_ID\"],\"vals\":[[\"\\u4e2d\\u6587\",\"\\u4e2d\\u6587\",\"\\u4e2d\\u6587\",\"  \",null,null]]}";
		System.out.println(JsonHelper.getInstance().read(teststr1));
		System.out.println(JsonHelper.getInstance().read(teststr2));
		List list = new ArrayList();
		list.add("a");
		list.add("b");
		Object[] o = list.toArray();
		System.out.println(o);
	}

}
