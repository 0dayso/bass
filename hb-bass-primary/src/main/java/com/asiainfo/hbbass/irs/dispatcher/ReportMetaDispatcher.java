package com.asiainfo.hbbass.irs.dispatcher;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.irs.report.core.Report;
import com.asiainfo.hbbass.irs.report.core.ReportContext;
/**
 *
 * @author Mei Kefu
 * @date 2009-9-15
 */
public class ReportMetaDispatcher implements Dispatcher {

	private static Logger LOG = Logger.getLogger(ReportMetaDispatcher.class);
	
	public void doDelete(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
	}

	@SuppressWarnings("unused")
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getPathInfo();
		response.setCharacterEncoding("UTF-8");
		Report report = (Report)ReportContext.getInstance().getContainer().get(path.split("/")[1]);
		
		//response.getWriter().print(new RenderHTML().render(report));
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getPathInfo();
		path = path.replaceAll("/reportmeta", "");
		Report report = (Report)ReportContext.getInstance().getContainer().get(path.split("/")[1]);
		
		SQLQuery query = SQLQueryContext.getInstance().getSQLQuery("json");
		//String sql = request.getParameter("sql");
		parse(report,request);
		String sql = "";//report.parse();
		LOG.debug(sql);
		String result = (String)query.query(sql);
		LOG.debug(result);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(result);
	}
	
	protected void parse(Report report,HttpServletRequest request){
		
		/*Report.Dimension[] dimensions = report.getDimensions();
		
		for (int i = 0; i < dimensions.length; i++) {
			
			String value = request.getParameter(dimensions[i].dbName);
			
			if(value!=null && value.length()>0){
				dimensions[i].value=value;
			}
		}*/
		
	}

	public void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
	}

}
