package com.asiainfo.bass.apps.controllers;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * 
 * @author LiZhijian
 * @date 2012-03-28
 */
@Controller
@RequestMapping(value = "/imei")
@SessionAttributes({ "mvcPath", "contextPath" })
public class ImeiManageController {
	private static Logger LOG = Logger.getLogger(ImeiManageController.class);

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath) {
		return "imei/index";
	}

	@RequestMapping(value = "/index", method = RequestMethod.POST)
	public String index(HttpSession session, HttpServletRequest request, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath, @RequestParam String imeiId, Model model) throws Exception {
		return "";
	}

	@RequestMapping(value = "/imeiManage", method = RequestMethod.GET)
	public String imeiManage(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath) {
		return "imei/imeiManage";
	}

	@RequestMapping(value = "/imeiManage", method = RequestMethod.POST)
	public String imeiManage(HttpSession session, HttpServletRequest request, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath, @RequestParam String imeiId, Model model) throws Exception {
		return "";
	}

	@RequestMapping(value = "/imeiAudit", method = RequestMethod.GET)
	public String imeiAudit(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath) {
		return "imei/imeiAudit";
	}

	@RequestMapping(value = "/imeiAudit", method = RequestMethod.POST)
	public String imeiAudit(HttpSession session, HttpServletRequest request, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("contextPath") String contextPath, @RequestParam String imeiId, Model model) throws Exception {
		return "";
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Object format(ResultSet rs) {
		List result = new ArrayList();
		try {
			ResultSetMetaData rsmd = rs.getMetaData();
			int size = rsmd.getColumnCount();
			while (rs.next()) {
				Map map = new HashMap();
				for (int i = 0; i < size; i++) {
					String colName = rsmd.getColumnName(i + 1);
					int type = rsmd.getColumnType(i + 1);
					if (Types.INTEGER == type || Types.SMALLINT == type) {
						map.put(colName.toLowerCase(), rs.getInt(colName));
					} else if (Types.BIGINT == type) {
						map.put(colName.toLowerCase(), rs.getLong(colName));
					} else if (Types.DECIMAL == type || Types.FLOAT == type || Types.DOUBLE == type) {
						map.put(colName.toLowerCase(), rs.getBigDecimal(colName));// 使用bigDecimal来取，可以取到null
					} else {
						map.put(colName.toLowerCase(), rs.getString(colName));
					}
				}
				result.add(map);
			}
		} catch (SQLException e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
	}

}
