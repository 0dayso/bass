package com.asiainfo.hbbass.ws.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.ws.model.MenuInfoModel;

@Repository
public class MenuInfoDAO {

	private static Logger LOG = Logger.getLogger(MenuInfoDAO.class);
	
	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSource;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceDw;

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource,false);
	}
	
	@SuppressWarnings("unused")
	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw,false);
	}

	private MenuInfoDAO() {
	}

	public Integer menuInfoListCount(MenuInfoModel menuInfoModel) throws Exception {
		Integer count = new Integer(0);
		try {
			String querySQL = "SELECT COUNT(ID) from MENUINFO_4A WHERE 1=1 ";
			if (StringUtils.isNotEmpty(menuInfoModel.getId())) {
				querySQL += " AND ID = '" + menuInfoModel.getId() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev1())) {
				querySQL += " AND MENULEV1 LIKE '%" + menuInfoModel.getMenuLev1() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev2())) {
				querySQL += " AND MENULEV2 LIKE '%" + menuInfoModel.getMenuLev2() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev3())) {
				querySQL += " AND MENULEV3 LIKE '%" + menuInfoModel.getMenuLev3() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev4())) {
				querySQL += " AND MENULEV4 LIKE '%" + menuInfoModel.getMenuLev4() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev5())) {
				querySQL += " AND MENULEV5 LIKE '%" + menuInfoModel.getMenuLev5() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getTypeMenu())) {
				querySQL += " AND TYPEMENU = '" + menuInfoModel.getTypeMenu() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getTypeOp())) {
				querySQL += " AND TYPEOP = '" + menuInfoModel.getTypeOp() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getStatus())) {
				querySQL += " AND STATUS = '" + menuInfoModel.getStatus() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getUpdDateStr())) {
				querySQL += " AND UPDDATESTR LIKE '%" + menuInfoModel.getUpdDateStr() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getSceneId())) {
				querySQL += " AND SCENEID = '" + menuInfoModel.getSceneId() + "' ";
			}
			count = this.jdbcTemplate.queryForObject(querySQL,Integer.class);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
		return count;
	}

	@SuppressWarnings("rawtypes")
	public List<MenuInfoModel> menuInfoList(MenuInfoModel menuInfoModel, Integer begin, Integer length) throws Exception {
		List<MenuInfoModel> returnList = new ArrayList<MenuInfoModel>();
		try {
			String querySQL = "SELECT AAA.* FROM ( SELECT ID,MENULEV1,MENULEV2,MENULEV3,MENULEV4,MENULEV5,TYPEMENU,TYPEOP,STATUS,UPDDATESTR,SCENEID,ROW_NUMBER() OVER(PARTITION BY 1 ORDER BY MENULEV1,MENULEV2,MENULEV3,MENULEV4 DESC) AS ROW_NUM from MENUINFO_4A WHERE 1=1 ";
			if (StringUtils.isNotEmpty(menuInfoModel.getId())) {
				querySQL += " AND ID = '" + menuInfoModel.getId() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev1())) {
				querySQL += " AND MENULEV1 LIKE '%" + menuInfoModel.getMenuLev1() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev2())) {
				querySQL += " AND MENULEV2 LIKE '%" + menuInfoModel.getMenuLev2() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev3())) {
				querySQL += " AND MENULEV3 LIKE '%" + menuInfoModel.getMenuLev3() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev4())) {
				querySQL += " AND MENULEV4 LIKE '%" + menuInfoModel.getMenuLev4() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getMenuLev5())) {
				querySQL += " AND MENULEV5 LIKE '%" + menuInfoModel.getMenuLev5() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getTypeMenu())) {
				querySQL += " AND TYPEMENU = '" + menuInfoModel.getTypeMenu() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getTypeOp())) {
				querySQL += " AND TYPEOP = '" + menuInfoModel.getTypeOp() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getStatus())) {
				querySQL += " AND STATUS = '" + menuInfoModel.getStatus() + "' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getUpdDateStr())) {
				querySQL += " AND UPDDATESTR LIKE '%" + menuInfoModel.getUpdDateStr() + "%' ";
			}
			if (StringUtils.isNotEmpty(menuInfoModel.getSceneId())) {
				querySQL += " AND SCENEID = '" + menuInfoModel.getSceneId() + "' ";
			}
			querySQL += " ) AAA WHERE AAA.ROW_NUM > " + begin + " AND AAA.ROW_NUM <= " + Integer.valueOf(begin + length);
			List list = this.jdbcTemplate.queryForList(querySQL);
			if (list != null) {
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map) list.get(i);
					MenuInfoModel tempModel = new MenuInfoModel();
					tempModel.setId((String) map.get("ID"));
					tempModel.setMenuLev1((String) map.get("MenuLev1"));
					tempModel.setMenuLev2((String) map.get("MenuLev2"));
					tempModel.setMenuLev3((String) map.get("MenuLev3"));
					tempModel.setMenuLev4((String) map.get("MenuLev4"));
					tempModel.setMenuLev5((String) map.get("MenuLev5"));
					tempModel.setTypeMenu((String) map.get("TYPEMENU"));
					tempModel.setTypeOp((String) map.get("TYPEOP"));
					tempModel.setStatus((String) map.get("STATUS"));
					tempModel.setUpdDateStr((String) map.get("UPDDATESTR"));
					tempModel.setSceneId((String) map.get("SCENEID"));
					returnList.add(tempModel);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
		return returnList;
	}

	@SuppressWarnings("rawtypes")
	public MenuInfoModel menuInfoByKey(MenuInfoModel menuInfoModel) throws Exception {
		MenuInfoModel returnModel = new MenuInfoModel();
		try {
			String querySQL = "SELECT ID,MENULEV1,MENULEV2,MENULEV3,MENULEV4,MENULEV5,TYPEMENU,TYPEOP,STATUS,UPDDATESTR,SCENEID from MENUINFO_4A WHERE 1=1 " + " AND ID = '" + menuInfoModel.getId() + "' " + " AND TYPEOP = '" + menuInfoModel.getTypeOp() + "' ";
			LOG.info("querySQL ==============="+querySQL);
			List list = this.jdbcTemplate.queryForList(querySQL);
			if (list != null && list.size() > 0) {
				Map map = (Map) list.get(0);
				returnModel.setId((String) map.get("ID"));
				returnModel.setMenuLev1((String) map.get("MENULEV1"));
				returnModel.setMenuLev2((String) map.get("MENULEV2"));
				returnModel.setMenuLev3((String) map.get("MENULEV3"));
				returnModel.setMenuLev4((String) map.get("MENULEV4"));
				returnModel.setMenuLev5((String) map.get("MENULEV5"));
				returnModel.setTypeMenu((String) map.get("TYPEMENU"));
				returnModel.setTypeOp((String) map.get("TYPEOP"));
				returnModel.setStatus((String) map.get("STATUS"));
				returnModel.setUpdDateStr((String) map.get("UPDDATESTR"));
				returnModel.setSceneId((String) map.get("SCENEID"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
		return returnModel;
	}

	public void insertMenuInfo(MenuInfoModel menuInfoModel) throws Exception {
		try {
			String insertSQL = "INSERT INTO MENUINFO_4A(ID,MENULEV1,MENULEV2,MENULEV3,MENULEV4,MENULEV5,TYPEMENU,TYPEOP,STATUS,UPDDATESTR,SCENEID) " + " VALUES('" + menuInfoModel.getId() + "','" + menuInfoModel.getMenuLev1() + "','" + menuInfoModel.getMenuLev2() + "','" + menuInfoModel.getMenuLev3() + "','"
					+ menuInfoModel.getMenuLev4() + "','" + menuInfoModel.getMenuLev5() + "','" + menuInfoModel.getTypeMenu() + "','" + menuInfoModel.getTypeOp() + "','" + menuInfoModel.getStatus() + "','" + menuInfoModel.getUpdDateStr() + "','" + menuInfoModel.getSceneId() + "')";
			jdbcTemplate.execute(insertSQL);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

	public void updateMenuInfo(MenuInfoModel menuInfoModel) throws Exception {
		try {
			String updateSQL = "UPDATE MENUINFO_4A SET(ID,MENULEV1,MENULEV2,MENULEV3,MENULEV4,MENULEV5,TYPEMENU,TYPEOP,STATUS,UPDDATESTR,SCENEID) = " + " ('" + menuInfoModel.getId() + "','" + menuInfoModel.getMenuLev1() + "','" + menuInfoModel.getMenuLev2() + "','" + menuInfoModel.getMenuLev3() + "','"
					+ menuInfoModel.getMenuLev4() + "','" + menuInfoModel.getMenuLev5() + "','" + menuInfoModel.getTypeMenu() + "','" + menuInfoModel.getTypeOp() + "','" + menuInfoModel.getStatus() + "','" + menuInfoModel.getUpdDateStr() + "','" + menuInfoModel.getSceneId() + "') WHERE 1=1 " + " AND ID = '"
					+ menuInfoModel.getId() + "' " + " AND TYPEOP = '" + menuInfoModel.getTypeOp() + "' ";
			jdbcTemplate.execute(updateSQL);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

	public void deleteMenuInfo(MenuInfoModel menuInfoModel) throws Exception {
		try {
			String deleteSQL = "DELETE MENUINFO_4A WHERE 1=1 " + " AND ID = '" + menuInfoModel.getId() + "' " + " AND TYPEOP = '" + menuInfoModel.getTypeOp() + "' ";
			jdbcTemplate.execute(deleteSQL);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

}
