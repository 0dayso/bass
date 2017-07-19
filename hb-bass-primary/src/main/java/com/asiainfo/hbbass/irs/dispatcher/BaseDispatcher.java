package com.asiainfo.hbbass.irs.dispatcher;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Mei Kefu
 * @date 2009-10-19
 */
public abstract class BaseDispatcher implements Dispatcher {

	public abstract void dispatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
	
	public void doDelete(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		dispatch(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		dispatch(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		dispatch(request, response);
	}

	public void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		dispatch(request, response);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {


	}

}
