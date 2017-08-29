package com.asiainfo.bass.apps.jinku;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class JinkuDao {
	
	private static Logger LOG = Logger.getLogger(JinkuDao.class); 
	
	@Autowired
	private DataSource dataSource;
	
	@SuppressWarnings("rawtypes")
	public ArrayList<String> getAccount(ArrayList<String> accounts){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		ArrayList<String> result = new ArrayList<String>();
		List list = jdbcTemplate.queryForList("select userid from FPF_MANAGE_4A ");
		if(accounts!=null && accounts.size()>0){
			for(int i=0;i<accounts.size();i++){
				String value = (String)accounts.get(i).trim();
				for(int j=0;j<list.size();j++){
					HashMap map = (HashMap)list.get(j);
					if(value.equals(map.get("userid").toString().trim())){
						result.add(value);
					}
				}
			}
		}
		return result;
	}
	
	public void insertLogBefore(String userId, String ip, String applyId, String sceneid, String d){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into FPF_LOG_4A_BEFORE(USERID, CLIENTIP, NID, SCENEID, CREATETIME) values(?, ?, ?, ?, ?)", new Object[] {userId, ip, applyId, sceneid, d});
	}
	
	public void insertLogApply(String userId, String clientIp, String sceneId, String approver, String caseDesc, String operContent, String optype){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into FPF_LOG_4A_APPLY(USERID, CLIENTIP, SCENEID, COOPERATE, APPLYREASON,  OPERATECONTENT, IMPOWERFASHION, IMPOWERCONDITION) values(?, ?, ?, ?, ?, ?, ?, ?)", new Object[] {userId, clientIp, sceneId, approver, caseDesc, operContent, "", optype});
	}
	
	public void insertLogResult(String userId, String ip, String sceneId, String approver, String result, String d, String impowerider){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into FPF_LOG_4A_RESULT(USERID, CLIENTIP, SCENEID, COOPERATE, RESULT, IMPOWERTIME, IMPOWERIDEA) values(?, ?, ?, ?, ?, ?, ?)", new Object[] {userId, ip, sceneId, approver, result, d, impowerider});
	}
	
	@SuppressWarnings("rawtypes")
	public List getList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select sid, isjinku,sceneid,name from FPF_IRS_SUBJECT_MENU_MAP inner join FPF_IRS_SUBJECT on sid = id where sid=?", new Object[] { Integer.parseInt(id) });
	}
	
	//得到金库状态：Y表示4a认证功能开启;N表示4a认证功能关闭
	public String get4ASwitch() {
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			return jdbcTemplate.queryForMap("select PARAMETERVALUE   from FPF_SYS_PARAMETERS where PARAMETERID='SENSITIVE_4A_IS_OPEN' with ur").get("PARAMETERVALUE").toString();
		} catch (DataAccessException e) {
			e.printStackTrace();
			return "N";
		}
	}
	
	//关闭金库模式
	public void update4ACloseSwitch(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update FPF_SYS_PARAMETERS set PARAMETERVALUE = 'N' where PARAMETERID='SENSITIVE_4A_IS_OPEN' with ur ");
	}
	
	//开启金库模式
	public void update4AOpenSwitch(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update FPF_SYS_PARAMETERS set PARAMETERVALUE = 'Y' where PARAMETERID='SENSITIVE_4A_IS_OPEN' with ur ");
	}
	
	public void save(String cityid, String userid, String username, String mobile){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(int(id)) from FPF_MANAGE_4A",Integer.class)+1;
		//增加标题
		jdbcTemplate.update("insert into FPF_MANAGE_4A(id,cityid,userid,username,mobile) values(?,?,?,?,?)", new Object[] { id, cityid, userid, username, mobile });
	}
	
	public void delete(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("delete from FPF_MANAGE_4A where id=?", new Object[] { id });
	}
	public Map<String, String> checkSensitive(String sid){
		Map<String, String> result = new HashMap<String, String>();
		//有可能会从数据库中查到一个报表配置到两个菜单中，所以改变查询方式,注意在更改报表为敏感数据时是根据报表id来修改，不是根据菜单id修改
		List<Map<String, Object>> list = new JdbcTemplate(dataSource).queryForList("select ISSENSITIVE from FPF_IRS_SUBJECT_MENU_MAP where sid = ?",new Object[]{sid});
		if(list != null && list.size()>0)
		{	
			for(Map<String, Object> map:list){
				if(map.get("ISSENSITIVE") !=null){
					String isSensitive = map.get("ISSENSITIVE").toString();
					result.put("result", isSensitive);
					break;
				}
			}
		}else {
			result.put("result", "");
		}
		return result;
	}
	
	public void insertLog(Jinku Jinku) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		try {
			String insertSQL = " INSERT INTO FPF_SENSITIVE_LOG_4A(USERID,CLIENTIP,NID,SCENEID,OPERATE,ISSENSITIVE,VISITDATESTR,COMMENT,COOPERATE, APPLYREASON, OPERATECONTENT, IMPOWERFASHION, IMPOWERCONDITION, IMPOWERRESULT, IMPOWERTIME, IMPOWERIDEA, RESULT)" + " VALUES('" + Jinku.getUserID() + "','" + Jinku.getClientIp() + "','" + Jinku.getNid() + "','" + Jinku.getSceneId() + "','" + Jinku.getOperate() + "','"
					+ Jinku.getIsSensitive() + "','" + Jinku.getVisitDateStr() + "','" + Jinku.getComment() + "','" + Jinku.getCooperate() + "','" + Jinku.getApplyReason() + "','" + Jinku.getOperateContent() + "','" + Jinku.getImpowerFashion() + "','" + Jinku.getImpowerCondition() + "','" + Jinku.getImpowerResult() + "','" + Jinku.getImpowerTime() + "','" + Jinku.getImpowerIdea() + "','" + Jinku.getResult() + "')";
			LOG.info("sql=================="+insertSQL);
			jdbcTemplate.execute(insertSQL);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}
}
