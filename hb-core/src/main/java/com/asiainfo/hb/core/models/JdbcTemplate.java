package com.asiainfo.hb.core.models;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.ParameterDisposer;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;
import org.springframework.jdbc.core.SqlTypeValue;
import org.springframework.jdbc.core.StatementCreatorUtils;
import org.springframework.jdbc.datasource.DataSourceUtils;

import com.asiainfo.hb.core.cache.CacheServer;
import com.asiainfo.hb.core.cache.CacheServerFactory;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.util.Encryption;

/**
 *
 * @author Mei Kefu
 * @date 2011-3-13
 */
//由于dataSource不同所以这里不能用@Compnonet
public class JdbcTemplate extends org.springframework.jdbc.core.JdbcTemplate {
	
	public static String defaultDatasourceName = "dataSource";
	public static boolean DEFAULT_USE_CACHE=false;
	
	private static Logger LOG = Logger.getLogger(JdbcTemplate.class);
	
	protected CacheServer cache = null;
	
	protected void putObjectToCache(String sql,Object obj){
		if(cache!=null){
			LOG.debug("cache SQL query:"+sql);
			cache.put(Encryption.md5Encode(sql), obj);
		}
	}

	/**
	 * 通过dataSourceName得到java.sql.DataSource的实例
	 * @param dataSource
	 * @return
	 */
	public static DataSource getDataSource(String dataSource){
		if(dataSource==null|| dataSource.length()==0 || "undefined".equalsIgnoreCase(dataSource)){
			dataSource=defaultDatasourceName;
		}
		DataSource ds = null;
		try{
			ds = (DataSource)BeanFactory.getBean(dataSource);
		}catch(Exception e){
			e.printStackTrace();
			LOG.error(e.getMessage(),e);
		}
		if(ds==null){
			return (DataSource)BeanFactory.getBean(defaultDatasourceName);
		}
		return ds;
	}
	/**
	 * 得到数据库的类型 全部小写的 db2 oracle mysql
	 * @return
	 */
	public String getDatabaseType(){
		String driverName = "";
		Connection con = DataSourceUtils.getConnection(getDataSource());
		try {
			DatabaseMetaData dbmd = con.getMetaData();
			driverName = dbmd.getDriverName();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DataSourceUtils.releaseConnection(con, getDataSource());
		}
		String result="";
		Pattern pattern = Pattern.compile(".*(db2|oracle|mysql|sql server).*");
		Matcher m = pattern.matcher(driverName.toLowerCase());
		if(m.matches()){
			result = m.group(1);
		}
		return result.replace(" ", "");
	}
	
	public SqlPageHelper getSqlPageHelper(){
		return SqlPageHelper.getSqlPageHelper(this);
	}
	
	@SuppressWarnings("unchecked")
	protected <T> T getObjectFromCache(String sql){
		T obj=null;
		if(cache!=null){
			obj=(T)cache.get(Encryption.md5Encode(sql));
			if(obj!=null)
				LOG.info("hit by cache SQL="+sql);
		}
		return obj;
	}
	
	public JdbcTemplate(){
		this(defaultDatasourceName,DEFAULT_USE_CACHE);
	}
	
	public JdbcTemplate(String dataSource){
		this(dataSource,DEFAULT_USE_CACHE);
	}
	
	public JdbcTemplate(boolean isCached){
		this(defaultDatasourceName,isCached);
	}
	
	public JdbcTemplate(String dataSource,boolean isCached){
		this(getDataSource(dataSource),isCached);
	}
	
	public JdbcTemplate(DataSource dataSource){
		this(dataSource,DEFAULT_USE_CACHE);
	}
	
	public JdbcTemplate(DataSource dataSource,boolean isCached){
		super(dataSource);
		if(isCached)
			cache=CacheServerFactory.getInstance().getCache("SQL");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	 public <T> T query(String sql, ResultSetExtractor<T> rse) throws DataAccessException{
		T obj = (T)getObjectFromCache(sql);
		
		if( obj == null ){
			obj = super.query(sql,rse);
			putObjectToCache(sql, obj);
		}
		
		return obj;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <T> T query(String sql, PreparedStatementSetter pss, ResultSetExtractor<T> rse) throws DataAccessException {
		if(cache!=null && pss instanceof ArgPreparedStatementSetter){
			//这里需要把参数都取出来，然后加入到sqlKey中去
			ArgPreparedStatementSetter apss = (ArgPreparedStatementSetter)pss;
			String key = sql+apss.getArgsString();
			T obj = (T)getObjectFromCache(key);
			if( obj == null ){
				obj = super.query(sql,pss,rse);
				putObjectToCache(key, obj);
			}
			return obj;
		}else{
			return super.query(sql,pss,rse);
		}
	}
	
	@Override
	protected PreparedStatementSetter newArgPreparedStatementSetter(
			Object[] args) {
		return new ArgPreparedStatementSetter(args);
	}
	/*
	 * 暂时先不缓存这个类型
	@Override
	protected PreparedStatementSetter newArgTypePreparedStatementSetter(
			Object[] args, int[] argTypes) {
		return new ArgTypePreparedStatementSetter(args, argTypes);
	}*/
	/**
	 * 把映射出来的Map.Key都转换成小写
	 */
	@Override
	protected RowMapper<Map<String, Object>> getColumnMapRowMapper(){
		return new ColumnMapRowMapper(){
			@Override
			protected String getColumnKey(String columnName){
				return columnName.toLowerCase();
			}
		};
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println(Calendar.getInstance().getTime());
	}
}
/**
 * 缓存使用时必须把参数也代入缓存的Key中
 * 本来应该继承原有类，但是由于Spring写成本包才能访问
 * @author Mei Kefu
 *
 */
class ArgPreparedStatementSetter implements PreparedStatementSetter, ParameterDisposer {

	private final Object[] args;

	/**
	 * 把参数拼接成一个字符串
	 * @return
	 */
	public String getArgsString(){
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < args.length; i++) {
			sb.append(",").append(args[i]);
		}
		return sb.toString();
	}
	
	public ArgPreparedStatementSetter(Object[] args) {
		this.args = args;
	}

	public void setValues(PreparedStatement ps) throws SQLException {
		if (this.args != null) {
			for (int i = 0; i < this.args.length; i++) {
				Object arg = this.args[i];
				doSetValue(ps, i + 1, arg);
			}
		}
	}
	protected void doSetValue(PreparedStatement ps, int parameterPosition, Object argValue) throws SQLException {
		if (argValue instanceof SqlParameterValue) {
			SqlParameterValue paramValue = (SqlParameterValue) argValue;
			StatementCreatorUtils.setParameterValue(ps, parameterPosition, paramValue, paramValue.getValue());
		}
		else {
			StatementCreatorUtils.setParameterValue(ps, parameterPosition, SqlTypeValue.TYPE_UNKNOWN, argValue);
		}
	}
	public void cleanupParameters() {
		StatementCreatorUtils.cleanupParameters(this.args);
	}
}
