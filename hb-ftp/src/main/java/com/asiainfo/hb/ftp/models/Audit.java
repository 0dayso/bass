package com.asiainfo.hb.ftp.models;

import java.io.Serializable;

public class Audit implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String file_id;// 文件id
	private String status;// 审核结果
	private String approve_opinion;// 审核意见
	private String approver;// 审核人

	public String getApprover() {
		return approver;
	}

	public void setApprover(String approver) {
		this.approver = approver;
	}

	public String getFile_id() {
		return file_id;
	}

	public void setFile_id(String file_id) {
		this.file_id = file_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getApprove_opinion() {
		return approve_opinion;
	}

	public void setApprove_opinion(String approve_opinion) {
		this.approve_opinion = approve_opinion;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
