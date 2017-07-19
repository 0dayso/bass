package com.asiainfo.hb.core.datastore;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
/**
 * SqlQuery 返回值对象
 * 为了缓存与可读性需要
 * @author Mei Kefu
 * @date 2012-3-1
 */
@SuppressWarnings("serial")
public class SqlQueryResultVo implements Serializable{
	
	private List<Map<String,Object>> root;
	private List<Map<String,String>> fields = new ArrayList<Map<String,String>>();
	private List<Map<String,String>> columnModel = new ArrayList<Map<String,String>>();
	private int count;
	
	private String message;
	private String errorMsg;
	
	public List<Map<String, Object>> getRoot() {
		return root;
	}
	public void setRoot(List<Map<String, Object>> root) {
		this.root = root;
	}
	public List<Map<String, String>> getFields() {
		return fields;
	}
	public void setFields(List<Map<String, String>> fields) {
		this.fields = fields;
	}
	public List<Map<String, String>> getColumnModel() {
		return columnModel;
	}
	public void setColumnModel(List<Map<String, String>> columnModel) {
		this.columnModel = columnModel;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getErrorMsg() {
		return errorMsg;
	}
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
	
}
