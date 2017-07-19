/**
 * 
 */
package com.asiainfo.hb.bass.frame.models;

import java.util.List;


/**
 * @author zhangds
 * @date 2015年7月22日
 */
public class MenuBean {

	String id;
	String name;
	String pid;
	int sortnum;
	String file;
	String iconurl;
	int menutype;
	List<MenuBean> children;
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
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public int getSortnum() {
		return sortnum;
	}
	public void setSortnum(int sortnum) {
		this.sortnum = sortnum;
	}
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	public String getIconurl() {
		return iconurl;
	}
	public void setIconurl(String iconurl) {
		this.iconurl = iconurl;
	}
	public int getMenutype() {
		return menutype;
	}
	public void setMenutype(int menutype) {
		this.menutype = menutype;
	}
	public List<MenuBean> getChildren() {
		return children;
	}
	public void setChildren(List<MenuBean> children) {
		this.children = children;
	}
	
	
}
