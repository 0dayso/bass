package com.asiainfo.bass.apps.news;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/news")
@SessionAttributes({ "mvcPath", SessionKeyConstants.USER})
public class NewsController {
	
private static Logger LOG = Logger.getLogger(NewsController.class);
	
	@Autowired
	private NewsDao newsDao;
	
	@Autowired
	private NewsService newsService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String NewInif(@ModelAttribute("user") User user) {
		return "ftl/news/newsInit";
	}
	
	/**
	 * 
	 * @param user			用户信息
	 * @param title			标题
	 * @param content		内容
	 * @param begindate		开始有效时间
	 * @param enddate		结束有效时间
	 * @param issend		是否发送给掌分
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/save", method = RequestMethod.PUT)
	public @ResponseBody
	Map save(@ModelAttribute("user") User user, @RequestParam String title, @RequestParam String content, @RequestParam String begindate, @RequestParam String enddate, @RequestParam String issend){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			newsDao.save(title, content, begindate, enddate, issend, user.getId());
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/update", method = RequestMethod.PUT)
	public @ResponseBody
	Map update(@ModelAttribute("user") User user, @RequestParam String newsid, @RequestParam String title, @RequestParam String content, @RequestParam String begindate, @RequestParam String enddate, @RequestParam String issend){
		Map msg = new HashMap();
		msg.put("status", "修改成功");
		try{
			newsDao.update(newsid, title, content, begindate, enddate, issend, user.getId());
		}catch(Exception e){
			msg.put("status", "修改失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/auditing", method = RequestMethod.PUT)
	public @ResponseBody
	Map auditing(@ModelAttribute("user") User user, @RequestParam String newsid, @RequestParam String issend){
		Map msg = new HashMap();
		msg.put("status", "发布成功");
		try{
			LOG.info("是否发送掌分===================="+issend);
			if(!"0".equals(String.valueOf(issend))){
				//接口把新闻公告发送给掌分
				LOG.info("调用掌分接口");
				HashMap result = newsService.sendPost(newsid);
				LOG.info("调用掌分接口返回信息=============="+result.get("msg"));
				if("200".equals(result.get("code"))){
					newsDao.auditing(newsid);
				} 
				msg.put("status", result.get("msg"));
			}else{
				newsDao.auditing(newsid);
			}
		}catch(Exception e){
			msg.put("status", "发布失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/delete", method = RequestMethod.DELETE)
	public @ResponseBody
	Map delete(@ModelAttribute("user") User user, @RequestParam String newsid){
		Map msg = new HashMap();
		msg.put("status", "删除成功");
		try{
			newsDao.delete(newsid);
		}catch(Exception e){
			msg.put("status", "删除失败");
			e.printStackTrace();
		}
		return msg;
	}
}
