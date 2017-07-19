package bass.common;

import com.asiainfo.hbbass.component.dimension.BassDimCache;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.Logger;

@SuppressWarnings("unchecked")
public class QueryTools3 {
	private static Logger LOG = Logger.getLogger(QueryTools3.class);
	@SuppressWarnings("rawtypes")
	private static Map dataformatMap = new HashMap();

	static {
		dataformatMap.put("yyyyMMdd", new SimpleDateFormat("yyyyMMdd"));
		dataformatMap.put("yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd"));
	}

	public static String getStaticBetweenHTML(String tagname) {
		StringBuffer sb = new StringBuffer("<input type=\"text\" name=\"");
		sb.append(tagname).append("_from\"").append(" class='form_input_between'").append("> 到 <input type=\"text\" name=\"").append(tagname).append("_to\"").append(" class='form_input_between'").append(">");

		return sb.toString();
	}

	public static String getStaticRankHTML(String tagname) {
		StringBuffer sb = new StringBuffer("<select name=\"");
		sb.append(tagname).append("_mode\"").append(" >").append("<option value='desc'>前</option>").append("<option value='asc'>后</option>").append("</select> <input type=\"text\" name=\"").append(tagname).append("_num\"").append(" class='form_input_between'").append("> 名");

		return sb.toString();
	}

	public static String getStaticLikeHTML(String tagname) {
		StringBuffer sb = new StringBuffer("<input type=\"text\" name=\"");
		sb.append(tagname).append("\"").append(" class='form_input'").append(">");
		return sb.toString();
	}

	public static String getStaticHTMLSelect(String tagName, String defaultValue) {
		return getStaticHTMLSelect(tagName, defaultValue, "");
	}

	@SuppressWarnings("rawtypes")
	public static String getStaticHTMLSelect(String tagName, String defaultValue, String funcStr) {
		if ((defaultValue == null) || (defaultValue.length() == 0)) {
			defaultValue = "";
		}

		StringBuffer sb = new StringBuffer("<select name='");

		if ((funcStr.trim().equals("")) || (funcStr == null))
			sb.append(tagName).append("' class='form_select'>");
		else {
			sb.append(tagName).append("' class='form_select' onChange=\"").append(funcStr).append("\">");
		}
		if (BassDimCache.getInstance().isKeyInCache(tagName)) {
			Iterator iterator = BassDimCache.getInstance().get(tagName).entrySet().iterator();

			while (iterator.hasNext()) {
				Map.Entry entry = (Map.Entry) iterator.next();
				if (defaultValue.equalsIgnoreCase((String) entry.getValue())) {
					sb.append("<option value='").append(entry.getKey()).append("' selected>").append(entry.getValue()).append("</option>");
				} else {
					sb.append("<option value='").append(entry.getKey()).append("'>").append(entry.getValue()).append("</option>");
				}
			}
		}
		sb.append("</select>");

		return sb.toString();
	}

	public static String getComboHtml(String formName, String funcStr) {
		StringBuffer htmlcode = new StringBuffer(500);
		if ((funcStr.trim().equals("")) || (funcStr == null))
			htmlcode.append("<select name='").append(formName).append("' class='form_select'>");
		else {
			htmlcode.append("<select name='").append(formName).append("' class='form_select' onChange=\"").append(funcStr).append("\">");
		}
		htmlcode.append("<option value=''>全部</option>");
		htmlcode.append("</select>");
		return htmlcode.toString();
	}

	public static String getDynamicHTMLSelect(String tagName, String defaultValue, String sql) {
		StringBuffer sb = new StringBuffer("<select name='");

		if ((defaultValue == null) || (defaultValue.length() == 0)) {
			defaultValue = "''";
		}

		sb.append(tagName).append("' class='form_select'>");
		sb.append("</select>");
		sb.append("<script language=javascript>drawDynamicHtmlSelect('").append(sql).append("',document.forms[0].").append(tagName).append(",'").append(defaultValue).append("');</script>");

		return sb.toString();
	}

	public static String getDateYMDHtml(String formName) {
		return getDateYMDHtml(formName, 0, "yyyyMMdd");
	}

	public static String getDateYMDHtml(String formName, int day) {
		return getDateYMDHtml(formName, day, "yyyyMMdd");
	}

	public static String getDateYMDHtml(String formName, int day, String format) {
		return getDateYMDHtml(formName, day, format, true);
	}

	public static String getDateYMDHtml(String formName, int day, boolean isReadOnly) {
		return getDateYMDHtml(formName, day, "yyyyMMdd", isReadOnly);
	}

	public static String getDateYMDHtml(String formName, int day, String format, boolean isReadOnly) {
		Calendar cal = GregorianCalendar.getInstance();
		cal.add(5, -day);

		SimpleDateFormat sdf = (SimpleDateFormat) dataformatMap.get(format);

		if (sdf == null) {
			sdf = new SimpleDateFormat(format);
			dataformatMap.put(format, sdf);
		}

		String default_date = sdf.format(cal.getTime());

		StringBuffer htmlcode = new StringBuffer(500);
		htmlcode.append("<input type='text' id='").append(formName).append("' name='").append(formName).append("' class='form_input' value='").append(default_date).append("' ").append((isReadOnly) ? "readonly" : "").append("/>")
				.append("<script type='text/javascript' src='/hb-bass-navigation/hbapp/app/operationmonitor/om_daily/calendar.js'></SCRIPT>")
				.append("&nbsp;<a title =\"点击选择时间(test)\" href=\"javascript:show_calendar('forms[0]." + formName + "',null,null,'" + format + "');\"  onMouseOver=\"window.status='Date Picker';return true;\" onMouseOut=\"window.status='';return true;\"><img src=\"/hb-bass-navigation/hbapp/resources/image/default/message.gif\" border=0 class=\"l\"></a>");
		return htmlcode.toString();
	}

	public static String getDateYMD(String formName, int day, String format) {
		return getDateYMDHtml(formName, day, "yyyy-MM-dd", true);
	}

	public static String getProvinceHtml(String formName) {
		StringBuffer sb = new StringBuffer();
		sb.append("<select name='").append(formName).append("' class='form_select'>");
		sb.append("<option value='0'>全省</option>");
		sb.append("</select>");
		return sb.toString();
	}

	public static void main(String[] args) {
		LOG.debug(getDynamicHTMLSelect("a", "select * from dual", null));

		LOG.debug(getStaticHTMLSelect("onnetwork", ""));
	}
}