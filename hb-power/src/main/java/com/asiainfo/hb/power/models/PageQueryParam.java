package com.asiainfo.hb.power.models;
/*
 * 分页工具类
 */
public class PageQueryParam {
	private int pageNumber = 1;
	private int pageSize = 10;
	//开始检索的地方
	private int indexNum;
	//总的页数
	private int pageCount ;	
	
	private String userid="";
	private String username="";
	private String cityid="";
	public int getIndexNum() {
		this.indexNum =(this.pageNumber-1)*this.pageSize;
		return indexNum;
	}
	public int getPageCount() {
		return pageCount;
	}
	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	public int getPageNumber() {
		return pageNumber;
	}
	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getCityid() {
		return cityid;
	}
	public void setCityid(String cityid) {
		this.cityid = cityid;
	}
}
