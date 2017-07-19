package com.asiainfo.hb.bass.data.model;

/**
 * 单一维度定义模型，对应表KPI_SIMPLE_DIM
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
public class DimSimpleDef {
	private String dimCode, dimName, columeCode, parentCode, columeValue, colValType;

	public String getDimCode() {
		return dimCode;
	}

	public void setDimCode(String dimCode) {
		this.dimCode = dimCode;
	}

	public String getDimName() {
		return dimName;
	}

	public void setDimName(String dimName) {
		this.dimName = dimName;
	}

	public String getColumeCode() {
		return columeCode;
	}

	public void setColumeCode(String columeCode) {
		this.columeCode = columeCode;
	}

	public String getParentCode() {
		return parentCode;
	}

	public void setParentCode(String parentCode) {
		this.parentCode = parentCode;
	}

	public String getColumeValue() {
		return columeValue;
	}

	public void setColumeValue(String columeValue) {
		this.columeValue = columeValue;
	}

	public String getColValType() {
		return colValType;
	}

	public void setColValType(String colValType) {
		this.colValType = colValType;
	}

}