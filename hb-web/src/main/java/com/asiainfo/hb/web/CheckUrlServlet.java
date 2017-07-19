package com.asiainfo.hb.web;

import java.io.IOException;
import java.net.InetAddress;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;

import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.models.CheckUrlService;

/**
 * 启动服务后自动加载页面
 * 
 * @author chendb
 *
 */
@Controller
public class CheckUrlServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public Logger LOG = Logger.getLogger(CheckUrlServlet.class);

	// 创建HttpClient
	public CloseableHttpClient closeableHttpClient = null;

	/**
	 * 初始化时异步模仿访问url预加载页面
	 */
	public void init() throws ServletException {
		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();
		closeableHttpClient = httpClientBuilder.build();
		//异步线程
		FutureTask<String> task = new FutureTask<String>(new Callable<String>() {

			@Override
			public String call() throws Exception {
				CheckUrlService checkUrlService = (CheckUrlService) BeanFactory.getBean("checkUrlService");
				List<String> list = checkUrlService.getAllUrl();
				List<Integer> listInt = Visiturl(list);
				closeableHttpClient.close();
				if(listInt.get(0) > 30 && listInt.get(1) < 3){
					LOG.info("------------------访问"+listInt.get(0)+"次中成功次数不足:"+listInt.get(1)+"次，停止访问------------------");
				}else{
					LOG.info("------------------访问url:"+listInt.get(0)+"个,成功访问:"+listInt.get(1)+"个------------------");
				}
				LOG.info("------------------结束并且关闭连接------------------");
				return null;
			}
		});
		ExecutorService Scheduled = Executors.newFixedThreadPool(1);
		try {
			Scheduled.execute(task);
			Scheduled.shutdown();
		} catch (Exception e) {
			LOG.error(LogUtil.getExceptionMessage(e));
		}
	}
	


	/**
	 * 获取url并访问
	 * 
	 * @param closeableHttpClient
	 *            连接对象
	 * @param response
	 *            返回对象
	 * @param target
	 *            访问地址
	 */
	public List<Integer> Visiturl(List<String> list) throws IOException, ClientProtocolException, InterruptedException {
		int count = 0;//计算访问url个数
		int succ = 0;//访问成功个数
		List<Integer> listint = new ArrayList<Integer>();
		String host = InetAddress.getLocalHost().getHostAddress();
		for (String str : list) {
			HttpGet get = null;
			URL url = null;
			str = str.replace("..", "");
			Matcher matcher = Pattern.compile("[\u4e00-\u9fa5]+|[\uFF00-\uFFFF]").matcher(str);//中文和大部分全角符号（不是所有）
			while(matcher.find()){//转换url里的中文
				str = str.replace(matcher.group(), URLEncoder.encode(matcher.group(),"gbk"));
			}
			if (str.startsWith("/")) {
				url = new URL("http://"+host+":8080/hb-bass-navigation" + str);
			} else if (str.startsWith("http://")) {
				url = new URL(str);
			} else {
				LOG.info("------------------URL地址错误，地址为：" + str + "------------------");
				continue;
			}
			CloseableHttpResponse response = null;
			try {
				get = new HttpGet(url.toURI());
				// 设置request访问头,模仿游览器访问
				get.addHeader("User-Agent",
						"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36");
				LOG.info("------------------访问url:" + get.getURI().toString() + "------------------");
				response = closeableHttpClient.execute(get);
				LOG.info("------------------返回状态码:" + response.getStatusLine() + "------------------");
				if (response != null) {
					EntityUtils.toString(response.getEntity());
					EntityUtils.consumeQuietly(response.getEntity());
				}
				succ++;
			} catch (ClientProtocolException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (IOException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (IllegalStateException e) {
				LOG.error("连接池关闭！");
				LOG.error(LogUtil.getExceptionMessage(e));
			}  catch (URISyntaxException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (Exception e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} finally {
				get.releaseConnection();
				if (response != null) {
					EntityUtils.consumeQuietly(response.getEntity());
					response.close();
				}
			}
			count++;
			if(count > 30 && succ <3){//访问30次中成功次数不足3次（此时运行30秒左右），关闭连接
				listint.add(count);
				listint.add(succ);
				return listint;
			}
		}
		listint.add(count);
		listint.add(succ);
		return listint;
	}

	// /**
	// * 使用HttpClient登录系统
	// */
	// public void doLogin() {
	// CloseableHttpResponse response = null;
	// try {
	// // 登录
	// HttpHost target = new HttpHost(IP, PORT, "http");
	// HttpPost request = new HttpPost("/hb-bass-navigation/login");
	// // 设置登录所需参数
	// List<NameValuePair> nvpList = new ArrayList<NameValuePair>();
	// nvpList.add(new BasicNameValuePair("userId", "admin"));
	// nvpList.add(new BasicNameValuePair("pwd", "let me pass"));
	// nvpList.add(new BasicNameValuePair("redirect", "/HBBassFrame/index"));
	// request.setEntity(new UrlEncodedFormEntity(nvpList,
	// Charset.forName("UTF-8")));
	//
	// // response = httpclient.execute(target, request, context);
	//
	// LOG.info("------------------开始连接------------------");
	// response = closeableHttpClient.execute(target, request);
	// // 登录成功后查询所有要生成缓存的页面并访问
	// if (200 == response.getStatusLine().getStatusCode()) {
	// Visiturl(closeableHttpClient, target);
	// } else {
	// LOG.info("------------------连接失败------------------");
	// }
	// EntityUtils.consume(response.getEntity());
	// LOG.info("------------------结束连接------------------");
	// } catch (ClientProtocolException e) {
	// LOG.error(LogUtil.getExceptionMessage(e));
	// } catch (IOException e) {
	// LOG.error(LogUtil.getExceptionMessage(e));
	// } catch (Exception e) {
	// LOG.error(LogUtil.getExceptionMessage(e));
	// } finally {
	// try {
	// LOG.info("------------------关闭连接------------------");
	// response.close();
	// closeableHttpClient.close();
	// } catch (IOException e) {
	// LOG.error(LogUtil.getExceptionMessage(e));
	// }
	// }
	// }
}
