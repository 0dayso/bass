package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-17
 */
@SuppressWarnings({"rawtypes"})
public class KPIEntityValueCells implements Serializable {

	private static final long serialVersionUID = -3018838884933435421L;

	private List<Object> cells = new ArrayList<Object>();

	/** 默认的状态，当前台什么维度都没有点击的时候使用默认值 */
	private static KPIEntityValueState DEFAULT_STATE = new KPIEntityValueState();

	private KPIEntityValue parentValue;// 保存父KPIEntityValue的值，能从子找到父

	public KPIEntityValueCells(KPIEntityValue parentValue) {
		this.parentValue = parentValue;
	}

	public Double getValue() {

		return getValue(null);
	}

	public Double getValue(KPIEntityValueState state) {

		double resultNumerator = 0d;
		double resultDenominator = 0d;
		for (int i = 0; i < cells.size(); i++) {

			KPIEntityValueCell cell = (KPIEntityValueCell) cells.get(i);

			if (state == null || DEFAULT_STATE.equals(state) || cell.getState().equals(state)) {
				if (cell.getDenominatorValue() != null) {
					resultDenominator += cell.getDenominatorValue().doubleValue();
				}
				resultNumerator += cell.getNumeratorValue().doubleValue();
			}
		}
		return parentValue.getFilter().doFilter(resultNumerator, resultDenominator);
		// return (resultDenominator==0)?new Double(resultNumerator):new
		// Double(resultNumerator/resultDenominator);
	}

	public List getCells() {
		return cells;
	}

	@SuppressWarnings("unchecked")
	public void setCells(List cells) {
		this.cells = cells;
	}

}
