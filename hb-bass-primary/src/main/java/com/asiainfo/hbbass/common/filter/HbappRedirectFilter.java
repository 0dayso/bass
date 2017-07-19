package com.asiainfo.hbbass.common.filter;

import java.io.IOException;
import java.io.PrintWriter;
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

import com.asiainfo.hb.web.models.User;

/**
 * 
 * 让112上面访问遗留应用是跳到114主机
 * 
 * @author Mei Kefu
 * @date 2010-10-28
 */
public class HbappRedirectFilter implements Filter {

	private static Logger LOG = Logger.getLogger(HbappRedirectFilter.class);

	private static String LOG_ERR_PAGE = "/mvc/frame/login";

	private static String EXCEPT = ".*/(mvc|detect|hbapp|hbirs|services|" + LOG_ERR_PAGE + ").*";

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		
		String uri = req.getRequestURI() + (req.getQueryString() != null ? "?" + req.getQueryString() : "");
		// uri = req.getRequestURI();
		if (uri.indexOf("/mvc/hbapp/kpiportal/") > -1) {
			uri = uri.replaceAll("/mvc/hbapp/kpiportal/", "/hbapp/kpiportal/");
			((HttpServletResponse) response).sendRedirect(uri);
			return;
		}

		if (uri.startsWith("/dispatch.jsp") || uri.equalsIgnoreCase("/") || uri.equalsIgnoreCase("/login.jsp") || uri.equalsIgnoreCase("/direct.jsp") || uri.equalsIgnoreCase("/index.jsp") || uri.matches(EXCEPT)
				|| uri.matches(".*\\.(jpg|jpeg|bmp|gif|png|tng|doc|docx|xsl|xslx|ppt|pptx|rar|zip|xml|txt|csv|css|js|swf|ico)")) {// 都是遗留应用

			if (uri.equalsIgnoreCase("/") || uri.equalsIgnoreCase("/login.jsp") || uri.equalsIgnoreCase("/index.jsp")) {
				String uaStr = ((HttpServletRequest) request).getHeader("user-agent");
				Pattern pattern = Pattern.compile(".*(iPhone|Android|iPad|IEMobile|OPhone).*");
				Matcher m = pattern.matcher(uaStr);
				if (m.matches()) {
					LOG.info("使用移动终端登录");
					String aaa = "http://10.25.124.110:8080";
					PrintWriter out = response.getWriter();
					out.print("<script>location.href='" + aaa + "'</script>");
					return;
					// ((HttpServletResponse)
					// response).sendRedirect("http://10.25.124.109:8080");
				}
			}
			chain.doFilter(request, response);

		} else if (uri.startsWith("/hb-bass-navigation/ws")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/channel/caiwu")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/groupcust/20/gcdown.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/ngbass/credit/main.htm")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbapp/app/import")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/groupcust/20/gcdownAction.jsp")) {
			chain.doFilter(request, response);
		}  else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/bureau_change.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/bureau_tree_newdel.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/bureau_tree_change.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/cell_tree.htm")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/cell_tree_detail.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/zone_aduit_jump.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/zone_aduit.html")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/audit_bureau_cfg.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/fee/fee_info_manage.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/menudown")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit/bureau_tree_change.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/feedback/navi_content.htm")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/baseSet/base_set_edit.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/baseSet/base_set_log_list.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/groupcust/groupImport1.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/groupcust/groupImport2.jsp")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/salesmanager/areasale/bureauAudit")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/town")) {
			chain.doFilter(request, response);
		} else if (uri.startsWith("/hb-bass-navigation/hbbass/common2/")) {
			chain.doFilter(request, response);
		}
		else if (uri.startsWith("/hb-bass-navigation/hbbass/debt")) {//收入保障与分析--欠费专题分析
			chain.doFilter(request, response);
		}else if(uri.startsWith("/hb-bass-navigation/download/")){//工号管理下载
			chain.doFilter(request, response);
		}else if(uri.startsWith("/hbbass/college")){//市场营销-高校市场监控
            chain.doFilter(request, response);
		}else if (uri.startsWith("/hb-bass-navigation/javamelody") || uri.indexOf("/monitoring") >= 0){
			chain.doFilter(request, response);
		}else {
			User user = (User) req.getSession().getAttribute("user");
			uri=uri.replace("/hb-bass-navigation", "");
			String remoteAdd = "http://10.25.124.115/redirect.jsp?loginname=" + user.getId() + "&url=";
			if (uri.indexOf("?") <= 0) {
				uri += "?";
			} else {
				uri += "&";
			}
			String rew_url = remoteAdd + uri.replaceAll("\\?", "|").replaceAll("&", "@");
			LOG.info("redirect to 115:" + rew_url);
			// ((HttpServletResponse)response).sendRedirect(rew_url);
			PrintWriter out = response.getWriter();
			out.print("<script>window.open('" + rew_url + "')</script>");
		}
	}

	public void init(FilterConfig config) throws ServletException {

	}

	public void destroy() {

	}

	public static void main(String[] args) {

	}
}
