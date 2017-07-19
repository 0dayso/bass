package com.asiainfo.hb.power.models;

import java.util.List;

/**
 * @author zhaob
 * @date 2016年8月22日
 */
public class UserItemsBean {

	int roleid;//角色id
	int menuid;//菜单id
	String power;//y,y,y,y  
	List<UserItemsBean> children;
	public int getRoleid() {
		return roleid;
	}
	public void setRoleid(int roleid) {
		this.roleid = roleid;
	}
	public int getMenuid() {
		return menuid;
	}
	public void setMenuid(int menuid) {
		this.menuid = menuid;
	}
	public String getPower() {
		return power;
	}
	public void setPower(String power) {
		this.power = power;
	}
	public List<UserItemsBean> getChildren() {
		return children;
	}
	public void setChildren(List<UserItemsBean> children) {
		this.children = children;
	}
	
	
}
