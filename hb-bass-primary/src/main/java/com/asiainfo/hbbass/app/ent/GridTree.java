package com.asiainfo.hbbass.app.ent;

import com.asiainfo.hbbass.common.persistence.Column;
import com.asiainfo.hbbass.common.persistence.Persistence;
import com.asiainfo.hbbass.common.persistence.Table;

/**
 * 
 * @author Mei Kefu
 * @date 2010-7-28
 */
@Table(name = "nmk.grid_tree_info")
public class GridTree extends Persistence {

	@Column(name = "grid_id", isPrimaryKey = true)
	private String id = "";

	@Column(name = "grid_name")
	private String name = "";

	@Column(name = "type")
	private String type = "";

	@Column(name = "parentgrid_id")
	private String pid = "";

	@Column(name = "parentgrid_name")
	private String pname = "";

	@Column(name = "staff_id")
	private String staffId = "";

	@Column(name = "staff_name")
	private String staffName = "";

	@Column(name = "level", type = "int")
	private int level;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getStaffId() {
		return staffId;
	}

	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}

	public String getStaffName() {
		return staffName;
	}

	public void setStaffName(String staffName) {
		this.staffName = staffName;
	}
}
