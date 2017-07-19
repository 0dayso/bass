package com.asiainfo.hb.core.cache;

@SuppressWarnings("serial")
public class CacheServerException extends Exception{
	public CacheServerException(String msg){
		super(msg);
	}
	
	public CacheServerException(String msg,Throwable cause){
		super(msg,cause);
	}
}
