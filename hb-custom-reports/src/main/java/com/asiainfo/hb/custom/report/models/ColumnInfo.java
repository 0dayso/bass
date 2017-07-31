package com.asiainfo.hb.custom.report.models;

/**
 * Easyui datagrid column 封装信息
 * 
 * @author king-pan
 *
 */
public class ColumnInfo {
	private String field;
	private String title;
	
	private int width;

	public ColumnInfo() {}

	public ColumnInfo(String field, String title) {
		this.field = field;
		this.title = title;
	}
	public ColumnInfo(String field, String title,int width) {
		this.field = field;
		this.title = title;
		this.width = width;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	@Override
	public String toString() {
		return "ColumnInfo [field=" + field + ", title=" + title + ", width=" + width + "]";
	}
}
