package com.asiainfo.bass.apps.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.apps.models.Twitter;
import com.asiainfo.bass.apps.models.TwitterDao;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-24
 */
@Controller
@RequestMapping(value = "/comment")
@SessionAttributes({SessionKeyConstants.USER})
public class CommentController {

	@Autowired
	private TwitterDao twitterDao;

	@RequestMapping(method = RequestMethod.POST)
	public @ResponseBody
	Object createComment(WebRequest request, @ModelAttribute("user") User user) {

		String content = request.getParameter("content");
		String replyId = request.getParameter("replyId");
		String reply = request.getParameter("reply");
		String state = request.getParameter("state");

		Twitter twitter = new Twitter();

		twitter.setContent(content);
		twitter.setReplyId(replyId);
		twitter.setReply(reply);
		twitter.setUser(user);
		twitter.setState(state);
		twitterDao.save(twitter);
		// model.addAttribute(twitter);

		return commetsData(request, replyId);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "{cid}", method = RequestMethod.POST)
	public @ResponseBody
	Object commetsData(WebRequest request, @PathVariable("cid") String cid) {

		String page = request.getParameter("page");

		if (page == null || page.length() == 0 || !page.matches("[0-9]+")) {
			page = "1";
		}

		String pageSize = request.getParameter("pageSize");
		if (pageSize == null || pageSize.length() == 0 || !pageSize.matches("[0-9]+")) {
			pageSize = "5";
		}

		Map map = new HashMap();
		map.put("currentPage", page);
		map.put("pageSize", pageSize);
		map.put("totalEl", twitterDao.getCommentsCount(cid));
		map.put("comments", twitterDao.getComments(cid, Integer.valueOf(page), Integer.valueOf(pageSize)));

		return map;
	}

}
