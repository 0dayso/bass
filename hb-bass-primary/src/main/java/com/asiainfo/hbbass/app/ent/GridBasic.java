package com.asiainfo.hbbass.app.ent;

import com.asiainfo.hbbass.common.persistence.Column;
import com.asiainfo.hbbass.common.persistence.Persistence;
import com.asiainfo.hbbass.common.persistence.Table;

/**
 * 
 * @author Mei Kefu
 * @date 2010-7-28
 */
@Table(name = "nmk.grid_basic")
public class GridBasic extends Persistence {

	@Column(name = "id", isPrimaryKey = true)
	private String id = "";

	@Column(name = "name")
	private String name = "";

	@Column(name = "pid")
	private String pid = "";

	@Column(name = "type")
	private String type = "";

	@Column(name = "city_id")
	private String cityId = "";

	@Column(name = "partition_type")
	private String partitionType = "";

	@Column(name = "channel_code1")
	private String channelCode1 = "";

	@Column(name = "channel_address1")
	private String channelAddress1 = "";

	@Column(name = "channel_code2")
	private String channelCode2 = "";

	@Column(name = "channel_code3")
	private String channelCode3 = "";

	@Column(name = "channel_address2")
	private String channelAddress2 = "";

	@Column(name = "channel_address3")
	private String channelAddress3 = "";

	@Column(name = "street")
	private String street = "";

	@Column(name = "section")
	private String section = "";

	@Column(name = "acreage", type = "int")
	private int acreage;

	@Column(name = "charger_name")
	private String chargerName = "";

	@Column(name = "charger_phone")
	private String chargerPhone = "";

	@Column(name = "staff_id")
	private String staffId = "";

	@Column(name = "staff_name")
	private String staffName = "";

	@Column(name = "level", type = "int")
	private int level;

	@Column(name = "remark")
	private String remark = "";

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

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCityId() {
		return cityId;
	}

	public void setCityId(String cityId) {
		this.cityId = cityId;
	}

	public String getPartitionType() {
		return partitionType;
	}

	public void setPartitionType(String partitionType) {
		this.partitionType = partitionType;
	}

	public String getChannelCode1() {
		return channelCode1;
	}

	public void setChannelCode1(String channelCode1) {
		this.channelCode1 = channelCode1;
	}

	public String getChannelAddress1() {
		return channelAddress1;
	}

	public void setChannelAddress1(String channelAddress1) {
		this.channelAddress1 = channelAddress1;
	}

	public String getChannelCode3() {
		return channelCode3;
	}

	public void setChannelCode3(String channelCode3) {
		this.channelCode3 = channelCode3;
	}

	public String getChannelAddress2() {
		return channelAddress2;
	}

	public void setChannelAddress2(String channelAddress2) {
		this.channelAddress2 = channelAddress2;
	}

	public String getChannelCode2() {
		return channelCode2;
	}

	public void setChannelCode2(String channelCode2) {
		this.channelCode2 = channelCode2;
	}

	public String getChannelAddress3() {
		return channelAddress3;
	}

	public void setChannelAddress3(String channelAddress3) {
		this.channelAddress3 = channelAddress3;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getSection() {
		return section;
	}

	public void setSection(String section) {
		this.section = section;
	}

	public int getAcreage() {
		return acreage;
	}

	public void setAcreage(int acreage) {
		this.acreage = acreage;
	}

	public String getChargerName() {
		return chargerName;
	}

	public void setChargerName(String chargerName) {
		this.chargerName = chargerName;
	}

	public String getChargerPhone() {
		return chargerPhone;
	}

	public void setChargerPhone(String chargerPhone) {
		this.chargerPhone = chargerPhone;
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

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
