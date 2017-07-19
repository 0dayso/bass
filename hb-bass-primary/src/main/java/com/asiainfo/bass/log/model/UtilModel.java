package com.asiainfo.bass.log.model;
/**
 * 此类主要放日志查询的从前天传到后台的值
 * @author Administrator
 *
 */
public class UtilModel {
	
	private int page;
	private int rows;
	
	private String order;
	private String sort;
	

	
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}

}
