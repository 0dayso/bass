package com.asiainfo.hbbass.component.chart;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class FusionChartHelper {
	public static Map COLOR_STYLE = new HashMap();

	public static java.text.DecimalFormat decimalFormat = new java.text.DecimalFormat("0.####");

	public static final String NUMBER_REGEX = "(\\-|\\+)?[0-9]+\\.?[0-9]+";

	static {
		List COLOR = new ArrayList();
		COLOR.add("AFD8F8");
		COLOR.add("F6BD0F");
		COLOR.add("8BBA00");
		COLOR.add("FF8E46");
		COLOR.add("008E8E");
		COLOR.add("D64646");
		COLOR.add("8E468E");
		COLOR.add("588526");
		COLOR.add("B3AA00");
		COLOR.add("008ED6");
		COLOR.add("DDDDDD");
		COLOR.add("9D080D");
		COLOR.add("F6BD0F");
		COLOR.add("C9198D");
		COLOR.add("BDF60F");
		COLOR.add("BA8B00");
		COLOR.add("8EFF46");
		COLOR.add("8E008E");
		COLOR.add("46D646");
		COLOR.add("468E8E");
		COLOR.add("EEEEEE");
		COLOR_STYLE.put("default", COLOR);
		COLOR = new ArrayList();
		COLOR.add("008ED6");
		COLOR.add("008ED6");
		COLOR.add("008ED6");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("DDDDDD");
		COLOR.add("D64646");
		COLOR.add("D64646");
		COLOR.add("D64646");
		COLOR_STYLE.put("order", COLOR);
	}

	public static List getColor(String style) {
		return (List) COLOR_STYLE.get(style);
	}

	/**
	 * 普通的柱状图 SetElement设置set 的属性值:如颜色,调用函数 SetElement =
	 * {"name","value","color","link"}; 默认List 是只有 ["name","value"]
	 * 
	 * @param list
	 * @param options
	 * @return
	 */
	public static String chartNormal(List list, Options options) {
		StringBuffer sb = new StringBuffer();

		sb.append("<graph baseFontSize='12' caption='").append(options.getCaption()).append("' formatNumberScale='0'").append(" numdivlines='").append(options.getNumDivLines()).append("'").append(" showNames='").append(options.getShowNames()).append("'").append(" rotateNames='").append(options.getRotateNames())
				.append("'").append(" showValues='").append(options.getShowValues()).append("'");
		if ("percent".equalsIgnoreCase(options.getValueType())) {
			sb.append(" numberSuffix='%25' decimalPrecision='2' ");
		} else {
			sb.append(" decimalPrecision='").append(options.getDecimalPrecision()).append("' ");
		}

		StringBuffer piece = new StringBuffer();
		double maxValue = -999999d;
		double minValue = 9999999999d;
		for (int i = 0; i < list.size(); i++) {
			String[] lines = (String[]) list.get(i);
			if (lines.length > 2 && options.getSetElement() != null) {
				piece.append("<set ");
				for (int j = 0; j < lines.length; j++) {

					if ("value".equalsIgnoreCase(options.getSetElement()[j])) {
						piece.append("value='");

						double num = 0;
						if (lines[j] != null && lines[j].matches(NUMBER_REGEX)) {
							if ("percent".equalsIgnoreCase(options.getValueType())) {
								num = Double.parseDouble(lines[j]) * 100;
							} else {
								num = Double.parseDouble(lines[j]);
							}
						}
						minValue = minValue < num ? minValue : num;
						maxValue = maxValue > num ? maxValue : num;
						piece.append(num);
						piece.append("' ");
					} else if ("defaultColor".equalsIgnoreCase(options.getSetElement()[j])) {
						piece.append(" color='").append(getColor(options.getColorStyle()).get(i % 14)).append("' ");
					} else if ("except".equalsIgnoreCase(options.getSetElement()[j])) {

					} else {
						String strValue = lines[j];
						if (strValue.matches(NUMBER_REGEX)) {
							double num = Double.parseDouble(strValue);
							minValue = minValue < num ? minValue : num;
							maxValue = maxValue > num ? maxValue : num;
						}
						piece.append(options.getSetElement()[j]).append("='").append(lines[j]).append("' ");
					}
				}
				piece.append("/>");
			} else {
				piece.append("<set name='").append(lines[0]).append("' value='");
				double num = 0;
				if (lines[1] != null && lines[1].matches(NUMBER_REGEX)) {
					if ("percent".equalsIgnoreCase(options.getValueType())) {
						num = Double.parseDouble(lines[1]) * 100;
					} else {
						num = Double.parseDouble(lines[1]);
					}
				}
				minValue = minValue < num ? minValue : num;
				maxValue = maxValue > num ? maxValue : num;
				piece.append(num);
				piece.append("' color='").append(getColor(options.getColorStyle()).get(i % 14)).append("'/>");
			}
		}
		if (options.getTrendlinesValue() != null && options.getTrendlinesValue().length() > 0) {
			if (options.getTrendlinesDisplayValue() == null || options.getTrendlinesDisplayValue().length() == 0)
				options.setTrendlinesDisplayValue("目标");
			double num = Double.parseDouble(options.getTrendlinesValue());
			minValue = minValue < num ? minValue : num;
			maxValue = maxValue > num ? maxValue : num;
			piece.append("<trendlines><line startvalue='" + options.getTrendlinesValue() + "' displayValue='" + options.getTrendlinesDisplayValue() + " " + options.getTrendlinesValue() + "%' color='FF8000' thickness='2' isTrendZone='0' showOnTop='1'/></trendlines>");
		}

		String formatMinValue = processMin(minValue);
		String formatMaxValue = processMax(maxValue);

		sb.append(" yaxisminvalue='").append(formatMinValue).append("' yaxismaxvalue='").append(formatMaxValue).append("' >").append(piece).append("</graph>");

		return sb.toString();
	}

	/**
	 * 比较图
	 * 
	 * @param list
	 *            ["time_id","鄂州","123","黄石","234"]
	 * @param options
	 * @return
	 */
	public static String chartMultiCol(List list, Options options) {
		StringBuffer sb = new StringBuffer();

		sb.append("<graph baseFontSize='12' caption='").append(options.getCaption()).append("' formatNumberScale='0'").append(" numdivlines='").append(options.getNumDivLines()).append("'").append(" showNames='").append(options.getShowNames()).append("'").append(" rotateNames='").append(options.getRotateNames())
				.append("'").append(" showValues='").append(options.showValues).append("'");

		if ("percent".equalsIgnoreCase(options.getValueType())) {
			sb.append(" numberSuffix='%25' decimalPrecision='2'");
		} else {
			sb.append(" decimalPrecision='").append(options.getDecimalPrecision()).append("'");
		}

		StringBuffer piece = new StringBuffer();

		piece.append("<categories FontSize='9'>");
		String[] line = null;

		for (int i = 0; i < list.size(); i++) {
			line = (String[]) list.get(i);
			piece.append("<category name='").append(line[0]).append("'/>");
		}
		piece.append("</categories>");
		int areaCount = 0;
		if(line!=null){
			areaCount = line.length / 2;
		}
		double minValue = 9999999999d;
		double maxValue = -999999d;
		for (int i = 0; i < areaCount; i++) {
			piece.append("<dataset seriesname='").append(line[i * 2 + 1]);
			piece.append("' areaAlpha='60' color='").append(getColor("default").get(i)).append("' areaBorderColor='").append(getColor("default").get(i)).append("'>");
			for (int j = 0; j < list.size(); j++) {
				line = (String[]) list.get(j);
				piece.append("<set value='");

				double num = 0;
				if (line[i * 2 + 2] != null && line[i * 2 + 2].matches(NUMBER_REGEX)) {
					if ("percent".equalsIgnoreCase(options.getValueType())) {
						num = Double.parseDouble(line[i * 2 + 2]) * 100;
					} else {
						num = Double.parseDouble(line[i * 2 + 2]);
					}
				}
				minValue = minValue < num ? minValue : num;
				maxValue = maxValue > num ? maxValue : num;
				piece.append(num);
				piece.append("' />");
			}
			piece.append("</dataset>");
		}

		String formatMinValue = processMin(minValue);
		String formatMaxValue = processMax(maxValue);

		sb.append(" yaxisminvalue='").append(formatMinValue).append("' yaxismaxvalue='").append(formatMaxValue).append("' >").append(piece).append("</graph>");

		return sb.toString();

		/*
		 * StringBuffer sb = new StringBuffer();
		 * sb.append("<graph baseFontSize='12' caption='"
		 * ).append(options.getCaption
		 * ()).append("' formatNumberScale='0'").append
		 * (" numdivlines='").append(
		 * options.getNumDivLines()).append("'").append
		 * (" showNames='").append(options
		 * .getShowNames()).append("'").append(" showValues='"
		 * ).append(options.showValues).append("' yAxisMaxValue='0.01'");
		 * if("percent".equalsIgnoreCase(options.getValueType()))
		 * sb.append(" numberSuffix='%25' decimalPrecision='2'"); else
		 * sb.append(" decimalPrecision='0'"); sb.append(">"); StringBuffer
		 * datasetpiece = new StringBuffer(); java.util.Set set = new
		 * java.util.HashSet(); int count = 0; int length = -1; for(int i = 0; i
		 * < list.size(); i++) { String lines[] = (String[])list.get(i);
		 * if(set.contains(lines[0])) { datasetpiece.append("<set value='");
		 * if("percent".equalsIgnoreCase(options.getValueType())) { double num =
		 * Double.parseDouble(lines[2]) * 100D; datasetpiece.append(num); } else
		 * { datasetpiece.append(lines[2]); } datasetpiece.append("' />");
		 * count++; } else { if(i > 0) datasetpiece.append("</dataset>");
		 * if(count != 0 && length == -1) length = count + 1;
		 * datasetpiece.append
		 * ("<dataset seriesname='").append(lines[0]).append("' color='"
		 * ).append(getColor("default").get(length != 0 ? i / length :
		 * 0)).append("'>"); datasetpiece.append("<set value='");
		 * if("percent".equalsIgnoreCase(options.getValueType())) { double num =
		 * Double.parseDouble(lines[2]) * 100D; datasetpiece.append(num); } else
		 * { datasetpiece.append(lines[2]); } datasetpiece.append("' />");
		 * set.add(lines[0]); } }
		 * 
		 * datasetpiece.append("</dataset>");
		 * sb.append("<categories font='Arial' fontSize='11' fontColor='000000'>"
		 * ); for(int i = 0; i < length; i++) { String lines[] =
		 * (String[])list.get(i);
		 * sb.append("<category name='").append(lines[1]).append("'/>"); }
		 * 
		 * sb.append("</categories>").append(datasetpiece).append("</graph>");
		 * return sb.toString();
		 */
	}

	protected static String processMin(double minValue) {
		String sMinValue = decimalFormat.format(minValue);
		String formatMinValue = sMinValue;
		if (minValue >= 10) {
			formatMinValue = (Integer.parseInt(sMinValue.substring(0, 2)) - 1) + "";
			int digit = sMinValue.indexOf(".");
			if (digit == -1)
				digit = sMinValue.length();
			for (int j = 0; j < digit - 2; j++) {
				formatMinValue += "0";
			}
		} else if (minValue > 1)
			formatMinValue = (Integer.parseInt(sMinValue.substring(0, 1)) - 1) + "";
		else if (minValue < 1 && minValue >= 0) {
			formatMinValue = "0";
		} else if (minValue < 0) {
			formatMinValue = "-" + processMax(-1 * minValue);
		}

		return formatMinValue;
	}

	protected static String processMax(double maxValue) {
		String sMaxValue = decimalFormat.format(maxValue);
		String formatMaxValue = sMaxValue;
		if (maxValue >= 10) {
			formatMaxValue = (Integer.parseInt(sMaxValue.substring(0, 2)) + 1) + "";
			int digit = sMaxValue.indexOf(".");
			if (digit == -1)
				digit = sMaxValue.length();
			for (int j = 0; j < digit - 2; j++) {
				formatMaxValue += "0";
			}
		} else if (maxValue > 0)
			formatMaxValue = (Integer.parseInt(sMaxValue.substring(0, 1)) + 1) + "";
		else if (maxValue <= 0)
			formatMaxValue = "0.01";
		return formatMaxValue;
	}

	/**
	 * 带指标线的柱状图
	 * 
	 * @param list
	 *            ["鄂州","123","34%"]
	 * @param options
	 * @return
	 */
	public static String chartColLineDY(List list, Options options) {
		if (list == null || list.size() == 0)
			return "";
		StringBuffer catlogpiece = new StringBuffer("<categories>");
		StringBuffer dspiece = new StringBuffer("<dataset ").append(" showValues='").append(options.getShowValues()).append("'>");
		StringBuffer dslinepiece = null;

		String[] lines = (String[]) list.get(0);
		double maxValue = -999999d;
		double minValue = 999999999d;
		double value = 0d;
		if (lines[2] != null) {
			if (options.dySeriesName == null || options.dySeriesName.length() == 0)
				options.dySeriesName = "目标";
			dslinepiece = new StringBuffer("<dataset seriesName='" + options.dySeriesName + "' parentYAxis='S' ").append(" showValues='").append(options.getShowValues()).append("'>");
		}

		for (int i = 0; i < list.size(); i++) {
			lines = (String[]) list.get(i);
			catlogpiece.append("<category name='").append(lines[0]).append("'/>");

			if (lines[1] != null && lines[1].length() > 0) {
				value = 0;
				if (lines[1].matches(NUMBER_REGEX)) {
					value = Double.parseDouble(lines[1]);
				}
				if ("percent".equalsIgnoreCase(options.getValueType())) {
					value *= 100;
				}
				maxValue = maxValue > value ? maxValue : value;
				minValue = minValue < value ? minValue : value;
				dspiece.append("<set value='").append(value).append("' color='").append(getColor("default").get(i % 14)).append("'/>");
			}
			// else
			// dspiece.append("<set value='").append(lines[1]).append("' color='").append(getColor("default").get(i%14)).append("'/>");

			if (dslinepiece != null) {
				if (lines[2] != null && lines[2].length() > 0) {
					value = 0;
					if (lines[2].matches(NUMBER_REGEX)) {
						value = Double.parseDouble(lines[2]);
					}

					if ("percent".equalsIgnoreCase(options.getValueType())) {
						value *= 100;
					}
					maxValue = maxValue > value ? maxValue : value;
					minValue = minValue < value ? minValue : value;
					dslinepiece.append("<set value='").append(value).append("'/>");
				}
				// else
				// dslinepiece.append("<set value='").append(lines[2]).append("'/>");
			}
		}
		catlogpiece.append("</categories>");
		dspiece.append("</dataset>");
		if (dslinepiece != null)
			dslinepiece.append("</dataset>");

		StringBuffer sb = new StringBuffer();

		sb.append("<graph baseFontSize='12' caption='").append(options.getCaption()).append("' formatNumberScale='0' showSecondaryLimits='0' showLegend='0' showDivLineSecondaryValue='0' ").append(" numdivlines='").append(options.getNumDivLines()).append("'").append(" showNames='").append(options.getShowNames())
				.append("'").append(" rotateNames='").append(options.getRotateNames()).append("'").append(" showValues='").append(options.getShowValues()).append("'");

		if ("percent".equalsIgnoreCase(options.getValueType())) {
			sb.append(" numberSuffix='%25' decimalPrecision='2'");
		} else {
			sb.append(" decimalPrecision='").append(options.getDecimalPrecision()).append("'");
		}

		String formatMaxValue = processMax(maxValue);
		String formatMinValue = processMin(minValue);

		sb.append(" PYAxisMaxValue='").append(formatMaxValue).append("' SYAxisMaxValue='").append(formatMaxValue).append("' ").append(" PYAxisMinValue='").append(formatMinValue).append("' SYAxisMinValue='").append(formatMinValue).append("' ").append(">");
		// sb.append(" PYAxisMaxValue='"+formatMaxValue+"' ").append(">");

		sb.append(catlogpiece).append(dspiece);
		if (dslinepiece != null)
			sb.append(dslinepiece);

		sb.append("</graph>");
		return sb.toString();
	}

	public static class Options {
		private String caption = "", showNames = "1", showValues = "0", numDivLines = "3", colorStyle = "default", decimalPrecision = "0",// 小数点的位数
				valueType = "",// 百分比的形式需要乘100
				trendlinesDisplayValue = "", trendlinesValue = "", dySeriesName = "",// Y轴的名称
				rotateNames = "0";

		public String[] setElement;

		public String getColorStyle() {
			return colorStyle;
		}

		public void setColorStyle(String colorStyle) {
			this.colorStyle = colorStyle;
		}

		public String getRotateNames() {
			return rotateNames;
		}

		public void setRotateNames(String rotateNames) {
			this.rotateNames = rotateNames;
		}

		public String[] getSetElement() {
			return setElement;
		}

		public void setSetElement(String[] setElement) {
			this.setElement = setElement;
		}

		public String getDecimalPrecision() {
			return decimalPrecision;
		}

		public void setDecimalPrecision(String decimalPrecision) {
			this.decimalPrecision = decimalPrecision;
		}

		public String getCaption() {
			return caption;
		}

		public void setCaption(String caption) {
			this.caption = caption;
		}

		public String getShowNames() {
			return showNames;
		}

		public void setShowNames(String showNames) {
			this.showNames = showNames;
		}

		public String getShowValues() {
			return showValues;
		}

		public void setShowValues(String showValues) {
			this.showValues = showValues;
		}

		public String getValueType() {
			return valueType;
		}

		public void setValueType(String valueType) {
			this.valueType = valueType;
		}

		public String getNumDivLines() {
			return numDivLines;
		}

		public void setNumDivLines(String numDivLines) {
			this.numDivLines = numDivLines;
		}

		public String getTrendlinesValue() {
			return trendlinesValue;
		}

		public void setTrendlinesValue(String trendlinesValue) {
			this.trendlinesValue = trendlinesValue;
		}

		public String getTrendlinesDisplayValue() {
			return trendlinesDisplayValue;
		}

		public void setTrendlinesDisplayValue(String trendlinesDisplayValue) {
			this.trendlinesDisplayValue = trendlinesDisplayValue;
		}

		public String getDySeriesName() {
			return dySeriesName;
		}

		public void setDySeriesName(String dySeriesName) {
			this.dySeriesName = dySeriesName;
		}

	}

	public static void main(String[] args) {

		System.out.println("1.1111".matches(NUMBER_REGEX));

		String str1 = new String("123");
		String str2 = "123";

		String str3 = str1.intern();

		System.out.println((str1 == str2) + "," + (str3 == str2));

		String str4 = new String("234");
		String str5 = new String("234");

		String str6 = str4.intern();
		String str7 = str5.intern();

		System.out.println((str4 == str5) + "," + (str6 == str7));
	}

	/*
	 * public static void main(String[] args) { String s = "0"; double d =
	 * Double.parseDouble(s); String num = s;
	 * System.out.println(1328434187328947d);
	 * 
	 * if (d>=10) { num = (Integer.parseInt(s.substring(0,2))+1)+""; int digit =
	 * s.indexOf("."); if(digit==-1)digit=s.length(); for (int j = 0; j <
	 * digit-2; j++) { num+="0"; } } else if(d>0) num =
	 * (Integer.parseInt(s.substring(0,1))+1)+"";
	 * 
	 * System.out.println(num);
	 * 
	 * System.out.println(5/2);
	 * 
	 * System.out.println("集团客户日累计ARPM(元/分钟)"+null);
	 * 
	 * 
	 * System.out.println("HB.WH1a".matches("[A-Za-z0-9\\.]+"));
	 * 
	 * }
	 */
}
