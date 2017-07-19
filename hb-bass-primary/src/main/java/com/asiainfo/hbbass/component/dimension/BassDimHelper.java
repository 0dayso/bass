package com.asiainfo.hbbass.component.dimension;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-8
 */
@SuppressWarnings({ "rawtypes", "unused" })
public class BassDimHelper {

	public static String time(String name, String dateFormat) {
		return time(name, dateFormat, null, null);
	}

	public static String time(String name, String dateFormat, String defaultValue) {
		return time(name, dateFormat, defaultValue, null);
	}

	public static String[] calDefDate(String dateFormat) {
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
	public static String time(String name, String dateFormat, String defaultValue, String onChange) {
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

		sb.append("<input type=\"text\" style=\"width:78px;\" value=\"").append(defaultValue1).append("\" class=\"Wdate\" id=\"time_from\" onFocus=\"WdatePicker({dateFmt:'").append(dateFormat).append("',maxDate:'#F{$dp.$D(\\\\\'time\\\\\',{d:-1});}'})\"/>");
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
	 * 生成时间HTML代码,需要引用calendar.js
	 * 
	 * @param name
	 *            : input的Name
	 * @param defaultValue
	 *            : 默认的时间
	 * @param onChange
	 *            : input改变的时候JS回调函数
	 * @param dateFormat
	 *            : 时间的格式
	 * @return
	 * 
	 */
	public static String date(String name, String defaultValue, String onChange, String dateFormat) {

		if (defaultValue == null || defaultValue.length() == 0) {
			Calendar cal = GregorianCalendar.getInstance();
			cal.add(Calendar.DATE, -1);
			defaultValue = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		}

		StringBuffer sb = new StringBuffer();

		sb.append("<script type='text/javascript'>").append("var ").append("calendar_").append(name).append("=new Calendar('").append("calendar_").append(name).append("');");

		if (onChange != null && onChange.length() > 0)
			sb.append("calendar_").append(name).append(".callback=").append(onChange).append(";");

		if (dateFormat != null && dateFormat.length() > 0)
			sb.append("calendar_").append(name).append(".dateFormat='").append(dateFormat).append("';");

		sb.append("document.write(").append("calendar_").append(name).append(");").append("</script>").append("<table cellspacing='0' cellpadding='0' style='width: 120px;height: 22px;border:1px solid #999999;background-color:#FFFFFF;'><tr>").append("<td><input type='text' name='").append(name).append("' id='")
				.append(name).append("' value='").append(defaultValue).append("' onchange=\"if(").append("calendar_").append(name).append(".callback").append(")").append("calendar_").append(name).append(".callback").append("(this.value)").append("\" style='border:0 none;padding:1px 0 0 3px;width:76px'/>")
				.append("<td align='right' style='padding-right : 2 px;'><span class='calendarimage' onclick=\"").append("calendar_").append(name).append(".showMoreDay = true;").append("calendar_").append(name).append(".show($('").append(name).append("'),this,'").append(defaultValue)
				.append("')\" ></span></td></tr></table>");

		return sb.toString();
	}

	/**
	 * 
	 * @param name
	 * @param defaultValue
	 * @param onChange
	 * @return
	 *
	 */
	public static String date(String name, String defaultValue, String onChange) {
		return date(name, defaultValue, onChange, null);
	}

	/**
	 * 
	 * @param name
	 * @param defaultValue
	 * @return
	 * 
	 */
	public static String date(String name, String defaultValue) {
		return date(name, defaultValue, null, null);
	}

	/**
	 * 
	 * @param name
	 * @return
	 * 
	 */
	public static String date(String name) {
		return date(name, null, null, null);
	}

	/**
	 * 生成月周期用
	 * 
	 * @param name
	 *            : select标签的名称
	 * @param onChange
	 *            : onchange的js函数
	 * @param defaultValue
	 *            : 默认月份
	 * @param defaultMonth
	 *            : 默认的月份,默认值是-1,一般为前一个月
	 * @return
	 * 
	 */
	public static String monthHtml(String name, String onChange, String defaultValue, int defaultMonth) {
		return monthHtml(name, onChange, defaultValue, defaultMonth, 13);
	}

	/**
	 * 生成月周期用
	 * 
	 * @param name
	 *            : select标签的名称
	 * @param onChange
	 *            : onchange的js函数
	 * @param defaultValue
	 *            : 默认月份
	 * @param defaultMonth
	 *            : 默认的月份,默认值是-1,一般为前一个月
	 * @param monthCount
	 *            : 显示月份的数量
	 * @return
	 *
	 */
	public static String monthHtml(String name, String onChange, String defaultValue, int defaultMonth, int monthCount) {

		Calendar cal = GregorianCalendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");

		if (defaultMonth == -1) {
			cal.add(Calendar.DATE, -3);
		}

		cal.add(Calendar.MONTH, defaultMonth);
		String monthValue = sdf.format(cal.getTime());

		StringBuffer htmlcode = new StringBuffer();

		htmlcode.append("<select name='").append(name).append("'");

		if (onChange != null && onChange.length() > 0)
			htmlcode.append(" onchange=\"").append(onChange).append("\" ");

		htmlcode.append(" class='form_select'>");
		htmlcode.append("<option value='").append(monthValue).append("'>").append(monthValue).append("</option>");

		if (monthCount < 6)
			monthCount = 13;

		for (int i = 1; i < monthCount; i++) {
			cal.add(Calendar.MONTH, -1);
			monthValue = sdf.format(cal.getTime());

			htmlcode.append("<option value=\"").append(monthValue).append("\"");

			if (monthValue.equalsIgnoreCase(defaultValue))
				htmlcode.append(" selected='selected'");

			htmlcode.append(">").append(monthValue).append("</option>");
		}
		htmlcode.append("</select>");
		return htmlcode.toString();
	}

	/**
	 * 生成月周期用
	 * 
	 * @param name
	 *            : select标签的名称
	 * @param onChange
	 *            : onchange的js函数
	 * @param defaultValue
	 *            : 默认月份
	 * @return
	 *
	 */
	public static String monthHtml(String name, String onChange, String defaultValue) {
		return monthHtml(name, onChange, defaultValue, -1);
	}

	/**
	 * 生成月周期用
	 * 
	 * @param name
	 *            : select标签的名称
	 * @param onChange
	 *            : onchange的js函数
	 * @return
	 * 
	 */
	public static String monthHtml(String name, String onChange) {
		return monthHtml(name, onChange, null, -1);
	}

	/**
	 * 生成月周期用
	 * 
	 * @param name
	 *            : select标签的名称
	 * @return
	 *
	 */
	public static String monthHtml(String name) {
		return monthHtml(name, null, null, -1);
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
	public static String areaCodeHtml(String name, String defaultValue, String onChange, boolean isAllArea) {

		StringBuffer htmlcode = new StringBuffer();

		htmlcode.append("<select name=\"").append(name).append("\" class='form_select'");

		if (onChange != null && onChange.length() > 0)
			htmlcode.append(" onchange=\"").append(onChange).append("\"");

		htmlcode.append(">");

		Map areaIdMap = BassDimCache.getInstance().get("area_id");
		Map areaCodeMap = BassDimCache.getInstance().get("area_code");

		if (areaIdMap == null || areaCodeMap == null) {// 如果为空就重新加载一下缓存，不知道为什么缓存老是有问题
			BassDimCache.getInstance().initialize();

			areaIdMap = BassDimCache.getInstance().get("area_id");
			areaCodeMap = BassDimCache.getInstance().get("area_code");
		}

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
	public static String areaCodeHtml(String name, String defaultValue, String onChange) {
		return areaCodeHtml(name, defaultValue, onChange, false);
	}

	/**
	 * 
	 * @param name
	 * @param onChange
	 * @return
	 */
	public static String comboSeleclHtml(String name, String onChange) {

		StringBuffer sb = new StringBuffer("<select name=\"");

		sb.append(name).append("\" class='form_select'");
		if (onChange != null && onChange.length() > 0)
			sb.append(" onchange=\"").append(onChange).append("\"");
		sb.append(">");
		sb.append("<option value=''>全部</option>");
		sb.append("</select>");

		// sb.append("<script type='text/javascript' defer='defer'>").append(onChange).append("</script>");
		return sb.toString();
	}

	public static String comboSeleclHtml(String name) {

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
	public static String selectHtml(String name, String defaultValue, String onChange) {

		StringBuffer sb = new StringBuffer("<select name=\"");

		sb.append(name).append("\" class='form_select'");
		if (onChange != null && onChange.length() > 0)
			sb.append(" onchange=\"").append(onChange).append("\"");

		sb.append(" >").append(optionsHtml(name, defaultValue)).append("</select>");

		return sb.toString();
	}

	public static String selectHtml(String name) {

		return selectHtml(name, null, null);
	}

	public static String renderSelect(String name, List options) {
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
	public static String tagInput() {
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
	protected static StringBuffer optionsHtml(String key, String defaultValue) {

		Map map = BassDimCache.getInstance().get(key);

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
