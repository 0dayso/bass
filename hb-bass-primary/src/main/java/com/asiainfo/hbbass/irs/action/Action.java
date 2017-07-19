package com.asiainfo.hbbass.irs.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Mei Kefu
 * @date 2009-9-15
 */
public abstract class Action {
	
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
