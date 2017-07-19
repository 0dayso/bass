package bass.common;

import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

@SuppressWarnings({ "unchecked", "unused" })
public class QueryTools2
{
  private static SimpleDateFormat SDF_MONTH = new SimpleDateFormat("yyyyMM");

  private static SimpleDateFormat SDF_DAY = new SimpleDateFormat("yyyyMMdd");

  @SuppressWarnings("rawtypes")
private static TreeMap areaCodePool = new TreeMap();

  @SuppressWarnings("rawtypes")
private static TreeMap areaIdCodePool = new TreeMap();

  @SuppressWarnings("rawtypes")
private static TreeMap areaIdPool = new TreeMap();

  @SuppressWarnings("rawtypes")
private static TreeMap areaReportSort = new TreeMap();

@SuppressWarnings({ "rawtypes" })
private static TreeMap brandPool = new TreeMap();

  private static String[] brand = { "全球通", "神州行", "动感地带" };
  private static String[] sex = { "男", "女" };
  private static String[] paperType = { "新闻时事类", "财经类", "体育类", "文娱类", "生活类", "文学类", "品牌专刊" };
  private static String[] netAge = { "3天内", "3-5天", "5-10天", "10-20天", "20-30天", "1-2个月", "2-3个月", "3-4个月", "4-6个月", "6-12个月", "12-18个月", "18-24个月", "24月以上", "未知" };
  private static String[] ageLevel = { "年龄不详", "20岁以下", "20-30岁", "30-45岁", "45-60岁", "60岁以上" };
  private static String[] consumeLevel = { "0元以下", "0-50元", "50-100元", "100-200元", "200-300元", "300-500元", "500元以上" };

  static
  {
    areaCodePool.put("0", "全省");
    areaCodePool.put("HB.WH", "武汉");
    areaCodePool.put("HB.HS", "黄石");
    areaCodePool.put("HB.EZ", "鄂州");
    areaCodePool.put("HB.YC", "宜昌");
    areaCodePool.put("HB.ES", "恩施");
    areaCodePool.put("HB.SY", "十堰");
    areaCodePool.put("HB.XF", "襄樊");
    areaCodePool.put("HB.JH", "江汉");
    areaCodePool.put("HB.XN", "咸宁");
    areaCodePool.put("HB.JZ", "荆州");
    areaCodePool.put("HB.JM", "荆门");
    areaCodePool.put("HB.SZ", "随州");
    areaCodePool.put("HB.HG", "黄冈");
    areaCodePool.put("HB.XG", "孝感");
    areaCodePool.put("HB.TM", "天门");

    areaIdCodePool.put("0", "0");
    areaIdCodePool.put("1", "HB.TM");
    areaIdCodePool.put("11", "HB.WH");
    areaIdCodePool.put("12", "HB.HS");
    areaIdCodePool.put("13", "HB.EZ");
    areaIdCodePool.put("14", "HB.YC");
    areaIdCodePool.put("15", "HB.ES");
    areaIdCodePool.put("16", "HB.SY");
    areaIdCodePool.put("17", "HB.XF");
    areaIdCodePool.put("18", "HB.JH");
    areaIdCodePool.put("19", "HB.XN");
    areaIdCodePool.put("20", "HB.JZ");
    areaIdCodePool.put("23", "HB.JM");
    areaIdCodePool.put("24", "HB.SZ");
    areaIdCodePool.put("25", "HB.HG");
    areaIdCodePool.put("26", "HB.XG");
    

    areaReportSort.put("0", "0");
    areaReportSort.put("10", "HB.WH");
    areaReportSort.put("20", "HB.JZ");
    areaReportSort.put("30", "HB.XF");
    areaReportSort.put("40", "HB.YC");
    areaReportSort.put("50", "HB.HG");
    areaReportSort.put("60", "HB.XG");
    areaReportSort.put("70", "HB.HS");
    areaReportSort.put("80", "HB.SY");
    areaReportSort.put("90", "HB.XN");
    areaReportSort.put("91", "HB.JM");
    areaReportSort.put("92", "HB.EZ");
    areaReportSort.put("93", "HB.ES");
    areaReportSort.put("94", "HB.JH");
    areaReportSort.put("95", "HB.SZ");

    areaIdPool.put("0", "全省");
    areaIdPool.put("1", "天门");
    areaIdPool.put("11", "武汉");
    areaIdPool.put("12", "黄石");
    areaIdPool.put("13", "鄂州");
    areaIdPool.put("14", "宜昌");
    areaIdPool.put("15", "恩施");
    areaIdPool.put("16", "十堰");
    areaIdPool.put("17", "襄樊");
    areaIdPool.put("18", "江汉");
    areaIdPool.put("19", "咸宁");
    areaIdPool.put("20", "荆州");
    areaIdPool.put("23", "荆门");
    areaIdPool.put("24", "随州");
    areaIdPool.put("25", "黄冈");
    areaIdPool.put("26", "孝感");
  }

  public static String getDateYMHtml(String formName, int length)
  {
    return getDateYMHtml(formName, length, null, null);
  }

  public static String getDateYMHtml(String formName, int length, String func, String defaultName)
  {
    StringBuffer htmlcode = new StringBuffer(500);

    Calendar cal = GregorianCalendar.getInstance();
    String tmpTime = "";
    htmlcode.append("<select name='").append(formName).append("'");

    if ((func != null) && (func.length() > 0)) htmlcode.append(" onchange='").append(func).append("' ");
    htmlcode.append(" class='form_select'>");

    for (int i = 0; i < length; ++i)
    {
      cal.add(2, -1);
      tmpTime = SDF_MONTH.format(cal.getTime());
      htmlcode.append("<option value='").append(tmpTime).append("'");
      if ((defaultName != null) && (defaultName.length() > 0) && (tmpTime.equalsIgnoreCase(defaultName)))
        htmlcode.append(" selected='selected' ");
      htmlcode.append(">").append(tmpTime).append("</option>");
    }
    htmlcode.append("</select>");
    return htmlcode.toString();
  }

  public static String getDateYMDHtml(String formName, int day)
  {
    Calendar cal = GregorianCalendar.getInstance();
    cal.add(5, -day);

    String default_date = SDF_DAY.format(cal.getTime());

    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<script type=\"text/javascript\" src=\"/hb-bass-navigation/hbbass/js/calendarBass2.js\"></script>")
      .append("<script type=\"text/javascript\" src=\"/hb-bass-navigation/hbbass/js/calendarBass2-setup.js\"></script>")
      .append("<script type=\"text/javascript\" src=\"/hb-bass-navigation/hbbass/js/calendarBass2-zh.js\"></script>")
      .append("<style type=\"text/css\"> @import url(\"/hb-bass-navigation/hbbass/css/calendarBass2.css\"); </style>")
      .append("<input type=\"text\" id=\"")
      .append(formName)
      .append("\" name=\"")
      .append(formName)
      .append("\" size=\"8\" maxlength=\"8\" value=\"")
      .append(default_date)
      .append("\" readonly/>")
      .append("<img id=cal-button-1 height=\"18\" src=\"/hb-bass-navigation/hbbass/images/calendarBass2.gif\"  width=\"34\" align=absMiddle border=\"0\">")
      .append("<script type=\"text/javascript\">Calendar.setup({inputField:\"")
      .append(formName).append("\",button:\"cal-button-1\",align: \"Tr\"});</script>");
    return htmlcode.toString();
  }

  @SuppressWarnings("rawtypes")
public static String getAreaIdHtml(String formName, String userArea, String funcStr)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    Iterator pt = areaIdPool.entrySet().iterator();

    if ((funcStr.trim().equals("")) || (funcStr == null))
      htmlcode.append("<select name='").append(formName).append(
        "' class='form_select'>");
    else
      htmlcode.append("<select name='").append(formName).append(
        "' class='form_select' onChange=\"").append(funcStr).append(
        "\">");
    while (pt.hasNext())
    {
      Map.Entry entry = (Map.Entry)pt.next();
      if (userArea.equals("0"))
      {
        htmlcode.append("<option value='").append(entry.getKey())
          .append("'>").append(entry.getValue()).append(
          "</option>");
      }
      else {
        if (!(userArea.equals(entry.getKey()))) continue;
        htmlcode.append("<option value='").append(entry.getKey())
          .append("'>").append(entry.getValue()).append(
          "</option>");
      }
    }
    htmlcode.append("</select>");
    return htmlcode.toString();
  }

  public static String getAreaCodeHtml(String formName, String defaultValue, String funcStr)
  {
    return getAreaCodeHtml(formName, defaultValue, true, funcStr);
  }

  public static String getAreaCodeHtml(String formName, String defaultValue, String funcStr, String type) {
    return getAreaCodeHtml(formName, defaultValue, true, funcStr, type);
  }

  public static String getAreaCodeHtml(String formName, String defaultValue, boolean disabled, String funcStr) {
    return getAreaCodeHtml(formName, defaultValue, disabled, funcStr, null);
  }

  @SuppressWarnings("rawtypes")
public static String getAreaCodeHtml(String formName, String defaultValue, boolean disabled, String funcStr, String type)
  {
    StringBuffer htmlcode = new StringBuffer(512);

    htmlcode.append("<select name='").append(formName).append("' class='form_select'");

    if ((funcStr != null) && (funcStr.trim().length() > 0)) {
      htmlcode.append(" onChange=\"").append(funcStr).append("\"");
    }
    htmlcode.append(">");

    if (!(defaultValue.startsWith("HB."))) defaultValue = getAreaCode(defaultValue);
    Map map = areaIdCodePool;
    if ("report".equalsIgnoreCase(type)) map = areaReportSort;
    if (disabled)
    {
      if ("0".equalsIgnoreCase(defaultValue))
      {
        mapAreaSortOption(htmlcode, map, null);
      }
      else {
        htmlcode.append("<option value='").append(defaultValue).append("'>").append(areaCodePool.get(defaultValue)).append("</option>");
      }
    }
    else {
      mapAreaSortOption(htmlcode, map, defaultValue);
    }

    htmlcode.append("</select>");

    htmlcode.append("<script type=\"text/javascript\" defer='defer'>").append(funcStr).append("</script>");

    return htmlcode.toString();
  }

  public static String getCountyHtml(String formName, String funcStr)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    if ((funcStr.trim().equals("")) || (funcStr == null))
      htmlcode.append("<select name='").append(formName).append("' class='form_select'>");
    else {
      htmlcode.append("<select name='").append(formName).append("' class='form_select' onChange=\"").append(funcStr).append("\">");
    }
    htmlcode.append("<option value=''>全部</option>");
    htmlcode.append("</select>");
    htmlcode.append("<script type=\"text/javascript\">").append("areacombo(1);").append("</script>");
    return htmlcode.toString();
  }

  public static String getAreaCode(String areaid)
  {
    if (!(areaIdCodePool.containsKey(areaid.trim())))
      return "未知";
    return ((String)areaIdCodePool.get(areaid.trim()));
  }

  public static String getAreaCodeName(String areaCode)
  {
    if (!(areaCodePool.containsKey(areaCode.trim())))
      return "未知";
    return ((String)areaCodePool.get(areaCode.trim()));
  }

  @SuppressWarnings("rawtypes")
protected static void mapAreaSortOption(StringBuffer sb, Map map, String defaultValue)
  {
    Iterator iterator = map.entrySet().iterator();
    Map.Entry entry;
    if ((defaultValue != null) && (defaultValue.length() > 0))
    {
      while (iterator.hasNext())
      {
        entry = (Map.Entry)iterator.next();
        if (defaultValue.equalsIgnoreCase((String)entry.getValue()))
          sb.append("<option value='").append(entry.getValue()).append("' selected='selected'>").append(areaCodePool.get(entry.getValue())).append("</option>");
        else {
          sb.append("<option value='").append(entry.getValue()).append("'>").append(areaCodePool.get(entry.getValue())).append("</option>");
        }
      }
    }
    else
      do
      {
        entry = (Map.Entry)iterator.next();
        sb.append("<option value='").append(entry.getValue()).append("'>").append(areaCodePool.get(entry.getValue())).append("</option>");
      }
      while (iterator.hasNext());
  }

  @SuppressWarnings("rawtypes")
protected static void mapToTagOption(StringBuffer sb, Map map)
  {
    mapToTagOption(sb, map, null);
  }

  @SuppressWarnings("rawtypes")
protected static void mapToTagOption(StringBuffer sb, Map map, String defaultValue)
  {
    Iterator iterator = map.entrySet().iterator();
    Map.Entry entry;
    if ((defaultValue != null) && (defaultValue.length() > 0))
    {
      while (iterator.hasNext())
      {
        entry = (Map.Entry)iterator.next();
        if (defaultValue.equalsIgnoreCase((String)entry.getKey()))
          sb.append("<option value='").append(entry.getKey()).append("' selected='selected'>").append(entry.getValue()).append("</option>");
        else {
          sb.append("<option value='").append(entry.getKey()).append("'>").append(entry.getValue()).append("</option>");
        }
      }
    }
    else
      do
      {
        entry = (Map.Entry)iterator.next();
        sb.append("<option value='").append(entry.getKey()).append("'>").append(entry.getValue()).append("</option>");
      }
      while (iterator.hasNext());
  }

  public static void getString(StringBuffer sb, String[] name)
  {
    sb.append("<option value='").append("").append("'>").append("请选择").append("</option>");
    for (int i = 0; i < name.length; ++i)
    {
      sb.append("<option value='").append(name[i]).append("'>").append(name[i]).append("</option>");
    }
    sb.append("</select>");
  }

  public static void getStringStat(StringBuffer sb, String[] name)
  {
    sb.append("<option value='").append("").append("'>").append("请选择").append("</option>");
    for (int i = 0; i < name.length; ++i)
    {
      sb.append("<option value='").append(name[i]).append("'>").append(name[i]).append("</option>");
    }
    sb.append("<option value='").append("全部").append("'>").append("全部").append("</option>");
    sb.append("</select>");
  }

  @SuppressWarnings("rawtypes")
public static String getAreaText(String formName, String userArea, String funcStr)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    Iterator pt = areaIdPool.entrySet().iterator();

    if ((funcStr.trim().equals("")) || (funcStr == null))
      htmlcode.append("<select name='").append(formName).append("' style='width:90 class='select_long'>");
    else {
      htmlcode.append("<select name='").append(formName).append("' style='width:90 class='select_long' onChange=\"").append(funcStr).append("\">");
    }
    while (pt.hasNext())
    {
      Map.Entry entry = (Map.Entry)pt.next();
      if (userArea.equals("0"))
      {
        htmlcode.append("<option value='").append(entry.getValue())
          .append("'>").append(entry.getValue()).append(
          "</option>");
      }
      else {
        if (!(userArea.equals(entry.getKey()))) continue;
        htmlcode.append("<option value='").append(entry.getValue())
          .append("'>").append(entry.getValue()).append(
          "</option>");
      }
    }
    htmlcode.append("</select>");
    return htmlcode.toString();
  }

  public static String getBrandText(String formName)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<select name='").append(formName).append("' class='select'>");
    getString(htmlcode, brand);
    return htmlcode.toString();
  }

  public static String getSexText(String formName)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<select name='").append(formName).append("' class='select'>");
    getString(htmlcode, sex);
    return htmlcode.toString();
  }

  public static String getPaperTypeText(String formName, String funcStr)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    if ((funcStr.trim().equals("")) || (funcStr == null))
      htmlcode.append("<select name='").append(formName).append("' class='select_long'>");
    else {
      htmlcode.append("<select name='").append(formName).append("' class='select_long' onChange=\"").append(funcStr).append("\">");
    }
    getStringStat(htmlcode, paperType);
    return htmlcode.toString();
  }

  public static String getNetAgeText(String formName)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<select name='").append(formName).append("' class='select'>");
    getStringStat(htmlcode, netAge);
    return htmlcode.toString();
  }

  public static String getAgeLevelText(String formName)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<select name='").append(formName).append("' class='select'>");
    getString(htmlcode, ageLevel);
    return htmlcode.toString();
  }

  public static String getConsumeLevelText(String formName)
  {
    StringBuffer htmlcode = new StringBuffer(500);
    htmlcode.append("<select name='").append(formName).append("' class='select'>");
    getString(htmlcode, consumeLevel);
    return htmlcode.toString();
  }

  public static void main(String[] args)
  {
    System.out.println(getAreaCodeHtml("city", "0", "areacombo(1)"));
    System.out.println(!("true".equalsIgnoreCase("true")));
  }
}