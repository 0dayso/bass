package com.asiainfo.hb.core.models;


import java.io.IOException;
import java.io.StringWriter;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Component;

/**
 *
 * @author Mei Kefu
 * @date 2010-3-5
 */
@Component
public class JsonHelper {
	
	//2010-5-27修改每次调用都new一个，虽然有部分开销但是防止了多线程同步修改问题
	//private JSONWriter writer = new JSONWriter(false);
	
	//private JSONReader reader = new JSONReader();
	
	private static JsonHelper HELPER = new JsonHelper();
	
	private ObjectMapper mapper = new ObjectMapper();
	
	private JsonHelper(){
		mapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);
		mapper.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
		mapper.configure(JsonParser.Feature.ALLOW_COMMENTS, true);
	}
	
	public static JsonHelper getInstance(){
		return HELPER;
	}
	
	public String write(Object object) {
		StringWriter sw = new StringWriter();

		try {
			JsonGenerator gen = new JsonFactory().createJsonGenerator(sw);
			mapper.writeValue(gen, object);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sw.toString();
	}
	
	public Object read(String string){
		string = string.trim();
		Object obj = null;
		try {
			obj = mapper.readValue(string,string.startsWith("[")?List.class:Map.class);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		return obj;
	}
	
	public <T> T read(String string,Class<T> clz){
		string = string.trim();
		T obj = null;
		try {
			obj = mapper.readValue(string,clz);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		return (T)obj;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
