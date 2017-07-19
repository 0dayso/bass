package com.asiainfo.hbbass.irs.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Mei Kefu
 * @date 2009-9-15
 */
public abstract class Service {
	
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
