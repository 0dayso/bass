package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;

/**
 * KPI应用的时间参数和缓存参数
 * 
 * @author Mei Kefu
 * @date 2009-8-6
 */
public class KPIAppData implements Serializable {

	private static final long serialVersionUID = 9219737471810441381L;

	private String name = "", /* 应用的名字 和 cache的名字必需一样 */
	appType = "", current = "", pre = "", befroe = "", year = "";

	public KPIAppData(String name, String appType) {
		super();
		this.name = name;
		this.appType = appType;
	}

	public String getName() {
		return name;
	}

	public String getAppType() {
		return appType;
	}

	public String getCurrent() {
		return current;
	}

	protected void setCurrent(String current) {
		this.current = current;
	}

	public String getPre() {
		return pre;
	}

	protected void setPre(String pre) {
		this.pre = pre;
	}

	protected void setName(String name) {
		this.name = name;
	}

	protected void setAppType(String appType) {
		this.appType = appType;
	}

	public String getBefroe() {
		return befroe;
	}

	protected void setBefroe(String befroe) {
		this.befroe = befroe;
	}

	public String getYear() {
		return year;
	}

	protected void setYear(String year) {
		this.year = year;
	}

}
