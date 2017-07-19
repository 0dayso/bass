package com.asiainfo.hbbass.app.action;

import java.io.File;
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

import com.asiainfo.hbbass.common.action.FileManageAction;
import com.asiainfo.hbbass.common.file.ExcelWriter;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;
import com.asiainfo.hbbass.irs.report.core.Report;

/**
 * 
 * 
 * @author Mei Kefu
 * @date 2009-12-21
 */
public class RptNaviAtion extends Action {

	private static Logger LOG = Logger.getLogger(RptNaviAtion.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();

	@SuppressWarnings("rawtypes")
	public void init(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		String pid = request.getParameter("pid");
		SQLQuery sqlQuery = null;
		if (pid == null || pid.length() == 0) {
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web", false);
			String userid = (String) request.getSession().getAttribute("loginname");
			String sql = "select a.id,a.name,value(a.desc,'') desc,'自定义报表' pname from FPF_IRS_SUBJECT a where user_id='" + userid + "' and kind='动态' order by lastupd desc with ur";
			LOG.debug(userid + " " + " SQL :" + sql);
			response.getWriter().print(sqlQuery.query(sql));
		} else {
			/**
			 * {name:"",subjects:[{id:"",name:""},{name:"",subjects:[{id:"",name
			 * :""}]}]}
			 */

			Map result = getSubjects(pid);

			String res = jsonHelper.write(result);
			LOG.debug(res);
			
			response.getWriter().print(res);
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ActionMethod(isLog = false)
	protected Map getSubjects(String pid) {

		// {packageName:"",elements:[]}
		/*
		 * elements:[ {subject} ->
		 * {id:"subject_id",name:"",desc:"",kind:"动态,配置,手工",uri:""} ,{package}->
		 * {subjects:[{subject}],id:"package_id",name:"",desc:"",type:"平板"}
		 * ,{package}-> {type:"下拉框",id:"package_id",name:"",desc:""} ]
		 */
		Map result = new HashMap();

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("jsonObject", "web", false);
		String sql1 = "select id,name,desc,sort,type from FPF_IRS_PACKAGE where (PID=" + pid + " or id=" + pid + ") and type!='下线' order by sort,id with ur";

		try {
			List elementMaps = (List) sqlQuery.querys(sql1);

			List elements = new ArrayList();
			String sql = "select a.id,a.name,value(a.desc,'') desc,uri,mt,kind,sort,a.status from FPF_IRS_SUBJECT a left join (select sid,max(case when code ='URI' then value end) uri,max(case when code ='MaxTime' then value end) mt from FPF_IRS_SUBJECT_EXT where code in ('MaxTime','URI') group by sid) c on a.id=c.sid where a.PID=@id and a.status !='下线' order by sort,id with ur";
			for (int i = 0; i < elementMaps.size(); i++) {
				Map elemMap = (Map) elementMaps.get(i);

				String packageId = String.valueOf(elemMap.get("id"));
				String packageType = (String) elemMap.get("type");
				if (packageId.equalsIgnoreCase(pid)) {// 直接挂在顶级package下面的

					List topSubjects = (List) sqlQuery.querys(sql.replaceAll("@id", packageId));
					result.put("packageName", elemMap.get("name"));// 顶级package的Name
					for (int j = 0; j < topSubjects.size(); j++) {
						elements.add(topSubjects.get(j));
					}
				} else if ("下拉框".equalsIgnoreCase(packageType) && !packageId.equalsIgnoreCase(pid)) {// 下拉框类型
					elements.add(elemMap);
				} else if (!packageId.equalsIgnoreCase(pid)) {// 子package类型
					elemMap.put("subjects", sqlQuery.querys(sql.replaceAll("@id", packageId)));
					elements.add(elemMap);
				}

			}

			// 对elements按照顶级packageId的sort来排序，就是挂在顶级package下面的subject和packge混合排序
			for (int i = 0; i < elements.size(); i++) {
				for (int j = elements.size() - 1; j > i; j--) {
					Map map1 = (Map) elements.get(j);
					Map map2 = (Map) elements.get(j - 1);
					int key1 = ((Integer) map1.get("sort")).intValue();
					int key2 = ((Integer) map2.get("sort")).intValue();
					if (key1 < key2) {
						elements.set(j, map2);
						elements.set(j - 1, map1);
					}
				}
			}

			result.put("elements", elements);

		} catch (SQLException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			sqlQuery.release();
		}

		return result;
	}

	@ActionMethod(isLog = false)
	public void logStat(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mid = request.getParameter("mid");

		String sql = " select opername id" + " ,count(case when opertype in ('query','render') and substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) qum"
				+ " ,count(case when opertype='down' and substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) dwm" + " ,count(distinct case when substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) lgm"
				+ " ,count(case when opertype in ('query','render') then loginname else null end) qu,count(case when opertype='down' then loginname else null end)dw" + " ,count(distinct loginname) lg " + " from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid " + " where track_mid like '%-" + mid
				+ "' and opertype in ('query','render','down') and value(opername,'')!='' and group_id<>'26020'" + " group by opername with ur";

		LOG.debug("SQL:" + sql);
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web");

		response.getWriter().print(sqlQuery.query(sql));
	}

	/*
	 *  这个方法在这个类中比较扭曲，需要提供一个query方法，时间紧张暂时不实现
	 * 
	 * Report对象跟RepMeta对象类似一个是处理配置报表一个处理KPI报表，应该重构对象抽取出通用的对象，然后两个实现
	 * ConfReportAction与DynamicReportAction两个Action也是类似应该合并成一个
	 * ，然后新建一个Service工厂提供对应不同的实现 两个default.htm也是有问题的，应该是基于不同的模板来开发，比如增加可编辑的一种类型
	 */
	@SuppressWarnings("rawtypes")
	public void down(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String pid = request.getParameter("pid");

		Map result = getSubjects(pid);
		String fileName = (String) result.get("packageName");
		List subjects = (List) result.get("elements");
		String path = System.getProperty("user.dir") + "/";
		File tempFile = new File(path + fileName + "_打包.xls");
		try {
			ExcelWriter book = new ExcelWriter();
			book.createBook(tempFile);
			Connection conn = ConnectionManage.getInstance().getDWConnection();
			try {
				for (int i = 0; i < subjects.size(); i++) {
					Map sub = (Map) subjects.get(i);

					Integer sid = (Integer) sub.get("id");
					Report rpt = new Report(String.valueOf(sid));

					List target = new ArrayList();
					FileManageAction.genResult(target, rpt.genSQL(), rpt.genDownHeader(), true, conn);
					try {
						book.writerSheet(target, rpt.getName());
					} catch (Exception e) {
						e.printStackTrace();
					}
					target = null;
					rpt = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
			book.closeBook();

			FileManageAction.outFile(response, tempFile);
		} finally {
			tempFile.deleteOnExit();
		}
	}
}
