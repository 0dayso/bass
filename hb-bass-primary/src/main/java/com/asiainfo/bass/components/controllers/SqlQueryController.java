package com.asiainfo.bass.components.controllers;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.bass.components.models.FileManage;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.PageSqlGen;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.util.Encrypt;
import com.asiainfo.util.EncryptUtil;

/**
 * 
 * @author Mei Kefu
 * @date 2011-3-8
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping(value = "/sqlQuery")
public class SqlQueryController {
	private static Logger LOG = Logger.getLogger(SqlQueryController.class);

	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;

	@RequestMapping(method = RequestMethod.GET)
	public String confMain1() {
		return "html/conf/navi";
	}

	@Autowired
	private PageSqlGen pageSqlGen;

	@Autowired
	private FileManage fileManage;

	/**
	 * 支持csv和xls下载使用参数fileKind=excel来判断 下载没用使用缓存，是否需要缓存，如果下载几百M的数据缓存也要挂掉
	 * 下载是先生成临时文件，然后下载文件，最后删除文件 支持复合表头的判断，但是在excel下载中没有合并，下次重构excel的复合表头合并问题
	 * 
	 * @param request参数
	 *            ：sql header fileName ds(可选) fileKind(可选)
	 * 
	 * @throws ServletException
	 * @throws IOException
	 */
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "down", method = RequestMethod.POST)
	public void down(WebRequest request, HttpServletResponse response) {
		String sql = request.getParameter("sql");
		if(!sql.trim().toLowerCase().startsWith("select")){
			sql =  DesUtil.defaultStrDec(sql);
		}
		String headerStr = request.getParameter("header");
		sql = charFilter(sql);
		LOG.debug(sql);

		String fileName = request.getParameter("fileName");

		JsonHelper jsonHelper = JsonHelper.getInstance();
		/**
		 * key:dataIndex,value:name {dataIndex:name, }
		 * 
		 * 先把header 转成全大写
		 */
		Map header = (Map) jsonHelper.read(headerStr.toUpperCase());
		String ds = request.getParameter("ds");
		String fileKind = request.getParameter("fileKind");

		FileManage.FilePorcess process = new FileManage.FilePorcess() {

			HttpServletResponse response;

			public void setObject(Object object) {
				this.response = (HttpServletResponse) object;
			}

			public void process(File file) {
				try {
					fileManage.outFile(response, file);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		};
		process.setObject(response);

		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}

		fileManage.execute(jdbcTemplate, sql, fileName, header, fileKind, process);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(method = RequestMethod.POST)
	public @ResponseBody
	Object query(WebRequest request) {
		try {
			String sql = request.getParameter("sql");
			sql=EncryptUtil.aesDecrypt(sql,"o7H8uIM2O5qv65l2");
			sql=java.net.URLDecoder.decode(sql ,"utf-8");
			sql=DesUtil.defaultStrDec(sql);
			if(!sql.trim().toLowerCase().startsWith("select")){
				sql =  DesUtil.defaultStrDec(sql);
			}
			sql = charFilter(sql);
			LOG.debug(sql);

			Object result = null;

			if (sql == null || sql.length() == 0) {
				result = new ArrayList<Object>();
			} else {
				String queryType = request.getParameter("qType");// 确定是否分页查询，放在一个方法是为了记录日志

				String ds = request.getParameter("ds");

				boolean isCached = !"false".equalsIgnoreCase(request.getParameter("isCached"));// 是否缓存，除非制定不缓存，其他的都默认缓存

				JdbcTemplate jdbcTemplate = null;
				if ("web".equalsIgnoreCase(ds))
					jdbcTemplate = new JdbcTemplate(dataSource, isCached);
				else if ("nl".equalsIgnoreCase(ds)) {
					jdbcTemplate = new JdbcTemplate(dataSourceNl, isCached);
				} else {
					jdbcTemplate = new JdbcTemplate(dataSourceDw, isCached);
				}

				if ("limit".equalsIgnoreCase(queryType)) {
					int limit = 0;
					int start = 1;
					String limitStr = request.getParameter("limit");
					if (limitStr != null && limitStr.matches("[0-9]+")) {
						limit = Integer.parseInt(limitStr);
					}
					String startStr = request.getParameter("start");
					if (startStr != null && startStr.matches("[0-9]+")) {
						start = Integer.parseInt(startStr);
					}

					// sqlQuery =
					// SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_LIMIT,ds,isCached);
					// result = (String)sqlQuery.query(sql,limit,start);
					result = new HashMap();
					List data = jdbcTemplate.queryForList(pageSqlGen.getLimitSQL(sql, limit, start));

					int count = data.size();// 计数器
					// 2.超过极限说明数据没有查询完整，需要countSQL一下
					int total = 0;// .返回值，总的元素数量
					if (limit == count) {
						total = jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql),Integer.class);
					}

					((Map) result).put("data", data);
					((Map) result).put("total", count > total ? count + start - 1 : total);
					((Map) result).put("start", start);

				} else if ("piece".equalsIgnoreCase(queryType)) {
					int rows = 0;
					String rowsStr = request.getParameter("rows");
					if (rowsStr != null && rowsStr.matches("[0-9]+")) {
						rows = Integer.parseInt(rowsStr);
					}
					// sqlQuery =
					// SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_PIECE,ds,isCached);
					// result = (String)sqlQuery.query(sql,rows);
					result = new HashMap();
					List data = jdbcTemplate.queryForList(pageSqlGen.getPieceSQL(sql, rows));
					((Map) result).put("data", data);
					((Map) result).put("total", data.size() < rows ? data.size() : jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql),Integer.class));

				} else {
					if (sql.trim().length() > 7 && (sql.trim().substring(0, 7).equalsIgnoreCase("select ") || sql.trim().substring(0, 4).equalsIgnoreCase("with"))) {

						// sqlQuery =
						// SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON,ds,isCached);
						// result = (String)sqlQuery.query(sql);
						result = jdbcTemplate.queryForList(sql);
					} else {
						LOG.error("这个方法没有定义");
						// result = BassDimCache.getInstance().getArray(sql);
					}
				}
			}

			return result;
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			throw new RuntimeException(e.getMessage());
		}
	}

	/*
	 * protected String getPieceSQL(String sql,int rows){ if(rows<500){
	 * rows=500; } StringBuffer pieceSQL = new StringBuffer(sql.trim());
	 * 
	 * if(pieceSQL.indexOf(" fetch first")>0){
	 * pieceSQL.delete(pieceSQL.indexOf("fetch first"),pieceSQL.length()); }
	 * 
	 * if(pieceSQL.indexOf(" with ur")>0){
	 * pieceSQL.delete(pieceSQL.indexOf("with ur"),pieceSQL.length()); }
	 * 
	 * pieceSQL.append(" fetch first "+rows+" rows only ").append(" with ur");
	 * //LOG.debug("SQL:"+pieceSQL); return pieceSQL.toString(); }
	 * 
	 * 
	 * protected String getLimitSQL(String sql,int limit,int start){
	 * StringBuffer limitSQL = new StringBuffer(
	 * "select * from (select t.*,rownumber() over(order by 1) as row_num from ("
	 * ); limitSQL.append(sql.trim());
	 * 
	 * if(limitSQL.indexOf(" with ur")>0){
	 * limitSQL.delete(limitSQL.indexOf("with ur"),limitSQL.length()); }
	 * 
	 * limitSQL.append(") t) t2 where row_num between ").append(start).append(
	 * " and ").append((start+limit)-1).append(" with ur");
	 * //LOG.debug("SQL:"+pieceSQL); return limitSQL.toString(); }
	 */
	/**
	 * 得到sql的统计行数的sql
	 * 
	 * @param sql
	 * @return
	 */
	/*
	 * protected String getCountSQL(String sql){ StringBuffer countSQL = new
	 * StringBuffer("select count(*) cnt from ("); countSQL.append(sql.trim());
	 * 
	 * if(countSQL.indexOf(" with ur")>0){
	 * countSQL.delete(countSQL.indexOf("with ur"),countSQL.length()); }
	 * 
	 * countSQL.append(") t").append(" with ur");
	 * 
	 * //LOG.debug("SQL:"+countSQL); return countSQL.toString(); }
	 */
	/**
	 * 去掉sql后面的非法字符
	 * 
	 * @param sql
	 * @return
	 */
	protected String charFilter(String sql) {
		sql = sql.trim();
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}
		return sql;
	}

	public static void main(String[] args) {
		String sql = "select * from dual;\r\n ";

		System.out.println(sql);

		System.out.println(sql.trim());
		sql = sql.trim();
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}

		System.out.println(sql);
	}
}
