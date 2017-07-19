package com.asiainfo.hbbass.ws.model;

import java.io.Serializable;

public class MenuInfoModel implements Serializable {
	private static final long serialVersionUID = -43243543531L;
	private String id; // (菜单类型'M'||报表类型'S') + 经分系统菜单当前ID
	private String menuLev1;// 一级菜单描述
	private String menuLev2;// 二级菜单描述
	private String menuLev3;// 三级菜单描述
	private String menuLev4;// 四级菜单描述
	private String menuLev5;// 五级菜单描述
	private String typeMenu;// M-菜单 S-报表
	private String typeOp;// Q-查询 D-下载
	private String status;// Y-受控 N-不受控
	private String updDateStr;// 最后变更时间，如：20120214
	private String sceneId;// 场景ID

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMenuLev1() {
		return menuLev1;
	}

	public void setMenuLev1(String menuLev1) {
		this.menuLev1 = menuLev1;
	}

	public String getMenuLev2() {
		return menuLev2;
	}

	public void setMenuLev2(String menuLev2) {
		this.menuLev2 = menuLev2;
	}

	public String getMenuLev3() {
		return menuLev3;
	}

	public void setMenuLev3(String menuLev3) {
		this.menuLev3 = menuLev3;
	}

	public String getMenuLev4() {
		return menuLev4;
	}

	public void setMenuLev4(String menuLev4) {
		this.menuLev4 = menuLev4;
	}

	public String getMenuLev5() {
		return menuLev5;
	}

	public void setMenuLev5(String menuLev5) {
		this.menuLev5 = menuLev5;
	}

	public String getTypeMenu() {
		return typeMenu;
	}

	public void setTypeMenu(String typeMenu) {
		this.typeMenu = typeMenu;
	}

	public String getTypeOp() {
		return typeOp;
	}

	public void setTypeOp(String typeOp) {
		this.typeOp = typeOp;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUpdDateStr() {
		return updDateStr;
	}

	public void setUpdDateStr(String updDateStr) {
		this.updDateStr = updDateStr;
	}

	public String getSceneId() {
		return sceneId;
	}

	public void setSceneId(String sceneId) {
		this.sceneId = sceneId;
	}
}
