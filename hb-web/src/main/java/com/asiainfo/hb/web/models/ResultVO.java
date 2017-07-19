package com.asiainfo.hb.web.models;

import java.io.Serializable;

/**
 * 
 * @author Administrator
 *�����������0 �ɹ���1 ʧ�ܹ�����
 */

@SuppressWarnings("serial")
public class ResultVO implements Serializable{
	private String result;
	private String resultDesc;
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getResultDesc() {
		return resultDesc;
	}
	public void setResultDesc(String resultDesc) {
		this.resultDesc = resultDesc;
	}

}
