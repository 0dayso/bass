package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;
import com.asiainfo.hbbass.irs.report.core.Report;

/**
 * 配置报表
 * 
 * @author Mei Kefu
 * @date 2010-5-5
 */
public class ConfReportAction extends Action {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(ConfReportAction.class);

	@ActionMethod(isLog = false)
	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String subjectName = request.getParameter("name");
		String subjectDesc = request.getParameter("desc");
		String userId = request.getParameter("user");
		String proc = request.getParameter("proc");
		String msg = "操作失败";
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			int subjectId = -1;
			PreparedStatement ps = conn.prepareStatement("values nextval for IRS_SUBJECT_id");
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				subjectId = rs.getInt(1);
			rs.close();
			ps.close();
			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT(id,name,desc,user_id,kind) values(?,?,?,?,'配置')");
			ps.setInt(1, subjectId);
			ps.setString(2, subjectName);
			ps.setString(3, subjectDesc);
			ps.setString(4, userId);

			ps.execute();
			ps.close();

			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Proc',?)");
			ps.setInt(1, subjectId);
			ps.setString(2, proc);

			ps.execute();
			ps.close();

			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);

	}

	@ActionMethod(isLog = false)
	public void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String subjectName = request.getParameter("name");
		String subjectDesc = request.getParameter("desc");
		String userId = request.getParameter("user");
		String proc = request.getParameter("proc");
		String resp = request.getParameter("resp");
		String sid = request.getParameter("sid");
		String msg = "操作失败";
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {

			PreparedStatement ps = conn.prepareStatement("update FPF_IRS_SUBJECT set name=?,desc=?,user_id=? where id =?");

			ps.setString(1, subjectName);
			ps.setString(2, subjectDesc);
			ps.setString(3, userId);
			ps.setInt(4, Integer.parseInt(sid));

			ps.execute();
			ps.close();

			ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT_EXT where sid =? and code in ('Proc','Resp')");
			ps.setInt(1, Integer.parseInt(sid));
			ps.execute();
			ps.close();

			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Proc',?)");
			ps.setInt(1, Integer.parseInt(sid));
			ps.setString(2, proc);
			ps.execute();
			ps.close();

			ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Resp',?)");
			ps.setInt(1, Integer.parseInt(sid));
			ps.setString(2, resp);
			ps.execute();
			ps.close();

			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);

	}

	@ActionMethod(isLog = false)
	public void dim(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", null, false);
		String string = (String) sqlQuery.query("select distinct name,tagname from dim_total order by name with ur");

		response.getWriter().print(string);
	}

	@ActionMethod(isLog = false)
	public void deleteDim(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("sid");
		int nId = Integer.parseInt(sid);
		String name = request.getParameter("name");
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			delDim(conn, nId, name);
			conn.commit();
			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

	@ActionMethod(isLog = false)
	protected void delDim(Connection conn, int nId, String name) throws SQLException {
		PreparedStatement ps1 = conn.prepareStatement("delete from FPF_IRS_SUBJECT_DIM where sid=? and name=?");
		ps1.setInt(1, nId);
		ps1.setString(2, name);
		ps1.execute();
	}

	@ActionMethod(isLog = false)
	public void saveDim(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("sid");
		int nId = Integer.parseInt(sid);
		String name = request.getParameter("name");
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			delDim(conn, nId, name);

			String label = request.getParameter("label");
			String dbname = request.getParameter("dbname");
			String opertype = request.getParameter("opertype");
			String datasource = request.getParameter("datasource");
			String seq = request.getParameter("seq");

			PreparedStatement ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_DIM(sid,label,name,dbname,opertype,defval,datasource,seq) values(?,?,?,?,?,?,?,?)");
			ps.setInt(1, nId);
			ps.setString(2, label);
			ps.setString(3, name);
			ps.setString(4, dbname);
			ps.setString(5, opertype);
			ps.setString(6, "");
			ps.setString(7, datasource);
			ps.setInt(8, Integer.parseInt(seq));
			ps.execute();
			conn.commit();
			msg = "操作成功";
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

	public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		String cityId = (String) request.getSession().getAttribute("area_id");
		Report rpt = new Report(sid, cityId);
		response.getWriter().print(rpt.render());
	}

	@ActionMethod(isLog = false)
	public void getHeader(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		Report rpt = new Report(sid);
		response.getWriter().print(rpt.getHeaderPiece());
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ActionMethod(isLog = false)
	public void getSQL(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		Report rpt = new Report(sid);
		Map map = new HashMap();
		map.put("sql", rpt.getOriSQL());
		map.put("grid", rpt.getGrid());
		map.put("maxTime", rpt.getMaxTime());
		map.put("cache", rpt.getIsCached());
		map.put("ds", rpt.getDs());
		map.put("excel", rpt.getUseExcel());
		map.put("chart", rpt.getUseChart());
		map.put("areaAll", rpt.getIsAreaAll());
		response.getWriter().print(JsonHelper.getInstance().write(map));
	}

	@ActionMethod(isLog = false)
	public void saveSQL(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("sid");
		int nId = Integer.parseInt(sid);
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			PreparedStatement ps1 = conn.prepareStatement("delete from FPF_IRS_SUBJECT_EXT where sid=? and code in ('SQL','Grid','MaxTime','DS','Cache','UseExcel','UseChart','AreaAll')");
			ps1.setInt(1, nId);
			ps1.execute();

			String sql = request.getParameter("sql");

			PreparedStatement ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SQL',?)");
			ps.setInt(1, nId);
			ps.setString(2, sql);
			ps.execute();

			String grid = request.getParameter("grid");
			PreparedStatement ps2 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Grid',?)");
			ps2.setInt(1, nId);
			ps2.setString(2, grid);
			ps2.execute();

			String maxTime = request.getParameter("maxTime");
			if (maxTime != null && maxTime.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'MaxTime',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, maxTime);
				ps3.execute();
				ps3.close();
			}

			String cache = request.getParameter("cache");
			if (cache != null && cache.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Cache',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, cache);
				ps3.execute();
				ps3.close();
			}

			String ds = request.getParameter("ds");
			if (ds != null && ds.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'DS',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, ds);
				ps3.execute();
				ps3.close();
			}

			String excel = request.getParameter("excel");
			if (excel != null && excel.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'UseExcel',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, excel);
				ps3.execute();
				ps3.close();
			}

			String chart = request.getParameter("chart");
			if (chart != null && chart.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'UseChart',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, chart);
				ps3.execute();
				ps3.close();
			}

			String areaAll = request.getParameter("areaAll");
			if (areaAll != null && areaAll.length() > 0) {
				PreparedStatement ps3 = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'AreaAll',?)");
				ps3.setInt(1, nId);
				ps3.setString(2, areaAll);
				ps3.execute();
				ps3.close();
			}

			conn.commit();
			msg = "操作成功";

		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ActionMethod(isLog = false)
	public void getCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		Report rpt = new Report(sid);
		Map map = new HashMap();
		map.put("code", rpt.getCodePiece());
		response.getWriter().print(JsonHelper.getInstance().write(map));
	}

	@ActionMethod(isLog = false)
	public void saveCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("sid");
		int nId = Integer.parseInt(sid);
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			PreparedStatement ps1 = conn.prepareStatement("delete from FPF_IRS_SUBJECT_EXT where sid=? and code='Code'");
			ps1.setInt(1, nId);
			ps1.execute();

			String code = request.getParameter("code");
			if (code != null && code.length() > 0) {
				PreparedStatement ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Code',?)");
				ps.setInt(1, nId);
				ps.setString(2, code);
				ps.execute();
			}
			conn.commit();
			msg = "操作成功";

		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

	@SuppressWarnings("rawtypes")
	@ActionMethod(isLog = false)
	public void saveHeader(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("sid");
		int nId = Integer.parseInt(sid);
		String headerStr = request.getParameter("headerStr");

		JsonHelper helper = JsonHelper.getInstance();
		List list = (List) helper.read(headerStr);
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			PreparedStatement ps1 = conn.prepareStatement("delete from FPF_IRS_SUBJECT_INDICATOR where sid=?");
			ps1.setInt(1, nId);
			ps1.execute();

			PreparedStatement ps = conn.prepareStatement("insert into FPF_IRS_SUBJECT_INDICATOR(sid,name,data_index,cell_func,cell_style,title,seq) values(?,?,?,?,?,?,?)");
			for (int i = 0; i < list.size(); i++) {

				Map map = (Map) list.get(i);

				List names = (List) map.get("name");

				String name = "";

				for (int j = 0; j < names.size(); j++) {
					if (name.length() > 0)
						name += ",";

					name += names.get(j);
				}

				ps.setInt(1, nId);
				ps.setString(2, name);
				ps.setString(3, (String) map.get("dataIndex"));
				ps.setString(4, (String) map.get("cellFunc"));
				ps.setString(5, (String) map.get("cellStyle"));
				ps.setString(6, (String) map.get("title"));
				ps.setInt(7, i + 1);
				ps.addBatch();
			}
			ps.executeBatch();
			conn.commit();
			msg = "操作成功";
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

}
