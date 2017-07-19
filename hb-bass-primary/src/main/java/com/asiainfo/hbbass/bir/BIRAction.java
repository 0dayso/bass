package com.asiainfo.hbbass.bir;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2010-2-26
 */
public class BIRAction extends Action {

	private static Logger LOG = Logger.getLogger(BIRAction.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();

	public void search(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String kw = request.getParameter("kw");

		String[] segkw = Segment.segment(kw).split(",");

		StringBuilder condi = new StringBuilder();

		StringBuilder jsonSegKw = new StringBuilder();

		for (int i = 0; i < segkw.length; i++) {
			if (segkw[i].length() > 0) {

				if (condi.length() > 0)
					condi.append(",");

				condi.append("'").append(segkw[i]).append("'");

				if (jsonSegKw.length() > 0)
					jsonSegKw.append(",");

				jsonSegKw.append("'").append(segkw[i]).append("'");
			}
		}
		
		//指标查询
		String sql = "select * from (select a.id id , a.name name, b.kpi_des desc, row_number() over(partition by a.id order by b.kpi_code) num " +
					" from boc_indicator_menu a , kpi_def b where a.DAILY_CODE= b.KPI_CODE or a.DAILY_CUMULATE_CODE= b.KPI_CODE " +
					" ) where num =1 and name like '%" + kw + "%'";

		String type = request.getParameter("type");
		
		//根据报表名称和报表描述模糊查询
		if ("subject".equalsIgnoreCase(type)) {
			sql = "select a.resource_id id, a.resource_uri uri, resource_name name, value(a.resource_desc,'') desc, value(m.name||b.name||'/'||a.resource_name, '') path from fpf_irs_resource a " +
					" left join fpf_irs_resource_sort b on a.irs_resource_sort_id=b.id " +
					" left join (select c.url,p.menuitemtitle||'/'||c.menuitemtitle||'/报表中心/' name from fpf_sys_menu_items p, fpf_sys_menu_items c where p.menuitemid= c.parentid) m on m.url like '%/roleAdapt/index/'||a.menu_id " +
					" where a.type_id=2 and a.state='在用' and (a.resource_name like '%" + kw + "%' or a.resource_desc like '%" + kw + "%')";
		}
		if("menu".equalsIgnoreCase(type)){
			sql="select menuitemid,menuitemtitle,url,'菜单' kind from FPF_SYS_MENU_ITEMS where state<>0 and menuitemtitle like '%"+kw+"%'";
		}

		LOG.debug("SQL:" + sql);
		if (condi.length() > 0) {
			SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web");

			String sb = (String) sqlQuery.query(sql);
			LOG.debug("sb:" + sb);
			PrintWriter out = response.getWriter();

			out.print("{'segment':[");
			out.print(jsonSegKw.toString());
			out.print("],'res':");
			out.print(sb.toString());
			out.print("}");
		}
	}

	@SuppressWarnings("rawtypes")
	@ActionMethod(isLog = false)
	public void suggest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String sql = "select distinct name from FPF_IRS_INDICATOR with ur";
		LOG.debug("SQL:" + sql);
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "web");

		List list = (List) sqlQuery.query(sql);

		List<Object> newList = new ArrayList<Object>();
		for (int i = 0; i < list.size(); i++) {
			String a = ((String[]) list.get(i))[0];
			newList.add(a);
		}

		LOG.debug("sb:" + jsonHelper.write(newList));
		response.getWriter().print(jsonHelper.write(newList));

	}
	
	//用户菜单权限
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void checkMenuRight(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String userId = (String) request.getSession().getAttribute("loginname");
		String menuId = request.getParameter("id");
		boolean flag = false;
		//查询用户是否属于管理员用户组
		String sql = "select * from fpf_user_group_map where userid='" + userId + "' and group_id='1'";
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "web");
		List list = (List) sqlQuery.query(sql);
		if(list != null && list.size()>0){
			LOG.info("用户：" + userId + "属于管理员用户组");
			flag = true;
		}else{
			LOG.info("用户：" + userId + "不属于管理员用户组");
			String menuSql = "select * from FPF_SYS_MENU_ITEMS a," +
					" (select distinct user_id,menu_id from " +
					" (select a.userid user_id,d.resourceid menu_id from FPF_USER_USER a,FPF_user_group_map b, " +
					" fpf_group_role_map c ,FPF_sys_menuitem_right d where  a.userid=b.userid and b.group_id = c.group_id " +
					" and c.role_id = d.operatorid union all select user_id,menu_id from FPF_SYS_MENUITEM_USER ) ) b " +
					" where a.menuitemid = b.menu_id and b.user_id= '" + userId + "' and  b.menu_id='" + menuId +"'";
			SQLQuery sqlQuery1 = SQLQueryContext.getInstance().getSQLQuery("list", "web");
			List list1 = (List) sqlQuery1.query(menuSql);
			if(list1 != null && list1.size()>0){
				LOG.info("用户：" + userId + "有菜单-" + menuId + "权限");
				flag = true;
			}else{
				LOG.info("用户：" + userId + "没有菜单-" + menuId + "权限");
			}
		}
		HashMap map = new HashMap();
		map.put("status", flag);
		LOG.info("sb:" + jsonHelper.write(map));
		response.getWriter().print(jsonHelper.write(map));
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	public void checkSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user_id = (String) request.getSession().getAttribute("loginname");
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String mid = "";
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "web");
		SQLQuery sqlQuery1 = SQLQueryContext.getInstance().getSQLQuery("json", "web");
		boolean flag = false;
		String menuSql = "select mid from FPF_IRS_SUBJECT_MENU_MAP where sid = "+id+" ";
		List list2 = (List) sqlQuery.query(menuSql);
		mid = ((String[]) list2.get(0))[0];
		String sql = "select menuitemid\n" +
						"  from FPF_SYS_MENU_ITEM\n" + 
						" where (accesstoken = 0 or\n" + 
						"       menuitemid in\n" + 
						"       (select distinct int(resourceid)\n" + 
						"           from FPF_SYS_MENUITEM_RIGHT smr,\n" + 
						"                (select role_id\n" + 
						"                   from FPF_USER_GROUP_MAP ugm, FPF_GROUP_ROLE_MAP grm\n" + 
						"                  where ugm.userid = '"+user_id+"'\n" + 
						"                    and ugm.group_id = grm.group_id\n" + 
						"                 union all\n" + 
						"                 select roleid role_id from FPF_USER_ROLE_MAP where userid = '"+user_id+"') roles\n" + 
						"          where smr.operatorid = role_id))\n" + 
						"   and menuitemid = "+mid+"";
		LOG.info("SQL:" + sql);
		String sb = (String) sqlQuery1.query(sql);
		if(sb!=null){
			if(sb.length()>0 && !sb.equals("[]")){
				flag = true;
			}
		}
//		if(kind.equalsIgnoreCase("配置")){
//			String menuSql = "select mid from FPF_IRS_SUBJECT_MENU_MAP where sid = "+id+" ";
//			List list2 = (List) sqlQuery.query(menuSql);
//			mid = ((String[]) list2.get(0))[0];
//		}
//		boolean flag = false;
//		String menuTypeSql = "select accessToken from FPF_SYS_MENU_ITEM where menuitemid = "+mid+"";
//		List list3 = (List) sqlQuery2.query(menuTypeSql);
//		String accessToken = ((String[]) list3.get(0))[0];
//		if(!"".equals(accessToken) && accessToken.equals("0")){
//			flag = true;
//		}else{
//			String sql = "select a.userid" +
//					"  from FPF_USER_USER a " + 
//					" inner join FPF_USER_GROUP_MAP b on a.userid = b.userid" + 
//					" inner join FPF_GROUP_ROLE_MAP c on c.group_id = b.group_id" + 
//					" inner join FPF_SYS_MENUITEM_RIGHT d on c.role_id = d.operatorid" + 
//					" where a.userid = '"+user_id+"'" + 
//					"   and resourceid = '"+mid+"'";
//			String sql1 = "select * from FPF_SYS_MENUITEM_USER where user_id = '"+user_id+"' and menu_id = "+mid+"";
//			LOG.info("SQL:" + sql);
//			LOG.info("SQL:" + sql1);
//			
//			String sb = (String) sqlQuery1.query(sql);
//			String sb1 = (String) sqlQuery3.query(sql1);
//			
//			if(sb!=null){
//				if(sb.length()>0 && !sb.equals("[]")){
//					flag = true;
//				}
//			}
//			if(sb1!=null){
//				if(sb1.length()>0 && !sb1.equals("[]")){
//					flag = true;
//				}
//			}
//		}
		HashMap map = new HashMap();
		map.put("status", flag);
		LOG.info("sb:" + jsonHelper.write(map));
		response.getWriter().print(jsonHelper.write(map));

	}
	
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	public void checkSearchByItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user_id = (String) request.getSession().getAttribute("loginname");
		String mid = request.getParameter("id");
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "web");
		SQLQuery sqlQuery1 = SQLQueryContext.getInstance().getSQLQuery("json", "web");
		boolean flag = false;
		String sql = "select menuitemid\n" +
						"  from FPF_SYS_MENU_ITEM\n" + 
						" where (accesstoken = 0 or\n" + 
						"       menuitemid in\n" + 
						"       (select distinct int(resourceid)\n" + 
						"           from FPF_SYS_MENUITEM_RIGHT smr,\n" + 
						"                (select role_id\n" + 
						"                   from FPF_USER_GROUP_MAP ugm, FPF_GROUP_ROLE_MAP grm\n" + 
						"                  where ugm.userid = '"+user_id+"'\n" + 
						"                    and ugm.group_id = grm.group_id\n" + 
						"                 union all\n" + 
						"                 select roleid role_id from FPF_USER_ROLE_MAP where userid = '"+user_id+"') roles\n" + 
						"          where smr.operatorid = role_id))\n" + 
						"   and menuitemid = "+mid+"";
		LOG.info("SQL:" + sql);
		String sb = (String) sqlQuery1.query(sql);
		if(sb!=null){
			if(sb.length()>0 && !sb.equals("[]")){
				flag = true;
			}
		}
		HashMap map = new HashMap();
		map.put("status", flag);
		LOG.info("sb:" + jsonHelper.write(map));
		response.getWriter().print(jsonHelper.write(map));

	}

	public void auto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String term=request.getParameter("term");
		
		if(term==null||term.length()==0)return;
		
		String sql="select id,value from (select distinct name as id,name as value from FPF_IRS_INDICATOR where name like '%"+
		term.toUpperCase()+"%'"+ 
		"union select distinct name as id,name as value from FPF_IRS_SUBJECT where name like '%"+
		term.toUpperCase()+"%' ) tab fetch first 10 rows only";

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web");

		Object obj= sqlQuery.query(sql);
		
		response.getWriter().print(obj);
	}
	
	public void hotSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String sql="select substr(indicator,1,8) indicator,count(1) from FPF_bir_subject_indicator_segment where length(INDICATOR)>4 group by substr(indicator,1,8) order by 2 desc fetch first 5 rows only with ur";
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web");

		Object obj=sqlQuery.query(sql);
		
		response.getWriter().print(obj);
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
