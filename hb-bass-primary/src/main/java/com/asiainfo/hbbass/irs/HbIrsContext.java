package com.asiainfo.hbbass.irs;

import java.util.HashMap;
import java.util.Map;

import com.asiainfo.hbbass.irs.dispatcher.ActionDispatcher;
import com.asiainfo.hbbass.irs.dispatcher.Dispatcher;
import com.asiainfo.hbbass.irs.dispatcher.ReportMetaDispatcher;
import com.asiainfo.hbbass.irs.dispatcher.ResourceDispatcher;
import com.asiainfo.hbbass.irs.dispatcher.ServiceDispatcher;

/**
 * 
 * @author Mei Kefu
 * @date 2009-9-15
 */
@SuppressWarnings("unchecked")
public class HbIrsContext {

	@SuppressWarnings("rawtypes")
	private static Map dispatchers = new HashMap();

	static {
		dispatchers.put("resources", new ResourceDispatcher());
		dispatchers.put("rptmeta", new ReportMetaDispatcher());
		dispatchers.put("action", new ActionDispatcher());
		dispatchers.put("service", new ServiceDispatcher());
	}

	public static Dispatcher getDispatcher(String key) {
		Dispatcher dispatcher = (Dispatcher) dispatchers.get(key);

		if (dispatcher == null) {
			dispatcher = Dispatcher.NULL;
		}
		return dispatcher;
	}

}
