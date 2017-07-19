package com.asiainfo.hbbass.ws.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

public class StatusBodyInfoDTO implements Serializable {
	private static final long serialVersionUID = -1178402090413385567L;
	private String result; // 开启1 无需开启0(老的) 状态正常：1  应急：0已授权：2 未知：3(新的)
	private String resultDesc;
	private ArrayList<HashMap<String, String>> relations; // 多值授权方式与访问方式关系
	private ArrayList<String> approvers; // 多值审批人
	private String historyAppSessionId;
	private String maxTime;
	private String cooperate;//协同操作人
	private String applyReason;//申请原因
	private String operateContent;//操作内容
	private String impowerFashion;//授权方式
	private String impowerCondition;//授权条件
	private String impowerResult;//授权结果
	private String impowerTime;//授权时间
	private String impowerIdea;//授权意见

	public String getCooperate() {
		return cooperate;
	}

	public void setCooperate(String cooperate) {
		this.cooperate = cooperate;
	}

	public String getApplyReason() {
		return applyReason;
	}

	public void setApplyReason(String applyReason) {
		this.applyReason = applyReason;
	}

	public String getOperateContent() {
		return operateContent;
	}

	public void setOperateContent(String operateContent) {
		this.operateContent = operateContent;
	}

	public String getImpowerFashion() {
		return impowerFashion;
	}

	public void setImpowerFashion(String impowerFashion) {
		this.impowerFashion = impowerFashion;
	}

	public String getImpowerCondition() {
		return impowerCondition;
	}

	public void setImpowerCondition(String impowerCondition) {
		this.impowerCondition = impowerCondition;
	}

	public String getImpowerResult() {
		return impowerResult;
	}

	public void setImpowerResult(String impowerResult) {
		this.impowerResult = impowerResult;
	}

	public String getImpowerTime() {
		return impowerTime;
	}

	public void setImpowerTime(String impowerTime) {
		this.impowerTime = impowerTime;
	}

	public String getImpowerIdea() {
		return impowerIdea;
	}

	public void setImpowerIdea(String impowerIdea) {
		this.impowerIdea = impowerIdea;
	}

	public String getHistoryAppSessionId() {
		return historyAppSessionId;
	}

	public void setHistoryAppSessionId(String historyAppSessionId) {
		this.historyAppSessionId = historyAppSessionId;
	}

	public String getMaxTime() {
		return maxTime;
	}

	public void setMaxTime(String maxTime) {
		this.maxTime = maxTime;
	}

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

	public ArrayList<HashMap<String, String>> getRelations() {
		return relations;
	}

	public void setRelations(ArrayList<HashMap<String, String>> relations) {
		this.relations = relations;
	}

	public ArrayList<String> getApprovers() {
		return approvers;
	}

	public void setApprovers(ArrayList<String> approvers) {
		this.approvers = approvers;
	}
}
