package com.asiainfo.hb.web.models;

import java.io.Serializable;

import com.asiainfo.hb.core.models.Configuration;

@SuppressWarnings("serial")
public class User implements Serializable {

	private String id;
	private String name;
	private String password;
	private String phone;
	private String mail;
	private String regionId;
	
	private String face=Configuration.getInstance().getProperty("com.asiainfo.pst.util.fileServerAddr")+"/images/face/default_face.gif";

	private String cityId;
	private String groupId;
	private String groupName;
	
	
	private String visitArea;
	private String areaCode;
	private String areaName; 
	
	private int sperAdmin=0;
	private int status;
	
	protected User() {}
	
	public User(String id, String name) {
		this.id = id;
		this.name = name;
	}
	
	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
	
	public String getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getRegionId() {
		return regionId;
	}
	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}
	public String getFace() {
		return face;
	}
	public void setFace(String face) {
		if(face!=null && face.length()>0)
			this.face = face;
	}

	public String getCityId() {
		return cityId;
	}

	public void setCityId(String cityId) {
		this.cityId = cityId;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getVisitArea() {
		return visitArea;
	}

	public void setVisitArea(String visitArea) {
		this.visitArea = visitArea;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public int getSperAdmin() {
		return sperAdmin;
	}

	public void setSperAdmin(int sperAdmin) {
		this.sperAdmin = sperAdmin;
	}


}
