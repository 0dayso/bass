package com.asiainfo.hbbass.frame;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.Util;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2009-11-11
 */
public class FrameAction extends Action {

	private static Logger LOG = Logger.getLogger(FrameAction.class);

	// private JSONWriter jsonWriter = new JSONWriter(false);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void nodes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);

		String user_id = (String) request.getSession().getAttribute("loginname");
		/*
		 * select menuitemid id,menuitemtitle text,value(url,'') url from
		 * FPF_SYS_MENU_ITEM where parentid=966 and (accesstoken=0 or menuitemid in
		 * ( select distinct int(resourceid) from FPF_SYS_MENUITEM_RIGHT smr, (
		 * select role_id from FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where
		 * ugm.userid='meikefu' and ugm.group_id=grm.group_id union all select
		 * role_id from FPF_USER_ROLE_MAP where userid='meikefu') roles where
		 * smr.operatorid=role_id ) ) order by sortnum with ur
		 */
		String sql = " select menuitemid id,menuitemtitle text,value(url,'') url " + " from FPF_SYS_MENU_ITEM where parentid=" + id + " and (accesstoken=0 or menuitemid in (" + " select distinct int(resourceid) from FPF_SYS_MENUITEM_RIGHT smr," + " ("
				+ " select role_id from FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where ugm.userid='" + user_id + "' and ugm.group_id=grm.group_id" + " union all" + " select roleid role_id from FPF_USER_ROLE_MAP where userid='" + user_id + "') roles" + " where smr.operatorid=role_id" + " ) )" + " order by sortnum with ur";
		List list = (List) sqlQuery.query(sql);

		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			String url = (String) map.get("url");
			String mid = String.valueOf(map.get("id"));
			if (url != null && url.length() > 0) {
				// String
				// paramStr="funccode="+line[0]+"&themecode="+line[1]+"&menuitemid="+id+"&catacode="+title;
				// String
				// paramStr="loginname="+user_id+"&cityId="+(String)request.getSession().getAttribute("area_id")+"&funccode="+request.getParameter("funccode")+"&menuitemid="+id;
				String paramStr = "loginname=" + user_id + "&cityId=" + (String) request.getSession().getAttribute("area_id") + "&mid=" + mid;

				if (url.startsWith("/direct.jsp?url=")) {
					if (url.substring(16).indexOf("?") > 0 || url.substring(16).indexOf("|") > 0) {
						url += "@";
					} else {
						url += "|";
					}
					url += paramStr.replaceAll("&", "@");
				} else {
					if (url.indexOf("?") > 0) {
						// url +="&amp;";
						url += "&";
					} else {
						url += "?";
					}
					// url += paramStr.replaceAll("&","&amp;");
					url += paramStr;
				}
				map.put("url", url);
			}
			map.put("leaf", (url != null && url.length() > 0) ? true : false);

		}

		/*
		 * List list = new ArrayList(); Map map = new HashMap(); map.put("text",
		 * "abc"); map.put("id", "abc"); map.put("leaf", "false");
		 * //map.put("cls", "folder");
		 * 
		 * list.add(map);
		 * 
		 * map = new HashMap(); map.put("text", "abcd"); map.put("id", "abcd");
		 * //map.put("cls", "file"); map.put("leaf", "true");
		 * 
		 * list.add(map);
		 * 
		 * String result = jsonWriter.write(list);
		 */
		String result = JsonHelper.getInstance().write(list);
		LOG.debug(result);

		response.getWriter().write(result);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ActionMethod(isLog = false)
	public void topNodes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);

		String user_id = (String) request.getSession().getAttribute("loginname");
		// ?funccode=966&menuitemid=353&loginname=meikefu&cityId=0
		// container.htm?id=966&text=运营管理监控

		/*
		 * 
		 * select t1.menuitemid pid,t1.menuitemtitle ptitle ,t2.menuitemid
		 * id,t2.menuitemtitle title,t2.url src from FPF_SYS_MENU_ITEM
		 * t1,FPF_SYS_MENU_ITEM t2 where t1.parentid =0 and t1.menuitemid in
		 * (966,3,4,5,6,7,2,749,1137,525,1,1000) and t2.parentid=t1.menuitemid
		 * 
		 * and (t2.accesstoken=0 or t2.menuitemid in ( select distinct
		 * int(resourceid) from FPF_SYS_MENUITEM_RIGHT smr, ( select role_id from
		 * FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where ugm.userid='meikefu' and
		 * ugm.group_id=grm.group_id union all select role_id from FPF_USER_ROLE_MAP
		 * where userid='meikefu') roles where smr.operatorid=role_id ) )
		 * 
		 * order by t1.sortnum,t2.sortnum with ur
		 */

		String sql = " select t1.menuitemid pid,t1.menuitemtitle ptitle " + " ,t2.menuitemid id,t2.menuitemtitle title,t2.url src" + " from FPF_SYS_MENU_ITEM t1,FPF_SYS_MENU_ITEM t2 " + " where t1.parentid =0 and t1.menuitemid in (1000,966,431,6,3,98091224,525,2,1,98091361)" + " and t2.parentid=t1.menuitemid"

		+ " and (t1.accesstoken=0 or t1.menuitemid in (" + " select distinct int(resourceid) from FPF_SYS_MENUITEM_RIGHT smr," + " (" + " select role_id from FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where ugm.userid='" + user_id + "' and ugm.group_id=grm.group_id" + " union all"
				+ " select roleid role_id from FPF_USER_ROLE_MAP where userid='" + user_id + "') roles" + " where smr.operatorid=role_id" + " ) )"

				+ " and (t2.accesstoken=0 or t2.menuitemid in (" + " select distinct int(resourceid) from FPF_SYS_MENUITEM_RIGHT smr," + " (" + " select role_id from FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where ugm.userid='" + user_id + "' and ugm.group_id=grm.group_id" + " union all"
				+ " select roleid role_id from FPF_USER_ROLE_MAP where userid='" + user_id + "') roles" + " where smr.operatorid=role_id" + " ) )" + " order by t1.sortnum,t2.sortnum with ur";

		List list = (List) sqlQuery.query(sql);

		List result = new ArrayList();

		Map pItem = new HashMap();

		for (int i = 0; i < list.size(); i++) {
			Map child = (Map) list.get(i);

			Integer pid = (Integer) child.get("pid");
			Integer id = (Integer) child.get("id");

			String url = (String) child.get("src");
			String paramStr = "loginname=" + user_id + "&cityId=" + (String) request.getSession().getAttribute("area_id") + "&mid=" + id;
			if (url != null && url.length() > 0) {
				// String
				// paramStr="funccode="+line[0]+"&themecode="+line[1]+"&menuitemid="+id+"&catacode="+title;

				if (url.startsWith("/direct.jsp?url=")) {
					if (url.substring(16).indexOf("?") > 0 || url.substring(16).indexOf("|") > 0) {
						url += "@";
					} else {
						url += "|";
					}
					url += paramStr.replaceAll("&", "@");
				} else {
					if (url.indexOf("?") > 0) {
						// url +="&amp;";
						url += "&";
					} else {
						url += "?";
					}
					// url += paramStr.replaceAll("&","&amp;");
					url += paramStr;
				}
				child.put("src", url);
			} else {
				child.put("suffix", paramStr);
			}

			if (!pItem.containsKey(pid)) {
				Map parent = new HashMap();
				pItem.put(pid, parent);
				parent.put("title", child.get("ptitle"));
				parent.put("id", child.get("pid"));
				parent.put("children", new ArrayList());
				result.add(parent);
			}

			List children = (List) ((Map) pItem.get(pid)).get("children");
			child.remove("pid");
			child.remove("ptitle");
			child.remove("psrc");
			children.add(child);

		}

		String str = JsonHelper.getInstance().write(result);
		LOG.debug(str);
		response.getWriter().write(str);

	}

	@ActionMethod(isLog = false)
	public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = (String) request.getSession().getAttribute("loginname");

		if (userId != null && userId.length() > 0) {
			LOG.info("clear online user :" + userId);
			Connection conn = ConnectionManage.getInstance().getWEBConnection();
			Connection conn1 = ConnectionManage.getInstance().getWEBConnection();
			try {
				conn.createStatement().execute("delete from fpf_online_user where user_id='" + userId + "'");
				conn.commit();
				String ip = Util.getRemoteAddr(request);
				String mac = Util.getMACAddress();
				String app_serv = request.getLocalAddr() + ":" + request.getLocalPort();
				//增加注销日志记录，其中result=4表示注销操作
				conn1.createStatement().execute("insert into FPF_LOGIN_INFO (LOGINNAME, IP, MAC, APP_SERV, RESULT) values('"+userId+"', '"+ip+"', '"+mac+"', '"+app_serv+"','4')");
				conn1.commit();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				ConnectionManage.getInstance().releaseConnection(conn1);
			}
		}
	}
}
