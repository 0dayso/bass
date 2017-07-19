package com.asiainfo.hbbass.kpiportal.report;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

public class DynamicReportAction extends Action {

	private static Logger LOG = Logger.getLogger(DynamicReportAction.class);

	/*
	 * public void init(HttpServletRequest request, HttpServletResponse
	 * response)throws ServletException, IOException {
	 * 
	 * String pid = request.getParameter("pid"); SQLQuery sqlQuery =
	 * SQLQueryContext.getInstance().getSQLQuery("json","AiomniDB"); String
	 * sql=""; if(pid==null || pid.length()==0){
	 * 
	 * String userid = (String)request.getSession().getAttribute("loginname");
	 * sql=
	 * "select a.id,a.name,a.desc,b.name pname,b.type from FPF_IRS_SUBJECT a,FPF_IRS_PACKAGE b where a.pid=b.id and type='customize' and user_id='"
	 * +userid+"' and kind='dynamic' order by lastupd desc with ur";
	 * LOG.debug(userid+" "+" SQL :"+sql); } else { sql =
	 * "select a.id,a.name,a.desc,b.name pname,b.type from FPF_IRS_SUBJECT a,FPF_IRS_PACKAGE b where a.pid=b.id and type='manaul' and a.pid="
	 * +pid+" order by lastupd desc with ur"; LOG.debug(pid+" "+" SQL :"+sql); }
	 * response.getWriter().print(sqlQuery.query(sql)); }
	 */
	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		String pid = request.getParameter("pid");

		String ids = request.getParameter("ids");
		String appName = request.getParameter("appName");
		String names = request.getParameter("names");
		names = URLDecoder.decode(names, "utf-8");

		String subjectName = request.getParameter("name");
		subjectName = URLDecoder.decode(subjectName, "utf-8");
		String subjectDesc = request.getParameter("desc");
		subjectDesc = URLDecoder.decode(subjectDesc, "utf-8");
		String userid = (String) request.getSession().getAttribute("loginname");
		LOG.debug(names + " " + userid + " " + subjectName);
		String[] zbCode = ids.split(",");
		String[] zbName = names.split(",");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			int subjectId = -1;
			int packageId = -1;
			if (sid == null || sid.length() == 0) {// 新增

				if (pid == null || pid.length() == 0) {
					ps = conn.prepareStatement("select id from FPF_IRS_PACKAGE where user_id=? order by id fetch first 1 rows only with ur");
					ps.setString(1, userid);
					rs = ps.executeQuery();

					if (rs.next()) {
						packageId = rs.getInt(1);
					}
					rs.close();
					ps.close();
					if (packageId == -1) {
						ps = conn.prepareStatement("values nextval for irs_package_id");
						rs = ps.executeQuery();
						if (rs.next())
							packageId = rs.getInt(1);
						rs.close();
						ps.close();
						ps = conn.prepareStatement("insert into FPF_IRS_PACKAGE(id,name,user_id,type) values(?,?,?,'自定义')");
						ps.setInt(1, packageId);
						ps.setString(2, "自定义报表");
						ps.setString(3, userid);
						ps.execute();
						ps.close();
					}

				} else {
					packageId = Integer.parseInt(pid);
				}
				ps = conn.prepareStatement("values nextval for IRS_SUBJECT_id");
				rs = ps.executeQuery();
				if (rs.next())
					subjectId = rs.getInt(1);
				rs.close();
				ps.close();
				ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT(id,pid,name,desc,user_id,kind) values(?,?,?,?,?,'动态')");
				ps.setInt(1, subjectId);
				ps.setInt(2, packageId);
				ps.setString(3, subjectName);
				ps.setString(4, subjectDesc);
				ps.setString(5, userid);

				ps.execute();
				ps.close();

			} else {// 修改
				subjectId = Integer.parseInt(sid);
				ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT_INDICATOR where sid=?");
				ps.setInt(1, subjectId);
				ps.execute();
				ps.close();

				ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT_EXT where sid=?");
				ps.setInt(1, subjectId);
				ps.execute();
				ps.close();

				ps = conn.prepareStatement("update FPF_IRS_SUBJECT set name=?,desc=?,lastupd=current_timestamp where id=?");
				ps.setString(1, subjectName);
				ps.setString(2, subjectDesc);
				ps.setInt(3, subjectId);
				ps.execute();
				ps.close();
			}

			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT values(?,'100',?)");
			ps.setInt(1, subjectId);
			ps.setString(2, appName);
			ps.execute();
			ps.close();

			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_INDICATOR(sid,name,data_index,seq) values(?,?,?,?)");
			for (int i = 0; i < zbCode.length; i++) {
				ps.setInt(1, subjectId);
				ps.setString(2, zbName[i]);
				ps.setString(3, zbCode[i]);
				ps.setInt(4, i + 1);
				ps.execute();
			}
			ps.close();
			conn.commit();

		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();

		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);

		try {
			Object obj1 = sqlQuery.querys("select name,desc,value from FPF_IRS_SUBJECT a,FPF_IRS_SUBJECT_EXT b  where id=" + sid + " and id=sid and b.code='100' with ur");

			Object obj2 = sqlQuery.querys("select name,data_index from FPF_IRS_SUBJECT_INDICATOR where sid=" + sid + " order by seq with ur");

			Map result = new HashMap();

			result.put("subject", obj1);
			result.put("indicators", obj2);

			String str = JsonHelper.getInstance().write(result);
			LOG.debug(str);
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(str);

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			sqlQuery.release();
		}

	}

	public void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		RepMeta rep = new RepMeta(sid);
		rep.delete();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ActionMethod(isLog = false)
	public void appIndicators(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String appName = request.getParameter("appName");
		String zbKind = request.getParameter("zbKind");
		Map kpis = KPIPortalService.getAKPIMap(appName);

		LOG.debug(appName + " " + zbKind + " " + kpis.size());

		List result = new ArrayList();
		for (Iterator iterator = kpis.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry obj = (Map.Entry) iterator.next();

			if (obj.getValue() instanceof KPIEntity) {
				KPIEntity entity = (KPIEntity) obj.getValue();
				if (zbKind == null || zbKind.length() == 0 || (zbKind != null && zbKind.length() > 0 && entity.getKpiMetaData().getKind().equalsIgnoreCase(zbKind))) {
					Map data = new HashMap();
					data.put("key", entity.getKpiMetaData().getId());
					data.put("name", entity.getKpiMetaData().getName());
					result.add(data);
				}

			}
		}
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(JsonHelper.getInstance().write(result));
	}

	public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		String cityId = (String) request.getSession().getAttribute("area_id");
		String groupName = checkRight(request, response);
		if (groupName.length() > 0) {
			cityId = "0";// 各地市领导等用户组的用户开放全省权限
		}
		RepMeta rep = new RepMeta(sid);
		rep.setCityId(cityId);
		rep.initialize();
		LOG.debug(rep);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(rep.render());
	}

	/**
	 * 各地市领导等用户组的用户开放全省权限
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	public String checkRight(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userid = (String) request.getSession().getAttribute("loginname");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String groupName = "";
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("select a.userid,b.group_name from FPF_USER_USER a,FPF_USER_GROUP b,FPF_USER_GROUP_MAP c where a.userid=c.userid and b.group_id=c.group_id and (group_name like '%领导%' or group_name like '%市场经理%' or group_name like '%超级管理员%' or group_name like  '%工号管理员%') and a.userid='" + userid
					+ "' with ur");
			rs = ps.executeQuery();
			if (rs.next()) {
				groupName = rs.getString(2);
			}
			rs.close();
			ps.close();
			conn.commit();
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		return groupName;
	}

	/**
	 * 对象的参数映射
	 * 
	 * @param request
	 * @return
	 */
	@ActionMethod(isLog = false)
	protected RepMeta initRep(HttpServletRequest request) {
		String sid = request.getParameter("sid");
		String time = request.getParameter("time");
		String timeFrom = request.getParameter("time_from");
		String timeDetail = request.getParameter("timeDetail");
		String cityValue = request.getParameter("city");
		String isPre = request.getParameter("isPre");
		String isBefore = request.getParameter("isBefore");
		String isYear = request.getParameter("isYear");
		String isProgress = request.getParameter("isProgress");
		String cityId = (String) request.getSession().getAttribute("area_id");
		RepMeta rep = new RepMeta(sid);
		rep.setCityId(cityId);
		rep.initialize();
		rep.setTime(time);
		rep.setTimeFrom(timeFrom);
		rep.setTimeDetail(timeDetail);
		if (isPre != null) {
			rep.setPre(true);
		}
		if (isBefore != null) {
			rep.setBefore(true);
		}
		if (isYear != null) {
			rep.setYear(true);
		}
		if (isProgress != null) {
			rep.setProgress(true);
		}
		LOG.debug(rep);
		if (!"0".equalsIgnoreCase(cityValue))
			rep.root.value = cityValue;

		if (rep.getAppName().startsWith("Bureau")) {
			String bureauCountyValue = request.getParameter("county_bureau");
			String detailCounty = request.getParameter("detailCounty");

			rep.root.child.value = bureauCountyValue;
			if (detailCounty != null)
				rep.root.child.detail = detailCounty;

			String marketingValue = request.getParameter("marketing_center");
			String detailMarketing = request.getParameter("detailMarketing");

			rep.root.child.child.value = marketingValue;
			if (detailMarketing != null)
				rep.root.child.child.detail = detailMarketing;

		} else if (rep.getAppName().startsWith("College")) {
			String collegeValue = request.getParameter("college");
			String detailCollege = request.getParameter("detailCollege");

			rep.root.child.value = collegeValue;
			if (detailCollege != null)
				rep.root.child.detail = detailCollege;
		} else if (rep.getAppName().startsWith("EntGrid")) {
			String ent_grid_main = request.getParameter("ent_grid_main");
			String detail_main = request.getParameter("detail_main");

			rep.root.child.value = ent_grid_main;
			if (detail_main != null)
				rep.root.child.detail = detail_main;

			String ent_grid_sub = request.getParameter("ent_grid_sub");
			String detail_sub = request.getParameter("detail_sub");

			rep.root.child.child.value = ent_grid_sub;
			if (detail_sub != null)
				rep.root.child.child.detail = detail_sub;

		} else if (rep.getAppName().startsWith("Groupcust")) {
			String entCountyValue = request.getParameter("entCounty");
			String detailCounty = request.getParameter("detailCounty");
			rep.root.child.value = entCountyValue;
			if (detailCounty != null)
				rep.root.child.detail = detailCounty;

			String custmgrValue = request.getParameter("custmgr");
			String detailCustmgr = request.getParameter("detailCustmgr");

			rep.root.child.child.value = custmgrValue;
			if (detailCustmgr != null)
				rep.root.child.child.detail = detailCustmgr;

		} else {
			String countyValue = request.getParameter("county");
			String detailCounty = request.getParameter("detailCounty");

			rep.root.child.value = countyValue;
			if (detailCounty != null)
				rep.root.child.detail = detailCounty;
		}
		return rep;
	}

	public void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RepMeta rep = initRep(request);

		String result = rep.query();
		LOG.debug(result);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(result);
	}

	@SuppressWarnings("rawtypes")
	public void down(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RepMeta rep = initRep(request);

		// response.setCharacterEncoding("UTF-8");
		/*
		 * response.setContentType("application/octet-stream");
		 * response.addHeader
		 * ("Content-Disposition","attachment; filename="+URLEncoder
		 * .encode(rep.getName(),"UTF-8")+".csv"); String result = rep.down();
		 * response.getWriter().print(result); response.flushBuffer();
		 */

		String path = System.getProperty("user.dir") + "/";
		File tempFile = new File(path + rep.getName() + ".xls");
		List result = rep.down();

		try {
			ExcelWriter writer = new ExcelWriter();
			writer.createBook(tempFile);
			writer.writerSheet(result, rep.getName());
			writer.closeBook();
			FileManageAction.outFile(response, tempFile);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (tempFile != null) {
				LOG.debug("删除文件" + tempFile.getAbsolutePath());
				tempFile.delete();
			}
		}

	}
}
