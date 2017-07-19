package com.asiainfo.bass.apps.models;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hb.web.models.User;

@Repository
public class ThreeFormsDao {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}
	
	public void save(String month, String fileName, User user){
		//查询数据库中是否有本月数据
		String sql = "select count(*) cnt from three_forms_audit where month='" + month + "'";
		int count = this.jdbcTemplate.queryForObject(sql,Integer.class);
		
		if(count == 0){
			this.jdbcTemplate.update("insert into three_forms_audit(month, name, status, creator_id, create_date, isdelete) values (?,?,?,?,?,?)",
					new Object[]{month, fileName, "已上传", user.getId(), new Date(), "1"});
		}else{
			this.jdbcTemplate.update("update three_forms_audit set name=?, status='已上传',isdelete='1' where month=?",
					new Object[]{fileName, month});
		}
		this.insertLog(month, user, "上传", "上传附件【" + fileName + "】");
		
	}
	
	private void insertLog(String month, User user, String opt, String remark){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sql = "insert into THREE_FORMS_AUDIT_LOG(month, opt_user, opt_user_id, opt , opt_time, remark) values (?,?,?,?,?,?)";
		this.jdbcTemplate.update(sql, new Object[]{month, user.getName(), user.getId(), opt, sdf.format(new Date()) , remark});
	}
	
	public void delete(String month, User user, String fileName){
		String sql = "update three_forms_audit set isdelete='0' where month='" + month + "'";
		this.jdbcTemplate.update(sql);
		this.insertLog(month, user, "删除", "删除附件【" + fileName + "】");
	}
	
	public Map<String, Object> queryUpload(String month){
		String sql = "select name, status, suggestion, isdelete from three_forms_audit where month='" + month + "'";
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql);
		if(list!= null && list.size() != 0){
			return list.get(0);
		}else{
			return new HashMap<String, Object>();
		}
	}
	
	public List<Map<String, Object>> getLogInfo(String month){
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		String sql = "select opt_user as optuser, to_char(opt_time, 'yyyy-mm-dd hh24:mi:ss') as opttime, remark from three_forms_audit_log where month='" + month + "' order by opt_time";
		result = this.jdbcTemplate.queryForList(sql);
		return result;
	}
	
	public void updateState(String month, String status, String suggestion, User user){
		String sql = "update three_forms_audit set status=?, suggestion=? where month=?";
		this.jdbcTemplate.update(sql, new Object[]{status,suggestion, month});
		String remark;
		if(status.equals("退回")){
			remark = "审核【退回】，退回理由：" + suggestion;
		}else{
			remark = "审核【通过】";
		}
		this.insertLog(month, user, status, remark);
	}
}
