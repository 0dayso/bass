package com.asiainfo.hbbass.common.action;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * Json对象持久化类，主要操作Json对象到数据库的持久化。把该类从JsonData中抽取出来。
 * 
 * @author Mei Kefu
 * @date 2010-2-23
 */
@SuppressWarnings({"rawtypes","unused"})
public class JsonPersistentAction extends Action {

	private static Logger LOG = Logger.getLogger(JsonPersistentAction.class);

	/**
	 * 
	 * 
	 * { 'meta':{ 'table':'credit_weight' ,'primary':'name' ,'column':[
	 * {'name':'name','type':'string'} ,{'name':'weight','type':'double'}
	 * ,{'name':'abs_weight','type':'double'} ,{'name':'level','type':'int'}
	 * ,{'name':'isleaf','type':'int'} ,{'name':'parent','type':'string'}
	 * 是保存对象还是对象主键？ ] } ,'data':[ {
	 * 'name':'aaa','weight':0.32,'abs_weight':0.32,'level':1,'isleaf':0,'parent':''
	 * } ] }
	 */
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String jsonData = "{" + "	'meta':{" + "		'table':'credit_weight'" + "		,'primary':'name'" + "		,'columns':[" + "			{'name':'name','type':'string'}" + "			,{'name':'weight','type':'double'}" + "			,{'name':'abs_weight','type':'double'}" + "			,{'name':'level','type':'int'}"
				+ "			,{'name':'isleaf','type':'int'}" + "			,{'name':'parent','type':'string'}/*是保存对象还是对象主键？*/" + "		]" + "	}" + "	,'data':[" + "		{'name':'aaa','weight':0.32,'abs_weight':0.32,'level':1,'isleaf':0,'parent':''}" + "	]" + "}";

		Object obj = JsonHelper.getInstance().read(jsonData);

		if (obj instanceof Map) {
			Map map = (Map) obj;

			Map metaMap = (Map) map.get("meta");

			JsonMeta meta = new JsonMeta();
			meta.table = (String) metaMap.get("table");
			meta.primary = (String) metaMap.get("primary");
			meta.columns = (List) metaMap.get("columns");
		}

	}

	static class JsonMeta {
		String table, primary;
		List columns;
	}

	static class JsonMetaColumn {
		String name;
		String type;
	}

}
