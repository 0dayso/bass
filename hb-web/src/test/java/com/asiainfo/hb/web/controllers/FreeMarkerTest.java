package com.asiainfo.hb.web.controllers;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockServletConfig;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.GenericWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;
//import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;

public class FreeMarkerTest {
	@SuppressWarnings("serial")
	@Test
	public void testFtlMapping() throws Exception {
		DispatcherServlet servlet = new DispatcherServlet() {
			@SuppressWarnings({ "rawtypes", "unchecked" })
			protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
				GenericWebApplicationContext wac = new GenericWebApplicationContext();
				wac.registerBeanDefinition("controller", new RootBeanDefinition(TestController.class));
				//把对象自动映射成json放在response里面
				/*RootBeanDefinition adapterDef = new RootBeanDefinition(AnnotationMethodHandlerAdapter.class);*/
				RootBeanDefinition adapterDef = new RootBeanDefinition(RequestMappingHandlerAdapter.class);
				List list = new ArrayList();
				list.add(new MappingJackson2HttpMessageConverter());
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
				
				wac.refresh();
				wac.setServletContext(getServletContext());
				return wac;
			}
		};
		servlet.init(new MockServletConfig());
		
		
		MockHttpServletRequest request = new MockHttpServletRequest("GET", "/test");
		MockHttpServletResponse response = new MockHttpServletResponse();
		response.setContentType("text/html;charset=utf-8");
		
		servlet.service(request, response);
		assertEquals("这是一个测试页面输出为:当然是测试",response.getContentAsString());
	}
}
@Controller
class TestController{
	
	@RequestMapping(value="/test",method=RequestMethod.GET)
	public String ftl(Model model){
		model.addAttribute("message", "当然是测试");
		return "ftl/test";
	}
}
