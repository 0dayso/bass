package com.asiainfo.hb.core.datastore;

import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedCaseInsensitiveMap;

import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * @author Mei Kefu
 */
@Component
public class SqlQuery {

	private static Logger LOG = Logger.getLogger(SqlQuery.class);
	
	/**
	 * 通过SQL查询数据，返回结果集
	 * @param sql
	 * @param dataSource
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List query(String sql, String dataSource) {
		return query(sql, dataSource, false);
	}
	
	/**
	 * 通过SQL查询数据，返回结果集
	 * @param sql
	 * @param dataSource
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List query(String sql, String dataSource,boolean isCached) {
		List result = null;
		try{
			DataSource ds = (DataSource)BeanFactory.getBean(dataSource);
			JdbcTemplate jdbcTemplate = new JdbcTemplate(ds,isCached);
			sql=charFilter(sql);
			LOG.debug(sql);
			if(sql.trim().length()>7 && (sql.trim().substring(0, 7).equalsIgnoreCase("select ") || sql.trim().substring(0, 4).equalsIgnoreCase("with") )){
				result = jdbcTemplate.queryForList(sql);
			} else {
				LOG.error("SQL不正确");
			}
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			result = new ArrayList();
		}
		return result;
	}
	
	/**
	 * 分页的SQL
	 * @param sql
	 * @param dataSource
	 * @param limit
	 * @param start
	 * @return
	 */
	public SqlQueryResultVo queryLimit(String sql,String dataSource,String limit,String start) {
		return queryLimit(sql, dataSource, limit, start,false);
	}
	
	/**
	 * 分页的SQL
	 * @param sql
	 * @param dataSource
	 * @param limit
	 * @param start
	 * @return
	 */
	public SqlQueryResultVo queryLimit(String sql,String dataSource,String limit,String start,boolean isCached) {
		return queryLimit(sql, dataSource, limit, start, null, isCached);
	}
	
	/**
	 * 分页的SQL
	 * @param sql
	 * @param dataSource
	 * @param limit
	 * @param start
	 * @param colMapping 维度映射
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public SqlQueryResultVo queryLimit(String sql,String dataSource,String limit,String start,Map colMappingKey) {
		return queryLimit(sql, dataSource, limit, start, colMappingKey, false);
	}
	
	/**
	 * 分页的SQL
	 * @param sql
	 * @param dataSource
	 * @param limit
	 * @param start
	 * @param colMapping 维度映射
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public SqlQueryResultVo queryLimit(String sql,String dataSource,String limit,String start,Map colMappingKey,boolean isCached) {
		int nLimit = 0;
		int nStart = 0;
		if(limit!=null && limit.matches("[0-9]+")){
			nLimit = Integer.parseInt(limit);
		}
		if(start!=null && start.matches("[0-9]+")){
			nStart = Integer.parseInt(start);
			if(nStart<0){
				nStart=0;
			}
		}
		SqlQueryResultVo sqlQueryResultVo = null;
		try{
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,isCached);
			SqlPageHelper sqlPageHelper = jdbcTemplate.getSqlPageHelper();
			
			final Map colMapping = fetchDimMapping(colMappingKey, dataSource);
			
			sqlQueryResultVo = (SqlQueryResultVo)jdbcTemplate.query(
					nLimit>0?sqlPageHelper.getLimitSQL(sql, nLimit, nStart):sql
					,new ResultSetExtractor() {
						
						boolean isExportDimMappingOrigin = false;//是否需要到处映射的原始字段初始化 //这个还没有写测试用例
						
						@Override
						public SqlQueryResultVo extractData(ResultSet rs)throws SQLException, DataAccessException {
							
							SqlQueryResultVo sqlQueryResultVo = new SqlQueryResultVo();
							ResultSetMetaData rsmd = rs.getMetaData();
							int columnCount = rsmd.getColumnCount();
							
							List<Map<String,String>> fields = new ArrayList<Map<String,String>>();
							List<Map<String,String>> columnModel = new ArrayList<Map<String,String>>();
							
							for (int i = 1; i <= columnCount; ++i) {//初始化fields与columnModel
								String key = JdbcUtils.lookupColumnName(rsmd, i).toUpperCase();
								if (!isPseudoColumn(key)) {//非伪列
									String columnType = rsmd.getColumnTypeName(i);
									metaInfoProcess(key,columnType,fields,columnModel,colMapping.containsKey(key));
									if(colMapping.containsKey(key) && isExportDimMappingOrigin ){
										metaInfoProcess( key+".ORIGIN",columnType,fields,columnModel,false);
									}
								}
							}
							sqlQueryResultVo.setColumnModel(columnModel);
							sqlQueryResultVo.setFields(fields);
							
							List<Map<String,Object>> results = new ArrayList<Map<String,Object>>();
							while (rs.next()) {
								Map mapOfColValues = new LinkedCaseInsensitiveMap(columnCount);
								for (int i = 1; i <= columnCount; ++i) {
									String key = JdbcUtils.lookupColumnName(rsmd, i).toUpperCase();
									if (!isPseudoColumn(key)) {//非伪列
										Object sourceObj = JdbcUtils.getResultSetValue(rs, i);
										if(colMapping.containsKey(key)){//是需要维度映射的
											Map<String,String> dimMap = (Map<String,String>)colMapping.get(key);
											String val = sourceObj!=null?sourceObj.toString():"null";
											mapOfColValues.put(key, dimMap.containsKey(val)?dimMap.get(val):val);//映射
											//是否需要输出原始值
											if(isExportDimMappingOrigin)
												mapOfColValues.put(key+".ORIGIN", sourceObj);
										}else{
											int sqlType = rsmd.getColumnType(i);
											if (sourceObj!=null && (Types.DATE == sqlType || Types.TIME == sqlType || Types.TIMESTAMP == sqlType)) {
												String _fmtDate = sourceObj.toString();
												mapOfColValues.put(key, _fmtDate.length()>19?_fmtDate.substring(0,19):_fmtDate);
											}else{
												if(sourceObj instanceof byte[]){
													try {
														sourceObj = new String((byte[])sourceObj,"utf-8");
													} catch (UnsupportedEncodingException e) {
														e.printStackTrace();
													}
												}
												mapOfColValues.put(key, sourceObj);
											}
										}
									}
								}
								results.add(mapOfColValues);
							}
							sqlQueryResultVo.setRoot(results);
							return sqlQueryResultVo;
						}

						private void metaInfoProcess(String key,String columnType,List<Map<String,String>> fields,List<Map<String,String>> columnModel,boolean isDimMappingKey){
							Map<String,String> field = new HashMap<String,String>();
							field.put("name", key);
							if (columnType.toUpperCase().equalsIgnoreCase("DATE")) {
								field.put("dateFormat", "Y-m-d");
							} else if (columnType.toUpperCase().equalsIgnoreCase("TIMESTAMP")) {
								field.put("dateFormat", "Y-m-d H:i:s");
							}
							field.put("type",dbTypeMapping(columnType.toUpperCase(),isDimMappingKey));
							fields.add(field);

							Map<String,String> column = new HashMap<String,String>();
							column.put("dataIndex", key);
							column.put("header", key);
							column.put("type",dbTypeMapping(columnType.toUpperCase(),isDimMappingKey));
							columnModel.add(column);
						}
						
						/**
						 * 判断是否是生成分页SQL时的伪列
						 * @param key
						 * @return
						 */
						private boolean isPseudoColumn(String key){
							return "pseudo_column_rownum".equalsIgnoreCase(key);
						}
						/**
						 * 
						 * @param oriType
						 * @param isDimMappingKey 是否是维度映射，维度映射直接返回string类型
						 * @return
						 */
						private String dbTypeMapping(String oriType,boolean isDimMappingKey) {
							if(isDimMappingKey){
								return "string";
							}
							
							if ("INT".equals(oriType) || "BIGINT".equals(oriType) || "INTEGER".equals(oriType) || "SMALLINT".equals(oriType)) {
								return "int";
							} else if ("DECIMAL".equals(oriType) || "DOUBLE".equals(oriType)) {
								return "float";
							} else if ("TIMESTAMP".equals(oriType) || "DATE".equals(oriType) || "TIME".equals(oriType)) {
								return "date";
							} else {
								return "string";
							}
						}
					}
				);
			
			int count=sqlQueryResultVo.getRoot().size();//计数器
			//2.超过极限说明数据没有查询完整，需要countSQL一下
			int total = 0;//.返回值，总的元素数量
			if(nLimit==count|| (nStart>=nLimit && nLimit>0) ){//只有第一页，并且查询的元素不满足最大分页数的时候才不需要查询总数
				total=new JdbcTemplate(dataSource,true).queryForObject(sqlPageHelper.getCountSQL(sql),Integer.class);
			}
			sqlQueryResultVo.setCount(count>total?count/*+nStart-1*/:total);
			
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			sqlQueryResultVo = new SqlQueryResultVo();
			sqlQueryResultVo.setMessage("SQL语句有错误");
			sqlQueryResultVo.setErrorMsg(e.getCause().getLocalizedMessage());
		}
		return sqlQueryResultVo;
	}
	
	@SuppressWarnings("rawtypes")
	public Map queryLimit1(String sql,String dataSource,String limit,String start) {
		return queryLimit1(sql, dataSource, limit, start, false);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map queryLimit1(String sql,String dataSource,String limit,String start,boolean isCached) {
		
		int nLimit = 0;
		int nStart = 1;
		if(limit!=null && limit.matches("[0-9]+")){
			nLimit = Integer.parseInt(limit);
		}
		if(start!=null && start.matches("[0-9]+")){
			nStart = Integer.parseInt(start);
			if(nStart<=0){
				nStart=1;
			}
		}
		Map result = new HashMap();
		
		try{
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource,isCached);
			SqlPageHelper sqlPageHelper = jdbcTemplate.getSqlPageHelper();
			List data = jdbcTemplate.queryForList(sqlPageHelper.getLimitSQL(sql, nLimit, nStart));
			
			int count=data.size();//计数器
			//2.超过极限说明数据没有查询完整，需要countSQL一下
			int total = 0;//.返回值，总的元素数量
			if(nLimit==count){
				total=jdbcTemplate.queryForObject(sqlPageHelper.getCountSQL(sql),Integer.class);
			}
			
			result.put("data", data);
			result.put("total", count>total?count/*+nStart-1*/:total);
			result.put("start", nStart);
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			result.put("message", "SQL语句有错误");
		}
		return result;
	}
	/**
	 * 随机取前多少条数据
	 * @param sql
	 * @param dataSource
	 * @param rows
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public Map queryPiece(String sql, String dataSource, String rows) {
		return queryPiece(sql, dataSource, rows,false);
	}
	
	/**
	 * 随机取前多少条数据
	 * @param sql
	 * @param dataSource
	 * @param rows
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map queryPiece(String sql, String dataSource, String rows,boolean isCached) {
		Map result = new HashMap();
		try{
			sql=charFilter(sql);
			LOG.debug(sql);
			
			int nRows = 0;
			if(rows!=null && rows.matches("[0-9]+")){
				nRows = Integer.parseInt(rows);
			}
			
			DataSource ds = (DataSource)BeanFactory.getBean(dataSource);
			JdbcTemplate jdbcTemplate = new JdbcTemplate(ds,isCached);
			
			SqlPageHelper sqlPageHelper = jdbcTemplate.getSqlPageHelper();
			List data = jdbcTemplate.queryForList(sqlPageHelper.getPieceSQL(sql,nRows) );
			result.put("data", data);
			result.put("total",  data.size()<nRows?data.size():jdbcTemplate.queryForObject(sqlPageHelper.getCountSQL(sql),Integer.class));
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			result.put("message", "SQL语句有错误");
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	Map<String,Map<String,String>> fetchDimMapping(Map colMappingKey,String dataSource){
		Map<String,Map<String,String>> result = new HashMap<String,Map<String,String>>();
		if(colMappingKey!=null && colMappingKey.size()>0){
			for (Iterator iterator = colMappingKey.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				//需要把Key都改成大写
				result.put(entry.getKey().toString().toUpperCase(), fetchOneDimMap((String)entry.getValue(),dataSource));
			}
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private Map<String,String> fetchOneDimMap(String dimKey,String dataSource){
		//维度的数据源指向默认的元数据库
		return (Map<String,String>)new JdbcTemplate("",true).query("select dim_rowid,dim_rowname from md.dimension where DIM_ID=?",new String[]{dimKey}
			, new ResultSetExtractor(){
				@Override
				public Object extractData(ResultSet rs) throws SQLException,DataAccessException {
					Map<String,String> map = new HashMap<String,String>();
					while(rs.next()){
						map.put(rs.getString(1), rs.getString(2));
					}
					return map;
				}
				
		});
		
	}
	
	/**
	 * 去掉sql后面的非法字符
	 * @param sql
	 * @return
	 */
	protected String charFilter(String sql){
		sql = sql.trim();
		if(sql.endsWith(";")){
			sql = sql.substring(0, sql.length()-1);
		}
		return sql;
	}
	
}
