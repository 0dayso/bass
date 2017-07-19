package com.asiainfo.bass.components.models;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-8
 */
@Component
public class BassDimHelper {

	private static Logger LOG = Logger.getLogger(BassDimHelper.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Autowired
	public BassDimHelper(DataSource dataSourceDw) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		areaIdMap = excuteList(jdbcTemplate.queryForList("select * from (values ('0','0') union all select trim(char(area_id)),area_code from mk.bt_area) as t(key,value) order by 1 "));
		areaCodeMap = excuteList(jdbcTemplate.queryForList("select * from (values ('0','全省') union all select area_code,area_name from mk.bt_area) as t(key,value) order by 1 "));

		try {
			List list = jdbcTemplate.queryForList("select tagname,key,value from dim_total order by tagname,key with ur");
			dimTotal = new HashMap();
			for (int i = 0; i < list.size(); i++) {

				Map dimElem = null;

				Map map = (Map) list.get(i);

				String tagname = (String) map.get("tagname");

				if (!dimTotal.containsKey(tagname)) {
					dimElem = new TreeMap();
					dimTotal.put(tagname, dimElem);
					dimElem.put("", "全部");
				}
				dimElem = (Map) dimTotal.get(tagname);
				dimElem.put(map.get("key"), map.get("value"));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Map excuteList(List list) {
		Map map = new TreeMap();
		for (int i = 0; i < list.size(); i++) {

			Map data = (Map) list.get(i);

			map.put(data.get("key"), data.get("value"));
		}
		return map;
	}

	@SuppressWarnings("rawtypes")
	public Map areaIdMap, areaCodeMap, dimTotal;

	public String time(String name, String dateFormat) {
		return time(name, dateFormat, null, null);
	}

	public String time(String name, String dateFormat, String defaultValue) {
		return time(name, dateFormat, defaultValue, null);
	}

	public String[] calDefDate(String dateFormat) {
		String[] defaultTime = new String[2];

		Calendar cal = GregorianCalendar.getInstance();
		if (dateFormat.replaceAll("-", "").replaceAll("/", "").length() == 6) {
			cal.add(Calendar.DATE, -3);
			cal.add(Calendar.MONTH, -1);
		} else {
			cal.add(Calendar.DATE, -1);
		}
		defaultTime[0] = new SimpleDateFormat(dateFormat).format(cal.getTime());

		if (dateFormat.replaceAll("-", "").replaceAll("/", "").length() == 6) {
			cal.add(Calendar.MONTH, -3);
		} else {
			cal.add(Calendar.DATE, -6);
		}
		defaultTime[1] = new SimpleDateFormat(dateFormat).format(cal.getTime());

		return defaultTime;
	}

	/**
	 * 
	 * @param name
	 *            : input的Name
	 * @param dateFormat
	 *            : 日，月
	 * @param defaultValue
	 * @param onChange
	 * @return
	 */
	public String time(String name, String dateFormat, String defaultValue, String onChange) {
		String defaultValue1 = "";
		if (defaultValue == null || defaultValue.length() == 0) {
			String[] defaultTime = calDefDate(dateFormat);
			defaultValue = defaultTime[0];
			defaultValue1 = defaultTime[1];
		} else {
			Calendar cal1 = Calendar.getInstance();
			if (dateFormat.replaceAll("-", "").replaceAll("/", "").length() == 6) {
				cal1.set(Integer.parseInt(defaultValue.substring(0, 4)), Integer.parseInt(defaultValue.substring(4, 6)) - 1, 1, 0, 0, 0);
				cal1.add(Calendar.MONTH, -3);

			} else {
				cal1.set(Integer.parseInt(defaultValue.substring(0, 4)), Integer.parseInt(defaultValue.substring(4, 6)) - 1, Integer.parseInt(defaultValue.substring(6, 8)), 0, 0, 0);
				cal1.add(Calendar.DATE, -6);
			}
			defaultValue1 = new SimpleDateFormat(dateFormat).format(cal1.getTime());
		}

		StringBuilder sb = new StringBuilder();

		sb.append("<span id=\"time_during\" style=\"display: none;\">");

		sb.append("<input type=\"text\" style=\"width:78px;\" value=\"").append(defaultValue1).append("\" class=\"Wdate\" id=\"time_from\" onFocus=\"WdatePicker({dateFmt:'").append(dateFormat)
		// .append("',maxDate:'#F{$dp.$D(\\\\\'time\\\\\',{d:-1});}'})\"/>");
				.append("',maxDate:'#F{$dp.$D(\\\'time\\\',{d:-1});}'})\"/>");
		sb.append(" 到 ");
		/*
		 * sb.append("到 <input type=\"text\" style=\"width:78px;\" value=\"")
		 * .append(defaultValue) .append(
		 * "\" class=\"Wdate\" id=\"time_to\" onFocus=\"WdatePicker({dateFmt:'")
		 * .append(dateFormat)
		 * .append("',minDate:'#F{$dp.$D(\\\\\'time_from\\\\\',{d:1});}'})\"/>"
		 * );
		 */

		sb.append("</span>");

		// sb.append("<span id=\"time_point\">");

		sb.append("<input type=\"text\" style=\"width:160px;\" value=\"").append(defaultValue).append("\" class=\"Wdate\" id=\"").append(name).append("\" name=\"").append(name).append("\" onfocus=\"WdatePicker({dateFmt:'").append(dateFormat).append("'");

		if (onChange != null && onChange.length() > 0) {
			sb.append(",changed:'").append(onChange).append("'");
		}
		sb.append("})\"/>");

		// sb.append("</span>");

		return sb.toString();
	}

	/**
	 * 
	 * @param name
	 * @param defaultValue
	 * @param onChange
	 * @param isAllArea
	 *            : 当默认是地市时,是否可以越级查看其他地市
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public String areaCodeHtml(String name, String defaultValue, String onChange, boolean isAllArea) {

		StringBuffer htmlcode = new StringBuffer();

		htmlcode.append("<select name=\"").append(name).append("\" class='form_select'").append(" id=\"").append(name).append("\"");

		if (onChange != null && onChange.length() > 0)
			htmlcode.append(" onchange=\"").append(onChange).append("\"");

		htmlcode.append(">");

		if (areaIdMap != null && areaCodeMap != null) {

			if (!"0".equalsIgnoreCase(defaultValue) && !defaultValue.startsWith("HB."))
				defaultValue = (String) areaIdMap.get(defaultValue);

			if (!"0".equalsIgnoreCase(defaultValue) && !isAllArea) {
				htmlcode.append("<option value=\"").append(defaultValue).append("\">").append(areaCodeMap.get(defaultValue)).append("</option>");
			} else {
				for (Iterator iterator = areaIdMap.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry entry = (Map.Entry) iterator.next();

					if (entry.getValue() == null || ((String) entry.getValue()).length() == 0 || ((String) areaCodeMap.get(entry.getValue())) == null)
						continue;

					htmlcode.append("<option value=\"").append(entry.getValue()).append("\"");

					if (defaultValue.equalsIgnoreCase((String) entry.getValue()))
						htmlcode.append(" selected='selected'");

					htmlcode.append(">").append(areaCodeMap.get(entry.getValue())).append("</option>");

				}
			}
		}

		htmlcode.append("</select>");

		// htmlcode.append("<script type='text/javascript' defer='defer'>").append(onChange).append("</script>");
		if (!"0".equalsIgnoreCase(defaultValue) && !isAllArea)
			htmlcode.append("<script type='text/javascript'>aihb.Util.addEventListener(window,'load',function(){areacombo(1);});</script>");
		return htmlcode.toString();
	}

	/**
	 * 
	 * @param name
	 * @param defaultValue
	 * @return
	 */
	public String areaCodeHtml(String name, String defaultValue, String onChange) {
		return areaCodeHtml(name, defaultValue, onChange, false);
	}

	/**
	 * 
	 * @param name
	 * @param onChange
	 * @return
	 */
	public String comboSeleclHtml(String name, String onChange) {

		StringBuffer sb = new StringBuffer("<select name=\"");

		sb.append(name).append("\" class='form_select'").append(" id=\"").append(name).append("\"");
		if (onChange != null && onChange.length() > 0)
			sb.append(" onchange=\"").append(onChange).append("\"");
		sb.append(">");
		sb.append("<option value=''>全部</option>");
		sb.append("</select>");

		// sb.append("<script type='text/javascript' defer='defer'>").append(onChange).append("</script>");
		return sb.toString();
	}

	public String comboSeleclHtml(String name) {

		return comboSeleclHtml(name, null);
	}

	/**
	 * 生成普通的select
	 * 
	 * @param name
	 *            : 需要与BassDimCache中的key值一致
	 * @param defaultValue
	 * @param onChange
	 * @return
	 */
	public String selectHtml(String name, String defaultValue, String onChange) {

		StringBuffer sb = new StringBuffer("<select name=\"");

		sb.append(name).append("\" class='form_select'");
		if (onChange != null && onChange.length() > 0)
			sb.append(" onchange=\"").append(onChange).append("\"");

		sb.append(" >").append(optionsHtml(name, defaultValue)).append("</select>");

		return sb.toString();
	}

	public String selectHtml(String name) {

		return selectHtml(name, null, null);
	}

	@SuppressWarnings("rawtypes")
	public String renderSelect(String name, List options) {
		StringBuffer sb = new StringBuffer("<select name='");
		sb.append(name).append("' class='form_select'");
		sb.append(" >");
		sb.append("<option value='' >").append("全部").append("</option>");
		for (int i = 0; i < options.size(); i++) {
			Map map = (Map) options.get(i);
			sb.append("<option value=\"").append(map.get("key")).append("\"").append(map.get("selected") != null && (((Boolean) map.get("selected")).booleanValue() == true) ? " selected=\"selected\"" : "").append(" >").append(map.get("value")).append("</option>");
		}

		sb.append("</select>");
		return sb.toString();
	}

	/**
	 * 生成普通的Input
	 * 
	 * @return
	 */
	public String tagInput() {
		return null;
	}

	/**
	 * 
	 * @param key
	 *            : 缓存中key
	 * @param defaultValue
	 *            : 默认值
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	protected StringBuffer optionsHtml(String key, String defaultValue) {

		Map map = (Map) dimTotal.get(key);

		StringBuffer sb = new StringBuffer();
		if (map != null && map.size() > 0) {
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				sb.append("<option value=\"").append(entry.getKey()).append("\"");

				if (defaultValue != null && defaultValue.equalsIgnoreCase((String) entry.getKey()))
					sb.append(" selected='selected'");

				sb.append(">").append(entry.getValue()).append("</option>");
			}
		}

		return sb;
	}

	public static void main(String[] args) {
		// System.out.println(selectHtml("brands"));

		/*
		 * String jsonStr = "{\"key\" : \"true\", \"key2\" : true}"; Object o =
		 * JsonHelper.getInstance().read(jsonStr); if(o instanceof Map) { Map m
		 * = (Map)o; System.out.println(m.get("key") instanceof String);
		 * System.out.println(m.get("key2") instanceof Boolean); }
		 * 
		 * String jsonStr = "{\"key\" : \"true\", \"key2\" : true}"; Object o =
		 * JsonHelper.getInstance().read(jsonStr); if(o instanceof Map) { Map m
		 * = (Map)o; System.out.println((Boolean)m.get("key3") == true); }
		 */

		/*
		 * Map map = new HashMap(); map.put("key1", true);
		 * System.out.println("1. " + map.get("key2")); System.out.println("2. "
		 * + ((Boolean)map.get("key2"))); System.out.println("3. " +
		 * ((Boolean)map.get("key2") == true)); i = i +1; int iii = 1; List l =
		 * null; l.add(iii);
		 */
	}
}
