/**
 * 
 */
package com.asiainfo.hb.bass.frame.models;

/**
 * @author zhangds
 * @date 2016年8月9日
 */
public class NoticeBean {
	/**
	 * CREATE TABLE sys_notice
		 (noticeID            INTEGER         NOT NULL  DEFAULT 0,
		  notice_start_dt          TIMESTAMP       NOT NULL  DEFAULT current timestamp,
		  notice_end_dt          TIMESTAMP       NOT NULL  DEFAULT current timestamp,
		  noticetitle         VARCHAR(128)    NOT NULL,
		  noticemsg           VARCHAR(4000),
		  extend_color		  VARCHAR(30),
		  CREATOR           VARCHAR(50)               DEFAULT 'admin',
		  STATUS            CHARACTER(2)              default '1'
		 )in userspace2;
	 */
	int noticeId = 0 ;
	String notice_start_dt,notice_end_dt;
	String noticetitle,noticemsg,extend_color,creator,status;
	public int getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(int noticeId) {
		this.noticeId = noticeId;
	}
	public String getNotice_start_dt() {
		return notice_start_dt;
	}
	public void setNotice_start_dt(String notice_start_dt) {
		this.notice_start_dt = notice_start_dt;
	}
	public String getNotice_end_dt() {
		return notice_end_dt;
	}
	public void setNotice_end_dt(String notice_end_dt) {
		this.notice_end_dt = notice_end_dt;
	}
	public String getNoticetitle() {
		return noticetitle;
	}
	public void setNoticetitle(String noticetitle) {
		this.noticetitle = noticetitle;
	}
	public String getNoticemsg() {
		return noticemsg;
	}
	public void setNoticemsg(String noticemsg) {
		this.noticemsg = noticemsg;
	}
	public String getExtend_color() {
		return extend_color;
	}
	public void setExtend_color(String extend_color) {
		this.extend_color = extend_color;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	

}
