package com.asiainfo.hb.web;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import com.asiainfo.hb.core.models.Configuration;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.util.WebUtil;


/**
 * 
 * 判断没有url的权限
 * 
 * 暂时先判断irs的
 * @author Mei Kefu
 * @date 2009-8-7
 * @date 2010-12-10
 * @date 2014-2-20 支持不进行登录判断开关 当EXCEPT_PATH_REGEX变量为all时，不进行登录判断与日志记录等耦合操作，但是还处理字符集、mvcPath等参数的设置
 */
public class DefaultFilter implements Filter {
	
	private static Logger LOG = Logger.getLogger(DefaultFilter.class);
	
	private String EXCEPT_PATH_REGEX=".*/(Login|login|api|ws).*";

	private String encoding = "utf-8";
	
	private String logtype = "on";
	
	@SuppressWarnings("unchecked")
	public void doFilter( ServletRequest request, ServletResponse response, FilterChain chain ) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse)response;
		String uri = req.getRequestURI();

		if(uri.matches(".*\\.(doc|docx|xsl|xslx|ppt|pptx|rar|zip|xml|txt|csv)")){
			req.setCharacterEncoding(encoding);
			res.setContentType("application/octet-stream;charset="+encoding);
		}
		User user = null;
		String ip = null;
		boolean writeLog = false;
		long beginTime=System.currentTimeMillis();
		//非资源文件
		//不是资源文件都记录日志，有部分还需要判断权限
		if(!uri.matches(".*\\.(jpg|jpeg|bmp|gif|png|tng|css|js|swf|eot|ttf|svg|woff|woff2)")){

			//一、字符集
			if(req.getHeader("Request-Type")!=null && "ajax".equalsIgnoreCase(req.getHeader("Request-Type"))){
				req.setCharacterEncoding("utf-8");
				res.setContentType("text/html;charset=utf-8");
			}else{
				req.setCharacterEncoding(encoding);
				res.setContentType("text/html;charset="+encoding);
			}
			
			/** 临时初始化mvcPath*/
			if(req.getSession().getAttribute("mvcPath")==null || req.getSession().getAttribute("springMvc")==null){
				/** 临时初始化mvcPath*/
				String springMvc = Configuration.getInstance().getProperty("com.asiainfo.pst.spring.mvcPath");
				String contextPath=req.getContextPath();
				req.getSession().setAttribute("mvcPath",contextPath+springMvc);
				req.getSession().setAttribute("springMvc",springMvc);
				req.getSession().setAttribute("contextPath",contextPath);
			}
			if(req.getSession().getAttribute("UA")==null||((String)req.getSession().getAttribute("UA")).length()==0){
				String uaStr=req.getHeader("user-agent");
				String ua = userAgent(uaStr);
				req.getSession().setAttribute("UA",ua);
			}
			user = (User)req.getSession().getAttribute(SessionKeyConstants.USER);
			
			ip=WebUtil.getRemoteAddr(req);
			
			//二、是否登录验证
			//判断是否需要登录
			if( !"all".equalsIgnoreCase(EXCEPT_PATH_REGEX)  && user==null && !uri.matches(EXCEPT_PATH_REGEX)){
				if(user==null){//跳转到登录页面
					String loginPage = Configuration.getInstance().getProperty("com.asiainfo.pst.web.loginPage");
					if(loginPage==null || loginPage.length()==0){
						loginPage = "/login";
					}
					String contextPath=req.getContextPath();
					String newUri = uri.replaceAll(contextPath, "");
					String offset="";
					if(newUri.length()>1){
						String paras = "";
						if(req.getParameterMap().entrySet().size()>0){
							Iterator<Entry<String,String[]>> iter = req.getParameterMap().entrySet().iterator();
							while(iter.hasNext()){
								Entry<String,String[]> entry = iter.next();
								String paraKey = entry.getKey();
								String paraVal = entry.getValue()[0];
								paras += paraKey + "=" + paraVal + "$";
							}
							paras = "?" + paras.substring(0, paras.length()-1);
						}
						offset=(loginPage.indexOf("?")>0?"&":"?")+"redirect="+newUri+paras;
					}
					if(loginPage.startsWith("http://")){
						res.sendRedirect(loginPage+offset);
					}else{
						String redirect =req.getSession().getAttribute("mvcPath")+ loginPage;
						res.sendRedirect(redirect+offset);
					}
					
					return;
				}
			}
			if(user!=null){
				writeLog=true;
			}
		}
		
		if(writeLog){
			try{
				chain.doFilter(req, res);
			}finally{
				if (!logtype.equalsIgnoreCase("off")){
					trackLog(user, uri, ip,beginTime, req);//日志记录
				}
			}
		}else{
			chain.doFilter(req, res);
		}
	}
	
	@SuppressWarnings("rawtypes")
	protected void trackLog(User user,String uri,String ip,long beginTime,HttpServletRequest request){
		try{
			if((null != request.getSession().getAttribute("LAST-URL") && uri.equals((String)request.getSession().getAttribute("LAST-URL")))
					|| uri.endsWith("/insertLog") || uri.endsWith("/watermark")){
				return;
			}
				
			StringBuilder menuTrack = new StringBuilder();
			StringBuilder menuIdTrack = new StringBuilder();
			String param = "";
			String opertype="";
			String opername="";
			if("get".equalsIgnoreCase(request.getMethod())){
				param = (request.getQueryString()!=null?request.getQueryString():"");
			}else if("post".equalsIgnoreCase(request.getMethod())){
				Map params = request.getParameterMap();
				StringBuilder sb = new StringBuilder();
				for (Iterator iterator = params.entrySet().iterator(); iterator
						.hasNext();) {
					Map.Entry entry = (Map.Entry) iterator.next();
					sb.append("&").append(entry.getKey()).append("=").append(((String[])entry.getValue())[0]);	
				}
				param = sb.toString();
			}
			
			JdbcTemplate jdbcTemplate = new JdbcTemplate();
			jdbcTemplate.update("insert into FPF_VISITLIST(loginname,area_id,track_mid,track,ipaddr,uri,param,opertype,opername,app_serv,dur_time,ua) values(?,?,?,?,?,?,?,?,?,?,?,?)",
					new Object[]{user.getId(),user.getCityId(),menuIdTrack.toString(),menuTrack.toString(),ip,uri,param.length()>64?param.substring(1,64):param,opertype,opername,request.getLocalAddr()+":"+request.getLocalPort(),System.currentTimeMillis()-beginTime,request.getSession().getAttribute("UA")});
			

		}catch(Exception e){
			e.printStackTrace();
		}
	}

	protected String userAgent(String uaStr){
		Pattern pattern = Pattern.compile(".*(iPhone|Android|iPad|IEMobile|OPhone|Chrome|Firefox|MSIE 9.0|MSIE 8.0|MSIE 7.0|MSIE 6.0|MSIE).*");
		Matcher m = pattern.matcher(uaStr);
		String ua = "未知";
		if(m.matches()){
			ua=m.group(1);
			LOG.info("UA为："+ua);
		}
		return ua;
	}
	
	public void init(FilterConfig config) throws ServletException {
		String encoding1 = config.getInitParameter("encoding");
		if(encoding1!=null && encoding1.length()>0){
			encoding = encoding1;
		}
		
		String except = config.getInitParameter("except_path_regex");
		if(except!=null && except.length()>0){
			EXCEPT_PATH_REGEX = except;
		}
		
		String logtype1 = config.getInitParameter("logtype");
		if (logtype1 != null && logtype1.length()>0 && logtype1.toLowerCase().equalsIgnoreCase("off")){
			logtype = logtype1;
		}
	}

	public void destroy() {}
}
