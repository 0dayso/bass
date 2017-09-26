package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.web.models.User;

@Repository
public class DocManageDao extends CommonDao{

	public void save(String name, String desc, User user){
		String sql = "insert into gbas.doc_manage (name, desc, creator, creator_name) values (?,?,?,?)";
		this.dwJdbcTemplate.update(sql, new Object[]{name, desc, user.getId(), user.getName()});
	}
	
	public void saveContent(String docId,String content, User user){
		String versionSql = "select max(version) version from gbas.doc_version where doc_id=" + docId;
		Map<String, Object> versionMap = this.dwJdbcTemplate.queryForMap(versionSql);
		String version = "version0001";
		if(null != versionMap.get("version")){
			String verStr = ((String) versionMap.get("version")).replace("version", "");
			int ver = Integer.valueOf(verStr) + 1;
			version = "version" + String.format("%04d", ver);
		}
		
		String sql = "insert into gbas.doc_version(doc_id, version, content, create_time, update_time, creator, creator_name," +
				" updator, updator_name) values (?,?,?, current timestamp, current timestamp,?,?,?,?)";
		this.dwJdbcTemplate.update(sql, new Object[]{docId, version, content, user.getId(), user.getName(), user.getId(), user.getName()});
	}
	
	public void updateContent(String docId, String content, User user, String version){
		String sql = "update gbas.doc_version set content=?, update_time= current timestamp, updator=?, updator_name=? " +
				" where doc_id=? and version=?";
		this.dwJdbcTemplate.update(sql, new Object[]{content, user.getId(), user.getName(), docId, version});
	}
	
	public Map<String, Object> getMdContent(String docId, String version){
		String sql = "select content from gbas.doc_version where version='" + version + "' and doc_Id=" + docId;
		List<Map<String, Object>> list = this.dwJdbcTemplate.queryForList(sql);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return new HashMap<String, Object>();
	}
	
	
	public Map<String, Object> getDocInfoList(String name, String userName, HttpServletRequest req){
		String pageSql = "select * from gbas.doc_manage where 1=1 ";
		String countSql = "select count(1) from gbas.doc_manage where 1=1 ";
		StringBuffer condition = new StringBuffer();
		if(isNotNull(name)){
			condition.append(" and name like '%").append(name).append("%'");
		}
		if(isNotNull(userName)){
			condition.append(" and creator_name like '%").append(userName).append("%'");
		}
		
		int[] pageParam = this.pageParam(req);
		return queryPage(dwJdbcTemplate, null, pageSql + condition.toString(), countSql + condition.toString(), pageParam[0], pageParam[1], " id desc");
	}
	
	public void saveDocInfo(String name, String desc, User user){
		int docId = this.dwJdbcTemplate.queryForObject("values nextval for gbas.doc_manage_id", Integer.class);
		String sql = "insert into gbas.doc_manage (id, name, desc, creator, creator_name) values (?,?,?,?,?)";
		this.dwJdbcTemplate.update(sql, new Object[]{docId, name, desc, user.getId(), user.getName()});
		
		String verSql = "insert into gbas.doc_version(doc_id, version, create_time, update_time, creator, creator_name, updator, updator_name)" +
				" values (?,?, current timestamp, current timestamp, ?,?,?,?)";
		this.dwJdbcTemplate.update(verSql, new Object[]{docId, "version0001", user.getId(), user.getName(), user.getId(), user.getName()});
	}
	
	public void updateDocInfo(String docId, String name, String desc){
		String sql = "update gbas.doc_manage set name=?, desc=? where id=?";
		this.dwJdbcTemplate.update(sql, new Object[]{name, desc, docId});
	}
	
	public void delDoc(String docId){
		String infoSql = "delete from gbas.doc_manage where id=" + docId;
		String verSql = "delete from gbas.doc_version where doc_id=" + docId;
		this.dwJdbcTemplate.update(infoSql);
		this.dwJdbcTemplate.update(verSql);
	}
	
	public List<Map<String, Object>> getVersionList(String docId){
		String sql = "select doc_id, version, creator_name, to_char(create_time,'YYYY-MM-DD HH24:MI:SS') create_time " +
				", updator_name, to_char(update_time,'YYYY-MM-DD HH24:MI:SS') update_time " +
				" from gbas.doc_version where doc_id=" + docId + " order by version desc";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
}
