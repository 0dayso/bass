package com.asiainfo.bass.apps.warning;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.sql.DataSource;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class WarningDao {
@SuppressWarnings("unused")
private static Logger LOG = Logger.getLogger(WarningDao.class);
	
	
	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;
	
	public void delete(String ds, String type){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		String sql = "";
		if("1".equals(type)){//满意度
			sql = "delete from WARNING_USERINFO_TMP";
		}else if("2".equals(type)){//700
			sql = "delete from WARNING_USERINFO_SATISFACTION_TMP";
		}else if("3".equals(type)){//十一大
			sql = "delete from WARNING_USERINFO_MAINRECREP";
		}
		jdbcTemplate.execute(sql);
	}
	
	public void insertLog(String ds, String type, String userid, String cityid){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		Date d = new Date();
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");   
		String date = format.format(d);  ;
		String importType = "";
		if("1".equals(type)){//满意度
			importType = "营业厅短信评测满意度阀值配置导入日志";
		}else if("2".equals(type)){//700
			importType = "700短信触发阀值配置导入日志";
		}else if("3".equals(type)){//十一大
			importType = "十一大业务办理时长阀值配置导入日志";
		}
		String sql = "insert into WARNING_LOG(USERID, OPERDATE, CITYID, TYPE) VALUES('"+userid+"','"+date+"','"+cityid+"','"+importType+"')";
		jdbcTemplate.execute(sql);
	}
	
	public void deleteTemp(String ds, String type){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		String temp = "";
		if("1".equals(type)){//满意度
			temp = "WARNING_USERINFO_TMP";
		}else if("2".equals(type)){//700
			temp = "WARNING_USERINFO_SATISFACTION_TMP";
		}else if("3".equals(type)){//十一大
			temp = "WARNING_USERINFO_MAINRECREP_TMP";
		}
		String sql = "delete from "+temp;
		jdbcTemplate.execute(sql);
	}
	
	@SuppressWarnings("rawtypes")
	public List getTempList(String ds, String type){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		String sql = "";
		if("1".equals(type)){//满意度
			sql = "select LEVEL, CITYCODE, CITYNAME, COUNTYCODE, COUNTYNAME, CHANNELCODE, CHANNELNAME, REDWARNVAL, REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL, ORANGEUSERNAME, ORANGEUSERPHONE, BLUEWARNVAL, BLUEUSERNAME, BLUEUSERPHONE from WARNING_USERINFO_TMP ";
		}else if("2".equals(type)){//700
			sql = "select LEVEL, CITYCODE, CITYNAME, COUNTYCODE, COUNTYNAME, CHANNELCODE, CHANNELNAME, REDWARNVAL, REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL, ORANGEUSERNAME, ORANGEUSERPHONE, BLUEWARNVAL, BLUEUSERNAME, BLUEUSERPHONE from WARNING_USERINFO_SATISFACTION_TMP ";
		}else if("3".equals(type)){//十一大
			sql = "select BUSINESS, LEVEL, CITYCODE, CITYNAME, COUNTYCODE, COUNTYNAME, CHANNELCODE, CHANNELNAME, REDWARNVAL, REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL, ORANGEUSERNAME, ORANGEUSERPHONE, BLUEWARNVAL, BLUEUSERNAME, BLUEUSERPHONE from WARNING_USERINFO_MAINRECREP_TMP ";
		}
		return jdbcTemplate.queryForList(sql);
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	public void update(List list, String ds, String type, String userid) {
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		String sql = "";
		for (int i = 0; i < list.size(); i++) {
			HashMap map = (HashMap) list.get(i);
			String LEVEL = map.get("LEVEL").toString();
			String CITYCODE = map.get("CITYCODE").toString();
			String CITYNAME = map.get("CITYNAME").toString();
			String COUNTYCODE = map.get("COUNTYCODE").toString();
			String COUNTYNAME = map.get("COUNTYNAME").toString();
			String CHANNELCODE = map.get("CHANNELCODE").toString();
			String CHANNELNAME = map.get("CHANNELNAME").toString();
			String REDWARNVAL = map.get("REDWARNVAL").toString();
			String REDUSERNAME = map.get("REDUSERNAME").toString();
			String REDUSERPHONE = map.get("REDUSERPHONE").toString();
			String ORANGEWARNVAL = map.get("ORANGEWARNVAL").toString();
			String ORANGEUSERNAME = map.get("ORANGEUSERNAME").toString();
			String ORANGEUSERPHONE = map.get("ORANGEUSERPHONE").toString();
			String BLUEWARNVAL = map.get("BLUEWARNVAL").toString();
			String BLUEUSERNAME = map.get("BLUEUSERNAME").toString();
			String BLUEUSERPHONE = map.get("BLUEUSERPHONE").toString();
			String BUSINESS = "";
			if ("3".equals(type)) {
				BUSINESS = map.get("BUSINESS").toString();
			}
			// 预警分公司公司管理员
			if ("1".equals(type)) {// 满意度
				if (!"".equals(LEVEL) && LEVEL.equals("地市")) {
					sql = "update warning_userinfo_data set REDWARNVAL=?, REDUSERNAME=?, REDUSERPHONE=?, ORANGEWARNVAL=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEWARNVAL=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDWARNVAL,
							REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL,
							ORANGEUSERNAME, ORANGEUSERPHONE, BLUEWARNVAL,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, LEVEL});
				} else if (!"".equals(LEVEL) && LEVEL.equals("区县")) {
					sql = "update warning_userinfo_data set REDWARNVAL=?, REDUSERNAME=?, REDUSERPHONE=?, ORANGEWARNVAL=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEWARNVAL=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and level = ? ";
					jdbcTemplate
							.update(sql, new Object[] { REDWARNVAL,
									REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL,
									ORANGEUSERNAME, ORANGEUSERPHONE,
									BLUEWARNVAL, BLUEUSERNAME, BLUEUSERPHONE,
									CITYCODE, COUNTYCODE, LEVEL });
				} else if (!"".equals(LEVEL) && LEVEL.equals("渠道")) {
					sql = "update warning_userinfo_data set REDWARNVAL=?, REDUSERNAME=?, REDUSERPHONE=?, ORANGEWARNVAL=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEWARNVAL=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and channelcode = ? and level = ? ";
					jdbcTemplate
							.update(sql, new Object[] { REDWARNVAL,
									REDUSERNAME, REDUSERPHONE, ORANGEWARNVAL,
									ORANGEUSERNAME, ORANGEUSERPHONE,
									BLUEWARNVAL, BLUEUSERNAME, BLUEUSERPHONE,
									CITYCODE, COUNTYCODE, CHANNELCODE, LEVEL });
				}
			} else if ("2".equals(type)) {// 700
				if (!"".equals(LEVEL) && LEVEL.equals("地市")) {
					sql = "update WARNING_USERINFO_SATISFACTION set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, LEVEL });
				} else if (!"".equals(LEVEL) && LEVEL.equals("区县")) {
					sql = "update WARNING_USERINFO_SATISFACTION set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, COUNTYCODE,
							BUSINESS, LEVEL });
				} else if (!"".equals(LEVEL) && LEVEL.equals("渠道")) {
					sql = "update WARNING_USERINFO_SATISFACTION set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and channelcode = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, COUNTYCODE,
							BUSINESS, CHANNELCODE, LEVEL });
				}
			} else if ("3".equals(type)) {// 十一大
				if (!"".equals(LEVEL) && LEVEL.equals("地市")) {
					sql = "update WARNING_USERINFO_MAINRECREP set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and BUSINESS = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, BUSINESS, LEVEL });
				} else if (!"".equals(LEVEL) && LEVEL.equals("区县")) {
					sql = "update WARNING_USERINFO_MAINRECREP set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and BUSINESS = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, COUNTYCODE,
							BUSINESS, LEVEL });
				} else if (!"".equals(LEVEL) && LEVEL.equals("渠道")) {
					sql = "update WARNING_USERINFO_MAINRECREP set REDUSERNAME=?, REDUSERPHONE=?, ORANGEUSERNAME=?, ORANGEUSERPHONE=?, BLUEUSERNAME=?, BLUEUSERPHONE=? where CITYCODE = ? and COUNTYCODE =? and channelcode = ? and BUSINESS = ? and level = ?";
					jdbcTemplate.update(sql, new Object[] { REDUSERNAME,
							REDUSERPHONE, ORANGEUSERNAME, ORANGEUSERPHONE,
							BLUEUSERNAME, BLUEUSERPHONE, CITYCODE, COUNTYCODE,
							CHANNELCODE, BUSINESS, LEVEL });
				}
			}
		}

	}
	
	/**
	 * 保存预警值
	 * @param red		红色预警值
	 * @param orange	橙色预警值
	 * @param blue		蓝色预警值
	 * @param type		类型 1：700短信触发；2:十一大业务
	 */
	public void saveConfig(String red, String orange, String blue, String type, String code, String business){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		String sql = "";
		if("1".equals(type)){
			sql = "update WARNING_USERINFO_SATISFACTION set REDWARNVAL=?, ORANGEWARNVAL=?, BLUEWARNVAL=? where code = ?";
			if(red.indexOf("#")>-1){
				String[] reds = red.split("#");
				String[] oranges = red.split("#");
				String[] blues = red.split("#");
				String[] codes = red.split("#");
				for(int i=0;i<codes.length;i++){
					jdbcTemplate.update(sql, new Object[]{reds[i], oranges[i], blues[i], codes[i]});
				}
			}
		}else if("2".equals(type)){
			sql = "update WARNING_USERINFO_MAINRECREP set REDWARNVAL=?, ORANGEWARNVAL=?, BLUEWARNVAL=? where code = ? and BUSINESS = ?";
			if(red.indexOf("#")>-1){
				String[] reds = red.split("#");
				String[] oranges = red.split("#");
				String[] blues = red.split("#");
				String[] codes = red.split("#");
				for(int i=0;i<codes.length;i++){
					jdbcTemplate.update(sql, new Object[]{reds[i], oranges[i], blues[i], codes[i], business});
				}
			}
		}
	}
}
