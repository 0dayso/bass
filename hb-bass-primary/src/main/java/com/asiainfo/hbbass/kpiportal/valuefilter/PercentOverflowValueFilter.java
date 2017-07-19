package com.asiainfo.hbbass.kpiportal.valuefilter;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueFilter;

/**
 * 净增用户数占比，极大与极小值的处理
 * 
 * @author Mei Kefu
 * @date 2009-12-29
 */
public class PercentOverflowValueFilter implements KPIEntityValueFilter {

	private static final long serialVersionUID = -2152765118950295208L;

	private static Logger LOG = Logger.getLogger(PercentOverflowValueFilter.class);

	public Double doFilter(Double num, Double den) {
		LOG.debug("num:" + num + " den:" + den);
		if (num >= den && num > 0) {
			return 1d;
		} else if (num < den && num > 0) {
			return num / den;
		} else
			return 0d;
	}
}
