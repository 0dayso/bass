package com.asiainfo.hbbass.irs;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.irs.dispatcher.Dispatcher;

/**
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public class HbIrsDispatcherServlet extends HttpServlet {

	private static Logger LOG = Logger.getLogger(HbIrsDispatcherServlet.class);
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String path = request.getPathInfo();
		LOG.debug(path);
		Dispatcher dispatcher = getDispatcher(path);
		dispatcher.doGet(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo();
		LOG.debug(path);
		Dispatcher dispatcher = getDispatcher(path);
		dispatcher.doPost(request, response);
	}

	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo();
		LOG.debug(path);
		Dispatcher dispatcher = getDispatcher(path);
		dispatcher.doPut(request, response);
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo();
		LOG.debug(path);
		Dispatcher dispatcher = getDispatcher(path);
		dispatcher.doDelete(request, response);
	}

	protected Dispatcher getDispatcher(String path) {

		String[] arr = path.split("/");

		Dispatcher dispatcher = HbIrsContext.getDispatcher(arr[1]);

		return dispatcher;
	}

}
