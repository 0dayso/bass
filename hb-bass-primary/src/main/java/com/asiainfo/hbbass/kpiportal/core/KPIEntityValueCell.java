package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-17
 */
public class KPIEntityValueCell implements Serializable {

	private static final long serialVersionUID = -2542822709859671717L;

	private KPIEntityValueState state = null;

	private Double numeratorValue = null;

	private Double denominatorValue = null;

	public KPIEntityValueCell(Double numeratorValue, KPIEntityValueState state) {
		this.state = state;
		this.numeratorValue = numeratorValue;
	}

	public KPIEntityValueCell(Double numeratorValue, Double denominatorValue, KPIEntityValueState state) {
		this.state = state;
		this.numeratorValue = numeratorValue;
		this.denominatorValue = denominatorValue;
	}

	public KPIEntityValueState getState() {
		return state;
	}

	public void setState(KPIEntityValueState state) {
		this.state = state;
	}

	public Double getValue() {
		if (denominatorValue != null && denominatorValue.doubleValue() != 0d) {
			return new Double(numeratorValue.doubleValue() / denominatorValue.doubleValue());
		}
		return numeratorValue;
	}

	public Double getNumeratorValue() {
		return numeratorValue;
	}

	public void setNumeratorValue(Double numeratorValue) {
		this.numeratorValue = numeratorValue;
	}

	public Double getDenominatorValue() {
		return denominatorValue;
	}

	public void setDenominatorValue(Double denominatorValue) {
		this.denominatorValue = denominatorValue;
	}

}
