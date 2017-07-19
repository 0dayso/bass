package com.asiainfo.hbbass.frame;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.dimension.BassDimCache;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

public class PortalMainAction extends Action {
	private final static Logger m_log = Logger.getLogger(PortalMainAction.class);

	@RequestMapping(value = "queryNews", method = RequestMethod.POST)
	public void queryNews(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String sql="select newsid id,char(date(newsdate)) date,to_char(newsdate,'yyyy-mm-dd hh24:mi:ss') newsdate,newstitle title,newsmsg content from FPF_USER_NEWS order by newsdate desc fetch first 10 rows only with ur";
		m_log.info("查询sql=" + sql);
		String result = this.query(sql, request);
		m_log.debug("查询结果：" + result);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "quertNewLine", method = RequestMethod.POST)
	public void quertNewLine(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String sql="select id,char(date(lastupd)) date,name,kind from FPF_IRS_SUBJECT where status='在用' order by lastupd desc fetch first 12 rows only with ur";
		m_log.info("查询sql=" + sql);
		String result = this.query(sql, request);
		m_log.debug("查询结果：" + result);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(result);
	}
	
	@ActionMethod(isLog = false)
	@RequestMapping(value = "querypv", method = RequestMethod.POST)
	public void querypv(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String _col = "substr(track,1,posstr(track,'-')-1)";
		m_log.info("_col=" + _col);
		String _condi = "and posstr(track,'-')>0";
		m_log.info("_condi=" + _condi);
		String sql = "select name,cnt from ("
			+" select "+_col+" name,count(*) cnt"
			+" from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid where substr(char(date(create_dt)),1,7) = substr(char(current date),1,7) and substr(track,1,posstr(track,'-')-1) <>'运营管理监控' and substr(track,1,posstr(track,'-')-1) <>'报表展示' "
			+" and group_id<>'26020' and (track !='' or opername!='' or OPERTYPE!='')"
			+ _condi
			+" and area_id is not null group by "+_col
			+" union all"
			+" select '地市集市' name,count(*) cnt FROM MD.LOG_INFO where usename not in ('sys','admin') and substr(char(DATE(LOG_DATE)),1,7) = substr(char(current date),1,7)"
			+" ) t order by 2 desc fetch first 10 rows only with ur";
		m_log.info("查询sql=" + sql);
		String result = this.query(sql, request);
		m_log.debug("查询结果：" + result);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(result);
	}
	
	private String query(String sql,HttpServletRequest request){
		String result = "";
		
		SQLQuery sqlQuery = SQLQuery.NULL;
		String queryType = request.getParameter("qType");

		String ds = request.getParameter("ds");

		boolean isCached = !"false".equalsIgnoreCase(request.getParameter("isCached"));
		if (!isCached)
			m_log.info("没有使用缓存");
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

			sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_LIMIT, ds, isCached);
			result = (String) sqlQuery.query(sql, limit, start);

		} else if ("piece".equalsIgnoreCase(queryType)) {
			int rows = 0;
			String rowsStr = request.getParameter("rows");
			if (rowsStr != null && rowsStr.matches("[0-9]+")) {
				rows = Integer.parseInt(rowsStr);
			}
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_PIECE, ds, isCached);
			result = (String) sqlQuery.query(sql, rows);
		} else {

			if (sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("select ")) {
				sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON, ds, isCached);
				result = (String) sqlQuery.query(sql);
			} else {
				result = BassDimCache.getInstance().getArray(sql);
			}
		}
		
		return result;
	}
}
