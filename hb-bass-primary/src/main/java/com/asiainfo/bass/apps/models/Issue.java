package com.asiainfo.bass.apps.models;

import org.springframework.stereotype.Service;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-24
 */
@Service
public class Issue extends Twitter {

	private String type;

	private String replyType;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getReplyType() {
		return replyType;
	}

	public void setReplyType(String replyType) {
		this.replyType = replyType;
	}

	public static void main(String[] args) {

	}

}
