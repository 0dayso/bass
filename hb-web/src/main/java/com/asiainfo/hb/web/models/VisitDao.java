package com.asiainfo.hb.web.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * 日志记录
 * @author xiaoh
 *
 */
@Repository
public class VisitDao implements VisitService{

	private JdbcTemplate jdbcTemplate;
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	@Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
	
	@SuppressWarnings("rawtypes")
	@Override
	public Map<String, String> getMenuTrace(String mid) {
		Map<String, String> map = new HashMap<String, String>();
		StringBuilder menuIdTrack = new StringBuilder();
		StringBuilder menuTrack = new StringBuilder();
		String sqlMenuTrack = "WITH RPL (id, name , pid , level) AS" + " (" + " SELECT ROOT.menuitemid, ROOT.menuitemtitle ,ROOT.parentid , 1 FROM FPF_SYS_MENU_ITEMs ROOT WHERE ROOT.menuitemid = ?" + " UNION  ALL"
				+ " SELECT  CHILD.menuitemid, CHILD.menuitemtitle,CHILD.parentid, level+1 FROM RPL PARENT, FPF_SYS_MENU_ITEMs CHILD WHERE PARENT.pid = CHILD.menuitemid" + " )" + " SELECT id mid, name FROM RPL order by level";

		List p_menuId = jdbcTemplate.queryForList(sqlMenuTrack, new Object[] { Integer.valueOf(mid) });
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
		map.put("menuIdTrack", menuIdTrack.toString());
		map.put("menuTrack", menuTrack.toString());
		return map;
	}

	@Override
	public void saveLog(Visit log, long beginTime) {
		String sql = "insert into FPF_VISITLIST(loginname,area_id,track_mid,track,ipaddr,uri,param,opertype,opername,app_serv,dur_time,ua) values(?,?,?,?,?,?,?,?,?,?,?,?)";
		String param = log.getParam()!= null ?log.getParam():"";
		jdbcTemplate.update(sql, new Object[]{
			log.getLoginName(), log.getAreaId(), log.getTrackId(), log.getTrack(), log.getIpAddr(), log.getUri(),
			param.length()>64?param.substring(1,64) : param, log.getOperType(), log.getOperName(), log.getAppServ(), System.currentTimeMillis()-beginTime,log.getUa()
		});
		
	}
	

}
