package bass.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase;
import java.sql.Connection;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class NgbassTools {
	private static SimpleDateFormat yyyyMM = new SimpleDateFormat("yyyyMM");
	private static SimpleDateFormat yyyyMM2 = new SimpleDateFormat("yyyy-MM");
	private static SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");
	private static SimpleDateFormat yyyyMMdd2 = new SimpleDateFormat("yyyy-MM-dd");


	public static HashMap ngmap = new HashMap();
	// public static Sqlca sqlca = null;

	private static final Logger LOG = Logger.getLogger(NgbassTools.class);

	static {
		init();
	}


	public static void init() {
		Connection conn = null;
		List list = null;
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			SQLQueryBase queryBase = new SQLQueryBase();
			queryBase.setConnection(conn);
			String sql = "select  TAGNAME||'@'||KEY id, VALUE value from DIM_TOTAL  order by NAME,KEY with ur";
			list = (List) queryBase.query(sql);
			for (int i = 0; i < list.size(); i++) {
				HashMap tempMap = (HashMap) list.get(i);
				ngmap.put(tempMap.get("id"), tempMap.get("value"));
			}
			// while (sqlca.next())
			// {
			// ngmap.put(sqlca.getString("id"), sqlca.getString("value"));
			// }

			LOG.info("维度权限加载完成");

		} catch (Exception excep) {
			excep.printStackTrace(); 
			LOG.debug(excep.getMessage());
		} finally {
		}
	}

	public static String getDimName(String name, String dimvalue) {
		String newKey = name + "@" + dimvalue;
		if (!(ngmap.containsKey(newKey)))
			return dimvalue;
		return ((String) ngmap.get(newKey.trim()));
	}

	@SuppressWarnings("unused")
	public String getQueryDate(String formName, String dataFormat) {
		Calendar cal2 = GregorianCalendar.getInstance();
		cal2.add(2, -1);
		String default_date1 = yyyyMM.format(cal2.getTime());
		String default_date2 = yyyyMM2.format(cal2.getTime());

		Calendar cal1 = GregorianCalendar.getInstance();
		cal1.add(5, -1);
		String default_date3 = yyyyMMdd.format(cal1.getTime());
		String default_date4 = yyyyMMdd2.format(cal1.getTime());

		StringBuffer htmlcode = new StringBuffer(1200);
		if (dataFormat.equalsIgnoreCase("YYYYMM")) {
			htmlcode.append(" <div style=\"position:relative;\">").append(" <span style=\"margin-left:60px;width:18px;overflow:hidden;\">").append("<select id=\"queryHidForm\" style=\"width:78px;margin-left:-60px\" onchange=\"this.parentNode.nextSibling.value=this.value;\">");
			for (int i = 0; i < 12; ++i) {
				htmlcode.append("<option value='").append(yyyyMM.format(cal2.getTime())).append("'>").append(yyyyMM.format(cal2.getTime())).append("</option>");
				cal2.add(2, -1);
			}
			htmlcode.append("</select></span>").append("<input name=" + formName + " id=" + formName + " style=\"width:60px;position:absolute;left:0px;\" value=" + default_date1 + "></div>");
		} else if (dataFormat.equalsIgnoreCase("YYYYMMDD")) {
			htmlcode.append("").append("<input type=\"text\" name=\"" + formName + "\" size=8 maxlength=8 value='" + default_date3 + "'>").append("<a  onClick=event.cancelBubble=true; href=\"javascript:showCalendar2('imageCalendar2',false,'" + formName + "',null);\">")
					.append("<img id=imageCalendar2 height=\"25\" width=25 src=\"/hbapp/resources/old/image/icon_date.gif\"   align=absMiddle border=0></a> ");
		} else if (dataFormat.equalsIgnoreCase("YYYY-MM-DD")) {
			htmlcode.append("").append("<input type=\"text\" name=\"" + formName + "\" size=10 maxlength=10 value='" + default_date4 + "'>").append("<a  onClick=event.cancelBubble=true; href=\"javascript:showCalendar('imageCalendar',false,'" + formName + "',null);\">")
					.append("<img id=imageCalendar height=\"25\" width=25 src=\"/hbapp/resources/old/image/icon_date.gif\"  width=25 align=absMiddle border=0></a> ");
		}
		return htmlcode.toString();
	}

	public static void main(String[] args) {
		NgbassTools nt = new NgbassTools();
		nt.getQueryDate("querydate", "YYYYMM");
	}
}