package com.asiainfo.hb.web.controllers;

import java.io.IOException;

import javax.servlet.ServletException;

import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockServletConfig;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.GenericWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
 

public class ProcControllerTest {
//	@Test
	@SuppressWarnings("serial")
	public void test() throws ServletException, IOException{
		DispatcherServlet servlet = new DispatcherServlet() {
			protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
				GenericWebApplicationContext wac = new GenericWebApplicationContext();
				wac.registerBeanDefinition("controller", new RootBeanDefinition(ProcController.class));
				wac.refresh();
				return wac;
			}
		};
		servlet.init(new MockServletConfig());
		{
			MockHttpServletRequest request = new MockHttpServletRequest("POST", "/procexec");
			request.addParameter("procname", "platArrayTest");
			request.addParameter("taskid", "20110102");
			request.addParameter("startstep", "1");
			MockHttpServletResponse response = new MockHttpServletResponse();
			servlet.service(request, response);
		}
	}
	
}
