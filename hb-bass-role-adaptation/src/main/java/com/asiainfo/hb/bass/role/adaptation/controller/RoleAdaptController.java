package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;
import com.asiainfo.hb.bass.role.adaptation.models.Node;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapService;
import com.asiainfo.hb.bass.role.adaptation.service.KpiVisitService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.DateUtil;
import com.asiainfo.hb.core.util.JedisClusterUtil;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

import redis.clients.jedis.JedisCluster;

/**
 * @author 李志坚
 * @since 2017年03月24日
 */
@Controller
@RequestMapping("/roleAdapt")
@SessionAttributes({ SessionKeyConstants.USER })
public class RoleAdaptController {
	public Logger logger = LoggerFactory.getLogger(RoleAdaptController.class);

	@Autowired
	AdapMenuService aMenuService;
	@Autowired
	AdapService adapService;
	@Autowired
	KpiVisitService kipVisitServie;

	@RequestMapping(value = "index/{menuId}")
	public String redirectIndex(@PathVariable String menuId, HttpServletRequest request, HttpServletResponse response, @ModelAttribute(SessionKeyConstants.USER) User user, Model model) {

		try {
			String queryDB = request.getParameter("queryDB");

			JedisCluster jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();

			Date date = DateUtil.getDateByIntervalDays(new Date(), -1);
			String lastDay = DateUtil.date2String(date, "yyyy-MM-dd");

			// 查出传入的menuId在BOC_INDICATO_MENU表中相同category下的所有指标
			AdapMenu adapMenu = aMenuService.getOneMenus(menuId);

			String cityId = user.getCityId();
			List<Map<String, Object>> areaList = new ArrayList<Map<String, Object>>();
			Map<String, Object> areaMap = new HashMap<String, Object>();
			if ("0".equals(cityId)) {
				areaMap.put("dimtype", "PROV_ID");
				areaMap.put("dimvalue", "HB");
				areaMap.put("dimname", "湖北");
			} else {
				areaMap.put("dimtype", "CITY_ID");
				String areaCode = user.getAreaCode();
				if (!StringUtils.isEmpty(areaCode) && areaCode.length() > 5) {
					areaCode = areaCode.substring(0, 5);
				}
				areaMap.put("dimvalue", areaCode);
				areaMap.put("dimname", user.getAreaName());
			}
			areaList.add(areaMap);

			String bocIndicatorMenus = "";
			if ("1".equals(queryDB) || jedisCluster == null || !jedisCluster.exists("indexList_" + menuId)) {
				// 构造7级指标树形存储结构
				List<Node> indexList = new ArrayList<Node>();
				Node node = new Node();
				node.setId(adapMenu.getMenuId());
				node.setpId(adapMenu.getParentmenuId());
				node.setName(adapMenu.getMenuName());
				indexList.add(node);
				List<AdapMenu> child1 = adapMenu.getChildren();
				if (child1 != null) {
					for (AdapMenu menu1 : child1) {
						Node node1 = new Node();
						node1.setId(menu1.getMenuId());
						node1.setpId(menu1.getParentmenuId());
						node1.setName(menu1.getMenuName());
						indexList.add(node1);
						List<AdapMenu> child2 = menu1.getChildren();
						if (child2 != null) {
							for (AdapMenu menu2 : child2) {
								Node node2 = new Node();
								node2.setId(menu2.getMenuId());
								node2.setpId(menu2.getParentmenuId());
								node2.setName(menu2.getMenuName());
								indexList.add(node2);
								List<AdapMenu> child3 = menu2.getChildren();
								if (child3 != null) {
									for (AdapMenu menu3 : child3) {
										Node node3 = new Node();
										node3.setId(menu3.getMenuId());
										node3.setpId(menu3.getParentmenuId());
										node3.setName(menu3.getMenuName());
										indexList.add(node3);
										List<AdapMenu> child4 = menu3.getChildren();
										if (child4 != null) {
											for (AdapMenu menu4 : child4) {
												Node node4 = new Node();
												node4.setId(menu4.getMenuId());
												node4.setpId(menu4.getParentmenuId());
												node4.setName(menu4.getMenuName());
												indexList.add(node4);
												List<AdapMenu> child5 = menu4.getChildren();
												if (child5 != null) {
													for (AdapMenu menu5 : child5) {
														Node node5 = new Node();
														node5.setId(menu5.getMenuId());
														node5.setpId(menu5.getParentmenuId());
														node5.setName(menu5.getMenuName());
														indexList.add(node5);
														List<AdapMenu> child6 = menu5.getChildren();
														if (child6 != null) {
															for (AdapMenu menu6 : child6) {
																Node node6 = new Node();
																node6.setId(menu6.getMenuId());
																node6.setpId(menu6.getParentmenuId());
																node6.setName(menu6.getMenuName());
																indexList.add(node6);
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				bocIndicatorMenus = JsonHelper.getInstance().write(indexList);
				jedisCluster.set("indexList_" + menuId, bocIndicatorMenus);
			} else {
				bocIndicatorMenus = jedisCluster.get("indexList_" + menuId);
			}

			// 暂时不放redis
			@SuppressWarnings("rawtypes")
			List lastestOnlineReportList = adapService.getLastOnlineReport(menuId, "", user.getId());
			String lastestOnlineReport = "";
			if ("1".equals(queryDB) || jedisCluster == null || !jedisCluster.exists("lastestOnlineReport_" + menuId)) {
				lastestOnlineReportList = adapService.getLastOnlineReport(menuId, "", user.getId());
				lastestOnlineReport = JsonHelper.getInstance().write(lastestOnlineReportList);
				jedisCluster.set("lastestOnlineReport_" + menuId, lastestOnlineReport);
			} else {
				lastestOnlineReport = jedisCluster.get("lastestOnlineReport_" + menuId);
			}
			model.addAttribute("menu_id", JsonHelper.getInstance().write(Integer.parseInt(menuId)));
			model.addAttribute("appName", null != adapMenu && null != adapMenu.getMenuName() ? adapMenu.getMenuName() : "");
			model.addAttribute("lastDay", lastDay);
			model.addAttribute("lastestOnlineReport", lastestOnlineReportList);
			model.addAttribute("bocIndicatorMenus", bocIndicatorMenus);
			model.addAttribute("loginUser", user.getId());
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return "ftl/kpi";
	}

	@RequestMapping(value = "/roleAdaptParam")
	@ResponseBody
	public Map<String, Object> getRoleAdaptParam(HttpServletRequest request, HttpServletResponse response, @ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
		String menuId = request.getParameter("menuId");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cityList", adapService.getCity(""));
		map.put("relaReports", adapService.getRelaReports(menuId, "", user.getId()));
		map.put("relaApps", adapService.getRelaApps(menuId, "", user.getId()));
		map.put("relaColls", adapService.getRelaCollect(menuId, "", user.getId()));
		return map;
	}

	@RequestMapping(value = "/recommend")
	@ResponseBody
	public List<Map<String, Object>> kipVisitServie() {
		return kipVisitServie.getNum();
	}
	
	@RequestMapping(value = "/updateKpiDes")
	@ResponseBody
	public  Map<String,Object> updateKpiDes(HttpServletRequest request, HttpServletResponse response) {
		String menuid=request.getParameter("menuid");
		String description=request.getParameter("description");
		Map<String,Object> map =kipVisitServie.updateKpiDisc(menuid,description);
		return map;
	}
	
}
