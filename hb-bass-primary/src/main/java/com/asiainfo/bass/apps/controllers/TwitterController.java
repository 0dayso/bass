package com.asiainfo.bass.apps.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.apps.models.Twitter;
import com.asiainfo.bass.apps.models.TwitterDao;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.models.UserDao;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-24
 */
@Controller
@RequestMapping(value = "/twitter")
@SessionAttributes({SessionKeyConstants.USER})
public class TwitterController {

	@Autowired
	private TwitterDao twitterDao;

	@Autowired
	private UserDao userDao;

	protected String render(Model model, @ModelAttribute("user") User user) {

		Twitter t = new Twitter();
		t.setUser(user);

		model.addAttribute("twitter", t);

		// model.addAttribute("twitters",twitterDao.getTwitters());

		// model.addAttribute("mytwis",twitterDao.getUserTwitters(userId));

		model.addAttribute("actives", twitterDao.getActiveUsers(user.getId()));

		// 可能关注的话题（应用）

		// 可能关注的人
		return "/ftl/twitter/twitter";
		// return "/twitter/twitter";
	}

	@RequestMapping(method = RequestMethod.POST)
	public String create(WebRequest request, @RequestParam("state.item") String item, @RequestParam("state.tab") String tab, Twitter twitter, Model model, @ModelAttribute("user") User user) {
		twitterDao.save(twitter);
		// model.addAttribute(twitter);

		if ("".equalsIgnoreCase(item)) {
			return all(request, model, user);
		} else {
			return my(model, user);
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(method = RequestMethod.GET)
	public String all(WebRequest request, Model model, @ModelAttribute("user") User user) {

		String page = request.getParameter("page");

		if (page == null || page.length() == 0 || !page.matches("[0-9]+")) {
			page = "1";
		}

		String pageSize = request.getParameter("pageSize");
		if (pageSize == null || pageSize.length() == 0 || !pageSize.matches("[0-9]+")) {
			pageSize = "15";
		}

		model.addAttribute("twis", twitterDao.getTwitters(Integer.valueOf(page), Integer.valueOf(pageSize)));
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("currentPage", page);
		model.addAttribute("twisCount", twitterDao.getTwittersCount());

		Map state = new HashMap();
		state.put("item", "");
		state.put("tab", "");
		model.addAttribute("state", state);

		return render(model, user);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/my", method = RequestMethod.GET)
	public String my(Model model, @ModelAttribute("user") User user) {
		String userId = user.getId();
		model.addAttribute("twis", twitterDao.getUserTwitters(userId));

		Map state = new HashMap();
		state.put("item", "");
		state.put("tab", "my");
		model.addAttribute("state", state);

		return render(model, user);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/atmy", method = RequestMethod.GET)
	public String atmy(Model model, @ModelAttribute("user") User user) {
		String userId = user.getId();
		model.addAttribute("twis", twitterDao.getAtUserTwitters(userId));
		Map state = new HashMap();
		state.put("item", "");
		state.put("tab", "atmy");
		model.addAttribute("state", state);
		return render(model, user);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/feed", method = RequestMethod.GET)
	public String feed(Model model, @ModelAttribute("user") User user) {
		String userId = user.getId();

		Map state = new HashMap();
		state.put("item", "feed");
		state.put("tab", "feed");
		model.addAttribute("state", state);

		model.addAttribute("twis", twitterDao.getFeed(userId));

		model.addAttribute("actives", twitterDao.getActiveUsers(userId));

		// return render(model, user);
		return "twitter/twitter";
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/fed", method = RequestMethod.GET)
	public String fed(Model model, @ModelAttribute("user") User user) {
		String userId = user.getId();

		Map state = new HashMap();
		state.put("item", "feed");
		state.put("tab", "fed");
		model.addAttribute("state", state);

		model.addAttribute("twis", twitterDao.getFed(userId));

		model.addAttribute("actives", twitterDao.getActiveUsers(userId));

		// return render(model, user);
		return "twitter/twitter";
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/fav", method = RequestMethod.GET)
	public String fav(Model model, @ModelAttribute("user") User user) {
		String userId = user.getId();
		Map state = new HashMap();
		state.put("item", "fav");
		state.put("tab", "fav");
		model.addAttribute("state", state);
		model.addAttribute("actives", twitterDao.getActiveUsers(userId));
		return "twitter/twitter";
	}

	@RequestMapping(value = "{twitterId}", method = RequestMethod.GET)
	public String add(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}

	@RequestMapping(value = "{twitterId}", method = RequestMethod.POST)
	public String reply(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}

	@RequestMapping(value = "{twitterId}", method = RequestMethod.DELETE)
	public String delete(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}

	@RequestMapping(value = "/user/{userId}", method = RequestMethod.GET)
	public String render(@PathVariable("userId") String userId, Model model, @ModelAttribute("user") User user) {
		model.addAttribute("user", userDao.getUserById(userId));
		model.addAttribute("twis", twitterDao.getUserTwitters(userId));

		model.addAttribute("feedUser", twitterDao.getFeed(userId));
		model.addAttribute("fedUser", twitterDao.getFed(userId));
		model.addAttribute("actives", twitterDao.getActiveUsers(userId));

		Twitter t = new Twitter();
		t.setUser(user);

		model.addAttribute("twitter", t);

		return "twitter/user";// 这个需要转到专门的页面
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/user/{userId}", method = RequestMethod.POST)
	public @ResponseBody
	Map replyUser(@PathVariable("userId") String fUserId, Model model, @ModelAttribute("user") User user) {
		Map map = new HashMap();
		map.put("message", twitterDao.feed(user.getId(), fUserId));
		return map;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/user/{userId}", method = RequestMethod.PUT)
	public @ResponseBody
	Map feedUser(@PathVariable("userId") String fUserId, Model model, @ModelAttribute("user") User user) {
		Map map = new HashMap();
		map.put("message", twitterDao.feed(user.getId(), fUserId));
		return map;
	}

	@RequestMapping(value = "/user/{userId}", method = RequestMethod.DELETE)
	public @ResponseBody
	Object getUername(@PathVariable("userId") String userId, Model model) {
		return userDao.getUserById(userId);
	}

	@RequestMapping(value = "/message", method = RequestMethod.GET)
	public String renderMsg(Model model, @ModelAttribute("user") User user) {
		model.addAttribute("_action", "msg");
		return "twitter/twitter";
	}

	@RequestMapping(value = "/message", method = RequestMethod.POST)
	public String sendMsg(Twitter t) {

		return null;
	}

	@RequestMapping(value = "/message/{twitterId}", method = RequestMethod.GET)
	public String msg(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}

	@RequestMapping(value = "/message/{twitterId}", method = RequestMethod.POST)
	public String replyMsg(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}

	@RequestMapping(value = "/message/{twitterId}", method = RequestMethod.DELETE)
	public String delMsg(@PathVariable("twitterId") String twitterId, Model model) {

		return null;
	}
}
