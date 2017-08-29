package com.asiainfo.hb.bass.log.visit.models;

public class VisitInfo {
	/**
	 * 地市名称
	 */
	private String areaName;
	/**
	 * 总访问次数
	 */
	private Integer times;
	/**
	 * 总访问人次
	 */
	private Integer count;
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	public Integer getTimes() {
		return times;
	}
	public void setTimes(Integer times) {
		this.times = times;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	@Override
	public String toString() {
		return "VisitInfo [areaName=" + areaName + ", times=" + times + ", count=" + count + "]";
	} 
	
}
