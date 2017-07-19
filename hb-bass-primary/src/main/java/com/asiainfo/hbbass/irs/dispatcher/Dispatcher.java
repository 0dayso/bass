package com.asiainfo.hbbass.irs.dispatcher;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface Dispatcher {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
	
	public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
	
	public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
	
	public static Dispatcher NULL = new Dispatcher(){

		public void doDelete(HttpServletRequest request,
				HttpServletResponse response) throws ServletException,
				IOException {
			
			
		}

		public void doGet(HttpServletRequest request,
				HttpServletResponse response) throws ServletException,
				IOException {
			
			
		}

		public void doPost(HttpServletRequest request,
				HttpServletResponse response) throws ServletException,
				IOException {
			
			
		}

		public void doPut(HttpServletRequest request,
				HttpServletResponse response) throws ServletException,
				IOException {
			
			
		}
		
	};
}
