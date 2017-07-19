package com.asiainfo.bass.components.web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.bass.components.models.DES;
import com.asiainfo.hb.core.cache.CacheServer;
import com.asiainfo.hb.core.cache.CacheServerFactory;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.models.UserDao;

/**
 * 
 * �ж�û��url��Ȩ��
 * 
 * ��ʱ���ж�irs��
 * 
 * @author Mei Kefu
 * @date 2009-8-7
 * @date 2010-12-10
 */
public class DefaultFilter implements Filter {

	// private static final String LOG_ERR_PAGE =
	// "/hbbass/error/loginerror.jsp";这些乱码可以使用
	private static Logger LOG = Logger.getLogger(DefaultFilter.class);

	//private static final String EXCEPT_PATH_REGEX = ".*/frame/login.*";
	private static final String EXCEPT_PATH_REGEX = ".*/frame/login.*";

	private static final String EXCEPT_PATH_REGEX1 = ".*/financeReport.*|.*/mstr.*|.*/MMSReport.*|.*/sendmms.*|.*/sendsms.*";
	//private static final String EXCEPT_PATH_REGEX1 = ".*/hbirs/service.*|.*/financeReport.*";

	private static String encoding = "UTF-8";
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		String uri = req.getRequestURI();
		// ����Դ�ļ�
		// ������Դ�ļ�����¼��־���в��ֻ���Ҫ�ж�Ȩ��
		if (!uri.matches(".*\\.(jpg|jpeg|bmp|gif|png|tng|doc|docx|xsl|xslx|ppt|pptx|rar|zip|xml|txt|csv|css|js|swf)")) {
			// һ���ַ�
			if (req.getHeader("Request-Type") != null && "ajax".equalsIgnoreCase(req.getHeader("Request-Type"))) {
				req.setCharacterEncoding("utf-8");
				res.setContentType("text/html;charset=utf-8");
			} else if (req.getHeader("X-Requested-With") != null && "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))) {
				req.setCharacterEncoding("utf-8");
				res.setContentType("text/html;charset=utf-8");
			} else {
				req.setCharacterEncoding(encoding);
				// response.setCharacterEncoding("UTF-8");
				res.setContentType("text/html;charset=" + encoding);
			}
			
			LOG.info("mvcPath��ʼ��ǰ:" + req.getSession().getAttribute("mvcPath"));
			/** ��ʱ��ʼ��mvcPath */
			if (req.getSession().getAttribute("mvcPath") == null) {
				req.getSession().setAttribute("mvcPath", req.getContextPath() + "/mvc");
				req.getSession().setAttribute("contextPath", req.getContextPath());
			}

			LOG.info("mvcPath��ʼ����:" + req.getSession().getAttribute("mvcPath"));
			
			User user = (User) req.getSession().getAttribute("user");

			LOG.info("user:" + user);
			// �����Ƿ��¼��֤
			// �ж��Ƿ���Ҫ��¼
			if (uri.matches(EXCEPT_PATH_REGEX)) {

			} else if (user == null) {
				if (uri.matches(EXCEPT_PATH_REGEX1)) {// ������Աֱ�ӽ�����ù���
					LOG.info("������Աֱ�ӽ�����ù��ߡ���");
					user = new User("","");
					user.setCityId("0");
					req.getSession().setAttribute("user", user);
				} else {
					// �ȴ�cookie�ж��û�
					Cookie[] cookies = req.getCookies();
					String userId = "";
					if (cookies != null) {
						for (Cookie cookie : cookies) {
							if (cookie != null && "cookieUser".equalsIgnoreCase(cookie.getName())) {
								userId = cookie.getValue();
							}
						}
					}
					LOG.info("cookies,userId:" + userId);
					// ���Ӵӻ�����ȡ
					CacheServer cache = CacheServerFactory.getInstance().getCache("SSO");
					Object obj = null;
					if (cache != null) {
						String ip = req.getHeader("X-Forwarded-For");
						if (ip == null) {
							ip = request.getRemoteAddr();
						}
						obj = cache.get(ip);
						// if(obj!=null && obj instanceof User){
						// user=(User)obj;
						// req.getSession().setAttribute("user",user);
						// }
						if (obj != null && obj instanceof String) {
							userId = (String) obj;
						}
					}

					LOG.info("cache,userId:" + userId);
					if (userId != null && userId.length() > 0) {
						LOG.info("��������userid������-------------------------");
						UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
						user = userDao.getUserById(userId);
						LOG.info("user�ǲ��ǿ�:"+user==null);
						LOG.info("user������:"+(user!=null?user.getName():"��"));
						if(user != null){
							req.getSession().setAttribute("user", user);
							req.getSession().setAttribute("loginname", user.getId());
							req.getSession().setAttribute("area_id", user.getCityId());
						}
					}

					if (user == null) {
						LOG.info("user == null");
						//��������а�access_user_id��Ϊ���¼
						String accessId = req.getParameter("access_user_id");
						LOG.info(accessId);
						if(StringUtils.isNotBlank(accessId)){
							userId = DES.decode(accessId);
							LOG.info("���¼��ȡuserid=" + userId);
							UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
							user = userDao.getUserById(userId);
							if(user != null){
								req.getSession().setAttribute("user", user);
								req.getSession().setAttribute("loginname", user.getId());
								req.getSession().setAttribute("area_id", user.getCityId());
							}else{
								LOG.warn("���¼ʱ��ͨ��userid��ѯ�û���ϢΪ��");
								res.sendRedirect(req.getContextPath() + "/mvc" + "/frame/login");
								return;
							}
							
						}else{
							LOG.info("accessId == null");
							res.sendRedirect(req.getContextPath() + "/mvc" + "/frame/login");
							return;
						}
					}
				}
			}
		}
		chain.doFilter(req, res);
	}

	public void destroy() {

	}

	public static void main(String[] args) {
		System.out.println("/report/conf".matches(EXCEPT_PATH_REGEX1));
	}

	public void init(FilterConfig config) throws ServletException {
		String encoding1 = config.getInitParameter("encoding");
		if (encoding1 != null && encoding1.length() > 0) {
			encoding = encoding1;
		}
	}
}
