package com.asiainfo.hb.web.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ClassUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.multiaction.NoSuchRequestHandlingMethodException;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import com.asiainfo.hb.core.cache.CacheServer;
import com.asiainfo.hb.core.cache.CacheServerFactory;
import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.models.Configuration;
import com.asiainfo.hb.core.util.Encryption;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.LoginService;
import com.asiainfo.hb.web.models.LoginStateVo;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.models.UserDao;
import com.asiainfo.hb.web.util.DES;
import com.asiainfo.hb.web.util.SaxHandler;
import com.asiainfo.hb.web.util.Util;
import com.asiainfo.hb.web.util.WebUtil;

/**
 *
 * @author Mei Kefu
 * @date 2011-9-26
 */
@SuppressWarnings("unused")
@Controller
public class FrameController {
	
	private static Logger LOG = Logger.getLogger(FrameController.class);
	
	@Autowired
	UserDao userDao;
	
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String login(HttpServletRequest req, HttpServletResponse resp, Model model,HttpSession session){
		
		String _token = req.getParameter("Token");
		LOG.info("Token为：" + _token);
		
		String token = "";
		if(!StringUtils.isEmpty(_token)){
			token = DES.decode(_token);
		}
		
		if(!StringUtils.isEmpty(token)){
			String[] tokenArr = token.split("@");
			//参数格式为sessionID@accountID@appID@IP@userID
			if(tokenArr.length != 5){
				model.addAttribute("msg", "参数错误");
				return toLoginPage(session, model);
			}
			String sessionID = tokenArr[0];
			String accountID = tokenArr[1];
			String appID = tokenArr[2];
//			String IP = tokenArr[3];
			String userID = tokenArr[4];
			
			String checkUrl = "http://10.25.5.177/portal/hbjf_login.do?method=ticketlogin2&APP_KEY=" + appID
					+ "&ACC_KEY=" +accountID + "&Token=" + sessionID + "&IP=10.25.125.100&USER_KEY=" + userID;
			CloseableHttpClient client = HttpClientBuilder.create().build();
			HttpPost post = new HttpPost(checkUrl);
			try {
				CloseableHttpResponse response = client.execute(post);
				int statusCode = response.getStatusLine().getStatusCode();
				LOG.info("4A认证接口返回状态码：" + statusCode);
				if(statusCode == HttpStatus.SC_OK){
					
					SAXParserFactory factory = SAXParserFactory.newInstance();
					XMLReader reader;
					reader = factory.newSAXParser().getXMLReader();
					SaxHandler hander = new SaxHandler();
					reader.setContentHandler(hander);
					reader.parse(new InputSource(response.getEntity().getContent()));
					String[] resultArray = hander.getResult().toString().split(";");
					LOG.debug("4A认证结果：RESULT=" + resultArray[0] + " RESULT_MSG=" + resultArray[1]);
					
					//1验证成功，0验证失败
					if (resultArray[0].equals("1")) {
						
						User user = userDao.getUserById(resultArray[3]);
						if(user == null || user.getId().equals(user.getName())){
							model.addAttribute("msg", "用户名不正确");
							return toLoginPage(session, model);
						}else if(user.getStatus() != 1){
							model.addAttribute("msg", "此帐号已被注销");
							return toLoginPage(session, model);
						}else{
							String ip = Util.getRemoteAddr(req);
							CacheServer cache = CacheServerFactory.getInstance().getCache("SSO");
							cache.put(ip, user.getId());// 改成放用户名
							session.setAttribute("loginname", user.getId());
							session.setAttribute("area_id", user.getCityId());
							session.setAttribute(SessionKeyConstants.USER, user);
							session.setAttribute("_token", _token);
							
							String mvcPath = (String)session.getAttribute("mvcPath");
							String redirectUri = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.redirectUri");
							String redirect = mvcPath + redirectUri;
							resp.getWriter().print("<script>window.location.href='" + redirect + "'</script>");
							return null;
						}
					}else{
						model.addAttribute("msg", resultArray[1]);
						return toLoginPage(session, model);
					}
				}else {
					post.abort();// 马上断开连接
					model.addAttribute("msg", "4A验证异常");
					return toLoginPage(session, model);
				}
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (SAXException e) {
				e.printStackTrace();
			} catch (ParserConfigurationException e) {
				e.printStackTrace();
			}finally{
				post.releaseConnection();
			}
		}
		model.addAttribute("msg", "");
		return toLoginPage(session, model);
	}
	@RequestMapping(value="/")
	public String index(HttpSession session,Model model){
		User user = (User)session.getAttribute(SessionKeyConstants.USER);
		if(user==null){
			return toLoginPage(session, model);
		}else{
			String ua = (String)session.getAttribute("UA");
			String springMvc = (String)session.getAttribute("springMvc");
			return redirectIndex(ua, springMvc,"");
		}
	}
	
	protected String redirectIndex(String ua,String springMvc,String redirect){
		if(isMobileAgent(ua)){
			return "redirect:"+springMvc+"/m";
		}
		if(redirect!=null && redirect.length()>0){
			return "redirect:"+springMvc+redirect;
		}else{
			String redirectUri = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.redirectUri");
			return "redirect:"+springMvc+redirectUri;
		}
	}
	
	protected boolean isMobileAgent(String ua){
		return ua!=null?ua.matches("iPhone|Android|IEMobile|OPhone"):false;
	}
	
	public String toLoginPage(HttpSession session,Model model){
		String redirectUri = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.redirectUri");
		model.addAttribute("redirectUri", redirectUri);
		String appName=Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.appName");
		model.addAttribute("appName", appName);
		model.addAttribute("time", Refresh());
		return "ftl/frame/login";
	}
	
	int timer=0;
	Date datestart=null;
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public @ResponseBody Object loginCheck(HttpServletRequest request,HttpServletResponse response,@RequestParam String userId,@RequestParam String pwd,@RequestParam String code,@RequestParam String code_input,Model model) throws Exception{
		
		Map<String,Object> data = new HashMap<String,Object>();
		if(code_input.trim()==""){
			data.put("msg","你没有输入验证码");
			return data;
		}else if(!(code.equals(code_input))){
			data.put("msg","你的验证码输入的有误");
			return data;
		}
		
		HttpSession sess = request.getSession(true);//获取一个session
		String add = request.getRemoteAddr();//获取当前用户的IP
		sess.setAttribute("id", add);
		Enumeration<?>   e   =   request.getSession().getAttributeNames();   
		Map<String,Object> map=new HashMap<String, Object>();
		while( e.hasMoreElements())   {   
		    String sessionName=(String)e.nextElement();
		    map.put(sessionName, request.getSession().getAttribute(sessionName));
		}
		
		request.getSession().invalidate();
		String ipAddr = WebUtil.getRemoteAddr(request);
		HttpSession session = request.getSession();
		String mvcPath1 = (String)session.getAttribute("mvcPath");
		for(String key:map.keySet()){
			session.setAttribute(key, map.get(key));
		}
		LoginService loginService = (LoginService)BeanFactory.getBean("loginService");
		LoginStateVo result =  loginService.login(userId, pwd, null, ipAddr, SessionKeyConstants.USER, session,response);
		
		
		data.put("success",result.isSuccess());
	    if(!result.isSuccess()){
	    	String id=(String) session.getAttribute("add");
	    	data.put("msg", result.getMsg());
	    	
	    	if(add.equals(ipAddr)){
	    		timer++;
	    		if(timer<10){
	    			data.put("succ", false);
	    			data.put("info", "你输入信息有误，你还有"+(10-timer)+"次机会");
	    			data.put("time",0);
	    		}else{
	    			data.put("succ", true);
	    			data.put("info", "你已经输入超过10次来 请60秒后在登陆");
	    			datestart=new Date();
	    		}
	    	}
	    	
	    }else{
	    	timer=0;
			String mvcPath = (String)session.getAttribute("mvcPath");
			String redirect = request.getParameter("redirect");
			redirect = redirect.replaceAll("\\$", "&");
			if(redirect==null || redirect.length()==0){
				redirect = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.redirectUri");
			}
			
			redirect = mvcPath+redirect;
			data.put("redirect", redirect);
			data.put("userId", Encryption.encrypt(userId));
			loginCheck(session, request, response, userId);
	    }
	   
	    return data;
	}
	public int Refresh(){
		int time=0;
		int a=main(datestart);
		if(a==60){
			timer=0;
    		datestart=null;
    	}else if(a>0){
    		time=60-a;
    	}
		return time;
	}
	public   int main(Date date) {  
        Date date1=new Date();
        if(date!=null){
        	long test=Math.abs(date1.getTime()-date.getTime());
    		int timer=(int) (test/1000);
    		date=null;
    		return timer;
        }
		return 0;
    }  
	@RequestMapping(value="/outlogin")
	public  String outloginCheck(HttpServletRequest request,HttpServletResponse response,Model model,HttpSession session) throws Exception{
		session.removeAttribute(SessionKeyConstants.USER);
		session.removeAttribute("loginname");
		session.removeAttribute("area_id");
	    return "redirect:login";
	}
	
	
	
	@RequestMapping(value="/currentUser",method=RequestMethod.POST)
	public @ResponseBody Object currentUser(HttpServletRequest request) {
		return request.getSession().getAttribute(SessionKeyConstants.USER);
	}
	
	/*
	 * 上传明文，返回加密后的密文
	 */
	@RequestMapping(value="/encrypt") 
	public @ResponseBody Object encryptPassword(HttpServletRequest request){
		String password = request.getParameter("password");
		return Encryption.encrypt(password);
	}
	/*
	 * 上传密文，返回解密后的明文
	 */
	@RequestMapping(value="/decrypt") 
	public @ResponseBody Object decryptPassword(HttpServletRequest request){
		String password = request.getParameter("password");
		return Encryption.decrypt(password);
	}
	/*
	 * 取服务器的时间
	 */
	@RequestMapping(value="/currentTime") 
	public @ResponseBody Object currentTime(HttpServletRequest request){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日");
		String dateNowStr = dateFormat.format(GregorianCalendar.getInstance().getTime());
		return dateNowStr;
	}
	@ExceptionHandler(NoSuchRequestHandlingMethodException.class)
	public String handleIOException(NoSuchRequestHandlingMethodException ex, HttpServletRequest request) {
		return ClassUtils.getShortName(ex.getClass());
	}
	
	@RequestMapping(value="/logout")
    public String loginOut(HttpServletRequest request,Model model,SessionStatus status){
        status.setComplete();
        LoginService loginService = (LoginService)BeanFactory.getBean(LoginService.class);
        loginService.clearCookie(request);
        return toLoginPage(request.getSession(), model);
    }
	
	public void loginCheck(HttpSession session, HttpServletRequest request, HttpServletResponse response, String userId) {
		LOG.info("userId=" + userId);
		String ip = Util.getRemoteAddr(request);
		CacheServer cacheSSO = CacheServerFactory.getInstance().getCache("SSO");
		Integer loginErrorCount = (Integer)cacheSSO.get("login_error_count"+ip);
		loginErrorCount=null;
		LOG.info("loginErrorCount=" + loginErrorCount);
		User user = userDao.getUserById(userId);
		CacheServer cache = CacheServerFactory.getInstance().getCache("SSO");
		cache.put(ip, user.getId());// 改成放用户名
	}
	
}
