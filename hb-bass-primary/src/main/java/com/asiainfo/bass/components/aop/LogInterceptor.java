package com.asiainfo.bass.components.aop;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.hb.web.models.User;

/**
 * 
 * @author Mei Kefu
 * @date 2011-4-7
 */
@SuppressWarnings({"rawtypes" })
public class LogInterceptor implements HandlerInterceptor {

	private String report_regex = ".*/report/([0-9]{4,6}).*";

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3) throws Exception {
	

	}

	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handle, ModelAndView model) throws Exception {

		try {
			String uri = request.getRequestURI();
			String param = null;
			if ("get".equalsIgnoreCase(request.getMethod())) {
				param = (request.getQueryString() != null ? request.getQueryString() : "");
			} else if ("post".equalsIgnoreCase(request.getMethod())) {
				Map params = request.getParameterMap();
				StringBuilder sb = new StringBuilder();
				for (Iterator iterator = params.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry entry = (Map.Entry) iterator.next();
					sb.append("&").append(entry.getKey()).append("=").append(((String[]) entry.getValue())[0]);
				}
				param = sb.toString();
			} else {
				param = "";
			}

			// 菜单轨迹全局量，因为有可能权限里面已经有了
			StringBuilder menuTrack = new StringBuilder();
			StringBuilder menuIdTrack = new StringBuilder();

			Pattern p = Pattern.compile(report_regex);
			Matcher m = p.matcher(uri);

			boolean logFlag = false;
			String opertype = "";
			String opername = "";
			long during = -1;
			if (m.matches()) {// KPI 和老 报表
				String sid = m.group(1);
				long preTime = ((Long) request.getAttribute("REPORT_DURING_" + sid)).longValue();
				during = (System.currentTimeMillis() - preTime);
				logFlag = true;
				opername = sid;

				opertype = uri.substring(uri.indexOf(sid) + sid.length());

				if (opertype.startsWith("/")) {
					opertype = opertype.substring(1);
				}

				if (opertype.length() > 0) {
					opertype = opertype.indexOf("/") > 0 ? opertype.substring(0, opertype.indexOf("/")) : opertype;
				} else {
					opertype = "render";
				}

				// 通过sid找到mid，再调用
				String sql = "select max(mid) from FPF_IRS_SUBJECT_MENU_MAP where sid=?";
				int mid = jdbcTemplate.queryForObject(sql, new Object[] { Integer.valueOf(sid) },Integer.class);
				menuTrack(String.valueOf(mid), menuIdTrack, menuTrack);
			}

//			p = Pattern.compile(".*/menu/([0-9]{1,11}).*");
//			m = p.matcher(uri);
//
//			if (m.matches()) {
//				logFlag = true;
//				String sid = m.group(1);
//				menuTrack(sid, menuIdTrack, menuTrack);
//			}
			
			//菜单路径后面都会添加menuid参数
			String menuId = request.getParameter("menuid");
			if (!StringUtils.isEmpty(menuId)) {
				logFlag = true;
				menuTrack(menuId, menuIdTrack, menuTrack);
			}

			if (logFlag) {
				User user = (User) request.getSession(false).getAttribute("user");
				String ip = Util.getRemoteAddr(request);

				jdbcTemplate.update("insert into FPF_VISITLIST(loginname,area_id,track_mid,track,ipaddr,uri,param,opertype,opername,app_serv,dur_time) values(?,?,?,?,?,?,?,?,?,?,?)",
						new Object[] { user.getId(), user.getCityId(), menuIdTrack.toString(), menuTrack.toString(), ip, uri, param.length() > 64 ? param.substring(1, 64) : param, opertype, opername, request.getLocalAddr() + ":" + request.getLocalPort(), during });
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handle) throws Exception {
		try {
			String uri = request.getRequestURI();

			Pattern p = Pattern.compile(report_regex);
			Matcher m = p.matcher(uri);
			if (m.matches()) {
				String sid = m.group(1);
				request.setAttribute("REPORT_DURING_" + sid, Long.valueOf(System.currentTimeMillis()));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	/**
	 * 根据mid找到上级的轨迹
	 * 
	 * @param p_menuId
	 * @param menuIdTrack
	 * @param menuTrack
	 * @throws SQLException
	 */
	protected List menuIdTree(String mid) throws SQLException {

		String sqlMenuTrack = "WITH RPL (id, name , pid , level) AS" + " (" + " SELECT ROOT.menuitemid, ROOT.menuitemtitle ,ROOT.parentid , 1 FROM FPF_SYS_MENU_ITEMs ROOT WHERE ROOT.menuitemid = ?" + " UNION  ALL"
				+ " SELECT  CHILD.menuitemid, CHILD.menuitemtitle,CHILD.parentid, level+1 FROM RPL PARENT, FPF_SYS_MENU_ITEMs CHILD WHERE PARENT.pid = CHILD.menuitemid" + " )" + " SELECT id mid, name FROM RPL order by level";

		return jdbcTemplate.queryForList(sqlMenuTrack, new Object[] { Integer.valueOf(mid) });
	}

	/**
	 * 根据mid找到上级的轨迹
	 * 
	 * @param p_menuId
	 * @param menuIdTrack
	 * @param menuTrack
	 * @throws SQLException
	 */
	protected void menuTrack(String mid, StringBuilder menuIdTrack, StringBuilder menuTrack) throws SQLException {

		List p_menuId = menuIdTree(mid);
		if (p_menuId.size() > 0) {
			for (int j = p_menuId.size() - 1; j >= 0; j--) {
				Map map1 = (Map) p_menuId.get(j);
				menuIdTrack.append(map1.get("mid"));
				menuIdTrack.append("-");
				menuTrack.append(map1.get("name"));
				menuTrack.append("-");
			}
			menuTrack.deleteCharAt(menuTrack.length() - 1);
			menuIdTrack.deleteCharAt(menuIdTrack.length() - 1);
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String uri = "/mvc/menu/98090685";

		Pattern p = Pattern.compile(".*/menu/([0-9]{1,11}).*");
		Matcher m = p.matcher(uri);

		System.out.println(m.matches());

		System.out.println(m.group(1));

	}

}
