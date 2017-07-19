package com.asiainfo.hb.web.controllers;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockServletConfig;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.GenericWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

import com.asiainfo.hb.core.models.JsonHelper;
//import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;

@ContextConfiguration(locations={"/conf/spring/*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class FrameControllerTest{
	
	static Logger LOG = Logger.getLogger(FrameControllerTest.class);
	
	@SuppressWarnings("serial")
	public static void setUp() throws Exception{
		DispatcherServlet servlet = new DispatcherServlet() {
			protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
				GenericWebApplicationContext wac = new GenericWebApplicationContext();
				wac.registerBeanDefinition("controller", new RootBeanDefinition(FrameController.class));
				/*
				//把对象自动映射成json放在response里面
				RootBeanDefinition adapterDef = new RootBeanDefinition(AnnotationMethodHandlerAdapter.class);
				List list = new ArrayList();
				list.add(new MappingJacksonHttpMessageConverter());
				list.add(new StringHttpMessageConverter());
				adapterDef.getPropertyValues().addPropertyValue("messageConverters", list);
				wac.registerBeanDefinition("handlerAdapter", adapterDef);
				
				//映射解析ftl文件到response里面
				RootBeanDefinition freemarker = new RootBeanDefinition(FreeMarkerConfigurer.class);
				freemarker.getPropertyValues().addPropertyValue("templateLoaderPath", "classpath:/resources/views");
				freemarker.getPropertyValues().addPropertyValue("defaultEncoding", "utf-8");
				wac.registerBeanDefinition("freemarkerConfig", freemarker);
				
				RootBeanDefinition vrDef = new RootBeanDefinition(FreeMarkerViewResolver.class);
				vrDef.getPropertyValues().addPropertyValue("suffix", ".ftl");
				vrDef.getPropertyValues().addPropertyValue("prefix", "");
				vrDef.getPropertyValues().addPropertyValue("cache", "true");
				vrDef.getPropertyValues().addPropertyValue("viewClass", "org.springframework.web.servlet.view.freemarker.FreeMarkerView");
				wac.registerBeanDefinition("viewResolver", vrDef);
				*/
				wac.refresh();
				wac.setServletContext(getServletContext());
				return wac;
			}
		};
		servlet.init(new MockServletConfig());
	}
	
	@SuppressWarnings("serial")
	@Test
	public void testLoginPage() throws Exception{
		DispatcherServlet servlet = new DispatcherServlet() {
			protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
				GenericWebApplicationContext wac = new GenericWebApplicationContext();
				wac.registerBeanDefinition("controller", new RootBeanDefinition(FrameController.class));
				wac.refresh();
				return wac;
			}
		};
		servlet.init(new MockServletConfig());
		
		MockHttpServletRequest request = new MockHttpServletRequest("GET", "/login");
		request.getSession().setAttribute("springMvc", "/");
		request.getSession().setAttribute("UA", "网页");
		request.getSession().setAttribute("mvcPath", "");
		MockHttpServletResponse response = new MockHttpServletResponse();
		servlet.service(request, response);
		assertEquals("ftl/frame/login",response.getForwardedUrl());
	}
	
	@SuppressWarnings({ "serial", "rawtypes" })
	@Test
	public void testLogin() throws Exception {
		DispatcherServlet servlet = new DispatcherServlet() {
			@SuppressWarnings({ "unchecked" })
			protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
				GenericWebApplicationContext wac = new GenericWebApplicationContext();
				wac.registerBeanDefinition("controller", new RootBeanDefinition(FrameController.class));
				//把对象自动映射成json放在response里面
				/*RootBeanDefinition adapterDef = new RootBeanDefinition(AnnotationMethodHandlerAdapter.class);*/
				RootBeanDefinition adapterDef = new RootBeanDefinition(RequestMappingHandlerAdapter.class);
				List list = new ArrayList();
				list.add(new MappingJackson2HttpMessageConverter());
				list.add(new StringHttpMessageConverter());
				adapterDef.getPropertyValues().addPropertyValue("messageConverters", list);
				wac.registerBeanDefinition("handlerAdapter", adapterDef);
				
				wac.refresh();
				return wac;
			}
		};
		servlet.init(new MockServletConfig());
		
		MockHttpServletRequest request = new MockHttpServletRequest("POST", "/LoginServlet");
		request.addParameter("name", "meikefu");
		request.addParameter("pws", "Jfqt2010");
		request.addParameter("areacode", "0");
		
		MockHttpServletResponse response = new MockHttpServletResponse();
		servlet.service(request, response);
		String str = response.getContentAsString();
		LOG.info(str);
		Map res = (Map)JsonHelper.getInstance().read(str);
		assertTrue((Boolean)res.get("success"));
		assertEquals("登录成功",(String)res.get("msg"));
		
		
		request = new MockHttpServletRequest("POST", "/LoginServlet");
		request.addParameter("name", "meikefu");
		request.addParameter("pws", "shability");
		request.addParameter("areacode", "0");
		
		response = new MockHttpServletResponse();
		servlet.service(request, response);
		str = response.getContentAsString();
		LOG.info(str);
		res = (Map)JsonHelper.getInstance().read(str);
		assertFalse((Boolean)res.get("success"));
		assertEquals("密码不正确",(String)res.get("msg"));
		
		
		request = new MockHttpServletRequest("POST", "/LoginServlet");
		request.addParameter("name", "meikefu1");
		request.addParameter("pws", "shability");
		request.addParameter("areacode", "0");
		
		response = new MockHttpServletResponse();
		servlet.service(request, response);
		str = response.getContentAsString();
		LOG.info(str);
		res = (Map)JsonHelper.getInstance().read(str);
		assertFalse((Boolean)res.get("success"));
		assertEquals("用户名不正确",(String)res.get("msg"));
	}
}
