/**
 * 
 */
package com.asiainfo.hb.bass.frame.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.Configuration;

/**
 * @author zhangds
 * @date 2015年7月22日
 */
@Repository
public class MenuDao extends BaseDao{
	
	public List<MenuBean> getSysMenu(String userid){
		List<MenuBean> list = null;
		boolean flag = wheSuperAdminGroup(userid);
		String _menuSql = Configuration.getInstance().getProperty("com.asiainfo.hb.bass.frame.MenuSql");
		if(flag){
			_menuSql = Configuration.getInstance().getProperty("com.asiainfo.hb.bass.frame.AdminMenuSql");
			list = jdbcTemplate.query(_menuSql, new DbSysMenuQuery());
		}else{
			list = jdbcTemplate.query(_menuSql,new String[]{userid}, new DbSysMenuQuery());
		}
		list = sortMenuBeans(list);
		return list;
	}
	
	public boolean wheSuperAdminGroup(String userid){
		boolean flag = false;
		String groupid = Configuration.getInstance().getProperty("com.asiainfo.hb.bass.frame.SuperAdminGroupId");
		String sql = "select GROUP_ID from FPF_USER_GROUP_MAP where USERID=? and GROUP_ID=?";
		List<Map<String,Object>> list = jdbcTemplate.queryForList(sql, new Object[]{userid,groupid});
		if(list.size()>0) {
			flag=true;
		}
		return flag;
	}
	
	public List<MenuBean> sortMenuBeans(List<MenuBean> list){
		for (MenuBean bean : list){
			for (MenuBean _bean : list){
				if (bean.getPid() != null && !bean.getPid().equals("0") && bean.getPid().equalsIgnoreCase(_bean.getId())){
					List<MenuBean> _list ;
					if (_bean.getChildren() == null){
						_list = new ArrayList<MenuBean>();
					}else{
						_list = _bean.getChildren();
					}
					_list.add(bean);
					_bean.setChildren(_list);
				}
			}
		}
		List<MenuBean> _list= new ArrayList<MenuBean>();
		for (MenuBean bean : list){
			if (bean.getPid().equals("0")){
				_list.add(bean);
			}
		}
		return _list.size()==0?null:_list;
	}
	
	static final class DbSysMenuQuery implements RowMapper<MenuBean>{
		@Override
		public MenuBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			MenuBean _bean = new MenuBean();
			_bean.setId(rs.getString("ID"));
			_bean.setName(rs.getString("NAME"));
			_bean.setPid(rs.getString("PID"));
			_bean.setFile(rs.getString("FILE"));
			_bean.setIconurl(rs.getString("ICONURL"));
			_bean.setSortnum(rs.getInt("SORTNUM"));
			_bean.setMenutype(rs.getInt("MENUTYPE"));
			return _bean;
		}
	}
	
	public final static String NOTICE_SQL = "SELECT NOTICEID, NOTICE_START_DT, NOTICE_END_DT,"+
	" NOTICETITLE, NOTICEMSG, EXTEND_COLOR, CREATOR, STATUS "+
	"FROM SYS_NOTICE WHERE STATUS = 1 AND to_char(NOTICE_START_DT,'yyyy-mm') = ?";
	
	public final static SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	public List<NoticeBean> getCurrentMonthNotices(String yyyyMM){
		List<NoticeBean> list = null ;
		if (yyyyMM != null && yyyyMM.trim().length()==7)
			list = jdbcTemplate.query(NOTICE_SQL,new String[]{yyyyMM}, new DbSysNoticeQuery());
		
		return list;
	}
	
	static final class DbSysNoticeQuery implements RowMapper<NoticeBean>{
		@Override
		public NoticeBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			NoticeBean _bean = new NoticeBean();
			_bean.setNoticeId(rs.getInt("noticeid"));
			_bean.setNotice_start_dt(df.format(new java.util.Date(rs.getTimestamp("notice_start_dt").getTime())));
			_bean.setNotice_end_dt(df.format(new java.util.Date(rs.getTimestamp("notice_end_dt").getTime())));
			_bean.setNoticetitle(rs.getString("noticetitle"));
			_bean.setNoticemsg(rs.getString("noticemsg"));
			_bean.setExtend_color(rs.getString("extend_color"));
			_bean.setCreator(rs.getString("creator"));
			_bean.setStatus(rs.getString("status"));
			return _bean;
		}
	}
}
