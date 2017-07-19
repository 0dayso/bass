package com.asiainfo.bass.apps.controllers;


//import java.io.IOException;
//import java.io.PrintStream;
//import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ExceptionController  {

	@RequestMapping(value="/404")
	public String _404(HttpServletRequest request,HttpServletResponse response,Model model) {

		String uri = (String)request.getAttribute("javax.servlet.error.request_uri");
		model.addAttribute("uri", uri);
		model.addAttribute("error_code","404");
		return "ftl/exception";
	}
	
	@RequestMapping(value="/500")
	public String _500(HttpServletRequest request,HttpServletResponse response,Model model) {
		//Object code = request.getAttribute("javax.servlet.error.status_code");
//		try {
//			request.setCharacterEncoding("gbk");
//			response.setContentType("text/html;charset=gbk");
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
//		try {
//			Exception e = (Exception)request.getAttribute("javax.servlet.error.exception");
//			e.printStackTrace(new PrintStream(response.getOutputStream()));
//		} catch (IOException e1) {
//			e1.printStackTrace();
//		}
		String uri = (String)request.getAttribute("javax.servlet.error.request_uri");
		model.addAttribute("uri", uri);
		model.addAttribute("error_code","500");
		return "ftl/exception";
	}
}
