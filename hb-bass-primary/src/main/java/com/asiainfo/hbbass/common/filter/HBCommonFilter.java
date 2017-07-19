package com.asiainfo.hbbass.common.filter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 
 * 判断没有url的权限
 * 
 * 暂时先判断irs的
 * 
 * @author Mei Kefu
 * @date 2009-8-7
 * @date 2010-12-10
 */
@SuppressWarnings("unchecked")
public class HBCommonFilter implements Filter {

	private static Logger LOG = Logger.getLogger(HBCommonFilter.class);

	private static String LOG_ERR_PAGE = "/hbbass/error/loginerror.jsp";

//	private static String EXCEPT_PATH_REGEX = ".*(/hbirs/service|/hbapp/resources|/hbbass/(report/config|getpasswd/ngbass)|" + LOG_ERR_PAGE + ").*";
	
	private static String EXCEPT_PATH_REGEX = "";

	@SuppressWarnings("rawtypes")
	private static Map appNameMapMenu = new HashMap();

	static {
		appNameMapMenu.put("ChannelD", "967");
		appNameMapMenu.put("ChannelM", "968");
		appNameMapMenu.put("BureauD", "967");
		appNameMapMenu.put("BureauM", "968");
		appNameMapMenu.put("GroupcustD", "997");
		appNameMapMenu.put("GroupcustM", "998");
		appNameMapMenu.put("CollegeD", "610");
		appNameMapMenu.put("CollegeM", "611");
		appNameMapMenu.put("EntGridD", "1028");
	}

	@SuppressWarnings({ "rawtypes", "unused" })
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		String uri = req.getRequestURI();
		// 非资源文件
		// 不是资源文件都记录日志，有部分还需要判断权限
		if (!uri.matches(".*\\.(jpg|jpeg|bmp|gif|png|tng|doc|docx|xsl|xslx|ppt|pptx|rar|zip|xml|txt|csv|css|js|swf)")) {

			// 一、字符集
			// 转字符集/hbbass不用
//			if (!uri.startsWith("/hbbass")) {
//				if (req.getHeader("Request-Type") != null && "ajax".equalsIgnoreCase(req.getHeader("Request-Type"))) {
//					req.setCharacterEncoding("utf-8");
//					res.setContentType("text/html;charset=utf-8");
//				} else {
//					req.setCharacterEncoding("GBK");
//					// response.setCharacterEncoding("UTF-8");
//					res.setContentType("text/html;charset=GBK");
//				}
//			}

			// 二、是否登录验证
			// 判断是否需要登录
			boolean nologin = false;

			if (req.getSession().getAttribute("nologin") != null || req.getParameter("nologin") != null) {
				nologin = true;
				req.getSession().setAttribute("nologin", Boolean.valueOf(nologin));
			}

			if (nologin) {
				if (req.getParameter("loginname") != null && req.getSession().getAttribute("loginname") == null) {
					req.getSession().setAttribute("loginname", req.getParameter("loginname"));

					if (req.getParameter("cityId") != null && req.getSession().getAttribute("area_id") == null) {
						req.getSession().setAttribute("area_id", req.getParameter("cityId"));
					}
				}
			}

			if (!(nologin || req.getSession().getAttribute("loginname") != null || uri.matches(EXCEPT_PATH_REGEX))) {

				res.sendRedirect(LOG_ERR_PAGE);
				return;
			} else if (!uri.matches(EXCEPT_PATH_REGEX)) {

				/**  */
				String param = null;
				if ("get".equalsIgnoreCase(req.getMethod())) {
					param = (req.getQueryString() != null ? req.getQueryString() : "");
				} else if ("post".equalsIgnoreCase(req.getMethod())) {
					Map params = req.getParameterMap();
					StringBuilder sb = new StringBuilder();
					for (Iterator iterator = params.entrySet().iterator(); iterator.hasNext();) {
						Map.Entry entry = (Map.Entry) iterator.next();
						sb.append("&").append(entry.getKey()).append("=").append(((String[]) entry.getValue())[0]);
					}
					param = sb.toString();
				}

				String fullUrl = uri + "?" + param;

				String userId = (String) req.getSession().getAttribute("loginname");
				String areaId = (String) req.getSession().getAttribute("area_id");

				Connection conn = null;
				SQLQuery sqlQuery = null;

				try {
					// 菜单轨迹全局量，因为有可能权限里面已经有了
					StringBuilder menuTrack = new StringBuilder();
					StringBuilder menuIdTrack = new StringBuilder();

					String sid = "";// subjectId
					String mid = "";// 菜单id

					// 一、权限判断
					if (fullUrl.matches(".*/hbirs/action/confReport.*method=render.*") && !fullUrl.matches(".*/hbirs/action/confReport.*except=true.*")) {
						LOG.debug("进去权限判断filter,full url" + fullUrl);

						sid = getParameter(req, fullUrl, "sid");

						conn = ConnectionManage.getInstance().getWEBConnection();
						sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, SQLQueryContext.webJndiName, true, conn);

						List menuIds = menuIds(sqlQuery, sid);// 根据sid找出来的mid
						Set hasResSet = hasResources(sqlQuery, userId);// 找出用户所有具有的资源menuId

						boolean hasPrem = false;
						// 1.判断mid是否在当前已有的menuid中
						for (int i = 0; i < menuIds.size(); i++) {
							Map map = (Map) menuIds.get(i);
							Integer menu_id = (Integer) map.get("mid");
							mid = String.valueOf(menu_id);// 给全局的mid赋值，但是只会赋值最后一个，跟这里的业务无关
							if (hasResSet.contains(menu_id)) {
								LOG.debug("原始id：" + menu_id + "在权限表中");
								hasPrem = true;
								break;
							}
						}

						// 2.不在menuid中就判断它的权限是否 access 为0
						// 还要判断上级menuid在已有的menuid中
						if (!hasPrem) {
							for (int i = 0; i < menuIds.size(); i++) {

								if (i > 0) {// 第一次已经初始化啦
									menuTrack = new StringBuilder();
									menuIdTrack = new StringBuilder();
								}

								Map map = (Map) menuIds.get(i);
								Integer menu_id = (Integer) map.get("mid");
								Integer acc = (Integer) map.get("acc");

								if (0 == acc) {// 只需要判断access_token是0的（共享权限）
									List p_menuId = menuIdTree(sqlQuery, String.valueOf(menu_id));
									if (p_menuId.size() > 2) {// 等于2的时候就是2级菜单，当二级菜单为0是就是全部都有权限
										for (int j = 1; j < p_menuId.size() - 1; j++) {
											Map map1 = (Map) p_menuId.get(j);

											Integer mid1 = (Integer) map1.get("mid");
											Integer acc1 = (Integer) map1.get("acc");

											if ((0 != acc1 && hasResSet.contains(mid1)) || (0 == acc1 && j == p_menuId.size() - 2) // 上级id也是0
																																	// 就需要判断上上级
											) {
												hasPrem = true;
												break;
											}
										}
										menuTrack(p_menuId, menuIdTrack, menuTrack);
									} else {
										hasPrem = true;
										break;
									}
								}
							}
						}

						if (!hasPrem) {// 没有权限的直接转到“没有权限”提示（还可以直接申请权限）
							String sql4 = "select t0.userid,username,mobilephone,'user' kind,group_name from FPF_USER_USER t0,FPF_USER_GROUP t1,FPF_USER_GROUP_MAP t2 where t0.userid=t2.userid and t1.group_id=t2.group_id and t0.userid='" + userId + "'" + " union all"
									+ " select userid,username,mobilephone,'mgr' kind,'' group_name  from FPF_USER_USER where userid!='admin' and userid in (" + " select userid from FPF_USER_GROUP_MAP where length(group_id)<=2" + " ) and cityid = (select cityid from FPF_USER_USER where userid='" + userId + "')";

							List list = (List) sqlQuery.querys(sql4);

							String result = "<html><head>" + "<meta http-equiv='Content-Type' content='text/html; charset=GBK' />" + "<script type='text/javascript' src='/hb-bass-navigation/hbapp/resources/js/default/default.js'></script>" + "<script type='text/javascript' src='/hb-bass-navigation/hbapp/conf/conf_perm_tip.js'></script>" + "<script>"
									+ "var user = eval(" + JsonHelper.getInstance().write(list) + ");" + "var menu = '" + menuTrack.toString() + "';" + "</script></head><body></body></html>";
							res.getWriter().print(result);
							return;
						}
					}

					//日志放在defaultFilter中记录
					// 二、日志记录
//					String isLogStr = request.getParameter("isLog");
//					boolean isLog = !"false".equalsIgnoreCase(isLogStr);// 指定是否使用日志，这个很扭曲，日志记录一直有些问题

					// 特殊不记录日志判断
					// 1./hbirs/action/bir 的method=suggest的时候

//					if (uri != null && uri.length() > 1 && !uri.matches(".*/hbirs/action/(watermark|log|frame).*") && isLog) {
//						if (sid.length() == 0) {
//							sid = getParameter(req, fullUrl, "sid");
//						}

						// 通过sid找到优先于跟在链接后面的
//						if (sid.length() > 0 && mid.length() == 0) {// 如果mid为空，但是sid不为空，可以查找一下mid
//							if (sqlQuery == null) {
//								if (conn == null) {
//									conn = ConnectionManage.getInstance().getWEBConnection();
//								}
//								sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, SQLQueryContext.webJndiName, true, conn);
//							}
//
//							List menuIds = menuIds(sqlQuery, sid);
//							if (menuIds.size() > 0) {
//								Map map = (Map) menuIds.get(0);
//								Integer menu_id = (Integer) map.get("mid");
//								mid = String.valueOf(menu_id);
//							}
//						}

//						if (mid.length() == 0) {
//							mid = getParameter(req, fullUrl, "mid");
//						}

//						String opertype = "";
//						String opername = sid;// 有sid的话就是使用sid
//						// 2.记录/hbirs/(service|action)的方法日志
//						// ，把这个调整到得到mid前面，得到KPI指标的时候直接定位mid
//						if (uri.matches(".*(hbirs|hbapp/kpiportal).*")) {
//							opertype = req.getParameter("method");
//
//							if (req.getParameter("promo") != null || param.matches(".*promo=true.*")) {// 是否是从推荐过来的
//								opertype = "promo";
//							}
//
//							if (req.getParameter("kw") != null) {
//								opername = req.getParameter("kw");
//								if (mid.length() == 0) {
//									mid = "353";// 直接定位到经分信息检索
//								}
//							} else if (req.getParameter("kpis") != null || req.getParameter("zbcode") != null) {
//								if (req.getParameter("kpis") != null) {
//									opername = req.getParameter("kpis");
//								} else if (req.getParameter("zbcode") != null) {
//									opername = req.getParameter("zbcode");
//								}
//
//								if (mid.length() == 0) {// 当有KpiId,uri
//														// param中又没有跟随mid的时候，直接赋给相关KPI的菜单id
//									String appName = req.getParameter("appName");
//									mid = String.valueOf(appNameMapMenu.get(appName) == null ? appNameMapMenu.get("ChannelD") : appNameMapMenu.get(appName));
//									String kind = req.getParameter("kind");
//									if (kind != null && !kind.equals("")) {
//										if ("ChannelD".equals(appName))
//											mid = "1833";
//										if ("ChannelM".equals(appName))
//											mid = "1834";
//									}
//								}
//							}
//						}

						// 1.有菜单ID的记录、菜单轨迹没有初始化
//						if (mid.length() > 0 && menuTrack.length() == 0)/*
//																		 * (mid.
//																		 * length
//																		 * ()>0
//																		 * ||
//																		 * fullUrl
//																		 * .
//																		 * matches
//																		 * (
//																		 * ".*mid=\\d+.*"
//																		 * ))
//																		 */{
//							if (sqlQuery == null) {
//								if (conn == null) {
//									conn = ConnectionManage.getInstance().getWEBConnection();
//								}
//								sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, SQLQueryContext.webJndiName, true, conn);
//							}
//
//							menuTrack(menuIdTree(sqlQuery, mid), menuIdTrack, menuTrack);
//						}

//						if (conn == null) {
//							conn = ConnectionManage.getInstance().getWEBConnection();
//						}
//						String sql = "insert into FPF_VISITLIST(loginname,area_id,track_mid,track,ipaddr,uri,param,opertype,opername,app_serv) values(?,?,?,?,?,?,?,?,?,?)";
//
//						PreparedStatement ps = conn.prepareStatement(sql);
//						ps.setString(1, userId);
//						ps.setInt(2, Integer.valueOf(areaId=areaId==null?"0":areaId));
//						ps.setString(3, menuIdTrack.toString());
//						ps.setString(4, menuTrack.toString());
//						ps.setString(5, Util.getRemoteAddr(req));
//						ps.setString(6, uri);
//						ps.setString(7, param.length() > 64 ? param.substring(1, 64) : param);
//						ps.setString(8, opertype);
//						ps.setString(9, opername);
//						ps.setString(10, req.getLocalAddr() + ":" + req.getLocalPort());
//						
//						ps.execute();
//					}

				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					if (sqlQuery != null)
						sqlQuery.release();
					ConnectionManage.getInstance().releaseConnection(conn);
				}
			}
		}
		chain.doFilter(req, res);
	}

	/**
	 * 找到用户有的所有有权限的menuid
	 * 
	 * @param sqlQuery
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("rawtypes")
	protected Set hasResources(SQLQuery sqlQuery, String userId) throws SQLException {
		// 获得该用户的所有权限ID
		String hasMenuIds = "select distinct int(resourceid) resid from FPF_SYS_MENUITEM_RIGHT smr," + " ( " + " select role_id from FPF_USER_GROUP_MAP ugm,FPF_GROUP_ROLE_MAP grm where ugm.userid='" + userId + "' and ugm.group_id=grm.group_id" + " union all" + " select roleid role_id from FPF_USER_ROLE_MAP where userid='" + userId
				+ "') roles" + " where smr.operatorid=role_id";

		List resource = (List) sqlQuery.querys(hasMenuIds);

		Set hasResSet = new HashSet();

		for (int i = 0; i < resource.size(); i++) {

			Map map = (Map) resource.get(i);

			Integer resid = (Integer) map.get("resid");

			hasResSet.add(resid);
		}

		return hasResSet;
	}

	/**
	 * 根据sid找到mid
	 * 
	 * @param sqlQuery
	 * @param sid
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("rawtypes")
	protected List menuIds(SQLQuery sqlQuery, String sid) throws SQLException {
		// 取所有的irs的id
		String sqlIdsReg = "select trim(char(t1.id))||'|'||trim(char(value(t1.pid,0)))||'|'||trim(char(value(t2.pid,0))) reg from FPF_IRS_SUBJECT t1 left join FPF_IRS_PACKAGE t2 on t1.pid=t2.id where t1.id=" + sid;

		List subjectIds = (List) sqlQuery.querys(sqlIdsReg);

		String idsReg = "0";
		if (subjectIds.size() == 1) {
			Map map = (Map) subjectIds.get(0);
			idsReg = String.valueOf(map.get("reg"));
		}

		String allMenuUrl = "select menuitemid mid,accesstoken acc,url from FPF_SYS_MENU_ITEM where parentid!=1111 and url is not null and length(url)>3 with ur";
		List allMenuId = (List) sqlQuery.querys(allMenuUrl);
		List<Map<?, ?>> menuIds = new ArrayList<Map<?, ?>>();
		// 0.判断是否是它的menuid

		for (int i = 0; i < allMenuId.size(); i++) {
			Map map = (Map) allMenuId.get(i);
			String url = (String) map.get("url");

			if (url.matches(".*(s|p)id=(" + idsReg + ").*")) {
				menuIds.add(map);
			}
		}

		return menuIds;
	}

	/**
	 * 根据mid找到上级的轨迹
	 * 
	 * @param p_menuId
	 * @param menuIdTrack
	 * @param menuTrack
	 * @throws SQLException
	 */
	@SuppressWarnings("rawtypes")
	protected List menuIdTree(SQLQuery sqlQuery, String mid) throws SQLException {

		String sqlMenuTrack = "WITH RPL (id, name , pid , level,accesstoken) AS" + " (" + " SELECT ROOT.menuitemid, ROOT.menuitemtitle ,ROOT.parentid , 1,accesstoken FROM FPF_SYS_MENU_ITEM ROOT WHERE ROOT.menuitemid = @resId" + " UNION  ALL"
				+ " SELECT  CHILD.menuitemid, CHILD.menuitemtitle,CHILD.parentid, level+1,CHILD.accesstoken FROM RPL PARENT, FPF_SYS_MENU_ITEM CHILD WHERE PARENT.pid = CHILD.menuitemid" + " )" + " SELECT id mid, accesstoken acc, name FROM RPL order by level";

		List p_menuId = (List) sqlQuery.querys(sqlMenuTrack.replaceAll("@resId", String.valueOf(mid)));

		return p_menuId;
	}

	/**
	 * 根据mid找到上级的轨迹
	 * 
	 * @param p_menuId
	 * @param menuIdTrack
	 * @param menuTrack
	 * @throws SQLException
	 */
	@SuppressWarnings("rawtypes")
	protected void menuTrack(List p_menuId, StringBuilder menuIdTrack, StringBuilder menuTrack) throws SQLException {

		if(p_menuId!=null&&p_menuId.size()>0)
		{
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
	 * 
	 * @param request
	 * @param oriStr
	 * @param key
	 * @return
	 */
	protected String getParameter(HttpServletRequest request, String oriStr, String key) {
		if (request.getParameter(key) != null) {
			return request.getParameter(key);
		} else if (oriStr.indexOf(key + "=") > 0) {
			String result = oriStr.substring(oriStr.indexOf(key) + key.length() + 2);
			result = result.substring(0, result.indexOf("&") > 0 ? result.indexOf("&") : result.length());
			return result.intern();
		} else {
			return "";
		}
	}

	public void init(FilterConfig config) throws ServletException {

		String errPage = config.getInitParameter("LOG_ERR_PAGE");

		if (errPage != null && errPage.length() > 0) {
			LOG_ERR_PAGE = errPage;
		}
	}

	public void destroy() {

	}

	public static void main(String[] args) {

	}
}
