package com.asiainfo.bass.apps.mmsreport;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.util.DateUtil;

@Repository
public class MMSReportDao {
@SuppressWarnings("unused")
private static Logger LOG = Logger.getLogger(MMSReportDao.class);
	
	
	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;
	
	@SuppressWarnings("rawtypes")
	public List getList(String id){
		String sql = "select ID, CODE, VALUE, CONTENT from NWH.GLOBAL_VAL_TEXT_TEMP WHERE ID = '"+id+"'";
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList(sql);
	}
	
	@SuppressWarnings("rawtypes")
	public List getMailList(String id){
		String sql = "select ID, CODE, VALUE, CONTENT from FPF_MAIL_CONTENT_CONFIG WHERE ID = '"+id+"'";
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList(sql);
	}
	
	public int getValue(String paraValue){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForObject(paraValue, Integer.class);
	}
	
	@SuppressWarnings("rawtypes")
	public List getCompare(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select VAR_NAME,  MEMO from NWH.GLOBAL_VAL with ur");
	}
	
	public void save(String title, String time, String content, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(int(id)) from NWH.GLOBAL_VAL_TEXT_TEMP",Integer.class)+1;
		//增加标题
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'title',?,?)", new Object[] { id, title, content });
		//增加时间
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'time',?,?)", new Object[] { id, time, content });
		//增加发送人
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'sender',?,?)", new Object[] { id, sender, content });
		//增加状态为未审核
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'status','1',?)", new Object[] { id, content });
		//增加参数
		
		if(content.indexOf("para")>-1){
			String[] str = content.split("para");
			String[] paras = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					paras[i-1] = "para"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < paras.length; i++) {
				if (!list.contains(paras[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(paras[i]);
				}
			}
			String[] newParas = list.toArray(new String[1]);
			for(int i=0;i<newParas.length;i++){
				jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, newParas[i],content });
			}
		}
		//增加同比
		if(content.indexOf("compare")>-1){
			String[] str = content.split("compare");
			String[] compares = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					compares[i-1] = "compare"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < compares.length; i++) {
				if (!list.contains(compares[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(compares[i]);
				}
			}
			String[] newCompares = list.toArray(new String[1]);
			for(int i=0;i<newCompares.length;i++){
				String newCompsql = newCompares[i].replace("are", "sql");
				jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, newCompares[i], content });
				jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, newCompsql, content });
			}
		}
	}
	
	public void saveMailContent(String title, String mail, String content){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(int(id)) from FPF_MAIL_CONTENT_CONFIG",Integer.class)+1;
		//增加标题
		jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,'title',?,?)", new Object[] { id, title, content });
		//增加时间
		jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,'mail',?,?)", new Object[] { id, mail, content });
		//增加参数
		if(content.indexOf("para")>-1){
			String[] str = content.split("para");
			String[] paras = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					paras[i-1] = "para"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < paras.length; i++) {
				if (!list.contains(paras[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(paras[i]);
				}
			}
			String[] newParas = list.toArray(new String[1]);
			for(int i=0;i<newParas.length;i++){
				jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,?,'',?)", new Object[] { id, newParas[i],content });
			}
		}
	}
	
	@SuppressWarnings("rawtypes")
	public void updateMailContent(String id, String title, String mail, String content){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("delete from FPF_MAIL_CONTENT_CONFIG where id=? and code in('title','mail')", new Object[] { id });
		jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,'title',?,?)", new Object[] { id, title, content });
		jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,'mail',?,?)", new Object[] { id, mail, content });
		//修改参数个数
		if(content.indexOf("para")>-1){
			//根据内容得到参数数组
			String[] str = content.split("para");
			String[] paras = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					paras[i-1] = "para"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < paras.length; i++) {
				if (!list.contains(paras[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(paras[i]);
				}
			}
			String[] newParas = list.toArray(new String[1]);
			List parasList = getMailContentParaValueList(id);
			String[] paraList = null;
			if(parasList!=null && parasList.size()>0){
				paraList = (String[]) getMailContentParaValueList(id).toArray(new String[1]);
			}
			for(int i=0;i<newParas.length;i++){
				String para = newParas[i];
				if(paraList!=null){
					if(!isHave(paraList, para)){
						jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,?,'',?)", new Object[] { id, para,content });
					}
				}else{
					jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,?,'',?)", new Object[] { id, para,content });
				}
			}
			if(paraList!=null){
				for(int i=0;i<paraList.length;i++){
					String para = paraList[i];
					if(!isHave(newParas, para)){
						jdbcTemplate.update("delete from  FPF_MAIL_CONTENT_CONFIG where id=? and code=?", new Object[] { id, para } );
					}
				}
			}
		}
		jdbcTemplate.update("update FPF_MAIL_CONTENT_CONFIG set content = ? where id = ? " , new Object[] { content, id });
	}
	
	@SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	public void update(String id, String title, String time, String content, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("delete from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code in('title','time','status','sender')", new Object[] { id });
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'title',?,?)", new Object[] { id, title, content });
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'time',?,?)", new Object[] { id, time, content });
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'sender',?,?)", new Object[] { id, sender, content });
		//增加状态为未审核
		jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,'status','1',?)", new Object[] { id, content });
		//修改参数个数
		if(content.indexOf("para")>-1){
			//根据内容得到参数数组
			String[] str = content.split("para");
			String[] paras = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					paras[i-1] = "para"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < paras.length; i++) {
				if (!list.contains(paras[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(paras[i]);
				}
			}
			String[] newParas = list.toArray(new String[1]);
			List<String> parasList = getParaValueList(id);
			String[] paraList = (String[]) getParaValueList(id).toArray(new String[1]);
			for(int i=0;i<newParas.length;i++){
				String para = newParas[i];
				if(!isHave(paraList, para)){
					jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, para,content });
				}
			}
			for(int i=0;i<paraList.length;i++){
				String para = paraList[i];
				if(!isHave(newParas, para)){
					jdbcTemplate.update("delete from  NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code=?", new Object[] { id, para } );
				}
			}
		}
		if(content.indexOf("compare")>-1){
			String[] str = content.split("compare");
			String[] compares = new String[str.length-1];
			for(int i=0;i<str.length;i++){
				if(i>0){
					int index = str[i].indexOf("}");
					compares[i-1] = "compare"+str[i].substring(0, index);
				}
			}
			//剔除数组中重复的
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < compares.length; i++) {
				if (!list.contains(compares[i])) {// 如果数组 list 不包含当前项，则增加该项到数组中
					list.add(compares[i]);
				}
			}
			String[] newCompares = list.toArray(new String[1]);
			List compareValueList = getCompareValueList(id);
			if(compareValueList!=null && compareValueList.size()>0){
				String[] compareList = (String[]) getCompareValueList(id).toArray(new String[1]);
				for(int i=0;i<newCompares.length;i++){
					String compare = newCompares[i];
					if(!isHave(compareList, compare)){
						String compsql = compare.replace("are", "sql");
						jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, compare,content });
						jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, compsql,content });
					}
				}
				for(int i=0;i<compareList.length;i++){
					String compare = compareList[i];
					if(!isHave(newCompares, compare)){
						jdbcTemplate.update("delete from  NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code=?", new Object[] { id, compare } );
					}
				}
			}else{
				for(int i=0;i<newCompares.length;i++){
					String compare = newCompares[i];
					String compsql = compare.replace("are", "sql");
					jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, compare,content });
					jdbcTemplate.update("insert into NWH.GLOBAL_VAL_TEXT_TEMP(id,code,value,content) values(?,?,'',?)", new Object[] { id, compsql,content });
				}
			}
		}
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set content = ? where id = ? " , new Object[] { content, id });
	}
	
	public void delete(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("delete from NWH.GLOBAL_VAL_TEXT_TEMP where id=?", new Object[] { id });
	}
	
	public void mailContentDelete(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("delete from FPF_MAIL_CONTENT_CONFIG where id=?", new Object[] { id });
	}
	
	public int getLength(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForObject("select count(1) from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%para%'",Integer.class, new Object[] {id});
	}
	
	@SuppressWarnings("rawtypes")
	public List getParaList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select id, code, value from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%para%'", new Object[] {id});
	}
	
	@SuppressWarnings("rawtypes")
	public List<String> getParaValueList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select code from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%para%'", new Object[] {id});
		List<String> result = new ArrayList<String>();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String code = (String)map.get("code");
				result.add(code);
			}
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public List<String> getMailContentParaValueList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select code from FPF_MAIL_CONTENT_CONFIG where id=? and code like '%para%'", new Object[] {id});
		List<String> result = new ArrayList<String>();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String code = (String)map.get("code");
				result.add(code);
			}
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public List getCompareValueList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select code from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%compare%'", new Object[] {id});
		List<String> result = new ArrayList<String>();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String code = (String)map.get("code");
				result.add(code);
			}
		}
		return result;
	}
	
	public void savePara(String id, String para, String sql){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value=? where id=? and code=?", new Object[] { sql, id, para});
	}
	
	public void saveMailContentPara(String id, String para, String sql){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update FPF_MAIL_CONTENT_CONFIG set value=? where id=? and code=?", new Object[] { sql, id, para});
	}
	
	public void saveCompare(String id, String compare, String compsqlvalue, String compsql, String comparesqlvalue){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value=? where id=? and code=?", new Object[] { compsqlvalue, id, compare});
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value=? where id=? and code=?", new Object[] { comparesqlvalue, id, compsql});
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getCompareList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select id, code, value, content from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%compare%' order by code", new Object[] {id});
		List sqlList = jdbcTemplate.queryForList("select id, code, value, content from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%compsql%' order by code", new Object[] {id});
		List<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
		if(list!=null && list.size()>0 && sqlList!=null && sqlList.size()>0 && list.size() == sqlList.size()){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				HashMap sqlMap = new HashMap();
				map = (HashMap)list.get(i);
				sqlMap = (HashMap)sqlList.get(i);
				String ID = map.get("id").toString();
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				String sqlCode = sqlMap.get("code").toString();
				String sqlValue = sqlMap.get("value").toString();
				HashMap res = new HashMap();
				res.put("id", ID);
				res.put("code", code);
				res.put("value", value);
				res.put("sqlCode", sqlCode);
				res.put("sqlValue", sqlValue);
				result.add(res);
			}
		}
		return result;
	}
	
	public void complete(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value = '2' where id = ? and code='status'" , new Object[] { id });
	}
	
	public void auditing(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value = '3' where id = ? and code='status'" , new Object[] { id });
	}
	
	@SuppressWarnings("rawtypes")
	public List getSqlList(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select id, code, value,content from NWH.GLOBAL_VAL_TEXT_TEMP where id=? and code like '%compsql%'",  new Object[] { id });
	}
	
	@SuppressWarnings("rawtypes")
	public String getResultTime(String code, String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String resultTime = "";
		List list = jdbcTemplate.queryForList("select VAR_NAME, VAR_TYPE, SQL_DEF, DLL_DEF, SHELL_NAME, MEMO from NWH.GLOBAL_VAL where var_name = ?", new Object[] { code });
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String sql ="";
			if(map.get("sql_def").toString().indexOf("&TASK_ID01")>-1){
				sql = map.get("sql_def").toString().replace("&TASK_ID01", time);
			}else if(map.get("sql_def").toString().indexOf("&TASK_ID")>-1){
				sql = map.get("sql_def").toString().replace("&TASK_ID", time);
			}
			List result = jdbcTemplate.queryForList(sql);
			if(result!=null && result.size()>0){
				Map map1 = (Map)result.get(0);
				resultTime = (String)map1.get("1");
			}
		}
		return resultTime;
	}
	
	public String getResult(String sql){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		StringBuffer result = new StringBuffer();
		SqlRowSet rs = jdbcTemplate.queryForRowSet(sql);
		SqlRowSetMetaData rsmd = rs.getMetaData();
		int size = rsmd.getColumnCount();
		while (rs.next()) {
			List<String> columnNames = new ArrayList<String>();
			for (int i = 0; i < size; i++) {
				String columnName = rsmd.getColumnName(i + 1);
				columnNames.add(columnName);
			}
			for (int j = 0; j < columnNames.size(); j++) {
				String value = rs.getString((String) columnNames.get(j));
				value = (value == null ? "" : value);
				if(size>1){
					int length = value.length();//value的长度
					//如果value.length<8,少于8的位数用空格补齐
					if(length<8){
						String s = "";
						for(int m=0;m<(8-length);m++){
							s = " " + s;
						}
						value = s + value;
					}
					if(j==0){
						result.append(value).append("    ");
					}else if(j==(columnNames.size()-1)){
						result.append(value).append("\r\n");
					}else{
						result.append(value).append(",").append("    ");
					}
				}else{
					result.append(value);
				}
			}
		}
		return result.toString();
	}
	
	@SuppressWarnings("rawtypes")
	public String getContent(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String content = "";
		List list = jdbcTemplate.queryForList("select content from NWH.GLOBAL_VAL_TEXT_TEMP where id = ?", new Object[] { id });
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			content = map.get("content").toString();
		}
		return content;
	}
	
	@SuppressWarnings("rawtypes")
	public String getmailContent(String id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String content = "";
		List list = jdbcTemplate.queryForList("select content from FPF_MAIL_CONTENT_CONFIG where id = ?", new Object[] { id });
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			content = map.get("content").toString();
		}
		return content;
	}
	
	public boolean isHave(String[] strs, String s) {
		/*
		 * 此方法有两个参数，第一个是要查找的字符串数组，第二个是要查找的字符或字符串
		 */
		for (int i = 0; i < strs.length; i++) {
			if (strs[i].indexOf(s) != -1) {// 循环查找字符串数组中的每个字符串中是否包含所有查找的内容
				return true;// 查找到了就返回真，不在继续查询
			}
		}
		return false;// 没找到返回false
	}
	
	@SuppressWarnings("rawtypes")
	public List getArea(String cityId){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "select key, value from (select area_id key, area_code ,case when area_name='湖北' then '全省' else area_name end  value from mk.bt_area ";
		if(!"".equals(cityId) && !"0".equals(cityId)){
			sql = sql + " ) a where area_id = "+cityId;
		}else if(!"".equals(cityId) && "0".equals(cityId)){
			sql = sql + " union all select 0 key, 'HB' , '全省' value from sysibm.sysdummy1) a ";
		}
		sql = sql + " order by case when value='全省' then 0 else 1 end ";
		return jdbcTemplate.queryForList(sql);
	}
	
	public void timeSave(String id, String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String newId = String.valueOf(jdbcTemplate.queryForObject(("select max(int(id)) from nwh.GLOBAL_VAL_TEXT_TEMP"),Integer.class)+1);
		String sql = "insert into NWH.GLOBAL_VAL_TEXT_TEMP(ID, CODE, VALUE, CONTENT) select '"+newId+"', CODE, VALUE, CONTENT from NWH.GLOBAL_VAL_TEXT_TEMP where id='"+id+"'";
		jdbcTemplate.update(sql);
		jdbcTemplate.update("update NWH.GLOBAL_VAL_TEXT_TEMP set value = '1' where id='"+id+"' and code = 'status'");
	}
	
	@SuppressWarnings("rawtypes")
	public void insertMailContent(String id, String mailContent){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select * from FPF_MAIL_CONTENT_CONFIG where code='content'");
		if(list!=null && list.size()>0){
			jdbcTemplate.update("update FPF_MAIL_CONTENT_CONFIG set content=? where id=?", new Object[] { mailContent, id });
		}else{
			jdbcTemplate.update("insert into FPF_MAIL_CONTENT_CONFIG(id,code,value,content) values(?,'content','',?)", new Object[] { id, mailContent });
		}
		
	}
	
	@SuppressWarnings("rawtypes")
	public String getMailContent(String id){
		String content = "";
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List list = jdbcTemplate.queryForList("select content from FPF_MAIL_CONTENT_CONFIG where id = ? and code='content' ", new Object[] { id });
		if(list!=null && list.size()>0){
			HashMap map = (HashMap)list.get(0);
			content = map.get("content").toString();
		}
		return content;
	}
	
	@SuppressWarnings("rawtypes")
	public int insertSendMailJob(HashMap map){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String d = DateUtil.getCurrentDate("HH:mm:ss");
		String content = map.get("mailContent").toString().replaceAll("\r\n", "<br>").replaceAll("\n", "<br>");
		return jdbcTemplate.update("insert into FPF_SENDMAILJOB(subject, mail,content,status,pushtime) values(?, ?, ?, '0',?)", new Object[] { map.get("title").toString(), map.get("mail").toString(), content, d});
	}
	
	@SuppressWarnings("rawtypes")
	public int insertSendMailJobForAttachment(HashMap map){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String d = DateUtil.getCurrentDate("HH:mm:ss");
		String content = map.get("mailContent").toString().replaceAll("\r\n", "<br>").replaceAll("\n", "<br>");
		return jdbcTemplate.update("insert into FPF_SENDMAILJOB(subject, mail,content,fileserver,attachment,status,pushtime) values(?, ?, ?, ?, ?, '0',?)", new Object[] { map.get("title").toString(), map.get("mail").toString(), content,"10.25.124.111",map.get("path").toString(), d});
	}
	
	@SuppressWarnings("rawtypes")
	public List getSmsList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		return jdbcTemplate.queryForList("select dim2, dim3, dim4, dim5, int(sum(ind1)) ind1, int(sum(ind3)) ind3 from report_total where REPORT_CODE='SNAPSHOT_JZ1' and time_id="+time+" and dim2 is not null and dim3 is not null and dim4 is not null and dim5 is not null group by dim2,dim3,dim4,dim5 order by dim2,dim3,dim4,dim5 with ur ");
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getSender(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		List list = jdbcTemplate.queryForList("select manager_accnbr,manager_name from nmk.snapshotpush_month_"+time+"_use where manager_accnbr is not null and manager_accnbr<>'0'  group by manager_accnbr,manager_name " );
		String[] senders = new String[list.size()];
		String[] managers = new String[list.size()];
		HashMap result = new HashMap();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				senders[i] = map.get("manager_accnbr").toString();
				managers[i] = map.get("manager_name").toString();
				result.put("senders", senders);
				result.put("managers", managers);
			}
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap getSenders(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		List list = jdbcTemplate.queryForList("select wxr_tel,value(wxr_name,'未填写') wxr_name from nmk.stock_khfb_userlist_"+time+" where wxr_tel is not null and wxr_tel<>'0'  group by wxr_tel,wxr_name " );
		String[] senders = new String[list.size()];
		String[] managers = new String[list.size()];
		HashMap result = new HashMap();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				senders[i] = map.get("wxr_tel").toString();
				managers[i] = map.get("wxr_name").toString();
				result.put("senders", senders);
				result.put("managers", managers);
			}
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public List getListForDay(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		return jdbcTemplate.queryForList("select dim2, dim3, dim4, dim5, int(sum(ind1)) ind1 ,int(sum(ind2)) ind2, int(sum(ind3)) ind3, int(sum(ind4)) ind4, int(sum(ind5)) ind5, int(sum(ind6)) ind6, int(sum(ind7)) ind7,int(sum(ind8)) ind8, int(sum(ind9)) ind9, int(sum(ind10)) ind10, int(sum(ind11)) ind11 from report_total where report_code = 'SNAPSHOT_JZ4' and time_id="+time+" and dim5<>'0' group by dim2,dim3,dim4,dim5 order by dim2,dim3,dim4,dim5 with ur ");
	}
	
	@SuppressWarnings("rawtypes")
	public List getListToWxrForDay(String time, String type){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		if("1".equals(type)){
			return jdbcTemplate.queryForList("SELECT AREA_NAME ,VALUE(COUNTY_NAME,AREA_NAME) COUNTY_NAME,VALUE(ZONE_NAME,'未知') ZONE_NAME,WXR_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT, SERVBIND_PP,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_WXR_"+time.substring(0, 6)+" WHERE TIME_ID="+time+" and AREA_NAME IN ('荆州','天门') and WXR_TEL is not null WITH UR");
		}else if("2".equals(type)){
			return jdbcTemplate.queryForList("SELECT AREA_NAME ,VALUE(COUNTY_NAME,AREA_NAME) COUNTY_NAME ,VALUE(ZONE_NAME,'未知') ZONE_NAME, TEAM_TEL,TARGET_CNT,STOCK_CNT ,STOCK_PP,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND  ,ADD_DEEPBIND_LJ  ,DEEPBIND_CNT,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT,ADD_HJH_CNT ,SERVBIND_CNT,SERVBIND_PP ,VPMN_ACTIVE_PP,HJH_ACTIVE_PP ,FB_CHANGE,FB_CHANGE_PP FROM NMK.STOCK_KHFB_TEAM_"+time.substring(0, 6)+" WHERE TIME_ID="+time+" and AREA_NAME IN ('荆州','天门') and TEAM_TEL is not null WITH UR");
		}else if("3".equals(type)){
			return jdbcTemplate.queryForList("SELECT AREA_NAME ,VALUE(COUNTY_NAME,AREA_NAME) COUNTY_NAME ,COUNTY_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT ,SERVBIND_PP ,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_COUNTY_"+time.substring(0, 6)+" WHERE TIME_ID="+time+" and AREA_NAME IN ('荆州','天门') and COUNTY_TEL is not null WITH UR");
		}else if("4".equals(type)){
			return jdbcTemplate.queryForList("SELECT AREA_NAME ,AREA_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT ,SERVBIND_PP ,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_AREA_"+time.substring(0, 6)+" WHERE TIME_ID="+time+" and AREA_NAME IN ('荆州','天门') and AREA_TEL is not null WITH UR");
		}
		return null;
	}
	
	@SuppressWarnings("rawtypes")
	public List getListToWxrForDay1(String para, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		return jdbcTemplate.queryForList("SELECT AREA_NAME ,COUNTY_NAME ,ZONE_NAME ,WXR_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT, SERVBIND_PP,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_WXR_"+para.substring(0, 6)+" WHERE TIME_ID="+para+" and AREA_NAME IN ('荆州','天门') and WXR_TEL in ('"+sender+"') WITH UR");
	}
	@SuppressWarnings("rawtypes")
	public List getListToTEAMForDay1(String para, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		return jdbcTemplate.queryForList("SELECT AREA_NAME ,COUNTY_NAME ,ZONE_NAME, TEAM_TEL,TARGET_CNT,STOCK_CNT ,STOCK_PP,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND  ,ADD_DEEPBIND_LJ  ,DEEPBIND_CNT,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT,ADD_HJH_CNT ,SERVBIND_CNT,SERVBIND_PP ,VPMN_ACTIVE_PP,HJH_ACTIVE_PP ,FB_CHANGE,FB_CHANGE_PP FROM NMK.STOCK_KHFB_TEAM_"+para.substring(0, 6)+" WHERE TIME_ID="+para+" and AREA_NAME IN ('荆州','天门') and TEAM_TEL in ('"+sender+"') WITH UR");
	}
	@SuppressWarnings("rawtypes")
	public List getListToCOUNTYForDay1(String para, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		return jdbcTemplate.queryForList("SELECT AREA_NAME ,COUNTY_NAME ,COUNTY_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT ,SERVBIND_PP ,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_COUNTY_"+para.substring(0, 6)+" WHERE TIME_ID="+para+" and AREA_NAME IN ('荆州','天门') and COUNTY_TEL in ('"+sender+"') WITH UR");
	}
	@SuppressWarnings("rawtypes")
	public List getListToAREAForDay1(String para, String sender){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		return jdbcTemplate.queryForList("SELECT AREA_NAME ,AREA_TEL ,TARGET_CNT ,STOCK_CNT ,STOCK_PP ,WILL_LEAVE_CNT ,LEAVE_PP ,ADD_DEEPBIND ,ADD_DEEPBIND_LJ ,DEEPBIND_CNT ,DEEPBIND_PP ,ADD_SERVBIND_CNT ,ADD_VPMN_CNT ,ADD_HJH_CNT ,SERVBIND_CNT ,SERVBIND_PP ,VPMN_ACTIVE_PP ,HJH_ACTIVE_PP ,FB_CHANGE ,FB_CHANGE_PP FROM NMK.STOCK_KHFB_AREA_"+para.substring(0, 6)+" WHERE TIME_ID="+para+" and AREA_NAME IN ('荆州','天门') and AREA_TEL in ('"+sender+"') WITH UR");
	}
	@SuppressWarnings("rawtypes")
	public List getListForWeek(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		return jdbcTemplate.queryForList("select dim2, dim3, dim4, dim5, int(sum(ind1)) ind1 ,int(sum(ind2)) ind2, int(sum(ind3)) ind3, ipd.tochar2(decimal(round(sum(double(ind4))/sum(double(ind1)),4)*100,30,2))||'%' ind4, int(sum(ind5)) ind5, int(sum(ind6)) ind6, int(sum(ind7)) ind7,ipd.tochar2(case when sum(ind5)=0 then 0 else decimal(round(sum(double(ind8))/sum(double(ind5)),4)*100,30,2) end)||'%' ind8, int(sum(ind9)) ind9, int(sum(ind10)) ind10, ipd.tochar2(case when sum(ind9)=0 then 0 else decimal(round(sum(double(ind11))/sum(double(ind9)),4),30,2) end)||'%' ind11 from report_total where report_code = 'SNAPSHOT_JZ5' and time_id="+time+" and dim5<>'0' group by dim2,dim3,dim4,dim5 order by dim2,dim3,dim4,dim5 with ur ");
	}
	@SuppressWarnings("rawtypes")
	public List getListForMonth(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		return jdbcTemplate.queryForList("select dim2 ,dim3 ,dim4 ,dim5,int(sum(ind1)) ind1,int(sum(ind2)) ind2,int(sum(ind3)) ind3,int(sum(ind4)) ind4,ipd.tochar2(decimal(round(sum(double(ind5))/sum(double(ind1)),4)*100,30,2))||'%' ind5,int(sum(ind6)) ind6,int(sum(ind7)) ind7,ipd.tochar2(decimal(round(sum(double(ind25))/sum(double(ind1)),4)*100,30,2))||'%' ind8,ipd.tochar2(decimal(round(sum(double(ind8))/sum(double(ind1)),4)*100,30,2))||'%' ind9 ,ipd.tochar2(decimal(round(sum(double(ind9))/sum(double(ind1)),4)*100,30,2))||'%' ind10,ipd.tochar2(decimal(round(sum(double(ind10))/sum(double(ind1)),4)*100,30,2))||'%' ind10s,int(sum(ind11)) ind11,int(sum(ind12)) ind12,int(sum(ind13)) ind13,int(sum(ind14)) ind14,int(sum(ind15)) ind15,ipd.tochar2(case when sum(double(ind11))=0 then 0 else decimal(round(sum(double(ind16))/sum(double(ind11)),4)*100,30,2) end)||'%' ind16,int(sum(ind17)) ind17,int(sum(ind18)) ind18,ipd.tochar2(case when sum(double(ind11))=0 then 0 else decimal(round(sum(double(ind26))/sum(double(ind11)),4)*100,30,2) end)||'%' ind19,ipd.tochar2(case when sum(double(ind11))=0 then 0 else decimal(round(sum(double(ind19))/sum(double(ind11)),4)*100,30,2) end)||'%' ind20,ipd.tochar2(case when sum(double(ind11))=0 then 0 else decimal(round(sum(double(ind20))/sum(double(ind11)),4)*100,30,2) end)||'%' ind21,ipd.tochar2(case when sum(double(ind11))=0 then 0 else decimal(round(sum(double(ind21))/sum(double(ind11)),4)*100,30,2) end)||'%' ind22,int(sum(ind22)) ind22s,int(sum(ind23)) ind23,ipd.tochar2(case when sum(double(ind22))=0 then 0 else decimal(round(sum(double(ind24))/sum(double(ind22)),4)*100,30,2) end)||'%' ind24 from report_total where REPORT_CODE='SNAPSHOT_JZ6' and dim5<>'0' and time_id="+time+" group by dim2,dim3,dim4,dim5 order by dim2,dim3,dim4,dim5 with ur");
	}
	
	public void insertMMS(String subject, String contacts, String type, String content, String status){
		String d = DateUtil.getCurrentDate("HH:mm:ss");
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into SENDMMSJOB(subject, sender, type, content, pushtime, status) values(?, ?, ?, ?, ?, ?)", new Object[] { subject, contacts, type, content, d, status});
	}
	@SuppressWarnings("rawtypes")
	public List getSenderList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		return jdbcTemplate.queryForList("select area_code, mail from nwh.dim_pho_chl ");
	}
	@SuppressWarnings("rawtypes")
	public List getContentList(String time, String area_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw,false);
		if(!"".equals(area_code) && area_code.equals("HB")){
			return jdbcTemplate.queryForList("select area_code, stat from nwh.mon_chl_stat where time_id="+time+" and hb='"+area_code+"' ");
		}else {
			return jdbcTemplate.queryForList("select area_code, stat from nwh.mon_chl_stat where time_id="+time+" and area_code='"+area_code+"' ");
		}
	}
	@SuppressWarnings("rawtypes")
	public List getSMSParaList(String content){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,false);
		return jdbcTemplate.queryForList("select para, sql, ds from sms_para where name='"+content+"' order by para");
	}
	@SuppressWarnings("rawtypes")
	public String getSMSValue(String sql, String ds){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		List list = jdbcTemplate.queryForList(sql);
		if(list!=null & list.size()>0){
			HashMap result = (HashMap)list.get(0);
			return String.valueOf(result.get("cnt"));
		}else {
			return "";
		}
	}
	
	public void insertSendMMSJob(String sender, String content, String status, String time){
		String d = DateUtil.getCurrentDate("HH:mm:ss");
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into FPF_SENDSMSJOB(sender,content,pushtime,status,sendinfo,para) values('"+sender+"','"+content+"','"+d+"','"+status+"','短信内容生成成功，带发送','"+time+"')");
	}
}

