package com.asiainfo.hb.bass.custome.report.models;

public class ComboboxBean {
	private String id;
	private boolean selected;
	private String text;
	
	public ComboboxBean(){}
	
	public ComboboxBean(String id,String text){
		this.id = id;
		this.text = text;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

}
