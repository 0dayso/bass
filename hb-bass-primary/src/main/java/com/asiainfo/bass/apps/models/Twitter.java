package com.asiainfo.bass.apps.models;

import java.util.Calendar;
import java.util.Date;

import org.springframework.stereotype.Service;

import com.asiainfo.hb.web.models.User;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-24
 */
@Service
public class Twitter {

	private Long id;

	private Long pid;

	private User user;

	private String replyId;

	private String reply;

	private Date createDt;

	private String dateContent;

	private String state = "喳喳";

	private String content;
	
	private String fileName;
	
	private String telephone;
	
	private String responsible;
	
	//责任人ID
	private String responsibleId;
	//责任人电话
	private String responsiblePhone;
	//要求完成时间
	private String endTime;
	//对应BOMC单号
	private String bomcId;
	
	public String getResponsibleId() {
		return responsibleId;
	}

	public void setResponsibleId(String responsibleId) {
		this.responsibleId = responsibleId;
	}

	public String getResponsiblePhone() {
		return responsiblePhone;
	}

	public void setResponsiblePhone(String responsiblePhone) {
		this.responsiblePhone = responsiblePhone;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getBomcId() {
		return bomcId;
	}

	public void setBomcId(String bomcId) {
		this.bomcId = bomcId;
	}

	public String getResponsible() {
		return responsible;
	}

	public void setResponsible(String responsible) {
		this.responsible = responsible;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getPid() {
		return pid;
	}

	public void setPid(Long pid) {
		this.pid = pid;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getReplyId() {
		return replyId;
	}

	public void setReplyId(String replyId) {
		if (replyId == null) {
			replyId = "";
		}
		this.replyId = replyId;
	}

	public String getReply() {
		return reply;
	}

	public void setReply(String reply) {
		if (reply == null) {
			reply = "";
		}
		this.reply = reply;
	}

	public Date getCreateDt() {
		return createDt;
	}

	public String getDateContent() {
		long dura = (System.currentTimeMillis() - createDt.getTime()) / 1000 / 60; // 分钟
		String text = "刚刚";
		if (dura > 48 * 60) {
			text = createDt.toString().substring(0, 10);
		} else if (dura > 24 * 60) {
			String dateText = createDt.toString().substring(10, 16);
			text = "昨天" + dateText;
		} else if (dura > 60) {
			text = dura / 60 + " 小时前";
		} else if (dura > 1) {
			text = dura + " 分钟前";
		}
		dateContent = text + " 来自网页";

		return dateContent;
	}

	public void setDateContent(String dateContent) {
		this.dateContent = dateContent;
	}

	public void setCreateDt(Date createDt) {
		this.createDt = createDt;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		if (state == null) {
			state = "";
		}
		this.state = state;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		if (content == null) {
			content = "";
		}
		this.content = content;
	}

	public static void main(String[] args) {

		System.out.println(Calendar.getInstance().getTime().getTime() - Calendar.getInstance().getTime().getTime());

	}

}
