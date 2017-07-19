package com.asiainfo.hb.power.models;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.core.models.BaseDao;
@SuppressWarnings({"rawtypes","unchecked"})
@Repository
public class MenuManageDao extends BaseDao {
	
	 public Logger logger = LoggerFactory.getLogger(MenuManageDao.class);
	
	  @Resource(name="jdbcTemplateN")
	  private NamedParameterJdbcTemplate pjdbcTemplate;

	  
	 public List<Map<String, Object>> queryAllMenuByMenuTab(String tableName)
	  {
		logger.debug("queryAllMenuByMenuTab-------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
	    try {
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT menuitemid, menuitemtitle, parentid,sortnum,MENUTYPE from ");
			sql.append(tableName)
			   .append(" order by parentid, sortnum");
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	    return list;
	  }

	public int createNewMenuId(String tableName) {
		
		logger.debug("createNewMenuId-------------------------------->");
		int menuId = 0;
		try {
			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT MAX(MENUITEMID)+1 MENUITEMID FROM ");
			sql.append(tableName);
			Map<String, Object> map = jdbcTemplate.queryForMap(sql.toString());
			menuId = Integer
					.parseInt(map.get("MENUITEMID").toString() == null ? "1"
							: map.get("MENUITEMID").toString());
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		return menuId;
	}

	public List queryMenus(String sysCode,String menuTable) {
		logger.debug("queryMenus--------------------->");
		String sql = "select menuitemid, menuitemtitle from "+menuTable+" order by menuitemid";
		List<String[]> lists = new ArrayList<String[]>();
	    try
	    {
	     List <Map<String,Object>> list = jdbcTemplate.queryForList(sql);
	     for (int i = 0; i < list.size(); i++) {
	    	 Map<String,Object> map = list.get(i);
	    	 lists.add(new String[] {map.get("menuitemid").toString(),map.get("menuitemtitle").toString()});
	     	}
	    }
	    catch (EmptyResultDataAccessException e) {
	    	e.printStackTrace();
	    }
	    return lists;
	}

	public Map<String, Object> queryMenuByMenuId(String menuId,String menuTable)
	  {
		logger.debug("queryMenuByMenuId-------------------------------->");
		String _sql="select * from ";
		if(menuTable.equals("FPF_SYS_MENU_ITEM")){
			_sql= " select menuitemid,parentid,menuitemtitle,sortnum,accesstoken state,pic1 iconurl,url,case kind when '配置' then '1' when '资源包' then '2' else '0' end menutype,'Y,Y,Y,Y' power from ";
		}
	    String sql =_sql +menuTable+" where menuitemid= '"+menuId+"'";
	    try
	    {
	      return jdbcTemplate.queryForMap(sql);
	    } catch (EmptyResultDataAccessException e) {
	    	e.printStackTrace();
	    }
	    return null;
	  }

	public Map<String,Object> queryMenuByMenuId(int menuId,String menuTable) {
	
		logger.debug("queryMenuByMenuId-------------------------------->");
		String _sql="select * from ";
		if(menuTable.equals("FPF_SYS_MENU_ITEM")){
			_sql= " select menuitemid,parentid,menuitemtitle,sortnum,accesstoken state,pic1 iconurl,url,kind menutype,'Y,Y,Y,Y' power from ";
		}
		 String sql = _sql+menuTable+" where menuitemid= ?";
		    
		    try
		    {
		      return jdbcTemplate.queryForMap(sql, new Object[]{menuId});
		    } catch (EmptyResultDataAccessException e) {
		    	e.printStackTrace();
		    }
		    return null;
	}

	public int queryMaxSortNumByPid(int pid, String tableName) {
		logger.debug("queryMaxSortNumByPid-------------------------------->");
		try {
			
			String sql = "select max(SORTNUM) from " + tableName
					+ " where PARENTID= ?";
			return jdbcTemplate.queryForObject(sql, new Object[] { pid },Integer.class);
		} catch (Exception e) {
			
			e.printStackTrace();
			return 0;
		}
	}



	public void addMenu(int menuId, int pid, int sortNum,
			String menuItemTitle, int menutype, String tableName) {
		
		logger.debug("addMenu-------------------------------->");
			try {
				Map paramMap = new HashMap();
				paramMap.put("MENUITEMID", Integer.valueOf(menuId));
				paramMap.put("PARENTID", Integer.valueOf(pid));
				paramMap.put("MENUITEMTITLE", menuItemTitle);
				paramMap.put("SORTNUM", Integer.valueOf(sortNum));
				paramMap.put("MENUTYPE", Integer.valueOf(menutype));
				StringBuffer sql = new StringBuffer();
				sql.append("insert into ")
				   .append(tableName)
				  .append(" (MENUITEMID,PARENTID,MENUITEMTITLE,SORTNUM,MENUTYPE) ")
				  .append(" values ")
				  .append(" (:MENUITEMID,:PARENTID,:MENUITEMTITLE,:SORTNUM,:MENUTYPE) ");
				pjdbcTemplate.execute(sql.toString(), paramMap, new PreparedStatementCallback()
				{
				    public Object doInPreparedStatement(PreparedStatement pre) throws SQLException, DataAccessException
				    {
				      return Boolean.valueOf(pre.execute());
				    } } );
			} catch (DataAccessException e) {
				
				e.printStackTrace();
			}
		
	}

	public void modifyMenuTitle(String menuItemTitle, String menuId,
			String tableName) {

		logger.debug("modifyMenuTitle-------------------------------->");
		try {
			String sql = "update "+tableName+" set MENUITEMTITLE=? where MENUITEMID=?";
			@SuppressWarnings("unused")
			Map paramMap = new HashMap();
			jdbcTemplate.update(sql, new Object[]{menuItemTitle,menuId});
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
	}

	public void updateMenu(int menuId, int pid, String menuItemTitle,
			int sortNum, String url, String pic1, int status, String menutype,
			String power,String table) {
		logger.debug("updateMenu-------------------------------->");
		try {
			String sql = " update "+ table +" set  PARENTID=? , MENUITEMTITLE=? , SORTNUM=? " +
					", ICONURL=? , URL=? , MENUTYPE=? , STATE=?  where MENUITEMID=? ";
			if(table.equals("FPF_SYS_MENU_ITEM")){
				sql = " update "+ table +" set  PARENTID=? , MENUITEMTITLE=? , SORTNUM=? " +
						", pic1=? , URL=? , kind=? , ACCESSTOKEN=?   where MENUITEMID=? ";
			}
			jdbcTemplate.update(sql, new Object[]{pid,menuItemTitle,sortNum,pic1,url,menutype,status,menuId});
			
		} catch (DataAccessException e) {
	
			e.printStackTrace();
		}
		
	}

	public void insertMenu(int menuId, int pid, String menuItemTitle,
			int sortNum, String url, String pic1, int status, String menutype,
			String power,String table) {
		logger.debug("insertMenu-------------------------------->");
		String _sql = " (PARENTID, MENUITEMTITLE, SORTNUM,ICONURL, URL, MENUTYPE, STATE ,MENUITEMID) ";
		String _sql1 = " (?,?,?,?,?,?,?,?,?) ";
		if(table.equals("FPF_SYS_MENU_ITEM")){
			_sql = " (PARENTID, MENUITEMTITLE, SORTNUM,pic1, URL, kind, ACCESSTOKEN ,MENUITEMID,MENUTYPE,RESTYPE,RESOURCE_TYPE) ";
			_sql1 = " (?,?,?,?,?,?,?,?,?,?,?,?) ";
		}
		 StringBuffer sql = new StringBuffer();
		 sql.append(" insert into ")
	      .append(table)
	      .append(_sql)
	      .append(" values ")
	      .append(_sql1);
		 Object[] obj=new Object[]{pid,menuItemTitle,sortNum,pic1,url,menutype,status,menuId};
		 if(table.equals("FPF_SYS_MENU_ITEM")){
			 obj=new Object[]{pid,menuItemTitle,sortNum,pic1,url,menutype,status,menuId,1,1,1};
		 }
		try {
			jdbcTemplate.update(sql.toString(),obj);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}

		
	}
	
	public void delMenuAndRoleMenuByMenuId(int menuId, String menuTable) {
		logger.debug("delMenuAndRoleMenuByMenuId-------------------------------->");
		
		String sql = " delete from "+menuTable+" where MENUITEMID = "+menuId;
		try {
			jdbcTemplate.execute(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}

	public void delMenuAndRoleMenuBypId(int menuId, String menuTable) {
		logger.debug("delMenuAndRoleMenuBypId-------------------------------->");
		
		String sql = " delete from "+menuTable+" where PARENTID = "+menuId;
		try {
			jdbcTemplate.execute(sql);
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
	}
	
	public List<Map<String,Object>> getChildIdsByParentId(String parentId){
		logger.debug("getChildIdsByParentId-------------------------------->");
		 List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		try {
			String sql = "SELECT MENUITEMID,PARENTID FROM FPF_SYS_MENU_ITEMS WHERE PARENTID = ?";
			list = jdbcTemplate.queryForList(sql, new Object[]{parentId});
		} catch (DataAccessException e) {
	
			e.printStackTrace();
		}
		return list;
	}
	
}
