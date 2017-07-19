package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;

/**
 * KPI的值对象的过滤器，过滤异常数据，比如计算净增用户占有率时，当计算出来的指标是负数的时候就为0.超过100%时就为100%
 * 
 * @author Mei Kefu
 * @date 2009-12-17
 */
public interface KPIEntityValueFilter extends Serializable {

	public static KPIEntityValueFilter NULL = new KPIEntityValueFilter() {

		private static final long serialVersionUID = 7250760820106378446L;

		public Double doFilter(Double num, Double den) {
			if (den == null || den.doubleValue() == 0)
				return num;
			else
				return num / den;

		}
	};

	public Double doFilter(Double num, Double den);
}
