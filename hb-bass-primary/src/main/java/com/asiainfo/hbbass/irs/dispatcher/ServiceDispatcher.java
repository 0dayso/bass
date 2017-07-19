package com.asiainfo.hbbass.irs.dispatcher;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.cglib.reflect.FastClass;
import net.sf.cglib.reflect.FastMethod;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.irs.service.Service;

/**
 *
 * @author Mei Kefu
 * @date 2010-9-26
 */
@SuppressWarnings("unchecked")
public class ServiceDispatcher extends BaseDispatcher {

	private static Logger LOG = Logger.getLogger(ServiceDispatcher.class);
	
	@SuppressWarnings("rawtypes")
	private static Map serviceClasses = new HashMap();
	
	static{
		try {
			serviceClasses.put("message", FastClass.create(Class.forName("com.asiainfo.hbbass.component.msg.MessageService")));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public void dispatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getPathInfo();
		
		String[] arr = path.split("/");
		
		String methodValue = request.getParameter("method");
		
		if(methodValue==null || methodValue.length()==0){
			methodValue = request.getMethod();
		}
		
		LOG.info(path+" methodValue="+methodValue);
		
		try {
			FastClass cls = (FastClass)serviceClasses.get(arr[2]);
			FastMethod method = null;
			try{
				method = cls.getMethod(methodValue,new Class[]{HttpServletRequest.class,HttpServletResponse.class});
			}catch(NoSuchMethodError e){
				//e.printStackTrace();
				//LOG.debug(e.getMessage(),e);
				LOG.info("methodValue:"+methodValue+",不存在，运行excute方法");
			}
			
			/*LogProxy proxy = new LogProxy(request,(method!=null)?methodValue:"execute",arr[2]);
			Service service = (Service)proxy.createProxy(cls.getJavaClass());*/
			Service service = (Service)cls.newInstance();
			if(method!=null){
				method.invoke(service, new Object[]{request,response});
			} else {
				service.execute(request, response);
			}
			
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
