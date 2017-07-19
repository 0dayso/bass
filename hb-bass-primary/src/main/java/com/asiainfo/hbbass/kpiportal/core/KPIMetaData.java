package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;

/**
 * KPI的元数据对象
 * 
 * @author Mei Kefu
 * 
 */
public class KPIMetaData implements Serializable {

	private static final long serialVersionUID = -3897110675298323843L;

	/*************** KPI的ID ********************/
	private String id = "";

	/*************** KPI的名称 ********************/
	private String name = "";

	/*************** KPI的类型 ********************/
	private String kind;

	/*************** 指标说明 ********************/
	private String instruction = "";

	/*************** 目标值的类型,是累计还是一般 ********************/
	private String targetType = "";

	/*************** 考核目标20091223增加，主要用在PercentLoad中，只试用于固定值的目标 ********************/
	private double targetValue = 0;

	/*************** 同(环)比增幅考核目标20091223增加，主要用在PercentLoad中，只试用于固定值的目标 ********************/
	private double compTargetValue = 0;

	/*************** 格式化类型,按照百分比还是一般 ********************/
	private String formatType = "";

	/*************** 单位的名称 ********************/
	private String unit = "";

	/*************** 用于单位,数值除一这个数 ********************/
	private double division = 1d;

	/*************** 使用SQL计算的原始指标代码 ********************/
	private String originIds = "";

	/*************** 算法 ********************/
	private String arithmetic = "";

	/*************** 表达规则，描述该指标的规则，已月同比，年同比，全省排名规则 2010-6-13 [月同比，年同比，绝对值，不排名] ********************/
	private String expRules = "";

	public String numerator = "", numberatorSign = "", denominator = "", denominatorSign = "";

	/*************** 加载的类名 ********************/
	private String loadClassName = "com.asiainfo.hbbass.kpiportal.load.DefaultLoad";

	/*************** 值过滤器的类 ********************/
	private String filterClassName = "";

	/**
	 * 算法解析,暂时不支持括号运算,不支持多个除法
	 */
	public void parseArithmetic() {
		if (arithmetic.length() > 0) {
			String[] pieces = arithmetic.split("/");
			if (pieces.length == 2) {
				String[] arr = pieces[0].replaceAll("[()]", "").split("(?<=[\\+\\-\\*])");
				StringBuffer sb = new StringBuffer();
				StringBuffer sb2 = new StringBuffer();

				for (int i = 0; i < arr.length; i++) {
					char[] c = arr[i].toCharArray();

					if (i < arr.length - 1) {
						if (sb2.length() > 0)
							sb2.append(",");
						sb2.append(c[c.length - 1]);
						c[c.length - 1] = ',';
					}
					sb.append(c);
				}
				numerator = sb.toString().intern();
				numberatorSign = sb2.toString().intern();

				arr = pieces[1].replaceAll("[()]", "").split("(?<=[\\+\\-\\*])");
				sb = new StringBuffer();
				sb2 = new StringBuffer();

				for (int i = 0; i < arr.length; i++) {
					char[] c = arr[i].toCharArray();

					if (i < arr.length - 1) {
						if (sb2.length() > 0)
							sb2.append(",");
						sb2.append(c[c.length - 1]);
						c[c.length - 1] = ',';
					}
					sb.append(c);
				}
				denominator = sb.toString().intern();
				denominatorSign = sb2.toString().intern();
			}
		}
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getInstruction() {
		return instruction;
	}

	public void setInstruction(String instruction) {
		this.instruction = instruction;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public String getFormatType() {
		return formatType;
	}

	public void setFormatType(String formatType) {
		this.formatType = formatType;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public double getDivision() {
		return division;
	}

	public void setDivision(double division) {
		this.division = division;
	}

	public String getOriginIds() {
		return originIds;
	}

	public void setOriginIds(String originIds) {
		this.originIds = originIds;
	}

	public String getArithmetic() {
		return arithmetic;
	}

	public void setArithmetic(String arithmetic) {
		this.arithmetic = arithmetic;
	}

	public String getLoadClassName() {
		return loadClassName;
	}

	public void setLoadClassName(String loadClassName) {
		this.loadClassName = loadClassName;
	}

	public double getTargetValue() {
		return targetValue;
	}

	public void setTargetValue(double targetValue) {
		this.targetValue = targetValue;
	}

	public static void main(String[] args) {

		KPIMetaData a = new KPIMetaData();
		a.arithmetic = "K11012/(K10019*$date)";
		a.parseArithmetic();
		System.out.println(a.denominator);

		System.out.println("$K10008".matches("\\$.*"));
	}

	public double getCompTargetValue() {
		return compTargetValue;
	}

	public void setCompTargetValue(double compTargetValue) {
		this.compTargetValue = compTargetValue;
	}

	public String getFilterClassName() {
		return filterClassName;
	}

	public void setFilterClassName(String filterClassName) {
		this.filterClassName = filterClassName;
	}

	public String getExpRules() {
		return expRules;
	}

	public void setExpRules(String expRules) {
		this.expRules = expRules;
	}

}
