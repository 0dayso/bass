package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.app.ent.GridBasic;
import com.asiainfo.hbbass.app.ent.GridBasicHist;
import com.asiainfo.hbbass.app.ent.GridTree;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 网格化
 * 
 * @author lizhijian
 * @date 2010-07-20
 */
public class EntGridAction extends Action {

	private static Logger LOG = Logger.getLogger(EntGridAction.class);

	/**
	 * 生成网格树
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void gridNodes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");
		String condi = request.getParameter("condi");
		if (condi != null && !"".equals(condi.trim())) {
			condi = " and grid_id like '" + condi + "%'";
		} else {
			condi = "";
		}

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON, SQLQueryContext.DefaultJndiName, false);
		String result = (String) sqlQuery.query("select grid_id id,grid_name text,'' url , case when level<5 then 'false' else 'true' end leaf from nmk.grid_tree_info where parentgrid_id='" + id + "'" + condi + " order by 1 with ur");

		LOG.debug(result.toString().replaceAll("\"false\"", "false"));

		response.getWriter().write(result.toString().replaceAll("\"false\"", "false"));
	}

	/**
	 * 保存每个网格的经纬度值 操作nmk.grid_points表
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void savePoints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String gid = request.getParameter("gid");

		String potStr = request.getParameter("points");

		if (gid != null && gid.length() > 0 && potStr != null && potStr.length() > 0) {

			Object obj = JsonHelper.getInstance().read(potStr);

			if (obj instanceof List) {
				List points = (List) obj;
				Connection conn = null;
				try {
					conn = ConnectionManage.getInstance().getDWConnection();
					// conn.setAutoCommit(false);

					Statement stat = conn.createStatement();
					stat.execute("delete from nmk.grid_points where id='" + gid + "'");
					stat.close();

					String sql = "insert into nmk.grid_points(id,lng,lat,order) values (?,?,?,?)";

					LOG.debug(sql);
					PreparedStatement ps = conn.prepareStatement(sql);

					for (int i = 0; i < points.size(); i++) {
						Map point = (Map) points.get(i);
						Double dLng = (Double) point.get("lng");
						Double dLat = (Double) point.get("lat");
						ps.setString(1, gid);
						ps.setDouble(2, dLng);
						ps.setDouble(3, dLat);
						ps.setInt(4, i + 1);
						ps.addBatch();
					}
					ps.executeBatch();
					ps.close();
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
			}
		}
		response.getWriter().print(msg);
	}

	/**
	 * 取单个网格的经纬度
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getPoints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String gid = request.getParameter("gid");
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON, SQLQueryContext.DefaultJndiName, false);

		String sql = "select lng,lat from nmk.grid_points where id='" + gid + "' order by order";
		LOG.debug(sql);
		response.getWriter().write((String) sqlQuery.query(sql));

	}

	/**
	 * 取同一级别的网格值
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void getChildGrid(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String glev = request.getParameter("glev");
		String gid = request.getParameter("gid");

		String sql = "";

		if (gid != null && gid.length() > 0) {
			sql = "select id,grid_name name,lng,lat from nmk.grid_points,nmk.grid_tree_info where id=grid_id and parentgrid_id='" + gid + "' order by id,order with ur";
		} else if (glev != null && glev.length() > 0) {
			sql = "select id,grid_name name,lng,lat from nmk.grid_points,nmk.grid_tree_info where id=grid_id and level=" + glev + " order by id,order with ur";
		}

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, SQLQueryContext.DefaultJndiName, false);

		List list = (List) sqlQuery.query(sql);

		List result = new ArrayList();

		Map gridPotMap = new HashMap();

		for (int i = 0; i < list.size(); i++) {

			Map point = (Map) list.get(i);
			String id = (String) point.get("id");
			String name = (String) point.get("name");
			if (!gridPotMap.containsKey(id)) {
				List points = new ArrayList();
				gridPotMap.put(id, points);
				Map map = new HashMap();
				map.put("id", id);
				map.put("name", name);
				map.put("points", points);
				result.add(map);
			}
			List gridPoints = (List) gridPotMap.get(id);
			point.remove("id");
			point.remove("name");
			gridPoints.add(point);
		}

		LOG.debug(JsonHelper.getInstance().write(result));

		response.getWriter().write(JsonHelper.getInstance().write(result));
	}

	public void del(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String id = request.getParameter("id");
		Connection connection = ConnectionManage.getInstance().getDWConnection();

		try {
			String sql = "select count(*) from nmk.grid_tree_info where parentgrid_id=?";

			PreparedStatement ps = connection.prepareStatement(sql);

			ps.setString(1, id);

			ResultSet rs = ps.executeQuery();
			int cnt = -1;
			if (rs.next()) {
				cnt = rs.getInt(1);
			}
			rs.close();
			ps.close();

			if (cnt == 0) {
				GridBasic basic = (GridBasic) GridBasic.parse(GridBasic.class, request);// 新建一条记录
				GridTree tree = (GridTree) GridTree.parse(GridTree.class, request);// 关系表也要

				basic.setConnection(connection);
				basic.delete();

				tree.setConnection(connection);
				tree.delete();

				msg = "操作成功";

			} else {
				msg = "请先删除子节点";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(connection);
		}
		response.getWriter().write(msg);
	}

	/**
	 * 存储网格
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		GridBasic basic = (GridBasic) GridBasic.parse(GridBasic.class, request);// 新建一条记录
		GridBasicHist hist = (GridBasicHist) GridBasicHist.parse(GridBasicHist.class, request);
		GridTree tree = (GridTree) GridTree.parse(GridTree.class, request);// 关系表也要

		hist.setUserId((String) request.getSession().getAttribute("loginname"));

		if (basic.getPid().length() == 0) {
			basic.setPid(basic.getCityId());
			tree.setPid(basic.getCityId());
			hist.setPid(basic.getCityId());
		}

		Connection connection = ConnectionManage.getInstance().getDWConnection();
		try {
			basic.setConnection(connection);
			basic.save();

			tree.setConnection(connection);
			tree.save();

			hist.setConnection(connection);
			hist.save();
			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(connection);
		}
		response.getWriter().write(msg);
	}

	/**
	 * 查询网格
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GridBasic basic = (GridBasic) GridBasic.parse(GridBasic.class, request);
		Connection connection = ConnectionManage.getInstance().getDWConnection();
		try {
			basic.setConnection(connection);
			basic.query();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(connection);
		}
		basic.setConnection(null);
		response.getWriter().write(JsonHelper.getInstance().write(basic));
	}

	/**
	 * 更新网格
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		// 需要更新实体表与关系表，要新建一条操作的日志
		GridBasic basic = (GridBasic) GridBasic.parse(GridBasic.class, request);
		GridTree tree = (GridTree) GridTree.parse(GridTree.class, request);
		GridBasicHist hist = (GridBasicHist) GridBasicHist.parse(GridBasicHist.class, request);
		hist.setUserId((String) request.getSession().getAttribute("loginname"));
		if (basic.getPid().length() == 0) {
			basic.setPid(basic.getCityId());
			tree.setPid(basic.getCityId());
			hist.setPid(basic.getCityId());
		}

		Connection connection = ConnectionManage.getInstance().getDWConnection();
		try {
			basic.setConnection(connection);
			basic.update();

			tree.setConnection(connection);
			tree.update();

			hist.setConnection(connection);
			hist.save();
			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(connection);
		}

		response.getWriter().write(msg);
	}

	@SuppressWarnings("rawtypes")
	public synchronized void genId(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pid = request.getParameter("pid");
		String sql = "select max(grid_id) from nmk.grid_tree_info where parentgrid_id='" + pid + "'";
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.LIST, SQLQueryContext.DefaultJndiName, false);
		List list = (List) sqlQuery.query(sql);
		String id = ((String[]) list.get(0))[0];
		String result = "";
		String prefix = "";
		if (id == null) {
			if (pid.length() == 5) {
				result = pid + ".01";
			} else if (pid.length() > 5) {
				result = pid + ".001";
			}
		} else {
			prefix = id.substring(0, id.lastIndexOf(".") + 1);
			int n = 0;
			if (id.length() <= 2) {
				result = "";
			} else if (id.length() <= 5) {
				result = id + ".01";
			} else if (id.length() == 8) {
				n = Integer.valueOf(id.substring(id.lastIndexOf(".") + 1, id.length()));
				DecimalFormat df = new DecimalFormat("00");
				result = prefix + df.format(n + 1);
			} else if (id.length() > 8) {
				n = Integer.valueOf(id.substring(id.lastIndexOf(".") + 1, id.length()));
				DecimalFormat df = new DecimalFormat("000");
				result = prefix + df.format(n + 1);
			}
		}
		response.getWriter().write(result);
	}

	public static void main(String[] args) {
	}
}
