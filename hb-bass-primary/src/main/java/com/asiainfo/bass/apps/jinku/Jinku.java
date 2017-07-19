package com.asiainfo.bass.apps.jinku;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

public class Jinku implements Serializable {
	private static final long serialVersionUID = 247435677832L;
	private String result; // 开启1 无需开启0(老的) 状态正常：1 应急：0已授权：2 未知：3(新的)
	private String resultDesc;
	private ArrayList<HashMap<String, String>> relations; // 多值授权方式与访问方式关系
	private ArrayList<String> approvers; // 多值审批人
	private String historyAppSessionId;
	private String maxTime;
	private String userID; // 用户id
	private String clientIp; // 客户端访问ip
	private String nid; // 金库改造新id
	private String sceneId; // 场景id
	private String operate; // 操作代码 查询Q 下载D
	private String isSensitive; // 是否保密菜单
	private String visitDateStr; // 访问时间
	private String comment; // 操作简要描述
	private String cooperate;// 协同操作人
	private String applyReason;// 申请原因
	private String operateContent;// 操作内容
	private String impowerFashion;// 授权方式
	private String impowerCondition;// 授权条件
	private String impowerResult;// 授权结果
	private String impowerTime;// 授权时间
	private String impowerIdea;// 授权意见
	private String status;// 1:申请 2:申请通过 3:申请未通过
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

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

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getNid() {
		return nid;
	}

	public void setNid(String nid) {
		this.nid = nid;
	}

	public String getSceneId() {
		return sceneId;
	}

	public void setSceneId(String sceneId) {
		this.sceneId = sceneId;
	}

	public String getOperate() {
		return operate;
	}

	public void setOperate(String operate) {
		this.operate = operate;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getIsSensitive() {
		return isSensitive;
	}

	public void setIsSensitive(String isSensitive) {
		this.isSensitive = isSensitive;
	}

	public String getVisitDateStr() {
		return visitDateStr;
	}

	public void setVisitDateStr(String visitDateStr) {
		this.visitDateStr = visitDateStr;
	}
}
