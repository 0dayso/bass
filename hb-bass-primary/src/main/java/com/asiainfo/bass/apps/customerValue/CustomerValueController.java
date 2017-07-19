package com.asiainfo.bass.apps.customerValue;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/customer")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class CustomerValueController {
	
private static Logger LOG = Logger.getLogger(CustomerValueController.class);
	
	@Autowired
	private CustomerValueService customerValueService;
	
	@Autowired
	private CustomerValueDao customerValueDao;
	
	@RequestMapping(method = RequestMethod.GET)
	public String index(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityid",user.getCityId());
		return "ftl/customer/index";
	}
	
	@RequestMapping(value = "/getCustUserList")
	@ResponseBody
	public Map<String, Object> getCustUserList(HttpServletRequest req){
		String cityId = req.getParameter("cityId");
		String userName = req.getParameter("userName");
		String type = req.getParameter("type");
		String limitStr = req.getParameter("limit");
		Map<String, Object> list = customerValueDao.getCustUserList(cityId, userName, type, limitStr);
		return list;
	}
	
	@RequestMapping(value = "/assessConfig", method = RequestMethod.GET)
	public String assessConfig(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityid",user.getCityId());
		return "ftl/customer/assessConfig";
	}
	
	@RequestMapping(value = "/getCity", method = RequestMethod.POST)
	public void getCity(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		List<Map<String, Object>> areaList = customerValueDao.getAreaList();
		try {
			String jsonStr = JsonHelper.getInstance().write(areaList);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/getChannel", method = RequestMethod.POST)
	public void getChannel(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		List<Map<String, Object>> channelList = customerValueDao.getChannelList();
		try {
			String jsonStr = JsonHelper.getInstance().write(channelList);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/saveConfig", method = RequestMethod.POST)
	public void saveConfig(HttpServletResponse response, @RequestParam String city, @RequestParam String type, @RequestParam String username, @RequestParam String mobilephone){
		String result = "新增成功";
		try{
			customerValueDao.saveConfig(city, type, username, mobilephone);
		}catch(Exception e){
			result = "新增失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/saveAssessConfig", method = RequestMethod.POST)
	public void saveAssessConfig(HttpServletResponse response, @RequestParam String city, @RequestParam String type, @RequestParam String username, @RequestParam String mobilephone){
		String result = "新增成功";
		try{
			customerValueDao.saveAssessConfig(city, type, username, mobilephone);
		}catch(Exception e){
			result = "新增失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/deleteConfig", method = RequestMethod.POST)
	public void deleteConfig(HttpServletResponse response, @RequestParam int id){
		String result = "删除成功";
		try{
			customerValueDao.deleteConfig(id);
		}catch(Exception e){
			result = "删除失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/deleteAssessConfig", method = RequestMethod.POST)
	public void deleteAssessConfig(HttpServletResponse response, @RequestParam int id){
		String result = "删除成功";
		try{
			customerValueDao.deleteAssessConfig(id);
		}catch(Exception e){
			result = "删除失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/addReply", method = RequestMethod.POST)
	public void addReply(HttpServletResponse response, @ModelAttribute("user") User user, @RequestParam String time_id, @RequestParam String area_code, @RequestParam String fee_id, @RequestParam String fee_name, @RequestParam String type, @RequestParam String reply){
		String result = "新增成功";
		try{
			customerValueDao.addReply(time_id, area_code, user.getName(), fee_id, fee_name, type, reply);
		}catch(Exception e){
			result = "新增失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/replyLevel", method = RequestMethod.POST)
	public void replyLevel(HttpServletResponse response, @RequestParam String id, @RequestParam String reply_level){
		String result = "评估成功";
		try{
			customerValueDao.replyLevel(id, reply_level);
		}catch(Exception e){
			result = "评估失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 营销案（事中预警）预警
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningListForSZYJ", method = RequestMethod.GET)
	public String warningListForSZYJ(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/customerValueWarning";
	}
	
	/**
	 * 营销案（事中预警）预警
	 * @return
	 */
	@RequestMapping(value = "/getCustValWarningList")
	@ResponseBody
	public Map<String, Object> getCustValWarningList(@ModelAttribute("user") User user, HttpServletRequest req){
		String time = req.getParameter("time");
		String channel = req.getParameter("channel");
		String status = req.getParameter("status");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getCustValWarningList(user.getName(), time, channel, status, limitStr);
	}
	
	/**
	 * 营销案（后评估）预警
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningListForJXPG", method = RequestMethod.GET)
	public String warningListForJXPG(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/customerValueWarningForJXPG";
	}
	
	@RequestMapping(value= "/getWarningForJXPGInfo")
	@ResponseBody
	public Map<String, Object> getWarningForJXPGInfo(@ModelAttribute("user")User user,HttpServletRequest req){
		String time = req.getParameter("time");
		String channel = req.getParameter("channel");
		String status = req.getParameter("status");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningForJXPGInfo(user.getName(), time, channel, status, limitStr);
	}
	
	/**
	 * 渠道监控预警
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningListForQDKZ", method = RequestMethod.GET)
	public String warningListForQDKZ(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/customerValueWarningForQDKZ";
	}
	
	@RequestMapping(value= "/getWarningListForQDKZ")
	@ResponseBody
	public Map<String, Object> getWarningListForQDKZ(@ModelAttribute("user") User user, HttpServletRequest req){
		String time = req.getParameter("time");
		String channel = req.getParameter("channel");
		String status = req.getParameter("status");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningListForQDKZ(time, channel, status, user.getName(), limitStr);
	}
	
	/**
	 * 资费案预警
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningListForZFA", method = RequestMethod.GET)
	public String warningListForZFA(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/customerValueWarningForZFA";
	}
	
	@RequestMapping(value="/getWarningListForZFA")
	@ResponseBody
	public Map<String, Object> getWarningListForZFA(HttpServletRequest req, @ModelAttribute("user") User user){
		String time = req.getParameter("time");
		String status = req.getParameter("status");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningListForZFA(user.getName(), time, status, limitStr);
	}
	
	/**
	 * 营销案（事中预警）预警回复
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/replyForWarning", method = RequestMethod.GET)
	public String replyForWarning(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReply(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/replyForWarning";
	}
	
	@RequestMapping(value = "/getWariningReply")
	@ResponseBody
	public Map<String, Object> getWariningReply(HttpServletRequest req){
		String limitStr = req.getParameter("limit");
		String feeId = req.getParameter("feeId");
		return customerValueDao.getWarningReply(feeId, limitStr);
	}
	
	/**
	 * 营销案（绩效评估）预警回复
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/replyForWarningForJXPG", method = RequestMethod.GET)
	public String replyForWarningForJXPG(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReply(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/replyForWarningForJXPG";
	}
	
	@RequestMapping(value = "/getReplyForWarningForJXPGInfo")
	@ResponseBody
	public Map<String, Object> getReplyForWarningForJXPGInfo(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getReplyForWarningForJXPGInfo(feeId, limitStr);
	}
	
	/**
	 * 渠道监控预警回复
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/replyForWarningForQDKZ", method = RequestMethod.GET)
	public String replyForWarningForQDKZ(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReply(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/replyForWarningForQDKZ";
	}
	
	@RequestMapping(value= "/getReplyForWarningForQDKZ")
	@ResponseBody
	public Map<String, Object> getReplyForWarningForQDKZ(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getReplyForWarningForQDKZ(feeId, limitStr);
	}
	
	/**
	 * 资费案预警回复
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/replyForWarningForZFA", method = RequestMethod.GET)
	public String replyForWarningForZFA(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReply(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/replyForWarningForZFA";
	}
	
	@RequestMapping(value = "/getReplyForWarningForZFA")
	@ResponseBody
	public Map<String, Object> getReplyForWarningForZFA(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getReplyForWarningForZFA(feeId, limitStr);
	}
	
	/**
	 * 营销案（事中预警）审核列表
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/assessForWarningForSZYJ", method = RequestMethod.GET)
	public String assessForWarningForSZYJ(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/assessForWarning";
	}
	
	@RequestMapping(value = "/getAccessForWarningInfo")
	@ResponseBody
	public Map<String, Object> getAccessForWarningInfo(@ModelAttribute("user")User user, HttpServletRequest req){
		String time = req.getParameter("time");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getAccessForWarningInfo(user.getName(), time, limitStr);
	}
	
	/**
	 * 营销案（绩效评估）审核列表
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/assessForWarningForJXPG", method = RequestMethod.GET)
	public String assessForWarningForJXPG(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/assessForWarningForJXPG";
	}
	
	@RequestMapping(value= "/getAccessForWarningForJXPGInfo")
	@ResponseBody
	public Map<String, Object> getAccessForWarningForJXPGInfo(@ModelAttribute("user") User user,HttpServletRequest req){
		String time = req.getParameter("time");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getAccessForWarningForJXPGInfo(time, user.getName(), limitStr);
	}
	
	/**
	 * 渠道监控审核列表
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/assessForWarningForQDKZ", method = RequestMethod.GET)
	public String assessForWarningForQDKZ(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/assessForWarningForQDKZ";
	}
	
	@RequestMapping(value = "/getAssessForWarningForQDKZ")
	@ResponseBody
	public Map<String, Object> getAssessForWarningForQDKZ(@ModelAttribute("user") User user, HttpServletRequest req){
		String time = req.getParameter("time");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getAssessForWarningForQDKZ(user.getName(), time, limitStr);
	}
	
	/**
	 * 资费案审核列表
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/assessForWarningForZFA", method = RequestMethod.GET)
	public String assessForWarningForZFA(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("username",user.getName());
		return "ftl/customer/assessForWarningForZFA";
	}
	
	@RequestMapping(value = "/getAssessForWarningForZFA")
	@ResponseBody
	public Map<String, Object> getAssessForWarningForZFA(HttpServletRequest req, @ModelAttribute("user") User user){
		String time = req.getParameter("time");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getAssessForWarningForZFA(user.getName(), time, limitStr);
	}
	
	/**
	 * 营销案（事中预警）预警评估
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningForAssess", method = RequestMethod.GET)
	public String warningForAssess(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReplyForWarning(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/warningForAssess";
	}
	
	@RequestMapping(value = "getWarningForAccessInfo")
	@ResponseBody
	public Map<String, Object> getWarningForAccessInfo(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningForAccessInfo(feeId, limitStr);
	}
	
	/**
	 * 营销案（绩效评估）预警评估
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningForAssessForJXPG", method = RequestMethod.GET)
	public String warningForAssessForJXPG(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReplyForWarning(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/warningForAssessForJXPG";
	}
	
	@RequestMapping(value = "/getWarningForAssessForJXPGInfo")
	@ResponseBody
	public Map<String, Object> getWarningForAssessForJXPGInfo(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningForAssessForJXPGInfo(feeId,limitStr);
	}
	
	/**
	 * 渠道监控预警评估
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningForAssessForQDKZ", method = RequestMethod.GET)
	public String warningForAssessForQDKZ(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReplyForWarning(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/warningForAssessForQDKZ";
	}
	
	@RequestMapping(value = "/getWarningForAssessForQDKZ")
	@ResponseBody
	public Map<String, Object> getWarningForAssessForQDKZ(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningForAssessForQDKZ(feeId, limitStr);
	}
	
	/**
	 * 资费案预警评估
	 * @param request
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/warningForAssessForZFA", method = RequestMethod.GET)
	public String warningForAssessForZFA(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String fee_id = request.getParameter("fee_id");
		String type = request.getParameter("type");
		String time_id = request.getParameter("time_id");
		String area_code = request.getParameter("area_code");
		HashMap<String, Object> result = customerValueService.getReplyForWarning(fee_id, time_id, type, area_code);
		model.addAttribute("time_id", result.get("time_id"));
		model.addAttribute("area_code", area_code);
		model.addAttribute("fee_id", result.get("fee_id"));
		model.addAttribute("fee_name", result.get("fee_name"));
		model.addAttribute("type", type);
		model.addAttribute("area_name", result.get("area_name"));
		model.addAttribute("act_type", result.get("act_type"));
		model.addAttribute("replyList", result.get("list"));
		return "ftl/customer/warningForAssessForZFA";
	}
	
	@RequestMapping(value= "/getWarningForAssessForZFA")
	@ResponseBody
	public Map<String, Object> getWarningForAssessForZFA(HttpServletRequest req){
		String feeId = req.getParameter("feeId");
		String limitStr = req.getParameter("limit");
		return customerValueDao.getWarningForAssessForZFA(feeId, limitStr);
	}
	
	@RequestMapping(value = "/panoramicView/{zb_code}", method = RequestMethod.GET)
	public String panoramicView(@ModelAttribute("user") User user, Model model, @PathVariable("zb_code") String zb_code) {
		String end_time = customerValueDao.getMaxTime(zb_code);
		if(!"".equals(end_time) && end_time!=null){
			String start_time = String.valueOf(Integer.parseInt(end_time)-1);
			HashMap<String, String> result = customerValueService.getCustomerInfo(start_time, end_time, zb_code);
			String _header = String.valueOf(result.get("header"));
			String sql = String.valueOf(result.get("sql"));
			Map<String, Object> info = customerValueDao.getZbName(zb_code);
			String zb_name = String.valueOf(info.get("CODE_NAME"));
			String unit = String.valueOf(info.get("UNIT"));
			Map<String,List<Map<String,Object>>> treeMap = customerValueService.getTreeList();
			String res = JsonHelper.getInstance().write(treeMap);
			res = res.replaceAll("\\/", "/");
			Map<String, Object> codeInfo = customerValueDao.getCodeInfo(zb_code);
			model.addAttribute("res", res);
			model.addAttribute("header", _header);
			model.addAttribute("sql", sql);
			model.addAttribute("zb_code", zb_code);
			model.addAttribute("zb_name", zb_name);
			model.addAttribute("unit", unit);
			model.addAttribute("start_time", start_time);
			model.addAttribute("end_time", end_time);
			model.addAttribute("month_code",String.valueOf(codeInfo.get("MONTH_CODE")));
			model.addAttribute("check",String.valueOf(codeInfo.get("check")));
		}
		return "ftl/customer/view";
	}
	
	@RequestMapping(value = "/query", method = RequestMethod.POST)
	public void query(HttpServletResponse response, WebRequest request, Model model, @ModelAttribute("user") User user) {
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		String zb_code = request.getParameter("zb_code");
//		String str = request.getParameter("str");
		HashMap<String, String> result = customerValueService.getCustomerInfo(start_time, end_time, zb_code);
		String _header = String.valueOf(result.get("header"));
		String sql = String.valueOf(result.get("sql"));
		Map<String, Object> info = customerValueDao.getZbName(zb_code);
		String zb_name = String.valueOf(info.get("CODE_NAME"));
		String unit = String.valueOf(info.get("UNIT"));
		Map<String,List<Map<String,Object>>> treeMap = customerValueService.getTreeList();
		String res = JsonHelper.getInstance().write(treeMap);
		res = res.replaceAll("\\/", "/");
		Map<String, Object> codeInfo = customerValueDao.getCodeInfo(zb_code);
		model.addAttribute("res", res);
		model.addAttribute("header", _header);
		model.addAttribute("sql", sql);
		model.addAttribute("zb_code", zb_code);
		model.addAttribute("zb_name", zb_name);
		model.addAttribute("unit", unit);
		model.addAttribute("start_time", start_time);
		model.addAttribute("end_time", end_time);
		model.addAttribute("month_code",String.valueOf(codeInfo.get("MONTH_CODE")));
		model.addAttribute("check",String.valueOf(codeInfo.get("check")));
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@RequestMapping(value = "/createImg", method = RequestMethod.POST)
	public void createImg(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String start_time = request.getParameter("start_time");
			String end_time = request.getParameter("end_time");
			String city = request.getParameter("city");
			String zb_code = request.getParameter("zb_code");
			if(city.equals("null")||"".equals(city)){
				city="HB";
			}
			Map<String,Object> result = new HashMap<String, Object>();
			List<Map<String,Object>> list = customerValueDao.getList(start_time, end_time, city, zb_code);
			if(list!=null && list.size()>0){
				double[] date1 = new double[list.size()];
				String[] columns = new String[list.size()];
				for(int i=0;i<list.size();i++){
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					double instore = Double.parseDouble(map.get("value").toString());
					columns[i] = map.get("time_id").toString();
					date1[i] = instore;
				}
				result.put("date1", date1);
				result.put("columns", columns);
			}
			Map<String, Object> info = customerValueDao.getZbName(zb_code);
			String zb_name = String.valueOf(info.get("CODE_NAME"));
			String unit = String.valueOf(info.get("UNIT"));
			result.put("zb_name", zb_name);
			result.put("unit", unit);
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@RequestMapping(value = "/sendmms/{month}", method = RequestMethod.GET)
	public void sendmms(HttpServletResponse response, WebRequest request, Model model, @ModelAttribute("user") User user, @PathVariable("month") String month) {
		boolean flag = customerValueService.sendmail(month);
		String result = "false";
		if(flag){
			result = "ok";
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
		LOG.info("短信发送："+flag);
	}
	
	@RequestMapping(value = "/sendmail/{month}", method = RequestMethod.GET)
	public void sendsms(HttpServletResponse response, WebRequest request, Model model, @ModelAttribute("user") User user, @PathVariable("month") String month) {
		boolean flag = customerValueService.sendsms(month);
		String result = "false";
		if(flag){
			result = "ok";
		}
		String jsonStr = JsonHelper.getInstance().write(result);
		try {
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
		LOG.info("邮件发送："+flag);
	}
}
