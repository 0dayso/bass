package com.asiainfo.hb.bass.data.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * KPI定义模型
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
@SuppressWarnings("serial")
public class KpiDef implements Serializable {

	public String kpiId;
	public String kpiName;
	public String kpiUnit;
	public String logicId;
	public String kpidefType;
	public String cycle;
	public String compdimId;
	public String kpiScopeId;
	public String kpiSql;
	public String state;
	public String dbname;
	public String kpiDes;
	public String remark;
	public String version;
	public String creater;
	public String updater;
	public String category;
	public String dataTableName;
	public String loadClass = "";
	public String formatValue = "###,###.00";
	public String formula;
	public String formulaUnit;
	public Timestamp start_dt;
	public Timestamp end_dt;
	public Timestamp create_dt;
	public Timestamp update_dt;

	public String getKpiId() {
		return kpiId;
	}

	public void setKpiId(String kpiId) {
		this.kpiId = kpiId;
	}

	public String getKpiName() {
		return kpiName;
	}

	public void setKpiName(String kpiName) {
		this.kpiName = kpiName;
	}

	public String getKpiUnit() {
		return kpiUnit;
	}

	public void setKpiUnit(String kpiUnit) {
		this.kpiUnit = kpiUnit;
	}

	public String getLogicId() {
		return logicId;
	}

	public void setLogicId(String logicId) {
		this.logicId = logicId;
	}

	public String getKpidefType() {
		return kpidefType;
	}

	public void setKpidefType(String kpidefType) {
		this.kpidefType = kpidefType;
	}

	public String getCycle() {
		return cycle;
	}

	public void setCycle(String cycle) {
		this.cycle = cycle;
	}

	public String getCompdimId() {
		return compdimId;
	}

	public void setCompdimId(String compdimId) {
		this.compdimId = compdimId;
	}

	public String getKpiScopeId() {
		return kpiScopeId;
	}

	public void setKpiScopeId(String kpiScopeId) {
		this.kpiScopeId = kpiScopeId;
	}

	public String getKpiSql() {
		return kpiSql;
	}

	public void setKpiSql(String kpiSql) {
		this.kpiSql = kpiSql;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getDbname() {
		return dbname;
	}

	public void setDbname(String dbname) {
		this.dbname = dbname;
	}

	public String getKpiDes() {
		return kpiDes;
	}

	public void setKpiDes(String kpiDes) {
		this.kpiDes = kpiDes;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getCreater() {
		return creater;
	}

	public void setCreater(String creater) {
		this.creater = creater;
	}

	public String getUpdater() {
		return updater;
	}

	public void setUpdater(String updater) {
		this.updater = updater;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getDataTableName() {
		return dataTableName;
	}

	public void setDataTableName(String dataTableName) {
		this.dataTableName = dataTableName;
	}

	public String getLoadClass() {
		return loadClass;
	}

	public void setLoadClass(String loadClass) {
		this.loadClass = loadClass;
	}

	public String getFormatValue() {
		return formatValue;
	}

	public void setFormatValue(String formatValue) {
		this.formatValue = formatValue;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}

	public String getFormulaUnit() {
		return formulaUnit;
	}

	public void setFormulaUnit(String formulaUnit) {
		this.formulaUnit = formulaUnit;
	}

	public Timestamp getStart_dt() {
		return start_dt;
	}

	public void setStart_dt(Timestamp start_dt) {
		this.start_dt = start_dt;
	}

	public Timestamp getEnd_dt() {
		return end_dt;
	}

	public void setEnd_dt(Timestamp end_dt) {
		this.end_dt = end_dt;
	}

	public Timestamp getCreate_dt() {
		return create_dt;
	}

	public void setCreate_dt(Timestamp create_dt) {
		this.create_dt = create_dt;
	}

	public Timestamp getUpdate_dt() {
		return update_dt;
	}

	public void setUpdate_dt(Timestamp update_dt) {
		this.update_dt = update_dt;
	}

}
