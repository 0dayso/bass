package com.asiainfo.bass.components.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;

/**
 * 
 * @author helei
 * @date 2011-11-21
 */
@Controller
@RequestMapping(value = "/sqlExec")
public class SqlExecController {
	private static Logger LOG = Logger.getLogger(SqlExecController.class);

	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(method = RequestMethod.POST)
	public void exec(WebRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map result = new HashMap();
		JdbcTemplate jdbcTemplate = null;
		try {
			String ds = request.getParameter("ds");
			String[] sqls = request.getParameterValues("sqls");
			if ("web".equalsIgnoreCase(ds))
				jdbcTemplate = new JdbcTemplate(dataSource, false);
			else if ("nl".equalsIgnoreCase(ds)) {
				jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
			} else {
				jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			}
			int[] num = jdbcTemplate.batchUpdate(sqls);
			LOG.debug(sqls[0]);
			LOG.debug(num[0]);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("message", "执行失败");
		}
		result.put("message", "执行成功");
		response.getWriter().print(JsonHelper.getInstance().write(result));
	}
}
