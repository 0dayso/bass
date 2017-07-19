/**
 * 
 */
package com.asiainfo.hb.core.datastore;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.SqlParameterValue;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Component;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * @author Mei Kefu
 * @date 2011-9-21
 */
@Component
public class SqlUpdate {

	private static Logger LOG = Logger.getLogger(SqlUpdate.class);

	public Object execute(String dataSource,String sql){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", true);
		result.put("msg", "执行SQL:"+sql+"成功");
		
		try{
			jdbcTemplate.execute(sql);
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(),e);
			result.put("success", false);
			result.put("msg", "执行SQL:"+sql+"成功");
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public Object batchExecute(final String dataSource,final List sqls){
		final Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", false);
		result.put("msg", "批量执行SQL失败");
		try{
			DataSource ds = JdbcTemplate.getDataSource(dataSource);
			DataSourceTransactionManager transactionManager = new DataSourceTransactionManager(ds);
			TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
			
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				public void doInTransactionWithoutResult(TransactionStatus status) {
					JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
					for (int i = 0; i < sqls.size(); i++) {
						String sql = (String)sqls.get(i);
						jdbcTemplate.execute(sql);
					}
					result.put("success", true);
					result.put("msg", "批量执行SQL成功");
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(),e);
			result.put("msg", e.getMessage());
		}
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public Object cud(final String cmd,final String dataSource,final String tableName,final String primaryKey,final List records){
		final Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", false);
		result.put("msg", "更新数据失败");
		try{
			DataSource ds = JdbcTemplate.getDataSource(dataSource);
			DataSourceTransactionManager transactionManager = new DataSourceTransactionManager(ds);
			TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
			
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@SuppressWarnings("unchecked")
				@Override
				public void doInTransactionWithoutResult(TransactionStatus status) {
					if("insert".equalsIgnoreCase(cmd)){
						save(dataSource,tableName, primaryKey,records,result);
					}else if("delete".equalsIgnoreCase(cmd)){
						delete(dataSource,tableName, primaryKey,records,result);
					}else if("update".equalsIgnoreCase(cmd)){
						modify(dataSource,tableName, primaryKey,records,result);
					}
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(),e);
			result.put("msg", e.getMessage());
		}
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public void delete(String dataSource,String tableName,String primaryKey,List records,Map<String,Object> result){
		if(records.size()>0){
			StringBuilder sql = new StringBuilder();
			sql.append("delete from ").append(tableName).append(" where ");
			
			boolean isMultiPk = false;
			//是否符合主键
			String[] pks = primaryKey.split(",");
			if(pks.length>1){
				isMultiPk=true;
				for (int i = 0; i < pks.length; i++) {
					sql.append(pks[i]).append("=? and ");
				}
				sql.delete(sql.length()-5, sql.length()-1);
			}else{
				sql.append(primaryKey).append("=?");
			}
			
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
			for (int i = 0; i < records.size(); i++) {
				Map record = (Map)records.get(i);
				
				if(isMultiPk){
					Object[] paramPks = new Object[pks.length];
					
					for (int j = 0; j < pks.length; j++) {
						paramPks[j]=record.get(pks[j]);
					}
					LOG.info("delete SQL："+sql.toString()+",binding val : "+Arrays.toString(paramPks));
					int row = jdbcTemplate.update(sql.toString(),paramPks);
					if(row<0){
						throw new RuntimeException("更新数据失败：delete SQL："+sql.toString()+",binding val : "+Arrays.toString(paramPks));
					}
				}else{
					Object pkVal = record.get(primaryKey);
					LOG.info("delete SQL："+sql.toString()+",binding val : "+pkVal);
					int row = jdbcTemplate.update(sql.toString(),new Object[]{pkVal});
					if(row<0){
						throw new RuntimeException("更新数据失败：delete SQL："+sql.toString()+",binding val : "+pkVal);
					}
				}
			}
			result.put("success", true);
			result.put("msg", "成功更新数据");
		}else{
			result.put("msg", "记录集[records]为空或不正确");
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	protected String builderSql(String tableName,String primaryKey,Map record ,List<String> columnNames,String[] pks,Map<String,Integer> columnsType){
		StringBuilder sql = new StringBuilder();
		sql.append("update ").append(tableName);
		int idx = 0;
		sql.append(" set ");
		
		columnNames.clear();//有可能重复调用，需要清空
		for (Iterator iterator = record.keySet().iterator(); iterator.hasNext();) {
			String obj =  (String)iterator.next();
			if(columnsType.containsKey(obj.toUpperCase())){
				sql.append(obj).append("=?,");
				columnNames.add(obj);
				idx++;
			}
		}
		sql.deleteCharAt(sql.length()-1).append(" where ");
		
		//是否符合主键
		if(pks.length>1){
			for (int i = 0; i < pks.length; i++) {
				sql.append(pks[i]).append("=? and ");
			}
			sql.delete(sql.length()-5, sql.length()-1);
		}else{
			sql.append(primaryKey).append("=?");
		}
		return sql.toString();
	}

	@SuppressWarnings("rawtypes")
	public void modify(String dataSource,String tableName,String primaryKey,List<Map> records,Map<String,Object> result){
		if(records.size()>0){
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
			//查询数据库得到表中的所有字段的类型
			Map<String,Integer> columnsType = getColumnsType(jdbcTemplate, tableName);
			
			String[] pks = primaryKey.split(",");
			List<String> columnNames = new ArrayList<String>();
			String sql = builderSql(tableName, primaryKey, records.get(0),columnNames,pks,columnsType);
			int recordFiledCount = records.get(0).size();
			boolean recordFiledDifferent = false;
			for (int i = 0; i < records.size(); i++) {
				Map record= records.get(i);
				
				if( !recordFiledDifferent && recordFiledCount!= record.size()){//当record中字段的属性不同时，就需要每条更新
					recordFiledDifferent = true;
				}
				
				if(recordFiledDifferent){
					sql = builderSql(tableName, primaryKey, record,columnNames,pks,columnsType);
				}
				
				Object[] objs = new Object[columnNames.size()+pks.length];
				for (int j = 0; j < columnNames.size(); j++) {
					objs[j]=record.get(columnNames.get(j));
					objs[j] = specialDateTypeHandle(objs[j],columnNames.get(j),columnsType);
				}
				
				for (int j = 0; j < pks.length; j++) {
					objs[objs.length-(pks.length-j)]=record.get(pks[j]);
				}
				
				LOG.info("update SQL："+sql.toString()+",binding val : "+Arrays.toString(objs));
				int row = jdbcTemplate.update(sql.toString(),objs);
				if(row<=0){
					throw new RuntimeException("更新数据失败：update SQL："+sql.toString()+",binding val : "+Arrays.toString(objs));
				}
			}
			result.put("success", true);
			result.put("msg", "成功更新数据");
		}else{
			result.put("msg", "记录集[records]为空或不正确");
		}
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	protected Map<String,Integer> getColumnsType(JdbcTemplate jdbcTemplate, String tableName){
		//得到每一字段的原信息
		return (Map<String,Integer>)jdbcTemplate.query("select * from "+tableName+" where 1=2", new ResultSetExtractor(){

			@Override
			public Map<String,Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
									
				ResultSetMetaData rsmd = rs.getMetaData();
				int length = rsmd.getColumnCount();
				Map<String,Integer> map = new HashMap<String,Integer>();
				for (int i = 0; i < length; i++) {
					int idx = i + 1;
					String name = rsmd.getColumnName(idx).toUpperCase();
					int type = rsmd.getColumnType(idx);
//					int width = rsmd.getColumnDisplaySize(idx);
					map.put(name, type);
				}
				return map;
			}
		});
	}
	
	
	private Object specialDateTypeHandle(Object val,String columnName,Map<String,Integer> columnsType){
		Object res = val;
		SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//wangqs 更新传入的字段有可能在表中不存在
		/*if(columnsType.get(columnName.toUpperCase())==null){
			LOG.error("错误,更新的表中不存在字段:"+columnName);
			return null;
		}*/
		int sqlType = columnsType.get(columnName.toUpperCase());
		if (val!=null && (Types.DATE == sqlType || Types.TIME == sqlType || Types.TIMESTAMP == sqlType)) {
			// 要对日期为空或者为特殊字符进行处理
			try {
				if(val instanceof Long){
					res = new SqlParameterValue(sqlType, new Date((Long)val));
				}else{
					String _fmtDate = val.toString().replace("T", " ");
					if(_fmtDate.length()==10){
						_fmtDate += " 00:00:00"; 
					}
					res = new SqlParameterValue(sqlType, formatDate.parse(_fmtDate));
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
	/*	}else if(Types.BLOB==sqlType){
			res = new javax.sql.rowset.serial.SerialBlob(objs[j].toString().getBytes());
		}else if(Types.CLOB==sqlType){
			//上海Clob乱码问题
			//objValue = new javax.sql.rowset.serial.SerialClob(EasyStr.gbkToISO(value).toCharArray());
			res = new javax.sql.rowset.serial.SerialClob(objs[j].toString().toCharArray());*/
			//by zhangds 在integer时报错
		}else if (val != null){
			res = new SqlParameterValue(sqlType, val.toString()); 
		}
		return res;
	}
	
	
	@SuppressWarnings("rawtypes")
	public void save(String dataSource,String tableName,String primaryKey,List records,Map<String,Object> result){
		if(records.size()>0){
			StringBuilder pix = new StringBuilder();
			pix.append("insert into ").append(tableName);
			//Map record = (Map)records.get(0);
			
			pix.append("(");
			
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
			
			Map<String,Integer> columnsType = getColumnsType(jdbcTemplate, tableName);
			
//			for (Iterator iterator = record.keySet().iterator(); iterator.hasNext();) {
//				String obj = (String) iterator.next();
//				
//				if(columnsType.containsKey(obj.toUpperCase())){
//					sql.append(obj).append(",");
//					columnNames.add(obj);
//				}
//			}
//			sql.deleteCharAt(sql.length()-1);
//			
//			sql.append(") values (");
//			
//			for (int i = 0; i < columnNames.size(); i++) {
//				sql.append("?,");
//			}
//			sql.deleteCharAt(sql.length()-1);
//			sql.append(")");
			/*
			 * by zhangds 用于批量更新的时候,光用第一行数据更新，会丢失某些列值(效率有所降低)
			 */
			StringBuffer sql = null;
			
			for (int i = 0; i < records.size(); i++) {
				Map record = (Map)records.get(i);
				List<String> columnNames = new ArrayList<String>();
				sql = new StringBuffer(pix.toString());
				for (Iterator iterator = record.keySet().iterator(); iterator
						.hasNext();) {
					String obj = (String) iterator.next();

					if (columnsType.containsKey(obj.toUpperCase())) {
						sql.append(obj).append(",");
						columnNames.add(obj);
					}
				}
				sql.deleteCharAt(sql.length() - 1);

				sql.append(") values (");

				for (int x = 0; x < columnNames.size(); x++) {
					sql.append("?,");
				}
				sql.deleteCharAt(sql.length() - 1);
				sql.append(")");
				
				Object[] objs = new Object[columnNames.size()];
				
				for (int j = 0; j < columnNames.size(); j++) {
					objs[j]=specialDateTypeHandle(
								record.get(columnNames.get(j))
								,columnNames.get(j)
								,columnsType);
					/*if(objs[j]==null){
						result.put("msg", "插入表数据失败：表不存在数据字段:"+columnNames.get(j));
						throw new RuntimeException("插入表数据失败：表不存在数据字段:"+columnNames.get(j));
					}*/
				}
				LOG.info("insert SQL："+sql.toString()+",binding val : "+Arrays.toString(objs));
			
				int row = jdbcTemplate.update(sql.toString(),objs);
				if(row<=0){
					throw new RuntimeException("更新数据失败：insert SQL："+sql.toString()+",binding val : "+Arrays.toString(objs));
				}
			}
			result.put("success", true);
			result.put("msg", "成功更新数据");
		}else{
			result.put("msg", "记录集[records]为空或不正确");
		}
	}
}

